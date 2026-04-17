{
  lib,
  config,
  pkgs,
  ...
}: {
  options.niri.enable = lib.mkEnableOption "enables niri wm module";

  config = lib.mkIf config.niri.enable {
    programs.niri = {
      enable = true;
      useNautilus = true;
    };
    xdg.portal.extraPortals = with pkgs; [xdg-desktop-portal-gtk];
    services.gnome.gnome-keyring.enable = true;

    environment.systemPackages = [
      pkgs.nautilus
      pkgs.gnome-disk-utility
      pkgs.ghostty
      pkgs.xwayland-satellite
    ];

    systemd = {
      packages = [pkgs.kdePackages.polkit-kde-agent-1];
      user.services.plasma-polkit-agent = {
        wantedBy = ["graphical-session.target"];
        after = ["graphical-session.target"];
      };
    };

    services.greetd = {
      enable = true;
      settings = {
        default_session.command = toString [
          (lib.getExe pkgs.tuigreet)
          "--time"
        ];
      };
    };
  };
}
