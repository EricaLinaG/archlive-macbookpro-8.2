all: iso

iso:
	mkarchiso -v -w /tmp/archiso-tmp archlive

# Archiso comes with two profiles, releng and baseline.

# - releng is used to create the official monthly installation ISO.
#      It can be used as a starting point for creating a customized ISO image.
# - baseline is a minimalistic configuration, that includes only the bare
#      minimum packages required to boot the live environment from the medium.

# To build an unmodified version of the profiles, skip to #Build the ISO. Otherwise, if you wish to adapt or customize one of archiso's shipped profiles, copy it from /usr/share/archiso/configs/profile-name/ to a writable directory with a name of your choice. For example:

fresh-releng:
	cp -r /usr/share/archiso/configs/releng/ archlive

fresh-baseline:
	cp -r /usr/share/archiso/configs/baseline/ archlive

inject-install-script:
	cp ~/Arch-Setup/install-arch archlive/airootfs/ \
             chmod a+x archlive/airootfs/arch-install

# kernel parameters for different computers and boot options
macbook-min-kernel-params := nomodeset radeon.modeset=0
macbook-i915-kernel-parms := nomodeset radeon.modeset=0 \
				i915.modeset=1 i915.lvds_channel_mod=2
mobile-studio-pro-kernel-parms := nomodeset AHCI=0
hp-chromebook-kernel-parms := nomodeset

dd-cmd:
    lsblk
    echo "sudo dd if=out/xxxx.iso of=/dev/sdX bs=1M"

# menuentry "Arch Linux install medium (x86_64, UEFI)" --class arch --class gnu-linux --class gnu --class os --id 'archlinux' {
#     set gfxpayload=keep
#     search --no-floppy --set=root --label %ARCHISO_LABEL%
#     linux /%INSTALL_DIR%/boot/x86_64/vmlinuz-linux archisobasedir=%INSTALL_DIR% archisolabel=%ARCHISO_LABEL% nomodeset
#     initrd /%INSTALL_DIR%/boot/intel-ucode.img /%INSTALL_DIR%/boot/amd-ucode.img /%INSTALL_DIR%/boot/x86_64/initramfs-linux.img
# }
