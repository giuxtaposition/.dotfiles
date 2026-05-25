{
  # Desktop modules
  docker = import ./docker.nix;
  steam = import ./steam.nix;
  thunar = import ./thunar.nix;
  fish = import ./fish.nix;
  amdgpu = import ./amdgpu.nix;
  network = import ./network.nix;
  niri = import ./niri.nix;
  bluetooth = import ./bluetooth.nix;
  tailscale = import ./tailscale.nix;
  laptop = import ./laptop.nix;
  brightness-control-desktop = import ./brightness-control-desktop.nix;

  # Work modules
  work = import ./work.nix;
  avahi = import ./avahi.nix;

  # Server modules
  server = import ./server.nix;
  secrets = import ./secrets.nix;

  # Service modules (server)
  media = import ./services/media.nix;
  paperless = import ./services/paperless.nix;
  immich = import ./services/immich.nix;
  vpn = import ./services/vpn.nix;

  #  # Game server modules
  dst-server = import ./dont_starve_together/dont_starve_together_server.nix;
}
