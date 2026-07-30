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
    environment.systemPackages = [
      pkgs.nautilus
      pkgs.gnome-disk-utility
      pkgs.xwayland-satellite
    ];

    security.polkit.enable = true;
    programs.partition-manager.enable = true;

    systemd.user.services.plasma-polkit-agent = {
      description = "KDE PolicyKit Authentication Agent";
      wantedBy = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
        Restart = "on-failure";
        Slice = "background.slice";
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
