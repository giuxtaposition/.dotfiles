{
  outputs,
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = builtins.attrValues outputs.homeManagerModules;
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

  home = {
    username = "giu";
    homeDirectory = "/home/giu";

    sessionVariables = {
      XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
      XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
      XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";
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
    };
  };

  bat.enable = true;
  fish.enable = true;
  git.enable = true;
  nvim.enable = true;
  wezterm.enable = true;
  ghostty.enable = true;
  btop.enable = true;
  yazi.enable = true;
  wayland.enable = true;
  spotify.enable = true;
  niri.enable = true;
  mpv.enable = true;
  noctalia-shell.enable = true;

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    slack # Messaging App
    zathura
    cbonsai

    (pkgs.wrapFirefox
      (pkgs.firefox-unwrapped.override {pipewireSupport = true;}) {})

    steam-run
    qalculate-gtk
    libreoffice-qt
    pavucontrol
    kdePackages.gwenview

    # Fonts
    merriweather
    nerd-fonts.jetbrains-mono
    inter
    obs-studio
    rclone
    trilium-desktop
    obsidian
    shotcut
  ];

  # GTK CONFIG
  gtk = {
    enable = true;
    theme = {
      name = "Sweet-Dark";
      package = pkgs.sweet;
    };
    font = {name = "JetBrains Mono";};
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

  systemd.user = {
    # Nicely reload system units when changing configs
    startServices = "sd-switch";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
