#!/bin/sh
sudo apt-get install -y qemu-user-static debootstrap binfmt-support

targetdir=zedboardImage$1/rootfs
distro=$1

if [ -z "$1" ]
  then
  distro=jessie
  targetdir=zedboardImage$distro/rootfs
fi


export targetdir
export distro

mkdir $targetdir

sudo debootstrap --arch=armhf --foreign $distro $targetdir



sudo cp /usr/bin/qemu-arm-static $targetdir/usr/bin/ 
sudo cp /etc/resolv.conf $targetdir/etc/

sudo cp addRootfsSecondStage.sh $targetdir 

sudo chroot $targetdir /bin/bash -c "./addRootfsSecondStage.sh $distro"

sudo rm $targetdr/addRootfsSecondStage.sh

sudo rm $targetdir/etc/resolv.conf
sudo rm $targetdir/usr/bin/qemu-arm-static


