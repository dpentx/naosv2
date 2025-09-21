// VolumeWidget.qml
import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Rectangle {
    id: root
    
    property int volumeLevel: 50
    property bool isMuted: false
    property bool popupVisible: false
    
    width: volumeLayout.implicitWidth + 12
    height: 32
    radius: 6
    color: popupVisible ? "#45475a" : "transparent"
    border.width: 1
    border.color: "#6c7086"
    
    RowLayout {
        id: volumeLayout
        anchors.centerIn: parent
        spacing: 4
        
        Text {
            text: {
                if (isMuted) return "🔇"
                if (volumeLevel > 70) return "🔊"
                if (volumeLevel > 30) return "🔉"
                return "🔈"
            }
            color: "#cdd6f4"
            font.pixelSize: 12
        }
        
        Text {
            text: isMuted ? "Sessiz" : volumeLevel + "%"
            color: "#cdd6f4"
            font.pixelSize: 10
        }
    }
    
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        
        onEntered: root.color = "#45475a"
        onExited: if (!popupVisible) root.color = "transparent"
        
        onClicked: (mouse) => {
            if (mouse.button === Qt.LeftButton) {
                popupVisible = !popupVisible
            } else if (mouse.button === Qt.RightButton) {
                // Sağ tık ile sessiz aç/kapa
                Process {
                    command: ["pactl", "set-sink-mute", "@DEFAULT_SINK@", "toggle"]
                    running: true
                }
            }
        }
        
        onWheel: (wheel) => {
            const delta = wheel.angleDelta.y > 0 ? 5 : -5
            Process {
                command: ["pactl", "set-sink-volume", "@DEFAULT_SINK@", (delta > 0 ? "+" : "") + delta + "%"]
                running: true
            }
        }
    }
    
    // Ses kontrolü popup
    Rectangle {
        id: popup
        visible: popupVisible
        
        x: parent.width - width
        y: parent.height + 5
        width: 200
        height: 160
        radius: 8
        color: "#1e1e2e"
        border.width: 1
        border.color: "#45475a"
        
        Column {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 12
            
            Text {
                text: "Ses Kontrolü"
                color: "#cdd6f4"
                font.pixelSize: 14
                font.bold: true
            }
            
            // Ana ses kontrolü
            Column {
                width: parent.width
                spacing: 8
                
                Row {
                    width: parent.width
                    Text {
                        text: "Sistem Sesi"
                        color: "#cdd6f4"
                        font.pixelSize: 12
                    }
                    Text {
                        anchors.right: parent.right
                        text: isMuted ? "Sessiz" : volumeLevel + "%"
                        color: isMuted ? "#f38ba8" : "#cdd6f4"
                        font.pixelSize: 12
                    }
                }
                
                Row {
                    width: parent.width
                    spacing: 8
                    
                    Rectangle {
                        width: 24; height: 24; radius: 4
                        color: "#585b70"
                        Text {
                            anchors.centerIn: parent
                            text: "🔈"
                            font.pixelSize: 10
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                Process {
                                    command: ["pactl", "set-sink-volume", "@DEFAULT_SINK@", "-10%"]
                                    running: true
                                }
                            }
                        }
                    }
                    
                    Rectangle {
                        width: parent.width - 80
                        height: 6
                        radius: 3
                        color: "#45475a"
                        
                        Rectangle {
                            width: isMuted ? 0 : parent.width * (volumeLevel / 100)
                            height: parent.height
                            radius: 3
                            color: "#cba6f7"
                            
                            Behavior on width {
                                NumberAnimation { duration: 100 }
                            }
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            onClicked: (mouse) => {
                                const newVolume = Math.round((mouse.x / parent.width) * 100)
                                Process {
                                    command: ["pactl", "set-sink-volume", "@DEFAULT_SINK@", newVolume + "%"]
                                    running: true
                                }
                            }
                        }
                    }
                    
                    Rectangle {
                        width: 24; height: 24; radius: 4
                        color: "#585b70"
                        Text {
                            anchors.centerIn: parent
                            text: "🔊"
                            font.pixelSize: 12
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                Process {
                                    command: ["pactl", "set-sink-volume", "@DEFAULT_SINK@", "+10%"]
                                    running: true
                                }
                            }
                        }
                    }
                }
            }
            
            // Hızlı işlemler
            Column {
                width: parent.width
                spacing: 6
                
                Row {
                    spacing: 8
                    
                    Rectangle {
                        width: 60; height: 28; radius: 4
                        color: isMuted ? "#f38ba8" : "#585b70"
                        Text {
                            anchors.centerIn: parent
                            text: isMuted ? "Sessiz Aç" : "Sessiz"
                            color: "#cdd6f4"
                            font.pixelSize: 9
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                Process {
                                    command: ["pactl", "set-sink-mute", "@DEFAULT_SINK@", "toggle"]
                                    running: true
                                }
                            }
                        }
                    }
                    
                    Rectangle {
                        width: 80; height: 28; radius: 4
                        color: "#585b70"
                        Text {
                            anchors.centerIn: parent
                            text: "Ses Ayarları"
                            color: "#cdd6f4"
                            font.pixelSize: 9
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                Process {
                                    command: ["pavucontrol"]
                                    running: true
                                }
                                popupVisible = false
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Popup dışına tıklandığında kapat
    MouseArea {
        anchors.fill: parent.parent
        enabled: popupVisible
        onClicked: popupVisible = false
        z: -1
    }
}
