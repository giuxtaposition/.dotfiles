{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ../common.nix
    ../../modules/nixos/thunar.nix
    ../../modules/nixos/docker.nix
  ];

  networking.hostName = "Kumiko";
}
