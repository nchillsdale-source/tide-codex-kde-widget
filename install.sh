#!/usr/bin/env bash
set -euo pipefail
source_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
data_dir="${XDG_DATA_HOME:-$HOME/.local/share}"
destination="$data_dir/plasma/plasmoids/local.tide.usage"
mkdir -p "$destination"
cp -R "$source_dir/package/." "$destination/"
printf 'Installed Tide to %s\nFor a first install, add Tide from KDE’s Add Widgets menu. After an update, press Alt+Space and run: plasmashell --replace\n' "$destination"
