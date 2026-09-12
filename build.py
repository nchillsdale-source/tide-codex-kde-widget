#!/usr/bin/env python3
"""Build Tide from source without including local caches or account data."""
from pathlib import Path
import zipfile

root = Path(__file__).resolve().parent
source = root / "package"
output = root / "tide-usage.plasmoid"
with zipfile.ZipFile(output, "w", zipfile.ZIP_DEFLATED) as archive:
    for path in sorted(source.rglob("*")):
        if path.is_file() and "__pycache__" not in path.parts and path.suffix != ".pyc":
            archive.write(path, path.relative_to(source))
print(f"Built {output.name}")
