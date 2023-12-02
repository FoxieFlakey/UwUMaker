# Recipes for each subdir

# Got from command line
SUBDIR 					:= $(SUBDIR)

ABSOLUTE_SUBDIR	:= $(abspath $(PROJECT_DIR)/$(SUBDIR))
BUILD_SUBDIR 		:= $(abspath $(OBJS_DIR)/$(SUBDIR))

include $(ABSOLUTE_SUBDIR)/Makefile
include makefiles/langs.mak

BUILD_DIR_OBJS		:= $(UwUMaker-dirs-y:%=$(BUILD_SUBDIR)/%/built_in.a)
BUILD_NO_DIR_OBJS := $(LANG_OBJS) 
BUILD_OBJECTS 		:= $(BUILD_DIR_OBJS) $(BUILD_NO_DIR_OBJS) 
ARCHIVE_NAME			:= $(BUILD_SUBDIR)/built_in.a

# Determine whether current SUBDIR is top dir
ifeq ($(PROJECT_DIR),$(ABSOLUTE_SUBDIR))
IS_TOPDIR	:= y
endif

# Final product
ifeq ($(UwUMaker-is-executable),y)
FINAL_PRODUCT	:= $(BUILD_SUBDIR)/Executable
endif

ifeq ($(UwUMaker-is-executable),m)
FINAL_PRODUCT	:= $(BUILD_SUBDIR)/lib.so
endif

ifeq ($(UwUMaker-is-executable),n)
FINAL_PRODUCT	:= $(BUILD_SUBDIR)/lib.a
endif

ifneq ($(BUILD_SUBDIR),$(OBJS_DIR))
$(BUILD_SUBDIR): $(OBJS_DIR)
	$Q$(MKDIR) $@
else
$(BUILD_SUBDIR):
endif

# Link into final product
ifdef IS_TOPDIR

# Link into elf executable
ifeq ($(UwUMaker-is-executable),y)
$(FINAL_PRODUCT): $(ARCHIVE_NAME) | $(BUILD_SUBDIR)
	@$(PRINT_STATUS) LD "Linking '$(@:$(OBJS_DIR)/%=%)'"
	$Q$(CC) $(BUILD_SUBDIR)/built_in.a $(UwUMaker-linker-flags-y) -o $@
endif

# Link into .so
ifeq ($(UwUMaker-is-executable),m)
$(FINAL_PRODUCT): $(ARCHIVE_NAME) | $(BUILD_SUBDIR)
	@$(PRINT_STATUS) LD "Linking '$(@:$(OBJS_DIR)/%=%)'"
	$Q$(CC) $(BUILD_SUBDIR)/built_in.a $(UwUMaker-linker-flags-y) -shared -o $@
endif

# Link into .a
ifeq ($(UwUMaker-is-executable),n)
$(BUILD_SUBDIR)/lib.o: $(ARCHIVE_NAME) | $(BUILD_SUBDIR)
	@$(PRINT_STATUS) LD "Linking 'lib.o'"
	$Q$(CC) -r $(ARCHIVE_NAME) $(UwUMaker-linker-flags-y) -o $(BUILD_SUBDIR)/lib.o

$(FINAL_PRODUCT): $(BUILD_SUBDIR)/lib.o | $(BUILD_SUBDIR)
	@$(PRINT_STATUS) AR "Archiving '$(@:$(OBJS_DIR)/%=%)'"
	$Q$(AR) rcs $(FINAL_PRODUCT) $(BUILD_SUBDIR)/lib.a
endif

else
$(FINAL_PRODUCT):
	$Q$(STDERR) "Attempting to generate final product from a subdir"
	$Q$(EXIT) 1
endif

define call_subdir_rule
.PHONY: /phonified_target_$1
/phonified_target_$1: | $(BUILD_SUBDIR)
	$Q$(MAKE) -f makefiles/subdir.mak SUBDIR=$(SUBDIR)/$(1:$(BUILD_SUBDIR)/%/built_in.a=%) $(MAKECMDGOALS)
	
endef

# Create target for each subdir so make
# can parallelize. Goal for each phonified
# target is retrieved from MAKECMDGOALS
$(foreach obj,$(BUILD_DIR_OBJS),$(eval $(call call_subdir_rule,$(obj))))

# Commands
.PHONY: call_subdirs
call_subdirs: $(BUILD_DIR_OBJS:%=/phonified_target_%)
	$(NOP)

.PHONY: cmd_update_self
cmd_update_self: $(BUILD_NO_DIR_OBJS) call_subdirs .WAIT $(ARCHIVE_NAME)
	$(NOP)

# Group objects into one UwU
$(ARCHIVE_NAME): $(BUILD_OBJECTS) | $(BUILD_SUBDIR)
	@$(PRINT_STATUS) AR "Archiving '$(@:$(OBJS_DIR)/%=%)'"
	$Q$(AR) qcs --thin $@ $(BUILD_OBJECTS)

.PHONY: cmd_clean
cmd_clean: clean_self call_subdirs

.PHONY: cmd_clean_self
clean_self:
	@$(PRINT_STATUS) CLEAN "Cleaning '$(BUILD_SUBDIR:$(OBJS_DIR)/%=%)'"
	-$Q$(RM) -f $(BUILD_NO_DIR_OBJS) $(FINAL_PRODUCT) $(BUILD_SUBDIR)/built_in.a $(DUMMY_OBJECT_FILE) 1>&2

.PHONY: cmd_all
cmd_all: cmd_update_self
	@# Re-exec so makefile can see changes
	$Q$(MAKE) -f makefiles/subdir.mak $(FINAL_PRODUCT)




