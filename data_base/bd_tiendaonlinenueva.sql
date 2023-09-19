/* create database tienda;
drop database tienda;
use tienda;
SET SQL_SAFE_UPDATES = 0;

-- -------------------------------------------
-- --------------------------------------------
-- ---------------- *************************************** ------------------------
-- ********************** SENTENCIAS CONSULTAR/BORRAR TABLAS  *****************************
-- ---------------- **************************************** -----------------------

-- Consultas TABLA USUARIO
select * from usuario;
-- Consultas TABLA PRODUCTOS
select * from producto;
-- Consultas TABLA CARRITO
select * from carrito;
-- Consultas TABLA PEDIDOS
select * from pedidos;

-- delete from pedidos;
-- Consultas TABLA PRODUCTO_SE_MUEVE_PEDIDOS
select * from producto_se_mueve_pedidos;

-- delete from producto_se_mueve_pedidos;


-- Ver todas las tablas creadas
SELECT TABLE_NAME
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'tienda';
-- ------------------------------------
DROP TABLE IF EXISTS producto_se_mueve_pedidos;
DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS carrito;
DROP TABLE IF EXISTS producto;
DROP TABLE IF EXISTS usuario;
*/

-- --------------------------
-- ************ 	TABLA 	USUARIO		**********************
CREATE TABLE usuario (
  ID int auto_increment primary key,
  nombre varchar(50) not null,
  contrasenia varchar(255) not null, -- Modificar la longitud aquí
  telefono int(9),
  f_nacimiento varchar(12),
  email varchar(50) unique,

  CONSTRAINT check_telefono CHECK 
  (telefono REGEXP '^[0-9]{0}$|^[0-9]{9}$'),

  CONSTRAINT check_f_nacimiento CHECK 
  (f_nacimiento REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'),

  CONSTRAINT check_email CHECK 
  (email REGEXP '^[^@]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
);

-- Te tienes que crear un usuario desde registro.php
-- Usa la contraseña -->Contra$12Aa<-- en todos los usuarios que te crees ya que en la BD ahora las contraseñas se guardan encriptadas


-- ----------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------
-- ************ 	TABLA 	PRODUCTO	**********************

CREATE TABLE producto (
  ID INT AUTO_INCREMENT PRIMARY KEY,
  precio DECIMAL(6,2) NOT NULL CHECK (precio >= 0),
  nombre_producto VARCHAR(200) NOT NULL,
  imagen VARCHAR(200) NOT NULL,
  descripcion TEXT,
  stock int(2) not null check (stock >= 0 and stock <= 99),
  tipo VARCHAR(50) NOT NULL 
  CHECK (tipo IN ('componente', 'ordenador', 'smartphone', 'periferico', 'televisor', 'consola')),
  subcategoria VARCHAR(50),
  detalles JSON,
  CONSTRAINT check_subcategoria CHECK (
    (tipo = 'componente' AND subcategoria IN ('placa base', 'cpu', 'ram', 'psu', 'almacenamiento')) OR
    (tipo = 'ordenador' AND subcategoria IN ('portatil', 'desktop')) OR
    (tipo = 'smartphone' AND subcategoria IN ('apple', 'android')) OR
    (tipo = 'periferico' AND subcategoria IN ('raton', 'teclado', 'monitor', 'cascos')) OR
    (tipo = 'consola' AND subcategoria IN ('playstation', 'xbox', 'nintendo', 'mandos', 'juegos')) OR
    (tipo = 'televisor' AND subcategoria = 'televisor')
  )
);

-- -----------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------
-- ************ 	TABLA 	CARRITO	**********************
CREATE TABLE carrito (
    ID_usuario INT,
    ID_producto INT,
    cantidad INT NOT NULL,
    PRIMARY KEY (ID_usuario, ID_producto),
    CONSTRAINT fk_usuario_compra FOREIGN KEY (ID_usuario) REFERENCES usuario(ID) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_producto_compra FOREIGN KEY (ID_producto) REFERENCES producto(ID) ON UPDATE CASCADE ON DELETE CASCADE
);

-- ----------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------
-- ************ 	TABLA 	PEDIDOS		**********************
CREATE TABLE pedidos (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    ID_usuario INT NOT NULL,
    fecha_compra DATE NOT NULL,
    fecha_entrega DATE NULL , -- Modificado para permitir NULL
    en_proceso BOOLEAN,
    finalizado BOOLEAN,
    cancelado BOOLEAN,
    CONSTRAINT fk_usuario_pedidos FOREIGN KEY (ID_usuario) REFERENCES usuario(ID) ON UPDATE CASCADE ON DELETE CASCADE,

    -- Restricciones para comprobar que el estado del pedido es siempre solo 1 de entre los 3 posibles
    CONSTRAINT check_estado_pedido CHECK (
            (en_proceso = TRUE AND finalizado = FALSE AND cancelado = FALSE) OR
            (en_proceso = FALSE AND finalizado = TRUE AND cancelado = FALSE) OR
            (en_proceso = FALSE AND finalizado = FALSE AND cancelado = TRUE))
    
    -- Comprobar que la fecha de entrega es mayor a la fecha de compra
    -- CONSTRAINT check_fechaentrega_esmayor CHECK (fecha_entrega > fecha_compra)
);


-- ----------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------
-- ************ 	TABLA 	PRODUCTO_SE_MUEVE_PEDIDOS		**********************
CREATE TABLE producto_se_mueve_pedidos (
    ID_producto INT NOT NULL,
    ID_pedido INT NOT NULL,
    cantidad INT NOT NULL,
    PRIMARY KEY (ID_producto, ID_pedido),
    CONSTRAINT fk_producto_semueve FOREIGN KEY (ID_producto) REFERENCES producto(ID) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_pedido_semueve FOREIGN KEY (ID_pedido) REFERENCES pedidos(ID) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ----------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------




-- ¡¡¡IMPORTANTE PONER LA RUTA RELATIVA TAL QUE ASI!!!
-- '/imagenes/componentes/placa_base/GIGABYTE AORUS X570 Master.webp'

-- ------   ************   PLACAS BASE   ************************* -----------------

 -- 1    ASUS ROG Strix B450-F Gaming
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
  139.99,
  'ASUS ROG Strix B450-F Gaming',
  '/imagenes/componentes/placa_base/ASUS ROG Strix B450-F Gaming.jpg',
  'Placa base para procesadores AMD Ryzen, con iluminación RGB y soporte para M.2',
  5,
  'componente',
  'placa base',
  '{"socket": "AM4", "chipset": "AMD B450", "formato": "ATX", "memoria_maxima": "64 GB", "slots_memoria": 4, "velocidades_memoria": "3200 (OC) / 3000 (OC) / 2933 / 2800 / 2666 / 2400 / 2133 MHz", "puertos_sata": 6, "puertos_m2": 2, "puertos_pci": "1 x PCIe 3.0 x16 (modo x16), 1 x PCIe 2.0 x16 (modo x4), 3 x PCIe 2.0 x1", "conectores_ventilador": 6, "puertos_usb": "2 x USB 3.1 Gen 2, 4 x USB 3.1 Gen 1, 2 x USB 2.0", "red": "Intel I211-AT, Realtek RTL8111H", "audio": "Realtek ALC1220A Codec, Sonic Studio III, DTS Sound Unbound"}'
);

-- 2    GIGABYTE AORUS X570 Master
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
  329.99,
  'GIGABYTE AORUS X570 Master',
  '/imagenes/componentes/placa_base/GIGABYTE AORUS X570 Master.webp', -- ¡¡¡IMPORTANTE PONER LA RUTA RELATIVA TAL QUE ASI!!!
  'Placa base para procesadores AMD Ryzen, con refrigeración activa para discos NVMe M.2 y soporte para WiFi 6',
  3,
  'componente',
  'placa base',
  '{"socket": "AM4", "chipset": "AMD X570", "formato": "ATX", "memoria_maxima": "128 GB", "slots_memoria": 4, "velocidades_memoria": "4400(O.C)/ 4300(O.C)/ 4266(O.C.)/ 4133(O.C.)/ 4000(O.C.)/ 3866(O.C.)/ 3800(O.C.)/ 3733(O.C.)/ 3600(O.C.)/ 3466(O.C.)/ 3400(O.C.)/ 3200/ 2933/ 2667/ 2400/ 2133 MHz", "puertos_sata": 6, "puertos_m2": 3, "puertos_pci": "1 x PCI Express 4.0 x16 Slot (PCIE1: x16 mode), 1 x PCI Express 4.0 x16 Slot (PCIE2: x8 mode), 1 x PCI Express 4.0 x16 Slot (PCIE3: x4 mode), 2 x PCI Express 4.0 x1 Slots", "conectores_ventilador": 7, "puertos_usb": "1 x USB 3.2 Gen 2 Type-C port (rear panel), 1 x USB 3.2 Gen 2 Type-A port (rear panel), 2 x USB 3.2 Gen 1 ports (rear panel), 2 x USB 3.2 Gen 2 Type-A ports (red), 2 x USB 3.2 Gen 1 headers, 2 x USB 2.0/1.1 headers", "red": "Intel GbE LAN chip (10/100/1000/2500Mbps)", "audio": "Realtek ALC1220-VB codec, ESSential 9118 DAC, Wima capacitors, Nichicon audio capacitors, RGB FUSION 2.0"}'
);

-- 3    MSI MPG B550 Gaming Edge WiFi
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles) 
VALUES (
  158.99,
  'MSI MPG B550 Gaming Edge WiFi',
  '/imagenes/componentes/placa_base/MSI MPG B550 Gaming Edge WiFi.webp',
  'Placa base AMD AM4 DDR4 M.2 USB 3.2 Gen 2 HDMI ATX Gaming',
  5,
  'componente',
  'placa base',
  '{"socket": "AM4", "chipset": "AMD B550", "formato": "ATX", "memoria_maxima": "128GB", "slots_memoria": "4", "velocidades_memoria": "5100+ (OC) MHz", "puertos_sata": "6", "puertos_m2": "2", "puertos_pci": "2", "conectores_ventilador": "5", "puertos_usb": "12", "red": "2.5G LAN with LAN Manager and Intel Wi-Fi 6 AX Solution", "audio": "Realtek ALC1200 Codec"}'
);

-- 4    ASRock A520M-HDV
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles) 
VALUES (
  61.99,
  'ASRock A520M-HDV',
  '/imagenes/componentes/placa_base/ASRock A520M-HDV.webp',
  'Placa base para procesadores AMD Ryzen con soporte para M.2',
  5,
  'componente',
  'placa base',
  '{"socket": "AM4", "chipset": "AMD A520", "formato": "Micro ATX", "memoria_maxima": "64 GB", "slots_memoria": 2, "velocidades_memoria": "4733+ (OC) MHz", "puertos_sata": 4, "puertos_m2": 1, "puertos_pci": "1 x PCIe 3.0 x16, 1 x PCIe 3.0 x1", "conectores_ventilador": "2", "puertos_usb": "6 x USB 3.2 Gen1 (4 x Rear, 2 x Front), 6 x USB 2.0 (2 x Rear, 4 x Front)", "red": "Realtek Gigabit LAN", "audio": "Realtek ALC887 Audio Codec"}'
);

-- 5    ASRock A520M-HVS
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles) 
VALUES (
  84.99,
  'ASRock A520M-HVS',
  '/imagenes/componentes/placa_base/ASRock A520M-HVS.webp',
  'Placa base para procesadores AMD Ryzen con soporte para M.2',
  5,
  'componente',
  'placa base',
  '{"socket": "AM4", "chipset": "AMD A520", "formato": "Micro ATX", "memoria_maxima": "64 GB", "slots_memoria": 2, "velocidades_memoria": "4733+ (OC) MHz", "puertos_sata": 4, "puertos_m2": 1, "puertos_pci": "1 x PCIe 3.0 x16, 1 x PCIe 3.0 x1", "conectores_ventilador": "1", "puertos_usb": "6 x USB 3.2 Gen1 (4 x Rear, 2 x Front), 6 x USB 2.0 (2 x Rear, 4 x Front)", "red": "Realtek Gigabit LAN", "audio": "Realtek ALC887 Audio Codec"}'
);

-- 6    ASRock B450M Pro4 R2.0'
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles) 
VALUES (
  79.99,
  'ASRock B450M Pro4 R2.0',
  '/imagenes/componentes/placa_base/ASRock B450M Pro4 R2.0.webp',
  'Placa base para procesadores AMD Ryzen con soporte para M.2 y CrossFireX',
  5,
  'componente',
  'placa base',
  '{"socket": "AM4", "chipset": "AMD B450", "formato": "Micro ATX", "memoria_maxima": "64 GB", "slots_memoria": 4, "velocidades_memoria": "3200+ (OC) MHz", "puertos_sata": 4, "puertos_m2": 2, "puertos_pci": "1 x PCIe 3.0 x16, 1 x PCIe 2.0 x16 (modo x4), 1 x PCIe 2.0 x1", "conectores_ventilador": "3", "puertos_usb": "2 x USB 3.2 Gen2 (Rear Type-A+C), 6 x USB 3.2 Gen1 (2 Front, 4 Rear)", "red": "Realtek Gigabit LAN", "audio": "Realtek ALC892/897 Audio Codec"}'
);

-- 7    ASUS Prime B450M-A II
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles) 
VALUES (
  85.99,
  'ASUS Prime B450M-A II',
  '/imagenes/componentes/placa_base/ASUS Prime B450M-A II.webp',
  'Placa base micro-ATX AMD B450 (Ryzen AM4) con soporte M.2, HDMI/DVI-D/D-Sub, SATA 6 Gbps, 1 Gb Ethernet y USB 3.2 Gen. 2 de tipo A',
  5,
  'componente',
  'placa base',
  '{"socket": "AM4", "chipset": "AMD B450", "formato": "Micro ATX", "memoria_maxima": "64 GB", "slots_memoria": 4, "velocidades_memoria": "3466+ (OC) MHz", "puertos_sata": 6, "puertos_m2": 1, "puertos_pci": "1 x PCIe 3.0 x16, 2 x PCIe 2.0 x1", "conectores_ventilador": "2", "puertos_usb": "6 x USB 3.2 Gen1 (2 Frontales, 4 Traseros), 2 x USB 3.2 Gen2 (Trasero Tipo A+C)", "red": "Realtek Gigabit LAN", "audio": "Realtek ALC887 Audio Codec"}'
);

-- 8    ASUS Prime Z790-A WiFi
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles) 
VALUES (
  334.99,
  'ASUS Prime Z790-A WiFi',
  '/imagenes/componentes/placa_base/ASUS Prime Z790-A WiFi.webp',
  'Placa base Intel Z790 LGA 1700 ATX con PCIe® 5.0, cuatro ranuras M.2, 16+1 DrMOS, DDR5, Intel WIFI 6E y LAN de 2,5 Gb',
  5,
  'componente',
  'placa base',
  '{"socket": "LGA1700", "chipset": "Intel Z790", "formato": "ATX", "memoria_maxima": "128 GB", "slots_memoria": 4, "velocidades_memoria": "DDR5 6000+ (OC) MHz", "puertos_sata": 6, "puertos_m2": 4, "puertos_pci": "2 x PCIe 5.0/4.0 x16, 1 x PCIe 4.0 x4", "conectores_ventilador": "5", "puertos_usb": "12 x USB 3.2 Gen 2x2 Type-A, 2 x USB 3.2 Gen 2 Type-C, 2 x USB 2.0", "red": "Intel Ethernet de 2.5 Gb", "audio": "Realtek ALC897 Audio Codec"}'
);

-- 9    ASUS Prime Z790-P WiFi
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles) 
VALUES (
  286.00,
  'ASUS Prime Z790-P WiFi',
  '/imagenes/componentes/placa_base/ASUS Prime Z790-P WiFi.webp',
  'Placa base Intel Z790 LGA 1700 ATX con PCIe® 5.0, tres ranuras M.2, 14+1 DrMOS, DDR5 y LAN Realtek de 2,5 Gb',
  5,
  'componente',
  'placa base',
  '{"socket": "LGA1700", "chipset": "Intel Z790", "formato": "ATX", "memoria_maxima": "128 GB", "slots_memoria": 4, "velocidades_memoria": "DDR5 6000+ (OC) MHz", "puertos_sata": 6, "puertos_m2": 3, "puertos_pci": "1 x PCIe 5.0/4.0 x16, 2 x PCIe 4.0 x4", "conectores_ventilador": "3", "puertos_usb": "10 x USB 3.2 Gen 2 Type-A, 2 x USB 2.0", "red": "Realtek Ethernet de 2.5 Gb", "audio": "Realtek ALC897 Audio Codec"}'
);

-- 10    ASUS ROG Strix Z790-E Gaming WiFi
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
  579.00,
  'ASUS ROG Strix Z790-E Gaming WiFi',
  '/imagenes/componentes/placa_base/ASUS ROG Strix Z790-E Gaming WiFi.webp',
  'Placa base Intel Z790 LGA 1700 ATX con 18 + 1 etapas de potencia, DDR5 y cinco ranuras M.2',
  5,
  'componente',
  'placa base',
  '{"socket": "LGA1700", "chipset": "Intel Z790", "formato": "ATX", "memoria_maxima": "256 GB", "slots_memoria": 4, "velocidades_memoria": "DDR5 5333+ MHz (OC)", "puertos_sata": 6, "puertos_m2": 5, "puertos_pci": "3 x PCIe 5.0 x16 (x16, x8/x8, x8/x4/x4), 1 x PCIe 5.0 x1", "conectores_ventilador": "2 x CPU Fan, 3 x Chassis Fan, 1 x VRM Fan", "puertos_usb": "5 x USB 3.2 Gen 2 (4 x Type-A, 1 x Type-C), 6 x USB 3.2 Gen 1, 4 x USB 2.0", "red": "Intel WiFi 6E, Intel Ethernet I225-V 2.5Gb Ethernet, LANGuard", "audio": "ROG SupremeFX 7.1 Surround Sound"}'
);

-- 11    Gigabyte B550M AORUS Elite
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
  109.99,
  'Gigabyte B550M AORUS Elite',
  '/imagenes/componentes/placa_base/Gigabyte B550M AORUS Elite.webp',
  'Placa base AMD B550 Ultra Durable con solución VRM digital pura, ranura PCIe 4.0 x16 y conectores M.2 duales',
  5,
  'componente',
  'placa base',
  '{"socket": "AM4", "chipset": "AMD B550", "formato": "Micro ATX", "memoria_maxima": "128 GB", "slots_memoria": 4, "velocidades_memoria": "DDR4 5200+ MHz (OC)", "puertos_sata": 6, "puertos_m2": 2, "puertos_pci": "1 x PCIe 4.0 x16, 1 x PCIe 3.0 x16 (x4), 1 x PCIe 3.0 x1", "conectores_ventilador": "2 x RGB, 3 x ARGB, 2 x CPU Fan, 2 x System Fan, 1 x CPU cooler, 1 x Water cooling CPU Fan", "puertos_usb": "1 x USB 3.2 Gen 2x2 Type-C, 2 x USB 3.2 Gen 2 Type-A, 2 x USB 3.2 Gen 1, 4 x USB 2.0", "red": "Realtek 2.5GbE LAN", "audio": "Realtek ALC1200 codec"}'
);


-- 12    Gigabyte B760M GAMING X DDR4
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles) 
VALUES ( 
136.98,
 'Gigabyte B760M GAMING X DDR4',
 '/imagenes/componentes/placa_base/Gigabyte B760M GAMING X DDR4.jpg',
'Placa base Intel ® B760 Chipset DDR4 M.2 USB 3.2 Gen 1 HDMI Micro ATX Gaming, ranura PCIe 4.0 x16, 2 conectores PCIe 4.0 x4 M.2', 
5,
 'componente',
 'placa base',
 '{"socket": "LGA1700", "chipset": "Intel ® B760", "formato": "Micro ATX", "memoria_maxima": "128GB", "slots_memoria": "4", "velocidades_memoria": "5300 (OC) MHz", "puertos_sata": "6", "puertos_m2": "1", "puertos_pci": "1", "conectores_ventilador": "3", "puertos_usb": "8", "red": "Realtek® GbE LAN chip (1000 Mbit/100 Mbit)", "audio": "Realtek® ALC897 codec"}'
);












-- ********PROCESADORES (CPU). Ejemplo de Intel y de AMD******







-- 1     Intel Core i5-12400F 2.5 GHz
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
  167.19,
  'Intel Core i5-12400F 2.5 GHz',
  '/imagenes/componentes/cpu/Intel Core i5-12400F 2.5 GHz.webp',
  'Procesador de alto rendimiento con 6 núcleos y 12 hilos. No incluye gráficos integrados.',
  10,
  'componente',
  'cpu',
  '{"socket": "LGA 1700", "base_frequency": "2.5 GHz", "l3_cache_size": "18MB", "total_l2_cache": "7.5MB", "processor_cores": "6 (6P+0E)", "processor_threads": "12", "maximum_memory_speed": "DDR5 4800 DDR4 3200", "max_turbo_frequency": "Up to 4.4", "cpu_pcie_5_0_lanes": 16, "cpu_pcie_4_0_lanes": 4, "unlocked": "No", "chipset_compatibility": "Intel® 600 Series Chipset", "processor_graphics": "N/A", "memory_channels": 2, "maximum_memory_capacity": "128GB"}'
);


-- 2    AMD Ryzen 5 5600G 4.4 GHz
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
  129.99,
  'AMD Ryzen 5 5600G 4.4 GHz',
  '/imagenes/componentes/cpu/AMD_Ryzen_5_5600G.jpg',
  'Procesador de alto rendimiento con 6 núcleos, 12 hilos y gráficos integrados.',
  10,
  'componente',
  'cpu',
  '{"num_cores_cpu": 6, "num_subprocesos": 12, "num_cores_gpu": 7, "reloj_base": "3.9GHz", "reloj_max_aumento": "Hasta 4.4GHz", "cache_l2_total": "3MB", "cache_l3_total": "16MB", "desbloqueado": "Si", "cmos": "TSMC 7nm FinFET", "paquete": "AM4", "version_pci_express": "PCIe® 3.0", "solucion_termica": "Wraith Stealth", "tdp": "65W", "max_temp": "95°C", "velocidad_max_memoria": "Up to 3200MHz", "tipo_memoria": "DDR4"}'
);


-- 3    AMD Ryzen 5 5500 3.6GHz Box
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
  98.99,
  'AMD Ryzen 5 5500 3.6GHz Box',
  '/imagenes/componentes/cpu/AMD Ryzen 5 5500 3.6GHz Box.jpeg',
  'Procesador de alto rendimiento con 6 núcleos, 12 hilos y gráficos integrados.',
  10,
  'componente',
  'cpu',
  '{"Plataforma": "Computadora de escritorio", "Familia de productos": "AMD Ryzen™ Processors", "Línea de productos": "AMD Ryzen™ 5 Desktop Processors", "n de núcleos de CPU": 6, "n de hilos": 12, "Reloj de aumento máx.": "Hasta 4.2GHz", "Reloj base": "3.6GHz", "Caché L1 total": "384KB", "Caché L2 total": "3MB", "Caché L3 total": "16MB", "TDP/TDP predeterminado": "65W", "Processor Technology for CPU Cores": "TSMC 7nm FinFET", "Desbloqueados": "Sí", "CPU Socket": "AM4", "Número de sockets": "1P"}'
);

-- 4    AMD Ryzen 5 5600X 3.7GHz
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
  174.91,
  'AMD Ryzen 5 5600X 3.7GHz',
  '/imagenes/componentes/cpu/AMD Ryzen 5 5600X 3.7GHz.webp',
  'Procesador de alto rendimiento con 6 núcleos, 12 hilos y gráficos integrados.',
  10,
  'componente',
  'cpu',
  '{
  "n de núcleos de CPU":"6",
  "n de hilos": "12",
  "Reloj base": "3.7GHz",
  "Reloj de aumento máx":"Hasta 4.6GHz",
  "Caché L2 total":"3MB",
  "Caché L3 total":"32MB",
  "Desbloqueados":"Sí",
  "CMOS":"TSMC 7nm FinFET",
  "Package":"AM4",
  "Versión de PCI Express":"PCIe 4.0",
  "Solución térmica (PIB)":"Wraith Stealth",
  "TDP/TDP predeterminado":"65W",
  "Velocidad máxima de memoria":"Up to 3200MHz",
  "Tipo de memoria":"DDR4",
  "Funcionalidades principales":"Tecnologías compatibles Tecnología AMD StoreMI",
  "Utilidad AMD Ryzen™ Master": "AMD Ryzen™ VR-Ready Premium"
  }'
);

-- 5    AMD Ryzen 7 5800X 3.8GHz
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
  244.99,
  'AMD Ryzen 7 5800X 3.8GHz',
  '/imagenes/componentes/cpu/AMD Ryzen 7 5800X 3.8GHz.webp',
  'Procesador de alto rendimiento con 8 núcleos, 16 hilos y gráficos integrados.',
  10,
  'componente',
  'cpu',
  '{"n de núcleos de CPU": "8",
  "n de hilos": "16",
  "Reloj base": "3.8GHz",
  "Reloj de aumento máx": "Hasta 4.7GHz",
  "Caché L2 total": "4MB",
  "Caché L3 total": "32MB",
  "Desbloqueados": "Sí",
  "CMOS": "TSMC 7nm FinFET",
  "Package": "AM4",
  "Versión de PCI Express": "PCIe 4.0",
  "Solución térmica (PIB)": "No incluida",
  "TDP/TDP predeterminado": "105W",
  "Velocidad máxima de memoria": "Up to 3200MHz",
  "Tipo de memoria": "DDR4",
  "Funcionalidades principales":"Utilidad AMD Ryzen™ Master"}'
);

-- 6    Intel Core i5-13600KF 3.5 GHz Box
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
  321.99,
  'Intel Core i5-13600KF 3.5 GHz Box',
  '/imagenes/componentes/cpu/Intel Core i5-13600KF 3.5 GHz Box.webp',
  'Con un mayor número de núcleos, estos procesadores continúan utilizando la arquitectura híbrida de rendimiento de Intel para optimizar tus videojuegos, creación de contenido y productividad. Aprovecha el mejor ancho de banda de la industria de hasta 16 carriles PCIe 5.03 y memoria DDR5 de hasta 5600 MT/s.4 5 Potencia el rendimiento de tu CPU con una poderosa suite de herramientas de ajuste y overclocking.',
  10,
  'componente',
  'cpu',
  '{"Fabricante de procesador": "Intel",
  "Generación del procesador": "Intel® Core™ i5 de 13ma Generación", "Modelo del procesador": "i5-13600KF", "Familia de procesador": "Intel® Core™ i5", "Número de núcleos de procesador": 14, "Socket de procesador": "LGA 1700", "Número de hilos de ejecución": 20, "Modo de procesador operativo": "64 bits", "Núcleos de rendimiento": 6, "Núcleos de eficiencia": 8, "Frecuencia del procesador turbo": "5.1 GHz", "Frecuencia de aceleración de núcleo de rendimiento": "5.1 GHz", "Frecuencia base de núcleo de rendimiento": "3.5 GHz", "Frecuencia de aceleración de núcleo eficiente": "3.9 GHz", "Frecuencia base de núcleo eficiente": "2.6 GHz", "Caché del procesador": "24 MB"}'
);

-- 7     AMD Ryzen 7 5700X 3.4GHz Box sin Ventilador
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
  193.99,
  'AMD Ryzen 7 5700X 3.4GHz Box sin Ventilador',
  '/imagenes/componentes/cpu/AMD Ryzen 7 5700X 3.4GHz Box sin Ventilador.webp',
  'Procesador de alto rendimiento con 8 núcleos, 16 hilos y gráficos integrados.',
  10,
  'componente',
  'cpu',
  '{"Plataforma": "Computadora de escritorio", "Familia de productos": "AMD Ryzen™ Processors", "Línea de productos": "AMD Ryzen™ 7 Desktop Processors", "# de núcleos de CPU": 8, "# de hilos": 16, "Reloj de aumento máx.": "Hasta 4.6GHz", "Reloj base": "3.4GHz", "Caché L1 total": "512KB", "Caché L2 total": "4MB", "Caché L3 total": "32MB", "TDP/TDP predeterminado": "65W", "Processor Technology for CPU Cores": "TSMC 7nm FinFET", "Desbloqueados": "Sí", "CPU Socket": "AM4", "Número de sockets": "1P"}'
  );

  
  -- 8   Intel Core i7-13700KF 3.4 GHz Box
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
  420.80,
  'Intel Core i7-13700KF 3.4 GHz Box',
  '/imagenes/componentes/cpu/Intel Core i7-13700KF 3.4 GHz Box.jpeg',
  'Con un mayor número de núcleos, estos procesadores continúan utilizando la arquitectura híbrida de rendimiento de Intel para optimizar tus videojuegos, creación de contenido y productividad. Aprovecha el mejor ancho de banda de la industria de hasta 16 carriles PCIe 5.03 y memoria DDR5 de hasta 5600 MT/s.4 5 Potencia el rendimiento de tu CPU con una poderosa suite de herramientas de ajuste y overclocking.',
  10,
  'componente',
  'cpu',
  '{"Fabricante de procesador": "Intel", "Generación del procesador": "Intel® Core™ i7 de 13ma Generación", "Modelo del procesador": "i7-13700KF", "Familia de procesador": "Intel® Core™ i7", "Número de núcleos de procesador": 16, "Socket de procesador": "LGA 1700", "Número de hilos de ejecución": 24, "Modo de procesador operativo": "64 bits", "Núcleos de rendimiento": 8, "Núcleos de eficiencia": 8, "Frecuencia del procesador turbo": "5,4 GHz", "Frecuencia de aceleración de núcleo de rendimiento": "5,3 GHz", "Frecuencia base de núcleo de rendimiento": "3,4 GHz", "Frecuencia de aceleración de núcleo eficiente": "4,2 GHz", "Frecuencia base de núcleo eficiente": "2,5 GHz", "Caché del procesador": "30 MB"}'
  );
  
  -- 9    AMD Ryzen 5 5600 3.5GHz Box
  INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (

  149.99,
  'AMD Ryzen 5 5600 3.5GHz Box',
  '/imagenes/componentes/cpu/AMD Ryzen 5 5600 3.5GHz Box.jpeg',
  'Procesador de alto rendimiento con 6 núcleos, 12 hilos y gráficos integrados.',
  10,
  'componente',
  'cpu',
  '{"Plataforma": "Computadora de escritorio", "Familia de productos": "AMD Ryzen™ Processors", "Línea de productos": "AMD Ryzen™ 5 Desktop Processors", "# de núcleos de CPU": 6, "# de hilos": 12, "Reloj de aumento máx.": "Hasta 4.4GHz", "Reloj base": "3.5GHz", "Caché L1 total": "384KB", "Caché L2 total": "3MB", "Caché L3 total": "32MB", "TDP/TDP predeterminado": "65W", "Processor Technology for CPU Cores": "TSMC 7nm FinFET", "Desbloqueados": "Sí *La garantía del producto AMD no cubre los daños ocasionados por overclocking, incluso si esta función se activa mediante hardware o software de AMD. GD-26.", "CPU Socket": "AM4", "Número de sockets": "1P", "Solución térmica (PIB)": "AMD Wraith Stealth"}'
  );

  -- 10    AMD Ryzen 7 7800X3D 4.2 GHz/5 GHz
  INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
  499.98,
  'AMD Ryzen 7 7800X3D 4.2 GHz/5 GHz',
  '/imagenes/componentes/cpu/AMD Ryzen 7 7800X3D 4.2 GHz 5 GHz.jpeg',
  'Procesador de alto rendimiento con 8 núcleos, 16 hilos y gráficos integrados.',
  10,
  'componente',
  'cpu',
  '{"Fabricante de procesador": "AMD", "Modelo del procesador": "7800X3D", "Frecuencia base del procesador": "4,2 GHz", "Familia de procesador": "AMD Ryzen™ 7", "Número de núcleos de procesador": 8, "Socket de procesador": "Zócalo AM5", "Litografía del procesador": "5 nm", "Número de hilos de ejecución": 16, "Frecuencia del procesador turbo": "5 GHz", "Caché del procesador": "96 MB", "Tipo de cache en procesador": "L3", "Potencia de diseño térmico (TDP)": "120 W", "Caja": "Si", "Refrigerador incluido": "No", "Tipos de memoria que admite el procesador": "DDR5-SDRAM", "Velocidad de reloj de memoria que admite el procesador": "3600,5200 MHz"}'
  );

-- 11    Intel Core i9-13900K 3 GHz Box
  INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
  639,
  'Intel Core i9-13900K 3 GHz Box',
  '/imagenes/componentes/cpu/Intel Core i9-13900K 3 GHz Box.jpeg',
  'Con un mayor número de núcleos, estos procesadores continúan utilizando la arquitectura híbrida de rendimiento de Intel para optimizar tus videojuegos, creación de contenido y productividad. Aprovecha el mejor ancho de banda de la industria de hasta 16 carriles PCIe 5.03 y memoria DDR5 de hasta 5600 MT/s.4 5 Potencia el rendimiento de tu CPU con una poderosa suite de herramientas de ajuste y overclocking.',
  10,
  'componente',
  'cpu',
  '{"Fabricante de procesador": "Intel", "Generación del procesador": "Intel® Core™ i9 de 13ma Generación", "Modelo del procesador": "i9-13900K", "Familia de procesador": "Intel® Core™ i9", "Número de núcleos de procesador": 24, "Socket de procesador": "LGA 1700", "Número de hilos de ejecución": 32, "Modo de procesador operativo": "64 bits", "Núcleos de rendimiento": 8, "Núcleos de eficiencia": 16, "Frecuencia del procesador turbo": "5,8 GHz", "Frecuencia de aceleración de núcleo de rendimiento": "5,4 GHz", "Frecuencia base de núcleo de rendimiento": "3 GHz", "Frecuencia de aceleración de núcleo eficiente": "4,3 GHz", "Frecuencia base de núcleo eficiente": "2,2 GHz"}'
  );

-- 12    AMD Ryzen 5 7600X 4.7 GHz Box sin Ventilador
  INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
  241.90,
  'AMD Ryzen 5 7600X 4.7 GHz Box sin Ventilador',
  '/imagenes/componentes/cpu/AMD Ryzen 5 7600X 4.7 GHz Box sin Ventilador.jpeg',
  'Procesador de alto rendimiento con 6 núcleos, 12 hilos y gráficos integrados.',
  10,
  'componente',
  'cpu',
  '{"Fabricante de procesador": "AMD", "Modelo del procesador": "7600X", "Frecuencia base del procesador": "4,7 GHz", "Familia de procesador": "AMD Ryzen™ 5", "Número de núcleos de procesador": 6, "Socket de procesador": "Socket AM5", "Número de hilos de ejecución": 12, "Modo de procesador operativo": "32-bit, 64 bits", "Frecuencia del procesador turbo": "5,3 GHz", "Caché del procesador": "32 MB", "Tipo de cache en procesador": "L3", "Potencia de diseño térmico (TDP)": "105 W", "Caja": "Si", "Memoria interna máxima que admite el procesador": "128 GB", "Velocidad de reloj de memoria que admite el procesador": "5200 MHz"}'
  );





-- **************************MEMORIA RAM *********************




-- 1    Kingston FURY Beast RGB DDR5 5600MHz 32GB 2x16GB CL36

INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
  299.99,
  'Kingston FURY Beast RGB DDR5 5600MHz 32GB 2x16GB CL36',
  '/imagenes/componentes/ram/Kingston FURY Beast RGB DDR5 5600MHz 32GB 2x16GB CL36.webp',
  'Memoria RAM de alto rendimiento con iluminación RGB.',
  10,
  'componente',
  'ram',
  '{"capacidad_memoria": "32 GB (16 GB x2)", "modulo_cantidad": 2, "velocidad_datos": "5600 MT/s", "tipo_modulo": "DIMM", "verificacion_errores": "no ECC", "latencia_cas": "CL36", "forma_factor": "DDR5", "rango": "1R (Rango único)", "pines": 288, "temperatura_funcionamiento": "0 °C a 85 °C", "iluminacion_rgb": "Si", "densidad_dram": "16Gbit", "voltaje_memoria": "1.25v", "profundidad_memoria": "2G", "soporte_XMP": "Si"}'
);

-- 2    G.Skill Trident Z RGB DDR4 3200 PC4-25600 16GB 2x8GB CL16
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
  95.16,
  'G.Skill Trident Z RGB DDR4 3200 PC4-25600 16GB 2x8GB CL16',
  '/imagenes/componentes/ram/G.Skill Trident Z RGB DDR4 3200 PC4-25600 16GB 2x8GB CL16.webp',
  'Memoria RAM de alto rendimiento con iluminación RGB.',
  10,
  'componente',
  'ram',
  '{"Tipo de memoria": "DDR4", "Capacidad": "16GB (2x8GB)", "Multi-Channel": "Kit de doble canal", "Velocidad Probada": "3200 MHz", "Latencia Probada": "16-18-18-38", "Voltaje Probado": "1.35 V", "Dimensiones": "16 x 13.7 x 1.4 cm", "Peso": "186g"}'
);

-- 3    Corsair VENGEANCE DDR5 5600MHz 32GB 2x16GB CL36
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
  128.56,
  'Corsair VENGEANCE DDR5 5600MHz 32GB 2x16GB CL36',
  '/imagenes/componentes/ram/Corsair VENGEANCE DDR5 5600MHz 32GB 2x16GB CL36.webp',
  'Memoria RAM de alto rendimiento con iluminación RGB.',
  10,
  'componente',
  'ram',
  '{"Densidad": "32 GB (2 x 16 GB)", "Velocidad": "DDR5-5600", "Latencia probada": "36-36-36-76", "Voltaje": "1.25 V", "Formato": "DIMM", "PMIC": "OC PMIC", "Control de software": "CORSAIR iCUE", "Esquema de pines": 288, "Intel XMP": "3.0", "Disipador de calor": "Aluminio", "Compatibilidad": "Intel 600 Series"}'
);


-- 4    Kingston FURY Beast RGB DDR4 3200 MHz 16GB 2x8GB CL16
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
  52.99,
  'Kingston FURY Beast RGB DDR4 3200 MHz 16GB 2x8GB CL16',
  '/imagenes/componentes/ram/Kingston FURY Beast RGB DDR4 3200 MHz 16GB 2x8GB CL16.jpeg',
  'El módulo de memoria RAM DDR4 RGB FURY Beast de Kingston ofrece un aumento del rendimiento con unas velocidades fulgurantes y un estilo agresivo único con iluminación RGB.',
  10,
  'componente',
  'ram',
  '{"Capacidad": "16 Go", "Frecuencia(s) memoria": "DDR4 3200 MHz", "Norma JEDEC": "PC4-25600", "Especificación memoria": "Unbuffered", "Número de módulos de memoria": 2, "Capacidad por módulo de memoria": "8 Go", "LED": "Sí", "LED RGB": "Sí", "Refrigeración": "Radiador", "Color radiador": "Negro", "Ventilador suministrado": "No", "CAS Latency": 16, "RAS to CAS Delay": 18, "RAS Precharge Time": 18, "Compatibilidad de tensiones": "1.35 Volt(s)", "Tensión": "1,35 Voltios"}'
);

-- 5    Corsair Vengeance LPX DDR4 3600MHz PC4-28800 32GB 2x16GB CL18
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
  89,
  'Corsair Vengeance LPX DDR4 3600MHz PC4-28800 32GB 2x16GB CL18',
  '/imagenes/componentes/ram/Corsair Vengeance LPX DDR4 3600MHz PC4-28800 32GB 2x16GB CL18.webp',
  'La memoria VENGEANCE LPX está diseñada para overclocking de alto rendimiento. El disipador térmico está hecho de aluminio puro para una disipación de calor más rápida, y el PCB de ocho capas ayuda a controlar el calor y proporciona un margen superior de overclocking superior.',
  10,
  'componente',
  'ram',
  '{"Latencia CAS": 18, "Memoria interna": "32 GB", "Diseño de memoria (módulos x tamaño)": "2 x 16 GB", "Tipo de memoria interna": "DDR4", "Velocidad de memoria del reloj": "3600 MHz", "Forma de factor de memoria": "288-pin DIMM", "Voltaje de memoria": "1.35 V", "Intel® Extreme Memory Profile (XMP)": "Si", "Versión del perfil Intel XMP (Extreme Memory Profile)": "2,0", "Voltaje de SPD": "1.2 V", "Latencia de SPD": 15, "Velocidad de SPD": "2133 MHz"}'
);


-- 6    Team Group Delta White RGB DDR4 3200 PC4-25600 16GB 2x8GB CL16
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
  51.99,
  'Team Group Delta White RGB DDR4 3200 PC4-25600 16GB 2x8GB CL16',
  '/imagenes/componentes/ram/Team Group Delta White RGB DDR4 3200 PC4-25600 16GB 2x8GB CL16.jpeg',
  'La serie de juegos TEAMGROUP T-FORCE lanzó una vez más el nuevo módulo de memoria luminosa: DELTA RGB. ',
  10,
  'componente',
  'ram',
  '{"Ancho": "49 mm", "Profundidad": "146,8 mm", "Altura": "7 mm","Memoria interna": "16 GB", "Tipo de memoria interna": "DDR4", "Velocidad de memoria del reloj": "3200 MHz", "Componente para": "PC/servidor", "Forma de factor de memoria": "288-pin DIMM", "Diseño de memoria (módulos x tamaño)": "2 x 8 GB", "Tipo de memoria con búfer": "Unregistered (unbuffered)", "ECC": "No", "Latencia CAS": 16, "Voltaje de memoria": "1.35 V", "Ancho de banda de memoria (max)": "19,2 GB/s", "Tipo de enfriamiento": "Disipador térmico", "Retroiluminación": "Si", "Color de luz de fondo": "Rojo/Verde/Azul", "Sistema operativo Windows soportado": "Si", "Sistema operativo Linux soportado": "Si"}'
);

-- 7    Crucial SO-DIMM DDR4 3200Mhz PC4-25600 8GB CL22
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
  20.99,
  'Crucial SO-DIMM DDR4 3200Mhz PC4-25600 8GB CL22',
  '/imagenes/componentes/ram/Crucial SO-DIMM DDR4 3200Mhz PC4-25600 8GB CL22.webp',
  'La memoria para portátiles Crucial es una de las formas más rentables y fáciles de mejorar el rendimiento de su sistema.',
  10,
  'componente',
  'ram',
  '{"Latencia CAS": 22, "Memoria interna": "8 GB", "Diseño de memoria (módulos x tamaño)": "1 x 8 GB", "Tipo de memoria interna": "DDR4", "Velocidad de memoria del reloj": "3200 MHz", "Componente para": "Portátil", "Tipo de memoria con búfer": "Unregistered (unbuffered)", "ECC": "No", "Voltaje de memoria": "1.2 V", "Configuración de módulos": "1024M x 64"}'
);

-- 8    Crucial DDR4 2400 PC4-19200 8GB CL17
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
  20.99,
  'Crucial DDR4 2400 PC4-19200 8GB CL17',
  '/imagenes/componentes/ram/Crucial DDR4 2400 PC4-19200 8GB CL17.jpeg',
  'La memoria para portátiles Crucial es una de las formas más rentables y fáciles de mejorar el rendimiento de su sistema.',
  10,
  'componente',
  'ram',
  '{"Memoria interna": "8 GB", "Tipo de memoria interna": "DDR4", "Velocidad de memoria del reloj": "2400 MHz", "Componente para": "PC/servidor", "Forma de factor de memoria": "288-pin DIMM", "Diseño de memoria (módulos x tamaño)": "1 x 8 GB", "Latencia CAS": 17, "Voltaje de memoria": "1.2 V", "ECC": "No", "Configuración de módulos": "1024M x 64", "Memoria sin buffer": "Si", "Clasificación de memoria": 1}'
);

-- 9    Team Group T-Force Delta RGB DDR4 3600MHz PC4-28800 16GB 2x8GB CL18 Negro
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
  56.99,
  'Team Group T-Force Delta RGB DDR4 3600MHz PC4-28800 16GB 2x8GB CL18 Negro',
  '/imagenes/componentes/ram/Team Group T-Force Delta RGB DDR4 3600MHz PC4-28800 16GB 2x8GB CL18 Negro.jpeg',
  'La serie de juegos TEAMGROUP T-FORCE lanzó una vez más el nuevo módulo de memoria luminosa: DELTA RGB. La R en el esparcidor de calor representa la Revolución y también representa un concepto creativo con un espíritu intransigente. ',
  10,
  'componente',
  'ram',
  '{"Latencia CAS": 18, "Memoria interna": "16 GB", "Diseño de memoria (módulos x tamaño)": "2 x 8 GB", "Tipo de memoria interna": "DDR4", "Velocidad de memoria del reloj": "3600 MHz", "Forma de factor de memoria": "288-pin DIMM", "Tipo de memoria con búfer": "Unregistered (unbuffered)", "ECC": "No", "Voltaje de memoria": "1.35 V", "Retroiluminación": "Si", "Color de luz de fondo": "RGB", "Ancho": "147 mm", "Profundidad": "7 mm", "Altura": "49 mm"}'
);

-- 10    Team Group T-Force Vulcan Z DDR4 3200Mhz PC4-25600 16 GB 2x8GB CL16 Gris
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
  44,
  'Team Group T-Force Vulcan Z DDR4 3200Mhz PC4-25600 16 GB 2x8GB CL16 Gris',
  '/imagenes/componentes/ram/Team Group T-Force Vulcan Z DDR4 3200Mhz PC4-25600 16 GB 2x8GB CL16 Gris.jpeg',
  'La memoria gaming Team Group T-Force Vulcan Z DDR4 ha sido rigurosamente probada por el laboratorio T-FORCE. Cada memoria de overclocking se prueba para una compatibilidad y estabilidad completas.',
  10,
  'componente',
  'ram',
  '{"Latencia CAS": "CL16-20-20-40", "Memoria interna": "16 GB", "Diseño de memoria (módulos x tamaño)": "2 x 8 GB", "Velocidad de memoria del reloj": "3200 MHz", "Componente para": "PC/servidor", "Forma de factor de memoria": "288-pin DIMM", "Tipo de memoria con búfer": "Unregistered (unbuffered)", "ECC": "No", "Voltaje de memoria": "1.35 V"}'
);


-- 11    Goodram IRDM Pro DDR4 3600MHz 8GB CL18
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
  44,
  'Goodram IRDM Pro DDR4 3600MHz 8GB CL18',
  '/imagenes/componentes/ram/Goodram IRDM Pro DDR4 3600MHz 8GB CL18.webp',
  'Los módulos de memoria IRDM PRO DDR4 Deep Black están diseñados para jugadores y entusiastas. Es una solución perfecta diseñada para procesadores de "próxima generación", que se estrenó a fines de 2020.',
  10,
  'componente',
  'ram',
  '{"Tipo de memoria con búfer": "Unregistered (unbuffered)", "Latencia CAS": 18, "Memoria interna": "8 GB", "Diseño de memoria (módulos x tamaño)": "1 x 8 GB", "Tipo de memoria interna": "DDR4", "Velocidad de memoria del reloj": "3600 MHz", "Componente para": "PC/servidor", "Forma de factor de memoria": "288-pin DIMM", "Voltaje de memoria": "1.35 V", "Tipo de enfriamiento": "Disipador térmico"}'
);


-- 12    GoodRam IRDM RGB DDR4 3600MHz 16GB 2x8GB CL18
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
  74.51,
  'GoodRam IRDM RGB DDR4 3600MHz 16GB 2x8GB CL18',
  '/imagenes/componentes/ram/GoodRam IRDM RGB DDR4 3600MHz 16GB 2x8GB CL18.jpeg',
  'No dé ninguna oportunidad a sus oponentes y use su computadora a su máximo potencial. Diseñados para jugadores y profesionales, los módulos de memoria IRDM RGB DDR4 con iluminación LED son una garantía de un rendimiento extraordinario y efectos visuales adaptados a la configuración de su computadora.',
  10,
  'componente',
  'ram',
  '{"Iluminación RGB": true, "Tecnología DDR4 de alta velocidad": true, "Capacidad": "16 GB (kit de 2x8GB)", "Frecuencia": "3600 MHz", "DIMM": "DDR4", "Canal dual": true}'
);










-- **************************PSU *********************








-- Corsair RM1200x SHIFT 1200W 80 Plus Gold Modular
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
  249.99,
  'Corsair RM1200x SHIFT 1200W 80 Plus Gold Modular',
  '/imagenes/componentes/psu/Corsair RM1200x SHIFT 1200W 80 Plus Gold Modular.jpeg',
  'Fuente de alimentación de alto rendimiento con eficiencia 80 Plus Gold y totalmente modular.',
  10,
  'componente',
  'psu',
  '{"peso": 2, "conector_atx": 1, "version_atx": "2.53", "potencia_continua": "1200 vatios", "tecnologia_cojinetes_ventilador": "FDB", "tamaño_ventilador": "140 mm", "MTBF_horas": "100.000 horas", "eficiencia_80_plus": "Oro", "tipo_cable": "Tipo 5", "conector_eps12v": 2, "version_eps12v": "2.92", "conector_pcie": 8, "conector_sata": 16}'
);


-- MSI MPG A850G PCIE5 850W 80 Plus Gold Full Modular
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
  139.98,
  'MSI MPG A850G PCIE5 850W 80 Plus Gold Full Modular',
  '/imagenes/componentes/psu/MSI MPG A850G PCIE5 850W 80 Plus Gold Full Modular.jpeg',
  'Fuente de alimentación de alto rendimiento con eficiencia 80 Plus Gold y totalmente modular.',
  10,
  'componente',
  'psu',
  '{"Potencia total": "850 W", "Voltaje de entrada AC": "100 - 240 V", "Frecuencia de entrada AC": "50/60 Hz", "Corrección del factor de potencia tipo (PFC)": "Activo", "Potencia combinada (3,3 V)": "120 W", "Potencia combinada (+12 V)": "850 W", "Potencia combinada (+5 V)": "120 W", "Corriente máxima de salida (+3.3V)": "22 A", "Corriente máxima de salida (+12V)": "25 A", "Corriente máxima de salida (-12V)": "0,3 A", "Eficiencia": "90%", "Funciones de protección de poder": "Sobreintensidad, Sobretensión, Sobrevoltaje, Cortocircuito, Bajo voltaje", "Alimentador de energía para tarjeta madre": "24-pin ATX", "Longitud del cable de alimentación de la placa base": "60 cm", "Número de conectores de energía SATA": "8"}'
);


-- Tempest PSU Fuente de Alimentación 750W
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
  35.99,
  'Tempest PSU Fuente de Alimentación 750W',
  '/imagenes/componentes/psu/Tempest PSU Fuente de Alimentación 750W.jpeg',
  'Tempest una vez más presenta una fuente para conquistar el mercado gaming. Por ello os presentamos la nueva fuente de 750W. Esta nueva versión mejorada hemos querido implementar todas aquellas mejoras a nivel interno que nos solicitaban nuestros usuarios.',
  10,
  'componente',
  'psu',
  '{"Potencia": "750W", "Tipo": "ATX 12V", "Ventilacion": "Ventilador 12 cm", "Cables": "mallados ultraresistentes", "PFC": true, "Dimensiones": "15 x 14 x 8.5 cm", "Ruido": "14 dB", "Conectores": {"24Pins cable": 1, "2PATA": 2, "5SATA": 5, "2*P6+2": 2}, "Longitud cable": "1.2 metros", "CE & RohS": true}'
);


-- Forgeon Bolt PSU 850W 80+ Gold Full Modular Fuente de Alimentación
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
  159.99,
  'Forgeon Bolt PSU 850W 80+ Gold Full Modular Fuente de Alimentación',
  '/imagenes/componentes/psu/Forgeon Bolt PSU 850W 80+ Gold Full Modular Fuente de Alimentación.jpeg',
  'Forgeon Bolt PSU 850W 80+ Gold Full Modular Dispone de todos los conectores necesarios para montar cualquier PC de sobremesa. Los cables modulares facilitan el montaje, ya que solo tendrás que conectar los que tu equipo necesite.',
  10,
  'componente',
  'psu',
  '{"MODELO": "BOLT 850W",
  "Dimensiones": "150mm x 86mm x 160mm",
  "Formato": "ATX",
  "Peso": "2,7Kg",
  "Puertos e interfaces": "Alimentador de energía para placa base",
  "Conector de energía EPS (8-pin)": "Longitud 700mm (x2)",
  "Conectores de energía PCI Express (6 + 2 pin)": "Longitud 550mm+150mm (x4)",
  "Conectores de energía SATA": "Longitud 550mm + 150mm por conector (x9)",
  "Conectores de Energía (4 pin) periferales (Molex)": "Longitud 550mm + 150mm por conector (x3)",
  "Conector adicional FDD": "Longitud 150mm"}'
);


-- Nfortec Scutum X 650W 80 Plus Bronze Semi Modular
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
  59.96,
  'Nfortec Scutum X 650W 80 Plus Bronze Semi Modular',
  '/imagenes/componentes/psu/Nfortec Scutum X 650W 80 Plus Bronze Semi Modular.jpg',
  'La nueva Nfortec Scutum X llega para estar a la altura de los requisitos de las nuevas generaciones de ordenadores, con la capacidad de mantener su rendimiento al 100% con una eficiencia energética de más del 85%. ',
  10,
  'componente',
  'psu',
  '{"Modelo": "SCUTUM X 650W", "Dimensiones": "153mm x 81mm x 160mm", "Formato": "ATX", "Peso": "1,45Kg", "Puertos e interfaces": {"Alimentador de energía para placa base": "20+4 pin ATX, Longitud 550mm", "Conector de energía EPS (8-pin)": "Longitud 680mm", "Conectores de energía PCI Express (6 + 2 pin)": "2, Longitud 500mm", "Conectores de energía SATA": "5, Longitud 450mm", "Conectores de Energía (4 pin) periferales (Molex)": "2, Longitud 450mm", "Conector adicional S4P (FLOPPY)": "Incluido"}, "Tipo de Cableado": "Semi modular", "Potencia total": "650 W", "Voltaje de entrada AC": "200 - 240 V", "Frecuencia de entrada AC": "47-63 Hz", "Corriente de entrada": "5 A"}'
);


-- Nox Urano VX 650W 80+ Bronze 120MM PWM
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
  48.99,
  'Nox Urano VX 650W 80+ Bronze 120MM PWM',
  '/imagenes/componentes/psu/Nox Urano VX 650W 80+ Bronze 120MM PWM.jpeg',
  'Nuestras exitosas fuentes Urano evolucionan por dentro y por fuera. Nuevas líneas y nuevo aspecto para contener la evolución de una fuente que mejora rendimiento, prestaciones y ofrece multitud de posibilidades para profesionales y entusiastas.',
  10,
  'componente',
  'psu',
  '{"Alimentador de energía para tarjeta madre": "20+4 pin ATX", "Conectores de poder (4 pin) periferales (Molex)": 2, "Número de conectores de energía SATA": 6, "Longitud del cable de alimentación SATA": "600,750,900 mm", "Longitud del cable de alimentación periférico (Molex)": "600,750 mm", "Longitud del cable de la unidad de disquete": "90 cm", "1x ATX MB 20+4 pines": "", "1x EPS +12V 4+4 pines": "", "1x PCIE 6+2 pines, 60cm": "", "1x PCIE 6+2 pines, 75cm": "", "2x SATA, 60cm": "", "2x SATA, 75cm": "", "2x SATA, 90cm": "", "1x Molex 4 pines, 60cm": "", "1x Molex 4 pines, 75cm": "", "1x FDD, 90cm": "", "Ancho": "150 mm", "Profundidad": "140 mm", "Altura": "85 mm", "Peso": "1,42 kg"}'
);


-- Corsair RMx Series RM1000x 1000W 80 Plus Gold Modular
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
  189.99,
  'Corsair RMx Series RM1000x 1000W 80 Plus Gold Modular',
  '/imagenes/componentes/psu/Corsair RMx Series RM1000x 1000W 80 Plus Gold Modular.jpeg',
  'Las fuentes de alimentación completamente modulares CORSAIR RM850x Series con conectores EPS12V se fabrican con componentes de la máxima calidad para proporcionar una potencia eficiente 80 PLUS Gold a su PC, con un funcionamiento prácticamente silencioso.',
  10,
  'componente',
  'psu',
  '{"Carril ajustable de 12V simple / múltiple": "No", "Conector ATX": 1, "Versión ATX12V": "v2.4", "Temperatura nominal de salida continua C": "50 °C", "Potencia continua W": "1000 vatios", "Tecnología de cojinetes de ventilador": "Cojinete de levitación magnética", "Tamaño del ventilador mm": 135, "Horas MTBF": "100.000 horas", "Listo para múltiples GPU": "sí", "Eficiencia 80 PLUS": "Diez años", "Factor de forma de la fuente de alimentación": "Certificado 80 PLUS Gold", "Modo de cero RPM": "No", "Tipo de cable": "Cables negros con mangas y planos", "iCUE Compatible": "No", "Dimensiones": "150 mm x 86 mm x 180 mm", "Conector EPS12V": 3}'
);


-- Tempest PSU X 850W 80+ Bronce Modular Fuente de Alimentación
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
  79.99,
  'Tempest PSU X 850W 80+ Bronce Modular Fuente de Alimentación',
  '/imagenes/componentes/psu/Tempest PSU X 850W 80+ Bronce Modular Fuente de Alimentación.jpeg',
  'Tempest nunca deja de sorprender y es que nos trae dentro de su gama de productos la nueva fuente de alimentación Gaming PSU X 850W.',
  10,
  'componente',
  'psu',
  '{"Rango de voltaje AC I / P": "200-240Vac con PFC activo", "Voltaje DC O / p": "+ 12V, + 5V, + 3.3V, -12V, + 5VSB", "Tecnología Always ON": "+ 5vsb / Max 3A", "Rango de temperatura de funcionamiento": "0 ºC a 40 ºC", "Apfc": "+", "Control de velocidad variable del ventilador": "120 mm para mantener un nivel de ruido bajo", "Protección": "OVP / UVP / SCP / OPP", "Cable planos": "para un perfecto SETUP", "Compatible con": "Intel y AMD", "Admite tarjetas Pci-e Vga": "", "CE / CB / FCC": "", "ROHS": "", "Potencia": "850W 80+ Bronce", "Revestimiento": "negro", "Cable negro de 20 + 4 pines": "550 mm", "2x cable plano negro P4 + 4": "680 mm"}'
);


-- Thermaltake Smart RGB 700W 80 Plus
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
  79.99,
  'Thermaltake Smart RGB 700W 80 Plus',
  '/imagenes/componentes/psu/Thermaltake Smart RGB 700W 80 Plus.jpeg',
  'Thermaltake, el pionero que construyó las luces RGB en las fuentes de alimentación, lanza la gama Smart RGB, que llega con colores RGB en su ventilador, un ventilador de refrigeración ultra silencioso de 120 mm que ofrece un excelente flujo de aire a un nivel de ruido excepcionalmente bajo.',
  10,
  'componente',
  'psu',
  '{"Tipo": "Intel ATX 12V 2.3", "Max. Capacidad de salida": "700W", "Color": "Negro", "Dimensión (H / W / D)": "86 mm x 150 mm x 140 mm", "PFC": "PFC activo", "Señal de buena potencia": "100-500 mseg", "Tiempo de espera": "16msec (mínimo) con un 60% de carga", "Corriente de entrada": "9A max", "Rango de frecuencia de entrada": "50 Hz - 60 Hz", "Voltaje de entrada": "230 Vac", "Temperatura de funcionamiento": "5º a +40º", "Humedad de funcionamiento": "20% a 85%, sin condensación", "Temperatura de almacenamiento": "-40º a +55º", "Humedad de almacenamiento": "10% a 95%, sin condensación", "Sistema de refrigeración": "120mm Ventilador: 1800 R.P.M. ± 10%", "Eficiencia": "82-86% de eficiencia @ 20-100% de carga"}'
);


-- Seasonic Core GC 500 500W 80 Plus Gold
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
  85.99,
  'Seasonic Core GC 500 500W 80 Plus Gold',
  '/imagenes/componentes/psu/Seasonic Core GC 500 500W 80 Plus Gold.jpeg',
  'La serie CORE es la novedad que completa la gama Seasonic. La serie cuenta con 80 PLUS Gold. El control de ventilación inteligente y silenciosa de Seasonic adapta automáticamente la velocidad del ventilador y la refrigeración según la temperatura de la fuente de alimentación. La serie CORE forma parte de TUF Gaming Alliance, por lo que es el dispositivo perfecto para cualquier PC de gaming.',
  10,
  'componente',
  'psu',
  '{"Potencia total":"500 W",
"Voltaje de entrada AC":"100 - 240 V",
"Frecuencia de entrada AC":"50/60 Hz",
"Potencia combinada (3,3 V)":"100 W",
"Potencia combinada (+12 V)":"492 W",
"Potencia combinada (+5 V)":"100 W",
"Potencia combinada (-12V)":"3,6 W",
"Potencia combinada (+5 VSB)":"15 W",
"Corriente máxima de salida (+3.3V)":"20 A",
"Corriente máxima de salida (+12V)":"41 A",
"Corriente máxima de salida (+5V)":"20 A",
"Corriente máxima de salida (-12V)":"0,3 A",
"Corriente máxima de salida (+5Vsb)":"3 A",
"Funciones de protección de poder":"Sobreintensidad, Sobretensión, Sobrevoltaje, Sobrecalentamiento, Cortocircuito, Bajo voltaje",
"Alimentador de energía para tarjeta madre":"20+4 pin ATX"}'
);



-- EVGA GQ 750W 80 Plus Gold Modular
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
  128.99,
  'EVGA GQ 750W 80 Plus Gold Modular',
  '/imagenes/componentes/psu/EVGA GQ 750W 80 Plus Gold Modular.jpeg',
  'Presentándoles el valor definitivo en la alineación de Fuentes de Alimentación EVGA; la serie GQ. Estas fuentes de alimentación tienen algunas de las mejores características de la galardonada línea de fuentes de EVGA, como por ejemplo el modo de EVGA ECO ventilador para un funcionamiento casi silencioso, condensadores japoneses, y un diseño altamente eficiente, a un excelente precio. Estas nuevas fuentes de alimentación tienen clasificación 80 Plus Gold y ofrecen una destacada garantía de 5 años que esta respaldado por el apoyo EVGA clase mundial.',
  10,
  'componente',
  'psu',
  '{"Calificación energética 80 Plus":"Gold",
"Longitud de cables ATX":"1 x 600mm",
"Longitud de cables EPS":"2 x 650mm",
"Longitud de cables PCIE":"2 x 650/750mm 2 x 650mm",
"Longitud de cables SATA":"3 x 550mm/650mm/750mm",
"Longitud de cables 4pin periféricos":"1 x 550",
"Longitud de cables Adaptador Floppy":"1 x 100mm",
"Longitud de cables Cable AC":"1 x 1530mm",
"Cables Modulares":"Sí",
"Cantidad de cables 24 Pin":"1",
"Cantidad de cables 8 pines (4+4) EPS (CPU)":"2",
"Cantidad de cables 8 pin (6+2) PCIE":"6",
"Cantidad de cables SATA":"9",
"Cantidad de cables 4 pines periféricos":"3",
"Cantidad de cables Floppy":"2",
"Rail +3.3V/+5V/+12V/5Vsb/-12V":"24A/62.4A/3A/0.5A",
"Máxima salida":"24A/62.4A/3A/0.5A",
"Potencia":"6W/15W/120W/748.8W",
"Total Potencia":"750W @ +50C",
"Temperatura de operación":"0º a 50ºC",
"Capacitores Japoneses":"100%",
"Modo eco":"Sí",
"MTBK":"100000 Horas",
"Dimensiones":"85 x 150 x 165mm",
"Ventilador":"135mm"}'
);




-- Corsair RM750x SHIFT 750W 80 Plus Gold Modular
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
  168.90,
  'Corsair RM750x SHIFT 750W 80 Plus Gold Modular',
  '/imagenes/componentes/psu/Corsair RM750x SHIFT 750W 80 Plus Gold Modular.jpeg',
  'Las fuentes de alimentación totalmente modulares de la serie RMx SHIFT de CORSAIR cuentan con una revolucionaria interfaz de cableado lateral (pendiente de patente) que mantiene todas sus conexiones al alcance de la mano y ofrece una alimentación excepcionalmente cómoda con eficiencia 80 PLUS Gold.',
  10,
  'componente',
  'psu',
  '{"Peso":"1.6",
"Conector ATX":"1",
"Versión ATX12V":"2.53",
"Potencia continua W":"750 vatios",
"Tecnología de cojinetes de ventilador":"FDB",
"Tamaño del ventilador mm":"140 mm",
"MTBF horas":"100.000 horas",
"80 Plus Eficiencia":"Oro",
"Tipo de cable":"Tipo 5",
"Conector EPS12V":"2",
"Versión EPS12V":"2.92",
"Conector PCIe":"3",
"Conector SATA":"12"}'
);


























-- ALMACENAMIENTOOOOOOOOOOOOOOOOOO







-- 1    Samsung 870 QVO SSD 2TB SATA 3
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
132.99,
'Samsung 870 QVO SSD 2TB SATA 3',
'/imagenes/componentes/almacenamiento/Samsung 870 QVO SSD 2TB SATA 3.jpeg',
'El 870 QVO es lo último de la segunda generación de Samsung. El SSD QLC es el tipo de SSD de mayor capacidad, ya que proporciona hasta 8 TB de almacenamiento. Este disco, ofrece opciones increíbles para los usuarios que quieren aumentar la memoria de su PC o portátil hasta el máximo disponible en el mercado, y sin comprometer el rendimiento.',
10,
'componente',
'almacenamiento',
'{
"Algoritmos de seguridad soportados":"256-bit AES",
"Factor de forma de disco SSD":"2.5",
"capacidad":"2000 GB",
"Interfaz":"Serial ATA III",
"Tipo de memoria":"V-NAND MLC",
"Encriptación de hardware":"Si",
"Velocidad de transferencia de datos":"6 Gbit/s",
"Velocidad de lectura":"560 MB/s",
"Velocidad de escritura":"530 MB/s",
"Lectura aleatoria (4KB)":"98000 IOPS",
"Escritura aleatoria (4KB)":"88000 IOPS",
"Soporte S.M.A.R.T.":"Si",
"Soporte TRIM":"Si",
"Tiempo medio entre fallos":"1500000 h",
"Voltaje de operación":"5 V",
"Consumo de energía (max)":"4 W",
"Consumo de energía (promedio)":"2,2W",
"Intervalo de temperatura operativa":"0 - 70 °C",
"Golpes en funcionamiento":"1500",
"Ancho":"69,8 mm",
"Profundidad":"100 mm",
"Altura":"6,8 mm",
"Peso":"46 g"
}'
);



-- 2    Nfortec Alcyon 256GB SSD M.2
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
39,
'Nfortec Alcyon 256GB SSD M.2',
'/imagenes/componentes/almacenamiento/Nfortec Alcyon 256GB SSD M.2.webp',
'Nfortec Alcyon SSD ofrece un rendimiento excelente para los amantes del hardware, la tecnología y los videojuegos que estén pensando en montar su nuevo PC gaming. Nfortec Alcyon SSD está disponible en capacidades de 256 y 512 GB y está a la altura de los mejores SSD del mercado actual de componentes.',
10,
'componente',
'almacenamiento',
'{
"modelo":"alcyon m.2 sataiii ssd 256gb",
"factor de forma":"m.2 2280",
"tamaño":"80mm x 22mm x 2mm",
"peso":"5.7g",
"interfaz de conexión":"serial ata interface of 6.0gbps",
"temperatura operativa":"0°c to 70°c",
"velocidad de lectura":"550mb/s",
"velocidad de escritura":"500mb/s",
"random read":"(4k) qd=32 (max) 94000 iops",
"random write":"(4k) qd=32 (max) 76800 iops",
"capacidad sin formato":"238,47gb",
"fiabilidad (mtbf)":"1.500.000 hours",
"fiabilidad (tbw)":"128tb"
}'
);




-- 3     Kioxia Exceria G2 Unidad SSD 1TB NVMe M.2 2280
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
54.38,
'Kioxia Exceria G2 Unidad SSD 1TB NVMe M.2 2280',
'/imagenes/componentes/almacenamiento/Kioxia Exceria G2 Unidad SSD 1TB NVMe M.2 2280.webp',
'La nueva segunda generación de la serie de unidades SDD EXCERIA G2 de KIOXIA lleva el rendimiento al siguiente nivel con hasta 2100 MB/s de velocidad de lectura secuencial(1), permitiendo un arranque, una transferencia de archivos y una capacidad de respuesta del sistema más rápidos. Aprovechando la memoria Flash 3D BiCS FLASH™, esta serie de unidades SSD actualizada para uso convencional ahora ofrece hasta 2 TB de capacidad en un diseño M.2 2280 adecuado para ordenadores de sobremesa y portátiles.',
10,
'componente',
'almacenamiento',
'{
"Capacidad":"1 TB",
"Diseño":"M.2 tipo 2280-S2-M",
"Interfaz":"PCI Express® Revisión de la especificación básica 3.1a (PCIe®)",
"Tipo de memoria":"flash BiCS FLASH™ TLC",
"Velocidad máxima de la interfaz":"32 GT/s (PCIe® Gen3 x4)",
"Tamaño (máx: lar. x an. x al.)":"80,15 x 22,15 x 2,23 mm",
"Peso":"1 TB: 6,8 g (típicamente)",
"Rendimiento Velocidad máxima de lectura secuencial":"2100 MB/s",
"Velocidad máxima de escritura secuencial":"1700 MB/s",
"Velocidad máxima de lectura aleatoria":"1 TB 400 000 IOPS",
"Velocidad máxima de escritura aleatoria":"400 000 IOPS",
"Resistencia: TBW":"400 TB",
"MTTF":"1,5 millones de horas",
"Temperatura de funcionamiento":"0 °C (Ta) a 85 °C (Tc)",
"Temperatura de almacenamiento":"-40 °C a 85 °C",
"Resistencia a los golpes":"9806 km/s2 {1,000 G} 0,5 ms media onda sinusoidal",
"Tensión de suministro":"3.3 V ±5 %",
"PS3":"50 mW (típicamente)",
"PS4":"5 mW (típicamente)",
"Consumo de energía (activo) 1 TB":"3.5 W (típicamente)"
}'
);



-- 4     Kingston NV2 2TB SSD PCIe 4.0 NVMe Gen 4x4
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
54.38,
'Kingston NV2 2TB SSD PCIe 4.0 NVMe Gen 4x4',
'/imagenes/componentes/almacenamiento/Kingston NV2 2TB SSD PCIe 4.0 NVMe Gen 4x4.webp',
'El disco SSD NVMe PCIe 4.0 NV2 es una solución de almacenamiento de nueva generación mejorada basada en un controlador NVME Gen 4x4. NV2 alcanza velocidades de lectura/escritura de hasta 3.500/2.800 MB/s1, con menor consumo eléctrico y generando menos calor, con lo cual optimiza el rendimiento de su sistema y mejora su valor sin sacrificar nada. El compacto diseño de M.2 2280 de una cara (22 x 80 mm) amplía el almacenamiento hasta los 2 TB2, además de ahorrar espacio para otros componentes. Por ello, el NV2 es ideal para portátiles más delgados, sistemas de pequeño factor de forma (SFF) y placas base para integradores de sistemas.',
10,
'componente',
'almacenamiento',
'{
"Factor de forma":"M.2 2280",
"Interfaz PCIe":"4.0 x4 NVMe",
"Capacidad":"2 TB",
"Lectura/escritura secuencial":"2 TB – 3.500/2.800 MB/s",
"Resistencia (Total de bytes escritos)":"2 TB – 640 TB",
"Temperatura de almacenamiento":"-40 °C ~ 85 °C",
"Temperatura de servicio":"0 °C ~ 70 °C",
"Dimensiones":"22 mm x 80 mm x 2,2 mm",
"Peso":"7g (todas las capacidades)",
"Vibraciones en servicio":"2,17 G (7-800 Hz)",
"Vibraciones en reposo":"20 G (20-1000 Hz)",
"MTBF":"1.500.000 horas"
}'
);






-- 5     Kingston A400 SSD 480GB
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
25.99,
'Kingston A400 SSD 480GB',
'/imagenes/componentes/almacenamiento/Kingston A400 SSD 480GB.jpeg',
'La unidad A400 de estado sólido de Kingston ofrece enormes mejoras en la velocidad de respuesta, sin actualizaciones adicionales del hardware. Brinda lapsos de arranque, carga y de transferencia de archivos increíblemente más breves en comparación con las unidades de disco duro mecánico.',
10,
'componente',
'almacenamiento',
'{ 
"Ancho":"100 mm",
"Profundidad":"69,9 mm",
"Altura":"7 mm",
"Peso":"41 g",
"Consumo de energía (lectura)":"0,642 W",
"Consumo de energía (escritura)":"1,535 W",
"Consumo de energía (espera)":"0,195 W",
"Consumo de energía (promedio)":"0,279 W",
"Intervalo de temperatura operativa":"0 - 70 °C",
"Intervalo de temperatura de almacenaje":"-40 - 85 °C",
"Vibración operativa":"2.17 G",
"Vibración no operativa":"20 G",
"Sistema operativo Windows soportado":"Si",
"Sistema operativo MAC soportado":"Si",
"Sistema operativo Linux soportado":"Si",
"Factor de forma de disco SSD":"2.5",
"Color del producto":"Negro",
"capacidad":"480 GB",
"Interfaces de disco de estado sólido":"Serial ATA III",
"Velocidad de lectura":"500 MB/s",
"Velocidad de escritura":"450 MB/s",
"Componente para":"PC/ordenador portátil",
"Compatible con NVM Express (NVMe)":"No",
"Velocidad de transferencia de datos":"6 Gbit/s",
"Tipo de memoria":"TLC",
"Tipo de controlador":"2Ch",
"calificación TBW":"160"
}'
);



-- 6     Seagate BarraCuda 3.5" 2TB SATA 3
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
50.99,
'Seagate BarraCuda 3.5" 2TB SATA 3',
'/imagenes/componentes/almacenamiento/Seagate BarraCuda 3.5_ 2TB SATA 3.jpeg',
'Impresionante versatilidad. Fiabilidad inigualable. Seagate incorpora más de 20 años de rendimiento y fiabilidad dignos de confianza a las unidades de disco duro Seagate® BarraCuda® de 3,5 pulgadas. ahora disponibles en diferentes capacidades.',
10,
'componente',
'almacenamiento',
'{ 
"Ancho":"101,6 mm",
"Altura":"20,2 mm",
"Profundidad":"147 mm",
"Peso":"415 g",
"Voltaje de operación":"5 / 12 V",
"Corriente de arranque":"2 A",
"Tamaño del HDD":"3.5",
"Capacidad del HDD":"2000 GB",
"Velocidad de rotación del HDD":"7200 RPM",
"Interfaz":"Serial ATA III",
"Tipo":"Unidad de disco duro",
"Componente para":"PC",
"Storage drive buffer size":"256 MB",
"Número de cabezales en el HDD":"2",
"Promedio de latencia":"6 ms",
"Tecnología inteligente":"Si",
"Tiempo para unidad preparada":"8 s",
"Bytes por sector":"4096",
"Ciclo comenzar/detener":"600000",
"Acorde RoHS":"Si"
}'
);


-- 7     Seagate Ironwolf NAS 3.5" 4TB SATA 3
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
95.99,
'Seagate Ironwolf NAS 3.5" 4TB SATA 3',
'/imagenes/componentes/almacenamiento/Seagate Ironwolf NAS 3.5_ 4TB SATA 3.png',
'Tanto si eres un usuario doméstico como un profesional creativo, para la oficina o el hogar, el disco duro NAS IronWolf de 4 TBde Seagate es la solución de almacenamiento que necesitas. Es un AgileArray optimizado para soluciones NAS y adecuado para el uso de 1 a 8 bahías NAS.',
10,
'componente',
'almacenamiento',
'{ 
"Ancho":"101.8 mm",
"Altura":"20.2 mm",
"Profundidad":"147 mm",
"Peso":"490 g",
"Tamaño del HDD":"3.5",
"Capacidad del HDD":"4000 GB",
"Velocidad de rotación del HDD":"5400 RPM",
"Interfaz":"Serial ATA III",
"Tipo":"Unidad de disco duro",
"Componente para":"NAS",
"Tamaño de unidad de almacenamiento de búfer":"256 MB",
"Velocidad de transferencia Interfaz del HDD":"6 Gbit/s",
"Velocidad de transferencia de impulso sostenido del HDD":"202 MiB/s",
"Funcionamiento 24/7":"Si",
"Ciclo comenzar/detener":"600000",
"Límite de tasa de carga de trabajo":"180 TB/año",
"Tiempo medio hasta fallo (MTTF)":"1000000 h",
"Consumo energético":"4.8 W",
"Consumo de energía (inactivo)":"0.5 W",
"Consumo de energía (espera)":"3.96 W",
"Voltaje de operación":"5 / 12 V",
"Corriente de arranque":"1.8 A"
}'
);


-- 8     Samsung T7 Disco Duro SSD PCIe NVMe USB 3.2 1TB Azul
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
92,
'Samsung T7 Disco Duro SSD PCIe NVMe USB 3.2 1TB Azul',
'/imagenes/componentes/almacenamiento/Samsung T7 Disco Duro SSD PCIe NVMe USB 3.2 1TB Azul.jpeg',
'Ligero, pequeño y portátil: el SSD portátil T7 te permite estar seguro de que estás seguro. Incluso los archivos de gran tamaño se transfieren de forma increíblemente rápida y bien protegida durante mucho tiempo. Ya sea profesional o doméstico, la T7 te ofrece un rendimiento fiable para el uso diario. Con la T7 puedes transferir grandes archivos en segundos con USB 3. 2. generación. Con la tecnología PCIe NVMe integrada, las velocidades de transferencia secuenciales de hasta 1 050 MB/s de lectura y hasta 1. 000 MB/s de escritura. El T7 es casi el doble de rápido que el modelo T5.',
10,
'componente',
'almacenamiento',
'{ 
"Ancho":"85 mm",
"Profundidad":"8 mm",
"Altura":"57 mm",
"Peso":"58 g",
"capacidad":"1000 GB",
"NVMe":"Si",
"Velocidad de lectura":"1050 MB/s",
"Velocidad de escritura":"1000 MB/s",
"Material de la carcasa":"Aluminio",
"Color del producto":"Azul",
"Protección mediante contraseña":"Si",
"Encriptación de hardware":"Si",
"Algoritmos de seguridad soportados":"256-bit AES",
"Sistema operativo Windows soportado":"Si",
"Sistema operativo MAC soportado":"Si"
}'
);




-- 9     WD Red 4TB 3.5" SATA3
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
87.99,
'WD Red 4TB 3.5" SATA3',
'/imagenes/componentes/almacenamiento/WD Red 4TB 3.5_ SATA3.jpeg',
'Hay un disco WD Red para cada sistema NAS compatible, que te ayudará a cubrir tus necesidades de almacenamiento de datos. Con discos de hasta 14TB, WD Red ofrece una amplia gama de soluciones para los clientes que quieren crear una solución de almacenamiento NAS de alto rendimiento.',
10,
'componente',
'almacenamiento',
'{ 
"Tamaño del HDD": "3.5", "Capacidad del HDD": "4000 GB", "Velocidad de rotación del HDD": "5400 RPM", "Interfaz": "Serial ATA III", "Tipo": "Unidad de disco duro", "Componente para": "NAS", "Hot-swap": "No", "Tamaño de unidad de almacenamiento de búfer": "256 MB", "Velocidad de transferencia Interfaz del HDD": "6 Gbit/s", "Velocidad de transferencia de impulso sostenido del HDD": "180 MiB/s", "Consumo de energía (inactivo)": "0,4 W", "Consumo de energía (lectura)": "4,8 W", "Consumo de energía (escritura)": "4,8 W", "Consumo de energía (espera)": "3,1 W", "Voltaje de operación": "5 / 12 V", "Corriente de arranque": "1,75 A", "Ancho": "101,6 mm", "Altura": "26,1 mm", "Profundidad" : "147 mm", "Peso": "570 g"
}'
);



-- 10     WD Blue SN570 SSD 500GB M.2 NVMe
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
30,
'WD Blue SN570 SSD 500GB M.2 NVMe',
'/imagenes/componentes/almacenamiento/WD Blue SN570 SSD 500GB M.2 NVMe.jpeg',
'Permanezca en el momento y cree más allá de sus expectativas con el SSD WD Blue SN570 NVMe. Esta potente unidad interna ofrece hasta 5 veces la velocidad de nuestras mejores SSD SATA para que pueda dejar volar su imaginación y preocuparse menos por los retrasos o los tiempos de carga de la PC.',
10,
'componente',
'almacenamiento',
'{ 
"Versión NVMe": "1.4", "Factor de forma de disco SSD": "M.2", "SDD, capacidad": "500 GB", "Interfaz": "PCI Express 3.0", "NVMe" : "Si", "Componente para": "PC", "Encriptación de hardware": "No", "Velocidad de lectura": "3500 MB/s", "Velocidad de escritura": "2300 MB/s", "Carriles datos de interfaz PCI Express": "x4", "calificación TBW": "300", "Ancho": "22 mm", "Profundidad": "80 mm", "Altura": "2,38 mm" 
}'
);



-- 11     Crucial MX500 SSD 500GB SATA
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
39.99,
'Crucial MX500 SSD 500GB SATA',
'/imagenes/componentes/almacenamiento/Crucial MX500 SSD 500GB SATA.jpeg',
'Cada vez que enciende su ordenador, está utilizando su disco de almacenamiento. Conserva todos sus archivos irremplazables y carga y guarda casi todo lo que haga su sistema. Únase a un grupo cada vez mayor de personas que conservan sus vídeos familiares, fotos de viajes, música y documentos importantes en un SSD, y obtenga el rendimiento casi instantáneo y la fiabilidad duradera que brinda el almacenamiento de estado sólido.',
10,
'componente',
'almacenamiento',
'{ 
"Factor de forma": "SSD interno de 2,5 pulgadas", "Capacidad total": "500GB", "Garantía": "limitada de 5 años", "Especificaciones": "SATA 6.0Gb/s • 560 MB/s de lectura, 510 MB/s de escritura", "Serie": "MX500", "Línea de producto": "SSD del cliente", "Interfaz": "SATA 6.0 Gb/s", "calificación TBW" : "300", "Ancho": "22 mm", "Profundidad": "80 mm", "Altura": "2,38 mm"
}'
);




-- 12     Toshiba Canvio Basics 2.5" 4TB USB 3.0
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
98.99,
'Toshiba Canvio Basics 2.5" 4TB USB 3.0',
'/imagenes/componentes/almacenamiento/Toshiba Canvio Basics 2.5_ 4TB USB 3.0.jpeg',
'Si tienes problemas de espacio, los discos duros externos son la solución a todos ellos. Olvídate de la falta de espacio con un disco duro externo Toshiba Canvio Basics de 4TB y continúa almacenando todos tus documentos sin preocuparte por el espacio. Si estás buscando un disco duro externo, el modelo Toshiba Canvio Basics es perfecto para ti. Su diseño elegante y discreto en color negro combina con cualquier escenario, y al ser mate resiste bien a las marcas de dedos y no te molestará con destellos.',
10,
'componente',
'almacenamiento',
'{ 
"Tamaño del HDD":"2.5",
"Capacidad del HDD":"4000 GB",
"Tipo":"Unidad de disco duro",
"Sistema de formato de archivo":"NTFS",
"Rango máximo de transferencia de datos":"5000 Mbit/s",
"Conector USB":"Micro-USB B",
"Versión USB":"3.0 (3.1 Gen 1)",
"Tecnología Thunderbolt (Rayo)":"No",
"Wifi":"No",
"Tasa de transferencia de datos USB":"5000 Mbit/s",
"Ancho":"78 mm",
"Profundidad":"109 mm",
"Altura":"19,5 mm",
"Peso":"217.5 g",
"Color del producto":"Negro"
}'
);









-- ORDENADOOOOREEEEEESSSSSSSSS  >>>>>>  POOORTTAAATIIILEEESSS







-- 1     MSI Thin GF63 12UDX-042XES Intel Core i5-12450H/16GB/512GB SSD/RTX 3050/15.6
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
749,
'MSI Thin GF63 12UDX-042XES Intel Core i5-12450H/16GB/512GB SSD/RTX 3050/15.6',
'/imagenes/ordenador/portatil/MSI Thin GF63 12UDX-042XES Intel Core i5-12450H 16GB 512GB SSD RTX 3050 15.6.jpeg',
'El Thin GF63 impulsa las demandas multitarea diarias con hasta el último procesador Intel® Core™ de 12.ª generación y los nuevos gráficos Intel® Arc™ A370M. Disfruta de cautivadores juegos, diseño y experiencia de transmisión.',
10,
'ordenador',
'portatil',
'{
"Procesador":"Alder Lake i5-12450H",
"Memoria RAM":"DDR IV 8GB2 (3200MHz)",
"Almacenamiento":"512GB NVMe PCIe SSD Gen4x4 w/o DRAM",
"Unidad óptica":"No dispone",
"Pantalla":"15.6 FHD (19201080) 144Hz 45%NTSC IPS-Level",
"Controlador gráfico":"RTX 3050 6GB, GDDR6 6GB",
"Conectividad":"Gigabit Ethernet / Intel® Wi-Fi 6 AX201 / Bluetooth v5.2","Webcam":"HD type (30fps@720p)","Micrófono":"Sí","Batería":"3-Cell, Li-Polymer, 51Whr","Teclado":"Red Backlit Gaming Keyboard","Conexiones":"1 x USB 3.2 Gen1 Type-C / DP 3 x USB 3.2 Gen1 Type-A x HDMI™ (4K@30Hz), 1 x USB 3.2 Gen1 Type-C / DP","Sistema operativo":"FreeDOS (SIN SISTEMA OPERATIVO)","Dimensiones (Ancho x Profundidad x Altura)":"359 (W) x 254 (D) x 21.7 (H) mm","Peso":"1,86 kg","Color":"Negro"
}'
);




-- 2      Lenovo V15 G2 ITL Intel Core i5-1135G7 8 GB 512 GB SSD 15.6
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
749,
'Lenovo V15 G2 ITL Intel Core i5-1135G7/8 GB/512 GB SSD/15.6',
'/imagenes/ordenador/portatil/Lenovo V15 G2 ITL Intel Core i5-1135G7 8 GB 512 GB SSD 15.6.jpeg',
'Diseñado para el lugar de trabajo moderno, el portátil Lenovo V15 de 2.ª generación (15.6" Intel) es el compañero de trabajo perfecto. Adecuado para la productividad móvil, ofrece un gran rendimiento tanto en la oficina como en casa. Windows 11, los procesadores opcionales de Intel® y la tarjeta gráfica independiente de NVIDIA®, además de las excelentes opciones de seguridad, memoria y almacenamiento, te facilitan el día a día.',
10,
'ordenador',
'portatil',
'{
"procesador": "Intel Core i5-1135G7",
"memoria_ram": "8GB DDR4 3200MHz",
"almacenamiento": " SSD de 512GB NVMe PCIe Gen3.0x4",
"pantalla": "15.6 pulgadas Full HD (1920x1080)",
"tarjeta_grafica": " integrada  Intel® Iris® Xe funcionando como UHD Graphics",
"unidad_optica":"No dispone",
"webcam":" HD 720p con obturador de privacidad",
"seguridad":"Módulo de plataforma segura (TPM) 2.0 (firmware)",
"bateria":"Integrada 38Wh",
"teclado":"Estándar de tamaño completo con teclado numérico y panel táctil de una sola pieza",
"sistema_operativo":"Windows 11 Pro 64 bits",
"dimensiones":"359.2 x 235.8 x 19.9 mm",
"peso":"1.7kg",
"color":"negro"
}'
);



-- 3      MSI Katana GF66 12UC-082XES Intel Core i7-12700H 16GB 1TB SSD RTX3050 15.6
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
899,
'MSI Katana GF66 12UC-082XES Intel Core i7-12700H/16GB/1TB SSD/RTX3050/15.6',
'/imagenes/ordenador/portatil/MSI Katana GF66 12UC-082XES Intel Core i7-12700H 16GB 1TB SSD RTX3050 15.6.jpeg',
'Procesador Intel® Core™ i7-12700H de hasta 12.ª generación. Los gráficos GeForce® liberan el máximo rendimiento para portátiles. Listo para crear el contenido de Metaverse. *Solo compatible con el procesador Intel® Core™ i7 con GPU para laptop GeForce RTX™ 3070 y superior. Refrigeración exclusiva Cooler Boost 5 con 2 ventiladores dedicados 6 tubos de calor de cobre (para 12UGS / 12UG / 12UE) 2 ventiladores 4 tubos de calor de cobre (para 12UD / 12UC). La SSD PCIe Gen 4 impulsa efectivamente el trabajo diario al ofrecer una velocidad de almacenamiento de siguiente nivel.',
10,
'ordenador',
'portatil',
'{
"Procesador":"Alder Lake i7-12700H (45W)",
"Memoria":"DDR IV 8GB2 (3200MHz)",
"Almacenamiento":"1TB NVMe PCIe SSD Gen4x4 w/o DRAM",
"Pantalla":"15.6 FHD (19201080) 144Hz 45%NTSC IPS-Level",
"Controlador gráfico":"RTX3050 GDDR6 4GB (60W)",
"Conectividad":"Gigabit Ethernet / Intel® Wi-Fi 6 AX201 / Bluetooth v5.2","Cámara de portátil":"HD type (30fps@720p)","Micrófono":"Sí","Batería":"3-Cell, Li-Polymer, 53.5Whr","Conexiones":"1 x USB3.2 Gen1 Type-C / 2 x USB3.2 Gen1 Type-A / 1 x USB2.0 Type-A / 1x HDMI (4K@60Hz)","Sistema operativo":"SIN SISTEMA OPERATIVO","Dimensiones":"359 (W) x 259 (D) x 24.9 (H) mm","Peso":"2.25 Kg","Color":"Negro"
}'
);


-- 4     PcCom Revolt 3060 Intel Core i7-12700H 32GB 500GB SSD RTX 3060 15.6
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
1516.99,
'PcCom Revolt 3060 Intel Core i7-12700H/32GB/500GB SSD/RTX 3060/15.6',
'/imagenes/ordenador/portatil/PcCom Revolt 3060 Intel Core i7-12700H 32GB 500GB SSD RTX 3060 15.6.jpeg',
'Haz tu vida más fácil con el nuevo portátil PcCom Revolt 3060, con procesador Intel® de 12ª generación, listo para finalizar con éxito los trabajos más arduos o ser el más jugón en tus tardes libres. Disfruta de la tecnología NVIDIA RTX 3060 con gráficos más realistas e inmersivos, así como de una pantalla de alta resolución. Además, mejora la experiencia de uso gracias al uso del control center habilitado para descarga.',
10,
'ordenador',
'portatil',
'{
"Procesador": "Intel Core i7-12700H",
"Memoria RAM": "32GB (2x16GB) RAM SO-DIMM DDR4 2400 MHz",
"Memoria RAM ampliable hasta": "64 GB (Máximo 32GB por slot)",
"Almacenamiento": "500 GB SSD M.2 PCIe NVMe Gen3 x4",
"Controlador gráfico": "NVIDIA RTX 3060 6GB GDDR6",
"Máximo TGP Soportado": "115W",
"Pantalla": "6” 144Hz FHD IPS antirreflejante. 72%NTSC",
"Teclado": "Membrana Single Zone RGB",
"Audio": "2x 2W. Compatible con Sound Blaster Cinema 6+",
"Micrófono": "Sí",
"Cámara integrada": "Sí",
"Batería": "Batería 4 celdas (4s1p 4100mAh) 62.32wh",
"Sistema operativo": "Sin sistema operativo",
"Control Center": "Disponible para descarga",
"Conectividad": "Red 10/100/1000/2500 Mb/sec Integrada / Wi-fi 6 AX201 / 11 a/b/g/n/ac/ax / Bluetooth 5.0",
"Conexiones": "2 USB A 3.1 Lado Derecho / 1 USB A 3.1 Lado Izquierdo / 1 USB C 3.1 Trasero / 1 HDMI1 / RJ45 / Conector Auriculares/Micro",
"Conector de seguridad": "Kensington",
"Dimensiones Producto (A x A x F)": "244,22 x 359,37 x 27,35 mm",
"Dimensiones Embalaje (A x A x F)": "125 x 444 x 330 mm",
"Peso Bruto / Neto (Kg)": "4,2 / 2,1 Kg",
"Color": "Negro"
}'
);



-- 5     MSI Vector GP77 13VG-021XES Intel Core i7-13700H 32GB 1TB SSD RTX 4070 17.3
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
1999,
'MSI Vector GP77 13VG-021XES Intel Core i7-13700H/32GB/1TB SSD/RTX 4070/17.3',
'/imagenes/ordenador/portatil/MSI Vector GP77 13VG-021XES Intel Core i7-13700H 32GB 1TB SSD RTX 4070 17.3.jpeg',
'La serie Vector GP utiliza el "Vector" como punto de partida, formando una estructura estereoscópica de 2ª y 3ª dimensión y extendiéndose a la existencia desconocida. ¡El Vector GP77 13V es definitivamente el pionero en el campo de la ciencia!',
10,
'ordenador',
'portatil',
'{
"Procesador": "Raptor Lake i7-13700H",
"Memoria RAM": "DDR5 16GB2 (5200MHz)",
"Almacenamiento": "1TB NVMe PCIe Gen4x4 SSD",
"Unidad óptica": "No",
"Pantalla": "17.3 QHD (25601440), 240Hz DCI-P3 100% typical",
"Controlador gráfico": "RTX 4070, GDDR6 8GB",
"Conectividad": "Intel® Wi-Fi 6E AX211+ BT 5.3 + Gb LAN (Up to 2.5G)",
"Webcam": "HD type (30fps@720p)",
"Micrófono": "Sí",
"Teclado": "Per key RGB steelseries KB + num",
"Batería": "4 cell, 65Whr",
"Conexiones": "1x Type-C (USB3.2 Gen2 / DP) with PD charging / 3x Type-A USB3.2 Gen1 / 1x (8K @ 60Hz / 4K @ 120Hz) HDMI™ / 1x Mini-DisplayPort / 1x RJ45",
"Sistema operativo": "SIN SISTEMA OPERATIVO",
"Dimensiones (Ancho x Profundidad x Altura)": "397 (W) x 284 (D) x 25.9 (H) mm",
"Peso": "2.9 kg",
"Color": "Negro"
}'
);




-- 6      HP 15S-fq2159ns Intel Core i3-1115G4 8GB 256GB SSD 15.6
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
699,
'HP 15S-fq2159ns Intel Core i3-1115G4/8GB/256GB SSD/15.6',
'/imagenes/ordenador/portatil/HP 15S-fq2159ns Intel Core i3-1115G4 8GB 256GB SSD 15.6.jpeg',
'Haz más cosas desde donde quieras. Todo el día. Permanece conectado a lo que más te importa gracias a una batería de larga duración y a un diseño ligero y fino con bisel con microborde. El ordenador portátil HP de 15,6 pulgadas, diseñado para mantener la productividad y estar entretenido en cualquier parte, ofrece un rendimiento fiable y una amplia pantalla que te permiten hacer streaming, navegar y completar tareas con rapidez. ',
10,
'ordenador',
'portatil',
'{
"Dimensiones (Ancho x Profundidad x Altura)": "35,85 x 24,2 x 1,79 cm",
"Peso": "1,69 kg",
"Color": "Plata natural",
"Procesador": "Intel® Core™ i3-1115G4 (hasta 4,1 GHz con tecnología Intel® Turbo Boost, 6 MB de caché L3, 2 núcleos, 4 subprocesos)",
"Memoria": "RAM DDR4-3200 MHz 8 GB (2 x 4 GB)",
"Almacenamiento": "SSD de 256 GB PCIe® NVMe™ M.2",
"Unidad óptica": "No",
"Display": "15,6 (39,6 cm) en diagonal, bisel micro-edge, antirreflectante, 250 nits, 45 % NTSC, FHD (1920 x 1080)",
"Controlador gráfico Integrado": "Intel® UHD",
"Conectividad": "Combo Realtek RTL8822CE 802.11a/b/g/n/ac (2x2) Wi-Fi® y Bluetooth® 5",
"Webcam": "HP True Vision 720p HD con micrófonos digitales de matriz dual integrados",
"Audio": "Altavoces dobles",
"Teclado": "Tamaño completo de color blanco nieve y con teclado numérico",
"Touchpad": "HP Imagepad compatible con función gestual multitáctil; Compatible con panel táctil de precisión",
"Batería": "Ion-litio de 3 celdas 41 Wh",
"Conexiones": "1 x USB 3.2 Gen1 Type-C® con velocidad de señal de 5 Gbps / 2 x USB 3.2 Gen1 de tipo A con velocidad de señal de 5 Gbps / 1 x HDMI 1.4b / 1 x Combinación de auriculares/micrófono jack 3.5 mm / Lector de tarjetas SD multiformato HP"
}'
);




-- 7      Medion Akoya E15415 Intel Core i5-10210U 8GB 256GB SSD 15.6
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
329,
'Medion Akoya E15415 Intel Core i5-10210U/8GB/256GB SSD/15.6',
'/imagenes/ordenador/portatil/Medion Akoya E15415 Intel Core i5-10210U 8GB 256GB SSD 15.6.jpeg',
'El procesador Intel® Core™ i5-10210U de la décima generación de CPU de Intel le ofrece el máximo rendimiento para software y juegos. Aprovéchate del gran rendimiento de este procesador superior y disfrute de una gran potencia, independientemente de si desea navegar por Internet, transmitir música y videos 4K o experimentar los últimos videojuegos en calidad de alta resolución',
10,
'ordenador',
'portatil',
'{
"Procesador": "Intel® Core™ i5-10210U",
"Memoria RAM": "8 GB DDR4",
"Almacenamiento": "256 GB SSD",
"Unidad óptica": "No",
"Pantalla": "15.6 (39.6 cm) Full HD (1920 x 1080 píxeles) con tecnología IPS",
"Controlador gráfico": "Intel UHD",
"Conectividad": "Intel® Wi-Fi AC-9462 con función Bluetooth® 5.1 integrada",
"Webcam": "Webcam de 1MP y micrófono dual - array integrados",
"Batería": "3 celdas polímeros de litio",
"Conexiones": "1 x Lector tarjeta SD / 1 x USB 3.2 Gen 1 Tipo C – soporte salida DisplayPort™ y función de carga / 2 x USB 3.2 Gen 1 Tipo A / 1 x USB 2.0 Tipo A / 1 x HDMI - Out / 1 x Audio Combo / 1 x DC-in",
"Sistema operativo": "SIN SISTEMA OPERATIVO",
"Dimensiones (Ancho x Profundidad x Altura)": "35.9 x 2.26 x 24 cm",
"Peso": "1,78 kg",
"Color": "Plata"
}'
);



-- 8      ASUS VivoBook 15 F515JA-EJ2882W Intel Core i7-1065G7 8GB 512GB SSD 15.6
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
329,
'ASUS VivoBook 15 F515JA-EJ2882W Intel Core i7-1065G7/8GB/512GB SSD/15.6',
'/imagenes/ordenador/portatil/ASUS VivoBook 15 F515JA-EJ2882W Intel Core i7-1065G7 8GB 512GB SSD 15.6.jpeg',
'El ASUS VivoBook 15 es un compacto portátil que pronuncia la sensación de inmersión cuando trabajas o te relajas con tus contenidos favoritos. Rodeada de marcos de 5,7 mm y con una relación pantalla-cuerpo del 88 %, la nueva pantalla NanoEdge ofrece un nivel de inmersión visual espectacular. La bisagra ErgoLift inclina el teclado para escribir cómodamente.',
10,
'ordenador',
'portatil',
'{
"Procesador": "Intel® Core™ i7-1065G7 (4 Núcleos, Caché: 8 MB SmartCache, 1.3 GHz hasta 3.9 GHz, 64-bit)",
"Memoria RAM": "8 GB (4GB + 4GB [EN PLACA]) DDR4 3200 MHz; Ampliable hasta 12 GB (1 x SO-DIMM)",
"Almacenamiento": "512 GB SSD M.2 NVMe™ PCIe® 3.0",
"Unidad óptica": "No dispone",
"Display": "15.6 (39,62 cm) LED Retroiluminado IPS / 60 Hz / NanoEdge (Borde Estrecho) / 220 nits / FHD (1920x1080/16:9) / Antirreflejos / NTSC: 45%",
"Controlador gráfico Integrado": "Intel® Iris™ Plus Graphics",
"Conectividad": "Wi-Fi 5 (802.11ac) 1x1 / Bluetooth® 4.1",
"Cámara de portátil": "VGA (640x480)",
"Altavoces": "Estéreo Integrados",
"Micrófono": "Integrado compatible con reconocimiento de voz del Asistente Cortana",
"Batería": "37Wh, 2 Celdas, Polímeros de Litio (no reemplazable)",
"Conexiones": "2 x USB 2.0 / 1 x USB 3.2 Gen1 / 1 x USB-C 3.2 Gen1 / 1 x Conector de Audio Combinado Auriculares/Micrófono 3,5 mm / 1 x HDMI 1.4",
"Sistema operativo": "Windows 11 Home 64 Bits",
"Dimensiones (Ancho x Profundidad x Altura)": "360,2 x 234,9 x 19,9 mm",
"Peso": "1,8 Kg",
"Color": "Slate Grey"
}'
);




-- 9      HP Victus 16-e0101ns AMD Ryzen 7 5800H 16GB 512GB SSD RTX 3060 16.1
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
329,
'HP Victus 16-e0101ns AMD Ryzen 7 5800H/16GB/512GB SSD/RTX 3060/16.1',
'/imagenes/ordenador/portatil/HP Victus 16-e0101ns AMD Ryzen 7 5800H 16GB 512GB SSD RTX 3060 16.1.jpeg',
'Gracias a un procesador AMD, el portátil Victus by HP de 16,1 pulgadas cuenta con todas las características que necesitas para jugar y utilizarlo en tu día a día. Consigue más flexibilidad al jugar con un teclado para videojuegos polivalente y disfruta de una pantalla con frecuencia de actualización y sin tearing. Supera el acaloramiento de cada partida gracias a un sistema de refrigeración que evita el sobrecalentamiento. Gana experiencia de juego más allá de tu hardware con OMEN Gaming Hub.',
10,
'ordenador',
'portatil',
'{
"Procesador": "AMD Ryzen™ 7 5800H (aumento máximo del reloj de hasta 4,4 GHz, 16 MB de caché L3, 8 núcleos, 16 subprocesos)",
"Memoria RAM": "16 GB DDR4-3200 MHz (2 x 8 GB)",
"Almacenamiento": "512 GB SSD PCIe® NVMe™ TLC M.2",
"Unidad óptica": "No",
"Pantalla": "40,9 cm (16,1) en diagonal, FHD (1920 x 1080), 144 Hz, IPS, microborde, antirreflectante, 250 nits, 45 % NTSC",
"Controlador gráfico": "GPU de portátil NVIDIA® GeForce RTX™ 3060 (GDDR6 de 6 GB dedicada)",
"Conectividad": "LAN 10/100/1000 GbE integrada / Combo Realtek Wi-Fi 6 (2x2) y Bluetooth® 5.2 (soporta velocidad de datos Gigabit) / Compatible con MU-MIMO / Compatible con Miracast",
"Audio": "de B&O Altavoces duales; HP Audio Boost",
"Teclado": "Tamaño completo, con retroiluminación, de color plata mica y teclado numérico",
"Touchpad": "HP Imagepad compatible con función gestual multitáctil Compatible con panel táctil de precisión",
"Batería": "Polímero de ion-litio 4 celdas, 70 Wh",
"Sistema operativo": "FreeDOS (SIN SISTEMA OPERATIVO)",
"Dimensiones (Ancho x Profundidad x Altura)": "37 x 26 x 2,35 cm",
"Peso": "2.46 kg",
"Color": "Plata mica logotipo cromado oscuro"
}'
);
      


-- 10     HP Pavilion 15-eh1004ns AMD Ryzen 5 5500U 16GB 512GB SSD 15.6
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
575,
'HP Pavilion 15-eh1004ns AMD Ryzen 5 5500U/16GB/512GB SSD/15.6',
'/imagenes/ordenador/portatil/HP Pavilion 15-eh1004ns AMD Ryzen 5 5500U 16GB 512GB SSD 15.6.jpeg',
'Tecnología a tu servicio en el trabajo. Máximo disfrute en el juego. El portátil HP Pavilion de 15,6 pulgadas ofrece más rendimiento en un perfil más reducido, para que cumplas tus metas sin importar dónde te encuentres. Disfruta de un entretenimiento sin igual gracias a la pantalla con microborde y al audio de B&O.',
10,
'ordenador',
'portatil',
'{
"Procesador": "AMD Ryzen™ 5 5500U (aumento máximo del reloj hasta 4 GHz, 8 MB de caché L3, 6 núcleos, 12 subprocesos)",
"Memoria RAM": "DDR4-3200 MHz 16 GB (2 x 8 GB)",
"Almacenamiento": "512GB SSD PCIe® NVMe™ M.2",
"Unidad óptica": "No",
"Display": "15.6 (39,6 cm) en diagonal, IPS, bisel micro-edge, antirreflectante, 250 nits, 45 % NTSC, FHD (1920 x 1080)",
"Controlador gráfico Integrada": "AMD Radeon™",
"Conectividad": "Combo MediaTek Wi-Fi CERTIFIED 6™ (2x2) y Bluetooth® 5.2 (soporta velocidad de datos Gigabit) / Compatible con Miracast / Compatible con MU-MIMO",
"Webcam": "HP Wide Vision 720p HD con micrófonos digitales de matriz dual integrados",
"Audio": "de B&O Altavoces duales HP Audio Boost",
"Teclado": "Teclado de tamaño completo, con retroiluminación, de color azul cielo y teclado numérico",
"Touchpad": "HP Imagepad compatible con función gestual multitáctil; Compatible con panel táctil de precisión",
"Batería": "Ion-litio de 3 celdas 41 Wh",
"Conexiones": "1 SuperSpeed USB Type-C® con velocidad de señal de 10 Gbps (suministro de energía por USB / DisplayPort™ 1.4 / HP Sleep and Charge) / 2 SuperSpeed USB Type-A con velocidad de señal de 5 Gbps / 1 HDMI 2.0 / 1 pin inteligente de CA; / 1 toma combinada de auriculares/micrófono",
"Sistema operativo": "Windows 11 Home 64 Bits",
"Dimensiones (Ancho x Profundidad x Altura)": "36,02 x 23,4 x 1,79 cm",
"Peso": "1,75 kg",
"Color": "Cubierta de aluminio en azul niebla base en azul nube y marco del teclado de aluminio en azul nube"
}'
);



-- 11     Acer Aspire 3 A315-59-504M Intel Core i5-1235U 16GB 512GB SSD 15.6
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
739,
'Acer Aspire 3 A315-59-504M Intel Core i5-1235U/16GB/512GB SSD/15.6',
'/imagenes/ordenador/portatil/Acer Aspire 3 A315-59-504M Intel Core i5-1235U 16GB 512GB SSD 15.6.jpeg',
'Ya estés en casa, en clase o en el trabajo, consigue todo el rendimiento que necesitas con los procesadores Intel más recientes, que mantienen el orden y logran que tus aplicaciones funcionen de forma constante y sin problemas.',
10,
'ordenador',
'portatil',
'{
"Procesador": "Intel® Core™ i5-1235U 1,30 GHz",
"Memoria RAM": "16 GB DDR4",
"Almacenamiento": "512 GB SSD M.2 PCIe NVMe",
"Unidad óptica": "No",
"Pantalla": "15.6 IPS ComfyView FHD (1920 x 1080)",
"Controlador gráfico": "Iris Xe Graphics",
"Conectividad": "WiFi 802.11ac + Bluetooth 5.0",
"Webcam": "HD 720p con 2 micrófonos",
"Audio": "Altavoces estéreo",
"Batería": "3 Celdas Ion de litio",
"Conexiones": "3 x USB 3.2 / 1 x HDMI / 1 x Combo de audio jack 3.5 mm",
"Sistema operativo": "SIN SISTEMA OPERATIVO",
"Dimensiones (Ancho x Profundidad x Altura)": "362,9 mm x 241,3 mm x 19,90 mm",
"Peso": "1.78 kg",
"Color": "Plata"
}'
);



-- 12    ASUS Chromebook CX1500CNA-EJ0100 Intel Celeron N3350 8GB 64GB eMMC 15.6
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
249.98,
'ASUS Chromebook CX1500CNA-EJ0100 Intel Celeron N3350/8GB/64GB eMMC/15.6',
'/imagenes/ordenador/portatil/ASUS Chromebook CX1500CNA-EJ0100 Intel Celeron N3350 8GB 64GB eMMC 15.6.jpeg',
'El ASUS Chromebook CX11 está diseñado para ayudarte a ser productivo y divertirte, durante todo el día y dondequiera que estés. Este portátil cuenta con una CPU Intel® de cuatro núcleos y conectividad Wi-Fi 6 superrápida de doble banda, así como una excelente portabilidad y una autonomía hasta de 11 horas.',
10,
'ordenador',
'portatil',
'{
"Procesador": "Intel Celeron N3350 (2C/DualCore 1.1GHz, 2MB)",
"Memoria RAM": "8GB SO-DIMM LPDDR4x",
"Almacenamiento": "64GB eMMC",
"Unidad óptica": "No",
"Display": "15.6 Full HD 1920 x 1080 pixeles LCD 220 nits",
"Controlador gráfico": "Intel UHD Graphics 500",
"Conectividad": "Wi-Fi 5(802.11ac)+BT4.2(Dual band) 2*2",
"Cámara de portátil": "HD (720p)",
"Micrófono": "Sí",
"Batería": "38 WHrs 2S1P 2 celdas de iones de litio",
"Teclado": "Teclado tipo chicle",
"Conexiones": "2 x USB 3.2 de 1.ª generación tipo A / 2 x USB 3.2 de 1.ª generación tipo C / 1 x Conector de audio combinado de 3,5 mm",
"Lector de tarjetas": "micro-SD",
"Sistema operativo": "Chrome OS",
"Dimensiones (Ancho x Profundidad x Altura)": "36.13 x 24.99 x 1.89 ~ 1.89 cm US MIL-STD 810H military-grade standard Titan C Security Chip",
"Peso": "1.80 kg",
"Color": "Plata"
}'
);











-- ORDENADOOOOREEEEEESSSSSSSSS  >>>>>>  SSOOOOBBBRRREEEEMMMEEEEESSSSAAAAAA







-- 1      PcCom Bronze AMD Ryzen 7 5700G 16 GB 500GB SSD
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
569,
'PcCom Bronze AMD Ryzen 7 5700G/16 GB/500GB SSD',
'/imagenes/ordenador/desktop/PcCom Bronze AMD Ryzen 7 5700G 16 GB 500GB SSD.jpeg',
'PcCom Bronze con procesador  AMD Ryzen 7 5700G 4.6GHz y tarjeta gráfica Radeon Graphics 1900 Mhz 7 Cores. Memoria RAM de 16GB DDR4 3200MHz y almacenamiento SSD de 500GB M.2 NVMe. Sin Sistena operativo.',
10,
'ordenador',
'desktop',
'{"procesador": " AMD Ryzen 7 5700G 4.6GHz",
"memoria_ram": "16GB DDR4 3200 PC4-25600 2X8GB",
"almacenamiento": "500 GB SSD M.2 NVMe",
"torre": "Tempest Shade RGB ATX",
"tarjeta_grafica": "Radeon Graphics 1900 Mhz 7 Cores",
"unidad_optica":"No dispone",
"placa_base":" Gigabyte B550 AORUS ELITE V2",
"conexiones_delanteras":"USB3.0 x 1 /  USB2.0 x 2 | HD Audio & Mic",
"conexiones_traseras":"1 x DisplayPort / 1 x HDMI / 2 x USB 3.2 Gen 2 Type-A ports (red) / 3 x USB 3.2 Gen 1 ports / 2 x puerto USB 2.0/1.1 / 1 x Q-Flash Plus button / 1 x Puerto RJ-45 / 1 x optical S/PDIF Out connector / 5 x audio jacks",
"sistema_operativo":"Sin sistema operativo",
"dimensiones":"360mm x 181mm x 430mm",
"fuente_alimentacion":"Tempest Gaming 650W",
"color":"negro"}'
);



-- 2     AlurinPC Intel Core i5 10400 16GB 500GB SSD
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
399,
'AlurinPC Intel Core i5 10400/16GB/500GB SSD',
'/imagenes/ordenador/desktop/AlurinPC Intel Core i5 10400 16GB 500GB SSD.jpeg',
'AlurinPC con procesador Intel Core i5 10400 y tarjeta gráfica Gráficos HD Intel® 630. 
Memoria RAM de 16GB 2x8GB DDR4 2666MHz y almacenamiento 500GB SSD NVMe M.2. Sin Sistena operativo.',
10,
'ordenador',
'desktop',
'{"procesador": "Intel Core i5-10400 2,9GHz",
"memoria_ram": "16GB 2x8GB DDR4 2666MHz CL16",
"almacenamiento": " 500GB SSD NVMe M.2 2280",
"torre": "Owlotech Start Case USB 3.0 500W Torre ATX",
"tarjeta_grafica": "Gráficos HD Intel® 630",
"unidad_optica":"No dispone",
"placa_base":"Gigabyte H510M S2H V2",
"conexiones_delanteras":"2x USB 3.0 / 2x USB 2.0 / Lector de Tarjetas / HD Audio",
"conexiones_traseras":"Cantidad de puertos USB 2.0: 4 / Cantidad de puertos tipo A USB 3.2 Gen 1 (3.1 Gen 1): 2 / Ethernet LAN (RJ-45) cantidad de puertos: 1 / Puerto de ratón PS/2: 2 / Número de puertos HDMI: 1 / Versión HDMI: 1.4 / Cantidad de DisplayPorts: 1 / Versión DisplayPort: 1.2 / Cantidad de puertos DVI-D: 1 / Salidas para auriculares: 3",
"grabadora":"No dispone",
"sistema_operativo":"Sin sistema operativo",
"dimensiones":"330 * 180 * 410 mm",
"fuente_alimentacion":"500W",
"color":"negro",
"tarjeta_sonido":"Integrada",
"tarjeta_red":"Integrada"
}'
);






-- 3     Acer Predator Orion 7000 PO7-640 Intel Core i9-12900K 16GB 1TB+1TB SSD RTX 3090
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
3649.01,
'Acer Predator Orion 7000 PO7-640 Intel Core i9-12900K/16GB/1TB+1TB SSD/RTX 3090',
'/imagenes/ordenador/desktop/Acer Predator Orion 7000 PO7-640 Intel Core i9-12900K 16GB 1TB+1TB SSD RTX 3090.jpeg',
'Acer Predator Orion 7000 PO7-640 con un procesador Intel Core i9-12900K con una memoria ram de 16GB y un almacenamiento de 1TB+1TB SSD también con una gráfica RTX 3090',
10,
'ordenador',
'desktop',
'{
"Procesador": "12th Generation Intel® CoreTM i9-12900K processor",
"Memoria RAM": "16 GB (8 GBx2) DDR5 4800 MHz UDIMM Up to 64 GB of Dual-channel DDR5 4000 MHz",
"Disco duro": "1024 GB M.2 2280 PCIe Gen4 SSD + 1 TB 3.5-inch 7200 RPM",
"Controlador gráfico": "NVIDIA® GeForce RTX 3090 with 24 GB of GDDR6X",
"Fuente de alimentación": "800 W PFC 80PLUS# Gold ATX",
"Audio": "DTX X® Ultra",
"Conectividad": "Wi-Fi 6 + Bluetooth® 5",
"Conexiones": "USB Type-CTM port / USB 3.2 Gen 1 port / Headset/Microphone jacks / 2.5” SSD/HDD Hot Swap Bay / Two USB 3.2 Gen 1 ports / Power button / Two USB 3.2 Gen 2 ports / Two USB 2.0 ports/ USB Type-CTM port (USB 3.2 Gen 2X2) / Audio jacks / Power connector / Ethernet (RJ-45) port / USB 3.2 Gen 2 port",
"Slots de expansión": "M.2 slot (for SSD): 2 / M.2 slot (for WLAN): 1 / PCIe x16 slot(s): 2 / PCIe x1 slot(s): 1",
"Sistema operativo": "SIN SISTEMA OPERATIVO",
"Dimensiones (Ancho x Profundidad x Altura)": "219 (W) x 504.8 (D) x 485 (H) mm",
"Color": "Negro"
}'
);



-- 4     Acer Nitro N50 N50-640 Intel Core i7-12700F 16GB 1TB SSD RTX 3060
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
1499.01,
'Acer Nitro N50 N50-640 Intel Core i7-12700F/16GB/1TB SSD/RTX 3060',
'/imagenes/ordenador/desktop/Acer Nitro N50 N50-640 Intel Core i7-12700F 16GB 1TB SSD RTX 3060.jpeg',
'El PC Gaming Nitro 50 de metal en negro intenso es lo único que necesitas para disfrutar de sesiones de Gaming fluidas y con una velocidad de fotogramas alta. Pon todos los ajustes al máximo gracias a los últimos procesadores Intel® Core™ de 12.a generación y las tarjetas gráficas GeForce RTX™ serie 30.',
10,
'ordenador',
'desktop',
'{
"Procesador": "12th Generation Intel® CoreTM i7-12700F 2.1 GHz",
"Memoria RAM": "16 GB (8GB x 2) DDR4 3200 MHz UDIMM Up to 32 GB of Dual-channel DDR4 3200 MHz",
"Disco duro": "1TB M.2 2280 PCIe SSD",
"Almacenamiento óptico": "NO",
"Controlador gráfico": "GeForce® RTX™ 3060 Hasta 12 GB",
"Conectividad": "802.11ax/ac/a/b/g/n, Wi-Fi 6 and Bluetooth® 5",
"Conexiones": "Power button / USB Type-CTM port (USB 3.2 Gen 2X2) / USB 3.2 Gen 2 port / Headset / speaker jack / Microphone jack / 2 x USB 2.0 ports / 2 x USB 3.2 Gen 1 ports / 2 x USB 2.0 ports / Audio jacks / Ethernet (RJ-45) port / Power connector",
"Sistema operativo": "SIN SISTEMA OPERATIVO",
"Dimensiones (Ancho x Altura x Profundidad)": "175 (W) x 386 (D) x 392 (H) mm",
"Fuente de alimentación": "500 W PFC, auto-sensing, 80PLUS# Gold, ATX",
"Audio": "DTS:X® Ultra",
"Color": "Negro"
}'
);



-- 5     PcCom Gold Élite AMD Ryzen 5 5600X 16GB 1TB SSD RX 6700
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
1499,
'PcCom Gold Élite AMD Ryzen 5 5600X/16GB/1TB SSD/RX 6700',
'/imagenes/ordenador/desktop/PcCom Gold Élite AMD Ryzen 5 5600X 16GB 1TB SSD RX 6700.jpeg',
'Prepárate para el futuro con nuestro PcCom Gold, gracias a la nueva gráfica AMD Radeon RX 6700 10GB GDDR6 y el nuevo procesador AMD Ryzen 5 5600x de 6 núcleos y 12 hilos estarás preparado para el gaming más puro, !No es el futuro, es el presente!. Una máquina indomable que te brindará una sensación de potencia descomunal a la hora de jugar. Creada y ensamblada con la mayor precisión y los mejores componentes del momento, el PcCom Gold posee unas condiciones inigualables para el juego, superando ampliamente los requisitos técnicos requeridos por los juegos que actualmente van apareciendo en el mercado.',
10,
'ordenador',
'desktop',
'{
"Torre": "MSI MAG Forge 100M Cristal Templado USB 3.2 RGB Negra",
"Fuente de alimentación": "Corsair CX750M 750 W 80 Plus Bronze Semi-Modular o similar - Según disponibilidad",
"Procesador": "AMD Ryzen 5 5600X 3.7GHz",
"Ventilador": "Cooler Master MasterLiquid ML240L V2 ARGB Kit de Refrigeración Líquida o similar - Según disponibilidad",
"Placa Base": "Gigabyte B550M DS3H o similar - Según disponibilidad",
"Disco duro": "Kioxia Exceria G2 Unidad SSD 1TB NVMe M.2 2280 o similar - Según disponibilidad",
"Memoria": "16GB DDR4 3200 2x8GB CL16",
"Gráfica": "AMD Radeon RX 6700 10GB GDDR6 / DisplayPort 1.4 *3 / HDMI 2.1 *1",
"Conexiones delanteras": "2 x USB 3.2 Gen1 Tipo-A / 1 x audio HD / 1 x micrófono",
"Conexiones traseras": "Cantidad de puertos USB 2.0 4 / Cantidad de puertos tipo A USB 3.2 Gen 1 (3.1 Gen 1) 4",
"Ethernet LAN (RJ-45) cantidad de puertos": 1,
"Puerto de ratón PS/2": 1,
"Número de puertos HDMI": 1,
"Cantidad de puertos DVI-D": 1,
"Salidas para auriculares": 1,
"Micrófono, jack de entrada": "Si",
"Conector USB": "USB tipo A",
"Dimensiones": "421 (D) x 210 (W) x 499 (H) mm"
}'
);




-- 6     PcCom Platinum AMD Ryzen 7 5700X 32GB 1TB SSD RTX 4080 + Windows 11 Home
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
2779,
'PcCom Platinum AMD Ryzen 7 5700X/32GB/1TB SSD/RTX 4080 + Windows 11 Home',
'/imagenes/ordenador/desktop/PcCom Platinum AMD Ryzen 7 5700X 32GB 1TB SSD RTX 4080 + Windows 11 Home.jpeg',
'El nuevo PcCom Gold está equipado con un procesador AMD Ryzen 7 5700X, gráficos impresionantes gracias a su RTX 4080 y 32GB de RAM DDR4 que te ofrecerá toda la potencia necesaria para disfrutar de los últimos juegos Online de más éxito del momento.',
10,
'ordenador',
'desktop',
'{
"Torre": "Nfortec AURIGA ARGB USB 3.0 con Ventana Negra",
"Fuente de alimentación": "Corsair RM850e 850W 80 Plus Gold Modular o similar (Según disponibilidad)",
"Procesador": "AMD Ryzen 7 5700X 3.4GHz",
"Ventilador": "Corsair iCUE H100i ELITE CAPELLIX Kit de Refrigeración Líquida o Similar (Según disponibilidad)",
"Placa Base": "Asus TUF GAMING B550-PLUS o Similar (Según disponibilidad)",
"Discos duros": "Samsung 980 SSD 1TB PCIe 3.0 NVMe M.2 o Similar (Según disponibilidad)",
"Memoria": "32GB DDR4 3600 MHz 2x16 CL18 o similar (Según disponibilidad)",
"Gráfica": "GeForce RTX 4080 16GB GDDR6X / Salida DisplayPort x 3 / HDMI 2.0b x 1",
"Conexiones delanteras": "USB 3.0 x2 / Auricular/Microfono x1 / Encendido/Apagado / Reinicio / LED",
"Conexiones traseras": "1 x DisplayPort / 1 x HDMI / 1 x LAN (2.5G) port(s) / 2 x USB 3.2 Gen 2 (teal blue) (1 x Type-A+1 x USB Type-C®) / 4 x USB 3.2 Gen 1 (blue) Type-A / 2 x USB 2.0 (one port can be switched to USB BIOS FlashBack™) / 1 x Optical S/PDIF out / 5 x Audio jack(s) / 1 x BIOS FlashBack™ Button(s)",
"Dimensiones": "(L x An x Al) 415mm x 220mm x 483mm"
}'
);



-- 7     PcCom Neural Mini Intel Core i5-10210U 8GB 250GB SSD + Windows 11 Home
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
569.12,
'PcCom Neural Mini Intel Core i5-10210U/8GB/250GB SSD + Windows 11 Home',
'/imagenes/ordenador/desktop/PcCom Neural Mini Intel Core i5-10210U 8GB 250GB SSD + Windows 11 Home.jpeg',
'El PcCom Neural Mini I5 equipado con un procesador Intel ® Core ™ I5-10210U junto con 8GB de RAM y un SSD de 250GB le proporcionará un rendimiento imparable. Además, cuenta con el controlador gráfico Intel® UHD Graphics que proporciona una alta calidad de vídeo. Su diseño con cuerpo metálico le otorga un aspecto elegante sin prescindir de sus funcionalidades.',
10,
'ordenador',
'desktop',
'{
"Familia Procesador": "Intel® Core™ de 10ª Generación",
"Modelo Procesador": "Procesador Intel® Core™ I5-10210U",
"Modelo de adaptador gráfico incorporado": "Intel® UHD Graphics",
"Sistema Operativo": "Sí (Microsoft Windows 11 Home)",
"Tipo de memoria interna": "SO-DIMM DDR4",
"Memoria interna máxima": "32GB por Slot",
"Ranuras de memoria": "2x SO-DIMM",
"Memoria RAM incluida": "8GB SO-DIMM DDR4",
"Factor de forma de disco SSD": "M.2 2280",
"Interfaz del SSD": "PCI Express 3.0 NVME/SATA",
"Capacidad máxima de almacenamiento": "2TB",
"Almacenamiento Incluido": "SSD 250GB M.2",
"Wifi": "Si",
"Estándar Wi-Fi": "Wi-Fi 4 (802.11b/g/n)",
"Bluetooth": "Si",
"Versión de Bluetooth": "4.0",
"Número de puertos USB 2.0": "4",
"Número de puertos tipo A USB 3.0": "4",
"Número de puertos tipo C USB 3.1": "1",
"Número de puertos HDMI 1.4": "1",
"Número de puertos DisplayPort 1.2": "1",
"Número de puertos Ethernet LAN (RJ-45)": "2",
"Entrada para micrófono": "1",
"Salidas para auriculares": "1",
"Color": "Negro/Plata",
"Ancho": "150mm",
"Profundidad": "135mm",
"Altura": "50mm",
"Peso Neto": "600g",
"Peso Bruto": "1.15kg"
}'
);



-- 8     MSI MAG Infinite S3 13TC-657XES Intel Core i7-13700F 16GB 1TB SSD RTX 3060
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
1199,
'MSI MAG Infinite S3 13TC-657XES Intel Core i7-13700F/16GB/1TB SSD/RTX 3060',
'/imagenes/ordenador/desktop/MSI MAG Infinite S3 13TC-657XES Intel Core i7-13700F 16GB 1TB SSD RTX 3060.jpeg',
'el MAG Infinite S3 combina el rendimiento con la innovación. Además de un elegante botón de encendido, cuenta con brillantes líneas afiladas en su panel frontal. Las enormes salidas de aire proporcionan una buena ventilación para evitar el sobrecalentamiento, mientras que la iluminación RGB personalizable da vida a tu sistema. El MAG Infinite S3 presenta un diseño único sin comprometer su funcionalidad.',
10,
'ordenador',
'desktop',
'{
"Procesador": "Intel Core i7-13700F 2.1GHz",
"Memoria RAM": "16GB(8GB*2) DDR4 SDRAM",
"Disco duro": "1TB PCIe GEN3x4 w/o DRAM NVMe",
"Almacenamiento óptico": "No",
"Controlador gráfico": "GeForce RTX 3060 VENTUS 2X 8G O",
"Conectividad": "802.11a/b/g/n/ac/ax 2x2+BT / Intel I219-V",
"Conexiones": "1xHeadphones/1xMicrophone. / 1xUSB 3.2 Gen 1 Type C/1xUSB 3.2 Gen 1 Type A. / HDD LED. / Power button. / 1x HDMI out. / 1x VGA (D-sub). / 1x Display Port out. / 2 x USB 2.0 Type A/ 1x PS/2 Combo port. / USB 3.2 Gen 1 Type A. / 2x USB 2.0 Type A/1x RJ45 (1G LAN). / 3x Audio jacks",
"Sistema operativo": "SIN SISTEMA OPERATIVO",
"Fuente de alimentación": "500W ATX 80PLUS BRONZE",
"Chipset": "H610",
"Dimensiones": "173.8 x 446.97 x 407.17",
"Color": "Negro"
}'
);



-- 9     Medion Erazer Recon P20 MD35173 Intel Core i5-11400 16GB 512GB SSD RTX 3060
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
929,
'Medion Erazer Recon P20 MD35173 Intel Core i5-11400/16GB/512GB SSD/RTX 3060',
'/imagenes/ordenador/desktop/Medion Erazer Recon P20 MD35173 Intel Core i5-11400 16GB 512GB SSD RTX 3060.jpeg',
'Un procesador Intel® Core™ de undécima generación convierte a su ordenador en una verdadera máquina gaming. Con fuertes reservas de energía y tecnología punta, el corazón de la CPU da una nueva vida a tus juegos favoritos. Para esto significa un rendimiento de primera clase, transmisión en vivo simultánea y todo lo que tengas en mente. ',
10,
'ordenador',
'desktop',
'{
"Procesador": "Intel® Core™ i5-11400 (2.60-4.40 GHz Single Core Turbo, 12MB Intel® Smart Cache, 6 núcleos, 12 hilos)",
"Memoria RAM": "16 GB DDR4 RAM",
"Disco duro": "512 GB SSD",
"Controlador gráfico": "NVIDIA® GeForce™ RTX 3060 (12 GB GDDR6 VRAM)",
"Conectividad": "Gigabit LAN (10/100/1000 Mbit/s.)",
"Frontales": "2 x USB 3.2 Gen 1 / 1 x Mic-in / 1 x Audio-out",
"Traseras": "2 x USB 2.0 / 2 x USB 3.2 Gen 1 / 1 x USB 3.2 Gen 2 (Tipo C) / 1 x LAN (RJ-45) / 1 x HDMI 2.1 / x DisplayPort 1.4a / 1 x PS/2 / 3 x Audio jacks",
"Sistema operativo": "Windows 11 Home 64 Bits",
"Dimensiones": "483 x 235 x 488 mm",
"Color": "Negro"
}'
);




-- 10     ASUS U500MA-75700G0090 AMD Ryzen 7 570G 16GB 512GB SSD
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
749,
'ASUS U500MA-75700G0090 AMD Ryzen 7 5700G/16GB/512GB SSD',
'/imagenes/ordenador/desktop/ASUS U500MA-75700G0090 AMD Ryzen 7 570G 16GB 512GB SSD.jpeg',
'Trabaja y juega a tu manera.  ASUS U500MA es un PC familiar con mucho estilo que eleva todos los aspectos de la creación de contenidos y la informática diaria. Equipado con un procesador AMD Ryzen™, el U500MA te brinda la productividad que necesitas para alimentar tu pasión creativa. El diseño de almacenamiento doble (hasta un SSD de 1 TB y un HDD de 2 TB) ofrece una combinación ideal de velocidad y capacidad de almacenamiento. Está acabado con un llamativo patrón de mosaico que combina perfectamente en cualquier espacio actual.',
10,
'ordenador',
'desktop',
'{
"Fabricante de procesador": "AMD",
"Modelo del procesador": "5700G",
"Familia de procesador": "AMD Ryzen™ 7",
"Número de núcleos de procesador": 8,
"Frecuencia del procesador turbo": "4,6 GHz",
"Frecuencia del procesador": "3,8 GHz",
"Caché del procesador": "16 MB",
"Memoria interna": "16 GB",
"Memoria interna máxima": "64 GB",
"Tipo de memoria interna": "DDR4-SDRAM",
"Disposición de la memoria": "1 x 16 GB",
"Capacidad total de almacenaje": "512 GB",
"Unidad de almacenamiento": "SSD",
"Tipo de unidad óptica": "No",
"Ethernet": "Si",
"Ethernet LAN, velocidad de transferencia de datos": "10,100,1000 Mbit/s",
"Tecnología de cableado": "10/100/1000Base-T(X)",
"Controlador LAN": "Realtek RTL8111H",
"Wifi": "Si",
"Estándar Wi-Fi": "Wi-Fi 5 (802.11ac)",
"Wi-Fi estándares": "Wi-Fi 5 (802.11ac)",
"Tipo de antena": "2x2",
"Bluetooth": "Si",
"Versión de Bluetooth": "4.2",
"Ancho": "160 mm",
"Profundidad": "294,4 mm",
"Altura": "373,5 mm",
"Peso": "5,59 kg",
"Sistema operativo instalado": "No"
}'
);



-- 11     HP OMEN 40L GT21-0001ns AMD Ryzen 5 5600G 16GB 1TB SSD RTX 3060
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
899.99,
'HP OMEN 40L GT21-0001ns AMD Ryzen 5 5600G/16GB/1TB SSD/RTX 3060',
'/imagenes/ordenador/desktop/HP OMEN 40L GT21-0001ns AMD Ryzen 5 5600G 16GB 1TB SSD RTX 3060.jpeg',
'Potencia para llevar tu juego a otro nivel. El ordenador de sobremesa gaming OMEN by HP 40L es el compañero definitivo para vivir tus partidas más espectaculares. Además de contar con la tecnología del último procesador de AMD y con gráficos avanzados, el ordenador de sobremesa OMEN dispone de un excelente sistema de refrigeración que evita que se sobrecaliente. El diseño del ordenador de sobremesa OMEN permite actualizarlo de forma sencilla y sin herramientas, y su hardware ofrece un rendimiento de máximo nivel que satisfará las necesidades de tus juegos más exigentes.',
10,
'ordenador',
'desktop',
'{
"Fabricante de procesador": "AMD",
"Modelo del procesador": "5600G",
"Familia de procesador": "AMD Ryzen™ 5",
"Memoria interna": "16 GB",
"Tipo de memoria interna": "DDR4-SDRAM",
"Disposición de la memoria": "2 x 8 GB",
"Capacidad total de almacenaje": "1000 GB",
"Unidad de almacenamiento": "SSD",
"Tipo de unidad óptica": "No",
"Adaptador de gráficos discreto": "Si",
"Fabricante de GPU (unidad de procesamiento gráfico) externa": "NVIDIA",
"Modelo de adaptador de gráficos discretos": "NVIDIA GeForce RTX 3060",
"Tipo de memoria de gráficos discretos": "GDDR6",
"Capacidad memoria de adaptador gráfico": "12 GB",
"Adaptador gráfico incorporado": "Si",
"Modelo de adaptador gráfico incorporado": "AMD Radeon Graphics",
"Ethernet": "Si",
"Ethernet LAN, velocidad de transferencia de datos": "10,100,1000 Mbit/s",
"Tecnología de cableado": "10/100/1000Base-T(X)",
"Wifi": "Si",
"Estándar Wi-Fi": "Wi-Fi 6 (802.11ax)",
"Wi-Fi estándares": "Wi-Fi 6 (802.11ax)",
"Fabricante del controlador WLAN": "Realtek",
"Tipo de antena": "2x2",
"Bluetooth": "Si",
"Versión de Bluetooth": "5.2",
"Ancho": "204 mm",
"Profundidad": "470 mm",
"Altura": "467 mm",
"Peso": "18,7 kg"
}'
);



-- 12     PcVIP Hydrus V1 AMD Ryzen 5 5500 16GB 1TB+500GB SSD RTX 3060
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
789.98,
'PcVIP Hydrus V1 AMD Ryzen 5 5500/16GB/1TB+500GB SSD/RTX 3060',
'/imagenes/ordenador/desktop/PcVIP Hydrus V1 AMD Ryzen 5 5500 16GB 1TB+500GB SSD RTX 3060.jpeg',
'Ibericavip presenta el PC Gaming Hydrus, equipado con un procesador AMD Ryzen 5 5500, unos gráficos excelentes gracias a su tarjeta gráfica RTX 3060 GAMING  12GB DDR6 que sumado a sus 16GB RAM DDR4 3200 MHz crean la unión perfecta que te ofrecerá toda la potencia necesaria para disfrutar de los últimos juegos online con más éxito del momento.',
10,
'ordenador',
'desktop',
'{
"Torre": "Danube Kolpa Gaming con cristal templado",
"Fuente de alimentación": "Fuente Gaming GAMING 650W 80+ BRONZE",
"Procesador": "AMD Ryzen 5 5500 3,6 GHz 16 MB",
"Refrigeración": "Cooler de serie",
"Placa Base": "A520M",
"Discos duros": "SSD M.2 500GB PCIE NMVE / 1TB HDD",
"Memoria": "16GB 2x8GB RAM PC 3200 RGB",
"Gráfica": "RTX 3060 GAMING 12GB DDR6",
"Red": "WIFI / ETHERNET",
"Entrada de audio": "Si",
"Salida de audio": "Si",
"Cantidad de puertos tipo A USB 3.2 Gen 1 (3.1 Gen 1)": "2",
"Cantidad de puertos tipo C USB 3.2 Gen 2 (3.1 Gen 2)": "1",
"Conexiones traseras": "4 x USB 2.0/1.1 ports / 1 x HDMI port / 4 x USB 3.2 Gen 1 ports / 2 x USB 3.2 Gen 2*/Gen 1 Type-A ports (red) / * For 3rd Generation AMD Ryzen processors only. / 1 x RJ-45 port / 1 x optical S/PDIF Out connector / 5 x audio jacks",
"Sistema Operativo": "Sin sistema operativo"
}'
);









-- SMARRRRRRTTTTTTTPHONEEEEEE >>> AAAAAAPPPPPPLLLLLEEEEEE





-- 1     Apple iPhone 14 Pro Max 256GB Plata Libre
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
1489,
'Apple iPhone 14 Pro Max 256GB Plata Libre',
'/imagenes/smartphone/apple/Apple iPhone 14 Pro Max 256GB Plata Libre.jpeg',
'iPhone 14 Pro Max 256GB Plata con procesador Apple A16 Bionic y pantalla Super Retina XDR 6,7 pulgadas y cámara trasera de Principal:48MP, Ultra angular:12MP, Teleobjetivo:12MP y cámara frontal 12MP. Memoria RAM de 6 GB LPDDR5X y almacenamiento 256GB. Sistena operativo iOS16.',
10,
'smartphone',
'apple',
'{
"procesador": "Apple A16 Bionic",
"memoria_ram": "6 GB LPDDR5X",
"almacenamiento": "256GB",
"pantalla": "Super Retina XDR 6,7 pulgadas",
"camaras_traseras": "Principal:48MP f/1.78 24mm Sensor Shift de segunda generación / Ultra angular: 12MP, f/2.2, 13mm / Teleobjetivo: 12MP, f/2.8, 77mm, OIS",
"camara_frontal":"12MP f1.9 enfoque automático",
"conectividad":"5G / Wi-fi / Bluetooth / Chip de banda ultraancha / NFC",
"bateria":"4.323 mAh /Carga rápida 20W / Carga inalámbrica 15W",
"tarjeta_sim":"Doble SIM (Nano SIM y eSIM)",
"sensores":"Face ID / Escáner LIDAR / Barómetro / Giroscopio de alto rangon dinámico / Acelerómetro de fuerza g alta / Sensor de proximidad / Doble sensor de luz ambiental",
"sistema_operativo":"iOS 16",
"dimensiones":"160,7 x 77,6 x 7,85 mm",
"peso":"240g",
"color":"plata"
}'
);


-- 2     Apple iPhone 12 128GB Negro Libre
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
799,
'Apple iPhone 12 128GB Negro Libre',
'/imagenes/smartphone/apple/Apple iPhone 12 128GB Negro Libre.jpeg',
'iPhone 14 Pro Max 128GB Negro con procesador Apple A14 Bionic y pantalla OLED Retina,Super Retina XDR 6,1 pulgadas y cámara trasera de Principal:12MP, Secundaria:12MP y cámara frontal 12MP.
Memoria RAM de 6 GB LPDDR4X y almacenamiento 128GB. Sistena operativo iOS14.',
10,
'smartphone',
'apple',
'{"procesador": "Apple A14 Bionic",
"memoria_ram": "6 GB LPDDR4X",
"almacenamiento": "128GB",
"pantalla": "Super Retina XDR 6,1 pulgadas / OLED Retina",
"camaras_traseras":"Principal12MP / Secundaria12MP",
"camara_frontal":"12MP",
"conectividad":"5G / Wi-fi / Bluetooth / Chip de banda ultraancha / NFC",
"bateria":"Carga rápida 18W e inalámbrica MagSafe 15W",
"tarjeta_sim":"Doble SIM (Nano SIM y eSIM)",
"sensores":"Face ID / Escáner LIDAR / Barómetro / Giroscopio de alto rangon dinámico / Acelerómetro de fuerza g alta / Sensor de proximidad / Sensor de luz ambiental",
"sistema_operativo":"iOS14",
"dimensiones":"146,7 mm x 71,5 mm x 7,4mm",
"peso":"162g",
"color":"negro"}'
);


-- 3     Apple iPhone 13 128GB Medianoche Libre
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
849,
'Apple iPhone 13 128GB Medianoche Libre',
'/imagenes/smartphone/apple/Apple iPhone 13 128GB Medianoche Libre.jpeg',
'iPhone 13: Tu nuevo superpoder. Nuestro sistema de cámara dual más avanzado. El chip que hace morder el polvo a la competencia. Un subidón de autonomía que vaya si notarás. Ceramic Shield, más duro que cualquier vidrio de smartphone. Pantalla Super Retina XDR de 6,1 pulgadas. Diseño robusto con bordes planos y resistente al agua.',
10,
'smartphone',
'apple',
'{
"sistema operativo":"iOS",
"version del sistema operativo":"iOS 14",
"pantalla":"tactil",
"tipo":"OLED",
"tamaño":"6.1",
"densidad":"460ppi",
"procesador":"Hexa-core A14 Bionic",
"grafico":"Apple GPU",
"memoria":"128GB",
"camara trasera":"12.0MP",
"camara frontal":"12.0MP",
"resolucion":"2160",
"conectividad":"3G / 4G / 5G / BLUETOOTH / NFC / WiFi / GPS",
"color":"negro"
}'
);



-- 4     Apple iPhone 11 64 GB Negro Libre
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
519.01,
'Apple iPhone 11 64 GB Negro Libre',
'/imagenes/smartphone/apple/Apple iPhone 11 64 GB Negro Libre.jpeg',
'La medida exacta de todo. Un nuevo sistema de cámara dual que abarca un campo de visión más amplio. El chip más rápido que haya tenido un smart­phone. Una batería que dura todo el día, para que hagas más y cargues menos. Y el vídeo de mayor calidad en un smart­phone, que hará que tus recuerdos sean aún más inolvidables. El iPhone 11 llega pisando fuerte.',
10,
'smartphone',
'apple',
'{
"sistema operativo":"iOS",
"version del sistema operativo":"iOS 13",
"pantalla":"tactil",
"tipo":"OLED",
"tamaño":"6.1",
"densidad":"360ppi",
"procesador":"A13 Bionic",
"grafico":"Apple GPU",
"memoria":"128GB",
"camara trasera":"12.0MP",
"camara frontal":"8.0MP",
"resolucion":"1792x828",
"conectividad":"3G / 4G / 5G / BLUETOOTH / NFC / WiFi / GPS",
"color":"negro",
"Ancho":"7,57 cm",
"Alto":"15,09 cm",
"Grosor":"0,83 cm",
"Peso":"194 g",
"almacenamiento":"64GB"
}'
);




-- 5     Apple iPhone 8 64GB Gris Espacial Libre
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
133,
'Apple iPhone 8 64GB Gris Espacial Libre',
'/imagenes/smartphone/apple/Apple iPhone 8 64GB Gris Espacial Libre.jpeg',
'Apple iPhone 8 Una mente brillante. Un espectacular diseño integral de vidrio. La cámara más popular del mundo en una versión aún mejor. El chip más inteligente y con mayor potencia que ha tenido un smartphone. Un sistema de carga inalámbrica que es pura comodidad. Y formas nunca vistas de disfrutar de la realidad aumentada. Es el iPhone 8, una nueva generación de iPhone.',
10,
'smartphone',
'apple',
'{
"almacenamiento":"64GB",
"dimensiones":"13,84 cm x 6,73 cm x 0,73 cm",
"peso":"148 g",
"pantalla":"retina HD",
"tipo":"LCD",
"resolucion":"1.920 por 1.080 píxeles a 401 p/p",
"color":"gris",
"tamaño":"4.7",
"camara delantera":"12MP",
"camara trasera":"12MP",
"sistema operativo":"iOS",
"version":"11.0"
}'
);




-- 6      Apple iPhone XR 64GB Negro Libre
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
133,
'Apple iPhone XR 64GB Negro Libre',
'/imagenes/smartphone/apple/Apple iPhone XR 64GB Negro Libre.jpeg',
'Nueva pantalla Liquid Retina con la tecnología LCD más avanzada del sector. Face ID aún más rápido. El chip más inteligente y con mayor potencia en un smart­phone. Y un revolucio­nario sistema de cámara. Da igual por dónde lo mires: el iPhone XR es sencillamente asombroso.',
10,
'smartphone',
'apple',
'{
"almacenamiento":"64GB",
"ancho":"7.57cm",
"alto":"15.09cm",
"grosor":"0.83cm",
"peso":"194 g",
"pantalla":"retina HD",
"tipo":"LCD",
"resolucion":"1.792 por 828 píxeles a 326 p/p",
"color":"negro",
"tamaño":"6.1",
"camara":"12MP",
"sistema operativo":"iOS",
"version":"A12 Bionic"
}'
);







--  SMARRRRTTTTTTPHONEEEEEE >>> AAAANDRRRRROIDDDDDDDD





-- 1     OPPO A57s 128GB Azul Libre
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
169,
'OPPO A57s 128GB Azul Libre',
'/imagenes/smartphone/android/OPPO A57s 128GB Azul Libre.jpeg',
'OPPO A57s - Teléfono Móvil Libre, 4GB+128GB, Cámara 50+2+8MP, Smartphone Android, Batería 5000mAh, Carga 33W, Dual Nano SIM - Azul',
10,
'smartphone',
'android',
'{"procesador": "MediaTek Helio G35 8 cores, up to 2.3GHZ",
"memoria_ram": "4 GB LPDDR4X 1600MHz",
"almacenamiento": "128GB",
"pantalla": "6.56 pulgadas LCD",
"camaras_traseras": "Principal:50MP",
"camara_frontal":"8MP",
"conectividad":"Wi-fi / Bluetooth / Conector de audio jack 3.5mm / NFC / USB tipo C",
"bateria":"5000 mAh (típico), 4880 mAh (mínimo) / Carga rápida SUPERVOOCTM",
"tarjeta_sim":"Dual SIM",
"sensores":"Lector de huellas dactilares / Sensor de luz / sensor de proximidad / sensor de aceleración",
"sistema_operativo":"Color OS 12",
"dimensiones":"163.74 x 75.03 x 7.99 mm",
"peso":"187g",
"color":"azul",
"marca":"oppo"}'
);


-- 2      Samsung Galaxy A53 5G 6/128GB Negro Libre
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
379.9,
'Samsung Galaxy A53 5G 6/128GB Negro Libre',
'/imagenes/smartphone/android/Samsung Galaxy A53 5G 6 128GB Negro Libre.jpeg',
'Samsung Galaxy A53 Negro Libre, 4GB+128GB, Cámara 64MP AF 1.8 + 5MP FF F2.4 + 12MP FF F2.2 123º + 5MP macro F2.4 + flash, Smartphone Android, Batería 5000mAh, Carga 25W, Dual Nano SIM',
10,
'smartphone',
'android',
'{"procesador": "Exynos 1280 5nm Octa-core (2.4GHz, 2GHz)",
"memoria_ram": "6 GB",
"almacenamiento": "128GB",
"pantalla": "6.5 pulgadas FHD+",
"camaras_traseras": "Principal (4 Cámaras): 64MP AF 1.8 + 5MP FF F2.4 + 12MP FF F2.2 123º + 5MP macro F2.4 + flash",
"camara_frontal":"32MP F2.2",
"conectividad":"Wi-fi / Bluetooth / NFC / USB tipo C",
"bateria":"5000 mAh / Carga Rápida de 25W",
"tarjeta_sim":"Dual SIM",
"sensores":"Lector de huellas dactilares / Sensor de luz ambiental/ sensor de proximidad / sensor de aceleración / giroscopio / brújula",
"sistema_operativo":"Android 12",
"dimensiones":"159,6 x 74,8 x 8,1 mm",
"peso":"189g",
"color":"negro",
"marca":"samsung"}'
);



-- 3     Samsung Galaxy M23 5G 4 128GB Azul Libre
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
189,
'Samsung Galaxy M23 5G 4/128GB Azul Libre',
'/imagenes/smartphone/android/Samsung Galaxy M23 5G 4 128GB Azul Libre.jpeg',
'Galaxy M23 5G ofrece un rendimiento asombroso con conectividad 5G, un potente procesador, junto con una cámara de alta resolución de 50 megapíxeles y la pantalla de 6,6" FHD+ de 120 Hz. Y, a pesar de ser un smartphone sobresaliente, es uno de los Galaxy más accesibles.',
10,
'smartphone',
'android',
'{
"dimensiones": "165,5 x 77 x 8,4 mm",
"peso": "198 g",
"pantalla": "LCD de 6,6 pulgadas / Resolución FullHD+ / 120 Hz de tasa de refresco",
"procesador": "Snapdragon 750G",
"ram": "4 GB",
"almacenamiento": "128 GB Hasta 1 TB con tarjeta microSD",
"camara delantera": "8 Mpx f/2.2",
"camara trasera": "50 Mpx f/1,8",
"Gran angular": "8 Mpx f/2,2",
"Sensor de profundidad": "2 Mpx f/2,4",
"bateria": "5.000 mAh y carga máxima a 25 W",
"software": "One UI 4.1 basado en Android 12",
"conectividad": "5G / WiFi 802.11 a/b/g/n/ac 2.4+5GHz / Bluetooth 5.0 / NFC / USB-C",
"otros": "Lector de huellas en el lateral"
}'
);




-- 4     Xiaomi Redmi Note 11S 6 128GB Gris Libre
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
204.94,
'Xiaomi Redmi Note 11S 6/128GB Gris Libre',
'/imagenes/smartphone/android/Xiaomi Redmi Note 11S 6 128GB Gris Libre.jpeg',
'Redmi Note 11S se renueva para darte lo mejor. Gracias a su cámara principal de 108MP, crea efectos de foto y de vídeos impresionantes de manera sencilla y listos para compartir.',
10,
'smartphone',
'android',
'{
"Conectividad": "Wi-Fi 802.11a/b/g/n/ac / Bluetooth 5.0 / NFC",
"Dimensiones": "159.87 x 73.87 x 8.09 mm",
"Peso": "179 g",
"Batería": "5000 mAh Carga rápida 25W",
"Audio": "Altavoces duales / Conector para auriculares de 3,5 mm",
"Seguridad": "Sensor de huella dactilar lateral / Desbloqueo facial por IA",
"Sensores": "Sensor de proximidad / Sensor de luz ambiental / Acelerómetro / Brújula electrónica / Emisor de infrarrojo / Giroscopio",
"USB": "Tipo C"
}'
);



-- 5    Samsung Galaxy A34 5G 8 256GB Plata Libre + Protector Pantalla
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
204.94,
'Samsung Galaxy A34 5G 8/256GB Plata Libre + Protector Pantalla',
'/imagenes/smartphone/android/Samsung Galaxy A34 5G 8 256GB Plata Libre + Protector Pantalla.jpeg',
'Te presentamos el nuevo miembro de la familia Samsung Galaxy A, el increíble Galaxy A34 5G. Este teléfono inteligente está diseñado para hacer que tu día a día sea más impresionante. Con una pantalla de alta calidad, podrás disfrutar de una experiencia visual superfluida. Además, cuenta con un avanzado sistema de carga rápida para que nunca te quedes sin batería.',
10,
'smartphone',
'android',
'{
"Sistema operativo": "Android 13",
"Procesador": "MediaTek Dimensity 1080 (MT6877V) Octa-Core (2.6GHz, 2GHz)",
"Pantalla": "6.6 1080 x 2340 (FHD+) On-Cell Touch Super AMOLED (120 Hz)",
"SIM": "Dual Nano-SIM (SIM 1 + Híbrido (SIM o microSD))",
"RAM": "8 GB",
"Almacenamiento interno": "256 GB (Ampliable con tarjeta microSD hasta 1 TB)",
"Cámara principal": "resolución (Múltiple): 48.0 MP + 8.0 MP + 5.0 MP",
"Autoenfoque": "Sí",
"OIS": "Sí",
"Zoom": "Digital hasta 10x",
"Flash": "Sí",
"Audio": "Dolby Atmos Conector de auriculares USB Tipo C",
"Conectividad": "WiFi 802.11 a/b/g/n/ac 2.4G+5GHz, VHT80 MIMO / WiFi Direct / Bluetooth 5.3 / NFC / USB Tipo C (2.0)",
"Biometría": "Lector de huella y Reconocimiento facial",
"Dimensiones": "161.3 x 78.1 x 8.2 mm",
"Peso": "199 g",
"Batería": "5000 mAh Carga rápida de 25W"
}'
);





-- 6    Realme C55 8 256GB Rainy Night Libre
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
209,
'Realme C55 8/256GB Rainy Night Libre',
'/imagenes/smartphone/android/Realme C55 8 256GB Rainy Night Libre.jpeg',
'Una de las características más impresionantes del realme C55 es su cámara trasera de 64MP con IA. Esto significa que podrás tomar fotos detalladas y nítidas con una gran cantidad de información visual en cada toma. Por ejemplo, podrías tomar fotos de paisajes impresionantes con una gran cantidad de detalles, como montañas, lagos y ríos. También podrás capturar fotos de cerca de objetos pequeños, como flores o insectos, para apreciar sus detalles más finos.',
10,
'smartphone',
'android',
'{
"Longitud": "164.2 mm",
"Ancho": "75.7 mm",
"Fondo": "Aprox. 7.89 mm",
"Peso": "188 g",
"Cámara principal": "64 MP",
"Cámara frontal": "8 MP",
"Sensores": "Escáner lateral de huellas dactilares",
"Conectividad": "Wi-Fi 802.11n 2.4GHz / Bluetooth 5.0 / Puerto Micro USB / Conector de audio jack 3.5mm",
"Batería": "5000 mAh (típ.) / 4890 mAh (mín.) Carga rápida SUPERVOOC de 33W"
}'
);








-- PERIIIIFÉRRRRRICOSSSSSS >>>> RRRRRRATÓNNNNNN








-- 1    Tempest MS300 Soldier RGB Ratón Gaming 4.000 DPI Negro
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
5.49,
'Tempest MS300 Soldier RGB Ratón Gaming 4.000 DPI Negro',
'/imagenes/periferico/raton/Tempest MS300 Soldier RGB Ratón Gaming 4.000 DPI Negro.jpeg',
'Tempest presenta su nuevo ratón, el MS-300 RGB Soldier, hecho para todos aquellos que buscan tener la mejor experiencia gaming al mejor precio posible. El mejor ratón con iluminación RGB, diseñado tanto para el juego como para cualquier uso diario.',
10,
'periferico',
'raton',
'{"sensor":"optico",
"resolucion_ajustable":"1000-4000 DPI",
"numero_teclas":"6 botones",
"dimensiones":"135*73*42 mm",
"longitud_cable_mallado":"1,8m",
"tasa_muestreo":"250Hz",
"velocidad_maxima":"30 IPS",
"compatibilidad":"Windows 10, 8, 7, Mac X 10.5 o superior, Linux",
"color":"negro"}'
);

-- 2     MSI Clutch GM31 Lightweight Ratón Gaming RGB 12000 DPI
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
37.99,
'MSI Clutch GM31 Lightweight Ratón Gaming RGB 12000 DPI',
'/imagenes/periferico/raton/MSI Clutch GM31 Lightweight Ratón Gaming RGB 12000 DPI.jpeg',
'El MSI GM31 Lightweight es un ratón para juegos con solo 58 g de peso para todos los que quieren jugar de forma rápida y precisa. El diseño compacto es especialmente adecuado para jugadores con manos pequeñas y medianas Con 2 m de longitud de cable, el PC se puede colocar de forma flexible. Perfecto para juegos competitivos.',
10,
'periferico',
'raton',
'{"sensor":"optico",
"resolucion_ajustable":"12000 DPI",
"numero_teclas":"6 botones",
"diseño":"diestros",
"dimensiones":"120 x 64 x 37 mm",
"garantia":"24 meses",
"longitud_cable":"2m",
"tasa_muestreo":"200Hz",
"interfaz":"USB",
"compatibilidad":"Windows 10, 11 Mac X 10.5 o superior, Linux",
"color":"negro"}'
);



-- 3    Logitech Lift Ratón Inalámbrico Vertical para Diestros 4000 DPI Negro Gris
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
70.99,
'Logitech Lift Ratón Inalámbrico Vertical para Diestros 4000 DPI Negro/Gris',
'/imagenes/periferico/raton/Logitech Lift Ratón Inalámbrico Vertical para Diestros 4000 DPI Negro Gris.jpeg',
'Di sí a la comodidad con Logitech Lift. Este ratón vertical ergonómico te permite trabajar durante horas sin sentir ningún dolor en la muñeca. Perfecta para manos pequeñas y medianas, tiene una superficie ligeramente texturizada, seis botones de fácil acceso, un sensor óptico de 4000 dpi y un cómodo apoyo para el pulgar.',
10,
'periferico',
'raton',
'{
"Utilizar con": "Oficina",
"Interfaz del dispositivo": "RF inalámbrica + Bluetooth",
"Tipo de botones": "Botones presionados",
"Tipo de desplazamiento": "Rueda",
"Cantidad de botones": 4,
"Resolución de movimiento": "4000 DPI",
"Factor de forma": "mano derecha",
"Diseño de plancha ergonómico": "Si",
"Diseño vertical": "Si",
"Color del producto": "Grafito",
"Coloración de superficie": "Monótono",
"Alcance inalámbrico": "10 m",
"Fuente de energía": "Baterías",
"Número de baterías soportadas": 1,
"Tipo de batería": "AA",
"Tecnología de batería": "Alcalino",
"Vida de batería en servicio": "24 meses",
"Ancho": "70 mm",
"Profundidad": "108 mm",
"Altura": "71 mm",
"Peso": "125 g",
"Color": "Negro"
}'
);





-- 4    Forgeon Darrowspike RGB Ratón Gaming Inalámbrico 19.000 DPI Negro
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
104.99,
'Forgeon Darrowspike RGB Ratón Gaming Inalámbrico 19.000 DPI Negro',
'/imagenes/periferico/raton/Forgeon Darrowspike RGB Ratón Gaming Inalámbrico 19.000 DPI Negro.jpeg',
'Presentamos el nuevo mouse gaming Forgeon Darrowspike Wireless. Este mouse inalámbrico ofrece unas prestaciones inigualables a un precio muy competitivo. Con el receptor inalámbrico incorporado sencillamente con conectarlo empezarás a disfrutar de tus mejores partidas dejando de lado esos cables que dificultan el movimiento.',
10,
'periferico',
'raton',
'{
"Modelo": "FORGEON Darrowspike",
"Dimensiones": "63mm x 125mm x 41mm",
"Peso": "95g",
"Longitud del cable USB 2.0": "1,8m Paracord",
"Batería": "600mAh",
"Receptor inalámbrico 2.4G": "USB 2.0",
"Resolution": "800-19.000 DPI",
"Polling Rate": "500-1000 Hz (1ms)",
"Aceleración máxima": "50G",
"Velocidad máxima": "400IPS",
"Cable de paracord": "1.8 m"
}'
);



-- 5     Newskill Eos Ivory Ratón Gaming Professional RGB 16000DPI Blanco
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
49.95,
'Newskill Eos Ivory Ratón Gaming Professional RGB 16000DPI Blanco',
'/imagenes/periferico/raton/Newskill Eos Ivory Ratón Gaming Professional RGB 16000DPI Blanco.jpeg',
'Una de las características que hace de Eos Ivory la elección perfecta para todos los que buscan un ratón tope de gama es que incorpora Pixart 3360, un sensor óptico de última generación capaz de ofrecer una enorme precisión, además de hasta 250 pulgadas por segundo (IPS) y hasta 50G de aceleración.',
10,
'periferico',
'raton',
'{
"Dimensiones": "63mm x 125mm x 41mm",
"Peso": "95g",
"Sensor óptico": "Pixart 3360",
"Pulgadas por segundo (IPS)": "Hasta 250",
"Aceleración": "Hasta 50G",
"DPI": "16000",
"Iluminación": "RGB por fases y diferentes efectos de iluminación",
"Perfiles configurables por el usuario": "10",
"Diseño": "Multitask",
"Botones": "7"
}'
);



-- 6    Logitech M185 Ratón Inalámbrico 1000DPI Gris
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
14.99,
'Logitech M185 Ratón Inalámbrico 1000DPI Gris',
'/imagenes/periferico/raton/Logitech M185 Ratón Inalámbrico 1000DPI Gris.jpeg',
'Ratón inalámbrico Logitech® M185. Un ratón sencillo y fiable con tecnología inalámbrica Plug and Play. Obtendrás la fiabilidad de un cable con la comodidad y la libertad de la tecnología inalámbrica: los datos se transfieren rápidamente sin apenas retrasos ni interrupciones.',
10,
'periferico',
'raton',
'{
"Altura": "99 mm (3,90 in)",
"Anchura": "60 mm (2,36 in)",
"Profundidad": "39 mm (1,54 in)",
"Peso (con pilas)": "75,2 g (2,65 oz)",
"dpi (mín./máx.)": "1000±",
"Número de botones": "3",
"Detalles de las pilas": "Una pila AA",
"Tipo de conexión": "Conexión inalámbrica de 2,4 GHz",
"Radio de acción inalámbrico": "10 m (393,7 in)",
"Contenido de la caja": "Ratón / Receptor USB / Una pila AA (preinstalada) / Documentación del usuario",
"Duración de las pilas": "12 meses"
}'
);





-- 7    Owlotech M70 Ratón Inalámbrico 1.000 DPI Negro
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
5.99,
'Owlotech M70 Ratón Inalámbrico 1.000 DPI Negro',
'/imagenes/periferico/raton/Owlotech M70 Ratón Inalámbrico 1.000 DPI Negro.jpeg',
'Con un diseño minimalista y una frecuencia inalámbrica de 2.4 GHz te proporciona la conexión perfecta para que puedas trabajar en cualquier situación o circunstancia. No te lo pienses más y renueva tu antiguo ratón por esta auténtica maravilla que hará del trabajo una experiencia mucho más agradable y divertida.',
10,
'periferico',
'raton',
'{
"Altura": "99 mm (3,90 in)",
"Anchura": "60 mm (2,36 in)",
"Profundidad": "39 mm (1,54 in)",
"Peso (con pilas)": "75,2 g (2,65 oz)",
"Chip": "Hanxia 8650",
"DPI": "1000",
"Material": "ABS",
"Tamaño del mouse": "9.85 x 3.75 x 6 cm",
"Resistencia del Switch": "1 millón",
"Radio de acción inalámbrico": "10 m (393,7 in)"
}'
);




-- 8    Logitech G203 Lightsync 2nd Gen Ratón Gaming 8000DPI RGB Negro
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
19.53,
'Logitech G203 Lightsync 2nd Gen Ratón Gaming 8000DPI RGB Negro',
'/imagenes/periferico/raton/Logitech G203 Lightsync 2nd Gen Ratón Gaming 8000DPI RGB Negro.jpeg',
'Aprovecha al máximo tu tiempo de juego con el ratón G203 2nd Gen para gaming, con tecnología LIGHTSYNC, un sensor para gaming y un diseño clásico con 6 botones. Anima tu juego... y tu escritorio.',
10,
'periferico',
'raton',
'{
"Requisitos": "Windows® 7 o posteriores / macOS 10.10 o posteriores / Chrome OSTM",
"Puerto": "USB",
"Altura": "116,6 mm",
"Anchura": "62,15 mm",
"Profundidad": "38,2 mm",
"Peso": "85 g (sólo ratón)",
"Longitud del cable": "2,1 m",
"Iluminación": "RGB LIGHTSYNC",
"botones programables": "6",
"Resolución": "200 – 8.000 dpi",
"Formato de datos USB": "16 bits/eje",
"Velocidad de respuesta USB": "1.000 Hz (1 ms)",
"Microprocesador": "ARM de 32 bits"
}'
);




-- 9    Xiaomi Mi Dual Mode Wireless Silent Edition Ratón Bluetooth 1300DPI Negro
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
13,
'Xiaomi Mi Dual Mode Wireless Silent Edition Ratón Bluetooth 1300DPI Negro',
'/imagenes/periferico/raton/Xiaomi Mi Dual Mode Wireless Silent Edition Ratón Bluetooth 1300DPI Negro.jpeg',
'En primer lugar, Mi Dual Mode Wireless Mouse Silent Edition en color negro es un ratón inalámbrico de Xiaomi. En segundo lugar, cabe destacar que este mouse ha sido mejorado respecto a generaciones anteriores. Así, se ha mejorado en ergonomía y calidad técnica.',
10,
'periferico',
'raton',
'{
"Requisitos": "Windows® 7 o posteriores / macOS 10.10 o posteriores / Chrome OSTM",
"Puerto": "USB",
"Altura": "116,6 mm",
"Anchura": "62,15 mm",
"Profundidad": "38,2 mm",
"Peso": "85 g (sólo ratón)",
"Dimensiones": "112,7 × 62,7 × 36,8mm",
"Peso neto": "aprox 93g",
"Material": "ABS y PC",
"Color": "Negro",
"Conectividad inalámbrica": "Bluetooth 4,2 y RF 2,4 GHz",
"Rango inalámbrico": "hasta 8 m",
"Batería": "2 pilas AAA (no incluidas)",
"Compatible con": "Windows 10, macOS o Android 6,0 y superior",
"Microprocesador": "ARM de 32 bits"
}'
);



-- 10    Forgeon Vendetta Ratón Gaming RGB 16000DPI Negro
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
84.99,
'Forgeon Vendetta Ratón Gaming RGB 16000DPI Negro',
'/imagenes/periferico/raton/Forgeon Vendetta Ratón Gaming RGB 16000DPI Negro.jpeg',
'Presentando este mouse Vendetta de Forgeon puedo decirte que te encuentras ante el ratón más competente del mercado. Este mouse ha sido por varios años consecutivos elegido el mejor mouse gaming en cuanto a su diseño. Dispone de diferentes botones que te generan todos los atajos y prestaciones que necesites al alcance de tu mano y lleva también un sensor que regula la velocidad que quieras en cada momento. Con el mouse Vendetta lo ganarás todo. ',
10,
'periferico',
'raton',
'{
"Tamaño del producto": "W74 x L129 x H43mm",
"Sensor": "PMW3389",
"Resolución del sensor": "500-1000-1500-2000-4000-8000-16000 DPI",
"Frecuencia de escaneo": "16000 FPS",
"Tasa de sondeo": "de 500 a 1000Hz",
"Tipo de LED": "RGB",
"Interruptor de botón": "Omron 20min",
"Codificador": "TTC",
"Conector": "USB 2.0",
"Cable": "1,8 m con filtro de ferrita",
"Accesorios": "1 pieza para cada uno",
"Dimensiones": "74mm x 129mm x 43mm",
"Peso": "115g",
"Longitud del cable USB 2.0": "1,8m",
"Botones": "8",
"Resolution": "500-16.000 DPI",
"Polling Rate": "500-1000 Hz (1ms)",
"Aceleración máxima": "60G",
"Velocidad máxima": "400IPS"
}'
);




-- 11    NGS Evo Karma Ratón Vertical Ergonómico Inalámbrico con Luces LED y Conexión Multimodo 3200 DPI
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
22.99,
'NGS Evo Karma Ratón Vertical Ergonómico Inalámbrico con Luces LED y Conexión Multimodo 3200 DPI',
'/imagenes/periferico/raton/NGS Evo Karma Ratón Vertical Ergonómico Inalámbrico con Luces LED y Conexión Multimodo 3200 DPI.jpeg',
'Ratón vertical ergonómico e inalámbrico NGS Evo Karma con tecnología multidispositivo y luces LED.',
10,
'periferico',
'raton',
'{
"Color": "Gris",
"Conectividad": "Bluetooth + Receptor",
"Preferencia de la mano": "Diestro",
"Características": "Multidispositivo",
"DPI Máximos": "3200 dpi",
"Compatibilidad": "Windows, iOS",
"Dimensiones": "74mm x 129mm x 43mm",
"Peso": "115g"
}'
);



-- 12    Philips SPK7307BL00 Ratón Inalámbrico 1600DPI Negro
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
9.9,
'Philips SPK7307BL/00 Ratón Inalámbrico 1600DPI Negro',
'/imagenes/periferico/raton/Philips SPK7307BL00 Ratón Inalámbrico 1600DPI Negro.jpeg',
'Un cómodo ratón que se ajusta perfectamente a la palma de la mano y cabe sin problemas en el bolso: este práctico ratón para portátil dispone de conexión inalámbrica y un sensor óptico que le permite funcionar en la mayoría de superficies.',
10,
'periferico',
'raton',
'{
"Utilizar con": "Oficina",
"Interfaz del dispositivo": "RF inalámbrico",
"Tecnología de detección de movimientos": "Óptico",
"Tipo de desplazamiento": "Rueda",
"Cantidad de botones": 3,
"Resolución de movimiento": "1600 DPI",
"Frecuencia de banda": "2.4 GHz",
"Factor de forma": "Ambidextro",
"Diseño de plancha ergonómico": "Si",
"Color del producto": "Negro",
"Ancho": "65 mm",
"Profundidad": "110 mm",
"Altura": "35 mm",
"Peso": "83 g",
"Fuente de energía": "Baterías",
"Numero de baterías soportadas": 1,
"Tipo de batería": "AA",
"Capacidad de batería": "1 mAh"
}'
);










-- PERRRRRRIFÉRRRRRICOSSSSSSS >>>> TEEEEEECLAAAAAADOOOOOOO









-- 1     Logitech G512 Carbon Teclado Mecánico Gaming RGB GX Brown
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
89.99,
'Logitech G512 Carbon Teclado Mecánico Gaming RGB GX Brown',
'/imagenes/periferico/teclado/Logitech G512 Carbon Teclado Mecánico Gaming RGB GX Brown.jpeg',
'G512 de Logitech es un teclado para gaming de alto rendimiento con interruptores mecánicos avanzados GX. Con tecnología de gaming avanzada y una construcción de aleación de aluminio, el teclado G512 es sencillo y duradero, con todas las funciones.',
10,
'periferico',
'teclado',
'{"distancia_actuacion":"1.9mm",
"recorrido_total":"4mm",
"tipo_conexion":"USB",
"retroiluminacion":"si",
"garantia":"24 meses",
"dimensiones":"Longitud: 132 mm Anchura: 445 mm Altura: 35.5 mm",
"fuerza_media_Actuacion":"50gf",
"fuerza_tactil":"60gf",
"longitud_cable":"1.8m",
"teclas_especiales":"Controles de iluminación: FN+F5/F6/F7 / Modo de juego: FN+F8 / Controles multimedia: FN+F9/F10/F11/F12 / Controles de volumen: FN+ IMPR PANT/BLOCK DESPL/PAUSA / Teclas FN programable mediante Logitech G HUB",
"color":"negro",
"peso":"1.130Kg"}'
);



-- 2     Newskill Chronos TKL Teclado Mecánico Gaming RGB Switch Red
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
43.95,
'Newskill Chronos TKL Teclado Mecánico Gaming RGB Switch Red',
'/imagenes/periferico/teclado/Newskill Chronos TKL Teclado Mecánico Gaming RGB Switch Red.jpeg',
' Este teclado gaming dispone de pad numérico, a diferencia de otros teclados TKL, y viene con dos juegos completos de keycaps, uno blanco y otro negro, para personalizarlo de manera única. Además, cuenta con software para configurar su iluminación cómodamente y grabar tus macros.',
10,
'periferico',
'teclado',
'{"tasa_transmision":"maxima velocidad",
"pad":"numerico",
"iluminacion":"RGB",
"sistemas":"Windows98?XP/2000/ME/Vistar/Win7/ Win8/ Win10//IOS",
"n_teclas":"93 teclas",
"dimensiones":"(L)359mm x (W)141mm x (H) 37.2mm±0.3mm",
"consumo":"300mA",
"conexion":"USB 2.0",
"longitud_cable":"1.8m",
"teclas_especiales":"Controles de iluminación: FN+F5/F6/F7 / Modo de juego: FN+F8 / Controles multimedia: FN+F9/F10/F11/F12 / Controles de volumen: FN+ IMPR PANT/BLOCK DESPL/PAUSA / Teclas FN programable mediante Logitech G HUB",
"color":"negro",
"peso":"850g±20g"}'
);




-- 3     Woxter Stinger RX 1000 KR Teclado Mecánico Retroiluminado
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
19.99,
'Woxter Stinger RX 1000 KR Teclado Mecánico Retroiluminado',
'/imagenes/periferico/teclado/Woxter Stinger RX 1000 KR Teclado Mecánico Retroiluminado.jpeg',
'Teclado gaming mecánico retroiluminado Stinger RX 1000 Kr. Nuevo teclado mecánico multimedia de Woxter Stinger: su rompedor diseño, su espectacular iluminación con efectos, su estructura de aluminio y sus teclas mecánicas, hacen de este RX 1000 Kr un teclado premium único. Ideal para gamers. Podrás configurar tus efectos de luz, automatizar atajos de tus juegos configurando macros o controlar el volumen de forma directa con su rueda de función. Teclas mecánicas, cable trenzado y conector USB.',
10,
'periferico',
'teclado',
'{"Teclas multimedia de función":"teclas programables, control del brillo y de efectos de luz, configuración de macros, automatización de los atajos de tus juegos",
"Rueda de función multimedia":"control del volumen y la retroiluminación",
"Botones con doble función":"configuración de modo de iluminación y grabación de efectos de luces, avanzar/retroceder/play-pause de pista",
"Retroiluminado":"luces led con varios modos de iluminación",
"Conectividad":"USB. Plug & Play",
"Reposa muñecas":"ergonómico y confortable de sujeción magnética",
"Micro switch de alta sensibilidad":"más de 50 millones de pulsaciones, pulsación mecánica ultraprecisa",
"Estructura":"aleación de aluminio y ABS",
"Dimensiones teclado":"435x123x38.5 mm",
"Dimensiones reposa muñecas":"435x68x14.5 mm",
"Peso":"670 gr",
"Corriente de trabajo":"DC 5V/<250mA",
"Longitud del cable de nilón":"1,6m",
"Sistema Operativo":"Windows Vista/WIN7/8/10, MAC OS, PS4, Fortnite® o Apex Legends®"}'
);






-- 4     Tempest Mephisto Teclado Mecánico Inalámbrico Gaming RGB Switch Red
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
79.99,
'Tempest Mephisto Teclado Mecánico Inalámbrico Gaming RGB Switch Red',
'/imagenes/periferico/teclado/Tempest Mephisto Teclado Mecánico Inalámbrico Gaming RGB Switch Red.jpeg',
'Tempest no podía quedarse atrás y presenta el teclado gaming que estábais esperando. El nuevo Tempest Mephisto RGB. Un teclado con un diseño gaming exclusivo para ofrecerte la mayor garantía y éxito en tus partidas. Un teclado Full layout para que puedas trabajar durante el día y jugar por las noches sin restricciones, de ningún tipo ya que además este teclado dispone de tecnología inalámbrica que te permitirá total libertad sin cables, sin engorros. Si quieres marcar la diferencia, Mephisto es tu nuevo aliado.',
10,
'periferico',
'teclado',
'{"Dimensiones": "441x137x40mm (LxAxAl)",
"Peso": "980±5g",
"Switches": "Red",
"Teclas de doble inyección": "ABS",
"Impresión": "láser",
"Número de teclas": "108 teclas",
"Layout": "Español",
"Cable": "tipo C de 1,5 m",
"Plug and Play": "Sí",
"Batería recargable": "3.000mAh"}'
);





-- 5     Razer Huntsman V2 TKL Teclado Mecánico Gaming RGB Switch Óptico Lineal Red
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
185.99,
'Razer Huntsman V2 TKL Teclado Mecánico Gaming RGB Switch Óptico Lineal Red',
'/imagenes/periferico/teclado/Razer Huntsman V2 TKL Teclado Mecánico Gaming RGB Switch Óptico Lineal Red.jpeg',
'Sin florituras. Todo rendimiento. La sensibilidad sin rival nunca ha sido tan estilizada. Descubre el Razer Huntsman V2 TKL, un teclado óptico gaming sin teclado numérico con una acústica mejorada, una latencia de entrada insignificante y más funciones avanzadas que ofrecen un diseño compacto con rendimiento de tamaño completo.',
10,
'periferico',
'teclado',
'{"Tipo de interruptor": "Conmutador óptico lineal Razer™",
"Sensación de tecla": "Ligero e instantáneo",
"Tamaño": "Tenkeyless (TKL)",
"Iluminación": "Retroiluminación Razer Chroma™ RGB personalizable con 16,8 millones de opciones de color",
"Reposamuñecas": "Sí",
"Memoria integrada": "Almacenamiento integrado híbrido, hasta 5 perfiles de combinación de teclas",
"Teclas multimedia": "Ninguna",
"Conectividad": "Alámbrico, cable de fibra trenzada USB-C desmontable",
"Teclas": "Razer Doubleshot PBT",
"Vida útil de las teclas": "100 millones de pulsaciones",
"Tecnología Razer™ HyperPolling": "Tasa de sondeo real de hasta 8000 Hz",
"Teclas programables": "Totalmente programables con grabación de macros sobre la marcha",
"N-key rollover": "Anti-ghosting con N-key rollover",
"Modo de juego": "Opción de modo de juego",
"Placa superior": "Aluminio mate"}'
);





-- 6     Logitech G413 TKL SE Teclado Gaming Mecánico Retroiluminado
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
65.99,
'Logitech G413 TKL SE Teclado Gaming Mecánico Retroiluminado',
'/imagenes/periferico/teclado/Logitech G413 TKL SE Teclado Gaming Mecánico Retroiluminado.jpeg',
'G413 TKL SE ofrece desempeño apto para juegos. Con interruptores mecánicos táctiles, seguidilla de 6 teclas con prevención de efecto fantasma y teclas de PBT en un óptimo formato compacto. Con un diseño minimalista sin sección numérica y una recia carcasa de aleación de aluminio, está listo para competir.',
10,
'periferico',
'teclado',
'{"Teclas de PBT": "Sí",
"Cubierta superior": "Aluminio",
"Retroiluminación": "Blanca",
"Idioma": "Español",
"Formato": "Ten Keyless",
"Interruptores": "Mecánicos táctiles",
"Distancia de actuación": "1,9 mm",
"Fuerza de actuación": "50 g",
"Recorrido total": "4,0 mm",
"Tipo de conexión": "USB 2.0",
"Protocolo USB": "USB 2.0",
"Retroiluminación por tecla": "Sí, iluminación blanca",
"Longitud": "355 mm",
"Ancho": "127 mm",
"Altura": "36,3 mm",
"Peso": "650 g",
"Longitud del cable": "1,8 m"}'
);



-- 7      MSI Vigor GK71 Sonic Teclado Mecánico Gaming RGB Switch Blue
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
114.90,
'MSI Vigor GK71 Sonic Teclado Mecánico Gaming RGB Switch Blue',
'/imagenes/periferico/teclado/MSI Vigor GK71 Sonic Teclado Mecánico Gaming RGB Switch Blue.jpeg',
'El teclado para juegos VIGOR GK71 SONIC - Blue Switches ofrece la mejor sensación de interruptor de clic mientras está empaquetado en un diseño liviano. Con uno de los interruptores mecánicos clicky más ligeros del mundo, nuestro propio MSI Sonic Blue, domina la competencia con reacciones rápidas y pulsaciones ligeras de teclas.',
10,
'periferico',
'teclado',
'{
"Nombre del modelo":"Teclado Sonic Para juegos Vigor GK71",
"Tipo de cable":"1.8m Tipo A Trenzado",
"Iluminación":"MYSTIC LIGHT RBG por tecla",
"Accesorios":"Extractor de llaves y reposamuñecas ergonómico",
"Interruptor":"MSI Sonic Blue",
"Sistema operativo":"Windows 10 o superior",
"N-KEY Rollover":"Híbrido 6+N",
"Vida útil de las teclas":"70+ millones de pulsaciones",
"Número de teclas":"104 / 105 / 109 (según idioma)",
"Dimensiones":"442.5 x 138 x 41 mm",
"Peso":"854 g"
}'
);


-- 8     Logitech MK295 Combo Teclado + Ratón Inalámbricos Blanco Crudo
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
34.70,
'Logitech MK295 Combo Teclado + Ratón Inalámbricos Blanco Crudo',
'/imagenes/periferico/teclado/Logitech MK295 Combo Teclado + Ratón Inalámbricos Blanco Crudo.webp',
'Menos ruido, más concentración. Mantén la concentración en tu trabajo, sin distracciones. La combinación inalámbrica silenciosa Logitech MK295 incluye SilentTouch, una tecnología exclusiva de Logitech que elimina más del 90% del ruido producido por teclados y ratones. Ofrece la misma sensación de clic y escritura que la mejor combinación de todas y sin molestos ruidos al hacer clic o escribir.',
10,
'periferico',
'teclado',
'{
"Modelo":"Logitech MK295",
"Estilo":"TKL 60 (66 teclas)",
"Dimensiones":"327,2mm x 114mm x 39,2mm",
"Peso":"630g",
"Longitud del cable":"1,8m desmontable",
"Switch":"OUTEMU Blue",
"Sensación":"Táctil-Clicky",
"Distancia de actuación":"2,0 mm",
"Fuerza de actuación":"60g",
"Distancia total":"~ 4mm",
"Botones":"control Rueda de volumen + funciones FN",
"A-RGB":"Si, customizable",
"Software":"Si"
}'
);



-- 9     HyperX Alloy Origins 60 Teclado Mecánico Gaming RGB Switch Táctil HyperX Aqua Layout USA
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
118.99,
'HyperX Alloy Origins 60 Teclado Mecánico Gaming RGB Switch Táctil HyperX Aqua Layout USA',
'/imagenes/periferico/teclado/HyperX Alloy Origins 60 Teclado Mecánico Gaming RGB Switch Táctil HyperX Aqua Layout USA.jpeg',
'El HyperX Alloy Origins 60 es un teclado duradero con un formato al 60 % que destaca por su portabilidad y te proporciona más espacio para arrastrar el ratón. Cuenta con un cuerpo duradero totalmente de aluminio y con las prácticas teclas HyperX de gran velocidad y rendimiento, diseñadas para soportar 80 millones de pulsaciones.',
10,
'periferico',
'teclado',
'{
"Tecla":"Tecla HyperX",
"Tipo":"Mecánico",
"Layout":"Inglés USA",
"Retroiluminación":"RGB (16 777 216 colores)",
"Efectos de iluminación":"Por iluminación RGB de tecla y cinco niveles de brillo *Iluminación RGB por tecla personalizable con el software HyperX NGENUITY",
"Memoria integrada para":"3 perfiles",
"Tipo de conexión":"USB-C a USB-A",
"Anti-ghosting":"100 % anti-ghosting",
"Pulsado simultáneo":"Modo N-key",
"Control de los medios":"Sí",
"Modo de juego":"Sí",
"Compatibilidad con el sistema operativo":"Windows® 10, 8.1, 8, 7; PS4/PS5; Xbox One; Xbox Series X|S",
"Tecla":"Tecla HyperX Aqua",
"Estilo de funcionamiento":"Táctil",
"Fuerza de funcionamiento":"45 g",
"Punto aplicado":"1,8 mm",
"Distancia total de recorrido":"3,8 mm",
"Vida útil (pulsaciones)":"80 millones",
"Tipo":"Extraíble, trenzado",
"Longitud":"1,8 metros"
}'
);



-- 10     Tempest K9 PRO Teclado Gaming RGB Negro
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
27,
'Tempest K9 PRO Teclado Gaming RGB Negro',
'/imagenes/periferico/teclado/Tempest K9 PRO Teclado Gaming RGB Negro.jpeg',
'¿Buscas cambiar tu experiencia gaming? Te traemos recién salido del horno este exclusivo teclado Tempest K9 PRO RGB. Un teclado pensado para ofrecerte la mejor experiencia dentro de tus partidas gaming. Cuenta con una iluminación RGB que puedes controlar a tu gusto y disfrutar de sus innumerables efectos de colores. Por otro lado, su diseño compacto te ofrecerá una libertad de movimiento perfecta ya que comprime todas sus teclas para que utilices las que más necesitas dentro de tus sesiones de juego. Si buscas calidad, busca a Tempest.',
10,
'periferico',
'teclado',
'{
"rueda de control":"Volumen y luz en el teclado",
"teclas":"89 teclas (teclado numérico adicional en el teclado TKL)",
"anti-ghosting":"19 teclas",
"cubierta superior":"ABS",
"cubierta inferior":"ABS",
"medidas":"372*151.37mm",
"peso":"580gr",
"longitud cable":"175cm",
"peso":"505gr"
}'
);




-- 11     Corsair K70 RGB TKL Champion Series Teclado Óptico-Mecánico Negro
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
98.99,
'Corsair K70 RGB TKL Champion Series Teclado Óptico-Mecánico Negro',
'/imagenes/periferico/teclado/Corsair K70 RGB TKL Champion Series Teclado Óptico-Mecánico Negro.jpeg',
'Llévese el teclado óptico-mecánico para juegos CORSAIR K70 RGB TKL a la próxima competición con su formato compacto sin teclado numérico (tenkeyless), la potente tecnología de hiperprocesamiento CORSAIR AXON y los interruptores de teclas óptico-mecánicos CORSAIR OPX RGB.',
10,
'periferico',
'teclado',
'{
"Formato": "Sin teclado numérico",
"Chasis": "Aluminio, anodizado negro, cepillado",
"Interruptores de teclas": "CORSAIR OPX, óptico-mecánico, fuerza de actuación de 45g, distancia de pulsación de 1,0 mm",
"Retroiluminación": "Iluminación individual y programable por tecla",
"Color LED": "RGB - 16,8 millones de colores",
"Teclas": "Policarbonato, compatibles con retroiluminación",
"Conectividad": "1 USB 3.0 tipo A",
"Velocidad de respuesta por USB": "Sondeo de hasta 8.000 Hz",
"Matriz": "Detección simultánea de teclas (NKRO) con protección completa contra pulsaciones nulas",
"Perfiles integrados": "Hasta 50",
"Teclas multimedia": "Cinco teclas de acceso rápido específicas (reproducción/pausa, detención, siguiente pista, última pista, silencio) y rueda de volumen (subir y bajar volumen)",
"Tecla de brillo": "Sí",
"Tecla de bloqueo de Windows": "Sí",
"Altura regulable": "Sí",
"iCUE (software)": "Compatible en Windows 10 y macOS 10.15",
"Cable": "1,82 m (6 ft), USB tipo C a tipo A, extraíble, negro, fibra trenzada",
"Dimensiones": "360 (L) x 164 (An) x 40 (Al) mm / 14,2 (L) x 6,46 (An) x 1,58 (Al) in",
"Peso": "0,88 kg / 1,95 lb"
}'
);




-- 12     Krom Kasic TKL Rainbow Teclado Gaming Negro
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
23.99,
'Krom Kasic TKL Rainbow Teclado Gaming Negro',
'/imagenes/periferico/teclado/Krom Kasic TKL Rainbow Teclado Gaming Negro.jpeg',
'Krom Kasic TKL es un teclado mecánico con formato TKL que tiene iluminación RGB y switches rojos de excelente calidad.Con tecnología anti-ghosting en 25 de sus teclas y bloqueo de la tecla Windows, este teclado es un buen aliado para los amantes de los teclados compactos.',
10,
'periferico',
'teclado',
'{
"Tipo": "Mecánico (Red Switch)",
"Retroiluminación": "RGB Rainbow",
"Dimensiones": "347 x 122 x 45 mm",
"Peso": "630 g",
"Compatibilidad": "Windows 7 / 8 / 8.1 / 10",
"Número de teclas": "87",
"Teclas multimedia": "12",
"Anti-ghosting": "25 teclas",
"Conexión": "USB",
"Longitud cable": "150 cm"

}'
);







-- PERRRRRRIFÉRRRRRICOSSSSSSS >>>> MOOOOOONNNNNIIIITTTOOOOOOORRRRREEEEESSSSS










-- 1    AOC Q27G2E 27" LED QHD 155Hz FreeSync Premium
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
199.99,
'AOC Q27G2E 27" LED QHD 155Hz FreeSync Premiumd',
'/imagenes/periferico/monitor/AOC Q27G2E 27_ LED QHD 155Hz FreeSync Premium.jpeg',
'El AOC Q27G2E/BK dispone de un panel VA de 27" con resolución QHD, ShadowControl y una relación de contraste superior de 3000:1. Disfrute de los juegos con mejor capacidad de respuesta y batallas más rápidas con Adaptive Sync sin interrupciones, una frecuencia de actualización de 155 Hz (OC), MPRT de 1 ms y un retardo de entrada bajo para reducir el desenfoque de movimiento y el retardo de entrada y salida.',
10,
'periferico',
'monitor',
'{"pantalla":"27 pulgadas",
"tipo":"plano",
"tratamiento":"antibrillo",
"pixeles_x_pulgada":"109",
"resolucion":"2560x1440",
"aspecto":"16:9",
"brillo":"250 Nits",
"tasa_refresco":"155Hz",
"Retroiluminacion":"WLED",
"tiempo_respuesta":"4ms",
"colores":"16.7 millones",
"color":"negro",
"conectividad":"2x HDMI 2.0 / 1x DisplayPort 1.2 / 1x Salida de Auriculares 3.5mm",
"consumo":"Alimentación eléctrica: Interna / Consumo en Standby: 0.3 W"}'
);


-- 2    MSI G27CQ4 E2 27" LED WQHD 170Hz FreeSync Premium Curva
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
239.99,
'MSI G27CQ4 E2 27" LED WQHD 170Hz FreeSync Premium Curva',
'/imagenes/periferico/monitor/MSI G27CQ4 E2 27_ LED WQHD 170Hz FreeSync Premium Curva.jpeg',
'monitor MSI G27CQ4 E2 Curved Gaming™. Equipado con una frecuencia de actualización de 2560x1440, 170 Hz, panel de tiempo de respuesta de 1 ms.',
10,
'periferico',
'monitor',
'{"pantalla":"27 pulgadas",
"curvatura":"1500R",
"tratamiento":"antideslumbrante",
"angulo_vision":"178º(H)/178º(V)",
"resolucion":"2560x1440",
"dimensiones":"611,5 x 225,4 x 457,9 mm / 24,07 x 8,87 x 18,03 pulgadas",
"aspecto":"16:9",
"brillo":"250 Nits",
"tasa_refresco":"170Hz",
"contraste":"3000:1",
"tiempo_respuesta":"1ms",
"colores":"1.07B",
"color":"negro",
"conectividad":"2x HDMI 2.0 / 1x DisplayPort / 1x Salida de Auriculares 3.5mm / Puertos de audio 1 salida de auriculares",
"alimentacion":"100~240V, 50~60Hz"}'
);




-- 3    Samsung Odyssey LC27G55TQBUXEN 27" LED WQHD 144Hz FreeSync Premium Curva
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
199.99,
'Samsung Odyssey LC27G55TQBUXEN 27" LED WQHD 144Hz FreeSync Premium Curva',
'/imagenes/periferico/monitor/Samsung Odyssey LC27G55TQBUXEN 27_ LED WQHD 144Hz FreeSync Premium Curva.jpeg',
'El monitor gaming LC27G55TQBUXEN de 27 pulgadas de Samsung ofrece una calidad de imagen nítida y clara, con una resolución de 2.560x1.440 píxeles. El panel VA de alta calidad proporciona una excelente calidad de imagen, con un tiempo de respuesta de 1 ms y una frecuencia de fotogramas nativa de 144 Hz. El monitor gaming de Samsung también cuenta con una pantalla curva, lo que le permite sumergirse en la acción de juego.',
10,
'periferico',
'monitor',
'{
"Diagonal de la pantalla": "68,6 cm (27\)",
"Resolución de la pantalla": "2560 x 1440 Pixeles",
"Tipo HD": "Wide Quad HD",
"Relación de aspecto nativa": "16:9",
"Tecnología de visualización": "LED",
"Tipo de pantalla": "VA",
"Brillo de la pantalla (típico)": "300 cd / m²",
"Tiempo de respuesta": "1 ms",
"Forma de la pantalla": "Curva",
"Color del producto": "Negro",
"Ethernet": "No",
"Clase de eficiencia energética (SDR)": "F",
"Clase de eficiencia energética (HDR)": "G",
"Consumo de energía (SDR) por 1000 horas": "24 kWh",
"Consumo de energía (HDR) por 1000 horas": "47 kWh",
"Ancho del paquete": "679 mm",
"Profundidad del paquete": "438 mm",
"Altura del paquete": "193 mm",
"Peso del paquete": "6,1 kg"
}'
);




-- 4    LG Ultragear 24GQ50F-B 24" LED FullHD 165Hz FreeSync Premium
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
159.99,
'LG Ultragear 24GQ50F-B 24" LED FullHD 165Hz FreeSync Premium',
'/imagenes/periferico/monitor/LG Ultragear 24GQ50F-B 24_ LED FullHD 165Hz FreeSync Premium.jpeg',
'Una velocidad ultrarrápida de 165Hz permite a los gamers ver el próximo frame rápidamente y hace que la imagen aparezca mucho más suave. Identifica más rápido a tus enemigos y apunta a tu objetivo más fácilmente. El tiempo de respuesta de 1ms, minimiza el efecto fantasma y te permite obtener la máxima velocidad de respuesta, para que disfrutes de tus videojuegos en un nivel gaming de alto desempeño.',
10,
'periferico',
'monitor',
'{
"Diagonal de la pantalla": "61 cm (24)",
"Resolución de la pantalla": "1920 x 1080 Pixeles",
"Tipo HD": "Full HD",
"Relación de aspecto nativa": "16:9",
"Tipo de pantalla": "VA",
"Tipo de retroiluminación": "LED",
"Pantalla táctil": "No",
"Brillo de la pantalla (típico)": "250 cd/m²",
"Tiempo de respuesta": "5ms (GtG at Faster), 1ms MBR",
"Pantalla antirreflectante": "Si",
"Forma de la pantalla": "Plana",
"Relación de aspecto": "16:9",
"Razón de contraste (típica)": "3000:1",
"Máxima velocidad de actualización": "165 Hz",
"HDMI": "Si",
"Número de puertos HDMI": "2",
"Versión HDMI": "1.4",
"Cantidad de DisplayPorts": "1",
"Versión de DisplayPort": "1.2",
"Entrada de audio": "No",
"Salida de auriculares": "Si",
"Clase de eficiencia energética (SDR)": "E",
"Consumo de energía (SDR) por 1000 horas": "17 kWh",
"Consumo energético": "24 W",
"Consumo de energía (inactivo)": "0,5 W",
"Ancho del dispositivo (con soporte)": "539,5 mm",
"Profundidad del dispositivo (con soporte)": "196 mm",
"Altura del dispositivo (con soporte)": "414,2 mm",
"Peso (con soporte)": "3,57 kg",
"Peso del paquete": "6,1 kg"

}'
);





-- 5    Lenovo L24e-30 23.8" LED FullHD FreeSync
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
99.99,
'Lenovo L24e-30 23.8" LED FullHD FreeSync',
'/imagenes/periferico/monitor/Lenovo L24e-30 23.8_ LED FullHD FreeSync.jpeg',
'El panel VA ultradelgado de 23,8 pulgadas del L24e-30 con un diseño casi sin bordes de 3 lados ofrece imágenes de calidad y un aspecto moderno. El L24e-30 ha adoptado un elegante soporte esculpido con soporte para teléfono y ranura para administración de cables. Los usuarios pueden sumergirse fácilmente en el entretenimiento con una frecuencia de actualización de 75 Hz y sincronización gratuita, mientras que la tecnología para el cuidado de la vista certificada Eye Comfort reduce la fatiga ocular incluso después de largas horas. Con el software Artery cargado, los usuarios pueden ajustar la configuración del monitor con la conveniente interfaz.',
10,
'periferico',
'monitor',
'{
"Tamaño de pantalla": "23,8",
"Área de visión": "527.04x296.46 mm",
"Alineación vertical del panel": "",
"Relación de aspecto": "16:9",
"Resolución": "1920 x 1080",
"Separación entre píxeles": "0,2745 x 0,2745 mm",
"Puntos / píxeles por pulgada": "93 ppp",
"Ángulo de visión (H / V)": "178/178",
"Tiempo de respuesta de píxeles": "4 ms (modo extremo) / 6 ms (modo normal)",
"Frecuencia de actualización": "75 Hz (solo para entrada HDMI)",
"Brillo": "250 nits",
"Relación de contraste": "3000:1",
"Color": "Negro Cuervo",
"Ancho del bisel lateral": "2,5 mm",
"Dimensiones con soporte (HxWxD)": "434.9x540.4x165.0 mm",
"Peso (incluido el soporte)": "8,42 lb / 3,82 kg"

}'
);




-- 6    ASUS TUF Gaming VG249Q1A 23.8" LED IPS FullHD 165Hz FreeSync Premium
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
169.99,
'ASUS TUF Gaming VG249Q1A 23.8" LED IPS FullHD 165Hz FreeSync Premium',
'/imagenes/periferico/monitor/ASUS TUF Gaming VG249Q1A 23.8_ LED IPS FullHD 165Hz FreeSync Premium.jpeg',
'TUF Gaming VG249Q1A es una pantalla IPS Full HD (1920 x 1080) de 23,8 pulgadas con una frecuencia de actualización ultrarrápida de 165Hz*. Diseñado para jugadores y otros que buscan un juego inmersivo, ofrece algunas especificaciones serias. Pero hay más ... Su función exclusiva ELMB presenta un tiempo de respuesta MPRT de 1 ms y tecnología Adaptive-Sync (FreeSync ™ Premium), para un juego extremadamente fluido sin desgarros ni tartamudeos.',
10,
'periferico',
'monitor',
'{
"Diagonal de la pantalla": "60,5 cm (23.8)",
"Brillo de la pantalla (típico)": "250 cd / m²",
"Resolución de la pantalla": "1920 x 1080 Pixeles",
"Relación de aspecto nativa": "16:9",
"Tiempo de respuesta": "1 ms",
"Tipo HD": "Full HD",
"Tecnología de visualización": "LED",
"Tipo de retroiluminación": "LED",
"Pantalla antirreflectante": "Si",
"Forma de la pantalla": "Plana",
"Formatos gráficos soportados": "1920 x 1080 (HD 1080)",
"Relación de aspecto": "16:9",
"Razón de contraste (típica)": "1000:1",
"Relación de contraste (dinámico)": "10000000:1",
"Nombre comercial de la relación de contraste dinámico": "SmartContrast",
"Máxima velocidad de actualización": "144hz overclockeable a 165hz*",
"Ángulo de visión, horizontal": "178°",
"Ángulo de visión, vertical": "178°",
"Número de colores de la pantalla": "16,7 millones de colores",
"Tipo de pantalla": "IPS",
"Tamaño de pixel": "0,2745 x 0,2745 mm",
"Intervalo de escaneado horizontal": "54 - 162 kHz",
"Intervalo de escaneado vertical": "48 - 165 Hz"

}'
);





-- 7    Nilox NXM24FHD01 24" LED FullHD 75Hz
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
94.99,
'Nilox NXM24FHD01 24" LED FullHD 75Hz',
'/imagenes/periferico/monitor/Nilox NXM24FHD01 24_ LED FullHD 75Hz.jpeg',
'Nilox ofrece el monitor de 24" con pantalla LED sin marco, puertos HDMI - VGA, resolución FULL HD y tecnología Low Blue Light.',
10,
'periferico',
'monitor',
'{
"Diagonal de la pantalla": "61 cm (24)",
"Brillo de la pantalla (típico)": "220 cd / m²",
"Resolución de la pantalla": "1920 x 1080 Pixeles",
"Relación de aspecto nativa": "16:9",
"Tiempo de respuesta": "5 ms",
"Tipo HD": "Full HD",
"Tecnología de visualización": "LED",
"Forma de la pantalla": "Plana",
"Máxima velocidad de actualización": "75 Hz",
"Tipo de pantalla": "VA",
"Conector USB incorporado": "No",
"Cantidad de puertos VGA (D-Sub)": "1",
"HDMI": "Si",
"Número de puertos HDMI": "1",
"Ancho del dispositivo (con soporte)": "538,9 mm",
"Profundidad dispositivo (con soporte)": "131,9 mm",
"Altura del dispositivo (con soporte)": "384,5 mm"

}'
);




-- 8    Gigabyte M32QC 31.5" LED QHD 170Hz FreeSync Premium Pro Curva
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
269.99,
'Gigabyte M32QC 31.5" LED QHD 170Hz FreeSync Premium Pro Curva',
'/imagenes/periferico/monitor/Gigabyte M32QC 31.5_ LED QHD 170Hz FreeSync Premium Pro Curva.jpeg',
'Como jugador invisible, a menudo se subestima al monitor. La verdad es que los monitores se forman como un efecto sinérgico y ofrecen el mejor rendimiento de los componentes de la PC. Los monitores para juegos de GIGABYTE ofrecen las mejores especificaciones y calidad, los usuarios pueden realmente disfrutar de un rendimiento de primer nivel sin necesidad de extravagancias.',
10,
'periferico',
'monitor',
'{
"Pantalla": "34 / No brillante",
"Tipo de panel": "VA / Curvo",
"Curvatura": "1500R",
"Resolución": "QHD (2560x1440)",
"Relación de aspecto": "16:9",
"Frecuencia de refresco": "165Hz (170Hz O.C)",
"Tiempo de respuesta": "1ms (MPRT)",
"Ángulo de visualización (H/V)": "178º / 178º",
"Brillo": "350 cd/m²",
"Contraste": "3000:1",
"Saturación de color": "DCI-P3: 94% / sRGB: 123%",
"Color": "8 bit",
"Tecnología VRR": "AMD FreeSync Premium Pro",
"Certificación HDR": "DisplayHDR 400",
"Tecnología Flicker-Free (anti parpadeo)": "Sí",
"Low Blue light": "Sí",
"PiP / PbP": "Sí, P2P",
"VESA": "100x100",
"Eficiencia energética": "Clase G",
  "HDMI": "2 x HDMI 2.0",
  "DisplayPort": "1 x DisplayPort 1.2 (HDR)",
  "USB Tipo C": "1 x USB Tipo C",
  "USB": "2 x USB 3.0",
  "Jack 3.5mm (Auriculares)": "1 x Jack 3.5mm (Auriculares)"
}'
);




-- 9    Samsung Essential Monitor LS24C310EAUXEN 24" LED IPS FullHD 75Hz FreeSync
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
95,
'Samsung Essential Monitor LS24C310EAUXEN 24" LED IPS FullHD 75Hz FreeSync',
'/imagenes/periferico/monitor/Samsung Essential Monitor LS24C310EAUXEN 24_ LED IPS FullHD 75Hz FreeSync.jpeg',
'Un diseño minimalista para la máxima concentración. La pantalla sin bisel de 3 lados brinda una estética limpia y moderna a cualquier espacio de trabajo. En la configuración de pantallas múltiples, los monitores parecen fusionarse entre sí, para una visualización continua y sin distracciones. Se mire como se mire, la experiencia visual no cambia.',
10,
'periferico',
'monitor',
'{
"Diagonal de la pantalla": "61 cm (24\)",
"Resolución de la pantalla": "1920 x 1080 Pixeles",
"Tipo HD": "Full HD",
"Relación de aspecto nativa": "16:9",
"Tecnología de visualización": "LED",
"Tipo de pantalla": "IPS",
"Pantalla táctil": "No",
"Brillo de la pantalla (típico)": "250 cd / m²",
"Tiempo de respuesta": "5 ms",
"Forma de la pantalla": "Plana",
"Razón de contraste (típica)": "1000:1",
"Máxima velocidad de actualización": "75 Hz",
"NVIDIA G-SYNC": "No",
"AMD FreeSync": "Si",
"Tecnología Flicker free (reduce el parpadeo de la pantalla)": "Si",
"Modo de juego": "Si",
"Conector USB incorporado": "No",
"Cantidad de puertos VGA (D-Sub)": "1",
"HDMI": "Si",
"Número de puertos HDMI": "1",
"Versión HDMI": "1.4",
"Salida de auriculares": "No",
"HDCP": "Si",
"HDCP versión": "1.2",
"Ancho del dispositivo (con soporte)": "539,5 mm",
"Profundidad dispositivo (con soporte)": "217,4 mm",
"Altura del dispositivo (con soporte)": "422,8 mm",
"Peso (con soporte)": "2,8 kg"

}'
);




-- 10    Philips 243V7QDSB 23.8" LED IPS FullHD
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
99.99,
'Philips 243V7QDSB 23.8" LED IPS FullHD',
'/imagenes/periferico/monitor/Philips 243V7QDSB 23.8_ LED IPS FullHD.jpeg',
'Philips 243V7QDSB es una amplia pantalla con imágenes impresionantes que se extienden de borde a borde sin dañar la vista con un diseño fino y compacto.',
10,
'periferico',
'monitor',
'{
"Diagonal de la pantalla": "60,5 cm (23.8\)",
"Resolución de la pantalla": "1920 x 1080 Píxeles",
"Tipo HD": "Full HD",
"Relación de aspecto nativa": "16:9",
"Tecnología de visualización": "LED",
"Tipo de pantalla": "IPS",
"Tipo de retroiluminación": "W-LED",
"Pantalla táctil": "No",
"Brillo de la pantalla (típico)": "250 cd/m²",
"Tiempo de respuesta": "4 ms",
"Superficie de la pantalla": "Mate",
"Pantalla antirreflectante": "Si",
"Forma de la pantalla": "Plana",
"Formatos gráficos soportados": "1920 x 1080 (HD 1080)",
"Relación de aspecto": "16:9",
"Razón de contraste (típica)": "1000:1",
"Relación de contraste (dinámico)": "10000000:1",
"Nombre comercial de la relación de contraste dinámico": "SmartContrast",
"Máxima velocidad de actualización": "75 Hz",
"Ancho del dispositivo (con soporte)": "540 mm",
"Profundidad del dispositivo (con soporte)": "209 mm",
"Altura del dispositivo (con soporte)": "415 mm",
"Peso (con soporte)": "3,5 kg"

}'
);



-- 11    MSI PRO MP243W 23.8" LED IPS FullHD 75Hz
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
109,
'MSI PRO MP243W 23.8" LED IPS FullHD 75Hz',
'/imagenes/periferico/monitor/MSI PRO MP243W 23.8_ LED IPS FullHD 75Hz.jpeg',
'MSI Eye Care: tecnología antiparpadeo + menos luz azul + pantalla antideslumbrante. Las tecnologías MSI Anti-Flicker, Less Blue Light y el panel antideslumbrante ayudan a proteger sus ojos durante períodos prolongados de visualización de datos e investigación.',
10,
'periferico',
'monitor',
'{
"tamaño del panel": "23.8\",
"resolución del panel": "1920 x 1080 (FHD)",
"tasa de actualización": "75Hz",
"tiempo de respuesta": "5ms (GTG)",
"panel tipo": "IPS",
"brillo (nits)": "250 cd/m2",
"ángulo de visión": "178°(H) / 178°(V)",
"relación de aspecto": "16:9",
"relación de contraste": "1000:1",
"rgb": "100% (CIE 1976)",
"área de visualización activa (mm)": "527.04 (H) x 296.46 (V)",
"paso de píxeles (H x V)": "0.2745 (H) x 0.2745 (V)",
"tratamiento superficial": "antideslumbrante",
"colores de la pantalla": "16.7M",
"bit de color": "8 bits",
"puertos de vídeo": "1x HDMI (1.4), 1x DP (1.2a)",
"puertos de audio": "1 salida de auriculares",
"bloqueo Kensington": "sí",
"altavoz": "2x 2W",
"montaje VESA": "75 x 75 mm",
"tipo de alimentación": "adaptador externo (12V 2.5A)",
"entrada de alimentación": "100~240V, 50~60Hz",
"ajuste (inclinación)": "-5° ~ 20°",
"dimensiones (An x Al x P)": "541.93 x 182.16 x 421.79 mm (21.34 x 7.17 x 16.61 pulgadas)",
"dimensiones de la caja (An x Al x P)": "605 x 116 x 407 mm (23.82 x 4.57 x 16.02 pulgadas)",
"peso (no / GW)": "2.95 kg (6.5 libras) / 4.15 kg (9.15 libras)"
}'
);




-- 12    Acer ED273 P 27" LED FullHD 165Hz FreeSync Premium Curva
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
189.90,
'Acer ED273 P 27" LED FullHD 165Hz FreeSync Premium Curva',
'/imagenes/periferico/monitor/Acer ED273 P 27_ LED FullHD 165Hz FreeSync Premium Curva.jpeg',
'Un monitor que ofrece un excepcional diseño curvado con una amplia gama de tecnologías de protección de la vista.',
10,
'periferico',
'monitor',
'{
"Tamaño de pantalla": "27\",
"Resolución Máxima": "1920 x 1080 a 165 Hz",
"Relación de aspecto": "16:9",
"Relación de contraste": "4000:1",
"Tiempo de respuesta": "1 ms VRB",
"Color admitido": "16.7 millones",
"Gestión de contraste adaptable (ACM)": "100.000.000:1",
"Brillo": "250 cd/m²",
"Tipo de iluminación": "LED",
"Ángulos de visión": "178° horizontales, 178° verticales",
"Tipo de panel": "VA (alineación vertical)",
"Puertos y Conectores": "HDMI® (1.4), (2.0), 1 Displayport (1.2), Auricular",
"Energía": "300 mW (Energía en espera), 300 mW (apagado), 42 W (potencia máxima), 26 W (encendido)",
"Color": "Negro",
"Compatible con VESA": "Sí (75x75mm)",
"Dimensiones (An. x Al. x Pr.)": "611mm x 363mm x 76mm, 611 mm x 456 mm x 199 mm (con soporte)",
"Peso (aproximado)": "3,30 kg"

}'
);















-- PPPPPPPPERIFÉRICOSSSSSSSSS >>>>>>>> AAAAAAAAAAAAURICULARESSSSSSSSS










-- 1    HyperX Cloud Flight Auriculares Gaming Inalámbricos
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
99.99,
'HyperX Cloud Flight Auriculares Gaming Inalámbricos',
'/imagenes/periferico/cascos/HyperX Cloud Flight Auriculares Gaming Inalámbricos.jpeg',
'Auriculares compatibles con PC, PS4 y PS4 Pro con una conexión inalámbrica de 2,4GHz. Los cascos para los oídos giran 90° y pueden apoyarse cómodamente alrededor del cuello durante las pausas; además, ofrecen controles muy prácticos para ajustar los efectos LED, el silencio del micrófono, el encendido y el volumen. El micrófono de cancelación de ruido extraíble te ayuda a garantizar que tus comunicaciones se oigan con total claridad y los Cloud Flight han recibido las certificaciones de TeamSpeak y Discord.',
10,
'periferico',
'cascos',
'{
"tipo": "circumaural",
"unidad_inalambrica": "20 Hz-20.000 Hz",
"unidad_analogica": "15 Hz-23.000 Hz",
"peso": "100g",
"peso_con_micro": "315g",
"vida_bateria": "30 horas -LED apagado / 18 horas -LED con modo de respiración / 13 horas -LED permanente / Alcance inalámbrico 2.4 GHz Hasta 20 metros",
"controlador": "Dinámico de 50 mm, con imanes de neodimio",
"impedancia": "32 ohms",
"color": "negro"
}'
);



-- 2    Corsair HS65 Surround Auriculares Gaming Multiplataforma 7.1 Blancos
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
69.99,
'Corsair HS65 Surround Auriculares Gaming Multiplataforma 7.1 Blancos',
'/imagenes/periferico/cascos/Corsair HS65 Surround Auriculares Gaming Multiplataforma 7.1 Blancos.jpeg',
'Los auriculares para juegos CORSAIR HS65 SURROUND ofrecen comodidad y sonido durante todo el día con almohadillas de memoria viscoelástica y polipiel, y sonido envolvente Dolby Audio 7.1 en PC y Mac, con la aportación del diseño ligero reforzado con aluminio.',
10,
'periferico',
'cascos',
'{
"tipo":"Omnidireccional",
"respuesta_frecuencia":"20 Hz - 20 kHz",
"unidad_analogica":"15 Hz-23.000 Hz",
"peso":"282g",
"sensibilidad":"114 dB (± 3 dB)",
"vida_bateria":"30 horas",
"transductores":"Neodimio personalizado de 50 mm",
"impedancia":"32 Ohms",
"dimensiones":"186 mm x 78 mm x 196 mm"
}'
);




-- 3    Tempest War Auriculares Gaming Inalámbricos Negros
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
27,
'Tempest War Auriculares Gaming Inalámbricos Negros',
'/imagenes/periferico/cascos/Tempest War Auriculares Gaming Inalámbricos Negros.jpeg',
'¿Sientes molestias con tus auriculares? Deja de buscar y descubre los nuevos Tempest War Earphones Wireless. Unos auriculares totalmente inalámbricos, ligeros y sofisticados que te ofrecen la ligereza y la calidad que tanto necesitas. Olvídate de los cables y pásate a la nueva generación de auriculares gaming.',
10,
'periferico',
'cascos',
'{
"Versión de Bluetooth": "5.1",
"Chipset": "Action",
"Batería Auricular": "40mAh",
"Batería Base": "300mAh",
"Distancia de transmisión": "10 Metros",
"Impedancia": "32 Ohms",
"Rango de frecuencia": "20 Hz-20 KHz",
"Tensión de funcionamiento": "3,7 V (3,3-4,2 V)",
"Tiempo de reproducción de música": "3 - 4 Horas",
"Tiempo de carga": "1-2 Horas",
"Tiempo de espera": "150 Horas",
"Puerto de carga": "Tipo-C",
"Compatibilidad": "HSP, HFP, A2DP, AVRCP"
}'
);




-- 4    Forgeon General Auriculares Gaming Inalámbricos PC PS4 PS5 Xbox Xbox X Switch Negros
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
159.99,
'Forgeon General Auriculares Gaming Inalámbricos PC/PS4/PS5/Xbox/Xbox X/Switch Negros',
'/imagenes/periferico/cascos/Forgeon General Auriculares Gaming Inalámbricos PC PS4 PS5 Xbox Xbox X Switch Negros.jpeg',
'Desde Forgeon presentamos los nuevos auriculares Forgeon General Wireless Headset 2,4 GHz. Unos auriculares con unos acabados de primera, acompañados de la más novedosa tecnología de triple conexión que te da la libertad que necesitas para jugar cómodamente. Esto unido a sus extras y a su peso de tan solo 350 g hace de estos auriculares imprescindibles en tu setup gaming ¡No te quedes sin ellos!',
10,
'periferico',
'cascos',
'{
"Modelo": "Forgeon GENERAL",
"Dimensiones": "197 x 170 x 95mm",
"Peso": "350g",
"Tipo de conexión": "Conexión 3.5mm jack combinado / 2.4Ghz con receptor / Bluethooth 4.0",
"Orejeras": "Piel sintética/Tela",
"Diadema": "Ajustable",
"Batería": "3.7V/1100mA / DC5V-2A",
"Entrada Carga": "DC5V-2A MicroUSB",
"Compatible": "Cable: PC/PS4/PS5/Xbox One/Xbox Series X&S/Nintendo Switch/Smartphone 2.4Ghz:PC",
"Dimensiones del altavoz": "?50mm",
"Sensibilidad del altavoz": "100 ?3dB",
"Impedancia del altavoz": "64 ?15% Ohm",
"Rango de frecuencia del altavoz": "20Hz-20KHz",
"Micrófono extraíble": "Si",
"Antipop": "Si",
"Sensibilidad del micrófono": "38±3dB",
"Impedancia del micrófono": "?2200Ohm"
}'
);




-- 5    Newskill Sobek Auriculares Gaming RGB 7.1 PlayStation/PC Negros
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
54.95,
'Newskill Sobek Auriculares Gaming RGB 7.1 PlayStation/PC Negros',
'/imagenes/periferico/cascos/Newskill Sobek Auriculares Gaming RGB 7.1 PlayStation PC Negros.jpeg',
'Los auriculares gaming Sobek combinan las mejores prestaciones en cuanto a sonido, con sus altavoces acolchados de 40mm y su micro omnidireccional flexible, que hará que tu voz se escuche de manera totalmente clara. Además, su estilizado diseño está complementado con el mejor toque gamer, gracias a su iluminación RGB. Los auriculares gaming que realmente mereces.',
10,
'periferico',
'cascos',
'{
    "Dimensiones de altavoces": "40 mm",
    "Impedancia": "32±15%",
    "Sensibilidad": "96±4dB",
    "Frecuencia de respuesta": "20Hz-20,000Hz",
    "Potencia nominal": "15mW",
    "Capacidad de energía": "100mW",
    "Longitud del cable": "2.4M",
    "Tipo de conectores": "USB -- Cable de extensión * 1",
    "Micrófono": "6*2.7mm",
    "Directividad del micrófono": "Omnidireccional",
    "Sensibilidad del micrófono": "-42±4dB",
    "Frecuencia de respuesta del micrófono": "50Hz-10,000Hz",
    "Voltaje de funcionamiento estándar": "3V"
}'
);




-- 6    Logitech G435 LIGHTSPEED Auriculares Gaming Inalámbricos Negros
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
54.90,
'Logitech G435 LIGHTSPEED Auriculares Gaming Inalámbricos Negros',
'/imagenes/periferico/cascos/Logitech G435 LIGHTSPEED Auriculares Gaming Inalámbricos Negros.jpeg',
'La conectividad inalámbrica LIGHTSPEED y la conectividad Bluetooth de baja latencia te permiten jugar y hablar en PC, Mac, PS5/PS4, smartphones y otros dispositivos con audio Bluetooth. El sonido de calidad para gaming, el audio de gran fidelidad cuidadosamente equilibrado, los drivers de audio de 40 mm y la compatibilidad con Dolby Atmos y Windows Sonic proporcionan el sonido envolvente definitivo para todas tus aventuras de gaming. Con micrófonos duales beamforming para reducir el ruido de fondo sin necesidad de un brazo de micrófono. Además, G435 está disponible en varios colores para que puedas combinar tu estilo favorito con tu entorno de juego.',
10,
'periferico',
'cascos',
'{
    "Peso": "165 g",
    "Dimensiones (posición más pequeña)": "163 x 170 x 71 mm",
    "Driver": "driver de audio de 40 mm",
    "Respuesta en frecuencia": "20 Hz - 20 KHz",
    "Impedancia": "45 Ohms (pasivo)",
    "Sensibilidad": "83,1 dB SPL/mW",
    "Patrón de captación del micrófono": "formación de doble haz",
    "Respuesta de frecuencia del micrófono": "100 Hz - 8 KHz",
    "Alcance inalámbrico": "hasta 10 m a través del receptor USB LIGHTSPEED o Bluetooth",
    "Batería recargable": "puerto de carga USB-C",
    "Cable de carga": "USB-A a USB-C",
    "Tiempo de reproducción": "18 horas"
}'
);





-- 7    Owlotech Ear Office Next Auriculares con Micrófono Negros
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
7.99,
'Owlotech Ear Office Next Auriculares con Micrófono Negros',
'/imagenes/periferico/cascos/Owlotech Ear Office Next Auriculares con Micrófono Negros.jpeg',
'Presentamos los nuevos auriculares Owlotech Ear Office, la nueva generación de auriculares. Unos auriculares fabricados exclusivamente para ti, con unos acabados únicos y formidables que harán que se adapten perfectamente a tu cabeza. Su diámetro de altavoz te proporcionará la potencia que siempre buscabas. No lo pienses más y disfruta de la verdadera experiencia de sonido.',
10,
'periferico',
'cascos',
'{
    "Rango de frecuencia": "20-20 KHz",
    "Micrófono":"móvil",
    "Conexión jack":"3.5mm x2",
    "Longitud del cable": "2,0 M",
    "Diámetro del altavoz": "40/32",
    "Dimensiones producto": "16x7.3x19.6cm",
    "Dimensiones caja": "17.5x18.6x8cm"
}'
);






-- 8      Razer Kraken X Lite Auriculares Gaming 7.1 Multiplataforma
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
30.99,
'Razer Kraken X Lite Auriculares Gaming 7.1 Multiplataforma',
'/imagenes/periferico/cascos/Razer Kraken X Lite Auriculares Gaming 7.1 Multiplataforma.jpeg',
'Comodidad ultraligera para jugar sin parar. Nunca más volverás a estar agotado por el peso de tus auriculares. El Razer Kraken X Lite está diseñado para ser ultraligero, por lo que apenas sientes que tienes algo en la cabeza, incluso cuando experimentas un audio de juego superior para una experiencia realmente envolvente.',
10,
'periferico',
'cascos',
'{
    "Respuesta de frecuencia": "12 Hz - 28 kHz",
    "Impedancia": "32 Ohm @ 1 kHz",
    "Sensibilidad (@ 1 kHz)": "TBD",
    "Controladores": "40 mm, con imanes de neodimio",
    "Diámetro interno del audífono": "65 x 44 mm",
    "Tipo de conexión": "analógico 3.5 mm",
    "Longitud del cable": "1.3 m / 4.27 pies",
    "Aprox. peso": "230g / 0.50lbs",
    "Almohadillas ovales": "diseñadas para una cobertura total de la oreja con cuero sintético, para aislamiento y comodidad del sonido",
    "Respuesta de frecuencia": "100 Hz - 10 kHz",
    "Relación señal / ruido": "60 dB",
    "Sensibilidad (@ 1 kHz)": "-45 ± 3 dB",
    "Patrón de recogida": "auge de ECM unidireccional"
}'
);






-- 9      Owlotech Ear Operator PRO Auriculares con Micrófono
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
21.99,
'Owlotech Ear Operator PRO Auriculares con Micrófono',
'/imagenes/periferico/cascos/Owlotech Ear Operator PRO Auriculares con Micrófono.jpeg',
'Llegan al mercado, de parte de Owlotech, los nuevos Owlotech Ear Operator. Estos auriculares, están preparados para cualquier situación o circunstancia. Puedes utilizarlo para tus reuniones de teletrabajo actuales o incluso para stremear como los verdaderos profesionales. Owlotech siempre está en primera línea y con esta apuesta, te garantiza una calidad a un precio increíble. ',
10,
'periferico',
'cascos',
'{
    "Diámetro": "30/40 mm",
    "Impedancia": "32 Ohm",
    "Sensibilidad": "110dB",
    "Nivel de ruido": "<-78dBA",
    "Rango dinámico": ">78dBA",
    "Distorsión THD": "<0.1%",
    "CrossTalk estéreo": "<-52dBA",
    "Respuesta de frecuencia": "20-20 K Hz",
    "Dimensiones": "4 * 1,5 mm",
    "Sensibilidad": "-58dB",
    "Direccionalidad": "omnidireccional",
    "Impedancia": "2,2 kO",
    "Respuesta de frecuencia": "50-15 K Hz",
    "Longitud del cable": "2 m",
    "Material de las orejeras": "PU"
}'
);



-- 10     Razer Kraken Mercury Auriculares Gaming
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
75,
'Razer Kraken Mercury Auriculares Gaming',
'/imagenes/periferico/cascos/Razer Kraken Mercury Auriculares Gaming.jpeg',
'Razer Kraken, los auriculares gaming han evolucionado. Desde su inicio, el Razer Kraken ha construido una reputación como un clásico de culto dentro de la comunidad de juegos. Hizo su marca como un elemento básico en innumerables eventos de juegos, convenciones y torneos. Ahora hemos mejorado las características de esta multitud favorita, no solo para mejorar la calidad de audio sino también para hacerla más cómoda para que puedas jugar todo el día con los auriculares que te encantan. Este es el nuevo Razer Kraken.',
10,
'periferico',
'cascos',
'{
    "Tecnología de conectividad": "Alámbrico",
    "Conector de 3,5 mm": "No",
    "Conector de 2,5 mm": "No",
    "Bluetooth": "No",
    "Longitud de cable": "1,3 m",
    "Respuesta de frecuencia": "100 Hz - 10 kHz",
    "Relación señal / ruido": "> 60 dB",
    "Sensibilidad de micrófono": "-42 dB",
    "Patrón de pick-up": "boom ECM unidireccional",
    "Efecto de cancelación de ruido": "Si",
    "Micrófono mudo": "Si",
    "Audífonos": "Supraaural",
    "Frecuencia de auricular": "12 - 28000 Hz",
    "Impedancia": "32 oHm @ 1 kHz",
    "Sensibilidad de auricular": "109 dB",
    "Tipo de imán": "Neodimio",
    "Potencia de entrada": "30 mW (Max)",
    "Conductores": "50 mm, con imanes de neodimio",
    "Diámetro de la oreja interna": "54 mm x 65 mm",
    "Tipo de conexión": "Analógico 3.5 mm",
    "Longitud del cable": "1.3 m / 4.27 ft",
    "Aprox. peso": "322 g / 0.71 libras"
}'
);






-- 11     Blackfire BFX-R80 Auriculares Gaming PS4 PS5
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
30.99,
'Blackfire BFX-R80 Auriculares Gaming PS4/PS5',
'/imagenes/periferico/cascos/Blackfire BFX-R80 Auriculares Gaming PS4 PS5.jpeg',
'Auriculares gaming Blackfire BFX-R80 compatibles con los mandos DualSense™ y DualShock™4 de PS5 y PS4 respectivamente. Con un diseño acolchado para mayor comodidad y micrófono ajustable que además, podrás silenciar cuando no lo necesites.',
10,
'periferico',
'cascos',
'{
    "Color": "Negro",
    "Material": "Símil Piel",
    "Compatibilidad": "Mandos DualSense™ y DualShock™4",
    "Micrófono": "Si",
    "Controles": "Si, en el cable",
    "Conector": "3.5 mm",
    "Longitud": "1.10 m"
}'
);




-- 12     Steelseires Arctis 5 Auriculares Gaming RGB Negros
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
92.99,
'Steelseires Arctis 5 Auriculares Gaming RGB Negros',
'/imagenes/periferico/cascos/Steelseires Arctis 5 Auriculares Gaming RGB Negros.jpeg',
'Diseñado específicamente para PC Gamer, Arctis 5 combina un juego independiente y control de chat, sonido envolvente DTS de última generación e iluminación RGB de doble zona para crear la solución de audio perfecta para su estación de batalla.',
10,
'periferico',
'cascos',
'{
    "Audifonos": "Circumaural",
    "Frecuencia de auricular": "20 - 22000 Hz",
    "Obstrucción": "32 Ohm",
    "Sensibilidad de auricular": "98 dB",
    "Tipo de imán": "Neodimio",
    "Unidad de disco": "4 cm",
    "THD, distorción armónica total": "3%",
    "Frecuencia de micrófono": "100 - 10000 Hz",
    "Sensibilidad de micrófono": "-48 dB",
    "Micrófono, impedancia de salida": "2200 Ohm",
    "Efecto de cancelación de ruido": "Si",
    "Tipo de dirección de micrófono": "Micrófono bidireccional",
    "Tecnología de conectividad": "Alámbrico",
    "Conector de 3,5 mm": "Si",
    "Conexión USB": "Si",
    "Bluetooth": "No"
}'
);








-- TEEEELEEEVVVIIIIIISOOOOORREEEESSSS








-- 1     Toshiba 55UA3D63DG 55" DLED UltraHD 4K HDR
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
352.99,
'Toshiba 55UA3D63DG 55" DLED UltraHD 4K HDR',
'/imagenes/televisor/Toshiba 55UA3D63DG 55_ DLED UltraHD 4K HDR.jpeg',
'Nuestra gama de televisores Premium 4K le ofrece la experiencia cinematográfica definitiva con una resolución 4K evolucionada con la tecnología Wide Colour Gamut, que brinda colores adicionales para disfrutar de imágenes de máximo realismo.',
10,
'televisor',
'televisor',
'{
    "Tamaño de pantalla (cm y pulg)": "55 139 cm",
    "Tipo Panel": "Direct Back Light (DLED)",
    "Resolución": "Ultra HD (3840 x 2160)",
    "Brillo": "350",
    "Salida de Sonido Digital": "Óptico",
    "CI+": "Si",
    "HDMI™": "3",
    "USB": "2",
    "Clase energética (HDR)": "G",
    "Consumo de energía (HDR)": "123 kW/1000h",
    "Consumo de energía en modo en espera (Promedio)": "<0.5 W",
    "Dimensiones con la caja": "1369 x 154 x 860 mm",
    "Dimensiones sin la caja": "1243 x 249 x 755 mm",
    "Dimensiones sin el soporte": "1243 x 81 x 720 mm",
    "Peso total": "21 kg"
}'
);





-- 2     Xiaomi TV Q2 65” QLED UltraHD 4K HDR10
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
728.50,
'Xiaomi TV Q2 65” QLED UltraHD 4K HDR10',
'/imagenes/televisor/Xiaomi TV Q2 65” QLED UltraHD 4K HDR10.jpeg',
'Equipado con la innovadora tecnología de visualización de puntos cuánticos, el Xiaomi TV Q2 da vida a los colores. Con una mayor cobertura de la gama de colores y una pantalla de mil millones de colores, podrás disfrutar de una calidad de imagen asombrosa desde la comodidad de tu salón.',
10,
'televisor',
'televisor',
'{
    "Diagonal de la pantalla": "65",
    "Tipo HD": "4K Ultra HD",
    "Tecnología de visualización": "QLED",
    "Forma de la pantalla": "Plana",
    "Relación de aspecto nativa": "16:9",
    "Formatos gráficos soportados": "3840 x 2160",
    "Ethernet LAN (RJ-45) cantidad de puertos": "1",
    "Cantidad de puertos USB 2.0": "2",
    "Entrada de video compuesto": "1",
    "Consumo energético": "140 W",
    "Voltaje de entrada AC": "200 - 240 V",
    "Frecuencia de entrada AC": "50/60 Hz",
    "Dimensiones, incluida la base (L x An x Al)": "1450,5 x 318,8 x 907,5 mm",
    "Dimensiones sin incluir la base (L x An x Al)": "1450,5 x 87,3 x 843,7 mm",
    "Tamaño del embalaje (L x An x Al)": "1600 x 164 x 960 mm"
}'
);




-- 3     LG 32LQ631C 32" LED FullHD HDR
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
205,
'LG 32LQ631C 32" LED FullHD HDR',
'/imagenes/televisor/LG 32LQ631C 32_ LED FullHD HDR.jpeg',
'Nuevo televisor 32LQ631C de LG, su pantalla Full HD ofrece imágenes precisas con una resolución extraordinaria y colores ricos.',
10,
'televisor',
'televisor',
'{
    "Formatos gráficos soportados": "1920 x 1080 (HD 1080)",
    "Frecuencia nativa de refresco": "60 Hz",
    "Resolución de la pantalla": "1920 x 1080 Pixeles",
    "Versión HDMI": "1.4",
    "Canal de retorno de audio (ARC)": "Si",
    "Ethernet LAN (RJ-45) cantidad de puertos": "1",
    "Clase de eficiencia energética (SDR)": "G",
    "Consumo de energía (SDR) por 1000 horas": "33 kWh",
    "Consumo de energía (inactivo)": "0,5 W",
    "Voltaje de entrada AC": "100 - 240 V",
    "Frecuencia de entrada AC": "50/60 Hz",
    "Ancho del dispositivo (con soporte)": "812 mm",
    "Profundidad del dispositivo (con soporte)": "142 mm",
    "Altura del dispositivo (con soporte)": "510 mm",
    "Peso (con soporte)": "4,7 kg"
}'
);



-- 4     LG 43NANO766QA 43" LED NanoCell UltraHD 4K HDR10 Pro
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
427.99,
'LG 43NANO766QA 43" LED NanoCell UltraHD 4K HDR10 Pro',
'/imagenes/televisor/LG 43NANO766QA 43_ LED NanoCell UltraHD 4K HDR10 Pro.jpeg',
'La tecnología LG NanoCell utiliza nanopartículas para filtrar los colores impuros de las longitudes de onda RGB.',
10,
'televisor',
'televisor',
'{
    "Pulgadas": "43",
    "cm": "108",
    "Resolución":"UHD 4K",
    "Resolución Píxeles": "3840*2160",
    "Panel": "4K NanoCell",
    "Refresco de Pantalla": "50Hz",
    "Color Frontal": "Cinema Screen Azul Oscuro Ceniza",
    "Color Trasera": "Oscuro",
    "Peana": "Peana Central Oscura",
    "Dimensiones Sin Peana / VESA": "967x564x57.7mm. 9.2Kg. VESA: 200x200",
    "Dimensiones con Peana": "967x629x249mm. 10.3Kg"
}'
);




-- 5     LG 50UQ81003LB 50" LED UltraHD 4K HDR10 Pro
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
470.99,
'LG 50UQ81003LB 50" LED UltraHD 4K HDR10 Pro',
'/imagenes/televisor/LG 50UQ81003LB 50_ LED UltraHD 4K HDR10 Pro.jpeg',
'Smart TV fácil, intuitivo y con Inteligencia Artificial. Los televisores UHD de LG mejoran tu experiencia audiovisual. Disfruta de colores vivos y de un mayor número de detalles en 4K. Disfruta de los TVs UHD de LG como nunca antes lo habías hecho. Disfruta de tus contenidos favoritos en las pantallas 4K de gran pulgada de los TVs UHD de LG. Ajuste perfecto con tu hogar. Los TVs UHD de LG ahora cuentan con un diseño más fino para que encajen a la perfección en tu hogar.',
10,
'televisor',
'televisor',
'{
    "Diagonal de la pantalla": "(50) 126cm",
    "Tipo HD": "4K Ultra HD",
    "Tecnología de visualización": "LCD",
    "Tipo de retroiluminación LED": "Direct-LED",
    "Forma de la pantalla": "Plana",
    "Relación de aspecto nativa": "16:9",
    "Control automático del brillo": "Si",
    "Frecuencia nativa de refresco": "60 Hz",
    "Resolución de la pantalla": "3840 x 2160 Pixeles",
    "Versión HDMI": "2.0",
    "Canal de retorno de audio (ARC)": "Si",
    "Ethernet LAN (RJ-45) cantidad de puertos": "1",
    "Cantidad de puertos USB 2.0": "2",
    "Audio digital, salida óptica": "1",
    "Número de puertos RF": "1",
    "Dimensiones sin soporte (An x Al x Pr en cm)": "112,1x65,1x5,71"
}'
);



-- 6     LG OLED48C24LA 48" OLED 4K HDR10 Pro
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
999,
'LG OLED48C24LA 48" OLED 4K HDR10 Pro',
'/imagenes/televisor/LG OLED48C24LA 48_ OLED 4K HDR10 Pro.jpeg',
'Realza la vívida belleza de los píxeles autoiluminados OLED de LG. Brightness Booster lleva los refinamientos del procesador ?9 Gen 5 AI al siguiente nivel, brindando hasta un 20% 2 más de luminancia. Ahora, las imágenes se ven más audaces con una eficiencia de luz superior.',
10,
'televisor',
'televisor',
'{
    "Diagonal de la pantalla": "121,9 cm (48)",
    "Tipo HD": "4K Ultra HD",
    "Tecnología de visualización": "OLED",
    "Forma de la pantalla": "Plana",
    "Relación de aspecto nativa": "16:9",
    "Frecuencia nativa de refresco": "120 Hz",
    "Resolución de la pantalla": "3840 x 2160 Pixeles",
    "Diagonal de pantalla": "121,92 cm",
    "Versión HDMI": "2.1",
    "Ethernet LAN (RJ-45) cantidad de puertos": "1",
    "Cantidad de puertos USB 2.0": "3",
    "Consumo de energía (SDR) por 1000 horas": "66 kWh",
    "Consumo de energía (HDR) por 1000 horas": "120 kWh",
    "Consumo de energía (inactivo)": "0,5 W",
    "Voltaje de entrada AC": "100 - 240 V",
    "Frecuencia de entrada AC": "50/60 Hz"
}'
);





-- 7     LG OLED77C17LB 77" OLED UltraHD 4K HDR10 Pro
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
2729,
'LG OLED77C17LB 77" OLED UltraHD 4K HDR10 Pro',
'/imagenes/televisor/LG OLED77C17LB 77_ OLED UltraHD 4K HDR10 Pro.jpeg',
'El LG OLED TV es un placer para la vista. Gracias a los píxeles autoiluminiscentes, la calidad de imagen es espectacular y las posibilidades de diseño son infinitas; además, las últimas tecnologías de vanguardia te ofrecen unos niveles de sorpresa sin precedentes. Todo lo que deseas de un televisor en todos los sentidos.',
10,
'televisor',
'televisor',
'{
    "Diagonal de la pantalla": "195,6 cm (77)",
    "Tipo HD": "4K Ultra HD",
    "Tecnología de visualización": "OLED",
    "Forma de la pantalla": "Plana",
    "Relación de aspecto nativa": "16:9",
    "Frecuencia nativa de refresco": "120 Hz",
    "Resolución de la pantalla": "3840 x 2160 Pixeles",
    "Diagonal de pantalla": "195 cm",
    "Wifi": "Si",
    "Ethernet": "Si",
    "Wi-Fi estándares": "Wi-Fi 5 (802.11ac)",
    "Bluetooth": "Si",
    "Versión de Bluetooth": "5.0",
    "Bluetooth de baja energía (BLE, Bluetooth Low Energy)": "Si",
    "Miracast": "Si",
    "Navegador web": "Si",
    "Ancho del dispositivo (con soporte)": "1723 mm",
    "Profundidad dispositivo (con soporte)": "269 mm",
    "Altura del dispositivo (con soporte)": "1023 mm",
    "Peso (con soporte)": "35,9 kg"
}'
);




-- 8     Philips The One 43PUS8887/12 43" LED UltraHD 4K HDR10+
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
649,
'Philips The One 43PUS8887/12 43" LED UltraHD 4K HDR10+',
'/imagenes/televisor/Philips The One 43PUS888712 43_ LED UltraHD 4K HDR10+.jpeg',
'Philips The One PUS8887 es la elección inteligente. Disfruta de lo que más te gusta en magnífico 4K. Juega hasta hartarte. Conecta fácilmente una barra de sonido y unos altavoces para disfrutar más de tu música. Además, disfruta de una experiencia envolvente sin igual gracias a Ambilight.',
10,
'televisor',
'televisor',
'{
    "Diagonal de la pantalla": "109.2 cm (43)",
    "Tipo HD": "4K Ultra HD",
    "Tecnología de visualización": "LED",
    "Forma de la pantalla": "Plana",
    "Relación de aspecto nativa": "16:9",
    "Frecuencia nativa de refresco": "120 Hz",
    "Resolución de la pantalla": "3840 x 2160 Pixeles",
    "Diagonal de pantalla": "108 cm",
    "Wifi": "Si",
    "Ethernet": "Si",
    "Wi-Fi estándares": "Wi-Fi 5 (802.11ac)",
    "Bluetooth": "Si",
    "Versión de Bluetooth": "5.0",
    "Navegación": "Si",
    "Navegador web": "Si",
    "Ancho del dispositivo (con soporte)": "962.8 mm",
    "Profundidad dispositivo (con soporte)": "220.2 mm",
    "Altura del dispositivo (con soporte)": "628.2 mm",
    "Peso (con soporte)": "10.8 kg"
}'
);




-- 9     TCL 43P631 43" LED UltraHD 4K Google TV
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
291.99,
'TCL 43P631 43" LED UltraHD 4K Google TV',
'/imagenes/televisor/TCL 43P631 43_ LED UltraHD 4K Google TV.jpeg',
'¡Con este televisor 4K, disfruta de una experiencia visual excepcional! ¡La tecnología de TV 4K Ultra HD le brinda una calidad de imagen superior con un contraste y una nitidez sin precedentes!',
10,
'televisor',
'televisor',
'{
    "Tamaño de pantalla (pulgadas/cm)": "43 / 109.2",
    "Tamaño de pantalla perceptible: diagonal (pulgadas/cm)": "43 / 108",
    "Resolución del panel": "UHD",
    "Tecnología": "Wide Color Dynamic color",
    "Formato HDR": "HDR10, HLG",
    "Índice de calidad de imagen": "2300",
    "Resolución": "3840x2160",
    "Tamaño del producto": "958 / 610 / 251 mm",
    "HDMI": "3 x 2.1",
    "HDCP 2.2": "2.3",
    "USB": "1 x 2.0",
    "YPbPr CVBS": "Opcional",
    "Ethernet (LAN RJ-45)": "Si",
    "Wifi": "Built-in ac/n/g 2.4/5Ghz MIMO",
    "Salida de sonido": "Digital Optical",
    "Auricular": "Si"
}'
);




-- 10    Nilait Luxe NI-50UB8001SE 50" QLED UltraHD 4K HDR10 Smart TV
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
375.90,
'Nilait Luxe NI-50UB8001SE 50" QLED UltraHD 4K HDR10 Smart TV',
'/imagenes/televisor/Nilait Luxe NI-50UB8001SE 50_ QLED UltraHD 4K HDR10 Smart TV.jpeg',
'¡Bienvenido al mundo de la tecnología avanzada en televisores! Presentamos la televisión Nilait Luxe NI-50UB8001SE, un televisor de última generación con pantalla QLED UHD 4K Smart TV de 50 pulgadas. Disfruta de la mejor calidad de imagen con una resolución cuatro veces superior a los modelos Full HD convencionales, que te brinda detalles y colores más vívidos y realistas. La tecnología QLED mejora el brillo y el contraste, haciendo que los blancos sean más brillantes y los negros más oscuros, creando una imagen más nítida y detallada. ',
10,
'televisor',
'televisor',
'{
    "Diagonal de la pantalla": "126cm (50)",
    "Tipo HD": "4K Ultra HD",
    "Resolución de la pantalla": "3840 x 2160 Pixeles",
    "Ángulo de visión, horizontal": "178°",
    "Ángulo de visión, vertical": "178°",
    "Relación de contraste estático": "1500:1",
    "Brillo (Nits)": "250 cd / m²",
    "DCI-P3 Color Gamut": "95",
    "Tecnología de visualización": "QLED",
    "Tipo de retroiluminación LED": "QLED",
    "Forma de la pantalla": "Plana",
    "Frecuencia de actualización": "50 Hz",
    "Puerto USB 2.0": "2",
    "Puerto HDMI 2.1": "3",
    "Clase de eficiencia de energía": "E",
    "Consumo energético": "54 kWh/1000h",
    "Voltaje de entrada AC": "220 - 240 V",
    "Frecuencia de entrada AC": "50 Hz"
}'
);





-- 11    Samsung Series 6 QE43Q60BAU 43" QLED UltraHD 4K Quantum HDR
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
429.99,
'Samsung Series 6 QE43Q60BAU 43" QLED UltraHD 4K Quantum HDR',
'/imagenes/televisor/Samsung Series 6 QE43Q60BAU 43_ QLED UltraHD 4K Quantum HDR.jpeg',
'Convierte la luz en más de 1.000 millones de colores, a cualquier nivel de brillo, con la tecnología inorgánica Quantum dot, exclusiva de Samsung.',
10,
'televisor',
'televisor',
'{
    "Diagonal de la pantalla": "109,2 cm (43)",
    "Tipo HD": "4K Ultra HD",
    "Tecnología de visualización": "QLED",
    "Forma de la pantalla": "Plana",
    "Relación de aspecto nativa": "16:9",
    "Tecnología de interpolación de movimiento": "PQI (Picture Quality Index) 3100",
    "Resolución de la pantalla": "3840 x 2160 Pixeles",
    "Diagonal de pantalla": "108 cm",
    "Wifi": "Si",
    "Ethernet": "Si",
    "Wi-Fi estándares": "Wi-Fi 5 (802.11ac)",
    "Bluetooth": "Si",
    "Cambio rápido entre entradas HDMI": "Si",
    "Ethernet LAN (RJ-45) cantidad de puertos": "1",
    "Cantidad de puertos USB 2.0": "2",
    "Ancho del dispositivo (con soporte)": "965,5 mm",
    "Profundidad dispositivo (con soporte)": "598,1 mm",
    "Altura del dispositivo (con soporte)": "181 mm",
    "Peso (con soporte)": "8,6 kg"
}'
);




-- 12    Hisense 32A4BG 32" DLED HD
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
429.99,
'Hisense 32A4BG 32" DLED HD',
'/imagenes/televisor/Hisense 32A4BG 32_ DLED HD.jpeg',
'Televisor DLED Smart TV Hisense 32A4BG con resolución HD (1366 x 768 píxeles), WiFi y Sonido DTS Virtual X.',
10,
'televisor',
'televisor',
'{
    "Diagonal de la pantalla": "81,3 cm (32)",
    "Tipo HD": "HD",
    "Tecnología de visualización": "LED",
    "Tipo de retroiluminación LED": "Direct-LED",
    "Forma de la pantalla": "Plana",
    "Relación de aspecto nativa": "16:9",
    "Formato de pantalla, ajustes": "16:9",
    "Formatos gráficos soportados": "1366 x 768",
    "Brillo de pantalla": "180 cd/m²",
    "Tiempo de respuesta": "8,5 ms",
    "Tecnología de interpolación de movimiento": "PCI (Picture Criteria Index) 600",
    "Frecuencia nativa de refresco": "60 Hz",
    "Versión HDMI": "2.0",
    "Cantidad de puertos USB 2.0": "2",
    "Ancho del dispositivo (con soporte)": "717 mm",
    "Profundidad del dispositivo (con soporte)": "160 mm",
    "Altura del dispositivo (con soporte)": "469 mm",
    "Peso (con soporte)": "3,9 kg"
}'
);















-- COOOOONSOLLLLAAAAAA >>>> PLLLLLAAAAAYSTATIOOOOONNNNNNN







-- 1    Sony PlayStation 5 Chassis B
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
549.95,
'Sony PlayStation 5 Chassis B',
'/imagenes/consola/playstation/Sony PlayStation 5 Chassis B.jpeg',
'PlayStation® 5: Jugar no tiene límites. Experimenta cargas superrápidas gracias a una unidad de estado sólido (SSD) de alta velocidad, una inmersión más profunda con retroalimentación háptica, gatillos adaptables y audio 3D.',
10,
'consola',
'playstation',
'{"memoria_ram":"16GB GDDR6",
"procesador":"AMD Ryzen Zen 2 3.5GHz",
"nucleos":"8",
"graficos":"AMD Radeon 2230MHz",
"color":"blanco",
"almacenamiento":"825GB SSD",
"conexion":" 1X HDM1 / 1x Puerto USB tipo A 3.2 Gen 1 / 1x Puerto USB tipo C 3.2 Gen 1",
"dimensiones":"Ancho 104 mm / Profundidad 260 mm / Altura 390 mm",
"peso":"4.5kg",
"fuente_alimentacion":"350W",
"formato_video":"2160p / 4320p"}'
);


-- 2    Sony PlayStation 4 Slim (Chasis F) 500GB
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
382.08,
'Sony PlayStation 4 Slim (Chasis F) 500GB',
'/imagenes/consola/playstation/Sony PlayStation 4 Slim (Chasis F) 500GB.jpeg',
'Una PS4 renovada y más pequeña. Disfruta de colores increíblemente vivos y brillantes con asombrosos gráficos HDR.',
10,
'consola',
'playstation',
'{"memoria_ram":"GDDR5 8GB",
"graficos":"1.84 TFLOPS, AMD unidad de procesamiento gráfico de próxima generación basada en Radeon",
"nucleos":"8",
"procesador":"x86-64 AMD",
"color":"negro",
"almacenamiento":"500GB",
"conexion":" 1X HDM1 / 1x Puerto USB de alta velocidad / 1x Puerto USB 3.0 / 1x Puerto AUX / DVD 8xCAV",
"dimensiones":" 265 × 39 × 288 mm",
"peso":"4.5kg",
"fuente_alimentacion":"240W",
"formato_video":"2160p"}'
);




-- 3     Sony PlayStation 5 Chasis C
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
549,
'Sony PlayStation 4 Slim (Chasis F) 500GB',
'/imagenes/consola/playstation/Sony PlayStation 5 Chasis C.jpeg',
'PlayStation® 5: Jugar no tiene límites. Experimenta cargas superrápidas gracias a una unidad de estado sólido (SSD) de alta velocidad, una inmersión más profunda con retroalimentación háptica, gatillos adaptables y audio 3D, además de una nueva generación de increíbles juegos de PlayStation®.',
10,
'consola',
'playstation',
'{
"Memoria interna":"16000 MB",
"Tipo de memoria interna":"GDDR6",
"Fabricante de procesador":"AMD",
"Modelo del procesador":"AMD Ryzen Zen 2",
"Frecuencia del procesador":"3,5 GHz",
"Número de núcleos de procesador":"8",
"Procesador gráfico":"AMD Radeon",
"Frecuencia del procesador gráfico":"2230 MHz",
"Rendimiento del procesador gráfico":"10,3 TFLOPS",
"Color del producto":"Negro, Blanco",
"Fuente de alimentación":"350 W",
"Ancho":"104 mm",
"Profundidad":"260 mm",
"Altura":"390 mm",
"Peso":"4,2 kg"
}'
);



-- 4     Sony PlayStation 5 + Marvel's Spider-Man Miles Morales + Blackfire BFX-R80 Auriculares Gaming
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
579.99,
'Sony PlayStation 5 + Marvels Spider-Man Miles Morales + Blackfire BFX-R80 Auriculares Gaming',
'/imagenes/consola/playstation/Spider-Man Miles Morales.webp',
'PlayStation® 5: Jugar no tiene límites. Experimenta cargas superrápidas gracias a una unidad de estado sólido (SSD) de alta velocidad, una inmersión más profunda con retroalimentación háptica, gatillos adaptables y audio 3D, además de una nueva generación de increíbles juegos de PlayStation®.',
10,
'consola',
'playstation',
'{
"Memoria interna": "16000 MB",
"Tipo de memoria interna": "GDDR6",
"Fabricante de procesador": "AMD",
"Modelo del procesador": "AMD Ryzen Zen 2",
"Frecuencia del procesador":"3,5 GHz",
"Número de núcleos de procesador": "8",
"Procesador gráfico": "AMD Radeon",
"Frecuencia del procesador gráfico": "2230 MHz",
"Rendimiento del procesador gráfico": "10,3 TFLOPS",
"Color del producto": "Negro, Blanco",
"Unidad de almacenamiento": "SSD",
"Capacidad de almacenamiento interno": "825 GB",
"Ethernet": "Si",
"Ethernet LAN, velocidad de transferencia de datos":" 10,100,1000 Mbit/s",
"Tipo de interfaz ethernet":"Gigabit Ethernet",
"Wifi":"Si",
"Número de puertos HDMI":"1",
"Versión HDMI":"2.1",
"Fuente de alimentación":"350 W",
"Ancho":"104 mm",
"Profundidad":"260 mm",
"Altura":"390 mm",
"Peso":"4,2 kg"
}'
);





-- 5     Sony PlayStation 5 Digital Chasis C
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
564.99,
'Sony PlayStation 5 Digital Chasis C',
'/imagenes/consola/playstation/Sony PlayStation 5 Digital Chasis C.jpeg',
'PlayStation® 5: Jugar no tiene límites. Experimenta cargas superrápidas gracias a una unidad de estado sólido (SSD) de alta velocidad, una inmersión más profunda con retroalimentación háptica, gatillos adaptables y audio 3D, además de una nueva generación de increíbles juegos de PlayStation®.',
10,
'consola',
'playstation',
'{
"CPU":"x86-64-AMD Ryzen Zen 2 con 8 núcleos y 16 subprocesos, y una frecuencia variable de hasta 3,5 GHz.",
"GPU":" 10,3 TFLOPS de potencia, con 36 CUs a una frecuencia variable de hasta 2,23 GHz, basada en AMD Radeon RDNA 2.",
"Memoria": "16 GB GDDR6",
"Disco": "SSD de 825 GB",
"Dimensiones del producto (ancho x alto x fondo)":" 92 x 390 260 mm",
"Dimensiones del embalaje (ancho x alto x fondo)":" 469 x 426 x 174 mm",
"Cable": "HDMI",
"Cable": "USB",
"Cable": "alimentación"
}'
);






-- 6     Sony PlayStation 5 Chasis C + FIFA 23
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
649.99,
'Sony PlayStation 5 Chasis C + FIFA 23',
'/imagenes/consola/playstation/Sony PlayStation 5 Chasis C + FIFA 23.jpeg',
'PlayStation® 5: Jugar no tiene límites. Experimenta cargas superrápidas gracias a una unidad de estado sólido (SSD) de alta velocidad, una inmersión más profunda con retroalimentación háptica, gatillos adaptables y audio 3D, además de una nueva generación de increíbles juegos de PlayStation®.',
10,
'consola',
'playstation',
'{
"Memoria interna": "16000 MB",
"Tipo de memoria interna": "GDDR6",
"Fabricante de procesador": "AMD",
"Modelo del procesador":"AMD Ryzen Zen 2",
"Frecuencia del procesador": "3,5 GHz",
"Número de núcleos de procesador": "8",
"Procesador gráfico": "AMD Radeon",
"Frecuencia del procesador gráfico": "2230 MHz",
"Rendimiento del procesador gráfico": "10,3 TFLOPS",
"Color del producto": "Negro, Blanco",
"Unidad de almacenamiento": "SSD",
"Capacidad de almacenamiento interno": "825 GB",
"Ethernet": "Si",
"Ethernet LAN, velocidad de transferencia de datos": "10,100,1000 Mbit/s",
"Tipo de interfaz ethernet": "Gigabit Ethernet",
"Wifi": "Si",
"Ancho": "104 mm",
"Profundidad": "260 mm",
"Altura": "390 mm",
"Peso": "4,2 kg"
}'
);





-- 7     Sony Pack PlayStation 5 + Pulse 3D Midnight Black Auriculares Inalámbricos
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
649.99,
'Sony Pack PlayStation 5 + Pulse 3D Midnight Black Auriculares Inalámbricos',
'/imagenes/consola/playstation/Sony Pack PlayStation 5 + Pulse 3D Midnight Black Auriculares Inalámbricos.jpeg',
'PlayStation® 5: Jugar no tiene límites. Experimenta cargas superrápidas gracias a una unidad de estado sólido (SSD) de alta velocidad, una inmersión más profunda con retroalimentación háptica, gatillos adaptables y audio 3D, además de una nueva generación de increíbles juegos de PlayStation®.',
10,
'consola',
'playstation',
'{
"Memoria interna": "16000 MB",
"Tipo de memoria interna": "GDDR6",
"Fabricante de procesador": "AMD",
"Modelo del procesador": "AMD Ryzen Zen 2",
"Frecuencia del procesador": "3,5 GHz",
"Número de núcleos de procesador": "8",
"Procesador gráfico": "AMD Radeon",
"Frecuencia del procesador gráfico": "2230 MHz",
"Rendimiento del procesador gráfico": "10,3 TFLOPS",
"Color del producto": "Negro, Blanco",
"Tipo HD": "4K Ultra HD",
"Formato de vídeo soportado": "2160p,4320p",
"Alto Rango Dinámico (HDR)": "Si",
"Listo para realidad virtual (RV)": "Si",
"Número de consolas de juego incluido": "1",
"Juego de video incluido": "No",
"Manual de usuario": "Si",
"Cables incluidos": "Corriente alterna, HDMI, USB",
"Manual de usuario": "Si",
"Adaptador AC incluido": "Si",
"Controlador incluido": "Gamepad"
}'
);





-- 8     Sony PlayStation 4 Pro 1TB Negra
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
359.64,
'Sony PlayStation 4 Pro 1TB NegrA',
'/imagenes/consola/playstation/Sony PlayStation 4 Pro 1TB Negra.jpeg',
'Presentamos la PS4 Pro, con aún más potencia. La consola PlayStation más potente jamás creada.',
10,
'consola',
'playstation',
'{
"Dimensiones Externas": "Aprox. 295 × 55 × 327 mm",
"CPU" : "AMD Jaguar x86-64",
"núcleos": "8",
"GPU": "4.20 TFLOPS, AMD unidad de procesamiento gráfico de próxima generación basada en Radeon",
"Memoria": "GDDR5 8GB",
"Almacenamiento": "Disco duro de 1TB",
"Sistema": "PlayStation®4",
"Mando inalámbrico":"DUALSHOCK®4",
"Auricular": "con micrófono mono",
"Cable": "alimentación AC",
"Cable": "HDMI",
"Cable": "USB",
"Tipo": "Batería recargable de litio incorporada",
"Voltaje": "DC3.7V (provisional)",
"Capacidad": "1000mAh (provisional)"
}'
);










-- COOOOOONSOOOOOLLLLAAAAAAAA >>>> XXXXXXBBBOOOOOOXXXXXXX












-- 1    Microsoft Xbox Series S 512GB
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
289.99,
'Microsoft Xbox Series S 512GB',
'/imagenes/consola/xbox/Microsoft Xbox Series S 512GB.jpeg',
'Rendimiento de nueva generación en la Xbox más pequeña de la historia. La nueva generación de videojuegos ofrece nuestra biblioteca de lanzamientos digitales más grande a la Xbox más pequeña de la historia. Con mundos más dinámicos, tiempos de carga más rápidos y la adición de Xbox Game Pass (se vende por separado), la Xbox Series S totalmente digital es el mejor valor disponible en el mundo de los videojuegos',
10,
'consola',
'xbox',
'{"memoria":"10 GB GDDR6",
"graficos":"4 TERAFLOPS, 20 CU a 1,565 GHz",
"nucleos":"8",
"procesador":"CPU Zen 2 personaliza de 8 núcleos a 3,6 GHz (3,4 GHz con SMT)",
"color":"blanco",
"almacenamiento":"512GB SSD",
"conexion":"HDMI. 1 puerto HDMI 2.1 / USB. 3 puertos USB 3.1 Gen 1 / Red inalámbrica. Banda dual de 802.11ac / Ethernet. 802.3 10/100/1000 / Accesorios de radio. Radio inalámbrica Xbox de doble banda dedicada",
"dimensiones":"6,5 cm x 15,1 cm x 27,5 cm",
"peso":"1.92kg",
"resolucion_juego":"1440p"}'
);



-- 2    Microsoft Xbox One X 1TB
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
287.91,
'Microsoft Xbox One X 1TB',
'/imagenes/consola/xbox/Microsoft Xbox One X 1TB.jpeg',
'Con un 40 % más de potencia que cualquier otra consola, disfruta de la auténtica experiencia de inmersión de juego en 4K. Los juegos se reproducen mejor en Xbox One X. Procesamiento más rápido: Experiencia de juego más fluida La CPU AMD personalizada de 8 núcleos y 2,3 GHz ofrece una inteligencia artificial mejorada, detalles de gran realismo e interacciones más fluidas durante tus partidas.',
10,
'consola',
'xbox',
'{"memoria":"12 GB de GDDR5",
"unidad_optica":"4K UHD Blu-ray",
"graficos":"GPU personalizada a 1.172 GHz, 40 CUs, características Polaris, 6.0 TFLOPS",
"nucleos":"8",
"procesador":"CPU personalizada a 2,30 GHz, 8 núcleos",
"color":"negro",
"almacenamiento":"1 TB HDD",
"conexion":"3 USB 3.0 / 2 HDMI (1 HDMI 2.0b out, 1 HDMI 1.4b in / S/PDIF / IR receiver / IR Blaster port / IR Blaster / Ethernet (IEEE 802.3 10/100/1000) / Kinect (via external USB adapter)",
"dimensiones":"11,81 x 9,44 x 2,36 pulgadas (299,97 x 239,77 x 59,94 mm)",
"peso":"3,81 kg",
"resolucion_juego":" 2160p @ 60Hz AMD FreeSync"}'
);





-- 3     Microsoft Xbox One Consola S 1TB + Battlefield V
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
283.07,
'Microsoft Xbox One Consola S 1TB + Battlefield V',
'/imagenes/consola/xbox/Microsoft Xbox One Consola S 1TB + Battlefield V.jpeg',
'Presentamos la nueva Xbox One S. Juega la mejor selección de juegos que existe, incluidos clásicos de Xbox 360, en una consola un 40 % más pequeña, hasta 2 TB de disco duro, con vídeo en 4K de ultra alta definición, función de alto rango dinámico con colores más vivos y luminosos y un mando más ergonómico. No permitas que su tamaño te engañe, la Xbox One S es la Xbox más avanzada que existe.',
10,
'consola',
'xbox',
'{"memoria":"10 GB GDDR6",
"graficos":"4 TERAFLOPS, 20 CU a 1,565 GHz",
"nucleos":"8",
"procesador":"CPU Zen 2 personaliza de 8 núcleos a 3,6 GHz (3,4 GHz con SMT)",
"color":"blanco",
"almacenamiento":"512GB SSD",
"conexion":"HDMI. 1 puerto HDMI 2.1 / USB. 3 puertos USB 3.1 Gen 1 / Red inalámbrica. Banda dual de 802.11ac / Ethernet. 802.3 10/100/1000 / Accesorios de radio. Radio inalámbrica Xbox de doble banda dedicada",
"dimensiones":"6,5 cm x 15,1 cm x 27,5 cm",
"peso":"1.92kg",
"resolucion_juego":"1440p"}'
);





-- 4    Microsoft Xbox Series S 512GB + Hogwarts Legacy Descarga Digital
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
364.95,
'Microsoft Xbox One Consola S 1TB + Battlefield V',
'/imagenes/consola/xbox/Microsoft Xbox Series S howarts.jpeg',
'Rendimiento de nueva generación en la Xbox más pequeña de la historia. La nueva generación de videojuegos ofrece nuestra biblioteca de lanzamientos digitales más grande a la Xbox más pequeña de la historia. Con mundos más dinámicos, tiempos de carga más rápidos y la adición de Xbox Game Pass (se vende por separado), la Xbox Series S totalmente digital es el mejor valor disponible en el mundo de los videojuegos.',
10,
'consola',
'xbox',
'{
"CPU":" CPU Zen 2 personaliza de 8 núcleos a 3,6 GHz (3,4 GHz con SMT)",
"GPU":" 4 TERAFLOPS, 20 CU a 1,565 GHz",
"Memoria": "Bus de 10 GB GDDR6 de 128 bits de ancho",
"Ancho de banda de la memoria": "8 GB a 224 GB/s, 2 GB a 56 GB/s.",
"Almacenamiento interno": "SSD NVME personalizado de 512 GB",
"Resolución de juego": "1440p",
"Objetivo de rendimiento": "Hasta 120 FPS",
"HDMI": "1 puerto HDMI 2.1",
"USB": "3 puertos USB 3.1 Gen 1",
"Red inalámbrica": "Banda dual de 802.11ac",
"Ethernet": "802.3 10/100/1000",
"Dimensiones": "6,5 cm x 15,1 cm x 27,5 cm",
"Peso": "1928 gramos"
}'
);








-- CCCCCCONSOOOOOLAAAAASSSSS >>>> NINTENDOOOOOOOOO








-- 1    Nintendo Switch OLED Blanca
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
349.99,
'Nintendo Switch OLED Blanca',
'/imagenes/consola/nintendo/Nintendo Switch OLED Blanca.jpeg',
'Nintendo Switch (modelo OLED) incluye una pantalla de 7 pulgadas con un marco más fino. Los colores intensos y el alto contraste de la pantalla proporcionan una experiencia de juego portátil y de sobremesa enriquecedora, y aportan mucha vida a los juegos, tanto si compites a gran velocidad sobre el asfalto como si te ves las caras con enemigos temibles.',
10,
'consola',
'nintendo',
'{"diagonal_pantalla":"17 pulgadas",
"tactil":"Sí",
"pantalla":"OLED",
"procesador":"NVIDIA Custom Tegra",
"color":"blanco",
"almacenamiento":"64GB",
"conexion":"Wifi / Bluetooth / HDMI / USB / Auriculares",
"dimensiones":"Ancho 242 mm / Profundidad 13,9 mm / Altura 102 mm",
"peso":"320g",
"resolucion_juego":"1280 x 720p",
"joystick":"si",
"tarjeta_lectura":"Si"}'
);



-- 2     Nintendo Switch Lite Azul Turquesa
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
219.99,
'Nintendo Switch Lite Azul Turquesa',
'/imagenes/consola/nintendo/Nintendo Switch Lite Azul Turquesa.jpeg',
'Nintendo presenta Nintendo Switch Lite, un dispositivo enfocado al juego portátil ideal para los jugadores que no se están quietos. Nintendo Switch Lite es la nueva incorporación a la familia Nintendo Switch: se trata de una consola compacta y ligera que se puede llevar a cualquier sitio con facilidad.',
10,
'consola',
'nintendo',
'{"diagonal_pantalla":"17 pulgadas",
"memoria":"32 GB (6,2 GB están reservados para el sistema operativo)",
"tactil":"Sí",
"pantalla":"LCD 5,5",
"procesador":"Tegra NVIDIA",
"color":" Azul turquesa",
"almacenamiento":"64GB",
"conexion":"Wifi / Bluetooth / USB tipo C / Auriculares",
"dimensiones":"91.1mm x 208mm x 13.9mm",
"peso":"275 g",
"resolucion_juego":"1280 x 720p",
"altavoces":"estereo",
"bateria":"Batería de ion de litio / capacidad de la batería 3570 mAh"}'
);







-- 3     Nintendo 2DS Rosa/Blanca + Tomodachi Life (preinstalado)
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
88.99,
'Nintendo 2DS Rosa/Blanca + Tomodachi Life (preinstalado)',
'/imagenes/consola/nintendo/Nintendo 2DS RosaBlanca + Tomodachi Life (preinstalado).jpeg',
'¡He aquí Nintendo 2DS, un nuevo miembro de la familia de consolas Nintendo 3DS! Nintendo 2DS es tu puerta de entrada portátil a un mundo de maravillosos juegos y servicios; podrás conectar con amigos y con la comunidad global de Nintendo con las opciones para compartir. Lleva la experiencia de juego portátil a un nivel superior con Nintendo 2DS...',
10,
'consola',
'nintendo',
'{
"conectividad": "wifi",
"almacenamiento": "capacidad (gb) 4 memoria interna",
"formato de juego": "juegos descargables / otros juegos descargables a través de la tienda nintendo e shop / retrocompatibles / soporte de juegos cartucho",
"pantallas": "pantalla principal / pantalla secundaria / táctil",
"tamaño (pulgadas)": "pantalla superior : 3.53 pulgadas / pantalla inferior: 3.02 pulgadas",
"cámaras": "camara principal / cámara secundaria",
"imagen y sonido": "altavoces integrados monoaural (estéreo con auriculares) / salida de auriculares",
"alimentación": "batería ion litio / duración batería (horas) / con juegos de nintendo 3ds : 3,5 - 5,5 horas / con juegos de nintendo ds : 5 - 9 horas / modo de espera : aproximadamente 3 días / cargador ac incluido sí",
"peso": "260g",
"contenido caja": "lápiz de nintendo 2ds / tarjeta sdhc (4 gb) / adaptador de corriente / 6 tarjetas ra / guía rápida / manual de instrucciones"
}'
);





-- 4     Nintendo 3Ds Azul Aqua
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
99.95,
'Nintendo 3Ds Azul Aqua',
'/imagenes/consola/nintendo/Nintendo 3Ds Azul Aqua.jpeg',
'Pantalla 3D Ver cómo mundos maravillosos en 3D ganan vida en la palma de tu mano es una experiencia que tendrás que ver por ti mismo para poder apreciarla en toda su profundidad. La gran pantalla superior de Nintendo 3DS hace uso de las más recientes tecnologías para crear un efecto 3D vívido y convincente sin que tengas que ponerte gafas especiales. Regulador 3D El regulador 3D permite aumentar o disminuir el efecto 3D para que encuentres el nivel 3D más conveniente para tus ojos: puede aumentarse hasta el nivel máximo, reducirse para obtener un efecto más moderado, o apagarse del todo. (Si niños de seis años o menores están jugando a la consola, los padres o tutores deberían apagar el efecto 3D a través de la función de control parental). Fotos en tres dimensiones Saca fotografías muy innovadoras con la Cámara de Nintendo 3DS. La consola Nintendo 3DS cuenta con una cámara interior y dos cámaras exteriores, lo que permite sacar fotos en 3D. ¡Los retratos familiares ya nunca serán lo mismo! Juegos de Realidad Aumentada Las posibilidades 3D de las cámaras te permiten entrar en una nueva dimensión con la Realidad Aumentada, en la aplicación de Juegos RA. Coloca una de las tarjetas RA proporcionadas en una superficie plana, aléjate un poco y maravíllate al ver cómo tu juego cobra vida. Crea tu propio Mii ¡Participa en el juego! ¡Es muy fácil crear un Mii utilizando el nuevo editor de Mii! Basta con hacer una foto 2D de ti mismo o de otra persona para que el editor de Mii la convierta en un personaje Mii personalizado. Después, puedes hacer los ajustes necesarios, como el color de ojos, de pelo y de piel, hasta que estés satisfecho con el Mii.',
10,
'consola',
'nintendo',
'{
"Tarjeta SD": "(2GB)",
"Bloque de alimentación": "Nintendo 3DS.",
"Lápiz": "Nintendo 3DS",
"Tarjetas": "RA (6 unidades)",
"Color": "azul",
"Estado del producto": "nuevo"
}'
);






-- 5     Nintendo Ds Nintendo Dsi
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
33.95,
'Nintendo Ds Nintendo Dsi',
'/imagenes/consola/nintendo/Nintendo Ds Nintendo Dsi.jpeg',
'la Nintendo DSi presenta pocas novedades respecto a su predecesora, pero si buscamos bien, hallaremos algunos detalles que personalmente creo que son un acierto si tenemos en cuenta a quién va dirigida esta consola. Nintendo ha sabido leer el mercado de nuevo y ha mejorado (poco eso sí) la consola para adaptarla a un tipo de público que demanda una forma distinta de interaccionar con su consola de videojuegos portátil.',
10,
'consola',
'nintendo',
'{
"Peso": "214,5 gramos.",
"Dimensiones": "137 mm x 74,9 mm x 18,9 mm.",
"Stylus más grande": "92 mm.",
"CPU": "ARM7 a 33 MHz y ARM9 a 166 MHz.",
"RAM": "16MB.",
"Pantallas": "2 de 3,25, 256x192 a 260 000 colores (la inferior es táctil).",
"Energía y batería": "Batería de ion-litio recargable de 840 mAh. Modo de ahorro de energía. Adaptador AC.",
"brillo mínimo": "10-15 horas",
"brillo bajo": "8-12 horas",
"brillo alto": "4-6 horas",
"brillo máximo": "3-4 horas"
}'
);






-- 6     Nintendo Switch OLED Edición Limitada The Legend of Zelda: Tears of the Kingdom
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
359.99,
'Nintendo Switch OLED Edición Limitada The Legend of Zelda: Tears of the Kingdom',
'/imagenes/consola/nintendo/Nintendo Switch OLED Edición Limitada The Legend of Zelda_ Tears of the Kingdom.jpeg',
'La nueva Nintendo Switch – Modelo OLED (edición The Legend of Zelda: Tears of the Kingdom), con un diseño especial inspirado en The Legend of Zelda: Tears of the Kingdom, se lanzará el 28 de abril*. Esta flamante edición cuenta con un diseño que aparece en The Legend of Zelda: Tears of the Kingdom, incluyendo el conocido símbolo hyliano de la saga The Legend of Zelda en la cara frontal de la base de la consola.',
10,
'consola',
'nintendo',
'{
"Plataforma": "Nintendo Switch",
"Modelo del procesador": "NVIDIA Custom Tegra",
"Acelerómetro": "Si",
"Sensor de luz ambiental": "Si",
"Giroscopio": "Si",
"Diagonal de la pantalla": "17,8 cm (7)",
"Pantalla": "OLED",
"Pantalla táctil": "Si",
"Resolución de la pantalla": "1280 x 720 Píxeles",
"Capacidad de memoria interna": "64 GB",
"Wifi": "Si",
"Bluetooth": "Si",
"HDMI": "Si",
"Puerto USB": "Si",
"Conector USB": "USB Tipo C",
"Auriculares": "3,5 mm"}'
);




-- 7    Nintendo Pack Switch Azul Neón/Rojo Neón + Minecraft: Nintendo Switch Edition
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
329.99,
'Nintendo Pack Switch Azul Neón/Rojo Neón + Minecraft: Nintendo Switch Edition',
'/imagenes/consola/nintendo/Nintendo Pack Switch Azul Neón çRojo Neón + Minecraft_ Nintendo Switch Edition.jpeg',
'Nintendo Switch es la consola de Nintendo para el hogar que ha liderado la venta en todo el mundo en los últimos años con casi 56 millones de consolas vendidas y más de 350 millones de juegos. En España superó el millón de consolas vendidas antes de la Navidad de 2019.',
10,
'consola',
'nintendo',
'{
"Pantalla":"Táctil capacitiva / LCD 6,2 / resolución de 1280x720p",
"CPU/GPU": "Procesador Tegra NVIDIA",
"Memoria": "32 GB (6,2 GB están reservados para el sistema operativo)",
"Comunicación": "LAN inalámbrico (compatible con IEEE 802.11 a/b/g/n/ac) / Bluetooth 4.1",
"Resolución máxima modo TV": "1920x1080, 60 fps",
"Resolución máxima modo portátil": "1280x720",
"Salida de audio": "Compatible con PCM lineal 5.1",
"Altavoces": "Estéreo",
"Puertos": "Terminal USB Type-C",
"Compatibilidad": "Tarjetas de juego de Nintendo Switch.",
"Tarjetas microSD compatibles": "microSD, microSDHC y microSDXC (se requiere una actualización a través de internet para usar tarjetas de memoria microSDXC)",
"Sensores": "Acelerómetro / giroscopio / sensor de brillo",
"Entorno operativo": "Temperatura: 5 - 35°C / Humedad: 20 - 80%",
"Batería interna": "Batería de ion de litio",
"Capacidad de la batería": "4310mAh",
"Duración de la batería": "De 4,5 a 9 horas aproximadamente.",
"Tiempo de carga": "3h aproximadamente"}'
);




-- 8      Nintendo Switch OLED Edición Limitada Splatoon 3
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
474.99,
'Nintendo Switch OLED Edición Limitada Splatoon 3',
'/imagenes/consola/nintendo/Nintendo Switch OLED Edición Limitada Splatoon 3.jpeg',
'Nintendo Switch (modelo OLED) Edición Limitada Splatoon 3 incluye una pantalla de 7 pulgadas con un marco más fino. Los colores intensos y el alto contraste de la pantalla proporcionan una experiencia de juego portátil y de sobremesa enriquecedora, y aportan mucha vida a los juegos, tanto si compites a gran velocidad sobre el asfalto como si te ves las caras con enemigos temibles.',
10,
'consola',
'nintendo',
'{
"Plataforma": "Nintendo Switch",
"Modelo del procesador": "NVIDIA Custom Tegra",
"Acelerómetro": "Si",
"Sensor de luz ambiental": "Si",
"Giroscopio": "Si",
"Color del producto": "Multicolor",
"Tecnología de control para juegos": "Analógico/Digital",
"Botones de función control para gaming": "Botón de inicio, Botón de encendido",
"Joystick analógico": "Si",
"Control de volumen": "Botones",
"Diagonal de la pantalla": "17,8 cm (7)",
"Pantalla": "OLED",
"Pantalla táctil": "Si",
"Resolución de la pantalla": "1280 x 720 Pixeles",
"Capacidad de memoria interna": "64 GB",
"Ancho": "242 mm",
"Profundidad": "13,9 mm",
"Altura": "102 mm",
"Peso": "320 g"
}'
);










-- COOONSOOOLASSSSSS >>>> MMMMMMMMAAAAAANDOSSSSSSS








-- 1    Sony DualShock 4 Blanco V2
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
59.99,
'Sony DualShock 4 Blanco V2',
'/imagenes/consola/mandos/Sony DualShock 4 Blanco V2.webp',
'Una revolución en tus manos, llega el nuevo DualShock para PS4 en color blanco.',
10,
'consola',
'mandos',
'{"Boton_share":"Captura y presume de tus mejores momentos con tan solo tocar un botón.",
"panel_tactil":"Control aún más preciso con el panel táctil que ahora deja ver nuestra exclusiva barra luminosa, añadiendo una dimensión adicional a tus juegos.",
"joystick":"Consigue la ventaja con una sensación de control mucho más precisa en tus juegos.",
"barra_luminosa":"Implícate aún más en tus juegos con la barra luminosa integrada que brilla con distintos colores dependiendo de la acción, visible ahora a través del panel táctil.",
"altavoz":"si",
"sensores_movimiento":"si",
"conexion":"USB",
"color":"blanco",
"peso":"210 g",
"dimensiones":"162 x 52 x 98 mm"}'
);




-- 2    Microsoft Xbox One Gamepad Inalámbrico Negro
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
77.80,
'Microsoft Xbox One Gamepad Inalámbrico Negro',
'/imagenes/consola/mandos/Microsoft Xbox One Gamepad Inalámbrico Negro.jpeg',
'Siente el tacto y la comodidad mejorados del nuevo mando inalámbrico Xbox, con un diseño más elegante y ergonómico y un agarre en relieve. Disfruta del esquema de botones personalizado y hasta el doble de alcance inalámbrico. Conecta cualquier auricular compatible con jack estéreo de 3,5 mm. Además, disfruta de tus juegos preferidos en un PC y tablets con Windows 10 gracias a la tecnología Bluetooth.',
10,
'consola',
'mandos',
'{"puertos":"Tecnología de conectividad Inalámbrico / Interfaz del dispositivo Bluetooth",
"color":"negro",
"dimensiones":"‎18.1 x 17.5 x 7.1 cm",
"peso":"345 g",
"tipo":"gamepad",
"baterias":"2",
"so_soportados":"Windows 10 Education, Windows 10 Education x64, Windows 10 Enterprise, Windows 10 Enterprise x64, Windows 10 Home, Windows 10 Home x64, Windows 10 Pro, Windows 10 Pro x64"}'
);




-- 3    Nacon Compact Controller Wired para PS4 Iluminado Verde
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
39.99,
'Nacon Compact Controller Wired para PS4 Iluminado Verde',
'/imagenes/consola/mandos/Nacon Compact Controller Wired para PS4 Iluminado Verde.jpeg',
'Siente el tacto y la comodidad mejorados del nuevo mando inalámbrico Xbox, con un diseño más elegante y ergonómico y un agarre en relieve. Disfruta del esquema de botones personalizado y hasta el doble de alcance inalámbrico. Conecta cualquier auricular compatible con jack estéreo de 3,5 mm. Además, disfruta de tus juegos preferidos en un PC y tablets con Windows 10 gracias a la tecnología Bluetooth.',
10,
'consola',
'mandos',
'{
"Tecnología de conectividad": "Alámbrico",
"Longitud de cable": "3 m",
"Salida de auriculares": "Si",
"Ancho": "170 mm",
"Profundidad": "205 mm",
"Altura": "65 mm",
"Color del producto": "Verde",
"Conectar y usar (Plug and Play)": "Si",
"Número de motovibradores":"2",
"Tipo de dispositivo": "Gamepad",
"Plataformas de juego soportadas": "PlayStation 4",
"Tecnología de control para juegos": "Analógico/Digital",
"Juegos de llaves de control de función": "Share"
}'
);




-- 4     Nacon Compact Controller Wired para PS4 Naranja
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
39.99,
'Nacon Compact Controller Wired para PS4 Naranja',
'/imagenes/consola/mandos/Nacon Compact Controller Wired para PS4 Naranja.jpeg',
'Siente el tacto y la comodidad mejorados del nuevo mando inalámbrico Xbox, con un diseño más elegante y ergonómico y un agarre en relieve. Disfruta del esquema de botones personalizado y hasta el doble de alcance inalámbrico. Conecta cualquier auricular compatible con jack estéreo de 3,5 mm. Además, disfruta de tus juegos preferidos en un PC y tablets con Windows 10 gracias a la tecnología Bluetooth.',
10,
'consola',
'mandos',
'{
"Color del producto": "Naranja",
"Conectar y usar (Plug and Play)": "Si",
"Número de motovibradores": "2",
"Tecnología de conectividad": "Alámbrico",
"Longitud de cable": "3 m",
"Salida de auriculares": "Si",
"Ancho": "170 mm",
"Profundidad": "205 mm",
"Altura": "65 mm",
"Tipo de dispositivo": "Gamepad",
"Plataformas de juego soportadas": "PlayStation 4",
"Tecnología de control para juegos": "Analógico/Digital",
"Juegos de llaves de control de función": "Share",
"Vibración por reflejo": "Si",
"Joystick analógico": "Si",
"Superficie táctil incorporada": "Si"
}'
);






-- 5      Nintendo Switch Joy-Con Set Izquierda Derecha Verde Neón Rosa Neón
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
79.98,
'Nintendo Switch Joy-Con Set Izquierda/Derecha Verde Neón/Rosa Neón',
'/imagenes/consola/mandos/Nintendo Switch Joy-Con Set Izquierda Derecha Verde Neón Rosa Neón.jpeg',
'Un mando o dos, en vertical o en horizontal, control por movimiento o mediante botones? Con los nuevos mandos Joy-Con para Nintendo Switch tendrás flexibilidad total a la hora de jugar y descubrirás nuevas formas de interactuar que transformarán por completo tus experiencias de juego.',
10,
'consola',
'mandos',
'{
"Marca": "Nintendo",
"Color": "A elegir",
"Número de botones": "16",
"Peso del producto": "150 Gramos",
"Cantidad de productos por paquete":"1",
"Plataforma de hardware": "nintendo_switch",
"Dimensiones del producto": "largo x ancho x alto: 12,3 x 4 x 14 centímetros"
}'
);





-- 6     Krom Kayros RGB Mando Inalámbrico para PC Switch Android
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
37.50,
'Krom Kayros RGB Mando Inalámbrico para PC/Switch/Android',
'/imagenes/consola/mandos/Krom Kayros RGB Mando Inalámbrico para PC Switch Android.jpeg',
'Krom Kayros es un mando bluetooth ergonómico, pensado para la competición, que ofrece un excelente rendimiento. Compatible con varias plataformas. Se trata de un gamepad RGB con muy buena autonomía perfecto para disfrutar de juegos tipo shooter o arcade.',
10,
'consola',
'mandos',
'{
"Prestaciones": "Botones traseros configurables / Creación de macros / Iluminación LED RGB / Compatible con PC, SWITCH™, ANDROID™ y IOS™",
"Modos de control": "D-PAD | Eje X/Y",
"Botones": "23",
"Conexión": "Cable USB Type C - USB  / Bluetooth",
"Dimensiones": "155 x 105.5 x 59 mm",
"Peso": "260 gr"
}'
);






-- 7     Microsoft Stellar Shift Special Edition Mando Inalámbrico para Xbox PC Android iOS
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
63.98,
'Microsoft Stellar Shift Special Edition Mando Inalámbrico para Xbox/PC/Android/iOS',
'/imagenes/consola/mandos/Microsoft Stellar Shift Special Edition Mando Inalámbrico para Xbox PC Android iOS.jpeg',
'Juega a otro nivel. Disfruta del Mando inalámbrico Xbox – Stellar Shift Special Edition, que cuenta con un llamativo patrón de camuflaje azul mineral, púrpura brillante, aguamarina y púrpura oscuro. Empareja rápidamente, juega y cambia entre dispositivos como consola, PC y dispositivos móviles.',
10,
'consola',
'mandos',
'{
"Tipo de dispositivo": "Gamepad",
"Tecnología de control para juegos": "Analógico/Digital",
"Plataformas de juego soportadas": "Android, PC, Xbox Series S, Xbox Series X, iOS",
"Botones de función control para gaming": "Cruceta, Botón de inicio, Botón menú, Botón Compartir",
"Joystick analógico": "Si",
"Botones del hombro": "Si",
"Interfaz del dispositivo": "Bluetooth",
"Conector USB": "USB Tipo C",
"Tecnología de conectividad": "Inalámbrico",
"Salida de auriculares": "Si",
"Color del producto": "Azul, Blanco",
"Fuente de energía": "Batería",
"Tipo de batería": "AA",
"Numero de baterías soportadas": "2",
"Autonomía": "40 h"
}'
);




-- 8    Retro-Bit Tribute 64 Gamepad USB para Nintendo64 Rojo
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
15.98,
'Retro-Bit Tribute 64 Gamepad USB para Nintendo64 Rojo',
'/imagenes/consola/mandos/Retro-Bit Tribute 64 Gamepad USB para Nintendo64 Rojo.jpeg',
'El Tribute64 es parte de la serie de controladores Platinum de Retro-Bit® dedicados a las consolas de juegos retro clásicas. Compatible con PC, Mac y Steam, Super RetroCade y Switch, presenta la máxima versatilidad para cualquier género de juegos. Construido con un stick analógico fabricado en Japón que utiliza el más alto grado en calidad, un diseño amplio y ergonómico para mejorar su experiencia de juego y un D-pad reposicionado para acceso con doble pulgar, los jugadores disfrutarán de largas horas de juego retro clásico.',
10,
'consola',
'mandos',
'{
"Compatible con": "PC, Mac y Steam, Super RetroCade y Switch",
"Cable": "3 metros",
"Stick": "analógico sensible, preciso y de alta calidad fabricado en Japón",
"Hombreras": "Dual Z remodeladas para un agarre máximo",
"Botón":  "de inicio grande para un fácil acceso",
"Puerto": "para tarjeta de memoria y paquete de rumble"
}'
);




-- 9     Sony DualSense Pink Mando Inalámbrico para PS5
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
73.99,
'Sony DualSense Pink Mando Inalámbrico para PS5',
'/imagenes/consola/mandos/Sony DualSense Pink Mando Inalámbrico para PS5.jpeg',
'El mando inalámbrico DualSense de PS5 ofrece una inmersiva retroalimentación háptica, gatillos adaptables dinámicos y un micrófono integrado, todo ello en un diseño icónico.',
10,
'consola',
'mandos',
'{
"Tipo": "Control de PS5",
"Generación": "Desde 9.ª generación",
"Desarrollador": "Sony Interactive Entertainment",
"Fabricante": "Sony",
"Fecha de lanzamiento": "12 de noviembre de 2020",
"Peso": "280 g",
"Conectividad": "USB-C",
"Batería": "3.5mm stereo receptacle Ver y modificar los datos en Wikidata",
"DualShock": "DualSense"
}'
);




-- 10     PDP Victrix Pro BFG Mando Inalámbrico para PS5 PS4 PC
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
199.98,
'PDP Victrix Pro BFG Mando Inalámbrico para PS5/PS4/PC',
'/imagenes/consola/mandos/PDP Victrix Pro BFG Mando Inalámbrico para PS5 PS4 PC.jpeg',
'Mando profesional avanzado para PS5, PS4 y PC con conectividad inalámbrica o por cable perfecta, batería de larga duración y un arsenal completo de opciones personalizables.',
10,
'consola',
'mandos',
'{
"licencia oficial": "de PlayStation.",
"Compatible con": "PlayStation 5, Playstation 4 y PC (usando la entrada X).",
"Botones": "4 traseros programables y 5 puntos de parada.",
"Gatillo con": "recorrido adaptable.",
"D-pads": "intercambiables.",
"cosas":"Joystiks, cruceta y botones intercambiables y con módulos rotables.",
"Diseño de": "6 botones FightPad.",
"Salida de": "3.5mm de audio customizable con la app."
}'
);





-- 11     Microsoft Pack Elite Serie 2 Mando Wireless Negro para Xbox/PC + Game Pass Ultimate 1 Mes Licencia D
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
172.99,
'Microsoft Pack Elite Serie 2 Mando Wireless Negro para Xbox/PC + Game Pass Ultimate 1 Mes Licencia D',
'/imagenes/consola/mandos/Microsoft Pack Elite Serie 2 Mando Wireless Negro para Xbox PC + Game Pass Ultimate 1 Mes Licencia D.jpeg',
'El mando Xbox Elite Series 2 se adapta al tamaño de tu mano y a tu estilo de juego con configuraciones que pueden mejorar la precisión, la velocidad y el alcance mediante gatillos de distintas formas y tamaños. Puedes intercambiar los joysticks de metal y crucetas para lograr un control y ergonomía personalizados. Incorpora cuatro ranuras para palancas intercambiables que puedes conectar o quitar sin ninguna herramienta.',
10,
'consola',
'mandos',
'{
"puertos":"Tecnología de conectividad Inalámbrico / Interfaz del dispositivo Bluetooth",
"color":"negro",
"dimensiones":"‎18.1 x 17.5 x 7.1 cm",
"peso":"345 g",
"tipo":"gamepad",
"baterias":"2",
"so_soportados":"Windows 10 Education, Windows 10 Education x64, Windows 10 Enterprise, Windows 10 Enterprise x64, Windows 10 Home, Windows 10 Home x64, Windows 10 Pro, Windows 10 Pro x64"
}'
);






-- 12     Thrustmaster eSwap X PRO Controller Xbox One PC
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
165,
'Thrustmaster eSwap X PRO Controller Xbox One/PC',
'/imagenes/consola/mandos/Thrustmaster eSwap X PRO Controller Xbox One PC.jpeg',
'El gamepadpreciso, receptivo y adaptable con licencia oficial para Xbox Series X|S, con módulos de próxima generación (NXG), que asegura una experiencia optimizada para cada tipo de juego y jugador. Diseñado para ayudarte a aumentar tu nivel de juego, alcanzar nuevas cotas de rendimiento y lograr las mejores clasificaciones posibles.',
10,
'consola',
'mandos',
'{
"Tipo de dispositivo": "Gamepad",
"Tecnología de control para juegos": "Analógico/Digital",
"Plataformas de juego soportadas": "Xbox One,Xbox Series S",
"Botones de función control para gaming": "Cruceta",
"Vibración por reflejo": "Si",
"Cantidad de botones": "4",
"Botones programables": "Si",
"Interfaz del dispositivo": "USB",
"Tecnología de conectividad": "Alámbrico",
"Fuente de energía": "Cable",
"Ancho": "160 mm",
"Profundidad": "120 mm",
"Altura":"60 mm",
"Peso":"300 g"
}'
);









-- CONNNNSSSSOOOOOLLLLAAAASSSSS     >>>>>>>     JJJJUUUUEEEGOOOOOSSSSSS









-- 1     Battlefield 2042 PS4
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
35.99,
'Battlefield 2042 PS4',
'/imagenes/consola/juegos/Battlefield 2042 PS4.jpeg',
'Un arsenal de vanguardia a tu disposición. El retorno de la guerra total. Adáptate y vence en descomunales batallas de 128 jugadores en las que las tormentas dinámicas, los peligros medioambientales, la libertad de combate y la característica destrucción de Battlefield desatan una nueva dimensión de momentos exclusivos de Battlefield.',
10,
'consola',
'juegos',
'{
"guerra sin cuartel":"Nunca has visto ni has jugado a Conquista y Avance mejor que en Battlefield 2042. Lucha por tierra, mar y aire en frenéticos combates para 128 jugadores.",
"conquista": "Vuelve el emblemático modo de mundo abierto de Battlefield, esta vez con partidas para 128 jugadores en Xbox Series X|S, PlayStation®5 y PC. Los mapas se han diseñado específicamente para esta gran escala, con la acción dividida en grupos de distintos tipos. Además, la acción ahora se centra en sectores que constan de varias banderas en vez de puntos de control individuales.",
"avance": "Con la vuelta de Avance, dos equipos (atacantes y defensores) se disputan sectores a gran escala mientras los atacantes avanzan hacia el último objetivo. Cada sector está diseñado para albergar a un mayor número de jugadores, lo que da lugar a más estrategias y más oportunidades de flanqueo. Acércate a las zonas de captura desde múltiples puntos y aprovecha muchas más posibilidades tácticas.",
"battlefield portal":"Cambia las reglas de la guerra y descubre batallas inesperadas en el amplio universo de Battlefield. Vuelve a jugar a los clásicos reimaginados de Battlefield 1942, Battlefield Bad Company 2 y Battlefield 3, o despliégate en estos mapas atemporales con el arsenal y el contenido modernos de Battlefield 2042.",
"hazard zone":"Hazard zone es una experiencia tensa que combina una jugabilidad frenética con lo mejor del mundo abierto de Battlefield."
}'
);






-- 2     Hogwarts Legacy Standard PS4
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
52.99,
'Hogwarts Legacy Standard PS4',
'/imagenes/consola/juegos/Hogwarts Legacy Standard PS4.jpeg',
'Hogwarts Legacy es un inmersivo juego de rol de mundo abierto de un jugador ambientado en el mundo mágico del siglo XIX. Los jugadores podrán experimentar la vida de estudiante del Colegio Hogwarts de Magia y Hechicería como nunca antes y embarcarse en una peligrosa aventura jamás contada para descubrir una verdad oculta del mundo mágico.',
10,
'consola',
'juegos',
'{
"Una nueva aventura del Mundo Mágico": "Ambientado en una época anterior a las historias originales de Harry Potter; los jugadores vivirán el mundo mágico como estudiantes de quinto año en una era inexplorada para revelar una verdad oculta de su pasado.",
"Controla la aventura": "Los jugadores pueden tomar el control de la acción y convertirse en el eje de su propia aventura. La habilidad de sus personajes crecerá a medida que dominan poderosos hechizos, preparan pociones y recolectan plantas mágicas para enfrentarse a enemigos letales.",
"Exploración y descubrimiento": "Este juego de mundo abierto no solo llevará a los jugadores al castillo de Hogwarts, sino también a lugares tanto conocidos como nuevos del mundo mágico para recorrerlos libremente, entre los que se encuentran Hogsmeade, el Bosque Prohibido y las zonas circundantes.",
"Puedes ser una bruja o un mago": "Los jugadores pueden personalizar su personaje mediante una gran variedad de opciones al inicio de su aventura. A medida que progresen, forjarán relaciones y dominarán habilidades para convertirse en la bruja o el mago que deseen ser.",
"Magia inmersiva": "El juego está repleto de acción y magia, donde los jugadores pueden lanzar hechizos, preparar pociones, volar en escobas, domar y montar a lomos de bestias mágicas, y luchar contra trolls, magos oscuros, duendes y muchos seres más."
}'
);





-- 3     WWE 2K23 PS4
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
55.99,
'WWE 2K23 PS4',
'/imagenes/consola/juegos/WWE 2K23 PS4.jpeg',
'¡Características ampliadas, magníficos gráficos y la experiencia WWE definitiva. Sube al ring con un gran elenco de superestrellas y leyendas de la WWE, como Roman Reigns, "American Nightmare" Cody Rhodes, Ronda Rousey, Brock Lesnar, "Stone Cold" Steve Austin y muchos más!',
10,
'consola',
'juegos',
'{
"Aún más fuerte": "Funciones ampliadas, gráficos espectaculares y la experiencia WWE definitiva.  Sube al ring con un gran elenco de superestrellas y leyendas de la WWE, como Roman Reigns, American Nightmare Cody Rhodes, Ronda Rousey, Brock Lesnar, Stone Cold Steve Austin y muchos más.",
"2K Showcase documental interactivo sobre deportes": "¡El campeón ya está aquí! Vive los momentos clave y los rivales más duros de los 20 años de carrera de John Cena en la WWE. Y, por primera vez en la franquicia, adopta el papel de cada uno de sus grandes oponentes -algunos de los mejores de la WWE de todos los tiempos- para derrotar a Mr. Hustle, Loyalty & Respect.",
"Wargames sin cuartel": "El popular modo repleto de acción Wargames debuta en WWE 2K23 y ofrece un caos multijugador de 3 contra 3 y de 4 contra 4 dentro de dos cuadriláteros uno al lado del otro, ¡rodeados por una jaula de acero doble!",
"Tu espectáculo, tus decisisiones": "Con Mi GM, toma las riendas de un programa semanal y compite contra managers rivales por la supremacía de la marca. Ahora con más GMs entre los que elegir, opciones de espectáculo adicionales, múltiples temporadas, cartas de combate ampliadas y más tipos de combate para hasta 4 jugadores.",
"Tú tienes todas las cartas": "Colecciona y mejora cartas de Superestrellas y Leyendas de la WWE para crear la facción definitiva en Mi FACCIÓN. Ahora con multijugador online, Mi FACCIÓN te permite llevar tu facción a Internet y competir por el dominio mundial.",
"Define tu futuro en mi leyenda": "Atraviesa el telón de tu debut en la WWE y da forma a tu carrera como superestrella de la WWE con las decisiones que tomes a lo largo del camino, con historias distintas: The Lock y The Legacy.",
"El universo es todo tuyo": "El mundo de la WWE está al alcance de tu mano con el modo Universo, el sandbox definitivo que te pone al mando de la WWE, desde los rosters de Superestrellas, los feudos, los campeones, los shows semanales y los Eventos Premium en Directo."
}'
);



-- 4     The Last Of Us Part I PS5
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
55.99,
'The Last Of Us Part I PS5',
'/imagenes/consola/juegos/The Last Of Us Part I PS5.jpeg',
'Resiste y sobrevive. Revive el juego que lo cambió todo, recreado para la consola PlayStation®5. Disfruta de la emotiva historia y los inolvidables personajes de The Last of Us, ganador de más de 200 premios de Juego del Año. En una civilización devastada en la que infectados y supervivientes embrutecidos campan sin control, Joel, nuestro exhausto protagonista, es contratado para sacar a escondidas de una zona militar en cuarentena a Ellie, una chica de 14 años. Pero lo que comienza siendo una simple tarea pronto se transforma en un brutal viaje campo a través.',
10,
'consola',
'juegos',
'{
"Recreado para Playstation 5":"Recreado por completo con la última tecnología de Naughty Dog para el motor de PS5, el juego ofrece una fidelidad visual avanzada, las funciones del mando inalámbrico DualSense™ totalmente integradas y mucho más.",
"Un remake fiel": "Disfruta de la emotiva historia y los inolvidables personajes de Joel y Ellie de The Last of Us, y explora los acontecimientos que cambiaron para siempre la vida de Ellie y su mejor amiga Riley en el aclamado capítulo previo: Left Behind.",
"Una experiencia completamente nueva": "Una nueva visión de la experiencia original que mantiene su esencia, pero incorpora una mecánica de juego más moderna, controles mejorados y más opciones de accesibilidad. Sumérgete en una narración ambiental renovada, con efectos, animaciones faciales, exploración y combate mejorados."
}'
);



-- 5     FIFA 23 PS5
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
58.99,
'FIFA 23 PS5',
'/imagenes/consola/juegos/FIFA 23 PS5.jpeg',
'EA SPORTS™ FIFA 23 nos acerca aún más a la acción y el realismo del juego del mundo gracias a la tecnología HyperMotion 2, con el doble de capturas de movimiento del mundo real y animaciones más auténticas que nunca en cada partido. Disputa los torneos más importantes del fútbol, como la Copa Mundial de la FIFA™ masculina y femenina, que llegarán a FIFA 23 durante la temporada, y juega por primera vez en la historia con equipos femeninos de clubes. Disfruta con las animaciones de HyperMotion2 y de las funciones multiplataforma, que harán que sea más fácil jugar contra tus colegas. Disfruta de una nueva forma de jugar y crear la plantilla de tus sueños con Momentos de FUT y un sistema de química renovado en FIFA Ultimate Team™. Haz realidad tus sueños en el modo Carrera, definiendo tu personalidad como jugador y gestionando clubes como algunos de los nombres más conocidos del mundo del fútbol. VOLTA Football y Clubes Pro aportarán más personalidad al campo gracias a los nuevos niveles de personalización y a a jugabilidad mejorada en las calles y los estadios.',
10,
'consola',
'juegos',
'{
"Tecnología HyperMotion 2":"La tecnología HyperMotion cuenta con el doble de captura de datos de partidos, desbloquea nuevas características y trae a FIFA 23 más de 6000 animaciones auténticas recogidas de millones de fotogramas de la captura avanzada de partidos.",
"Copa del Mundo de la FIFA™": "Disfruta de la competición cumbre del fútbol internacional con la FIFA World Cup de Catar 2022™ y la Copa Mundial Femenina de la FIFA de Australia y Nueva.",
"Fútbol femenino": "Juega por primera vez en la historia de EA SPORTS FIFA con clubes femeninos de fútbol, con la llegada de la Barclays FA Womens Super League y la Division 1",
"Jugabilidad":"La nueva mecánica de tiros basada en el equilibrio entre riesgo y recompensa, los nuevos lanzamientos de falta, penaltis y saques de esquina, y unas físicas más realistas añaden más variedad al Juego del mundo.",
"Centro de entrenamiento": "Un nuevo sistema de entrenamiento ayuda a introducir a los jugadores nuevos y menos experimentados en los fundamentos del juego, con una serie de desafíos y capítulos que te ayudarán a mejorar tu juego.",
"Multiplataforma":"Juega con y contra amistades en diferentes plataformas. FIFA 23 introduce el juego cruzado en los modos de 1 contra 1 en FIFA Ultimate Team™, temporadas.",
"FIFA 23 Ultimate Team™": "Los Momentos FUT y el renovado sistema de química te proporcionan una nueva forma de jugar y crear el equipo de tus sueños. Además, nuevos iconos y héroes de FUT se unen al modo más popular del juego.",
"Modo Carrera": "Define tu personalidad como jugador, gestiona un club al estilo de algunos de los nombres más conocidos del mundo del fútbol y disfruta de la temporada con los nuevos Momentos destacados jugables. Todo esto lo encontrarás en la experiencia del modo Carrera de FIFA más auténtica hasta la fecha.",
"Clubes Pro": "Lleva más personalidad que nunca al campo con la nueva personalización, las mejoras en los partidos informales, las nuevas ventajas y mucho más.",
"VOLTA FOOTBALL": "Forma equipo con amigos o con la comunidad de VOLTA FOOTBALL y expresa tu estilo en los nuevos y mejorados VOLTA Arcades, con más formas de hacer que tu avatar se sienta único.",
"Autenticidad": "Juega al Juego del mundo con más de 19000 futbolistas, 700 equipos, 100 estadios y 30 ligas en FIFA 23."
}'
);



-- 6     Grand Theft Auto V PS5
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
22.51,
'Grand Theft Auto V PS5',
'/imagenes/consola/juegos/Grand Theft Auto V PS5.jpeg',
'Incluye Grand Theft Auto V: Modo Historia y Grand Theft Auto Online. Continúa tu aventura en PS5™ y transfiere tanto tu progreso en el Modo Historia de GTAV, como tus personajes y progreso de GTA Online a PS5™, con una migración única. Disfruta de los superventas del entretenimiento Grand Theft Auto V y GTA Online, ahora en PlayStation®5.',
10,
'consola',
'juegos',
'{
"gráficos impresionantes": "niveles de fidelidad y rendimiento mejorados, con nuevos modos gráficos que ofrecen resoluciones de hasta 4K, 60 fotogramas por segundo, opciones HDR, trazado de rayos, mejoras en la calidad de las texturas y mucho más.",
"carga más rápida":"entra en la acción rápidamente, ya que el mundo de Los Santos y el condado de Blaine ahora se carga más rápido que nunca.",
"gatillos adaptativos y respuesta háptica":"siente cada momento a través del mando DualSense™, desde el daño direccional hasta los efectos atmosféricos, baches en las carreteras, explosiones y mucho más.",
"sonido tempest 3d":"oye los sonidos del mundo con una precisión milimétrica, desde la aceleración de un supercoche robado hasta los disparos de un tiroteo cercano, el estruendo de un helicóptero sobre tu cabeza y mucho más.",
"nuevo contenido exclusivo":"ve a Haos Special Works en el Car Meet de Los Santos, donde encontrarás nuevas mejoras para vehículos de élite y modificaciones exclusivas. Después, participa con estos vehículos de alto rendimiento en carreras de HSW, contrarrelojes y mucho más.",
"el creador de profesiones":"ponte en marcha en GTA Online con las herramientas del oficio. Accede rápidamente a uno de los cuatro negocios ilícitos (Motero, Ejecutivo, Propietario de un club nocturno o Traficante de armas) y elige entre una selección de propiedades, potentes vehículos y armamento para poner en marcha tu negocio.",
"nuevo diseño del menú":"accede al instante a todo lo que te ofrece GTA Online directamente desde el menú principal, incluidas las actualizaciones más recientes y populares. "
}'
);



-- 7     Gran Turismo 7 PS5
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
63.07,
'Gran Turismo 7 PS5',
'/imagenes/consola/juegos/Gran Turismo 7 PS5.jpeg',
'Ya seas un corredor competitivo, un coleccionista, un perfeccionista, un diseñador, un fotógrafo o un entusiasta de los arcades, alimenta tu pasión por los coches con elementos inspirados en el pasado, el presente y el futuro de Gran Turismo. Desde los vehículos y circuitos más clásicos hasta la reincorporación del legendario modo Simulación GT, disfruta de las mejores funcionalidades de las anteriores entregas de la serie. Y, si te apasiona la velocidad, practica y compite en los Campeonatos FIA y en el modo Sport (requiere subscripción a PS Plus para el modo multijugador).',
10,
'consola',
'juegos',
'{
"elementos": "Alimenta tu pasión por los coches con elementos inspirados en el pasado, el presente y el futuro de Gran Turismo",
"funciones": "Desde los vehículos y circuitos más clásicos hasta la reincorporación del legendario modo Simulación GT, disfruta de las mejores funcionalidades de las anteriores entregas de la serie",
"ps plus": "Si te apasiona la velocidad, practica y compite en los Campeonatos FIA y en el modo Sport, requiere subscripción a PS Plus para el modo multijugador",
"variedad":"Recuerda que no todo es correr en Gran Turismo 7, perfecciona y crea en el nuevo modo de diseño y personalización o mejora tus habilidades y estrategias de carrera en la escuela de conducción"
}'
);




-- 8     Legend of Zelda:Breath of the Wild Nintendo Switch
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
55.99,
'Legend of Zelda:Breath of the Wild Nintendo Switch',
'/imagenes/consola/juegos/Legend of Zelda_Breath of the Wild Nintendo Switch.jpeg',
'Te presentamos Legend of Zelda:Breath of the Wild para Nintendo Switch, vive la nueva aventura de Link en este nuevo mundo, plagado de novedades y nuevas mecánicas. ¡Y por primera vez en la saga, voces en castellano!',
10,
'consola',
'juegos',
'{
"Entra en un mundo de aventura":"Olvida todo lo que sabes sobre los juegos de The Legend of Zelda. Entra en un mundo de descubrimientos, exploración y aventura en The Legend of Zelda: Breath of the Wild, un nuevo juego de la aclamada serie que rompe con las convenciones. Viaja por prados, bosques y cumbres montañosas para descubrir qué ha sido del asolado reino de Hyrule en esta maravillosa aventura a cielo abierto.",
"Explora las tierras de Hyrule como más te guste": "Escala torres y montañas en busca de nuevos destinos y sigue tu propio camino para llegar hasta ellos. Por el camino lucharás contra enormes enemigos, cazarás feroces bestias y recolectarás ingredientes para preparar las comidas y elixires que te permitirán subsistir durante tu aventura.",
"Más de 100 santuarios que descubrir y explorar": "Los santuarios salpican en paisaje de Hyrule y están esperando a ser descubiertos por ti en cualquier orden. Búscalos de diversas maneras y resuelve los diversos puzles que albergan. Ábrete camino entre las trampas e ingenios mecánicos de los santuarios para conseguir objetos especiales y otras recompensas que te serán de ayuda en tu aventura.",
"Prepárate y equípate a conciencia": "Un mundo entero está esperando a que lo explores, y para llegar hasta todos sus rincones necesitarás variedad de atuendos y equipamiento. Tendrás que abrigarte o vestir ropas más ligeras para adaptarte a climas gélidos y calores desérticos. Algunas prendas de ropa producirán incluso ciertos efectos, como hacerte más rápido o sigiloso.",
"Luchar contra los enemigos requiere estrategia":"El mundo está habitado por enemigos de todas las formas y tamaños. Cada uno tiene sus propias armas y métodos de ataque, así que se impone pensar rápido y desarrollar las estrategias adecuadas para derrotarlos.",
"Aventúrate con amiibo": "Nuevos usos de amiibo para Legend of Zelda:Breath of the Wild"
}'
);




-- 9     Super Smash Bros Ultimate Nintendo Switch
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
55.99,
'Super Smash Bros Ultimate Nintendo Switch',
'/imagenes/consola/juegos/Super Smash Bros Ultimate Nintendo Switch.jpeg',
'¿Puede Link derrotar a Mario? ¿Puede Yoshi tumbar a Donkey Kong? ¿Puede Kirby darle una paliza a Pikachu? Descúbrelo en Super Smash Bros para Nintendo Switch Antes de Super Smash Bros Melee para Nintendo Gamecube, estas y otras viejas preguntas encontraron respuesta inmediata con Super Smash Bros para Nintendo 64, el juego original de lucha por torneos con todas las estrellas de Nintendo. Así, podrás enfrentar entre sí a los personajes más populares de Nintendo.',
10,
'consola',
'juegos',
'{
"Super Smash Bros": "está también lleno de sorpresas; en el escenario de Pikachu, por ejemplo, aparecen multitud de Pokémon para ayudar y poner en dificultades a los combatientes. Resulta extraño ver a dos buenos chicos como Mario y Fox McCloud golpeando cabezas, pero no te preocupes, cuando acabe la lucha, descubrirás que todos los personajes son en realidad buenos amigos.",
"mundos": "Luchadores y mundos de juego míticos colisionan en el enfrentamiento definitivo: ¡una nueva entrada de la serie Super Smash Bros. para Nintendo Switch!",
"luchadores": "Nuevos luchadores, como los inklings de la serie Splatoon y Ridley de la serie Metroid, hacen su debut en Super Smash Bros. junto a todos los personajes de las entregas anteriores. ¡Todos!",
"habilidades":"Un combate más ágil, nuevos objetos, nuevos ataques, nuevas opciones defensivas y otras muchas sorpresas mantendrán la batalla al rojo vivo cuando y donde quieras."
}'
);



-- 10     Mario Party Superstars Nintendo Switch
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
50.99,
'Mario Party Superstars Nintendo Switch',
'/imagenes/consola/juegos/Mario Party Superstars Nintendo Switch.jpeg',
'¡Es hora de montar una fiesta irrepetible! Disfruta de 5 tableros clásicos de Nintendo 64 y de 100 minijuegos de distintas entregas de la serie en Mario Party Superstars para Nintendo Switch.¡Vuelve Mario Party con 5 tableros clásicos de las entregas de Nintendo 64! Ábrete paso por un escenario delicioso (¡literalmente!) para echarles el guante al mayor número de estrellas mientras se lo pones difícil a tus oponentes en El pastel de cumpleaños de Peach, un tablero del juego original de Mario Party. O vigila con mucha atención la cuenta atrás que activa el rayo de monedas de Bowser y aférrate a tus monedas en La estación espacial. ¡El curso de la partida puede cambiar en cualquier momento en Mario Party, así que más te vale andarte con ojo! ¡Además, este y otros modos están disponibles en el juego en línea! ',
10,
'consola',
'juegos',
'{
"Juego de edición": "Básico",
"Versión de idioma": "Alemán, Inglés",
"Plataforma": "Nintendo Switch",
"Género del juego": "Juego de socialización",
"Explorador":"NDcube",
"Fecha de lanzamiento (dd/mm/aa)":"29/10/2021",
"Clasificación PEGI": "7",
"Editor": "Nintendo"
}'
);



-- 11     Rainbow Six Siege Advanced Edition Xbox One
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
17.99,
'Rainbow Six Siege Advanced Edition Xbox One',
'/imagenes/consola/juegos/Rainbow Six Siege Advanced Edition Xbox One.jpeg',
'Rainbow Six Siege es el nombre de la próxima entrega de la aclamada serie de shooters en primera persona, desarrollada por el reconocido estudio de Ubisoft Montreal para la nueva generación de consolas y PC.',
10,
'consola',
'juegos',
'{
"La destrucción como herramienta":"La destrucción es vital en el concepto del asedio. Todos los elementos del escenario reaccionan de forma realista y dinámica, en función del calibre de la munición utilizada o de la cantidad de explosivo que hayas puesto. Las paredes pueden volarse para abrir otras líneas de disparo, y los techos y suelos derribarse para crear otros puntos de acceso. Dominar el arte de la destrucción será en muchos casos la clave de la victoria.",
"Juego basado en equipo": "En Rainbow Six Siege la coordinación será fundamental para el éxito de la misión. Únete a tus amigos y disfruta con una mejor experiencia multijugador. Lucha en enfrentamientos intensos de rango cercano de tipo Jugador contra Jugador (JcJ) o Jugador contra Entorno (JcE) y vence al enemigo eligiendo las tácticas adecuadas. Crea un equipo basado en la coordinación y prepara mejores estrategias para convertirte en un maestro de la destrucción.",
"El asedio como concepto de juego": "El Asedio es un concepto de juego que refleja la realidad que viven los especialistas de lucha antiterrorista de todo el mundo: combates de rango cercano intenso y asimétricos entre atacantes y defensores. Como defensor tendrás a tu alcance los medios para transformar tu entorno en una fortaleza y evitar que los atacantes irrumpan en ella. Como atacante, podrás planificar el asalto con diferentes estrategias que te permitan afrontar el desafío y solucionar las situaciones de crisis."
}'
);



-- 12     Overwatch Legendary Edition Xbox One
INSERT INTO producto (precio, nombre_producto, imagen, descripcion, stock, tipo, subcategoria, detalles)
VALUES (
33.99,
'Overwatch Legendary Edition Xbox One',
'/imagenes/consola/juegos/Overwatch Legendary Edition Xbox One.jpeg',
'Soldados. Científicos. Aventureros. Prodigios. En una época de crisis global, un escuadrón internacional de héroes se formó para devolver la paz a un mundo devastado por la guerra: Overwatch. Juntos pusieron fin a la crisis y mantuvieron la paz en las décadas posteriores, dando pie a toda una era de exploración, innovación y descubrimiento. Sin embargo, muchos años después, la influencia de Overwatch disminuyó y esta acabó por disolverse.',
10,
'consola',
'juegos',
'{
"Elige un héroe": "Overwatch presenta un amplio reparto de héroes únicos: desde una aventurera del espacio-tiempo hasta un caballero con un martillo a reacción, pasando por un robot monje espiritual. Cada héroe se juega de forma distinta, y dominar sus habilidades es la clave para desplegar todo su potencial. No hay dos héroes iguales.",
"Desempeña tu función": "Tanto si prefieres combatir en el frente como si optas por proteger a tus aliados con un escudo de energía o ayudarlos aumentando el daño que infligen, las habilidades de cada héroe están diseñadas para ser eficaces en un contexto de equipo. Utilizar tus habilidades de forma coordinada con tus compañeros de equipo es la clave de la victoria.",
"Objetivos por equipos": "Varios héroes se enfrentan por equipos por todo el planeta. Tanto si proteges los secretos del misterioso Templo de Anubis como si escoltas un dispositivo de PEM por King´s Row, el mundo es tu campo de batalla."
}'
);







 
































































