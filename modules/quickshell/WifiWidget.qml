// WifiWidget.qml
import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Rectangle {
    id: root
    
    property string wifiName: ""
    property int wifiStrength: 0
    property bool popupVisible: false
    property var availableNetworks: []
    
    width: wifiLayout.implicitWidth + 12
    height: 32
    radius: 6
    color: popupVisible ? "#45475a" : "transparent"
    border.width: 1
    border.color: "#6c7086"
    
    RowLayout {
        id: wifiLayout
        anchors.centerIn: parent
        spacing: 4
        
        Text {
            text: {
                if (wifiName === "Bağlı değil" || wifiName === "") return "📶"
                if (wifiStrength > 75) return "📶"
                if (wifiStrength > 50) return "📶"
                if (wifiStrength > 25) return "📶"
                return "📶"
            }
            color: wifiName === "Bağlı değil" ? "#f38ba8" : "#cdd6f4"
            font.pixelSize: 12
        }
        
        Text {
            text: wifiName === "Bağlı değil" || wifiName === "" ? "Bağlı değil" : wifiName
            color: "#cdd6f4"
            font.pixelSize: 10
            elide: Text.ElideRight
            Layout.maximumWidth: 80
        }
    }
    
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        
        onEntered: root.color = "#45475a"
        onExited: if (!popupVisible) root.color = "transparent"
        
        onClicked: {
            popupVisible = !popupVisible
            if (popupVisible) {
                scanNetworks()
            }
        }
    }
    
    function scanNetworks() {
        networkScanProcess.running = true
    }
    
    Process {
        id: networkScanProcess
        command: ["nmcli", "-t", "-f", "SSID,SIGNAL,SECURITY", "dev", "wifi"]
        
        stdout: StdioCollector {
            onStreamFinished: {
                const networks = []
                const lines = this.text.trim().split('\n')
                
                for (const line of lines) {
                    const parts = line.split(':')
                    if (parts.length >= 2 && parts[0] !== '') {
                        networks.push({
                            ssid: parts[0],
                            signal: parseInt(parts[1]) || 0,
                            security: parts[2] || ''
                        })
                    }
                }
                
                // Sinyal gücüne göre sırala
                networks.sort((a, b) => b.signal - a.signal)
                availableNetworks = networks.slice(0, 8) // İlk 8 ağı göster
            }
        }
    }
    
    // WiFi kontrolü popup
    Rectangle {
        id: popup
        visible: popupVisible
        
        x: parent.width - width
        y: parent.height + 5
        width: 280
        height: 320
        radius: 8
        color: "#1e1e2e"
        border.width: 1
        border.color: "#45475a"
        
        Column {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 12
            
            Row {
                width: parent.width
                Text {
                    text: "WiFi Bağlantıları"
                    color: "#cdd6f4"
                    font.pixelSize: 14
                    font.bold: true
                }
                
                Rectangle {
                    anchors.right: parent.right
                    width: 28; height: 28; radius: 4
                    color: "#585b70"
                    Text {
                        anchors.centerIn: parent
                        text: "🔄"
                        font.pixelSize: 12
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: scanNetworks()
                    }
                }
            }
            
            // Mevcut bağlantı
            Rectangle {
                width: parent.width
                height: 40
                radius: 6
                color: "#313244"
                
                Row {
                    anchors.left: parent.left
                    anchors.leftMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 8
                    
                    Text {
                        text: "📶"
                        color: wifiName === "Bağlı değil" ? "#f38ba8" : "#a6e3a1"
                        font.pixelSize: 14
                    }
                    
                    Column {
                        Text {
                            text: wifiName === "Bağlı değil" || wifiName === "" ? "Bağlı Değil" : wifiName
                            color: "#cdd6f4"
                            font.pixelSize: 12
                            font.bold: true
                        }
                        Text {
                            text: wifiName === "Bağlı değil" || wifiName === "" ? "" : "Sinyal: " + wifiStrength + "%"
                            color: "#bac2de"
                            font.pixelSize: 10
                        }
                    }
                }
                
                Rectangle {
                    anchors.right: parent.right
                    anchors.rightMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                    width: 60; height: 24; radius: 4
                    color: wifiName === "Bağlı değil" ? "#a6e3a1" : "#f38ba8"
                    
                    Text {
                        anchors.centerIn: parent
                        text: wifiName === "Bağlı değil" ? "Bağlan" : "Kes"
                        color: "#1e1e2e"
                        font.pixelSize: 9
                        font.bold: true
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (wifiName === "Bağlı değil" || wifiName === "") {
                                Process {
                                    command: ["nmcli", "radio", "wifi", "on"]
                                    running: true
                                }
                            } else {
                                Process {
                                    command: ["nmcli", "connection", "down", wifiName]
                                    running: true
                                }
                            }
                        }
                    }
                }
            }
            
            // Mevcut ağlar listesi
            ScrollView {
                width: parent.width
                height: 180
                
                Column {
                    width: parent.width
                    spacing: 4
                    
                    Repeater {
                        model: availableNetworks
                        
                        Rectangle {
                            width: parent.width
                            height: 36
                            radius: 4
                            color: mouseArea.containsMouse ? "#45475a" : "#313244"
                            
                            Row {
                                anchors.left: parent.left
                                anchors.leftMargin: 8
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 8
                                
                                Text {
                                    text: {
                                        const signal = modelData.signal
                                        if (signal > 75) return "📶"
                                        if (signal > 50) return "📶"
                                        if (signal > 25) return "📶"
                                        return "📶"
                                    }
                                    color: "#cdd6f4"
                                    font.pixelSize: 12
                                }
                                
                                Column {
                                    Text {
                                        text: modelData.ssid
                                        color: "#cdd6f4"
                                        font.pixelSize: 11
                                        elide: Text.ElideRight
                                        width: 140
                                    }
                                    Text {
                                        text: modelData.security !== "" ? "🔒 Şifreli" : "🔓 Açık"
                                        color: "#bac2de"
                                        font.pixelSize: 9
                                    }
                                }
                                
                                Text {
                                    anchors.right: parent.right
                                    text: modelData.signal + "%"
                                    color: "#bac2de"
                                    font.pixelSize: 10
                                }
                            }
                            
                            MouseArea {
                                id: mouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                
                                onClicked: {
                                    Process {
                                        command: ["nmcli", "device", "wifi", "connect", modelData.ssid]
                                        running: true
                                        onExited: {
                                            if (exitCode === 0) {
                                                popupVisible = false
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            // Hızlı işlemler
            Row {
                spacing: 8
                
                Rectangle {
                    width: 80; height: 28; radius: 4
                    color: "#585b70"
                    Text {
                        anchors.centerIn: parent
                        text: "Ağ Ayarları"
                        color: "#cdd6f4"
                        font.pixelSize: 9
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            Process {
                                command: ["nm-connection-editor"]
                                running: true
                            }
                            popupVisible = false
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
