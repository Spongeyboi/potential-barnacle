### USB Burn
` cdrecord dev=/dev/sr0 install-amd64-minimal-20141204.iso `

### Disable Secure Boot

### Insert USB

### Update Keys
pacman -Sy --noconfirm archlinux-keyring
/usr/bin/localectl --no-pager list-keymaps
/usr/bin/localectl set-keymap uk

### Connect via SSH (make it easier)
passwd
ssh root@IP_ADDRESS

### Setup reflector
reflector -c GB,Germany,France -p https --latest 10 -a 2 --sort rate --save /etc/pacman.d/mirrorlist

reflector -c GB -p https --latest 10 -a 2 --sort rate --save /etc/pacman.d/mirrorlist
### Setup Disk Partition
cgdisk /dev/vda

EFI partition 1G Label efi@partition
ALL partition END Label arch@partition

### Setup Filesystems
mkfs.vfat -F32 -n efi@fat32 /dev/vda1
mkfs.btrfs -L arch@btrfs /dev/vda2

### BTRFS Subvolumes

mount --mkdir /dev/vda2 /mnt/arch_btrfs

btrfs subvolume create /mnt/arch_btrfs/@
btrfs subvolume create /mnt/arch_btrfs/@home
btrfs subvolume create /mnt/arch_btrfs/@log
btrfs subvolume create /mnt/arch_btrfs/@pkg
btrfs subvolume create /mnt/arch_btrfs/@.snapshots

btrfs subvolume create /mnt/arch_btrfs/@flatpak
btrfs subvolume create /mnt/arch_btrfs/@tmp

btrfs subvolume create /mnt/arch_btrfs/@swap

btrfs subvolume create /mnt/arch_btrfs/do_not_snapshot
btrfs subvolume create /mnt/arch_btrfs/do_not_snapshot/@downloads
btrfs subvolume create /mnt/arch_btrfs/do_not_snapshot/@.cache
btrfs subvolume create /mnt/arch_btrfs/do_not_snapshot/@steam

umount /mnt/arch_btrfs

### Mount Subvolumes

mount -m -o subvol=@ /dev/vda2 /mnt/arch
mount -m -o subvol=@home /dev/vda2 /mnt/arch/home
mount -m -o subvol=@pkg /dev/vda2 /mnt/arch/var/cache/pacman/pkg
mount -m -o subvol=@log /dev/vda2 /mnt/arch/var/log
mount -m -o subvol=@.snapshots /dev/vda2 /mnt/arch/.snapshots

mount -m -o subvol=@swap /dev/vda2 /mnt/arch/swap

btrfs filesystem mkswapfile --size 1g --uuid clear /mnt/arch/swap/swapfile
swapon /mnt/arch/swap/swapfile

btrfs subvolume list -a /mnt/arch

mount -m /dev/vda1 /mnt/arch/boot

### Install core packages
pacstrap -K /mnt/arch base base-devel linux-zen linux-zen-headers linux-firmware amd-ucode neovim nano btrfs-progs util-linux unzip kitty sudo man man-db texinfo tldr reflector git neofetch btop pipewire zsh firefox limine


pacstrap -K /mnt/arch base base-devel linux-zen linux-zen-headers linux-firmware amd-ucode neovim nano btrfs-progs util-linux sudo man man-db texinfo tldr reflector neofetch btop limine

arch-chroot /mnt/arch locale-gen
arch-chroot /mnt/arch chmod 700 /root
arch-chroot /mnt/arch mkinitcpio -P

pacstrap -K /mnt/arch hyprland dunst kitty dolphin wofi xdg-desktop-portal-hyprland qt5-wayland qt6-wayland --noconfirm

arch-chroot /mnt/arch systemctl enable polkit

pacstrap -K /mnt/arch xorg-server xorg-xinit mesa xf86-video-amdgpu xf86-video-ati xf86-video-nouveau xf86-video-vmware libva-mesa-driver libva-intel-driver intel-media-driver vulkan-radeon vulkan-intel --noconfirm

arch-chroot /mnt/arch useradd -m -G wheel openbsd
arch-chroot /mnt/arch sh -c 'echo openbsd:pikachu | chpasswd'

pacstrap -K /mnt/arch pipewire pipewire-alsa pipewire-jack pipewire-pulse gst-plugin-pipewire libpulse wireplumber --noconfirm
/usr/bin/arch-chroot /mnt/arch su - o -c 'systemctl enable --user pipewire-pulse.service'

### Copy Newtork Configuration
cp -r -t /mnt/arch/etc/systemd/ /etc/systemd/network.conf.d/* /etc/systemd/network/* /etc/systemd/resolved.conf.d/*

genfstab -L /mnt/arch >> /mnt/arch/etc/fstab

mkdir -p /mnt/arch/boot/EFI/BOOT
cp /mnt/arch/usr/share/limine/BOOTX64.EFI /mnt/arch/boot/EFI/BOOT

### Arch-chroot
arch-chroot /mnt/arch

### Setup

ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
hwclock --systohc
echo -e "en_IE.UTF-8 UTF-8\nen_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_IE.UTF-8" >> /etc/locale.conf
echo "KEYMAP=uk" >> /etc/vconsole.conf
echo "openbsd" >> /etc/hostname

echo -e "TIMEOUT=5\n\n:Arch Linux (Zen Kernel)\n\tPROTOCOL=linux\n\tKERNEL_PATH=boot:///vmlinuz-linux-zen\n\tCMDLINE=root=LABEL=arch@btrfs rootflags=subvol=@ rw rootfstype=btrfs\n\tMODULE_PATH=boot:///initramfs-linux-zen.img\n\n:Arch Linux (Fallback Zen Kernel)\n\tPROTOCOL=linux\n\tKERNEL_PATH=boot:///vmlinuz-linux-zen\n\tCMDLINE=root=LABEL=arch@btrfs rootflags=subvol=@ rw rootfstype=btrfs\n\tMODULE_PATH=boot:///initramfs-linux-zen-fallback.img" >> /boot/limine.cfg

TIMEOUT=5

:Arch Linux (Zen Kernel)
    PROTOCOL=linux
    KERNEL_PATH=boot:///vmlinuz-linux-zen
    CMDLINE=root=LABEL=arch@btrfs rootflags=subvol=@ rw rootfstype=btrfs
    MODULE_PATH=boot:///initramfs-linux-zen.img

:Arch Linux (Fallback Zen Kernel)
    PROTOCOL=linux
    KERNEL_PATH=boot:///vmlinuz-linux-zen
    CMDLINE=root=LABEL=arch@btrfs rootflags=subvol=@ rw rootfstype=btrfs
    MODULE_PATH=boot:///initramfs-linux-zen-fallback.img


passwd

### Setup Limine with LABELS

mkinitcpio -P
systemctl enable systemd-network
systemctl enable systemd-resolved
systemctl start systemd-network
systemctl start systemd-resolved

## Uncomment wheel in /etc/sudoers

exit

reboot


### Other
Dash for running shell scripts
ZSH for bash scripts
ZSH for user shell