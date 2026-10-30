"""Writes presets/<name>.json from definition.json's presets. Run from the repository root:
    python generators/presets.py .

Each file is a version 4 OP-XY preset whose type is the machine's ID, with the
four engine params scaled to 0..32767 and the remaining four 0, no sample
regions, and an amp envelope chosen for the preset's character.
Mountain Breath becomes default.json, the machine's init preset. The output is
deterministic: sorted keys, two-space indent, one trailing newline.
"""
import copy, json, os, sys

root = sys.argv[1] if len(sys.argv) > 1 else '.'
# A version 4 OP-XY preset with the fields the device saves; engine params,
# and envelope are filled in below.
TEMPLATE = {
    "engine": {
        "bendrange": 8191, "highpass": 0,
        "modulation": {
            "aftertouch": {"amount": 16384, "target": 0}, "modwheel": {"amount": 16384, "target": 0},
            "pitchbend": {"amount": 16384, "target": 0}, "velocity": {"amount": 16384, "target": 0}},
        "params": [0] * 8, "playmode": "poly", "portamento.amount": 0, "portamento.type": 0,
        "transpose": 0, "tuning.root": 0, "tuning.scale": 0, "velocity.sensitivity": 0,
        "volume": 16384, "width": 0},
    "envelope": {
        "amp": {"attack": 0, "decay": 8192, "release": 6000, "sustain": 32767},
        "filter": {"attack": 0, "decay": 0, "release": 0, "sustain": 32767}},
    "fx": {"active": False, "params": [0, 0, 0, 0, 0, 32767, 0, 0], "type": "svf"},
    "lfo": {"active": False, "params": [0] * 8, "type": "value"},
    "octave": 0, "platform": "OP-XY", "regions": [], "type": "", "version": 4,
}
# Breath takes time to fill a long pipe: soft attacks, long releases where the
# preset should ring. Octave stays 0 as the device saves it; README.md names
# each preset's natural register.
SHAPE = {
    'Mountain Breath':  {'attack': 1800, 'release': 9000},
    'Overtone Wraith':  {'attack': 2600, 'release': 14000},
    'Mourning Wood':    {'attack': 4200, 'release': 12000},
    'High Pasture':     {'attack': 1200, 'release': 7000},
    'Storm Calling':    {'attack': 300,  'release': 8000},
    'The Hollow Saint': {'attack': 3400, 'release': 20000},
}
FILES = {'Mountain Breath': 'default'}


def file_name(name):
    return FILES.get(name, name.lower().replace(' ', '-'))


def main():
    d = json.load(open(os.path.join(root, 'definition.json')))
    ids = [p['id'] for p in d['parameters']]
    if set(d['presets']) != set(SHAPE):
        sys.exit('definition.json presets and SHAPE differ')
    folder = os.path.join(root, 'presets')
    os.makedirs(folder, exist_ok=True)
    for name, values in d['presets'].items():
        p = copy.deepcopy(TEMPLATE)
        p['type'] = d['id']
        p['engine']['params'] = [round(values[i] * 32767) for i in ids] + [0] * (8 - len(ids))
        p['envelope']['amp'] = {'attack': SHAPE[name]['attack'], 'decay': 8192,
                                'release': SHAPE[name]['release'], 'sustain': 32767}
        with open(os.path.join(folder, file_name(name) + '.json'), 'w') as f:
            json.dump(p, f, indent=2, sort_keys=True)
            f.write('\n')


if __name__ == '__main__':
    main()
