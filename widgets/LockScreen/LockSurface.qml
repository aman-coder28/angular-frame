import QtQuick
import QtQuick.Controls.Fusion
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell.Io

Rectangle {
  id: root

  required property LockContext context
  property string image: ""

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

    onClicked: context.unlocked()
  }

  MultiEffect {
    id: wallpaperImageBlur

    anchors.fill: parent
    source: wallpaperImage
    // blurEnabled: true
    // blur: 0.4
    // blurMax: 22
    visible: wallpaperImage.status === Image.Ready
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

  Label {
    id: clock

    property var date: new Date()

    renderType: Text.NativeRendering
    font.pointSize: 80
    font.family: "Google Sans"
    font.weight: Font.Bold
    font.letterSpacing: 0.7
    color: Colors.secondary
    text: {
      const hours = this.date.getHours().toString().padStart(2, '0');
      const minutes = this.date.getMinutes().toString().padStart(2, '0');
      return `${hours}:${minutes}`;
    }

    anchors {
      horizontalCenter: parent.horizontalCenter
      top: parent.top
      topMargin: 100
    }

    Timer {
      running: true
      repeat: true
      interval: 1000

      onTriggered: clock.date = new Date()
    }
  }

  ColumnLayout {
    anchors {
      horizontalCenter: parent.horizontalCenter
      top: parent.verticalCenter
    }

    RowLayout {
      TextField {
        id: passwordBox

        property var passwordIcons: ["●", "◆", "✦", "❄", "✻"]
        property var passwordSequence: []

        function getRandomIcon(): string {
          return passwordIcons[Math.floor(Math.random() * passwordIcons.length)];
        }

        implicitWidth: 400
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

        implicitWidth: root.context.unlockInProgress ? 50 : 65
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

          Text {
            text: "Unlock"
            anchors.centerIn: parent
            color: Colors.background
            opacity: !root.context.unlockInProgress ? 1 : 0
          }

          Image {
            id: spinner

            anchors.centerIn: parent
            opacity: root.context.unlockInProgress ? 1 : 0
            source: "assets/spinner.svg"
            width: 24
            height: 24

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

    Rectangle {
      implicitHeight: 38
      implicitWidth: 250
      color: Colors.secondary
      radius: 8
      opacity: root.context.showFailure ? 1 : 0

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
}
