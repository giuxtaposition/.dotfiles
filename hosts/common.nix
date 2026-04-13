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
      substituters = ["https://wezterm.cachix.org" "https://nix-community.cachix.org" "https://yazi.cachix.org"];
      trusted-public-keys = [
        "wezterm.cachix.org-1:kAbhjYUC9qvblTE+s7S+kl5XM1zVa4skO+E/1IDWdH0="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
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
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
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
