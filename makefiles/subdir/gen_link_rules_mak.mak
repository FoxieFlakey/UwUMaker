# The idea is having a link_rules.mak
# which drives the overall linking process
# which indirectly drives compilation

LINK_RULES_FILE := $(BUILD_SUBDIR)/link_rules.mak

# TODO: Somehow properly tell to update
# via make prereq
.PHONY: $(LINK_RULES_FILE)

ifneq (/,$(SUBPROJECT))
$(LINK_RULES_FILE): export IS_SUBPROJECT := 1
else
$(LINK_RULES_FILE): export IS_SUBPROJECT := 0
endif
$(LINK_RULES_FILE): export SHARED_LIB_EXTENSION := $(SHARED_LIB_EXTENSION)
$(LINK_RULES_FILE): export STATIC_LIB_EXTENSION := $(STATIC_LIB_EXTENSION)
$(LINK_RULES_FILE): export LINK_FLAGS 		:= $(UwUMaker-linker-flags-y)
$(LINK_RULES_FILE): export SHARED_OBJECTS := $(DYNAMIC_LINK_OBJECTS)
$(LINK_RULES_FILE): export STATIC_OBJECTS := $(STATIC_LINK_OBJECTS)
$(LINK_RULES_FILE): export ALWAYS_OBJECTS := $(ALWAYS_OBJECTS)
$(LINK_RULES_FILE): export COMPILE_COMMANDS_FILES := $(BUILD_SUBDIR)/compile_commands.json $(SUBDIR_SUBPROJECTS_COMPILE_COMMANDS_JSON)
$(LINK_RULES_FILE): export ARCHIVE_NAME 	:= $(ARCHIVE_NAME)
$(LINK_RULES_FILE): export COMPILE_COMMANDS_JSON_OUTPUT := $(abspath $(BUILD_DIR)/compile_commands.json)
$(LINK_RULES_FILE): export LINK_OUTPUT 		:= $(FINAL_PRODUCT)
$(LINK_RULES_FILE): export OBJS_DIR				:= $(OBJS_DIR)
$(LINK_RULES_FILE): export OUTPUT_TYPE 		:= $(FINAL_PRODUCT_TYPE)
$(LINK_RULES_FILE): export SAVE_AS				:= $(LINK_RULES_FILE)
$(LINK_RULES_FILE): export EXTRA_INCLUDES	:= $(SUBDIR_LINK_RULES) 
$(LINK_RULES_FILE): | $(BUILD_DIR) $(BUILD_SUBDIR)
	$Q$(LUA) scripts/subdir/gen_link_rules_mak.lua






