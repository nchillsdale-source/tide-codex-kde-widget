# Tide 1.7.0 — Codex & Work Usage

An independent, community-built native Plasma 6 desktop usage meter with five selectable visual styles. It uses KDE’s system font, a transparent background, translucent water, and detailed swimming fish with shaded bodies, scales, patterned coloring, gills, eyes, flexible fins and tails. The reset countdown sits beside the update status; there is no “Weekly allowance” title.

![Tide display styles using illustrative sample data](styles-preview.png)

[Full settings help](HELP.md) · [Configuration showcase video](social/tide-widget-configurations.mp4) · [Social sharing files](social/)

## Install or update

Download this repository using **Code → Download ZIP**, extract it, and run `bash install.sh` from the extracted folder, or download [`tide-usage.plasmoid`](tide-usage.plasmoid?raw=true) and install it through KDE’s Add Widgets → Get New Widgets → Install Widget From Local File. Search for **Tide** to add it to your desktop. Suggested size: 360 × 500.

**After updating:** Plasma can retain old QML even after removing and re-adding a widget. Press **Alt+Space**, run `plasmashell --replace`, and wait for the desktop and panels to reload. Application windows remain open. The installer does not restart Plasma automatically.

Designed for Linux distributions running KDE Plasma 6; tested on CachyOS. Other distributions have not yet been verified. Plasma 5 is not supported.

Requires Plasma 6, Plasma5Support’s executable data engine, Kirigami, Python 3, and a signed-in Codex CLI. The bundled Codex binary at `/usr/lib/chatgpt/resources/codex` is supported as a fallback. The package includes no sign-in credentials or account data.

## Settings

Right-click Tide → **Configure Tide / Tide Settings**. Settings are stored per widget by KDE and applied with the configuration dialog’s Apply or OK buttons. Editable settings pages have a restore-defaults button. The **Help** tab provides a searchable offline guide covering every option, defaults, ranges, Analytics history and troubleshooting. The same guide is included in `HELP.md`.

### Styles

- **Aquarium:** translucent water, detailed fish, bubbles and a glowing quota ring. Remaining allowance determines the water level.
- **Lava chamber:** a metal-and-glass reservoir with molten fill, rising heat pockets, drifting crust, glowing seams and embers. Remaining allowance determines the lava level.
- **Analytics:** a clean session trend with a fixed 0–100% axis and labeled allowance bars. History uses successful readings recorded while the widget is running (up to 480 snapshots). The chart shows individual points until eight readings are collected, then connects them. Gaps remain unconnected; quota resets start a new series. Reloading the widget clears history. Suggested size: 360 × 540.
- **Minimal:** a compact 280 × 116 display with a percentage, slim allowance bar and reset/update times. Transparent by default, with system or custom fonts. No decorative motion, secondary bars, credits or buttons; hover for status and connection details. Meter-only mode shows just the bar (minimum 140 × 20). Resize an existing desktop instance after switching if Plasma preserves its old size.
- **Motorsport:** an original open-wheel race car follows a flowing circuit with curbs and a checkered start line. An independent inner fuel-style gauge represents remaining allowance. The car is decorative; its lap position does not represent usage.
- The Styles page includes a live sample preview, independent motion toggle, speed (20–200%), surface opacity (20–100%), detail toggle and five race-car colors.
- All styles use the same account data, custom-font settings, meter-only layout and frame pacing modes. The master animation toggle pauses all styles. Aquarium-specific controls affect only the aquarium; the new styles have their own motion settings. Styling controls apply to the features present in each display.
- The existing aquarium remains the default; switching styles preserves other settings.

### Display

- **Meter only:** shows the selected meter alone, without any text or buttons. Right-click to configure it; hover for usage, reset and connection information. It can resize down to 120 × 120 (Analytics: 280 × 240).
- Individually show or hide the title, connection status, percentage, Remaining caption, additional allowances, credits, reset countdown, update time, action buttons, scope note and error message.
- Adjust text size from 70–160% while retaining KDE’s chosen font. Widget minimum dimensions adapt to larger text.

### Fonts

- Keep KDE’s system font (default), or enable a custom font for this widget only.
- Use **Choose font…** to select an installed family and style, including bold or italic styles.
- Adjust the base size from 6–48 pt and inspect the live preview. Display text scaling applies on top of this size.
- **Restore KDE font defaults** returns to the system font. Larger custom fonts increase the widget’s minimum dimensions to preserve the layout.
- Font selections use the settings dialog’s Apply/OK workflow; canceling the font picker does not apply a selection.

### Aquarium

- Enable or hide fish; choose 1–10 fish.
- Adjust fish size (50–200%) and swimming speed (20–200%).
- Choose koi, tropical or silver colors.
- Animate fish and water independently.
- Enable bubbles and adjust wave height.
- **Balanced (default):** display-synced drawing capped at 30 fps.
- **Smooth:** display-synced drawing capped at 60 fps.
- **Match display:** draws on each frame supplied by Qt’s animation clock, without an additional cap. Actual cadence depends on the display, compositor and system load.
- **Custom:** choose a drawing cap from 10–240 fps. The custom limit control is enabled only in Custom mode.
- All modes use real elapsed time, so swimming speed stays consistent. Capped modes skip painting on intervening display frames. Pausing resets the timing budget to avoid catch-up jumps. Existing custom numeric values are retained, while the newly added mode defaults to Balanced.
- Fish stay inside the sphere below the waves, shrink in shallow water, and disappear when there is insufficient room. Their silhouettes narrow naturally during turns.

### Appearance

- Choose lagoon, ocean, aurora, sunset or KDE highlight colors.
- Optionally switch to amber at 25% remaining and coral at 10%.
- Show or hide the progress ring, scale markings and glow; adjust glow intensity.
- **Water opacity:** default 35%, letting your wallpaper show through. Set 0% to hide the water tint while retaining the fish.
- **Glass shading:** default 0%; increase for a darker glass interior.
- **Background panel opacity:** default 0% for a transparent desktop widget.

### Local token analytics

Analytics can show today’s local input, cached-input, output, reasoning and total tokens, a trailing five-minute tokens/minute average, and twelve five-minute rate bars for the last hour. Enable or disable it under Updates → Show local token usage in Analytics. Suggested Analytics size with this section: 360 × 810. Meter-only mode hides token details.

These are counters from `CODEX_HOME/sessions` and `archived_sessions` (default `~/.codex`), across accounts/models recorded in that local profile. They are not account-wide usage, billing totals or a conversion of allowance percentages. Cached input is already included in input; reasoning is already included in output. Today uses local midnight; rates use event timestamps, not instantaneous generation speed. Duplicate cumulative reports and copied timestamp/counter records are deduplicated. Missing initial history, malformed records or scan limits produce a Partial label. Scans are bounded to 256 MiB / five seconds of reading and do not return conversation text or paths or save new token-history files. Local results can refresh even if the allowance read fails. This log format may change with Codex versions.

### Updates

- Refresh every 1–30 minutes; default three minutes. The refresh button updates immediately.
- Select the most depleted, weekly or 5-hour Codex & Work window for the main meter. If the requested window is unavailable, Tide falls back to the available shared allowance, then another reported bucket.
- Master animation switch. The widget’s animation button saves this setting too.

### About

The About tab lists **Nicholas Hillsdale** as author, the widget version, license, usage scope and update instructions. The package metadata also credits Nicholas Hillsdale.

## Data and limitations

Reads `account/rateLimits/read` through the documented local `codex app-server --stdio` interface. The reader has a 35-second deadline and shuts down its app-server after each read. It uses your existing Codex sign-in and may cause Codex to maintain its normal state files and refresh authentication.

No model turns, purchases, reset redemptions or usage-history files are created by Tide. Missing values are shown as unavailable. Failed updates retain the previous data and mark it stale. Staleness also detects overdue updates, with a threshold adjusted to the selected refresh interval. In meter-only mode, hover to see connection problems.

The shared allowance covers Codex, Work, Workspace Agents, and ChatGPT for Excel. **Ordinary ChatGPT conversations are not included.** Other reported allowances, such as Spark, appear in the additional bars. Hover an additional bar for its reset time.

The scope note can be hidden, but the data scope does not change. The open-arrow button opens the account’s Usage page in your regular browser.

## Validation

`python3 tests/test_local_tokens.py` checks token deduplication, resets, midnight boundaries, rates and partial scans. `python3 tests/test_usage.py` checks quota parsing, unknown values, legacy data and window ordering. `python3 tests/test_frame_clock.py` tests pacing at display rates from 30–240 Hz, including 59.94 Hz, stable motion speed and stall handling. `python3 tests/test_qml.py` additionally requires PySide6 and KDE QML modules; it checks all settings-page bindings against the schema, window selection, meter-only visibility, independent animation, frame-mode controls, custom-font selection and fallback, style switching and motion, session history, reset boundaries, empty states, and actual water translucency. QML checks: `qmllint package/contents/ui/*.qml package/contents/config/config.qml`.

`preview.png` renders the actual QML over an illustrative background with sample 72% remaining allowance. It compares the standard and meter-only views; it is not a live desktop screenshot.

`styles-preview.png` and `styles-preview.mp4` show all four actual QML renderers with a sample 72% allowance. The trend uses explicitly illustrative sample readings. The video is a 30 fps offscreen preview, not a hardware performance benchmark. `analytics-preview.png` compares a populated session with a newly started session.

## Building the installable package

Run `python3 build.py` from the repository folder. It packages the `package/` source directory into `tide-usage.plasmoid`, excluding Python caches. No account connection is needed to build.

## Remove

Remove the desktop widget and delete only `local.tide.usage` under your user data directory’s `plasma/plasmoids/`. No background service is installed.

## Sources

- https://learn.chatgpt.com/docs/app-server
- https://develop.kde.org/docs/plasma/widget/configuration/
- https://develop.kde.org/docs/plasma/widget/testing/
