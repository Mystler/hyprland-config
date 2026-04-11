import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

Repeater {
    model: SystemTray.items

    WrapperMouseArea {
        required property var modelData
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: event => {
            if (event.button === Qt.LeftButton && !modelData.onlyMenu) {
                modelData.activate();
            } else if (modelData.hasMenu) {
                menuAnchor.open();
            }
        }
        Image {
            source: modelData.icon
            sourceSize: Qt.size(16, 16)
        }
        QsMenuAnchor {
            id: menuAnchor
            anchor.item: parent
            anchor.edges: Edges.Bottom | Edges.Right
            menu: modelData.menu
        }
    }
}
