# Material Scalloped Clock

A highly customizable, Material 3-inspired analog clock widget for Quickshell.

## 📝 Overview

This project was built as a Quickshell Wayland desktop widget featuring:

- A scalloped background pattern with configurable amplitude
- Analog clock hands (hour, minute, second)
- Tick marks and hour numbers
- Day label (curved text under 12 o'clock)
- Digital time display and date badge
- Pywal color palette integration
- Responsive design that scales with window size

## 🛠 Features

- **Responsive Scalloped Design**: Perimeter count and amplitude scale with window size
- **Pywal Integration**: Automatically inherits system colors from `~/.cache/wal/colors.json`
- **Hybrid Display**: Combined analog hands with a large digital time background
- **Customizable Components**: Toggleable numbers, tick marks, day-of-week labels, and date badges
- **Flexible Mechanics**: Independent control over hand lengths, thicknesses, and floating second-hand indicators
- **Angular Frame**: Decorative angular border surrounding the clock area

## 📸 Showcase

![Material Scalloped Clock](image.png)

## 📋 Prerequisites

- [Quickshell](https://github.com/outfoxxed/quickshell)
- Wayland compositor (Hyprland, Sway, etc.)

## 📦 Installation

1. Copy the `clock` directory to `~/.config/quickshell/`.
2. Ensure `settings.json` and `clock.qml` are in the same folder.

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
