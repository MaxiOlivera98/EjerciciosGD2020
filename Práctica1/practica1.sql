-- Práctica SQL
-- Práctica 1 - sentencia SELECT
-- 1
describe empresas;
select * from empresas;
-- 2
describe personas;
select apellido, nombre, fecha_registro_agencia from personas;
-- 3
DROP TABLE IF EXISTS titulos2; 
CREATE TABLE `titulos2` (	
  `Codigo` int NOT NULL,	
  `Descripcion` varchar(50) NOT NULL,	
  `Tipo` varchar(20) NOT NULL,
  PRIMARY KEY (`Codigo`)	
);
describe titulos2;
INSERT INTO titulos2 (Codigo, Descripcion, Tipo) 
	VALUES (1, 'Tecnico Electronico', 'Secundario'),
		   (2, 'Diseñador de Interiores', 'Terciario'),
		   (3, 'Tecnico Mecanico', 'Secundario'),
		   (4, 'Payaso de Circo', 'Educacion no formal'),
		   (5, 'Arquitecto', 'Universitario'),
           (6, 'Entrenador de Lemures', 'Educacion no formal'),
           (7, 'Ing en Sist de Inf', 'Universitario'),
           (8, 'Bachiller', 'Secundario');
SELECT *
	FROM titulos2
    ORDER BY titulos2.Descripcion;
-- 4
SELECT concat(apellido, ", ", nombre) "Apellido y Nombre", fecha_nacimiento "Fecha Nac.", Telefono "Teléfono", direccion "Dirección"
	FROM personas
    WHERE dni = "28675888";
-- 5
SELECT concat(apellido, ", ", nombre) "Apellido y Nombre", fecha_nacimiento "Fecha Nac.", Telefono "Teléfono", direccion "Dirección"
	FROM personas
    WHERE dni = "27890765" OR dni = "29345777" OR dni = "31345778"
    ORDER BY fecha_nacimiento;
-- 6
SELECT *
	FROM personas
    WHERE apellido LIKE "g%";
-- 7
SELECT nombre, apellido, fecha_nacimiento
	FROM personas
    WHERE fecha_nacimiento BETWEEN "1980-01-01" AND "2000-12-31";
-- 8
SELECT *
	FROM solicitudes_empresas
    ORDER BY fecha_solicitud;
-- 9
SELECT *
	FROM antecedentes
    WHERE fecha_hasta IS NULL
    ORDER BY fecha_desde;
-- 10
SELECT dni, cod_cargo, fecha_desde, fecha_hasta
	FROM antecedentes
    WHERE fecha_hasta NOT BETWEEN "2013-06-01" AND "2013-12-31"
    ORDER BY dni;
-- 11
SELECT nro_contrato "Nro Contrato", dni "DNI", sueldo "Salario", cuit "Cuil"
	FROM contratos
    WHERE sueldo > 2000 AND (cuit = "30-10504876-5" OR cuit = "30-21098732-4");
-- 12
SELECT *
	FROM titulos
    WHERE desc_titulo LIKE "%Tecnico%";
-- 13
SELECT *
	FROM solicitudes_empresas
    WHERE (fecha_solicitud > "2013-09-21" AND cod_cargo = 6) OR sexo = "Femenino";
-- 14
SELECT *
	FROM contratos
    WHERE sueldo > 2000 AND fecha_caducidad IS NULL;