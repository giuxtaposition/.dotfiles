{
  lib,
  config,
  inputs,
  ...
}: {
  imports = [inputs.cassiopea.homeManagerModules.default];
  options = {
    cassiopea.enable = lib.mkEnableOption "enables cassiopea shell module";
  };

  config = lib.mkIf config.cassiopea.enable {
    programs.cassiopea = {
      enable = true;
    };
  };
}
