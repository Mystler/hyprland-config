import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

BarField {
    property string onIcon: "󰕾"
    property string offIcon: "󰖁"
    property var node: Pipewire.defaultAudioSink
    readonly property var audio: node.audio
    property real interval: 0.05

    cursorShape: Qt.PointingHandCursor
    property var ctlApp: Process {
        command: "hyprpwcenter"
    }
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    onClicked: ev => {
        if (ev.button === Qt.RightButton) {
            ctlApp.startDetached();
            return;
        }
        audio.muted = !audio.muted;
    }
    onWheel: wheel => {
        wheel.accepted = true;
        if (wheel.angleDelta.y < -20) {
            audio.volume = Math.max(0, audio.volume - interval);
        } else if (wheel.angleDelta.y > 20) {
            audio.volume = Math.min(1, audio.volume + interval);
        }
    }

    PwObjectTracker {
        objects: [node]
    }

    Tooltip {
        visible: hovered
        text: node.description
    }

    BarText {
        visible: !audio.muted
        text: `${Math.round(100 * audio.volume)}%`
    }

    NerdFontIcon {
        text: audio.muted ? offIcon : onIcon
    }
}
