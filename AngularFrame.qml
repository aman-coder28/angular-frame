import QtQuick
import QtQuick.Shapes
import Quickshell.Io
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import QtQuick.Effects
import "."

Shape {
	id: shapeFrames

  ShapePath {
    strokeWidth: 8
    strokeColor: Colors.accentColor
    strokeStyle: ShapePath.SolidLine
    joinStyle: ShapePath.MiterJoin
    fillColor: "transparent"

    startX: 460; startY: 2
    PathLine { x: 251; y: 146.5 }
    PathLine { x: 251; y: 750 }
  }
}
