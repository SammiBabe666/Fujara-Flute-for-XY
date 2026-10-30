// Shared helpers for Fujara's host tests. Tests use require(), never assert.
#pragma once
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>

inline void require(bool ok, const char* message) {
    if (!ok) {
        std::fprintf(stderr, "FAIL %s\n", message);
        std::exit(1);
    }
}

static const int peak = 1073741824;  // definition.json outputPeakQ31
static const double rate = 44100;

// Q31 control word for a normalised value.
inline int q31(double value) { return static_cast<int>(std::lrint(value * 2147483647.0)); }

// Phase increment for a MIDI note at 44.1 kHz.
inline unsigned increment(double midi) {
    return static_cast<unsigned>(std::llrint(440.0 * std::pow(2.0, (midi - 69) / 12) / rate * 4294967296.0));
}
inline double hertz(double midi) { return 440.0 * std::pow(2.0, (midi - 69) / 12); }

// The six shipped presets (definition.json), in order: Breath, Body, Overtones, Air.
struct Preset { const char* name; double values[4]; };
static const Preset presets[6] = {
    {"Mountain Breath", {0.45, 0.65, 0.35, 0.40}},
    {"Overtone Wraith", {0.55, 0.35, 0.90, 0.30}},
    {"Mourning Wood", {0.22, 0.85, 0.12, 0.25}},
    {"High Pasture", {0.40, 0.20, 0.62, 0.85}},
    {"Storm Calling", {0.95, 0.55, 0.78, 0.45}},
    {"The Hollow Saint", {0.30, 1.00, 0.62, 0.55}},
};

// Goertzel magnitude of one frequency over a buffer of doubles (Hann window).
inline double magnitude(const double* x, unsigned n, double hz) {
    const double w = 2 * 3.14159265358979323846 * hz / rate, c = 2 * std::cos(w);
    double s1 = 0, s2 = 0;
    for (unsigned i = 0; i < n; ++i) {
        const double window = 0.5 - 0.5 * std::cos(2 * 3.14159265358979323846 * i / (n - 1));
        const double s0 = x[i] * window + c * s1 - s2;
        s2 = s1;
        s1 = s0;
    }
    return std::sqrt(std::fabs(s1 * s1 + s2 * s2 - c * s1 * s2)) / n;
}
inline double db(double ratio) { return 20 * std::log10(ratio > 1e-12 ? ratio : 1e-12); }
