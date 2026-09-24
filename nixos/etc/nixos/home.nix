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
      system-upgrade = "nix flake update --flake /home/zhy/projects/dotfiles/nixos/etc/nixos && nh os switch /home/zhy/projects/dotfiles/nixos/etc/nixos";
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
      system-upgrade = "nix flake update --flake /home/zhy/projects/dotfiles/nixos/etc/nixos && nh os switch /home/zhy/projects/dotfiles/nixos/etc/nixos";
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
  xdg.configFile = {
    # "kdeglobals".text = ''
    #   [General]
    #   ColorScheme=BreezeDark
    #
    #   [KDE]
    #   LookAndFeelPackage=org.kde.breezedark.desktop
    # '';

    "tmux/tmux.conf".source = ../../../tmux/.config/tmux/tmux.conf;
    "bat/config".source = ../../../bat/.config/bat/config;
    "mimeapps.list".source = ../../../xdg/.config/mimeapps.list;

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

  # xdg.desktopEntries.sioyek = {
  #   name = "Sioyek";
  #   comment = "PDF viewer";
  #   exec = "env QT_QPA_PLATFORM=xcb sioyek %f";
  #   icon = "sioyek";
  #   terminal = false;
  #   type = "Application";
  #   categories = [
  #     "Office"
  #     "Viewer"
  #   ];
  #   mimeType = [
  #     "application/pdf"
  #   ];
  # };

  home.stateVersion = "26.05";
}
