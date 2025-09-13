# ~/.config/home-manager/modules/launcher.nix
{ config, pkgs, ... }:

{
  # Wofi (launcher) yapılandırması
  programs.wofi = {
    enable = true;
    settings = {
      width = 600;
      height = 300;
      location = "center";
      show = "drun";
      prompt = "Search...";
      filter_rate = 100;
      allow_markup = true;
      no_actions = true;
      halign = "fill";
      orientation = "vertical";
      content_halign = "fill";
      insensitive = true;
      allow_images = true;
      image_size = 40;
      gtk_dark = true;
    };
    
    style = ''
      window {
        margin: 0px;
        border: 2px solid #ca9ee6;
        background-color: rgba(30, 30, 46, 0.9);
        border-radius: 15px;
        font-family: "JetBrainsMono Nerd Font";
        font-size: 14px;
      }
      
      #input {
        margin: 5px;
        border: none;
        color: #cdd6f4;
        background-color: rgba(49, 50, 68, 0.8);
        border-radius: 10px;
        padding: 10px;
      }
      
      #inner-box {
        margin: 5px;
        border: none;
        background-color: transparent;
      }
      
      #outer-box {
        margin: 5px;
        border: none;
        background-color: transparent;
      }
      
      #scroll {
        margin: 0px;
        border: none;
      }
      
      #text {
        margin: 5px;
        border: none;
        color: #cdd6f4;
      }
      
      #entry {
        padding: 5px;
        border-radius: 8px;
      }
      
      #entry:selected {
        background-color: rgba(202, 158, 230, 0.2);
      }
      
      #text:selected {
        color: #ca9ee6;
      }
    '';
  };
  
  # Rofi alternatif yapılandırması (isteğe bağlı)
  programs.rofi = {
    enable = false; # Wofi kullandığımız için kapalı
    package = pkgs.rofi-wayland;
    theme = {
      "*" = {
        bg-col = "#1e1e2e";
        bg-col-light = "#1e1e2e";
        border-col = "#ca9ee6";
        selected-col = "#313244";
        blue = "#89b4fa";
        fg-col = "#cdd6f4";
        fg-col2 = "#f38ba8";
        grey = "#6c7086";
        width = 600;
      };
    };
  };
}
