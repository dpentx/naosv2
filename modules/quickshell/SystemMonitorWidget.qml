// SystemMonitorWidget.qml
import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Rectangle {
    id: root
    
    property real cpuUsage: 0
    property real ramUsage: 0  
    property real gpuUsage: 0
    property bool popupVisible: false
    
    width: systemLayout.implicitWidth + 16
    height: 32
    radius: 6
    color: popupVisible ? "#45475a" : "transparent"
    border.width: 1
    border.color: "#6c7086"
    
    RowLayout {
        id: systemLayout
        anchors.centerIn: parent
        spacing: 8
        
        // CPU
        Row {
            spacing: 3
            Text {
                text: "CPU"
                color: "#f38ba8"
                font.pixelSize: 9
                font.bold: true
            }
            Text {
                text: Math.round(cpuUsage) + "%"
                color: "#cdd6f4"
                font.pixelSize: 10
            }
        }
        
        // RAM
        Row {
            spacing: 3
            Text {
                text: "RAM"
                color: "#a6e3a1"
                font.pixelSize: 9
                font.bold: true
            }
            Text {
                text: Math.round(ramUsage) + "%"
                color: "#cdd6f4"
                font.pixelSize: 10
            }
        }
        
        // GPU
        Row {
            spacing: 3
            Text {
                text: "GPU"
                color: "#fab387"
                font.pixelSize: 9
                font.bold: true
            }
            Text {
                text: Math.round(gpuUsage) + "%"
                color: "#cdd6f4"
                font.pixelSize: 10
            }
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
    
    // Detaylı sistem bilgisi popup
    Rectangle {
        id: popup
        visible: popupVisible
        
        x: parent.width - width
        y: parent.height + 5
        width: 320
        height: 280
        radius: 8
        color: "#1e1e2e"
        border.width: 1
        border.color: "#45475a"
        
        Column {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 12
            
            Text {
                text: "Sistem İzleyici"
                color: "#cdd6f4"
                font.pixelSize: 14
                font.bold: true
            }
            
            // CPU detayları
            Column {
                width: parent.width
                spacing: 4
                
                Row {
                    width: parent.width
                    Text {
                        text: "CPU Kullanımı"
                        color: "#f38ba8"
                        font.pixelSize: 12
                        font.bold: true
                    }
                    Text {
                        anchors.right: parent.right
                        text: Math.round(cpuUsage) + "%"
                        color: "#cdd6f4"
                        font.pixelSize: 12
                    }
                }
                
                Rectangle {
                    width: parent.width
                    height: 6
                    radius: 3
                    color: "#45475a"
                    
                    Rectangle {
                        width: parent.width * (cpuUsage / 100)
                        height: parent.height
                        radius: 3
                        color: cpuUsage > 80 ? "#f38ba8" : cpuUsage > 60 ? "#fab387" : "#a6e3a1"
                        
                        Behavior on width {
                            NumberAnimation { duration: 200 }
                        }
                    }
                }
            }
            
            // RAM detayları  
            Column {
                width: parent.width
                spacing: 4
                
                Row {
                    width: parent.width
                    Text {
                        text: "RAM Kullanımı"
                        color: "#a6e3a1"
                        font.pixelSize: 12
                        font.bold: true
                    }
                    Text {
                        anchors.right: parent.right
                        text: Math.round(ramUsage) + "%"
                        color: "#cdd6f4"
                        font.pixelSize: 12
                    }
                }
                
                Rectangle {
                    width: parent.width
                    height: 6
                    radius: 3
                    color: "#45475a"
                    
                    Rectangle {
                        width: parent.width * (ramUsage / 100)
                        height: parent.height
                        radius: 3
                        color: ramUsage > 80 ? "#f38ba8" : ramUsage > 60 ? "#fab387" : "#a6e3a1"
                        
                        Behavior on width {
                            NumberAnimation { duration: 200 }
                        }
                    }
                }
            }
            
            // GPU detayları
            Column {
                width: parent.width
                spacing: 4
                
                Row {
                    width: parent.width
                    Text {
                        text: "GPU Kullanımı"
                        color: "#fab387"
                        font.pixelSize: 12
                        font.bold: true
                    }
                    Text {
                        anchors.right: parent.right
                        text: Math.round(gpuUsage) + "%"
                        color: "#cdd6f4"
                        font.pixelSize: 12
                    }
                }
                
                Rectangle {
                    width: parent.width
                    height: 6
                    radius: 3
                    color: "#45475a"
                    
                    Rectangle {
                        width: parent.width * (gpuUsage / 100)
                        height: parent.height
                        radius: 3
                        color: gpuUsage > 80 ? "#f38ba8" : gpuUsage > 60 ? "#fab387" : "#a6e3a1"
                        
                        Behavior on width {
                            NumberAnimation { duration: 200 }
                        }
                    }
                }
            }
            
            // Hızlı işlemler
            Column {
                width: parent.width
                spacing: 8
                
                Text {
                    text: "Hızlı İşlemler"
                    color: "#cdd6f4"
                    font.pixelSize: 12
                    font.bold: true
                }
                
                Row {
                    spacing: 8
                    
                    Rectangle {
                        width: 80; height: 28; radius: 4
                        color: "#585b70"
                        Text {
                            anchors.centerIn: parent
                            text: "Htop"
                            color: "#cdd6f4"
                            font.pixelSize: 10
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                Process {
                                    command: ["kitty", "-e", "htop"]
                                    running: true
                                }
                                popupVisible = false
                            }
                        }
                    }
                    
                    Rectangle {
                        width: 80; height: 28; radius: 4
                        color: "#585b70"
                        Text {
                            anchors.centerIn: parent
                            text: "Görev Mgr"
                            color: "#cdd6f4"
                            font.pixelSize: 10
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                Process {
                                    command: ["gnome-system-monitor"]
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
