#!/bin/sh
#
# Resize the root filesystem of a newly flashed Raspbian image.
# Directly equivalent to the expand_rootfs section of raspi-config.
# No claims of originality are made.
# Mike Ray.  Feb 2013.  No warranty is implied.  Use at your own risk.
#
# Run as root.  Expands the root file system.  After running this,
# reboot and give the resizefs-once script a few minutes to finish expanding the file system.
# Check the file system with 'df -h' once it has run and you should see a size
# close to the known size of your card.
#
 
# Get the starting offset of the root partition
PART_START=$(parted /dev/mmcblk0 -ms unit s p | grep "^2" | cut -f 2 -d:)
[ "$PART_START" ] || return 1
# Return value will likely be error for fdisk as it fails to reload the 
# partition table because the root fs is mounted
fdisk /dev/mmcblk0 <<EOF
p
d
2
n
p
2
$PART_START
 
p
w
EOF
partprobe 
resize2fs /dev/mmcblk0p2

echo "Root partition has been resized. The filesystem will be enlarged upon the next reboot"
