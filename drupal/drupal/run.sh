#!/bin/sh

docker build --no-cache -t jianhe/drupal . && \
  docker push jianhe/drupal
