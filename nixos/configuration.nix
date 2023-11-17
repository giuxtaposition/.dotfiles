{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [ "electron-24.8.6" ];
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}")
      config.nix.registry;

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };

    gc = {
      # Automatic garbage collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  networking.hostName = "Kumiko";
  networking.networkmanager.enable = true;

  boot = {
    # Boot Options
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
      timeout = 1;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  users.users = {
    giu = {
      initialPassword = "pigsarecute";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      extraGroups = [ "wheel" "video" "audio" "networkmanager" "docker" ];
      shell = pkgs.fish;
    };
  };
  programs.dconf.enable = true;
  programs.fish.enable = true;

  # Time Zone and Locale
  time.timeZone = "Europe/Rome";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "it_IT.UTF-8";
    LC_MONETARY = "it_IT.UTF-8";
  };

  console = {
    useXkbConfig = true;
    font = "Lat2-Terminus16";
  };

  # Services
  services = {
    xserver = {
      enable = true;
      xkbOptions = "ctrl:swapcaps";
      displayManager = {
        sddm.enable = true;
        sddm.theme = let
          stdenv = pkgs.stdenv;
          src = inputs.sddm-sugar-catppuccin-theme;
        in "${import ../pkgs/sddm-sugar-catppuccin-theme.nix {
          inherit stdenv src;
        }}";

        defaultSession =
          "none+awesome"; # need to add none to use window manager without desktop manager
      };
      windowManager.awesome = {
        enable = true;
        luaModules = with pkgs.luaPackages; [ luarocks luadbi-mysql lgi ];
      };
    };
    blueman.enable = true;
    openssh.enable = true;
  };

  # Sound
  sound = { enable = true; };

  hardware = {
    pulseaudio = { enable = true; };
    bluetooth = {
      enable = true;
      hsphfpd.enable = true;
      settings = { General = { Enable = "Source,Sink,Media,Socket"; }; };
    };
  };

  environment = {
    variables = {
      TERMINAL = "wezterm";
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    systemPackages = with pkgs; [
      # System-Wide Packages
      home-manager
      nurl
      firefox
      ark # archiving tool
      libsForQt5.qt5.qtgraphicaleffects
      xfce.thunar
      obsidian

      #Theme
      starship
      neofetch
      rofi
      papirus-icon-theme

      #Programming
      neovim
      unstable.wezterm
      git
      lazygit
      docker
      docker-compose
      insomnia
      mongodb-compass
      sqlite
      go
      unstable.rustc
      cargo
      cmake
      gnumake

      # Typescript/Javascript programming
      nodejs_20
      nodePackages_latest.pnpm

      # Command line tools
      xclip # clipboard tool
      exa # replacement for ls
      feh # image viewer
      fd # replacement for find
      ripgrep
      rsync
      openssh
      wget
      unzip
      gcc
      tree-sitter
      acpi # power management
      brightnessctl # screen brightness
      pamixer
      bat # cat alternative
      libnotify # send notifications from terminal
    ];
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
