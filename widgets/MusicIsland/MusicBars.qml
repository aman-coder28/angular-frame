import QtQuick

Row {
  id: root

  property real barWidth: 4
  property real barSpacing: 3
  property real maxHeight: 30
  property real borderRadius: 2
  property bool isPlaying: Music.activePlayer && Music.activePlayer.isPlaying

  height: maxHeight
  spacing: barSpacing

  Repeater {
    model: Cava.bars

    Rectangle {
      required property int index

      width: root.barWidth
      radius: root.borderRadius
      color: Colors.secondary
      anchors.bottom: parent.bottom
      height: {
        if (!root.isPlaying)
          return 2;
        var level = Cava.levels[index] || 0;
        return Math.max(2, Math.min(level * root.maxHeight, root.maxHeight));
      }

      Behavior on height {
        NumberAnimation {
          duration: 80
          easing.type: Easing.OutQuad
        }
      }

      anchors {
        leftMargin: 8
      }
    }
  }
}
