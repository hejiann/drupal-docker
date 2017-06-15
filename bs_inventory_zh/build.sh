#!/bin/bash

if ! type "docker" > /dev/null; then
  wget -qO- https://get.docker.com/ | sh
  #curl -sSL http://acs-public-mirror.oss-cn-hangzhou.aliyuncs.com/docker-engine/internet | sh -
fi

if ! type "docker-compose" > /dev/null; then
  sudo apt-get install -y python-pip
  sudo pip install docker-compose
fi

sudo usermod -aG docker $USER
sudo usermod -aG www-data $USER

newgrp docker <<EONG
docker pull jianhe/bs_inventory_zh
sed -i 's/volumes:/#volumes:/' docker-compose.yml
sed -i 's/- .\/web:\/var\/www\/html/#- .\/web:\/var\/www\/html/' docker-compose.yml
docker-compose up -d
if [ -d ./web.old ]; then
  sudo rm ./web.old -rf
fi
if [ -d ./web ]; then
  mv ./web ./web.old
fi
sudo docker cp bs_inventory_zh:/var/www/html ./web
docker-compose stop
sed -i 's/#volumes:/volumes:/' docker-compose.yml
sed -i 's/#- .\/web:\/var\/www\/html/- .\/web:\/var\/www\/html/' docker-compose.yml
EONG

sudo chown www-data.www-data ./web -R
sudo chmod g+w ./web -R

