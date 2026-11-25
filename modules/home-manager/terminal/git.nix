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
      # --remote (not --remote-tab) so the file opens in the pane that was
      # focused when lazygit/kitty was launched, instead of a new tab.
      nvim --server "$socket" --remote "$FILE"
      if [ "$LINE" -gt 0 ] 2>/dev/null; then
        nvim --server "$socket" --remote-send ":''${LINE}<CR>"
      fi
      # Called from lazygit in a tmux popup: close it so the pane running the
      # neovim instance that just got the file is visible again.
      if [ -n "$TMUX" ]; then
        tmux display-popup -C
      fi
    }

    # Under tmux, find neovim by the pane it runs in: this window first, then
    # the rest of the session. The directory hash below cannot be trusted here,
    # because it is taken at startup and :cd moves neovim away from it; knowing
    # the pane also means the window holding it can be focused afterwards,
    # which the caller's window usually is not.
    if [ -n "$TMUX" ]; then
      NVIM_PANE="$(tmux list-panes -F '#{pane_id}' -f '#{==:#{pane_current_command},nvim}' | head -1)"
      if [ -z "$NVIM_PANE" ]; then
        NVIM_PANE="$(tmux list-panes -s -F '#{pane_id}' -f '#{==:#{pane_current_command},nvim}' | head -1)"
      fi

      if [ -n "$NVIM_PANE" ] && nvim --server "/tmp/nvim-pane-$NVIM_PANE" --remote-expr "1" >/dev/null 2>&1; then
        send_to "/tmp/nvim-pane-$NVIM_PANE"
        tmux select-window -t "$(tmux display-message -p -t "$NVIM_PANE" '#{window_id}')"
        tmux select-pane -t "$NVIM_PANE"
        exit 0
      fi
    fi

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
          core = {
            editor = "nvim";
          };
          pull.rebase = true;
          push.autoSetupRemote = true;
          fetch.prune = true;
          init.defaultBranch = "main";
          merge = {
            conflictStyle = "zdiff3";
          };
          diff = {
            algorithm = "histogram";
            colorMoved = "default";
            mnemonicPrefix = "true";
          };
          rerere = {
            enabled = true;
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

      lazygit = {
        enable = true;
        package = pkgs.unstable.lazygit;
        settings = {
          git = {
            parseEmoji = true;
          };
          os = {
            edit = "nvim-open {{filename}}";
            editAtLine = "nvim-open {{filename}} {{line}}";
          };
          promptToReturnFromSubprocess = false;
          customCommands = [
            {
              key = "R";
              context = "files";
              description = "Retry last failed commit (reuse COMMIT_EDITMSG)";
              command = "git commit -F .git/COMMIT_EDITMSG";
            }
            {
              key = "C";
              context = "files";
              description = "Commit changes using gitmojis";
              command = "git commit -m '{{ .Form.emoji }}{{ if .Form.scope }} {{ .Form.scope }}:{{ end }} {{ .Form.message }}'";
              prompts = [
                {
                  type = "menuFromCommand";
                  title = "Choose a gitmoji:";
                  command = "gitmoji -l";
                  filter = "^(.*?) - (:.*?:) - (.*)$";
                  key = "emoji";
                  labelFormat = "{{ .group_1 }} - {{ .group_3 }}";
                  valueFormat = "{{ .group_1 }}";
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
  };
}
