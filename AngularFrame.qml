import QtQuick
import QtQuick.Shapes
import Quickshell.Io
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

Shape {
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

  ShapePath {
    strokeWidth: 7
    strokeColor: colors.accentColor
    strokeStyle: ShapePath.SolidLine
    joinStyle: ShapePath.MiterJoin
    fillColor: "transparent"

    startX: 460; startY: 5
    PathLine { x: 250; y: 150 }
    PathLine { x: 250; y: 750 }
  }
}
