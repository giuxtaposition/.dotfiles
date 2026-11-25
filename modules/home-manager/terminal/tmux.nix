{
  config,
  pkgs,
  lib,
  ...
}: let
  # Pick a file:line reference out of the pane's scrollback and open it in the
  # neovim instance running there. This used to be `kitten hints`, which broke
  # under tmux: kitty reads a window's directory from its foreground process,
  # and that is now the tmux client sitting in $HOME, so nvim-open hashed the
  # wrong path and never found the socket. The pane knows its own directory.
  openInNvim = pkgs.writeShellScript "tmux-open-in-nvim.sh" ''
    set -eu
    pane="$(tmux display-message -p '#{pane_id}')"
    dir="$(tmux display-message -p '#{pane_current_path}')"

    match=$(
      tmux capture-pane -p -S - -t "$pane" \
        | grep -oE '[^[:space:]()]+\.[a-zA-Z]+:[0-9]+' \
        | awk '!seen[$0]++' \
        | tac \
        | fzf --no-sort --exact --prompt=' ' --bind 'ctrl-c:abort'
    ) || exit 0

    file="''${match%:*}"
    line="''${match##*:}"
    case "$file" in
      /*) ;;
      *) file="$dir/$file" ;;
    esac

    nvim-open "$file" "$line"
  '';

  # Pick files under the pane's directory and type them back into the pane.
  filePicker = pkgs.writeShellScript "tmux-file-picker.sh" ''
    set -eu
    pane="$(tmux display-message -p '#{pane_id}')"
    dir="$(tmux display-message -p '#{pane_current_path}')"
    pane_pid="$(tmux display-message -p '#{pane_pid}')"

    selection=$(
      cd "$dir"
      fd --hidden --follow --type f --exclude .git \
        | fzf --multi --reverse --tiebreak=index \
          --preview 'bat --style=numbers --color=always {}' \
          --bind 'ctrl-c:abort'
    ) || exit 0
    [ -n "$selection" ] || exit 0

    if pgrep -P "$pane_pid" -f 'claude|codex|gemini' >/dev/null; then
      # Coding agents read @path as a file reference. Paste it bracketed so the
      # agent takes the whole line at once instead of opening its own completer
      # on the @ and filtering on the rest.
      line="$(printf '%s' "$selection" | sed 's|^|@|' | tr '\n' ' ')"
      tmux send-keys -l -t "$pane" $'\e[200~'"$line"$'\e[201~'
    else
      # A shell gets the paths escaped, and -l so a file called "Enter" is not
      # read as a key name.
      line="$(printf '%s' "$selection" | sed 's| |\\ |g' | tr '\n' ' ')"
      tmux send-keys -l -t "$pane" "$line"
    fi
  '';

  # CPU and memory usage for the statusline. tmux-cpu-mem-monitor and friends
  # rewrite status-right once, at plugin load, and home-manager emits plugins
  # before extraConfig, so they would never see the status-right set below.
  # /proc is right there: sample it from `#()` instead. One metric per call so
  # the statusline styles each segment itself: tmux parses `#[]` in `#()` output
  # but does not re-expand `#{@thm_*}` there.
  cpuMem = pkgs.writeShellScript "tmux-cpu-mem.sh" ''
    set -eu

    if [ "''${1:-}" = mem ]; then
      awk '/^MemTotal:/{t=$2} /^MemAvailable:/{a=$2} END{printf "%d%%", (t - a) * 100 / t}' /proc/meminfo
      exit 0
    fi

    state="''${TMPDIR:-/tmp}/tmux-cpu.$(id -u)"

    read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat
    idle_all=$((idle + iowait))
    total=$((user + nice + system + idle_all + irq + softirq + steal))

    # First call has nothing to diff against and reports the average since boot;
    # it corrects itself one status-interval later.
    prev_total=0
    prev_idle=0
    if [ -r "$state" ]; then
      read -r prev_total prev_idle < "$state"
    fi
    printf '%s %s\n' "$total" "$idle_all" > "$state"

    delta_total=$((total - prev_total))
    delta_idle=$((idle_all - prev_idle))
    cpu=0
    if [ "$delta_total" -gt 0 ]; then
      cpu=$(((100 * (delta_total - delta_idle)) / delta_total))
    fi

    printf '%s%%' "$cpu"
  '';

  # Fuzzy-find the pane's scrollback and park copy mode on the chosen line.
  scrollbackSearch = pkgs.writeShellScript "tmux-scrollback-search.sh" ''
    set -eu
    # display-popup does not expand formats in its command, and a popup is not a
    # pane, so the active pane is still the one the popup covers.
    pane="$(tmux display-message -p '#{pane_id}')"
    scrollback="$(mktemp)"
    trap 'rm -f "$scrollback"' EXIT

    tmux capture-pane -p -S - -t "$pane" > "$scrollback"

    selection=$(
      nl -ba "$scrollback" | fzf \
        --ansi \
        --no-sort \
        --exact \
        --tac \
        --delimiter='\t' \
        --with-nth=2.. \
        --preview "bat --color=always --decorations=never --highlight-line {1} $scrollback" \
        --preview-label 'Scrollback Buffer (Search Result Highlighted)' \
        --preview-window 'up,80%,border-rounded,+{1}/2' \
        --bind 'ctrl-c:abort' \
        --bind 'ctrl-b:preview-half-page-up' \
        --bind 'ctrl-f:preview-half-page-down'
    ) || exit 0

    line_no="$(printf '%s\n' "$selection" | cut -f1 | tr -d ' ')"

    # goto-line counts from the top of the visible screen, so walk down from the
    # oldest line instead, which is where capture-pane starts counting.
    tmux copy-mode -t "$pane"
    tmux send-keys -X -t "$pane" history-top
    if [ "$line_no" -gt 1 ]; then
      tmux send-keys -X -t "$pane" -N "$((line_no - 1))" cursor-down
    fi
  '';

  # tmux-continuum has no timer of its own: it prepends a `#()` to status-right
  # when the plugin loads and lets the status line tick drive the save.
  # home-manager emits plugins before extraConfig, so the status-right set
  # below would drop that and auto-save would silently stop. Call the script
  # from our own status-right instead — it writes the state and prints nothing.
  continuumSave = "${pkgs.tmuxPlugins.continuum}/share/tmux-plugins/continuum/scripts/continuum_save.sh";
in {
  options = {tmux.enable = lib.mkEnableOption "enables tmux module";};

  config = lib.mkIf config.tmux.enable {
    # Tmux - Terminal multiplexer. Each worktree gets its own window.
    programs.tmux = {
      enable = true;
      mouse = true;
      keyMode = "vi";
      # Default is 500ms, which shows up as a lag on <Esc> in nvim.
      escapeTime = 10;
      historyLimit = 50000;
      shortcut = "a";
      # Windows start at 1 so Alt+1..9 covers every window.
      baseIndex = 1;
      disableConfirmationPrompt = true;
      # The multiplexer-sidebar pane only redraws on a focus change if tmux
      # reports one.
      focusEvents = true;

      plugins = [
        {
          plugin = pkgs.tmuxPlugins.resurrect;
          extraConfig = ''
            # Scrollback is restored with the pane, which is the part worth
            # having back: what an agent printed before the reboot.
            set -g @resurrect-capture-pane-contents 'on'
          '';
        }
        {
          plugin = pkgs.tmuxPlugins.continuum;
          extraConfig = ''
            set -g @continuum-save-interval '15'
            # Restores the last saved state when the server starts, which is
            # the first time a terminal opens after a boot.
            set -g @continuum-restore 'on'
          '';
        }
      ];

      extraConfig = ''
        # Every binding below, plus the tmux defaults kept as-is and the wt
        # commands, are written out in ./tmux.md. Prefix is C-a. `prefix ?`
        # lists the live bindings if that file drifts.

        set -g default-terminal "tmux-256color"

        # Close window 3 and the old 4 becomes 3, so M-1..M-9 keep matching what
        # the statusline shows instead of leaving a hole.
        set -g renumber-windows on

        # A rebuild only rewrites this file; a server already running keeps the
        # config it started with until it is re-sourced.
        bind R source-file ~/.config/tmux/tmux.conf \; display-message "tmux.conf reloaded"

        # Splits inherit the current directory. v = side by side (as in :vsplit),
        # b = stacked.
        unbind '"'
        unbind %
        bind v split-window -h -c "#{pane_current_path}"
        bind b split-window -v -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"
        bind C-c new-session

        # Were kitty windows before: lazygit in a popup, scrollback search over
        # the pane's own history.
        bind g display-popup -d "#{pane_current_path}" -w 100% -h 100% -E lazygit
        bind f display-popup -w 80% -h 80% -E ${scrollbackSearch}
        bind F display-popup -w 80% -h 80% -E ${filePicker}
        bind e display-popup -w 80% -h 60% -E ${openInNvim}

        # Every session and the coding agents in them, in one list. Upstream
        # binds `new-pane`, which needs tmux 3.8; a popup is the 3.7 equivalent.
        # Below ~72 columns the preview is hidden, hence the 80%.
        bind Tab display-popup -d "#{pane_current_path}" -w 80% -h 80% -E multiplexer-sidebar
        # The sidebar is a real pane, so it stays until it is closed. Swap -l 32
        # for `-l 3 multiplexer-sidebar --compact` to get the narrow strip
        # instead. Upstream binds this to `b`, which splits stacked here.
        bind S split-window -hbf -l 32 -c "#{pane_current_path}" multiplexer-sidebar --sidebar

        bind -r h select-pane -L
        bind -r j select-pane -D
        bind -r k select-pane -U
        bind -r l select-pane -R

        # smart-splits integration: Ctrl moves, Alt resizes. @pane-is-vim is set on
        # the pane by smart-splits' tmux backend while nvim runs there, so the key
        # is handed back to nvim, which walks its own splits first and drives tmux
        # itself once it runs out of them.
        bind -n C-h if -F '#{@pane-is-vim}' "send-keys C-h" "select-pane -L"
        bind -n C-j if -F '#{@pane-is-vim}' "send-keys C-j" "select-pane -D"
        bind -n C-k if -F '#{@pane-is-vim}' "send-keys C-k" "select-pane -U"
        bind -n C-l if -F '#{@pane-is-vim}' "send-keys C-l" "select-pane -R"
        bind -n M-h if -F '#{@pane-is-vim}' "send-keys M-h" "resize-pane -L 3"
        bind -n M-j if -F '#{@pane-is-vim}' "send-keys M-j" "resize-pane -D 3"
        bind -n M-k if -F '#{@pane-is-vim}' "send-keys M-k" "resize-pane -U 3"
        bind -n M-l if -F '#{@pane-is-vim}' "send-keys M-l" "resize-pane -R 3"
        bind -T copy-mode-vi C-h select-pane -L
        bind -T copy-mode-vi C-j select-pane -D
        bind -T copy-mode-vi C-k select-pane -U
        bind -T copy-mode-vi C-l select-pane -R
        bind -n C-Left if -F '#{@pane-is-vim}' "send-keys C-Left" "select-pane -L"
        bind -n C-Down if -F '#{@pane-is-vim}' "send-keys C-Down" "select-pane -D"
        bind -n C-Up if -F '#{@pane-is-vim}' "send-keys C-Up" "select-pane -U"
        bind -n C-Right if -F '#{@pane-is-vim}' "send-keys C-Right" "select-pane -R"
        bind -n M-Left if -F '#{@pane-is-vim}' "send-keys M-Left" "resize-pane -L 3"
        bind -n M-Down if -F '#{@pane-is-vim}' "send-keys M-Down" "resize-pane -D 3"
        bind -n M-Up if -F '#{@pane-is-vim}' "send-keys M-Up" "resize-pane -U 3"
        bind -n M-Right if -F '#{@pane-is-vim}' "send-keys M-Right" "resize-pane -R 3"
        bind -T copy-mode-vi C-Left select-pane -L
        bind -T copy-mode-vi C-Down select-pane -D
        bind -T copy-mode-vi C-Up select-pane -U
        bind -T copy-mode-vi C-Right select-pane -R

        bind -n S-Left previous-window
        bind -n S-Right next-window
        bind -n M-1 select-window -t 1
        bind -n M-2 select-window -t 2
        bind -n M-3 select-window -t 3
        bind -n M-4 select-window -t 4
        bind -n M-5 select-window -t 5
        bind -n M-6 select-window -t 6
        bind -n M-7 select-window -t 7
        bind -n M-8 select-window -t 8
        bind -n M-9 select-window -t 9

        # Vim-like copy/paste. Dropping MouseDragEnd1Pane keeps a mouse selection
        # on screen instead of copying and exiting copy mode on release.
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
        unbind -T copy-mode-vi MouseDragEnd1Pane

        # Statusline, in the style of tmux-dotbar: window list centred, names
        # only, the current one bright and the rest dim; the session name sits
        # on the left and turns into a filled pill while the prefix is held.
        # Colours come from catppuccin as tmux options, so they follow whatever
        # flavor is set above. Styles are written one attribute per `#[]` so no
        # comma ever lands inside a `#{?...}` branch and needs escaping.
        set -g status-position top
        set -g status-justify absolute-centre
        # -F because a style is read when set, not expanded at draw time like
        # the format options below.
        set -gF status-style "bg=#{@thm_bg},fg=#{@thm_overlay_0}"
        # Default status-left-length is 10, which would cut the session name off.
        set -g status-left-length 30
        # Both branches are the same width: the pill's edges take the places the
        # padding spaces hold otherwise, so the window list does not shift.
        set -g status-left "#{?client_prefix,#[fg=#{@thm_teal}]#[bg=#{@thm_teal}]#[fg=#{@thm_bg}]#[bold]#S#[nobold]#[bg=#{@thm_bg}]#[fg=#{@thm_teal}],#[fg=#{@thm_overlay_0}] #S }"
        # Default is 15s, which makes the CPU figure feel stuck.
        set -g status-interval 5
        set -g window-status-separator " • "
        # A coding agent in the window reports what it is doing through the
        # @agent-status window option; the hooks that set it live in
        # ~/.config/claude/settings.json. Expanded with #{E:} so the three-way
        # test is written once instead of once per window format.
        set -g @agent-dot "#{?#{==:#{@agent-status},working},#[fg=#{@thm_yellow}]● ,#{?#{==:#{@agent-status},waiting},#[fg=#{@thm_peach}]● ,#{?#{==:#{@agent-status},done},#[fg=#{@thm_green}]● ,}}}"
        set -g window-status-format " #{E:@agent-dot}#[fg=#{@thm_overlay_0}]#W "
        set -g window-status-current-format " #{E:@agent-dot}#[fg=#{@thm_fg}]#W #{?window_zoomed_flag,#[fg=#{@thm_blue}]󰊓,}"
        set -g status-right "#(${continuumSave})#[fg=#{@thm_lavender}] #(${cpuMem} cpu) #[fg=#{@thm_overlay_0}]│ #[fg=#{@thm_lavender}] #(${cpuMem} mem) "

        # -F because these are read as a colour and a style when set, not as a
        # format at draw time like the statusline options above.
        set -gF clock-mode-colour "#{@thm_blue}"
        set -gF mode-style "fg=#{@thm_blue} bg=#{@thm_surface_1} bold"
      '';
    };

    home.packages = [
      pkgs.multiplexer-sidebar # Dashboard of every session and the coding agents in them
      (pkgs.writeShellApplication {
        name = "wt";
        runtimeInputs = [pkgs.git pkgs.tmux pkgs.gawk];
        text = builtins.readFile ./wt.sh;
      })
    ];
  };
}
