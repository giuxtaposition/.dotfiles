{
  config,
  lib,
  ...
}: {
  options = {fish.enable = lib.mkEnableOption "enables fish module";};

  config = lib.mkIf config.fish.enable {
    programs = {
      fish = {
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

          set -gx EDITOR nvim

          # starship
          starship init fish | source

          # vim mode
          set fish_key_bindings fish_user_key_bindings

          function __postexec_notify_on_long_running_commands --on-event fish_postexec
            set --function interactive_commands 'vim' 'nvim' 'yazi' 'claude'
            set --function command (string split ' ' $argv[1])
            if contains $command $interactive_commands
              return
            end
            if test $CMD_DURATION -gt 30000
              notify-send 'command finished' "$argv"
            end
          end
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
          gp = "git pull --rebase --autostash";
          gP = "git push";
          gpf = "git push --force-with-lease";
          gs = "git status --short";
        };
      };
    };
  };
}
