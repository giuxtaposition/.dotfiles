{ pkgs, inputs, ... }: {
  imports = [ ./hardware-configuration.nix ../common ];
  networking.hostName = "Kumiko";
}
