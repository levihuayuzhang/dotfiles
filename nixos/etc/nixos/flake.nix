{
  description = "levi-pc NixOS";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # stylix = {
    #   url = "github:nix-community/stylix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # noctalia = {
    #   # url = "github:noctalia-dev/noctalia";
    #   url = "github:noctalia-dev/noctalia/cachix"; # https://docs.noctalia.dev/noctalia/getting-started/nixos/?section=binary-cache#binary-cache
    #   # inputs.nixpkgs.follows = "nixpkgs"; # this line is optional, prevents downloading two versions of nixpkgs but disables cache
    # };
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      # stylix,
      # noctalia,
      ...
    }:
    {
      nixosConfigurations.levi-pc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = {
          inherit inputs;
        };

        modules = [
          ./configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.zhy = import ./home.nix;
              backupFileExtension = "backup";
            };
          }

          # stylix.nixosModules.stylix
        ];
      };
    };
}
