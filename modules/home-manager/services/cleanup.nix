{
  config,
  lib,
  pkgs,
  ...
}: let
  script = pkgs.writeShellScript "user-cleanup" ''
    set -u
    log() { echo "[cleanup] $*"; }

    cache_dirs=(
      chromium mozilla JetBrains Cypress ms-playwright puppeteer
      typescript go-build uv phpactor thumbnails fontconfig wine pnpm
    )
    for d in "''${cache_dirs[@]}"; do
      path="$HOME/.cache/$d"
      [ -d "$path" ] || continue
      log "rm $path"
      rm -rf "$path"
    done

    if [ -d "$HOME/.cache/dotslash" ]; then
      log "chmod + rm ~/.cache/dotslash"
      chmod -R u+w "$HOME/.cache/dotslash" 2>/dev/null || true
      rm -rf "$HOME/.cache/dotslash"
    fi

    if [ -d "$HOME/.gradle/caches" ]; then
      log "rm ~/.gradle/caches"
      rm -rf "$HOME/.gradle/caches"
    fi

    if [ -d "$HOME/.npm/_cacache" ]; then
      log "rm ~/.npm/_cacache"
      rm -rf "$HOME/.npm/_cacache"
    fi

    for browser in "$HOME/.mozilla" "$HOME/.zen"; do
      [ -d "$browser" ] || continue
      log "sweep $browser browser caches"
      ${pkgs.findutils}/bin/find "$browser" -type d \
        \( -name cache2 -o -name startupCache -o -name OfflineCache \
           -o -name shader-cache -o -name jumpListCache \) \
        -exec rm -rf {} + 2>/dev/null || true
    done

    if [ -d "$HOME/Programming" ]; then
      log "sweep stale .direnv (>30d) in ~/Programming"
      ${pkgs.findutils}/bin/find "$HOME/Programming" -maxdepth 4 -type d \
        -name .direnv -mtime +30 -exec rm -rf {} + 2>/dev/null || true
    fi

    log "done"
  '';
in {
  options.cleanup.enable = lib.mkEnableOption "weekly user cache and stale .direnv cleanup";

  config = lib.mkIf config.cleanup.enable {
    systemd.user.services.user-cleanup = {
      Unit.Description = "Weekly cleanup of regenerable user caches and stale nix-direnv pins";
      Service = {
        Type = "oneshot";
        ExecStart = "${script}";
      };
    };

    systemd.user.timers.user-cleanup = {
      Unit.Description = "Weekly user cleanup timer";
      Timer = {
        OnCalendar = "weekly";
        Persistent = true;
        RandomizedDelaySec = "30m";
      };
      Install.WantedBy = ["timers.target"];
    };
  };
}
