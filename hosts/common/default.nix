{ inputs, outputs, lib, config, pkgs, ... }: {
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
      permittedInsecurePackages = [
        "electron-24.8.6" # needed for Obsidian
        "openssl-1.1.1w" # needed for mongodb-memory-server
      ];
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
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
    gc = {
      # Automatic garbage collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  networking.networkmanager.enable = true;
  networking.extraHosts = ''
    127.0.0.1   calc-local.vitesicure.it
    127.0.0.1   calc-local.bridgebroker.it
  '';

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
      extraGroups = [ "wheel" "video" "audio" "networkmanager" "rtkit" ];
      shell = pkgs.fish;
    };
  };
  programs.dconf.enable = true;
  programs.fish.enable = true;
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [

      # nodejs asdf plugin dependencies
      gpgme
      gawk
      stdenv.cc.cc

      # mongodb-memory-server
      curlFull
      openssl
      openssl_1_1
      xz
      libGL
      libuuid
    ];
  };

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
    dbus.enable = true;
    xserver = {
      enable = true;
      libinput.enable = true;
      xkbOptions = "ctrl:swapcaps";
      displayManager = {
        sddm = {
          enable = true;
          theme = let
            stdenv = pkgs.stdenv;
            src = inputs.sddm-sugar-catppuccin-theme;
          in "${
            import ../../pkgs/sddm-sugar-catppuccin-theme.nix {
              inherit stdenv src;
            }
          }/sddm-sugar-catppuccin-theme";
          wayland.enable = true;
        };
        defaultSession = "hyprland";
      };
      windowManager.hypr = { enable = true; };
    };
    blueman.enable = true;
    openssh.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  # Sound
  sound.enable = true;
  security.rtkit.enable = true;

  # Use swaylock as screen lock
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };

  hardware = {
    bluetooth = {
      enable = true;
      settings = { General = { Enable = "Source,Sink,Media,Socket"; }; };
    };

    opengl.enable = true;
    nvidia.modesetting.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  environment = {
    systemPackages = with pkgs; [
      # System-Wide Packages
      home-manager
      nurl
      unstable.firefox
      ark # archiving tool
      libsForQt5.qt5.qtgraphicaleffects
      xfce.thunar
      obsidian

      #Theme
      papirus-icon-theme

      #Programming
      neovim
      wezterm
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
      libnotify # send notifications from terminal
    ];
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
