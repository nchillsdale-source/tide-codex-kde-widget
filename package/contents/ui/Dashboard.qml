pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import "Settings.js" as Settings
import "Typography.js" as Typography
import "History.js" as History

Item {
    id: panel
    width: 360; height: 500
    property var snapshot: ({windows: []})
    property var settings: ({})
    property var historySamples: []
    onSnapshotChanged: historySamples = History.append(historySamples, snapshot)
    readonly property var trendSeries: History.series(historySamples, selected)
    readonly property font textFont: Typography.resolve(settings, Kirigami.Theme.defaultFont)
    property bool busy: false
    property string failure: ""
    property bool motion: true
    property double now: Date.now() / 1000
    property var windows: snapshot.windows || []
    property var selected: {
        var main = windows.filter(function(w) { return w.main || w.name === "Codex & Work"; });
        var choice = opt("mainWindow");
        var target = main.find(function(w) { return w.window === (choice === 1 ? "Weekly" : "5-hour"); });
        return (choice && target) || main[0] || windows[0] || null;
    }
    property string selectedId: selected ? (selected.id || selected.name + "/" + selected.window) : ""
    property var additional: windows.filter(function(w) { return (w.id || w.name + "/" + w.window) !== panel.selectedId; })
    property real remaining: selected ? selected.remaining : 0
    property bool meterOnly: opt("meterOnly")
    property real textScale: opt("textScale") / 100
    property color accent: {
        if (!selected) return "#6b8195";
        if (opt("warningColors") && remaining <= 10) return "#ff7d83";
        if (opt("warningColors") && remaining <= 25) return "#ffc778";
        var colors = ["#6af7df", "#7bc8ff", "#c0a0ff", "#ffad99", Kirigami.Theme.highlightColor];
        return colors[opt("palette")] || colors[0];
    }
    property bool stale: !!failure || (!!snapshot.updatedAt && now - snapshot.updatedAt > Math.max(420, opt("refreshMinutes")*120+60))
    property string status: busy ? "SYNCING" : !selected ? "OFFLINE" : stale ? "STALE" : "LIVE"
    property string hoverText: (selected ? selected.name + " · " + selected.window + ": " + Math.round(remaining) + "% remaining\n" + countdown(selected.resetsAt) : "Usage unavailable") + "\n" + status + (failure ? " · " + failure : "") + "\nChat conversations are not included."
    signal refreshRequested()
    signal motionToggled(bool enabled)
    function opt(key) { return settings[key] === undefined ? Settings.defaults[key] : settings[key]; }
    function shown(key) { return !meterOnly && opt(key); }
    function countdown(ts) {
        if (!ts) return "Reset time unavailable";
        var s = Math.max(0, ts-now);
        if (!s) return "Reset due · awaiting update";
        var d = Math.floor(s/86400), h = Math.floor(s%86400/3600), m = Math.floor(s%3600/60);
        return "Resets in " + (d ? d+"d " : "") + (h ? h+"h " : "") + (d ? "" : m+"m");
    }
    Timer { interval: 15000; running: true; repeat: true; onTriggered: panel.now = Date.now()/1000 }
    HoverHandler { id: hover }
    ToolTip.visible: hover.hovered && (panel.meterOnly || panel.opt("displayStyle") === 4)
    ToolTip.delay: 900
    ToolTip.text: panel.hoverText
    Rectangle { anchors.fill: parent; radius: 24; color: "#0b1826"; opacity: panel.opt("backgroundOpacity")/100 }
    MinimalView {
        objectName: "minimal"
        anchors.fill: parent; visible: panel.opt("displayStyle") === 4
        selected: panel.selected; textFont: panel.textFont; textScale: panel.textScale
        meterOnly: panel.meterOnly; showHeader: panel.opt("showHeader"); showStatus: panel.opt("showStatus")
        showValue: panel.opt("showPercentage"); showRemaining: panel.opt("showRemaining"); status: panel.status
        resetText: panel.opt("showResetTime") && panel.selected ? panel.countdown(panel.selected.resetsAt) : ""
        updatedText: panel.opt("showUpdated") ? (panel.stale ? "Stale" : panel.busy ? "Syncing" : panel.snapshot.updatedAt ? "Updated " + new Date(panel.snapshot.updatedAt*1000).toLocaleTimeString(Qt.locale(),"hh:mm") : "No data") : ""
    }
    ColumnLayout {
        visible: panel.opt("displayStyle") !== 4
        anchors.fill: parent; anchors.margins: panel.meterOnly ? 0 : 22; spacing: 10
        RowLayout {
            visible: panel.shown("showHeader") || panel.shown("showStatus")
            Layout.fillWidth: true
            Column {
                visible: panel.shown("showHeader"); spacing: 4
                TideText { baseFont: panel.textFont; text: "T I D E"; color: "#edfaff"; sizeScale: 1.35*panel.textScale }
                TideText { baseFont: panel.textFont; text: "CODEX & WORK"; color: "#90a9bd"; sizeScale: 0.75*panel.textScale; font.letterSpacing: 1 }
            }
            Item { Layout.fillWidth: true }
            Rectangle { visible: panel.shown("showStatus"); implicitWidth: 6; implicitHeight: 6; radius: 3; color: panel.stale ? "#ffc778" : panel.accent }
            TideText { baseFont: panel.textFont; visible: panel.shown("showStatus"); text: panel.status; color: "#a1b7c8"; sizeScale: 0.675*panel.textScale; font.letterSpacing: 1 }
        }
        Item {
            Layout.fillWidth: true; Layout.fillHeight: true
            Layout.minimumHeight: panel.meterOnly ? 100 : 140
            LiquidOrb {
                id: aquarium
                visible: panel.opt("displayStyle") !== 2
                displayStyle: panel.opt("displayStyle")
                styleAnimate: panel.opt("styleAnimate"); styleSpeed: panel.opt("styleSpeed")/100
                styleOpacity: panel.opt("styleOpacity")/100; styleDetail: panel.opt("styleDetail")
                raceColor: ["#ef4b4b", "#ff9b45", "#5cadff", "#dae4eb", "#40ca98"][panel.opt("carColor")] || "#ef4b4b"
                objectName: "aquarium"
                anchors.centerIn: parent
                width: Math.min(parent.width, parent.height); height: width
                value: panel.remaining / 100; accent: panel.accent
                active: panel.motion && panel.opt("motionEnabled") && panel.visible && panel.opt("displayStyle") !== 4
                hasData: !!panel.selected
                showFish: panel.opt("showFish"); fishCount: panel.opt("fishCount")
                fishScale: panel.opt("fishScale")/100; fishSpeed: panel.opt("fishSpeed")/100
                fishStyle: panel.opt("fishStyle"); animateFish: panel.opt("animateFish")
                animateWater: panel.opt("animateWater"); showBubbles: panel.opt("showBubbles")
                waveStrength: panel.opt("waveStrength")/100; frameRate: panel.opt("frameRate"); frameMode: panel.opt("frameMode")
                showRing: panel.opt("showRing"); showTicks: panel.opt("showTicks")
                showGlow: panel.opt("showGlow"); glowStrength: panel.opt("glowStrength")/100
                waterOpacity: panel.opt("waterOpacity")/100
                glassOpacity: panel.opt("glassOpacity")/100
            }
            AnalyticsView {
                objectName: "analytics"
                anchors.fill: parent
                visible: panel.opt("displayStyle") === 2
                selected: panel.selected; windows: panel.windows; series: panel.trendSeries
                textFont: panel.textFont; textScale: panel.textScale
                showLabels: !panel.meterOnly; showValue: panel.shown("showPercentage")
                showBars: panel.meterOnly || panel.opt("showExtraLimits")
                refreshSeconds: panel.opt("refreshMinutes")*60
            }
            Column {
                visible: panel.opt("displayStyle") !== 2
                anchors.centerIn: parent; spacing: 3
                TideText { baseFont: panel.textFont; visible: panel.shown("showPercentage"); anchors.horizontalCenter: parent.horizontalCenter; text: panel.selected ? Math.round(panel.remaining) + "%" : "—"; sizeScale: 3.975*panel.textScale; color: "#f2ffff" }
                TideText { baseFont: panel.textFont; visible: panel.shown("showRemaining"); anchors.horizontalCenter: parent.horizontalCenter; text: panel.selected ? "R E M A I N I N G" : "A W A I T I N G  D A T A"; sizeScale: 0.675*panel.textScale; color: "#d7f6f5" }
            }
        }
        Flickable {
            visible: panel.opt("displayStyle") !== 2 && panel.shown("showExtraLimits") && panel.additional.length > 0
            Layout.fillWidth: true; Layout.preferredHeight: Math.min(100*panel.textScale, meters.height)
            contentHeight: meters.height; clip: true
            Column {
                id: meters; width: parent.width; spacing: 9
                Repeater {
                    model: panel.additional
                    delegate: Column {
                        id: meter
                        required property var modelData
                        width: meters.width; spacing: 5
                        Row {
                            width: parent.width
                            TideText { baseFont: panel.textFont; width: parent.width-45*panel.textScale; text: meter.modelData.name + " · " + meter.modelData.window; elide: Text.ElideRight; color: "#94aebe"; sizeScale: 0.75*panel.textScale }
                            TideText { baseFont: panel.textFont; width: 45*panel.textScale; horizontalAlignment: Text.AlignRight; text: Math.round(meter.modelData.remaining)+"%"; color: "#d7eef3"; sizeScale: 0.75*panel.textScale }
                        }
                        Rectangle {
                            width: parent.width; height: 3; radius: 2; color: "#253748"
                            Rectangle { width: parent.width*meter.modelData.remaining/100; height: 3; radius: 2; color: panel.accent }
                        }
                        HoverHandler { id: meterHover }
                        ToolTip.visible: meterHover.hovered; ToolTip.text: panel.countdown(meter.modelData.resetsAt)
                    }
                }
            }
        }
        RowLayout {
            visible: panel.shown("showCredits"); Layout.fillWidth: true
            TideText { baseFont: panel.textFont; text: "CREDITS  " + (panel.snapshot.credits == null ? "—" : panel.snapshot.credits); color: "#91a9bb"; sizeScale: 0.675*panel.textScale }
            Item { Layout.fillWidth: true }
            TideText { baseFont: panel.textFont; text: "RESETS  " + (panel.snapshot.resetCredits == null ? "—" : panel.snapshot.resetCredits); color: "#91a9bb"; sizeScale: 0.675*panel.textScale }
        }
        TideText { baseFont: panel.textFont;
            Layout.fillWidth: true; visible: panel.shown("showErrors") && !!panel.failure
            text: panel.failure; color: "#ffc778"; sizeScale: 0.75*panel.textScale; wrapMode: Text.WordWrap
        }
        RowLayout {
            visible: panel.shown("showUpdated") || panel.shown("showResetTime") || panel.shown("showButtons")
            Layout.fillWidth: true; spacing: 5
            ColumnLayout {
                Layout.fillWidth: true; spacing: 3
                TideText { baseFont: panel.textFont; visible: panel.shown("showResetTime"); Layout.fillWidth: true; text: panel.selected ? panel.countdown(panel.selected.resetsAt) : "Reset time unavailable"; color: "#a8c3d2"; sizeScale: 0.75*panel.textScale; wrapMode: Text.WordWrap }
                TideText { baseFont: panel.textFont;
                    visible: panel.shown("showUpdated"); Layout.fillWidth: true
                    text: panel.snapshot.updatedAt ? "Updated " + new Date(panel.snapshot.updatedAt*1000).toLocaleTimeString(Qt.locale(), "hh:mm") : "Waiting for first update"
                    color: "#839daf"; sizeScale: 0.675*panel.textScale; wrapMode: Text.WordWrap
                }
            }
            TideButton { textFont: panel.textFont;
                visible: panel.shown("showButtons"); text: panel.motion && panel.opt("motionEnabled") ? "≈" : "–"
                Accessible.name: "Toggle animation"
                ToolTip.visible: hovered; ToolTip.text: "Toggle all animation"
                onClicked: panel.motionToggled(!(panel.motion && panel.opt("motionEnabled")))
            }
            TideButton { textFont: panel.textFont;
                visible: panel.shown("showButtons"); text: "↗"
                Accessible.name: "Open ChatGPT usage"
                ToolTip.visible: hovered; ToolTip.text: "Open usage page"
                onClicked: Qt.openUrlExternally("https://chatgpt.com/#settings/Usage")
            }
            TideButton { textFont: panel.textFont;
                visible: panel.shown("showButtons"); text: "↻"; enabled: !panel.busy
                Accessible.name: "Refresh usage"
                ToolTip.visible: hovered; ToolTip.text: "Refresh now"
                onClicked: panel.refreshRequested()
            }
        }
        TideText { baseFont: panel.textFont; visible: panel.shown("showScopeNote"); Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter; wrapMode: Text.WordWrap; text: "Chat conversations are not included"; sizeScale: 0.675*panel.textScale; color: "#8298a9" }
    }
}
