#pragma once
#include <opxy/audio.hpp>

namespace fujara {
using opxy::i16;
using opxy::i32;
using opxy::u32;

// Controls, in parameter order: Breath, Body, Overtones, Air.
const u32 control_count = 4;
// Partials of the blown tone: the fundamental and harmonics 2 to 8.
const u32 partial_count = 8;
// The bore: a delay line one period long. 1024 samples reach 43 Hz; lower
// notes resonate an octave (or two) up, which keeps every partial harmonic.
const u32 bore_length = 1024, bore_mask = bore_length - 1;

// Only sound state, all of it bounded: no pointers, no resources.
struct Voice {
    u32 phase;                    // the jet's phase, 2^32 per cycle
    u32 seed;                     // breath noise
    u32 write;                    // bore write position
    u32 started;                  // a note began; its onset is set by the next render
    u32 primed;                   // smoothed controls hold real values
    i32 control[control_count];   // block-smoothed controls, Q31
    i32 weight[partial_count];    // the last block's partial weights, Q15
    i32 drift;                    // slow pitch wander, Q15 noise
    i32 onset;                    // overblown attack, Q15, decays each block
    i32 scoop;                    // the attack's rise into pitch, Q15, decays each block
    i32 air_low, air_band;        // breath-noise band filter
    i32 bore_low;                 // the bore's loop filter (wood losses), Q15
    i32 dc;                       // the output's DC blocker: 2048 x its running mean
    i16 bore[bore_length];        // the bore's travelling wave, Q15
};
// Voices share nothing.
struct Shared {};
}
