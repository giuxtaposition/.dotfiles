# Desktop-specific configuration shared by personal machines (asuka, reina)
{pkgs, ...}: {
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

    xserver.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    upower.enable = true;

    printing.enable = true;
    gvfs.enable = true;
  };
  security.rtkit.enable = true;

  environment.systemPackages = with pkgs; [
    home-manager
    xarchiver
    gcc
    brightnessctl
    pulseaudio
    libnotify
  ];

  bluetooth.enable = true;
  niri.enable = true;
  programs.kdeconnect.enable = true;
  tailscale.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
