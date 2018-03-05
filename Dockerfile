FROM php:5.6-apache






#########
#  PHP  #
#########

COPY php.ini $PHP_INI_DIR


RUN export DEBIAN_FRONTEND=noninteractive; \
    apt-get update && apt-get install -y \
    git  ghostscript  at  ssed  \
    sendmail-bin sendmail  \
    zlib1g-dev  firebird-dev  libsqlite3-dev  \
    libedit-dev  libicu-dev  libpq-dev  libpng12-dev  \
    libbz2-dev  libfreetype6-dev  libjpeg-dev  libxml2-dev  \
    libcurl3  libcurl4-gnutls-dev  \
&&  docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/  \
&&  docker-php-ext-install  -j$(nproc)  \
    pdo_firebird  pdo_mysql  pdo_pgsql  \
    mbstring  \
    zip  \
    intl  \
    mysqli  bz2  gd  xmlrpc  \
    opcache  \
    soap \
&&  apt-get clean \
;  pecl install xdebug-2.5.5


RUN a2enmod rewrite


# Habilita al usuario www-data para hacer uso del comando 'at'
RUN sed -i -e '/www-data/d' /etc/at.deny


# Configure timezone and locale
RUN apt-get install -y locales  \
    &&  echo "America/Bogota" > /etc/timezone  \
    &&  dpkg-reconfigure -f noninteractive tzdata  \
    &&  sed -i -e 's/# en/en/' /etc/locale.gen  \
    &&  sed -i -e 's/# es/es/' /etc/locale.gen  \
    &&  dpkg-reconfigure --frontend=noninteractive locales


# Hay problemas de compatibilidad con el sistema operativo base que dificultan
# la instalación de la extensión 'readline', por lo que se obtiene el archivo
# necesario desde el paquete php5-readline de Ubuntu 14.04
COPY readline.so /usr/lib/php5/20121212/

COPY xdebug.ini /usr/local/etc/php/conf.d/


# Virtual hosts para apache
COPY sites-available/* /etc/apache2/sites-enabled/


# Se habilita el archivo de logs de PHP
RUN (\
export LOGS_PATH=/var/log/php_errors.log; \
touch $LOGS_PATH; \
chown www-data:www-data $LOGS_PATH; \
)

RUN echo "\nServerName localhost" >> /etc/apache2/apache2.conf


# Script para mostrar los logs con colores
COPY scripts/log-colorizer.sh /usr/local/bin/log-colorizer
RUN chmod a+x /usr/local/bin/log-colorizer





COPY apache2-foreground /usr/local/bin/apache2-foreground
CMD bash apache2-foreground
