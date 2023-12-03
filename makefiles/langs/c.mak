# C language support

LANG_C_RULES_DIR	:= $(LANG_RULES_DIR)
LANG_C_OBJS_DIR		:= $(LANG_OBJS_DIR)/c
LANG_C_OBJS				:= $(UwUMaker-c-sources-y:%.c=$(LANG_C_OBJS_DIR)/%.o)
LANG_C_RULES			:= $(UwUMaker-c-sources-y:%.c=$(LANG_C_RULES_DIR)/%.d)

LANG_OBJS					+= $(LANG_C_OBJS)
LANG_OBJ_RULES		+= $(LANG_C_RULES)

$(LANG_C_OBJS_DIR): $(LANG_OBJS_DIR) 
	$Q$(MKDIR) $@
#$(LANG_C_RULES_DIR): $(LANG_RULES_DIR) 
#	$Q$(MKDIR) $@

# This C flags applies recursively
# Therefore export to child
export UwUMaker-c-flags-y

# TODO: Smartly determine when file needed to be updated
# 			if the CONFIG_ option which affects it changes
# 			(probably grep trickery or something)
define lang_c_compile
$1: $2 $(KCONFIG_LANG_CONFIG_DIR)/kconfig_config.h | $(LANG_C_OBJS_DIR) $(LANG_C_RULES_DIR)
	@$(PRINT_STATUS) CC "$(SUBDIR)/$(2:$(ABSOLUTE_SUBDIR)/%=%)"
	$Q$(CC) -c $2 $(UwUMaker-c-flags-y) -I$(KCONFIG_LANG_CONFIG_DIR)/.. -I$(PROJECT_DIR) -MT $1 -MP -MMD -MF $(2:$(ABSOLUTE_SUBDIR)/%.c=$(LANG_C_RULES_DIR)/%.d) -o $1

endef

# Create a recipe for compiling each source file
$(foreach obj,$(LANG_C_OBJS),$(eval $(call lang_c_compile,$(obj),$(obj:$(LANG_C_OBJS_DIR)/%.o=$(ABSOLUTE_SUBDIR)/%.c))))



