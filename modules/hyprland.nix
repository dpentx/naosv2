# ~/.config/home-manager/modules/hyprland.nix
{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # Monitor yapılandırması - herhangi bir monitörü kullan
      monitor = [
        ",preferred,auto,1"
      ];
      
      # Başlangıç uygulamaları
      exec-once = [
        "swww init"
        "swww img /home/asus/wallpaper/wallpaper.jpg"
        "dunst"
        "/usr/lib/polkit-kde-authentication-agent-1"
        # Bluetooth ses desteği
        "blueman-applet"
        "~/.config/scripts/bluetooth-audio-fix.sh fix"
        # Quickshell'i başlat
        "quickshell"
      ];
      
      # Input yapılandırması
      input = {
        kb_layout = "tr";
        kb_options = "grp:alt_shift_toggle";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
        };
        sensitivity = 0;
      };
      
      # Genel yapılandırma
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
        "col.inactive_border" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
        layout = "dwindle";
      };
      
      # Dekorasyon - Yeni syntax
      decoration = {
        rounding = 16;
        blur = {
          enabled = true;
          size = 8;
          passes = 3;
          new_optimizations = true;
        };
        # Yeni shadow syntax
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
      };
      
      # Animasyonlar
      animations = {
        enabled = true;
        bezier = [
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.1"
          "winOut, 0.3, -0.3, 0, 1"
          "liner, 1, 1, 1, 1"
        ];
        animation = [
          "windows, 1, 6, wind, slide"
          "windowsIn, 1, 6, winIn, slide"
          "windowsOut, 1, 5, winOut, slide"
          "windowsMove, 1, 5, wind, slide"
          "border, 1, 1, liner"
          "borderangle, 1, 30, liner, loop"
          "fade, 1, 10, default"
          "workspaces, 1, 5, wind"
        ];
      };
      
      # Pencere kuralları
      windowrulev2 = [
        "float, class:^(pavucontrol)$"
        "float, class:^(blueman-manager)$"
        "float, class:^(nm-connection-editor)$"
        "float, class:^(chromium)$"
        "float, class:^(thunar)$"
        "float, title:^(btop)$"
        "float, title:^(update-sys)$"
        "size 800 600, class:^(pavucontrol)$"
        "center, class:^(pavucontrol)$"
      ];
      
      # Keybindings
      bind = [
        "SUPER, Q, exec, kitty"
        "SUPER, C, killactive"
        "SUPER, M, exit"
        "SUPER, E, exec, thunar"
        "SUPER, V, togglefloating"
        "SUPER, R, exec, wofi --show drun"
        "SUPER, P, pseudo"
        "SUPER, J, togglesplit"
        
        # Ekran görüntüsü
        "SUPER, Print, exec, grim -g \"$(slurp)\" - | wl-copy"
        ", Print, exec, grim - | wl-copy"
        
        # Media keys - Bluetooth dahil tüm cihazlar için
        ", XF86AudioRaiseVolume, exec, ~/.config/scripts/bluetooth-audio-fix.sh volume up"
        ", XF86AudioLowerVolume, exec, ~/.config/scripts/bluetooth-audio-fix.sh volume down"
        ", XF86AudioMute, exec, ~/.config/scripts/bluetooth-audio-fix.sh volume mute"
        
        # Alternatif ses kontrolleri (bluetooth için özel)
        "SUPER, equal, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
        "SUPER, minus, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
        "SUPER, 0, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
        
        # Media control
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
        
        # Brightness
        ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"
        ", XF86MonBrightnessUp, exec, brightnessctl set 10%+"
        
        # Workspace navigation
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"
        "SUPER, 0, workspace, 10"
        
        # Move to workspace
        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"
        "SUPER SHIFT, 6, movetoworkspace, 6"
        "SUPER SHIFT, 7, movetoworkspace, 7"
        "SUPER SHIFT, 8, movetoworkspace, 8"
        "SUPER SHIFT, 9, movetoworkspace, 9"
        "SUPER SHIFT, 0, movetoworkspace, 10"
        
        # Move/resize windows
        "SUPER, left, movefocus, l"
        "SUPER, right, movefocus, r"
        "SUPER, up, movefocus, u"
        "SUPER, down, movefocus, d"
        
        # Special binds
        "SUPER SHIFT, S, exec, grim -g \"$(slurp)\" ~/Pictures/Screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png"
        "SUPER, F11, fullscreen, 0"
        "SUPER, F, fullscreen, 1"
        
        # Quickshell restart
        "SUPER SHIFT, R, exec, pkill quickshell && quickshell"

  # QuickShell sistem kontrolleri
  "SUPER, SPACE, exec, fuzzel"  # Fuzzel launcher (senin wofi yerine)
  "SUPER SHIFT, A, exec, pavucontrol"        # Ses kontrolü
  "SUPER SHIFT, B, exec, blueman-manager"    # Bluetooth
  "SUPER SHIFT, N, exec, nm-connection-editor" # Network
  
  # QuickShell yeniden başlatma
  "SUPER SHIFT, Q, exec, pkill quickshell && sleep 0.1 && quickshell &"
  
  # Sistem kontrol script'leri
  "SUPER, F1, exec, ~/.config/scripts/quickshell-system.sh audio control"
  "SUPER, F2, exec, ~/.config/scripts/quickshell-system.sh bluetooth manager"
  "SUPER, F3, exec, ~/.config/scripts/quickshell-system.sh network manager"
  
      ];
      
      # Mouse bindings
      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];
    };
  };
}
