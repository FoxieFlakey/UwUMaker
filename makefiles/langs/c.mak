# C language support

LANG_C_OBJS_DIR		:= $(LANG_OBJS_DIR)/c
LANG_C_OBJS				:= $(UwUMaker-c-sources-y:%.c=$(LANG_C_OBJS_DIR)/%.o)
LANG_C_RULES			:= $(UwUMaker-c-sources-y:%=$(LANG_RULES_SUBDIR)/%.d)

LANG_OBJS					+= $(LANG_C_OBJS)
LANG_OBJ_RULES		+= $(LANG_C_RULES)
LANG_COMPILE_COMMAND_FRAGMENT_FILES += $(LANG_C_OBJS:%=%_compile_command.json)

$(LANG_C_OBJS_DIR): | $(LANG_OBJS_DIR) 
	$Q$(MKDIR) $@

# This C flags applies recursively
# Therefore export to child
#export UwUMaker-c-flags-y

$(LANG_C_OBJS_DIR)/%.o: compile_flags = -xc -c $< $(UwUMaker-c-flags-y) -I$(KCONFIG_LANG_CONFIG_DIR)/.. -I$(PROJECT_DIR) -MT $@ -MP -MMD -MF $(<:$(ABSOLUTE_SUBDIR)/%=$(LANG_RULES_SUBDIR)/%.d) -o $@
$(LANG_C_OBJS_DIR)/%.o: $(ABSOLUTE_SUBDIR)/%.c $(KCONFIG_LANG_CONFIG_DIR)/kconfig_config.h | $(LANG_C_OBJS_DIR) $(LANG_RULES_SUBDIR) $(TEMP_DIR)
	@$(PRINT_STATUS) CC "$(SUBDIR)/$(<:$(ABSOLUTE_SUBDIR)/%=%)"
	@# Create dirs needed to place the outputs
	$Q$(MKDIR) $(dir $@) $(dir $(<:$(ABSOLUTE_SUBDIR)/%=$(LANG_RULES_SUBDIR)/%.d))	
	$Q$(LUA) scripts/lang/gen_compile_command_json_fragment.lua "$(BUILD_DIR)" "$<" "$@" "$(CC) $(compile_flags)" > $(@:%=%_compile_command.json)
	$Qcd $(BUILD_DIR) && $(CC) $(compile_flags)
	$QCFLAGS="$(UwUMaker-c-flags-y)" $(SHELL) scripts/lang/c/gen_config_dep.sh "$2"





