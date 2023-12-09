.EXPORT_ALL_VARIABLES:
.DELETE_ON_ERROR:

# Version of the buildsystem
UWUMAKER_MAJOR_VERSION := 0
UWUMAKER_MINOR_VERSION := 1
UWUMAKER_PATCH_VERSION := 0
UWUMAKER_EXTRA_VERSION := -dev

UWUMAKER_VERSION 	:= $(UWUMAKER_MAJOR_VERSION).$(UWUMAKER_MINOR_VERSION).$(UWUMAKER_PATCH_VERSION)$(UWUMAKER_EXTRA_VERSION)
UWUMAKER_DIR			:= $(CURDIR)

PROJECT_DIR ?= $(PROJECT_DIR)
DOTCONFIG_PATH ?= $(PROJECT_DIR)/.config

# Build dir where miscellanous stuff located
BUILD_DIR		?= $(PROJECT_DIR)/build

# Temporary directory (filled by boot Makefile)
TEMP_DIR		:= $(TEMP_DIR)

# This can be deleted with only caveat slower or
# trigger regeneration of resources (or recompilation)
# don't cherry pick what to delete unless you know
# what do you do
CACHE_DIR		:= $(BUILD_DIR)/cache

# Contain compiled files (like .o, .a, .so, etc)
OBJS_DIR		:= $(BUILD_DIR)/objs

SHELL       ?= $(shell which dash)
LUA					?= $(shell which lua5.4)

LUA_PATH		:= $(shell $(LUA) scripts/gen_lua_path.lua '$(shell pwd)')
LUA_CPATH		:= $(shell $(LUA) scripts/gen_lua_cpath.lua '$(shell pwd)')

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
TRUNCATE	?= truncate
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

do_all: kconfig_gen_config_files | $(OBJS_DIR) $(TEMP_DIR)
	$Q$(MAKE) -f makefiles/subdir.mak cmd_all

.PHONY: cmd_all
cmd_all: do_all .WAIT $(BUILD_DIR)/compile_commands.json
	$(NOP)

# Generating compile_commands.json
$(BUILD_DIR)/compile_commands.json: $(OBJS_DIR)/compile_commands.json
	$Q$(COPY) $< $@

.PHONY: cmd_clean
clean_subdir:
	$Q$(MAKE) -f makefiles/subdir.mak cmd_clean

.PHONY: cmd_clean
cmd_clean: clean_subdir cmd_kconfig_clean
	$(NOP)

.PHONY: cmd_clean_cache
cmd_clean_cache: | $(CACHE_DIR)
	$Q$(PRINT_STATUS) CLEAN "Cleaning caches"
	-$Q$(RMDIR) -f $(CACHE_DIR)

# Deletes everything in $(BUILD_DIR)
.PHONY: cmd_sanitize
cmd_sanitize: cmd_clean_cache
	$Q$(PRINT_STATUS) RM "Deleting $(OBJS_DIR) dir"
	-$Q$(RMDIR) -f $(OBJS_DIR)
	$Q$(PRINT_STATUS) RM "Deleting $(BUILD_DIR) dir"
	-$Q$(RMDIR) -f $(BUILD_DIR)


