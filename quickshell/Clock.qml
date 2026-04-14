import Quickshell

BarField {
    Tooltip {
        text: Qt.formatDateTime(sysClock.date, "dddd, MMMM dd, yyyy")
        visible: hovered
    }

    BarText {
        text: Qt.formatDateTime(sysClock.date, "HH:mm")
    }

    SystemClock {
        id: sysClock
        precision: SystemClock.Minutes
    }
}
