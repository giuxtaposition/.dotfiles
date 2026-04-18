{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {kitty.enable = lib.mkEnableOption "enables kitty module";};

  config = lib.mkIf config.kitty.enable {
    programs.kitty = {
      enable = true;
      shellIntegration.enableFishIntegration = true;
      # enableGitIntegration = true;
      keybindings = {
        "ctrl+j" = "neighboring_window down";
        "ctrl+k" = "neighboring_window up";
        "ctrl+h" = "neighboring_window left";
        "ctrl+l" = "neighboring_window right";
        "ctrl+down" = "neighboring_window down";
        "ctrl+up" = "neighboring_window up";
        "ctrl+left" = "neighboring_window left";
        "ctrl+right" = "neighboring_window right";
        "alt+j" = "kitten relative_resize.py down 3";
        "alt+k" = "kitten relative_resize.py up 3";
        "alt+h" = "kitten relative_resize.py left 3";
        "alt+l" = "kitten relative_resize.py right 3";
        "alt+down" = "kitten relative_resize.py down 3";
        "alt+up" = "kitten relative_resize.py up 3";
        "alt+left" = "kitten relative_resize.py left 3";
        "alt+right" = "kitten relative_resize.py right 3";
        "kitty_mod+t" = "new_tab_with_cwd";
        "kitty_mod+enter" = "new_window_with_cwd";
        "ctrl+shift+g" = "launch --type=background --cwd=current kitten quick-access-terminal -- lazygit";
        "kitty_mod+f" = let
          fzf_ksb_find_script = pkgs.writeShellScript "fzf_ksb_find.sh" ''
            #! ${pkgs.bash}/bin/sh
            # Purpose: Fuzzy-find through the Kitty scrollback buffer
            # and copy the selected line to clipboard

            set -euo pipefail

            stdin="$(mktemp)"
            trap 'rm -f "$stdin"' EXIT

            # Read scrollback into temp file
            cat > "$stdin"

            # Add line numbers and run fzf
            selection=$(
              nl -ba "$stdin" | fzf \
                --ansi \
                --no-sort \
                --exact \
                --tac \
                --delimiter=$'\t' \
                --with-nth=2.. \
                --preview "bat --color=always --decorations=never --highlight-line {1} $stdin" \
                --preview-label 'Scrollback Buffer (Search Result Highlighted)' \
                --preview-window 'up,80%,border-rounded,+{1}/2' \
                --bind 'ctrl-c:abort' \
                --bind 'ctrl-b:preview-half-page-up' \
                --bind 'ctrl-f:preview-half-page-down'
            )

            # Extract the actual line (remove line number column)
            line="$(printf '%s\n' "$selection" | cut -f2-)"

            # Copy to clipboard (no trailing newline)
            printf "%s" "$line" | kitty +kitten clipboard
          '';
        in "launch --type=overlay --stdin-source=@screen_scrollback --stdin-add-formatting --copy-env ${fzf_ksb_find_script}";
      };
      extraConfig = ''
        map --when-focus-on var:IS_NVIM ctrl+j
        map --when-focus-on var:IS_NVIM ctrl+k
        map --when-focus-on var:IS_NVIM ctrl+h
        map --when-focus-on var:IS_NVIM ctrl+l
        map --when-focus-on var:IS_NVIM ctrl+down
        map --when-focus-on var:IS_NVIM ctrl+up
        map --when-focus-on var:IS_NVIM ctrl+left
        map --when-focus-on var:IS_NVIM ctrl+right

        map --when-focus-on var:IS_NVIM alt+j
        map --when-focus-on var:IS_NVIM alt+k
        map --when-focus-on var:IS_NVIM alt+h
        map --when-focus-on var:IS_NVIM alt+l
        map --when-focus-on var:IS_NVIM alt+down
        map --when-focus-on var:IS_NVIM alt+up
        map --when-focus-on var:IS_NVIM alt+left
        map --when-focus-on var:IS_NVIM alt+right
      '';
      settings = {
        font_family = "JetBrainsMono Nerd Font Mono";
        cursor_shape = "block";
        cursor_trail = "1";
        copy_on_select = "true";
        tab_bar_min_tabs = "1";
        tab_bar_edge = "bottom";
        tab_bar_style = "powerline";
        tab_powerline_style = "round";
        undercurl_style = "thick-dense";
        focus_follows_mouse = "true";
        allow_remote_control = "yes";
        listen_on = "unix:@mykitty";
        scrollback_lines = "5000";
        scrollback_pager_history_size = "10";
      };
      quickAccessTerminalConfig = {
        edge = "center";
      };
    };

    catppuccin.kitty = {
      enable = true;
    };

    xdg = {
      configFile = {
        "kitty/neighboring_window.py".source = "${pkgs.vimPlugins.smart-splits-nvim}/kitty/neighboring_window.py";
        "kitty/relative_resize.py".source = "${pkgs.vimPlugins.smart-splits-nvim}/kitty/relative_resize.py";
        "kitty/split_window.py".source = "${pkgs.vimPlugins.smart-splits-nvim}/kitty/split_window.py";
      };
    };
  };
}
