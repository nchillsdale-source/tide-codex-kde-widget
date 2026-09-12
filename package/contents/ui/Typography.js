.pragma library
function resolve(settings, fallback) {
    if (!settings || !settings.useCustomFont) return fallback;
    return Qt.font({
        family: settings.fontFamily || fallback.family,
        pointSize: Math.max(6, Math.min(48, settings.fontSize || fallback.pointSize)),
        weight: settings.fontWeight === undefined ? fallback.weight : settings.fontWeight,
        italic: !!settings.fontItalic,
        styleName: settings.fontStyle || ""
    });
}
