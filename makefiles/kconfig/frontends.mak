cmd_%config: export KCONFIG_CONFIG=$(DOTCONFIG_PATH)

# Foxie still doesnt know what the purpose
# of SRCTREE to kconfig
# SRCTREE=$(PROJECT_DIR)

.PHONY: cmd_menuconfig
cmd_menuconfig: $(KCONFIG_PREPROCESSED_DIR)/Kconfig | $(KCONFIG_PREPROCESSED_DIR)
	$(Q)cd $(KCONFIG_PREPROCESSED_DIR) && kconfig-mconf $<

.PHONY: cmd_config
cmd_config: $(KCONFIG_PREPROCESSED_DIR)/Kconfig | $(KCONFIG_PREPROCESSED_DIR)
	$(Q)cd $(KCONFIG_PREPROCESSED_DIR) && kconfig-conf $<

.PHONY: cmd_oldconfig
cmd_oldconfig: $(KCONFIG_PREPROCESSED_DIR)/Kconfig | $(KCONFIG_PREPROCESSED_DIR)
	$(Q)cd $(KCONFIG_PREPROCESSED_DIR) && kconfig-conf --oldaskconfig $<

.PHONY: cmd_olddefconfig
cmd_olddefconfig: $(KCONFIG_PREPROCESSED_DIR)/Kconfig | $(KCONFIG_PREPROCESSED_DIR)
	$(Q)cd $(KCONFIG_PREPROCESSED_DIR) && kconfig-conf --olddefconfig $<

.PHONY: cmd_randconfig
cmd_randconfig: $(KCONFIG_PREPROCESSED_DIR)/Kconfig | $(KCONFIG_PREPROCESSED_DIR)
	$(Q)cd $(KCONFIG_PREPROCESSED_DIR) && kconfig-conf --randconfig $<

.PHONY: cmd_allyesconfig
cmd_allyesconfig: $(KCONFIG_PREPROCESSED_DIR)/Kconfig | $(KCONFIG_PREPROCESSED_DIR)
	$(Q)cd $(KCONFIG_PREPROCESSED_DIR) && kconfig-conf --allyesconfig $<

.PHONY: cmd_allnoconfig
cmd_allnoconfig: $(KCONFIG_PREPROCESSED_DIR)/Kconfig | $(KCONFIG_PREPROCESSED_DIR)
	$(Q)cd $(KCONFIG_PREPROCESSED_DIR) && kconfig-conf --allnoconfig $<

.PHONY: cmd_allmodconfig
cmd_allmodconfig: $(KCONFIG_PREPROCESSED_DIR)/Kconfig | $(KCONFIG_PREPROCESSED_DIR)
	$(Q)cd $(KCONFIG_PREPROCESSED_DIR) && KCONFIG_CONFIG=$(DOTCONFIG_PATH) kconfig-conf --allmodconfig $<

.PHONY: cmd_alldefconfig
cmd_alldefconfig: $(KCONFIG_PREPROCESSED_DIR)/Kconfig | $(KCONFIG_PREPROCESSED_DIR)
	$(Q)cd $(KCONFIG_PREPROCESSED_DIR) && KCONFIG_CONFIG=$(DOTCONFIG_PATH) kconfig-conf --alldefconfig $<


