# Giuxtaposition's dotfiles 💜

This is a collection of my configuration files.

_Warning_: Don’t blindly use my settings unless you know what that entails. Use at your own risk!

Here are some details about my setup:

- **OS**: [NixOs](https://github.com/NixOS/nixpkgs)
- **Shell**: [Fish](https://github.com/fish-shell/fish-shell)
- **Terminal**: [Kitty](https://github.com/kovidgoyal/kitty)
- **Editor**: [Neovim](https://github.com/neovim/neovim/)
- **WM**: [Niri](https://github.com/YaLTeR/niri)
- **Widgets**: [Noctalia-shell](https://github.com/noctalia-dev/noctalia-shell)

![](/.github/images/screenshot1.png)

## NixOS Installation Guide

### Partitioning (UEFI)

```bash
parted /dev/sda -- mklabel gpt # create GPT partition table
parted /dev/sda -- mkpart primary 512MB -8GB # add the root partition, this will fill the disk except for the end part, where the swap will live and space left in front will be used by the boot partition
parted /dev/sda -- mkpart primary linux-swap -8GB 100% # add swap partition
# Setup the boot partition. NixOS by default uses the ESP (EFI system partition) as its /boot partition. It uses the initially reserved 512MiB at the start of the disk.
parted /dev/sda -- mkpart ESP fat32 1MB 512MB
parted /dev/sda -- set 3 esp on
mkfs.ext4 -L nixos /dev/sda1 # for initialising ext4 partition
mkswap -L swap /dev/sda2 # for creating swap partitions
mkfs.fat -F 32 -n boot /dev/sda3 # for creating boot partition

```

Result:

- /dev/sda1
  - label: nixos
  - size: remaining size after boot and swap partitions has been set
- /dev/sda2
  - label: swap
  - size: 8GiB
- /dev/sda3
  - label: boot
  - size: 512MiB

### Installation (UEFI)

#### Mount system

```bash
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
swapon /dev/sda2
```

#### Generate and Install config

```bash
nixos-generate-config --root /mnt # generate default configuration
nix-env -iA nixos.git # install git
git clone https://github.com/giuxtaposition/.dotfiles /home/giu/.dotfiles
cd /home/giu/.dotfiles
cp /mnt/etc/nixos/hardware-configuration.nix ./nixos # copy generated hardware-configuration
nixos-install --flake .#reina
```

### Update and rebuild config

```bash
nix flake update # to update the flake.lock file (packages versions)
sudo nixos-rebuild switch --flake .#reina # update and rebuild nixos config
home-manager switch --flake .#giu@reina # update and rebuild home-manager config
```

## Secrets Management

Secrets are managed with [sops-nix](https://github.com/Mic92/sops-nix) using [age](https://github.com/FiloSottile/age) encryption.
Encrypted secrets live in `secrets/secrets.yaml` and are decrypted at NixOS activation time to `/run/secrets/<name>`.

### Initial setup (per host)

1. Generate an age key on the target machine:

```bash
sudo mkdir -p /var/lib/sops-nix
sudo age-keygen -o /var/lib/sops-nix/key.txt
```

The public key is printed to stderr — copy it.

2. Add the public key to `secrets/.sops.yaml`:

```yaml
keys:
  - &kumiko age1abc123...

creation_rules:
  - path_regex: secrets\.yaml$
    key_groups:
      - age:
          - *kumiko
```

3. Create or edit the encrypted secrets file (requires `sops` and `age` in your shell, available via `nix develop`):

```bash
sops secrets/secrets.yaml
```

This opens your `$EDITOR` with the decrypted YAML. Add secrets using path-style keys:

```yaml
vpn:
  protonvpn:
    env-file: |
      OPENVPN_USER=username+pmp
      OPENVPN_PASSWORD=password
```

Save and close — sops encrypts the file automatically.

### Using secrets in modules

Reference secrets in NixOS modules via `config.sops.secrets`:

```nix
# Declare the secret
sops.secrets."vpn/protonvpn/env-file" = {};

# Use the decrypted path
environmentFiles = [
  config.sops.secrets."vpn/protonvpn/env-file".path
];
```

Secrets are decrypted to `/run/secrets/<name>` with `0400 root:root` by default.
To grant access to a service user, set the `owner` field:

```nix
sops.secrets."services/paperless/admin-password" = {
  owner = "paperless";
};
```

### Adding a new host

When adding a new server that needs secrets:

1. Generate an age key on the host (step 1 above)
2. Add the new public key to `secrets/.sops.yaml` under `keys` and the relevant `creation_rules`
3. Re-encrypt existing secrets so the new host can decrypt them:

```bash
sops updatekeys secrets/secrets.yaml
```

4. Enable the secrets module in the host config:

```nix
secrets.enable = true;
```
