import QtQuick
import Quickshell.Io

BarField {
    BarText {
        text: SystemInfo.brightness
    }

    NerdFontIcon {
        text: {
            const icons = ["", "", "", "", "", "", "", "", "", "", "󰽢"];
            return icons[SystemInfo.brightness];
        }
    }

    Tooltip {
        text: "Brightness"
        visible: hovered
    }

    property var brightnessCtl: Process {
        command: ["brightnessctl", "s", "5"]
    }
    onWheel: wheel => {
        if (wheel.angleDelta.y > 50) {
            brightnessCtl.command[2] = "+1";
            brightnessCtl.startDetached();
        } else if (wheel.angleDelta.y < -50) {
            brightnessCtl.command[2] = "1-";
            brightnessCtl.startDetached();
        }
    }
}
