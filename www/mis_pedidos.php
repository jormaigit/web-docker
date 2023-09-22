<?php
ob_start();
if (session_status() == PHP_SESSION_NONE) {
    session_start();
}

// Comprueba si el usuario está logueado
if (!isset($_SESSION["emailLogued"])) {
    // Si no está logueado, redirige a index.php
    header("Location: index.php");
    exit();
  }

  $conexion = new mysqli("base_datos", "root", "test", "tienda");
  $conexion->set_charset("utf8mb4");


$ID_usuario = isset($_SESSION['ID_usuario']) ? intval($_SESSION['ID_usuario']) : 0;

$sql1 = "SELECT * FROM pedidos WHERE ID_usuario = ?";
$stmt1 = $conexion->prepare($sql1);
$stmt1->bind_param('i', $ID_usuario);
$stmt1->execute();
$result1 = $stmt1->get_result();


echo '<h2 class="sombra mt-5 pb-5 border-bottom border-2">MIS PEDIDOS</h2>';

$contador = 1; // Variable contador a 1

if($result1->num_rows > 0) {
    while ($row1 = $result1->fetch_assoc()) {
        $ID_pedido = $row1["ID"]; // Para usarlo en la consulta select
        $fecha_compra = date("d/m/Y", strtotime($row1["fecha_compra"]));
        $estado = $row1["en_proceso"] ? "En proceso" : ($row1["finalizado"] ? "Finalizado" : "Cancelado");

        echo "<div class='container text-center pb-5 pt-5'>";
        echo '<button class="accordion btn btn-white w-100" id="accordionButton'.htmlspecialchars($contador).'">Pedido '.
        htmlspecialchars($contador).'</button>';
        echo '<div class="panel" id="accordionContent'.htmlspecialchars($contador).'">';

        echo '<div class="mt-5 border-light borde">';
        echo '<div class="d-flex justify-content-between align-items-center ml-3 mr-3 mt-3">';
        echo '<h3>Numero de pedido: ' . htmlspecialchars($ID_pedido) . '</h3>';
        echo '<p>Fecha de compra: ' . htmlspecialchars($fecha_compra) . '</p>';
        echo '<p>Estado: ' . htmlspecialchars($estado) . '</p>';
        echo '</div>';
        echo "</div>";

        // Obtiene detalles de productos y la cantidad para un pedido en concreto.        
        $sql2 = "SELECT producto.ID, producto.nombre_producto, producto.imagen, producto.precio, producto_se_mueve_pedidos.cantidad 
                FROM producto_se_mueve_pedidos 
                INNER JOIN producto ON producto_se_mueve_pedidos.ID_producto = producto.ID 
                WHERE producto_se_mueve_pedidos.ID_pedido = ?";
        $stmt2 = $conexion->prepare($sql2);
        $stmt2->bind_param('i', $ID_pedido);
        $stmt2->execute();
        $result2 = $stmt2->get_result();

        echo '<div class="row text-dark">';
    while ($row2 = $result2->fetch_assoc()) {
        echo '<div class="col-lg-4 col-md-6 mb-4">';
        echo '<div class="card h-100">';
        echo '<div class="card-img-container d-flex justify-content-center">';
        echo '<img class="card-img-top" height="250px" width="250px" src="'.htmlspecialchars($row2["imagen"]).'" alt="">';
        echo '</div>';
        echo '<div class="card-body pb-5">';
        echo '<h4 class="card-title">';
        echo '<a class="text-dark">'.htmlspecialchars($row2["nombre_producto"]).'</a>';
        echo '</h4>';
        echo '<h5>'.htmlspecialchars($row2["precio"]).'€</h5>';
        echo '<p class="card-text">Cantidad: '.htmlspecialchars($row2["cantidad"]).'</p>';
        echo '</div>';
        echo '</div>';
        echo '</div>';
    }
    echo '</div>';

        echo '</div>';
        echo '</div>';

        echo '</div>'; // Cierra div panel

        $contador++;
    }
        $stmt1->close();
        
        if (isset($stmt2)) { // verifica si stmt2 está definido antes de intentar cerrarlo de cara a errores
            $stmt2->close();
        }

} else {
    echo "<p>No hay pedidos realizados</p>";
}
    $conexion->close();
echo '</div>';

ob_end_flush();
?>

<script>
    // Script para manejar el plegado y replegado de los pedidos cuando el usuario hace click
    var acc = document.getElementsByClassName("accordion");
    var i;

    for (i = 0; i < acc.length; i++) {
        acc[i].addEventListener("click", function() {
            this.classList.toggle("active");
            var panel = document.getElementById('accordionContent' + this.id.replace('accordionButton',''));
            if (panel.style.display === "block") {
                panel.style.display = "none";
            } else {
                panel.style.display = "block";
            }
        });
    }
</script>



