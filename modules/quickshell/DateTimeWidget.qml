// DateTimeWidget.qml
pragma Singleton
import Quickshell
import QtQuick

Singleton {
    id: root
    
    readonly property string time: {
        Qt.formatDateTime(clock.date, "HH:mm:ss")
    }
    
    readonly property string date: {
        const turkishMonths = [
            "Ocak", "Şubat", "Mart", "Nisan", "Mayıs", "Haziran",
            "Temmuz", "Ağustos", "Eylül", "Ekim", "Kasım", "Aralık"
        ]
        const turkishDays = [
            "Pazar", "Pazartesi", "Salı", "Çarşamba", 
            "Perşembe", "Cuma", "Cumartesi"
        ]
        
        const currentDate = clock.date
        const day = turkishDays[currentDate.getDay()]
        const dayNum = currentDate.getDate()
        const month = turkishMonths[currentDate.getMonth()]
        const year = currentDate.getFullYear()
        
        return `${day}, ${dayNum} ${month} ${year}`
    }
    
    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}

// DateTimeDisplay.qml - Ana widget dosyası
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    
    property string currentTime: ""
    property string currentDate: ""
    
    width: dateTimeLayout.implicitWidth + 20
    height: 32
    radius: 6
    color: "transparent"
    
    Column {
        id: dateTimeLayout
        anchors.centerIn: parent
        spacing: 1
        
        Text {
            text: DateTimeWidget.time
            color: "#cdd6f4"
            font.pixelSize: 14
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
        }
        
        Text {
            text: DateTimeWidget.date
            color: "#bac2de"
            font.pixelSize: 9
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
        }
    }
}
