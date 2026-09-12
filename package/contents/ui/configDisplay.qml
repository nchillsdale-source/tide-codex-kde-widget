import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

ScrollView {
    id: page
    implicitWidth: 640; implicitHeight: 600
    clip: true; contentWidth: availableWidth
    property alias cfg_meterOnly: meterOnly.checked
    property alias cfg_showHeader: showHeader.checked
    property alias cfg_showStatus: showStatus.checked
    property alias cfg_showPercentage: showPercentage.checked
    property alias cfg_showRemaining: showRemaining.checked
    property alias cfg_showExtraLimits: showExtraLimits.checked
    property alias cfg_showCredits: showCredits.checked
    property alias cfg_showResetTime: showResetTime.checked
    property alias cfg_showUpdated: showUpdated.checked
    property alias cfg_showButtons: showButtons.checked
    property alias cfg_showScopeNote: showScopeNote.checked
    property alias cfg_showErrors: showErrors.checked
    property alias cfg_textScale: textScale.value
    property alias cfg_backgroundOpacity: backgroundOpacity.value
    ColumnLayout {
        width: page.availableWidth; spacing: 12
        Label { Layout.fillWidth: true; Layout.leftMargin: 16; Layout.topMargin: 12; text: "Display & text"; font.bold: true; font.pointSize: 18 }
        Label { Layout.fillWidth: true; Layout.leftMargin: 16; Layout.rightMargin: 16; text: "Choose what stays visible. Meter-only mode overrides text options without changing their saved values."; wrapMode: Text.WordWrap; opacity: .75 }
        GroupBox {
            title: "Layout"; Layout.fillWidth: true; Layout.leftMargin: 16; Layout.rightMargin: 16
            Kirigami.FormLayout {
                width: parent.width
                CheckBox { id: meterOnly; text: "Meter only — hide all text and controls" }
                SpinBox { id: textScale; Kirigami.FormData.label: "Text scale (% of chosen font):"; from: 70; to: 160; editable: true }
            }
        }
        GroupBox {
            title: "Main readout"; Layout.fillWidth: true; Layout.leftMargin: 16; Layout.rightMargin: 16
            GridLayout {
                columns: page.availableWidth >= 600 ? 2 : 1; columnSpacing: 20; rowSpacing: 2; width: parent.width
                enabled: !meterOnly.checked
                CheckBox { id: showHeader; objectName: "showHeader"; text: "Title and product name" }
                CheckBox { id: showStatus; objectName: "showStatus"; text: "Connection status" }
                CheckBox { id: showPercentage; objectName: "showPercentage"; text: "Percentage" }
                CheckBox { id: showRemaining; objectName: "showRemaining"; text: "Remaining caption" }
            }
        }
        GroupBox {
            title: "Details & controls"; Layout.fillWidth: true; Layout.leftMargin: 16; Layout.rightMargin: 16
            GridLayout {
                columns: page.availableWidth >= 600 ? 2 : 1; columnSpacing: 20; rowSpacing: 2; width: parent.width
                enabled: !meterOnly.checked
                CheckBox { id: showExtraLimits; objectName: "showExtraLimits"; text: "Additional allowance bars" }
                CheckBox { id: showCredits; objectName: "showCredits"; text: "Credits and reset credits" }
                CheckBox { id: showResetTime; objectName: "showResetTime"; text: "Reset countdown" }
                CheckBox { id: showUpdated; objectName: "showUpdated"; text: "Last update time" }
                CheckBox { id: showButtons; objectName: "showButtons"; text: "Action buttons" }
                CheckBox { id: showScopeNote; objectName: "showScopeNote"; text: "Usage scope note" }
                CheckBox { id: showErrors; objectName: "showErrors"; text: "Connection error text" }
            }
        }
        GroupBox {
            title: "Widget background"; Layout.fillWidth: true; Layout.leftMargin: 16; Layout.rightMargin: 16
            Kirigami.FormLayout {
                width: parent.width
                SpinBox { id: backgroundOpacity; Kirigami.FormData.label: "Background panel opacity (%):"; from: 0; to: 100; editable: true }
            }
        }
        Button { Layout.leftMargin: 16; text: "Restore this page’s defaults"; onClicked: { backgroundOpacity.value = 0;  meterOnly.checked = false; showHeader.checked = true; showStatus.checked = true; showPercentage.checked = true; showRemaining.checked = true; showExtraLimits.checked = true; showCredits.checked = true; showResetTime.checked = true; showUpdated.checked = true; showButtons.checked = true; showScopeNote.checked = true; showErrors.checked = true; textScale.value = 100 } }
        Item { Layout.preferredHeight: 12 }
    }
}
