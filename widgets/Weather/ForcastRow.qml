pragma ComponentBehavior: Bound
import QtQuick
import "../.."

Row {
  id: forecastRow

  property var forecastData: []

  function buildForecastModel(data) {
    const daily = data;
    const model = [];

    for (let i = 0; i < daily.time.length; i++) {
      model.push({
        day: dayAbbrev(daily.time[i]),
        icon: "../../assets/" + Service.wmoIcon(daily.weather_code[i]) + ".svg",
        number: Math.round(daily.temperature_2m_max[i]) + "°"
      });
    }

    return model;
  }

  function dayAbbrev(dateStr) {
    const [y, m, d] = dateStr.split("-").map(Number);
    return Qt.formatDate(new Date(y, m - 1, d), "ddd");
  }

  spacing: 7

  anchors {
    fill: parent
    rightMargin: 15
    topMargin: 12
  }

  Repeater {
    model: buildForecastModel(forecastData)

    Column {
      required property var modelData

      spacing: 3

      Text {
        text: forecastRow.forecastData ? modelData.day : "°°°"
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: "Google Sans"
        font.weight: Font.Normal
        font.pixelSize: 13
        color: Colors.secondary
        font.letterSpacing: 0.7
      }

      Image {
        asynchronous: true
        cache: true
        source: forecastRow.forecastData ? modelData.icon : "°°°"
        width: 26
        height: 26
        anchors.horizontalCenter: parent.horizontalCenter
        fillMode: Image.PreserveAspectFit
      }

      Text {
        text: forecastRow.forecastData ? modelData.number : "°°°"
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: "Google Sans"
        font.weight: Font.Medium
        font.pixelSize: 14
        color: Colors.secondary
        opacity: 0.7
      }
    }
  }
}
