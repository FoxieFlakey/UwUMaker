# Helper program for the main sample project
# Only shares same .config

UwUMaker-dirs-y += app
UwUMaker-c-flags-y += -fvisibility=hidden \
	-I$(ROOT_PROJECT_DIR)/extra_lib_static/include \
	-I$(ROOT_PROJECT_DIR)/extra_lib_shared/include

UwUMaker-is-executable := y

# Project name excluding extension and prefix
UwUMaker-name := HelperProgram

# Testing relative and abs path
UwUMaker-static-lib-subprojects-y += $(ROOT_PROJECT_DIR)/extra_lib_static
UwUMaker-shared-lib-subprojects-y += ../extra_lib_shared


