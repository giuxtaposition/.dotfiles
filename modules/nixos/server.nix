# Server base configuration — headless, hardened, minimal
{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {server.enable = lib.mkEnableOption "server base configuration (headless, nftables, SSH hardening)";};

  config = lib.mkIf config.server.enable {
    # Firewall — always enabled with nftables backend
    networking.firewall.enable = true;
    networking.nftables.enable = true;

    # SSH hardening
    services.openssh = {
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        KbdInteractiveAuthentication = false;
      };
    };

    # Headless packages
    environment.systemPackages = with pkgs; [
      vim
      tmux
      ncdu
      iotop
      lsof
    ];

    # Disable suspend/sleep on servers
    systemd.targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };
  };
}
