#!/bin/bash

docker pull jianhe/debian
sed -i 's/volumes:/#volumes:/' docker-compose.yml
sed -i 's/- .\/web:\/var\/www\/html/#- .\/web:\/var\/www\/html/' docker-compose.yml
docker-compose up -d
if [ -d ./web.old ]; then
  rm ./web.old -rf
fi
if [ -d ./web ]; then
  mv ./web ./web.old
fi
sudo docker cp debian:/var/www/html ./web
docker-compose stop
sed -i 's/#volumes:/volumes:/' docker-compose.yml
sed -i 's/#- .\/web:\/var\/www\/html/- .\/web:\/var\/www\/html/' docker-compose.yml

sudo chown www-data.www-data ./web -R
sudo chmod g+w ./web -R

