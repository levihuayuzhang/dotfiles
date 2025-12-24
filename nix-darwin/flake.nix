# sudo darwin-rebuild switch --flake ~/projects/dotfiles/nix-darwin#levi-mbp

{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
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

          # fonts.packages = [
          #   (pkgs.nerdfonts.override {
          #     fonts = [ "CaskaydiaCove Nerd Font Mono" ];
          #     # fonts = [ "JetBrainsMono" ];
          #   })
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
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#levi-mbp
      darwinConfigurations."levi-mbp" = nix-darwin.lib.darwinSystem {
        modules = [ configuration ];
      };
    };
}
