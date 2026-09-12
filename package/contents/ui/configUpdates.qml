import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

ScrollView {
    id: page
    implicitWidth: 640; implicitHeight: 600
    clip: true; contentWidth: availableWidth
    property alias cfg_refreshMinutes: refreshMinutes.value
    property alias cfg_mainWindow: mainWindow.currentIndex
    property alias cfg_showLocalTokens: localTokens.checked
    ColumnLayout {
        width: page.availableWidth; spacing: 12
        Label { Layout.fillWidth: true; Layout.leftMargin: 16; Layout.topMargin: 12; text: "Data & updates"; font.bold: true; font.pointSize: 18 }
        Label { Layout.fillWidth: true; Layout.leftMargin: 16; Layout.rightMargin: 16; text: "Account allowances and local token counters refresh together. Ordinary ChatGPT conversations are excluded."; wrapMode: Text.WordWrap; opacity: .75 }
        GroupBox {
            title: "Account allowance"; Layout.fillWidth: true; Layout.leftMargin: 16; Layout.rightMargin: 16
            Kirigami.FormLayout {
                width: parent.width
                ComboBox { id: mainWindow; Kirigami.FormData.label: "Main allowance:"; model: ["Most depleted Codex & Work window", "Weekly Codex & Work window", "5-hour Codex & Work window"]; Layout.preferredWidth: 300; Layout.maximumWidth: 380 }
                SpinBox { id: refreshMinutes; Kirigami.FormData.label: "Refresh interval (minutes):"; from: 1; to: 30; editable: true }
            }
        }
        GroupBox {
            title: "Local token usage"; Layout.fillWidth: true; Layout.leftMargin: 16; Layout.rightMargin: 16
            Kirigami.FormLayout {
                width: parent.width
                CheckBox { id: localTokens; text: "Show local token usage on all displays" }
                Label { Layout.fillWidth: true; text: "Analytics shows the full breakdown and graph. Other displays show today’s total and the last five-minute average rate. Updates follow the refresh interval above. Counts come from this local Codex profile, not account-wide billing. See Help for coverage and rate calculations."; wrapMode: Text.WordWrap; opacity: .75 }
            }
        }
        Button { Layout.leftMargin: 16; text: "Restore this page’s defaults"; onClicked: { localTokens.checked = true; refreshMinutes.value = 3; mainWindow.currentIndex = 0 } }
        Item { Layout.preferredHeight: 12 }
    }
}
