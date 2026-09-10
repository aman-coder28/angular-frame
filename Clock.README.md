# Material Scalloped Clock

A highly customizable, Material 3-inspired analog clock widget for Quickshell.

> Based on [quickshell-clock](https://github.com/notsopreety/quickshell-clock).

## Overview

This project was built as a Quickshell Wayland desktop widget featuring:

- A scalloped background pattern with configurable amplitude
- Analog clock hands (hour, minute, second)
- Tick marks and hour numbers
- Day label (curved text under 12 o'clock)
- Digital time display and date badge
- Pywal color palette integration
- Responsive design that scales with window size

## Features

- **Responsive Scalloped Design**: Perimeter count and amplitude scale with window size
- **Pywal Integration**: Automatically inherits system colors from `~/.cache/wal/colors.json`
- **Hybrid Display**: Combined analog hands with a large digital time background
- **Customizable Components**: Toggleable numbers, tick marks, day-of-week labels, and date badges
- **Flexible Mechanics**: Independent control over hand lengths, thicknesses, and floating second-hand indicators
- **Angular Frame**: Decorative angular border surrounding the clock area

## Showcase

![Material Scalloped Clock](clocks.png)

## Prerequisites

- [Quickshell](https://github.com/outfoxxed/quickshell)
- Wayland compositor (Hyprland, Sway, etc.)

## Installation

1. Copy the `clock` directory to `~/.config/quickshell/`.
2. Ensure `settings.json` and `Clock.qml` are in the same folder.

## ⚙️ Configuration

Modify `settings.json` to adjust the widget's behavior:

| Property             | Type   | Description                                              |
| -------------------- | ------ | -------------------------------------------------------- |
| `winX` & `winY`      | int    | Position of widget over screen                           |
| `winSize`            | int    | Total width/height of the widget (proportional scaling)  |
| `scallops`           | int    | Number of scallops around the perimeter                  |
| `amplitude`          | int    | Depth of the scalloped curves                            |
| `showNumbers`        | bool   | Toggle visibility of the hour numbers                    |
| `showTicks`          | bool   | Toggle visibility of the hour and minutes ticks          |
| `showDayLabel`       | bool   | Toggle visibility of week's day                          |
| `showDigitalTime`    | bool   | Toggle visibility of the digital time in numbers         |
| `showDateBadge`      | bool   | Toggle visibility of the month's day date                |
| `showSecondHand`     | bool   | Toggle visibility of the second hand                     |
| `showSecondHandLine` | bool   | Toggle between a full line or a floating dot for seconds |
| `usePywal`           | bool   | Prioritize Pywal color palette over static colors        |
| `accentColor`        | string | Custom accent color if Pywal isn't installed             |
| `bgColor`            | string | Custom bg color if Pywal isn't installed                 |
| `primaryColor`       | string | Custom primary color if Pywal isn't installed            |

_Built with QtQuick and Quickshell for a modern Wayland desktop experience._

## Noctalia v5 Color Integration

Noctalia v5 is a native runtime (not Quickshell like v4 was), so it doesn't share its color objects with your Quickshell widget directly. The clean way to bridge them is: let Noctalia render the current palette into a JSON file, and have your Quickshell widget watch that file. This works for all theme sources (wallpaper, built-in, custom palette).

### 1. Create a Noctalia template

`~/.config/noctalia/templates/quickshell-colors.json`:

```json
{
	"accentColor": "{{ colors.primary.default.hex }}",
	"bgColor": "{{ colors.surface.default.hex }}",
	"primaryColor": "{{ colors.primary.default.hex }}"
}
```

If you want the old Material token feel, other useful tokens are `secondary`, `tertiary`, `surface_container`, `on_surface`, `surface_variant`, `outline`, etc. — v5's roles are `mPrimary`/`mSurface` style, where primary ≈ your accent and surface ≈ the shell background.

### 2. Register it in your Noctalia config

In `~/.config/noctalia/settings.toml` (or any `~/.config/noctalia/*.toml`):

```toml
[theme.templates.user.quickshell]
input_path  = "$XDG_CONFIG_HOME/noctalia/templates/quickshell-colors.json"
output_path = "$XDG_CONFIG_HOME/quickshell/noctalia-colors.json"
```

Noctalia renders user templates every time the palette/theme changes, and it skips rewriting the file when nothing changed so you won't get spurious reloads.
