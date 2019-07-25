#
# Copyright (c) 2016 Cisco and/or its affiliates, and 
#                    Cable Television Laboratories, Inc. ("CableLabs")
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
# Script that builds RPD from OpenWRT sources.

# Create feeds.conf file with OpenRPD feed
echo "================================================================"
echo "Create Core-sim OpenRPD feeds [X86-based vRPD]"
cat $TARGET_DIR/OpenRPD.feeds > $TOP_DIR/feeds.conf
echo "================================================================"

# Create .config file with VM based RPD
echo "======================================================"
echo "Create Core-sim VM based solution config file [X86-based vRPD] "
cp $TARGET_DIR/core-sim.config $TOP_DIR/.config
echo "======================================================"
