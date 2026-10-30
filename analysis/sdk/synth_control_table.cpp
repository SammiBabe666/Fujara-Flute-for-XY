// Generated ownership and control metadata for one collection's synths and FX.
#include "synth_controls.hpp"
#include "lfo.hpp"
extern "C" {
int fujara_record_ready() __asm__("fujara_record_ready");
extern const char fujara_engine_id[] __asm__("fujara_engine_id");
int fujara_ready() __asm__("fujara_ready");
}
using opxy::platform::SynthControls;
using opxy::platform::control_tenths;
using opxy::platform::control_ratio;
using opxy::platform::control_division;
using opxy::platform::control_label;

static bool fujara_format(opxy::u32 slot, opxy::i32 value, char* text) {
    switch (slot) {
    case 0:
        control_tenths(text, value < 0 ? 0 : ((static_cast<opxy::u32>(value) >> 10) * 1000 + (1u << 20)) >> 21, "");
        return true;
    case 1:
        control_tenths(text, value < 0 ? 0 : ((static_cast<opxy::u32>(value) >> 10) * 1000 + (1u << 20)) >> 21, "");
        return true;
    case 2:
        control_tenths(text, value < 0 ? 0 : ((static_cast<opxy::u32>(value) >> 10) * 1000 + (1u << 20)) >> 21, "");
        return true;
    case 3:
        control_tenths(text, value < 0 ? 0 : ((static_cast<opxy::u32>(value) >> 10) * 1000 + (1u << 20)) >> 21, "");
        return true;
    default: return false;
    }
}

const SynthControls sdk_synth_controls[] = {
    {fujara_engine_id, fujara_ready, {0, 1, 2, 3, 4, 5, 6, 7}, 15, {0, 0, 0, 0, 0, 0, 0, 0}, fujara_format, false, false},
    {nullptr, nullptr, {0, 1, 2, 3, 4, 5, 6, 7}, 0, {0, 0, 0, 0, 0, 0, 0, 0}, nullptr, false, false}
};
// The terminating entry keeps the array nonempty for a sample-only collection.
const opxy::u32 sdk_synth_control_count = sizeof(sdk_synth_controls) / sizeof(sdk_synth_controls[0]) - 1;

const opxy::platform::LfoMachine sdk_lfo_machines[] = {
    {fujara_engine_id, fujara_record_ready, 4, {0, 1, 2, 3}},
    {nullptr, nullptr, 0, {}}
};
const opxy::u32 sdk_lfo_machine_count = sizeof(sdk_lfo_machines) / sizeof(sdk_lfo_machines[0]) - 1;
