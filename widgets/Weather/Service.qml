pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  property real lat: 9.03
  property real lon: 38.74
  property string cityName: "Addis Ababa"
  property var cur: null
  property var daily: null
  property bool loading: false
  property string lastError: ""
  readonly property bool loaded: cur !== null && lastError === ""
  property bool cached: false
  readonly property int maxCacheAge: 12 * 60 * 60 * 1000

  function refresh() {
    loading = true;

    fetch.running = true;
  }

  function wmoIcon(code): string {
    if (code === 0)
      return "clear";
    if (code === 1 || code === 2)
      return "partly-cloudy";
    if (code === 3)
      return "overcast";
    if (code === 45 || code === 48)
      return "fog";
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
      return "thunderstorms";
    if ([96, 99].includes(code))
      return "thunderstorms-rain";
    return "not-available";
  }

  function saveCache() {
    cacheFile.setText(JSON.stringify({
      savedAt: Date.now(),
      current: cur,
      daily: daily
    }));
  }

  function loadCache(): bool {
    const text = cacheFile.text();

    if (!text)
      return false;
    try {
      const j = JSON.parse(text);
      if (!j.savedAt || Date.now() - j.savedAt > maxCacheAge)
        return false;

      cur = j.current;
      daily = j.daily;
      cached = true;
      return true;
    } catch (e) {
      return false;
    }
  }

  FileView {
    id: cacheFile

    path: Quickshell.env("HOME") + "/.cache/quickshell/weather.json"
  }

  Timer {
    interval: 21600
    running: true
    repeat: true

    onTriggered: refresh()
  }

  Process {
    id: fetch

    running: true
    command: ["sh", "-c", "curl -sf 'https://api.open-meteo.com/v1/forecast" + "?latitude=" + lat + "&longitude=" + lon + "&current=temperature_2m,weather_code" + "&daily=temperature_2m_max,temperature_2m_min,weather_code," + "&forecast_days=3" + "&timezone=auto'"]

    stdout: StdioCollector {
      onStreamFinished: {
        try {
          const j = JSON.parse(text);
          cur = j.current;
          daily = j.daily;

          lastError = "";

          cached = false;
          saveCache();
        } catch (e) {
          lastError = "weather fetch failed";
        }
        loading = false;
      }
    }
    stderr: StdioCollector {
      onStreamFinished: {
        if (text !== "")
          lastError = "weather: " + text;
        loading = false;
      }
    }

    onExited: exitCode => {
      loading = false;

      if (exitCode !== 0 && cur === null) {
        if (!loadCache())
          lastError = "offline, no cached weather";
      }
    }
  }
}
