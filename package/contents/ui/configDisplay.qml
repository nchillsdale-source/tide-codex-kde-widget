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
    ColumnLayout {
        width: page.availableWidth
        spacing: 12
        Label { Layout.fillWidth: true; Layout.margins: 12; text: "Meter-only mode keeps only the selected meter. Right-click the widget to reopen settings. Hidden connection and quota information remains available in the hover tooltip."; wrapMode: Text.WordWrap }
        Kirigami.FormLayout {
            Layout.fillWidth: true
            Layout.margins: 12
        CheckBox { id: meterOnly; text: "Meter only — hide all text and controls" }
        CheckBox { id: showHeader; text: "Show Tide title and product name" }
        CheckBox { id: showStatus; text: "Show connection status" }
        CheckBox { id: showPercentage; text: "Show percentage inside the meter" }
        CheckBox { id: showRemaining; text: "Show “Remaining” caption" }
        CheckBox { id: showExtraLimits; text: "Show additional allowance bars" }
        CheckBox { id: showCredits; text: "Show credits and reset credits" }
        CheckBox { id: showResetTime; text: "Show reset countdown" }
        CheckBox { id: showUpdated; text: "Show last update time" }
        CheckBox { id: showButtons; text: "Show action buttons" }
        CheckBox { id: showScopeNote; text: "Show usage scope note" }
        CheckBox { id: showErrors; text: "Show connection error text" }
        SpinBox { id: textScale; Kirigami.FormData.label: "Text scale (% of chosen font):"; from: 70; to: 160; editable: true }
        }
        Button { Layout.leftMargin: 12; text: "Restore this page’s defaults"; onClicked: { meterOnly.checked = false; showHeader.checked = true; showStatus.checked = true; showPercentage.checked = true; showRemaining.checked = true; showExtraLimits.checked = true; showCredits.checked = true; showResetTime.checked = true; showUpdated.checked = true; showButtons.checked = true; showScopeNote.checked = true; showErrors.checked = true; textScale.value = 100 } }
    }
}
