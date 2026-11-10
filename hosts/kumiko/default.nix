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

  # Power schedule: power off at midnight, firmware RTC alarm wakes at 8am.
  #
  # S3 suspend keeps the USB ports partially powered, so the external Fantec
  # bay holding /media never sees a clean off->on and stays down after resume
  # ("usb 3-3: USB disconnect" with no re-enumeration), leaving /media dead
  # until the bay is power-cycled by hand. A full poweroff drops port power and
  # the bay comes back every morning.
  #
  # rtcwake's one-shot alarm from S5 occasionally missed a night, which is why
  # this used to suspend instead. The wake is now owned by the BIOS "Power On
  # By RTC Alarm" (daily, 08:00) — the OS must not touch the RTC alarm register
  # or it clobbers that repeat, so there is no rtcwake call here any more.
  systemd.services.scheduled-poweroff = {
    description = "Power off with BIOS RTC alarm waking at 8am";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "poweroff-at-midnight" ''
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

        echo "Powering off..."
        systemctl poweroff
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
