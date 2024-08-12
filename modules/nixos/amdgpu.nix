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

  };
}
