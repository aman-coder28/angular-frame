# Angular Frame

![Preview](frame.jpg)

A Wayland desktop shell built with [Quickshell](https://quickshell.outfoxxed.me/) and Qt Quick, featuring an angular sidebar frame, a floating music pill, and a scalloped analog clock.

## Overview

The shell renders multiple background layers on Wayland:

- **Angular Frame** — A full-screen background layer that paints a left sidebar panel with a diagonal cut (chamfered top-right corner). A thin accent stroke traces the top edge, the diagonal cut, and the sidebar's right edge. The sidebar hosts three stacked widgets.

- **Sidebar Widgets** — Weather, Calendar, and SystemMonitor are rendered as rounded cards inside the sidebar, positioned at fixed offsets from the top-left corner.

- **MusicIsland** — A floating pill-shaped music bar at the top center of the screen. Uses MPRIS to detect any active media player. Collapsed mode shows album art, track info, and animated audio visualizer bars that cycle automatically. On hover, expands to reveal a seek slider and transport controls (repeat, previous, play/pause, next, shuffle). Powered by [Cava](https://github.com/karlstav/cava) for real-time audio visualization.

- **Scalloped Clock** — An analog clock with a scalloped (wavy) edge face, configurable tick marks, hour numbers, clock hands, a curved day-of-week label, and a faint digital time overlay. Fully configurable via `settings.json`. See [Clock README.md](widgets/Clock/README.md) for full details.

### Sidebar Widgets

- **Weather** — Fetches current conditions and a 3-day forecast from [Open-Meteo](https://open-meteo.com/) (no API key required). Displays temperature, weather icon, and high/low temps. Auto-refreshes every 6 hours. Configured for Addis Ababa by default.

- **Calendar** — A full monthly calendar grid with prev/next navigation arrows, day-of-week headers, today highlight, and out-of-month day dimming.

- **SystemMonitor** — Three circular gauges (CPU, RAM, Disk) with smooth animated arcs. Polls `/proc/stat`, `/proc/meminfo`, `df`, and thermal sensors every 2 seconds. Shows used/total values and changes color at 70% and 90% thresholds.

## Files

| File | Purpose |
|---|---|
| `shell.qml` | Main entry point. Defines all panel windows and the angular frame shape. |
| `Colors.qml` | Singleton reading Material Design 3 color tokens from Noctalia JSON. |
| `Calendar.qml` | Monthly calendar with prev/next navigation and today highlight. |
| `widgets/Clock/Clock.qml` | Scalloped analog clock with hands, ticks, day label, digital overlay. |
| `widgets/Clock/Colors.qml` | Clock-specific color singleton. |
| `widgets/Clock/settings.json` | Clock configuration (size, scallops, amplitude, toggles, hand lengths). |
| `widgets/Weather/Weather.qml` | Current weather + 3-day forecast via Open-Meteo API. |
| `widgets/Weather/ForcastRow.qml` | Forecast row sub-component (day, icon, temp). |
| `widgets/SystemMonitor/SystemMonitor.qml` | CPU/RAM/Disk circular gauges with 2s polling. |
| `widgets/MusicIsland/MusicIsland.qml` | Collapsed/expanded music pill with hover animation. |
| `widgets/MusicIsland/Music.qml` | Singleton wrapping the MPRIS player API. |
| `widgets/MusicIsland/MusicControl.qml` | Expanded controls (seek slider, transport buttons). |
| `widgets/MusicIsland/MusicBars.qml` | Animated audio visualizer bars. |
| `widgets/MusicIsland/Cava.qml` | Spawns Cava process and parses output into bar levels. |
| `assets/` | SVG weather icons (clear, rain, snow, etc.). |

## Noctalia v5 Color Integration

Noctalia v5 is a native runtime (not Quickshell like v4 was), so it doesn't share its color objects with your Quickshell widget directly. The clean way to bridge them is: let Noctalia render the current palette into a JSON file, and have your Quickshell widget watch that file. This works for all theme sources (wallpaper, built-in, custom palette).

### 1. Create a Noctalia template

`~/.config/noctalia/templates/quickshell-colors.json`:

```json
{
<* for name, value in colors *>
  "{{ name }}": "{{ value.default.hex }}"<* if not {{ loop.last }} *>,<* endif *>
<* endfor *>
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


## Dependencies

- [Quickshell](https://quickshell.outfoxxed.me/) with Wayland support
- Qt 6 (QtQuick, QtQuick.Controls, QtQuick.Shapes, QtQuick.Layouts, QtQuick.Effects)
- Quickshell modules: `Quickshell.Wayland`, `Quickshell.Io`, `Quickshell.Services.Mpris`, `Quickshell.Widgets`
- [Cava](https://github.com/karlstav/cava) (optional, for audio visualizer in MusicIsland)
- `curl` (used by Weather widget to fetch from Open-Meteo API)
