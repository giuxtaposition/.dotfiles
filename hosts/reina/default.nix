{ ... }: {
  imports = [ ./hardware-configuration.nix ../common.nix ];

  networking.hostName = "Reina";

  ddcutil.enable = true;
  docker.enable = true;
  steam.enable = true;
  thunar.enable = true;
  fish.enable = true;
  amdgpu.enable = true;
  jellyfin.enable = true;
}
