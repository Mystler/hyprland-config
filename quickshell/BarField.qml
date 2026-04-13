import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets

WrapperMouseArea {
    id: root
    default property alias content: contentLayout.data
    readonly property alias hovered: root.containsMouse
    hoverEnabled: true

    WrapperRectangle {
        leftMargin: 10
        rightMargin: 10
        topMargin: 2
        bottomMargin: 2
        radius: 12
        color: {
            if (root.containsMouse)
                return Colors.primaryBgHover;
            return Colors.primaryBg;
        }

        RowLayout {
            id: contentLayout
            spacing: 4
        }
    }
}
