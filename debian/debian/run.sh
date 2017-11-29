#!/bin/sh

docker build --no-cache -t jianhe/debian . && \
  docker push jianhe/debian
