# SQL Manager 2005 Lite for MySQL 3.7.0.1
# ---------------------------------------
# Host     : localhost
# Port     : 3306
# Database : ferreteria


SET FOREIGN_KEY_CHECKS=0;

DROP DATABASE IF EXISTS `ferreteria`;

CREATE DATABASE `ferreteria`
    CHARACTER SET 'utf8'
    COLLATE 'utf8_general_ci';

USE `ferreteria`;

#
# Structure for the `categorias` table : 
#

DROP TABLE IF EXISTS `categorias`;

CREATE TABLE `categorias` (
  `ID_Categoria` int(11) NOT NULL,
  `Nom_Categoria` varchar(20) default NULL,
  `Descri_Categ` varchar(20) default NULL,
  PRIMARY KEY  (`ID_Categoria`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# Structure for the `descuentos_ventas` table : 
#

DROP TABLE IF EXISTS `descuentos_ventas`;

CREATE TABLE `descuentos_ventas` (
  `Fecha_Vigencia` date NOT NULL,
  `Monto_Desde` decimal(11,2) NOT NULL,
  `Porc_Descuento` float(9,3) default NULL,
  PRIMARY KEY  (`Fecha_Vigencia`,`Monto_Desde`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# Structure for the `provincias` table : 
#

DROP TABLE IF EXISTS `provincias`;

CREATE TABLE `provincias` (
  `Id_Pcia` int(11) NOT NULL,
  `Nom_pcia` varchar(20) NOT NULL,
  PRIMARY KEY  (`Id_Pcia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# Structure for the `localidades` table : 
#

DROP TABLE IF EXISTS `localidades`;

CREATE TABLE `localidades` (
  `Cod_Postal` int(11) NOT NULL,
  `ciudad` varchar(20) NOT NULL,
  `Id_Pcia` int(11) NOT NULL,
  PRIMARY KEY  (`Cod_Postal`),
  KEY `Id_Pcia` (`Id_Pcia`),
  CONSTRAINT `localidades_fk` FOREIGN KEY (`Id_Pcia`) REFERENCES `provincias` (`Id_Pcia`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# Structure for the `personas` table : 
#

DROP TABLE IF EXISTS `personas`;

CREATE TABLE `personas` (
  `Cuit` bigint(11) NOT NULL,
  `Razon_Social` varchar(20) NOT NULL,
  `Direccion` varchar(30) NOT NULL,
  `Telefono` varchar(20) default NULL,
  `E-mail` varchar(25) default NULL,
  `Direc_WEB` varchar(20) default NULL,
  `Cod_Postal` int(11) NOT NULL,
  PRIMARY KEY  (`Cuit`),
  KEY `Cod_Postal` (`Cod_Postal`),
  CONSTRAINT `personas_fk` FOREIGN KEY (`Cod_Postal`) REFERENCES `localidades` (`Cod_Postal`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# Structure for the `productos` table : 
#

DROP TABLE IF EXISTS `productos`;

CREATE TABLE `productos` (
  `ID_Producto` int(11) NOT NULL,
  `Descripc_Prod` varchar(30) default NULL,
  `Stock` int(11) default NULL,
  `ID_Categoria` int(11) NOT NULL,
  PRIMARY KEY  (`ID_Producto`),
  KEY `ID_Categoria` (`ID_Categoria`),
  CONSTRAINT `producto_fk` FOREIGN KEY (`ID_Categoria`) REFERENCES `categorias` (`ID_Categoria`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# Structure for the `productos_proveedores` table : 
#

DROP TABLE IF EXISTS `productos_proveedores`;

CREATE TABLE `productos_proveedores` (
  `Cuit` bigint(11) NOT NULL,
  `ID_Producto` int(11) NOT NULL,
  PRIMARY KEY  (`Cuit`,`ID_Producto`),
  KEY `Cuit` (`Cuit`),
  KEY `ID_Categoria` (`ID_Producto`),
  CONSTRAINT `productos_proveedores_fk1` FOREIGN KEY (`Cuit`) REFERENCES `personas` (`Cuit`),
  CONSTRAINT `productos_proveedores_fk` FOREIGN KEY (`ID_Producto`) REFERENCES `productos` (`ID_Producto`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# Structure for the `pedidos` table : 
#

DROP TABLE IF EXISTS `pedidos`;

CREATE TABLE `pedidos` (
  `ID_Pedido` int(11) NOT NULL,
  `Fecha_Ped` date NOT NULL,
  `Cuit` bigint(11) NOT NULL,
  PRIMARY KEY  (`ID_Pedido`),
  KEY `Cuit` (`Cuit`),
  CONSTRAINT `pedidos_fk` FOREIGN KEY (`Cuit`) REFERENCES `personas` (`Cuit`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# Structure for the `detalle_pedidos` table : 
#

DROP TABLE IF EXISTS `detalle_pedidos`;

CREATE TABLE `detalle_pedidos` (
  `Cuit` bigint(11) NOT NULL,
  `ID_Producto` int(11) NOT NULL,
  `ID_Pedido` int(11) NOT NULL,
  `Cantidad` int(11) default NULL,
  PRIMARY KEY  (`Cuit`,`ID_Producto`,`ID_Pedido`),
  KEY `Cuit` (`Cuit`,`ID_Producto`),
  KEY `ID_Pedido` (`ID_Pedido`),
  CONSTRAINT `detalle_pedidos_fk` FOREIGN KEY (`Cuit`, `ID_Producto`) REFERENCES `productos_proveedores` (`Cuit`, `ID_Producto`),
  CONSTRAINT `detalle_pedidos_fk1` FOREIGN KEY (`ID_Pedido`) REFERENCES `pedidos` (`ID_Pedido`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# Structure for the `precios` table : 
#

DROP TABLE IF EXISTS `precios`;

CREATE TABLE `precios` (
  `Fecha_Desde` date NOT NULL,
  `Cuit` bigint(11) NOT NULL,
  `ID_Producto` int(11) NOT NULL,
  `Precio` decimal(11,2) default NULL,
  PRIMARY KEY  (`Fecha_Desde`,`Cuit`,`ID_Producto`),
  KEY `ID_Categoria` (`ID_Producto`,`Cuit`),
  KEY `Cuit` (`Cuit`,`ID_Producto`),
  CONSTRAINT `precios_fk` FOREIGN KEY (`Cuit`, `ID_Producto`) REFERENCES `productos_proveedores` (`Cuit`, `ID_Producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# Data for the `categorias` table  (LIMIT 0,500)
#

INSERT INTO `categorias` (`ID_Categoria`, `Nom_Categoria`, `Descri_Categ`) VALUES 
  (123,'Herramientas','Productos para trabo'),
  (124,'Pinturas','Para pintar');

COMMIT;

#
# Data for the `descuentos_ventas` table  (LIMIT 0,500)
#

INSERT INTO `descuentos_ventas` (`Fecha_Vigencia`, `Monto_Desde`, `Porc_Descuento`) VALUES 
  ('2010-09-09',23.4,12.89),
  ('2010-09-21',15.5,21.5);

COMMIT;

#
# Data for the `provincias` table  (LIMIT 0,500)
#

INSERT INTO `provincias` (`Id_Pcia`, `Nom_pcia`) VALUES 
  (1,'Santa Fe'),
  (2,'Salta');

COMMIT;

#
# Data for the `localidades` table  (LIMIT 0,500)
#

INSERT INTO `localidades` (`Cod_Postal`, `ciudad`, `Id_Pcia`) VALUES 
  (2000,'Rosario',1),
  (2505,'Las Parejas',1);

COMMIT;

#
# Data for the `personas` table  (LIMIT 0,500)
#

INSERT INTO `personas` (`Cuit`, `Razon_Social`, `Direccion`, `Telefono`, `E-mail`, `Direc_WEB`, `Cod_Postal`) VALUES 
  (12345678891,'Tornillos SRL','Urquiza','888','contacto@tornillos.com.ar','www.tornillos.com.ar',2000),
  (12345678900,'La Ferre SA','San Martin','455-5500','laferre@gmail.com','www.laferresa.com',2505);

COMMIT;

#
# Data for the `productos` table  (LIMIT 0,500)
#

INSERT INTO `productos` (`ID_Producto`, `Descripc_Prod`, `Stock`, `ID_Categoria`) VALUES 
  (456,'Pintura Latex',20,124),
  (789,'Martillo',10,123);

COMMIT;

#
# Data for the `productos_proveedores` table  (LIMIT 0,500)
#

INSERT INTO `productos_proveedores` (`Cuit`, `ID_Producto`) VALUES 
  (12345678891,456),
  (12345678900,789);

COMMIT;

#
# Data for the `pedidos` table  (LIMIT 0,500)
#

INSERT INTO `pedidos` (`ID_Pedido`, `Fecha_Ped`, `Cuit`) VALUES 
  (1,'2010-08-02',12345678900),
  (2,'2010-12-22',12345678891);

COMMIT;

#
# Data for the `detalle_pedidos` table  (LIMIT 0,500)
#

INSERT INTO `detalle_pedidos` (`Cuit`, `ID_Producto`, `ID_Pedido`, `Cantidad`) VALUES 
  (12345678891,456,2,10),
  (12345678900,789,1,5);

COMMIT;

#
# Data for the `precios` table  (LIMIT 0,500)
#

INSERT INTO `precios` (`Fecha_Desde`, `Cuit`, `ID_Producto`, `Precio`) VALUES 
  ('2010-07-22',12345678891,456,50.99),
  ('2010-08-02',12345678900,789,25.5);

COMMIT;

