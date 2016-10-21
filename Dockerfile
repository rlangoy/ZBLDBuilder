FROM ubuntu:16.04
MAINTAINER Rune Langoy "rune@something.com"
RUN apt-get update
RUN apt-get update && apt-get install -y git make binutils-arm-none-eabi build-essential
RUN apt-get install -y  gcc-arm-none-eabi libnewlib-arm-none-eabi libssl-dev device-tree-compiler
RUN apt-get install -y gcc-arm-linux-gnueabihf
RUN apt-get install -y g++-arm-linux-gnueabihf
RUN apt-get -y install bc
RUN apt-get -y install ncurses-dev
RUN apt-get install -y u-boot-tools
RUN apt-get install -y wget bsdtar
RUN apt-get install -y python sudo
#######
#  Enviroment vars
########

ARG CHECKOUT_TAG
ENV CHECKOUT_TAG xilinx-v2016.2
ENV COMP_ARGS  ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
#ARCH=arm CROSS_COMPILE=arm-none-eabi-
##  arm-none-eabi- Does not work :(

#########
##  Build U-BOOT
##########

WORKDIR /
RUN wget https://github.com/Xilinx/u-boot-xlnx/archive/$CHECKOUT_TAG.tar.gz -O u-boot-$CHECKOUT_TAG.tar.gz
RUN tar xvzf u-boot-$CHECKOUT_TAG.tar.gz
WORKDIR /u-boot-xlnx-$CHECKOUT_TAG
#RUN git clone  https://github.com/Xilinx/u-boot-xlnx.git
#CMD ["/bin/sh", "-c", "git checkout ${CHECKOUT_TAG}"]

RUN make $COMP_ARGS zynq_zed_defconfig
RUN make $COMP_ARGS 

#########
##  Build Linux
##########

#RUN git clone https://github.com/Xilinx/linux-xlnx.git
#WORKDIR /linux-xlnx
#CMD ["/bin/sh", "-c", "git checkout ${CHECKOUT_TAG}"]
#RUN "wget", "https://github.com/Xilinx/linux-xlnx/archive/" ${CHECKOUT_TAG} ".tar.gz"
#RUN "tar", "xvzf", ${CHECKOUT_TAG}".tar.gz"
WORKDIR /
RUN wget https://github.com/Xilinx/linux-xlnx/archive/$CHECKOUT_TAG.tar.gz -O linux-$CHECKOUT_TAG.tar.gz 
RUN tar xvzf linux-$CHECKOUT_TAG.tar.gz
WORKDIR /linux-xlnx-$CHECKOUT_TAG


#CMD ["/bin/sh", "-c", "wget https://github.com/Xilinx/linux-xlnx/archive/${CHECKOUT_TAG}.tar.gz"]
#make ARCH=arm CROSS_COMPILE=arm-none-eabi- xilinx_zynq_defconfig
COPY config.txt .config
COPY zynq-zed.dts ./arch/arm/boot/dts/zynq-zed.dts
#RUN make $COMP_ARGS oldconfig
RUN make $COMP_ARGS clean
RUN make $COMP_ARGS UIMAGE_LOADADDR=0x8000 uImage modules zynq-zed.dtb

#########
##  Collect builded files
##########

WORKDIR /
RUN mkdir zedFiles
WORKDIR /zedFiles
RUN mkdir boot
WORKDIR /zedFiles/boot
RUN cp /linux-xlnx-$CHECKOUT_TAG/arch/arm/boot/uImage .
RUN cp /linux-xlnx-$CHECKOUT_TAG/arch/arm/boot/dts/zynq-zed.dtb devicetree.dtb
RUN cp /u-boot-xlnx-$CHECKOUT_TAG/u-boot.bin boot.bin
WORKDIR /linux-xlnx-$CHECKOUT_TAG
RUN make $COMP_ARGS INSTALL_MOD_PATH="/zedFiles" modules_install
WORKDIR /zedFiles
RUN bsdtar -cpzf xilinxv2016.2-lib.tar.gz lib
WORKDIR /zedFiles/boot
COPY BOOT.BIN .
RUN mkdir bp
RUN cp BOOT.BIN bp
RUN cp devicetree.dtb bp
RUN cp uImage bp
WORKDIR /zedFiles/boot/bp
RUN bsdtar -cpzf bootPartition.tar.gz *
##
##  Must run depmod -a
###

##
##  Add files for building a linuxDistro .img width debian jessie
#WORKDIR /
#COPY BuildScripts/addRootfs.sh .
#COPY BuildScripts/addRootfsSecondStage.sh .
#COPY BuildScripts/expand-rootfs.sh .
#COPY BuildScripts/mkLinuxImg.sh .

#RUN mkLinuxImg.sh  do do docker run --privileged=true