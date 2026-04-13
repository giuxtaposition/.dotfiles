{...}: {
  imports = [./hardware-configuration.nix ../common.nix ../desktop.nix];

  networking.hostName = "Asuka";

  # Framework
  hardware.framework.amd-7040.preventWakeOnAC = true;
  # Firmware update: need to run `fwupdmgr update` from terminal
  # after reboot run `sudo fprintd-enroll $USER` to enroll fingerprint

  docker.enable = true;
  fish.enable = true;
  amdgpu.enable = true;
  laptop.enable = true;
}
