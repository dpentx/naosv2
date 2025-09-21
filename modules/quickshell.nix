# waybar-like-quickshell.nix - Waybar benzeri QuickShell konfigÃ¼rasyonu

{ config, pkgs, lib, inputs, ... }:

let
  # Waybar'daki renkleri analiz ettim
  colors = {
    # Ana arka plan - gradient koyu
    background = "rgba(30, 30, 46, 0.85)";     # Åžeffaf koyu
    surface = "rgba(49, 50, 68, 0.9)";         # Biraz aÃ§Ä±k
    
    # Metin renkleri
    text = "#cdd6f4";                          # AÃ§Ä±k beyaz
    textDim = "#a6adc8";                       # Soluk beyaz
    
    # Vurgu renkleri  
    accent = "#89b4fa";                        # Mavi (HDMI ikonu iÃ§in)
    success = "#a6e3a1";                      # YeÅŸil (workspace aktif)
    warning = "#f9e2af";                      # SarÄ± (workspace)  
    error = "#f38ba8";                        # KÄ±rmÄ±zÄ± (logo + workspace)
    
    # Ã–zel renkler
    musicControl = "#cba6f7";                 # Mor (mÃ¼zik kontrolleri)
    networkGreen = "#a6e3a1";                 # AÄŸ iÃ§in yeÅŸil
    batteryColor = "#fab387";                 # Batarya turuncu
  };

  # Boyutlar - Waybar'a uygun
  dimensions = {
    barHeight = 32;                           # Waybar yÃ¼ksekliÄŸi
    fontSize = 13;                            # Ana yazÄ± boyutu
    iconSize = 14;                            # Ä°kon boyutu
    spacing = 8;                              # Elemanlar arasÄ±
    margin = 6;                               # Kenarlardaki boÅŸluk
    borderRadius = 8;                         # KÃ¶ÅŸe yuvarlaklÄ±ÄŸÄ±
  };

  # Waybar benzeri QML iÃ§eriÄŸi - Ä°ÅŸlevli ses/pil popup'larÄ± ile
  shellContent = ''
    import Quickshell
    import QtQuick
    import QtQuick.Effects
    import Quickshell.Services.SystemTray

    ShellRoot {
        // Ana panel
        PanelWindow {
            id: waybarPanel
            
            anchors {
                left: true
                right: true  
                top: true
            }
        
        // WIFI POPUP PENCERESÄ°
        FloatingWindow {
            id: wifiPopup
            visible: waybarPanel.wifiPopupVisible
            
            anchors {
                top: waybarPanel.bottom
                right: waybarPanel.right
                topMargin: 5
                rightMargin: 200
            }
            
            width: 300
            height: 250
            
            Rectangle {
                anchors.fill: parent
                color: "${colors.background}"
                radius: ${toString dimensions.borderRadius}
                border.color: "${colors.accent}"
                border.width: 1
                
                Column {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 12
                    
                    // BaÅŸlÄ±k
                    Row {
                        width: parent.width
                        spacing: 8
                        
                        Text {
                            text: "ðŸ“¶"
                            font.pixelSize: 20
                            color: "${colors.accent}"
                        }
                        Text {
                            text: "WiFi Networks"
                            font.pixelSize: 16
                            font.bold: true
                            color: "${colors.text}"
                        }
                        
                        // WiFi aÃ§/kapat toggle
                        Rectangle {
                            width: 40
                            height: 20
                            radius: 10
                            color: "${colors.success}"
                            anchors.verticalCenter: parent.verticalCenter
                            
                            Rectangle {
                                width: 16
                                height: 16
                                radius: 8
                                color: "${colors.text}"
                                x: parent.width - width - 2
                                y: 2
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                onClicked: console.log("WiFi toggle")
                            }
                        }
                    }
                    
                    // Mevcut baÄŸlantÄ±
                    Rectangle {
                        width: parent.width
                        height: 35
                        color: "${colors.surface}"
                        radius: 5
                        border.color: "${colors.success}"
                        border.width: 1
                        
                        Row {
                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 8
                            
                            Text {
                                text: "âœ…"
                                font.pixelSize: 14
                                anchors.verticalCenter: parent.verticalCenter
                                color: "${colors.success}"
                            }
                            
                            Column {
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 2
                                
                                Text {
                                    text: "ðŸ  Ev_WiFi_5G"
                                    color: "${colors.text}"
                                    font.pixelSize: 13
                                    font.bold: true
                                }
                                
                                Text {
                                    text: "BaÄŸlÄ± â€¢ 192.168.1.105"
                                    color: "${colors.textDim}"
                                    font.pixelSize: 10
                                }
                            }
                            
                            Text {
                                text: "â–²â–²â–²â–²"
                                color: "${colors.success}"
                                font.pixelSize: 12
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                    
                    // KullanÄ±labilir aÄŸlar
                    Text {
                        text: "ðŸ“¡ KullanÄ±labilir AÄŸlar"
                        color: "${colors.textDim}"
                        font.pixelSize: 14
                    }
                    
                    Column {
                        spacing: 4
                        width: parent.width
                        
                        // AÄŸ 1
                        Rectangle {
                            width: parent.width
                            height: 30
                            color: "transparent"
                            
                            Row {
                                anchors.fill: parent
                                anchors.margins: 4
                                spacing: 8
                                
                                Text {
                                    text: "ðŸ”’"
                                    font.pixelSize: 12
                                    anchors.verticalCenter: parent.verticalCenter
                                    color: "${colors.warning}"
                                }
                                
                                Text {
                                    text: "Komsu_WiFi"
                                    color: "${colors.text}"
                                    font.pixelSize: 12
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                
                                Text {
                                    text: "â–²â–²â–²"
                                    color: "${colors.warning}"
                                    font.pixelSize: 10
                                    anchors.right: parent.right
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                onClicked: console.log("Connect to Komsu_WiFi")
                                hoverEnabled: true
                                onEntered: parent.color = "${colors.surface}"
                                onExited: parent.color = "transparent"
                            }
                        }
                        
                        // AÄŸ 2
                        Rectangle {
                            width: parent.width
                            height: 30
                            color: "transparent"
                            
                            Row {
                                anchors.fill: parent
                                anchors.margins: 4
                                spacing: 8
                                
                                Text {
                                    text: "ðŸ”“"
                                    font.pixelSize: 12
                                    anchors.verticalCenter: parent.verticalCenter
                                    color: "${colors.success}"
                                }
                                
                                Text {
                                    text: "Free_Internet"
                                    color: "${colors.text}"
                                    font.pixelSize: 12
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                
                                Text {
                                    text: "â–²â–²"
                                    color: "${colors.textDim}"
                                    font.pixelSize: 10
                                    anchors.right: parent.right
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                onClicked: console.log("Connect to Free_Internet")
                                hoverEnabled: true
                                onEntered: parent.color = "${colors.surface}"
                                onExited: parent.color = "transparent"
                            }
                        }
                        
                        // AÄŸ 3
                        Rectangle {
                            width: parent.width
                            height: 30
                            color: "transparent"
                            
                            Row {
                                anchors.fill: parent
                                anchors.margins: 4
                                spacing: 8
                                
                                Text {
                                    text: "ðŸ”’"
                                    font.pixelSize: 12
                                    anchors.verticalCenter: parent.verticalCenter
                                    color: "${colors.warning}"
                                }
                                
                                Text {
                                    text: "NETGEAR_5G"
                                    color: "${colors.text}"
                                    font.pixelSize: 12
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                
                                Text {
                                    text: "â–²"
                                    color: "${colors.error}"
                                    font.pixelSize: 10
                                    anchors.right: parent.right
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                onClicked: console.log("Connect to NETGEAR_5G")
                                hoverEnabled: true
                                onEntered: parent.color = "${colors.surface}"
                                onExited: parent.color = "transparent"
                            }
                        }
                    }
                    
                    // Yenile butonu
                    Rectangle {
                        width: parent.width
                        height: 25
                        color: "${colors.surface}"
                        radius: 5
                        border.color: "${colors.accent}"
                        border.width: 1
                        
                        Text {
                            text: "ðŸ”„ AÄŸlarÄ± Yenile"
                            anchors.centerIn: parent
                            color: "${colors.accent}"
                            font.pixelSize: 12
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            onClicked: console.log("Refreshing networks...")
                            hoverEnabled: true
                            onEntered: parent.color = "${colors.accent}"
                            onExited: parent.color = "${colors.surface}"
                        }
                    }
                }
                
                // Kapat butonu
                Text {
                    text: "âœ•"
                    anchors {
                        top: parent.top
                        right: parent.right
                        margins: 8
                    }
                    color: "${colors.error}"
                    font.pixelSize: 16
                    
                    MouseArea {
                        anchors.fill: parent
                        onClicked: waybarPanel.wifiPopupVisible = false
                    }
                }
            }
        }
        
        // BLUETOOTH POPUP PENCERESÄ°
        FloatingWindow {
            id: bluetoothPopup
            visible: waybarPanel.bluetoothPopupVisible
            
            anchors {
                top: waybarPanel.bottom
                right: waybarPanel.right
                topMargin: 5
                rightMargin: 150
            }
            
            width: 260
            height: 220
            
            Rectangle {
                anchors.fill: parent
                color: "${colors.background}"
                radius: ${toString dimensions.borderRadius}
                border.color: "${colors.accent}"
                border.width: 1
                
                Column {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 12
                    
                    // BaÅŸlÄ±k
                    Row {
                        spacing: 8
                        Text {
                            text: "ðŸ”µ"
                            font.pixelSize: 20
                            color: "${colors.accent}"
                        }
                        Text {
                            text: "Bluetooth"
                            font.pixelSize: 16
                            font.bold: true
                            color: "${colors.text}"
                        }
                        
                        // Bluetooth aÃ§/kapat toggle
                        Rectangle {
                            width: 40
                            height: 20
                            radius: 10
                            color: "${colors.success}"
                            anchors.verticalCenter: parent.verticalCenter
                            
                            Rectangle {
                                width: 16
                                height: 16
                                radius: 8
                                color: "${colors.text}"
                                x: parent.width - width - 2
                                y: 2
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                onClicked: console.log("Bluetooth toggle")
                            }
                        }
                    }
                    
                    // BaÄŸlÄ± cihazlar
                    Text {
                        text: "ðŸ”— BaÄŸlÄ± Cihazlar"
                        color: "${colors.textDim}"
                        font.pixelSize: 14
                    }
                    
                    Column {
                        spacing: 8
                        width: parent.width
                        
                        // KulaklÄ±k
                        Row {
                            width: parent.width
                            spacing: 8
                            
                            Rectangle {
                                width: 12
                                height: 12
                                radius: 6
                                color: "${colors.success}"
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            
                            Text {
                                text: "ðŸŽ§ AirPods Pro"
                                color: "${colors.text}"
                                font.pixelSize: 13
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            
                            Text {
                                text: "87%"
                                color: "${colors.success}"
                                font.pixelSize: 11
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                        
                        // Mouse
                        Row {
                            width: parent.width
                            spacing: 8
                            
                            Rectangle {
                                width: 12
                                height: 12
                                radius: 6
                                color: "${colors.success}"
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            
                            Text {
                                text: "ðŸ–±ï¸ MX Master 3"
                                color: "${colors.text}"
                                font.pixelSize: 13
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            
                            Text {
                                text: "45%"
                                color: "${colors.warning}"
                                font.pixelSize: 11
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                    
                    // KullanÄ±labilir cihazlar
                    Text {
                        text: "ðŸ” KullanÄ±labilir Cihazlar"
                        color: "${colors.textDim}"
                        font.pixelSize: 14
                    }
                    
                    Column {
                        spacing: 6
                        width: parent.width
                        
                        Row {
                            width: parent.width
                            spacing: 8
                            
                            Rectangle {
                                width: 12
                                height: 12
                                radius: 6
                                color: "${colors.surface}"
                                border.color: "${colors.textDim}"
                                border.width: 1
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            
                            Text {
                                text: "ðŸ“± Samsung Galaxy"
                                color: "${colors.textDim}"
                                font.pixelSize: 13
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            
                            Text {
                                text: "EÅŸleÅŸtir"
                                color: "${colors.accent}"
                                font.pixelSize: 11
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: console.log("Pair Samsung Galaxy")
                                }
                            }
                        }
                        
                        Row {
                            width: parent.width
                            spacing: 8
                            
                            Rectangle {
                                width: 12
                                height: 12
                                radius: 6
                                color: "${colors.surface}"
                                border.color: "${colors.textDim}"
                                border.width: 1
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            
                            Text {
                                text: "ðŸŽµ JBL Speaker"
                                color: "${colors.textDim}"
                                font.pixelSize: 13
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            
                            Text {
                                text: "EÅŸleÅŸtir"
                                color: "${colors.accent}"
                                font.pixelSize: 11
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: console.log("Pair JBL Speaker")
                                }
                            }
                        }
                    }
                }
                
                // Kapat butonu
                Text {
                    text: "âœ•"
                    anchors {
                        top: parent.top
                        right: parent.right
                        margins: 8
                    }
                    color: "${colors.error}"
                    font.pixelSize: 16
                    
                    MouseArea {
                        anchors.fill: parent
                        onClicked: waybarPanel.bluetoothPopupVisible = false
                    }
                }
            }
        }
            
            height: ${toString dimensions.barHeight}
            
            // Popup pencereler iÃ§in state yÃ¶netimi
            property bool audioPopupVisible: false
            property bool batteryPopupVisible: false
            property bool bluetoothPopupVisible: false
            property bool wifiPopupVisible: false
            property int currentVolume: 75
            property int currentMicVolume: 65
            property int currentHeadphoneVolume: 80
            property int currentBrightness: 60
            
            // Ana container - gradient ve blur efektli
            Rectangle {
                id: mainBar
                anchors.fill: parent
                
                // Gradient arka plan
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "${colors.background}" }
                    GradientStop { position: 1.0; color: "${colors.surface}" }
                }
                
                radius: ${toString dimensions.borderRadius}
                
                // Sol taraf - sistem + workspace + mÃ¼zik
                Row {
                    id: leftSection
                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        leftMargin: ${toString dimensions.margin}
                    }
                    spacing: ${toString dimensions.spacing}
                    
                    // Sistem logosu (ateÅŸ ikonu - fuzzel launcher)
                    Text {
                        text: "ðŸ”¥"
                        font.pixelSize: ${toString dimensions.iconSize}
                        color: "${colors.error}"
                        anchors.verticalCenter: parent.verticalCenter
                        
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                // Fuzzel launcher'Ä± Ã§alÄ±ÅŸtÄ±r
                                Qt.createComponent("").createObject(null, {}).exec("fuzzel")
                            }
                            hoverEnabled: true
                            onEntered: parent.color = "#ed8796"
                            onExited: parent.color = "${colors.error}"
                        }
                    }
                    
                    // Workspace indikatÃ¶rleri (SVG ikonlarÄ±)
                    Row {
                        spacing: 6
                        anchors.verticalCenter: parent.verticalCenter
                        
                        // Workspace 1 - aktif (dolu daire SVG)
                        Rectangle {
                            width: 20
                            height: 20
                            color: "transparent"
                            
                            Image {
                                anchors.fill: parent
                                source: 'data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 640"><path fill="${colors.success}" d="M320 576C178.6 576 64 461.4 64 320C64 178.6 178.6 64 320 64C461.4 64 576 178.6 576 320C576 461.4 461.4 576 320 576zM320 112C205.1 112 112 205.1 112 320C112 434.9 205.1 528 320 528C434.9 528 528 434.9 528 320C528 205.1 434.9 112 320 112zM320 416C267 416 224 373 224 320C224 267 267 224 320 224C373 224 416 267 416 320C416 373 373 416 320 416z"/></svg>'
                                smooth: true
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                onClicked: console.log("Workspace 1")
                            }
                        }
                        
                        // Workspace 2 - boÅŸ (Ã§ember SVG)
                        Rectangle {
                            width: 20  
                            height: 20
                            color: "transparent"
                            
                            Image {
                                anchors.fill: parent
                                source: 'data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 640"><path fill="${colors.warning}" d="M528 320C528 205.1 434.9 112 320 112C205.1 112 112 205.1 112 320C112 434.9 205.1 528 320 528C434.9 528 528 434.9 528 320zM64 320C64 178.6 178.6 64 320 64C461.4 64 576 178.6 576 320C576 461.4 461.4 576 320 576C178.6 576 64 461.4 64 320z"/></svg>'
                                smooth: true
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                onClicked: console.log("Workspace 2")
                            }
                        }
                        
                        // Workspace 3 - boÅŸ (Ã§ember SVG)
                        Rectangle {
                            width: 20
                            height: 20  
                            color: "transparent"
                            
                            Image {
                                anchors.fill: parent
                                source: 'data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 640"><path fill="${colors.error}" d="M528 320C528 205.1 434.9 112 320 112C205.1 112 112 205.1 112 320C112 434.9 205.1 528 320 528C434.9 528 528 434.9 528 320zM64 320C64 178.6 178.6 64 320 64C461.4 64 576 178.6 576 320C576 461.4 461.4 576 320 576C178.6 576 64 461.4 64 320z"/></svg>'
                                smooth: true
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                onClicked: console.log("Workspace 3")
                            }
                        }
                    }
                    
                    // MÃ¼zik kontrolleri
                    Row {
                        spacing: 6
                        anchors.verticalCenter: parent.verticalCenter
                        
                        // Geri butonu
                        Text {
                            text: "â®"
                            font.pixelSize: ${toString dimensions.iconSize}
                            color: "${colors.musicControl}"
                            anchors.verticalCenter: parent.verticalCenter
                            
                            MouseArea {
                                anchors.fill: parent
                                onClicked: console.log("Previous track")
                            }
                        }
                        
                        // Duraklat/Oynat butonu  
                        Text {
                            text: "â¸"
                            font.pixelSize: ${toString dimensions.iconSize}
                            color: "${colors.musicControl}"
                            anchors.verticalCenter: parent.verticalCenter
                            
                            MouseArea {
                                anchors.fill: parent
                                onClicked: console.log("Pause/Play")
                            }
                        }
                        
                        // Ä°leri butonu
                        Text {
                            text: "â­"
                            font.pixelSize: ${toString dimensions.iconSize}
                            color: "${colors.musicControl}"
                            anchors.verticalCenter: parent.verticalCenter
                            
                            MouseArea {
                                anchors.fill: parent
                                onClicked: console.log("Next track")
                            }
                        }
                        
                        // ÅžarkÄ± adÄ±
                        Text {
                            text: "3AM - Desde el MÃ¡s AllÃ¡"
                            font.pixelSize: ${toString dimensions.fontSize}
                            color: "${colors.text}"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }
                
                // SaÄŸ taraf - sistem bilgileri
                Row {
                    id: rightSection
                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter  
                        rightMargin: ${toString dimensions.margin}
                    }
                    spacing: ${toString dimensions.spacing}
                    
                    // WiFi/Sinyal
                    Row {
                        spacing: 3
                        anchors.verticalCenter: parent.verticalCenter
                        
                        Text {
                            text: "ðŸ“¶"
                            font.pixelSize: ${toString dimensions.iconSize}
                            color: "${colors.text}"
                        }
                        
                        Text {
                            text: "26%"
                            font.pixelSize: ${toString dimensions.fontSize}
                            color: "${colors.text}"
                        }
                    }
                    
                    // Ses kontrolÃ¼ - tÄ±klanabilir
                    Row {
                        spacing: 3
                        anchors.verticalCenter: parent.verticalCenter
                        
                        Text {
                            text: waybarPanel.currentVolume > 50 ? "ðŸ”Š" : waybarPanel.currentVolume > 0 ? "ðŸ”‰" : "ðŸ”‡"
                            font.pixelSize: ${toString dimensions.iconSize}
                            color: "${colors.text}"
                        }
                        
                        Text {
                            text: waybarPanel.currentVolume + "%"
                            font.pixelSize: ${toString dimensions.fontSize}
                            color: "${colors.text}"
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                waybarPanel.audioPopupVisible = !waybarPanel.audioPopupVisible
                                waybarPanel.batteryPopupVisible = false
                                waybarPanel.bluetoothPopupVisible = false
                                waybarPanel.wifiPopupVisible = false
                            }
                        }
                    }
                    
                    // Batarya - tÄ±klanabilir
                    Row {
                        spacing: 3
                        anchors.verticalCenter: parent.verticalCenter
                        
                        Text {
                            text: "ðŸ”‹"
                            font.pixelSize: ${toString dimensions.iconSize}
                            color: "${colors.batteryColor}"
                        }
                        
                        Text {
                            text: "31%"
                            font.pixelSize: ${toString dimensions.fontSize}
                            color: "${colors.batteryColor}"
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                waybarPanel.batteryPopupVisible = !waybarPanel.batteryPopupVisible
                                waybarPanel.audioPopupVisible = false
                                waybarPanel.bluetoothPopupVisible = false
                                waybarPanel.wifiPopupVisible = false
                            }
                        }
                    }
                    
                    // HDMI/Monitor ikonu
                    Text {
                        text: "ðŸ–¥"
                        font.pixelSize: ${toString dimensions.iconSize}
                        color: "${colors.accent}"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    
                    // AÄŸ baÄŸlantÄ±sÄ±
                    Row {
                        spacing: 3
                        anchors.verticalCenter: parent.verticalCenter
                        
                        Text {
                            text: "enp5s0: Aesthetic"
                            font.pixelSize: ${toString dimensions.fontSize}
                            color: "${colors.networkGreen}"
                        }
                        
                        Text {
                            text: "âš¡"
                            font.pixelSize: ${toString dimensions.iconSize}
                            color: "${colors.warning}"
                        }
                        
                        Text {
                            text: "50%"
                            font.pixelSize: ${toString dimensions.fontSize}
                            color: "${colors.text}"
                        }
                    }
                    
                    // Saat
                    Text {
                        id: clockDisplay
                        text: new Date().toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'})
                        font.pixelSize: ${toString dimensions.fontSize}
                        color: "${colors.text}"
                        font.bold: true
                        anchors.verticalCenter: parent.verticalCenter
                        
                        Timer {
                            interval: 1000
                            running: true
                            repeat: true
                            onTriggered: {
                                clockDisplay.text = new Date().toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'})
                            }
                        }
                    }
                }
            }
        }
        
        // SES POPUP PENCERESÄ°
        FloatingWindow {
            id: audioPopup
            visible: waybarPanel.audioPopupVisible
            
            // Panel'in altÄ±na konumlandÄ±r
            anchors {
                top: waybarPanel.bottom
                right: waybarPanel.right
                topMargin: 5
                rightMargin: 100
            }
            
            width: 280
            height: 200
            
            Rectangle {
                anchors.fill: parent
                color: "${colors.background}"
                radius: ${toString dimensions.borderRadius}
                border.color: "${colors.accent}"
                border.width: 1
                
                Column {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 12
                    
                    // BaÅŸlÄ±k
                    Text {
                        text: "ðŸ”Š Ses KontrolÃ¼"
                        font.pixelSize: 16
                        font.bold: true
                        color: "${colors.text}"
                    }
                    
                    // Ses seviyesi slider
                    Row {
                        width: parent.width
                        spacing: 10
                        
                        Text {
                            text: "Ses:"
                            color: "${colors.text}"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        
                        Rectangle {
                            id: volumeSliderBg
                            width: 180
                            height: 6
                            color: "${colors.surface}"
                            radius: 3
                            anchors.verticalCenter: parent.verticalCenter
                            
                            Rectangle {
                                id: volumeSliderFill
                                width: (waybarPanel.currentVolume / 100) * parent.width
                                height: parent.height
                                color: "${colors.accent}"
                                radius: 3
                            }
                            
                            Rectangle {
                                id: volumeHandle
                                x: volumeSliderFill.width - width/2
                                anchors.verticalCenter: parent.verticalCenter
                                width: 16
                                height: 16
                                radius: 8
                                color: "${colors.text}"
                                border.color: "${colors.accent}"
                                border.width: 2
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                onMouseXChanged: {
                                    if (pressed) {
                                        let newVolume = Math.round((mouseX / width) * 100)
                                        waybarPanel.currentVolume = Math.max(0, Math.min(100, newVolume))
                                    }
                                }
                            }
                        }
                        
                        Text {
                            text: waybarPanel.currentVolume + "%"
                            color: "${colors.text}"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                    
                    // ParlaklÄ±k kontrolÃ¼
                    Row {
                        width: parent.width
                        spacing: 10
                        
                        Text {
                            text: "ðŸŽ§ KulaklÄ±k:"
                            color: "${colors.text}"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        
                        Rectangle {
                            id: headphoneSliderBg
                            width: 140
                            height: 6
                            color: "${colors.surface}"
                            radius: 3
                            anchors.verticalCenter: parent.verticalCenter
                            
                            Rectangle {
                                id: headphoneSliderFill
                                width: (waybarPanel.currentHeadphoneVolume / 100) * parent.width
                                height: parent.height
                                color: "${colors.musicControl}"
                                radius: 3
                            }
                            
                            Rectangle {
                                id: headphoneHandle
                                x: headphoneSliderFill.width - width/2
                                anchors.verticalCenter: parent.verticalCenter
                                width: 16
                                height: 16
                                radius: 8
                                color: "${colors.text}"
                                border.color: "${colors.musicControl}"
                                border.width: 2
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                onMouseXChanged: {
                                    if (pressed) {
                                        let newVolume = Math.round((mouseX / width) * 100)
                                        waybarPanel.currentHeadphoneVolume = Math.max(0, Math.min(100, newVolume))
                                    }
                                }
                            }
                        }
                        
                        Text {
                            text: waybarPanel.currentHeadphoneVolume + "%"
                            color: "${colors.text}"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                    
                    // Mikrofon ses seviyesi
                    Row {
                        width: parent.width
                        spacing: 10
                        
                        Text {
                            text: "ðŸŽ¤ Mikrofon:"
                            color: "${colors.text}"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        
                        Rectangle {
                            id: micSliderBg
                            width: 140
                            height: 6
                            color: "${colors.surface}"
                            radius: 3
                            anchors.verticalCenter: parent.verticalCenter
                            
                            Rectangle {
                                width: (waybarPanel.currentMicVolume / 100) * parent.width
                                height: parent.height
                                color: "${colors.error}"
                                radius: 3
                            }
                            
                            Rectangle {
                                x: (waybarPanel.currentMicVolume / 100) * parent.width - width/2
                                anchors.verticalCenter: parent.verticalCenter
                                width: 16
                                height: 16
                                radius: 8
                                color: "${colors.text}"
                                border.color: "${colors.error}"
                                border.width: 2
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                onMouseXChanged: {
                                    if (pressed) {
                                        let newVolume = Math.round((mouseX / width) * 100)
                                        waybarPanel.currentMicVolume = Math.max(0, Math.min(100, newVolume))
                                    }
                                }
                            }
                        }
                        
                        Text {
                            text: waybarPanel.currentMicVolume + "%"
                            color: "${colors.text}"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                    Row {
                        width: parent.width
                        spacing: 10
                        
                        Text {
                            text: "ParlaklÄ±k:"
                            color: "${colors.text}"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        
                        Rectangle {
                            id: brightnessSliderBg
                            width: 150
                            height: 6
                            color: "${colors.surface}"
                            radius: 3
                            anchors.verticalCenter: parent.verticalCenter
                            
                            Rectangle {
                                width: (waybarPanel.currentBrightness / 100) * parent.width
                                height: parent.height
                                color: "${colors.warning}"
                                radius: 3
                            }
                            
                            Rectangle {
                                x: (waybarPanel.currentBrightness / 100) * parent.width - width/2
                                anchors.verticalCenter: parent.verticalCenter
                                width: 16
                                height: 16
                                radius: 8
                                color: "${colors.text}"
                                border.color: "${colors.warning}"
                                border.width: 2
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                onMouseXChanged: {
                                    if (pressed) {
                                        let newBrightness = Math.round((mouseX / width) * 100)
                                        waybarPanel.currentBrightness = Math.max(0, Math.min(100, newBrightness))
                                    }
                                }
                            }
                        }
                        
                        Text {
                            text: waybarPanel.currentBrightness + "%"
                            color: "${colors.text}"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                    
                    // Ã‡Ä±kÄ±ÅŸ cihazlarÄ±
                    Text {
                        text: "ðŸŽ§ Ã‡Ä±kÄ±ÅŸ CihazlarÄ±"
                        color: "${colors.textDim}"
                        font.pixelSize: 14
                    }
                    
                    Column {
                        spacing: 8
                        
                        Row {
                            spacing: 8
                            Rectangle {
                                width: 12
                                height: 12
                                radius: 6
                                color: "${colors.success}"
                            }
                            Text {
                                text: "ðŸŽµ Analog Stereo Output"
                                color: "${colors.text}"
                                font.pixelSize: 13
                            }
                        }
                        
                        Row {
                            spacing: 8
                            Rectangle {
                                width: 12
                                height: 12
                                radius: 6
                                color: "${colors.surface}"
                            }
                            Text {
                                text: "ðŸŽ§ USB Headphones"
                                color: "${colors.textDim}"
                                font.pixelSize: 13
                            }
                        }
                    }
                }
                
                // Kapat butonu
                Text {
                    text: "âœ•"
                    anchors {
                        top: parent.top
                        right: parent.right
                        margins: 8
                    }
                    color: "${colors.error}"
                    font.pixelSize: 16
                    
                    MouseArea {
                        anchors.fill: parent
                        onClicked: waybarPanel.audioPopupVisible = false
                    }
                }
            }
        }
        
        // BATARÄ° POPUP PENCERESÄ°  
        FloatingWindow {
            id: batteryPopup
            visible: waybarPanel.batteryPopupVisible
            
            anchors {
                top: waybarPanel.bottom
                right: waybarPanel.right
                topMargin: 5
                rightMargin: 50
            }
            
            width: 250
            height: 180
            
            Rectangle {
                anchors.fill: parent
                color: "${colors.background}"
                radius: ${toString dimensions.borderRadius}
                border.color: "${colors.batteryColor}"
                border.width: 1
                
                Column {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15
                    
                    // BaÅŸlÄ±k
                    Row {
                        spacing: 8
                        Text {
                            text: "ðŸ”‹"
                            font.pixelSize: 20
                            color: "${colors.batteryColor}"
                        }
                        Text {
                            text: "GÃ¼Ã§ YÃ¶netimi"
                            font.pixelSize: 16
                            font.bold: true
                            color: "${colors.text}"
                        }
                    }
                    
                    // Batarya durumu
                    Column {
                        spacing: 8
                        width: parent.width
                        
                        Row {
                            width: parent.width
                            Text {
                                text: "Åžarj Seviyesi:"
                                color: "${colors.textDim}"
                            }
                            Text {
                                text: "31%"
                                color: "${colors.batteryColor}"
                                font.bold: true
                                anchors.right: parent.right
                            }
                        }
                        
                        // Batarya progress bar
                        Rectangle {
                            width: parent.width
                            height: 12
                            color: "${colors.surface}"
                            radius: 6
                            border.color: "${colors.batteryColor}"
                            border.width: 1
                            
                            Rectangle {
                                width: parent.width * 0.31  // %31
                                height: parent.height - 2
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 1
                                color: "${colors.batteryColor}"
                                radius: 5
                            }
                        }
                        
                        Row {
                            width: parent.width
                            Text {
                                text: "Durum:"
                                color: "${colors.textDim}"
                            }
                            Text {
                                text: "Åžarj oluyor ðŸ”Œ"
                                color: "${colors.success}"
                                anchors.right: parent.right
                            }
                        }
                        
                        Row {
                            width: parent.width  
                            Text {
                                text: "Kalan SÃ¼re:"
                                color: "${colors.textDim}"
                            }
                            Text {
                                text: "2sa 15dk"
                                color: "${colors.text}"
                                anchors.right: parent.right
                            }
                        }
                    }
                    
                    // GÃ¼Ã§ profilleri
                    Text {
                        text: "âš¡ GÃ¼Ã§ Profili"
                        color: "${colors.textDim}"
                        font.pixelSize: 14
                    }
                    
                    Row {
                        spacing: 15
                        
                        Rectangle {
                            width: 60
                            height: 25
                            radius: 5
                            color: "${colors.success}"
                            
                            Text {
                                text: "Performans"
                                anchors.centerIn: parent
                                color: "${colors.background}"
                                font.pixelSize: 10
                                font.bold: true
                            }
                        }
                        
                        Rectangle {
                            width: 50
                            height: 25
                            radius: 5
                            color: "${colors.surface}"
                            border.color: "${colors.textDim}"
                            border.width: 1
                            
                            Text {
                                text: "Dengeli"
                                anchors.centerIn: parent
                                color: "${colors.textDim}"
                                font.pixelSize: 10
                            }
                        }
                        
                        Rectangle {
                            width: 60
                            height: 25
                            radius: 5
                            color: "${colors.surface}"
                            border.color: "${colors.textDim}"
                            border.width: 1
                            
                            Text {
                                text: "Tasarruf"
                                anchors.centerIn: parent
                                color: "${colors.textDim}"
                                font.pixelSize: 10
                            }
                        }
                    }
                }
                
                // Kapat butonu
                Text {
                    text: "âœ•"
                    anchors {
                        top: parent.top
                        right: parent.right
                        margins: 8
                    }
                    color: "${colors.error}"
                    font.pixelSize: 16
                    
                    MouseArea {
                        anchors.fill: parent
                        onClicked: waybarPanel.batteryPopupVisible = false
                    }
                }
            }
        }
        
        // DÄ±ÅŸÄ±na tÄ±klayÄ±nca popup'larÄ± kapat
        MouseArea {
            anchors.fill: parent
            z: -1
            onClicked: {
                waybarPanel.audioPopupVisible = false
                waybarPanel.batteryPopupVisible = false
                waybarPanel.bluetoothPopupVisible = false
                waybarPanel.wifiPopupVisible = false
            }
        }
    }
  '';

in
{
   options.programs.quickshell = {
    enable = lib.mkEnableOption "Enable Quickshell";
    configs = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options.text = lib.mkOption {
          type = lib.types.lines;
          default = "";
        };
      });
      default = {};
      description = "Quickshell configs";
    };
  };

  config = lib.mkIf config.programs.quickshell.enable {
    environment.etc = lib.mapAttrs' (name: cfg: {
      name = "quickshell/${name}";
      value.text = cfg.text;
    }) config.programs.quickshell.configs;
    
    programs.quickshell.configs.shell.text = shellContent;

    environment.systemPackages = with pkgs; [
      playerctl
      acpi          
      iproute2     
      inputs.quickshell.packages.${pkgs.system}.default  
    ];
  };
}