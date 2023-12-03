# Configuration management

# Create config file for corresponding language
KCONFIG_LANGS := lua h sh rs
KCONFIG_KNOBS_DIR	:= $(CACHE_DIR)/knobs
KCONFIG_LANG_CONFIG_DIR	:= $(CACHE_DIR)/config/generated
KCONFIG_LANG_CONFIG_FILES	:= $(foreach lang,$(KCONFIG_LANGS),$(KCONFIG_LANG_CONFIG_DIR)/kconfig_config.$(lang))

$(KCONFIG_LANG_CONFIG_DIR): $(CACHE_DIR)
	$Q$(MKDIR) $@

$(KCONFIG_KNOBS_DIR): $(CACHE_DIR)
	$Q$(MKDIR) $@

.PHONY: cmd_menuconfig
cmd_menuconfig: $(TEMP_DIR)/Kconfig
	$(Q)cd $(PROJECT_DIR) && kconfig-mconf $<

.PHONY: cmd_config
cmd_config: $(TEMP_DIR)/Kconfig
	$(Q)cd $(PROJECT_DIR) && kconfig-conf $<

.PHONY: cmd_kconfig_clean
cmd_kconfig_clean: | $(CACHE_DIR)
	@$(PRINT_STATUS) CLEAN "Deleting config files for all languages"
	-$Q$(RM) $(KCONFIG_LANG_CONFIG_FILES)
	@$(PRINT_STATUS) CLEAN "Deleting knobs"
	-$Q$(RM) $(KCONFIG_KNOBS_DIR)/CONFIG_*

.PHONY: $(TEMP_DIR)/Kconfig
ifeq (,$(wildcard $(PROJECT_DIR)/Kconfig))
# Project dont have kconfig so give empty
$(TEMP_DIR)/Kconfig: | $(TEMP_DIR)
	$Q$(TOUCH) $@
else
$(TEMP_DIR)/Kconfig: $(PROJECT_DIR)/Kconfig | $(TEMP_DIR)
	@$(PRINT_STATUS) PREPROC "Preprocessing $<"
	$Q$(LUA) scripts/kconfig/preprocess.lua < $< > $@
endif

$(DOTCONFIG_PATH):
	$Q$(STDERR) Please run cmd_config
	$Q$(EXIT) 1

define kconfig_gen_config_rule
$1: $(DOTCONFIG_PATH) | $(CACHE_DIR) $(KCONFIG_LANG_CONFIG_DIR)
	$Q$(PRINT_STATUS) GEN_CONFIG 'Generating config file for $(suffix $1)'; $(LUA) scripts/kconfig/gen_$(subst .,,$(suffix $1))_config.lua < $$< >$$@

endef

$(foreach config_file,$(KCONFIG_LANG_CONFIG_FILES),$(eval $(call kconfig_gen_config_rule,$(config_file))))

$(KCONFIG_KNOBS_DIR)/knobs_dummy.mak: $(DOTCONFIG_PATH) | $(KCONFIG_KNOBS_DIR)
	@$(PRINT_STATUS) UPDATE "Updating knobs"
	$Q$(LUA) scripts/kconfig/update_knobs.lua
	$Q$(STDOUT) "Content don't matter UwU only update time so make know when to do its thing UwU" > $@
	$Q$(TOUCH) $@

# If creating configuration or cleaning,
# don't load config
ifeq (,$(filter cmd_menuconfig cmd_config cmd_clean,$(MAKECMDGOALS)))
include $(DOTCONFIG_PATH)
endif

.PHONY: kconfig_update_knobs
kconfig_update_knobs: $(KCONFIG_KNOBS_DIR)/knobs_dummy.mak
	$(NOP)

.PHONY: kconfig_gen_config_files
kconfig_gen_config_files: kconfig_update_knobs $(KCONFIG_LANG_CONFIG_FILES) 
	$(NOP)

# Create new knob for nonexisting
$(KCONFIG_KNOBS_DIR)/%:
	$Qtouch '$@'



