FROM jianhe/business_core
MAINTAINER Jian He <hejian.he@gmail.com>

# Install projects
RUN git clone git://git.drupal.org/project/projects.git /var/www/html/modules/projects

# Finish
EXPOSE 80 3306 22 443
CMD exec supervisord -n

