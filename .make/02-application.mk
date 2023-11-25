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
	"$(MAKE)" composer ARGS="install --prefer-dist --no-progress --no-scripts --no-interaction --optimize-autoloader"
	"$(MAKE)" composer ARGS="dump-autoload --classmap-authoritative"

.PHONY: db-schema
db-schema: ## Create DB schema
	$(EXECUTE_IN_APPLICATION_CONTAINER) php bin/console doctrine:schema:create $(ARGS)
