# C language support

LANG_C_OBJS_DIR		:= $(LANG_OBJS_DIR)/c
LANG_C_OBJS				:= $(UwUMaker-c-sources-y:%.c=$(LANG_C_OBJS_DIR)/%.o)
LANG_C_RULES			:= $(UwUMaker-c-sources-y:%.c=$(LANG_C_RULES_DIR)/%.d)

LANG_OBJS					+= $(LANG_C_OBJS)
LANG_OBJ_RULES		+= $(LANG_C_RULES)

$(LANG_C_OBJS_DIR): $(LANG_OBJS_DIR) 
	$Q$(MKDIR) $@

# This C flags applies recursively
# Therefore export to child
export UwUMaker-c-flags-y

UwUMaker-c-flags-y += -I$(KCONFIG_LANG_CONFIG_DIR)/.. -I$(PROJECT_DIR)  
define lang_c_compile
$1: $2 $(KCONFIG_LANG_CONFIG_DIR)/kconfig_config.h | $(dir $2) $(LANG_C_OBJS_DIR) $(LANG_RULES_DIR) $(TEMP_DIR)
	@$(PRINT_STATUS) CC "$(SUBDIR)/$(2:$(ABSOLUTE_SUBDIR)/%=%)"

	@# Create dirs needed to place the outputs
	$Q$(MKDIR) $(dir $1) $(dir $(2:$(ABSOLUTE_SUBDIR)/%=$(LANG_RULES_DIR)/%.d))
	
	$Q$(CC) -c $2 $(UwUMaker-c-flags-y) -MT $1 -MP -MMD -MF $(2:$(ABSOLUTE_SUBDIR)/%=$(LANG_RULES_DIR)/%.d) -o $1
	$QCFLAGS="$(UwUMaker-c-flags-y)" $(SHELL) scripts/lang/c/gen_config_dep.sh "$2"

endef

# Create a recipe for compiling each source file
$(foreach obj,$(LANG_C_OBJS),$(eval $(call lang_c_compile,$(obj),$(obj:$(LANG_C_OBJS_DIR)/%.o=$(ABSOLUTE_SUBDIR)/%.c))))



