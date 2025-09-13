#!/bin/bash
# ~/.config/scripts/bluetooth-audio-fix.sh

# Bluetooth ses cihazını otomatik olarak varsayılan yap
fix_bluetooth_audio() {
    # Bluetooth ses cihazlarını bul
    BT_SINK=$(pactl list short sinks | grep -i "bluez" | head -n1 | cut -f2)
    BT_SOURCE=$(pactl list short sources | grep -i "bluez" | head -n1 | cut -f2)
    
    if [ ! -z "$BT_SINK" ]; then
        echo "Bluetooth sink bulundu: $BT_SINK"
        pactl set-default-sink "$BT_SINK"
        
        # Mevcut ses akışlarını bluetooth cihazına yönlendir
        pactl list short sink-inputs | while read STREAM; do
            STREAM_ID=$(echo $STREAM | cut -d' ' -f1)
            echo "Stream $STREAM_ID bluetooth cihazına yönlendiriliyor..."
            pactl move-sink-input "$STREAM_ID" "$BT_SINK" 2>/dev/null
        done
        
        # Ses seviyesini eşitle
        pactl set-sink-volume "$BT_SINK" 70%
        
        # A2DP profil kontrolü
        BT_CARD=$(pactl list cards short | grep -i "bluez" | head -n1 | cut -f2)
        if [ ! -z "$BT_CARD" ]; then
            echo "Bluetooth kartı: $BT_CARD"
            pactl set-card-profile "$BT_CARD" a2dp-sink 2>/dev/null || \
            pactl set-card-profile "$BT_CARD" a2dp_sink 2>/dev/null
        fi
        
        echo "Bluetooth ses yapılandırması tamamlandı"
        notify-send "Bluetooth Ses" "Bluetooth ses cihazı etkinleştirildi" -i audio-headphones
    else
        echo "Bluetooth ses cihazı bulunamadı"
    fi
    
    if [ ! -z "$BT_SOURCE" ]; then
        echo "Bluetooth mikrofon bulundu: $BT_SOURCE"
        pactl set-default-source "$BT_SOURCE"
    fi
}

# Ses seviyesi kontrolü (bluetooth cihazlar için)
bluetooth_volume_control() {
    ACTION=$1
    BT_SINK=$(pactl list short sinks | grep -i "bluez" | head -n1 | cut -f2)
    
    if [ ! -z "$BT_SINK" ]; then
        case $ACTION in
            "up")
                pactl set-sink-volume "$BT_SINK" +5%
                ;;
            "down")
                pactl set-sink-volume "$BT_SINK" -5%
                ;;
            "mute")
                pactl set-sink-mute "$BT_SINK" toggle
                ;;
        esac
        
        # Mevcut seviyeyi göster
        VOLUME=$(pactl get-sink-volume "$BT_SINK" | grep -oP '\d+%' | head -n1)
        notify-send "Bluetooth Ses" "Seviye: $VOLUME" -i audio-volume-high -t 1000
    else
        # Normal ses kontrolü
        case $ACTION in
            "up")
                wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
                ;;
            "down")
                wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
                ;;
            "mute")
                wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
                ;;
        esac
    fi
}

# Bluetooth bağlantı izleme
monitor_bluetooth() {
    dbus-monitor --system "type='signal',interface='org.freedesktop.DBus.Properties'" | \
    while read line; do
        if echo "$line" | grep -q "Connected.*true"; then
            sleep 2  # Bağlantının stabilleşmesi için bekle
            fix_bluetooth_audio
        fi
    done
}

case $1 in
    "fix")
        fix_bluetooth_audio
        ;;
    "volume")
        bluetooth_volume_control $2
        ;;
    "monitor")
        monitor_bluetooth
        ;;
    *)
        echo "Kullanım: $0 {fix|volume {up|down|mute}|monitor}"
        echo "  fix     - Bluetooth ses yapılandırmasını düzelt"
        echo "  volume  - Bluetooth ses seviyesini kontrol et"
        echo "  monitor - Bluetooth bağlantılarını izle"
        ;;
esac
