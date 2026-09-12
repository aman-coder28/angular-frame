pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  property alias background: colors.background
  property alias error: colors.error
  property alias error_container: colors.error_container
  property alias inverse_on_surface: colors.inverse_on_surface
  property alias inverse_primary: colors.inverse_primary
  property alias inverse_surface: colors.inverse_surface
  property alias on_background: colors.on_background
  property alias on_error: colors.on_error
  property alias on_error_container: colors.on_error_container
  property alias on_primary: colors.on_primary
  property alias on_primary_container: colors.on_primary_container
  property alias on_primary_fixed: colors.on_primary_fixed
  property alias on_primary_fixed_variant: colors.on_primary_fixed_variant
  property alias on_secondary: colors.on_secondary
  property alias on_secondary_container: colors.on_secondary_container
  property alias on_secondary_fixed: colors.on_secondary_fixed
  property alias on_secondary_fixed_variant: colors.on_secondary_fixed_variant
  property alias on_surface: colors.on_surface
  property alias on_surface_variant: colors.on_surface_variant
  property alias on_tertiary: colors.on_tertiary
  property alias on_tertiary_container: colors.on_tertiary_container
  property alias on_tertiary_fixed: colors.on_tertiary_fixed
  property alias on_tertiary_fixed_variant: colors.on_tertiary_fixed_variant
  property alias outline: colors.outline
  property alias outline_variant: colors.outline_variant
  property alias primary: colors.primary
  property alias primary_container: colors.primary_container
  property alias primary_fixed: colors.primary_fixed
  property alias primary_fixed_dim: colors.primary_fixed_dim
  property alias scrim: colors.scrim
  property alias secondary: colors.secondary
  property alias secondary_container: colors.secondary_container
  property alias secondary_fixed: colors.secondary_fixed
  property alias secondary_fixed_dim: colors.secondary_fixed_dim
  property alias shadow: colors.shadow
  property alias source_color: colors.source_color
  property alias surface: colors.surface
  property alias surface_bright: colors.surface_bright
  property alias surface_container: colors.surface_container
  property alias surface_container_high: colors.surface_container_high
  property alias surface_container_highest: colors.surface_container_highest
  property alias surface_container_low: colors.surface_container_low
  property alias surface_container_lowest: colors.surface_container_lowest
  property alias surface_dim: colors.surface_dim
  property alias surface_tint: colors.surface_tint
  property alias surface_variant: colors.surface_variant
  property alias tertiary: colors.tertiary
  property alias tertiary_container: colors.tertiary_container
  property alias tertiary_fixed: colors.tertiary_fixed
  property alias tertiary_fixed_dim: colors.tertiary_fixed_dim

  FileView {
    path: Quickshell.env("HOME") + "/.config/quickshell/noctalia-colors.json"
    watchChanges: true

    onFileChanged: reload()
    onAdapterUpdated: writeAdapter()

    JsonAdapter {
      id: colors

      property string background: "#121317"
      property string error: "#ffb4ab"
      property string error_container: "#93000a"
      property string inverse_on_surface: "#2f3034"
      property string inverse_primary: "#3f5e94"
      property string inverse_surface: "#e3e2e7"
      property string on_background: "#e3e2e7"
      property string on_error: "#690005"
      property string on_error_container: "#ffdad6"
      property string on_primary: "#052f62"
      property string on_primary_container: "#13386c"
      property string on_primary_fixed: "#001b3e"
      property string on_primary_fixed_variant: "#25467a"
      property string on_secondary: "#253145"
      property string on_secondary_container: "#aab5cf"
      property string on_secondary_fixed: "#101c2f"
      property string on_secondary_fixed_variant: "#3c475d"
      property string on_surface: "#e3e2e7"
      property string on_surface_variant: "#c4c6d1"
      property string on_tertiary: "#4a1f50"
      property string on_tertiary_container: "#542759"
      property string on_tertiary_fixed: "#320739"
      property string on_tertiary_fixed_variant: "#633568"
      property string outline: "#8d909a"
      property string outline_variant: "#43474f"
      property string primary: "#aac7ff"
      property string primary_container: "#84a3dd"
      property string primary_fixed: "#d7e3ff"
      property string primary_fixed_dim: "#aac7ff"
      property string scrim: "#000000"
      property string secondary: "#bbc7e1"
      property string secondary_container: "#3c475d"
      property string secondary_fixed: "#d7e3fe"
      property string secondary_fixed_dim: "#bbc7e1"
      property string shadow: "#000000"
      property string source_color: "#84a3dd"
      property string surface: "#121317"
      property string surface_bright: "#38393d"
      property string surface_container: "#1e2023"
      property string surface_container_high: "#292a2e"
      property string surface_container_highest: "#333539"
      property string surface_container_low: "#1a1b1f"
      property string surface_container_lowest: "#0d0e12"
      property string surface_dim: "#121317"
      property string surface_tint: "#aac7ff"
      property string surface_variant: "#43474f"
      property string tertiary: "#eeb3ef"
      property string tertiary_container: "#c790c9"
      property string tertiary_fixed: "#ffd6fd"
      property string tertiary_fixed_dim: "#eeb3ef"
    }
  }
}
