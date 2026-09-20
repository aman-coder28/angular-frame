import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell.Services.Mpris
import Quickshell.Widgets

ColumnLayout {
  id: controls

  property bool expanded: parent.expanded

  width: 400
  spacing: 10

  anchors {
    fill: parent
    margins: 14
  }

  Row {
    Layout.alignment: Qt.AlignLeft
    Layout.fillWidth: parent
    spacing: 20
    opacity: controls.expanded ? 1 : 0

    Behavior on opacity {
      NumberAnimation {
        duration: 200
        easing.type: Easing.Bezier
        easing.bezierCurve: [0.34, 0.8, 0.34, 1, 1, 1]
      }
    }

    ClippingRectangle {
      width: 57
      height: 57
      radius: 8
      color: "transparent"

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

    Column {
      spacing: 10
      topPadding: 4

      Column {
        Layout.alignment: Qt.AlignCenter
        spacing: 6

        Text {
          text: Music.shortenStrings(Music.trackTitle)
          font.pixelSize: 16
          font.weight: 500
          font.family: "Inter"
          color: Colors.secondary
        }

        Text {
          text: Music.trackArtist
          font.pixelSize: 13
          font.weight: 400
          font.family: "Inter"
          color: Colors.on_surface
        }
      }
    }
  }

  RowLayout {
    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.margins: 4
    Layout.topMargin: 2
    Layout.bottomMargin: 1
    spacing: 8

    Text {
      text: Music.formatTime(pBar.pressed ? pBar.value : Music.position)
      font.pixelSize: 13
      color: "white"
      font.weight: 400
      font.family: "Inter"
    }

    Item {
      Layout.fillWidth: true
      Layout.preferredHeight: 12

      Slider {
        id: pBar

        anchors.fill: parent
        from: 0
        to: Music.length > 0 ? Music.length : 1

        background: Rectangle {
          x: pBar.leftPadding
          y: pBar.topPadding + pBar.availableHeight / 2 - height / 2
          width: pBar.availableWidth
          height: 7
          radius: height / 2
          color: Colors.outline

          Rectangle {
            width: pBar.visualPosition * parent.width
            height: parent.height
            radius: height / 2
            color: Colors.on_background
          }
        }
        handle: Item {
          x: pBar.leftPadding + pBar.visualPosition * (pBar.availableWidth - width)
          y: pBar.topPadding + pBar.availableHeight / 2 - height / 2
          width: 14
          height: 14

          RectangularShadow {
            anchors.fill: parent
            radius: width / 2
            blur: 1
            spread: 1
            color: Colors.on_surface_variant
          }

          Rectangle {
            anchors.fill: parent
            radius: width / 2
            color: Colors.on_primary
          }
        }

        onPressedChanged: {
          if (!pressed) {
            Music.seekTo(value);
          }
        }

        Binding {
          target: pBar
          property: "value"
          value: Music.position
          when: !pBar.pressed
        }
      }
    }

    Text {
      text: Music.formatTime(Music.length)
      font.pixelSize: 13
      font.weight: 400
      font.family: "Inter"
      color: "white"
    }
  }

  RowLayout {
    Layout.alignment: Qt.AlignCenter
    layoutDirection: Qt.LeftToRight
    spacing: 30

    Rectangle {
      Layout.preferredWidth: 19
      Layout.preferredHeight: 19
      Layout.alignment: Qt.AlignVCenter
      color: Music.activePlayer && Music.activePlayer.loopState !== MprisLoopState.None ? Colors.secondary_container : "transparent"

      Image {
        asynchronous: true
        cache: true
        source: "assets/repeat.svg"
        width: 19
        height: 19
        anchors.fill: parent
      }

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: Music.cycleLoop()
      }
    }

    Rectangle {
      Layout.preferredWidth: 24
      Layout.preferredHeight: 24
      Layout.alignment: Qt.AlignVCenter
      color: "transparent"

      Image {
        asynchronous: true
        cache: true
        source: "assets/skip_previous.svg"
        width: 24
        height: 24
        anchors.fill: parent
      }

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
          if (Music.activePlayer && Music.activePlayer.canGoPrevious)
            Music.activePlayer.previous();
        }
      }
    }

    Rectangle {
      id: playBtn

      Layout.preferredWidth: 36
      Layout.preferredHeight: 36
      Layout.alignment: Qt.AlignVCenter
      radius: 11
      color: Colors.secondary_container

      Image {
        asynchronous: true
        cache: true
        source: Music.activePlayer && Music.activePlayer.isPlaying ? "assets/pause.svg" : "assets/play.svg"
        width: 24
        height: 24

        anchors {
          centerIn: parent
        }
      }

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
          if (Music.activePlayer && Music.activePlayer.canTogglePlaying)
            Music.activePlayer.togglePlaying();
        }
      }
    }

    Rectangle {
      Layout.preferredWidth: 24
      Layout.preferredHeight: 24
      Layout.alignment: Qt.AlignVCenter
      radius: 8
      color: "transparent"

      Image {
        asynchronous: true
        cache: true
        source: "assets/skip_next.svg"
        width: 24
        height: 24
        anchors.fill: parent
      }

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
          if (Music.activePlayer && Music.activePlayer.canGoNext)
            Music.activePlayer.next();
        }
      }
    }

    Rectangle {
      Layout.preferredWidth: 28
      Layout.preferredHeight: 28
      Layout.alignment: Qt.AlignVCenter
      radius: 8
      color: Music.activePlayer && Music.activePlayer.shuffle ? Colors.secondary_container : "transparent"

      Image {
        asynchronous: true
        cache: true
        source: "assets/shuffle.svg"
        width: 20
        height: 20

        anchors {
          centerIn: parent
        }
      }

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
          if (Music.activePlayer && Music.activePlayer.shuffleSupported)
            Music.activePlayer.shuffle = !Music.activePlayer.shuffle;
        }
      }
    }
  }
}
