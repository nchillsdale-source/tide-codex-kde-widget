import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ScrollView {
    id: page
    implicitWidth: 620; implicitHeight: 560
    clip: true; contentWidth: availableWidth
    ColumnLayout {
        width: page.availableWidth; spacing: 16
        Label { Layout.margins: 16; text: "Tide"; font.pointSize: 24 }
        Label { Layout.leftMargin: 16; text: "Version 1.5.1" }
        Label { Layout.leftMargin: 16; text: "Author: Nicholas Hillsdale" }
        Label {
            Layout.fillWidth: true; Layout.margins: 16; wrapMode: Text.WordWrap
            text: "A customizable desktop meter for Codex & Work usage: aquarium, lava chamber, analytics and motorsport styles, with custom fonts and display-synced animation."
        }
        Label {
            Layout.fillWidth: true; Layout.margins: 16; wrapMode: Text.WordWrap
            text: "Uses your own Codex sign-in. Ordinary ChatGPT conversations are not included. Tide does not create model turns, buy credits or consume usage resets."
        }
        Label { Layout.leftMargin: 16; text: "License: MIT" }
        Label {
            Layout.fillWidth: true; Layout.margins: 16; wrapMode: Text.WordWrap
            text: "After installing an update, press Alt+Space and run plasmashell --replace to reload Plasma’s cached widget code. Your desktop and panels will briefly reload."
        }
    }
}
