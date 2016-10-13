#!/bin/bash
LC_ALL=C 
LANGUAGE=C LANG=C 
distro=$1

if [ -z "$1" ]
  then
  distro=jessie
fi


export LC_ALL
export LANGUAGE

/debootstrap/debootstrap --second-stage

cat <<EOT > /etc/apt/sources.list
deb http://ftp.uk.debian.org/debian $distro main contrib non-free
deb-src http://ftp.uk.debian.org/debian $distro main contrib non-free
deb http://ftp.uk.debian.org/debian $distro-updates main contrib non-free
deb-src http://ftp.uk.debian.org/debian $distro-updates main contrib non-free
deb http://security.debian.org/debian-security $distro/updates main contrib non-free
deb-src http://security.debian.org/debian-security $distro/updates main contrib non-free
EOT

cat <<EOT > /etc/apt/apt.conf.d/71-no-recommends
APT::Install-Recommends "0";
APT::Install-Suggests "0";
EOT

apt-get update

apt-get install locales dialog

dpkg --configure -a

apt-get install -y openssh-server ntpdate parted

cat <<EOT >> /etc/network/interfaces
auto eth0
allow-hotplug eth0
iface eth0 inet dhcp
EOT

echo zedboard > /etc/hostname

echo T0:2345:respawn:/sbin/getty -L ttyS0 115200 vt100 >> /etc/inittab

printf "zedboard\nzedboard" | passwd

printf "## Serial Console for zedboard\nttyPS0\n" >> /etc/securetty 

