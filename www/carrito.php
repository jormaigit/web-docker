<?php
ob_start();
header('Content-Type: text/html; charset=utf-8');
if (session_status() == PHP_SESSION_NONE) {
    session_start();
}

// Comprueba si el usuario está logueado
if (!isset($_SESSION["emailLogued"])) {
    // Si no está logueado, redirige a index.php
    header("Location: index.php");
    exit();
  }

$ID_usuario = $_SESSION['ID_usuario']; 


// Conexión a la BD
$conexion = new mysqli("base_datos", "root", "test", "tienda");
$conexion->set_charset("utf8mb4");

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
    <link rel="stylesheet" href="/css/carrito.css">
    <link rel="icon" type="image/x-icon" href="/imagenes/otros/ALJOR S.L.ico">
    <title>ALJOR S.L</title>
</head>
<body class="bg-dark">


<?php
if (isset($_POST['product_id']) && is_numeric($_POST['product_id'])) {
    if (isset($_POST['borrar'])) {
        // Borrar producto del carrito según el ID_usuario e ID_producto
        $ID_producto = $_POST['product_id'];

        $stmt = $conexion->prepare("DELETE FROM carrito WHERE ID_usuario = ? AND ID_producto = ?");
        $stmt->bind_param("ii", $ID_usuario, $ID_producto);
        $stmt->execute();

        if ($stmt->affected_rows > 0) {
            header("Location: carrito.php"); //redirige de nuevo a la página del carrito(técnica PRG para errores formulario cache)
            exit;
        } else {
            echo "Error: " . $stmt->error;
        }

    } else {
        // Agregar o actualizar producto en el carrito
        $ID_producto = $_POST['product_id'];

        $cantidad = isset($_POST['cantidad']) && 
        is_numeric($_POST['cantidad']) ? $_POST['cantidad'] : 1; // Cantidad por defecto

        // Verifica si el producto ya está en el carrito
        $stmt = $conexion->prepare("SELECT * FROM carrito WHERE ID_usuario = ? AND ID_producto = ?");
        $stmt->bind_param("ii", $ID_usuario, $ID_producto);
        $stmt->execute();
        $result = $stmt->get_result();


        if ($result->num_rows > 0) {
            // Verifica el stock del producto
            $stmt_stock = $conexion->prepare("SELECT stock FROM producto WHERE ID = ?");
            $stmt_stock->bind_param("i", $ID_producto);
            $stmt_stock->execute();
            $result_stock = $stmt_stock->get_result();

            $row_stock = $result_stock->fetch_assoc();

            // Verificación de si la cantidad es mayor al stock
            if ($cantidad <= $row_stock['stock']) {
                // El producto ya está en el carrito, actualiza la cantidad
                $stmt_update = $conexion->prepare("UPDATE carrito SET cantidad = ? WHERE ID_usuario = ? AND ID_producto = ?");
                $stmt_update->bind_param("iii", $cantidad, $ID_usuario, $ID_producto);
                $stmt_update->execute();

                
                if ($stmt_update->affected_rows > 0) {
                    header("Location: carrito.php"); //redirige de nuevo a la página del carrito(técnica PRG para errores formulario cache)
                    exit;
                } else {
                    echo "Error: " . $stmt_update->error;
                }
            } else {
                // La cantidad solicitada excede el stock, guarda el mensaje de error en una variable de sesión específica para este producto
                $_SESSION['error'][$ID_producto] = "Stock insuficiente";
                header("Location: carrito.php"); //redirige de nuevo a la página del carrito(técnica PRG para errores formulario cache)
                exit;
            }
        } else {
            // El producto no está en el carrito, inserta un nuevo producto
            $stmt_insert = $conexion->prepare("INSERT INTO carrito (ID_usuario, ID_producto, cantidad) VALUES (?, ?, ?)");
            $stmt_insert->bind_param("iii", $ID_usuario, $ID_producto, $cantidad);
            $stmt_insert->execute();

            if ($stmt_insert->affected_rows > 0) {
                header("Location: carrito.php"); 
                exit;
            } else {
                echo "Error: " . $stmt_insert->error;
            }
        }
    }
}


// Preparamos la consulta para los productos en el carrito
$stmt = $conexion->prepare("SELECT carrito.*, producto.* 
                        FROM carrito 
                        INNER JOIN producto ON carrito.ID_producto = producto.ID
                        WHERE carrito.ID_usuario = ?");
$stmt->bind_param("i", $ID_usuario);
$stmt->execute();

$result = $stmt->get_result(); 

$total = 0; // Inicio la variable total a cero

// Verificación de si el carrito está vacío
echo "<h1 class='d-flex text-white justify-content-center'>CARRITO</h1>";
echo '<div class="container d-flex justify-content-center align-items-center">

    <div class="text-center">';

        if ($result->num_rows === 0) {
            echo '<h1 class="bg-dark text-white pt-5">ESTÁ VACÍO</h1>';
            echo '<img src="/imagenes/otros/carritoVacio.png" height="600px" width="600px" alt="Carrito Vacío">';
            echo '<br>';
            echo '<a class="d-flex justify-content-center" href="/index.php"><button class="btn btn-white w-100">Volver a la tienda</button></a>';
            exit;
        }
        ?>
    </div>
</div>


<?php

if ($result->num_rows > 0) {
    // Mostramos cada producto en el carrito
    while($row = $result->fetch_assoc()) {

        // Uso htmlspecialchars para los datos que se vayan a mostrar
        $id_producto = htmlspecialchars($row["ID_producto"]);
        $nombre_producto = htmlspecialchars($row["nombre_producto"]);
        $cantidad = htmlspecialchars($row["cantidad"]);
        $precio = htmlspecialchars($row["precio"]);
        $imagen = htmlspecialchars($row["imagen"]);
        // Carta para cada producto
        echo '<div class="col">';
        echo '<div class="card mb-4">';
        echo '<div class="card-body p-4">';
        
        echo '<div class="row">';
        echo '<div class="col-md-2 text-center">'; 
        echo "<img src='" . $imagen . "' class='img-fluid imagen-grande' alt='Product image'>"; 
        echo '</div>';
        echo '<div class="col-md-2 justify-content-left">';
        echo '<div>';
        echo '<p class="small text-muted mb-2 pb-2">Nombre</p>';
        echo "<p class='lead fw-normal mb-0 justify-content-left'>" . $nombre_producto . "</p>";
        echo '</div>';
        echo '</div>';
        echo '<div class="col-md-3 d-flex justify-content-left">';
        echo '<div>';
        echo '<p class="small text-muted mb-1 pb-2">Cantidad</p>';
        
        // Formulario para actualizar la cantidad
        echo "<form class='mt-2' action='carrito.php' method='POST'>";
        echo "<input type='hidden' name='product_id' value='" . $id_producto . "'>";
        echo "<input type='number' name='cantidad' value='" . $cantidad . "' min='1'>";
        echo "<button class='col-lg-12 mt-3 btn btn-white' type='submit'><svg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='currentColor' class='bi bi-arrow-clockwise' viewBox='0 0 16 16'>
        <path fill-rule='evenodd' d='M8 3a5 5 0 1 0 4.546 2.914.5.5 0 0 1 .908-.417A6 6 0 1 1 8 2v1z'/>
        <path d='M8 4.466V.534a.25.25 0 0 1 .41-.192l2.36 1.966c.12.1.12.284 0 .384L8.41 4.658A.25.25 0 0 1 8 4.466z'/>
        </svg> Actualizar</button>";
        echo "</form>";
        
        

        // Muestra el mensaje de error si existe para este producto
        if (isset($_SESSION['error'][$id_producto])) {
            echo '<span class="alert alert-danger temporal">' . ($_SESSION['error'][$id_producto]) . '</span>';
            unset($_SESSION['error'][$id_producto]); // Borra el mensaje de error después de mostrarlo
        }

        echo '</div>';
        echo '</div>';
        echo '<div class="col-md-2">';
        echo '<div>';
        echo '<p class="small text-muted mb-4 pb-2">Precio</p>';
        echo "<p class='lead fw-normal mb-0'>" . $precio . " €</p>";
        echo '</div>';
        echo '</div>';
        echo '<div class="col-md-2">';
        echo '<div>';
        echo '<p class="small text-muted mb-4 pb-2">Total</p>';
        echo "<p class='lead fw-normal mb-0'>" . $precio * $cantidad . " €</p>";

        // Botón-formulario para borrar el producto del carrito
        echo "<form action='carrito.php' method='POST'>";
        echo "<input type='hidden' name='product_id' value='" . $id_producto . "'>";
        echo "<input type='hidden' name='borrar' value='1'>";
        echo "<button class='col-lg-12 btn btn-white mt-2' type='submit' class='delete-button'>";
        echo "<svg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='currentColor' class='bi bi-trash3-fill' viewBox='0 0 16 16'>";
        echo "<path d='M11 1.5v1h3.5a.5.5 0 0 1 0 1h-.538l-.853 10.66A2 2 0 0 1 11.115 16h-6.23a2 2 0 0 1-1.994-1.84L2.038 3.5H1.5a.5.5 0 0 1 0-1H5v-1A1.5 1.5 0 0 1 6.5 0h3A1.5 1.5 0 0 1 11 1.5Zm-5 0v1h4v-1a.5.5 0 0 0-.5-.5h-3a.5.5 0 0 0-.5.5ZM4.5 5.029l.5 8.5a.5.5 0 1 0 .998-.06l-.5-8.5a.5.5 0 1 0-.998.06Zm6.53-.528a.5.5 0 0 0-.528.47l-.5 8.5a.5.5 0 0 0 .998.058l.5-8.5a.5.5 0 0 0-.47-.528ZM8 4.5a.5.5 0 0 0-.5.5v8.5a.5.5 0 0 0 1 0V5a.5.5 0 0 0-.5-.5Z'/>";
        echo "</svg>";
        echo " Borrar";
        echo "</button>";
        echo "</form>";
        echo '</div>';
        echo '</div>';
        echo '</div>';

        echo '</div>';
        echo '</div>';
        echo '</div>';

        $total += $precio * $cantidad; // suma el total del precio de cada producto multiplicado por su cantidad
        
    }

echo '</div>'; // Cierre del div de cada producto en el carrito

echo '</div>'; // Cierre del div del row de productos en el carrito
echo '</div>'; // Cierre del div del contenedor de productos en el carrito

// Muestra el total del carrito
echo '<div class="card mb-5">';
echo '<div class="card-body p-4">';
echo '<div class="float-end">';
echo '<p class="mb-0 me-5 d-flex align-items-center">';
echo '<span class="small text-muted me-2">Total a pagar:</span>';
echo '<span class="lead fw-normal">' . htmlspecialchars($total) . ' €</span>';
echo '</p>';
echo '</div>';
echo '</div>';
echo '</div>';

// Muestra los botones de continuar comprando y pagar
echo '<div class="d-flex justify-content-end">';
echo '
<form action="paypal.php" method="post">
    <input type="hidden" name="total" value="' . htmlspecialchars($total) . '">
    <button type="button" class="btn btn-light btn-lg me-2 mr-5"><a href="/index.php">Seguir comprando</a></button>
    <button type="submit" class="btn btn-primary btn-lg mr-5">Pagar</button>
</form>';

echo '</div>';

echo '</div>'; // Cierre del div de la columna del contenido principal
echo '</div>'; // Cierre del div del row del contenido principal
echo '</div>'; // Cierre del div del contenedor del contenido principal
echo '</section>'; // Cierre de la sección del contenido principal
}
$conexion->close();


ob_end_flush();
?>




<script>
// Función para que los mensajes desaparezcan al cabo de 5 segundos
window.onload = function() {
    setTimeout(function() {
        var temporales = document.getElementsByClassName('temporal');

        for(var i = 0; i < temporales.length; i++) {
            (function(i) {
                var op = 1;  

                // Para disminuir la opacidad del elemento progresivamente    
                var timer = setInterval(function () {
                    if (op <= 0.1){
                        clearInterval(timer); // detiene el temporizador
                        temporales[i].style.display = 'none';
                    }
                    temporales[i].style.opacity = op;
                    temporales[i].style.filter = 'alpha(opacity=' + op * 100 + ")";
                    op -= op * 0.1;
                }, 50);
            })(i);
        }
    }, 5000);
}
</script>




</body>
</html>

