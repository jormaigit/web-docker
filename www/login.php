<?php
ob_start();
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
    <link rel="stylesheet" href="/css/login.css">
    <link rel="icon" type="image/x-icon" href="/imagenes/otros/ALJOR S.L.ico">
    <title>Inciar Sesión</title>

    <script>
      // Para que el mensaje de error con "alert" desaparezca en 5 segundos
      setTimeout(function() {
        var errorDivs = document.getElementsByClassName('alert alert-danger');
        if (errorDivs) {
          // Filtrando por clase, es necesario iterar por cada uno de los div con su respectiva posicion
          for (var i = 0; i < errorDivs.length; i++) {
            errorDivs[i].style.display = 'none';
          }
        }
      }, 5000);
    </script>
</head>

<body class="bg-dark">

<?php
// Si se ha enviado el formulario, realiza la validación
if (isset($_POST["submit"])) {
    // Comprobación de si los campos de correo electrónico y contraseña están definidos y no están vacíos
    if (isset($_POST["email"]) && !empty($_POST["email"]) 
        && isset($_POST["password"]) && !empty($_POST["password"])) {

        // BD
        $conexion = new mysqli("base_datos", "root", "test", "tienda");
        $conexion->set_charset("utf8");

        if ($conexion->connect_error) {
            die("Error de conexión " . $conexion->connect_error);
        }

        $stmt = $conexion->prepare("SELECT ID, contrasenia, email FROM usuario WHERE email = ?");
        $stmt->bind_param("s", $_POST["email"]);
        $stmt->execute();
        $resultado = $stmt->get_result();

        if ($resultado->num_rows > 0) {
            $fila = $resultado->fetch_assoc();

            // Verfifcación de que la password introducida es igual a la que hay hasheada en la BD
            if (password_verify($_POST["password"], $fila["contrasenia"])) {
                // Guardo campos de formulario en variables de session y redirección
                $_SESSION["emailLogued"] = $_POST['email'];
                $_SESSION["ID_usuario"] = $fila["ID"];

                header("Location: index.php");
            } else {
                echo "<div class='alert alert-danger'>Email o contraseña incorrectos</div>";
                // Incluyo el html del formualrio después de que me muestre el error
                include('html/login.html');
            }
        } else {
            echo "<div class='alert alert-danger'>Email o contraseña incorrectos</div>";
            include('html/login.html');
        }

        $conexion->close();
    } else {
        // Si alguno de los campos está vacío, muestra un mensaje de error
        echo "<div class='alert alert-danger'>Por favor, rellene todos los campos.</div>";
    }
}

// Si no se ha enviado el formulario, lo muestras
if (!isset($_POST["submit"]) || (isset($_POST["submit"]) && (empty($_POST["email"]) || empty($_POST["password"])))) {
    include('html/login.html');
}
ob_end_flush();
?>

</body>
</html>