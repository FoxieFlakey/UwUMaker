# Not applies recursively
UwUMaker-dirs-y += app common

# Global flags (applies recursively)
UwUMaker-c-flags-y			+= -g -DIM_FROM_ROOT_MAKEFILE=1

# Linker flags for final Executable
# (applies only to top makefile)
UwUMaker-linker-flags-y += -lpthread -lm

# y mean yes (default), Generates file named Executable
# m mean module, Generates file named lib.so
# n mean no, Generates file named lib.a
# Applies only to top makefile
UwUMaker-is-executable = y

# List of pkg config libs
# Applies only to top makefile
UwUMaker-pkg-config-libs-y += zlib

