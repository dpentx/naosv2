# ~/.config/home-manager/modules/shell.nix
{ config, pkgs, ... }:

{
  # Starship prompt yapılandırması
  programs.starship = {
    enable = true;
    settings = {
      format = "$username$hostname$directory$git_branch$git_status$cmd_duration$line_break$character";
      
      username = {
        style_user = "bold blue";
        style_root = "bold red";
        format = "[$user]($style) ";
        disabled = false;
        show_always = false;
      };
      
      hostname = {
        ssh_only = true;
        format = "[@$hostname](bold green) ";
        disabled = false;
      };
      
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        style = "bold cyan";
        format = "[$path]($style)[$read_only]($read_only_style) ";
        read_only = "🔒";
        read_only_style = "red";
      };
      
      git_branch = {
        symbol = " ";
        style = "bold purple";
        format = "[$symbol$branch]($style) ";
      };
      
      git_status = {
        style = "bold yellow";
        format = "[$all_status$ahead_behind]($style) ";
        conflicted = "=";
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        up_to_date = "";
        untracked = "?\${count}";
        stashed = "$\${count}";
        modified = "!\${count}";
        staged = "+\${count}";
        renamed = "»\${count}";
        deleted = "✘\${count}";
      };
      
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
        vimcmd_symbol = "[](bold green)";
      };
      
      cmd_duration = {
        min_time = 2000;
        format = " took [$duration](bold yellow)";
      };
      
      # Language specific
      nix_shell = {
        symbol = " ";
        format = "[$symbol$state( \\($name\\))]($style) ";
        style = "bold blue";
      };
      
      nodejs = {
        symbol = " ";
        style = "bold green";
      };
      
      python = {
        symbol = " ";
        style = "bold yellow";
      };
      
      rust = {
        symbol = " ";
        style = "bold red";
      };
      
      package = {
        symbol = " ";
        style = "bold cyan";
      };
    };
  };

  # Zsh yapılandırması
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    history = {
      size = 10000;
      save = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
      ignoreDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
    };
    
    shellAliases = {
      # Genel kısayollar
      ll = "ls -l";
      la = "ls -la";
      l = "ls -CF";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      
      # Git kısayolları
      g = "git";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      gs = "git status";
      gd = "git diff";
      gb = "git branch";
      gco = "git checkout";
      
      # NixOS kısayolları
      rebuild = "sudo nixos-rebuild switch";
      rebuild-test = "sudo nixos-rebuild test";
      hm-switch = "home-manager switch";
      hm-build = "home-manager build";
      
      # Sistem kısayolları
      grep = "grep --color=auto";
      fgrep = "fgrep --color=auto";
      egrep = "egrep --color=auto";
      cat = "bat";
      ls = "exa --icons";
      tree = "exa --tree";
      
      # Hyprland kısayolları
      hypr-log = "journalctl -f _COMM=Hyprland";
      waybar-restart = "killall waybar && waybar &";
      
      # Sistem bilgileri
      ports = "netstat -tulanp";
      meminfo = "free -m -l -t";
      psmem = "ps auxf | sort -nr -k 4";
      psmem10 = "ps auxf | sort -nr -k 4 | head -10";
      pscpu = "ps auxf | sort -nr -k 3";
      pscpu10 = "ps auxf | sort -nr -k 3 | head -10";
      
      # Paket yönetimi
      search = "nix search nixpkgs";
      shell = "nix-shell -p";
    };
    
    initContent = ''
      # Improved tab completion
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      
      # Case insensitive completion
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
      
      # Partial completion suggestions
      zstyle ':completion:*' list-suffixes
      zstyle ':completion:*' expand prefix suffix
      
      # Key bindings
      bindkey "^[[A" history-search-backward
      bindkey "^[[B" history-search-forward
      bindkey "^[[3~" delete-char
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
      
      # Custom functions
      function mkcd() {
        mkdir -p "$1" && cd "$1"
      }
      
      function extract() {
        if [ -f $1 ] ; then
          case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
          esac
        else
          echo "'$1' is not a valid file"
        fi
      }
      
      # Environment variables
      export EDITOR="nvim"
      export BROWSER="firefox"
      export TERMINAL="kitty"
      
      # Hyprland specific
      if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
        export MOZ_ENABLE_WAYLAND=1
        export QT_QPA_PLATFORM=wayland
        export SDL_VIDEODRIVER=wayland
        export _JAVA_AWT_WM_NONREPARENTING=1
      fi
      
      # Color support for less
      export LESS_TERMCAP_mb=$'\e[1;32m'
      export LESS_TERMCAP_md=$'\e[1;32m'
      export LESS_TERMCAP_me=$'\e[0m'
      export LESS_TERMCAP_se=$'\e[0m'
      export LESS_TERMCAP_so=$'\e[01;33m'
      export LESS_TERMCAP_ue=$'\e[0m'
      export LESS_TERMCAP_us=$'\e[1;4;31m'
    '';
  };

  # Bash backup yapılandırması (isteğe bağlı)
  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyControl = [ "ignoredups" "ignorespace" ];
    
    shellAliases = {
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
      ".." = "cd ..";
      rebuild = "sudo nixos-rebuild switch";
      hm-switch = "home-manager switch";
    };
  };
}
