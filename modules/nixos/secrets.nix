# sops-nix secrets management
#
# Setup workflow:
#   1. Generate age key on host:
#      age-keygen -o /var/lib/sops-nix/key.txt
#      (prints public key to stderr — add it to secrets/.sops.yaml)
#
#   2. Add public key to secrets/.sops.yaml creation_rules
#
#   3. Create/edit secrets:
#      sops secrets/secrets.yaml
#
#   4. Secrets are decrypted at activation to /run/secrets/<name>
#      with restricted permissions (0400 root:root by default)
{
  lib,
  config,
  ...
}: {
  options = {secrets.enable = lib.mkEnableOption "sops-nix secrets management";};

  config = lib.mkIf config.secrets.enable (lib.mkMerge [
    {
      sops.age.keyFile = "/var/lib/sops-nix/key.txt";
    }
    (lib.mkIf (builtins.pathExists ../../secrets/secrets.yaml) {
      sops.defaultSopsFile = ../../secrets/secrets.yaml;
    })
  ]);
}
