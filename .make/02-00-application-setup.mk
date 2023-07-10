##@ [Application: Setup]

.PHONY: composer
composer: ## Run composer commands. Specify the command e.g. via ARGS="install"
	$(EXECUTE_IN_APPLICATION_CONTAINER) composer $(ARGS);
