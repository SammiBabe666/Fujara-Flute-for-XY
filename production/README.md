# Making the artwork and the demo

Everything in [assets/](../assets) is made by these scripts from this
repository's own code. Run them from the repository root with the Open-XY SDK
checked out beside it (`../open-xy`).

| Script | Makes |
| --- | --- |
| [hero.py](hero.py) | The hero artwork as SVG: an original, procedural engraving (seeded, so it is the same every run) |
| [render_svg.mjs](render_svg.mjs) | Renders an SVG to PNG with Playwright's Chromium |
| [make_assets.py](make_assets.py) | `fujara-hero.png` (2560 × 1280), `fujara-hero.jpg` (1280 × 640), `fujara-thumbnail.png` (1920 × 1080) |
| [render_demo.cc](render_demo.cc) | The demo's audio: includes `engine.cpp`, renders a score with eight voices through a simple amp envelope, writes 16-bit PCM |
| [capture_screens.mjs](capture_screens.mjs) | The real screen, frame by frame: steps the machine's `display.cpp` (compiled by `sdk.py preview`) in the SDK's browser renderer along the demo timeline |
| [make_demo.py](make_demo.py) | The whole demo: preview build and server, audio, screens, composition, H.264/AAC encoding, poster and `fujara-device.png` |

## Requirements

- Python 3.11+ with NumPy and Pillow
- Node 22+ with Playwright and its Chromium (`npm i -g playwright && npx playwright install chromium`;
  set `NODE_PATH` to the global module folder, `export NODE_PATH=$(npm root -g)`)
- A C++11 compiler (`g++` or `clang++`)
- ffmpeg with `libx264` and `aac`, and ffprobe
- The Inter and Inter Display fonts (SIL Open Font License) at
  `/usr/share/fonts/opentype/inter/` (edit `font()` in `make_demo.py` and the
  paths in `make_assets.py` elsewhere)
- The SDK's preview requirements (Clang with wasm32 and wasm-ld)

## Commands

```sh
export NODE_PATH=$(npm root -g)
python production/make_demo.py --sdk ../open-xy --work ../fujara-demo-work     # about 2 minutes
python production/make_assets.py --work ../fujara-assets-work                  # after make_demo (uses fujara-device.png)
python tests/check_release.py --media
```

`make_demo.py` prints each preset segment's controls (and stops if any segment
would not play exactly its preset), the audio level of every segment, and
ffprobe's view of the result. It serves the preview on port 8937 while it runs.

## What the demo is

- **Sound**: Fujara's own `engine.cpp`, compiled for the host, playing the
  score in `make_demo.py` with up to eight voices. A linear-attack,
  exponential-release envelope stands in for the OP-XY's amp envelope (its
  time mapping, `8 × (value / 32767)²` seconds, is the demo's own, not the
  device's). One gain sets the whole film's peak to −1 dBFS. There is no
  reverb, filter, effect or sample.
- **Screen**: the machine's own `display.cpp`, compiled to WebAssembly by
  `sdk.py preview` and drawn by the SDK's browser renderer and screen template,
  stepped at 30 frames a second with the same notes and controls as the sound.
  The browser's fonts stand in for the device's in the header.
- **Not shown**: an OP-XY. Nothing in the film was filmed or recorded on a device.

The score is newly composed for this demo. To change it, edit `PHRASES`,
`CONTROL_TEXT`, `DESCRIPTIONS` and the segment lengths in `make_demo.py`.
