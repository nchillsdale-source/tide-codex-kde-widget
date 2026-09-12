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
    property alias cfg_palette: palette.currentIndex
    property alias cfg_warningColors: warningColors.checked
    property alias cfg_showRing: showRing.checked
    property alias cfg_showTicks: showTicks.checked
    property alias cfg_showGlow: showGlow.checked
    property alias cfg_glowStrength: glowStrength.value
    property alias cfg_waterOpacity: waterOpacity.value
    property alias cfg_glassOpacity: glassOpacity.value
    property alias cfg_backgroundOpacity: backgroundOpacity.value
    ColumnLayout {
        width: page.availableWidth
        spacing: 12
        Label { Layout.fillWidth: true; Layout.margins: 12; text: "The background is transparent at 0%. Low allowance colors use amber below 25% and coral below 10%."; wrapMode: Text.WordWrap }
        Kirigami.FormLayout {
            Layout.fillWidth: true
            Layout.margins: 12
        ComboBox { id: palette; Kirigami.FormData.label: "Water palette:"; model: ["Lagoon cyan", "Ocean blue", "Aurora violet", "Sunset coral", "KDE highlight color"]; Layout.preferredWidth: 300; Layout.maximumWidth: 380 }
        CheckBox { id: warningColors; text: "Change color when remaining allowance is low" }
        CheckBox { id: showRing; text: "Show the outer progress ring" }
        CheckBox { id: showTicks; text: "Show scale markings" }
        CheckBox { id: showGlow; text: "Show glow around the meter" }
        SpinBox { id: glowStrength; Kirigami.FormData.label: "Glow intensity (%):"; from: 0; to: 100; editable: true }
        SpinBox { id: waterOpacity; Kirigami.FormData.label: "Water opacity (%):"; from: 0; to: 100; editable: true }
        SpinBox { id: glassOpacity; Kirigami.FormData.label: "Glass shading (%):"; from: 0; to: 100; editable: true }
        SpinBox { id: backgroundOpacity; Kirigami.FormData.label: "Background panel opacity (%):"; from: 0; to: 100; editable: true }
        }
        Button { Layout.leftMargin: 12; text: "Restore this page’s defaults"; onClicked: { palette.currentIndex = 0; warningColors.checked = true; showRing.checked = true; showTicks.checked = true; showGlow.checked = true; glowStrength.value = 60; waterOpacity.value = 35; glassOpacity.value = 0; backgroundOpacity.value = 0 } }
    }
}
