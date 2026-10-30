"""Writes the hero artwork's SVG: an original monochrome engraving of a fujara
standing against hatched night mountains under a hatched moon.

    python production/hero.py <out.svg> [width height]

Everything is drawn from code (deterministic, seeded): no photographs, no
traced images, no text, no logos. production/make_assets.py renders it to PNG
with Chromium and derives the JPEG, thumbnail and poster.
"""
import math, random, sys

out = sys.argv[1]
W = int(sys.argv[2]) if len(sys.argv) > 2 else 2560
H = int(sys.argv[3]) if len(sys.argv) > 3 else 1280
S = H / 1280.0  # all geometry is authored for a 1280-high canvas
rng = random.Random(1987)
parts = []


def f(v):
    return ('%.2f' % v).rstrip('0').rstrip('.')


def line(x1, y1, x2, y2, stroke, width, opacity=1.0):
    parts.append('<line x1="%s" y1="%s" x2="%s" y2="%s" stroke="%s" stroke-width="%s" stroke-opacity="%s" '
                 'stroke-linecap="round"/>' % (f(x1), f(y1), f(x2), f(y2), stroke, f(width), f(opacity)))


def path(d, fill='none', stroke='none', width=1, extra=''):
    parts.append('<path d="%s" fill="%s" stroke="%s" stroke-width="%s"%s/>' % (d, fill, stroke, f(width), extra))


def poly(points):
    return 'M' + ' L'.join('%s %s' % (f(x), f(y)) for x, y in points) + ' Z'


cx = W * 0.5  # the canvas centre; the composition is laid out around it
# ---------------------------------------------------------------- the sky
parts.append('<rect width="%d" height="%d" fill="#050505"/>' % (W, H))
# Sparse engraved sky lines, denser toward the top.
for y in range(0, int(560 * S), int(7 * S) or 1):
    density = 1 - y / (560 * S)
    x = -50.0
    while x < W:
        length = rng.uniform(30, 260) * S
        if rng.random() < 0.18 + 0.32 * density:
            line(x, y, x + length, y, '#bdbdbd', 0.7 * S, 0.10 + 0.12 * density)
        x += length + rng.uniform(10, 120) * S
# ---------------------------------------------------------------- the moon
mx, my, mr = cx + 120 * S, 430 * S, 255 * S
parts.append('<defs><clipPath id="moon"><circle cx="%s" cy="%s" r="%s"/></clipPath></defs>' % (f(mx), f(my), f(mr)))
parts.append('<circle cx="%s" cy="%s" r="%s" fill="#0b0b0b" stroke="#d8d8d8" stroke-width="%s"/>' % (f(mx), f(my), f(mr), f(1.6 * S)))
parts.append('<g clip-path="url(#moon)">')
step = 4.2 * S
y = my - mr
while y < my + mr:
    # Horizontal engraving lines, thicker on the lit (upper-left) side.
    half = math.sqrt(max(mr * mr - (y - my) ** 2, 0))
    light = 0.5 + 0.5 * ((my - y) / mr)
    # Long strokes with a few random breaks; heavier toward the lit left.
    x0 = mx - half
    while x0 < mx + half:
        x1 = min(x0 + rng.uniform(0.25, 1.1) * mr, mx + half)
        lit = 0.55 + 0.45 * (1 - ((x0 + x1) / 2 - (mx - half)) / (2 * half + 1e-6))
        w = (0.6 + 1.9 * light * lit) * S
        line(x0, y, x1, y, '#e6e6e6', w, 0.85)
        x0 = x1 + rng.uniform(2, 9) * S
    y += step
# Craters: small rings of darker hatching.
for _ in range(9):
    a, d = rng.uniform(0, 2 * math.pi), rng.uniform(0.1, 0.75) * mr
    r = rng.uniform(14, 34) * S
    parts.append('<circle cx="%s" cy="%s" r="%s" fill="none" stroke="#6a6a6a" stroke-opacity="0.6" stroke-width="%s"/>'
                 % (f(mx + d * math.cos(a)), f(my + d * math.sin(a)), f(r), f(1.0 * S)))
parts.append('</g>')
# ---------------------------------------------------------------- the mountains
def ridge(base, amplitude, seed, rough):
    r = random.Random(seed)
    pts, x = [], -20 * S
    phase = [r.uniform(0, 6.28) for _ in range(4)]
    while x <= W + 20 * S:
        y = base - amplitude * (0.55 * math.sin(x / (W * 0.21) + phase[0]) + 0.3 * math.sin(x / (W * 0.083) + phase[1])
                                + 0.15 * math.sin(x / (W * 0.031) + phase[2])) - r.uniform(0, rough) * S
        pts.append((x, y))
        x += r.uniform(14, 34) * S
    return pts


layers = [(700 * S, 150 * S, 11, 26, '#2a2a2a', 9.0, 0.9), (820 * S, 120 * S, 23, 18, '#1d1d1d', 7.0, 1.2),
          (960 * S, 90 * S, 37, 12, '#121212', 5.5, 1.5), (1120 * S, 60 * S, 41, 8, '#090909', 4.2, 1.8)]
for base, amp, seed, rough, fill, spacing, weight in layers:
    pts = ridge(base, amp, seed, rough)
    path(poly(pts + [(W + 20 * S, H + 10), (-20 * S, H + 10)]), fill, '#cfcfcf', 1.1 * S)
    # Woodcut hatching: horizontal lines under the ridge, fading downward.
    ys = [p[1] for p in pts]
    top = min(ys)
    y = top + 3 * S
    while y < H:
        run_start = None
        for i in range(len(pts) - 1):
            (x1, y1), (x2, y2) = pts[i], pts[i + 1]
            below = y > max(y1, y2) + 2 * S
            if below and run_start is None:
                run_start = x1
            if (not below or i == len(pts) - 2) and run_start is not None:
                depth = (y - top) / (H - top)
                if rng.random() < 0.82:
                    line(run_start + rng.uniform(2, 12) * S, y, x1 - rng.uniform(2, 12) * S, y, '#d0d0d0',
                         weight * S * (0.35 + 0.65 * (1 - depth)) * 0.6, 0.55 * (1 - depth) + 0.08)
                run_start = None
        y += spacing * S * (1 + 1.4 * (y - top) / H)
# Mist: a few long soft strokes across the valleys.
for k in range(14):
    y = rng.uniform(760, 1060) * S
    x = rng.uniform(-100, W * 0.8)
    line(x, y, x + rng.uniform(300, 900) * S, y + rng.uniform(-4, 4) * S, '#ffffff', rng.uniform(1, 3) * S, 0.05)
# ---------------------------------------------------------------- the fujara
# Standing, leaning slightly; local coordinates: u along the bore from the
# head (0) to the foot (L), v across it.
L = 1040 * S
fx, fy = cx + 250 * S, 150 * S         # the head
tilt = math.radians(-6.5)
ux, uy = math.sin(-tilt), math.cos(tilt)  # along the bore, downward
vx, vy = uy, -ux                           # across it, to the right


def at(u, v):
    return fx + ux * u + vx * v, fy + uy * u + vy * v


def radius(u):
    return (27 + 6 * u / L) * S


WOOD, INK = '#cfcfcf', '#050505'
# Shadow cast on the ground.
gx, gy = at(L, 0)
parts.append('<ellipse cx="%s" cy="%s" rx="%s" ry="%s" fill="#000000" fill-opacity="0.7"/>' % (f(gx + 40 * S), f(min(gy + 8 * S, H - 6)), f(120 * S), f(10 * S)))
# The bore's silhouette.
outline = [at(u, -radius(u)) for u in [i * L / 60 for i in range(61)]] + \
          [at(u, radius(u)) for u in [i * L / 60 for i in range(60, -1, -1)]]
path(poly(outline), '#9c9c9c', '#f0f0f0', 1.6 * S)
# Cylindrical engraving: lines across the bore, sparse on the lit left,
# dense and heavy on the shaded right.
u = 4 * S
while u < L - 4 * S:
    r = radius(u)
    for k in range(10):
        v0 = -r + k * 2 * r / 10
        v1 = v0 + 2 * r / 10
        shade = (k + 0.5) / 10  # 0 lit, 1 shaded
        if rng.random() < 0.15 + 0.85 * shade:
            x1, y1 = at(u, v0)
            x2, y2 = at(u + 1.2 * S, v1)
            line(x1, y1, x2, y2, INK, (0.4 + 2.2 * shade * shade) * S, 0.85)
    u += 3.4 * S
# Highlight down the lit edge.
p1, p2 = at(8 * S, -radius(0) * 0.62), at(L - 10 * S, -radius(L) * 0.62)
line(p1[0], p1[1], p2[0], p2[1], '#ffffff', 2.4 * S, 0.8)
# Burnt ornament bands: diamonds, dots and zigzag rings.
def band(u0, u1):
    step = 26 * S
    u = u0
    while u + step <= u1:
        r = radius(u) * 0.86
        d = poly([at(u, 0), at(u + step / 2, -r), at(u + step, 0), at(u + step / 2, r)])
        path(d, 'none', INK, 2.0 * S)
        c = at(u + step / 2, 0)
        parts.append('<circle cx="%s" cy="%s" r="%s" fill="%s"/>' % (f(c[0]), f(c[1]), f(2.6 * S), INK))
        u += step
    for edge in (u0 - 6 * S, u1 + 6 * S):
        pts = [at(edge + (i % 2) * 6 * S, -radius(edge) + i * 2 * radius(edge) / 8) for i in range(9)]
        path('M' + ' L'.join('%s %s' % (f(x), f(y)) for x, y in pts), 'none', INK, 2.0 * S)
    for side in (-0.93, 0.93):
        a, b = at(u0, side * radius(u0)), at(u1, side * radius(u1))
        line(a[0], a[1], b[0], b[1], INK, 1.6 * S)


band(130 * S, 300 * S)
band(470 * S, 700 * S)
# Head cap and foot ring.
for u0, u1, grow in ((0, 22 * S, 3 * S), (L - 26 * S, L, 5 * S)):
    path(poly([at(u0, -radius(u0) - grow), at(u1, -radius(u1) - grow), at(u1, radius(u1) + grow), at(u0, radius(u0) + grow)]),
         '#6e6e6e', '#f0f0f0', 1.4 * S)
# Three finger holes near the foot.
for u0 in (800 * S, 870 * S, 940 * S):
    c = at(u0, -2 * S)
    parts.append('<ellipse cx="%s" cy="%s" rx="%s" ry="%s" fill="#000000" stroke="#e0e0e0" stroke-width="%s" transform="rotate(%s %s %s)"/>'
                 % (f(c[0]), f(c[1]), f(9 * S), f(7 * S), f(1.4 * S), f(math.degrees(tilt)), f(c[0]), f(c[1])))
# The window (labium) at u = 420, on the duct's side (left).
wu = 390 * S
path(poly([at(wu - 14 * S, -radius(wu) - 0.5 * S), at(wu + 16 * S, -radius(wu) - 0.5 * S), at(wu + 12 * S, -2 * S), at(wu - 14 * S, -2 * S)]),
     '#000000', '#f0f0f0', 1.4 * S)
# The air duct, on the left, from the mouthpiece above the head down to the window.
duct_v, duct_r = -radius(0) - 26 * S, 12 * S
top_u = -80 * S
duct = [at(top_u, duct_v - duct_r), at(wu - 46 * S, duct_v - duct_r), at(wu - 6 * S, -radius(wu) - 2 * S),
        at(wu + 6 * S, -radius(wu) - 2 * S), at(wu - 40 * S, duct_v + duct_r), at(top_u, duct_v + duct_r)]
path(poly(duct), '#a8a8a8', '#f0f0f0', 1.4 * S)
u = top_u + 4 * S
while u < wu - 48 * S:
    for k in range(4):
        v0 = duct_v - duct_r + k * duct_r / 2
        if rng.random() < 0.3 + 0.2 * k:
            a, b = at(u, v0), at(u + 1 * S, v0 + duct_r / 2)
            line(a[0], a[1], b[0], b[1], INK, (0.5 + 0.6 * k) * S, 0.8)
    u += 3.6 * S
# Mouthpiece: a flared cup at the duct's top.
path(poly([at(top_u - 30 * S, duct_v - duct_r - 6 * S), at(top_u, duct_v - duct_r), at(top_u, duct_v + duct_r),
           at(top_u - 30 * S, duct_v + duct_r + 6 * S)]), '#7a7a7a', '#f0f0f0', 1.4 * S)
# Leather bindings around duct and bore.
for u0 in (30 * S, 210 * S):
    left, right = duct_v - duct_r - 4 * S, radius(u0) + 4 * S
    path(poly([at(u0 - 12 * S, left), at(u0 + 12 * S, left), at(u0 + 12 * S, right), at(u0 - 12 * S, right)]),
         '#2c2c2c', '#e8e8e8', 1.4 * S)
    v = left + 4 * S
    while v < right - 2 * S:
        a, b = at(u0 - 10 * S, v), at(u0 + 10 * S, v + 4 * S)
        line(a[0], a[1], b[0], b[1], '#9a9a9a', 1.2 * S)
        v += 7 * S
# A tassel hanging from the lower binding.
anchor = at(216 * S, radius(216 * S) + 4 * S)
knot = (anchor[0] + 26 * S, anchor[1] + 70 * S)
path('M%s %s Q%s %s %s %s' % (f(anchor[0]), f(anchor[1]), f(anchor[0] + 30 * S), f(anchor[1] + 20 * S), f(knot[0]), f(knot[1])),
     'none', '#bdbdbd', 1.6 * S)
for k in range(9):
    line(knot[0], knot[1], knot[0] + (k - 4) * 3.2 * S, knot[1] + rng.uniform(70, 96) * S, '#bdbdbd', 1.1 * S, 0.9)
parts.append('<circle cx="%s" cy="%s" r="%s" fill="#bdbdbd"/>' % (f(knot[0]), f(knot[1]), f(5 * S)))
# Breath rising from the window: a few thin wavering lines.
w0 = at(wu, -radius(wu) - 4 * S)
for k in range(4):
    pts = []
    for i in range(40):
        t = i / 39
        pts.append((w0[0] - t * 110 * S - k * 10 * S + 12 * S * math.sin(t * 6 + k), w0[1] - t * 210 * S + k * 6 * S))
    path('M' + ' L'.join('%s %s' % (f(x), f(y)) for x, y in pts), 'none', '#ffffff', (1.4 - 0.25 * k) * S,
         ' stroke-opacity="%s" stroke-linecap="round"' % f(0.35 - 0.07 * k))
# ---------------------------------------------------------------- frame
parts.append('<rect x="%s" y="%s" width="%s" height="%s" fill="none" stroke="#3a3a3a" stroke-width="%s"/>'
             % (f(18 * S), f(18 * S), f(W - 36 * S), f(H - 36 * S), f(1.2 * S)))

with open(out, 'w') as fh:
    fh.write('<svg xmlns="http://www.w3.org/2000/svg" width="%d" height="%d" viewBox="0 0 %d %d">\n' % (W, H, W, H))
    fh.write('\n'.join(parts))
    fh.write('\n</svg>\n')
