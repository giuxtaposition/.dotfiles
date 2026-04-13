# Kumiko — Home media server
{...}: {
  imports = [./hardware-configuration.nix ../common.nix];

  networking.hostName = "kumiko";

  # Boot — GRUB for server (will be updated after hardware-configuration.nix is generated)
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

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

  system.stateVersion = "25.11";
}
