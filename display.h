#pragma once
#include <opxy/draw.hpp>

namespace fujara {
// Matches resources.display in definition.json: paths, points, nodes, texts, palette.
// Node 0 is the breath wisp, 1..8 the overtone ladder, 9 the window's glow.
using Frame = opxy::draw::Frame<1, 64, 10, 0, 16>;
struct DisplayState {
    opxy::draw::NoteTracker notes;  // 16 bytes
    opxy::u32 serial;               // last note-start serial seen
    opxy::u32 primed;               // serial and track hold real values
    opxy::u32 track;
    opxy::i32 onset;                // Q10: 1 at a note start, eases to 0 (the overtone cascade)
    opxy::i32 glow;                 // Q10: the window's glow, eases toward held / not held
    opxy::u32 key;                  // the wisp's geometry key
};
}
