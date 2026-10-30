// Renders the engine on the host for Fujara's tests: the same C++ the
// device and the browser preview compile.
#pragma once
#include "../engine.cpp"
#include "check.h"

static const unsigned block = opxy::block_frames;

struct Player {
    fujara::Voice voice;
    fujara::Shared shared;
    opxy::u32 owner;
    opxy::i32 parameters[8];
    opxy::u32 pitch[64];
    opxy::i32 output[64];

    void begin(opxy::u32 id) {
        std::memset(&voice, 0, sizeof(voice));
        owner = id;
        fujara::initialize(voice, shared, owner);
        fujara::start(voice, shared, owner);
    }
    void set(const double* controls) {
        for (unsigned c = 0; c < 8; ++c) parameters[c] = c < 4 ? q31(controls[c]) : 0;
    }
    void note(double midi) {
        const opxy::u32 inc = increment(midi);
        for (unsigned i = 0; i < block; ++i) pitch[i] = inc;
    }
    // Renders blocks into out (normalised to the declared peak), checking bounds.
    void run(unsigned blocks, double* out = 0) {
        for (unsigned b = 0; b < blocks; ++b) {
            fujara::render(voice, shared, owner, output, parameters, pitch);
            for (unsigned i = 0; i < block; ++i) {
                require(output[i] >= -peak && output[i] <= peak, "output above the declared peak");
                if (out) out[b * block + i] = output[i] / static_cast<double>(peak);
            }
        }
    }
};

inline double rms(const double* x, unsigned n) {
    double e = 0;
    for (unsigned i = 0; i < n; ++i) e += x[i] * x[i];
    return std::sqrt(e / n);
}
inline double mean(const double* x, unsigned n) {
    double s = 0;
    for (unsigned i = 0; i < n; ++i) s += x[i];
    return s / n;
}
// The frequency of the strongest component within +-range cents of hz, by a
// fine Goertzel scan in half-cent steps.
inline double strongest(const double* x, unsigned n, double hz, double range) {
    double best = -1, at = hz;
    const int steps = static_cast<int>(range * 2);
    for (int k = -steps; k <= steps; ++k) {
        const double f = hz * std::pow(2.0, k / 2.0 / 1200);
        const double m = magnitude(x, n, f);
        if (m > best) { best = m; at = f; }
    }
    return at;
}
inline double cents(double f, double reference) { return 1200 * std::log2(f / reference); }
