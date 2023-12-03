# Languages object generation support
# included by subdir.mak

LANG_OBJS_DIR			:= $(BUILD_SUBDIR)/lang
LANG_OBJS					:= $(LANG_OBJS)
LANG_OBJ_RULES		:= $(LANG_OBJ_RULES)

# Contains recipes for how to build each
LANG_RULES_DIR		:= $(abspath $(CACHE_DIR)/lang_rules/$(SUBDIR))

$(LANG_RULES_DIR): $(CACHE_DIR)
	$Q$(MKDIR) $@

# Langs dirs 
$(LANG_OBJS_DIR): $(BUILD_SUBDIR)
	$Q$(MKDIR) $@

include makefiles/langs/c.mak

include $(wildcard $(LANG_OBJ_RULES))

