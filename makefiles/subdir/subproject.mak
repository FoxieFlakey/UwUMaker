# Subproject support

# List of subprojects
ALWAYS_SUBPROJECTS := 
STATIC_LIB_SUBPROJECTS := 
SHARED_LIB_SUBPROJECTS := 

define process_paths
$2 += $$(foreach v,$$($1), $$(if $$(filter /%,$$v),$$v,$$(realpath $(ABSOLUTE_SUBDIR)/$$v)) )
endef

# Absolutify paths
$(eval $(call process_paths,UwUMaker-always-subprojects-y,ALWAYS_SUBPROJECTS))
$(eval $(call process_paths,UwUMaker-static-lib-subprojects-y,STATIC_LIB_SUBPROJECTS))
$(eval $(call process_paths,UwUMaker-shared-lib-subprojects-y,SHARED_LIB_SUBPROJECTS))

# List of subprojects' outputs
ALWAYS_OBJECTS := $(ALWAYS_SUBPROJECTS:$(ROOT_PROJECT_DIR)%=$(ROOT_OBJS_DIR)%/output_path.txt)
STATIC_LINK_OBJECTS := $(STATIC_LIB_SUBPROJECTS:$(ROOT_PROJECT_DIR)%=$(ROOT_OBJS_DIR)%/output_path.txt)
DYNAMIC_LINK_OBJECTS := $(SHARED_LIB_SUBPROJECTS:$(ROOT_PROJECT_DIR)%=$(ROOT_OBJS_DIR)%/output_path.txt)

# Add this as prereq and make will execute
.PHONY: alt_phony
alt_phony:

# List current subdir's subprojects's project dir to be
# kept up to date
SUBDIR_SUBPROJECTS := $(filter $(ABSOLUTE_SUBDIR)%,$(ALWAYS_SUBPROJECTS) $(STATIC_LIB_SUBPROJECTS) $(SHARED_LIB_SUBPROJECTS))
SUBDIR_SUBPROJECTS_COMPILE_COMMANDS_JSON := $(SUBDIR_SUBPROJECTS:$(ABSOLUTE_SUBDIR)/%=$(BUILD_SUBDIR)/%/compile_commands.json)

# Phonified targets for each subproject
SUBDIR_SUBPROJECTS_TARGETS := $(SUBDIR_SUBPROJECTS:%=/phonified_subproject/%)

# Communicate to subproject that
# it should be producing this output type
STATIC_LIB_SUBPROJECTS_TARGETS := $(STATIC_LIB_SUBPROJECTS:%=/phonified_subproject/%)
$(STATIC_LIB_SUBPROJECTS_TARGETS): export EXPECTED_IS_EXECUTABLE := n

SHARED_LIB_SUBPROJECTS_TARGETS := $(SHARED_LIB_SUBPROJECTS:%=/phonified_subproject/%)
$(SHARED_LIB_SUBPROJECTS_TARGETS): export EXPECTED_IS_EXECUTABLE := m

/phonified_subproject/%: SUBPROJECT = $(@:/phonified_subproject/$(ROOT_PROJECT_DIR)%=%)
/phonified_subproject/%: export SUBPROJECT_SHARED_CACHE_DIR = $(CACHE_DIR)
/phonified_subproject/%: export SUBPROJECT_CACHE_DIR = $(abspath $(ROOT_CACHE_DIR)/subproject/$(SUBPROJECT))
/phonified_subproject/%: export SUBPROJECT_LANG_RULES_DIR = $(abspath $(ROOT_LANG_RULES_DIR)/$(SUBPROJECT))
/phonified_subproject/%: export SUBPROJECT_DOTCONFIG_PATH = $(DOTCONFIG_PATH)
/phonified_subproject/%: export SUBPROJECT_BUILD_DIR = $(abspath $(ROOT_OBJS_DIR)/$(SUBPROJECT))
/phonified_subproject/%: export SUBPROJECT_DIR = $(abspath $(ROOT_PROJECT_DIR)/$(SUBPROJECT))
/phonified_subproject/%: alt_phony | $(BUILD_SUBDIR)
	$Q$(MAKE) -f makefiles/subdir/call_subproj_trampoline.mak -C $(UWUMAKER_DIR) $(MAKECMDGOALS)

# Acts like call_subdir but sets proper
# variables for subproject
.PHONY: call_subprojects
call_subprojects: $(SUBDIR_SUBPROJECTS:%=/phonified_subproject/%)
	$(NOP)




