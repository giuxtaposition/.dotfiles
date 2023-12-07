{ config, pkgs, lib, ... }: {
  home.packages = with pkgs; [
    eza # replacement for ls
    starship
    fzf
    neofetch
    imagemagick
  ];

  # fish theme
  home.file."${config.home.homeDirectory}/.config/fish/themes" = {
    source = "${pkgs.fish-catppuccin-theme.out}/fish-catppuccin-theme";
  };

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

    plugins = [
      {
        name = "fzf";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "z";
        src = pkgs.fishPlugins.z.src;
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
      ll = "eza -l -g --icons";
      lla = "eza -la -g --icons";
      ":q" = "exit";
    };
    shellAbbrs = {

      #GIT
      gp = "git pull --rebase --autostash";
      gpf = "git push --force-with-lease";
      gs = "git status --short";
    };
  };

}
