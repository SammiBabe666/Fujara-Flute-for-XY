// Generated: fujara's stock identity for the SDK's checked registration.
#include "registration.hpp"
extern "C" {
extern const char fujara_factory[] __asm__("fujara_factory");
extern const char fujara_parameter_name[] __asm__("fujara_parameter_name");
extern const char fujara_name[] __asm__("fujara_name");
extern const char fujara_engine_id[] __asm__("fujara_engine_id");
extern const char fujara_page_id[] __asm__("fujara_page_id");
extern char fujara_screen_state[] __asm__("fujara_screen_state");
extern const char fujara_screen_vtable[] __asm__("fujara_screen_vtable");
extern const char fujara_screen_asset[] __asm__("fujara_screen_asset");
char* fujara_screen_ctor(char*, opxy::u32) __asm__("fujara_screen_ctor");
int fujara_screen_register() __asm__("fujara_screen_register");
int fujara_register() __asm__("fujara_register");
int fujara_record_ready() __asm__("fujara_record_ready");
int fujara_name_matches(const void* string) __asm__("fujara_name_matches");
int fujara_ready() __asm__("fujara_ready");
}
namespace {
const opxy::platform::Record record = {fujara_factory, fujara_parameter_name, fujara_name, fujara_engine_id, fujara_page_id, 0};
const opxy::platform::Screen screen = {fujara_screen_state, 220, fujara_screen_vtable, fujara_screen_asset, fujara_screen_ctor};
}
int fujara_screen_register() { return sdk_register_screen(&record, &screen); }
int fujara_register() { return sdk_register_engine(&record); }
int fujara_record_ready() { return sdk_engine_ready(&record, nullptr); }
int fujara_name_matches(const void* string) { return sdk_name_matches(&record, string); }
int fujara_ready() { return sdk_engine_ready(&record, &screen); }
