### theme building example
# FROM node:17.3.0-alpine3.15 AS builder

# WORKDIR /var/theme

# COPY ./webroot/themes/custom/some_theme/ .

FROM composer:2.2.4 AS composer

COPY var/www/composer.json /var/www/composer.json
COPY var/www/composer.lock /var/www/composer.lock
COPY var/www/patches /var/www/patches
COPY var/www/scripts /var/www/scripts

WORKDIR /var/www

RUN composer install

FROM ubuntu:22.04 AS image

ARG WEB_ROOT=/var/www/
ENV WEB_ROOT=$WEB_ROOT
ENV DEBIAN_FRONTEND noninteractive

# Add composer
COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY packages.txt /tmp/packages.txt

RUN apt-get update && \
	apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages --no-install-recommends \
		ca-certificates \
		apt-utils \
		apt-transport-https \
		locales \
		gpg-agent \
		software-properties-common && \
	add-apt-repository ppa:ondrej/php && \
	apt-get update && \
	xargs -a /tmp/packages.txt apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages --no-install-recommends && \
	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	addgroup --gid 1000 http && \
	adduser http --gid 1000 --disabled-password --no-create-home --disabled-login --gecos "" && \
	a2dismod mpm_event && \
	a2enmod \
		expires \
		headers \
		rewrite \
		alias \
		actions \
		fcgid \
		proxy_fcgi \
		setenvif \
		mpm_worker \
		proxy \
		proxy_http \
		rewrite \
		ssl \
		proxy_balancer \
		remoteip \
		http2

# add custom apache.confg and rootfiles
COPY etc/ /etc
COPY --chown=http:http var/www /var/www
COPY --chown=http:http --from=composer /var/www/ /var/www/

# Copy bootstrap scripts
COPY scripts/ /bootstrap/

EXPOSE 80
WORKDIR ${WEB_ROOT}

# send it
CMD ["/bootstrap/start.sh"]
