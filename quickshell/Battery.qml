import QtQuick
import Quickshell
import Quickshell.Services.UPower

Loader {
    visible: active
    active: UPower.displayDevice.type === UPowerDeviceType.Battery

    sourceComponent: BarField {
        property int percent: Math.round(100 * UPower.displayDevice.percentage)
        property bool charging: UPower.displayDevice.state === UPowerDeviceState.Charging

        bgColor: {
            if (!charging && percent <= 15)
                return hovered ? Colors.alertBgHover : Color.alertBg;
            if (charging || percent >= 100)
                return hovered ? Colors.greenBgHover : Colors.greenBg;
            return hovered ? Colors.primaryBgHover : Colors.primaryBg;
        }

        BarText {
            text: `${percent}%`
        }

        NerdFontIcon {
            text: {
                if (charging) {
                    const icons = ["󰢟", "󰢜", "󰂆", "󰂇", "󰂈", "󰢝", "󰂉", "󰢞", "󰂊", "󰂋", "󰂅"];
                    return icons[Math.round(percent / 10)];
                } else {
                    const icons = ["󰂎", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"];
                    return icons[Math.round(percent / 10)];
                }
            }
        }

        Tooltip {
            visible: hovered
            text: {
                if (percent >= 100)
                    return "Full";
                const time = UPower.displayDevice.timeToFull || UPower.displayDevice.timeToEmpty;
                const hours = Math.floor(time / 3600);
                const minutes = Math.floor(time % 3600 / 60);
                return `${hours} h ${minutes} min ${!charging ? "remaining" : "to full"}`;
            }
        }
    }
}
