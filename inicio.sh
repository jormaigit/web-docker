#!/bin/bash

# Puertos a comprobar
ports=("80" "8000" "3306")

# Patrón del nombre de los contenedores
container_pattern="web-docker"

ports_free=true

# Obteniene una lista de puertos en uso por los contenedores que coinciden con el patrón
docker_ports=$(docker ps --format '{{.Names}} {{.Ports}}' 2>/dev/null | grep "$container_pattern")

# Comprueba cada puerto para ver si está libre
for port in "${ports[@]}"; do
    port_info=$(ss -tuln | grep ":$port ")
    if [ -n "$port_info" ]; then
        if ! echo "$docker_ports" | grep -q ":$port->"
        then
            echo "El puerto $port ya está en uso por otro servicio."
            exit
        fi
    fi
done

# Comprobación de si los paquetes necesarios están instalados
docker_installed=true
compose_installed=true
git_installed=true

docker_version=$(docker --version 2> /dev/null | cut -d " " -f 3)
if [ -z "$docker_version" ]
then
    echo "Parece que no tienes Docker instalado."
    exit
fi

compose_version=$(docker compose version 2> /dev/null | cut -d " " -f 4)
if [ -z "$compose_version" ]
then
    echo "Parece que no tienes Docker Compose instalado."
    exit
fi

git_version=$(git --version 2> /dev/null | cut -d " " -f 3)
if [ -z "$git_version" ] 
then
    echo "Parece que no tienes Git instalado."
    exit
fi

# Si todo está en orden, procede con la eliminación y recreación de contenedores
docker compose down
docker volume rm web-docker_persistent
docker build .
docker compose up -d




