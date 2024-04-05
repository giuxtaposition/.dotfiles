{ pkgs, lib, config, ... }: {

  options = { ddcutil.enable = lib.mkEnableOption "enables ddcutil module"; };

  config = lib.mkIf config.ddcutil.enable {

    # Monitor brighthness control
    hardware.i2c.enable = true;
    services.udev.extraRules = ''
      KERNEL=="i2c-[0-9]*", GROUP="ddc", MODE="0660", PROGRAM="${pkgs.ddcutil}/bin/ddcutil --bus=%n getvcp 0x10"
    '';

    users.groups.ddc = { };
    users.users.cmp = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "ddc" ];
    };

    environment = { systemPackages = with pkgs; [ ddcutil ddcui ]; };
  };
}
