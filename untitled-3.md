# UUID=2a64514c-8f1a-49dd-814b-2730433f5155 LABEL=arch@btrfs
/dev/vda2           	/         	btrfs     	rw,relatime,discard=async,space_cache=v2,subvolid=256,subvol=/@	0 0

# UUID=2a64514c-8f1a-49dd-814b-2730433f5155 LABEL=arch@btrfs
/dev/vda2           	/home     	btrfs     	rw,relatime,discard=async,space_cache=v2,subvolid=257,subvol=/@home	0 0

# UUID=2a64514c-8f1a-49dd-814b-2730433f5155 LABEL=arch@btrfs
/dev/vda2           	/var/cache/pacman/pkg	btrfs     	rw,relatime,discard=async,space_cache=v2,subvolid=259,subvol=/@pkg	0 0

# UUID=2a64514c-8f1a-49dd-814b-2730433f5155 LABEL=arch@btrfs
/dev/vda2           	/var/log  	btrfs     	rw,relatime,discard=async,space_cache=v2,subvolid=258,subvol=/@log	0 0

# UUID=2a64514c-8f1a-49dd-814b-2730433f5155 LABEL=arch@btrfs
/dev/vda2           	/.snapshots	btrfs     	rw,relatime,discard=async,space_cache=v2,subvolid=260,subvol=/@.snapshots	0 0

# UUID=2a64514c-8f1a-49dd-814b-2730433f5155 LABEL=arch@btrfs
/dev/vda2           	/swap     	btrfs     	rw,relatime,discard=async,space_cache=v2,subvolid=263,subvol=/@swap	0 0

# UUID=2DBB-8598 LABEL=efi@fat32
/dev/vda1           	/boot     	vfat      	rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=ascii,shortname=mixed,utf8,errors=remount-ro	0 2

/swap/swapfile      	none      	swap      	defaults  	0 0
