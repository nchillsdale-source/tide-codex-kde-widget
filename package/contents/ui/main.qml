pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import "Typography.js" as Typography
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasma5support as P5Support

PlasmoidItem {
    id: root
    preferredRepresentation: fullRepresentation
    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground
    property var config: Plasmoid.configuration
    readonly property font textFont: Typography.resolve(config, Kirigami.Theme.defaultFont)
    readonly property real fontScale: Math.max(1, textFont.pointSize / Kirigami.Theme.defaultFont.pointSize)
    property var snapshot: ({windows: []})
    property var localTokens: null
    property bool busy: false
    property string failure: ""
    property string command: "python3 '" + decodeURIComponent(Qt.resolvedUrl("../scripts/usage.py").toString().replace(/^file:\/\//, "")).replace(/'/g, "'\\''") + "'" + (root.config.showLocalTokens ? "" : " --no-local-tokens")
    function refresh() {
        if (busy) return;
        busy = true;
        source.connectSource(command);
    }
    P5Support.DataSource {
        id: source
        engine: "executable"
        connectedSources: []
        onNewData: function(sourceName, data) {
            disconnectSource(sourceName);
            root.busy = false;
            try {
                var result = JSON.parse(data.stdout);
                root.localTokens = result.localTokens || null;
                if (result.ok) { root.snapshot = result; root.failure = ""; }
                else root.failure = result.error || "Usage unavailable";
            } catch (e) { root.failure = "Usage reader failed. Check Codex installation."; }
        }
    }
    Timer { interval: Math.max(1, root.config.refreshMinutes) * 60000; running: true; repeat: true; onTriggered: root.refresh() }
    Component.onCompleted: refresh()
    fullRepresentation: Dashboard {
        Layout.minimumWidth: root.config.displayStyle === 4 ? (root.config.meterOnly ? 140 : 260) * Math.max(1, root.config.textScale/100) * root.fontScale : root.config.meterOnly ? (root.config.displayStyle === 2 ? 280 : 120) : (root.config.displayStyle === 2 ? 360 : 300) * Math.max(1, root.config.textScale/100) * root.fontScale
        Layout.minimumHeight: root.config.displayStyle === 4 ? (root.config.meterOnly ? 20 : 116) * Math.max(1, root.config.textScale/100) * root.fontScale : root.config.meterOnly ? (root.config.displayStyle === 2 ? 240 : 120) : (root.config.displayStyle === 2 ? (root.config.showLocalTokens ? 810 : 540) : 440) * Math.max(1, root.config.textScale/100) * root.fontScale
        Layout.preferredWidth: root.config.displayStyle === 4 ? 280 : 360
        Layout.preferredHeight: root.config.displayStyle === 4 ? (root.config.meterOnly ? 20 : 116) : root.config.meterOnly ? 300 : 500
        settings: root.config
        snapshot: root.snapshot
        localTokens: root.localTokens
        busy: root.busy
        failure: root.failure
        onRefreshRequested: root.refresh()
        onMotionToggled: function(enabled) { root.config.motionEnabled = enabled; }
    }
    compactRepresentation: Rectangle {
        implicitWidth: 70; implicitHeight: 32; radius: 9; color: "transparent"
        TideText { baseFont: root.textFont; anchors.centerIn: parent; color: "#74f7e4"; text: root.snapshot.windows.length ? Math.round(root.snapshot.windows[0].remaining) + "%" : "TIDE" }
        MouseArea { anchors.fill: parent; onClicked: root.expanded = !root.expanded }
    }
}
