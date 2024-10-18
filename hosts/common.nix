{ inputs, outputs, lib, config, pkgs, ... }: {

  imports = (builtins.attrValues outputs.nixosModules);

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      # outputs.overlays.unstable-packages

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
      # permittedInsecurePackages = [
      #   "openssl-1.1.1w" # needed for mongodb-memory-server
      # ];
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = (lib.mapAttrs (_: flake: { inherit flake; }))
      ((lib.filterAttrs (_: lib.isType "flake")) inputs);

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = [ "/etc/nix/path" ];

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      substituters =
        [ "https://wezterm.cachix.org" "https://nix-community.cachix.org" ];
      trusted-public-keys = [
        "wezterm.cachix.org-1:kAbhjYUC9qvblTE+s7S+kl5XM1zVa4skO+E/1IDWdH0="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    gc = {
      # Automatic garbage collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

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

  network.enable = true;

  users.users = {
    giu = {
      initialPassword = "pigsarecute";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      extraGroups = [ "wheel" "video" "audio" "rtkit" ];
    };
  };

  programs.dconf.enable = true;
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [

      # nodejs asdf plugin dependencies
      gpgme
      gawk
      stdenv.cc.cc

      # mongodb-memory-server
      # curlFull
      # openssl
      # openssl_1_1
      # xz
      # libGL
      # libuuid
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
    dbus = {
      enable = true;
      packages = [ pkgs.dconf ];
    };

    libinput.enable = true;

    xserver = {
      enable = true;
      xkb.options = "ctrl:swapcaps";
    };

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
          user = "giu";
        };
      };
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
    upower.enable = true;

    printing.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };

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
      powerOnBoot = true;
      settings = { General = { Enable = "Source,Sink,Media,Socket"; }; };
    };

    keyboard = { qmk.enable = true; };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-wlr xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };

  environment = {
    systemPackages = with pkgs; [
      # System-Wide Packages
      home-manager
      nurl
      ark # archiving tool
      libsForQt5.qt5.qtgraphicaleffects

      #Theme
      papirus-icon-theme

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
      brightnessctl # screen brightness
      pulseaudio
      pamixer
      libnotify # send notifications from terminal
    ];

    etc = lib.mapAttrs' (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    }) config.nix.registry;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
