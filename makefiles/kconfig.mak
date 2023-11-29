# Configuration management

.PHONY: cmd_menuconfig
cmd_menuconfig: $(TEMP_DIR)/Kconfig
	$(Q)cd $(PROJECT_DIR) && kconfig-mconf $<

.PHONY: cmd_config
cmd_config: $(TEMP_DIR)/Kconfig
	$(Q)cd $(PROJECT_DIR) && kconfig-conf $<

.PHONY: $(TEMP_DIR)/Kconfig
ifeq (,$(wildcard $(PROJECT_DIR)/Kconfig))
$(TEMP_DIR)/Kconfig: $(TEMP_DIR)
	$Q$(TOUCH) $@
else
$(TEMP_DIR)/Kconfig: $(PROJECT_DIR)/Kconfig $(TEMP_DIR)
	$Q$(LUA) scripts/kconfig/preprocess.lua < $< > $@
endif

$(CONFIG_PATH):
	$Q$(STDERR) Please run cmd_config
	$Q$(EXIT) 1

# If creating configuration,
# don't load config
ifeq (,$(filter cmd_menuconfig cmd_config,$(MAKECMDGOALS)))
include $(CONFIG_PATH)
endif

# Create config in corresponding language
KCONFIG_LANGS := lua h sh rs

define kconfig_gen_config_rule
$(CACHE_DIR)/kconfig.$1: $(CONFIG_PATH) $(CACHE_DIR)
	$Q$(LUA) scripts/kconfig/gen_$1_config.lua < $$< >$$@
endef

$(foreach lang, $(KCONFIG_LANGS), $(eval $(call kconfig_gen_config_rule,$(lang))))



