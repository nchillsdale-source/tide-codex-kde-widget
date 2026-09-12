#!/usr/bin/env python3
"""Build versioned KDE installer and portable source bundle for a GitHub release."""
from pathlib import Path
import hashlib
import json
import re
import shutil
import subprocess
import sys
import zipfile

root = Path(__file__).resolve().parent
version = json.loads((root / 'package/metadata.json').read_text())['KPlugin']['Version']
if not re.fullmatch(r'\d+\.\d+\.\d+', version):
    raise SystemExit('Expected a numeric major.minor.patch version')
subprocess.run([sys.executable, str(root / 'build.py')], check=True)
out = root / 'dist' / ('v' + version)
out.mkdir(parents=True, exist_ok=True)
widget = out / f'tide-usage-{version}.plasmoid'
shutil.copyfile(root / 'tide-usage.plasmoid', widget)
bundle = out / f'tide-usage-{version}-source.zip'
files = [root / name for name in ('README.md', 'HELP.md', 'LICENSE', 'install.sh', 'build.py', 'release.py', 'RELEASING.md')]
files += [p for p in (root / 'package').rglob('*') if p.is_file() and '__pycache__' not in p.parts and p.suffix != '.pyc']
with zipfile.ZipFile(bundle, 'w', zipfile.ZIP_DEFLATED) as archive:
    for path in sorted(files):
        archive.write(path, Path(f'tide-usage-{version}') / path.relative_to(root))
checksums = ''.join(f'{hashlib.sha256(p.read_bytes()).hexdigest()}  {p.name}\n' for p in (widget, bundle))
(out / 'SHA256SUMS').write_text(checksums)
print(f'Release assets: {out}')
