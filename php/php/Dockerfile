FROM debian:stretch
ENV DEBIAN_FRONTEND noninteractive

ENV DEBIAN_VERSION 20190529
RUN apt-get update && apt-get dist-upgrade -y

# Install Apache/MySQL/PHP
RUN apt-get install -y \
  apache2 \
  mysql-server \
  php-cli \
  libapache2-mod-php

# Setup MySQL
RUN sed -i -e 's/^bind-address\s*=\s*127.0.0.1/#bind-address = 127.0.0.1/' /etc/mysql/mariadb.conf.d/50-server.cnf && \
  /etc/init.d/mysql start && \
  mysql -e "update user set plugin='' where User='root'; flush privileges;" mysql

# Setup Apache
RUN sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
RUN a2enmod rewrite && \
  a2enmod ssl && \
  a2ensite default-ssl.conf

# Setup PHP
RUN sed -i 's/memory_limit = 128M/memory_limit = 1024M/' /etc/php/7.0/apache2/php.ini && \
  sed -i 's/memory_limit = 128M/memory_limit = 1024M/' /etc/php/7.0/cli/php.ini && \
  sed -i 's/;date.timezone =/date.timezone = Asia\/Shanghai/' /etc/php/7.0/apache2/php.ini && \
  sed -i 's/;date.timezone =/date.timezone = Asia\/Shanghai/' /etc/php/7.0/cli/php.ini && \
  sed -i 's/post_max_size = 8M/post_max_size = 128M/' /etc/php/7.0/apache2/php.ini && \
  sed -i 's/post_max_size = 8M/post_max_size = 128M/' /etc/php/7.0/cli/php.ini && \
  sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 128M/' /etc/php/7.0/apache2/php.ini && \
  sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 128M/' /etc/php/7.0/cli/php.ini && \
  sed -i 's/max_execution_time = 30/max_execution_time = 64/' /etc/php/7.0/apache2/php.ini && \
  sed -i 's/max_execution_time = 30/max_execution_time = 64/' /etc/php/7.0/cli/php.ini
# eva module need always_populate_raw_post_data PHP setting be set to -1
RUN sed -i 's/;always_populate_raw_post_data = -1/always_populate_raw_post_data = -1/' /etc/php/7.0/apache2/php.ini && \
  sed -i 's/;always_populate_raw_post_data = -1/always_populate_raw_post_data = -1/' /etc/php/7.0/cli/php.ini

# Install PHP extensions
RUN apt-get install -y \
  php-apcu \
  php-bcmath \
  php-curl \
  php-gd \
  php-mbstring \
  php-mysql \
  php-xml \
  php-zip

# Setup apcu
RUN echo 'apc.shm_size=64M' >> /etc/php/7.0/mods-available/apcu.ini

# Install memcached
RUN apt-get install -y \
  memcached \
  php-memcached

# Install varnish
RUN apt-get install -y \
  varnish
COPY files/default.vcl /etc/varnish/default.vcl

# Install composer
RUN apt-get install -y \
  composer

# Install Supervisor
RUN apt-get install -y \
  supervisor

# Setup Supervisor.
RUN echo '[program:apache2]\ncommand=/bin/bash -c "source /etc/apache2/envvars && exec /usr/sbin/apache2 -DFOREGROUND"\nautorestart=true\n\n' >> /etc/supervisor/supervisord.conf
RUN echo '[program:mysql]\ncommand=/usr/bin/pidproxy /var/run/mysqld/mysqld.pid /usr/sbin/mysqld\nautorestart=true\n\n' >> /etc/supervisor/supervisord.conf
RUN echo '[program:memcached]\ncommand=/usr/bin/memcached -m 64 -p 11211 -u memcache -l 127.0.0.1\nautorestart=true\n\n' >> /etc/supervisor/supervisord.conf
RUN echo '[program:varnish]\ncommand=/usr/sbin/varnishd -P /run/varnishd.pid -a :6081 -T localhost:6082 -f /etc/varnish/default.vcl -S /etc/varnish/secret -s malloc,256m -F\nautorestart=true\n\n' >> /etc/supervisor/supervisord.conf

RUN apt-get clean

# Finish
EXPOSE 80 3306 22 443 6081
CMD exec supervisord -n

