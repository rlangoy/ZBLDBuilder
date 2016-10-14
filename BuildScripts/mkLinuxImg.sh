#!/bin/sh

distro=$1
loopadapter=loop2
loopmapper=/dev/mapper/$loopadapter
loopdev=/dev/$loopadapter

if [ -z "$1" ]
  then
   distro=jessie
fi

IMAGE_NAME=zedboardImage$distro

sudo umount "$loopdev"p1
sudo umount "$loopdev"p2
sudo kpartx -d $IMAGE_NAME.img
sudo losetup -d "$loopdev"

fallocate -l 512M $IMAGE_NAME.img

fdisk $IMAGE_NAME.img <<EOF
o
p
n
p
1

+16M
t
c
n
p
2


w
EOF

sudo sync
sudo losetup "$loopdev" $IMAGE_NAME.img
sudo kpartx -av "$loopdev"

sudo mkfs.vfat "$loopmapper"p1
sudo mkfs.ext4 "$loopmapper"p2
sudo sync

mkdir $IMAGE_NAME
mkdir $IMAGE_NAME/boot
sudo mount "$loopmapper"p1 $IMAGE_NAME/boot
mkdir $IMAGE_NAME/rootfs
sudo mount "$loopmapper"p2 $IMAGE_NAME/rootfs

./addRootfs.sh $distro
sudo bsdtar -cpf /zedFiles/boot/libs.tar.gz $IMAGE_NAME/rootfs/lib

sudo sync
sudo cp expand-rootfs.sh $IMAGE_NAME/rootfs/home/zed
#sudo cp /zedFiles/boot/boot.bin $IMAGE_NAME/boot
sudo cp /BOOT.BIN $IMAGE_NAME/boot
sudo cp /zedFiles/boot/devicetree.dtb $IMAGE_NAME/boot
sudo cp /zedFiles/boot/uImage $IMAGE_NAME/boot


sudo sync
sudo umount "$loopmapper"p1
sudo umount "$loopmapper"p2
sudo kpartx -d "$loopmapper"p1
sudo kpartx -d "$loopmapper"p2
sudo kpartx -d "$loopdev"

sudo losetup -d "$loopdev"
sudo losetup -d "$loopdev"p1
sudo losetup -d "$loopdev"p2
sudo sync
sudo rm -rf $IMAGE_NAME

