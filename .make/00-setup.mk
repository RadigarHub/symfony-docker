##@ [Setup]

help:
	@printf '%-43s \033[1mDefault values: \033[0m     \n'
	@printf '%-43s ===================================\n'
	@printf '%-43s ENV: \033[31m "$(ENV)" \033[0m     \n'
	@printf '%-43s TAG: \033[31m "$(TAG)" \033[0m     \n'
	@printf '%-43s ===================================\n'
	@printf '%-43s \033[3mRun the following command to start:\033[0m\n'
	@printf '%-43s \033[1mmake setup-init\033[0m\n'
	@awk 'BEGIN {FS = ":.*##"; printf "\n\033[1mUsage:\033[0m\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-40s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' Makefile .make/*.mk

.PHONY: setup-init
setup-init: ## Run this command once after cloning the repo to initialize everything (make, docker, ...)
	@printf	"$(GREEN)Initializing 'make' environment$(NO_COLOR)\n"
	"$(MAKE)" -s setup-env
	@printf	"$(GREEN)Verifying local tools$(NO_COLOR)\n"
	"$(MAKE)" -s setup-verify-tools
	@printf	"$(GREEN)Verifying 'docker compose' version$(NO_COLOR)\n"
	"$(MAKE)" -s setup-verify-docker-compose
	@printf	"$(GREEN)Initializing 'docker' environment$(NO_COLOR)\n"
	"$(MAKE)" -s docker-env
	@printf	"$(GREEN)Initializing user$(NO_COLOR)\n"
	"$(MAKE)" -s setup-user
	@printf	"$(GREEN)Copying the 'behat.yml.dist' file to 'behat.yml'$(NO_COLOR)\n"
	cp ./behat.yml.dist ./behat.yml
	@printf	"$(GREEN)Copying the 'phpspec.yml.dist' file to 'phpspec.yml'$(NO_COLOR)\n"
	cp ./phpspec.yml.dist ./phpspec.yml
	@printf	"$(GREEN)Building docker setup$(NO_COLOR)\n"
	"$(MAKE)" -s docker-build
	@printf	"$(GREEN)Starting docker setup$(NO_COLOR)\n"
	"$(MAKE)" -s docker-up
	@printf	"$(GREEN)Installing composer dependencies$(NO_COLOR)\n"
	"$(MAKE)" -s composer-install
	@printf	"$(GREEN)DONE$(NO_COLOR)\n"
	@echo ""
	@printf	"==> You should now be able to open http://127.0.0.1/ and see the UI\n"
	@echo ""

ENVS?=ENV=local TAG=latest
.PHONY: setup-env
setup-env: ## Initializes the local .makefile/.env file with ENV variables for make. Use via ENVS="KEY_1=value1 KEY_2=value2"
	@$(if $(ENVS),,$(error ENVS is undefined))
	@rm -f .make/.env
	@for variable in $(ENVS); do \
	  echo $$variable | tee -a .make/.env > /dev/null 2>&1; \
	done
	@echo "Created a local .make/.env file"

.PHONY: setup-user
setup-user: ## Set the correct user id and group id for linux users to avoid permission issues
	@if [ "$(OS)" = "Linux" ]; then \
		printf "APP_USER_ID=%s\n" $$(id -u) >> .make/.env; \
		printf "APP_GROUP_ID=%s\n" $$(id -g) >> .make/.env; \
	else \
		printf "$(YELLOW)Nothing to do (not a Linux system)$(NO_COLOR)\n"; \
	fi;

.PHONY: setup-verify-docker-compose
setup-verify-docker-compose: ## Verify, that docker uses compose version >= v2.5
	@compose_version=$$(docker compose version | cut  -c 25-); \
	result=`.make/scripts/compare_version.sh "$$compose_version" "<" "2.5"`; \
	if [ "$$result" = "0" ]; then \
		printf "$(RED)Your version of docker compose is $$compose_version. It has to be >= 2.5 => Please update compose$(NO_COLOR)\n"; \
		exit 1; \
	else \
		printf "$(YELLOW)Your version of docker compose is $$compose_version (>= 2.5) => All good.$(NO_COLOR)\n"; \
	fi;

# see https://stackoverflow.com/a/677212/413531
.PHONY: setup-verify-tools
setup-verify-tools: ## Verify, that the necessary tools exist locally
	@tools="docker bash"; \
	for tool in $$tools; do \
		command -v $$tool >/dev/null 2>&1 || { printf "$(RED)Command '$$tool' not found$(NO_COLOR)\n"; exit 1; } \
	done;
	@printf "$(YELLOW)All tools exist$(NO_COLOR)\n";
