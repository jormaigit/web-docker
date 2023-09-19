<?php
// Solo se inicia sessión si no hay otra sessión ya activa
if (session_status() == PHP_SESSION_NONE) {
  session_start();
}


?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="/css/politicaprivacidad.css">
    <link rel="icon" type="image/x-icon" href="/imagenes/otros/ALJOR S.L.ico">
    <title>Políticas de Privacidad</title>


    

</head>
<body class="bg-dark">
  <!--BARRA DE NAVEGACIÓN PRINCIPAL-->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="col-2 container-fluid justify-content-center">
          <a class="navbar-brand" href="/index.php">
            <img src="/imagenes/otros/ALJOR S.L.png" alt="" width="40" height="40" class="d-inline-block align-text-center">
            ALJOR
          </a>
        </div>

        <div class="col-lg-4 col-md-12 container-fluid justify-content-center">
          <!-- Formulario para buscar productos en la base de datos-->
          <form class="form-inline w-75 my-2 my-sm-0" action="buscar.php" method="GET">
            <div class="col-10">
                <input class="form-control mr-sm-2 w-100 align-text-center" type="search" name="consulta" placeholder="Escribe algo para buscar" aria-label="Search">
            </div>
            <div class="col-2">
                <input class="btn btn-outline-success my-2 my-sm-0 bg-dark text-light border-light" type="submit" value="Buscar">
            </div>
          </form>
        </div>
        <div class="col-lg-6 container-fluid justify-content-center">
            <a class="nav-link text-light" href="/logout.php"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" class="bi bi-person" viewBox="0 0 16 16">
            <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6Zm2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0Zm4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4Zm-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10c-2.29 0-3.516.68-4.168 1.332-.678.678-.83 1.418-.832 1.664h10Z"/>
          </svg>  Logout</a>

          <a class="nav-link text-light" href="/datosUsu.php"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" class="bi bi-person" viewBox="0 0 16 16">
            <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6Zm2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0Zm4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4Zm-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10c-2.29 0-3.516.68-4.168 1.332-.678.678-.83 1.418-.832 1.664h10Z"/>
          </svg><?php 
          echo $_SESSION["emailLogued"]?></a>
          
          <?php 
          // Aqui tambien hay que cambiar el html para que si el usuario esta logueado, la función que llama al carrito desplegable funcione
          ?>
          <a class="nav-link text-light" href="/carrito.php" id="botonCarrito">
          <?php 
          // Inlcude del codigo php para que muestre el numero de articulos que hay en el carrito
          include("cartNumber.php")
          ?>
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" class="bi bi-cart2" viewBox="0 0 16 16">
              <path d="M0 2.5A.5.5 0 0 1 .5 2H2a.5.5 0 0 1 .485.379L2.89 4H14.5a.5.5 0 0 1 .485.621l-1.5 6A.5.5 0 0 1 13 11H4a.5.5 0 0 1-.485-.379L1.61 3H.5a.5.5 0 0 1-.5-.5zM3.14 5l1.25 5h8.22l1.25-5H3.14zM5 13a1 1 0 1 0 0 2 1 1 0 0 0 0-2zm-2 1a2 2 0 1 1 4 0 2 2 0 0 1-4 0zm9-1a1 1 0 1 0 0 2 1 1 0 0 0 0-2zm-2 1a2 2 0 1 1 4 0 2 2 0 0 1-4 0z"/>
          </svg> Carrito <?php if ($_SESSION["totalCarrito"] > 0) { echo "(" . $_SESSION["totalCarrito"] . ")"; } ?>
          </a>

        </div>
        </nav>

<!-- BARRA DE NAVEGACIÓN DE PRODUCTOS-->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark border-top border-2 border-light">
  <div class="col-lg-2 container-fluid navitem dropdown d-flex justify-content-center">
    <a class="navbar-brand dropdown-toggle text-white" id="componentesDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
      Componentes
    </a>
    <ul class="dropdown-menu w-100" aria-labelledby="componentesDropdown">
      <li><a class="dropdown-item" href="/show_All.php?subcategoria=placa_base">Placa Base</a></li>
      <li><a class="dropdown-item" href="/show_All.php?subcategoria=cpu">CPU</a></li>
      <li><a class="dropdown-item" href="/show_All.php?subcategoria=ram">RAM</a></li>
      <li><a class="dropdown-item" href="/show_All.php?subcategoria=psu">PSU</a></li>
      <li><a class="dropdown-item" href="/show_All.php?subcategoria=almacenamiento">Almacenamiento</a></li>
    </ul>
  </div> 
  <div class="col-lg-2 container-fluid navitem dropdown d-flex justify-content-center">
    <a class="navbar-brand dropdown-toggle text-white" id="ordenadoresDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
      Ordenadores
    </a>
    <ul class="dropdown-menu w-100" aria-labelledby="ordenadoresDropdown">
      <li><a class="dropdown-item" href="/show_All.php?subcategoria=portatil">Portátiles</a></li>
      <li><a class="dropdown-item" href="/show_All.php?subcategoria=desktop">Desktops</a></li>
    </ul>
  </div>
  <div class="col-lg-2 container-fluid navitem dropdown d-flex justify-content-center">
    <a class="navbar-brand dropdown-toggle text-white" id="smartphonesDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
      Smartphones
    </a>
    <ul class="dropdown-menu w-100" aria-labelledby="smartphonesDropdown">
      <li><a class="dropdown-item" href="/show_All.php?subcategoria=apple">Apple</a></li>
      <li><a class="dropdown-item" href="/show_All.php?subcategoria=android">Android</a></li>
    </ul>
  </div>
  <div class="col-lg-2 container-fluid navitem dropdown d-flex justify-content-center">
    <a class="navbar-brand dropdown-toggle text-white" id="perifericosDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
      Periféricos
    </a>
    <ul class="dropdown-menu w-100" aria-labelledby="perifericosDropdown">
      <li><a class="dropdown-item" href="/show_All.php?subcategoria=raton">Ratones</a></li>
      <li><a class="dropdown-item" href="/show_All.php?subcategoria=teclado">Teclados</a></li>
      <li><a class="dropdown-item" href="/show_All.php?subcategoria=monitor">Monitores</a></li>
      <li><a class="dropdown-item" href="/show_All.php?subcategoria=cascos">Cascos</a></li>
    </ul>
  </div>
  <div class="col-lg-2 container-fluid navitem dropdown d-flex justify-content-center">
    <a class="navbar-brand " href="/show_All.php?subcategoria=televisor" id="televisoresDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
      Televisores
    </a>
  </div>
  <div class="col-lg-2 container-fluid navitem dropdown d-flex justify-content-center">
    <a class="navbar-brand dropdown-toggle text-white" id="consolasDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
      Consolas
    </a>
    <ul class="dropdown-menu w-100" aria-labelledby="consolasDropdown">
      <li><a class="dropdown-item" href="/show_All.php?subcategoria=playstation">PlayStation</a></li>
      <li><a class="dropdown-item" href="/show_All.php?subcategoria=xbox">Xbox</a></li>
      <li><a class="dropdown-item" href="/show_All.php?subcategoria=nintendo">Nintendo</a></li>
      <li><a class="dropdown-item" href="/show_All.php?subcategoria=mandos">Mandos</a></li>
      <li><a class="dropdown-item" href="/show_All.php?subcategoria=juegos">Juegos</a></li>
    </ul>
  </div>
</nav>
<!--POLÍTICAS DE PRIVACIDAD-->
<div class="bg-dark text-light pt-5 pb-5 border-2 border-top border-bottom border-light border-botttom">
    <p class="sombra text-center tamanio">POLÍTICA DE PRIVACIDAD DE ALJOR S.L.</p>
</div>
<div class="sombra text-light ml-5 mr-5 ">
    <p class="text-center pt-5 pb-5">

Fecha de entrada en vigencia: 12/06/2023

En ALJOR S.L, nos comprometemos a proteger su privacidad y garantizar la seguridad de la información personal que proporcione al utilizar nuestro sitio web de venta de componentes informáticos. Esta Política de Privacidad describe cómo recopilamos, utilizamos, compartimos y protegemos su información personal. Al utilizar nuestro sitio web, usted acepta los términos de esta Política de Privacidad.

    Información que recopilamos:
    Recopilamos información personal que usted nos proporciona directamente cuando se registra en nuestro sitio web, realiza una compra, se suscribe a nuestro boletín informativo, participa en encuestas o nos contacta a través de formularios de contacto. La información que podemos recopilar incluye, entre otros:

    Nombre completo
    Dirección de correo electrónico
    Dirección postal
    Número de teléfono
    Información de facturación y envío
    Información de pago

Además, recopilamos información no personal de forma automática, como direcciones IP, tipo de navegador, sistema operativo y páginas web visitadas, con el fin de mejorar la funcionalidad de nuestro sitio web y brindar una experiencia de usuario personalizada.

    Uso de la información recopilada:
    Utilizamos la información recopilada para los siguientes propósitos:

    Procesar y completar sus pedidos de productos y servicios.
    Comunicarnos con usted sobre su pedido, incluyendo confirmaciones de compra y actualizaciones de envío.
    Proporcionar asistencia al cliente y responder a sus consultas y solicitudes.
    Personalizar su experiencia en nuestro sitio web y mostrar contenido relevante.
    Enviarle comunicaciones de marketing sobre productos, promociones y ofertas especiales, siempre que haya dado su consentimiento.
    Realizar análisis y mejoras en nuestros productos, servicios y sitio web.
    Cumplir con nuestras obligaciones legales y proteger nuestros derechos legales.

    Compartir información con terceros:
    Podemos compartir su información personal con terceros en las siguientes circunstancias:

    Proveedores de servicios: Podemos compartir su información con terceros que prestan servicios en nuestro nombre, como procesamiento de pagos, envío de pedidos y análisis de datos. Estos proveedores de servicios tienen acceso a su información personal solo en la medida necesaria para realizar dichos servicios en nuestro nombre y están obligados a mantener la confidencialidad de la información.
    Cumplimiento legal: Podemos divulgar su información personal si creemos de buena fe que dicha divulgación es necesaria para cumplir con una obligación legal, proteger nuestros derechos legales o responder a una solicitud válida de las autoridades gubernamentales.
    Consentimiento: Podemos compartir su información personal con terceros cuando haya dado su consentimiento para hacerlo.

    Cookies y tecnologías similares:
    Utilizamos cookies y tecnologías similares para recopilar información no personal sobre el uso de nuestro sitio web. Estas tecnologías nos permiten mejorar la funcionalidad de nuestro sitio web, personalizar su experiencia y analizar patrones de tráfico. Puede ajustar la configuración de su navegador para rechazar cookies, pero tenga en cuenta que esto puede afectar la funcionalidad de nuestro sitio web.

    Seguridad de la información:
    Implementamos medidas de seguridad adecuadas para proteger la información personal que recopilamos y mantenemos. Sin embargo, tenga en cuenta que ninguna transmisión de datos a través de Internet o almacenamiento electrónico es completamente segura. No podemos garantizar la seguridad absoluta de su información.

    Enlaces a sitios web de terceros:
    Nuestro sitio web puede contener enlaces a sitios web de terceros. No nos hacemos responsables de las prácticas de privacidad o el contenido de dichos sitios web. Le recomendamos que revise las políticas de privacidad de los sitios web de terceros antes de proporcionar cualquier información personal.

    Sus derechos y elecciones:
    Usted tiene ciertos derechos con respecto a su información personal. Puede solicitar acceso, corrección o eliminación de su información personal en cualquier momento. También puede optar por no recibir comunicaciones de marketing por correo electrónico en el futuro. Para ejercer sus derechos o actualizar sus preferencias, contáctenos utilizando la información de contacto que se proporciona al final de esta Política de Privacidad.

    Cambios en esta Política de Privacidad:
    Podemos actualizar esta Política de Privacidad periódicamente para reflejar cambios en nuestras prácticas de privacidad. Se publicará una versión actualizada en nuestro sitio web con la fecha de entrada en vigor. Le recomendamos que revise periódicamente esta Política de Privacidad para mantenerse informado sobre cómo protegemos su información.

    Contacto:
    Si tiene alguna pregunta o inquietud sobre esta Política de Privacidad o nuestras prácticas de privacidad, puede contactarnos en la siguiente dirección:
<br>
Dirección: Calle del Torno, 2-4, 28522 Rivas-Vaciamadrid, Madrid, España <br>
Correo electrónico: aljorsl@gmail.com <br>
Teléfono: 910 503 345</p>
</div>
<!--PIE DE PÁGINA-->
<footer class="bg-dark text-white border-top border-2 border-white">
  <div class="container-fluid d-flex flex-wrap justify-content-center pb-5 pt-5">
    <div class="col-12 col-md-4 mb-4">
      <h4 class="text-center">Nuestras Marcas</h4>
      <nav class="nav flex-wrap justify-content-center">
        <div class="text-center">
          <a href="https://www.hp.com/es-es/home.html"><img class="p-1" src="/imagenes/otros/hp.png" alt="" width="100" height="100"></a>
          <a href="https://www.samsung.com/es/"><img class="p-1" src="/imagenes/otros/samsung.png" alt="" width="100" height="100"></a>
          <a href="https://www.intel.es/content/www/es/es/homepage.html"><img class="p-1" src="/imagenes/otros/intel.png" alt="" width="100" height="100"></a>
          <a href="https://www.logitech.com/es-es"><img class="p-1" src="/imagenes/otros/logitech.png" alt="" width="100" height="100"></a>
          <a href="https://www.apple.com/es/"><img class="p-1" src="/imagenes/otros/apple.png" alt="" width="100" height="100"></a>
          <a href="https://www.asus.com/es/"><img class="p-1" src="/imagenes/otros/asus.png" alt="" width="100" height="100"></a>
          <a href="https://www.amd.com/es.html"><img class="p-1" src="/imagenes/otros/amd.png" alt="" width="100" height="100"></a>
          <a href="https://www.corsair.com/es/es/"><img class="p-1" src="/imagenes/otros/corsair.png" alt="" width="100" height="100"></a>
          <a href="https://www.microsoft.com/es-es/windows"><img class="p-1" src="/imagenes/otros/windows.png" alt="" width="100" height="100"></a>
          <a href="https://www.nvidia.com/es-es/"><img class="p-1" src="/imagenes/otros/nvidia.avif" alt="" width="100" height="100"></a>
          <a href="https://www.toshiba.es/"><img class="p-1" src="/imagenes/otros/toshiba.png" alt="" width="100" height="100"></a>
          <a href="https://es.msi.com/"><img class="p-1" src="/imagenes/otros/msi.png" alt="" width="100" height="100"></a>
          <a href="https://www.lenovo.com/es/es/"><img class="p-1" src="/imagenes/otros/lenovo.png" alt="" width="100" height="100"></a>
          <a href="https://www.seagate.com/es/es/"><img class="p-1" src="/imagenes/otros/seagate.png" alt="" width="100" height="100"></a>
          <a href="https://www.westerndigital.com/es-es/brand/sandisk"><img class="p-1" src="/imagenes/otros/sandisk.png" alt="" width="100" height="100"></a>
        </div>
      </nav>
    </div>

    <div class="col-12 col-md-4 mb-4">
      <nav class="nav flex-column">
        <h4 class="text-center">Quiénes Somos</h4>
        <a class="nav-link text-center text-white" aria-current="page" href="/quienessomos.php">Quiénes Somos</a>
        <a class="nav-link text-center text-white" href="/localizanos.php">Localízanos</a>
        <a class="nav-link text-center text-white" href="/contacto.php">Contacto</a>
        <a class="nav-link text-center text-white" href="/politicaprivacidad.php">Política de privacidad</a>
      </nav>
    </div>

    <div class="col-12 col-md-4 mb-4">
      <nav class="nav flex-column">
      <h4 class=" text-center">Redes Sociales</h4>
              <a class="nav-link text-light text-center" aria-current="page" href="https://www.instagram.com/"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-instagram" viewBox="0 0 16 16">
                <path d="M8 0C5.829 0 5.556.01 4.703.048 3.85.088 3.269.222 2.76.42a3.917 3.917 0 0 0-1.417.923A3.927 3.927 0 0 0 .42 2.76C.222 3.268.087 3.85.048 4.7.01 5.555 0 5.827 0 8.001c0 2.172.01 2.444.048 3.297.04.852.174 1.433.372 1.942.205.526.478.972.923 1.417.444.445.89.719 1.416.923.51.198 1.09.333 1.942.372C5.555 15.99 5.827 16 8 16s2.444-.01 3.298-.048c.851-.04 1.434-.174 1.943-.372a3.916 3.916 0 0 0 1.416-.923c.445-.445.718-.891.923-1.417.197-.509.332-1.09.372-1.942C15.99 10.445 16 10.173 16 8s-.01-2.445-.048-3.299c-.04-.851-.175-1.433-.372-1.941a3.926 3.926 0 0 0-.923-1.417A3.911 3.911 0 0 0 13.24.42c-.51-.198-1.092-.333-1.943-.372C10.443.01 10.172 0 7.998 0h.003zm-.717 1.442h.718c2.136 0 2.389.007 3.232.046.78.035 1.204.166 1.486.275.373.145.64.319.92.599.28.28.453.546.598.92.11.281.24.705.275 1.485.039.843.047 1.096.047 3.231s-.008 2.389-.047 3.232c-.035.78-.166 1.203-.275 1.485a2.47 2.47 0 0 1-.599.919c-.28.28-.546.453-.92.598-.28.11-.704.24-1.485.276-.843.038-1.096.047-3.232.047s-2.39-.009-3.233-.047c-.78-.036-1.203-.166-1.485-.276a2.478 2.478 0 0 1-.92-.598 2.48 2.48 0 0 1-.6-.92c-.109-.281-.24-.705-.275-1.485-.038-.843-.046-1.096-.046-3.233 0-2.136.008-2.388.046-3.231.036-.78.166-1.204.276-1.486.145-.373.319-.64.599-.92.28-.28.546-.453.92-.598.282-.11.705-.24 1.485-.276.738-.034 1.024-.044 2.515-.045v.002zm4.988 1.328a.96.96 0 1 0 0 1.92.96.96 0 0 0 0-1.92zm-4.27 1.122a4.109 4.109 0 1 0 0 8.217 4.109 4.109 0 0 0 0-8.217zm0 1.441a2.667 2.667 0 1 1 0 5.334 2.667 2.667 0 0 1 0-5.334z"/>
              </svg>  Instagram</a>
              <a class="nav-link text-light text-center" href="https://twitter.com/?lang=es"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-twitter" viewBox="0 0 16 16">
                <path d="M5.026 15c6.038 0 9.341-5.003 9.341-9.334 0-.14 0-.282-.006-.422A6.685 6.685 0 0 0 16 3.542a6.658 6.658 0 0 1-1.889.518 3.301 3.301 0 0 0 1.447-1.817 6.533 6.533 0 0 1-2.087.793A3.286 3.286 0 0 0 7.875 6.03a9.325 9.325 0 0 1-6.767-3.429 3.289 3.289 0 0 0 1.018 4.382A3.323 3.323 0 0 1 .64 6.575v.045a3.288 3.288 0 0 0 2.632 3.218 3.203 3.203 0 0 1-.865.115 3.23 3.23 0 0 1-.614-.057 3.283 3.283 0 0 0 3.067 2.277A6.588 6.588 0 0 1 .78 13.58a6.32 6.32 0 0 1-.78-.045A9.344 9.344 0 0 0 5.026 15z"/>
              </svg>  Twitter</a>
              <a class="nav-link text-light text-center" href="https://es-es.facebook.com/"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-facebook" viewBox="0 0 16 16">
                <path d="M16 8.049c0-4.446-3.582-8.05-8-8.05C3.58 0-.002 3.603-.002 8.05c0 4.017 2.926 7.347 6.75 7.951v-5.625h-2.03V8.05H6.75V6.275c0-2.017 1.195-3.131 3.022-3.131.876 0 1.791.157 1.791.157v1.98h-1.009c-.993 0-1.303.621-1.303 1.258v1.51h2.218l-.354 2.326H9.25V16c3.824-.604 6.75-3.934 6.75-7.951z"/>
              </svg>  Facebook</a>
              <a class="nav-link text-light text-center" href="https://www.tiktok.com/es/"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-tiktok" viewBox="0 0 16 16">
                <path d="M9 0h1.98c.144.715.54 1.617 1.235 2.512C12.895 3.389 13.797 4 15 4v2c-1.753 0-3.07-.814-4-1.829V11a5 5 0 1 1-5-5v2a3 3 0 1 0 3 3V0Z"/>
              </svg>  Tik Tok</a>
      </nav>
    </div>
  </div>

  <div class="border-top pt-5 pb-5 border-2 border-white">
    <div class="text-center"><p class="text-white">Calle del Torno, 2-4, 28522 Rivas-Vaciamadrid, Madrid, España</p></div>
  </div>
</footer>


</body>
</html>