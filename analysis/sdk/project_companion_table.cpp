// Generated: this collection's machines for project companions, sorted by ID.
#include "project_companion.hpp"
extern "C" {
extern const char fujara_engine_id[] __asm__("fujara_engine_id");
extern const char fujara_page_id[] __asm__("fujara_page_id");
}

const opxy::platform::CompanionMachine sdk_companion_machines[] = {
    {"fujara", fujara_engine_id, fujara_page_id, false},
    {nullptr, nullptr, nullptr, false}
};
