import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

ScrollView {
    id: page
    implicitWidth: 620; implicitHeight: 640
    clip: true; contentWidth: availableWidth
    property alias cfg_displayStyle: styleChoice.currentIndex
    property alias cfg_styleAnimate: motion.checked
    property alias cfg_styleSpeed: speed.value
    property alias cfg_styleOpacity: opacityControl.value
    property alias cfg_styleDetail: detail.checked
    property alias cfg_carColor: carColor.currentIndex
    ColumnLayout {
        width: page.availableWidth; spacing: 12
        Label { Layout.fillWidth: true; Layout.margins: 12; wrapMode: Text.WordWrap; text: "Choose a display for the same live Codex & Work allowance. All styles support meter-only mode, fonts, text visibility and animation frame modes." }
        Kirigami.FormLayout {
            Layout.fillWidth: true; Layout.margins: 12
            ComboBox { id: styleChoice; objectName: "styleChoice"; Kirigami.FormData.label: "Display style:"; model: ["Aquarium", "Lava chamber", "Analytics", "Motorsport"]; Layout.preferredWidth: 280 }
            CheckBox { id: motion; enabled: styleChoice.currentIndex === 1 || styleChoice.currentIndex === 3; text: "Animate this style" }
            SpinBox { id: speed; enabled: styleChoice.currentIndex === 1 || styleChoice.currentIndex === 3; Kirigami.FormData.label: "Animation speed (%):"; from: 20; to: 200; editable: true }
            SpinBox { id: opacityControl; enabled: styleChoice.currentIndex === 1 || styleChoice.currentIndex === 3; Kirigami.FormData.label: "Surface opacity (%):"; from: 20; to: 100; editable: true }
            CheckBox { id: detail; enabled: styleChoice.currentIndex === 1 || styleChoice.currentIndex === 3; text: "Show texture and small details" }
            ComboBox { id: carColor; objectName: "carColor"; enabled: styleChoice.currentIndex === 3; Kirigami.FormData.label: "Race car color:"; model: ["Racing red", "Papaya orange", "Electric blue", "Silver", "Emerald green"]; Layout.preferredWidth: 280 }
        }
        Label {
            Layout.fillWidth: true; Layout.margins: 12; wrapMode: Text.WordWrap
            text: ["Aquarium: remaining allowance sets the water level. Fish and water options are on the Aquarium tab.", "Lava chamber: remaining allowance sets the molten lava level. Crust and embers animate inside the chamber.", "Analytics: current quota bars and a session trend from successful updates. History starts when this widget opens; the line appears after 8 readings. Reset windows are kept separate.", "Motorsport: the inner fuel-style gauge shows remaining allowance. The open-wheel car laps the circuit independently of usage."][styleChoice.currentIndex] || ""
        }
        Label { Layout.alignment: Qt.AlignHCenter; text: "Style preview · sample 72% remaining" }
        LiquidOrb {
            visible: styleChoice.currentIndex !== 2
            Layout.alignment: Qt.AlignHCenter; Layout.preferredWidth: 220; Layout.preferredHeight: 220
            value: 0.72; hasData: true
            displayStyle: styleChoice.currentIndex; styleAnimate: motion.checked
            styleSpeed: speed.value/100; styleOpacity: opacityControl.value/100; styleDetail: detail.checked
            raceColor: ["#ef4b4b", "#ff9b45", "#5cadff", "#dae4eb", "#40ca98"][carColor.currentIndex] || "#ef4b4b"
            frameMode: 0
        }
        Rectangle {
            visible: styleChoice.currentIndex === 2
            Layout.fillWidth: true; Layout.margins: 20; Layout.preferredHeight: 340; color: "#111d2b"; radius: 8
            AnalyticsView {
            anchors.fill: parent; anchors.margins: 15
            selected: ({name:"Codex & Work",window:"Weekly",remaining:72})
            windows: [{name:"Codex & Work",window:"Weekly",remaining:72},{name:"Spark",window:"5-hour",remaining:96}]
            series: [{time:1000,remaining:94},{time:1180,remaining:92},{time:1360,remaining:88},{time:1540,remaining:85},{time:1720,remaining:82},{time:1900,remaining:78},{time:2080,remaining:75},{time:2260,remaining:72}]
            }
        }
        Button {
            Layout.leftMargin: 12; text: "Restore style defaults"
            onClicked: { styleChoice.currentIndex = 0; motion.checked = true; speed.value = 100; opacityControl.value = 85; detail.checked = true; carColor.currentIndex = 0; }
        }
    }
}
