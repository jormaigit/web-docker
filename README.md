Tienda web de venta componentes informáticos. Uso de front y back end, con funcionalidad de creación de usuarios, 
carrito de la compra y pedidos realizados. Despliegue con Docker.

Principales tecnologías y servicios empleadas:
- Docker, docker compose, git, PHP, MySQL, JavaScript, HTML, css.

Entorno necesario para el despliegue:
- Máquina virtual Ubuntu 20.04.6 LTS (6 GiB RAM y 2 núcleos de procesador).
- Tener docker, docker compose y git instalados.
- Tener los puertos 80, 8000 y 3006 libres.
- Tener un usuario con permisos de sudo y que esté en el grupo docker.

Estructura del proyecto:
web-docker/            # Raíz del proyecto
├── conf/              # Configuraciones
├── data_base/         # Scripts de la base de datos
├── www/               # Código fuente de la web
├── Dockerfile         # Dockerfile para construir la imagen de la aplicación web
├── docker-compose.yml # Archivo de Docker Compose para orquestar los servicios
└── inicio.sh          # Script para iniciar los contenedores


Pasos a seguir:
1. Una vez tienes la maquina virtual con los paquetes instalados y puertos libres, clonas el repositorio con el comando --> git clone https://github.com/jormaigit/web-docker.git
2. Una vez clonado, entras al directorio llamado "web-docker" con --> cd web-docker
3. Dentro del directorio ejecutas el script "inicio.sh" --> bash inicio.sh   o   ./inicio.sh
4. Una vez finalizado el proceso de creación de los contenedores, para ver la web o PhpMyAdmin accede en un navegador:
Web --> localhost:80  o  127.0.0.1:80  //   PhpMyAdmin --> localhost:8000   o   127.0.0.1:8000

***************************************************
PhpMyAdmin (Usuario / contraseña) --> root / test
***************************************************

Guías de instalación:
Docker ---> https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04-es
Docker compose --> https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-20-04-es
git --> https://www.digitalocean.com/community/tutorials/how-to-install-git-on-ubuntu-20-04-es


