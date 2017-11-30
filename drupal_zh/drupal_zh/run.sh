#!/bin/sh

docker build --no-cache -t jianhe/drupal_zh . && \
  docker push jianhe/drupal_zh
