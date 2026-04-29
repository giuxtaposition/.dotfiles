{
  config,
  pkgs,
  ...
}: {
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    documents = "${config.home.homeDirectory}/Documents";
    pictures = "${config.home.homeDirectory}/Pictures";
  };

  kitty.enable = true;
  wayland.enable = true;
  niri.enable = true;
  mpv.enable = true;
  noctalia-shell.enable = true;

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    zathura
    cbonsai

    (pkgs.wrapFirefox
      (pkgs.firefox-unwrapped.override {pipewireSupport = true;}) {})

    qalculate-gtk
    onlyoffice-desktopeditors
    pavucontrol
    kdePackages.gwenview

    # Fonts
    merriweather
    nerd-fonts.jetbrains-mono
    inter
    rclone
    obsidian
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
}
