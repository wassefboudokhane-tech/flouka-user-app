#!/usr/bin/env python3
"""Build the filled F monogram (app icon + splash) from Markazi Text."""

from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
FONT = Path("/tmp/fonts/MarkaziText-Regular.ttf")
INK = (31, 31, 31, 255)
WHITE = (255, 255, 255, 255)


def load_font(size: int) -> ImageFont.FreeTypeFont:
    return ImageFont.truetype(str(FONT), size=size)


def monogram(size: int, *, ring: bool = False) -> Image.Image:
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    pad = int(size * 0.04)
    fill = WHITE if ring else INK
    outline = INK if ring else None
    if ring:
        draw.ellipse([pad, pad, size - pad - 1, size - pad - 1], fill=WHITE, outline=INK, width=max(2, size // 48))
    else:
        draw.ellipse([pad, pad, size - pad - 1, size - pad - 1], fill=INK)
    font = load_font(int(size * 0.62))
    letter = "F"
    x0, y0, x1, y1 = draw.textbbox((0, 0), letter, font=font)
    tw, th = x1 - x0, y1 - y0
    draw.text(
        ((size - tw) / 2 - x0, (size - th) / 2 - y0 - size * 0.03),
        letter,
        font=font,
        fill=INK if ring else WHITE,
    )
    return img


def save_rgb(img: Image.Image, path: Path, bg=WHITE) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    base = Image.new("RGB", img.size, bg[:3])
    base.paste(img, mask=img.split()[-1])
    base.save(path, "PNG")


def main() -> None:
    icon = monogram(1024)
    ios = ROOT / "ios/Runner/Assets.xcassets/AppIcon.appiconset"
    sizes = {
        "20.png": 20,
        "29.png": 29,
        "40.png": 40,
        "50.png": 50,
        "57.png": 57,
        "58.png": 58,
        "60.png": 60,
        "72.png": 72,
        "76.png": 76,
        "80.png": 80,
        "87.png": 87,
        "100.png": 100,
        "114.png": 114,
        "120.png": 120,
        "144.png": 144,
        "152.png": 152,
        "167.png": 167,
        "180.png": 180,
        "1024.png": 1024,
    }
    for name, px in sizes.items():
        save_rgb(icon.resize((px, px), Image.Resampling.LANCZOS), ios / name)

    android_map = {
        "mipmap-mdpi": 48,
        "mipmap-hdpi": 72,
        "mipmap-xhdpi": 96,
        "mipmap-xxhdpi": 144,
        "mipmap-xxxhdpi": 192,
    }
    res = ROOT / "android/app/src/main/res"
    for folder, px in android_map.items():
        save_rgb(icon.resize((px, px), Image.Resampling.LANCZOS), res / folder / "ic_launcher.png")

    fg = monogram(432)
    adaptive = res / "mipmap-anydpi-v26"
    # Keep raster foreground for older tools; also write drawable.
    save_rgb(fg, res / "drawable" / "ic_launcher_foreground.png", bg=(255, 255, 255, 255))
    fg.save(res / "drawable" / "ic_launcher_foreground_alpha.png", "PNG")

    splash = Image.new("RGB", (1024, 1024), (255, 255, 255))
    mark = icon.resize((420, 420), Image.Resampling.LANCZOS)
    splash.paste(mark, ((1024 - 420) // 2, (1024 - 420) // 2), mark)
    splash_path = res / "drawable" / "splash_logo.png"
    splash.save(splash_path, "PNG")
    for dens, px in {"drawable-mdpi": 192, "drawable-hdpi": 288, "drawable-xhdpi": 384, "drawable-xxhdpi": 576, "drawable-xxxhdpi": 768}.items():
        d = res / dens
        d.mkdir(parents=True, exist_ok=True)
        splash.resize((px, px), Image.Resampling.LANCZOS).save(d / "splash_logo.png", "PNG")

    launch = ROOT / "ios/Runner/Assets.xcassets/LaunchImage.imageset"
    launch.mkdir(parents=True, exist_ok=True)
    for name, px in {"LaunchImage.png": 168, "LaunchImage@2x.png": 336, "LaunchImage@3x.png": 504}.items():
        save_rgb(icon.resize((px, px), Image.Resampling.LANCZOS), launch / name)
    (launch / "Contents.json").write_text(
        """{
  "images" : [
    { "idiom" : "universal", "filename" : "LaunchImage.png", "scale" : "1x" },
    { "idiom" : "universal", "filename" : "LaunchImage@2x.png", "scale" : "2x" },
    { "idiom" : "universal", "filename" : "LaunchImage@3x.png", "scale" : "3x" }
  ],
  "info" : { "version" : 1, "author" : "xcode" }
}
""",
        encoding="utf-8",
    )

    web = ROOT / "web"
    save_rgb(icon.resize((192, 192), Image.Resampling.LANCZOS), web / "icons" / "Icon-192.png")
    save_rgb(icon.resize((512, 512), Image.Resampling.LANCZOS), web / "icons" / "Icon-512.png")
    save_rgb(icon.resize((192, 192), Image.Resampling.LANCZOS), web / "icons" / "Icon-maskable-192.png")
    save_rgb(icon.resize((512, 512), Image.Resampling.LANCZOS), web / "icons" / "Icon-maskable-512.png")
    save_rgb(icon.resize((32, 32), Image.Resampling.LANCZOS), web / "favicon.png")
    save_rgb(icon, ROOT / "assets/brand/app_icon.png")
    print("icons written")


if __name__ == "__main__":
    main()
