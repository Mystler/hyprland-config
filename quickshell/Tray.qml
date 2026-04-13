pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

RowLayout {
    spacing: 4

    Repeater {
        model: SystemTray.items
        delegate: IconImage {
            id: iconImage

            required property SystemTrayItem modelData
            ToolTip {
                id: tooltip
                text: modelData.tooltipDescription || modelData.tooltipTitle
                visible: text && trayIconMA.containsMouse
                delay: 400
                popupType: Popup.Window

                background: Rectangle {
                    radius: 6
                    border.width: 1
                    border.color: Colors.primaryBorder
                    color: Colors.darkBg
                }
            }

            source: modelData?.icon ?? ""
            implicitSize: 16

            QsMenuOpener {
                id: trayMenuOpener
                menu: iconImage.modelData?.hasMenu ? iconImage.modelData.menu : null
            }

            ContextMenu.menu: TrayMenu {
                model: trayMenuOpener.children
            }

            MouseArea {
                id: trayIconMA
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton | Qt.MiddleButton
                anchors.fill: parent

                onClicked: mouse => {
                    if (mouse.button === Qt.LeftButton)
                        iconImage.modelData.activate();
                    else if (mouse.button === Qt.MiddleButton)
                        iconImage.modelData.secondaryActivate();
                }
            }
        }
    }

    component TrayMenu: Menu {
        id: trayMenu
        property alias model: iconImageMenuInstantiator.model
        popupType: Popup.Window

        background: Rectangle {
            implicitWidth: 200
            color: Colors.darkBg
            border.width: 2
            border.color: Colors.primaryBorder
            radius: 12
        }

        // Delegate handles sub menu opener entries while rest is handled by Instantiator
        delegate: MenuItem {
            id: subMenuItem
            readonly property int index: {
                for (let i = 0; i < subMenuItem.menu.count; i++) {
                    if (subMenuItem.menu.itemAt(i) === subMenuItem)
                        return i;
                }
                return -1;
            }

            readonly property int count: subMenuItem.menu.count

            background: Rectangle {
                color: subMenuItem.highlighted ? Colors.primaryBgHover : "transparent"
                topLeftRadius: index === 0 ? 12 : 0
                topRightRadius: index === 0 ? 12 : 0
                bottomLeftRadius: (index === count - 1) ? 12 : 0
                bottomRightRadius: (index === count - 1) ? 12 : 0

                // HoverEnabled on the parent doesn't work because it triggers the menu
                // Implement the effect manually instead
                MouseArea {
                    id: subMenuItemMA
                    hoverEnabled: true
                    anchors.fill: parent
                    onEntered: {
                        subMenuItem.menu.currentIndex = index;
                    }
                }
            }
        }

        Instantiator {
            id: iconImageMenuInstantiator

            onObjectAdded: (index, object) => {
                if (object instanceof Menu)
                    trayMenu.insertMenu(index, object);
                else
                    trayMenu.insertItem(index, object);
            }

            onObjectRemoved: (index, object) => {
                if (object instanceof Menu)
                    trayMenu.removeMenu(object);
                else
                    trayMenu.removeItem(object);
            }

            delegate: DelegateChooser {
                role: "isSeparator"

                DelegateChoice {
                    roleValue: false

                    delegate: DelegateChooser {
                        role: "hasChildren"

                        DelegateChoice {
                            roleValue: false

                            delegate: MenuItem {
                                id: menuItem

                                required property QsMenuEntry modelData
                                required property int index
                                hoverEnabled: true

                                background: Rectangle {
                                    color: menuItem.highlighted ? Colors.primaryBgHover : "transparent"
                                    topLeftRadius: index === 0 ? 12 : 0
                                    topRightRadius: index === 0 ? 12 : 0
                                    bottomLeftRadius: (index === count - 1) ? 12 : 0
                                    bottomRightRadius: (index === count - 1) ? 12 : 0
                                }

                                icon.source: modelData?.icon ?? ""
                                text: modelData?.text ?? ""

                                enabled: modelData?.enabled ?? false
                                checkable: modelData ? modelData.buttonType !== QsMenuButtonType.None : false

                                indicator: Loader {
                                    x: menuItem.mirrored ? menuItem.width - width - menuItem.rightPadding : menuItem.leftPadding
                                    y: menuItem.topPadding + (menuItem.availableHeight - height) / 2

                                    sourceComponent: {
                                        if (!menuItem.modelData)
                                            return null;
                                        if (menuItem.modelData.buttonType === QsMenuButtonType.CheckBox)
                                            return checkBoxComponent;
                                        else if (menuItem.modelData.buttonType === QsMenuButtonType.RadioButton)
                                            return radioButtonComponent;
                                        else
                                            return null;
                                    }
                                }

                                onTriggered: modelData.triggered()

                                Component {
                                    id: checkBoxComponent
                                    CheckBox {
                                        checkState: menuItem.modelData?.checkState ?? Qt.Unchecked
                                    }
                                }

                                Component {
                                    id: radioButtonComponent
                                    RadioButton {
                                        checked: menuItem.modelData?.checkState === Qt.Checked ?? false
                                    }
                                }
                            }
                        }

                        DelegateChoice {
                            roleValue: true

                            delegate: trayMenuComponent
                        }
                    }
                }

                DelegateChoice {
                    roleValue: true

                    delegate: MenuSeparator {
                        contentItem: Rectangle {
                            implicitHeight: 1
                            implicitWidth: 200
                            color: Colors.primaryBorder
                        }
                    }
                }
            }
        }
    }

    Component {
        id: trayMenuComponent

        TrayMenu {
            id: trayMenu
            required property QsMenuEntry modelData
            model: menuEntryOpener.children

            enabled: modelData?.enabled ?? false
            title: modelData?.text ?? ""

            QsMenuOpener {
                id: menuEntryOpener
                menu: trayMenu.modelData
            }
        }
    }
}
