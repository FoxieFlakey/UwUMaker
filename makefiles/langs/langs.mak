# Languages object generation support
# included by subdir.mak

LANG_OBJS_DIR			:= $(BUILD_SUBDIR)/lang
LANG_OBJS					:= $(LANG_OBJS)
LANG_OBJ_RULES		:= $(LANG_OBJ_RULES)

# Contains recipes for how to build each
LANG_RULES_SUBDIR		:= $(LANG_RULES_DIR)/$(SUBDIR)

# Contains compile_commands.json fragments
LANG_COMPILE_COMMAND_FRAGMENT_FILES :=

$(LANG_RULES_SUBDIR): | $(CACHE_DIR)
	$Q$(MKDIR) $@

# Langs dirs 
$(LANG_OBJS_DIR): | $(BUILD_SUBDIR)
	$Q$(MKDIR) $@

# Append language includes supports here
include makefiles/langs/c.mak

include $(wildcard $(LANG_OBJ_RULES))

COMPILE_COMMAND_FILES += $(LANG_COMPILE_COMMAND_FRAGMENT_FILES)

