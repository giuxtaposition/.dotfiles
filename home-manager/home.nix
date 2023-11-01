{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [ ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
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
  };

  xdg = {
    enable = true;

    userDirs = {
      enable = true;
      documents = "${config.home.homeDirectory}/Documents";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
    };
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    steam
    aseprite # Pixel Art Editor
    calibre # Library Management
    deluge # Torrent Client
    kazam # Screenshot and screencast tool
    slack # Messaging App
    discord # Messaging App
    mpv-unwrapped # Media Player

    # Fonts
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  programs.home-manager.enable = true;

  # GIT CONFIG
  programs.git = {
    enable = true;
    userName = "giuxtaposition";
    userEmail = "yg97.cs@gmail.com";
    extraConfig = {
      core = { editor = "nvim"; };
      pull.rebase = true;
      init.defaultBranch = "main";
    };
  };

  # NEOVIM CONFIG
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraPackages = with pkgs; [
      # Language servers
      unstable.vscode-langservers-extracted
      unstable.nodePackages_latest.typescript-language-server
      unstable.nodePackages_latest.svelte-language-server
      unstable.emmet-ls
      unstable.lua-language-server
      unstable.marksman
      unstable.nil

      # Linters and formatters
      unstable.prettierd # typescript formatter
      unstable.eslint_d # typescript linter
      unstable.stylua # lua formatter
      unstable.codespell # code spell
      unstable.nixfmt
    ];
  };

  home.file."${config.home.homeDirectory}/.dotfiles/.config/nvim/lua/giuxtaposition/core/nixosExtra.lua" =
    {
      text = ''
        vim.g.sqlite_clib_path = '${pkgs.sqlite.out}/lib/libsqlite3.so'
      '';

    };

  home.file."${config.home.homeDirectory}/.config/nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.dotfiles/.config/nvim";
  };

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

  home.file."${config.home.homeDirectory}/.config/awesome" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.dotfiles/.config/awesome";
  };

  home.file."${config.home.homeDirectory}/.config/wezterm" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.dotfiles/.config/wezterm";
  };

  home.file."${config.home.homeDirectory}/.config/fish" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.dotfiles/.config/fish";
  };

  home.file."${config.home.homeDirectory}/.config/rofi" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.dotfiles/.config/rofi";
  };

  home.file."${config.home.homeDirectory}/.config/neofetch" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.dotfiles/.config/neofetch";
  };

  home.file."${config.home.homeDirectory}/.config/starship.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.dotfiles/.config/starship.toml";
  };

  home.file."${config.home.homeDirectory}/.config/lazygit/config.yml" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.dotfiles/.config/lazygit/config.yml";
  };

  home.file."${config.home.homeDirectory}/.local/share/icons/candy-icons" = {
    source = pkgs.candy-icons;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
