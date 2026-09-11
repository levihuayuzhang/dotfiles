# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = pkgs.linuxPackages;

  boot.kernelModules = [ "ntsync" ];

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    # dynamicBoost.enable = true;
    powerManagement.enable = true;
  };
  hardware.nvidia-container-toolkit = {
    enable = true;
  };

  nixpkgs.config.allowUnfree = true;
  # nixpkgs.config.cudaSupport = true;

  networking.hostName = "levi-pc"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.wireless.enable = true;
  networking.networkmanager.enable = true;

  programs.zsh.enable = true;
  users.users.zhy = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "docker"
      "vboxusers"
    ];

    packages = with pkgs; [
      tree
    ];
  };
  programs.fish = {
    enable = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  programs.vscode.enable = true;

  services.gnome.gnome-keyring.enable = true;

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    protontricks.enable = true;
    extest.enable = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    remotePlay.openFirewall = true;
  };
  programs.gamescope = {
    enable = true;
    enableWsi = true;
  };
  programs.gamemode.enable = true;

  programs.obs-studio = {
    enable = true;
    package = (pkgs.obs-studio.override { cudaSupport = true; });
    enableVirtualCamera = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vkcapture
    ];
  };

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
  nix.settings.substituters = [
    "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
    "https://mirrors.ustc.edu.cn/nix-channels/store"
    # "https://mirror.sjtu.edu.cn/nix-channels/store"
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  boot.loader.systemd-boot.configurationLimit = 10;

  services.mihomo = {
    enable = true;
    tunMode = true;
    processesInfo = true;
    configFile = "/home/zhy/proxy/config.yaml";
    # extraOpts = "-d /var/lib/private/mihomo";
    webui = pkgs.zashboard;
  };

  # networking.proxy.default = "http://user:password@proxy:port/";
  networking.proxy.default = "http://127.0.0.1:7890"; # the default value for httpProxy, httpsProxy, ftpProxy and rsyncProxy.
  networking.proxy.allProxy = "socks5h://127.0.0.1:7891";
  # networking.proxy.noProxy = "127.0.0.1,localhost";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    fcitx5 = {
      waylandFrontend = true;

      addons = with pkgs; [
        fcitx5-rime
        fcitx5-gtk
        qt6Packages.fcitx5-configtool
        fcitx5-nord
        fcitx5-material-color
      ];
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
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # services.displayManager.defaultSession = "niri";
  # services.displayManager.sddm.enable = true;
  # services.desktopManager.plasma6.enable = true;
  services.desktopManager.gnome.enable = true;

  services.displayManager.cosmic-greeter.enable = true;
  programs.niri = {
    enable = true;
    useNautilus = true;
  };
  programs.waybar.enable = true;
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
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
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    neovim
    vim
    nano

    git
    wget
    curl
    stow

    rustup
    rustc
    cargo

    tmux
    nil
    nixd
    nixfmt
    tree-sitter
    fzf
    shfmt
    prettier
    stylua
    tex-fmt

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

    cudaPackages.cuda_nvcc
    cudaPackages.cuda_cudart
    cudaPackages.cuda_gdb
    cudaPackages.cuda_cuobjdump
    # cudaPackages.cuda-samples
    cudaPackages.cutlass
    cudaPackages.libcurand
    cudaPackages.libcublas
    cudaPackages.libcufft
    # cudaPackages.libnvvm
    cudaPackages.cudnn
    # cudaPackages.tensorrt
    cudaPackages.cccl
    # cudaPackages.nccl
    # cudaPackages.cuda_opencl
    cudaPackages.nsight_compute
    # cudaPackages.nsight_systems

    awww
    eza
    lolcat
    fastfetch
    wl-clipboard
    swayidle
    swaylock
    mako
    fuzzel
    glib
    gsettings-desktop-schemas
    adwaita-icon-theme
    papirus-icon-theme
    adwaita-qt
    adwaita-qt6
    exfatprogs
    xwayland-satellite
    pulseaudio
    mangohud
    lm_sensors
    texliveFull
    nvtopPackages.full
    htop
    btop
    bat
    delta

    alacritty
    firefox-devedition
    nautilus
    cosmic-files
    cosmic-monitor
    kdePackages.okular
    kdePackages.gwenview
    sioyek
    mpv
    prismlauncher

    wechat
    qq
    feishu
    wpsoffice-cn
    # qqmusic

    wineWow64Packages.staging
    winetricks
    lutris
    bottles
    protonup-qt
    vulkan-tools
  ];

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
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    source-han-sans
    source-han-serif
    wqy_zenhei
    corefonts
    vista-fonts
    liberation_ttf
    dejavu_fonts
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
