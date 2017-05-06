FROM debian:jessie
MAINTAINER Jian He <hejian.he@gmail.com>
ENV DEBIAN_FRONTEND noninteractive

# Install basic system
RUN sed -i 's/deb.debian.org/mirrors.163.com/' /etc/apt/sources.list
RUN sed -i 's/security.debian.org/mirrors.163.com\/debian-security/' /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y \
  bash-completion \
  command-not-found \
  cron \
  curl \
  git \
  mc \
  openssh-server \
  sudo

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

# Setup Apache
RUN sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
RUN a2enmod rewrite
RUN a2enmod ssl
RUN a2ensite default-ssl.conf

# Setup PHPMyAdmin
RUN echo "\n# Include PHPMyAdmin configuration\nInclude /etc/phpmyadmin/apache.conf\n" >> /etc/apache2/apache2.conf
RUN sed -i -e "s/\/\/ \$cfg\['Servers'\]\[\$i\]\['AllowNoPassword'\]/\$cfg\['Servers'\]\[\$i\]\['AllowNoPassword'\]/g" /etc/phpmyadmin/config.inc.php

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
RUN curl -sS https://install.phpcomposer.com/installer | php
RUN mv composer.phar /usr/local/bin/composer
RUN composer config -g repo.packagist composer https://packagist.phpcomposer.com

# Install Drush
RUN composer global require drush/drush
# Unfortunately, adding the composer vendor dir to the PATH doesn't seem to work. So:
RUN ln -s /root/.composer/vendor/bin/drush /usr/local/bin/drush

# Install Drupal
RUN rm -rf /var/www/html
RUN git clone git://git.drupal.org/project/drupal.git -b 8.3.x /var/www/html

WORKDIR /var/www/html

RUN composer install

# Install Drupal modules
RUN composer require \
  drupal/address \
  drupal/block_class \
  drupal/default_content \
  drupal/features \
  drupal/field_formatter_class \
  drupal/inline_entity_form \
  drupal/jsonapi \
  drupal/menu_block \
  drupal/migrate_source_csv \
  drupal/paragraphs \
  drupal/panels \
  drupal/php \
  drupal/state_machine \
  drupal/restui \
  drupal/token

# Install page_manager
RUN git clone git://git.drupal.org/project/page_manager.git -b 8.x-4.x /var/www/html/modules/page_manager
# Patch: Custom attributes in blocks
RUN apt-get install -y wget && \
  cd /var/www/html/modules/page_manager && \
  wget https://www.drupal.org/files/issues/2710169-block-attributes-24.patch && \
  patch -p1 < 2710169-block-attributes-24.patch && \
  rm 2710169-block-attributes-24.patch

# Patch: No hook alter to override Field Widget wrappers created by WidgetBase::form
RUN wget https://www.drupal.org/files/issues/2872162-field-widget-hook-3.patch && \
  patch -p1 < 2872162-field-widget-hook-3.patch && \
  rm 2872162-field-widget-hook-3.patch

# Install Drupal site
RUN mkdir -p /var/www/html/sites/default/files && \
  chmod a+rw /var/www/html/sites/default -R && \
  cp /var/www/html/sites/default/default.settings.php /var/www/html/sites/default/settings.php && \
  cp /var/www/html/sites/default/default.services.yml /var/www/html/sites/default/services.yml && \
  chmod a+rw /var/www/html/sites/default/settings.php && \
  chmod a+rw /var/www/html/sites/default/services.yml && \
  chown -R www-data:www-data /var/www/html/

RUN /etc/init.d/mysql start && \
  drush site-install -y --account-pass=admin --db-url=mysql://root:@localhost/drupal && \
  drush en -y simpletest
# big_pipe will let page_manager not work: https://www.drupal.org/node/2868216

# Twig Debug
RUN sed -i 's/debug: false/debug: true/' /var/www/html/sites/default/services.yml && \
  sed -i 's/auto_reload: null/auto_reload: true/' /var/www/html/sites/default/services.yml

# Setup basic dev environment
RUN /etc/init.d/mysql start && \
  drush cset -y system.performance css.preprocess 0 && \
  drush cset -y system.performance js.preprocess 0

# Setup extended dev environment
RUN /etc/init.d/mysql start && \
  drush en -y page_manager_ui && \
  drush en -y panels && \
  drush en -y features_ui

# Clearing cache via UI in translated language resets config translation of field labels to default language
# https://www.drupal.org/node/2650434
RUN wget https://www.drupal.org/files/issues/clearing_cache_via_ui-2650434-128.patch && \
  patch -p1 < clearing_cache_via_ui-2650434-128.patch && \
  rm clearing_cache_via_ui-2650434-128.patch

# Patch: View output is not used for entityreference options
RUN wget https://www.drupal.org/files/issues/2174633-143-entity-reference.patch && \
  patch -p1 < 2174633-143-entity-reference.patch && \
  rm 2174633-143-entity-reference.patch

# Finish
EXPOSE 80 3306 22 443
CMD exec supervisord -n

