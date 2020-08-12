FROM jianhe/drupal
ENV DEBIAN_FRONTEND noninteractive

# Install dev environment
RUN apt-get install -y \
  bash-completion \
  command-not-found \
  man-db \
  mc \
  mysqltuner

COPY files/.bash_aliases /root/.bash_aliases
COPY files/.inputrc /root/.inputrc

ENV TERM=xterm-256color \
  LANG=C.UTF-8

RUN echo ". /usr/share/bash-completion/bash_completion" >> /root/.bashrc
RUN echo "PS1='\${debian_chroot:+($debian_chroot)}\[\\033[01;32m\]\u@\h\[\\033[00m\]:\[\\033[01;34m\]\w\[\033[00m\]\$(__git_ps1 \"(\[\\033[01;32m\]%s\[\033[00m\])\")\\\$ '" >> /root/.bashrc
RUN echo ". ~/.bash_aliases" >> /root/.bashrc

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
  # nerd-commenter \
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

COPY files/.vimrc /root/.vimrc

# Setup apcu
# php-apcu for debian stretch does not have apc.php file
#RUN cp /usr/share/doc/php5-apcu/apc.php /var/www/html/

# Setup PHP
RUN sed -i 's/display_errors = Off/display_errors = On/' /etc/php/7.3/apache2/php.ini && \
  sed -i 's/display_errors = Off/display_errors = On/' /etc/php/7.3/cli/php.ini

# Install PHPMyAdmin
#RUN apt-get install -y \
#  phpmyadmin

# Setup PHPMyAdmin
#RUN echo "\n# Include PHPMyAdmin configuration\nInclude /etc/phpmyadmin/apache.conf\n" >> /etc/apache2/apache2.conf
#RUN sed -i -e "s/\/\/ \$cfg\['Servers'\]\[\$i\]\['AllowNoPassword'\]/\$cfg\['Servers'\]\[\$i\]\['AllowNoPassword'\]/g" /etc/phpmyadmin/config.inc.php
#RUN sed -i -e "s/\$cfg\['Servers'\]\[\$i\]\['\(table_uiprefs\|history\)'\].*/\$cfg\['Servers'\]\[\$i\]\['\1'\] = false;/g" /etc/phpmyadmin/config.inc.php

# Setup XDebug
RUN apt-get install -y \
  php-xdebug
RUN echo "xdebug.max_nesting_level = 300" >> /etc/php/7.3/apache2/conf.d/20-xdebug.ini && \
  echo "xdebug.remote_enable = on" >> /etc/php/7.3/apache2/conf.d/20-xdebug.ini && \
  echo "xdebug.profiler_enable_trigger = on" >> /etc/php/7.3/apache2/conf.d/20-xdebug.ini

# Install dev tool modules
RUN composer require \
  drupal/devel \
  drupal/config_inspector

# Enable memcache debug
#RUN echo "\$settings['memcache_storage']['debug'] = TRUE;" >> sites/default/settings.local.php

# PHPUnit testing framework version 7 or greater is required when running on PHP 7.3 or greater.
RUN composer run-script drupal-phpunit-upgrade

# update to development version
RUN cd modules/eabax && \
  sshpass -p 39cb3ae0 git pull && \
  git checkout d

# Finish
EXPOSE 80 3306 22 443
CMD exec supervisord -n

