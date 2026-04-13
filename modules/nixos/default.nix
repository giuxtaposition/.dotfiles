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

  # Server modules
  server = import ./server.nix;
  secrets = import ./secrets.nix;

  # Service modules (server)
  media = import ./services/media.nix;
  paperless = import ./services/paperless.nix;
  immich = import ./services/immich.nix;
  vpn = import ./services/vpn.nix;
  triliumnext = import ./services/triliumnext.nix;
}
