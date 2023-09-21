<?php
ob_start();
    session_start();
    
    // Desasigna todas las variables de la sesión
    $_SESSION = array();
    
    if (ini_get("session.use_cookies")) {
        $params = session_get_cookie_params();
        setcookie(session_name(), '', time() - 42000,
            $params["path"], $params["domain"],
            $params["secure"], $params["httponly"]
        );
    }
    // Destruye la sesión
    session_destroy();

    
    header("location: index.php");
    ob_end_flush();
    exit();
    
    
?>
