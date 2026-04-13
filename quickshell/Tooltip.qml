import QtQuick
import QtQuick.Controls

ToolTip {
    id: tooltip
    delay: 400
    popupType: Popup.Window
    y: 26

    background: Rectangle {
        radius: 6
        border.width: 1
        border.color: Colors.primaryBorder
        color: Colors.darkBg
    }
}
