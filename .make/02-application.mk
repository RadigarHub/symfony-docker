##@ [Application]

.PHONY: execute-in-container
execute-in-container: ## Execute a command in a container. E.g. via "make execute-in-container DOCKER_SERVICE_NAME=php-fpm COMMAND="echo 'hello'"
	@$(if $(DOCKER_SERVICE_NAME),,$(error DOCKER_SERVICE_NAME is undefined))
	@$(if $(COMMAND),,$(error COMMAND is undefined))
	$(EXECUTE_IN_ANY_CONTAINER) $(COMMAND)

# @see https://stackoverflow.com/a/43076457
.PHONY: restart-php-fpm
restart-php-fpm: ## Restart the php-fpm service
	"$(MAKE)" execute-in-container DOCKER_SERVICE_NAME=$(DOCKER_SERVICE_NAME_PHP_FPM) COMMAND="kill -USR2 1"

.PHONY: enable-xdebug
enable-xdebug: ## Enable xdebug in the php based containers.
	"$(MAKE)" execute-in-container APP_USER_NAME="root" DOCKER_SERVICE_NAME=$(DOCKER_SERVICE_NAME_PHP_FPM) COMMAND='bash -i -c "sed -i \"s/.*zend_extension=xdebug/zend_extension=xdebug/\" \$$$$PHP_INI_PATH/conf.d/zzz-app-local.ini"'
	"$(MAKE)" restart-php-fpm

.PHONY: disable-xdebug
disable-xdebug: ## Disable xdebug in the php based containers.
	"$(MAKE)" execute-in-container APP_USER_NAME="root" DOCKER_SERVICE_NAME=$(DOCKER_SERVICE_NAME_PHP_FPM) COMMAND='bash -i -c "sed -i \"s/.*zend_extension=xdebug/;zend_extension=xdebug/\" \$$$$PHP_INI_PATH/conf.d/zzz-app-local.ini"'
	"$(MAKE)" restart-php-fpm

.PHONY: composer
composer: ## Run composer commands. Specify the command e.g. via ARGS="install"
	$(EXECUTE_IN_APPLICATION_CONTAINER) composer $(ARGS)

.PHONY: composer-install
composer-install: ## Install composer dependencies
	"$(MAKE)" composer ARGS="install --prefer-dist --no-progress --no-scripts --no-interaction"

.PHONY: lint
lint: ## Check the application code and display suggestions to address linting issues
	"$(MAKE)" execute-in-container DOCKER_SERVICE_NAME=$(DOCKER_SERVICE_NAME_PHP_FPM) COMMAND="vendor/bin/ecs check"

.PHONY: lint-fix
lint-fix: ## Check the application code and lint issues
	"$(MAKE)" execute-in-container DOCKER_SERVICE_NAME=$(DOCKER_SERVICE_NAME_PHP_FPM) COMMAND="vendor/bin/ecs check --fix"

.PHONY: static-analysis
static-analysis: ## Run a static analysis of the application code
	"$(MAKE)" execute-in-container DOCKER_SERVICE_NAME=$(DOCKER_SERVICE_NAME_PHP_FPM) COMMAND="vendor/bin/psalm"

.PHONY: test
test: test-unit test-integration test-application ## Run all tests of the application

.PHONY: test-unit
test-unit: ## Run all unit tests of the application
	"$(MAKE)" execute-in-container DOCKER_SERVICE_NAME=$(DOCKER_SERVICE_NAME_PHP_FPM) COMMAND="bin/phpunit --order-by=random --testsuite Unit"

.PHONY: test-integration
test-integration: ## Run all integration tests of the application
	"$(MAKE)" execute-in-container DOCKER_SERVICE_NAME=$(DOCKER_SERVICE_NAME_PHP_FPM) COMMAND="bin/phpunit --order-by=random --testsuite Integration"

.PHONY: test-application
test-application: ## Run all application tests of the application
	"$(MAKE)" execute-in-container DOCKER_SERVICE_NAME=$(DOCKER_SERVICE_NAME_PHP_FPM) COMMAND="bin/phpunit --order-by=random --testsuite Application"

.PHONY: test-coverage
test-coverage: ## Run test coverage for the application. First you need to run command "make enable-xdebug".
	"$(MAKE)" execute-in-container DOCKER_SERVICE_NAME=$(DOCKER_SERVICE_NAME_PHP_FPM) COMMAND="bin/phpunit --coverage-text --coverage-clover=coverage.xml --order-by=random"
