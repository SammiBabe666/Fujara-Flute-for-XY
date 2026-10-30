"""Release checks that are not C++: run from the repository root.

    python tests/check_release.py [--media]

- definition.json: the four controls in order, exactly six presets in the
  documented order, Mountain Breath first and equal to the control defaults.
- tests/check.h carries the same preset values as definition.json.
- presets/: regenerating them from definition.json reproduces the committed
  files byte for byte; each is a valid OP-XY version 4 preset of `fujara` with
  params in range, Mountain Breath is default.json, and nothing else is there.
- panel.svg.fragment: regenerating it reproduces the committed file.
- README.md: every relative link and image points at a file that exists.
- --media: every documented asset exists with the documented size and format,
  and the MP4 holds H.264 video and AAC audio of 2 to 4 minutes (ffprobe).
Uses require(), never assert, like the SDK's checks.
"""
import json, os, re, shutil, subprocess, sys, tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
ORDER = ['breath', 'body', 'overtones', 'air']
PRESETS = ['Mountain Breath', 'Overtone Wraith', 'Mourning Wood', 'High Pasture', 'Storm Calling', 'The Hollow Saint']
ASSETS = {'fujara-hero.png': (2560, 1280), 'fujara-hero.jpg': (1280, 640), 'fujara-device.png': (480, 220),
          'fujara-thumbnail.png': (1920, 1080), 'fujara-demo-poster.png': (1920, 1080)}


def require(ok, message):
    if not ok:
        print('FAIL ' + message)
        sys.exit(1)


def regenerate(script, outputs):
    with tempfile.TemporaryDirectory() as scratch:
        copy = Path(scratch) / 'machine'
        shutil.copytree(ROOT, copy, ignore=shutil.ignore_patterns('.git', 'assets', 'presets', '*.fragment'))
        subprocess.run([sys.executable, str(ROOT / 'generators' / script), str(copy)], check=True)
        for name in outputs:
            require((copy / name).read_bytes() == (ROOT / name).read_bytes(), name + ' is not what generators/' + script + ' writes')


def main():
    d = json.loads((ROOT / 'definition.json').read_text())
    require([p['id'] for p in d['parameters']] == ORDER, 'controls are breath, body, overtones, air in that order')
    require(list(d['presets']) == PRESETS, 'exactly the six documented presets, in order')
    defaults = {p['id']: p['default'] for p in d['parameters']}
    require(d['presets']['Mountain Breath'] == defaults, 'Mountain Breath equals the control defaults')
    for name, values in d['presets'].items():
        require(set(values) == set(ORDER) and all(0 <= v <= 1 for v in values.values()), 'preset values in 0..1: ' + name)
    header = (ROOT / 'tests' / 'check.h').read_text()
    for name, values in d['presets'].items():
        found = re.search(r'\{"%s", \{([^}]*)\}\}' % re.escape(name), header)
        require(found is not None, 'tests/check.h lists ' + name)
        require([float(v) for v in found.group(1).split(',')] == [values[k] for k in ORDER],
                'tests/check.h and definition.json agree on ' + name)
    files = sorted(p.name for p in (ROOT / 'presets').iterdir() if not p.name.startswith('.'))
    expected = sorted(['default.json'] + [n.lower().replace(' ', '-') + '.json' for n in PRESETS[1:]])
    require(files == expected, 'presets/ holds exactly the six preset files')
    for name in PRESETS:
        f = 'default.json' if name == 'Mountain Breath' else name.lower().replace(' ', '-') + '.json'
        p = json.loads((ROOT / 'presets' / f).read_text())
        params = p['engine']['params']
        require(p['version'] == 4 and p['platform'] == 'OP-XY' and p['type'] == 'fujara' and p['regions'] == [] and
                len(params) == 8 and all(type(v) is int and 0 <= v <= 32767 for v in params),
                'presets/%s is a version 4 OP-XY preset of fujara' % f)
        require(params == [round(d['presets'][name][k] * 32767) for k in ORDER] + [0] * 4, 'presets/%s params' % f)
        require((ROOT / 'presets' / f).stat().st_size <= 16384, 'presets/%s within 16 KiB' % f)
    regenerate('presets.py', ['presets/' + f for f in files])
    regenerate('panel.py', ['panel.svg.fragment'])
    readme = (ROOT / 'README.md').read_text()
    for target in re.findall(r'\]\(([^)#\s]+)(?:#[^)]*)?\)', readme):
        if '://' not in target:
            require((ROOT / target).exists(), 'README links a missing file: ' + target)
    if '--media' in sys.argv:
        from PIL import Image
        for name, size in ASSETS.items():
            path = ROOT / 'assets' / name
            require(path.exists(), 'missing asset ' + name)
            with Image.open(path) as im:
                require(im.size == size, '%s is %dx%d' % ((name,) + size))
            require(path.stat().st_size < 1024 * 1024, name + ' under 1 MiB')
        mp4 = ROOT / 'assets' / 'fujara-demo.mp4'
        require(mp4.exists() and mp4.stat().st_size < 25 * 1024 * 1024, 'fujara-demo.mp4 exists, under 25 MiB')
        probe = json.loads(subprocess.run(['ffprobe', '-v', 'error', '-show_entries',
                                           'format=duration:stream=codec_name,codec_type,width,height', '-of', 'json',
                                           str(mp4)], check=True, capture_output=True, text=True).stdout)
        streams = {s['codec_type']: s for s in probe['streams']}
        require(streams.get('video', {}).get('codec_name') == 'h264' and streams['video']['width'] == 1920 and
                streams['video']['height'] == 1080, 'MP4 video is H.264 1920x1080')
        require(streams.get('audio', {}).get('codec_name') == 'aac', 'MP4 audio is AAC')
        require(120 <= float(probe['format']['duration']) <= 240, 'MP4 lasts 2 to 4 minutes')
    print('release checks: definition, presets, generators, README links%s pass' % (', media' if '--media' in sys.argv else ''))


if __name__ == '__main__':
    main()
