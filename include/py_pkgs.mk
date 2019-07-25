#
# Copyright (c) 2016 Cisco and/or its affiliates, and 
#                    Cable Television Laboratories, Inc. ("CableLabs")
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

# TOOLCHAIN PATH + CROSSCOMPILATION TARGET PREFIX
export TCH_P:=$(TOOLCHAIN_DIR)/bin/$(TARGET_CROSS)
export STAGING_DIR
export CC:=$(TCH_P)gcc 
export CFLAGS:=$(TARGET_CFLAGS) 
export LDFLAGS:=$(TARGET_LDFLAGS) 
export LDSHARED:=$(TCH_P)gcc -shared 
export BLDSHARED:=$(TCH_P)gcc -shared 
export PATH:=$(BUILD_DIR_HOST)/bin:$(TARGET_PATH)
export AS:=$(TCH_P)as
export LD:=$(TCH_P)ld 
export CXX:=$(TCH_P)g++
export AR:=$(TCH_P)ar 
export NM:=$(TCH_P)nm
export STRIP:=$(TCH_P)strip
export RANLIB:=$(TCH_P)ranlib
export READELF:=$(TCH_P)readelf
export OBJCOPY:=$(TCH_P)objcopy 
export OBJDUMP:=$(TCH_P)objdump 
export SIZE:=$(TCH_P)size
export PYTHONPATH:=$(STAGING_DIR_HOST)/bin:$(BUILD_DIR_HOST)/lib/python2.7/site-packages:$(STAGING_DIR_HOST)/lib/python2.7/site-packages
export PYTHONCPREFIX:=$(BUILD_DIR_HOST)/Python-2.7.3
export HOSTARCH:=$(REAL_GNU_TARGET_NAME)
export CROSS_COMPILE:=$(REAL_GNU_TARGET_NAME)
export CROSS_COMPILE_TARGET:=yes

#PKG_BUILD_PARALLEL:=0
#PKG_JOBS:=-j1

define PY_PKG_DEBUG
	@echo
	@echo $\"#### MAKE DEBUG ####$\"
	@echo STAGING_DIR_ROOT: $$(STAGING_DIR_ROOT)
	@echo BUILD_DIR_HOST: $$(BUILD_DIR_HOST)
	@echo TOOLCHAIN_DIR: $$(TOOLCHAIN_DIR)
	@echo TARGET_CROSS: $$(TARGET_CROSS)
	@echo TARGET_PATH: $$(TARGET_PATH)
	@echo TARGET_LDFLAGS: $$(TARGET_LDFLAGS)
	@echo TARGET_CFLAGS: $$(TARGET_CFLAGS)

	@echo
	@echo $\"#### MAKE DEBUG ENV ####$\"
	echo TCH_P: $$$$TCH_P
	echo STAGING_DIR: $$$$STAGING_DIR
	echo CFLAGS: $$$$CFLAGS
	echo LDFLAGS: $$$$LDFLAGS

	@echo
	@echo $\"#### MAKE DEBUG ENV PYTHON ####$\"
	echo PYTHONPATH: $$$$PYTHONPATH
	echo PYTHONCPREFIX: $$$$PYTHONCPREFIX
	echo HOST_ARCH: $$$$HOSTARCH
	echo CROSS_COMPILE: $$$$CROSS_COMPILE
	echo CROSS_COMPILE_TARGET: $$$$CROSS_COMPILE_TARGET
endef
