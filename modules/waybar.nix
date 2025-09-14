# ~/.config/home-manager/modules/waybar.nix
{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 42;
        spacing = 4;
        margin-top = 5;
        margin-left = 10;
        margin-right = 10;
        
        modules-left = [ 
          "hyprland/workspaces" 
          "custom/separator"
          "custom/media-with-controls" 
        ];
        modules-center = [ 
          "custom/weather"
        ];
        modules-right = [ 
          "custom/notification"
          "cpu" 
          "memory" 
          "temperature"
          "pulseaudio" 
          "bluetooth"
          "network" 
          "battery"
          "custom/power-menu"
          "tray"
        ];
        
        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          warp-on-scroll = false;
          format = "{icon}";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            "6" = "";
            "7" = "";
            "8" = "";
            "9" = "";
            "10" = "";
            active = "";
            default = "";
          };
          persistent-workspaces = {
            "*" = 5;
          };
        };
        
        "custom/separator" = {
          format = "│";
          interval = "once";
          tooltip = false;
        };
        
        "custom/media-with-controls" = {
          format = "{icon} {}";
          return-type = "json";
          max-length = 40;
          format-icons = {
            default = "";
          };
          escape = true;
          exec = "playerctl -a metadata --format '{\"text\": \"{{artist}} - {{markup_escape(title)}}\", \"tooltip\": \"{{playerName}} : {{markup_escape(title)}}\\nSol: Oynat/Durdur | Sağ: Sonraki | Orta: Önceki\", \"alt\": \"{{status}}\", \"class\": \"{{status}}\"}' 2>/dev/null || echo '{\"text\": \"Müzik yok\", \"class\": \"none\"}'";
          on-click = "playerctl play-pause";
          on-click-right = "playerctl next";
          on-click-middle = "playerctl previous";
          interval = 2;
        };
        
        "custom/weather" = {
          format = " {}°C";
          exec = "curl -s 'wttr.in/Kars?format=%t' | sed 's/[^0-9-]//g'";
          interval = 1800;
          tooltip-format = "Hava Durumu";
        };
        
        "custom/notification" = {
          tooltip = true;
          format = "";
          tooltip-format = "Bildirimler\\nSol tık: Son bildirimi göster\\nSağ tık: Tümünü temizle";
          exec = "echo ''";
          on-click = "dunstctl history-pop";
          on-click-right = "dunstctl close-all";
          interval = 60;
        };
        
        cpu = {
          format = " {usage}%";
          tooltip-format = "CPU Kullanımı: {usage}%\\nSol tık: Sistem monitörü aç";
          interval = 2;
          on-click = "kitty --class btop -e btop";
        };
        
        memory = {
          format = " {}%";
          tooltip-format = "RAM: {used:0.1f}G/{total:0.1f}G ({percentage}%)\\nSwap: {swapUsed:0.1f}G/{swapTotal:0.1f}G\\nSol tık: Sistem monitörü aç";
          on-click = "kitty --class btop -e btop";
        };
        
        temperature = {
          hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
          critical-threshold = 80;
          format = " {temperatureC}°C";
          format-critical = " {temperatureC}°C";
          tooltip-format = "Sistem Sıcaklığı: {temperatureC}°C";
        };
        
        "custom/power-menu" = {
          format = "";
          on-click = "wlogout -b 5 -T 400 -B 400";
          tooltip-format = "Güç Menüsü\\nSol tık: Güç seçeneklerini aç";
        };
        
        pulseaudio = {
          format = "{icon} {volume}%";
          format-bluetooth = " {volume}%";
          format-bluetooth-muted = " Muted";
          format-muted = " Muted";
          format-source = " {volume}%";
          format-source-muted = " Muted";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click = "pavucontrol";
          on-click-right = "pactl set-sink-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-scroll-up = "pactl set-sink-volume @DEFAULT_AUDIO_SINK@ +5%";
          on-scroll-down = "pactl set-sink-volume @DEFAULT_AUDIO_SINK@ -5%";
          scroll-step = 5;
          tooltip-format = "Ses: {volume}%\\nCihaz: {desc}\\nSol tık: Ses kontrolü\\nSağ tık: Sessiz aç/kapat\\nScroll: Ses seviyesi";
          ignored-sinks = ["Easy Effects Sink"];
        };
        
        bluetooth = {
          format = " {status}";
          format-disabled = "";
          format-off = "";
          format-on = "";
          format-connected = " {device_alias}";
          format-connected-battery = " {device_alias} {device_battery_percentage}%";
          tooltip-format = "{controller_alias}\\t{controller_address}\\n\\n{num_connections} bağlı\\n\\nSol tık: Bluetooth yöneticisi\\nSağ tık: Bluetooth aç/kapat";
          tooltip-format-connected = "{controller_alias}\\t{controller_address}\\n\\n{num_connections} bağlı\\n\\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\\t{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\\t{device_address}\\t{device_battery_percentage}%";
          on-click = "blueman-manager";
          on-click-right = "rfkill toggle bluetooth";
        };
        
        network = {
          format-wifi = " {essid}";
          format-ethernet = "";
          format-disconnected = "⚠ Bağlantısız";
          tooltip-format = "WiFi: {essid}\\nSinyal: {signalStrength}%\\nHız: {bandwidthDownBits}↓ {bandwidthUpBits}↑\\nIP: {ipaddr}\\nAğ geçidi: {gwaddr}\\n\\nSol tık: Ağ yöneticisi\\nSağ tık: WiFi aç/kapat";
          tooltip-format-disconnected = "Ağ bağlantısı yok\\n\\nSol tık: Ağ yöneticisi";
          on-click = "nm-connection-editor";
          on-click-right = "nmcli radio wifi toggle";
        };
        
        battery = {
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{icon} {time}";
          format-icons = ["" "" "" "" ""];
          tooltip-format = "Batarya: {capacity}%\\nDurum: {status}\\nKalan süre: {time}\\nGüç: {power}W";
        };
        
        tray = {
          spacing = 8;
          icon-size = 16;
        };
      };
    };
    
    style = ''
      * {
        font-family: 'JetBrains Mono Nerd Font', 'Font Awesome 6 Free', monospace;
        font-size: 13px;
        font-weight: 500;
        border: none;
        border-radius: 0;
        min-height: 0;
      }
      
      window#waybar {
        background: linear-gradient(135deg, rgba(30, 30, 46, 0.95), rgba(24, 24, 37, 0.95));
        border-radius: 15px;
        color: #cdd6f4;
        transition-property: background-color;
        transition-duration: 0.3s;
        border: 1px solid rgba(137, 180, 250, 0.2);
      }
      
      window#waybar.hidden {
        opacity: 0.2;
      }
      
      /* Genel modül stilleri */
      .modules-left > widget:first-child > #workspaces {
        margin-left: 0;
      }
      .modules-right > widget:last-child > #tray {
        margin-right: 0;
      }
      
      /* Sol Taraf - Workspaces ve Media */
      #workspaces {
        margin: 2px 4px;
        padding: 2px 4px;
        background: linear-gradient(135deg, rgba(137, 180, 250, 0.15), rgba(116, 199, 236, 0.15));
        border-radius: 12px;
        border: 1px solid rgba(137, 180, 250, 0.3);
      }
      
      #workspaces button {
        padding: 6px 10px;
        margin: 1px 2px;
        background: transparent;
        color: rgba(205, 214, 244, 0.7);
        border-radius: 8px;
        transition: all 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94);
        border: 1px solid transparent;
      }
      
      #workspaces button:hover {
        background: linear-gradient(135deg, rgba(137, 180, 250, 0.2), rgba(116, 199, 236, 0.2));
        color: #cdd6f4;
        border: 1px solid rgba(137, 180, 250, 0.4);
        transform: translateY(-1px);
        box-shadow: 0 4px 8px rgba(137, 180, 250, 0.2);
      }
      
      #workspaces button.active {
        background: linear-gradient(135deg, rgba(137, 180, 250, 0.4), rgba(116, 199, 236, 0.4));
        color: #1e1e2e;
        font-weight: bold;
        border: 1px solid rgba(137, 180, 250, 0.6);
        box-shadow: 0 2px 4px rgba(137, 180, 250, 0.3);
      }
      
      #custom-separator {
        color: rgba(205, 214, 244, 0.3);
        margin: 0 6px;
        font-size: 18px;
      }
      
      #custom-media-with-controls {
        margin: 2px 4px;
        padding: 6px 12px;
        background: linear-gradient(135deg, rgba(203, 166, 247, 0.2), rgba(245, 194, 231, 0.2));
        border-radius: 12px;
        color: #cdd6f4;
        min-width: 180px;
        border: 1px solid rgba(203, 166, 247, 0.3);
        transition: all 0.3s ease;
      }
      
      #custom-media-with-controls:hover {
        background: linear-gradient(135deg, rgba(203, 166, 247, 0.3), rgba(245, 194, 231, 0.3));
        transform: translateY(-1px);
        box-shadow: 0 4px 8px rgba(203, 166, 247, 0.2);
      }
      
      /* Orta - Hava Durumu */
      #custom-weather {
        margin: 2px 8px;
        padding: 6px 15px;
        background: linear-gradient(135deg, rgba(250, 179, 135, 0.2), rgba(249, 226, 175, 0.2));
        border-radius: 12px;
        color: #cdd6f4;
        font-weight: 600;
        font-size: 14px;
        border: 1px solid rgba(250, 179, 135, 0.3);
        transition: all 0.3s ease;
      }
      
      #custom-weather:hover { 
        background: linear-gradient(135deg, rgba(250, 179, 135, 0.3), rgba(249, 226, 175, 0.3));
        transform: translateY(-1px);
        box-shadow: 0 4px 8px rgba(250, 179, 135, 0.2);
      }
      
      /* Sağ Taraf - Sistem modülleri */
      #custom-notification,
      #cpu,
      #memory,
      #temperature,
      #pulseaudio,
      #bluetooth,
      #network,
      #battery,
      #custom-power-menu {
        margin: 2px 3px;
        padding: 6px 10px;
        border-radius: 12px;
        color: #cdd6f4;
        transition: all 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94);
        border: 1px solid transparent;
      }
      
      #custom-notification {
        background: linear-gradient(135deg, rgba(250, 179, 135, 0.2), rgba(254, 100, 11, 0.2));
        border: 1px solid rgba(250, 179, 135, 0.3);
        font-size: 15px;
      }
      
      #cpu {
        background: linear-gradient(135deg, rgba(137, 180, 250, 0.2), rgba(116, 199, 236, 0.2));
        border: 1px solid rgba(137, 180, 250, 0.3);
      }
      
      #memory {
        background: linear-gradient(135deg, rgba(235, 160, 172, 0.2), rgba(243, 139, 168, 0.2));
        border: 1px solid rgba(235, 160, 172, 0.3);
      }
      
      #temperature {
        background: linear-gradient(135deg, rgba(249, 226, 175, 0.2), rgba(250, 179, 135, 0.2));
        border: 1px solid rgba(249, 226, 175, 0.3);
      }
      
      #temperature.critical {
        background: linear-gradient(135deg, rgba(243, 139, 168, 0.3), rgba(235, 160, 172, 0.3));
        color: #f38ba8;
        animation: blink 1s linear infinite alternate;
      }
      
      #pulseaudio {
        background: linear-gradient(135deg, rgba(203, 166, 247, 0.2), rgba(245, 194, 231, 0.2));
        border: 1px solid rgba(203, 166, 247, 0.3);
      }
      
      #bluetooth {
        background: linear-gradient(135deg, rgba(116, 199, 236, 0.2), rgba(137, 180, 250, 0.2));
        border: 1px solid rgba(116, 199, 236, 0.3);
      }
      
      #network {
        background: linear-gradient(135deg, rgba(166, 227, 161, 0.2), rgba(148, 226, 213, 0.2));
        border: 1px solid rgba(166, 227, 161, 0.3);
      }
      
      #network.disconnected {
        background: linear-gradient(135deg, rgba(243, 139, 168, 0.2), rgba(235, 160, 172, 0.2));
        color: #f38ba8;
      }
      
      #battery {
        background: linear-gradient(135deg, rgba(166, 227, 161, 0.2), rgba(148, 226, 213, 0.2));
        border: 1px solid rgba(166, 227, 161, 0.3);
      }
      
      #battery.charging {
        background: linear-gradient(135deg, rgba(249, 226, 175, 0.3), rgba(250, 179, 135, 0.3));
        color: #fab387;
      }
      
      #battery.warning:not(.charging) {
        background: linear-gradient(135deg, rgba(250, 179, 135, 0.3), rgba(254, 100, 11, 0.3));
        color: #fab387;
      }
      
      #battery.critical:not(.charging) {
        background: linear-gradient(135deg, rgba(243, 139, 168, 0.3), rgba(235, 160, 172, 0.3));
        color: #f38ba8;
        animation: blink 0.5s linear infinite alternate;
      }
      
      #custom-power-menu {
        background: linear-gradient(135deg, rgba(243, 139, 168, 0.25), rgba(235, 160, 172, 0.25));
        border: 1px solid rgba(243, 139, 168, 0.4);
        font-size: 15px;
        font-weight: bold;
      }
      
      #tray {
        margin: 2px 4px;
        padding: 6px 8px;
        background: linear-gradient(135deg, rgba(205, 214, 244, 0.1), rgba(186, 194, 222, 0.1));
        border-radius: 12px;
        border: 1px solid rgba(205, 214, 244, 0.2);
      }
      
      /* Hover Efektleri */
      #custom-notification:hover {
        background: linear-gradient(135deg, rgba(250, 179, 135, 0.3), rgba(254, 100, 11, 0.3));
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(250, 179, 135, 0.3);
      }
      
      #cpu:hover {
        background: linear-gradient(135deg, rgba(137, 180, 250, 0.3), rgba(116, 199, 236, 0.3));
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(137, 180, 250, 0.3);
      }
      
      #memory:hover {
        background: linear-gradient(135deg, rgba(235, 160, 172, 0.3), rgba(243, 139, 168, 0.3));
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(235, 160, 172, 0.3);
      }
      
      #temperature:hover {
        background: linear-gradient(135deg, rgba(249, 226, 175, 0.3), rgba(250, 179, 135, 0.3));
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(249, 226, 175, 0.3);
      }
      
      #pulseaudio:hover {
        background: linear-gradient(135deg, rgba(203, 166, 247, 0.3), rgba(245, 194, 231, 0.3));
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(203, 166, 247, 0.3);
      }
      
      #bluetooth:hover {
        background: linear-gradient(135deg, rgba(116, 199, 236, 0.3), rgba(137, 180, 250, 0.3));
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(116, 199, 236, 0.3);
      }
      
      #network:hover {
        background: linear-gradient(135deg, rgba(166, 227, 161, 0.3), rgba(148, 226, 213, 0.3));
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(166, 227, 161, 0.3);
      }
      
      #battery:hover {
        background: linear-gradient(135deg, rgba(166, 227, 161, 0.3), rgba(148, 226, 213, 0.3));
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(166, 227, 161, 0.3);
      }
      
      #custom-power-menu:hover {
        background: linear-gradient(135deg, rgba(243, 139, 168, 0.4), rgba(235, 160, 172, 0.4));
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(243, 139, 168, 0.4);
      }
      
      #tray:hover {
        background: linear-gradient(135deg, rgba(205, 214, 244, 0.15), rgba(186, 194, 222, 0.15));
        transform: translateY(-1px);
      }
      
      /* Animasyonlar */
      @keyframes blink {
        to {
          background-color: rgba(243, 139, 168, 0.5);
        }
      }
      
      /* Tooltip stilleri */
      tooltip {
        border-radius: 12px;
        background: linear-gradient(135deg, rgba(30, 30, 46, 0.98), rgba(24, 24, 37, 0.98));
        border: 2px solid rgba(137, 180, 250, 0.3);
        color: #cdd6f4;
        font-family: 'JetBrains Mono Nerd Font', monospace;
        font-size: 12px;
        padding: 8px 12px;
        box-shadow: 0 8px 16px rgba(0, 0, 0, 0.4);
      }
      
      tooltip label {
        color: #cdd6f4;
      }
      
      /* Pulse efekti aktif workspace için */
      #workspaces button.active {
        animation: pulse 2s infinite;
      }
      
      @keyframes pulse {
        0% {
          box-shadow: 0 2px 4px rgba(137, 180, 250, 0.3);
        }
        50% {
          box-shadow: 0 4px 8px rgba(137, 180, 250, 0.6);
        }
        100% {
          box-shadow: 0 2px 4px rgba(137, 180, 250, 0.3);
        }
      }
    '';
  };
}
