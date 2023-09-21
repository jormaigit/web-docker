<?php
ob_start();
// Solo se inicia sessión si no hay otra sessión ya activa
if (session_status() == PHP_SESSION_NONE) {
  session_start();
  $session_id = session_id(); // Guardo el Id de sesión para usarlo de cara a BD etc
  
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
    <link rel="stylesheet" href="/css/datosusu.css">
    <link rel="stylesheet" href="/css/mis_pedidos.css">
    <link rel="icon" type="image/x-icon" href="/imagenes/otros/ALJOR S.L.ico">
    <title>ALJOR S.L</title>
</head>
<body class="bg-dark text-white">
  <?php
          // Para mostrar boton provisional logout si hay un usuario que haya iniciado sesión 
          if(isset($_SESSION["emailLogued"]) && !empty($_SESSION["emailLogued"])){ 
          // Para mostrar la barra de arriba, si el usuario está logueado, con su correo
          include("indexlogueado.php");
          }
          else{
        ?>
    <?php
            }
    ?>

<!--DATOS DEL USUARIO-->
<div class="bg-dark text-light pt-5 pb-5 border-2 border-top border-light border-botttom text-center">
    <p class="sombra datosdeusuario">DATOS DEL USUARIO</p>
</div>
<?php

    // Función para verificar las contraseñas
    function passVerify($contrasenia) {
      $contraseniaLongRestriccion= "/^.{6,20}$/";
      $contraseniaMayusRestriccion= "/[A-Z]/";
      $contraseniaMinusRestriccion= "/[a-z]/";
      $contraseniaSpecialChRestriccion= "/[!@#$%^&*()_+{}|:\"<>?`~\\-=\\[\\]\\\\;',.\/]/";
      $contraseniaDigitoRestriccion= "/\d/";
      
      if (!(preg_match($contraseniaLongRestriccion, $contrasenia) &&
          preg_match($contraseniaMayusRestriccion, $contrasenia) &&
          preg_match($contraseniaMinusRestriccion, $contrasenia) &&
          preg_match($contraseniaSpecialChRestriccion, $contrasenia) &&
          preg_match($contraseniaDigitoRestriccion, $contrasenia))) {
        return "La contraseña no es válida";
      }
      return true;
      }

    // Conexion BD
    include("conx_BD.php");

    // Consulta a la BD filtrando por email sacado de la session
    $email = $_SESSION['emailLogued'];
    $consulta = "SELECT * FROM usuario WHERE email = ?";
    $stmt = $conexion->prepare($consulta);
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $resultado = $stmt->get_result();
    $fila = $resultado->fetch_assoc();


    // Actualizar teléfono en la base de datos
    if (isset($_POST['telefono'])) {
      $telefono = $_POST['telefono'];
      $sql = "UPDATE usuario SET telefono = ? WHERE email = ?";
      $stmt = $conexion->prepare($sql);
      $stmt->bind_param("is", $telefono, $email);
      if ($stmt->execute()) {
          echo "Teléfono actualizado exitosamente.";
      } else {
          echo "Error al actualizar el teléfono: " . $stmt->error;
      }
  }

  // Actualizar fecha de nacimiento en la base de datos
  if (isset($_POST['fecha_nacimiento'])) {
      $fecha_nacimiento = $_POST['fecha_nacimiento'];
      $sql = "UPDATE usuario SET f_nacimiento = ? WHERE email = ?";
      $stmt = $conexion->prepare($sql);
      $stmt->bind_param("ss", $fecha_nacimiento, $email);
      if ($stmt->execute()) {
          echo "Fecha de nacimiento actualizada exitosamente.";
      } else {
          echo "Error al actualizar la fecha de nacimiento: " . $stmt->error;
          echo "$fecha_nacimiento";
          gettype($fecha_nacimiento);
      }
  }


// Actualizar contraseña en la base de datos
if (isset($_POST['pass_antigua']) && isset($_POST['nueva_pass'])) {
  $contra_antigua = $_POST['pass_antigua'];
  $nueva_contra = $_POST['nueva_pass'];

  // Verifica que la antigua contraseña es correcta
  $contraHasheada = $fila['contrasenia'];

  if (password_verify($contra_antigua, $contraHasheada)) {
      // Verifica si la nueva contraseña es igual a la antigua
      if ($contra_antigua === $nueva_contra) {
          echo "La nueva contraseña no puede ser igual a la antigua.";
      } else {
          // Verifica la nueva contraseña con las restricciones
          $validacion = passVerify($nueva_contra);
          if ($validacion === true) {
              // Encriptar la nueva contraseña
              $nueva_contra = password_hash($nueva_contra, PASSWORD_DEFAULT);

              // Actualizar la contraseña en la base de datos
              $sql = "UPDATE usuario SET contrasenia = ? WHERE email = ?";
              $stmt = $conexion->prepare($sql);
              $stmt->bind_param("ss", $nueva_contra, $email);
              if ($stmt->execute()) {
                  echo "Contraseña actualizada exitosamente.";
              } else {
                  echo "Error al actualizar la contraseña: " . $stmt->error;
              }
          } else {
              echo "La nueva contraseña no cumple con los requisitos: " . $validacion;
          }
      }
  } else {
      echo "La contraseña antigua no es correcta.";
  }
}




    echo "<div class='bg-dark text-light border-2 border-top pt-5 border-light border-botttom text-center'><p class='tamanoletra'><b>Nombre: </b>" . $fila['nombre'] . "</p><br>";
    echo "<p class='tamanoletra'><b>Email: </b>" . $fila['email'] . "</p><br>";
    // Formulario para actualizar teléfono
    echo '<form method="POST" action="datosUsu.php" class="form-inline col-lg-12 d-flex justify-content-center">
    <div class="form-group">
      <label for="telefono" class="mr-2 tamanoletra"><strong>Teléfono:</strong></label>
      <input type="tel" name="telefono" class="form-control mr-2" pattern="[0-9]{9}" value="' . $fila['telefono'] . '">
      <button type="submit" class="btn btn-primary">Actualizar teléfono</button>
    </div>
    </form>';

    // Formulario para actualizar fecha de nacimiento
    echo '<form method="POST" action="datosUsu.php" class="form-inline d-flex justify-content-center pt-3 pb-3">
    <div class="form-group">
      <label for="fecha_nacimiento" class="mr-2 tamanoletra"><strong>Fecha de nacimiento:</strong></label>
      <input type="date" name="fecha_nacimiento" class="form-control mr-2" value="' . $fila['f_nacimiento'] . '">
      <button type="submit" class="btn btn-primary">Actualizar fecha de nacimiento</button>
    </div>
    </form>';

    // Formulario para actualizar contraseña
    echo '<form method="POST" action="datosUsu.php" class="form-inline d-flex justify-content-center pt-3 pb-5 border-light border-bottom border-2">
    <div class="form-inline d-flex justify-content-center">
      <label for="pass_antigua" class="mr-2 tamanoletra" ><strong>Contraseña antigua:</strong></label>
      <input type="password" name="pass_antigua" class="form-control mr-2">
    </div>
    <div class="form-inline d-flex justify-content-center">
      <label for="nueva_pass" class="mr-2 pt-3 pb-3 tamanoletra"><strong>Nueva contraseña:</strong></label>
      <input type="password" name="nueva_pass" class="form-control mr-2">
      <button type="submit" class="btn btn-primary">Cambiar contraseña</button>
    </div>
    </form>';


    // Mostrar los pedidos en datosUSu.php
    include ("mis_pedidos.php");
    ob_end_flush();

?>

          

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