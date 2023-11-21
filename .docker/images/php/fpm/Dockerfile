ARG BASE_IMAGE
FROM ${BASE_IMAGE} as base

RUN echo ${TARGET_PHP_VERSION}
RUN apk add --no-cache --update \
		php${TARGET_PHP_VERSION}-fpm \
# make "php-fpm" as command available by creating a symlink
	&& ln -s /usr/sbin/php-fpm${TARGET_PHP_VERSION} /usr/bin/php-fpm

COPY ./images/php/fpm/php-fpm.d/ /etc/php${TARGET_PHP_VERSION}/php-fpm.d/
COPY ./images/php/fpm/conf.d/zzz-app-fpm.ini /etc/php${TARGET_PHP_VERSION}/conf.d/

RUN sed -i "s/__APP_USER_NAME/$APP_USER_NAME/" /etc/php${TARGET_PHP_VERSION}/php-fpm.d/* \
	&& sed -i "s/__APP_GROUP_NAME/$APP_GROUP_NAME/" /etc/php${TARGET_PHP_VERSION}/php-fpm.d/*

USER $APP_USER_NAME

EXPOSE 9000

CMD ["php-fpm", "-F"]

FROM base as local
