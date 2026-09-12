import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "widgets/Clock"

ShellRoot {
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
        startY: frameWindow.strokeW / 2
        strokeColor: Colors.primary
        strokeStyle: ShapePath.SolidLine
        strokeWidth: frameWindow.strokeW

        PathLine {
          x: frameWindow.panelW + 5
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
          x: frameWindow.panelW + frameWindow.cutout
          y: 0
        }

        PathLine {
          x: frameWindow.panelW
          y: frameWindow.cutout
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
        startY: 0
        strokeColor: Colors.primary
        strokeStyle: ShapePath.SolidLine
        strokeWidth: frameWindow.strokeW

        PathLine {
          x: frameWindow.panelW + frameWindow.cutout
          y: 0
        }

        PathLine {
          x: frameWindow.panelW
          y: frameWindow.cutout
        }

        PathLine {
          x: frameWindow.panelW
          y: frame.height
        }
      }
    }
  }

  Clock {}
}
