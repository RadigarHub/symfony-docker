ARG ALPINE_VERSION
ARG COMPOSER_VERSION
FROM composer:${COMPOSER_VERSION} as composer
FROM alpine:${ALPINE_VERSION} as base

# make build args available as ENV variables to downstream images
# so that we don't have to pass the same build args again
ARG APP_USER_ID
ARG APP_GROUP_ID
ARG APP_USER_NAME
ARG APP_GROUP_NAME
ARG APP_CODE_PATH
ARG TARGET_PHP_VERSION
ARG ALPINE_VERSION
ARG ENV
ENV APP_USER_ID=${APP_USER_ID}
ENV APP_GROUP_ID=${APP_GROUP_ID}
ENV APP_USER_NAME=${APP_USER_NAME}
ENV APP_GROUP_NAME=${APP_GROUP_NAME}
ENV APP_CODE_PATH=${APP_CODE_PATH}
ENV TARGET_PHP_VERSION=${TARGET_PHP_VERSION}
ENV ALPINE_VERSION=${ALPINE_VERSION}
ENV ENV=${ENV}

RUN addgroup -g $APP_GROUP_ID $APP_GROUP_NAME && \
	adduser -D -u $APP_USER_ID -s /bin/bash $APP_USER_NAME -G $APP_GROUP_NAME && \
	mkdir -p $APP_CODE_PATH && \
	chown $APP_USER_NAME: $APP_CODE_PATH

RUN apk add --update --no-cache \
		bash \
		git \
		make \
		sudo \
		vim

# install PHP
RUN apk --update-cache add ca-certificates && \
	apk add --update --no-cache  \
		php${TARGET_PHP_VERSION} \
		php${TARGET_PHP_VERSION}-ctype \
		php${TARGET_PHP_VERSION}-curl \
		php${TARGET_PHP_VERSION}-dom \
		php${TARGET_PHP_VERSION}-iconv \
		php${TARGET_PHP_VERSION}-intl \
		php${TARGET_PHP_VERSION}-mbstring \
		php${TARGET_PHP_VERSION}-opcache \
		php${TARGET_PHP_VERSION}-openssl \
		php${TARGET_PHP_VERSION}-pdo \
		php${TARGET_PHP_VERSION}-pdo_pgsql \
		php${TARGET_PHP_VERSION}-phar \
		php${TARGET_PHP_VERSION}-posix \
		php${TARGET_PHP_VERSION}-session \
		php${TARGET_PHP_VERSION}-simplexml \
		php${TARGET_PHP_VERSION}-tokenizer \
		php${TARGET_PHP_VERSION}-xml \
		php${TARGET_PHP_VERSION}-xmlwriter

# make bash default shell
RUN sed -e 's;/bin/ash$;/bin/bash;g' -i /etc/passwd

COPY ./images/php/base/conf.d/zz-app.ini /etc/php${TARGET_PHP_VERSION}/conf.d/
COPY ./images/php/base/conf.d/zzz-app-${ENV}.ini /etc/php${TARGET_PHP_VERSION}/conf.d/

COPY --chown=$APP_USER_NAME:$APP_GROUP_NAME ./images/php/base/.bashrc /home/${APP_USER_NAME}/.bashrc
COPY ./images/php/base/.bashrc /root/.bashrc

COPY --from=composer /usr/bin/composer /usr/local/bin/composer

WORKDIR $APP_CODE_PATH

FROM base as local

# add app user to sudoers
# see https://ostechnix.com/add-delete-and-grant-sudo-privileges-to-users-in-alpine-linux/ for adding sudo
# see https://askubuntu.com/a/340669 for not requiring a sudo pw
RUN echo "root ALL=(ALL) NOPASSWD: ALL " | tee -a "/etc/sudoers.d/users" && \
	echo "${APP_USER_NAME} ALL=(ALL) NOPASSWD: ALL " | tee -a "/etc/sudoers.d/users"

RUN apk add --no-cache --update \
		postgresql-client \
		php${TARGET_PHP_VERSION}-xdebug \
	# ensure that xdebug is not enabled by default
	&& rm -f /etc/php${TARGET_PHP_VERSION}/conf.d/00_xdebug.ini
