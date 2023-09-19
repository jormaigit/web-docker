<?php 
$conexion = new mysqli("base_datos", "root", "test", "tienda");

if ($conexion->connect_error) {
    die("Error de conexión " . $conexion->connect_error);
    }
    //echo "Se ha conectado correctamente" . "<br>";
?>