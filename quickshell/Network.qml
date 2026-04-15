import Quickshell.Networking

BarField {
    readonly property var device: {
        // Display first connected
        let display = Networking.devices.values.find(x => x.connected);
        // Fallback to first Wifi
        if (!display)
            display = Networking.devices.values.find(x => x.type === DeviceType.Wifi);
        return display;
    }
    readonly property var network: {
        if (!device || device.type !== DeviceType.Wifi)
            return null;
        return device.networks.values.find(x => x.connected);
    }

    NerdFontIcon {
        text: {
            if (device.type !== DeviceType.Wifi) {
                if (device.connected)
                    return "󰲝";
                else
                    return "󰲜";
            }
            const strLevel = Math.round((network?.signalStrength ?? 0) * 4);
            if (Networking.connectivity === NetworkConnectivity.Full) {
                const icons = ["󰤯", "󰤟", "󰤢", "󰤥", "󰤨"];
                return icons[strLevel];
            }
            if (Networking.connectivity === NetworkConnectivity.Portal) {
                const icons = ["󱛏", "󱛋", "󱛌", "󱛍", "󱛎"];
                return icons[strLevel];
            }
            if (Networking.connectivity === NetworkConnectivity.Limited) {
                const icons = ["󰤫", "󰤠", "󰤣", "󰤦", "󰤩"];
                return icons[strLevel];
            }
            if (device && device.state === ConnectionState.Connecting)
                return "󱛄";
            return "󰖪";
        }
    }

    Tooltip {
        visible: hovered && text
        text: {
            if (network && network.connected && network.signalStrength)
                return `${Math.round(100 * network.signalStrength)}% in ${network.name}`;
            if (device && device.state === ConnectionState.Connecting)
                return "Connecting...";
            if (Networking.connectivity === NetworkConnectivity.None)
                return "Disconnected";
            return "";
        }
    }

    acceptedButtons: Qt.RightButton
    onClicked: {
        Networking.wifiEnabled = false;
        Networking.wifiEnabled = true;
    }
}
