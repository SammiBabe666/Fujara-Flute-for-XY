// The screen: every frame valid through 20,000 random steps; the wisp keeps
// 64 distinct points, encloses area and changes its key whenever its points
// change; an idle screen stays still (frames identical); reset and track
// changes never fabricate a note; reduced motion shows the end state at once;
// a note's overtone cascade settles within 0.2 s; the ladder follows the
// engine's voicing; drawing does bounded work (no allocation, no recursion).
#include "../display.cpp"
#include "check.h"

typedef fujara::Frame Frame;

static long long area(const Frame::path_type& path) {
    long long twice = 0;
    for (unsigned i = 0; i < Frame::point_count; ++i) {
        const auto& a = path.points[i];
        const auto& b = path.points[(i + 1) % Frame::point_count];
        twice += static_cast<long long>(a.x) * b.y - static_cast<long long>(b.x) * a.y;
    }
    return twice < 0 ? -twice : twice;
}
static void check_outline(const Frame& frame) {
    const auto& path = frame.paths[0];
    require(path.key != 0, "outline without a key");
    require(area(path) > 4LL * opxy::draw::unit * opxy::draw::unit, "outline encloses no area");
    for (unsigned i = 0; i < Frame::point_count; ++i)
        for (unsigned j = i + 1; j < Frame::point_count; ++j)
            require(path.points[i].x != path.points[j].x || path.points[i].y != path.points[j].y,
                    "outline repeats a point; the device would merge it");
}
static bool same(const Frame& a, const Frame& b) { return std::memcmp(&a, &b, sizeof(Frame)) == 0; }

int main() {
    static fujara::DisplayState state;
    static Frame frame, previous;
    opxy::draw::Input input = {};
    input.elapsed = 17;  // about 60 frames a second
    input.track = 1;
    input.note_serial = 42;
    for (unsigned c = 0; c < 4; ++c) input.slots[c] = input.parameters[c] = q31(presets[0].values[c]);
    fujara::display_reset(state);
    fujara::display(state, input, frame);
    require(opxy::draw::valid(frame), "first frame invalid");
    check_outline(frame);
    // Idle: nothing changes, so the frame is identical (the device redraws nothing).
    for (unsigned k = 0; k < 600; ++k) {
        previous = frame;
        fujara::display(state, input, frame);
        require(same(previous, frame), "an idle screen moves");
    }
    // Reset with a held note and an old serial: no cascade, glow shown at once.
    input.held_notes = 1;
    input.note_serial = 7;
    fujara::display_reset(state);
    fujara::display(state, input, frame);
    require(state.onset == 0, "reset fabricated a note");
    require(state.glow == opxy::draw::unit, "reset did not show the held state");
    input.track = 2;
    input.note_serial = 99;
    fujara::display(state, input, frame);
    require(state.onset == 0, "a track change fabricated a note");
    // A note: the cascade starts and settles within 0.2 s; then still again.
    input.held_notes = 0;
    for (unsigned k = 0; k < 30; ++k) fujara::display(state, input, frame);
    input.note_serial = 100;
    input.held_notes = 1;
    fujara::display(state, input, frame);
    require(state.onset > opxy::draw::unit / 2, "a note did not start the cascade");
    const Frame struck = frame;
    for (unsigned k = 0; k < 12; ++k) fujara::display(state, input, frame);  // 0.2 s
    require(state.onset < 40, "the cascade does not settle");
    require(!same(struck, frame), "the cascade does not move the ladder");
    for (unsigned k = 0; k < 120; ++k) fujara::display(state, input, frame);
    previous = frame;
    fujara::display(state, input, frame);
    require(same(previous, frame), "a held note keeps the screen moving");
    // Reduced motion: no cascade, glow at its end state at once.
    input.reduced_motion = 1;
    input.note_serial = 101;
    input.held_notes = 0;
    fujara::display(state, input, frame);
    require(state.onset == 0 && state.glow == 0, "reduced motion animates");
    input.reduced_motion = 0;
    // The ladder: Overtones high lights an upper dot brightest; low lights a low one.
    for (unsigned k = 0; k < 60; ++k) fujara::display(state, input, frame);
    input.slots[2] = q31(1.0);
    for (unsigned k = 0; k < 60; ++k) fujara::display(state, input, frame);
    unsigned upper = 0;
    for (unsigned h = 1; h < 8; ++h) upper = frame.nodes[1 + h].shade > frame.nodes[1 + upper].shade ? h : upper;
    input.slots[2] = 0;
    for (unsigned k = 0; k < 60; ++k) fujara::display(state, input, frame);
    unsigned lower = 1;
    for (unsigned h = 1; h < 8; ++h) lower = frame.nodes[1 + h].shade > frame.nodes[1 + lower].shade ? h : lower;
    require(upper >= 5 && lower <= 2, "the ladder does not follow Overtones");
    // The wisp's key changes whenever its points change.
    opxy::u32 seed = 3;
    for (unsigned k = 0; k < 20000; ++k) {
        seed = seed * 1664525u + 1013904223u;
        previous = frame;
        if (seed % 7 == 0) input.slots[seed >> 30] = static_cast<opxy::i32>(seed >> 1);
        if (seed % 11 == 0) ++input.note_serial;
        if (seed % 13 == 0) input.held_notes = (seed >> 8) % 3;
        if (seed % 97 == 0) input.track = seed >> 28;
        if (seed % 89 == 0) input.reduced_motion ^= 1;
        if (seed % 211 == 0) fujara::display_reset(state);
        input.elapsed = static_cast<opxy::i32>((seed >> 9) % 140) - 10;  // late, early and invalid frames
        if (seed % 31 == 0) input.slots[seed >> 30] = static_cast<opxy::i32>(seed);  // hostile words
        fujara::display(state, input, frame);
        require(opxy::draw::valid(frame), "an invalid frame");
        check_outline(frame);
        if (std::memcmp(previous.paths[0].points, frame.paths[0].points, sizeof(frame.paths[0].points)) != 0)
            require(previous.paths[0].key != frame.paths[0].key, "the wisp changed without a new key");
    }
    std::puts("display: valid, still when idle, honest about notes, cascade settles, wisp keys tracked");
    return 0;
}
