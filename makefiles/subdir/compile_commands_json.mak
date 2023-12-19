# Collects individual compile_commands.json from subdir
# and each generated fragments

# compile_commands.json in each subdir
$(BUILD_SUBDIR)/compile_commands.json: $(COMPILE_COMMAND_FILES)
	$Q$(LUA) scripts/subdir/merge_compile_command_json.lua $^ > $@

