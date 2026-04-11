import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: root

    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: 30
    color: "transparent"

    RowLayout {
        anchors.fill: parent
        anchors.margins: 4
        spacing: 4

        // Logo
        Image {
            source: "/home/mystler/Pictures/hyprland-logo.svg"
            sourceSize: Qt.size(10, 20)
            fillMode: Image.PreserveAspectFit

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                property var launcher: Process {
                    command: "hyprlauncher"
                }
                onClicked: launcher.startDetached()
            }
        }

        // Workspaces
        Repeater {
            model: Hyprland.workspaces

            WrapperMouseArea {
                id: wsHover
                required property int index
                required property var modelData
                property bool isActive: modelData.focused
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (!isActive)
                        modelData.activate();
                }

                WrapperRectangle {
                    leftMargin: 10
                    rightMargin: 10
                    topMargin: 2
                    bottomMargin: 2
                    radius: 12
                    color: wsHover.containsMouse ? Colors.primaryBgHover : isActive ? Colors.primaryBg : Colors.primaryBgDim

                    RowLayout {
                        spacing: 4

                        BarText {
                            text: modelData.id
                        }

                        Repeater {
                            model: modelData.toplevels

                            Image {
                                required property var modelData

                                fillMode: Image.PreserveAspectFit
                                sourceSize: Qt.size(16, 16)
                                source: {
                                    const icon = DesktopEntries.heuristicLookup(modelData?.wayland?.appId)?.icon;
                                    return Quickshell.iconPath(icon, "application-x-object");
                                }
                            }
                        }
                    }
                }
            }
        }

        // Current Window
        BarText {
            function getTitle() {
                if (!Hyprland.activeToplevel)
                    return "";
                if (Hyprland.activeToplevel?.workspace !== Hyprland.focusedWorkspace)
                    return "";
                return Hyprland.activeToplevel.title;
            }
            text: getTitle()
            Layout.fillWidth: true
            clip: true
        }

        // Clock
        BarText {
            id: clock
            text: Qt.formatDateTime(sysClock.date, "HH:mm")

            SystemClock {
                id: sysClock
                precision: SystemClock.Minutes
            }
        }

        Tray {}

        // Lock
        WrapperMouseArea {
            leftMargin: 4
            rightMargin: 4
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            property var process: Process {
                command: ["hyprlock"]
            }
            onClicked: process.startDetached()

            NerdFontIcon {
                text: ""
                color: parent.containsMouse ? Colors.primary : Colors.textLight
            }
        }

        // Logout Menu Caller
        WrapperMouseArea {
            leftMargin: 4
            rightMargin: 4
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            property var process: Process {
                command: ["qs", "ipc", "call", "logout", "reveal"]
            }
            onClicked: process.startDetached()

            NerdFontIcon {
                text: ""
                color: parent.containsMouse ? Colors.primary : Colors.textLight
            }
        }
    }
}
