##@ [Application: Setup]

.PHONY: composer
composer: ## Run composer commands. Specify the command e.g. via ARGS="install"
	$(EXECUTE_IN_APPLICATION_CONTAINER) composer $(ARGS);

.PHONY: setup-db
setup-db: ## Setup the DB tables
	$(EXECUTE_IN_APPLICATION_CONTAINER) php bin/console doctrine:database:create $(ARGS);
