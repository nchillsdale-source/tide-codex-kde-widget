import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

ScrollView {
    id: page
    implicitWidth: 640; implicitHeight: 600
    clip: true; contentWidth: availableWidth
    property alias cfg_motionEnabled: motionEnabled.checked
    property alias cfg_frameMode: frameMode.currentIndex
    property alias cfg_frameRate: frameRate.value
    ColumnLayout {
        width: page.availableWidth; spacing: 12
        Label { Layout.fillWidth: true; Layout.leftMargin: 16; Layout.topMargin: 12; text: "Animation & performance"; font.bold: true; font.pointSize: 18 }
        Label { Layout.fillWidth: true; Layout.leftMargin: 16; Layout.rightMargin: 16; text: "Control decorative motion across all displays. Pausing animation does not pause usage updates."; wrapMode: Text.WordWrap; opacity: .75 }
        GroupBox {
            title: "Motion"; Layout.fillWidth: true; Layout.leftMargin: 16; Layout.rightMargin: 16
            Kirigami.FormLayout {
                width: parent.width
                CheckBox { id: motionEnabled; text: "Enable animation (master switch)" }
            }
        }
        GroupBox {
            title: "Frame pacing"; Layout.fillWidth: true; Layout.leftMargin: 16; Layout.rightMargin: 16
            Kirigami.FormLayout {
                width: parent.width
                enabled: motionEnabled.checked
                ComboBox { id: frameMode; objectName: "frameMode"; Kirigami.FormData.label: "Animation mode:"; model: ["Balanced — up to 30 fps", "Smooth — up to 60 fps", "Match display", "Custom"]; Layout.preferredWidth: 300; Layout.maximumWidth: 380 }
                SpinBox { id: frameRate; objectName: "customFrameRate"; enabled: frameMode.currentIndex === 3; Kirigami.FormData.label: "Custom frame limit (fps):"; from: 10; to: 240; editable: true }
            }
        }
        GroupBox {
            title: "About these controls"; Layout.fillWidth: true; Layout.leftMargin: 16; Layout.rightMargin: 16
            Kirigami.FormLayout {
                width: parent.width
                Label { Layout.fillWidth: true; text: "Balanced uses up to 30 fps; Smooth up to 60 fps. Match display follows Qt’s frame clock and can use more resources. Fish and water motion are set on Aquarium; Lava and Motorsport motion on Styles. Analytics and Minimal update only when needed."; wrapMode: Text.WordWrap; opacity: .75 }
            }
        }
        Button { Layout.leftMargin: 16; text: "Restore this page’s defaults"; onClicked: { motionEnabled.checked = true; frameMode.currentIndex = 0; frameRate.value = 30 } }
        Item { Layout.preferredHeight: 12 }
    }
}
