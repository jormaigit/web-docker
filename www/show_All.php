<?php
// Solo se inicia sessión si no hay otra sessión ya activa
if (session_status() == PHP_SESSION_NONE) {
  session_start();
  $session_id = session_id(); // Guardo el Id de sesión para usarlo de cara a BD
  
}



// para usarlo en los titulos y descripciones
$nombre_subcategoria = $_GET["subcategoria"];


// Arrays asociativos estáticos
$titulos = array(
  "placa_base" => "PLACA BASE",
  "cpu" => "PROCESADORES",
  "ram" => "MEMORIA RAM",
  "psu" => "FUENTE DE ALIMENTACIÓN",
  "almacenamiento" => "ALMACENAMIENTO",
  "portatil" => "PORTÁTILES",
  "desktop" => "ORDENADORES DE ESCRITORIO",
  "apple" => "MÓVILES APPLE",
  "android" => "MÓVILES ANDROID",
  "raton" => "RATONES",
  "teclado" => "TECLADOS",
  "monitor" => "MONITORES",
  "cascos" => "AURICULARES",
  "televisor" => "TELEVISORES",
  "playstation" => "PLAYSTATION",
  "xbox" => "XBOX",
  "nintendo" => "NINTENDO",
  "mandos" => "MANDOS",
  "juegos" => "JUEGOS"
  );

  $descripcion = array(
    "placa_base" => "La placa base es el componente principal de un ordenador. Es como el 'corazón' que conecta todos los demás componentes y permite que funcionen juntos. Proporciona puertos y ranuras para conectar la CPU, la RAM, el almacenamiento y otros dispositivos. Sin una placa base funcional, el ordenador no puede operar correctamente.",
    "cpu" => "El procesador es el 'cerebro' de un ordenador. Se encarga de ejecutar las tareas y procesar la información. Cuanto más potente sea el procesador, más rápido y eficiente será el ordenador en la ejecución de programas y tareas.",
    "ram" => "La memoria RAM es como la 'memoria de trabajo' de un ordenador. Almacena temporalmente los datos e instrucciones que el ordenador necesita para funcionar en el corto plazo. Cuanta más RAM tenga un ordenador, más programas podrá ejecutar simultáneamente sin ralentizarse.",
    "psu" => "La fuente de alimentación es el componente que suministra energía eléctrica a todos los demás componentes del ordenador. Convierte la corriente eléctrica de la toma de corriente en voltajes y corrientes adecuados para cada componente. Una fuente de alimentación confiable y de alta calidad es esencial para un funcionamiento estable del ordenador.",
    "almacenamiento" => "El almacenamiento se refiere a los dispositivos utilizados para guardar los datos en un ordenador de forma permanente. Los discos duros y los discos de estado sólido (SSD) son los tipos de almacenamiento más comunes. Cuanta mayor capacidad de almacenamiento tenga un ordenador, más archivos y programas podrá guardar.",
    "portatil" => "Los portátiles son ordenadores compactos y portátiles diseñados para ser utilizados sobre la marcha. Son perfectos para usuarios que necesitan movilidad y flexibilidad. Los portátiles suelen incluir una pantalla, un teclado y otros componentes internos necesarios para su funcionamiento.",
    "desktop" => "Las computadoras de escritorio son sistemas informáticos completos diseñados para ser utilizados en un escritorio o lugar fijo. Ofrecen un mayor rendimiento y capacidad de actualización en comparación con los portátiles. Son ideales para usuarios que requieren un mayor poder de procesamiento y capacidad de almacenamiento.",
    "apple" => "Los productos de Apple son dispositivos electrónicos conocidos por su calidad, diseño elegante y experiencia de uso intuitiva. Incluyen iPhones, iPads, MacBooks, iMacs y otros dispositivos. Los productos de Apple son apreciados por su rendimiento, facilidad de uso y ecosistema integrado.",
    "android" => "Android es un sistema operativo móvil utilizado en una amplia gama de dispositivos, como smartphones y tablets. Es conocido por su versatilidad, personalización y amplia disponibilidad de aplicaciones en la tienda de Google Play. Android es uno de los sistemas operativos móviles más populares en el mundo.",
    "raton" => "El ratón es un dispositivo de entrada utilizado para controlar el movimiento del cursor en la pantalla del ordenador. Permite a los usuarios interactuar con la interfaz gráfica, hacer clic, arrastrar y soltar elementos. Los ratones pueden tener diferentes diseños y características adicionales para adaptarse a las necesidades de cada usuario.",
    "teclado" => "El teclado es un dispositivo de entrada utilizado para escribir texto y enviar comandos al ordenador. Contiene un conjunto de teclas que representan letras, números, símbolos y funciones especiales. Los teclados pueden tener diferentes diseños y características, como retroiluminación o teclas mecánicas.",
    "monitor" => "El monitor es el dispositivo de salida que muestra la información visual generada por el ordenador. Proporciona una interfaz visual para que los usuarios puedan ver imágenes, vídeos, documentos y otros contenidos. Los monitores vienen en diferentes tamaños y tecnologías para ofrecer una experiencia visual de alta calidad.",
    "cascos" => "Los auriculares son dispositivos de salida utilizados para escuchar audio en un ordenador. Proporcionan una experiencia de audio inmersiva y personal. Los auriculares pueden ser con cable o inalámbricos, y ofrecen funciones adicionales como cancelación de ruido o micrófonos incorporados.",
    "televisor" => "El televisor es un dispositivo de visualización utilizado para ver contenido audiovisual en el hogar. Proporciona una pantalla más grande y de mayor resolución que los monitores de ordenador. Los televisores modernos suelen ser inteligentes, lo que les permite acceder a servicios de streaming y contenido en línea.",
    "playstation" => "PlayStation es una marca de consolas de videojuegos conocida por su amplia selección de juegos y experiencias de entretenimiento. Las consolas PlayStation ofrecen gráficos de alta calidad, exclusivas populares y funciones multimedia. También permiten jugar en línea con otros jugadores y acceder a servicios adicionales.",
    "xbox" => "Xbox es una marca de consolas de videojuegos desarrollada por Microsoft. Las consolas Xbox ofrecen una amplia variedad de juegos, incluyendo títulos exclusivos y populares. También proporcionan servicios de entretenimiento multimedia y opciones de juego en línea con otros jugadores.",
    "nintendo" => "Nintendo es una reconocida empresa de videojuegos conocida por sus consolas y juegos icónicos. Sus consolas, como Nintendo Switch y Nintendo 3DS, ofrecen experiencias de juego únicas y exclusivas. Los juegos de Nintendo, como Super Mario, The Legend of Zelda y Pokémon, son populares entre jugadores de todas las edades.",
    "mandos" => "Los controladores, también conocidos como mandos o gamepads, son dispositivos de entrada utilizados para controlar videojuegos en consolas u ordenadores. Permiten a los jugadores interactuar con los juegos a través de botones, palancas y otros controles. Los controladores ofrecen una experiencia de juego cómoda y facilitan la inmersión en los juegos.",
    "juegos" => "Los juegos son programas de software diseñados para entretener a los usuarios mediante desafíos interactivos y narrativas. Hay una amplia variedad de géneros de juegos, como acción, aventura, deportes, estrategia, RPG, entre otros. Los juegos se pueden disfrutar en consolas, ordenadores y dispositivos móviles, y ofrecen experiencias divertidas y emocionantes para los jugadores."
  );
  

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
    <link rel="stylesheet" href="/css/showall.css">
    <link rel="stylesheet" href="/css/index.css">
    <link rel="icon" type="image/x-icon" href="/imagenes/otros/ALJOR S.L.ico">
    <title>ALJOR S.L</title>
</head>
<body>
  <?php
          // Para mostrar boton provisional logout si hay un usuario que haya iniciado sesión 
          if(isset($_SESSION["emailLogued"]) && !empty($_SESSION["emailLogued"])){ 
          // Para mostrar la barra de arriba, si el usuario está logueado, con su correo
          include("indexlogueado.php");
          }
          else{
        ?>
<!-- BARRAD DE NAVEGACIÓN PRINCIPAL-->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark ">
    <div class="col-2 container-fluid justify-content-center">
      <a class="navbar-brand" href="/index.php">
        <img src="/imagenes/otros/ALJOR S.L.png" alt="" width="40" height="40" class="d-inline-block align-text-center">
        ALJOR
      </a>    
    </div> 
    <div class="col-lg-4 col-md-12 container-fluid justify-content-center">
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
      <a class="nav-link text-light" href="/registro.php"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" class="bi bi-person" viewBox="0 0 16 16">
        <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6Zm2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0Zm4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4Zm-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10c-2.29 0-3.516.68-4.168 1.332-.678.678-.83 1.418-.832 1.664h10Z"/>
      </svg>  Regístrate</a>

      <a class="nav-link text-light" href="/login.php"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" class="bi bi-person" viewBox="0 0 16 16">
        <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6Zm2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0Zm4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4Zm-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10c-2.29 0-3.516.68-4.168 1.332-.678.678-.83 1.418-.832 1.664h10Z"/>
      </svg>  Inicia Sesión</a>

      <a id="botonCarrito" class="nav-link text-light" href="/login.php"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" class="bi bi-cart2" viewBox="0 0 16 16">
        <path d="M0 2.5A.5.5 0 0 1 .5 2H2a.5.5 0 0 1 .485.379L2.89 4H14.5a.5.5 0 0 1 .485.621l-1.5 6A.5.5 0 0 1 13 11H4a.5.5 0 0 1-.485-.379L1.61 3H.5a.5.5 0 0 1-.5-.5zM3.14 5l1.25 5h8.22l1.25-5H3.14zM5 13a1 1 0 1 0 0 2 1 1 0 0 0 0-2zm-2 1a2 2 0 1 1 4 0 2 2 0 0 1-4 0zm9-1a1 1 0 1 0 0 2 1 1 0 0 0 0-2zm-2 1a2 2 0 1 1 4 0 2 2 0 0 1-4 0z"/>
      </svg>  Carrito</a>
      
    </div>
</nav>
    <?php
            }
    ?>

<!-- BARRA DE NAVEGACIÓN DE PRODUCTOS-->

<nav class="navbar navbar-expand-lg navbar-dark bg-dark border-top border-bottomborder-light">
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

<div class="bg-dark text-light pt-5 pb-5 border-2 border-top border-light border-botttom">
  <?php
  // Para mostrar el titulo
  if (isset($titulos[$nombre_subcategoria])) {
    echo "<p class='sombra tamanio text-center'>" . $titulos[$nombre_subcategoria] . "</p>";
  } else {
    echo "El título para esta subcategoría no está disponible.";
  }
  ?>
</div>

</div>
<div class="sombra d-flex bg-dark text-light border-light pb-5 border-top border-2 border-light align-items-center">
<div class="flex-row col-12 text-center pt-5">
    <?php
    // Para mostrar la descripción 
        if (isset($descripcion[$nombre_subcategoria])) {
            echo $descripcion[$nombre_subcategoria];
        } else {
            echo "La descripción para esta subcategoría no está disponible.";
        }
    ?>
</div>
</div>



<?php 

//    ------------------>  TEST DE FILTROS   <----------------------

// Guardo en $subcategoria que valor va a tomar según se haya echo click en index.php o aqui
$subcategoria = isset($_GET['subcategoria']) ? $_GET['subcategoria'] : "null";
$subcategoria = htmlspecialchars($subcategoria, ENT_QUOTES, 'UTF-8');

function mostrarProductos($subcategoria, $precio_min, $precio_max, $conexion) {

  // Consulta con filtros aplicados y segun subcategoria
  $sql = "SELECT * FROM producto WHERE subcategoria = ? AND precio BETWEEN ? AND ?";
  $stmt = $conexion->prepare($sql);
  $stmt->bind_param("sdd", $subcategoria, $precio_min, $precio_max);
  $stmt->execute();
  $result = $stmt->get_result();

  // Mostramos los productos
  if ($result->num_rows > 0) {
    echo "<div id='filtros_y_resultados'>";

  while ($row = $result->fetch_assoc()) {
    echo "<div class='product-container bg-dark col-md-4 col-lg-3 col-sm-6'>";
    $imagen = htmlspecialchars($row['imagen'], ENT_QUOTES, 'UTF-8');
    $nombre_producto = htmlspecialchars($row['nombre_producto'], ENT_QUOTES, 'UTF-8');
    $precio = htmlspecialchars($row['precio'], ENT_QUOTES, 'UTF-8');
    
    echo "<div class='row'>";
    echo "<div class='col-12 col-md-6'>";
    echo "<img class='imagen' src='" . $imagen . "' alt='" . $nombre_producto . "'>";
    echo "</div>";
    echo "<div class='col-12 col-md-6'>";
    echo "<h2 class='product-name mt-4'><a class='sindecoracion' href='/mostarProducto.php?id=" . $row['ID'] . "'>" . $nombre_producto . "</a></h2>";
    echo "<div class='precio-producto text-white'>" . $precio . " €</div>";
    echo "</div>";
    echo "</div>";
    echo "</div>";
    
  }


  } else {
    echo "<span>No se encontraron productos en el rango de precios seleccionado.</span>";
    echo "</div>";
    }
    // Scroll y focus del UI automático
    echo "<script>document.getElementById('filtros_y_resultados')
    .scrollIntoView({ behavior: 'smooth', block: 'start' });</script>";
  
}

?>

<br><br>
<?php
// Ocultar formulario precios si la subcategoria no es correcta
if (in_array($subcategoria, array_keys($titulos))){
?>
<!-- Formulario para aplicar filtros -->
<div class="d-flex justify-content-center">
<form method="GET" action="show_All.php" id="formFiltros">
  <input type="hidden" name="subcategoria" value="<?php echo $subcategoria; ?>">
<div class="col-lg-12">
  <label for="precio_min">Precio mínimo:</label>
  <input type="number" id="precio_min" name="precio_min" step="0.01" min="0">
  </div>  
  <div class="col-lg-12">
  <label for="precio_max">Precio máximo:</label>
  <input type="number" id="precio_max" name="precio_max" step="0.01" min="0">
  </div>
  <div class="col-lg-12">
  <button class="btn btn-light" type="submit">Aplicar filtros</button>
  <button class="btn btn-light" type="submit" name="borrar_filtros" id="resetFiltros">Borrar filtros</button>
  </div>
</form>
</div>
<?php
}
?>


<?php
  // Valores predeterminados para los filtros
  $precio_min = 0;
  $precio_max = 10000;

// Verifica si se ha enviado el formulario y los campos están rellenos para mostrar los productos
if ($_SERVER['REQUEST_METHOD'] == 'GET') {

    // Verifica si se presionó el botón "Borrar filtros"
    if (isset($_GET['borrar_filtros'])) {
        $precio_min = 0;
        $precio_max = 10000;
    } else {
        // Precio mínimo formulario
        if (isset($_GET['precio_min']) && !empty($_GET['precio_min'])) {
            $precio_min = $_GET['precio_min'];
        }

        // Precio máximo formulario
        if (isset($_GET['precio_max']) && !empty($_GET['precio_max'])) {
            $precio_max = $_GET['precio_max'];
        }
    }

    // Validación de que el precio máximo no sea menor que el precio mínimo
    if ($precio_max < $precio_min) {
      echo "<span>El precio máximo no puede ser menor que el precio mínimo.</span>";
      exit;
    }

          // Conecta a la base de datos
          include("conx_BD.php");

          // Llamo a la función mostrarProductos según la subcategoría
          if ($subcategoria === "placa_base") {
            mostrarProductos('placa base', $precio_min, $precio_max, $conexion);
          }
          elseif ($subcategoria === "cpu") {
            mostrarProductos('cpu', $precio_min, $precio_max, $conexion);
          }
          elseif ($subcategoria === "ram") {
            mostrarProductos('ram', $precio_min, $precio_max, $conexion);
          }
          elseif ($subcategoria === "psu") {
            mostrarProductos('psu', $precio_min, $precio_max, $conexion);
          }
          elseif ($subcategoria === "almacenamiento") {
            mostrarProductos('almacenamiento', $precio_min, $precio_max, $conexion);
          }       
          elseif ($subcategoria === "portatil") {
            mostrarProductos('portatil', $precio_min, $precio_max, $conexion);
          }
          elseif ($subcategoria === "desktop") {
            mostrarProductos('desktop', $precio_min, $precio_max, $conexion);
          }
          elseif ($subcategoria === "apple") {
            mostrarProductos('apple', $precio_min, $precio_max, $conexion);
          }
          elseif ($subcategoria === "android") {
            mostrarProductos('android', $precio_min, $precio_max, $conexion);
          }
          elseif ($subcategoria === "raton") {
            mostrarProductos('raton', $precio_min, $precio_max, $conexion);
          }
          elseif ($subcategoria === "teclado") {
            mostrarProductos('teclado', $precio_min, $precio_max, $conexion);
          }
          elseif ($subcategoria === "monitor") {
            mostrarProductos('monitor', $precio_min, $precio_max, $conexion);
          }
          elseif ($subcategoria === "cascos") {
            mostrarProductos('cascos', $precio_min, $precio_max, $conexion);
          }
          elseif ($subcategoria === "televisor") {
            mostrarProductos('televisor', $precio_min, $precio_max, $conexion);
          }
          elseif ($subcategoria === "playstation") {
            mostrarProductos('playstation', $precio_min, $precio_max, $conexion);
          }
          elseif ($subcategoria === "xbox") {
            mostrarProductos('xbox', $precio_min, $precio_max, $conexion);
          }
          elseif ($subcategoria === "nintendo") {
            mostrarProductos('nintendo', $precio_min, $precio_max, $conexion);
          }
          elseif ($subcategoria === "mandos") {
            mostrarProductos('mandos', $precio_min, $precio_max, $conexion);
          }
          elseif ($subcategoria === "juegos") {
            mostrarProductos('juegos', $precio_min, $precio_max, $conexion);
          }
          else {
            echo "NO SE ENCONTRARON PRODUCTOS";
          }
        
          $conexion->close();
  }
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
