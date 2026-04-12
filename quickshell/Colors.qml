pragma Singleton
import Quickshell
import QtQuick

Singleton {
    function alpha(alpha: real, color: color): color {
        return Qt.rgba(color.r, color.g, color.b, alpha);
    }

    property color textLight: "#eeeeee"
    property color primary: "#80ccff"
    property color primaryBg: alpha(0.2, primary)
    property color primaryBgDim: alpha(0.1, primary)
    property color primaryBgHover: alpha(0.33, primary)
    property color primaryBorder: alpha(0.66, primary)
    property color alert: "#f05050"
    property color alertBg: alpha(0.5, alert)
    property color alertBgHover: alpha(0.75, alert)
    property color dark: "#18181b"
    property color darkBg: alpha(0.9, dark)
}
