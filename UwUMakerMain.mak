.EXPORT_ALL_VARIABLES:
.DELETE_ON_ERROR:

# Version of the buildsystem
UWUMAKER_MAJOR_VERSION := 0
UWUMAKER_MINOR_VERSION := 1
UWUMAKER_PATCH_VERSION := 0
UWUMAKER_EXTRA_VERSION := -dev

UWUMAKER_VERSION := $(UWUMAKER_MAJOR_VERSION).$(UWUMAKER_MINOR_VERSION).$(UWUMAKER_PATCH_VERSION)$(UWUMAKER_EXTRA_VERSION)

PROJECT_DIR ?= $(PROJECT_DIR)
DOTCONFIG_PATH ?= $(PROJECT_DIR)/.config

OLDDOTCONFIG_PATH	:= $(DOTCONFIG_PATH).old

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
ECHO			?= echo
MKDIR			?= mkdir -p
RM				?= rm
RMDIR			?= rm -r
TOUCH			?= touch
COPY			?= cp
MOVE			?= mv
CAT				?= cat
EXIT			?= exit
FLOCK			?= flock
########

# Compiler and binutils
LD			?= ld
CC			?= cc
AR			?= ar
###############

# Useful stuffs >w<
COMMA := ,
SPACE := $(shell printf " ")
##########

# Some nice things
STDERR				:= >&2 echo
STDOUT				:= >&1 echo
PRINT_STATUS	:= scripts/print_status.sh
NOP						:= @:
########

include makefiles/kconfig.mak
include makefiles/directories.mak

.PHONY: cmd_all
cmd_all: kconfig_gen_config_files $(OBJS_DIR)
	$Q$(MAKE) -f makefiles/subdir.mak cmd_all

.PHONY: cmd_clean
clean_subdir:
	$Q$(MAKE) -f makefiles/subdir.mak cmd_clean

.PHONY: cmd_clean
cmd_clean: clean_subdir cmd_kconfig_clean
	$(NOP)

.PHONY: cmd_clean_cache
cmd_clean_cache:
	$Q$(PRINT_STATUS) CLEAN Cleaning caches
	-$Q$(RMDIR) $(CACHE_DIR)

# Deletes everything in $(BUILD_DIR)
.PHONY: cmd_sanitize
cmd_sanitize:
	$Q$(PRINT_STATUS) RM Deleting build dir
	-$Q$(RMDIR)  $(BUILD_DIR)


