{
  config,
  lib,
  pkgs,
  ...
}: let
  nvimOpen = pkgs.writeShellScriptBin "nvim-open" ''
    FILE="$1"
    LINE="''${2:-0}"

    send_to() {
      local socket="$1"
      nvim --server "$socket" --remote-tab "$FILE"
      if [ "$LINE" -gt 0 ] 2>/dev/null; then
        nvim --server "$socket" --remote-send ":''${LINE}<CR>"
      fi
      if [ -n "$KITTY_LISTEN_ON" ]; then
        kitty @ focus-window --match "var:IS_NVIM and cwd:$PWD"
      fi
    }

    # Find neovim instance open in the current directory
    SOCKET="/tmp/nvim-$(echo -n "$PWD" | sha256sum | cut -c1-8)"
    if [ -S "$SOCKET" ] && nvim --server "$SOCKET" --remote-expr "1" 2>/dev/null; then
      send_to "$SOCKET"
      exit 0
    fi

    # Open new neovim instance
    if [ "$LINE" -gt 0 ] 2>/dev/null; then
      nvim +"$LINE" "$FILE"
    else
      nvim "$FILE"
    fi
  '';
in {
  options = {git.enable = lib.mkEnableOption "enables git module";};

  config = lib.mkIf config.git.enable {
    home.packages = [nvimOpen];
    programs = {
      git = {
        enable = true;
        settings = {
          user = {
            name = "giuxtaposition";
            email = "yg97.cs@gmail.com";
          };
          core = {editor = "nvim";};
          pull.rebase = true;
          push.autoSetupRemote = true;
          fetch.prune = true;

          init.defaultBranch = "main";
          merge = {tool = "fugitive";};
          mergetool = {
            fugitive = {cmd = ''nvim -f -c \"Gvdiff\" \"$MERGED\"'';};
          };
        };

        includes = [
          {
            condition = "gitdir:~/Programming/vitesicure/";
            contents = {
              user = {
                email = "gye@vitesicure.it";
                name = "Giulia Ye";
              };
            };
          }
        ];
      };

      difftastic = {
        enable = true;
        git = {
          enable = true;
          diffToolMode = true;
        };
      };

      lazygit = {
        enable = true;
        settings = {
          git.pagers = [
            {
              "externalDiffCommand" = "difft --color=always --display=inline";
            }
          ];
          os = {
            edit = "nvim-open {{filename}}";
            editAtLine = "nvim-open {{filename}} {{line}}";
          };
          promptToReturnFromSubprocess = false;
        };
      };
    };

    catppuccin.lazygit = {
      enable = true;
      accent = "lavender";
    };
  };
}
