{
  lib,
  config,
  ...
}: {
  options = {amdgpu.enable = lib.mkEnableOption "enables amdgpu module";};

  config = lib.mkIf config.amdgpu.enable {
    hardware = {
      amdgpu = {
        initrd.enable = true;
        opencl.enable = true;
      };

      graphics = {
        enable = true;
        enable32Bit = true;
      };
    };

    services.libinput = {
      enable = true;
    };
  };
}
