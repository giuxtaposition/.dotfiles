# Kumiko — Home media server
{...}: {
  imports = [./hardware-configuration.nix ../common.nix ../desktop.nix];

  networking.hostName = "kumiko";

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

  # Notes
  triliumnext.enable = true;

  # Provide the standard desktop modules used by other hosts.
  fish.enable = true;
  amdgpu.enable = true;
}
