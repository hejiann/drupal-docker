#!/bin/sh

docker build --no-cache -t 114.215.42.138:5000/drupal . && \
  docker push 114.215.42.138:5000/drupal
