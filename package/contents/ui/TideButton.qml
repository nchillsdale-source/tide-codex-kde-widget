import QtQuick
import QtQuick.Controls
import org.kde.kirigami as Kirigami
ToolButton {
    id: control
    property font textFont: Kirigami.Theme.defaultFont
    implicitWidth: 28; implicitHeight: 28
    contentItem: TideText {
        baseFont: control.textFont
        text: control.text; color: control.enabled ? "#9cd9df" : "#506779"
        sizeScale: 1.425; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
    }
    background: Rectangle { radius: 7; color: control.hovered ? "#253d50" : "transparent" }
}
