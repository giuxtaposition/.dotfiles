# IMPORTANT: Replace with output of nixos-generate-config --show-hardware-config on Kumiko
#
# This is a minimal placeholder so the flake evaluates.
# Before first deploy, run on the target machine:
#   nixos-generate-config --show-hardware-config > hosts/kumiko/hardware-configuration.nix
{modulesPath, ...}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };
}
