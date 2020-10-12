-- Práctica 6 
-- DB: agencia_personal
-- 1
DROP TEMPORARY TABLE IF EXISTS emp_contratos;
CREATE TEMPORARY TABLE emp_contratos (
	SELECT con.cuit, em.razon_social, con.dni, per.apellido, per.nombre, con.cod_cargo, car.desc_cargo
		FROM contratos con 
        INNER JOIN cargos car ON car.cod_cargo = con.cod_cargo
        INNER JOIN empresas em ON em.cuit = con.cuit
        INNER JOIN personas per ON per.dni = con.dni
);
DROP TEMPORARY TABLE IF EXISTS emp_antecedentes;
CREATE TEMPORARY TABLE emp_antecedentes (
	SELECT a.cuit, em.razon_social, a.dni, per.apellido, per.nombre, a.cod_cargo, car.desc_cargo
		FROM antecedentes a 
        INNER JOIN cargos car ON car.cod_cargo = a.cod_cargo
        INNER JOIN empresas em ON em.cuit = a.cuit
        INNER JOIN personas per ON per.dni = a.dni
);
SELECT *, "Antecedentes" AS "Contrato o antecedente" FROM emp_antecedentes UNION SELECT *, "Contrato" AS "Contrato o antecedente" FROM emp_contratos
	ORDER BY razon_social DESC;
-- 2
DROP TEMPORARY TABLE IF EXISTS emp_contratos;
CREATE TEMPORARY TABLE emp_contratos (
	SELECT con.cuit, count(DISTINCT con.dni) AS cantidad
		FROM contratos con 
        GROUP BY con.cuit
);
DROP TEMPORARY TABLE IF EXISTS emp_antecedentes;
CREATE TEMPORARY TABLE emp_antecedentes (
	SELECT a.cuit, count(DISTINCT a.dni) AS cantidad
		FROM antecedentes a 
        GROUP BY a.cuit
);
SELECT count(*) INTO @total
	FROM personas;
SELECT em.cuit, em.razon_social, ifnull(ec.cantidad, 0) , ifnull(ec.cantidad * @total /100, 0.0000)
	FROM empresas em 
    LEFT JOIN emp_contratos ec ON em.cuit = ec.cuit
UNION
SELECT em.cuit, em.razon_social, ifnull(ea.cantidad, 0) , ifnull(ea.cantidad * @total /100, 0.0000)
	FROM empresas em 
    LEFT JOIN emp_antecedentes ea ON em.cuit = ea.cuit;
-- 3
DROP TEMPORARY TABLE IF EXISTS emp_solicitantes;
CREATE TEMPORARY TABLE emp_solicitantes (
	SELECT em.cuit, em.razon_social, sol.fecha_solicitud, car.desc_cargo
		FROM empresas em
		INNER JOIN solicitudes_empresas sol ON sol.cuit = em.cuit
		INNER JOIN cargos car ON car.cod_cargo = sol.cod_cargo
);
DROP TEMPORARY TABLE IF EXISTS emp_sin_solicitudes;
CREATE TEMPORARY TABLE emp_sin_solicitudes (
	SELECT em.cuit, em.razon_social
		FROM empresas em
		WHERE em.cuit NOT IN (
			SELECT em.cuit
				FROM empresas em
				INNER JOIN solicitudes_empresas sol ON sol.cuit = em.cuit
		)
);
DROP TEMPORARY TABLE IF EXISTS cargos_sin_solicitar;
CREATE TEMPORARY TABLE cargos_sin_solicitar (
	SELECT cod_cargo, desc_cargo
		FROM cargos
        WHERE cod_cargo NOT IN (
			SELECT cod_cargo
				FROM solicitudes_empresas
		)
);
SELECT em.cuit, em.razon_social, esol.fecha_solicitud AS "Fecha Solicitud", esol.desc_cargo AS "Cargo"
	FROM empresas em
    INNER JOIN emp_solicitantes esol ON esol.cuit = em.cuit
UNION
SELECT em.cuit, em.razon_social, "Sin Solicitud" AS "Fecha Solicitud", "Sin Solicitud" AS "Cargo"
	FROM empresas em
	INNER JOIN emp_sin_solicitudes esin ON esin.cuit = em.cuit
UNION
SELECT "Cargo No Solicitado" AS cuit, "Cargo No Solicitado" AS razon_social, "Sin Solicitud" AS "Fecha Solicitud", carsin.desc_cargo AS "Cargo"
	FROM cargos car
    INNER JOIN cargos_sin_solicitar carsin ON carsin.cod_cargo = car.cod_cargo;
-- 4
DROP TEMPORARY TABLE IF EXISTS personas_contratadas;
CREATE TEMPORARY TABLE personas_contratadas (
	SELECT DISTINCT per.dni, per.apellido, per.nombre
		FROM personas per
        INNER JOIN contratos con ON con.dni = per.dni
);
DROP TEMPORARY TABLE IF EXISTS personas_antecedentes;
CREATE TEMPORARY TABLE personas_antecedentes (
	SELECT DISTINCT per.dni, per.apellido, per.nombre
		FROM personas per
        INNER JOIN antecedentes a ON a.dni = per.dni
);
SELECT per.dni, per.apellido, per.nombre
	FROM personas per
    INNER JOIN personas_contratadas pc ON pc.dni = per.dni
    INNER JOIN personas_antecedentes pa ON pa.dni = per.dni;