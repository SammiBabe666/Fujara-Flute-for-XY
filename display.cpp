#include "display.h"
#include "voicing.h"

// The screen is a still engraving of the fujara (panel.svg.fragment). Three
// small things answer the player:
//   - the breath wisp over the window grows with Breath and waves with Air;
//   - the overtone ladder under the bore shows which partials the controls
//     emphasise, and on each note replays the overblown cascade falling down
//     the series, settling within 0.2 s (the sound's cascade is a little longer);
//   - the window glows while notes are held.
// With nothing changing the frame stays identical, so the device redraws
// nothing. Reduced motion and track changes show the end state at once.
namespace fujara {
namespace {
using opxy::i32;
using opxy::u32;
using namespace opxy::draw;

const i32 kWindowX = 214, kWindowY = 119;    // wisp origin, pixels
const i32 kLadderX = 165, kLadderStep = 22, kLadderY = 196;
using voicing::q15;
using voicing::along;

// The wisp: a ribbon rising from the window, 14 to 60 px tall with Breath,
// swaying 1 to 6 px with Air, tapering to a point. 32 points up its left
// edge and 32 back down its right, every one distinct.
void wisp(Frame::path_type& path, i32 breath, i32 air) {
    const i32 length = (14 + 46 * breath / 32768) * unit;
    const i32 sway = unit + 5 * unit * air / 32768;
    const i32 base = unit * 3 / 2 + unit * 6 / 5 * breath / 32768;
    for (i32 i = 0; i < 32; ++i) {
        const i32 y = -length * i / 31;
        const i32 centre = sway * sine(i * 5400 / 31 % 3600) / unit * i / 31;
        const i32 half = base - (base - unit * 3 / 10) * i / 31;
        path.points[i].x = centre - half;
        path.points[i].y = y;
        path.points[63 - i].x = centre + half;
        path.points[63 - i].y = y;
    }
}
}

inline void display_reset(DisplayState& state) {
    state.notes.reset();
    state.serial = state.primed = state.track = 0;
    state.onset = state.glow = 0;
    state.key = 0;
}

inline void display(DisplayState& state, const Input& input, Frame& frame) {
    const i32 elapsed = clamp(input.elapsed, 0, 102);  // at most 0.1 s per frame
    const bool still = input.reduced_motion != 0;
    const NoteEvents events = state.notes.update(input);
    (void)events;
    const bool held = input.held_notes != 0 && input.held_notes <= 128;
    const i32 breath = q15(input.slots[0]), body = q15(input.slots[1]);
    const i32 overtones = q15(input.slots[2]), air = q15(input.slots[3]);

    // A new note restarts the cascade; initialising or changing track never does.
    if (!state.primed || state.track != input.track) {
        state.primed = 1;
        state.track = input.track;
        state.serial = input.note_serial;
        state.onset = 0;
        state.glow = held ? unit : 0;
    } else if (state.serial != input.note_serial) {
        state.serial = input.note_serial;
        state.onset = still ? 0 : unit;
    }
    // The cascade eases out over about 0.2 s (time constant 50 ms).
    state.onset = still ? 0 : state.onset * (unit - (elapsed * 20 < unit ? elapsed * 20 : unit)) / unit;
    if (state.onset < 16) state.onset = 0;
    const i32 glow_target = held ? unit : 0;
    if (still) state.glow = glow_target;
    else state.glow += (glow_target - state.glow) * (elapsed * 20 < unit ? elapsed * 20 : unit) / unit;
    if (state.glow < 8 && !held) state.glow = 0;
    if (state.glow > unit - 8 && held) state.glow = unit;

    // The wisp changes shape only when Breath or Air move by a visible step.
    // Its shape is built from the same 64-step values as its key.
    const i32 breath_step = breath >> 9, air_step = air >> 9;
    const u32 key = 1u + (static_cast<u32>(breath_step) << 8) + static_cast<u32>(air_step);
    if (key != state.key || frame.paths[0].key != key) {
        wisp(frame.paths[0], breath_step << 9, air_step << 9);
        frame.paths[0].key = key;
        state.key = key;
    }
    const i32 wisp_shade = clamp(6 + 6 * breath / 32768 + 3 * state.glow / unit, 0, 15);
    place(frame, 0, kWindowX * unit, kWindowY * unit, unit, static_cast<u32>(wisp_shade), stroke);

    // The ladder: each dot's brightness and size follow its partial's weight,
    // relative to the strongest.
    i32 weight[8];
    const i32 onset = state.onset * 32 * voicing::onset_strength(breath) / 32768;
    for (i32 h = 0; h < 8; ++h) weight[h] = voicing::weight(h, breath, body, overtones, onset);
    i32 strongest = 1;
    for (u32 h = 0; h < 8; ++h) strongest = weight[h] > strongest ? weight[h] : strongest;
    for (u32 h = 0; h < 8; ++h) {
        const i32 w = weight[h] * 64 / strongest;  // 0..64
        place(frame, 1 + h, (kLadderX + static_cast<i32>(h) * kLadderStep) * unit, kLadderY * unit,
              unit * 9 / 16 + unit * w / 96, static_cast<u32>(3 + w * 12 / 64), fill_and_stroke);
    }
    // The window glows while a note is held.
    place(frame, 9, kWindowX * unit + unit / 2, (kWindowY + 5) * unit, unit + unit * 2 / 5 * state.glow / unit,
          static_cast<u32>(2 + 13 * state.glow / unit), fill_and_stroke);
    for (u32 i = 0; i < opxy::page_controls; ++i) frame.header[i][0] = 0;  // stock values
}
}
