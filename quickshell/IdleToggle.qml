import Quickshell.Wayland

BarField {
    property alias window: inhibitor.window

    cursorShape: Qt.PointingHandCursor
    onClicked: inhibitor.enabled = !inhibitor.enabled

    IdleInhibitor {
        id: inhibitor
    }

    NerdFontIcon {
        text: inhibitor.enabled ? "󰈈" : "󰈉"
    }

    Tooltip {
        visible: hovered
        text: `Idle Inhibitor: ${inhibitor.enabled ? "On" : "Off"}`
    }
}
