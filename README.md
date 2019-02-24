# drupal-docker
Docker for Drupal development environment.

This docker contains full Drupal environment, including Apache, MySQL, PHP, Drupal and some must include third party tools. And included a install-drupal.sh script for quick install.

The basic pattern for starting a drupal instance is:
```
$ cd drupal
$ docker-compose up -d
```
