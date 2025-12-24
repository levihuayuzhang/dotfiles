# sudo darwin-rebuild switch --flake ~/projects/dotfiles/nix-darwin#levi-mbp

# ref:
# - https://github.com/elliottminns/nix/blob/main/flake.nix

{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    # # Optional: Declarative tap management
    # # https://github.com/zhaofengli/nix-homebrew?tab=readme-ov-file#quick-start
    # homebrew-core = {
    #   url = "github:homebrew/homebrew-core";
    #   flake = false;
    # };
    # homebrew-cask = {
    #   url = "github:homebrew/homebrew-cask";
    #   flake = false;
    # };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      nix-homebrew,
      # homebrew-core,
      # homebrew-cask,
      ...
    }:
    let
      configuration =
        { pkgs, config, ... }:
        {
          nixpkgs.config.allowUnfree = true;

          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = [
            # GUI apps
            # pkgs.ghostty # on Linux
            # pkgs.ghostty-bin # on Mac
            # pkgs.alacritty
            # pkgs.obsidian # unfree

            # dev tools
            pkgs.vim
            pkgs.neovim
            pkgs.tmux
            pkgs.gnupg
            pkgs.git
            pkgs.gh
            pkgs.eza
            pkgs.delta
            pkgs.bat

            # dev toolchains
            pkgs.cmake
            pkgs.meson
            pkgs.ninja
            pkgs.llvm

            # beautify & misc
            pkgs.fastfetch
            pkgs.lolcat
            pkgs.mkalias
          ];

          system.primaryUser = "zhy";
          homebrew = {
            enable = true;
            brews = [
              "zsh-autosuggestions"
              "zsh-syntax-highlighting"
              "mas"
              "direnv"
            ];
            # brew list --cask
            casks = [
              # "firefox-devedition"
              # "firefox"
              # "mpv"
              # "iina"
              # "the-unarchiver"
              "gpg-suite"
              "hammerspoon"
              "calibre"
            ];
            # # mas search xxx, App Store share - copy -> id
            # # login & purchased
            # masApps = {
            #   "TestFlight" = 899247664;
            # };
            onActivation.cleanup = "zap";
          };

          # fonts.packages = [
          #   (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
          # ];

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          nix.settings.substituters = [
            "https://mirror.sjtu.edu.cn/nix-channels/store"
            "https://mirrors.ustc.edu.cn/nix-channels/store"
            "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
            "https://cache.nixos.org"
          ];

          # Enable alternative shell support in nix-darwin.
          # programs.fish.enable = true;

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 6;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";

          environment.variables = {
            HOMEBREW_BREW_GIT_REMOTE = "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git";
            HOMEBREW_CORE_GIT_REMOTE = "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git";
            HOMEBREW_BOTTLE_DOMAIN = "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles";
            HOMEBREW_API_DOMAIN = "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api";
            HOMEBREW_PIP_INDEX_URL = "https://pypi.tuna.tsinghua.edu.cn/simple";
          };
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#levi-mbp
      darwinConfigurations."levi-mbp" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = false;
              user = "zhy";
              # autoMigrate = true;
              # taps = {
              #   "homebrew/homebrew-core" = homebrew-core;
              #   "homebrew/homebrew-cask" = homebrew-cask;
              # };
            };
          }
        ];
      };
    };
}
