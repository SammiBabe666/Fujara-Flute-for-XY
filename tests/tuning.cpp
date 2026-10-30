// Pitch and control behaviour: the played note is the fundamental across the
// keyboard, within the intended breath sharpening and wander; the bore is
// tuned to the jet's harmonics at every pitch; Overtones moves the whistle up
// the series; Air adds breath noise; Body adds fundamental; Breath brightens;
// and an overblown attack cascades from high partials down.
#include "play.h"

static const unsigned blocks = 690;  // one second
static double out[(blocks + 60) * 64];

static double measured;  // the sustained note's fundamental, Hz

static void sustain(const double* controls, double midi, unsigned owner = 5) {
    static Player p;
    p.begin(owner);
    p.set(controls);
    p.note(midi);
    p.run(blocks + 60, out);
    measured = strongest(out + 60 * 64, blocks * 64, hertz(midi), 30);
}
// Power of partial k relative to the fundamental, dB, after the attack, at
// the measured fundamental (breath sharpens the note by up to 8 cents).
static double partial_db(double, int k) {
    const double f0 = measured;
    return db(magnitude(out + 60 * 64, blocks * 64, k * f0) / magnitude(out + 60 * 64, blocks * 64, f0));
}
static int whistle(double midi) {
    int best = 3;
    for (int k = 3; k <= 8; ++k) if (partial_db(midi, k) > partial_db(midi, best)) best = k;
    return best;
}
// Power off the harmonics (between them) relative to the whole, dB.
static double breathiness(double) {
    const double f0 = measured;
    double between = 0, on = 0;
    for (int k = 1; k <= 12; ++k) {
        const double h = magnitude(out + 60 * 64, blocks * 64, k * f0);
        const double b = magnitude(out + 60 * 64, blocks * 64, (k + 0.5) * f0);
        on += h * h;
        between += b * b;
    }
    return 10 * std::log10(between / on);
}

int main() {
    // Pitch: with Breath 0 there is no sharpening and the wander is 2 cents
    // rms, so every one-second note is within 1.5 cents of the played pitch.
    for (double midi = 24; midi <= 108; midi += 6) {
        const double plain[4] = {0.0, 0.6, 0.5, 0.4};
        sustain(plain, midi, 3);
        const double c = cents(strongest(out + 60 * 64, blocks * 64, hertz(midi), 20), hertz(midi));
        if (std::fabs(c) > 1.5) std::printf("MIDI %.0f: %+.2f cents\n", midi, c);
        require(std::fabs(c) <= 1.5, "fundamental is off the played note");
    }
    // The presets: averaged over four voices (their wander differs), each note
    // sits at the intended breath sharpening, 8 cents at full breath, within
    // 3 cents.
    for (double midi = 36; midi <= 96; midi += 15) {
        for (unsigned p = 0; p < 6; ++p) {
            double sum = 0;
            for (unsigned owner = 1; owner <= 4; ++owner) {
                sustain(presets[p].values, midi, owner);
                sum += cents(strongest(out + 60 * 64, blocks * 64, hertz(midi), 30), hertz(midi));
            }
            const double c = sum / 4, expected = 8 * presets[p].values[0];
            if (std::fabs(c - expected) > 3)
                std::printf("MIDI %.0f %s: %+.1f cents (expected %+.1f)\n", midi, presets[p].name, c, expected);
            require(std::fabs(c - expected) <= 3, "a preset is out of tune");
        }
    }
    // The bore: its loop (delay plus the wood filter's lag) is one period
    // (halved below 44 Hz, doubled above 10 kHz: still on the series), within
    // 0.2% at every MIDI note and Body setting.
    for (int midi = 0; midi <= 127; ++midi) {
        for (int body = 0; body <= 4; ++body) {
            const opxy::i32 filter = fujara::voicing::along(body * 8191, 27000, 15000);
            const double loop = fujara::bore_delay(increment(midi), filter) / 256.0 + (32767.0 - filter) / filter;
            // The note's period, halved below 44 Hz or doubled above 10 kHz.
            double period = rate / hertz(midi);
            while (period > 1000.5) period /= 2;
            while (period < 3 + (32767.0 - filter) / filter) period *= 2;
            if (std::fabs(loop / period - 1) > 0.002)
                std::printf("MIDI %d: bore %.2f, period %.2f\n", midi, loop, period);
            require(std::fabs(loop / period - 1) <= 0.002, "bore off the jet's harmonics");
        }
    }
    // Overtones moves the whistle up the series.
    int previous = 0;
    for (double o = 0.3; o <= 1.0001; o += 0.175) {
        const double controls[4] = {0.5, 0.4, o, 0.0};
        sustain(controls, 50);
        const int w = whistle(50);
        std::printf("Overtones %.2f: whistle on partial %d (%+.1f dB)\n", o, w, partial_db(50, w));
        require(w >= previous, "Overtones does not climb the series");
        previous = w;
    }
    require(previous >= 6, "Overtones never reaches the upper series");
    // Air adds breath noise between the harmonics.
    double last = -1000;
    for (double a = 0; a <= 1.0001; a += 0.25) {
        const double controls[4] = {0.5, 0.6, 0.4, a};
        sustain(controls, 50);
        const double b = breathiness(50);
        std::printf("Air %.2f: noise between harmonics %.1f dB\n", a, b);
        require(b > last + 2, "Air does not add breath noise");
        last = b;
    }
    // Body adds fundamental against the upper series.
    {
        const double thin[4] = {0.5, 0.0, 0.5, 0.3}, full[4] = {0.5, 1.0, 0.5, 0.3};
        sustain(thin, 45);
        const double a = partial_db(45, 4);
        sustain(full, 45);
        const double b = partial_db(45, 4);
        std::printf("Body 0 -> 100: 4th partial relative to fundamental %.1f -> %.1f dB\n", a, b);
        require(b < a - 3, "Body does not weigh the fundamental");
    }
    // Breath brightens and raises the level.
    {
        const double soft[4] = {0.1, 0.5, 0.3, 0.3}, hard[4] = {0.95, 0.5, 0.3, 0.3};
        sustain(soft, 45);
        const double a = partial_db(45, 5), la = rms(out + 60 * 64, blocks * 64);
        sustain(hard, 45);
        const double b = partial_db(45, 5), lb = rms(out + 60 * 64, blocks * 64);
        std::printf("Breath 10 -> 95: 5th partial %.1f -> %.1f dB, level %.3f -> %.3f\n", a, b, la, lb);
        require(b > a + 4 && lb > la * 1.2, "Breath does not brighten and strengthen");
    }
    // The attack: the emphasis starts high and settles lower within ~0.3 s.
    {
        static Player p;
        const double controls[4] = {0.95, 0.5, 0.2, 0.0};
        p.begin(9);
        p.set(controls);
        p.note(45);
        p.run(1, out);  // the attack starts with the first block
        p.run(400, out + 64);
        const double f0 = hertz(45);
        double early = 0, late = 0, early_total = 0, late_total = 0;
        for (int k = 1; k <= 8; ++k) {
            const double e = magnitude(out + 2 * 64, 2048, k * f0), l = magnitude(out + 300 * 64, 2048, k * f0);
            early += k * e * e; early_total += e * e;
            late += k * l * l; late_total += l * l;
        }
        std::printf("attack: harmonic centroid %.2f at 5 ms, %.2f at 435 ms\n", early / early_total, late / late_total);
        require(early / early_total > late / late_total + 0.2, "no overblown attack");
    }
    std::puts("tuning: pitch, bore, Overtones, Air, Body, Breath and attack behave as documented");
    return 0;
}
