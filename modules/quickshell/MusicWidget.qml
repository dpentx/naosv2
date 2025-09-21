// MusicWidget.qml
import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Rectangle {
    id: root
    
    property string currentTrack: ""
    property bool isPlaying: false
    property bool popupVisible: false
    property int bluetoothVolume: 75
    
    width: musicLayout.implicitWidth + 16
    height: 32
    radius: 6
    color: popupVisible ? "#45475a" : "transparent"
    border.width: 1
    border.color: "#6c7086"
    
    RowLayout {
        id: musicLayout
        anchors.centerIn: parent
        spacing: 6
        
        Text {
            text: isPlaying ? "⏸" : "▶"
            color: "#cdd6f4"
            font.pixelSize: 12
        }
        
        Text {
            text: currentTrack || "Müzik Yok"
            color: "#cdd6f4"
            font.pixelSize: 11
            elide: Text.ElideRight
            Layout.maximumWidth: 150
        }
    }
    
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        
        onEntered: root.color = "#45475a"
        onExited: if (!popupVisible) root.color = "transparent"
        
        onClicked: {
            popupVisible = !popupVisible
        }
    }
    
    // Müzik kontrolü popup
    Rectangle {
        id: popup
        visible: popupVisible
        
        x: 0
        y: parent.height + 5
        width: 280
        height: 200
        radius: 8
        color: "#1e1e2e"
        border.width: 1
        border.color: "#45475a"
        
        Column {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 12
            
            Text {
                text: "Müzik Kontrolü"
                color: "#cdd6f4"
                font.pixelSize: 14
                font.bold: true
            }
            
            Column {
                width: parent.width
                spacing: 8
                
                Text {
                    text: currentTrack || "Şarkı çalmıyor"
                    color: "#cdd6f4"
                    font.pixelSize: 12
                    wrapMode: Text.WordWrap
                    width: parent.width
                }
                
                Row {
                    spacing: 8
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Rectangle {
                        width: 32; height: 32; radius: 4
                        color: "#585b70"
                        Text {
                            anchors.centerIn: parent
                            text: "⏮"
                            color: "#cdd6f4"
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                Process {
                                    command: ["playerctl", "previous"]
                                    running: true
                                }
                            }
                        }
                    }
                    
                    Rectangle {
                        width: 32; height: 32; radius: 4
                        color: "#cba6f7"
                        Text {
                            anchors.centerIn: parent
                            text: isPlaying ? "⏸" : "▶"
                            color: "#1e1e2e"
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                Process {
                                    command: ["playerctl", "play-pause"]
                                    running: true
                                }
                            }
                        }
                    }
                    
                    Rectangle {
                        width: 32; height: 32; radius: 4
                        color: "#585b70"
                        Text {
                            anchors.centerIn: parent
                            text: "⏭"
                            color: "#cdd6f4"
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                Process {
                                    command: ["playerctl", "next"]
                                    running: true
                                }
                            }
                        }
                    }
                }
            }
            
            Column {
                width: parent.width
                spacing: 8
                
                Text {
                    text: "Bluetooth Kulaklık Sesi"
                    color: "#cdd6f4"
                    font.pixelSize: 12
                }
                
                Row {
                    width: parent.width
                    spacing: 8
                    
                    Rectangle {
                        width: 24; height: 24; radius: 4
                        color: "#585b70"
                        Text {
                            anchors.centerIn: parent
                            text: "🔊"
                            font.pixelSize: 10
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                bluetoothVolume = Math.max(0, bluetoothVolume - 10)
                                // Bluetooth ses kontrolü komutu
                            }
                        }
                    }
                    
                    Rectangle {
                        width: parent.width - 80
                        height: 4
                        radius: 2
                        color: "#45475a"
                        
                        Rectangle {
                            width: parent.width * (bluetoothVolume / 100)
                            height: parent.height
                            radius: 2
                            color: "#cba6f7"
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
                                bluetoothVolume = Math.min(100, bluetoothVolume + 10)
                            }
                        }
                    }
                }
                
                Text {
                    text: bluetoothVolume + "%"
                    color: "#cdd6f4"
                    font.pixelSize: 10
                    anchors.horizontalCenter: parent.horizontalCenter
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
