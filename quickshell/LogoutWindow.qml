import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Variants {
    id: root
    property color backgroundColor: "#ee18181b"
    property color buttonColor: "#2280ccff"
    property color buttonHoverColor: "#7780ccff"
    default property list<LogoutButton> buttons
    required property var loader

    model: Quickshell.screens
    PanelWindow {
        id: w

        property var modelData
        screen: modelData

        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

        color: "transparent"

        contentItem {
            focus: true
            Keys.onPressed: event => {
                if (event.key == Qt.Key_Escape)
                    root.loader.active = false;
                else {
                    for (let i = 0; i < buttons.length; i++) {
                        let button = buttons[i];
                        if (event.key == button.keybind) {
                            button.exec();
                            root.loader.active = false;
                        }
                    }
                }
            }
        }

        anchors {
            top: true
            left: true
            bottom: true
            right: true
        }

        Rectangle {
            color: backgroundColor
            anchors.fill: parent

            MouseArea {
                anchors.fill: parent
                onClicked: root.loader.active = false

                GridLayout {
                    anchors.centerIn: parent

                    width: parent.width * 0.75
                    height: parent.height * 0.5

                    columns: 3
                    columnSpacing: 4
                    rowSpacing: 4

                    Repeater {
                        model: buttons
                        delegate: Rectangle {
                            required property LogoutButton modelData

                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            color: ma.containsMouse ? buttonHoverColor : buttonColor
                            border.color: "#aa80ccff"
                            border.width: ma.containsMouse ? 0 : 1
                            radius: 12

                            MouseArea {
                                id: ma
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    modelData.exec();
                                    root.loader.active = false;
                                }
                            }

                            Image {
                                id: icon
                                anchors.centerIn: parent
                                source: modelData.icon
                                height: parent.width * 0.5
                                width: parent.width * 0.5
                                fillMode: Image.PreserveAspectFit
                            }

                            Text {
                                anchors {
                                    top: icon.bottom
                                    topMargin: 20
                                    horizontalCenter: parent.horizontalCenter
                                }

                                text: modelData.text
                                font.family: "Noto Sans"
                                font.pointSize: 20
                                color: "#eeeeee"
                            }
                        }
                    }
                }
            }
        }
    }
}
