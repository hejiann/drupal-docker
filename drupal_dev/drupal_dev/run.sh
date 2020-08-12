#!/bin/sh

docker build --no-cache -t jianhe/drupal_dev . && \
  docker push jianhe/drupal_dev
