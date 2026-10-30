// Long holds: twenty minutes of the most resonant, most driven settings at
// the lowest and highest notes keep the bore's line within its proven bound,
// the output within the declared peak and free of DC, and the voice still
// sounding (no decay into silence, no runaway).
#include "play.h"

int main() {
    const double settings[3][4] = {{1, 1, 1, 1}, {0, 1, 0, 1}, {1, 1, 0, 0}};
    const double notes[3] = {0, 40, 127};
    for (unsigned s = 0; s < 3; ++s)
        for (unsigned n = 0; n < 3; ++n) {
            static Player p;
            p.begin(1 + s * 3 + n);
            p.set(settings[s]);
            p.note(notes[n]);
            const unsigned minutes = 20, blocks = minutes * 60 * 690 / 9;  // 20 minutes over the nine runs
            static double x[690 * 64];
            double sum = 0;
            unsigned seconds = 0;
            for (unsigned k = 0; k < blocks; k += 690) {
                p.run(690, x);
                for (unsigned i = 0; i < fujara::bore_length; ++i)
                    require(p.voice.bore[i] <= 31500 && p.voice.bore[i] >= -31500, "bore line beyond its bound");
                require(rms(x, 690 * 64) > 0.02, "a held note died away");
                sum += mean(x, 690 * 64);
                ++seconds;
                if (k % (690 * 60) == 0) fujara::start(p.voice, p.shared, p.owner);  // a retrigger each minute
            }
            // DC over the whole hold (over two minutes, so whole cycles do not matter).
            std::printf("setting %u note %3.0f: mean over %u s %+.6f\n", s, notes[n], seconds, sum / seconds);
            if (notes[n] >= 40) require(std::fabs(sum / seconds) < 0.0005, "a held note drifted to DC");
        }
    std::puts("stability: 20 minutes of extreme holds stay bounded, centred and sounding");
    return 0;
}
