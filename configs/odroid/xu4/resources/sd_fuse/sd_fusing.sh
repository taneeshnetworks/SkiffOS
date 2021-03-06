#
# Copyright (C) 2011 Samsung Electronics Co., Ltd.
#              http://www.samsung.com/
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.
#
####################################
set -x

if [ -z $1 ]
then
    echo "usage: ./sd_fusing.sh <SD Reader's device file> <ubootimg>"
    exit 0
fi
ubootimg=$2

if [ -f $1 ]
then
    echo "$1 reader is identified."
else
    echo "$1 is NOT identified."
    exit 0
fi

####################################
# fusing images

signed_bl1_position=1
bl2_position=31
uboot_position=63
tzsw_position=2111
device=$1

# Get the U-Boot blob
if [ ! -f $ubootimg ]; then
  echo "U-Boot blob not found."
  exit 1
fi

#<BL1 fusing>
echo "BL1 fusing"
dd iflag=dsync oflag=dsync if=./bl1.bin.hardkernel of=$device seek=$signed_bl1_position ${SD_FUSE_DD_ARGS}

#<BL2 fusing>
echo "BL2 fusing"
dd iflag=dsync oflag=dsync if=./bl2.bin.hardkernel.1mb_uboot of=$device seek=$bl2_position ${SD_FUSE_DD_ARGS}

#<u-boot fusing>
echo "u-boot fusing"
dd iflag=dsync oflag=dsync if=$ubootimg of=$device seek=$uboot_position ${SD_FUSE_DD_ARGS}

#<TrustZone S/W fusing>
echo "TrustZone S/W fusing"
dd iflag=dsync oflag=dsync if=./tzsw.bin.hardkernel of=$device seek=$tzsw_position ${SD_FUSE_DD_ARGS}

####################################
#<Message Display>
echo "U-boot image is fused successfully."
