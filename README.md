# ZBLDBuilder
Zedboard Linux Image Bilding system using Docker

--------------------
Build the Linux Kernel and u-boot using 
docker build -t tag/name .
ie: docker build -t rlangoy/zed3_8 .

Extract the zedboard files (boot.bin devicetree.dtb uImage) using<br>
docker cp tag/name /zedFiles/boot/* .<br>
ie: docker cp rlangoy/zed3_8/zedFiles/boot/* .<br>

Better info at: https://archlinuxarm.org/platforms/armv7/xilinx/zedboard

Format the SD-card using:
   1 partition - vfat (fat32)
       Copy the files boot.bin devicetree.dtb uImage
	
   2 partition - ext4 (
     extract the file libs.tar.gz to /usr
     get and extract archLinux from http://os.archlinuxarm.org/os/ArchLinuxARM-zedboard-latest.tar.gz to the root filder
     
     
User alarm   passwd alarm
     root    passwd root
     
login as root and run depmod -a to update module dependencies.


