// WorkspaceWidget.qml
import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

RowLayout {
    id: root
    spacing: 4
    
    property var hyprland: Hyprland.instance
    
    Repeater {
        model: hyprland?.workspaces ?? []
        
        Rectangle {
            id: workspaceButton
            required property var modelData
            
            width: 32
            height: 32
            radius: 6
            
            color: {
                if (modelData.id === hyprland?.focusedWorkspace?.id) {
                    return "#cba6f7"  // Aktif workspace
                } else if (modelData.windows > 0) {
                    return "#585b70"  // Pencere olan workspace
                } else {
                    return "transparent"  // Boş workspace
                }
            }
            
            border.width: 1
            border.color: "#6c7086"
            
            Text {
                anchors.centerIn: parent
                text: modelData.name
                color: {
                    if (modelData.id === hyprland?.focusedWorkspace?.id) {
                        return "#1e1e2e"
                    } else {
                        return "#cdd6f4"
                    }
                }
                font.pixelSize: 12
                font.bold: modelData.id === hyprland?.focusedWorkspace?.id
            }
            
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                
                onEntered: parent.color = Qt.lighter(parent.color, 1.2)
                onExited: parent.color = Qt.binding(() => {
                    if (modelData.id === hyprland?.focusedWorkspace?.id) {
                        return "#cba6f7"
                    } else if (modelData.windows > 0) {
                        return "#585b70"
                    } else {
                        return "transparent"
                    }
                })
                
                onClicked: {
                    Process {
                        command: ["hyprctl", "dispatch", "workspace", modelData.name]
                        running: true
                    }
                }
            }
        }
    }
}
