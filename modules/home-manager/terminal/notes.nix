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
            Type = "forking";
            Environment = "PATH=${
              lib.makeBinPath [pkgs.openssh pkgs.gawk pkgs.git pkgs.libnotify]
            }";
            ExecStart = let
              script = pkgs.writeShellScript "sync-notes" ''
                echo "Syncing notes"
                git pull --rebase --autostash
                filesChanged=$(git status --porcelain | awk '{print $2}')
                if [ -n "$filesChanged" ]; then
                git add .
                git commit -m "updating notes 📘"
                git push
                notify-send "Synced notes"
                fi
              '';
            in "${pkgs.bash}/bin/bash ${script}";
            WorkingDirectory = "${config.home.homeDirectory}/notes";
          };
          Install.WantedBy = ["default.target"];
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
