{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [ ./terminal ./wm ];
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

    sessionVariables = {
      XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
      XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
      XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";
    };
  };

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

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    steam
    aseprite # Pixel Art Editor
    calibre # Library Management
    deluge # Torrent Client
    slack # Messaging App
    discord # Messaging App
    mpv-unwrapped # Media Player
    zathura
    spotify
    fnm # node version manager

    # Fonts
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  programs.home-manager.enable = true;

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
      unstable.nodePackages_latest.bash-language-server
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
      unstable.shellcheck # sh linter
      unstable.shfmt # sh formatter
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

  home.file."${config.home.homeDirectory}/.config/wezterm" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.dotfiles/.config/wezterm";
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
