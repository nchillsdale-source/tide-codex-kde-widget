# Publishing Tide

Every published update must include a new version, a matching `vMAJOR.MINOR.PATCH` tag, a GitHub release, and downloadable packages. Never replace a published version with different code. Documentation-only updates also receive a patch version when published as an update.

1. Bump `package/metadata.json` and the versions displayed in README and About; update help and release notes.
2. Run the tests listed in README and QML lint. Check previews when appearance changes.
3. Run `python3 release.py`. It creates `dist/vVERSION/tide-usage-VERSION.plasmoid`, a portable source ZIP, and `SHA256SUMS`.
4. Publish all source, documentation, and preview changes to main. Verify the remote files match the tested sources.
5. Create a release from that exact main commit with the matching version tag. Attach all three generated assets, describe changes and validation, and publish it as the latest release.
6. Verify the release, tag, downloads, checksum contents, README video player and settings GIF.

The `.plasmoid` is the installable KDE package for Plasma 6. The source ZIP includes the installer, runtime files and documentation. GitHub Packages has no native KDE plasmoid registry; installers are distributed as GitHub Release assets, not unrelated npm or container packages.

For README playback, upload the MP4 as a GitHub attachment and put its returned URL on its own line. Keep the settings GIF in `social/` and embed it with normal Markdown image syntax.
