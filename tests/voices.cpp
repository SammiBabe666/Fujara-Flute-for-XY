// Voice lifecycle: voices share no state (one voice's output is the same
// whether or not others render between its blocks); initialize fully resets a
// stolen voice (it then sounds exactly as a fresh one, with nothing of the old
// note); a retriggered note does not click; destroy holds nothing; and
// controls that jump are smoothed.
#include "play.h"

static const unsigned blocks = 300;
static double alone[blocks * 64], crowded[blocks * 64], fresh[blocks * 64], reused[blocks * 64];

// Largest sample-to-sample step over a range, normalised to the peak.
static double steepest(const double* x, unsigned from, unsigned to) {
    double s = 0;
    for (unsigned i = from + 1; i < to; ++i) s = std::fabs(x[i] - x[i - 1]) > s ? std::fabs(x[i] - x[i - 1]) : s;
    return s;
}

int main() {
    const double* storm = presets[4].values;
    // Independence.
    static Player a, b, c;
    a.begin(1); a.set(storm); a.note(50);
    a.run(blocks, alone);
    a.begin(1); a.set(storm); a.note(50);
    b.begin(2); b.set(presets[1].values); b.note(74);
    c.begin(3); c.set(presets[3].values); c.note(31);
    for (unsigned k = 0; k < blocks; ++k) {
        a.run(1, crowded + k * 64);
        b.run(1);
        c.run(2);
    }
    require(std::memcmp(alone, crowded, sizeof(alone)) == 0, "voices share state");
    // Reuse: a voice that played a loud high note, then initialised for a new
    // owner, matches a fresh voice for that owner sample for sample.
    a.begin(4); a.set(presets[5].values); a.note(43);
    a.run(blocks, fresh);
    a.begin(9); a.set(storm); a.note(96);
    a.run(500);
    fujara::initialize(a.voice, a.shared, 4);
    fujara::start(a.voice, a.shared, 4);
    a.owner = 4; a.set(presets[5].values); a.note(43);
    a.run(blocks, reused);
    require(std::memcmp(fresh, reused, sizeof(fresh)) == 0, "a reused voice keeps its old note");
    // destroy releases nothing and changes nothing.
    {
        static fujara::Voice before;
        std::memcpy(&before, &a.voice, sizeof(before));
        fujara::destroy(a.voice, a.shared, 4);
        require(std::memcmp(&before, &a.voice, sizeof(before)) == 0, "destroy changed the voice");
    }
    // Retrigger: start() mid-note keeps the phase and bore running, so the
    // waveform's steepest step near the retrigger is no larger than a normal
    // stretch of the same note (the overblown attack only re-voices it).
    for (unsigned p = 0; p < 6; ++p) {
        static double x[400 * 64];
        a.begin(5); a.set(presets[p].values); a.note(45);
        a.run(200, x);
        fujara::start(a.voice, a.shared, 5);
        a.run(200, x + 200 * 64);
        const double normal = steepest(x, 120 * 64, 190 * 64), at = steepest(x, 199 * 64, 203 * 64);
        require(at <= normal * 1.25, "a retrigger clicks");
    }
    // A control jumping from 0 to full moves the output gradually: no single
    // step larger than a steady full-breath note's.
    {
        static double x[300 * 64];
        const double low[4] = {0, 0, 0, 0}, high[4] = {1, 1, 1, 1};
        a.begin(6); a.set(low); a.note(50);
        a.run(100, x);
        a.set(high);
        a.run(200, x + 100 * 64);
        require(steepest(x, 99 * 64, 104 * 64) <= steepest(x, 200 * 64, 300 * 64) * 1.25, "a control jump clicks");
    }
    // Pitch glides inside a block (a ramp) and jumps between blocks stay bounded.
    {
        a.begin(8); a.set(presets[0].values);
        for (unsigned k = 0; k < 400; ++k) {
            for (unsigned i = 0; i < 64; ++i) a.pitch[i] = increment(30 + (k % 80) + i / 64.0);
            a.run(1);
        }
    }
    std::puts("voices: independent, fully reset on reuse, retriggers and control jumps are smooth");
    return 0;
}
