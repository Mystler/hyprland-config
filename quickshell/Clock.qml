import Quickshell

BarField {
    cursorShape: Qt.PointingHandCursor
    property bool showDate: false
    onClicked: {
      showDate = !showDate
    }

    BarText {
      text: Qt.formatDateTime(sysClock.date, showDate ? "yyyy-MM-dd" : "HH:mm")
    }

    SystemClock {
        id: sysClock
        precision: SystemClock.Minutes
    }
}
