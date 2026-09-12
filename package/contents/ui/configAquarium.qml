import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

ScrollView {
    id: page
    implicitWidth: 640; implicitHeight: 600
    clip: true; contentWidth: availableWidth
    property alias cfg_showFish: showFish.checked
    property alias cfg_fishCount: fishCount.value
    property alias cfg_fishScale: fishScale.value
    property alias cfg_fishSpeed: fishSpeed.value
    property alias cfg_fishStyle: fishStyle.currentIndex
    property alias cfg_animateFish: animateFish.checked
    property alias cfg_animateWater: animateWater.checked
    property alias cfg_showBubbles: showBubbles.checked
    property alias cfg_waveStrength: waveStrength.value
    property alias cfg_waterOpacity: waterOpacity.value
    property alias cfg_glassOpacity: glassOpacity.value
    property alias cfg_showRing: showRing.checked
    property alias cfg_glowStrength: glowStrength.value
    ColumnLayout {
        width: page.availableWidth; spacing: 12
        Label { Layout.fillWidth: true; Layout.leftMargin: 16; Layout.topMargin: 12; text: "Aquarium"; font.bold: true; font.pointSize: 18 }
        Label { Layout.fillWidth: true; Layout.leftMargin: 16; Layout.rightMargin: 16; text: "Aquarium fish, water, glass and ring controls. Shared glow, markings and accent colors are on Styles; global motion is on Animation."; wrapMode: Text.WordWrap; opacity: .75 }
        GroupBox {
            title: "Fish"; Layout.fillWidth: true; Layout.leftMargin: 16; Layout.rightMargin: 16
            Kirigami.FormLayout {
                width: parent.width
                CheckBox { id: showFish; text: "Show fish" }
                SpinBox { id: fishCount; enabled: showFish.checked; Kirigami.FormData.label: "Number of fish:"; from: 1; to: 10; editable: true }
                SpinBox { id: fishScale; enabled: showFish.checked; Kirigami.FormData.label: "Fish size (%):"; from: 50; to: 200; editable: true }
                ComboBox { id: fishStyle; enabled: showFish.checked; Kirigami.FormData.label: "Fish colors:"; model: ["Koi — pearl, gold and orange", "Tropical — turquoise and blue", "Silver — natural shoal"]; Layout.preferredWidth: 300; Layout.maximumWidth: 380 }
                CheckBox { id: animateFish; enabled: showFish.checked; text: "Animate swimming and fins" }
                SpinBox { id: fishSpeed; enabled: showFish.checked; Kirigami.FormData.label: "Swimming speed (%):"; from: 20; to: 200; editable: true }
            }
        }
        GroupBox {
            title: "Water"; Layout.fillWidth: true; Layout.leftMargin: 16; Layout.rightMargin: 16
            Kirigami.FormLayout {
                width: parent.width
                CheckBox { id: animateWater; text: "Animate water" }
                CheckBox { id: showBubbles; text: "Show rising bubbles" }
                SpinBox { id: waveStrength; Kirigami.FormData.label: "Wave height (%):"; from: 0; to: 180; editable: true }
            }
        }
        GroupBox {
            title: "Water & glass appearance"; Layout.fillWidth: true; Layout.leftMargin: 16; Layout.rightMargin: 16
            Kirigami.FormLayout {
                width: parent.width
                SpinBox { id: waterOpacity; Kirigami.FormData.label: "Water opacity (%):"; from: 0; to: 100; editable: true }
                SpinBox { id: glassOpacity; Kirigami.FormData.label: "Glass shading (%):"; from: 0; to: 100; editable: true }
            }
        }
        GroupBox {
            title: "Aquarium accents"; Layout.fillWidth: true; Layout.leftMargin: 16; Layout.rightMargin: 16
            Kirigami.FormLayout {
                width: parent.width
                CheckBox { id: showRing; text: "Show the outer progress ring" }
                SpinBox { id: glowStrength;  Kirigami.FormData.label: "Glow intensity (%):"; from: 0; to: 100; editable: true }
            }
        }
        Button { Layout.leftMargin: 16; text: "Restore this page’s defaults"; onClicked: { waterOpacity.value = 35; glassOpacity.value = 0; showRing.checked = true; glowStrength.value = 60;  showFish.checked = true; fishCount.value = 3; fishScale.value = 125; fishSpeed.value = 80; fishStyle.currentIndex = 0; animateFish.checked = true; animateWater.checked = true; showBubbles.checked = true; waveStrength.value = 100 } }
        Item { Layout.preferredHeight: 12 }
    }
}
