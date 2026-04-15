import Quickshell.Bluetooth
import Quickshell.Io

BarField {
    NerdFontIcon {
        text: {
            if (!Bluetooth.defaultAdapter?.enabled)
                return "󰂲";
            return "󰂯";
        }
    }

    Tooltip {
        visible: hovered
        text: {
            if (!Bluetooth.defaultAdapter?.enabled)
                return "Disabled";
            const devs = Bluetooth.defaultAdapter.devices.values.map(x => x.name);
            return `${devs.length} connected` + devs.length > 0 ? `\n\n${devs.join("\n")}` : "";
        }
    }

    cursorShape: Qt.PointingHandCursor
    property var btApp: Process {
        command: "blueman-manager"
    }
    onClicked: btApp.startDetached()
}
