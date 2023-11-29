# Languages object generation support
# included by subdir.mak

LANG_OBJS_DIR			:= $(BUILD_SUBDIR)/lang

# Langs dirs
$(BUILD_LANG_DIR): $(BUILD_SUBDIR)
	$Q$(MKDIR) $@

# C lang support
LANG_C_OBJS_DIR	:= $(LANG_OBJS_DIR)/c
LANG_C_OBJS			:= $(UwUMaker-c-sources-y:%.c=$(LANG_C_OBJS_DIR)/%.o)

$(LANG_C_OBJS_DIR): $(BUILD_LANG_DIR)
	$Q$(MKDIR) $@

define lang_c_compile
$1: $2 $(LANG_C_OBJS_DIR)
	@$(PRINT_STATUS) CC "$(SUBDIR)/$(2:$(ABSOLUTE_SUBDIR)/%=%)"
	$Q$(CC) -c $2 $(UwUMaker-c-flags) -o $1
endef

# Create a recipe for each object file
$(foreach obj,$(LANG_C_OBJS),$(eval $(call lang_c_compile,$(obj),$(obj:$(LANG_C_OBJS_DIR)/%.o=$(ABSOLUTE_SUBDIR)/%.c))))



