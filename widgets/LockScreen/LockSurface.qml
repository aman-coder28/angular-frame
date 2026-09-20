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
    blurEnabled: true
    blur: 0.9
    blurMax: 32
    visible: wallpaperImage.status === Image.Ready
  }

  Image {
    id: wallpaperImage

    anchors.fill: parent
    asynchronous: true
    cache: true
    source: "fairy-tale.webp"
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

  Rectangle {
    anchors.fill: parent
    color: "#000000"
    opacity: 0.45
  }

  Label {
    id: clock

    property var date: new Date()

    renderType: Text.NativeRendering
    font.pointSize: 80
    font.family: "Google Sans"
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

    // updates the clock every second
    Timer {
      running: true
      repeat: true
      interval: 1000

      onTriggered: clock.date = new Date()
    }
  }

  ColumnLayout {
    // Uncommenting this will make the password entry invisible except on the active monitor.
    // visible: Window.active

    anchors {
      horizontalCenter: parent.horizontalCenter
      top: parent.verticalCenter
    }

    RowLayout {
      TextField {
        id: passwordBox

        implicitWidth: 400
        padding: 10
        focus: true
        enabled: !root.context.unlockInProgress
        echoMode: TextInput.Password
        inputMethodHints: Qt.ImhSensitiveData
        placeholderText: "Input Password"
        placeholderTextColor: "gray"
        selectionColor: "blue"
        color: "black"

        background: Rectangle {
          radius: 10
          color: Colors.primary
        }

        // Update the text in the context when the text in the box changes.
        onTextChanged: root.context.currentText = this.text

        // Try to unlock when enter is pressed.
        onAccepted: root.context.tryUnlock()

        // Update the text in the box to match the text in the context.
        // This makes sure multiple monitors have the same text.
        Connections {
          function onCurrentTextChanged() {
            passwordBox.text = root.context.currentText;
          }

          target: root.context
        }
      }

      RoundButton {
        id: myButton

        text: "Unlock"
        padding: 10
        radius: 8

        // don't steal focus from the text box
        focusPolicy: Qt.NoFocus
        enabled: !root.context.unlockInProgress && root.context.currentText !== ""

        background: Rectangle {
          // Preserve rounded corners
          radius: myButton.radius

          // Dynamic colors based on state
          color: Colors.primary
        }
        contentItem: Text {
          text: myButton.text
          anchors.centerIn: parent
          color: "black"
        }

        onClicked: root.context.tryUnlock()
      }
    }

    Label {
      visible: root.context.showFailure
      font.family: "Google Sans"
      text: "Incorrect password, Try Again."
      color: Colors.inverse_surface
    }
  }
}
