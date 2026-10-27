{...}: {
  imports = [./hardware-configuration.nix ../common.nix ../desktop.nix];

  networking.hostName = "Reina";
  networking.extraHosts = ''
    127.0.0.1 db redis es mc
  '';

  avahi.enable = true;
  docker.enable = true;
  steam.enable = true;
  fish.enable = true;
  amdgpu.enable = true;
  llama-server.enable = false;
  work.enable = true;
  brightness-control-desktop.enable = true;

  hardware = {
    keyboard = {qmk.enable = true;};
  };

  services.hardware.openrgb.enable = true;
  services.fwupd.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
