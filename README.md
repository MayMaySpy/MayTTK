# MayTTK

A lightweight **Time To Kill** calculator for World of Warcraft with adaptive DPS smoothing.

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![WoW](https://img.shields.io/badge/WoW-Retail%20%7C%20Classic%20%7C%20TBC%20%7C%20MoP-green)

## Features

- **Real-time TTK estimation** - See how long until your target dies
- **Adaptive DPS smoothing** - Accurate calculations that adjust to burst and sustained damage
- **Trend indicators** - Visual feedback showing if TTK is increasing or decreasing
- **Flexible positioning** - Drag freely or attach to target frame
- **UI addon support** - Auto-detects ElvUI and Shadowed Unit Frames
- **Minimap button** - Quick access to settings with visual enabled/disabled state
- **Fully configurable** - Fonts, colors, scale, opacity, and more

## Installation

1. Download the latest release for your WoW edition
2. Extract the `MayTTK` folder to your AddOns directory:
   - **Retail:** `World of Warcraft/_retail_/Interface/AddOns/`
   - **Classic Era:** `World of Warcraft/_classic_era_/Interface/AddOns/`
   - **TBC Classic:** `World of Warcraft/_classic_/Interface/AddOns/`
   - **MoP Classic:** `World of Warcraft/_classic_/Interface/AddOns/`
3. Restart WoW or type `/reload`

## Downloads

| Edition | File |
|---------|------|
| Retail | `MayTTK-x.x.x.zip` |
| Classic Era | `MayTTK-x.x.x-classic.zip` |
| TBC Classic | `MayTTK-x.x.x-bcc.zip` |
| MoP Classic | `MayTTK-x.x.x-mists.zip` |

## Usage

Target an enemy and start dealing damage. The TTK display will appear showing the estimated time until the target dies.

### Slash Commands

| Command | Description |
|---------|-------------|
| `/ttk` | Open settings window |
| `/ttk toggle` | Enable/disable the addon |
| `/ttk show` | Show the TTK display |
| `/ttk hide` | Hide the TTK display |
| `/ttk lock` | Toggle frame lock |
| `/ttk reset` | Reset frame position |
| `/ttk minimap` | Toggle minimap button |
| `/ttk preview` | Toggle preview mode for positioning |
| `/ttk help` | Show available commands |

### Minimap Button

- **Left-click:** Open settings
- **Right-click:** Toggle addon on/off
- **Drag:** Reposition around the minimap

## Configuration

Access settings via `/ttk` or the minimap button.

### General
- Enable/disable addon
- Show/hide TTK display
- Lock frame position
- Show trend arrows
- Show minimap button

### Appearance
- Font selection (7 built-in fonts)
- Font size (12-28pt)
- Color presets (Classic, Warm, Cool, White, Gold, Purple)
- Trend style (Off or Arrows)
- Frame scale

### Frame Style
- Show/hide background
- Show/hide border
- Background opacity

### Positioning
- Attach to target frame (auto-detects ElvUI/SUF)
- Anchor point selection
- X/Y offset adjustment

## Color Coding

TTK values are color-coded based on how quickly the target will die:

| Color | Meaning |
|-------|---------|
| 🔴 Red | Fast (≤5 seconds) |
| 🟡 Yellow | Medium (5-15 seconds) |
| 🟢 Green | Slow (>15 seconds) |

## Compatibility

| Edition | Interface |
|---------|-----------|
| WoW Retail | 110207+ |
| Classic Era | 11508+ |
| TBC Classic | 20505+ |
| MoP Classic | 50503+ |

**Supported UI Addons:**
- ElvUI
- Shadowed Unit Frames

## Localization

Full translations available for:
- English, Deutsch, Français, Español, Português
- Русский, 简体中文, 繁體中文, 한국어

## Support

Found a bug or have a suggestion? Open an issue on GitHub!

## License

This addon is free to use and modify for personal use.

## Author

Created by **May**
