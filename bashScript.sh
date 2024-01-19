
#!/bin/bash

cd &&

pacman -Sy --noconfirm archlinux-keyring &&
/usr/bin/localectl set-keymap uk &&

#reflector --score 10 --sort rate --save /etc/pacman.d/mirrorlist &&

mkfs.vfat -F32 -n efi@fat32 /dev/sda1 &&
mkfs.btrfs -L arch@btrfs /dev/sda2 &&

mount --mkdir /dev/sda2 /mnt/arch_btrfs &&

btrfs subvolume create /mnt/arch_btrfs/@ &&
btrfs subvolume create /mnt/arch_btrfs/@home &&
btrfs subvolume create /mnt/arch_btrfs/@log &&
btrfs subvolume create /mnt/arch_btrfs/@pkg &&
btrfs subvolume create /mnt/arch_btrfs/@.snapshots &&

btrfs subvolume create /mnt/arch_btrfs/@swap &&

umount /mnt/arch_btrfs &&

mount -m -o subvol=@ /dev/sda2 /mnt/arch &&
mount -m -o subvol=@home /dev/sda2 /mnt/arch/home &&
mount -m -o subvol=@pkg /dev/sda2 /mnt/arch/var/cache/pacman/pkg &&
mount -m -o subvol=@log /dev/sda2 /mnt/arch/var/log &&
mount -m -o subvol=@.snapshots /dev/sda2 /mnt/arch/.snapshots &&

mount -m -o subvol=@swap /dev/sda2 /mnt/arch/swap &&

btrfs filesystem mkswapfile --size 18g --uuid clear /mnt/arch/swap/swapfile &&
swapon /mnt/arch/swap/swapfile &&

btrfs subvolume list -a /mnt/arch &&

mount -m /dev/sda1 /mnt/arch/boot &&

pacstrap -K /mnt/arch base base-devel linux-zen linux-zen-headers linux-firmware amd-ucode neovim nano btrfs-progs util-linux unzip kitty sudo man man-db texinfo tldr reflector git neofetch btop pipewire zsh firefox limine &&

x=$(arch-chroot /mnt/arch "locale-gen") &&
x=$(arch-chroot /mnt/arch chmod 700 /root) &&
x=$(arch-chroot /mnt/arch mkinitcpio -P) &&

cp -r -t /mnt/arch/etc/systemd/ /etc/systemd/network* /etc/systemd/resolved* &&

genfstab -L /mnt/arch >> /mnt/arch/etc/fstab &&

mkdir -p /mnt/arch/boot/EFI/BOOT &&
cp /mnt/arch/usr/share/limine/BOOTX64.EFI /mnt/arch/boot/EFI/BOOT &&

ln -sf /mnt/arch/usr/share/zoneinfo/Europe/London /mnt/arch/etc/localtime &&
x=$(arch-chroot /mnt/arch hwclock --systohc) &&
echo -e "en_IE.UTF-8 UTF-8\nen_US.UTF-8 UTF-8" >> /mnt/arch/etc/locale.gen &&
x=$(arch-chroot /mnt/arch locale-gen) &&
echo "LANG=en_IE.UTF-8" >> /mnt/arch/etc/locale.conf &&
echo "KEYMAP=uk" >> /mnt/arch/etc/vconsole.conf &&
echo "openbsd" >> /mnt/arch/etc/hostname &&

x=$(arch-chroot /mnt/arch echo -e "TIMEOUT=1\n\n:Arch Linux (Zen Kernel)\n\tPROTOCOL=linux\n\tKERNEL_PATH=boot:///vmlinuz-linux-zen\n\tCMDLINE=root=LABEL=arch@btrfs rootflags=subvol=@ rw rootfstype=btrfs\n\tMODULE_PATH=boot:///initramfs-linux-zen.img\n\n:Arch Linux (Fallback Zen Kernel)\n\tPROTOCOL=linux\n\tKERNEL_PATH=boot:///vmlinuz-linux-zen\n\tCMDLINE=root=LABEL=arch@btrfs rootflags=subvol=@ rw rootfstype=btrfs\n\tMODULE_PATH=boot:///initramfs-linux-zen-fallback.img" >> /mnt/arch/boot/limine.cfg) &&

x=$(arch-chroot /mnt/arch mkinitcpio -P) &&
x=$(arch-chroot /mnt/arch systemctl enable systemd-networkd) &&
x=$(arch-chroot /mnt/arch systemctl enable systemd-resolved) &&

echo "COMPLETED!!!!!"

arch-chroot /mnt/arch
