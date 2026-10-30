"""Counts the instructions in each innermost loop of a Blackfin assembly file:
hardware loops (LSETUP) and backward conditional jumps. Parallel bundles
(a || b || c) count once. Development aid; not a cycle count."""
import re, sys
lines = [l.rstrip() for l in open(sys.argv[1])]
labels = {l.strip()[:-1]: i for i, l in enumerate(lines) if re.match(r'^\.?\w+:$', l.strip())}

def body(a, b):
    out, k = [], a
    while k <= b:
        t = lines[k].strip()
        if t and not t.endswith(':') and not t.startswith(('.', '//')):
            while t.endswith('||'):
                k += 1; t += ' ' + lines[k].strip()
            out.append(t)
        k += 1
    return out

for i, l in enumerate(lines):
    m = re.search(r'LSETUP \((\S+?), ?(\S+?)\)', l)
    if m:
        s, e = labels[m.group(1)], labels[m.group(2)]
        b = body(s, e + 1)
        print('hw loop %s (line %d): %d instructions' % (m.group(1), s, len(b)))
        if '-v' in sys.argv: print('   ' + '\n   '.join(b))
    m = re.search(r'if !?cc jump (\.L\d+)', l)
    if m and m.group(1) in labels and labels[m.group(1)] < i and i - labels[m.group(1)] < 200:
        b = body(labels[m.group(1)], i)
        print('jump loop %s (line %d): %d instructions' % (m.group(1), labels[m.group(1)], len(b)))
        if '-v' in sys.argv: print('   ' + '\n   '.join(b))
