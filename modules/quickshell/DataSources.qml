// DataSources.qml - Tüm sistem verilerini toplar
import Quickshell
import Quickshell.Io
import QtQuick

QtObject {
    id: root
    
    // Sinyaller
    signal timeChanged(string time)
    signal dateChanged(string date)
    signal cpuUsageChanged(real usage)
    signal ramUsageChanged(real usage)
    signal gpuUsageChanged(real usage)
    signal volumeChanged(int level, bool muted)
    signal wifiChanged(string name, int strength)
    signal musicChanged(string track, bool playing)
    
    // Zaman güncelleyici
    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        
        onTriggered: {
            const now = new Date()
            const turkishMonths = [
                "Ocak", "Şubat", "Mart", "Nisan", "Mayıs", "Haziran",
                "Temmuz", "Ağustos", "Eylül", "Ekim", "Kasım", "Aralık"
            ]
            const turkishDays = [
                "Pazar", "Pazartesi", "Salı", "Çarşamba", 
                "Perşembe", "Cuma", "Cumartesi"
            ]
            
            // Saat
            const timeStr = Qt.formatTime(now, "HH:mm:ss")
            root.timeChanged(timeStr)
            
            // Tarih
            const day = turkishDays[now.getDay()]
            const dayNum = now.getDate()
            const month = turkishMonths[now.getMonth()]
            const year = now.getFullYear()
            const dateStr = `${day}, ${dayNum} ${month} ${year}`
            root.dateChanged(dateStr)
        }
    }
    
    // CPU kullanımı
    Process {
        id: cpuProcess
        command: ["bash", "-c", "grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$3+$4+$5)} END {print usage}'"]
        running: true
        
        stdout: StdioCollector {
            onStreamFinished: {
                const usage = parseFloat(this.text.trim())
                if (!isNaN(usage)) {
                    root.cpuUsageChanged(usage)
                }
            }
        }
    }
    
    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: cpuProcess.running = true
    }
    
    // RAM kullanımı
    Process {
        id: ramProcess
        command: ["bash", "-c", "free | grep Mem | awk '{print ($3/$2) * 100.0}'"]
        running: true
        
        stdout: StdioCollector {
            onStreamFinished: {
                const usage = parseFloat(this.text.trim())
                if (!isNaN(usage)) {
                    root.ramUsageChanged(usage)
                }
            }
        }
    }
    
    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: ramProcess.running = true
    }
    
    // GPU kullanımı (NVIDIA için)
    Process {
        id: gpuProcess
        command: ["bash", "-c", "nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null || echo '0'"]
        running: true
        
        stdout: StdioCollector {
            onStreamFinished: {
                const usage = parseFloat(this.text.trim())
                if (!isNaN(usage)) {
                    root.gpuUsageChanged(usage)
                }
            }
        }
    }
    
    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: gpuProcess.running = true
    }
    
    // Ses seviyesi
    Process {
        id: volumeProcess
        command: ["bash", "-c", "pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '\\d+(?=%)' | head -1"]
        running: true
        
        stdout: StdioCollector {
            onStreamFinished: {
                const volume = parseInt(this.text.trim())
                if (!isNaN(volume)) {
                    // Sessiz olup olmadığını kontrol et
                    muteProcess.running = true
                    volumeLevel = volume
                }
            }
        }
        
        property int volumeLevel: 50
    }
    
    Process {
        id: muteProcess
        command: ["bash", "-c", "pactl get-sink-mute @DEFAULT_SINK@ | grep -q 'yes' && echo 'true' || echo 'false'"]
        running: false
        
        stdout: StdioCollector {
            onStreamFinished: {
                const isMuted = this.text.trim() === 'true'
                root.volumeChanged(volumeProcess.volumeLevel, isMuted)
            }
        }
    }
    
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: volumeProcess.running = true
    }
    
    // WiFi durumu
    Process {
        id: wifiProcess
        command: ["bash", "-c", "iwgetid -r 2>/dev/null || echo 'Bağlı değil'"]
        running: true
        
        stdout: StdioCollector {
            onStreamFinished: {
                const wifiName = this.text.trim()
                wifiStrengthProcess.wifiName = wifiName
                wifiStrengthProcess.running = true
            }
        }
    }
    
    Process {
        id: wifiStrengthProcess
        command: ["bash", "-c", "cat /proc/net/wireless | awk 'NR==3 {print int($3 * 100 / 70)}' 2>/dev/null || echo '0'"]
        running: false
        
        property string wifiName: ""
        
        stdout: StdioCollector {
            onStreamFinished: {
                const strength = parseInt(this.text.trim())
                root.wifiChanged(wifiStrengthProcess.wifiName, isNaN(strength) ? 0 : strength)
            }
        }
    }
    
    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: wifiProcess.running = true
    }
    
    // Müzik durumu (PlayerCtl ile)
    Process {
        id: musicProcess
        command: ["playerctl", "metadata", "--format", "{{ artist }} - {{ title }}"]
        running: true
        
        stdout: StdioCollector {
            onStreamFinished: {
                const track = this.text.trim()
                musicStatusProcess.currentTrack = track
                musicStatusProcess.running = true
            }
        }
        
        onExited: {
            if (exitCode !== 0) {
                root.musicChanged("", false)
            }
        }
    }
    
    Process {
        id: musicStatusProcess
        command: ["playerctl", "status"]
        running: false
        
        property string currentTrack: ""
        
        stdout: StdioCollector {
            onStreamFinished: {
                const isPlaying = this.text.trim() === "Playing"
                root.musicChanged(musicStatusProcess.currentTrack, isPlaying)
            }
        }
        
        onExited: {
            if (exitCode !== 0) {
                root.musicChanged(musicStatusProcess.currentTrack, false)
            }
        }
    }
    
    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: musicProcess.running = true
    }
}
