{ inputs, outputs, lib, config, pkgs, ... }:
let
  firefoxWorkScript = pkgs.writeScriptBin "firefoxWork" ''
    #! ${pkgs.bash}/bin/sh
    firefox -P "work"
  '';

  firefoxWork = pkgs.makeDesktopItem {
    name = "firefox-work-profile";
    desktopName = "Firefox Work Profile";
    exec = ''firefox -P "work"'';
    terminal = false;
    icon = "firefox";
  };

in {
  imports = (builtins.attrValues outputs.homeManagerModules);
  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      inputs.neovim-nightly-overlay.overlay
    ];
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "giu";
    homeDirectory = "/home/giu";

    sessionVariables = {
      XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
      XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
      XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";
      MONGOMS_DISTRO =
        "ubuntu-22.04"; # MONGO MEMORY SERVER not supporting nixos
      CYPRESS_INSTALL_BINARY = "0";
      CYPRESS_RUN_BINARY = "${pkgs.cypress}/bin/Cypress";
    };
  };

  programs.home-manager.enable = true;

  xdg = {
    enable = true;

    userDirs = {
      enable = true;
      createDirectories = true;
      documents = "${config.home.homeDirectory}/Documents";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
    };
  };

  bat.enable = true;
  fish.enable = true;
  git.enable = true;
  nvim.enable = true;
  wezterm.enable = true;

  wayland.enable = true;
  sway.enable = true;
  ags.enable = true;

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    aseprite # Pixel Art Editor
    calibre # Library Management
    deluge # Torrent Client
    slack # Messaging App
    discord # Messaging App
    mpv-unwrapped # Media Player
    zathura
    spotify
    asdf-vm # runtime version management

    (pkgs.wrapFirefox
      (pkgs.firefox-unwrapped.override { pipewireSupport = true; }) { })
    (firefoxWork)
    (firefoxWorkScript)

    chromium
    glxinfo # info about GPU
    steam-run
    cypress
    qalculate-gtk
    unstable.qmk
    unstable.qmk-udev-rules
    opera
    wvkbd
    vlc
    libreoffice-qt

    jdk
    kotlin
    gradle

    miller # csv
    ventoy

    libsForQt5.gwenview

    # Fonts
    (pkgs.unstable.nerdfonts.override {
      fonts = [ "JetBrainsMono" "Monaspace" ];
    })
  ];

  # GTK CONFIG
  gtk = {
    enable = true;
    theme = {
      name = "Sweet-Dark";
      package = pkgs.sweet;
    };
    font = { name = "JetBrains Mono"; };
    iconTheme = {
      name = "candy-icons";
      package = pkgs.candy-icons;
    };
  };

  # Cursor theme
  home.pointerCursor = {
    name = "Dracula-cursors";
    package = pkgs.dracula-theme;
    size = 16;
  };

  home.file."${config.home.homeDirectory}/.local/share/icons/candy-icons" = {
    source = pkgs.candy-icons;
  };

  home.file."${config.home.homeDirectory}/.local/share/icons/papirus-icon-theme" =
    {
      source = pkgs.papirus-icon-theme;
    };

  systemd.user = {
    # Nicely reload system units when changing configs
    startServices = "sd-switch";

    services = {
      sync-notes = {
        Unit = { Description = "Sync notes with github repo"; };
        Service = {
          Type = "forking";
          Environment = "PATH=${
              lib.makeBinPath [ pkgs.openssh pkgs.gawk pkgs.git pkgs.libnotify ]
            }";
          ExecStart = let
            script = pkgs.writeShellScript "sync-notes" ''
              echo "Syncing notes"
              filesChanged=$(git status --porcelain | awk '{print $2}')
              if [ -n "$filesChanged" ]; then
              git pull
              git add .
              git commit -m "updating notes 📘"
              git push
              notify-send "Synced notes"
              fi
            '';
          in "${pkgs.bash}/bin/bash ${script}";
          WorkingDirectory = "${config.home.homeDirectory}/notes";
        };
        Install.WantedBy = [ "default.target" ];
      };
    };

    timers = {
      sync-notes = {
        Unit.Description = "Timer for sync-notes service";
        Timer = {
          Unit = "sync-notes";
          OnBootSec = "1m";
          OnUnitActiveSec = "1h";
        };
        Install.WantedBy = [ "timers.target" ];
      };
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
