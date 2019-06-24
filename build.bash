set -x

disk_image="${1}"
wget http://boot.ipxe.org/ipxe.iso

export LIBGUESTFS_DEBUG=1 LIBGUESTFS_TRACE=1
guestfish --add file://${CI_PROJECT_DIR}/ipxe.iso \
<<_EOF_
run
sparse ${disk_image} 4M
part-disk /dev/sda gpt
part-set-bootable /dev/sda 1 true
mkfs ext4 /dev/sda1
mount /dev/sda1 /
mkdir /media
mount /dev/sdb  /media
mkdir /boot
cp /media/ipxe.krn /boot
copy-in /usr/share/syslinux/mbr.bin /boot
copy-in syslinux.cfg /boot
extlinux /boot
ls /boot
pwrite-device /dev/sda /boot/mbr.bin 0

umount /media
rmdir /media
_EOF_