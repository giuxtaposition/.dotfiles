{
  ddcutil = import ./ddcutil.nix;
  docker = import ./docker.nix;
  steam = import ./steam.nix;
  thunar = import ./thunar.nix;
  fish = import ./fish.nix;
  media_server = import ./media-server.nix;
  amdgpu = import ./amdgpu.nix;
  network = import ./network.nix;
  niri = import ./niri.nix;
  bluetooth = import ./bluetooth.nix;
  homelab = import ./homelab.nix;
}
