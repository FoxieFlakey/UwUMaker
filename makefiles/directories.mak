# This prepares the directories

$(BUILD_DIR):
	$Q$(MKDIR) $@

$(TEMP_DIR):
	$Q$(MKDIR) $@

$(CACHE_DIR):
	$Q$(MKDIR) $@

$(OBJS_DIR): | $(BUILD_DIR)
	$Q$(MKDIR) $@

