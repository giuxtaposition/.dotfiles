{
  description = "Giuxtaposition's NixOS Flake";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nekowinston-nur.url = "github:nekowinston/nur";

    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-23.11";

    # Candy Icons
    candy-icons = {
      url =
        "https://github.com/EliverLara/candy-icons/archive/refs/heads/master.zip";
      flake = false;
    };

    # SDDM Sugar Catppuccin Theme
    sddm-sugar-catppuccin-theme = {
      url = "github:TiagoDamascena/sddm-sugar-catppuccin";
      flake = false;
    };

    ags.url = "github:Aylur/ags";

    fish-catppuccin-theme = {
      url = "github:catppuccin/fish";
      flake = false;
    };

    bat-catppuccin-theme = {
      url = "github:catppuccin/bat";
      flake = false;
    };

    spotify-adblock = {
      url = "github:abba23/spotify-adblock";
      flake = false;
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Default branch
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, nix-index-database, nixos-hardware
    , ... }@inputs:
    let
      inherit (self) outputs;
      # Supported systems for your flake packages, shell, etc.
      systems = [ "x86_64-linux" ];
      # This is a function that generates an attribute by calling a function you
      # pass to it, with each system as an argument
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
      # Your custom packages
      # Accessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./pkgs { inherit pkgs inputs; });
      # Formatter for your nix files, available through 'nix fmt'
      # Other options beside 'alejandra' include 'nixpkgs-fmt'
      formatter =
        forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };
      homeManagerModules = import ./modules/home-manager;
      nixosModules = import ./modules/nixos;

      nixosConfigurations = {
        # Personal Laptop
        kumiko = nixpkgs.lib.nixosSystem {
          modules = [ ./hosts/kumiko ];
          specialArgs = { inherit inputs outputs; };
        };

        # Personal Laptop
        asuka = nixpkgs.lib.nixosSystem {
          modules =
            [ ./hosts/asuka nixos-hardware.nixosModules.framework-13-7040-amd ];
          specialArgs = { inherit inputs outputs; };

        };

        # Personal Desktop
        reina = nixpkgs.lib.nixosSystem {
          modules = [ ./hosts/reina ];
          specialArgs = { inherit inputs outputs; };
        };
      };

      homeConfigurations = {
        "giu@kumiko" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/kumiko.nix
            nix-index-database.hmModules.nix-index
          ];
        };
        "giu@asuka" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules =
            [ ./home-manager/asuka.nix nix-index-database.hmModules.nix-index ];
        };
        "giu@reina" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules =
            [ ./home-manager/reina.nix nix-index-database.hmModules.nix-index ];
        };
      };

    };
}
