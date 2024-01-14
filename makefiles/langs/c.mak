# C, assembly and objc language support
# (assembly is odd piece because uses clang as driver)
#
LANG_C_OBJS_DIR		:= $(LANG_OBJS_DIR)/c
LANG_C_OBJS				:= $(UwUMaker-c-sources-y:%=$(LANG_C_OBJS_DIR)/%.o)
LANG_C_RULES			:= $(UwUMaker-c-sources-y:%=$(LANG_RULES_SUBDIR)/%.d)

LANG_AS_OBJS_DIR		:= $(LANG_OBJS_DIR)/as
LANG_AS_OBJS				:= $(UwUMaker-as-sources-y:%=$(LANG_AS_OBJS_DIR)/%.o)
LANG_AS_RULES				:= $(UwUMaker-as-sources-y:%=$(LANG_RULES_SUBDIR)/%.d)

LANG_OBJC_OBJS_DIR		:= $(LANG_OBJS_DIR)/objc
LANG_OBJC_OBJS				:= $(UwUMaker-objc-sources-y:%=$(LANG_OBJC_OBJS_DIR)/%.o)
LANG_OBJC_RULES				:= $(UwUMaker-objc-sources-y:%=$(LANG_RULES_SUBDIR)/%.d)

LANG_OBJS					+= $(LANG_C_OBJS) $(LANG_AS_OBJS) $(LANG_OBJC_OBJS)
LANG_OBJ_RULES		+= $(LANG_C_RULES) $(LANG_AS_RULES) $(LANG_OBJS_RULES)
LANG_COMPILE_COMMAND_FRAGMENT_FILES += \
	$(LANG_C_OBJS:%=%_compile_command.json) \
	$(LANG_AS_OBJS:%=%_compile_command.json) \
	$(LANG_OBJC_OBJS:%=%_compile_command.json)

$(LANG_OBJC_OBJS_DIR) $(LANG_AS_OBJS_DIR) $(LANG_C_OBJS_DIR): | $(LANG_OBJS_DIR) 
	$Q$(MKDIR) $@

# Common flags
$(LANG_OBJC_OBJS_DIR)/%.o $(LANG_C_OBJS_DIR)/%.o $(LANG_AS_OBJS_DIR)/%.o: compile_flags += $(UwUMaker-cpp-flags) -I$(KCONFIG_LANG_CONFIG_DIR)/.. -I$(PROJECT_DIR) -MT $@ -MP -MMD -MF $(<:$(ABSOLUTE_SUBDIR)/%=$(LANG_RULES_SUBDIR)/%.d) -o $@

# Per lang type flags
$(LANG_C_OBJS_DIR)/%.o: compile_flags += -xc $< -c $(UwUMaker-c-flags-y) 
$(LANG_C_OBJS_DIR)/%.o: tool := CC
$(LANG_AS_OBJS_DIR)/%.o: compile_flags += -xassembler-with-cpp $< -c $(UwUMaker-as-flags-y)
$(LANG_AS_OBJS_DIR)/%.o: tool := AS

# Inherits C flags
$(LANG_OBJC_OBJS_DIR)/%.o: compile_flags += -xobjective-c $< -c $(UwUMaker-c-flags-y) $(UwUMaker-objc-flags-y)
$(LANG_OBJC_OBJS_DIR)/%.o: tool := OBJCC

define gen_rule
$$(LANG_$1_OBJS_DIR)/%.o: $(ABSOLUTE_SUBDIR)/% $(KCONFIG_LANG_CONFIG_DIR)/kconfig_config.h | $$(LANG_$1_OBJS_DIR) $(LANG_RULES_SUBDIR) $(TEMP_DIR)
	@$(PRINT_STATUS) $$(tool) "$(SUBDIR)/$$(<:$(ABSOLUTE_SUBDIR)/%=%)"
	$Q$(MKDIR) $$(dir $$@) $$(dir $$(<:$(ABSOLUTE_SUBDIR)/%=$(LANG_RULES_SUBDIR)/%.d))	
	$Q$(LUA) scripts/lang/gen_compile_command_json_fragment.lua "$(BUILD_DIR)" "$$<" "$$@" "$(CC) $$(compile_flags)" > $$(@:%=%_compile_command.json)
	$Qcd $(BUILD_DIR) && $(CC) $$(compile_flags)

endef

$(eval $(call gen_rule,C))
$(eval $(call gen_rule,AS))
$(eval $(call gen_rule,OBJC))




