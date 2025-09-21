// TrayWidget.qml
import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Rectangle {
    id: root
    
    property bool popupVisible: false
    
    width: 32
    height: 32
    radius: 6
    color: popupVisible ? "#45475a" : "transparent"
    border.width: 1
    border.color: "#6c7086"
    
    Text {
        anchors.centerIn: parent
        text: "⏶"
        color: "#cdd6f4"
        font.pixelSize: 12
        rotation: 180
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
    
    // Sistem tepsisi popup
    Rectangle {
        id: popup
        visible: popupVisible
        
        x: parent.width - width
        y: parent.height + 5
        width: 200
        height: 250
        radius: 8
        color: "#1e1e2e"
        border.width: 1
        border.color: "#45475a"
        
        Column {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 12
            
            Text {
                text: "Sistem Tepsisi"
                color: "#cdd6f4"
                font.pixelSize: 14
                font.bold: true
            }
            
            // Hızlı ayarlar
            Grid {
                width: parent.width
                columns: 2
                spacing: 8
                
                // Bildirimler
                Rectangle {
                    width: 80; height: 60; radius: 6
                    color: "#313244"
                    
                    Column {
                        anchors.centerIn: parent
                        spacing: 4
                        
                        Text {
                            text: "🔔"
                            color: "#cdd6f4"
                            font.pixelSize: 16
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Text {
                            text: "Bildirimler"
                            color: "#cdd6f4"
                            font.pixelSize: 9
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            Process {
                                command: ["dunstctl", "toggle"]
                                running: true
                            }
                        }
                    }
                }
                
                // Gece modu
                Rectangle {
                    width: 80; height: 60; radius: 6
                    color: "#313244"
                    
                    Column {
                        anchors.centerIn: parent
                        spacing: 4
                        
                        Text {
                            text: "🌙"
                            color: "#cdd6f4"
                            font.pixelSize: 16
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Text {
                            text: "Gece Modu"
                            color: "#cdd6f4"
                            font.pixelSize: 9
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            Process {
                                command: ["redshift", "-O", "3500"]
                                running: true
                            }
                        }
                    }
                }
                
                // Ekran kilidi
                Rectangle {
                    width: 80; height: 60; radius: 6
                    color: "#313244"
                    
                    Column {
                        anchors.centerIn: parent
                        spacing: 4
                        
                        Text {
                            text: "🔒"
                            color: "#cdd6f4"
                            font.pixelSize: 16
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Text {
                            text: "Kilitle"
                            color: "#cdd6f4"
                            font.pixelSize: 9
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            Process {
                                command: ["hyprlock"]
                                running: true
                            }
                            popupVisible = false
                        }
                    }
                }
                
                // Güç seçenekleri
                Rectangle {
                    width: 80; height: 60; radius: 6
                    color: "#313244"
                    
                    Column {
                        anchors.centerIn: parent
                        spacing: 4
                        
                        Text {
                            text: "⏻"
                            color: "#f38ba8"
                            font.pixelSize: 16
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Text {
                            text: "Güç"
                            color: "#cdd6f4"
                            font.pixelSize: 9
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        onClicked: powerMenuVisible = true
                    }
                    
                    property bool powerMenuVisible: false
                    
                    // Güç menüsü
                    Rectangle {
                        visible: parent.powerMenuVisible
                        x: -50
                        y: -120
                        width: 120
                        height: 100
                        radius: 6
                        color: "#1e1e2e"
                        border.width: 1
                        border.color: "#f38ba8"
                        
                        Column {
                            anchors.centerIn: parent
                            spacing: 4
                            
                            Rectangle {
                                width: 100; height: 24; radius: 4
                                color: "#585b70"
                                Text {
                                    anchors.centerIn: parent
                                    text: "Yeniden Başlat"
                                    color: "#cdd6f4"
                                    font.pixelSize: 10
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        Process {
                                            command: ["systemctl", "reboot"]
                                            running: true
                                        }
                                    }
                                }
                            }
                            
                            Rectangle {
                                width: 100; height: 24; radius: 4
                                color: "#f38ba8"
                                Text {
                                    anchors.centerIn: parent
                                    text: "Kapat"
                                    color: "#1e1e2e"
                                    font.pixelSize: 10
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        Process {
                                            command: ["systemctl", "poweroff"]
                                            running: true
                                        }
                                    }
                                }
                            }
                            
                            Rectangle {
                                width: 100; height: 24; radius: 4
                                color: "#585b70"
                                Text {
                                    anchors.centerIn: parent
                                    text: "Çıkış Yap"
                                    color: "#cdd6f4"
                                    font.pixelSize: 10
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        Process {
                                            command: ["hyprctl", "dispatch", "exit"]
                                            running: true
                                        }
                                    }
                                }
                            }
                        }
                        
                        MouseArea {
                            anchors.fill: parent.parent.parent
                            enabled: parent.visible
                            onClicked: parent.parent.powerMenuVisible = false
                            z: -1
                        }
                    }
                }
            }
            
            Rectangle {
                width: parent.width
                height: 1
                color: "#45475a"
            }
            
            // Sistem bilgileri
            Column {
                width: parent.width
                spacing: 6
                
                Text {
                    text: "Hızlı Erişim"
                    color: "#cdd6f4"
                    font.pixelSize: 12
                    font.bold: true
                }
                
                Column {
                    width: parent.width
                    spacing: 4
                    
                    Rectangle {
                        width: parent.width
                        height: 28
                        radius: 4
                        color: "#313244"
                        
                        Row {
                            anchors.left: parent.left
                            anchors.leftMargin: 8
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 8
                            
                            Text {
                                text: "📁"
                                color: "#cdd6f4"
                                font.pixelSize: 12
                            }
                            
                            Text {
                                text: "Dosya Yöneticisi"
                                color: "#cdd6f4"
                                font.pixelSize: 10
                            }
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                Process {
                                    command: ["thunar"]
                                    running: true
                                }
                                popupVisible = false
                            }
                        }
                    }
                    
                    Rectangle {
                        width: parent.width
                        height: 28
                        radius: 4
                        color: "#313244"
                        
                        Row {
                            anchors.left: parent.left
                            anchors.leftMargin: 8
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 8
                            
                            Text {
                                text: "⚙️"
                                color: "#cdd6f4"
                                font.pixelSize: 12
                            }
                            
                            Text {
                                text: "Sistem Ayarları"
                                color: "#cdd6f4"
                                font.pixelSize: 10
                            }
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                Process {
                                    command: ["gnome-control-center"]
                                    running: true
                                }
                                popupVisible = false
                            }
                        }
                    }
                    
                    Rectangle {
                        width: parent.width
                        height: 28
                        radius: 4
                        color: "#313244"
                        
                        Row {
                            anchors.left: parent.left
                            anchors.leftMargin: 8
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 8
                            
                            Text {
                                text: "💻"
                                color: "#cdd6f4"
                                font.pixelSize: 12
                            }
                            
                            Text {
                                text: "Terminal"
                                color: "#cdd6f4"
                                font.pixelSize: 10
                            }
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                Process {
                                    command: ["kitty"]
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
