# Angular Frame

![Preview](frame.jpg)

A Wayland desktop Frame built with [Quickshell](https://quickshell.outfoxxed.me/) and Qt Quick, featuring an angular panel frame and a scalloped analog clock.

## Overview

The shell renders a background layer on Wayland with two components:

- **Angular Frame** — A full-screen background layer that paints a left sidebar panel with a diagonal cut (chamfered top-right corner), creating the angular aesthetic visible in the screenshot. A thin accent stroke traces the top edge and the diagonal cut.

- **Scalloped Clock** — An analog clock with a scalloped (wavy) edge face, configurable tick marks, hour numbers, clock hands, a curved day-of-week label, and a faint digital time overlay. Fully configurable via `settings.json`. See [Clock README.md](widgets/Clock/README.md) for full details.

## Files

| File            | Purpose                                                                                  |
| --------------- | ---------------------------------------------------------------------------------------- |
| `shell.qml`     | Main entry point. Defines the full-screen background layer with the angular frame shape. |
| `Clock.qml`     | Analog clock component with scalloped face, hands, tick marks, and digital overlay.      |
| `Colors.qml`    | Singleton that reads accent/background/primary colors from `noctalia-colors.json`.       |
| `settings.json` | Clock configuration (size, scallops, amplitude, visibility toggles, hand lengths).       |

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
- Qt 6 (QtQuick, QtQuick.Controls, QtQuick.Shapes)
