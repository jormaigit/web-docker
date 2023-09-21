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
  $conexion->set_charset("utf8mb4");



if(isset($_SESSION["ID_usuario"])) {
    $ID_usuario = $_SESSION["ID_usuario"];
    $sql = "SELECT COUNT(*) AS total FROM carrito WHERE ID_usuario = ?";
    $stmt = $conexion->prepare($sql);
    $stmt->bind_param('i', $ID_usuario);
    $stmt->execute();
    $result = $stmt->get_result();
    $row = $result->fetch_assoc();
    $_SESSION["totalCarrito"] = $row['total'] ? $row['total'] : 0; // Guarda el total en la sesión
}

ob_end_flush();
?>


