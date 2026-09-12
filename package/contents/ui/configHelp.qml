pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "HelpContent.js" as HelpContent

ColumnLayout {
    id: page
    implicitWidth: 640; implicitHeight: 600
    spacing: 12
    readonly property var results: HelpContent.entries.filter(function(entry) {
        var term = search.text.trim().toLowerCase();
        return (section.currentIndex === 0 || entry.section === section.currentText)
            && (!term || (entry.section + " " + entry.title + " " + entry.body).toLowerCase().indexOf(term) !== -1);
    })
    Label { Layout.fillWidth: true; Layout.margins: 12; text: "Tide settings help"; font.bold: true; font.pointSize: 18 }
    Label {
        Layout.fillWidth: true; Layout.leftMargin: 12; Layout.rightMargin: 12
        text: "Offline guide to every option. Search by name or topic, or choose a section."
        wrapMode: Text.WordWrap
    }
    TextField {
        id: search; objectName: "helpSearch"
        Layout.fillWidth: true; Layout.leftMargin: 12; Layout.rightMargin: 12
        placeholderText: "Search help…"; Accessible.name: "Search settings help"
        selectByMouse: true
        onTextChanged: scroll.contentItem.contentY = 0
    }
    RowLayout {
        Layout.fillWidth: true; Layout.leftMargin: 12; Layout.rightMargin: 12
        ComboBox {
            id: section; objectName: "helpSection"
            Layout.fillWidth: true; Accessible.name: "Help section"
            model: ["All sections", "Getting started", "Styles", "Analytics", "Display", "Fonts", "Aquarium", "Animation", "Updates", "About", "Troubleshooting"]
            onCurrentIndexChanged: scroll.contentItem.contentY = 0
        }
        Button { text: "Clear"; enabled: search.text.length > 0 || section.currentIndex !== 0; onClicked: { search.clear(); section.currentIndex = 0; } }
    }
    Label {
        Layout.leftMargin: 12; text: page.results.length ? page.results.length + " topics" : "No matching topics. Try another term or clear the filters."
        Layout.fillWidth: true; Layout.rightMargin: 12; wrapMode: Text.WordWrap
    }
    ScrollView {
        id: scroll
        Layout.fillWidth: true; Layout.fillHeight: true
        clip: true; contentWidth: availableWidth
        ColumnLayout {
            width: scroll.availableWidth; spacing: 18
            Repeater {
                model: page.results
                ColumnLayout {
                    required property var modelData
                    id: topic
                    Layout.fillWidth: true; Layout.leftMargin: 12; Layout.rightMargin: 20; spacing: 6
                    Label { Layout.fillWidth: true; text: topic.modelData.section; opacity: .65; font.pointSize: 9; wrapMode: Text.WordWrap }
                    Label { Layout.fillWidth: true; text: topic.modelData.title; font.bold: true; wrapMode: Text.WordWrap }
                    Label { Layout.fillWidth: true; text: topic.modelData.body; wrapMode: Text.WordWrap; textFormat: Text.PlainText }
                    Rectangle { Layout.fillWidth: true; Layout.topMargin: 8; implicitHeight: 1; color: palette.text; opacity: .15 }
                }
            }
            Item { Layout.preferredHeight: 12 }
        }
    }
}
