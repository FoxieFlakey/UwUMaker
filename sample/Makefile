# Not applies recursively
UwUMaker-dirs-y += app common

# Global flags (applies recursively)
UwUMaker-c-flags-y += -fvisibility=hidden -g -DIM_FROM_ROOT_MAKEFILE=1 \
	-I$(PROJECT_DIR)/extra_lib_static/include \
	-I$(PROJECT_DIR)/extra_lib_shared/include

# Linker flags for final Executable
# (applies only to top makefile)
UwUMaker-linker-flags-y += -lpthread -lm

# y mean yes, Generates file named Executable
# m mean module, Generates file named lib.so
# n mean no, Generates file named lib.a
# Applies only to top makefile
UwUMaker-is-executable := y

UwUMaker-name := Sample

# List of pkg config libs
# Applies only to top makefile
UwUMaker-pkg-config-libs-y += zlib

# List of subprojects to link with
# also accepts absolute and relative
# path like $(PROJECT_DIR)/extra_lib
# or ../extra_lib and be realpath'ed

# Link as .a archive (e.g. for common only available
# to same project)
UwUMaker-static-lib-subprojects-y += $(PROJECT_DIR)/extra_lib_static
# Link as .so archive (e.g. for available to other
# subproject and to external program to link with)
UwUMaker-shared-lib-subprojects-y += extra_lib_shared

# Project which will be always be kept updated
# e.g. would be for compiling additional tool
# or additional libraries
UwUMaker-always-subprojects-y += helper_program

.PHONY: proj_hi
proj_hi:
	$Q$(ECHO) "Hiiiii from $@ UwU"


