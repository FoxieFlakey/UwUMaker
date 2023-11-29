# Recipes for each subdir

# Got from command line
SUBDIR 					:= $(SUBDIR)

ABSOLUTE_SUBDIR	:= $(abspath $(PROJECT_DIR)/$(SUBDIR))
BUILD_SUBDIR 		:= $(abspath $(OBJS_DIR)/$(SUBDIR))

include $(ABSOLUTE_SUBDIR)/Makefile
include makefiles/langs.mak

BUILD_DIR_OBJS	:= $(UwUMaker-dirs-y:%=$(BUILD_SUBDIR)/%/built_in.a)
BUILD_OBJECTS 	:= $(BUILD_DIR_OBJS) \
									 $(LANG_C_OBJS) 

# Recurse to dirs
$(BUILD_DIR_OBJS):
	$Q$(MKDIR) $(@:/built_in.a=)
	$Q$(MAKE) -f makefiles/subdir.mak SUBDIR=$(SUBDIR)/$(@:$(BUILD_SUBDIR)/%/built_in.a=%) $(abspath $@)

# Group objects into one UwU
$(BUILD_SUBDIR)/built_in.a: $(BUILD_OBJECTS)
	@$(PRINT_STATUS) AR "Archiving '$@'"
	$Q$(AR) qcs --thin $@ $(BUILD_OBJECTS)

# Link into an executable
# TODO: Something to fix why ld dont
# search in correct paths
$(BUILD_SUBDIR)/Executable: $(BUILD_SUBDIR)/built_in.a
	@$(PRINT_STATUS) LD "Linking '$@'"
	$Q$(CC) $(BUILD_SUBDIR)/built_in.a $(UwUmaker-linker-flags) -o $@


