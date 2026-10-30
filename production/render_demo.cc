// Renders the demo's audio from Fujara's own engine.cpp: the same C++ the
// OP-XY and the browser preview compile. Reads a score on stdin and writes
// 16-bit mono PCM at 44.1 kHz to stdout. Build and run with make_demo.py.
//
// Score lines (times in seconds):
//   controls <t> <breath> <body> <overtones> <air>   set the four controls from t
//   ramp <t0> <t1> <control> <from> <to>             move one control linearly (until the next controls line)
//   envelope <attack> <release>                       OP-XY amp envelope values, 0..32767
//   note <t> <duration> <midi>                        a note on a free voice
//   end <t>                                           length of the render
//
// After the engine, each voice passes through a simple linear-attack,
// exponential-release amp envelope standing in for the OP-XY's own amp
// envelope (which follows the engine on the device). Its time mapping,
// seconds = 8 * (value / 32767)^2, is this demo's approximation, not the
// device's. Nothing else is added: no reverb, filter or effect.
#include "engine.cpp"  // found through -I <repository root>
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <vector>

namespace {
const int kVoices = 8;  // definition.json voiceCapacity
const double kRate = 44100;

struct Note { double at, length; double midi; double attack, release; };
struct Ramp { double t0, t1; int control; double from, to; };
struct Controls { double at; double value[4]; };

struct Slot {
    fujara::Voice voice;
    bool active = false;
    int note = -1;
    double level = 0;
    unsigned owner = 0;
};

double seconds(double value) { const double v = value / 32767; return 8 * v * v; }
}

int main() {
    std::vector<Note> notes;
    std::vector<Ramp> ramps;
    std::vector<Controls> settings;
    double end = 0, attack = 1800, release = 9000;
    char word[32];
    while (std::scanf("%31s", word) == 1) {
        if (!std::strcmp(word, "controls")) {
            Controls c;
            if (std::scanf("%lf %lf %lf %lf %lf", &c.at, &c.value[0], &c.value[1], &c.value[2], &c.value[3]) != 5) return 2;
            settings.push_back(c);
        } else if (!std::strcmp(word, "ramp")) {
            Ramp r;
            if (std::scanf("%lf %lf %d %lf %lf", &r.t0, &r.t1, &r.control, &r.from, &r.to) != 5) return 2;
            ramps.push_back(r);
        } else if (!std::strcmp(word, "envelope")) {
            if (std::scanf("%lf %lf", &attack, &release) != 2) return 2;
        } else if (!std::strcmp(word, "note")) {
            Note n;
            if (std::scanf("%lf %lf %lf", &n.at, &n.length, &n.midi) != 3) return 2;
            n.attack = attack;
            n.release = release;
            notes.push_back(n);
        } else if (!std::strcmp(word, "end")) {
            if (std::scanf("%lf", &end) != 1) return 2;
        } else {
            std::fprintf(stderr, "unknown score word %s\n", word);
            return 2;
        }
    }
    static fujara::Shared shared;
    static Slot slots[kVoices];
    unsigned next_owner = 1;
    const long blocks = static_cast<long>(end * kRate / 64);
    std::vector<short> pcm;
    pcm.reserve(blocks * 64);
    std::vector<double> mix(64);
    std::vector<int> started(notes.size(), 0);
    for (long b = 0; b < blocks; ++b) {
        const double t = b * 64 / kRate;
        // Controls at this block: the last setting, then any ramp.
        // The latest setting, then the ramps that began after it.
        double value[4] = {0.45, 0.65, 0.35, 0.40}, since = 0;
        for (const Controls& c : settings)
            if (c.at <= t) { std::memcpy(value, c.value, sizeof(value)); since = c.at; }
        for (const Ramp& r : ramps)
            if (r.t0 >= since && t >= r.t0)
                value[r.control] = t >= r.t1 ? r.to : r.from + (r.to - r.from) * (t - r.t0) / (r.t1 - r.t0);
        opxy::i32 parameters[8] = {};
        for (int c = 0; c < 4; ++c) parameters[c] = static_cast<opxy::i32>(std::lrint(value[c] * 2147483647.0));
        // Note starts: a free voice, or the quietest releasing one.
        for (size_t i = 0; i < notes.size(); ++i) {
            if (started[i] || notes[i].at > t) continue;
            started[i] = 1;
            int pick = -1;
            for (int v = 0; v < kVoices && pick < 0; ++v) if (!slots[v].active) pick = v;
            if (pick < 0) {
                double quietest = 1e9;
                for (int v = 0; v < kVoices; ++v)
                    if (slots[v].level < quietest && notes[slots[v].note].at + notes[slots[v].note].length <= t) {
                        quietest = slots[v].level;
                        pick = v;
                    }
            }
            if (pick < 0) { std::fprintf(stderr, "more than %d voices at %.2f s\n", kVoices, t); return 3; }
            Slot& s = slots[pick];
            s.owner = next_owner++;
            fujara::initialize(s.voice, shared, s.owner);
            fujara::start(s.voice, shared, s.owner);
            s.active = true;
            s.note = static_cast<int>(i);
            s.level = 0;
        }
        std::fill(mix.begin(), mix.end(), 0.0);
        for (Slot& s : slots) {
            if (!s.active) continue;
            const Note& n = notes[s.note];
            opxy::u32 pitch[64];
            const opxy::u32 inc = static_cast<opxy::u32>(std::llrint(440.0 * std::pow(2.0, (n.midi - 69) / 12) / kRate * 4294967296.0));
            for (int i = 0; i < 64; ++i) pitch[i] = inc;
            opxy::i32 output[64];
            fujara::render(s.voice, shared, s.owner, output, parameters, pitch);
            const double rise = 1 / std::fmax(seconds(n.attack) * kRate, 1.0);
            const double fall = std::exp(-1 / std::fmax(seconds(n.release) / 6.9 * kRate, 1.0));  // -60 dB at the release time
            for (int i = 0; i < 64; ++i) {
                const double now = t + i / kRate;
                if (now < n.at + n.length) s.level = std::fmin(1.0, s.level + rise);
                else s.level *= fall;
                mix[i] += output[i] / 2147483648.0 * s.level;
            }
            if (t > n.at + n.length && s.level < 1e-4) s.active = false;
        }
        for (int i = 0; i < 64; ++i) {
            const double x = std::fmax(-1.0, std::fmin(1.0, mix[i]));
            pcm.push_back(static_cast<short>(std::lrint(x * 32767)));
        }
    }
    std::fwrite(pcm.data(), sizeof(short), pcm.size(), stdout);
    return 0;
}
