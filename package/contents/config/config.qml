import org.kde.plasma.configuration
ConfigModel {
    ConfigCategory { name: "Styles"; icon: "preferences-desktop-theme"; source: "configStyles.qml" }
    ConfigCategory { name: "Display"; icon: "view-visible"; source: "configDisplay.qml" }
    ConfigCategory { name: "Fonts"; icon: "preferences-desktop-font"; source: "configFonts.qml" }
    ConfigCategory { name: "Aquarium"; icon: "applications-science"; source: "configAquarium.qml" }
    ConfigCategory { name: "Appearance"; icon: "preferences-desktop-color"; source: "configAppearance.qml" }
    ConfigCategory { name: "Updates"; icon: "view-refresh"; source: "configUpdates.qml" }
    ConfigCategory { name: "Help"; icon: "help-contents"; source: "configHelp.qml" }
    ConfigCategory { name: "About"; icon: "help-about"; source: "configAbout.qml" }
}
