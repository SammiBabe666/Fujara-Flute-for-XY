// Every control corner and the middle, at pitches across the whole MIDI range,
// with restarts: bounded by the declared peak and audible. Then hostile input:
// negative and full-scale control words, and pitch buffers that jump within a
// block, for 4,000 blocks.
#include "play.h"

int main() {
    static Player p;
    const double notes[] = {0, 12, 24, 36, 48, 60, 72, 84, 96, 108, 120, 127};
    for (unsigned corner = 0; corner < 17; ++corner) {
        double controls[4];
        for (unsigned c = 0; c < 4; ++c) controls[c] = corner == 16 ? 0.5 : (corner >> c) & 1 ? 1.0 : 0.0;
        for (unsigned n = 0; n < sizeof(notes) / sizeof(notes[0]); ++n) {
            p.begin(1 + corner);
            p.set(controls);
            p.note(notes[n]);
            static double out[120 * 64];
            for (unsigned b = 0; b < 120; ++b) {
                if (b == 60) fujara::start(p.voice, p.shared, p.owner);
                p.run(1, out + b * block);
            }
            require(rms(out + 20 * block, 100 * block) > 0.02, "a corner is silent");
        }
    }
    p.begin(7);
    opxy::u32 seed = 1;
    for (unsigned b = 0; b < 4000; ++b) {
        for (unsigned c = 0; c < 8; ++c) p.parameters[c] = static_cast<opxy::i32>(seed = seed * 1664525u + 1013904223u);
        for (unsigned i = 0; i < block; ++i) p.pitch[i] = (seed >> (i & 7)) + i * 99991u;
        if (b % 97 == 0) fujara::start(p.voice, p.shared, p.owner);
        p.run(1);
    }
    std::puts("sound: 17 control settings x 12 pitches bounded and audible; 4,000 hostile blocks bounded");
    return 0;
}
