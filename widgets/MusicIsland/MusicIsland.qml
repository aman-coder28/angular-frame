import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets

PanelWindow {
  id: root

  implicitWidth: 120
  WlrLayershell.exclusionMode: ExclusionMode.Ignore
  color: "transparent"

  mask: Region {
    item: musicRect
  }

  anchors {
    top: true
    left: true
    right: true
    bottom: true
  }

  Rectangle {
    id: dropShadow

    width: musicRect.width + 2
    height: musicRect.height + 2
    radius: musicRect.radius
    color: Colors.surface_bright
    opacity: musicRect.state === "shown" ? 0.4 : 0
    anchors.centerIn: musicRect
    z: -1
  }

  Rectangle {
    id: musicRect

    property bool expanded: hover.hovered

    clip: true
    z: 1
    color: Colors.on_secondary
    radius: expanded ? Math.min(height / 2, 16) : Math.min(height / 2, 8)
    opacity: Music.activePlayer !== null && Music.activePlayer.isPlaying ? 1 : 0
    implicitWidth: expanded ? 400 : musicRow.implicitWidth + 24
    implicitHeight: expanded ? musicRow.implicitHeight + 140 : 31
    width: expanded ? 400 : musicRow.implicitWidth + 24
    height: expanded ? musicRow.implicitHeight + 140 : 31
    state: Music.activePlayer !== null && Music.activePlayer.isPlaying ? "shown" : "hidden"

    Behavior on opacity {
      NumberAnimation {
        duration: 200
        easing.type: Easing.InOutElastic
      }
    }
    Behavior on width {
      NumberAnimation {
        duration: 300
        easing.type: Easing.Bezier
        easing.bezierCurve: [0.34, 0.8, 0.34, 1, 1, 1]
      }
    }
    Behavior on height {
      NumberAnimation {
        duration: 300
        easing.type: Easing.Bezier
        easing.bezierCurve: [0.34, 0.8, 0.34, 1, 1, 1]
      }
    }
    states: [
      State {
        name: "shown"

        PropertyChanges {
          target: musicRect
          width: musicRect.expanded ? 380 : musicRow.width + 24
          opacity: 1
          visible: true
        }
      },
      State {
        name: "hidden"

        PropertyChanges {
          target: musicRect
          width: 0
          opacity: 0
          visible: false
        }
      }
    ]
    transitions: [
      Transition {
        from: "shown"
        to: "hidden"

        SequentialAnimation {
          NumberAnimation {
            properties: "width,opacity"
            duration: 250
            easing.type: Easing.InCubic
          }

          PropertyAction {
            property: "visible"
          }
        }
      },
      Transition {
        from: "hidden"
        to: "shown"

        SequentialAnimation {
          PropertyAction {
            property: "visible"
          }

          NumberAnimation {
            properties: "width,opacity"
            duration: 250
            easing.type: Easing.OutCubic
          }
        }
      }
    ]

    HoverHandler {
      id: hover
    }

    anchors {
      top: parent.top
      horizontalCenter: parent.horizontalCenter
      topMargin: expanded ? 6 : 2
    }

    Row {
      id: musicRow

      spacing: 8
      opacity: musicRect.expanded ? 0 : 1

      anchors {
        centerIn: parent
      }

      ClippingRectangle {
        width: 19
        height: 19
        radius: 180
        opacity: musicRect.expanded ? 0 : 1

        Image {
          id: musicImage

          asynchronous: true
          cache: true
          source: Music.albumArt ?? ""
          fillMode: Image.PreserveAspectCrop

          anchors {
            fill: parent
          }
        }
      }

      Row {
        id: controls

        property int cycleState: 0
        property real slideOffset: 40

        function getItemX(itemIndex) {
          if (itemIndex === cycleState)
            return 0; // Active item is centered
          if (itemIndex === (cycleState + 1) % 3)
            return slideOffset; // Next item comes from right
          return -slideOffset; // Previous item goes to the left
        }

        Timer {
          id: cycleTimer

          interval: 3000
          running: true
          repeat: true

          onTriggered: {
            controls.cycleState = (controls.cycleState + 1) % 3;

            if (controls.cycleState === 0) {
              interval = 3000;
            } else if (controls.cycleState === 1) {
              interval = 5000;
            } else {
              interval = 60000;
            }
          }
        }

        Connections {
          function onTrackTitleChanged() {
            controls.cycleState = 0;
            cycleTimer.interval = 5000;
            cycleTimer.restart();
          }

          target: Music
        }

        MusicBars {
          visible: controls.cycleState === 2 ? 1 : 0
          opacity: musicRect.expanded ? 0 : 1
          maxHeight: 15
          barWidth: 3
          barSpacing: 4
          x: controls.getItemX(2)

          Behavior on visible {
            NumberAnimation {
              duration: 400
              easing.type: Easing.OutCubic
            }
          }
          Behavior on x {
            NumberAnimation {
              duration: 500
              easing.type: Easing.OutCubic
            }
          }
        }

        Text {
          text: Music.trackArtist
          font.pixelSize: 13
          font.weight: 500
          font.family: "Inter"
          opacity: musicRect.expanded ? 0 : 1
          visible: controls.cycleState === 0 ? 1 : 0
          x: controls.getItemX(0)
          color: Colors.on_surface

          Behavior on visible {
            NumberAnimation {
              duration: 400
              easing.type: Easing.OutCubic
            }
          }
          Behavior on x {
            NumberAnimation {
              duration: 500
              easing.type: Easing.OutCubic
            }
          }
        }

        Text {
          text: Music.shortenStrings(Music.trackTitle || "Unknown Title")
          font.pixelSize: 13
          font.weight: 500
          font.family: "Inter"
          opacity: musicRect.expanded ? 0 : 1
          visible: controls.cycleState === 1 ? 1 : 0
          x: controls.getItemX(1)
          color: Colors.on_surface

          Behavior on visible {
            NumberAnimation {
              duration: 400
              easing.type: Easing.OutCubic
            }
          }
          Behavior on x {
            NumberAnimation {
              duration: 500
              easing.type: Easing.OutCubic
            }
          }
        }
      }
    }

    MusicControl {}
  }
}
