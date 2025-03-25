{...}: {
  imports = [./hardware-configuration.nix ../common.nix];

  networking.hostName = "Kumiko";

  fish.enable = true;
  jellyfin.enable = true;
}
