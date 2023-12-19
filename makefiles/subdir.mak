# Recipes for each subdir
.DELETE_ON_ERROR:

ifndef SUBDIR
$(error "Internal problem SUBDIR is not defined when supposed to -w-")
endif

ABSOLUTE_SUBDIR	:= $(abspath $(PROJECT_DIR)/$(SUBDIR))
BUILD_SUBDIR 		:= $(abspath $(OBJS_DIR)/$(SUBDIR))

# Variables accessible to project's makefile
CURRENT_DIR	:= $(ABSOLUTE_SUBDIR)
PROJECT_DIR	:= $(PROJECT_DIR)
ROOT_PROJECT_DIR := $(ROOT_PROJECT_DIR)

include makefiles/langs/flags_export.mak

define fix_var
___TMP_FIX_VAR := $$($1)
override undefine UwUMaker-c-flags-y
$1 := $$(___TMP_FIX_VAR)

endef

$(foreach v,$(LANG_FLAG_EXPORTS_LIST),$(eval $(call fix_var,$v)))
include $(ABSOLUTE_SUBDIR)/Makefile

# Determine whether current SUBDIR is top dir
ifeq ($(PROJECT_DIR),$(ABSOLUTE_SUBDIR))
IS_TOPDIR	:= y
endif

# Checkings here
ifdef IS_TOPDIR

# These two are only bare minimum needed
ifndef UwUMaker-is-executable
$(error "Top dir must define UwUMaker-is-executable")
endif
ifndef UwUMaker-name
$(error "Top dir must define UwUMaker-name")
endif

ifdef EXPECTED_IS_EXECUTABLE
ifneq ($(EXPECTED_IS_EXECUTABLE),$(UwUMaker-is-executable))
$(error "This subproject's UwUMaker-is-executable should be '$(EXPECTED_IS_EXECUTABLE)' (SUBPROJECT=$(SUBPROJECT))")
endif
endif

export FINAL_PRODUCT_TYPE := $(UwUMaker-is-executable)
export PROJECT_NAME := $(UwUMaker-name)
else

ifdef UwUMaker-is-executable
	$(error "Subdir must not define or use UwUMaker-is-executable")
endif

ifdef UwUMaker-name
	$(error "Subdir cannot not use UwUMaker-name")
endif
endif

COMPILE_COMMAND_FILES := $(UwUMaker-dirs-y:%=$(BUILD_SUBDIR)/%/compile_commands.json)

include makefiles/subdir/pkg-config.mak
include makefiles/kconfig.mak
include makefiles/langs/langs.mak
include makefiles/subdir/final_product.mak
include makefiles/subdir/subproject.mak

# Must come last in include list
# to generate per subdir compile_commands.json
include makefiles/subdir/compile_commands_json.mak

SUBDIRS								:= $(UwUMaker-dirs-y:%=$(ABSOLUTE_SUBDIR)/%)
SUBDIR_ARCHIVES				:= $(UwUMaker-dirs-y:%=$(BUILD_SUBDIR)/%/built_in.o)
SUBDIR_LINK_RULES			:= $(SUBDIRS:$(ABSOLUTE_SUBDIR)/%=$(BUILD_SUBDIR)/%/link_rules.mak)
BUILD_NO_DIR_OBJS 		:= $(LANG_OBJS) 
BUILD_OBJECTS 				:= $(SUBDIR_ARCHIVES) $(BUILD_NO_DIR_OBJS) 
ARCHIVE_NAME					:= $(BUILD_SUBDIR)/built_in.o

# Include rules for making link rules
include makefiles/subdir/gen_link_rules_mak.mak

# Create the build subdir
ifndef IS_TOPDIR
$(BUILD_SUBDIR): | $(OBJS_DIR)
	$Q$(MKDIR) $@
else
$(BUILD_SUBDIR):
	$Q$(MKDIR) $@
endif

# Add this as prereq and make will execute
.PHONY: alt_phony
alt_phony:
	$(NOP)

# Pattern rule to call subdirs so make can
# parellelize.

# Export all flags
$(foreach v,$(LANG_FLAG_EXPORTS_LIST),$(eval /phonified_subdir/%: export $v = $($v)))
/phonified_subdir/%: export SUBDIR = $(@:/phonified_subdir/$(PROJECT_DIR)%=%)
/phonified_subdir/%: alt_phony | $(BUILD_SUBDIR)
	$Q$(MAKE) -f makefiles/subdir.mak $(MAKECMDGOALS)	

.PHONY: call_subdirs
call_subdirs: $(SUBDIRS:%=/phonified_subdir/%)
	$(NOP)

# Group objects into one UwU
$(ARCHIVE_NAME): $(BUILD_OBJECTS) | $(BUILD_SUBDIR)
	@$(PRINT_STATUS) LD "Partial linking '$(@:$(OBJS_DIR)%=%)'"
	$Q$(CC) -r $^ -o $@

.PHONY: clean_self
clean_self:
	@$(PRINT_STATUS) CLEAN "Cleaning '$(SUBDIR)'"
	-$Q$(RM) -f -- $(BUILD_NO_DIR_OBJS) $(BUILD_DIR)/output_path.txt $(FINAL_PRODUCT) $(ARCHIVE_NAME) $(LANG_COMPILE_COMMAND_FRAGMENT_FILES) $(BUILD_SUBDIR)/compile_commands.json

ifeq (,$(filter cmd_%,$(MAKECMDGOALS)))
$(error "You can only call with cmd_* goals")
endif


ifdef IS_TOPDIR
ifeq (/,$(SUBPROJECT))
OUTPUT_PATH_TXT := $(OBJS_DIR)/output_path.txt
$(OBJS_DIR)/output_path.txt: | $(OBJS_DIR)
else
OUTPUT_PATH_TXT := $(BUILD_DIR)/output_path.txt
$(BUILD_DIR)/output_path.txt: | $(BUILD_DIR)
endif
	@# Write output path into txt file so later
	@# can be retrieved
	$Q$(ECHO) "$(FINAL_PRODUCT)" > $@
else
OUTPUT_PATH_TXT :=
endif

# Commands
.PHONY: cmd_clean
cmd_clean: clean_self call_subdirs call_subprojects 
	$(NOP)

.PHONY: cmd_gen_link_rules
cmd_gen_link_rules: $(OUTPUT_PATH_TXT) call_subprojects call_subdirs .WAIT $(LINK_RULES_FILE) | $(BUILD_SUBDIR)
	$(NOP)

# Compile files on subdir recursively
# but not for subprojects
.PHONY: cmd_compile_subdir
cmd_compile_subdir: $(BUILD_NO_DIR_OBJS) call_subdirs .WAIT $(ARCHIVE_NAME) $(BUILD_SUBDIR)/compile_commands.json | $(BUILD_SUBDIR)
	$(NOP)




