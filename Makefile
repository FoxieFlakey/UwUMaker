# Initial makefile to chain call
# to real MainUwUMaker.mak

MAKEFLAGS += --no-print-directory -rR

# TODO: fix all undefined var usage and add this
#--warn-undefined-variables 

ifndef PROJECT_DIR
  $(error "Please pass PROJECT_DIR")
endif

ifneq (1,$(words [$(PROJECT_DIR)]))
	$(error "Please put PROJECT_DIR in path without spaces (there some little bugs about path with spaces -w- its currently broken")
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
endif

$(TEMP_DIR):
	@mkdir -p "$@"

# Shell no-op
NOP := @:

.PHONY: alt_phony
alt_phony:
	$(NOP)

# Apparently make trigger Makefile target???
Makefile:
	$(NOP)

unexport TEMP_DIR_GENERATED
unexport ABS_PROJECT_DIR
unexport GOALS_TO_RUN
unexport NOP

# Do not pass command line overrides
# use env for the rest of make
MAKEOVERRIDES :=

# Properly delete in exit
.EXPORT_ALL_VARIABLES:
.NOTPARALLEL:
cmd_%: PROJECT_DIR := $(ABS_PROJECT_DIR)
cmd_%: alt_phony
ifdef TEMP_DIR_GENERATED
	@trap 'rm -rf $(TEMP_DIR)' EXIT; \
	$(MAKE) -ef UwUMakerMain.mak $@
else
	@$(MAKE) -ef UwUMakerMain.mak $@
endif



