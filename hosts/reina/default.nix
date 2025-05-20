{...}: {
  imports = [./hardware-configuration.nix ../common.nix];

  networking.hostName = "Reina";

  ddcutil.enable = true;
  docker.enable = true;
  steam.enable = true;
  fish.enable = true;
  amdgpu.enable = true;
  media_server.enable = true;

  services.hardware.openrgb.enable = true;
  services.fwupd.enable = true;
}
