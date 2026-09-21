pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
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
          temp = t > 1000 ? t / 1000 : t;
        }
      }
    }

    if (memTotal > 0) {
      ramTotalGb = memTotal / 1048576;
      ramUsedGb = (memTotal - memAvail) / 1048576;
      ram = 1 - (memAvail / memTotal);
      ram = Math.max(0, Math.min(1, ram));
    }
  }

  Timer {
    interval: 2000
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
}
