{ ... }: {
  imports = [ ./hardware-configuration.nix ../common.nix ];

  networking.hostName = "Kumiko";

  docker.enable = true;
  thunar.enable = true;
}
