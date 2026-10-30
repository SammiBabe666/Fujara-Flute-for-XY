"""Renders the still artwork from production/hero.py. Run from the repository root:

    python production/make_assets.py [--work <scratch folder>]

Writes:
  assets/fujara-hero.png        2560 x 1280, the repository and social artwork (no text)
  assets/fujara-hero.jpg        1280 x 640 JPEG for sharing and previews
  assets/fujara-thumbnail.png   1920 x 1080, the video thumbnail: the 16:9 artwork,
                                the title, and the engine's real screen
                                (assets/fujara-device.png, from make_demo.py)
Needs Node 22 with Playwright's Chromium, Pillow and the Inter fonts (OFL).
"""
import argparse, subprocess, sys
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parent.parent


def run(cmd):
    print('$ ' + ' '.join(str(c) for c in cmd), flush=True)
    subprocess.run(cmd, check=True)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--work', default=str(ROOT.parent / 'fujara-assets-work'))
    work = Path(parser.parse_args().work)
    work.mkdir(parents=True, exist_ok=True)
    assets = ROOT / 'assets'
    for name, w, h in (('hero', 2560, 1280), ('hero16x9', 1920, 1080)):
        run([sys.executable, str(ROOT / 'production' / 'hero.py'), str(work / (name + '.svg')), str(w), str(h)])
        run(['node', str(ROOT / 'production' / 'render_svg.mjs'), str(work / (name + '.svg')), str(work / (name + '.png'))])
    hero = Image.open(work / 'hero.png').convert('RGB')
    hero.save(assets / 'fujara-hero.png', optimize=True)
    hero.resize((1280, 640), Image.LANCZOS).save(assets / 'fujara-hero.jpg', quality=86, optimize=True, progressive=True)
    # Thumbnail: the artwork, dimmed a little, with the title and the real screen.
    thumb = Image.open(work / 'hero16x9.png').convert('RGB')
    thumb = Image.blend(thumb, Image.new('RGB', thumb.size, (0, 0, 0)), 0.30)
    d = ImageDraw.Draw(thumb)
    title = ImageFont.truetype('/usr/share/fonts/opentype/inter/InterDisplay-ExtraLight.otf', 160)
    sub = ImageFont.truetype('/usr/share/fonts/opentype/inter/Inter-Light.otf', 46)
    x = 110
    for ch in 'FUJARA':
        d.text((x, 280), ch, font=title, fill=(245, 245, 245))
        x += d.textlength(ch, font=title) + 14
    d.text((118, 480), 'Overtone flute for the OP-XY', font=sub, fill=(220, 220, 220))
    d.text((118, 540), 'Six presets  ·  demo and preset tour', font=sub, fill=(165, 165, 165))
    device = Image.open(assets / 'fujara-device.png').convert('RGB').resize((720, 330), Image.LANCZOS)
    thumb.paste(device, (118, 680))
    d.rectangle((117, 679, 838, 1010), outline=(90, 90, 90))
    thumb.save(assets / 'fujara-thumbnail.png', optimize=True)
    for f in ('fujara-hero.png', 'fujara-hero.jpg', 'fujara-thumbnail.png'):
        im = Image.open(assets / f)
        print('%-22s %dx%d  %d KB' % (f, im.size[0], im.size[1], (assets / f).stat().st_size // 1024))


if __name__ == '__main__':
    main()
