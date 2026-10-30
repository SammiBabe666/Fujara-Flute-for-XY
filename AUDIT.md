# Fujara: design and verification record

Validated against Open-XY SDK `staging` at
`8d4bb49de8a2d72453f0ca247fecbb0aeb0daf27` (29 October 2026; release 0.0.3,
machine format SDK 1.6, OS 1.2.1), the commit pinned in CI. Core machines read
for reference at `45d24ca`; Daath at `ea60d4a`.

**Hardware status: not verified on an OP-XY.** No device build, installation,
audition or CPU readout has happened. Everything below is host evidence.

## 1. Audit before implementation

Read in the SDK: AGENTS.md, README, CONTRIBUTING, `docs/` (first machine, API,
display, UX, profiling, preview, build, toolchain), `sdk/include/opxy/*.hpp`,
the preview and native artwork validators in `tooling/`, and the core machines
Karplus (delay-line synth), 2op FM and Macro Osc. Read in Daath: AGENTS.md,
AUDIT.md, README, definition, machine.json, core.h, engine.cpp, display,
generators, tests and CI.

What the SDK requires, as found:

| Topic | Requirement |
| --- | --- |
| Target | Blackfin+ BF707, GCC 8 (`-O2 -mcpu=bf707`, freestanding C++11): no FPU, no divide instruction, eight data registers |
| Block | 64 frames at 44.1 kHz; Q31 output at most half scale (`outputPeakQ31`) |
| Voices | `initialize`/`start`/`destroy`/`render`; storage zeroed, no constructors; `voiceCapacity` 8 recommended per track; pool = voice × (capacity + 1) |
| Memory | One 2,032 KiB module region shared by every selected machine |
| Display | 480 × 220, retained SVG; stock header above y ≈ 40; paths of distinct points that enclose area; at most four decimals; preview accepts only `g`, `path`, `circle`, `text` |
| Presets | Version 4 OP-XY JSON in a `presets` folder, `type` = machine ID, eight params 0..32767, no regions; at most 16 |
| CPU | Host estimate aim ≤ 15,000 instructions per voice block; catalog readout recommended ≤ 3.5% of the 580,352-cycle block, measured on hardware |

What Daath's release taught, and what Fujara reuses:

- **Host timing does not see register pressure.** Daath dropped audio on a
  device while its host estimate looked acceptable, because one sample loop
  carried more state than the Blackfin's eight data registers. Fujara was
  written as short passes from the start and checked in compiled Blackfin
  assembly (section 4), which found and removed spills that host timing never
  showed.
- Practices kept: generators for presets and artwork checked in CI, a
  bit-exact render hash guarding optimisations, sanitizer runs, a pinned SDK
  commit, `voiceCapacity` 8, and an honest pending-hardware statement.
- Not reused: Daath's DSP, artwork, palette and display code.

## 2. Plan (as carried out)

1. Scaffold with `sdk.py new --repository --id fujara`; four controls on the
   stock header.
2. DSP: additive harmonic jet + tuned delay-line bore + breath noise, integer
   only, per-block coefficients, short passes; prove bounds instead of clamping.
3. Display: static engraved artwork from a generator; three small bound
   elements that answer the player.
4. Six presets in definition.json → `generators/presets.py` → presets/.
5. Tests in Daath's shape, plus tuning, voices, stability and release checks.
6. Inspect compiled Blackfin loops; measure the host estimate against the core
   machines in the same session.
7. Hero art, real screen captures and the demo video from scripts in production/.

## 3. DSP architecture and rationale

Signal flow per voice and block:

```
breath noise -> band (rumble removed) -> x (base + jet/2) ----+
jet: partials 1..8, weights from voicing.h ------------------>+-> (1-g) -> bore -> wet
                                                               \-> dry: jet + free hiss
dry + wet -> drive (G = 1..2.75, 1.5u - 0.5u^3) -> trim -> DC blocker (3.4 Hz) -> clamp -> half scale
```

Why this model. A full jet-drive waveguide (a nonlinear jet feeding a bore)
makes overblowing emerge physically, but the played pitch then depends on
breath and the loop can lock to the wrong register: unusable for a keyboard
instrument that must play the note pressed. Fujara keeps the pitch exact by
generating the jet additively (each partial's phase is exactly *h* times the
fundamental's) and keeps the physical character with a real resonant bore:
breath noise passing through it becomes pitched air on the harmonics, and the
bore's wood losses colour the tone. The overtone choice that defines the fujara
is a moving emphasis over the series, its attack an overblown cascade down it.

| Part | Implementation | Cost and bounds |
| --- | --- | --- |
| Partial weights | `voicing.h`: natural roll-off (~1/h^1.5) brightened by Breath, a triangular emphasis whose centre is 2 + 5·Overtones + 0.75·Breath + 3·onset partials, a fundamental weighted by Body. Normalised so the sum is 0.29 × level of full scale. Weights under −72 dB are 0 | Per block: 8 small calculations, 8 divisions |
| Jet | Parabolic sine `x(1 − |x|)` in Q15 per partial; phase integrates a per-block increment ramp, so glides follow; weights glide across the block | 12 Blackfin instructions per partial-sample (14 while gliding); skipped when silent or above ~15 kHz |
| Breath noise | LCG white noise (quarter scale) → one-pole (Air sets cutoff) → minus a 220 Hz one-pole → × (base + jet/2) | ≤ 0.45 of full scale |
| Bore | 1,024-sample Q15 line; linear-interpolated read; one-pole loop filter (Body: 0.82 → 0.46); delay = period − filter lag; input × (1 − g), g = 0.52 → 0.94 | |x| ≤ X ⇒ |v| ≤ X by induction; X ≤ 31,490 < 32,767, so no clamp. Runs in chunks no longer than the delay: a gather pass then the recursion |
| Pitch | Wander: per-block one-pole of noise, 2 to 7 cents rms with Breath, clamped to ±40; +8 cents × Breath; attack scoop from −22 cents × strength, 28 ms | One Q31 multiply per block |
| Attack | `start()` sets a flag; the next block sets onset (re-voicing) and scoop; onset decays 0.988 per block and snaps to 0 below 64 | Phase and bore continue: no click |
| Output | Drive, cubic soft curve (≤ full scale), trim 0.875 → 0.55 with Breath², DC blocker, clamp, × 32768 | Never above 2^30, the declared peak |

Deliberate departures found during testing (each with a test):

- The bore's lowest notes were fixed at 1,000 samples instead of halving the
  period; above 10 kHz the delay could not get short enough. Both now stay on
  the harmonic series (`tests/tuning.cpp`: within 0.2% at all 128 notes).
- A retrigger stepped the partial weights and doubled the steepest sample step;
  weights now glide across each block (`tests/voices.cpp`).
- The shaper's asymmetry left DC; a 14 Hz blocker after it rippled into the
  clamp on low notes (4% of samples clipped at full Breath and Body on E2).
  Now a 3.4 Hz blocker with headroom: no clipping in 20 minutes
  (`tests/stability.cpp`).
- Storm Calling played 5 dB above the other presets; a breath trim now keeps
  the six within about 4 dB.

## 4. CPU and memory

**Method.** (a) The SDK host estimate, `sdk.py test` (render timed on the host
against a reference loop of known Blackfin cost, worst control setting), run
seven times with the core machines timed in the same session for calibration.
(b) The compiled render: the Blackfin+ GNU fork at the SDK's pinned commit
`e4408a1`, built locally with the SDK's two GCC patches and its exact
`-O2 -mcpu=bf707` flags; instructions counted in each inner loop with
[tools/blackfin_loops.py](tools/blackfin_loops.py). This compiler is not the
SDK's hash-pinned build (the SDK rejects it, correctly), and instruction counts
are not cycles.

| Reading | Result |
| --- | --- |
| First implementation, host estimate | about 28,900 |
| First implementation, compiled | every signed `/2^k` compiled to a compare and branch; the bore and mix loops spilled registers every sample (about 95 instructions per sample in the bore alone) |
| Final, compiled loops (instructions per sample) | partial 12 (14 gliding) × up to 8; noise 11; band and modulation 16; bore input 16; bore gather 14; bore recursion 15; drive and output 31. About **200 per sample** at the heaviest setting with a steady pitch (all 8 partials), **216** gliding: **about 12,800 to 13,800 per voice block** plus per-block set-up |
| Final, host estimate (7 runs) | 11,200 to 28,000, median 16,900; 2op FM in the same session 13,800 to 19,500, median 18,100 (published about 14,000). Fujara times at or below 2op FM |
| Cost against controls | flat within a few percent across all 37 swept settings (host timing): no heavy path |
| Render stack | 896 bytes (`-fstack-usage`, Blackfin), static; no recursion |
| Engine code | about 2.4 KB of Blackfin text |
| Voice | 2,144 bytes; with 8 voices and the spare, about 19 KiB of the shared 2,032 KiB |
| Display state | 40 bytes; one 64-point path, 10 nodes, no text slots |

**Not measured:** device cycles, the catalog's `block_percent`, behaviour with
many notes across tracks, and graphics cost on the device. The recommended
catalog limit (3.5% of 580,352 cycles, about 20,300 cycles per voice block)
sits above the instruction count, but pipeline stalls and memory waits are
unknown until a hardware run.

## 5. Test evidence

Commands run (host: Linux x86_64, GCC 13.3, Clang 18, Python 3.13 with NumPy
2.5.3; the SDK pins NumPy 2.3.5, which this host's package index could not
supply. Only `doctor` checks that pin; previews and tests ran normally):

```sh
python ../open-xy/sdk.py test --machine . --host-cxx g++        # PASS, 7 host test programs
for t in tests/*.cpp; do g++ -std=c++11 -O1 -fsanitize=undefined,address \
  -fno-sanitize-recover=all -Wall -Wextra -Werror -I../open-xy/sdk/include -I. $t && ./a.out; done   # all 7 pass
python tests/check_release.py --media                            # PASS
python ../open-xy/sdk.py preview --source . --out ../open-xy/local/fujara-preview-...   # PASS (smoke checks)
```

Browser preview, in Playwright's Chromium (headless): the workbench loads with
the `cpp-wasm` audio and display backends, all six presets appear, **Play
phrase** produces sound (output RMS 0.011 at the preview's default volume), and
the console shows no errors.

Selected measurements (from the tests' own output):

| Check | Result |
| --- | --- |
| Pitch at Breath 0, MIDI 24 to 108 | within 1.5 cents (typically under 1) |
| Preset pitch, mean of four voices | within 3 cents of 8 × Breath cents |
| Overtones 30 → 100 (D3) | whistle moves from the 4th to the 7th partial |
| Air 0 → 100 | noise between harmonics −78 → −33 dB |
| Body 0 → 100 | 4th partial relative to fundamental −6.0 → −17.7 dB |
| Breath 10 → 95 | 5th partial −26.9 → −17.8 dB; level 0.18 → 0.32 of peak |
| Attack (Breath 95, Overtones 20) | harmonic centroid 3.44 at 5 ms, 1.69 at 435 ms |
| Preset DC, 8 voices | at most 0.0002 of peak |
| Render hash | `0xfa28adc5`, identical with GCC -O0/-O2 and Clang -O3 |

## 6. Display

Static artwork (`generators/panel.py`): 299 paths and 25 circles, only the
subset both the preview and the device accept, at most two decimals. Bound
elements: a 64-point wisp (key changes only when its 64-step Breath/Air value
does), eight ladder dots and a window glow. Each frame does constant work (one
voicing evaluation per partial, 64 points only when the key changes). Motion
eases out within 0.2 s; idle frames are identical.

## 7. Assets

All assets come from scripts in production/ and the machine's own code:

| Asset | Made by | Notes |
| --- | --- | --- |
| `assets/fujara-hero.png`, `.jpg` | `hero.py` → Chromium | Original, procedural engraving; no text, no logos |
| `assets/fujara-device.png` | `capture_screens.mjs` | The preview's rendering of display.cpp at 480 × 220; not a device photograph |
| `assets/fujara-thumbnail.png` | `make_assets.py` | 16:9 artwork, title and the real screen |
| `assets/fujara-demo.mp4`, `-poster.png` | `make_demo.py` | 2:47, 1920 × 1080, H.264 + AAC 192 kb/s, 6.4 MB |

The demo's audio is the engine rendered offline (`production/render_demo.cc`
includes `engine.cpp`), through a linear-attack, exponential-release amp
envelope with this demo's own time mapping (not the device's), one gain for
the whole film to −1 dBFS peak, and nothing else. Every preset segment is
checked by the script to play exactly that preset's controls. The browser
preview's own audio was verified but not recorded into the film.

## 8. Pending

- A firmware build with the SDK's pinned tools and the owner's stock OS (not
  possible in the build environment: the SDK ships no Linux toolchain download,
  and its container recipe needs Docker and snapshot.debian.org). CI's
  `blackfin` job does compile and link the machine natively with the SDK's
  hash-pinned Windows tools (`sdk.py compile`, no stock files): it passed on
  commit `5bdccf4` (Actions run 41002412844).
- Installation, audition on an OP-XY, and the hardware CPU sweep readout
  ([profiling guide](https://github.com/etcetc000/open-xy/blob/staging/docs/profiling.md)).
- Engine and screen numbers come from the firmware's layout at build time.
