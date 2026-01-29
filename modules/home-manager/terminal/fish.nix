{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {fish.enable = lib.mkEnableOption "enables fish module";};

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
      source =
        config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/.dotfiles/.config/starship.toml";
    };

    # neofetch config
    home.file."${config.home.homeDirectory}/.config/neofetch" = {
      source =
        config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/.dotfiles/.config/neofetch";
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
      '';
      functions = {
        fish_user_key_bindings = ''
          fish_vi_key_bindings
          bind -M insert -m default kj backward-char force-repaint #use kj as Esc
          bind -M insert -m default \cp "open_project_in_neovim; commandline -f repaint" #open project in neovim
        '';
        open_project_in_neovim = ''
          set selected_repo (zoxide query --list | fzf --ansi --preview "eza --color=always --long --no-filesize --icons=always --no-time --no-user --no-permissions {}")

          if test -n "$selected_repo"
              cd "$selected_repo" && nvim
          end
        '';
      };

      shellAliases = {
        vim = "nvim";
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
    };
    catppuccin.fish.enable = true;

    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.skim = {
      enable = true;
    };

    home.sessionVariables = {
      SKIM_DEFAULT_OPTIONS = "--color=fg:#cdd6f4,bg:#1e1e2e,matched:#313244,matched_bg:#b4befe,current:#cdd6f4,current_bg:#45475a,current_match:#1e1e2e,current_match_bg:#89b4fa,spinner:#a6e3a1,info:#cba6f7,prompt:#89b4fa,cursor:#f38ba8,selected:#eba0ac,header:#94e2d5,border:#6c7086";
    };

    programs.fzf = {
      enable = true;
      enableFishIntegration = true;
      colors = let
        c = config.colors;
      in {
        fg = "${c.fg}";
        bg = "${c.bg}";
        "preview-fg" = "${c.fg}";
        "preview-bg" = "${c.bg}";
        hl = "${c.purple}";
        "fg+" = "${c.fg}";
        "bg+" = "${c.selection_bg}";
        "hl+" = "${c.lilac}";
        info = "${c.sky}";
        border = "${c.indigo}";
        prompt = "${c.green}";
        pointer = "${c.lilac}";
        marker = "${c.lilac}";
        spinner = "${c.sky}";
        header = "${c.indigo}";
      };
    };
  };
}
