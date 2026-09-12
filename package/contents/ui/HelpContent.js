.pragma library
var entries = [
  {
    "section": "Getting started",
    "title": "Using settings",
    "body": "Right-click Tide and choose Configure Tide / Tide Settings. Choose a page on the left, make changes, then use Apply or OK to save. Settings belong to this widget instance. Restore defaults buttons reset only their page; save with Apply or OK. Help is available offline. Search below by option name or topic, or select a section.",
    "keys": []
  },
  {
    "section": "Getting started",
    "title": "What the numbers mean",
    "body": "All percentages mean allowance remaining, not allowance used. Tide reads the shared Codex & Work quota through your existing Codex sign-in. Ordinary ChatGPT conversations are not included. Other reported buckets, such as Spark, have their own allowance bars. The reader does not send model prompts, buy credits or redeem resets.",
    "keys": []
  },
  {
    "section": "Styles",
    "title": "Display style",
    "body": "Default: Aquarium. Aquarium uses the water level to show remaining allowance. Lava chamber uses the molten fill level. Analytics uses a session graph and quota bars. Motorsport uses the inner fuel-style gauge; the car’s position is decorative and does not measure usage. Switching styles preserves the other settings. The settings preview uses illustrative sample data.",
    "keys": [
      "displayStyle"
    ]
  },
  {
    "section": "Styles",
    "title": "Animate this style",
    "body": "Default: on. Enables lava motion or the moving race car. Available only for Lava chamber and Motorsport. The master animation switch in Updates must also be on. Aquarium has separate water and fish controls. Analytics redraws when data changes and does not need continuous animation.",
    "keys": [
      "styleAnimate"
    ]
  },
  {
    "section": "Styles",
    "title": "Animation speed (%)",
    "body": "20–200%; default 100%. Adjusts lava or car motion, not the usage refresh interval. Higher numbers mean faster motion. Aquarium swimming speed is configured separately.",
    "keys": [
      "styleSpeed"
    ]
  },
  {
    "section": "Styles",
    "title": "Surface opacity (%)",
    "body": "20–100%; default 85%. Controls the styled surfaces in Lava chamber and Motorsport. Lower values reveal more of the wallpaper. For aquarium water, use Appearance → Water opacity; for the entire panel background, use Background panel opacity.",
    "keys": [
      "styleOpacity"
    ]
  },
  {
    "section": "Styles",
    "title": "Show texture and small details",
    "body": "Default: on. Adds decorative details to Lava chamber and Motorsport. Turn it off for a simpler appearance. This does not affect quota values.",
    "keys": [
      "styleDetail"
    ]
  },
  {
    "section": "Styles",
    "title": "Race car color",
    "body": "Default: Racing red. Choose Racing red, Papaya orange, Electric blue, Silver or Emerald green. This option is available only for Motorsport.",
    "keys": [
      "carColor"
    ]
  },
  {
    "section": "Analytics",
    "title": "Reading the graph",
    "body": "The vertical axis runs from 0% to 100% remaining; the horizontal axis uses local time. Points are successful readings from the selected allowance during this widget session. After eight readings, a line connects nearby points. At the default three-minute refresh interval, eight readings take about 21 minutes after the first successful reading. Unchanged values produce a flat trend, not an error.",
    "keys": []
  },
  {
    "section": "Analytics",
    "title": "History, gaps and resets",
    "body": "History holds up to 480 snapshots in memory and is cleared when the widget reloads. It does not download earlier activity or write usage-history files. A quota reset starts a separate series. Switching the main allowance selects that window’s recorded samples. Long gaps stay unconnected. Failed reads do not create points. The allowance bars show the latest reported values; they are separate windows and should not be added together.",
    "keys": []
  },
  {
    "section": "Analytics",
    "title": "Size and text visibility",
    "body": "Suggested size: at least 360 × 540; larger fonts require more room. Meter-only mode keeps the graph and bars but hides all labels and controls; its minimum size is 280 × 240. Outside meter-only mode, Show additional allowance bars controls the entire Analytics bar section, including the selected allowance. The Remaining caption option applies to the decorative meters; Analytics keeps its own descriptive chart labels.",
    "keys": []
  },
  {
    "section": "Display",
    "title": "Meter only — hide all text and controls",
    "body": "Default: off. Leaves only the chosen display, overriding the individual text toggles without erasing them. In Aquarium, fish remain if Show fish is on. Hover for allowance, reset and connection information. Right-click to reopen settings. Decorative meters can shrink to 120 × 120; Analytics needs 280 × 240.",
    "keys": [
      "meterOnly"
    ]
  },
  {
    "section": "Display",
    "title": "Show Tide title and product name",
    "body": "Default: on. Shows the Tide heading and CODEX & WORK product label.",
    "keys": [
      "showHeader"
    ]
  },
  {
    "section": "Display",
    "title": "Show connection status",
    "body": "Default: on. Shows LIVE, SYNCING, STALE or OFFLINE and the status indicator. See Troubleshooting for their meanings.",
    "keys": [
      "showStatus"
    ]
  },
  {
    "section": "Display",
    "title": "Show percentage inside the meter",
    "body": "Default: on. Shows the large remaining percentage. In Analytics it appears in the overview header.",
    "keys": [
      "showPercentage"
    ]
  },
  {
    "section": "Display",
    "title": "Show “Remaining” caption",
    "body": "Default: on. Shows the small caption beneath the percentage in Aquarium, Lava chamber and Motorsport. Analytics uses its own chart labels.",
    "keys": [
      "showRemaining"
    ]
  },
  {
    "section": "Display",
    "title": "Show additional allowance bars",
    "body": "Default: on. Shows other reported quota windows below decorative meters. In Analytics it shows all allowance bars, including the selected window.",
    "keys": [
      "showExtraLimits"
    ]
  },
  {
    "section": "Display",
    "title": "Show credits and reset credits",
    "body": "Default: on. Shows reported credit balance and available reset credits. Displaying these values does not spend or redeem them.",
    "keys": [
      "showCredits"
    ]
  },
  {
    "section": "Display",
    "title": "Show reset countdown",
    "body": "Default: on. Shows time until the selected allowance resets near the update time. When the time passes, Tide waits for a new reading to confirm the reset.",
    "keys": [
      "showResetTime"
    ]
  },
  {
    "section": "Display",
    "title": "Show last update time",
    "body": "Default: on. Shows the time of the last successful data reading. Animation frames do not count as usage updates.",
    "keys": [
      "showUpdated"
    ]
  },
  {
    "section": "Display",
    "title": "Show action buttons",
    "body": "Default: on. Shows animation pause/resume, open Usage in your regular browser, and refresh now. Pausing animation does not pause data refreshes.",
    "keys": [
      "showButtons"
    ]
  },
  {
    "section": "Display",
    "title": "Show usage scope note",
    "body": "Default: on. Shows the reminder that chat conversations are not included. Hiding the note does not change which usage is measured.",
    "keys": [
      "showScopeNote"
    ]
  },
  {
    "section": "Display",
    "title": "Show connection error text",
    "body": "Default: on. Shows a failed update’s error message. Hiding it does not resolve the error; status can still show STALE, and meter-only hover information still includes the failure.",
    "keys": [
      "showErrors"
    ]
  },
  {
    "section": "Display",
    "title": "Text scale (% of chosen font)",
    "body": "70–160%; default 100%. Scales text relative to the system or custom base font. Larger text increases minimum widget dimensions. This changes text size, not fish size.",
    "keys": [
      "textScale"
    ]
  },
  {
    "section": "Fonts",
    "title": "Use a custom font",
    "body": "Default: off. Tide follows KDE’s system font unless enabled. A custom font changes only this widget. The settings interface itself continues using KDE’s normal UI font. Restore KDE font defaults returns the widget to the system font.",
    "keys": [
      "useCustomFont"
    ]
  },
  {
    "section": "Fonts",
    "title": "Font family and style / Choose font…",
    "body": "Opens the font picker for installed families and styles, including bold and italic. Tide saves the selected family, style, weight and italic setting together. Accept the picker, then Apply or OK in settings. Canceling the picker leaves the selection unchanged. The preview shows the selected font. With custom fonts disabled, these saved choices have no effect.",
    "keys": [
      "fontFamily",
      "fontStyle",
      "fontWeight",
      "fontItalic"
    ]
  },
  {
    "section": "Fonts",
    "title": "Base size (pt)",
    "body": "6–48 pt; default custom size 10 pt. Available when custom fonts are enabled. Display → Text scale applies on top: 12 pt at 125% uses a 15 pt base before each label’s own size factor. Large sizes may require a larger widget.",
    "keys": [
      "fontSize"
    ]
  },
  {
    "section": "Aquarium",
    "title": "Show fish",
    "body": "Default: on. Displays the fish in Aquarium. Fish shrink as water gets shallow and disappear when too little space remains. This control does not add fish to the other styles.",
    "keys": [
      "showFish"
    ]
  },
  {
    "section": "Aquarium",
    "title": "Number of fish",
    "body": "1–10; default 3. Sets the aquarium population. More fish add visual activity and drawing work. Shallow water may prevent them from being visible.",
    "keys": [
      "fishCount"
    ]
  },
  {
    "section": "Aquarium",
    "title": "Fish size (%)",
    "body": "50–200%; default 125%. Adjusts fish size relative to the aquarium. Fish still adapt to available water depth.",
    "keys": [
      "fishScale"
    ]
  },
  {
    "section": "Aquarium",
    "title": "Swimming speed (%)",
    "body": "20–200%; default 80%. Adjusts swimming motion. Speed is based on elapsed time, so choosing a higher frame limit does not make fish swim faster.",
    "keys": [
      "fishSpeed"
    ]
  },
  {
    "section": "Aquarium",
    "title": "Fish colors",
    "body": "Default: Koi — pearl, gold and orange. Tropical uses turquoise and blue; Silver uses a natural silver shoal. All choices keep the detailed fish drawing.",
    "keys": [
      "fishStyle"
    ]
  },
  {
    "section": "Aquarium",
    "title": "Animate swimming and fins",
    "body": "Default: on. Animates fish movement and fins. Turn off to keep fish still while allowing water motion to continue. The Updates master animation switch overrides this option.",
    "keys": [
      "animateFish"
    ]
  },
  {
    "section": "Aquarium",
    "title": "Animate water",
    "body": "Default: on. Animates the water surface and water-related motion. Independent of fish animation; the master animation switch overrides both.",
    "keys": [
      "animateWater"
    ]
  },
  {
    "section": "Aquarium",
    "title": "Show rising bubbles",
    "body": "Default: on. Shows decorative bubbles in Aquarium. Their motion follows water animation.",
    "keys": [
      "showBubbles"
    ]
  },
  {
    "section": "Aquarium",
    "title": "Wave height (%)",
    "body": "0–180%; default 100%. Adjusts surface wave amplitude. Zero flattens the surface; it does not disable fish motion or data updates.",
    "keys": [
      "waveStrength"
    ]
  },
  {
    "section": "Aquarium",
    "title": "Animation mode",
    "body": "Default: Balanced, capped at 30 fps. Smooth caps drawing at 60 fps. Match display draws on every frame provided by Qt’s animation clock, with no extra cap. Custom enables a chosen limit. This setting also controls Lava chamber and Motorsport even though it is on the Aquarium page. Actual frame rate depends on the display, compositor and system load. Higher rates can look smoother but use more resources. Analytics only repaints when needed.",
    "keys": [
      "frameMode"
    ]
  },
  {
    "section": "Aquarium",
    "title": "Custom frame limit (fps)",
    "body": "10–240 fps; default 30. Editable only in Custom animation mode. This is a drawing cap, not a guaranteed frame rate or monitor setting. Use Balanced for lighter resource use, Smooth for more fluid motion, or Match display to follow Qt’s display-driven timing.",
    "keys": [
      "frameRate"
    ]
  },
  {
    "section": "Appearance",
    "title": "Water palette",
    "body": "Default: Lagoon cyan. Other choices are Ocean blue, Aurora violet, Sunset coral and KDE highlight color. Sets the aquarium water/accent palette and shared decorative accents where used. Lava retains its molten colors, the car uses its own color, and Analytics uses a restrained blue graph palette.",
    "keys": [
      "palette"
    ]
  },
  {
    "section": "Appearance",
    "title": "Change color when remaining allowance is low",
    "body": "Default: on. Shared accents change to amber at 25% or less remaining and coral at 10% or less. It does not recolor every styled surface or the Analytics graph.",
    "keys": [
      "warningColors"
    ]
  },
  {
    "section": "Appearance",
    "title": "Show the outer progress ring",
    "body": "Default: on. Shows the aquarium quota ring. Lava chamber, Motorsport and Analytics keep their own gauge or chart elements independently.",
    "keys": [
      "showRing"
    ]
  },
  {
    "section": "Appearance",
    "title": "Show scale markings",
    "body": "Default: on. Shows decorative tick marks where present, such as around Aquarium. The removed outer lava dashes do not return when this is enabled. Analytics keeps its chart scale independently.",
    "keys": [
      "showTicks"
    ]
  },
  {
    "section": "Appearance",
    "title": "Show glow around the meter",
    "body": "Default: on. Enables glow effects in the decorative displays where supported. Analytics stays flat and does not use a glow.",
    "keys": [
      "showGlow"
    ]
  },
  {
    "section": "Appearance",
    "title": "Glow intensity (%)",
    "body": "0–100%; default 60%. Adjusts the aquarium’s outer glow when Show glow is enabled. It does not change the lava’s inherent molten shading or the Analytics graph.",
    "keys": [
      "glowStrength"
    ]
  },
  {
    "section": "Appearance",
    "title": "Water opacity (%)",
    "body": "0–100%; default 35%. Controls aquarium water transparency. Zero hides the water tint while retaining enabled fish and other decorations. Lower values reveal more of the wallpaper.",
    "keys": [
      "waterOpacity"
    ]
  },
  {
    "section": "Appearance",
    "title": "Glass shading (%)",
    "body": "0–100%; default 0%. Darkens the aquarium interior to create a glass effect and improve contrast. Zero leaves the interior shading transparent.",
    "keys": [
      "glassOpacity"
    ]
  },
  {
    "section": "Appearance",
    "title": "Background panel opacity (%)",
    "body": "0–100%; default 0%. Sets the dark panel behind the entire widget in every style. Zero is transparent; increase it when text is hard to read over wallpaper. It is separate from water and style surface opacity.",
    "keys": [
      "backgroundOpacity"
    ]
  },
  {
    "section": "Updates",
    "title": "Refresh interval (minutes)",
    "body": "1–30 minutes; default 3. Controls automatic usage reads. The refresh button requests a reading immediately. Shorter intervals collect Analytics history faster but perform more reads. This is unrelated to animation frame rate.",
    "keys": [
      "refreshMinutes"
    ]
  },
  {
    "section": "Updates",
    "title": "Main allowance",
    "body": "Default: Most depleted Codex & Work window. Alternatively prefer Weekly or 5-hour. This selection drives the main percentage, decorative fill or gauge, reset countdown and Analytics trend. If the preferred window is absent, Tide uses an available shared allowance, then another reported bucket. Other available windows remain in the bars.",
    "keys": [
      "mainWindow"
    ]
  },
  {
    "section": "Updates",
    "title": "Enable animation (master switch)",
    "body": "Default: on. Overrides aquarium and style motion switches. Turning it off freezes decorative motion but keeps usage refreshes and graph updates active. The widget’s animation button changes this same saved setting.",
    "keys": [
      "motionEnabled"
    ]
  },
  {
    "section": "Styles",
    "title": "Minimal display",
    "body": "A compact, professional display with a remaining percentage, thin quota bar, and reset/update times. Suggested size: 280 × 116. Keeps the transparent panel and system/custom fonts. Header, status dot, percentage, caption, reset and updated visibility switches apply. To stay compact, secondary bars, credits, action buttons and scope/error paragraphs are omitted; hover for status, reset and error details. No continuous animation is needed. Meter-only mode keeps just the bar, with a 140 × 20 minimum. Plasma may preserve the old size when switching styles; resize the desktop widget to make it small.",
    "keys": []
  },
  {
    "section": "About",
    "title": "Author, version and license",
    "body": "About lists Nicholas Hillsdale as author, the installed Tide version, MIT license, data scope and reload instructions. Help and About do not change settings.",
    "keys": []
  },
  {
    "section": "Troubleshooting",
    "title": "LIVE, SYNCING, STALE and OFFLINE",
    "body": "LIVE means a sufficiently recent successful reading is available. SYNCING means a read is in progress. STALE means the previous reading is retained after a failure or overdue update. OFFLINE means no allowance is available yet. These describe data freshness, not continuous server connectivity. Check the error text and your Codex sign-in, then refresh.",
    "keys": []
  },
  {
    "section": "Troubleshooting",
    "title": "Updated widget still looks old",
    "body": "Plasma can cache widget code even after removing and re-adding it. After an installation update, press Alt+Space and run plasmashell --replace. The desktop and panels briefly reload; application windows stay open. This also clears Analytics session history. Ordinary settings changes need only Apply or OK.",
    "keys": []
  },
  {
    "section": "Troubleshooting",
    "title": "Transparent or missing parts",
    "body": "If text blends into wallpaper, increase Background panel opacity. If fish disappear, check Show fish, water depth and fish size. A disabled style option applies to another display. If all text is hidden, turn off Meter only. A new Analytics session needs successful reads before it can show a trend; it cannot reconstruct earlier usage.",
    "keys": []
  }
];
