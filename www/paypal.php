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


// En caso de que el total no esté definido
$total = isset($_POST["total"]) ? $_POST["total"] : 0;
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title> PayPal Checkout Integration | Horizontal Buttons </title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="/css/paypal.css">
    <link rel="icon" type="image/x-icon" href="/imagenes/otros/ALJOR S.L.ico">
</head>
<body class="bg-dark">

<h1 class="d-flex justify-content-center text-light w-100 pb-5">MÉTODOS DE PAGO</h1>
<div class="d-flex align-items-center justify-content-center">
  <div id="paypal-button-container"></div>
</div>
<script src="https://www.paypal.com/sdk/js?client-id=AVjNgKu9Y0vGoJ9WuNT4dALIGf7rKjV2vPqOjSTOYIpahnLgYn3gFXLeUokQCsUgdo4gPXREgDXY32Bb&currency=EUR"></script>

<script>
  paypal.Buttons({
    style: {
      color: 'blue',
      shape: 'pill',
      label: 'pay',
      layout: 'horizontal'
    },
    fundingSource: paypal.FUNDING.PAYPAL,
    createOrder: function(data, actions) {
      return actions.order.create({
        purchase_units: [{
          amount: {
            value: '<?php echo $total; ?>'
          }
        }]
      });
    },
    onApprove: function(data, actions) {
      return actions.order.capture().then(function(details) {
        console.log(details)
        if (details.status === 'COMPLETED') {
          $.post('update_db.php'); // post para que update_db.php haga su parte
          $('#successModal').modal('show'); // llama al modal
          setTimeout(function() {
            window.location.href = '/datosUsu.php';
          }, 5000);
        } else {
          alert('La transacción ha fallado. Por favor, inténtelo de nuevo.');
          window.location.href = '/carrito.php';
        }
      });
    }
  }).render('#paypal-button-container');
</script>

    <!-- Modal de Bootstrap que muestra en mensaje de éxito al comprar-->
    <div class="modal fade" id="successModal" tabindex="-1" role="dialog" aria-labelledby="successModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="successModalLabel">Pago exitoso</h5>
                </div>
                <div class="modal-body">
                    Tu pago se ha realizado con éxito. Serás redirigido a la página de pedidos en breve.
                </div>
            </div>
        </div>
    </div>
</body>
</html>


