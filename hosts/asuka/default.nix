{ ... }: {
  imports = [ ./hardware-configuration.nix ../common.nix ];

  networking.hostName = "Asuka";

  docker.enable = true;
  thunar.enable = true;
  fish.enable = true;
}
