{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    niri.enable = lib.mkEnableOption "enables niri wm module";

    # Allow system-level definitions for programs.niri.settings so NixOS
    # modules can provide sane defaults for systems without home-manager.
    programs.niri.settings = lib.mkOption {
      type = lib.types.attrs;
      description = "System-level fallback for Niri user settings (merged with user settings).";
      default = {};
    };
  };

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

    # Default bindings for systems that do not set programs.niri.settings
    # via home-manager. We use lib.mkDefault so user/home-manager values
    # override these defaults.
    programs.niri.settings = lib.mkDefault {
      spawn-at-startup = [{command = ["ghostty"];}];
      binds = {
        "Mod+Q".action.spawn = ["ghostty"];
      };
    };

    environment.etc."niri/config.kdl".text = ''
      binds {
        "Mod+Q" {
          spawn "ghostty";
        }
      }
    '';

    system.activationScripts.niri_user_config = {
      text = ''
        if [ -d /home/giu ]; then
          mkdir -p /home/giu/.config/niri
          if [ ! -f /home/giu/.config/niri/config.kdl ]; then
            cp /etc/niri/config.kdl /home/giu/.config/niri/config.kdl
            chown giu:giu /home/giu/.config/niri/config.kdl || true
          fi
        fi
      '';
    };

    systemd = {
      packages = [pkgs.kdePackages.polkit-kde-agent-1];
      # User services provided as a fallback when home-manager doesn't
      # configure user-level Niri settings.
      user.services = {
        plasma-polkit-agent = {
          wantedBy = ["graphical-session.target"];
          after = ["graphical-session.target"];
        };

        niri-terminal = {
          wantedBy = ["graphical-session.target"];
          after = ["graphical-session.target"];
          serviceConfig = {
            # Use doubled-dollar so Nix doesn't try to interpolate $USER; use
            # builtins.toString for the ghostty derivation to avoid linter
            # warnings about unquoted URI expressions.
            ExecStart = ''${pkgs.runtimeShell}/bin/sh -c 'if [ "$${USER:-}" = "giu" ]; then exec "${builtins.toString pkgs.ghostty}/bin/ghostty"; fi' '';
            Restart = "no";
          };
        };
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
