FROM php:7.1.14-fpm

MAINTAINER Maju Ansari



EXPOSE 9000 9111
# COPY ./conf/www.conf /usr/local/etc/php-fpm.d/www.conf

COPY ./conf/www.conf /usr/local/etc/php-fpm/www.conf
COPY ./conf/php.ini /usr/local/etc/php/php.ini

COPY src/ /var/www/html
COPY src/ /code/public/
# cleanup
USER root
RUN apt-get clean && \
	rm -rfv \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*