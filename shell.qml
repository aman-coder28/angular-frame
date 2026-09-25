import QtQuick
import QtQuick.Layouts
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

    WlrLayershell.layer: WlrLayer.Background
    WlrLayershell.namespace: "material-frame"
    color: "transparent"

    anchors {
      bottom: true
      left: true
      right: true
      top: true
    }

    Rectangle {
      id: frameRect

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

    ColumnLayout {
      Layout.fillWidth: true
      anchors.horizontalCenter: frameRect.horizontalCenter
      spacing: 12

      Item {
        id: clockCard

        width: 166
        height: 166

        Clock {}
      }

      Rectangle {
        id: weatherCard

        width: 215
        height: 195
        radius: 12
        color: Colors.surface_container

        Weather {}
      }

      Rectangle {
        id: calendarCard

        width: 215
        height: 215
        radius: 12
        color: Colors.surface_container

        Calendar {}
      }

      Rectangle {
        id: systemMonitorCard

        implicitWidth: 215
        implicitHeight: 113
        radius: 12
        color: Colors.surface_container

        SystemMonitor {}
      }
    }
  }
}
