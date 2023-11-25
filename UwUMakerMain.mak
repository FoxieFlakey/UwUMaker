.EXPORT_ALL_VARIABLES:
.DELETE_ON_ERROR:

# Version of the buildsystem
UWUMAKER_MAJOR_VERSION := 0
UWUMAKER_MINOR_VERSION := 1
UWUMAKER_PATCH_VERSION := 0
UWUMAKER_EXTRA_VERSION := -dev

UWUMAKER_VERSION := $(UWUMAKER_MAJOR_VERSION).$(UWUMAKER_MINOR_VERSION).$(UWUMAKER_PATCH_VERSION)$(UWUMAKER_EXTRA_VERSION)

PROJECT_DIR ?= $(PROJECT_DIR)
CONFIG_PATH ?= $(PROJECT_DIR)/.config

BUILD_DIR		?= $(PROJECT_DIR)/build
TEMP_DIR		?= $(BUILD_DIR)/temp
CACHE_DIR		?= $(BUILD_DIR)/cache

SHELL       ?= $(Q)$(shell which dash)
LUA					?= $(Q)$(shell which lua5.4)

# Prefixes #
V ?= 0
ifneq (0,$(V))
Q =
else
Q = @
endif
############

# Common commands
MKDIR		?= $(Q)mkdir -p
RM			?= $(Q)rm
RMDIR		?= $(Q)rm -r
TOUCH		?= $(Q)touch
COPY		?= $(Q)cp
MOVE		?= $(Q)mv
CAT			?= $(Q)cat
EXIT		:= $(Q)exit
########

# Useful stuffs >w<
COMMA := ,
SPACE := $(shell printf " ")
NEWLINE := $(shell printf "\n")
##########

# Some nice things
STDERR	:= $(Q)>&2 echo
STDOUT	:= $(Q)>&1 echo
########

include makefiles/kconfig.mak
include makefiles/directories.mak

.PHONY: cmd_all
cmd_all:
	echo "Hello UwU (Config at $(CONFIG_PATH))"
	echo "Compiler selected is $(CONFIG_IS_CLANG)"

