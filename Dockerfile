FROM ubuntu:15.04
MAINTAINER Rune Langoy "rune@something.com"
RUN apt-get update
RUN apt-get update && apt-get install -y git make binutils-arm-none-eabi build-essential
RUN apt-get install -y  gcc-arm-none-eabi libnewlib-arm-none-eabi libssl-dev device-tree-compiler
RUN apt-get -y install bc
RUN apt-get -y install ncurses-dev
RUN git clone --depth 1 https://github.com/Xilinx/linux-xlnx.git
RUN git clone --depth 1 https://github.com/Xilinx/u-boot-xlnx.git
WORKDIR u-boot-xlnx
RUN make ARCH=arm CROSS_COMPILE=arm-none-eabi- zynq_zed_defconfig
RUN make ARCH=arm CROSS_COMPILE=arm-none-eabi-
COPY myconfig.txt /linux-xlnx/.config
WORKDIR /linux-xlnx
#RUN make ARCH=arm CROSS_COMPILE=arm-none-eabi- xilinx_zynq_defconfig
#RUN make menuconfig 
RUN apt-get install -y u-boot-tools
RUN make ARCH=arm CROSS_COMPILE=arm-none-eabi- UIMAGE_LOADADDR=0x8000 uImage modules zynq-zed.dtb
WORKDIR /
RUN mkdir zedFiles
WORKDIR /zedFiles
RUN mkdir boot
WORKDIR /zedFiles/boot
RUN cp /linux-xlnx/arch/arm/boot/uImage .
RUN cp /linux-xlnx/arch/arm/boot/dts/zynq-zed.dtb devicetree.dtb
RUN cp /u-boot-xlnx/u-boot.bin boot.bin
WORKDIR /linux-xlnx 
RUN make INSTALL_MOD_PATH="/zedFiles" modules_install
WORKDIR /zedFiles/boot
RUN tar cvzf libs.tar.gz ../lib
