.DEFAULT_GOAL := check_config

.PHONY: check_config
check_config:
	$(SHELL) ./scripts/check_file.sh "$(CONFIG_PATH)" "Config file doesn't exist at '$(CONFIG_PATH)', please generate one"

