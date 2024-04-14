# Giuxtaposition's dotfiles 💜

This is a collection of my configuration files.

_Warning_: Don’t blindly use my settings unless you know what that entails. Use at your own risk!

Here are some details about my setup:

- **OS**: [NixOs](https://github.com/NixOS/nixpkgs)
- **Shell**: [Fish](https://github.com/fish-shell/fish-shell)
- **Terminal**: [Wezterm](https://github.com/wez/wezterm)
- **Editor**: [Neovim](https://github.com/neovim/neovim/)
- **WM**: [SwayFX](https://github.com/WillPower3309/swayfx)
- **Widgets**: [Eww](https://github.com/elkowar/eww)
- **Notify Daemon**: [Dunst](https://github.com/dunst-project/dunst)

![](/.github/images/screenshot1.png)
![](/.github/images/screenshot2.png)

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
nixos-install --flake .#kumiko
```

### Update and rebuild config

```bash
nix flake update # to update the flake.lock file (packages versions)
sudo nixos-rebuild switch --flake .#kumiko # update and rebuild nixos config
home-manager switch --flake .#giu@kumiko # update and rebuild home-manager config
```
