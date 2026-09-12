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
    property alias cfg_showFish: showFish.checked
    property alias cfg_fishCount: fishCount.value
    property alias cfg_fishScale: fishScale.value
    property alias cfg_fishSpeed: fishSpeed.value
    property alias cfg_fishStyle: fishStyle.currentIndex
    property alias cfg_animateFish: animateFish.checked
    property alias cfg_animateWater: animateWater.checked
    property alias cfg_showBubbles: showBubbles.checked
    property alias cfg_waveStrength: waveStrength.value
    property alias cfg_frameMode: frameMode.currentIndex
    property alias cfg_frameRate: frameRate.value
    ColumnLayout {
        width: page.availableWidth
        spacing: 12
        Label { Layout.fillWidth: true; Layout.margins: 12; text: "Fish use shaded bodies, fins, gills and scales. They get smaller in shallow water and disappear if there is not enough room. Balanced limits drawing to 30 fps; Smooth to 60 fps. Match display draws on every Qt animation frame and can use more resources on high-refresh displays."; wrapMode: Text.WordWrap }
        Kirigami.FormLayout {
            Layout.fillWidth: true
            Layout.margins: 12
        CheckBox { id: showFish; text: "Show fish" }
        SpinBox { id: fishCount; Kirigami.FormData.label: "Number of fish:"; from: 1; to: 10; editable: true }
        SpinBox { id: fishScale; Kirigami.FormData.label: "Fish size (%):"; from: 50; to: 200; editable: true }
        SpinBox { id: fishSpeed; Kirigami.FormData.label: "Swimming speed (%):"; from: 20; to: 200; editable: true }
        ComboBox { id: fishStyle; Kirigami.FormData.label: "Fish colors:"; model: ["Koi — pearl, gold and orange", "Tropical — turquoise and blue", "Silver — natural shoal"]; Layout.preferredWidth: 300; Layout.maximumWidth: 380 }
        CheckBox { id: animateFish; text: "Animate swimming and fins" }
        CheckBox { id: animateWater; text: "Animate water" }
        CheckBox { id: showBubbles; text: "Show rising bubbles" }
        SpinBox { id: waveStrength; Kirigami.FormData.label: "Wave height (%):"; from: 0; to: 180; editable: true }
        ComboBox { id: frameMode; objectName: "frameMode"; Kirigami.FormData.label: "Animation mode:"; model: ["Balanced — up to 30 fps", "Smooth — up to 60 fps", "Match display", "Custom"]; Layout.preferredWidth: 300; Layout.maximumWidth: 380 }
        SpinBox { id: frameRate; objectName: "customFrameRate"; enabled: frameMode.currentIndex === 3; Kirigami.FormData.label: "Custom frame limit (fps):"; from: 10; to: 240; editable: true }
        }
        Button { Layout.leftMargin: 12; text: "Restore this page’s defaults"; onClicked: { showFish.checked = true; fishCount.value = 3; fishScale.value = 125; fishSpeed.value = 80; fishStyle.currentIndex = 0; animateFish.checked = true; animateWater.checked = true; showBubbles.checked = true; waveStrength.value = 100; frameMode.currentIndex = 0; frameRate.value = 30 } }
    }
}
