import Quickshell

BarField {
    cursorShape: Qt.PointingHandCursor
    property bool showDate: false
    onClicked: {
      showDate = !showDate
    }
    Tooltip {
      text: Qt.formatDateTime(sysClock.date, "dddd, MMMM dd, yyyy")
      visible: hovered
    }

    BarText {
      text: Qt.formatDateTime(sysClock.date, showDate ? "yyyy-MM-dd" : "HH:mm")
    }

    SystemClock {
        id: sysClock
        precision: SystemClock.Minutes
    }
}
