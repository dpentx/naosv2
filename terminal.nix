# ~/.config/home-manager/modules/terminal.nix
{ config, pkgs, ... }:

{
  # Kitty terminal yapılandırması
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };
    settings = {
      background_opacity = "0.8";
      window_padding_width = 10;
      scrollback_lines = 10000;
      enable_audio_bell = false;
      
      # Catppuccin Mocha colors
      foreground = "#CDD6F4";
      background = "#1E1E2E";
      selection_foreground = "#1E1E2E";
      selection_background = "#F5E0DC";
      
      # Cursor colors
      cursor = "#F5E0DC";
      cursor_text_color = "#1E1E2E";
      
      # URL underline color when hovering with mouse
      url_color = "#F5E0DC";
      
      # Kitty window border colors
      active_border_color = "#B4BEFE";
      inactive_border_color = "#6C7086";
      bell_border_color = "#F9E2AF";
      
      # Tab colors
      active_tab_foreground = "#11111B";
      active_tab_background = "#CBA6F7";
      inactive_tab_foreground = "#CDD6F4";
      inactive_tab_background = "#181825";
      tab_bar_background = "#11111B";
      
      # Normal colors
      color0 = "#45475A";
      color1 = "#F38BA8";
      color2 = "#A6E3A1";
      color3 = "#F9E2AF";
      color4 = "#89B4FA";
      color5 = "#F5C2E7";
      color6 = "#94E2D5";
      color7 = "#BAC2DE";
      
      # Bright colors
      color8 = "#585B70";
      color9 = "#F38BA8";
      color10 = "#A6E3A1";
      color11 = "#F9E2AF";
      color12 = "#89B4FA";
      color13 = "#F5C2E7";
      color14 = "#94E2D5";
      color15 = "#A6ADC8";
    };
    keybindings = {
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
      "ctrl+shift+n" = "new_window";
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+w" = "close_window";
      "ctrl+shift+q" = "close_tab";
      "ctrl+shift+right" = "next_tab";
      "ctrl+shift+left" = "previous_tab";
      "ctrl+shift+plus" = "increase_font_size";
      "ctrl+shift+minus" = "decrease_font_size";
      "ctrl+shift+equal" = "reset_font_size";
    };
  };
}
