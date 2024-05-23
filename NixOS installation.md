1. Become root
```bash
sudo -i
```
2. Set keyboard layout
```bash
loadkeys sv-latin1
```
3. Partitions
```bash
parted /dev/vda -- mklabel gpt
parted /dev/vda -- mkpart primary 512MiB -8GiB
parted /dev/vda -- mkpart primary linux-swap -8GiB 100%
parted /dev/vda -- mkpart ESP fat32 1MiB 512MiB
parted /dev/vda -- set 3 esp on
mkfs.ext4 -L nixos /dev/vda1
mkswap -L swap /dev/vda2
mkfs.fat -F 32 -n boot /dev/vda3
```
4. Mount root and boot. Turn on swap.
```bash
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
swapon /dev/vda2
```
5. Generate NixOS default and hardware config
```bash
nixos-generate-config --root /mnt
```
6. Edit /mnt/etc/nixos/configuration.nix and change the user + enable networkmanager.
7. Install NixOS
```bash
nixos-install
```
8. Reboot
9. Pull custom NixOS config