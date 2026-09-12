import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

ScrollView {
    id: page
    implicitWidth: 620
    implicitHeight: 560
    clip: true
    contentWidth: availableWidth
    property alias cfg_refreshMinutes: refreshMinutes.value
    property alias cfg_mainWindow: mainWindow.currentIndex
    property alias cfg_showLocalTokens: localTokens.checked
    property alias cfg_motionEnabled: motionEnabled.checked
    ColumnLayout {
        width: page.availableWidth
        spacing: 12
        Label { Layout.fillWidth: true; Layout.margins: 12; text: "Reads the shared Codex & Work allowance through your existing Codex sign-in. Regular ChatGPT conversations are not included. No model turns, purchases or reset redemptions are made."; wrapMode: Text.WordWrap }
        Kirigami.FormLayout {
            Layout.fillWidth: true
            Layout.margins: 12
        SpinBox { id: refreshMinutes; Kirigami.FormData.label: "Refresh interval (minutes):"; from: 1; to: 30; editable: true }
        ComboBox { id: mainWindow; Kirigami.FormData.label: "Main allowance:"; model: ["Most depleted Codex & Work window", "Weekly Codex & Work window", "5-hour Codex & Work window"]; Layout.preferredWidth: 300; Layout.maximumWidth: 380 }
        CheckBox { id: localTokens; text: "Show local token usage in Analytics" }
        CheckBox { id: motionEnabled; text: "Enable animation (master switch)" }
        }
        Button { Layout.leftMargin: 12; text: "Restore this page’s defaults"; onClicked: { localTokens.checked = true; refreshMinutes.value = 3; mainWindow.currentIndex = 0; motionEnabled.checked = true } }
    }
}
