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

        anchors {
            top: true
            left: true
            right: true
            bottom: true
        }

        WlrLayershell.layer: WlrLayershell.Background
        WlrLayershell.namespace: "material-frame"
        color: "transparent"

        property int panelW: Math.round(width * 0.190)
        property int cutout: Math.round(width * 0.11)
        property int strokeW: 8

        Rectangle {
            width: frameWindow.panelW
            height: frameWindow.height
            color: Colors.bgColor
        }

        Shape {
            id: frame
            anchors.fill: parent

            ShapePath {
                strokeWidth: frameWindow.strokeW
                strokeColor: Colors.accentColor
                strokeStyle: ShapePath.SolidLine
                joinStyle: ShapePath.MiterJoin
                fillColor: "transparent"

                startX: frame.width - frameWindow.strokeW / 2
                startY: frameWindow.strokeW / 2
                PathLine {
                    x: frameWindow.panelW + 5
                    y: frameWindow.strokeW / 2
                }
            }

            // seal the diagonal cut so the wallpaper doesn't show through
            ShapePath {
                fillColor: Colors.bgColor
                strokeColor: "transparent"
                startX: frameWindow.panelW
                startY: 0
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
                strokeWidth: frameWindow.strokeW
                strokeColor: Colors.accentColor
                strokeStyle: ShapePath.SolidLine
                joinStyle: ShapePath.MiterJoin
                fillColor: "transparent"

                startX: frame.width
                startY: 0
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
