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

  # Document management
  paperless.enable = true;

  # Photo management
  immich.enable = true;

  # VPN + torrent downloading
  vpn.enable = true;

  fish.enable = true;
  amdgpu.enable = true;

  services.dst-server = {
    enable = true;

    cluster = {
      name = "Giuxtaposition Survival Madness";
      description = "Giuxtaposition Survival Madness";
      maxPlayers = 8;
      pvp = false;
      gameMode = "endless";
      key = "giuxtaposition-survival-madness-shard-key";
    };
  };

  # Power schedule: wake at 8am, shut down at 11pm
  systemd.services.scheduled-poweroff = {
    description = "Set RTC wake alarm for 8am and power off";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "poweroff-with-wake" ''
        ${pkgs.util-linux}/bin/rtcwake -m no -t $(${pkgs.coreutils}/bin/date -d "tomorrow 08:00" +%s)
        /run/current-system/sw/bin/systemctl poweroff
      '';
    };
  };

  systemd.timers.scheduled-poweroff = {
    description = "Shut down kumiko at 11pm daily";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "*-*-* 23:00:00";
      Persistent = true;
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
