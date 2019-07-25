#!/usr/bin/env bash
#
# Copyright (c) 2016 Cisco and/or its affiliates, and 
#                    Cable Television Laboratories, Inc. ("CableLabs")
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
# Script that builds RPD from OpenWRT sources.
BUILD_LOG="build_rpd.log"
TOP_DIR=.
TARGET_DIR=$TOP_DIR/build
TARGET_TAG=

# Allow make to multithread
j=1
while getopts ":j:" o; do
	case "${o}" in
		j)
			j=${OPTARG}
			;;
	esac
done
shift $((OPTIND-1))

rpdclean()
{
       rm .config 2>/dev/null
       rm feeds.conf 2>/dev/null
       #remove gnureadline to re-patch & re-compile the image
       find . -name gnureadline-6.3.3|xargs rm -rf 
       #remove pip tmp.
       USER_BUILD=`whoami`
       PIP_TMP_REMOVE=/tmp/pip_build_$USER_BUILD
       rm -rf $PIP_TMP_REMOVE
}

source build/common/build_common.inc

usage()
{
	echo "$0 usage:"
	echo "$0           ---without param:     build VM based RPD image"
	echo "$0 vRPD      --- build VM based RPD image"
	echo "$0 core-sim  --- build core emulator image"
	echo "$0 rpi2-rpd      --- build Raspberry Pi 2 based RPD image"
	echo "$0 rpi2-core-sim --- build Raspberry Pi 2 core emulator image"
	echo "$0 update    --- update to latest" 
	echo "$0 clean     --- clean: clean target bin" 
	echo "$0 dirclean  --- dirclean: clean all including toolchain"
	echo "$0 distclean --- distclean: clean all including toolchain, dl,feeds"
	echo "$0 help      --- with help param:   build cmd help"
}



if [ $# -eq 0 ]; then
	echo "Build Default VM based RPD [vRPD]"
	sleep 3
        rpdclean
	TARGET_DIR=$TOP_DIR/build/x86
        x86_config
        image_build
	exit 1
fi

if [ $# -eq 2 ]; then
        FUNCTION=$1
        case $FUNCTION in
	   *)
		usage
		exit 1
	   ;;
        esac

        exit 1
fi



TARGET=$1
echo $TARGET
case $TARGET in
	vRPD)
                TARGET_DIR=$TOP_DIR/build/x86
                rpdclean
                x86_config
	;;
	update)
		image_update
		exit 1
	;;
	clean)
                echo "clean target bin dir"
		make clean
		exit 1
	;;
	dirclean)
                echo "clean bin dir and toolchain"
		make dirclean
		exit 1
	;;
	distclean)
                echo "clean bin dir and toolchain and all download source and conf files"
		make distclean
		exit 1
	;;
	core-sim)
                TARGET_DIR=$TOP_DIR/build/x86
                BUILD_LOG="build_core.log"
                rpdclean
                core_sim_config
	;;
	rpi2-rpd)
                # print a message that we're running an rpi2 build
                echo "==============================="
                echo "Building RPD for Raspberry Pi 2"
                echo "==============================="
                # start with the x86 configuration
                TARGET_DIR=$TOP_DIR/build/x86
                BUILD_LOG="build_rpi2_rpd.log"
                rpdclean
                x86_config
                # add the rpi2 configuration
                TARGET_DIR=$TOP_DIR/build/rpi2
                rpi2_config
	;;
	rpi2-core-sim)
                # print a message that we're running an rpi2 build
                echo "========================================="
                echo "Building Core Emulator for Raspberry Pi 2"
                echo "========================================="
                # start with the x86 configuration
                TARGET_DIR=$TOP_DIR/build/x86
                BUILD_LOG="build_rpi2_core.log"
                rpdclean
                core_sim_config
                # add the rpi2 configuration
                TARGET_DIR=$TOP_DIR/build/rpi2
                rpi2_config
	;;
	help)
		usage
		exit 1
	;;
	*)
		usage
		exit 1
	;;
esac

image_build
