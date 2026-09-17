import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../.."

Rectangle {
  id: card

  // ---- config ----
  property real lat: 9.03
  property real lon: 38.74
  property string cityName: "Addis Ababa"

  // ---- state ----
  property var cur: null
  property var daily: null
  property bool loading: false
  property string lastError: ""
  readonly property bool loaded: cur !== null && lastError === ""

  // ---- data: Open-Meteo, no API key ----
  function refresh() {
    loading = true;
    fetch.start();
  }

  function wmoIcon(code) {
    if (code === 0)
      return "clear-day";
    if (code === 1 || code === 2)
      return "partly-cloudy-day";
    if (code === 3)
      return "overcast-day";
    if (code === 45 || code === 48)
      return "fog-day";
    if ([51, 53, 55].includes(code))
      return "drizzle";
    if ([56, 57, 66, 67].includes(code))
      return "sleet";
    if ([61, 63, 65].includes(code))
      return "rain";
    if ([71, 73, 75, 77].includes(code))
      return "snow";
    if ([80, 81, 82].includes(code))
      return "rain";
    if ([85, 86].includes(code))
      return "snow";
    if (code === 95)
      return "thunderstorms-day";
    if ([96, 99].includes(code))
      return "thunderstorms-day-rain";
    return "not-available";
  }

  function descForCode(code) {
    if (code === 0)
      return "Clear";
    if (code <= 2)
      return "Partly cloudy";
    if (code === 3)
      return "Overcast";
    if (code === 45 || code === 48)
      return "Fog";
    if (code <= 57)
      return "Drizzle";
    if (code <= 67)
      return "Rain";
    if (code <= 77)
      return "Snow";
    if (code <= 82)
      return "Showers";
    return "Thunderstorm";
  }

  color: Colors.surface_container
  radius: 12
  height: 180
  width: parent.width

  Component.onCompleted: refresh()

  Timer {
    interval: 21600
    running: true
    repeat: true

    onTriggered: card.refresh()
  }

  Process {
    id: fetch

    running: true
    command: ["sh", "-c", "curl -sf 'https://api.open-meteo.com/v1/forecast" + "?latitude=" + card.lat + "&longitude=" + card.lon + "&current=temperature_2m,weather_code" + "&daily=temperature_2m_max,temperature_2m_min,weather_code," + "&forecast_days=3" + "&timezone=auto'"]

    stdout: StdioCollector {
      onStreamFinished: {
        try {
          const j = JSON.parse(text);
          card.cur = j.current;
          card.daily = j.daily;

          card.lastError = "";
        } catch (e) {
          card.lastError = "weather fetch failed";
        }
        card.loading = false;
      }
    }
    stderr: StdioCollector {
      onStreamFinished: {
        if (text !== "")
          card.lastError = "weather: " + text;
        card.loading = false;
      }
    }

    onExited: {
      card.loading = false;
      if (!card.lastError && card.cur === null)
        card.lastError = "weather fetch failed";
    }
  }

  ColumnLayout {
    spacing: 23

    anchors {
      fill: parent
      margins: 16
    }

    RowLayout {
      spacing: 10

      Rectangle {
        color: "transparent"
        width: 50
        height: 50

        Image {
          anchors.horizontalCenter: parent.horizontalCenter
          fillMode: Image.PreserveAspectFit
          width: 50
          height: 50
          source: "../../assets/" + wmoIcon(cur.weather_code)
        }
      }

      Item {
        Layout.fillWidth: true
      }

      ColumnLayout {
        width: 80
        spacing: 6

        Text {
          text: cityName
          font.family: "Google Sans"
          font.weight: Font.Normal
          font.pixelSize: 15
          color: Colors.secondary
          font.letterSpacing: 1
        }

        Text {
          text: card.loaded ? descForCode(cur.weather_code) : "..."
          font.weight: Font.Medium
          font.family: "Google Sans"
          font.pixelSize: 16
          color: Colors.secondary
          Layout.alignment: Qt.AlignRight
          font.letterSpacing: 0.7
        }
      }
    }

    RowLayout {
      spacing: 10
      Layout.alignment: Qt.AlignCenter

      ColumnLayout {
        spacing: 4

        Text {
          text: card.loaded ? Math.round(cur.temperature_2m) + "°" : "—"
          font.family: "Google Sans"
          font.weight: Font.Medium
          font.pixelSize: 50
          color: Colors.secondary
          font.letterSpacing: 0.7
          Layout.alignment: Qt.AlignLeft
        }

        Text {
          text: card.loaded && daily ? " " + Math.round(daily.temperature_2m_max[0]) + "°  " + Math.round(daily.temperature_2m_min[0]) + "°" : "°°°"
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
        width: 90
        height: 80
        color: "transparent"
        Layout.alignment: Qt.AlignLeft

        ForcastRow {
          forecastData: card.daily
        }
      }
    }
  }
}
