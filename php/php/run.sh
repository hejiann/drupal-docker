#!/bin/sh

docker build --no-cache -t jianhe/php . && \
  docker push jianhe/php
