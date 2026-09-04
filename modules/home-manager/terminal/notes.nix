{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {notes.enable = lib.mkEnableOption "enables notes module";};

  config = lib.mkIf config.notes.enable {
    systemd.user = {
      # Nicely reload system units when changing configs
      startServices = "sd-switch";

      services = {
        sync-notes = {
          Unit = {Description = "Sync notes with github repo";};
          Service = {
            Type = "oneshot";
            Environment = [
              "PATH=${lib.makeBinPath [pkgs.openssh pkgs.git pkgs.libnotify]}"
              "DBUS_SESSION_BUS_ADDRESS=unix:path=%t/bus"
            ];
            TimeoutStartSec = "5m";
            ExecStart = let
              notesDir = "${config.home.homeDirectory}/notes";
              script = pkgs.writeShellScript "sync-notes" ''
                set -euo pipefail
                if [ ! -d "${notesDir}/.git" ]; then
                  echo "Cloning notes repo"
                  git clone git@github.com:giuxtaposition/notes.git "${notesDir}"
                fi
                cd "${notesDir}"
                echo "Syncing notes"
                git pull --rebase --autostash
                if [ -n "$(git status --porcelain)" ]; then
                  git add .
                  git commit -m "updating notes 📘"
                  git push
                  notify-send "Synced notes"
                fi
              '';
            in "${pkgs.bash}/bin/bash ${script}";
          };
        };
      };

      timers = {
        sync-notes = {
          Unit.Description = "Timer for sync-notes service";
          Timer = {
            Unit = "sync-notes";
            OnBootSec = "1m";
            OnUnitActiveSec = "1h";
          };
          Install.WantedBy = ["timers.target"];
        };
      };
    };

    programs = {
      zk = {
        enable = true;
      };
    };
  };
}
