#!/bin/bash

docker pull jianhe/debian

docker rm -f debian
docker run -d --name debian jianhe/debian
if [ -d ./web.old ]; then
  rm -rf ./web.old
fi
if [ -d ./web ]; then
  mv ./web ./web.old
fi
sudo docker cp debian:/var/www/html ./web
docker stop debian
docker rm debian

sudo chown -R www-data.www-data ./web
sudo chmod -R g+w ./web

