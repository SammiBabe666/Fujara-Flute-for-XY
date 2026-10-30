// Bit-exact output: a fixed workload (every preset, extreme and random
// controls, retriggers, stolen voices, pitch steps, glides and bends across
// the keyboard) hashes to the value recorded for this release. Any change to
// the sound changes the hash: an optimisation must keep it; a deliberate
// sound change records the new value here and says why in AUDIT.md.
#include "play.h"

static const opxy::u32 expected = 0xfa28adc5u;

int main() {
    static Player p;
    opxy::u32 hash = 2166136261u, seed = 12345;
    for (unsigned run = 0; run < 24; ++run) {
        p.begin(1 + run * 37);
        for (unsigned k = 0; k < 750; ++k) {
            if (k % 125 == 0) {
                seed = seed * 1664525u + 1013904223u;
                if (run < 6) p.set(presets[run].values);
                else if (run < 12) { const double edge[4] = {run & 1 ? 1.0 : 0.0, run & 2 ? 1.0 : 0.0, run & 4 ? 1.0 : 0.0, run & 8 ? 0.0 : 1.0}; p.set(edge); }
                else for (unsigned c = 0; c < 4; ++c) p.parameters[c] = static_cast<opxy::i32>((seed >> c) & 0x7fffffff);
                fujara::start(p.voice, p.shared, p.owner);
            }
            if (k == 375 && run % 3 == 0) {  // a stolen voice
                fujara::initialize(p.voice, p.shared, 999 + run);
                fujara::start(p.voice, p.shared, 999 + run);
                p.owner = 999 + run;
            }
            const double base = 12 + (run * 13 + k / 50 * 7) % 108;
            for (unsigned i = 0; i < 64; ++i)
                p.pitch[i] = run % 4 == 1 ? increment(base + (k % 50) / 25.0 + i / 1600.0)  // glide
                           : run % 4 == 2 ? increment(base) + ((k * 977u + i * 131u) & 0xffffu)  // bend noise
                           : increment(base);
            p.run(1);
            for (unsigned i = 0; i < 64; ++i) hash = (hash ^ static_cast<opxy::u32>(p.output[i])) * 16777619u;
        }
    }
    std::printf("render hash %#010x\n", hash);
    require(hash == expected, "the sound changed: see the comment at the top of tests/render.cpp");
    return 0;
}
