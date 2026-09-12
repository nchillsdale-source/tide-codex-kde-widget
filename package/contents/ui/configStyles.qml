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
    property alias cfg_palette: palette.currentIndex
    property alias cfg_warningColors: warningColors.checked
    property alias cfg_showTicks: showTicks.checked
    property alias cfg_showGlow: showGlow.checked
    property bool cfg_meterOnly: false
    property bool cfg_showLocalTokens: true
    property bool cfg_showHeader: true
    property bool cfg_showStatus: true
    property bool cfg_showPercentage: true
    property bool cfg_showRemaining: true
    property bool cfg_showExtraLimits: true
    property bool cfg_showCredits: true
    property bool cfg_showResetTime: true
    property bool cfg_showUpdated: true
    property bool cfg_showButtons: true
    property bool cfg_showScopeNote: true
    property bool cfg_showErrors: true
    property int cfg_textScale: 100
    property bool cfg_showFish: true
    property int cfg_fishCount: 3
    property int cfg_fishScale: 125
    property int cfg_fishSpeed: 80
    property int cfg_fishStyle: 0
    property bool cfg_animateFish: true
    property bool cfg_animateWater: true
    property bool cfg_showBubbles: true
    property int cfg_waveStrength: 100
    property int cfg_frameMode: 0
    property int cfg_frameRate: 30
    property bool cfg_showRing: true
    property int cfg_glowStrength: 60
    property int cfg_waterOpacity: 35
    property int cfg_glassOpacity: 0
    property int cfg_backgroundOpacity: 0
    property int cfg_refreshMinutes: 3
    property int cfg_mainWindow: 0
    property bool cfg_motionEnabled: true
    property bool cfg_useCustomFont: false
    property string cfg_fontFamily: ""
    property int cfg_fontSize: 10
    property int cfg_fontWeight: 400
    property bool cfg_fontItalic: false
    property string cfg_fontStyle: ""
    readonly property var previewSettings: ({meterOnly: page.cfg_meterOnly, showLocalTokens: page.cfg_showLocalTokens, showHeader: page.cfg_showHeader, showStatus: page.cfg_showStatus, showPercentage: page.cfg_showPercentage, showRemaining: page.cfg_showRemaining, showExtraLimits: page.cfg_showExtraLimits, showCredits: page.cfg_showCredits, showResetTime: page.cfg_showResetTime, showUpdated: page.cfg_showUpdated, showButtons: page.cfg_showButtons, showScopeNote: page.cfg_showScopeNote, showErrors: page.cfg_showErrors, textScale: page.cfg_textScale, showFish: page.cfg_showFish, fishCount: page.cfg_fishCount, fishScale: page.cfg_fishScale, fishSpeed: page.cfg_fishSpeed, fishStyle: page.cfg_fishStyle, animateFish: page.cfg_animateFish, animateWater: page.cfg_animateWater, showBubbles: page.cfg_showBubbles, waveStrength: page.cfg_waveStrength, frameMode: page.cfg_frameMode, frameRate: page.cfg_frameRate, palette: page.cfg_palette, warningColors: page.cfg_warningColors, showRing: page.cfg_showRing, showTicks: page.cfg_showTicks, showGlow: page.cfg_showGlow, glowStrength: page.cfg_glowStrength, waterOpacity: page.cfg_waterOpacity, glassOpacity: page.cfg_glassOpacity, backgroundOpacity: page.cfg_backgroundOpacity, refreshMinutes: page.cfg_refreshMinutes, mainWindow: page.cfg_mainWindow, motionEnabled: page.cfg_motionEnabled, useCustomFont: page.cfg_useCustomFont, fontFamily: page.cfg_fontFamily, fontSize: page.cfg_fontSize, fontWeight: page.cfg_fontWeight, fontItalic: page.cfg_fontItalic, fontStyle: page.cfg_fontStyle, displayStyle: page.cfg_displayStyle, styleAnimate: page.cfg_styleAnimate, styleSpeed: page.cfg_styleSpeed, styleOpacity: page.cfg_styleOpacity, styleDetail: page.cfg_styleDetail, carColor: page.cfg_carColor})
    readonly property real previewScale: Math.max(1, cfg_textScale/100) * Math.max(1, cfg_useCustomFont ? cfg_fontSize/10 : 1)
    ColumnLayout {
        width: page.availableWidth; spacing: 12
        Label { Layout.leftMargin: 16; Layout.topMargin: 12; text: "Display style"; font.bold: true; font.pointSize: 18 }
        Label { Layout.fillWidth: true; Layout.margins: 12; wrapMode: Text.WordWrap; text: "Choose a display for the same live Codex & Work allowance. Use Display for text and panel transparency, Aquarium for water and fish, and Animation for global motion." }
        Kirigami.FormLayout {
            Layout.fillWidth: true; Layout.margins: 12
            ComboBox { id: styleChoice; objectName: "styleChoice"; Kirigami.FormData.label: "Display style:"; model: ["Aquarium", "Lava chamber", "Analytics", "Motorsport", "Minimal"]; Layout.preferredWidth: 280 }
            Label { Kirigami.FormData.isSection: true; text: "Style details"; font.bold: true }
            CheckBox { id: motion; enabled: styleChoice.currentIndex === 1 || styleChoice.currentIndex === 3; text: "Animate this style" }
            SpinBox { id: speed; enabled: styleChoice.currentIndex === 1 || styleChoice.currentIndex === 3; Kirigami.FormData.label: "Animation speed (%):"; from: 20; to: 200; editable: true }
            SpinBox { id: opacityControl; enabled: styleChoice.currentIndex === 1 || styleChoice.currentIndex === 3; Kirigami.FormData.label: "Surface opacity (%):"; from: 20; to: 100; editable: true }
            CheckBox { id: detail; enabled: styleChoice.currentIndex === 1 || styleChoice.currentIndex === 3; text: "Show texture and small details" }
            ComboBox { id: carColor; objectName: "carColor"; enabled: styleChoice.currentIndex === 3; Kirigami.FormData.label: "Race car color:"; model: ["Racing red", "Papaya orange", "Electric blue", "Silver", "Emerald green"]; Layout.preferredWidth: 280 }
        }
        Label {
            Layout.fillWidth: true; Layout.margins: 12; wrapMode: Text.WordWrap
            text: ["Aquarium: remaining allowance sets the water level. Fish and water options are on the Aquarium tab.", "Lava chamber: remaining allowance sets the molten lava level. Crust and embers animate inside the chamber.", "Analytics: current quota bars and a session trend from successful updates. History starts when this widget opens; the line appears after 8 readings. Reset windows are kept separate.", "Motorsport: the inner fuel-style gauge shows remaining allowance. The open-wheel car laps the circuit independently of usage.", "Minimal: compact percentage, a slim quota bar, and reset/update times. No decorative motion, secondary bars or action buttons; hover for connection details."][styleChoice.currentIndex] || ""
        }
        CheckBox { id: previewToggle; objectName: "previewToggle"; Layout.leftMargin: 16; text: "Show live preview (sample data)"; checked: false }
        RowLayout {
            visible: previewToggle.checked
            Layout.leftMargin: 16
            Label { text: "Sample allowance remaining (%):" }
            SpinBox { id: sampleRemaining; objectName: "sampleRemaining"; from: 0; to: 100; value: 72; editable: true }
        }
        Label {
            visible: previewToggle.checked; Layout.fillWidth: true; Layout.margins: 16; wrapMode: Text.WordWrap; opacity: .75
            text: "Changes on this page preview immediately. Apply changes on other pages, then return here to preview them. Sample controls do not change your account data or saved settings."
        }
        Rectangle {
            visible: previewToggle.checked
            Layout.fillWidth: true; Layout.margins: 16
            Layout.preferredHeight: Math.min(650, preview.height + 24)
            color: "#162331"; radius: 8; clip: true
            Dashboard {
                id: preview; objectName: "stylePreview"
                anchors.centerIn: parent
                width: 360*page.previewScale
                height: (page.cfg_meterOnly ? (page.cfg_displayStyle === 4 ? 30 : 300) : page.cfg_displayStyle === 4 ? (page.cfg_showLocalTokens ? 240 : 130) : page.cfg_displayStyle === 2 ? (page.cfg_showLocalTokens ? 810 : 540) : (page.cfg_showLocalTokens ? 610 : 500))*page.previewScale
                scale: Math.min(1,(parent.width-24)/width,(parent.height-24)/height)
                settings: page.previewSettings
                advanceClock: false
                now: 1789242000
                snapshot: ({updatedAt:1789242000, credits:0, resetCredits:0, windows:[
                    {id:"codex/week",main:true,name:"Codex & Work",window:"Weekly",remaining:sampleRemaining.value,resetsAt:1789642000},
                    {id:"spark/short",name:"Spark",window:"5-hour",remaining:96,resetsAt:1789252000}
                ]})
                localTokens: ({available:true,updatedAt:1789242000,today:{total_tokens:125000,input_tokens:100000,cached_input_tokens:80000,output_tokens:25000,reasoning_output_tokens:5000},rate:800,rates:[100,600,300,800,1200,500,300,600,900,1000,600,800]})
                // The embedded preview is visual only; its buttons never run account actions.
                enabled: false
            }
        }
        GroupBox {
            title: "Shared colors & effects"; Layout.fillWidth: true; Layout.leftMargin: 16; Layout.rightMargin: 16
            Kirigami.FormLayout {
                width: parent.width
                ComboBox { id: palette; Kirigami.FormData.label: "Accent palette:"; model: ["Lagoon cyan", "Ocean blue", "Aurora violet", "Sunset coral", "KDE highlight color"]; Layout.preferredWidth: 300; Layout.maximumWidth: 380 }
                CheckBox { id: warningColors; text: "Change color when remaining allowance is low" }
                CheckBox { id: showTicks; text: "Show decorative scale markings" }
                CheckBox { id: showGlow; text: "Show glow around the meter" }
            }
        }
        Label { Layout.fillWidth: true; Layout.margins: 16; wrapMode: Text.WordWrap; opacity: .75; text: "Palette and low-allowance colors affect shared accents. Glow and scale markings apply where supported; Analytics and Minimal keep their clean styling. Aquarium water, glass and ring controls are on Aquarium." }
        Button {
            Layout.leftMargin: 12; text: "Restore style defaults"
            onClicked: { palette.currentIndex = 0; warningColors.checked = true; showTicks.checked = true; showGlow.checked = true;  styleChoice.currentIndex = 0; motion.checked = true; speed.value = 100; opacityControl.value = 85; detail.checked = true; carColor.currentIndex = 0; }
        }
    }
}
