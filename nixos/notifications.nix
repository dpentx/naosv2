# ~/.config/home-manager/modules/notifications.nix
{ config, pkgs, ... }:

{
  # Dunst bildirim yapılandırması
  services.dunst = {
    enable = true;
    settings = {
      global = {
        # Display
        monitor = 0;
        follow = "mouse";
        
        # Geometry
        width = 300;
        height = 300;
        origin = "top-right";
        offset = "30x50";
        scale = 0;
        notification_limit = 0;
        
        # Progress bar
        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;
        
        # Appearance
        transparency = 10;
        separator_height = 2;
        padding = 8;
        horizontal_padding = 8;
        text_icon_padding = 0;
        frame_width = 2;
        frame_color = "#ca9ee6";
        separator_color = "frame";
        sort = "yes";
        
        # Text
        font = "JetBrainsMono Nerd Font 11";
        line_height = 0;
        markup = "full";
        format = "<b>%s</b>\n%b";
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        ellipsize = "middle";
        ignore_newline = "no";
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = "yes";
        
        # Icons
        icon_position = "left";
        min_icon_size = 32;
        max_icon_size = 128;
        icon_path = "/usr/share/icons/Papirus/16x16/status/:/usr/share/icons/Papirus/16x16/devices/";
        
        # History
        sticky_history = "yes";
        history_length = 20;
        
        # Misc/Advanced
        dmenu = "${pkgs.wofi}/bin/wofi -p dunst";
        browser = "${pkgs.firefox}/bin/firefox";
        always_run_script = true;
        title = "Dunst";
        class = "Dunst";
        corner_radius = 10;
        ignore_dbusclose = false;
        
        # Legacy
        force_xinerama = false;
        
        # Mouse
        mouse_left_click = "close_current";
        mouse_middle_click = "do_action, close_current";
        mouse_right_click = "close_all";
      };
      
      experimental = {
        per_monitor_dpi = false;
      };
      
      urgency_low = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        timeout = 5;
        icon = "dialog-information";
      };
      
      urgency_normal = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        timeout = 10;
        icon = "dialog-information";
      };
      
      urgency_critical = {
        background = "#1e1e2e";
        foreground = "#f38ba8";
        frame_color = "#f38ba8";
        timeout = 0;
        icon = "dialog-warning";
      };
      
      # Custom rules
      play_sound = {
        summary = "*";
        script = "~/.config/dunst/sound.sh";
      };
    };
  };
  
  # Mako alternatif yapılandırması (isteğe bağlı)
  services.mako = {
    enable = false; # Dunst kullandığımız için kapalı
    settings = {
      background-color = "#1e1e2e";
      border-color = "#ca9ee6";
      border-radius = 10;
      border-size = 2;
      text-color = "#cdd6f4";
      font = "JetBrainsMono Nerd Font 11";
      width = 300;
      height = 150;
      margin = "10";
      padding = "15";
      default-timeout = 5000;
    };
  };
}
