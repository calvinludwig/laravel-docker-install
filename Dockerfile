ARG PHP_VERSION=8.4

FROM serversideup/php:${PHP_VERSION}-fpm-nginx AS base

USER root

RUN apt-get update \
  && apt-get install \
  neovim \
  --no-install-recommends -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && install-php-extensions intl redis

USER www-data

WORKDIR /var/www/html

############################################
# Development Image
############################################
# https://serversideup.net/open-source/docker-php/docs/guide/understanding-file-permissions#example
FROM base AS development
USER root
ARG USER_ID
ARG GROUP_ID
RUN docker-php-serversideup-set-id www-data $USER_ID:$GROUP_ID \
  && docker-php-serversideup-set-file-permissions \
  --owner $USER_ID:$GROUP_ID \
  --service nginx

RUN apt-get update \
  && apt-get install \
  npm \
  --no-install-recommends -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && install-php-extensions pcov

USER www-data

RUN composer install && npm install

############################################
# Production Image
############################################
FROM base AS production
COPY --chown=www-data:www-data . /var/www/html
RUN composer install --no-dev --optimize-autoloader --no-interaction \
  && composer clear-cache \
  && npm install --prod
