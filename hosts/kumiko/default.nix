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

  # E-book library
  calibre.enable = true;

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

  # Power schedule: power off at midnight, RTC wake at 8am.
  #
  # Must be S5, not S3: suspend keeps the USB ports powered, and the external
  # Fantec bay holding /media and /docs idles itself off partway through the
  # night. On resume its JMicron bridge is simply gone from the bus and never
  # re-enumerates, so both filesystems stay dead until the bay's power button
  # is pressed by hand. The bay only restarts on a real power cycle, which is
  # what S5 gives it — verified by waking from S5 with the bay coming back on
  # its own 5s into the boot.
  #
  # The bay must stay on a bus 3 port. On bus 2 it does not come back from S5.
  systemd.services.scheduled-poweroff = {
    description = "Power off with RTC wake alarm for 8am";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "poweroff-with-wake" ''
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

        # -m off sets the alarm and then calls shutdown itself, unlike the
        # 06e5515 predecessor of this service, which set the alarm with -m no
        # and ran a separate systemctl poweroff. Keeping the two steps in one
        # command shrinks the window in which the alarm can be clobbered.
        #
        # The 8h lead time matters: the alarm has to outlast the shutdown, and
        # unmounting the bay can be slow. A short alarm fires mid-shutdown, is
        # consumed, and the machine then stays off.
        echo "Powering off with RTC wake at 08:00..."
        ${pkgs.util-linux}/bin/rtcwake \
          -m off \
          -t $(${pkgs.coreutils}/bin/date -d "today 08:00" +%s)
      '';
    };
  };

  systemd.timers.scheduled-poweroff = {
    description = "Power off kumiko at midnight daily";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "*-*-* 00:00:00";
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
