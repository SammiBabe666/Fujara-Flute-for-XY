#pragma once
#include <opxy/types.hpp>

// The fujara's voicing: how strongly each partial of the blown tone speaks
// for given controls. engine.cpp sounds these weights; display.cpp draws them
// on the overtone ladder. Q15 throughout, all within 32-bit arithmetic.
namespace fujara {
namespace voicing {
using opxy::i32;

inline i32 q15(i32 control) { return control < 0 ? 0 : control >> 16; }
// low + (high - low) * x for x in Q15.
inline i32 along(i32 x, i32 low, i32 high) { return low + (high - low) * x / 32768; }
inline i32 mul15(i32 a, i32 b) { return a * b / 32768; }

// Natural roll-off of a blown pipe's partials (about 1 / h^1.5).
const i32 rolloff[8] = {32767, 11585, 6306, 4096, 2931, 2229, 1769, 1448};

// The unnormalised weight of partial h (0 = fundamental). Overtones moves a
// triangle of emphasis, one to two partials wide, from the 2nd partial to the
// 7th; harder breath overblows it up to 0.75 partial higher, and an overblown
// attack (onset) lifts it by up to three more and lets it fall back. Body is
// the fundamental (and some 2nd); Breath brightens the natural series; strong
// overtones thin the fundamental and the natural series.
inline i32 weight(i32 h, i32 breath, i32 body, i32 overtones, i32 onset) {
    if (h == 0) return mul15(along(body, 12000, 32767), 32767 - mul15(overtones, 17000));
    const i32 centre = 512 + overtones * 1280 / 32768 + breath * 192 / 32768 + onset * 768 / 32768;  // Q8 partial number
    const i32 width = 460 - overtones * 200 / 32768;                         // Q8
    i32 emphasis = mul15(overtones, 22000) + mul15(onset, 20000);
    if (emphasis > 32767) emphasis = 32767;
    const i32 natural = 32767 - mul15(overtones, 19000);
    const i32 roll = h == 1 ? rolloff[1] + mul15(body, 5000) : mul15(rolloff[h], along(breath, 3600, 32767));
    const i32 distance = ((h + 1) << 8) - centre;
    const i32 near = width - (distance < 0 ? -distance : distance);
    const i32 peak = near > 0 ? near * 32767 / width : 0;
    return mul15(roll, natural) + mul15(mul15(peak, emphasis), 30000);
}
// The overblown attack's starting strength for a breath (Q15).
inline i32 onset_strength(i32 breath) { return along(breath, 9000, 32767); }
}
}
