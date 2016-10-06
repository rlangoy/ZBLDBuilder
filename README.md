# ZBLDBuilder
Zedboard Linux Image Bilding system using Docker

This image does not curently work...

Working image could be dowloaded from:
https://archlinuxarm.org/platforms/armv7/xilinx/zedboard <<br>
(but it is missing the ip_table_nat.ko) 

Errors to be solved...
mmc0: tried to reset card
mmc0: Timeout waiting for hardware interrupt.
mmcblk0: error -110 transferring data, sector 77576, nr 240, cmd response 0x900,
 card status 0xb00
 
--------------------
Build the Linux Kernel and u-boot using 
docker build -t tag/name .
ie: docker build -t rlangoy/zed3_8 .

Extract the zedboard files (boot.bin devicetree.dtb uImage) using<br>
docker cp tag/name /zedFiles/boot/* .<br>
ie: docker cp rlangoy/zed3_8/zedFiles/boot/* .<br>
