FROM debian:stretch
MAINTAINER Jian He <hejian.he@gmail.com>
ENV DEBIAN_FRONTEND noninteractive

# Install basic system
RUN apt-get update
RUN apt-get install -y \
  cron \
  curl \
  git \
  sudo \
  wget

# Install Apache/MySQL/PHP
RUN apt-get install -y \
  apache2 \
  mysql-server \
  php-apcu \
  php-cli \
  php-mysql \
  php-gd \
  php-curl \
  libapache2-mod-php

# Setup apcu
RUN echo 'apc.shm_size=64M' >> /etc/php/7.0/mods-available/apcu.ini

# Setup PHP
RUN sed -i 's/memory_limit = 128M/memory_limit = 256M/' /etc/php/7.0/apache2/php.ini && \
  sed -i 's/memory_limit = 128M/memory_limit = 256M/' /etc/php/7.0/cli/php.ini && \
  sed -i 's/;date.timezone =/date.timezone = Asia\/Shanghai/' /etc/php/7.0/apache2/php.ini && \
  sed -i 's/;date.timezone =/date.timezone = Asia\/Shanghai/' /etc/php/7.0/cli/php.ini && \
  sed -i 's/post_max_size = 8M/post_max_size = 16M/' /etc/php/7.0/apache2/php.ini && \
  sed -i 's/post_max_size = 8M/post_max_size = 16M/' /etc/php/7.0/cli/php.ini && \
  sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 16M/' /etc/php/7.0/apache2/php.ini && \
  sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 16M/' /etc/php/7.0/cli/php.ini
# eva module need always_populate_raw_post_data PHP setting be set to -1
RUN sed -i 's/;always_populate_raw_post_data = -1/always_populate_raw_post_data = -1/' /etc/php/7.0/apache2/php.ini && \
  sed -i 's/;always_populate_raw_post_data = -1/always_populate_raw_post_data = -1/' /etc/php/7.0/cli/php.ini

# Setup Apache
RUN sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
RUN a2enmod rewrite && \
  a2enmod ssl && \
  a2ensite default-ssl.conf

# Setup MySQL, bind on all addresses.
RUN sed -i -e 's/^bind-address\s*=\s*127.0.0.1/#bind-address = 127.0.0.1/' /etc/mysql/my.cnf

# Install memcached
RUN apt-get install -y \
  memcached \
  php-memcached

# Install varnish
RUN apt-get install -y \
  varnish
COPY default.vcl /etc/varnish/default.vcl

# Install Supervisor
RUN apt-get install -y \
  supervisor

# Setup Supervisor.
RUN echo '[program:apache2]\ncommand=/bin/bash -c "source /etc/apache2/envvars && exec /usr/sbin/apache2 -DFOREGROUND"\nautorestart=true\n\n' >> /etc/supervisor/supervisord.conf
RUN echo '[program:mysql]\ncommand=/usr/bin/pidproxy /var/run/mysqld/mysqld.pid /usr/sbin/mysqld\nautorestart=true\n\n' >> /etc/supervisor/supervisord.conf
RUN echo '[program:sshd]\ncommand=/usr/sbin/sshd -D\n\n' >> /etc/supervisor/supervisord.conf
RUN echo '[program:cron]\ncommand=cron -f\nautorestart=false \n\n' >> /etc/supervisor/supervisord.conf
RUN echo '[program:memcached]\ncommand=/usr/bin/memcached -m 64 -p 11211 -u memcache -l 127.0.0.1\nautorestart=true\n\n' >> /etc/supervisor/supervisord.conf
RUN echo '[program:varnish]\ncommand=/usr/sbin/varnishd -P /run/varnishd.pid -a :6081 -T localhost:6082 -f /etc/varnish/default.vcl -S /etc/varnish/secret -s malloc,256m\nautorestart=true\n\n' >> /etc/supervisor/supervisord.conf

RUN apt-get clean

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php
#RUN curl -sS https://install.phpcomposer.com/installer | php
RUN mv composer.phar /usr/local/bin/composer
#RUN composer config -g repo.packagist composer https://packagist.phpcomposer.com

# Install yarn
# webpack needs node version >=5.10
RUN curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
RUN apt-get install -y nodejs

RUN curl -sS http://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
RUN sudo apt-get update && sudo apt-get install yarn

# Finish
EXPOSE 80 3306 22 443 6081
CMD exec supervisord -n

