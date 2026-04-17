{...}: {
  imports = [./hardware-configuration.nix ../common.nix ../desktop.nix];

  networking.hostName = "Asuka";

  # Framework
  hardware.framework.amd-7040.preventWakeOnAC = true;

  # Firmware update: need to run `fwupdmgr update` from terminal
  # after reboot run `sudo fprintd-enroll $USER` to enroll fingerprint

  work.enable = true;
  docker.enable = true;
  fish.enable = true;
  amdgpu.enable = true;
  laptop.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
