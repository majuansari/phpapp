FROM php:7.1.14-fpm

MAINTAINER Maju Ansari

RUN apt-get update

RUN apt-get -y install vim
RUN apt-get install -y \
    freetds-dev \
    libicu-dev \
    libpq-dev \
    libmcrypt-dev \
 && cp -s /usr/lib/x86_64-linux-gnu/libsybdb.so /usr/lib/ \
 && docker-php-ext-configure pdo_mysql \
 && docker-php-ext-install \
    intl \
    mbstring \
    mcrypt \
    pcntl \
    pdo_dblib \
    pdo_mysql \
    pdo_pgsql \
    pgsql \
    zip \
    opcache


RUN apt-get install -y --no-install-recommends \
        libmagickwand-dev \
    && rm -rf /var/lib/apt/lists/* \
    && pecl install imagick-3.4.3 \
    && docker-php-ext-enable imagick

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN ls
RUN  apt-get update \
	 && apt-get install -y libgmp-dev re2c libmhash-dev
RUN ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/local/include/
RUN docker-php-ext-configure gmp
RUN docker-php-ext-install gmp

#Install php-soap
RUN apt-get install -y libxml2-dev \
    && pear install -a SOAP-0.13.0 \
    && docker-php-ext-install soap;

EXPOSE 9000 9111
# COPY ./conf/www.conf /usr/local/etc/php-fpm.d/www.conf

COPY ./conf/www.conf /usr/local/etc/php-fpm/www.conf
COPY ./conf/php.ini /usr/local/etc/php/php.ini

COPY ./src/blog /code/
COPY ./src/blog/env.txt /code/.env
COPY ./cmd /cmd
# WORKDIR /cmd
# RUN ls
# RUN ls /
WORKDIR /code
# set requirement privileges
RUN chown -R 9000:9000 storage && \
	chown -R 9000:9000 bootstrap/cache && \
	chmod -R ug+rwx    bootstrap/cache && \
	chgrp -R 9000      bootstrap/cache && \
	chmod +x artisan && \
	chmod +x /cmd/provision.sh

# cleanup
USER root
RUN apt-get clean && \
	rm -rfv \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*