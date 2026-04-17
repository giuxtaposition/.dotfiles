{
  lib,
  config,
  ...
}: {
  options.avahi.enable = lib.mkEnableOption "enables avahi mDNS";

  config = lib.mkIf config.avahi.enable {
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
