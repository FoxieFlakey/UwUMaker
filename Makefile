# Initial makefile to chain call
# to real MainUwUMaker.mak

MAKEFLAGS += --no-print-directory -rR

ifndef PROJECT_DIR
  $(error "Please pass PROJECT_DIR")
endif

ifneq (1,$(words [$(PROJECT_DIR)]))
	$(error "Please put PROJECT_DIR in path without spaces (there some little bugs about path with spaces -w-")
endif

ifneq ($(PROJECT_DIR),$(abspath $(PROJECT_DIR)))
	$(error "Please put PROJECT_DIR as absolute path -w-")
endif

ABS_PROJECT_DIR := $(shell readlink -f $(PROJECT_DIR))

ifeq ($(words $(MAKECMDGOALS)),0)
GOALS_TO_RUN = cmd_all
else
GOALS_TO_RUN = $(strip $(MAKECMDGOALS))
endif

ifndef TEMP_DIR
TEMP_DIR := $(shell mktemp -d)
TEMP_DIR_GENERATED := y
unexport TEMP_DIR_GENERATED
endif

# Todo find a way to rm tmp dir
.EXPORT_ALL_VARIABLES:
.NOTPARALLEL:
.PHONY: %
%:
ifdef TEMP_DIR_GENERATED
	@trap 'rm -rf "$(TEMP_DIR)"' EXIT;	\
	$(MAKE) -f UwUMakerMain.mak PROJECT_DIR="$(ABS_PROJECT_DIR)" $@
else
	@$(MAKE) -f UwUMakerMain.mak PROJECT_DIR="$(ABS_PROJECT_DIR)" $@
endif


