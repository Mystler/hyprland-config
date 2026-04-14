pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property real lastCpuIdle
    property real lastCpuTotal
    property real cpuPerc

    property real usedMemory
    property real usedMemoryPerc

    // Real-time CPU Usage
    FileView {
        id: procStat
        path: "file:///proc/stat"

        onLoaded: {
            const cpuTimes = text().split(' ').slice(2, 9).map(Number);

            const idle = cpuTimes[3] + cpuTimes[4];
            const total = cpuTimes.reduce((acc, cur) => acc + cur, 0);

            const idleDiff = idle - root.lastCpuIdle;
            const totalDiff = total - root.lastCpuTotal;

            root.cpuPerc = root.lastCpuTotal > 0 && totalDiff > 0 ? 100 * (1 - idleDiff / totalDiff) : 0;

            root.lastCpuIdle = idle;
            root.lastCpuTotal = total;
        }
    }

    // Memory Usage
    FileView {
        id: procMemInfo
        path: "file:///proc/meminfo"

        onLoaded: {
            const memNumbers = text().split('\n').map(m => parseInt(m.split(':')[1]));

            root.usedMemory = (memNumbers[0] - memNumbers[2]) / (1024 * 1024);
            root.usedMemoryPerc = 100 * (1 - memNumbers[2] / memNumbers[0]);
        }
    }

    // Update Timers
    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            procStat.reload();
            procMemInfo.reload();
        }
    }
}
