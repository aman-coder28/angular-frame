import QtQuick
import "../.."

Rectangle {
  id: root

  width: parent.width
  implicitHeight: 113
  color: Colors.surface_container
  radius: 12

  Column {
    anchors.fill: parent
    anchors.margins: 14

    // Gauges Row
    Row {
      width: parent.width
      spacing: 12

      CircularGauge {
        id: cpuGauge

        value: Service.cpu
        label: "CPU"
        sublabel: Service.temp > 0 ? Math.round(Service.temp) + "°C" : ""
        gaugeColor: Service.cpu > 0.9 ? Colors.error : Service.cpu > 0.7 ? "#ffb74d" : Colors.secondary
        size: 55
      }

      CircularGauge {
        id: ramGauge

        value: Service.ram
        label: "RAM"
        sublabel: Service.ramUsedGb.toFixed(1) + " / " + Service.ramTotalGb.toFixed(1) + " GB"
        gaugeColor: Service.ram > 0.9 ? Colors.error : Service.ram > 0.7 ? "#ffb74d" : Colors.secondary
        size: 55
      }

      CircularGauge {
        id: diskGauge

        value: Service.disk
        label: "Disk"
        sublabel: Service.diskUsedGb.toFixed(0) + " / " + Service.diskTotalGb.toFixed(0) + " GB"
        gaugeColor: Service.disk > 0.9 ? Colors.error : Service.disk > 0.7 ? "#ffb74d" : Colors.secondary
        size: 55
      }
    }
  }

  // ---- Gauge Component ----
  component CircularGauge: Item {
    property real value: 0  // 0.0 to 1.0
    property string label: ""
    property string sublabel: ""
    property color gaugeColor: Colors.secondary
    property real size: 80
    property real thickness: 6

    width: size
    height: size + 40

    Behavior on value {
      NumberAnimation {
        duration: 1000             // Takes 1 second to reach the new value
        easing.type: Easing.InOutQuad // Smooth acceleration and deceleration
      }
    }

    onValueChanged: gaugeCanvas.requestPaint()

    // Gauge arc
    Canvas {
      id: gaugeCanvas

      anchors.centerIn: parent
      width: size
      height: size
      anchors.verticalCenterOffset: 18

      onPaint: {
        var ctx = getContext("2d");
        ctx.reset();

        var centerX = width / 2;
        var centerY = height / 2;
        var radius = (width - thickness) / 2;
        var startAngle = 0.75 * Math.PI;  // 135 degrees
        var endAngle = 2.25 * Math.PI;    // 315 degrees (270 degree arc)

        // Background arc
        ctx.beginPath();
        ctx.arc(centerX, centerY, radius, startAngle, endAngle);
        ctx.strokeStyle = Colors.surface_variant;
        ctx.lineWidth = thickness;
        ctx.lineCap = "round";
        ctx.stroke();

        // Value arc
        if (value > 0) {
          var currentAngle = startAngle + (value * (endAngle - startAngle));
          ctx.beginPath();
          ctx.arc(centerX, centerY, radius, startAngle, currentAngle);
          ctx.strokeStyle = gaugeColor;
          ctx.lineWidth = thickness;
          ctx.lineCap = "round";
          ctx.stroke();
        }

        // Percentage text
        ctx.fillStyle = Colors.on_surface;
        ctx.font = "bold 11px Inter";
        ctx.textAlign = "center";
        ctx.textBaseline = "middle";
        ctx.fillText(Math.round(value * 100) + "%", centerX, centerY);
      }
    }

    // Label
    Text {
      anchors.top: parent.top
      anchors.horizontalCenter: parent.horizontalCenter
      text: label
      color: Colors.secondary
      font.family: "Google Sans"
      font.pixelSize: 12
      font.weight: 600
      font.letterSpacing: 0.5
    }

    // Sublabel (e.g., "4.2 / 16 GB")
    Text {
      anchors.top: parent.top
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.topMargin: 17
      text: sublabel
      color: Colors.secondary
      opacity: 0.7
      font.weight: 500
      font.family: "Google Sans"
      font.pixelSize: 10
      font.letterSpacing: 0.3
    }
  }
}
