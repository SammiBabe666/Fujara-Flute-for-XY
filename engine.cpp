#include "core.h"
#include "voicing.h"
#include <opxy/q31.hpp>

// Fujara: an overtone flute. A breath-driven jet sounds the bore's harmonic
// series; the player chooses which overtones speak by how hard and how
// precisely they blow. The model is small and all-integer:
//
//   breath noise --> band filter --(jet modulation)--+
//                                                    v
//   jet: harmonics 1..8, weights from Breath,  --> bore: a delay line one period
//        Body and Overtones (voicing.h), with an     long with a lossy wood filter
//        overblown attack that cascades down          (a tuned, bounded comb)
//                                                    v
//                         dry jet + bore + air hiss --> breath drive --> output
//
// Breath is excitation: level, brightness, the overblown attack, a little
// sharpening and unsteadiness. Body is the fundamental and the bore's
// resonance. Overtones moves a narrow emphasis up the harmonic series, from the
// 2nd to the 7th partial: the whistle of an overblown fujara. Air is the noise
// of the breath, part of it pitched by the bore, part a free hiss.
//
// Audio runs in Q15 (32767 is full scale) inside 32-bit words, so the sample
// loops multiply 16-bit values; there is no floating point, no 64-bit
// arithmetic and no division per sample. Per-block work (a few divisions)
// sets weights and coefficients. Each sample loop is a short pass that fits
// the Blackfin's eight data registers (AUDIT.md: register pressure). Signed
// right shifts are arithmetic on both SDK compilers, as in the core machines.
// The OP-XY's amp envelope shapes every note; the engine runs freely.
namespace fujara {
namespace {
using voicing::along;
using voicing::mul15;
using voicing::q15;

const unsigned N = opxy::block_frames;

inline i32 clamp(i32 v, i32 lo, i32 hi) { return v < lo ? lo : v > hi ? hi : v; }
inline u32 lcg(u32 seed) { return seed * 1664525u + 1013904223u; }
inline i32 noise15(u32& seed) {
    seed = lcg(seed);
    return static_cast<i32>(seed >> 17) - 16384;  // Q15, half scale
}

// A partial is skipped once its frequency would pass about 15 kHz:
// h * increment < 0.34 * 2^32.
const u32 kLimit[partial_count] = {1460288881u, 730144440u, 486762960u, 365072220u,
                                   292057776u,  243381480u, 208612697u, 182536110u};
// Fixed starting phases spread the partials' peaks (a lower crest factor).
const u32 kOffset[partial_count] = {0u, 0x2a000000u, 0x55000000u, 0x13000000u,
                                    0x91000000u, 0x3d000000u, 0xc7000000u, 0x6b000000u};
// One cent of pitch as a Q31 fraction of the increment (2^31 * ln2 / 1200).
const i32 kCent = 1240428;
// The jet's partial weights sum to this at full breath (Q15, 0.29 of full scale).
const i32 kJetLevel = 9500;

// Partial weights for this block, Q15, normalised so the jet's sum is
// kJetLevel * level whatever the controls. Weights below -72 dB are 0, so
// the render skips those partials.
void weights(i32 breath, i32 body, i32 overtones, i32 onset, u32 increment, i32* result) {
    i32 total = 0;
    for (u32 h = 0; h < partial_count; ++h) {
        const i32 w = increment < kLimit[h]
                          ? voicing::weight(static_cast<i32>(h), breath, body, overtones, onset) : 0;
        result[h] = w;
        total += w;
    }
    if (total < 1) total = 1;
    // Soft breath plays a little quieter.
    const i32 target = mul15(along(breath, 21000, 32767), kJetLevel);
    for (u32 h = 0; h < partial_count; ++h) {
        const i32 w = result[h] * target / total;  // raw < 2^16, target < 2^14
        result[h] = w < 8 ? 0 : w;
    }
}

// The bore's delay, Q8 samples, for a phase increment, less the loop filter's
// delay so the resonance stays on the jet's harmonics. A period above 1000
// samples (below 44 Hz) is halved until it fits: the bore then resonates an
// octave or more higher, still on the same harmonic series.
u32 bore_delay(u32 increment, i32 filter) {
    u32 period;
    if (increment < 65536u) {  // below 0.7 Hz: not a note, keep the bound
        period = 1000u << 8;
    } else {
        const u32 whole = 0xffffffffu / increment;
        const u32 rest = 0xffffffffu - whole * increment;
        period = (whole << 8) + rest / ((increment >> 8) + 1);
    }
    while (period > (1000u << 8)) period >>= 1;
    // A one-pole y += c (x - y) delays low frequencies by (1 - c) / c samples.
    // A period too short for the delay and the filter's lag (above about
    // 10 kHz) is doubled: the note is then the bore's 2nd harmonic.
    const u32 lag = static_cast<u32>((32767 - filter) * 256 / filter);
    while (period < lag + (3u << 8)) period <<= 1;
    return period - lag;
}

// One partial added into the jet: its own phase integrates the block's
// increment ramp, so h times the fundamental's phase is exact.
// A parabola sine, 4x(1 - |x|): its 3rd harmonic at -28 dB is part of the
// jet's colour. |x| is approximated by its ones' complement.
// Its weight moves from the last block's to this block's across the block
// (within 63/32768 of it; the next block starts exactly there), so a new
// note's re-voicing or a control move never steps the waveform.
__attribute__((noinline)) void partial(i32* jet, u32 phase, u32 increment, i32 ramp, i32 weight, i32 step) {
    for (unsigned i = 0; i < N; ++i) {
        const i32 x = static_cast<i32>(phase) >> 16;              // Q15
        const i32 magnitude = x ^ (x >> 31);
        const i32 sine = (x * (32767 - magnitude)) >> 13;          // Q15
        jet[i] += sine * weight;                                   // Q30
        weight += step;
        phase += increment;
        increment += static_cast<u32>(ramp);
    }
}
// The same for a steady pitch (no ramp), the usual case: one register fewer,
// two instructions a sample fewer on the Blackfin.
__attribute__((noinline)) void steady_partial(i32* jet, u32 phase, u32 increment, i32 weight, i32 step) {
    for (unsigned i = 0; i < N; ++i) {
        const i32 x = static_cast<i32>(phase) >> 16;
        const i32 magnitude = x ^ (x >> 31);
        const i32 sine = (x * (32767 - magnitude)) >> 13;
        jet[i] += sine * weight;
        weight += step;
        phase += increment;
    }
}
}

// Callbacks run serially per voice; owner is a stable nonzero voice ID.
inline void initialize(Voice& voice, Shared&, u32 owner) {
    voice.phase = owner * 0x9e3779b9u;
    voice.seed = owner * 2654435761u | 1u;
    voice.write = 0;
    voice.started = 0;
    voice.primed = 0;
    for (u32 c = 0; c < control_count; ++c) voice.control[c] = 0;
    for (u32 h = 0; h < partial_count; ++h) voice.weight[h] = 0;
    voice.drift = voice.onset = voice.scoop = 0;
    voice.air_low = voice.air_band = voice.bore_low = voice.dc = 0;
    for (u32 i = 0; i < bore_length; ++i) voice.bore[i] = 0;
}
// Each note re-blows the pipe: the next block starts the overblown attack.
// The jet's phase and the bore run on, so legato and retriggers never click.
inline void start(Voice& voice, Shared&, u32) { voice.started = 1; }
inline void destroy(Voice&, Shared&, u32) {}

// Controls: Breath, Body, Overtones, Air.
inline void render(Voice& voice, Shared&, u32, opxy::Output output, opxy::Parameters parameters,
                   opxy::Pitch pitch) {
    // Controls glide over about 12 ms; a new voice starts on its values.
    for (u32 c = 0; c < control_count; ++c) {
        const i32 target = parameters[c] < 0 ? 0 : parameters[c];
        voice.control[c] = voice.primed ? voice.control[c] + (target - voice.control[c]) / 8 : target;
    }
    voice.primed = 1;
    const i32 breath = q15(voice.control[0]), body = q15(voice.control[1]);
    const i32 overtones = q15(voice.control[2]), air = q15(voice.control[3]);

    // The attack: harder breath overblows further and starts a little flatter.
    if (voice.started) {
        voice.onset = voicing::onset_strength(breath);
        voice.scoop = along(breath, 14000, 32767);
        voice.started = 0;
    }
    voice.onset = voice.onset < 64 ? 0 : voice.onset * 32374 >> 15;  // about 0.99 a block: 120 ms
    voice.scoop = voice.scoop * 31130 >> 15;  // about 0.95 a block: 28 ms

    // Pitch: a slow random wander of 2 to 7 cents rms that grows with breath,
    // overblowing sharpens by up to 8 cents, and the attack rises from up to
    // 22 cents flat. All of it bends this block's increments.
    voice.drift += (noise15(voice.seed) - voice.drift) >> 5;
    const i32 wander = voice.drift * along(breath, 1760, 6150) >> 12;  // Q8 cents
    const i32 cents_q8 = clamp(wander, -40 * 256, 40 * 256) + (breath * 8 * 256 >> 15)
                       - (voice.scoop * 22 * 256 >> 15);
    const i32 bend = cents_q8 * (kCent >> 8);  // Q31 fraction, at most about 0.04
    // The block's increments as a ramp from the first to the last sample:
    // pitch moves per block or glides smoothly, so the ramp follows it.
    const u32 first = pitch[0], last = pitch[N - 1];
    const u32 start_inc = first + 2u * static_cast<u32>(opxy::q31::multiply(static_cast<i32>(first >> 1), bend));
    const u32 end_inc = last + 2u * static_cast<u32>(opxy::q31::multiply(static_cast<i32>(last >> 1), bend));
    const i32 ramp = static_cast<i32>(end_inc - start_inc) / static_cast<i32>(N - 1);

    i32 weight[partial_count];
    weights(breath, body, overtones, voice.onset, first > last ? first : last, weight);

    // Pass 1: the jet, partial by partial, into a Q30 sum. A partial silent
    // in this block and the last costs nothing.
    i32 jet[N];
    for (unsigned i = 0; i < N; ++i) jet[i] = 0;
    for (u32 h = 0; h < partial_count; ++h) {
        const i32 before = voice.weight[h];
        voice.weight[h] = weight[h];
        if (before == 0 && weight[h] == 0) continue;
        const u32 harmonic = h + 1;
        const i32 step = (weight[h] - before) / static_cast<i32>(N);
        if (ramp == 0) steady_partial(jet, voice.phase * harmonic + kOffset[h], start_inc * harmonic, before, step);
        else partial(jet, voice.phase * harmonic + kOffset[h], start_inc * harmonic,
                     ramp * static_cast<i32>(harmonic), before, step);
    }
    voice.phase += start_inc * N + static_cast<u32>(ramp) * (N * (N - 1) / 2);

    // Pass 2: breath noise, a low-passed quarter-scale white noise.
    i32 noise[N];
    {
        const i32 cutoff = along(air, 2600, 9000);  // Q15 one-pole
        u32 seed = voice.seed;
        i32 low = voice.air_low;
        for (unsigned i = 0; i < N; ++i) {
            seed = lcg(seed);
            const i32 white = static_cast<i32>(seed >> 18) - 8192;
            low += (white - low) * cutoff >> 15;
            noise[i] = low;
        }
        voice.seed = seed;
        voice.air_low = low;
    }
    // Pass 3: the band (less its rumble), modulated by the jet: turbulence
    // rides on the oscillation. The jet becomes Q15 here.
    {
        const i32 base = along(breath, 11264, 24576);  // Q15, 0.34 to 0.75
        i32 band = voice.air_band;
        for (unsigned i = 0; i < N; ++i) {
            const i32 low = noise[i];
            band += (low - band) >> 5;  // about 220 Hz: the rumble removed
            const i32 tone = jet[i] >> 15;                         // at most kJetLevel
            jet[i] = tone;
            noise[i] = (low - band) * (base + (tone >> 1)) >> 15;  // at most 16384 * 0.9
        }
        voice.air_band = band;
    }
    // Pass 4: the bore's input, (1 - g)(jet + pitched breath), and the dry
    // mix, jet and free hiss. |jet + pitched breath| <= 9500 + 14700 * 1.5.
    i32 bore_in[N];
    const i32 feedback = along(body, 17000, 30800);  // Q15, 0.52 to 0.94: resonance
    const i32 filter = along(body, 27000, 15000);    // Q15 loop one-pole: darker wood
    {
        const i32 input_gain = 32767 - feedback;
        const i32 pitched = along(air, 3000, 49152);   // up to 1.5
        const i32 dry = along(body, 26000, 14000);
        const i32 hiss = along(air, 0, 52000);         // up to 1.6
        for (unsigned i = 0; i < N; ++i) {
            const i32 tone = jet[i], breathy = noise[i];
            bore_in[i] = (tone + (breathy * pitched >> 15)) * input_gain >> 15;
            jet[i] = (tone * dry + breathy * hiss) >> 15;  // the dry mix, at most 31000
        }
    }
    // Pass 5: the bore, v = (1 - g) x + g L(v one period ago). Its peaks, on
    // the jet's harmonics, have unity gain; noise between them fades. If
    // |x| <= X then |v| <= X by induction, since L, the interpolation and
    // g < 1 never raise a bound: no clamp is needed for the Q15 line.
    // The block runs in chunks no longer than the delay, so each chunk's
    // reads were written before it: a gather pass, then the recursion.
    {
        const u32 delay = bore_delay(first, filter);
        const u32 whole = delay >> 8;
        const i32 fraction = static_cast<i32>(delay & 255u);
        i16* bore = voice.bore;
        u32 write = voice.write;
        i32 low = voice.bore_low;
        i32* delayed = noise;  // the breath noise is spent: reuse its stack
        for (unsigned begin = 0; begin < N;) {
            const unsigned count = N - begin < whole ? N - begin : whole;
            // Each read's older neighbour is the previous read.
            u32 read = write - whole;
            i32 older = bore[(read - 1u) & bore_mask];
            for (unsigned i = begin; i < begin + count; ++i, ++read) {
                const i32 newer = bore[read & bore_mask];
                delayed[i] = newer + ((older - newer) * fraction >> 8);
                older = newer;
            }
            for (unsigned i = begin; i < begin + count; ++i, ++write) {
                low += (delayed[i] - low) * filter >> 15;
                const i32 v = bore_in[i] + (low * feedback >> 15);
                bore[write & bore_mask] = static_cast<i16>(v);
                bore_in[i] = v;
            }
            begin += count;
        }
        voice.write = write & bore_mask;
        voice.bore_low = low;
    }
    // Pass 6: dry + bore, then breath drive: gain G from 1 to 2.75 with
    // Breath, shaped by 1.5u - 0.5u^3 (at most full scale). The shaping of an
    // asymmetric wave leaves a little DC: a blocker (about 3.4 Hz; centre is
    // 2048 x the running mean) removes it, after a trim that leaves at least
    // 1.2 dB of headroom so its ripple on the lowest notes stays clear of the clamp. The clamp keeps the
    // proof simple; at half scale the output never passes the declared peak.
    {
        const i32 wet = along(body, 30000, 44000);                        // up to 1.34
        const i32 forced = mul15(breath, breath);
        const i32 drive = along(forced, 8192, 22528);                     // Q15, G / 4
        // Headroom for the blocker's ripple (7/8 at soft breath), and a
        // make-down for hard breath so it drives rather than only gets louder.
        const i32 trim = along(forced, 28672, 18000);                     // Q15
        i32 centre = voice.dc;
        for (unsigned i = 0; i < N; ++i) {
            const i32 mix = jet[i] + (bore_in[i] * wet >> 15);              // at most 73300: * drive fits
            const i32 u = clamp(mix * drive >> 13, -32767, 32767);         // G * mix, Q15
            const i32 curve = u + ((u >> 1) * (32767 - (u * u >> 15)) >> 15);  // at most 32767
            const i32 shaped = (curve * trim >> 15) - (centre >> 10);
            centre += shaped >> 1;
            output[i] = clamp(shaped, -32767, 32767) * 32768;              // half scale
        }
        voice.dc = centre;
    }
}
}
