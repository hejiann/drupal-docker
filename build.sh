#!/bin/bash

if ! type "docker" > /dev/null; then
  wget -qO- https://get.docker.com/ | sh
  #curl -sSL http://acs-public-mirror.oss-cn-hangzhou.aliyuncs.com/docker-engine/internet | sh -
fi

if ! type "docker-compose" > /dev/null; then
  sudo apt-get install -y python-pip
  sudo pip install docker-compose
fi

if ! grep -q "http://hub-mirror.c.163.com" /etc/default/docker; then
  echo "DOCKER_OPTS=\"\$DOCKER_OPTS --registry-mirror=http://hub-mirror.c.163.com\"" | sudo tee --append /etc/default/docker
  sudo service docker restart
fi

sudo usermod -aG docker $USER
sudo usermod -aG www-data $USER

newgrp docker <<EONG
docker-compose build
sed -i 's/volumes:/#volumes:/' docker-compose.yml
sed -i 's/- .\/web:\/var\/www\/html/#- .\/web:\/var\/www\/html/' docker-compose.yml
docker-compose up -d
sudo rm ./web -r
sudo docker cp drupal:/var/www/html web
docker-compose stop
sed -i 's/#volumes:/volumes:/' docker-compose.yml
sed -i 's/#- .\/web:\/var\/www\/html/- .\/web:\/var\/www\/html/' docker-compose.yml
EONG

sudo chown www-data.www-data web -R
sudo chmod g+w web -R

