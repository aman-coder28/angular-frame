import QtQuick
import QtQuick.Shapes
import Quickshell.Io
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import QtQuick.Effects
import "."

PanelWindow {
  id: trianglePanel
  WlrLayershell.layer: WlrLayershell.Background
  WlrLayershell.namespace: "material-frame"

  margins {
    top: 0
    left: 248
	}

  anchors { top: true; left: true }
  implicitWidth: 180
  implicitHeight: 180
  color: "transparent"

  Shape {
    anchors.fill: parent

    ShapePath {
	    strokeWidth: 7
	    strokeColor: "transparent"
	    strokeStyle: ShapePath.SolidLine
	    joinStyle: ShapePath.MiterJoin
	    fillColor: Colors.bgColor

      startX: 0; startY: 0
      PathLine { x: 0; y: trianglePanel.height }
      PathLine { x: trianglePanel.width; y: 0 }
      PathLine { x: 0; y: 0 }
    }

    ShapePath {
    	strokeWidth: 7
	    strokeColor: Colors.accentColor
	    strokeStyle: ShapePath.SolidLine
			joinStyle: ShapePath.MiterJoin
      fillColor: Colors.bgColor

      startX: 149; startY: 0
      PathLine { x: 0; y: 150 }
    }
  }
}
