-- Práctica 3 - Funciones de presentación de datos
-- DB: agencia_personal
-- 1
SELECT nro_contrato, fecha_incorporacion, fecha_finalizacion_contrato, adddate(fecha_incorporacion, interval 30 day) 'Fecha Caducidad'
	FROM contratos
	WHERE fecha_caducidad IS NULL;
-- 2
SELECT con.nro_contrato, em.razon_social, p.nombre, p.apellido, con.fecha_incorporacion, ifnull(con.fecha_caducidad,"Sin caducidad")
FROM contratos con
INNER JOIN empresas em ON em.cuit = con.cuit
INNER JOIN personas p ON p.dni = con.dni;
-- 3
SELECT *, datediff(fecha_finalizacion_contrato, fecha_caducidad) 'dias_restantes'
	FROM contratos
    WHERE fecha_caducidad < fecha_finalizacion_contrato;
-- 4 
SELECT em.cuit, em.razon_social, em.direccion, com.anio_contrato, com.mes_contrato, com.importe_comision, adddate(CURRENT_DATE(), INTERVAL 2 MONTH) 'fecha vencimiento'
	FROM contratos con
    INNER JOIN comisiones com ON com.nro_contrato = con.nro_contrato
    INNER JOIN empresas em ON em.cuit = con.cuit
	WHERE com.fecha_pago IS NULL;
-- 5
SELECT concat(apellido, " ", nombre) 'Apellido y Nombre', fecha_nacimiento, DAY(fecha_nacimiento) 'Día', MONTH(fecha_nacimiento) 'Mes', YEAR(fecha_nacimiento) 'Año'
	FROM personas;