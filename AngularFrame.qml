// AngularFrame.qml
import QtQuick
import QtQuick.Shapes

Item {
  id: root

  property real cornerCut: 24        // size of the diagonal cut
  property color borderColor: "#e8a0a0"
  property real borderWidth: 2
  property color bgColor: "#1a1a1acc"
  property bool cutTopLeft: true
  property bool cutTopRight: false
  property bool cutBottomLeft: false
  property bool cutBottomRight: true

  Shape {
      anchors.fill: parent
      preferredRendererType: Shape.CurveRenderer

      ShapePath {
          fillColor: root.bgColor
          strokeColor: root.borderColor
          strokeWidth: root.borderWidth
          joinStyle: ShapePath.MiterJoin

          // Build the outline as a list of points, skipping the
          // corner and inserting two points wherever a cut is enabled.
          PathPolyline {
              path: {
                  const w = root.width
                  const h = root.height
                  const c = root.cornerCut
                  let pts = []

                  // top-left
                  if (root.cutTopLeft) {
                      pts.push(Qt.point(0, c))
                      pts.push(Qt.point(c, 0))
                  } else {
                      pts.push(Qt.point(0, 0))
                  }

                  // top-right
                  if (root.cutTopRight) {
                      pts.push(Qt.point(w - c, 0))
                      pts.push(Qt.point(w, c))
                  } else {
                      pts.push(Qt.point(w, 0))
                  }

                  // bottom-right
                  if (root.cutBottomRight) {
                      pts.push(Qt.point(w, h - c))
                      pts.push(Qt.point(w - c, h))
                  } else {
                      pts.push(Qt.point(w, h))
                  }

                  // bottom-left
                  if (root.cutBottomLeft) {
                      pts.push(Qt.point(c, h))
                      pts.push(Qt.point(0, h - c))
                  } else {
                      pts.push(Qt.point(0, h))
                  }

                  pts.push(pts[0]) // close the path
                  return pts
              }
          }
      }
  }
}
