# ZBLDBuilder
Zedboard Linux Image Bilding system using Docker

This is all work in progress !!!
--------------------
Build the Linux Kernel and u-boot using 
docker build -t tag/name .
ie: docker build -t rlangoy/zed3_8 .

To build the sd-card .img run: <br>
<br>
docker run --privileged=true -it ubuntu /bin/bash<br>
$ mkLinuxImg.sh
