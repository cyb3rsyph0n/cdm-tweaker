# CDMTweaker

A World of Warcraft addon that provides tweaks and enhancements for Cooldown Manager, including automatic UI dimming when mounted and a quick settings access panel.

## Features

### 🐴 Mounted Opacity
Automatically dims the Cooldown Manager UI when you mount up, reducing visual clutter while traveling. The opacity level is fully customizable via a slider (0-100%).

**Supported frames:**
- Essential Cooldowns
- Utility Cooldowns
- Primary Resource Bar
- Secondary Resource Bar

### ⚙️ Quick Settings Access
- **`/cdm`** - Toggle the Cooldown Viewer Settings window
- **`/cdmt`** - Open CDMTweaker options (via Game Menu → AddOns)

### 💾 Persistent Settings
All your preferences are automatically saved and restored between sessions.

## Installation

1. Download the latest release from [CurseForge](https://www.curseforge.com/wow/addons/cdm-tweaker)
2. Extract the `CDMTweaker` folder to your `World of Warcraft\_retail_\Interface\AddOns\` directory
3. Restart World of Warcraft or reload your UI (`/reload`)

## Configuration

Access settings through **Game Menu → Options → AddOns → CDMTweaker**

| Setting | Description |
|---------|-------------|
| Enable /cdm slash command | Toggles the `/cdm` shortcut (requires reload) |
| Essential Cooldowns | Dim Essential Cooldowns frame while mounted |
| Utility Cooldowns | Dim Utility Cooldowns frame while mounted |
| Primary Resource Bar | Dim Primary Resource Bar while mounted |
| Secondary Resource Bar | Dim Secondary Resource Bar while mounted |
| Also dim during ground and normal flying | When disabled, only dims while skyriding |
| Dim Opacity | Opacity level (0% = invisible, 100% = fully visible) |

## Requirements

- World of Warcraft Retail (Interface 120000+)
- [Cooldown Manager](https://www.curseforge.com/wow/addons/cooldownmanager) addon

## Author

**Cyb3rSyph0n**

## License

All rights reserved.
