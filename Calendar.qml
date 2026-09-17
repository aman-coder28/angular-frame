import QtQuick

Rectangle {
  width: parent.width
  height: parent.height
  color: Colors.surface_container

  anchors {
    fill: parent
    margins: 11
  }

  Column {
    id: root

    property int year: new Date().getFullYear()
    property int month: new Date().getMonth()
    readonly property var today: {
      const d = new Date();
      return {
        year: d.getFullYear(),
        month: d.getMonth(),
        day: d.getDate()
      };
    }
    readonly property int firstWeekday: new Date(root.year, root.month, 1).getDay()
    readonly property int daysInMonth: new Date(root.year, root.month + 1, 0).getDate()
    readonly property int daysInPrev: new Date(root.year, root.month, 0).getDate()
    readonly property string monthLabel: {
      const names = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
      return names[root.month] + " " + root.year;
    }

    // Per-column width so 7 columns exactly fill the card
    readonly property real cellW: (grid.width - grid.spacing * 6) / 7

    function cellDay(i) {
      const d = i - root.firstWeekday + 1;
      if (d >= 1 && d <= root.daysInMonth)
        return d;
      if (d < 1)
        return root.daysInPrev + d;
      return d - root.daysInMonth;
    }

    function inMonth(i) {
      const d = i - root.firstWeekday + 1;
      return d >= 1 && d <= root.daysInMonth;
    }

    function isToday(i) {
      return inMonth(i) && root.month === root.today.month && root.year === root.today.year && cellDay(i) === root.today.day;
    }

    function prevMonth() {
      month--;
      if (month < 0) {
        month = 11;
        year--;
      }
    }

    function nextMonth() {
      month++;
      if (month > 11) {
        month = 0;
        year++;
      }
    }

    width: 210
    height: 210
    spacing: 10
    anchors.fill: parent

    // ---- Header: month/year + navigation ----
    Item {
      width: parent.width
      height: 26

      Row {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter

        NavButton {
          glyph: "‹"
          action: root.prevMonth
        }
      }

      Row {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        NavButton {
          glyph: "›"
          action: root.nextMonth
        }
      }

      Text {
        anchors.centerIn: parent
        text: root.monthLabel
        color: Colors.secondary
        font.family: "Inter"
        font.pixelSize: 14
        font.weight: 600
      }
    }

    // ---- Weekday header ----
    Grid {
      width: parent.width
      columns: 7
      spacing: 2

      Repeater {
        model: ["S", "M", "T", "W", "T", "F", "S"]

        delegate: Text {
          required property string modelData

          width: root.cellW
          height: 13
          text: modelData
          color: Colors.secondary
          opacity: 0.6
          font.family: "Inter"
          font.pixelSize: 11
          font.weight: 600
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
        }
      }
    }

    // ---- Day grid (fixed 6 weeks so height never jumps) ----
    Grid {
      id: grid

      width: parent.width
      columns: 7
      spacing: 2

      Repeater {
        model: 42

        delegate: Rectangle {
          required property int index

          width: root.cellW
          height: 25.5
          radius: 180
          color: root.isToday(index) ? Colors.secondary : "transparent"

          Text {
            anchors.centerIn: parent
            text: root.cellDay(index)
            color: root.isToday(index) ? Colors.background : Colors.secondary
            opacity: root.inMonth(index) ? 1 : 0.35
            font.family: "Inter"
            font.weight: 430
            font.pixelSize: 13
          }
        }
      }
    }
  }

  // Small reusable nav button
  component NavButton: Rectangle {
    property string glyph
    property var action

    width: 22
    height: 22
    radius: 11
    color: hover.containsMouse ? Colors.surface_variant : "transparent"

    Text {
      anchors.centerIn: parent
      text: glyph
      color: Colors.secondary
      font.family: "Inter"
      font.pixelSize: 13
    }

    MouseArea {
      id: hover

      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor

      onClicked: action()
    }
  }
}
