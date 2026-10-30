"""Writes panel.svg.fragment: the Fujara screen artwork. Run from the repository root:
    python generators/panel.py .

A monochrome engraving of a fujara lying across the 480 x 220 screen, below the
stock header (y < 40 is left to it). Static elements are drawn once by the
device; display.cpp only moves, reshapes and repaints the bound nodes:

  node 0      the breath wisp rising from the window (a 64-point outline)
  nodes 1..8  the overtone ladder: one dot per partial, fundamental first
  node 9      the window's glow while a note is held
  palette     sixteen greys, black to white

Only path and circle elements with explicit paint are used: the subset both
the browser preview and the device accept. Every number has at most two
decimals and no exponent (docs/api.md#platform-rules).
"""
import math, os, sys

root = sys.argv[1] if len(sys.argv) > 1 else '.'
P = 'fujara'
out = []


def n(v):
    s = ('%.2f' % v).rstrip('0').rstrip('.')
    return '0' if s in ('-0', '') else s


def path(d, fill='none', stroke='#ffffff', width=1, extra=''):
    out.append('  <path d="%s" fill="%s" stroke="%s" stroke-width="%s"%s/>' % (d, fill, stroke, n(width), extra))


def poly(points, fill, stroke, width=0.6):
    path('M' + ' L'.join('%s %s' % (n(x), n(y)) for x, y in points) + ' Z', fill, stroke, width)


def line(x1, y1, x2, y2, stroke, width=0.6):
    path('M%s %s L%s %s' % (n(x1), n(y1), n(x2), n(y2)), 'none', stroke, width)


def ellipse(cx, cy, rx, ry, fill, stroke, width=0.6):
    # Twelve-sided: the drawing subset has no ellipse element and no arcs.
    poly([(cx + rx * math.cos(k * math.pi / 6), cy + ry * math.sin(k * math.pi / 6)) for k in range(12)],
         fill, stroke, width)


WOOD, GRAIN, INK, SHADOW, LIGHT, BG = '#c8c8c8', '#8a8a8a', '#1a1a1a', '#5c5c5c', '#f2f2f2', '#000000'

# Geometry. The bore lies from the head (left) to the foot (right), slightly
# widening; the air duct runs above its upper third, from the mouthpiece to
# the window, where it bends down into the bore.
HEAD, FOOT, Y = 58, 466, 128          # bore ends and centre line
R_HEAD, R_FOOT = 7.5, 8.6              # bore half-width at each end
DUCT_Y, DUCT_R = 98, 3.6              # air duct centre and half-width
MOUTH, WINDOW = 36, 214                # mouthpiece tip and window x


def r_at(x):
    return R_HEAD + (R_FOOT - R_HEAD) * (x - HEAD) / (FOOT - HEAD)


out.append('<g id="%s_panel">' % P)

# A faint ground line: the instrument rests in darkness.
line(20, 176, 460, 176, '#262626', 0.6)

# The bore: an outline of the turned wood, a light edge above and engraved
# hatching on the shaded lower half (woodcut shading).
top = [(x, Y - r_at(x)) for x in range(HEAD, FOOT + 1, 8)] + [(FOOT, Y - r_at(FOOT))]
bottom = [(x, Y + r_at(x)) for x, _ in reversed(top)]
poly(top + bottom, WOOD, INK, 0.8)
for x in range(HEAD + 3, FOOT - 2, 3):
    r = r_at(x)
    line(x, Y + r * 0.15, x - 1.6, Y + r * 0.95, SHADOW, 0.5)
line(HEAD + 2, Y - R_HEAD + 1.6, FOOT - 2, Y - R_FOOT + 1.6, LIGHT, 0.8)
# Wood grain: long faint lines along the bore.
for k, offset in enumerate((-0.45, -0.1)):
    pts = []
    for x in range(HEAD + 6, FOOT - 4, 6):
        pts.append('%s %s' % (n(x), n(Y + offset * r_at(x) + 0.5 * math.sin(x / 23.0 + k))))
    path('M' + ' L'.join(pts), 'none', GRAIN, 0.4)

# Carved ornament: two bands of diamonds and zigzags burnt into the wood,
# the fujara's traditional decoration, kept between the bindings and holes.
def ornament(x0, x1):
    step = 9
    for x in range(int(x0), int(x1) - step + 1, step):
        r = r_at(x) * 0.78
        poly([(x, Y), (x + step / 2, Y - r), (x + step, Y), (x + step / 2, Y + r)], 'none', INK, 0.55)
        ellipse(x + step / 2, Y, 0.9, 0.9, INK, INK, 0.3)
    line(x0, Y - r_at(x0) * 0.9, x1, Y - r_at(x1) * 0.9, INK, 0.5)
    line(x0, Y + r_at(x0) * 0.9, x1, Y + r_at(x1) * 0.9, INK, 0.5)

ornament(232, 322)
ornament(96, 186)
# Zigzag rings between the ornament bands.
for x0 in (226, 328, 90, 192):
    pts = ['%s %s' % (n(x0 + (i % 2) * 2.2), n(Y - r_at(x0) + i * 2 * r_at(x0) / 8)) for i in range(9)]
    path('M' + ' L'.join(pts), 'none', INK, 0.55)

# Head cap and foot ring.
poly([(HEAD - 4, Y - R_HEAD - 1), (HEAD + 2, Y - R_HEAD - 1), (HEAD + 2, Y + R_HEAD + 1),
      (HEAD - 4, Y + R_HEAD + 1)], '#a8a8a8', INK, 0.8)
poly([(FOOT - 6, Y - R_FOOT - 1.2), (FOOT + 1, Y - R_FOOT - 1.6), (FOOT + 1, Y + R_FOOT + 1.6),
      (FOOT - 6, Y + R_FOOT + 1.2)], '#a8a8a8', INK, 0.8)
ellipse(FOOT + 1, Y, 1.6, R_FOOT + 1.2, '#2a2a2a', INK, 0.6)

# The three finger holes near the foot, burnt-edged.
for x in (356, 386, 416):
    ellipse(x, Y - 1, 3.3, 2.4, '#3a3a3a', INK, 0.6)
    ellipse(x, Y - 1.4, 1.9, 1.2, '#000000', '#000000', 0.4)

# The window (labium): a cut through the top of the bore under the duct's end.
poly([(WINDOW - 4, Y - r_at(WINDOW) - 0.2), (WINDOW + 5, Y - r_at(WINDOW) - 0.2),
      (WINDOW + 3, Y - 1), (WINDOW - 4, Y - 1)], '#101010', INK, 0.6)
line(WINDOW + 5, Y - r_at(WINDOW), WINDOW + 3, Y - 1, LIGHT, 0.6)

# The air duct: mouthpiece, straight run, and the bend down into the window.
bend = WINDOW - 14
duct_top = [(MOUTH + 6, DUCT_Y - DUCT_R), (bend, DUCT_Y - DUCT_R),
            (bend + 8, DUCT_Y - DUCT_R + 2), (WINDOW + 2, Y - r_at(WINDOW) - 1.5)]
duct_bottom = [(WINDOW - 5, Y - r_at(WINDOW) - 1.5), (bend + 4, DUCT_Y + DUCT_R + 2),
               (bend - 2, DUCT_Y + DUCT_R), (MOUTH + 6, DUCT_Y + DUCT_R)]
poly(duct_top + duct_bottom, WOOD, INK, 0.8)
for x in range(MOUTH + 8, bend, 3):
    line(x, DUCT_Y + 0.4, x - 1.0, DUCT_Y + DUCT_R - 0.3, SHADOW, 0.45)
line(MOUTH + 7, DUCT_Y - DUCT_R + 1.1, bend, DUCT_Y - DUCT_R + 1.1, LIGHT, 0.6)
# Mouthpiece: a short flared cup.
poly([(MOUTH, DUCT_Y - 5), (MOUTH + 7, DUCT_Y - DUCT_R - 0.6), (MOUTH + 7, DUCT_Y + DUCT_R + 0.6),
      (MOUTH, DUCT_Y + 5)], '#a8a8a8', INK, 0.8)
ellipse(MOUTH, DUCT_Y, 1.4, 5, '#1a1a1a', INK, 0.6)

# Leather bindings tying the duct to the bore: wraps with a stitched edge.
for x in (82, 150):
    poly([(x - 4, DUCT_Y - DUCT_R - 1.4), (x + 4, DUCT_Y - DUCT_R - 1.4), (x + 4, Y + r_at(x) + 1.4),
          (x - 4, Y + r_at(x) + 1.4)], '#3c3c3c', INK, 0.7)
    for y in range(int(DUCT_Y - 2), int(Y + r_at(x)), 3):
        line(x - 3, y, x + 3, y + 1.4, '#7a7a7a', 0.45)
    line(x - 4, DUCT_Y + DUCT_R + 1, x - 4, Y - r_at(x) - 1, '#7a7a7a', 0.5)
    line(x + 4, DUCT_Y + DUCT_R + 1, x + 4, Y - r_at(x) - 1, '#7a7a7a', 0.5)

# A tassel hanging from the foot binding, a common folk adornment.
line(FOOT - 3, Y + R_FOOT + 1.4, FOOT - 6, Y + 26, '#9a9a9a', 0.6)
for dx in (-2, -0.5, 1):
    line(FOOT - 6, Y + 26, FOOT - 6 + dx, Y + 36, '#9a9a9a', 0.5)

# The overtone ladder's rail: eight places under the bore, fundamental at left.
LADDER_X, LADDER_STEP, LADDER_Y = 165, 22, 196
line(LADDER_X - 8, LADDER_Y, LADDER_X + 7 * LADDER_STEP + 8, LADDER_Y, '#303030', 0.6)
for h in range(8):
    line(LADDER_X + h * LADDER_STEP, LADDER_Y - 2.5, LADDER_X + h * LADDER_STEP, LADDER_Y + 2.5, '#303030', 0.6)

# Bound node 0: the breath wisp (an outline display.cpp reshapes), at the window.
pts = []
for i in range(32):
    pts.append((-1.5 + 0.02 * i, -i * 1.6))
for i in range(32):
    pts.append((1.5 + 0.02 * (31 - i), -(31 - i) * 1.6 - 0.5))
d = 'M' + ' L'.join('%s %s' % (n(x), n(y)) for x, y in pts) + ' Z'
out.append('  <path id="%s_node_0" d="%s" fill="none" stroke="#bdbdbd" stroke-width="0.8" '
           'transform="matrix(1 0 0 1 %s %s)"/>' % (P, d, n(WINDOW), n(Y - 9)))
# Bound nodes 1..8: the overtone dots; 9: the window glow.
for h in range(8):
    out.append('  <circle id="%s_node_%d" cx="0" cy="0" r="3.5" fill="#808080" stroke="#808080" '
               'stroke-width="0.6" transform="matrix(1 0 0 1 %s %s)"/>' % (P, h + 1, n(LADDER_X + h * LADDER_STEP), LADDER_Y))
out.append('  <circle id="%s_node_9" cx="0" cy="0" r="2.6" fill="#303030" stroke="#303030" stroke-width="0.6" '
           'transform="matrix(1 0 0 1 %s %s)"/>' % (P, n(WINDOW + 0.5), n(Y - 4)))
# Palette: sixteen greys, parked off screen.
for i in range(16):
    v = round(i * 255 / 15)
    c = '#%02x%02x%02x' % (v, v, v)
    out.append('  <circle id="%s_palette_%d" cx="640" cy="0" r="1" fill="%s" stroke="%s" stroke-width="1"/>' % (P, i, c, c))
out.append('</g>')

with open(os.path.join(root, 'panel.svg.fragment'), 'w') as f:
    f.write('\n'.join(out) + '\n')
