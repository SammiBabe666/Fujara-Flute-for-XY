# CPU test builds without the pinned tools at home

How the Fujara + Daath CPU test OS and its Chrome test page are made when the
computer holding the stock OS cannot run the SDK's pinned Blackfin tools.

1. **Compile in CI.** Run the *Profiling module* workflow
   ([.github/workflows/profiling-module.yml](../../.github/workflows/profiling-module.yml)).
   On Windows, with the SDK's hash-pinned tools, it compiles Fujara and Daath
   with profiling and the control sweep on ([compile_module.py](compile_module.py),
   the first half of `sdk.py build`), and force-pushes the module to the
   `profiling-module` branch. That is compiled code only: no firmware is used or made.
2. **Patch at home.** [finish_package.py](finish_package.py) checks that every
   machine and SDK source hash equals the compiled module's, then completes
   `sdk.py build` with the SDK's own code (`prepare_assets`, `assemble`: the
   reviewed edits only, the module confined to the reserved region, the stock
   OS reconstructed byte for byte from the result). The package has the usual
   layout, so `sdk.py profile` accepts it. Keep it private.

   ```sh
   git fetch origin profiling-module && git worktree add --detach ../module origin/profiling-module
   python tools/profiling/finish_package.py ../open-xy ../module <private>/stock-1.2.1/os.ldr <private>/fujara-daath-cpu-NNN . ../Daath-OP-XY-WitchHouse-engine
   ```

3. **Measure in Chrome.** [make_test_page.py](make_test_page.py) writes one
   HTML file bound to that package: it speaks the SDK collector's protocol
   (greet, identity, benchmark) over Web MIDI, refuses a device not in normal
   mode on OS 1.2.1, shows each machine's results and downloads each run as a
   capture in the collector's format.

   ```sh
   python tools/profiling/make_test_page.py ../open-xy <private>/fujara-daath-cpu-NNN "CPU test.html" fujara-daath-cpu-TAG
   ```

4. **Report.** `python ../open-xy/sdk.py profile report --package <package> --machine fujara --capture run-1.json --capture run-2.json --capture run-3.json --out <fresh folder>`
   (and again with `--machine daath`).

Differences from `sdk.py build`: the package has no `verification.json`, since
the independent rebuild needs the pinned tools; the compile itself is the
pinned one. Test-page captures name their collector as the browser page.
The page and the report path were checked against a simulated device;
hardware runs are what count.
