FROM jianhe/business_core
MAINTAINER Jian He <hejian.he@gmail.com>

RUN composer require drupal/reference_table_formatter

# Install bs_inveotory
RUN git clone git://git.drupal.org/project/bs_inventory.git /var/www/html/modules/bs_inventory

RUN /etc/init.d/mysql start && \
  vendor/bin/drush en -y bs_inventory

# Finish
EXPOSE 80 3306 22 443
CMD exec supervisord -n

