.PHONY: cmd_menuconfig
cmd_menuconfig: $(KCONFIG_PREPROCESSED_DIR)/Kconfig | $(KCONFIG_PREPROCESSED_DIR)
	$(Q)cd $(KCONFIG_PREPROCESSED_DIR) && SRCTREE=$(PROJECT_DIR) kconfig-mconf $<

.PHONY: cmd_config
cmd_config: $(KCONFIG_PREPROCESSED_DIR)/Kconfig | $(KCONFIG_PREPROCESSED_DIR)
	$(Q)cd $(KCONFIG_PREPROCESSED_DIR) && KCONFIG_CONFIG=$(DOTCONFIG_PATH) kconfig-conf $<

.PHONY: cmd_oldconfig
cmd_oldconfig: $(KCONFIG_PREPROCESSED_DIR)/Kconfig | $(KCONFIG_PREPROCESSED_DIR)
	$(Q)cd $(KCONFIG_PREPROCESSED_DIR) && KCONFIG_CONFIG=$(DOTCONFIG_PATH) kconfig-conf --oldaskconfig $<

.PHONY: cmd_olddefconfig
cmd_olddefconfig: $(KCONFIG_PREPROCESSED_DIR)/Kconfig | $(KCONFIG_PREPROCESSED_DIR)
	$(Q)cd $(KCONFIG_PREPROCESSED_DIR) && KCONFIG_CONFIG=$(DOTCONFIG_PATH) kconfig-conf --olddefconfig $<

.PHONY: cmd_randconfig
cmd_randconfig: $(KCONFIG_PREPROCESSED_DIR)/Kconfig | $(KCONFIG_PREPROCESSED_DIR)
	$(Q)cd $(KCONFIG_PREPROCESSED_DIR) && KCONFIG_CONFIG=$(DOTCONFIG_PATH) kconfig-conf --randconfig $<

.PHONY: cmd_allyesconfig
cmd_allyesconfig: $(KCONFIG_PREPROCESSED_DIR)/Kconfig | $(KCONFIG_PREPROCESSED_DIR)
	$(Q)cd $(KCONFIG_PREPROCESSED_DIR) && KCONFIG_CONFIG=$(DOTCONFIG_PATH) kconfig-conf --allyesconfig $<

.PHONY: cmd_allnoconfig
cmd_allnoconfig: $(KCONFIG_PREPROCESSED_DIR)/Kconfig | $(KCONFIG_PREPROCESSED_DIR)
	$(Q)cd $(KCONFIG_PREPROCESSED_DIR) && KCONFIG_CONFIG=$(DOTCONFIG_PATH) kconfig-conf --allnoconfig $<

.PHONY: cmd_allmodconfig
cmd_allmodconfig: $(KCONFIG_PREPROCESSED_DIR)/Kconfig | $(KCONFIG_PREPROCESSED_DIR)
	$(Q)cd $(KCONFIG_PREPROCESSED_DIR) && KCONFIG_CONFIG=$(DOTCONFIG_PATH) kconfig-conf --allmodconfig $<

.PHONY: cmd_alldefconfig
cmd_alldefconfig: $(KCONFIG_PREPROCESSED_DIR)/Kconfig | $(KCONFIG_PREPROCESSED_DIR)
	$(Q)cd $(KCONFIG_PREPROCESSED_DIR) && KCONFIG_CONFIG=$(DOTCONFIG_PATH) kconfig-conf --alldefconfig $<

.PHONY: cmd_kconfig_clean
cmd_kconfig_clean: | $(CACHE_DIR)
	@$(PRINT_STATUS) CLEAN "Deleting config files for all languages"
	-$Q$(RM) -f $(KCONFIG_LANG_CONFIG_FILES)
	@$(PRINT_STATUS) CLEAN "Deleting knobs"
	-$Q$(RM) -f $(KCONFIG_KNOBS_DIR)/CONFIG_*

