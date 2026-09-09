import QtQuick
import QtQuick.Shapes
import Quickshell.Io
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import QtQuick.Effects

PanelWindow {
  id: trianglePanel
  WlrLayershell.layer: WlrLayershell.Background
  WlrLayershell.namespace: "material-frame"

  margins {
    top: 0
    left: 247
	}

  anchors { top: true; left: true }
  implicitWidth: 180
  implicitHeight: 170

  color: "transparent"

 	FileView {
     id: noctaliaColors
     path: Quickshell.env("HOME") + "/.config/quickshell/noctalia-colors.json"
     watchChanges: true
     onFileChanged: reload()
     onAdapterUpdated: writeAdapter()

     JsonAdapter {
     	id: colors
       property string accentColor
       property string bgColor
       property string primaryColor
     }
   }

  Shape {
    anchors.fill: parent

    ShapePath {
	    strokeWidth: 8
	    strokeColor: "transparent"
	    strokeStyle: ShapePath.SolidLine
	    joinStyle: ShapePath.MiterJoin
	    fillColor: colors.bgColor

      startX: 0; startY: 0
      PathLine { x: 0; y: trianglePanel.height }
      PathLine { x: trianglePanel.width; y: 0 }
      PathLine { x: 0; y: 0 }
    }

    ShapePath {
    	strokeWidth: 8
	    strokeColor: colors.accentColor
	    strokeStyle: ShapePath.SolidLine
			joinStyle: ShapePath.MiterJoin
      fillColor: colors.bgColor

      startX: 150; startY: 0
      PathLine { x: 0; y: 150 }
    }
  }
}
