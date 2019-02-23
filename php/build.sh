#!/bin/bash

docker pull 114.215.42.138:5000/php

docker rm -f php
docker run -d --name php 114.215.42.138:5000/php
if [ -d ./web.old ]; then
  rm -rf ./web.old
fi
if [ -d ./web ]; then
  mv ./web ./web.old
fi
sudo docker cp php:/var/www/html ./web
docker stop php
docker rm php

sudo chown -R www-data.www-data ./web
sudo chmod -R g+w ./web

