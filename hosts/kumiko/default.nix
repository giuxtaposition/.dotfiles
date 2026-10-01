# Kumiko — Home media server
{pkgs, ...}: {
  imports = [./hardware-configuration.nix ../common.nix];

  networking.hostName = "kumiko";

  network.enable = true;
  avahi.enable = true; # mDNS — lets reina reach kumiko via kumiko.local

  # Server base configuration
  server.enable = true;
  tailscale.enable = true;
  secrets.enable = true;

  # Media services
  media.enable = true;

  # Manga library
  suwayomi.enable = true;
  byparr.enable = true;

  # Document management
  paperless.enable = true;

  # Photo management
  immich.enable = true;

  # VPN + torrent downloading
  vpn.enable = true;

  fish.enable = true;
  amdgpu.enable = true;

  services.dst-server = {
    enable = false;

    cluster = {
      name = "Giuxtaposition Survival Madness";
      description = "Giuxtaposition Survival Madness";
      maxPlayers = 8;
      pvp = false;
      gameMode = "endless";
      key = "giuxtaposition-survival-madness-shard-key";
    };
    adminlist = ["KU_2DNgIgiw"];
    mods = [
      {id = "378160973";}
      {id = "2189004162";}
      {id = "2477889104";}
      {id = "3734456345";}
      {id = "1207269058";}
    ];
  };

  # Power schedule: suspend at midnight, RTC wake at 8am
  systemd.services.scheduled-poweroff = {
    description = "Suspend to RAM with RTC wake alarm for 8am";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "suspend-with-wake" ''
        set -e
        echo "Stopping DST caves shard..."
        systemctl stop dst-caves.service || true
        while systemctl is-active --quiet dst-caves.service; do
          sleep 1
        done

        echo "Stopping DST master shard..."
        systemctl stop dst-master.service || true
        while systemctl is-active --quiet dst-master.service; do
          sleep 1
        done

        echo "Suspending with RTC wake at 08:00..."
        ${pkgs.util-linux}/bin/rtcwake \
          -m mem \
          -t $(${pkgs.coreutils}/bin/date -d "today 08:00" +%s)
      '';
    };
  };

  systemd.timers.scheduled-poweroff = {
    description = "Suspend kumiko at midnight daily";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "*-*-* 00:00:00";
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
