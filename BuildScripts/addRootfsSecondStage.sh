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

apt-get install -y locales dialog

dpkg --configure -a

apt-get install -y openssh-server ntpdate parted sudo

cat <<EOT >> /etc/network/interfaces
auto eth0
allow-hotplug eth0
iface eth0 inet dhcp
EOT

echo zedboard > /etc/hostname
echo "127.0.1.1       zedboard" >> /etc/hosts

echo T0:2345:respawn:/sbin/getty -L ttyS0 115200 vt100 >> /etc/inittab

#create /home/user when running useradd
echo "CREATE_HOME yes" >> /etc/login.defs 

#printf "zedboard\nzedboard" | passwd
#Add user zed width password zed
useradd zed
printf "zed\nzed" | passwd zed
usermod -aG sudo zed
#change to use bash login
chsh -s /bin/bash zed

#alow all user's to ping 
sudo chmod u+s /bin/ping

printf "## Serial Console for zedboard\nttyPS0\n" >> /etc/securetty 

