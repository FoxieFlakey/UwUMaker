# Initial makefile to chain call
# to real makefiles/MainUwUMaker.mak

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

define task_rule
.EXPORT_ALL_VARIABLES:
.NOTPARALLEL:
.PHONY: $1
$1:
	@$(MAKE) -f UwUMakerMain.mak PROJECT_DIR="$(ABS_PROJECT_DIR)" $1
endef

# Create individual tasks
$(foreach goal, $(GOALS_TO_RUN), $(eval $(call task_rule,$(goal))))

