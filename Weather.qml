import QtQuick
import Quickshell.Io

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
    // fetch.start();
  }

  function iconForCode(code) {
    if (code === 0)
      return "☀";
    if (code <= 2)
      return "⛅";
    if (code === 3)
      return "☁";
    if (code === 45 || code === 48)
      return "🌫";
    if (code <= 57)
      return "🌦";
    if (code <= 67)
      return "🌧";
    if (code <= 77)
      return "🌨";
    if (code <= 82)
      return "🌧";
    return "⛈";
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

  color: Colors.surface
  border.color: Colors.surface_variant
  border.width: 1
  radius: 16                 // match your sidebar cards
  height: 64
  width: parent.width

  Component.onCompleted: refresh()

  Timer {                    // auto-refresh every 10 min
    interval: 600000
    running: true
    repeat: true

    onTriggered: card.refresh()
  }

  Process {
    id: fetch

    command: ["sh", "-c", "--max-time", "10", "https://api.open-meteo.com/v1/forecast" + "?latitude=" + card.lat + "&longitude=" + card.lon + "&current=temperature_2m,apparent_temperature,weather_code," + "wind_speed_10m,relative_humidity_2m" + "&hourly=temperature_2m,weather_code,precipitation_probability" + "&daily=temperature_2m_max,temperature_2m_min,weather_code," + "precipitation_probability_max,sunrise,sunset" + "&forecast_days=7" + "&timezone=auto" + "&models=knmi_seamless"]

    stdout: StdioCollector {
      onStreamFinished: {
        try {
          console.log(text);
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
        if (text !== "") card.lastError = "weather: " + text;
        card.loading = false;
      }
    }

    onExited: {
      card.loading = false;
      if (!card.lastError && card.cur === null) card.lastError = "weather fetch failed";
    }
  }

  // ---- hover tint (body clicks sit below content) ----
  MouseArea {
    id: bodyMa

    anchors.fill: parent
    hoverEnabled: true
    z: -1
  }

  Rectangle {
    anchors.fill: parent
    radius: card.radius
    color: Colors.surface_variant
    opacity: bodyMa.containsMouse ? 0.25 : 0

    Behavior on opacity {
      NumberAnimation {
        duration: 120
      }
    }
  }

  Item {
    anchors.fill: parent
    anchors.margins: 10

    // ---- top row: icon + temp + city | refresh + hi/lo ----
    Item {
      id: topRow

      height: 22

      anchors {
        left: parent.left
        right: parent.right
        top: parent.top
      }

      Row {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        spacing: 8

        Text {                              // icon
          anchors.verticalCenter: parent.verticalCenter
          width: 22
          horizontalAlignment: Text.AlignHCenter
          text: card.loaded ? iconForCode(cur.weather_code) : "…"
          color: Colors.on_surface
          font.pixelSize: 16
        }

        Text {                              // temp
          anchors.verticalCenter: parent.verticalCenter
          text: card.loaded ? Math.round(cur.temperature_2m) + "°" : "—"
          color: Colors.on_surface
          font.family: "Inter"
          font.pixelSize: 18
          font.weight: Font.Bold
        }

        Text {                              // city label
          anchors.verticalCenter: parent.verticalCenter
          width: Math.min(implicitWidth, 90)
          elide: Text.ElideRight
          text: cityName
          color: Colors.secondary
          font.family: "Inter"
          font.pixelSize: 12
        }
      }

      Row {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        spacing: 8

        Rectangle {                         // refresh button
          width: 24
          height: 22
          radius: 8
          color: refreshMa.containsMouse ? Colors.surface_variant : "transparent"

          Text {
            anchors.centerIn: parent
            text: "⟳"
            color: Colors.secondary
            font.pixelSize: 13

            // spins while fetching — kept from the original
            RotationAnimation on rotation {
              running: card.loading
              from: 0
              to: 360
              duration: 900
              loops: Animation.Infinite
            }
          }

          MouseArea {
            id: refreshMa

            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onClicked: card.refresh()
          }
        }

        Text {                              // hi / lo
          anchors.verticalCenter: parent.verticalCenter
          text: card.loaded && daily ? "H " + Math.round(daily.temperature_2m_max[0]) + "°  L " + Math.round(daily.temperature_2m_min[0]) + "°" : ""
          color: Colors.secondary
          font.family: "Inter"
          font.pixelSize: 11
        }
      }
    }

    // ---- bottom row: desc · feels · wind ----
    Text {
      elide: Text.ElideRight
      text: {
        if (card.lastError !== "")
          return card.lastError;
        if (!card.loaded)
          return card.loading ? "Loading…" : "—";
        return descForCode(cur.weather_code) + " · feels " + Math.round(cur.apparent_temperature) + "°" + " · " + Math.round(cur.wind_speed_10m) + " km/h";
      }
      color: Colors.secondary
      font.family: "Inter"
      font.pixelSize: 11

      anchors {
        left: parent.left
        right: parent.right
        top: topRow.bottom
        topMargin: 4
      }
    }
  }
}
