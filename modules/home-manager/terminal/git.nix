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
        kitty @ close-window --match "id:$KITTY_WINDOW_ID"
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
    home.packages = [nvimOpen pkgs.gitmoji-cli];
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
          merge = {
            conflictStyle = "zdiff3";
          };
          diff = {
            colorMoved = "default";
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

      delta = {
        enable = true;
        enableGitIntegration = true;
        options = {
          navigate = true;
          side-by-side = true;
          diff-highlight = true;
          true-color = "always";
        };
      };

      lazygit = {
        enable = true;
        settings = {
          git = {
            pagers = [
              {
                pager = "delta --dark --paging=never";
                colorArg = "always";
                useConfig = true;
              }
            ];
            parseEmoji = true;
          };
          os = {
            edit = "nvim-open {{filename}}";
            editAtLine = "nvim-open {{filename}} {{line}}";
          };
          promptToReturnFromSubprocess = false;
          customCommands = [
            {
              key = "C";
              context = "files";
              description = "Commit changes using gitmojis";
              command = "git commit -m '{{ .Form.emoji }}{{ if .Form.scope }} ({{ .Form.scope }}):{{ end }} {{ .Form.message }}'";
              prompts = [
                {
                  type = "menuFromCommand";
                  title = "Choose a gitmoji:";
                  command = "gitmoji -l";
                  filter = "^(.*?) - (:.*?:) - (.*)$";
                  key = "emoji";
                  labelFormat = "{{ .group_1 }} - {{ .group_3 }}";
                  valueFormat = "{{ .group_2 }}";
                }
                {
                  type = "input";
                  title = "Enter the scope of current changes:";
                  key = "scope";
                }
                {
                  type = "input";
                  title = "Enter the commit title:";
                  key = "message";
                }
              ];
            }
          ];
        };
      };
    };

    catppuccin.delta.enable = true;
    catppuccin.lazygit = {
      enable = true;
      accent = "lavender";
    };
  };
}
