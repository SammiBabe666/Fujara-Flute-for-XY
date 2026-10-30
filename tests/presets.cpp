// The six shipped presets (check.h, kept in step with definition.json by
// tests/check_release.py): with eight voices, stolen voices, control sweeps
// and pitch bends they stay bounded, audible and free of DC; and each pair of
// presets differs audibly in a measured way, not only by name.
#include "play.h"

struct Features { double level, centroid, noise, whistle, fundamental; };

// A coarse spectrum (Goertzel, 10 Hz grid to 9 kHz) of one sustained note:
// level, spectral centroid as a multiple of f0, breath-noise share of power,
// the strongest upper overtone (3..8) and the fundamental's share of power.
static Features analyse(const double* x, unsigned n, double f0) {
    Features f = {};
    double total = 0, harmonic = 0, weighted = 0, best = 0, fundamental = 0;
    for (double hz = 40; hz < 9000; hz += 10) {
        const double m = magnitude(x, n, hz), p = m * m;
        total += p;
        weighted += p * hz;
        const double k = std::floor(hz / f0 + 0.5);
        if (k >= 1 && std::fabs(hz - k * f0) < 16) {
            harmonic += p;
            if (k == 1) fundamental += p;
        }
    }
    for (int k = 3; k <= 8; ++k) {
        const double m = magnitude(x, n, k * f0);
        if (m > best) { best = m; f.whistle = k; }
    }
    f.level = db(rms(x, n));
    f.centroid = weighted / total / f0;
    f.noise = 10 * std::log10((total - harmonic) / total);
    f.fundamental = 10 * std::log10(fundamental / total);
    return f;
}

int main() {
    static fujara::Shared shared;
    static fujara::Voice voices[8];
    opxy::i32 parameters[8], output[64];
    opxy::u32 pitch[64];
    for (unsigned p = 0; p < 6; ++p) {
        std::memset(voices, 0, sizeof(voices));
        for (unsigned v = 0; v < 8; ++v) {
            fujara::initialize(voices[v], shared, v + 1);
            fujara::start(voices[v], shared, v + 1);
        }
        double sum = 0, energy = 0;
        unsigned count = 0;
        for (unsigned b = 0; b < 1400; ++b) {
            for (unsigned c = 0; c < 8; ++c) parameters[c] = c < 4 ? q31(presets[p].values[c]) : 0;
            if (b >= 600 && b < 700) parameters[0] = parameters[2] = 0x7fffffff;  // a sweep mid-note
            if (b % 175 == 0) {  // a stolen voice is initialised again for its new owner
                const unsigned v = (b / 175) & 7;
                fujara::initialize(voices[v], shared, 9 + b);
                fujara::start(voices[v], shared, 9 + b);
            }
            for (unsigned v = 0; v < 8; ++v) {
                const opxy::u32 base = increment(43 + 5 * v);
                for (unsigned i = 0; i < 64; ++i)
                    pitch[i] = b >= 1000 ? base + ((b * 131u + i * 977u) & 0x3ffffu) : base;
                fujara::render(voices[v], shared, v + 1, output, parameters, pitch);
                for (unsigned i = 0; i < 64; ++i) {
                    require(output[i] >= -peak && output[i] <= peak, "preset exceeds the declared peak");
                    if (b > 50) {
                        sum += output[i];
                        energy += static_cast<double>(output[i]) * output[i];
                        ++count;
                    }
                }
            }
        }
        const double level = std::sqrt(energy / count) / peak, dc = sum / count / peak;
        std::printf("%-17s rms %.3f dc %+.5f\n", presets[p].name, level, dc);
        require(level > 0.08, "preset too quiet");
        require(level < 0.6, "preset too loud");
        require(std::fabs(dc) < 0.002, "preset carries DC");
    }
    // Distinctness: one sustained A3 per preset, after its attack.
    static double out[(40 + 512) * 64];
    Features f[6];
    for (unsigned p = 0; p < 6; ++p) {
        static Player player;
        player.begin(3);
        player.set(presets[p].values);
        player.note(57);
        player.run(40 + 512, out);
        f[p] = analyse(out + 40 * 64, 512 * 64, hertz(57));
        std::printf("%-17s level %5.1f dB  centroid %4.2f f0  noise %5.1f dB  whistle h%.0f  fundamental %5.1f dB\n",
                    presets[p].name, f[p].level, f[p].centroid, f[p].noise, f[p].whistle, f[p].fundamental);
    }
    for (unsigned a = 0; a < 6; ++a)
        for (unsigned b = a + 1; b < 6; ++b) {
            const bool differs = std::fabs(f[a].noise - f[b].noise) >= 3 || f[a].whistle != f[b].whistle ||
                                 std::fabs(f[a].centroid - f[b].centroid) / (f[a].centroid + f[b].centroid) >= 0.08 ||
                                 std::fabs(f[a].level - f[b].level) >= 2.5 ||
                                 std::fabs(f[a].fundamental - f[b].fundamental) >= 3;
            if (!differs) std::printf("too alike: %s / %s\n", presets[a].name, presets[b].name);
            require(differs, "two presets are not measurably different");
        }
    return 0;
}
