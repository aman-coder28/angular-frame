import QtQuick
import Quickshell.Io
import "../.."

Rectangle {
  id: root

  // ---- System Metrics ----
  property real cpu: 0
  property real ram: 0
  property real disk: 0
  property real temp: -1
  property real ramUsedGb: 0
  property real ramTotalGb: 0
  property real diskUsedGb: 0
  property real diskTotalGb: 0
  property real prevTotal: 0
  property real prevIdle: 0

  function parseOutput(text) {
    var section = "";
    var lines = text.split("\n");
    var memTotal = 0, memAvail = 0;
    var cpuUser = 0, cpuNice = 0, cpuSystem = 0, cpuIdle = 0;

    for (var i = 0; i < lines.length; i++) {
      var line = lines[i].trim();
      if (line.charAt(0) === "@") {
        section = line.substring(1);
        continue;
      }
      if (line === "")
        continue;
      if (section === "cpu") {
        var parts = line.split(/\s+/);
        if (parts.length >= 5) {
          cpuUser = parseInt(parts[1]) || 0;
          cpuNice = parseInt(parts[2]) || 0;
          cpuSystem = parseInt(parts[3]) || 0;
          cpuIdle = parseInt(parts[4]) || 0;

          var total = cpuUser + cpuNice + cpuSystem + cpuIdle;
          var idle = cpuIdle;

          if (prevTotal > 0) {
            var diffTotal = total - prevTotal;
            var diffIdle = idle - prevIdle;
            if (diffTotal > 0) {
              cpu = 1 - (diffIdle / diffTotal);
              cpu = Math.max(0, Math.min(1, cpu));
            }
          }
          prevTotal = total;
          prevIdle = idle;
        }
      } else if (section === "mem") {
        var m = /^(\w+):\s+(\d+)/.exec(line);
        if (m) {
          if (m[1] === "MemTotal")
            memTotal = parseInt(m[2]);
          else if (m[1] === "MemAvailable")
            memAvail = parseInt(m[2]);
        }
      } else if (section === "disk") {
        var d = line.split(/\s+/);
        if (d.length >= 2) {
          var totalBytes = parseInt(d[0]);
          var usedBytes = parseInt(d[1]);
          if (totalBytes > 0) {
            diskTotalGb = totalBytes / 1073741824;
            diskUsedGb = usedBytes / 1073741824;
            disk = usedBytes / totalBytes;
          }
        }
      } else if (section === "temp") {
        var t = parseInt(line);
        if (!isNaN(t) && t > 0) {
          temp = t > 1000 ? t / 1000 : t;  // Convert millidegrees
        }
      }
    }

    if (memTotal > 0) {
      ramTotalGb = memTotal / 1048576;
      ramUsedGb = (memTotal - memAvail) / 1048576;
      ram = 1 - (memAvail / memTotal);
      ram = Math.max(0, Math.min(1, ram));
    }

    cpuGauge.requestPaint();
    ramGauge.requestPaint();
    diskGauge.requestPaint();
  }

  width: parent.width
  implicitHeight: 113
  color: Colors.surface_container
  radius: 12

  // ---- Polling ----
  Timer {
    interval: 2000  // Update every 2 seconds
    running: true
    repeat: true
    triggeredOnStart: true

    onTriggered: pollProc.running = true
  }

  Process {
    id: pollProc

    running: false
    command: ["sh", "-c", "echo @cpu; head -1 /proc/stat; " + "echo @mem; grep -E '^(MemTotal|MemAvailable):' /proc/meminfo; " + "echo @disk; df -B1 --output=size,used / | tail -1; " + "echo @temp; cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null || echo 0"]

    stdout: StdioCollector {
      onStreamFinished: {
        parseOutput(text);
      }
    }
  }

  // ---- Layout ----
  Column {
    anchors.fill: parent
    anchors.margins: 14

    // Gauges Row
    Row {
      width: parent.width
      spacing: 10

      CircularGauge {
        id: cpuGauge

        value: cpu
        label: "CPU"
        sublabel: temp > 0 ? Math.round(temp) + "°C" : ""
        gaugeColor: cpu > 0.9 ? Colors.error : cpu > 0.7 ? "#ffb74d" : Colors.secondary
        size: 55
      }

      CircularGauge {
        id: ramGauge

        value: ram
        label: "RAM"
        sublabel: ramUsedGb.toFixed(1) + " / " + ramTotalGb.toFixed(1) + " GB"
        gaugeColor: ram > 0.9 ? Colors.error : ram > 0.7 ? "#ffb74d" : Colors.secondary
        size: 55
      }

      CircularGauge {
        id: diskGauge

        value: disk
        label: "Disk"
        sublabel: (diskTotalGb - diskUsedGb).toFixed(0) + " / " + (diskTotalGb).toFixed(0) + " GB"
        gaugeColor: disk > 0.9 ? Colors.error : disk > 0.7 ? "#ffb74d" : Colors.secondary
        size: 55
      }
    }

    // Spacer
    Item {
      width: parent.width
      height: 3
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
    }
  }
}
