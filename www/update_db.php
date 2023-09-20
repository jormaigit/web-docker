<?php
ob_start();
if (session_status() == PHP_SESSION_NONE) {
    session_start();
    $session_id = session_id(); 
    }

    // Comprueba si el usuario está logueado
    if (!isset($_SESSION["emailLogued"])) {
        // Si no está logueado, redirige a index.php
        header("Location: index.php");
        exit();
    }

    $conexion = new mysqli("base_datos", "root", "test", "tienda");
    $conexion->set_charset("utf8");

$ID_usuario = $_SESSION['ID_usuario'];

// Inserta en la tabla pedidos los datos 
$sql1 = "INSERT INTO pedidos (ID_usuario, fecha_compra, en_proceso) VALUES (?, NOW(), 1)";
$stmt1 = $conn->prepare($sql1);
$stmt1->bind_param("i", $ID_usuario);
$stmt1->execute();

// Obtiene el ID del pedido insertado
$ID_pedido = $conn->insert_id;

// Obtenemos el ID y las cantidades del carrito del usuario
$sql3 = "SELECT ID_producto, cantidad FROM carrito WHERE ID_usuario = ?";
$stmt3 = $conn->prepare($sql3);
$stmt3->bind_param("i", $ID_usuario);
$stmt3->execute();
$result3 = $stmt3->get_result();

while ($row3 = $result3->fetch_assoc()) {
    $ID_producto = $row3['ID_producto']; 
    $cantidad = $row3['cantidad']; 

    // Insertamos los ID de producto, pedido y cantidad en la tabla producto_se_mueve_pedidos
    $sql2 = "INSERT INTO producto_se_mueve_pedidos (ID_producto, ID_pedido, cantidad) 
    VALUES (?, ?, ?)";
    $stmt2 = $conn->prepare($sql2);
    $stmt2->bind_param("iii", $ID_producto, $ID_pedido, $cantidad);
    $stmt2->execute();
}

// Limpia el carrito del usuario
$sql4 = "DELETE FROM carrito WHERE ID_usuario = ?";
$stmt4 = $conn->prepare($sql4);
$stmt4->bind_param("i", $ID_usuario);
$stmt4->execute();

$conn->close();

ob_end_flush();
?>
