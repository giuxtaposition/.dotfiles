{ pkgs, lib, config, ... }: {

  options = { amdgpu.enable = lib.mkEnableOption "enables amdgpu module"; };

  config = lib.mkIf config.amdgpu.enable {

    hardware.amdgpu = {
      initrd.enable = true;
      opencl.enable = true;
      amdvlk = {
        enable = true;
        support32Bit.enable = true;
      };
    };

    # HARDWARE ACCELERATION
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        libvdpau-va-gl
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [ intel-vaapi-driver ];
    };

    environment.sessionVariables = {
      VDPAU_DRIVER = "radeonsi";
      LIBVA_DRIVER_NAME = "radeonsi";
    };
  };
}
