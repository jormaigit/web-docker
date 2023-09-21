#!/bin/bash
docker compose down
cp -r /var/www/aljor/* ~/docker-lamp-project/www/
docker build .
docker compose up -d

