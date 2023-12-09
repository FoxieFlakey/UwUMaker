# Recipes for each subdir
.DELETE_ON_ERROR:

# Got from command line
SUBDIR 					:= $(SUBDIR)

ABSOLUTE_SUBDIR	:= $(abspath $(PROJECT_DIR)/$(SUBDIR))
BUILD_SUBDIR 		:= $(abspath $(OBJS_DIR)/$(SUBDIR))

# Variables accessible to project's makefile
CURRENT_DIR	:= $(ABSOLUTE_SUBDIR)
PROJECT_DIR	:= $(PROJECT_DIR)
include $(ABSOLUTE_SUBDIR)/Makefile

# Determine whether current SUBDIR is top dir
ifeq ($(PROJECT_DIR),$(ABSOLUTE_SUBDIR))
IS_TOPDIR	:= y
endif

include makefiles/subdir/pkg-config.mak
include makefiles/kconfig.mak

COMPILE_COMMAND_FILES := $(UwUMaker-dirs-y:%=$(BUILD_SUBDIR)/%/compile_commands.json)
include makefiles/langs/langs.mak

# Must come after langs.mak
include makefiles/subdir/compile_commands_json.mak

BUILD_DIR_OBJS		:= $(UwUMaker-dirs-y:%=$(BUILD_SUBDIR)/%/built_in.a)
BUILD_NO_DIR_OBJS := $(LANG_OBJS) 
BUILD_OBJECTS 		:= $(BUILD_DIR_OBJS) $(BUILD_NO_DIR_OBJS) 
ARCHIVE_NAME			:= $(BUILD_SUBDIR)/built_in.a

include makefiles/subdir/final_product.mak

# Add this as prereq and make will execute
.PHONY: alt_phony
alt_phony:

# Create target for each subdir so make
# can parallelize. Goal for each phonified
# target is retrieved from MAKECMDGOALS
/phonified_target_%: alt_phony | $(BUILD_SUBDIR)
	$Q$(MAKE) -f makefiles/subdir.mak SUBDIR=$(SUBDIR)/$(@:/phonified_target_$(BUILD_SUBDIR)/%/built_in.a=%) $(MAKECMDGOALS)	

# Commands
.PHONY: call_subdirs
call_subdirs: $(BUILD_DIR_OBJS:%=/phonified_target_%)
	$(NOP)

.PHONY: cmd_update_self
cmd_update_self: $(BUILD_NO_DIR_OBJS) call_subdirs .WAIT $(ARCHIVE_NAME) $(BUILD_SUBDIR)/compile_commands.json
	$(NOP)

# Group objects into one UwU
$(ARCHIVE_NAME): $(BUILD_OBJECTS) | $(BUILD_SUBDIR)
	@$(PRINT_STATUS) AR "Archiving '$(@:$(OBJS_DIR)%=%)'"
	@# Make sure ar recreates
	$Q$(RM) -f $@
	$Q$(AR) rcsP --thin $@ $(BUILD_OBJECTS)

.PHONY: cmd_clean
cmd_clean: clean_self call_subdirs

.PHONY: clean_self
clean_self:
	@$(PRINT_STATUS) CLEAN "Cleaning '$(BUILD_SUBDIR:$(OBJS_DIR)/%=%)'"
	-$Q$(RM) -f $(BUILD_NO_DIR_OBJS) $(FINAL_PRODUCT) $(BUILD_SUBDIR)/built_in.a $(LANG_COMPILE_COMMAND_FRAGMENT_FILES) $(BUILD_SUBDIR)/compile_commands.json 1>&2

.PHONY: cmd_all
cmd_all: cmd_update_self .WAIT $(FINAL_PRODUCT)
	$(NOP)



