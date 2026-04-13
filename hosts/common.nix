# Shared configuration for ALL machines (desktops + servers)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = builtins.attrValues outputs.nixosModules;

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry =
      (lib.mapAttrs (_: flake: {inherit flake;}))
      ((lib.filterAttrs (_: lib.isType "flake")) inputs);

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = ["/etc/nix/path" "nixpkgs=${inputs.nixpkgs}"];

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      # Use extra-* to add to defaults (cache.nixos.org) rather than replace
      extra-substituters = [
        "https://giuxtaposition.cachix.org"
        "https://nix-community.cachix.org"
        "https://nixpkgs-wayland.cachix.org"
        "https://wezterm.cachix.org"
        "https://yazi.cachix.org"
      ];
      extra-trusted-public-keys = [
        "giuxtaposition.cachix.org-1:ZY2fy+5YOPsu79QNFd6TUR9gCR/AHkP2m/ygLRu5Hm8="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        "wezterm.cachix.org-1:kAbhjYUC9qvblTE+s7S+kl5XM1zVa4skO+E/1IDWdH0="
        "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
      ];
    };

    gc = {
      # Automatic garbage collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Time Zone and Locale
  time.timeZone = "Europe/Rome";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "it_IT.UTF-8";
    LC_MONETARY = "it_IT.UTF-8";
  };

  users.users = {
    giu = {
      initialPassword = "pigsarecute";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ/ZtdnGzYTF7xrk9kYEltadoO3RC7FNvU0nUEJ4V8FA yg97.cs@gmail.com"
      ];
      extraGroups = ["wheel"];
    };
  };

  services.openssh.enable = true;

  environment = {
    systemPackages = with pkgs; [
      git
      wget
      curl
      fd
      ripgrep
      rsync
      openssh
      unzip
      zip
      htop
    ];

    etc =
      lib.mapAttrs' (name: value: {
        name = "nix/path/${name}";
        value.source = value.flake;
      })
      config.nix.registry;
  };
}
