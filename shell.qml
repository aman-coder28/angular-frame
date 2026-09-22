import QtQuick
import QtQuick.Shapes
import Quickshell
import Quickshell.Wayland
import "widgets/Clock"
import "widgets/MusicIsland"
import "widgets/SystemMonitor"
import "widgets/Weather"

ShellRoot {
  MusicIsland {}

  PanelWindow {
    id: frameWindow

    property int cutout: Math.round(width * 0.12)
    property int panelW: Math.round(width * 0.190)
    property int strokeW: 8

    WlrLayershell.layer: WlrLayershell.Background
    WlrLayershell.namespace: "material-frame"
    color: "transparent"

    anchors {
      bottom: true
      left: true
      right: true
      top: true
    }

    Rectangle {
      color: Colors.background
      height: frameWindow.height
      width: frameWindow.panelW
    }

    Shape {
      id: frame

      anchors.fill: parent

      ShapePath {
        fillColor: "transparent"
        joinStyle: ShapePath.MiterJoin
        startX: frame.width - frameWindow.strokeW / 2
        startY: 0
        strokeColor: Colors.background
        strokeStyle: ShapePath.SolidLine
        strokeWidth: frameWindow.strokeW

        PathLine {
          x: frameWindow.panelW + 8
          y: frameWindow.strokeW / 2
        }
      }

      // seal the diagonal cut so the wallpaper doesn't show through
      ShapePath {
        fillColor: Colors.background
        startX: frameWindow.panelW
        startY: 0
        strokeColor: "transparent"

        PathLine {
          x: frameWindow.panelW + frameWindow.cutout + 12
          y: 0
        }

        PathLine {
          x: frameWindow.panelW
          y: frameWindow.cutout + 12
        }

        PathLine {
          x: frameWindow.panelW
          y: 0
        }
      }

      // the frame line: top edge -> diagonal -> down the column
      ShapePath {
        fillColor: "transparent"
        joinStyle: ShapePath.MiterJoin
        startX: frame.width
        startY: 7
        strokeColor: Colors.primary
        strokeStyle: ShapePath.SolidLine
        strokeWidth: frameWindow.strokeW

        PathLine {
          x: frameWindow.panelW + frameWindow.cutout
          y: 7
        }

        PathLine {
          x: frameWindow.panelW
          y: frameWindow.cutout + 7
        }

        PathLine {
          x: frameWindow.panelW
          y: frame.height
        }
      }
    }
  }

  Clock {}

  PanelWindow {
    WlrLayershell.layer: WlrLayershell.Background
    implicitWidth: 215
    implicitHeight: 195
    color: "transparent"

    mask: Region {
      item: sideCal
    }

    anchors {
      top: true
      left: true
    }

    margins {
      top: 178
      left: 20
    }

    Rectangle {
      id: sideWeather

      anchors.fill: parent
      color: Colors.surface_container
      radius: 12

      Weather {}
    }
  }

  PanelWindow {
    WlrLayershell.layer: WlrLayershell.Background
    implicitWidth: 215
    implicitHeight: 215
    color: "transparent"

    mask: Region {
      item: sideWeather
    }

    anchors {
      top: true
      left: true
    }

    margins {
      top: 386
      left: 20
    }

    Rectangle {
      id: sideCal

      anchors.fill: parent
      color: Colors.surface_container
      radius: 12

      Calendar {}
    }
  }

  PanelWindow {
    WlrLayershell.layer: WlrLayershell.Background
    implicitWidth: 215
    implicitHeight: 113
    color: "transparent"

    mask: Region {
      item: systemWidget
    }

    anchors {
      top: true
      left: true
    }

    margins {
      top: 613
      left: 20
    }

    Rectangle {
      id: systemWidget

      anchors.fill: parent
      color: Colors.surface_container
      radius: 12

      SystemMonitor {}
    }
  }
}
