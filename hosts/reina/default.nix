{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../common.nix
    ../../modules/nixos/thunar.nix
    ../../modules/nixos/steam.nix
    ../../modules/nixos/ddcutil.nix
    ../../modules/nixos/docker.nix
  ];

  networking.hostName = "Reina";

  services.xserver.videoDrivers = [ "nouveau" ];

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
        nvidia-vaapi-driver
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
      setLdLibraryPath = true;
    };

    nvidia = {
      open = true;
      modesetting.enable = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      forceFullCompositionPipeline = true;
      powerManagement.enable = true;
    };
  };
}
