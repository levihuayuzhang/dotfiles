{ config, pkgs, ... }:

{
  home.username = "zhy";
  home.homeDirectory = "/home/zhy";

  # home.sessionVariables = {
  #   http_proxy = "http://127.0.0.1:7890";
  #   https_proxy = "http://127.0.0.1:7890";
  #   # all_proxy = "socks5h://127.0.0.1:7891";
  #
  #   HTTP_PROXY = "http://127.0.0.1:7890";
  #   HTTPS_PROXY = "http://127.0.0.1:7890";
  #   # ALL_PROXY = "socks5h://127.0.0.1:7891";
  # };

  home.sessionPath = [
    "$HOME/bin"
    "$HOME/.local/bin"
  ];

  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Huayu Zhang";
        email = "zhanghuayu.dev@gmail.com";
        signingkey = "71C9DEC83C653F60";
      };

      commit = {
        gpgsign = true;
      };

      tag = {
        gpgSign = true;
      };

      # gpg = {
      #   format = "openpgp";
      # };

      init = {
        defaultBranch = "main";
      };
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;

    options = {
      navigate = true;
      side-by-side = true;
      line-numbers = true;
    };
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo I use nixos, btw";
    };
  };

  programs.zsh = {
    enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "sudo"
        "docker"
      ];
    };

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initContent = ''
      export GPG_TTY=$(tty)

      export PATH="$HOME/.local/share/fnm:$PATH"
      eval "$(fnm env --use-on-cd --shell zsh)"
    '';
    envExtra = ''
      . "$HOME/.cargo/env"
    '';
    shellAliases = {
      l = "eza -la --icons always";
      ls = "eza --icons always";
      ll = "eza -l --icons always";
      la = "eza -a --icons always";
      grep = "grep --color=auto";
      nfu = "nix flake update --flake /home/zhy/projects/dotfiles/nixos/etc/nixos";
      nrs = "sudo nixos-rebuild switch --flake /home/zhy/projects/dotfiles/nixos/etc/nixos#levi-pc";
      nos = "nh os switch /home/zhy/projects/dotfiles/nixos/etc/nixos";
      # system-upgrade = "nix flake update --flake /home/zhy/projects/dotfiles/nixos/etc/nixos && sudo nixos-rebuild switch --flake /home/zhy/projects/dotfiles/nixos/etc/nixos#levi-pc";
      system-upgrade = "nh os switch /home/zhy/projects/dotfiles/nixos/etc/nixos -u";
    };
  };

  programs.fish = {
    enable = true;

    shellInit = "
      set -gx GPG_TTY (tty)

      set -gx RUSTUP_DIST_SERVER https://mirrors.tuna.tsinghua.edu.cn/rustup
      set -gx RUSTUP_UPDATE_ROOT https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup
      set -gx RUST_BACKTRACE full
      set -gx RUSTC_WRAPPER sccache
      # set -gx SCCACHE_SERVER_UDS $HOME/sccache.sock
    ";

    interactiveShellInit = "
      set fish_greeting
      set fish_color_command green --bold
    ";

    shellAbbrs = {
      c = "cargo";
      ct = "cargo t";
      e = "nvim";
      m = "make";
      o = "xdg-open";
      g = "git";

      gc = "git checkout";
      ga = "git add -p";
      gaa = "git add --all";
      gdca = "git diff --cached";
      gcss = "git commit --gpg-sign --signoff";
      gp = "git push";

      vimdiff = "nvim -d";

      l = "eza -la --icons always";
      ls = "eza --icons always";
      ll = "eza -l --icons always";
      la = "eza -a --icons always";
      grep = "grep --color=auto";

      nfu = "nix flake update --flake /home/zhy/projects/dotfiles/nixos/etc/nixos";
      nrs = "sudo nixos-rebuild switch --flake /home/zhy/projects/dotfiles/nixos/etc/nixos#levi-pc";
      nos = "nh os switch /home/zhy/projects/dotfiles/nixos/etc/nixos";
      # system-upgrade = "nix flake update --flake /home/zhy/projects/dotfiles/nixos/etc/nixos && sudo nixos-rebuild switch --flake /home/zhy/projects/dotfiles/nixos/etc/nixos#levi-pc";
      system-upgrade = "nh os switch /home/zhy/projects/dotfiles/nixos/etc/nixos -u";
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;

    settings = {
      add_newline = false;

      os = {
        disabled = false;

        symbols = {
          Macos = " ";
          Arch = " ";
          NixOS = " ";
          Debian = " ";
          Linux = " ";
        };
      };
    };
  };

  dconf = {
    enable = true;

    settings = {
      # "org/gnome/desktop/interface" = {
      #   color-scheme = "prefer-dark";
      # };

      "org/gnome/desktop/wm/preferences" = {
        button-layout = "menu:";
      };
    };

  };

  home.packages = with pkgs; [
    adwaita-icon-theme
    papirus-icon-theme
    gnome-themes-extra
  ];

  gtk = {
    enable = true;

    # theme = {
    #   name = "Adwaita-dark";
    #   package = pkgs.gnome-themes-extra;
    # };

    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };

    # cursorTheme = {
    #   name = "Adwaita";
    #   # size = 24;
    # };

    # font = {
    #   name = "Noto Sans";
    #   # size = 10;
    # };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      # gtk-sound-theme-name = "freedesktop";
      # gtk-cursor-blink = true;
      # gtk-cursor-blink-time = 1000;
      # gtk-button-images = true;
      # # gtk-decoration-layout = "icon:minimize,maximize,close";
      # gtk-decoration-layout = ":";
      # gtk-enable-animations = true;
      # gtk-menu-images = true;
      # gtk-primary-button-warps-slider = true;
      # gtk-toolbar-style = 3;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  # # noctalia config export > ~/projects/dotfiles/noctalia/.config/noctalia/config.toml
  # programs.noctalia = {
  #   enable = true;
  #   settings = ../../../noctalia/.config/noctalia/config.toml;
  # };
  programs.noctalia = {
    enable = true;
    settings = {
      backdrop = {
        enabled = true;
      };

      bar.default = {
        background_opacity = 0.0;
        capsule = true;
        margin_ends = 0;
        shadow = false;

        start = [
          "NixOS"
          "workspaces"
          "active_window"
        ];

        end = [
          "audio_visualizer"
          "media"
          "tray"
          "group:g1"
          "weather"
          "network"
          "bluetooth"
          "volume"
          "brightness"
          "battery"
          "clipboard"
          "notifications"
          "control-center"
          "session"
        ];

        capsule_group = [
          {
            accordion = false;
            accordion_direction = "end";
            enabled = true;
            fill = "surface_variant";
            id = "g1";

            members = [
              "network_rx"
              "network_tx"
              "cpu"
              "ram"
              "temp"
            ];

            opacity = 1.0;
            padding = 6.0;
          }
        ];
      };

      idle = {
        behavior_order = [
          "lock"
          "screen-off"
          "lock-and-suspend"
        ];

        pre_action_fade_seconds = 0;

        behavior.lock = {
          action = "lock";
          enabled = true;
          timeout = 600.0;
        };

        behavior.screen-off = {
          action = "screen_off";
          enabled = true;
          timeout = 660.0;
        };

        behavior.lock-and-suspend = {
          action = "lock_and_suspend";
          enabled = true;
          timeout = 900.0;
        };
      };

      location = {
        address = "Haikou, China";
      };

      lockscreen = {
        fingerprint = false;
        wallpaper = "/home/zhy/wallpapers/mrx.png";
      };

      shell = {
        launch_apps_as_systemd_services = true;
        niri_overview_type_to_launch_enabled = true;
        polkit_agent = true;
      };

      system.monitor = {
        network_poll_seconds = 2;
      };

      theme = {
        mode = "dark";
        source = "wallpaper";
        wallpaper_scheme = "m3-content";

        templates = {
          builtin_ids = [
            "gtk3"
            "gtk4"
            "kcolorscheme"
            "niri"
            "qt"
          ];
        };
      };

      wallpaper = {
        directory = "/home/zhy/wallpapers";
        transition_on_startup = true;

        automation = {
          enabled = true;
          interval_seconds = 600;
        };

        default = {
          path = "/home/zhy/wallpapers/mrx.png";
        };

        monitors.HDMI-A-1 = {
          path = "/home/zhy/wallpapers/mrx.png";
        };

        favorite = [
          {
            path = "/home/zhy/wallpapers/mrx-swim.png";
            palette_source = "wallpaper";
            theme_mode = "dark";
            wallpaper_scheme = "m3-content";
          }

          {
            path = "/home/zhy/wallpapers/mrx.png";
            palette_source = "wallpaper";
            theme_mode = "dark";
            wallpaper_scheme = "m3-content";
          }

          {
            path = "/home/zhy/wallpapers/dac40c_5_Morning2_8k.jpg";
            palette_source = "wallpaper";
            theme_mode = "dark";
            wallpaper_scheme = "m3-content";
          }

          {
            path = "/home/zhy/wallpapers/2.jpg";
            palette_source = "wallpaper";
            theme_mode = "dark";
            wallpaper_scheme = "m3-content";
          }

          {
            path = "/home/zhy/wallpapers/7a7da0_Sunset_8k.jpg";
            palette_source = "wallpaper";
            theme_mode = "dark";
            wallpaper_scheme = "m3-content";
          }

          {
            path = "/home/zhy/wallpapers/498ca7_26_reading_8k.jpg";
            palette_source = "wallpaper";
            theme_mode = "dark";
            wallpaper_scheme = "m3-content";
          }

          {
            path = "/home/zhy/wallpapers/15157c_sin2_8k_wallpaper.jpg";
            palette_source = "wallpaper";
            theme_mode = "dark";
            wallpaper_scheme = "m3-content";
          }

          {
            path = "/home/zhy/wallpapers/20211126_173703000_iOS.jpg";
            palette_source = "wallpaper";
            theme_mode = "dark";
            wallpaper_scheme = "m3-content";
          }

          {
            path = "/home/zhy/wallpapers/20140319_224404000_iOS.jpg";
            palette_source = "wallpaper";
            theme_mode = "dark";
            wallpaper_scheme = "m3-content";
          }

          {
            path = "/home/zhy/wallpapers/b-250.jpg";
            palette_source = "wallpaper";
            theme_mode = "dark";
            wallpaper_scheme = "m3-content";
          }
        ];
      };

      widget.NixOS = {
        label = "";
        tooltip = "NixOS";
        type = "custom_button";
      };

      widget.clock = {
        format = "{:%Y-%m-%d %a %H:%M:%S}";
      };

      widget.control-center = {
        enabled = false;
      };

      widget.launcher = {
        enabled = false;
      };

      widget.media = {
        album_art_only = true;
        enabled = false;
      };

      widget.session = {
        enabled = false;
      };

      widget.wallpaper = {
        enabled = false;
      };

      widget.weather = {
        show_condition = false;
      };
    };
  };

  # edit files under dotfiles directory, then rebuild
  # do not edit the files under ~/.config
  xdg = {
    configFile = {
      # "kdeglobals".text = ''
      #   [General]
      #   ColorScheme=BreezeDark
      #
      #   [KDE]
      #   LookAndFeelPackage=org.kde.breezedark.desktop
      # '';

      "tmux/tmux.conf".source = ../../../tmux/.config/tmux/tmux.conf;
      "bat/config".source = ../../../bat/.config/bat/config;
      # "mimeapps.list".source = ../../../xdg/.config/mimeapps.list;

      # "fish" = {
      #   source = ../../../fish/.config/fish;
      #   recursive = true;
      # };

      "nvim" = {
        source = ../../../nvim/.config/nvim;
        recursive = true;
      };

      "alacritty" = {
        source = ../../../alacritty/.config/alacritty;
        recursive = true;
      };

      "niri" = {
        source = ../../../niri/.config/niri;
        recursive = true;
      };

      "waybar" = {
        source = ../../../waybar/.config/waybar;
        recursive = true;
      };

      "fuzzel" = {
        source = ../../../fuzzel/.config/fuzzel;
        recursive = true;
      };

      "mpv" = {
        source = ../../../mpv/.config/mpv;
        recursive = true;
      };

      "sioyek" = {
        source = ../../../sioyek/.config/sioyek;
        recursive = true;
      };
    };

    # desktopEntries = {
    #   sioyek = {
    #     name = "Sioyek";
    #     comment = "PDF viewer";
    #     exec = "env QT_QPA_PLATFORM=xcb sioyek %f";
    #     icon = "sioyek";
    #     terminal = false;
    #     type = "Application";
    #     categories = [
    #       "Office"
    #       "Viewer"
    #     ];
    #     mimeType = [
    #       "application/pdf"
    #     ];
    #   };
    # };

    mimeApps = {
      enable = true;
      defaultApplications = {
        # "inode/directory" = [ "org.kde.dolphin.desktop" ];
        # "application/x-gnome-saved-search" = [ "org.kde.dolphin.desktop" ];
        "inode/directory" = [ "com.system76.CosmicFiles.desktop" ];
        "application/x-gnome-saved-search" = [ "com.system76.CosmicFiles.desktop" ];

        "video/mp4" = [ "mpv.desktop" ];
        "video/matroska" = [ "mpv.desktop" ];
        "video/x-matroska" = [ "mpv.desktop" ];
        "video/mkv" = [ "mpv.desktop" ];
        "video/webm" = [ "mpv.desktop" ];
        "video/x-msvideo" = [ "mpv.desktop" ];
        "video/avi" = [ "mpv.desktop" ];
        "video/x-avi" = [ "mpv.desktop" ];
        "video/mpeg" = [ "mpv.desktop" ];
        "video/x-mpeg2" = [ "mpv.desktop" ];
        "video/x-mpeg3" = [ "mpv.desktop" ];
        "video/mp4v-es" = [ "mpv.desktop" ];
        "video/x-m4v" = [ "mpv.desktop" ];
        "video/divx" = [ "mpv.desktop" ];
        "video/vnd.divx" = [ "mpv.desktop" ];
        "video/msvideo" = [ "mpv.desktop" ];
        "video/ogg" = [ "mpv.desktop" ];
        "video/quicktime" = [ "mpv.desktop" ];
        "video/vnd.rn-realvideo" = [ "mpv.desktop" ];
        "video/x-ms-afs" = [ "mpv.desktop" ];
        "video/x-ms-asf" = [ "mpv.desktop" ];
        "video/x-ms-wmv" = [ "mpv.desktop" ];
        "video/x-ms-wmx" = [ "mpv.desktop" ];
        "video/x-ms-wvxvideo" = [ "mpv.desktop" ];
        "video/x-flic" = [ "mpv.desktop" ];
        "video/fli" = [ "mpv.desktop" ];
        "video/x-flc" = [ "mpv.desktop" ];
        "video/flv" = [ "mpv.desktop" ];
        "video/x-flv" = [ "mpv.desktop" ];
        "video/x-theora" = [ "mpv.desktop" ];
        "video/x-theora+ogg" = [ "mpv.desktop" ];
        "video/mp2t" = [ "mpv.desktop" ];
        "video/vnd.mpegurl" = [ "mpv.desktop" ];
        "video/3gp" = [ "mpv.desktop" ];
        "video/3gpp" = [ "mpv.desktop" ];
        "video/3gpp2" = [ "mpv.desktop" ];
        "video/dv" = [ "mpv.desktop" ];
        "video/vnd.avi" = [ "mpv.desktop" ];
        "video/x-ogm+ogg" = [ "mpv.desktop" ];
        "video/x-ogm" = [ "mpv.desktop" ];

        "audio/x-vorbis+ogg" = [ "mpv.desktop" ];
        "audio/aac" = [ "mpv.desktop" ];
        "audio/x-aac" = [ "mpv.desktop" ];
        "audio/vnd.dolby.heaac.1" = [ "mpv.desktop" ];
        "audio/vnd.dolby.heaac.2" = [ "mpv.desktop" ];
        "audio/aiff" = [ "mpv.desktop" ];
        "audio/x-aiff" = [ "mpv.desktop" ];
        "audio/m4a" = [ "mpv.desktop" ];
        "audio/x-m4a" = [ "mpv.desktop" ];
        "audio/mp1" = [ "mpv.desktop" ];
        "audio/x-mp1" = [ "mpv.desktop" ];
        "audio/mp2" = [ "mpv.desktop" ];
        "audio/x-mp2" = [ "mpv.desktop" ];
        "audio/mp3" = [ "mpv.desktop" ];
        "audio/x-mp3" = [ "mpv.desktop" ];
        "audio/mpeg" = [ "mpv.desktop" ];
        "audio/mpeg2" = [ "mpv.desktop" ];
        "audio/mpeg3" = [ "mpv.desktop" ];
        "audio/mpegurl" = [ "mpv.desktop" ];
        "audio/x-mpegurl" = [ "mpv.desktop" ];
        "audio/mpg" = [ "mpv.desktop" ];
        "audio/x-mpg" = [ "mpv.desktop" ];
        "audio/rn-mpeg" = [ "mpv.desktop" ];
        "audio/musepack" = [ "mpv.desktop" ];
        "audio/x-musepack" = [ "mpv.desktop" ];
        "audio/ogg" = [ "mpv.desktop" ];
        "audio/scpls" = [ "mpv.desktop" ];
        "audio/x-scpls" = [ "mpv.desktop" ];
        "audio/vnd.rn-realaudio" = [ "mpv.desktop" ];
        "audio/wav" = [ "mpv.desktop" ];
        "audio/x-pn-wav" = [ "mpv.desktop" ];
        "audio/x-pn-windows-pcm" = [ "mpv.desktop" ];
        "audio/x-realaudio" = [ "mpv.desktop" ];
        "audio/x-pn-realaudio" = [ "mpv.desktop" ];
        "audio/x-ms-wma" = [ "mpv.desktop" ];
        "audio/x-pls" = [ "mpv.desktop" ];
        "audio/x-wav" = [ "mpv.desktop" ];
        "audio/x-ms-asf" = [ "mpv.desktop" ];
        "audio/x-matroska" = [ "mpv.desktop" ];
        "audio/webm" = [ "mpv.desktop" ];
        "audio/vorbis" = [ "mpv.desktop" ];
        "audio/x-vorbis" = [ "mpv.desktop" ];
        "audio/x-shorten" = [ "mpv.desktop" ];
        "audio/x-ape" = [ "mpv.desktop" ];
        "audio/x-wavpack" = [ "mpv.desktop" ];
        "audio/x-tta" = [ "mpv.desktop" ];
        "audio/AMR" = [ "mpv.desktop" ];
        "audio/ac3" = [ "mpv.desktop" ];
        "audio/eac3" = [ "mpv.desktop" ];
        "audio/amr-wb" = [ "mpv.desktop" ];
        "audio/flac" = [ "mpv.desktop" ];
        "audio/mp4" = [ "mpv.desktop" ];
        "audio/x-pn-au" = [ "mpv.desktop" ];
        "audio/3gpp" = [ "mpv.desktop" ];
        "audio/3gpp2" = [ "mpv.desktop" ];
        "audio/dv" = [ "mpv.desktop" ];
        "audio/opus" = [ "mpv.desktop" ];
        "audio/vnd.dts" = [ "mpv.desktop" ];
        "audio/vnd.dts.hd" = [ "mpv.desktop" ];
        "audio/x-adpcm" = [ "mpv.desktop" ];
        "audio/m3u" = [ "mpv.desktop" ];
        "audio/vnd.wave" = [ "mpv.desktop" ];

        "image/jpeg" = [ "org.kde.gwenview.desktop" ];
        "image/avif" = [ "org.kde.gwenview.desktop" ];
        "image/gif" = [ "org.kde.gwenview.desktop" ];
        "image/heif" = [ "org.kde.gwenview.desktop" ];
        "image/jxl" = [ "org.kde.gwenview.desktop" ];
        "image/png" = [ "org.kde.gwenview.desktop" ];
        "image/bmp" = [ "org.kde.gwenview.desktop" ];
        "image/x-eps" = [ "org.kde.gwenview.desktop" ];
        "image/x-icns" = [ "org.kde.gwenview.desktop" ];
        "image/x-ico" = [ "org.kde.gwenview.desktop" ];
        "image/x-portable-bitmap" = [ "org.kde.gwenview.desktop" ];
        "image/x-portable-graymap" = [ "org.kde.gwenview.desktop" ];
        "image/x-portable-pixmap" = [ "org.kde.gwenview.desktop" ];
        "image/x-xbitmap" = [ "org.kde.gwenview.desktop" ];
        "image/x-xpixmap" = [ "org.kde.gwenview.desktop" ];
        "image/tiff" = [ "org.kde.gwenview.desktop" ];
        "image/x-psd" = [ "org.kde.gwenview.desktop" ];
        "image/x-webp" = [ "org.kde.gwenview.desktop" ];
        "image/webp" = [ "org.kde.gwenview.desktop" ];
        "image/x-tga" = [ "org.kde.gwenview.desktop" ];
        "image/x-xcf" = [ "org.kde.gwenview.desktop" ];
        "image/openraster" = [ "org.kde.gwenview.desktop" ];
        "image/svg+xml" = [ "org.kde.gwenview.desktop" ];
        "image/svg+xml-compressed" = [ "org.kde.gwenview.desktop" ];

        "text/plain" = [ "code.desktop" ];
        "application/pdf" = [ "sioyek.desktop" ];

        "x-scheme-handler/http" = [ "firefox-devedition.desktop" ];
        "x-scheme-handler/https" = [ "firefox-devedition.desktop" ];
        "application/xhtml+xml" = [ "firefox-devedition.desktop" ];
        "text/html" = [ "firefox-devedition.desktop" ];
      };
    };
  };

  home.stateVersion = "26.05";
}
