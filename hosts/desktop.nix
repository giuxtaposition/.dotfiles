# Desktop-specific configuration shared by personal machines (asuka, reina)
{pkgs, ...}: {
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
      timeout = 1;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  network.enable = true;

  users.users.giu.extraGroups = ["video" "audio" "rtkit"];

  programs.dconf.enable = true;

  console = {
    useXkbConfig = true;
    font = "Lat2-Terminus16";
  };

  services = {
    dbus = {
      enable = true;
      packages = [pkgs.dconf];
    };

    libinput.enable = true;

    xserver = {
      enable = true;
      xkb.options = "ctrl:swapcaps";
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    upower.enable = true;

    printing.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    gvfs.enable = true;
  };
  security.rtkit.enable = true;

  hardware = {
    keyboard = {qmk.enable = true;};
  };

  environment.systemPackages = with pkgs; [
    home-manager
    nurl
    xarchiver
    papirus-icon-theme
    xclip
    feh
    gcc
    brightnessctl
    pulseaudio
    pamixer
    libnotify
  ];

  bluetooth.enable = true;
  niri.enable = true;
  programs.kdeconnect.enable = true;
  tailscale.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
