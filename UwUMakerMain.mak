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
OBJS_DIR		?= $(BUILD_DIR)/objs
CACHE_DIR		?= $(BUILD_DIR)/cache

SHELL       ?= $(shell which dash)
LUA					?= $(shell which lua5.4)

# Prefixes #
V ?= 0
ifneq (0,$(V))
Q =
else
Q = @
endif
############

# Common commands
MKDIR		?= mkdir -p
RM			?= rm
RMDIR		?= rm -r
TOUCH		?= touch
COPY		?= cp
MOVE		?= mv
CAT			?= cat
EXIT		?= exit
########

# Compiler and binutils
LD			?= ld
CC			?= cc
AR			?= ar
###############

# Useful stuffs >w<
COMMA := ,
SPACE := $(shell printf " ")
NEWLINE := $(shell printf "\n")
##########

# Some nice things
STDERR	:= >&2 echo
STDOUT	:= >&1 echo
PRINT_STATUS := scripts/print_status.sh
########

include makefiles/kconfig.mak
include makefiles/directories.mak

.PHONY: cmd_all
cmd_all: $(OBJS_DIR)
#	$(STDOUT) "Hello UwU (Config at $(CONFIG_PATH))"
#	$(STDOUT) "Compiler selected is $(CONFIG_IS_CLANG)"
	$(Q)$(MAKE) -f makefiles/subdir.mak SUBDIR= $(OBJS_DIR)/Executable






