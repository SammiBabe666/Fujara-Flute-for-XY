"""Produces the demo video, its poster and the device screenshot from the
machine's own code. Run from the repository root, with the Open-XY SDK beside it:

    python production/make_demo.py --sdk ../open-xy --work ../fujara-demo-work

Steps (each prints what it did):
  1. Builds the browser preview with `sdk.py preview` and serves it locally.
  2. Compiles production/render_demo.cc (which includes engine.cpp) with the
     host C++ compiler and renders the score below: the engine's real output,
     through a simple amp envelope, with no effects.
  3. Steps the machine's display code through the same timeline in the SDK's
     browser renderer (production/capture_screens.mjs) to capture every screen.
  4. Composes 1920 x 1080 frames (hero artwork, the captured screens, labels)
     and encodes H.264 + AAC with ffmpeg.
  5. Writes assets/fujara-demo.mp4, assets/fujara-demo-poster.png and
     assets/fujara-device.png, and prints ffprobe's view of the MP4.

Needs: Python 3 with Pillow and NumPy, Node 22 with Playwright's Chromium,
g++ (or another C++11 compiler), ffmpeg with libx264 and aac, Inter and GFS
Display fonts (OFL), and the SDK's preview requirements.
"""
import argparse, importlib.util, json, os, shutil, subprocess, sys, time, wave
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parent.parent
FPS = 30
W, H = 1920, 1080
PORT = 8937
STATUS = ('Host tests pass (sdk.py test, 7 test programs)  ·  browser preview verified  ·  '
          'OP-XY hardware CPU profiling still pending')

# ------------------------------------------------------------------ the score
definition = json.loads((ROOT / 'definition.json').read_text())
PRESETS = list(definition['presets'].items())
ORDER = ['breath', 'body', 'overtones', 'air']
spec = importlib.util.spec_from_file_location('presets_generator', ROOT / 'generators' / 'presets.py')
generator = importlib.util.module_from_spec(spec)
sys.argv, saved = ['presets.py', str(ROOT)], sys.argv
spec.loader.exec_module(generator)
sys.argv = saved
SHAPE = generator.SHAPE

DESCRIPTIONS = {
    'Mountain Breath': 'Warm, woody and airy: the foundational fujara voice.',
    'Overtone Wraith': 'The whistle climbs to the 7th partial: ghostly upper harmonics.',
    'Mourning Wood': 'Soft breath, a dark bore: the fundamental and the wood speak.',
    'High Pasture': 'Light and very airy, the 5th partial singing over a thin bore.',
    'Storm Calling': 'Forceful breath: overblown attacks, driven partials, unsteady pitch.',
    'The Hollow Saint': 'Full bore resonance: a drone under a slow ceremonial line.',
}
# Phrases: (start, length, MIDI note), seconds from the segment's start.
PHRASES = {
    'Mountain Breath': [(0.5, 2.6, 62), (3.3, 1.2, 64), (4.6, 1.6, 62), (6.3, 2.4, 57), (8.9, 1.1, 59),
                        (10.1, 1.3, 57), (11.5, 1.4, 55), (13.0, 4.2, 50)],
    'Overtone Wraith': [(0.5, 4.5, 52), (5.3, 3.8, 57), (9.4, 2.2, 55), (11.8, 5.4, 52)],
    'Mourning Wood': [(0.6, 3.2, 45), (4.0, 1.8, 48), (6.0, 2.2, 47), (8.4, 2.0, 45), (10.6, 1.6, 43), (12.4, 4.8, 40)],
    'High Pasture': [(0.4, 0.8, 74), (1.3, 0.5, 76), (1.9, 1.4, 78), (3.5, 0.6, 76), (4.2, 0.6, 74), (4.9, 1.8, 71),
                     (7.0, 0.5, 74), (7.6, 0.5, 76), (8.2, 0.5, 78), (8.8, 1.6, 81), (10.6, 0.7, 78), (11.4, 0.7, 76),
                     (12.2, 0.7, 74), (13.0, 3.8, 69)],
    'Storm Calling': [(0.4, 0.9, 55), (1.4, 0.9, 55), (2.4, 2.2, 62), (4.8, 0.7, 60), (5.6, 0.7, 58), (6.4, 2.0, 55),
                      (8.8, 0.6, 55), (9.5, 0.6, 58), (10.2, 0.6, 62), (10.9, 2.6, 67), (13.7, 3.4, 55)],
    'The Hollow Saint': [(0.3, 16.8, 38), (1.5, 3.5, 50), (5.5, 3.0, 45), (9.0, 3.5, 53), (13.0, 3.8, 50)],
}
CONTROL_TEXT = [
    ('Breath', 'How hard the pipe is blown: level, brightness, the overblown attack.'),
    ('Body', 'The fundamental and the resonance of the wooden bore.'),
    ('Overtones', 'Moves the whistle up the harmonic series.'),
    ('Air', 'The breath noise: part pitched by the bore, part free.'),
]
OPEN, TOUR, PRESET, CLOSE = 15.0, 20.0, 19.5, 15.0
TOTAL = OPEN + TOUR + PRESET * len(PRESETS) + CLOSE


def score():
    """Segments, notes, control settings and ramps on one timeline."""
    segments, notes, settings, ramps = [], [], [], []
    default = [PRESETS[0][1][k] for k in ORDER]
    shape0 = SHAPE[PRESETS[0][0]]
    segments.append(('open', 0.0, OPEN, None))
    settings.append((0.0, default))
    for at, length, midi in [(2.0, 3.5, 50), (6.0, 2.0, 57), (8.3, 2.5, 55), (11.2, 3.0, 50)]:
        notes.append((at, length, midi, shape0['attack'], shape0['release']))
    t = OPEN
    segments.append(('tour', t, TOUR, None))
    for k in range(4):
        start = t + 0.6 + k * 4.8
        notes.append((start, 4.4, 50, shape0['attack'], shape0['release']))
        base = default[k]
        peak = 0.0 if k == 1 else 1.0
        ramps.append((start + 0.4, start + 2.0, k, base, peak))
        ramps.append((start + 2.0, start + 3.8, k, peak, 1.0 - peak if k == 1 else (0.0 if k == 3 else base)))
        ramps.append((start + 3.8, start + 4.4, k, 1.0 - peak if k == 1 else (0.0 if k == 3 else base), base))
    t += TOUR
    for i, (name, values) in enumerate(PRESETS):
        segments.append(('preset', t, PRESET, i))
        settings.append((t, [values[k] for k in ORDER]))
        for at, length, midi in PHRASES[name]:
            notes.append((t + at, length, midi, SHAPE[name]['attack'], SHAPE[name]['release']))
        t += PRESET
    segments.append(('close', t, CLOSE, None))
    settings.append((t, default))
    notes.append((t + 0.5, 6.5, 50, shape0['attack'], shape0['release']))
    notes.append((t + 2.5, 4.5, 57, shape0['attack'], shape0['release']))
    return segments, notes, settings, ramps


def controls_at(t, settings, ramps):
    """The controls at t: the latest setting, then the ramps that began after
    it (render_demo.cc applies the same rule)."""
    value, since = list(settings[0][1]), settings[0][0]
    for at, v in settings:
        if at <= t:
            value, since = list(v), at
    for t0, t1, k, a, b in ramps:
        if since <= t0 <= t:
            value[k] = b if t >= t1 else a + (b - a) * (t - t0) / (t1 - t0)
    return value


def segment_at(t, segments):
    for kind, start, length, index in segments:
        if start <= t < start + length:
            return kind, start, index
    return segments[-1][0], segments[-1][1], segments[-1][3]


# ------------------------------------------------------------------ helpers
def run(cmd, **kw):
    print('$ ' + ' '.join(str(c) for c in cmd), flush=True)
    return subprocess.run(cmd, check=True, **kw)


def font(name, size):
    paths = {'serif': '/usr/share/fonts/opentype/inter/InterDisplay-ExtraLight.otf',
             'title': '/usr/share/fonts/opentype/inter/InterDisplay-Light.otf',
             'light': '/usr/share/fonts/opentype/inter/Inter-Light.otf',
             'regular': '/usr/share/fonts/opentype/inter/Inter-Regular.otf',
             'medium': '/usr/share/fonts/opentype/inter/Inter-Medium.otf'}
    if not os.path.exists(paths[name]):
        raise SystemExit('missing font ' + paths[name])
    return ImageFont.truetype(paths[name], size)


def spaced(draw, xy, text, fnt, fill, spacing):
    x, y = xy
    for ch in text:
        draw.text((x, y), ch, font=fnt, fill=fill)
        x += draw.textlength(ch, font=fnt) + spacing
    return x


# ------------------------------------------------------------------ main
def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--sdk', default=str(ROOT.parent / 'open-xy'))
    parser.add_argument('--work', default=str(ROOT.parent / 'fujara-demo-work'))
    parser.add_argument('--cxx', default='g++')
    args = parser.parse_args()
    sdk, work = Path(args.sdk).resolve(), Path(args.work).resolve()
    if work.exists():
        shutil.rmtree(work)
    work.mkdir(parents=True)
    segments, notes, settings, ramps = score()
    print('Timeline %.1f s, %d notes' % (TOTAL, len(notes)))
    # Each preset segment sounds and shows exactly its preset's controls.
    for kind, start, length, index in segments:
        if kind == 'preset':
            heard = controls_at(start + length / 2, settings, ramps)
            expected = [PRESETS[index][1][k] for k in ORDER]
            if any(abs(a - b) > 1e-9 for a, b in zip(heard, expected)):
                raise SystemExit('score error: %s plays %s' % (PRESETS[index][0], heard))
            print('  %-17s %s' % (PRESETS[index][0], ' '.join('%s %d' % (k, round(v * 100)) for k, v in zip(ORDER, heard))))

    # 1. Preview build and server.
    preview = sdk / 'local' / ('fujara-demo-%d' % int(time.time()))
    run([sys.executable, 'sdk.py', 'preview', '--source', str(ROOT), '--out', str(preview)], cwd=sdk)
    server = subprocess.Popen([sys.executable, 'tools/serve_harness.py', '--preview', str(preview), '--port', str(PORT)],
                              cwd=sdk, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    time.sleep(3)
    try:
        # 2. Audio from the engine.
        exe = work / 'render_demo'
        run([args.cxx, '-std=c++11', '-O2', '-I', str(sdk / 'sdk' / 'include'), '-I', str(ROOT),
             str(ROOT / 'production' / 'render_demo.cc'), '-o', str(exe)])
        lines = []
        for at, value in settings:
            lines.append('controls %.4f %s' % (at, ' '.join('%.4f' % v for v in value)))
        for t0, t1, k, a, b in ramps:
            lines.append('ramp %.4f %.4f %d %.4f %.4f' % (t0, t1, k, a, b))
        for at, length, midi, attack, release in sorted(notes):
            lines.append('envelope %d %d' % (attack, release))
            lines.append('note %.4f %.4f %d' % (at, length, midi))
        lines.append('end %.4f' % TOTAL)
        (work / 'score.txt').write_text('\n'.join(lines) + '\n')
        pcm = subprocess.run([str(exe)], input=(work / 'score.txt').read_bytes(), stdout=subprocess.PIPE, check=True).stdout
        audio = np.frombuffer(pcm, dtype=np.int16).astype(np.float64) / 32767
        peak = np.max(np.abs(audio))
        gain = 10 ** (-1.0 / 20) / peak  # one gain for the whole film: -1 dBFS peak
        audio *= gain
        print('Audio: %.1f s, raw peak %.3f, gain %.2f dB' % (len(audio) / 44100, peak, 20 * np.log10(gain)))
        for kind, start, length, index in segments:
            seg = audio[int(start * 44100):int((start + length) * 44100)]
            label = PRESETS[index][0] if index is not None else kind
            print('  %-17s rms %.1f dBFS, peak %.1f dBFS' % (label, 20 * np.log10(np.sqrt(np.mean(seg ** 2))),
                                                            20 * np.log10(np.max(np.abs(seg)))))
        with wave.open(str(work / 'audio.wav'), 'wb') as w:
            w.setnchannels(2)
            w.setsampwidth(2)
            w.setframerate(44100)
            s16 = np.round(audio * 32767).astype(np.int16)
            w.writeframes(np.repeat(s16, 2).tobytes())

        # 3. Screens from the display code.
        frames = []
        count = int(round(TOTAL * FPS))
        for n in range(count):
            t = n / FPS
            on = sum(1 for at, *_ in notes if at <= t)
            off = sum(1 for at, length, *_ in notes if at + length <= t)
            held = len({midi for at, length, midi, *_ in notes if at <= t < at + length})
            frames.append({'c': [round(v, 5) for v in controls_at(t, settings, ramps)], 'on': on, 'held': held, 'off': off})
        (work / 'timeline.json').write_text(json.dumps({'fps': FPS, 'frames': frames}))
        run(['node', str(ROOT / 'production' / 'capture_screens.mjs'), str(work / 'timeline.json'),
             str(work / 'screens'), str(PORT), '2.5'])
        # The device screenshot: Mountain Breath, a note held after its attack, at 480 x 220.
        still = [{'c': [PRESETS[0][1][k] for k in ORDER], 'on': 0, 'held': 0, 'off': 0}] * 10 + \
                [{'c': [PRESETS[0][1][k] for k in ORDER], 'on': 1, 'held': 1, 'off': 0}] * 30
        (work / 'still.json').write_text(json.dumps({'fps': FPS, 'frames': still}))
        run(['node', str(ROOT / 'production' / 'capture_screens.mjs'), str(work / 'still.json'), str(work / 'still'), str(PORT), '1'])
    finally:
        server.terminate()
    index = json.loads((work / 'screens' / 'index.json').read_text())['frames']
    still_index = json.loads((work / 'still' / 'index.json').read_text())['frames'][-1]
    shutil.copy(work / 'still' / ('screen-%d.png' % still_index), ROOT / 'assets' / 'fujara-device.png')

    # 4. Frames and encoding.
    run([sys.executable, str(ROOT / 'production' / 'hero.py'), str(work / 'hero16x9.svg'), str(W), str(H)])
    run(['node', str(ROOT / 'production' / 'render_svg.mjs'), str(work / 'hero16x9.svg'), str(work / 'hero16x9.png')])
    hero = Image.open(work / 'hero16x9.png').convert('RGB')
    compose(work, segments, notes, settings, ramps, index, hero)


def compose(work, segments, notes, settings, ramps, index, hero):
    serif_big, serif, serif_small = font('serif', 150), font('title', 60), font('title', 40)
    light, light_small, regular, medium = font('light', 30), font('light', 21), font('regular', 24), font('medium', 22)
    screens = {}

    def screen(k):
        if k not in screens:
            screens[k] = Image.open(work / 'screens' / ('screen-%d.png' % k)).convert('RGB')
        return screens[k]

    hero_dim = Image.blend(hero, Image.new('RGB', hero.size, (0, 0, 0)), 0.45)
    out = work / 'fujara-demo.mp4'
    ffmpeg = subprocess.Popen(['ffmpeg', '-y', '-loglevel', 'error', '-f', 'rawvideo', '-pix_fmt', 'rgb24',
                               '-s', '%dx%d' % (W, H), '-r', str(FPS), '-i', '-', '-i', str(work / 'audio.wav'),
                               '-c:v', 'libx264', '-preset', 'veryfast', '-crf', '20', '-pix_fmt', 'yuv420p',
                               '-c:a', 'aac', '-b:a', '192k', '-movflags', '+faststart', '-shortest', str(out)],
                              stdin=subprocess.PIPE)
    SX, SY = 360, 196  # the screen's place: 480 x 220 at 2.5x
    poster = None
    for n, k in enumerate(index):
        t = n / FPS
        kind, start, which = segment_at(t, segments)
        local = t - start
        frame = Image.new('RGB', (W, H), (0, 0, 0))
        d = ImageDraw.Draw(frame)
        if kind == 'open' and local < 8.0:
            # Hero and title; the title fades in, the whole fades to the interface.
            frame.paste(hero_dim)
            d = ImageDraw.Draw(frame)
            a = max(0.0, min(1.0, (local - 0.8) / 1.2))
            grey = lambda v: (int(v * a),) * 3
            spaced(d, (120, 300), 'FUJARA', serif_big, grey(245), 18)
            d.text((126, 470), 'An original Fujara-inspired overtone-flute machine', font=light, fill=grey(215))
            d.text((126, 512), 'for Open-XY / OP-XY', font=light, fill=grey(215))
            d.text((126, 600), 'An independent community project.', font=light_small, fill=grey(170))
            d.text((126, 632), 'Not an official Teenage Engineering product; not affiliated with or endorsed by them.',
                   font=light_small, fill=grey(170))
            if local > 7.0:
                frame = Image.blend(frame, layout_frame(screen(k), t, kind, local, which, settings, ramps, serif, serif_small,
                                                        light, light_small, regular, medium, SX, SY), local - 7.0)
            if 4.9 < t < 5.1 and poster is None:
                poster = frame.copy()
        else:
            frame = layout_frame(screen(k), t, kind, local, which, settings, ramps, serif, serif_small, light,
                                 light_small, regular, medium, SX, SY)
        ffmpeg.stdin.write(frame.tobytes())
        if n % 600 == 0:
            print('  frame %d / %d' % (n, len(index)), flush=True)
    ffmpeg.stdin.close()
    if ffmpeg.wait():
        raise SystemExit('ffmpeg failed')
    shutil.copy(out, ROOT / 'assets' / 'fujara-demo.mp4')
    poster.save(ROOT / 'assets' / 'fujara-demo-poster.png', optimize=True)
    run(['ffprobe', '-v', 'error', '-show_entries', 'format=duration,size:stream=codec_name,width,height,r_frame_rate,sample_rate,channels',
         '-of', 'compact', str(ROOT / 'assets' / 'fujara-demo.mp4')])


def layout_frame(scr, t, kind, local, which, settings, ramps, serif, serif_small, light, light_small, regular, medium, SX, SY):
    frame = Image.new('RGB', (W, H), (0, 0, 0))
    d = ImageDraw.Draw(frame)
    # Masthead.
    spaced(d, (96, 64), 'FUJARA', serif_small, (235, 235, 235), 8)
    d.text((330, 80), 'Open-XY / OP-XY machine  ·  independent community project', font=light_small, fill=(120, 120, 120))
    big = scr.resize((1200, 550), Image.LANCZOS) if scr.size != (1200, 550) else scr
    if kind == 'close':
        big = scr.resize((960, 440), Image.LANCZOS)
        frame.paste(big, (480, 150))
        d.rectangle((479, 149, 1440, 590), outline=(46, 46, 46))
    else:
        frame.paste(big, (SX, SY))
        d.rectangle((SX - 1, SY - 1, SX + 1200, SY + 550), outline=(46, 46, 46))
        d.text((SX, SY + 562), "The engine's own screen: display.cpp in the Open-XY browser preview (480 x 220)",
               font=light_small, fill=(105, 105, 105))
    values = controls_at(t, settings, ramps)
    fade = lambda: max(0.0, min(1.0, local / 0.5))
    if kind in ('open', 'tour'):
        if kind == 'open':
            title, text = 'The instrument', 'A breath-blown jet sounding a resonant wooden bore.'
            active = -1
        else:
            active = min(3, int(max(0.0, local - 0.6) // 4.8))
            title, text = CONTROL_TEXT[active]
        a = fade() if kind == 'tour' and local < 0.5 else 1.0
        d.text((SX, 818), title, font=serif, fill=(int(240 * a),) * 3)
        wrap(d, (SX, 902), text, light, (int(190 * a),) * 3, 820)
        draw_controls(d, values, active, regular, medium)
    elif kind == 'preset':
        name = PRESETS[which][0]
        a = fade()
        d.text((SX, 818), '%02d' % (which + 1), font=serif, fill=(int(110 * a),) * 3)
        d.text((SX + 100, 818), name, font=serif, fill=(int(240 * a),) * 3)
        wrap(d, (SX, 902), DESCRIPTIONS[name], light, (int(190 * a),) * 3, 820)
        draw_controls(d, values, -1, regular, medium)
    else:  # close
        d.text((480, 618), 'github.com/SammiBabe666/Fujara-Flute-for-XY', font=light, fill=(235, 235, 235))
        for i, (name, _) in enumerate(PRESETS):
            x, y = 480 + (i % 3) * 330, 690 + (i // 3) * 46
            d.text((x, y), '%02d  %s' % (i + 1, name), font=regular, fill=(200, 200, 200))
        d.text((480, 830), STATUS, font=light_small, fill=(150, 150, 150))
        d.text((480, 864), 'MIT licence  ·  built on the Open-XY SDK  ·  not affiliated with Teenage Engineering',
               font=light_small, fill=(120, 120, 120))
    d.text((96, 1022), "Sound: Fujara's own engine.cpp, rendered offline from the same C++ the device compiles, "
                       'through a simple amp envelope. No effects, no samples.', font=light_small, fill=(88, 88, 88))
    return frame


def wrap(d, xy, text, fnt, fill, width):
    x, y = xy
    line = ''
    for word in text.split():
        trial = (line + ' ' + word).strip()
        if d.textlength(trial, font=fnt) > width and line:
            d.text((x, y), line, font=fnt, fill=fill)
            y += 40
            line = word
        else:
            line = trial
    d.text((x, y), line, font=fnt, fill=fill)


def draw_controls(d, values, active, regular, medium):
    x0 = 1250
    for i, (label, value) in enumerate(zip(['Breath', 'Body', 'Overtones', 'Air'], values)):
        y = 832 + i * 34
        on = active < 0 or active == i
        colour = (225, 225, 225) if on else (95, 95, 95)
        d.text((x0, y), label, font=medium if active == i else regular, fill=colour)
        d.rectangle((x0 + 150, y + 12, x0 + 150 + 160, y + 15), fill=(40, 40, 40))
        d.rectangle((x0 + 150, y + 10, x0 + 150 + int(160 * value), y + 17), fill=colour)
        d.text((x0 + 330, y), '%d' % round(value * 100), font=regular, fill=colour)


if __name__ == '__main__':
    main()
