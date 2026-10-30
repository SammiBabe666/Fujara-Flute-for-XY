// Generated translation unit. One display implementation, bounded SDK frame.
#include "display_binding.hpp"
#include "display.cpp"
using opxy::binding::Frame;
static_assert(sizeof(opxy::binding::DisplayState) == opxy::binding::display_bytes,
              "Declared display size differs from C++ type");
static_assert(alignof(opxy::binding::DisplayState) == opxy::binding::display_alignment,
              "Declared display alignment differs from C++ type");
static_assert(__is_trivial(opxy::binding::DisplayState) && __is_standard_layout(opxy::binding::DisplayState),
              "Display state must be trivial standard-layout data");
static_assert(sizeof(Frame) == 864 &&
              sizeof(Frame::path_type) == 516 && sizeof(opxy::draw::Node) == 28 &&
              __builtin_offsetof(Frame::path_type, points) == 4 &&
              __builtin_offsetof(Frame, nodes) == 516 &&
              __builtin_offsetof(Frame, texts) == 796 &&
              __builtin_offsetof(Frame, header) == 832 &&
              __builtin_offsetof(opxy::draw::Node, scale) == 8 &&
              __builtin_offsetof(opxy::draw::Node, cos) == 12 &&
              __builtin_offsetof(opxy::draw::Node, shade) == 20 &&
              __builtin_offsetof(opxy::draw::Node, paint) == 24 &&
              __builtin_offsetof(opxy::draw::Text, chars) == 12,
              "Drawing frame layout differs from the declared display");
extern "C" void fujara_display_reset(opxy::binding::DisplayState* state, Frame* frame) {
    fujara::display_reset(*state);
    for (opxy::u32 i = 0; i < Frame::path_count; ++i) frame->paths[i].key = 0;
}
extern "C" void fujara_display_render(opxy::binding::DisplayState* state,
                                       const opxy::draw::Input* input, Frame* frame) {
    fujara::display(*state, *input, *frame);
}
extern "C" unsigned fujara_display_validate(const Frame* frame) {
    return opxy::draw::valid(*frame);
}
