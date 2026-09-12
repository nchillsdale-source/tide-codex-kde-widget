import QtQuick
import org.kde.kirigami as Kirigami

Text {
    property real sizeScale: 1
    property font baseFont: Kirigami.Theme.defaultFont
    // Bind to the live KDE theme rather than the process's startup font.
    font.family: baseFont.family
    font.pointSize: baseFont.pointSize * sizeScale
    font.weight: baseFont.weight
    font.italic: baseFont.italic
    font.styleName: baseFont.styleName
    style: Text.Raised
    styleColor: "#90071420"
}
