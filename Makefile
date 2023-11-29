# Initial makefile to chain call
# to real makefiles/MainUwUMaker.mak

MAKEFLAGS :=--no-print-directory

ifndef PROJECT_DIR
  $(error Please pass PROJECT_DIR)
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

