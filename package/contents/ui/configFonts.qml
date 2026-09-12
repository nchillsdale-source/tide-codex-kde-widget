import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import org.kde.kirigami as Kirigami
import "Typography.js" as Typography

ScrollView {
    id: page
    implicitWidth: 620; implicitHeight: 560
    clip: true; contentWidth: availableWidth
    property alias cfg_useCustomFont: custom.checked
    property string cfg_fontFamily: ""
    property alias cfg_fontSize: fontSize.value
    property int cfg_fontWeight: 400
    property bool cfg_fontItalic: false
    property string cfg_fontStyle: ""
    readonly property font previewFont: Typography.resolve({useCustomFont: cfg_useCustomFont, fontFamily: cfg_fontFamily, fontSize: cfg_fontSize, fontWeight: cfg_fontWeight, fontItalic: cfg_fontItalic, fontStyle: cfg_fontStyle}, Kirigami.Theme.defaultFont)
    FontDialog {
        id: picker
        objectName: "fontPicker"
        title: "Choose Tide’s font"
        onAccepted: {
            page.cfg_fontFamily = selectedFont.family;
            page.cfg_fontSize = Math.max(6, Math.min(48, Math.round(selectedFont.pointSize)));
            page.cfg_fontWeight = selectedFont.weight;
            page.cfg_fontItalic = selectedFont.italic;
            page.cfg_fontStyle = selectedFont.styleName;
        }
    }
    ColumnLayout {
        width: page.availableWidth; spacing: 18
        Label {
            Layout.fillWidth: true; Layout.margins: 12; wrapMode: Text.WordWrap
            text: "By default Tide follows KDE’s system font. A custom font applies only to this widget. The Display tab’s text scaling still applies on top of the selected base size."
        }
        Kirigami.FormLayout {
            Layout.fillWidth: true; Layout.margins: 12
            CheckBox { id: custom; text: "Use a custom font" }
            Button {
                objectName: "chooseFontButton"
                enabled: custom.checked
                Kirigami.FormData.label: "Font family and style:"
                text: "Choose font…"
                onClicked: { picker.selectedFont = page.previewFont; picker.open(); }
            }
            Label {
                Layout.maximumWidth: 380; wrapMode: Text.WordWrap
                text: page.previewFont.family + (page.previewFont.styleName ? " · " + page.previewFont.styleName : "")
            }
            SpinBox { id: fontSize; enabled: custom.checked; Kirigami.FormData.label: "Base size (pt):"; from: 6; to: 48; value: 10; editable: true }
        }
        Label { Layout.leftMargin: 12; text: "Preview" }
        Label {
            objectName: "fontPreview"
            Layout.fillWidth: true; Layout.margins: 12; wrapMode: Text.WordWrap
            text: "Tide · 72% remaining\nResets in 4d 17h · Updated 11:35"
            font: page.previewFont
        }
        Button {
            Layout.leftMargin: 12; text: "Restore KDE font defaults"
            onClicked: { page.cfg_useCustomFont = false; page.cfg_fontFamily = ""; page.cfg_fontSize = 10; page.cfg_fontWeight = 400; page.cfg_fontItalic = false; page.cfg_fontStyle = ""; }
        }
    }
}
