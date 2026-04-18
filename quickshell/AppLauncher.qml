import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets

PanelWindow {
    id: root
    focusable: true
    aboveWindows: true
    exclusionMode: ExclusionMode.Ignore
    anchors.top: true
    anchors.left: true
    anchors.bottom: true
    anchors.right: true
    color: "transparent"

    function launchSelected() {
        if (appList.currentIndex >= 0 && appList.currentIndex < appList.count) {
            appList.model.values[appList.currentIndex].execute();
            Global.showAppLauncher = false;
        }
    }

    contentItem {
        Keys.onEscapePressed: Global.showAppLauncher = false
        Keys.onReturnPressed: launchSelected()
        Keys.onUpPressed: appList.decrementCurrentIndex()
        Keys.onDownPressed: appList.incrementCurrentIndex()
    }

    MouseArea {
        anchors.fill: parent
        onClicked: Global.showAppLauncher = false

        ClippingRectangle {
            implicitWidth: 300
            implicitHeight: 200
            x: 6
            y: 36
            radius: 12
            border.width: 2
            border.color: Colors.primaryBorder
            color: Colors.darkBg

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                TextInput {
                    id: searchInput
                    padding: 6
                    Layout.fillWidth: true
                    color: Colors.textLight
                    focus: true
                    Component.onCompleted: forceActiveFocus()
                    onTextChanged: appList.currentIndex = 0
                }

                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 2
                    color: Colors.primaryBorder
                }

                ScrollView {
                    id: scroll
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    contentHeight: appList.contentHeight
                    clip: true

                    ScrollBar.vertical {
                        contentItem: Rectangle {
                            implicitWidth: 3
                            color: Colors.primaryBorder
                            radius: 4
                        }
                    }

                    ListView {
                        id: appList
                        width: parent.availableWidth
                        model: ScriptModel {
                            values: [...DesktopEntries.applications.values].sort((a, b) => {
                                const lca = a.name.toLowerCase();
                                const lcb = b.name.toLowerCase();
                                if (lca < lcb)
                                    return -1;
                                if (lca > lcb)
                                    return 1;
                                return 0;
                            }).filter(x => x.name.toLowerCase().includes(searchInput.text.toLowerCase()))
                        }

                        delegate: WrapperMouseArea {
                            id: itemMA
                            width: ListView.view.width
                            hoverEnabled: true
                            required property var modelData
                            required property int index

                            onEntered: appList.currentIndex = index
                            onClicked: root.launchSelected()

                            WrapperRectangle {
                                margin: 6
                                color: appList.currentIndex === index ? Colors.primaryBgHover : "transparent"

                                RowLayout {
                                    anchors.leftMargin: 6
                                    anchors.rightMargin: 6
                                    spacing: 4
                                    anchors.fill: parent

                                    IconImage {
                                        implicitSize: 16
                                        source: Quickshell.iconPath(modelData.icon)
                                    }

                                    Text {
                                        text: modelData.name
                                        color: Colors.textLight
                                        Layout.fillWidth: true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
