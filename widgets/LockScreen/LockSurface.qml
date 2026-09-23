import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls.Fusion
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets

Rectangle {
  id: root

  required property LockContext context
  property string image: ""

  function getGreeting() {
    const hour = new Date().getHours();

    return hour < 12 ? "Good Morning, " : hour < 18 ? "Good Morning, " : "Good Evening, ";
  }

  color: "transparent"
  anchors.fill: parent

  // opacity: context.locked ? 1 : 0

  Behavior on opacity {
    NumberAnimation {
      duration: 350
      easing.type: Easing.OutCubic
    }
  }

  Process {
    id: fetch

    command: ["noctalia", "msg", "wallpaper-get"]

    stdout: StdioCollector {
      onStreamFinished: {
        root.image = text.trim();
      }
    }

    Component.onCompleted: running = true
  }

  Button {
    text: "Its not working, let me out"

    onClicked: root.context.unlocked()
  }

  FastBlur {
    anchors.fill: parent
    source: wallpaperImage
    cached: true
    radius: 12
  }

  Image {
    id: wallpaperImage

    anchors.fill: parent
    asynchronous: true
    cache: true
    source: root.image.startsWith("file://") ? root.image : root.image ?? "fairy-tale.webp"
    opacity: status === Image.Ready ? 1.0 : 0.0
    smooth: true
    visible: false

    Behavior on opacity {
      NumberAnimation {
        duration: 300
        easing.type: Easing.OutQuad
      }
    }
  }

  ColumnLayout {
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    anchors.topMargin: 60
    Layout.alignment: Qt.AlignCenter
    spacing: 2

    Text {
      id: date

      property date myDate: new Date()

      renderType: Text.NativeRendering
      font.pointSize: 17
      font.family: "Google Sans"
      font.weight: Font.DemiBold
      font.letterSpacing: 0.7
      color: Colors.tertiary
      text: myDate.toLocaleDateString(Qt.locale(), "dddd, MMM d")
      visible: false

      anchors {
        horizontalCenter: parent.horizontalCenter
        top: parent.top
      }
    }

    Glow {
      anchors.fill: date
      radius: 2
      samples: 17
      color: Colors.secondary
      source: date
      transparentBorder: true
    }

    Text {
      id: clock

      property var date: new Date()

      renderType: Text.NativeRendering
      font.pointSize: 80
      font.family: "Google Sans"
      font.weight: Font.DemiBold
      font.letterSpacing: 0.7
      color: Colors.tertiary
      text: {
        const hours = this.date.getHours().toString().padStart(2, '0');
        const minutes = this.date.getMinutes().toString().padStart(2, '0');
        return `${hours}:${minutes}`;
      }
      visible: false

      anchors {
        horizontalCenter: parent.horizontalCenter
        top: parent.top
        topMargin: 16
      }

      Timer {
        running: true
        repeat: true
        interval: 1000

        onTriggered: clock.date = new Date()
      }
    }

    Glow {
      anchors.fill: clock
      radius: 5
      samples: 27
      color: Colors.secondary
      source: clock
      transparentBorder: true
    }
  }

  Rectangle {
    id: card

    opacity: 0.8
    color: Colors.on_primary_fixed
    radius: 12
    height: 210
    width: 380

    border {
      color: Colors.on_primary_fixed_variant
      width: 1
    }

    anchors {
      horizontalCenter: parent.horizontalCenter
      bottom: parent.bottom
      bottomMargin: 75
      margins: 14
    }

    ColumnLayout {
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: parent.top
      Layout.alignment: Qt.AlignCenter
      anchors.margins: 26
      spacing: 12

      ClippingRectangle {
        implicitWidth: 70
        implicitHeight: 70
        radius: 180
        Layout.alignment: Qt.AlignCenter

        Image {
          anchors.fill: parent
          source: "/var/lib/AccountsService/icons/" + Quickshell.env("USER")
        }
      }

      Text {
        text: Quickshell.env("USER")
        font.weight: Font.Medium
        font.family: "Google Sans"
        font.pixelSize: 18
        color: Colors.secondary
        Layout.alignment: Qt.AlignCenter
        font.letterSpacing: 0.9
        font.capitalization: Font.Capitalize
        layer.enabled: true
      }
    }

    ColumnLayout {
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      anchors.right: parent.right

      anchors {
        margins: 14
      }

      RowLayout {
        spacing: 5

        anchors {
          margins: 14
        }

        TextField {
          id: passwordBox

          property var passwordIcons: ["●", "◆", "❄"]
          property var passwordSequence: []

          function getRandomIcon(): string {
            return passwordIcons[Math.floor(Math.random() * passwordIcons.length)];
          }

          Layout.fillWidth: true
          padding: 10
          focus: true
          enabled: !root.context.unlockInProgress
          echoMode: TextInput.Password
          inputMethodHints: Qt.ImhSensitiveData
          placeholderText: "Input Password"
          color: Colors.background
          placeholderTextColor: Colors.background
          selectionColor: Colors.background
          passwordCharacter: getRandomIcon()

          background: Rectangle {
            radius: 10
            color: Colors.secondary
          }

          onTextChanged: root.context.currentText = this.text
          onAccepted: root.context.tryUnlock()

          Connections {
            function onCurrentTextChanged() {
              passwordBox.text = root.context.currentText;
            }

            target: root.context
          }
        }

        RoundButton {
          id: myButton

          implicitWidth: 40
          implicitHeight: 37
          padding: 10
          radius: 8
          focusPolicy: Qt.NoFocus
          enabled: !root.context.unlockInProgress && root.context.currentText !== ""

          background: Rectangle {
            radius: myButton.radius
            color: Colors.secondary
          }
          contentItem: Item {
            anchors.fill: parent

            Image {
              id: arrow

              anchors.centerIn: parent
              opacity: !root.context.unlockInProgress ? 1 : 0
              source: "assets/arrow.svg"
              width: 20
              height: 20
              colorSpace: Colors.background
            }

            Image {
              id: spinner

              anchors.centerIn: parent
              opacity: root.context.unlockInProgress ? 1 : 0
              source: "assets/spinner.svg"
              width: 20
              height: 20
              colorSpace: Colors.background

              NumberAnimation on rotation {
                from: 0
                to: 360
                duration: 650
                loops: Animation.Infinite
              }
            }
          }

          onClicked: root.context.tryUnlock()
        }
      }
    }
  }

  Rectangle {
    implicitHeight: 38
    implicitWidth: 250
    color: Colors.secondary
    radius: 8
    opacity: root.context.showFailure ? 1 : 0
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 22

    Behavior on opacity {
      NumberAnimation {
        duration: 200
        easing.type: Easing.InOutBounce
      }
    }

    Label {
      anchors.centerIn: parent
      visible: root.context.showFailure
      font.family: "Google Sans"
      text: "Incorrect password, Try Again."
      color: Colors.background
      font.weight: Font.Medium
      font.pixelSize: 15
      font.letterSpacing: 0.5
    }
  }
}
