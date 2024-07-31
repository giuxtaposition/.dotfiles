{ ... }: {
  imports = [ ./hardware-configuration.nix ../common.nix ];

  networking.hostName = "Kumiko";

  thunar.enable = true;
  fish.enable = true;
  jellyfin.enable = true;
}
