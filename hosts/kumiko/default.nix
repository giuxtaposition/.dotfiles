# Kumiko — Home media server
{...}: {
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

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
