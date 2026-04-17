{...}: {
  imports = [./hardware-configuration.nix ../common.nix ../desktop.nix];

  networking.hostName = "Reina";

  docker.enable = true;
  steam.enable = true;
  fish.enable = true;
  amdgpu.enable = true;

  hardware = {
    keyboard = {qmk.enable = true;};
  };

  services.hardware.openrgb.enable = true;
  services.fwupd.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
