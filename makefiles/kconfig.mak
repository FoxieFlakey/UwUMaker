# Configuration management

# Create config file for corresponding language
KCONFIG_LANGS := lua h sh rs
KCONFIG_KNOBS_DIR	:= $(CACHE_DIR)/knobs
KCONFIG_LANG_CONFIG_DIR	:= $(CACHE_DIR)/config/generated
KCONFIG_LANG_CONFIG_FILES	:= $(foreach lang,$(KCONFIG_LANGS),$(KCONFIG_LANG_CONFIG_DIR)/kconfig_config.$(lang))
KCONFIG_PREPROCESSED_DIR	:= $(TEMP_DIR)/kconfig_preproc

include makefiles/kconfig/frontends.mak

.PHONY: cmd_kconfig_clean
cmd_kconfig_clean: | $(CACHE_DIR)
	@$(PRINT_STATUS) CLEAN "Deleting config files for all languages"
	-$Q$(RM) -f $(KCONFIG_LANG_CONFIG_FILES)
	@$(PRINT_STATUS) CLEAN "Deleting knobs"
	-$Q$(RM) -f $(KCONFIG_KNOBS_DIR)/CONFIG_*

$(KCONFIG_LANG_CONFIG_DIR): $(CACHE_DIR)
	$Q$(MKDIR) $@

$(KCONFIG_KNOBS_DIR): $(CACHE_DIR)
	$Q$(MKDIR) $@

$(KCONFIG_PREPROCESSED_DIR): $(TEMP_DIR)
	$Q$(MKDIR) $@

.PHONY: $(TEMP_DIR)/Kconfig
ifeq (,$(wildcard $(PROJECT_DIR)/Kconfig))
# Project dont have kconfig so give empty
$(KCONFIG_PREPROCESSED_DIR)/Kconfig: | $(KCONFIG_PREPROCESSED_DIR)
	@$(PRINT_STATUS) PREPROC "Kconfig not preprocessed, project has no Kconfig"
	$Q$(TOUCH) $@
else
# Phony because preprocessing also calls to
# shell which may provide different output
.PHONY: $(KCONFIG_PREPROCESSED_DIR)/Kconfig
$(KCONFIG_PREPROCESSED_DIR)/Kconfig: $(PROJECT_DIR)/Kconfig | $(KCONFIG_PREPROCESSED_DIR)
	@$(PRINT_STATUS) PREPROC "Preprocessing $<"
	$Q$(LUA) scripts/kconfig/preprocess.lua "$(PROJECT_DIR)" "$(KCONFIG_PREPROCESSED_DIR)"

endif

$(DOTCONFIG_PATH):
	$Q$(STDERR) Please run cmd_config
	$Q$(EXIT) 1

$(KCONFIG_LANG_CONFIG_DIR)/%: $(DOTCONFIG_PATH) | $(CACHE_DIR) $(KCONFIG_LANG_CONFIG_DIR)
	$Q$(PRINT_STATUS) GEN_CONFIG 'Generating config file for $(suffix $@)'
	$Q$(LUA) scripts/kconfig/gen_$(subst .,,$(suffix $@))_config.lua < $< >$@

$(KCONFIG_KNOBS_DIR)/knobs_dummy.txt: $(DOTCONFIG_PATH) | $(KCONFIG_KNOBS_DIR)
	@$(PRINT_STATUS) UPDATE "Updating knobs"
	$Q$(LUA) scripts/kconfig/update_knobs.lua
	$Q$(STDOUT) "Content don't matter UwU only update time so make know when to do its thing UwU" > $@
	$Q$(TOUCH) $@

# Create new knob for nonexisting
$(KCONFIG_KNOBS_DIR)/%:
	$Q$(TOUCH) '$@'

# If creating configuration or cleaning,
# don't load config
ifeq (,$(filter cmd_menuconfig cmd_config cmd_clean,$(MAKECMDGOALS)))
include $(DOTCONFIG_PATH)
endif

.PHONY: kconfig_update_knobs
kconfig_update_knobs: $(KCONFIG_KNOBS_DIR)/knobs_dummy.txt
	$(NOP)

.PHONY: kconfig_gen_config_files
kconfig_gen_config_files: kconfig_update_knobs $(KCONFIG_LANG_CONFIG_FILES) 
	$(NOP)




