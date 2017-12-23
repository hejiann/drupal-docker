#!/bin/sh

docker pull jianhe/drupal

docker rm -f drupal
docker run -d --name drupal jianhe/drupal
if [ -d ./web.old ]; then
  sudo rm ./web.old -rf
fi
if [ -d ./web ]; then
  mv ./web ./web.old
fi
sudo docker cp drupal:/var/www/html ./web
docker stop drupal
docker rm drupal

sudo chown www-data.www-data ./web -R
sudo chmod g+w ./web -R

