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
    color: Colors.surface_container
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

        implicitWidth: 400
        padding: 10
        focus: true
        enabled: !root.context.unlockInProgress
        echoMode: TextInput.Password
        inputMethodHints: Qt.ImhSensitiveData
        placeholderText: "Input Password"
        color: Colors.on_surface
        placeholderTextColor: Colors.secondary
        selectionColor: Colors.primary

        background: Rectangle {
          radius: 10
          color: Colors.surface_container
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

        text: "Unlock"
        padding: 10
        radius: 8
        focusPolicy: Qt.NoFocus
        enabled: !root.context.unlockInProgress && root.context.currentText !== ""

        background: Rectangle {
          radius: myButton.radius
          color: Colors.surface_container
        }
        contentItem: Text {
          text: myButton.text
          anchors.centerIn: parent
          color: Colors.secondary
        }

        onClicked: root.context.tryUnlock()
      }
    }

    Label {
      visible: root.context.showFailure
      font.family: "Google Sans"
      text: "Incorrect password, Try Again."
      color: Colors.surface_container
    }
  }
}
