##@ [Application: Commands]

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
enable-xdebug: ## Enable xdebug in the given container specified by "DOCKER_SERVICE_NAME". E.g. "make enable-xdebug DOCKER_SERVICE_NAME=php-fpm"
	"$(MAKE)" execute-in-container APP_USER_NAME="root" DOCKER_SERVICE_NAME=$(DOCKER_SERVICE_NAME) COMMAND="sed -i 's/.*zend_extension=xdebug/zend_extension=xdebug/' '/etc/php8/conf.d/zz-app-local.ini'"

.PHONY: disable-xdebug
disable-xdebug: ## Disable xdebug in the given container specified by "DOCKER_SERVICE_NAME". E.g. "make enable-xdebug DOCKER_SERVICE_NAME=php-fpm"
	"$(MAKE)" execute-in-container APP_USER_NAME="root" DOCKER_SERVICE_NAME=$(DOCKER_SERVICE_NAME) COMMAND="sed -i 's/.*zend_extension=xdebug/;zend_extension=xdebug/' '/etc/php8/conf.d/zz-app-local.ini'"
