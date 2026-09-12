pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Item {
    id: view
    property var selected: null
    property var localTokens: null
    property bool showLocalTokens: false
    property double now: Date.now()/1000
    property int staleAfter: 420
    property font textFont: Kirigami.Theme.defaultFont
    property real textScale: 1
    property bool meterOnly: false
    property bool showHeader: true
    property bool showStatus: true
    property bool showValue: true
    property bool showRemaining: true
    property string status: "OFFLINE"
    property string resetText: ""
    property string updatedText: ""
    property color accent: "#87b9d8"
    ColumnLayout {
        anchors.fill: parent; anchors.margins: view.meterOnly ? 0 : 14
        spacing: 10
        RowLayout {
            visible: !view.meterOnly && (view.showHeader || view.showStatus || view.showValue || view.showRemaining)
            Layout.fillWidth: true; spacing: 8
            Rectangle { visible: view.showStatus; implicitWidth: 5; implicitHeight: 5; radius: 3; color: view.status === "LIVE" ? view.accent : "#c4aa7d" }
            ColumnLayout {
                Layout.fillWidth: true; spacing: 3
                TideText { visible: view.showHeader; baseFont: view.textFont; Layout.fillWidth: true; text: view.selected ? "TIDE · " + view.selected.window.toUpperCase() : "TIDE"; color: "#a9bbc9"; sizeScale: .72*view.textScale; elide: Text.ElideRight; font.letterSpacing: .6 }
                TideText { visible: view.showRemaining; baseFont: view.textFont; text: "Allowance remaining"; color: "#8195a6"; sizeScale: .66*view.textScale }
            }
            TideText { visible: view.showValue; baseFont: view.textFont; text: view.selected ? Math.round(view.selected.remaining)+"%" : "—"; color: "#e9f1f7"; sizeScale: 1.8*view.textScale }
        }
        Rectangle {
            Layout.fillWidth: true; Layout.preferredHeight: 4; radius: 2; color: "#334350"
            Rectangle { width: parent.width*(view.selected ? Math.max(0,Math.min(100,view.selected.remaining))/100 : 0); height: parent.height; radius: 2; color: view.accent }
        }
        TokenUsageView {
            objectName: "minimalTokens"
            Layout.fillWidth: true
            visible: !view.meterOnly && view.showLocalTokens
            compact: true; usage: view.localTokens; now: view.now; staleAfter: view.staleAfter
            textFont: view.textFont; textScale: view.textScale
        }
        RowLayout {
            visible: !view.meterOnly && (view.resetText.length > 0 || view.updatedText.length > 0)
            Layout.fillWidth: true; spacing: 8
            TideText { visible: view.resetText.length>0; baseFont: view.textFont; Layout.fillWidth: true; text: view.resetText; elide: Text.ElideRight; color: "#91a4b4"; sizeScale: .65*view.textScale }
            Item { visible: !view.resetText.length; Layout.fillWidth: true }
            TideText { visible: view.updatedText.length>0; baseFont: view.textFont; text: view.updatedText; color: "#91a4b4"; sizeScale: .65*view.textScale }
        }
    }
}
