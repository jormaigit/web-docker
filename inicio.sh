#!/bin/bash
docker compose down
docker volume rm web-docker_persistent
docker build .
docker compose up -d
