{
  description = "Giuxtaposition's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    catppuccin.url = "github:catppuccin/nix/release-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    wezterm.url = "github:wez/wezterm?dir=nix";
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-index-database,
    nixos-hardware,
    catppuccin,
    sops-nix,
    ...
  } @ inputs: let
    inherit (self) outputs;
    systems = ["x86_64-linux"];
    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;
    treefmtEval = forAllSystems (system:
      inputs.treefmt-nix.lib.evalModule nixpkgs.legacyPackages.${system} {
        projectRootFile = "flake.nix";
        programs = {
          alejandra.enable = true;
          stylua.enable = true;
          prettier.enable = true;
          shfmt.enable = true;
        };
      });
  in {
    # Your custom packages
    # Accessible through 'nix build', 'nix shell', etc
    packages = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in
      import ./pkgs {inherit pkgs inputs;});
    formatter = forAllSystems (system: treefmtEval.${system}.config.build.wrapper);

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};
    homeManagerModules = import ./modules/home-manager;
    nixosModules = import ./modules/nixos;

    nixosConfigurations = {
      # Personal Laptop
      asuka = nixpkgs.lib.nixosSystem {
        modules = [./hosts/asuka nixos-hardware.nixosModules.framework-13-7040-amd sops-nix.nixosModules.sops];
        specialArgs = {inherit inputs outputs;};
      };

      # Personal Desktop
      reina = nixpkgs.lib.nixosSystem {
        modules = [./hosts/reina sops-nix.nixosModules.sops];
        specialArgs = {inherit inputs outputs;};
      };

      # Home Server
      kumiko = nixpkgs.lib.nixosSystem {
        modules = [./hosts/kumiko sops-nix.nixosModules.sops];
        specialArgs = {inherit inputs outputs;};
      };
    };

    homeConfigurations = let
      commonModules = [
        nix-index-database.homeModules.nix-index
        catppuccin.homeModules.catppuccin
        inputs.spicetify-nix.homeManagerModules.default
        inputs.niri.homeModules.niri
      ];
    in {
      "giu@asuka" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./home-manager/asuka.nix] ++ commonModules;
      };
      "giu@reina" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./home-manager/reina.nix] ++ commonModules;
      };
    };

    checks = forAllSystems (system: {
      git-hooks = inputs.git-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          alejandra.enable = true;
          statix.enable = true;
          deadnix.enable = true;
        };
      };

      # Formatting check
      formatting = treefmtEval.${system}.config.build.check self;

      # NixOS configuration checks
      nixos-asuka = self.nixosConfigurations.asuka.config.system.build.toplevel;
      nixos-reina = self.nixosConfigurations.reina.config.system.build.toplevel;
      nixos-kumiko = self.nixosConfigurations.kumiko.config.system.build.toplevel;

      # Home-manager configuration checks
      home-asuka = self.homeConfigurations."giu@asuka".activationPackage;
      home-reina = self.homeConfigurations."giu@reina".activationPackage;
    });

    devShells = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.mkShell {
        packages = [pkgs.cachix pkgs.nodejs_24 pkgs.sops pkgs.age];
        inherit (self.checks.${system}.git-hooks) shellHook;
        buildInputs = self.checks.${system}.git-hooks.enabledPackages;
      };
    });
  };
}
