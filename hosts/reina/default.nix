{...}: {
  imports = [./hardware-configuration.nix ../common.nix];

  networking.hostName = "Reina";

  docker.enable = true;
  steam.enable = true;
  fish.enable = true;
  amdgpu.enable = true;

  services.hardware.openrgb.enable = true;
  services.fwupd.enable = true;
}
