# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix # Include the results of the hardware scan.

    inputs.noctalia.nixosModules.default
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = pkgs.linuxPackages;

  boot.kernelModules = [ "ntsync" ];

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true; # https://wiki.nixos.org/wiki/AMD_GPU
  services.xserver.videoDrivers = [
    "nvidia"
  ];
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    # dynamicBoost.enable = true;
    powerManagement = {
      enable = true;
      # finegrained = true;
      kernelSuspendNotifier = true;
    };

    # # https://wiki.nixos.org/wiki/NVIDIA#Hybrid_graphics_with_PRIME
    # prime = {
    #   offload.enable = true;
    #   offload.enableOffloadCmd = true;
    #
    #   amdgpuBusId = "PCI:5@0:0:0";
    #   nvidiaBusId = "PCI:1@0:0:0";
    # };
  };
  # https://wiki.nixos.org/wiki/Docker#NVIDIA_Docker_Containers
  hardware.nvidia-container-toolkit = {
    enable = true;
  };
  virtualisation.docker.daemon.settings.features.cdi = true;

  # https://github.com/NixOS/nixpkgs/issues/562776#issuecomment-5662138287
  # nixpkgs.overlays = [
  #   (final: prev: {
  #     cudaPackages = prev.lib.recurseIntoAttrs prev.cudaPackages_13_4;
  #   })
  # ];
  nixpkgs.overlays = [
    (final: prev: {
      cudaPackages = prev.lib.recurseIntoAttrs (
        prev.cudaPackages_13_4
        // {
          nsight_systems = prev.cudaPackages_13_4.nsight_systems.overrideAttrs (old: {
            buildInputs = builtins.map (
              x: if (x.pname or null) == "boost" then prev.boost186 else x
            ) old.buildInputs;
          });
        }
      );
    })
  ];

  nixpkgs.config.allowUnfree = true;
  # nixpkgs.config.cudaSupport = true;

  # hardware.enableAllFirmware = true;
  # hardware.firmware = [
  #   pkgs.sof-firmware
  # ];

  networking.hostName = "levi-pc"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.wireless.enable = true;
  networking.networkmanager.enable = true;

  programs.zsh.enable = true;
  programs.fish = {
    enable = true;
  };
  users.users.zhy = {
    isNormalUser = true;
    # shell = pkgs.zsh;
    shell = pkgs.fish;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "docker"
      "vboxusers"
      "libvirtd"
    ];

    packages = with pkgs; [
      tree
    ];
  };

  # stylix = {
  #   enable = true;
  #   polarity = "dark";
  #   # image = /home/zhy/wallpapers/mrx-swim.png;
  #   # base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
  #   base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  # };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  # programs.vscode = {
  #   enable = true;
  #   # package = pkgs.vscode-fhs;
  # };
  services.gnome.gnome-keyring.enable = true;

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep-since 6d --keep 3";
    };
    flake = "/home/zhy/projects/dotfiles/nixos/etc/nixos"; # sets NH_OS_FLAKE
  };

  # nix.gc = {
  #   automatic = true;
  #   dates = "weekly";
  #   options = "--delete-older-than 30d";
  # };
  # boot.loader.systemd-boot.configurationLimit = 10;

  programs.steam = {
    enable = true;
    gamescopeSession = {
      enable = true;
      args = [
        "-W"
        "3840"
        "-H"
        "2160"
        "-r"
        "60"
        # "--adaptive-sync"
        # "--hdr-enabled"
        "--steam"
        "--expose-wayland"
      ];
      # env = {
      #   # for Prime render offload, Also requires `hardware.nvidia.prime.offload.enable`
      #   __NV_PRIME_RENDER_OFFLOAD = "1";
      #   __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
      #   __VK_LAYER_NV_optimus = "NVIDIA_only";
      #   __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      # };
    };
    protontricks.enable = true;
    extest.enable = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    remotePlay.openFirewall = true;
  };
  programs.gamescope = {
    enable = true;
    enableWsi = true;
    capSysNice = true;
    # env = {
    #   # for Prime render offload, Also requires `hardware.nvidia.prime.offload.enable`
    #   __NV_PRIME_RENDER_OFFLOAD = "1";
    #   __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
    #   __VK_LAYER_NV_optimus = "NVIDIA_only";
    #   __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    # };
  };
  programs.gamemode.enable = true;

  # programs.obs-studio = {
  #   enable = true;
  #   package = (pkgs.obs-studio.override { cudaSupport = true; });
  #   enableVirtualCamera = true;
  #   plugins = with pkgs.obs-studio-plugins; [
  #     wlrobs
  #     obs-backgroundremoval
  #     obs-pipewire-audio-capture
  #     obs-vkcapture
  #   ];
  # };

  programs.java.enable = true;

  programs.htop = {
    enable = true;
    settings = {
      # color_scheme = 6; # dark
      show_cpu_frequency = true;
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
      xdg-desktop-portal-cosmic
    ];
    config = {
      common = {
        default = [
          "gtk"
        ];
      };
    };
  };

  fileSystems."/home/zhy/hdd" = {
    device = "/dev/disk/by-uuid/34B5-8CB0";
    fsType = "exfat";
    options = [
      "uid=1000"
      "gid=100"
      "user"
      "nofail"
    ];
  };

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # nix.settings.substituters = lib.mkForce [ "https://mirror.sjtu.edu.cn/nix-channels/store" ];
  nix.settings = {
    substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      # "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://cache.nixos-cuda.org" # https://wiki.nixos.org/wiki/CUDA#Setting_up_CUDA_Binary_Cache
      "https://nix-community.cachix.org" # https://wiki.nixos.org/wiki/Binary_Cache#Using_a_binary_cache
    ];
    trusted-public-keys = [
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    extra-substituters = [ "https://noctalia.cachix.org" ]; # https://docs.noctalia.dev/noctalia/getting-started/nixos/?section=binary-cache#binary-cache
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  services.mihomo = {
    enable = true;
    tunMode = true;
    processesInfo = true;
    configFile = "/home/zhy/proxy/config.yaml";
    # extraOpts = "-d /var/lib/private/mihomo";
    webui = pkgs.zashboard;
  };

  # networking.proxy.default = "http://user:password@proxy:port/"; # the default value for httpProxy, httpsProxy, ftpProxy and rsyncProxy.
  networking.proxy.default = "http://127.0.0.1:7890";
  # networking.proxy.httpProxy = "http://127.0.0.1:7890";
  # networking.proxy.httpsProxy = "http://127.0.0.1:7890";
  # networking.proxy.allProxy = "socks5h://127.0.0.1:7891";
  networking.proxy.noProxy = "127.0.0.1,::1,localhost";

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    nssmdns6 = true;
    # nssmdnsFull = true;
  };

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    # font = "Lat2-Terminus16";
    keyMap = "us";
    # useXkbConfig = true; # use xkb.options in tty.
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    fcitx5 = {
      waylandFrontend = true;

      addons = with pkgs; [
        fcitx5-rime
        fcitx5-gtk
        qt6Packages.fcitx5-qt
        qt6Packages.fcitx5-configtool
        qt6Packages.fcitx5-chinese-addons
        # fcitx5-nord
        # fcitx5-material-color
      ];
    };
  };

  security.polkit.enable = true;
  systemd.user.services.polkit-gnome-agent = {
    description = "Polkit Authentication Agent";
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
    };
  };

  security.rtkit.enable = true;
  # services.pulseaudio.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # services.displayManager.defaultSession = "niri";
  # services.displayManager.sddm.enable = true;
  # services.desktopManager.plasma6.enable = true;
  services.desktopManager.gnome.enable = true;

  # services.displayManager.cosmic-greeter.enable = true;
  services.displayManager.noctalia-greeter = {
    enable = true;
    settings = {
      cursor.size = 24;
      keyboard.layout = "us";
    };
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
    };
  };

  programs.niri = {
    enable = true;
    useNautilus = true;
  };
  # programs.waybar.enable = true;
  # security.pam.services.swaylock = { }; # https://wiki.nixos.org/wiki/Niri#Additional_Setup

  # https://docs.noctalia.dev/noctalia/getting-started/nixos/
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  programs.noctalia = {
    enable = true;

    # Enables NetworkManager, Bluetooth, UPower, and a power profile service.
    recommendedServices.enable = true;
    systemd.enable = true;
  };

  # qt = {
  #   enable = true;
  #   platformTheme = "qt5ct";
  #   # style = "breeze";
  # };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";

    # GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    SDL_IM_MODULE = "fcitx";
    GLFW_IM_MODULE = "fcitx";
    IMSETTINGS_MODULE = "fcitx";
    INPUT_METHOD = "fcitx";

    GDK_BACKEND = "wayland,x11,*";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_ENABLE_HIGHDPI_SCALING = "1";
    SDL_VIDEODRIVER = "wayland,x11";
    CLUTTER_BACKEND = "wayland";
  };

  services.udisks2.enable = true;
  services.gvfs.enable = true;

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  services.xserver = {
    enable = true;
    autoRepeatDelay = 200;
    autoRepeatInterval = 35;
  };

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # programs.firefox.enable = true;

  # services.ollama = {
  #   enable = true;
  #   package = pkgs.ollama-cuda;
  # };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    nix-direnv.enable = true;
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      gcc
      zlib
      openssl
      curl
    ];
  };

  services.flatpak.enable = true;
  services.linyaps.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    vim
    nano
    vscode-fhs

    git
    wget
    curl
    stow

    rustup
    rustc
    cargo
    sccache

    tmux
    nil
    nixd
    nixfmt
    tree-sitter
    shfmt
    prettier
    stylua
    tex-fmt
    fzf
    bat
    delta
    ripgrep
    fd

    python3
    python314
    python314Packages.pip
    uv
    ruff
    ty

    gnumake
    cmake
    ninja
    pkg-config
    gcc
    clang
    clang-tools
    llvm
    lld
    mold
    openssl
    # qemu_full
    docker-compose

    cudaPackages.cudatoolkit
    # cudaPackages.cuda_nvcc
    # cudaPackages.cuda_cudart
    # cudaPackages.cuda_gdb
    # cudaPackages.cuda_cuobjdump
    # cudaPackages.cuda-samples
    cudaPackages.cutlass
    # cudaPackages.cudnn
    # cudaPackages.libcurand
    # cudaPackages.libcublas
    # cudaPackages.libcufft
    # cudaPackages.libnvvm
    # cudaPackages.tensorrt
    # cudaPackages.cccl
    # cudaPackages.nccl
    # cudaPackages.cuda_opencl
    cudaPackages.nsight_compute
    cudaPackages.nsight_systems

    # inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    awww
    eza
    lolcat
    fastfetch
    wl-clipboard
    # swayidle
    # swaylock
    # mako
    # fuzzel
    xwayland-satellite
    glib
    gsettings-desktop-schemas
    adwaita-icon-theme
    papirus-icon-theme
    adwaita-qt
    adwaita-qt6
    exfatprogs
    pulseaudio
    mangohud
    lm_sensors
    texliveFull
    nvtopPackages.full
    htop
    btop
    mesa-demos
    usbutils

    alacritty
    firefox-devedition
    nautilus
    cosmic-files
    cosmic-monitor
    kdePackages.okular
    kdePackages.gwenview
    kdePackages.kdeconnect-kde
    kdePackages.breeze
    kdePackages.breeze-icons
    kdePackages.qt6ct
    libsForQt5.qt5ct
    sioyek
    mpv
    prismlauncher
    hmcl
    rpi-imager
    polkit_gnome
    # (blender.override {
    #   config.cudaSupport = true;
    #   config.rocmSupport = false;
    # })
    libxcb
    xwayland

    wechat
    qq
    wemeet
    feishu
    wpsoffice-cn
    qqmusic
    spotify

    wineWow64Packages.staging
    winetricks
    lutris
    bottles
    protonup-qt
    fuse
    fuse3
    appimage-run
    vulkan-tools
    distrobox
  ];

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  # virtualisation.podman = {
  #   enable = true;
  #   dockerCompat = true;
  # };
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };
  virtualisation.virtualbox.host = {
    enable = true;
    # enableKvm = true;
    enableExtensionPack = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  fonts.packages = with pkgs; [
    nerd-fonts.caskaydia-cove
    nerd-fonts.jetbrains-mono

    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    source-han-sans
    source-han-serif
    wqy_zenhei
    wqy_microhei
    corefonts
    vista-fonts
    liberation_ttf
    dejavu_fonts
    sarasa-gothic
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}
