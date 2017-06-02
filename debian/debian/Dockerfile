FROM debian:jessie
MAINTAINER Jian He <hejian.he@gmail.com>
ENV DEBIAN_FRONTEND noninteractive

# Install basic system
RUN sed -i 's/deb.debian.org/mirrors.163.com/' /etc/apt/sources.list
RUN sed -i 's/security.debian.org/mirrors.163.com\/debian-security/' /etc/apt/sources.list
ENV DEBIAN_VERSION 20170511
RUN apt-get update
RUN apt-get install -y \
  bash-completion \
  command-not-found \
  cron \
  curl \
  git \
  mc \
  openssh-server \
  sudo \
  wget

COPY .inputrc /root/.inputrc

ENV TERM=xterm-256color \
  LANG=C.UTF-8

RUN echo "PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '" >> /root/.bashrc

RUN update-command-not-found

# Install vim
RUN apt-get install -y \
  exuberant-ctags \
  vim \
  vim-ctrlp \
  vim-fugitive \
  vim-pathogen \
  vim-syntastic \
  vim-tabular \
  vim-ultisnips \
  vim-youcompleteme

RUN vim-addons install \
  ctrlp \
  matchit \
  youcompleteme

RUN set -x; \
  mkdir -p /root/.vim/bundle \
  && cd /root/.vim/bundle/ \
  && git clone --depth 1 https://github.com/scrooloose/nerdtree.git \
  && git clone --depth 1 https://github.com/majutsushi/tagbar.git \
  && git clone --depth 1 https://github.com/mbbill/echofunc.git \
  && git clone --depth 1 https://github.com/vim-airline/vim-airline.git \
  && git clone --depth 1 https://github.com/ap/vim-css-color.git \
  && git clone --depth 1 https://github.com/evidens/vim-twig.git \
  && git clone --depth 1 https://github.com/derekwyatt/vim-scala.git \
  && git clone --depth 1 https://github.com/kchmck/vim-coffee-script.git

COPY .vimrc /root/.vimrc

# Install MySQL
RUN apt-get install -y \
  mysql-server

# Install PHP
RUN apt-get install -y \
  apache2 \
  php-apc \
  php5-cli \
  php5-mysql \
  php5-gd \
  php5-curl \
  php5-xdebug \
  libapache2-mod-php5 \
  phpmyadmin

# Setup PHP
RUN sed -i 's/display_errors = Off/display_errors = On/' /etc/php5/apache2/php.ini
RUN sed -i 's/display_errors = Off/display_errors = On/' /etc/php5/cli/php.ini
RUN sed -i 's/memory_limit = 128M/memory_limit = 256M/' /etc/php5/apache2/php.ini
RUN sed -i 's/memory_limit = 128M/memory_limit = 256M/' /etc/php5/cli/php.ini
RUN sed -i 's/;date.timezone =/date.timezone = Asia\/Shanghai/' /etc/php5/apache2/php.ini
RUN sed -i 's/;date.timezone =/date.timezone = Asia\/Shanghai/' /etc/php5/cli/php.ini
# eva module need always_populate_raw_post_data PHP setting be set to -1
RUN sed -i 's/;always_populate_raw_post_data = -1/always_populate_raw_post_data = -1/' /etc/php5/apache2/php.ini
RUN sed -i 's/;always_populate_raw_post_data = -1/always_populate_raw_post_data = -1/' /etc/php5/cli/php.ini

# Setup Apache
RUN sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
RUN a2enmod rewrite
RUN a2enmod ssl
RUN a2ensite default-ssl.conf

# Setup PHPMyAdmin
RUN echo "\n# Include PHPMyAdmin configuration\nInclude /etc/phpmyadmin/apache.conf\n" >> /etc/apache2/apache2.conf
RUN sed -i -e "s/\/\/ \$cfg\['Servers'\]\[\$i\]\['AllowNoPassword'\]/\$cfg\['Servers'\]\[\$i\]\['AllowNoPassword'\]/g" /etc/phpmyadmin/config.inc.php
RUN sed -i -e "s/\$cfg\['Servers'\]\[\$i\]\['\(table_uiprefs\|history\)'\].*/\$cfg\['Servers'\]\[\$i\]\['\1'\] = false;/g" /etc/phpmyadmin/config.inc.php

# Setup MySQL, bind on all addresses.
RUN sed -i -e 's/^bind-address\s*=\s*127.0.0.1/#bind-address = 127.0.0.1/' /etc/mysql/my.cnf

# Setup XDebug
RUN echo "xdebug.max_nesting_level = 300" >> /etc/php5/apache2/conf.d/20-xdebug.ini
RUN echo "xdebug.max_nesting_level = 300" >> /etc/php5/cli/conf.d/20-xdebug.ini
RUN echo "xdebug.remote_enable = on" >> /etc/php5/apache2/conf.d/20-xdebug.ini

# Install Supervisor
RUN apt-get install -y \
  supervisor

# Setup Supervisor.
RUN echo '[program:apache2]\ncommand=/bin/bash -c "source /etc/apache2/envvars && exec /usr/sbin/apache2 -DFOREGROUND"\nautorestart=true\n\n' >> /etc/supervisor/supervisord.conf
RUN echo '[program:mysql]\ncommand=/usr/bin/pidproxy /var/run/mysqld/mysqld.pid /usr/sbin/mysqld\nautorestart=true\n\n' >> /etc/supervisor/supervisord.conf
RUN echo '[program:sshd]\ncommand=/usr/sbin/sshd -D\n\n' >> /etc/supervisor/supervisord.conf
RUN echo '[program:cron]\ncommand=cron -f\nautorestart=false \n\n' >> /etc/supervisor/supervisord.conf

RUN apt-get clean

# Install Composer
#RUN curl -sS https://getcomposer.org/installer | php
RUN curl -sS https://install.phpcomposer.com/installer | php
RUN mv composer.phar /usr/local/bin/composer
RUN composer config -g repo.packagist composer https://packagist.phpcomposer.com

# Finish
EXPOSE 80 3306 22 443
CMD exec supervisord -n

