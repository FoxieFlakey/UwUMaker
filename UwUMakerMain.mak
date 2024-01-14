.DELETE_ON_ERROR:

# Version of the buildsystem
export UWUMAKER_MAJOR_VERSION := 1
export UWUMAKER_MINOR_VERSION := 1
export UWUMAKER_PATCH_VERSION := 0
export UWUMAKER_EXTRA_VERSION := 

export UWUMAKER_VERSION 	:= $(UWUMAKER_MAJOR_VERSION).$(UWUMAKER_MINOR_VERSION).$(UWUMAKER_PATCH_VERSION)$(UWUMAKER_EXTRA_VERSION)
export UWUMAKER_DIR				:= $(CURDIR)

#######################################
## Start of user modifieable vars
#######################################

export PROJECT_DIR 				?= $(PROJECT_DIR)
export DOTCONFIG_PATH 		?= $(PROJECT_DIR)/.config

# Build dir where miscellanous stuff located
export BUILD_DIR		?= $(PROJECT_DIR)/build

# Temporary directory (filled by boot Makefile)
export TEMP_DIR			?= $(TEMP_DIR)

# This can be deleted with only caveat slower or
# trigger regeneration of resources (or recompilation)
# don't cherry pick what to delete unless you know
# what do you do
export CACHE_DIR		?= $(BUILD_DIR)/cache

#######################################
## End of user modifieable vars
#######################################

# For sharing certain stuffs between
# subprojects (e.g, kconfig knobs and
# generated headers as those remains
# the same between subprojects)
#
# Care must taken when using shared cache
# dir in makefiles to ensure its content
# completely unaffected by Subproject
# settings.
export SHARED_CACHE_DIR ?= $(CACHE_DIR)

# Where lang rules resides. Lang rules describes
# dependency for each source code for each lang
export LANG_RULES_DIR 		?= $(BUILD_DIR)/lang_rules

# Contain compiled files (like .o, .a, .so, etc)
export OBJS_DIR			:= $(BUILD_DIR)/objs

export SHELL 				?= $(shell which dash)
export LUA 					?= $(shell which lua5.4)

export LUA_PATH			:= $(shell $(LUA) scripts/gen_lua_path.lua '$(shell pwd)')
export LUA_CPATH		:= $(shell $(LUA) scripts/gen_lua_cpath.lua '$(shell pwd)')

# Tracking subproject and root dirs
export SUBPROJECT   		?= /
export ROOT_PROJECT_DIR	?= $(PROJECT_DIR)
export ROOT_OBJS_DIR 		?= $(OBJS_DIR)
export ROOT_CACHE_DIR 		?= $(CACHE_DIR)
export ROOT_LANG_RULES_DIR 	?= $(LANG_RULES_DIR)

# Prefixes #
export V ?= 0
ifneq (0,$(V))
export Q =
else
export Q = @
endif
############

# Common commands
export ECHO			?= echo
export MKDIR		?= mkdir -p
export RM				?= rm
export RMDIR		?= rm -r
export TOUCH		?= touch
export COPY			?= cp
export MOVE			?= mv
export CAT			?= cat
export EXIT			?= exit
export TRUNCATE	?= truncate
########

# Compiler and binutils
export LD				?= ld.lld
export CC				?= clang
export AR				?= llvm-ar
export OBJCOPY	?= llvm-objcopy
###############

# Was useful stuffs >w<
##########

# Some nice things
export STDERR				:= >&2 echo
export STDOUT				:= >&1 echo
export PRINT_STATUS	:= scripts/print_status.sh
export NOP						:= @:
########

include makefiles/kconfig.mak
include makefiles/directories.mak

.PHONY: compile_project
compile_project: export SUBDIR := /
compile_project: 
	$Q$(MAKE) -f makefiles/subdir.mak cmd_compile_subdir
	
.PHONY: clean_subdir
clean_subdir: export SUBDIR := /
clean_subdir:
	$Q$(MAKE) -f makefiles/subdir.mak cmd_clean

# Commands
.PHONY: cmd_all
cmd_all: cmd_gen_link_rules
	$Q$(MAKE) -f $(OBJS_DIR)/link_rules.mak cmd_run

ifneq (,$(filter cmd_all,$(MAKECMDGOALS)))
ifneq (/,$(SUBPROJECT))
$(error "Subprojects cannot invoke cmd_all")
endif
endif

# Only compiles current project's built_in.a
# and generates compile_commands.json for
# current project (the compile_commands.json
# not exported to $BUILD_DIR)
.PHONY: cmd_compile_project
cmd_compile_project: kconfig_gen_config_files .WAIT compile_project
	$(NOP)

# Only generate link rules
.PHONY: cmd_gen_link_rule
cmd_gen_link_rules: export SUBDIR := /
cmd_gen_link_rules: kconfig_gen_config_files | $(OBJS_DIR) $(TEMP_DIR) 
	$Q$(MAKE) -f makefiles/subdir.mak cmd_gen_link_rules

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
	-$Q$(RMDIR) -f -- $(OBJS_DIR)
	$Q$(PRINT_STATUS) RM "Deleting $(BUILD_DIR) dir"
	-$Q$(RMDIR) -f -- $(BUILD_DIR)


