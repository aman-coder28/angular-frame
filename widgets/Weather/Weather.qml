import QtQuick
import QtQuick.Layouts
import "../.."

Rectangle {
  id: card

  color: Colors.surface_container
  radius: 12
  height: 180
  width: parent.width

  Component.onCompleted: {
    Service.loadCache();
    Service.refresh();
  }

  ColumnLayout {
    spacing: 23

    anchors {
      fill: parent
      margins: 12
    }

    RowLayout {
      spacing: 10

      Rectangle {
        color: "transparent"
        width: 50
        height: 50

        Image {
          asynchronous: true
          cache: true
          anchors.horizontalCenter: parent.horizontalCenter
          fillMode: Image.PreserveAspectFit
          width: 50
          height: 50
          source: "../../assets/" + Service.wmoIcon(Service.cur.weather_code) + ".svg"
        }
      }

      Item {
        Layout.fillWidth: true
      }

      ColumnLayout {
        width: 80
        spacing: 4

        Text {
          text: Service.loaded ? Service.cityName : Service.cached ? Service.cityName + " ⚡" : "..."
          font.family: "Google Sans"
          font.weight: 430
          font.pixelSize: 15
          color: Colors.secondary
          font.letterSpacing: 0.8
        }

        Text {
          text: Service.loaded || Service.cached ? Service.wmoIcon(Service.cur.weather_code).replace(/-/, " ") : "..."
          font.weight: Font.Medium
          font.family: "Google Sans"
          font.pixelSize: 16
          color: Colors.secondary
          Layout.alignment: Qt.AlignRight
          font.letterSpacing: 0.8
          font.capitalization: Font.Capitalize
        }
      }
    }

    RowLayout {
      spacing: 10
      Layout.alignment: Qt.AlignCenter

      ColumnLayout {
        spacing: 4

        Text {
          text: Service.loaded || Service.cached ? Math.round(Service.cur.temperature_2m) + "°" : "—"
          font.family: "Google Sans"
          font.weight: Font.Medium
          font.pixelSize: 50
          color: Colors.secondary
          font.letterSpacing: 0.7
          Layout.alignment: Qt.AlignLeft
        }

        Text {
          text: Service.loaded && Service.daily || Service.cached ? " " + Math.round(Service.daily.temperature_2m_max[0]) + "°  " + Math.round(Service.daily.temperature_2m_min[0]) + "°" : "°°°"
          color: Colors.secondary
          font.weight: Font.Medium
          font.family: "Google Sans"
          font.pixelSize: 17
          font.letterSpacing: 0.7
        }
      }

      Item {
        Layout.fillWidth: true
      }

      Rectangle {
        width: 100
        height: 80
        color: "transparent"
        Layout.alignment: Qt.AlignLeft

        ForcastRow {
          forecastData: Service.daily
        }
      }
    }
  }
}
