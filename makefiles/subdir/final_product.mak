# Linking objects into final result

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
	@# Make sure ar recreates
	$Q$(RM) -f $@
	$Q$(AR) rcsP $@ $(BUILD_SUBDIR)/lib.a
endif

else
ifdef UwUMaker-is-executable
	$(error "Subdir must not define or use UwUMaker-is-executable")
endif

$(FINAL_PRODUCT):
	$Q$(STDERR) "Attempting to generate final product from a subdir"
	$Q$(EXIT) 1
endif

