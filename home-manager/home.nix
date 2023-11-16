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
    spotify

    # Fonts
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  programs.home-manager.enable = true;

  # FISH CONFIG
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "fzf";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "z";
        src = pkgs.fishPlugins.z.src;
      }
      {
        name = "nvm";
        src = pkgs.nvm-fish.src;
      }
    ];

    interactiveShellInit = ''
      function fish_greeting
        echo (set_color b4befe)'Hello Giu,

          ／l、               
        （ﾟ､ ｡ ７         
          l  ~ヽ       
          じしf_,)ノ'
      end

      set -gx TERM xterm-256color
      set -gx EDITOR nvim

      # FZF theme
      set -Ux FZF_DEFAULT_OPTS "\
      --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
      --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
      --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
             
      fish_config theme choose "Catppuccin Mocha"

      # starship
      starship init fish | source

      # Autocall nvm use if supported
      function __check_rvm --on-variable PWD --description 'Autocall nvm use'
        status --is-command-substitution; and return
        if test -f .nvmrc; and test -r .nvmrc;
          nvm use
        else
        end
      end

      # vim mode
      set fish_key_bindings fish_user_key_bindings

    '';
    functions = {
      fish_user_key_bindings = ''
        fish_vi_key_bindings
        bind -M insert -m default kj backward-char force-repaint #use kj as Esc'';
    };
    shellAliases = {
      vim = "nvim";
      ll = "exa -l -g --icons";
      lla = "exa -la -g --icons";
      ":q" = "exit";
    };
  };

  # GIT CONFIG
  programs.git = {
    enable = true;
    userName = "giuxtaposition";
    userEmail = "yg97.cs@gmail.com";
    extraConfig = {
      core = { editor = "nvim"; };
      pull.rebase = true;
      push.autoSetupRemote = true;
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

  home.file."${config.home.homeDirectory}/.config/fish/themes" = {
    source = "${pkgs.fish-catppuccin-theme.out}/fish-catppuccin-theme";
  };

  home.file."${config.home.homeDirectory}/.local/share/icons/candy-icons" = {
    source = pkgs.candy-icons;
  };

  home.file."${config.home.homeDirectory}/.local/share/icons/papirus-icon-theme" =
    {
      source = pkgs.papirus-icon-theme;
    };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
