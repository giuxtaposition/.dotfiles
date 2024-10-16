{ config, pkgs, lib, ... }: {

  options = { fish.enable = lib.mkEnableOption "enables fish module"; };

  config = lib.mkIf config.fish.enable {

    home.packages = with pkgs; [
      eza # replacement for ls
      starship
      neofetch
      imagemagick
      ueberzugpp
      tree
    ];

    # starship config
    home.file."${config.home.homeDirectory}/.config/starship.toml" = {
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/.dotfiles/.config/starship.toml";
    };

    # neofetch config
    home.file."${config.home.homeDirectory}/.config/neofetch" = {
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/.dotfiles/.config/neofetch";
    };

    # asdf config
    home.file."${config.home.homeDirectory}/.asdfrc" = {
      text = ''
        legacy_version_file = yes
      '';
    };

    programs.command-not-found.enable = false;

    programs.nix-index = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.fish = {
      enable = true;

      interactiveShellInit = ''
        function fish_greeting
          echo (set_color b4befe)'Hello Giu,
                               _
              |\      _-``---,) )
        ZZZzz /,`.-```    -.   /
             |,4-  ) )-,_. ,\ (
            `---``(_/--`  `-`\_)
        ' 
        end

        set -gx TERM xterm-256color
        set -gx EDITOR nvim

        # starship
        starship init fish | source

        # vim mode
        set fish_key_bindings fish_user_key_bindings

        # load asdf definitions
        source "$HOME/.nix-profile/share/asdf-vm/asdf.fish"
      '';
      functions = {
        fish_user_key_bindings = ''
          fish_vi_key_bindings
          bind -M insert -m default kj backward-char force-repaint #use kj as Esc'';
      };

      shellAliases = {
        vim = "nvim";
        nvim =
          "env TERM=wezterm nvim --listen ~/.cache/nvim/(pwd | sed 's/\\//-/g' | sed 's/^-//' | sed 's/\\//./g').pipe";
        ll = "eza -l -g --icons";
        lla = "eza -la -g --icons";
        ":q" = "exit";
        keyboard = "wvkbd-mobintl";
      };

      shellAbbrs = {
        #GIT
        gp = "git pull --rebase --autostash";
        gP = "git push";
        gpf = "git push --force-with-lease";
        gs = "git status --short";
      };

      catppuccin.enable = true;
    };

    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.fzf = {
      enable = true;
      enableFishIntegration = true;
      catppuccin.enable = true;
    };
  };
}
