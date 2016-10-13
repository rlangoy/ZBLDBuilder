#!/bin/sh

distro=$1

if [ -z "$1" ]
  then
   distro=jessie
fi

IMAGE_NAME=zedboardImage$distro

sudo umount /dev/loop2p1
sudo umount /dev/loop2p2
sudo kpartx -d $IMAGE_NAME.img
sudo losetup -d /dev/loop2

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


sudo losetup /dev/loop2 $IMAGE_NAME.img
sudo partx -v --add /dev/loop2
sudo mkfs.vfat /dev/mapper/loop2p1
sudo mkfs.ext4 /dev/mapper/loop2p2

mkdir $IMAGE_NAME
mkdir $IMAGE_NAME/boot
sudo mount /dev/mapper/loop2p1 $IMAGE_NAME/boot
mkdir $IMAGE_NAME/rootfs
sudo mount /dev/mapper/loop2p2 $IMAGE_NAME/rootfs

./addRootfs.sh $distro
sudo bsdtar -cpf libs.tar.gz $IMAGE_NAME/rootfs/lib
sudo cp expand-rootfs.sh $IMAGE_NAME/rootfs/root
sudo cp ./boot/* $IMAGE_NAME/boot

sudo rm -rf $IMAGE_NAME
sudo umount /dev/mapper/loop2p1
sudo umount /dev/mapper/loop2p2
sudo kpartx -d $IMAGE_NAME.img
sudo losetup -d /dev/loop2
