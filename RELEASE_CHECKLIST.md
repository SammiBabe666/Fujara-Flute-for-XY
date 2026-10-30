# Release checklist

Paths: `<sdk>` is an Open-XY checkout at the commit pinned in
[the workflow](.github/workflows/machine.yml); `<private>` is a folder outside
every checkout for firmware, for example `~/.local/share/OPXY-SDK/private`
(Linux), `~/Library/Application Support/OPXY-SDK/private` (macOS) or
`%LOCALAPPDATA%/OPXY-SDK/private` (Windows). Never commit or publish firmware,
stock files or firmware packages.

## Host (done for this release; repeat after any change)

- [x] `python <sdk>/sdk.py test --machine . --host-cxx g++`: PASS, 7 host test programs
- [x] Tests under UBSan and ASan with `-Wall -Wextra -Werror` (CI does this)
- [x] `python generators/presets.py . && python generators/panel.py . && git diff --exit-code`
- [x] `python tests/check_release.py --media`
- [x] Browser preview builds, plays and draws without console errors
- [x] Six presets, Mountain Breath as `default.json`
- [x] Assets rebuilt from source (`production/make_assets.py`, `production/make_demo.py`)
- [x] Demo MP4 checked: H.264 1920 × 1080, AAC, 2:47, every preset segment checked
- [x] AUDIT.md and README match the measured numbers
- [x] CI green on the pushed commit, including the native Blackfin compile with the SDK's pinned tools (run 41002412844, commit 5bdccf4)

## Device build (needs your computer)

1. Get the pinned tools (Windows x86_64 or Apple-silicon macOS; on Linux,
   build them with `tools/gcc/build-linux.sh` in the SDK's container):

   ```sh
   cd <sdk>
   python sdk.py toolchain fetch
   ```

2. Keep your stock OS 1.2.1 at `<private>/stock-1.2.1/os.ldr`. Its SHA-256 must be
   `60358afdaa9b58ed40411602f6d5d4e1e3e02553ff2da7e25038e71dd002b52f`.
3. Commit this repository's state, then build a profiling development image
   (pass `--layout <your last layout.json>` if you have built before, so other
   machines keep their numbers):

   ```sh
   python sdk.py build --machine ../Fujara-Flute-for-XY --profiling on \
     --stock-os <private>/stock-1.2.1/os.ldr --out <private>/fujara-build-001
   ```

4. Install the package's `candidate/` files using the SDK's
   [installation steps](https://github.com/etcetc000/open-xy/blob/staging/docs/build.md#5-install),
   then power-cycle. Keep `layout.json` from the build.

## Device checks (needs your OP-XY)

- [ ] Fujara appears in the engine list; the screen matches `assets/fujara-device.png` in layout
- [ ] The six presets load and sound as described; Mountain Breath is the init sound
- [ ] Hold eight notes on one track at Storm Calling and at The Hollow Saint: no dropped audio
- [ ] Play Fujara on several tracks at once with other machines: no dropped audio
- [ ] Turn every control quickly while notes sound: no clicks or runaway level
- [ ] Release notes: no stuck voices; long releases fade cleanly
- [ ] Levels sit with stock engines and other Open-XY machines
- [ ] Hardware CPU readout, from [profiling](https://github.com/etcetc000/open-xy/blob/staging/docs/profiling.md):

  ```sh
  python -m pip install python-rtmidi
  python sdk.py profile benchmark --package <private>/fujara-build-001 --installed --greet --out <private>/fujara-cpu-001
  python sdk.py profile report --package <private>/fujara-build-001 --machine fujara \
    --capture <private>/fujara-cpu-001/capture.json --out <private>/fujara-cpu-report-001
  ```

  Fujara uses breath noise, so collect three captures and pass all of them.
  Keep `block_percent` at or below 3.5%; if it is higher, the readout names the
  heaviest setting. Record the result in AUDIT.md. Keep captures private.

## Publication (only when you decide)

- [ ] Tag the measured commit
- [ ] Catalog entry with the hardware `cpu` record, per the SDK's
      [catalog submission](https://github.com/etcetc000/open-xy/blob/staging/docs/catalog.md#submit-a-machine)
