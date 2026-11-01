#!/usr/bin/env python3
"""Select the Mango/Waybar palette without replacing unrelated settings."""

import argparse
from pathlib import Path
import re

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("theme", choices=("tokyo-night", "gruvbox"))
args = parser.parse_args()
root = Path(__file__).resolve().parent
palette = root / "themes" / args.theme
config_path = root / "config.conf"
config = config_path.read_text()
block = palette.with_suffix(".conf").read_text()
config, count = re.subn(
    r"(?<=# BEGIN MANGO THEME\n).*?(?=# END MANGO THEME)",
    lambda _: block,
    config,
    flags=re.DOTALL,
)
if count != 1:
    parser.error("Expected exactly one marked theme block in config.conf")
background = "1a1b26" if args.theme == "tokyo-night" else "282828"
config = re.sub(r"(swaybg -c '#)[0-9a-fA-F]{6}", rf"\g<1>{background}", config)
config = re.sub(r"(swaylock -f -c )[0-9a-fA-F]{6}", rf"\g<1>{background}", config)
css = palette.with_suffix(".css").read_text()
config_path.write_text(config)
(root / "waybar.css").write_text(css)
print(f"Mango: {args.theme}. Super+R reloads borders and manual locking; log in again for all components.")
