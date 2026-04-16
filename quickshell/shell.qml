//@ pragma UseQApplication
import QtQuick
import Quickshell
import Quickshell.Io

ShellRoot {
    Bar {}

    // Logout Screen
    IpcHandler {
        target: "logout"

        function reveal(): void {
            Global.showLogoutWindow = true;
        }
    }
    Loader {
        active: Global.showLogoutWindow
        sourceComponent: LogoutWindow {
            LogoutButton {
                command: "hyprshutdown"
                keybind: Qt.Key_H
                text: "Exit Hyprland"
                icon: "/home/mystler/Pictures/hyprland-logo.svg"
            }

            LogoutButton {
                command: "hyprshutdown -t 'Shutting down...' --post-cmd 'shutdown now'"
                keybind: Qt.Key_S
                text: "Shutdown"
                icon: Quickshell.iconPath("system-shutdown")
            }

            LogoutButton {
                command: "hyprshutdown -t 'Rebooting...' --post-cmd 'reboot'"
                keybind: Qt.Key_R
                text: "Reboot"
                icon: Quickshell.iconPath("system-reboot")
            }
        }
    }

    // App Launcher
    IpcHandler {
        target: "launcher"

        function reveal(): void {
            Global.showAppLauncher = true;
        }
    }
    Loader {
        active: Global.showAppLauncher
        sourceComponent: AppLauncher {}
    }
}
