FROM jianhe/drupal
MAINTAINER Jian He <hejian.he@gmail.com>

# Install zh-hans language
RUN /etc/init.d/mysql start && \
  vendor/bin/drush en -y config_translation

RUN git clone git://git.drupal.org/project/drush_language.git -b 8.x-1.x /var/www/html/modules/drush_language
RUN /etc/init.d/mysql start && \
  vendor/bin/drush en -y drush_language

RUN mkdir -p sites/default/files/translations
COPY translations/* sites/default/files/translations/

RUN /etc/init.d/mysql start && \
  vendor/bin/drush language-add zh-hans
#RUN /etc/init.d/mysql start && drupal locale:language:add zh-hans

RUN /etc/init.d/mysql start && \
  vendor/bin/drush cset -y system.site default_langcode "zh-hans"

# Update translations
#RUN /etc/init.d/mysql start && \
#  vendor/bin/drush locale-update

#RUN /etc/init.d/mysql start && \
#  vendor/bin/drush langimp zh-hans sites/default/files/translations/drupal-8.3.x-zh-hans.po

# Finish
EXPOSE 80 3306 22 443
CMD exec supervisord -n

