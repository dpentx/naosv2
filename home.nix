{ config, pkgs, lib, ... }:

{
  home.username = "asus";
  home.homeDirectory = "/home/asus";

  home.stateVersion = "25.05";
  
  imports = [
    ./modules/hyprland.nix
    ./modules/waybar.nix
    ./modules/terminal.nix
    ./modules/launcher.nix
    ./modules/notifications.nix
    ./modules/shell.nix
  ];

  home.packages = with pkgs; [
    jetbrains.pycharm-community
    (python3.withPackages (p: with p; [
      pip
      virtualenv
      textual
    ]))
    prismlauncher
    qbittorrent
    harmony-music
    gtk3
    pamixer
    libnotify
    # Nerd Font
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  nixpkgs.config.allowUnfree = true;

  services = {
    # Bluetooth applet (sistem seviyesinde blueman var)
    blueman-applet.enable = true;
    
    # Bildirimler (sistem seviyesinde dunst var ama home-manager ile yapılandırmak daha iyi)
    dunst = {
      enable = true;
      settings = {
        global = {
          width = 300;
          height = 300;
          offset = "30x50";
          origin = "top-right";
          transparency = 10;
          frame_color = "#89b4fa";
          font = "JetBrains Mono Nerd Font 10";
          corner_radius = 15;
        };
        urgency_normal = {
          background = "#1e1e2e";
          foreground = "#cdd6f4";
          timeout = 10;
        };
      };
    };
  }; # Bu kapatma parantezi eksikti!

  home.sessionVariables = {
  };

  home.file.".config/scripts/bluetooth-audio-fix.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      # Bluetooth ses düzeltme scripti
      
      fix_bluetooth_audio() {
          BT_SINK=$(pactl list short sinks | grep -i "bluez" | head -n1 | cut -f2)
          
          if [ ! -z "$BT_SINK" ]; then
              echo "Bluetooth sink bulundu: $BT_SINK"
              pactl set-default-sink "$BT_SINK"
              
              pactl list short sink-inputs | while read STREAM; do
                  STREAM_ID=$(echo $STREAM | cut -d' ' -f1)
                  pactl move-sink-input "$STREAM_ID" "$BT_SINK" 2>/dev/null
              done
              
              pactl set-sink-volume "$BT_SINK" 70%
              notify-send "Bluetooth Ses" "Bluetooth cihaz etkinleştirildi" -i audio-headphones
          fi
      }
      
      bluetooth_volume_control() {
          ACTION=$1
          BT_SINK=$(pactl list short sinks | grep -i "bluez" | head -n1 | cut -f2)
          
          if [ ! -z "$BT_SINK" ]; then
              case $ACTION in
                  "up") pactl set-sink-volume "$BT_SINK" +5% ;;
                  "down") pactl set-sink-volume "$BT_SINK" -5% ;;
                  "mute") pactl set-sink-mute "$BT_SINK" toggle ;;
              esac
              VOLUME=$(pactl get-sink-volume "$BT_SINK" | grep -oP '\d+%' | head -n1)
              notify-send "Bluetooth Ses" "Seviye: $VOLUME" -i audio-volume-high -t 1000
          else
              case $ACTION in
                  "up") wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ ;;
                  "down") wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- ;;
                  "mute") wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle ;;
              esac
          fi
      }
      
      case $1 in
          "fix") fix_bluetooth_audio ;;
          "volume") bluetooth_volume_control $2 ;;
          *) echo "Kullanım: $0 {fix|volume {up|down|mute}}" ;;
      esac
    '';
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
