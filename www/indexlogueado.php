<?php
// Solo se inicia sessión si no hay otra sessión ya activa
if (session_status() == PHP_SESSION_NONE) {
  session_start();
}

// Comprueba si el usuario está logueado
if (!isset($_SESSION["emailLogued"])) {
  // Si no está logueado, redirige a index.php
  header("Location: index.php");
  exit();
}

?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="/css/index.css">
    <link rel="icon" type="image/x-icon" href="/imagenes/otros/ALJOR S.L.ico">
    <title>ALJOR S.L</title>

</head>
<body>
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
        
</body>
</html>