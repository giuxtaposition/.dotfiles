{
  lib,
  config,
  ...
}: {
  options = {work.enable = lib.mkEnableOption "enables work module";};

  config = lib.mkIf config.work.enable {
    networking.extraHosts = ''
      127.0.0.1   calc-local.vitesicure.it
      127.0.0.1   calc-local.bridgebroker.it
      127.0.0.1   calc-local.viteprotette.it
      127.0.0.1   api-v2-local.vitesicure.it
      127.0.0.1   api-v2-local.bridgebroker.it
      127.0.0.1   api-v2-local.viteprotette.it
    '';
  };
}
