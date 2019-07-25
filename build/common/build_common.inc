#
# Copyright (c) 2016 Cisco and/or its affiliates, and 
#                    Cable Television Laboratories, Inc. ("CableLabs")
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
# Script that builds RPD from OpenWRT sources.
x86_config(){
   source $TARGET_DIR/x86.inc
}

core_sim_config(){
   source $TARGET_DIR/core-sim.inc
}

rpi2_config(){
   source $TARGET_DIR/rpi2.inc
}

image_update(){
   echo "=================================================================="
   echo "image update,please check output to see if there are any conflicts"
   if [ -f feeds.conf ]; then
      rm feeds.conf
   else
      touch feeds.conf
   fi

   echo "repository update..."
   cat build/x86/OpenRPD.feeds > $TOP_DIR/feeds.conf

   echo "Openwrt update..."
   git pull
   echo "OpenRPD update..."
   scripts/feeds update -a
   scripts/feeds install -a
   echo "========================================================"
   touch build/.build_not_update
   echo "next build from build_rpd.sh will not auto update again"
   echo "========================================================"
}

image_build(){
   echo "Update/install feeds and build the image "

   # build the server if local python path exist
   if [ -d $TOP_DIR/dl/pypi_pkg ]; then
      cd $TOP_DIR/dl/pypi_pkg
      python -m SimpleHTTPServer 8800  1>/dev/null 2>/dev/null &
      cd -
   fi

   # Check if compatible version of protoc is available
   if [[ ! "$(protoc --version 2>/dev/null)" =~ "libprotoc 2."[3-7] ]]; then
      echo "Incompatible or missing protoc, expected: protoc 2.5.0"
      exit 1
   fi

   # Check version of protoc-c
   if [[ ! "$(protoc-c --version 2>/dev/null)" =~ "libprotoc 2."[3-7] ]]; then
      echo "Incompatible or missing protoc-c, expected: protoc-c 2.5.0"
      exit 1
   fi


   if [ -f build/.build_not_update ]; then
      echo "======================================================="
      echo "Note: !!!!!!!!Build without update to lastest!!!!!!!!!!"
      sleep 8
   else
      echo "============================================================================"
      echo "Note: !!!!!!!!first time build. pull OpenRPD Repositories!!!!!!!!!"
      scripts/feeds update -a
      scripts/feeds install -a
      touch build/.build_not_update
      echo "============================================================================"
      sleep 8
   fi

   echo "RPD_IMAGE_VERSION=$RPD_RELEASE_VER" >> $RPD_IMAGE_INFO_F
   echo "RPD_TYPE=$TARGET" >> $RPD_IMAGE_INFO_F
   branchname=$(git branch | grep '\*' | awk '{for(i=2;i<=NF;i++){printf "%s ", $i}; printf "\n"}')
   echo "RPD_BRANCH=$branchname" >> $RPD_IMAGE_INFO_F
   branchname=$(cd feeds/openrpd/ && git branch | grep '\*' | awk '{for(i=2;i<=NF;i++){printf "%s ", $i}; printf "\n"}')
   echo "OPENRPD_BRANCH=$branchname" >> $RPD_IMAGE_INFO_F
   echo "RPD_BUILDER=$(whoami)" >> $RPD_IMAGE_INFO_F
   echo "RPD_BUILD_TIME=$(date +%s)" >> $RPD_IMAGE_INFO_F

   if [ "$TARGET" = "vRPD" ];then	
      echo "===================================="
      echo "Note: Build vRPD & make defconfig..."
      sleep 3
      echo "===================================="
      cp $TARGET_DIR/x86.config .config
      make defconfig
   fi

   if [ "$TARGET" = "core-sim" ];then	
      echo "===================================="
      echo "Note: Build Core-sim vRPD & make defconfig..."
      sleep 3
      echo "===================================="
      cp $TARGET_DIR/core-sim.config .config
      make defconfig
   fi

   if [ "$TARGET" = "rpi2-rpd" ];then
      echo "===================================="
      echo "Note: Build Raspberry Pi 2 RPD & make defconfig..."
      sleep 3
      echo "===================================="
      $TOP_DIR/scripts/merge_config.sh -m -r $TOP_DIR/.config $TARGET_DIR/rpi2.config
      make defconfig
   fi

   if [ "$TARGET" = "rpi2-core-sim" ];then
      echo "===================================="
      echo "Note: Build Raspberry Pi 2 Core-sim & make defconfig..."
      sleep 3
      echo "===================================="
      $TOP_DIR/scripts/merge_config.sh -m -r $TOP_DIR/.config $TARGET_DIR/rpi2.config
      make defconfig
   fi

   make  --jobs=${j} V=99 2>&1 | tee $BUILD_LOG
   ps -ef|grep SimpleHTTPServer|awk '{print $2}'|xargs kill -9
   exit ${PIPESTATUS[0]}
}
