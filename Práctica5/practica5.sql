-- Práctica 5 - Subconsultas, Tablas Temporales y Variables
-- DB: agencia_personal
-- 1
SELECT DISTINCT p.dni, p.apellido, p.nombre
	FROM personas p
    INNER JOIN contratos c ON p.dni = c.dni
    WHERE c.cuit IN
	(SELECT con.cuit
		FROM contratos con
		INNER JOIN personas per ON con.dni = per.dni
		WHERE apellido LIKE "L_pez" AND nombre LIKE "Stef%");
-- 2
SELECT max(sueldo) INTO @maxi
	FROM contratos con
    INNER JOIN empresas em ON con.cuit = em.cuit
    WHERE razon_social LIKE '%viejos amigos%';
SELECT @maxi;
SELECT per.dni, concat(per.apellido, ' ', per.nombre), con.sueldo
	FROM personas per
    INNER JOIN contratos con ON con.dni = per.dni
    WHERE con.sueldo < @maxi;
-- 3 por variable
SELECT avg(importe_comision) into @prome
	FROM comisiones com
    INNER JOIN contratos con ON com.nro_contrato = con.nro_contrato
    INNER JOIN empresas em ON con.cuit = em.cuit
	WHERE razon_social LIKE "Tr_igame%";
SELECT @prome;
SELECT em.cuit, razon_social, avg(importe_comision)
	FROM empresas em
    INNER JOIN contratos con ON em.cuit = con.cuit
    INNER JOIN comisiones com ON con.nro_contrato = com.nro_contrato
    GROUP BY em.cuit, razon_social 
    HAVING avg (importe_comision) > @prome;
-- 3 por subconsulta
SELECT em.cuit, razon_social, avg(importe_comision)
	FROM empresas em
    INNER JOIN contratos con ON em.cuit = con.cuit
    INNER JOIN comisiones com ON con.nro_contrato = com.nro_contrato
    GROUP BY em.cuit, razon_social 
    HAVING avg (importe_comision) > 
		(SELECT avg(importe_comision)
			FROM comisiones com
			INNER JOIN contratos con ON com.nro_contrato = con.nro_contrato
			INNER JOIN empresas em ON con.cuit = em.cuit
			WHERE razon_social LIKE "Tr_igame%");
-- 4
SELECT avg(importe_comision) into @prome
	FROM comisiones;
SELECT @prome;
SELECT em.razon_social, per.nombre, per.apellido, con.nro_contrato, com.mes_contrato, com.anio_contrato, com.importe_comision
	FROM contratos con
	INNER JOIN empresas em ON em.cuit = con.cuit
    INNER JOIN personas per ON per.dni = con.dni
    INNER JOIN comisiones com ON com.nro_contrato = con.nro_contrato
    WHERE com.importe_comision < @prome;
-- 5 	Agrego WHERE fecha_pago IS NOT NULL para obtener las empresas que pagaron todas las comisiones
DROP TEMPORARY TABLE IF EXISTS prome;
CREATE TEMPORARY TABLE prome
SELECT em.cuit, razon_social, avg(importe_comision) promcom
	FROM empresas em
    INNER JOIN contratos con ON em.cuit = con.cuit
    INNER JOIN comisiones com ON con.nro_contrato = com.nro_contrato
    WHERE fecha_pago IS NOT NULL
    GROUP BY em.cuit, razon_social;
SELECT * FROM prome;
SELECT max(promcom) INTO @maxi
	FROM prome;
SELECT razon_social, promcom
	FROM prome
    WHERE promcom = @maxi;
-- 6
SELECT p.apellido, p.nombre
	FROM personas p
    WHERE p.dni NOT IN
    (SELECT pt.dni
		FROM personas_titulos pt 
        INNER JOIN titulos tit ON tit.cod_titulo = pt.cod_titulo
        WHERE tit.tipo_titulo = 'Terciario' OR tit.tipo_titulo = 'Educacion no formal');
-- 7
DROP TEMPORARY TABLE IF EXISTS prome;
CREATE TEMPORARY TABLE prome
SELECT cuit, avg(sueldo) prom
	FROM contratos con
    GROUP BY cuit;
SELECT *
	FROM prome;
SELECT con.cuit, con.dni, con.sueldo, prome.prom
	FROM contratos con
    INNER JOIN prome ON prome.cuit = con.cuit
    WHERE con.sueldo > prome.prom;
-- 8
DROP TEMPORARY TABLE IF EXISTS promedio;
CREATE TEMPORARY TABLE promedio
SELECT cuit, avg(com.importe_comision) comision
	FROM contratos con
    INNER JOIN comisiones com ON com.nro_contrato = con.nro_contrato
	WHERE fecha_pago IS NOT NULL
    GROUP BY cuit;
SELECT max(comision), min(comision) INTO @max, @min
	FROM promedio;
SELECT @max, @min;
SELECT emp.cuit, emp.razon_social, comision 
	FROM promedio prom
	INNER JOIN empresas emp ON prom.cuit = emp.cuit
    WHERE comision = @max OR comision = @min;
-- BD AFATSE
-- 9
SELECT count(*) INTO @cant
	FROM inscripciones i
    INNER JOIN alumnos a ON a.dni = i.dni
    WHERE a.nombre LIKE "Antoine de" AND a.apellido LIKE "Saint-Exupery";
SELECT @cant;
SELECT a.dni, a.nombre, a.apellido, a.direccion, a.email, a.tel, count(*), count(*) - @cant
	FROM inscripciones i
	INNER JOIN alumnos a ON a.dni = i.dni
    GROUP BY a.dni, a.nombre, a.apellido, a.direccion, a.email, a.tel
    HAVING count(*) > @cant;
-- 10
SELECT count(*) INTO @total
	FROM inscripciones ins
	WHERE year(ins.fecha_inscripcion) = 2014;
SELECT ins.nom_plan, count(*), count(*)*100/@total "% total"
	FROM inscripciones ins
	WHERE year(ins.fecha_inscripcion) = 2014
	GROUP BY nom_plan;
-- 11
DROP TEMPORARY TABLE IF EXISTS ult_fecha;
CREATE TEMPORARY TABLE ult_fecha ( 
	SELECT nom_plan, max(fecha_desde_plan) AS fecha_desde
	FROM valores_plan
	GROUP BY nom_plan
);
select * from ult_fecha;
SELECT DISTINCT  vp.nom_plan, uf.fecha_desde, vp.valor_plan
FROM valores_plan vp
INNER JOIN ult_fecha uf ON uf.fecha_desde = vp.fecha_desde_plan AND uf.nom_plan = vp.nom_plan;
-- 11 otra forma de solucionar
SELECT vp.nom_plan, maxif, vp.valor_plan
	FROM valores_plan vp 
	INNER JOIN
		(SELECT vp.nom_plan, max(vp.fecha_desde_plan) maxif
			FROM valores_plan vp
			WHERE vp.fecha_desde_plan <= current_date
			GROUP BY  vp.nom_plan)
	maxi ON vp.nom_plan = maxi.nom_plan AND vp.fecha_desde_plan = maxif;
-- 12
DROP TEMPORARY TABLE IF EXISTS ult_fecha;
CREATE TEMPORARY TABLE ult_fecha ( 
	SELECT vp.nom_plan, max(vp.fecha_desde_plan) maxif
			FROM valores_plan vp
			WHERE vp.fecha_desde_plan <= current_date
			GROUP BY  vp.nom_plan
);
DROP TEMPORARY TABLE IF EXISTS ult_precio;
CREATE TEMPORARY TABLE ult_precio (
	SELECT DISTINCT  vp.nom_plan AS nom_plan, vp.valor_plan AS valor_plan
	FROM valores_plan vp
	INNER JOIN ult_fecha uf ON uf.maxif = vp.fecha_desde_plan
);
SELECT min(valor_plan) INTO @mini
	FROM ult_precio;
SELECT up.nom_plan, pc.desc_plan, pc.hs, pc.modalidad, up.valor_plan
	FROM ult_precio up
    INNER JOIN plan_capacitacion pc ON pc.nom_plan = up.nom_plan
	WHERE up.valor_plan = @mini;
-- 13
DROP TEMPORARY TABLE IF EXISTS inst_2014;
CREATE TEMPORARY TABLE inst_2014 ( 
	SELECT DISTINCT ci.cuil
		FROM cursos_instructores ci
		INNER JOIN cursos cur ON cur.nro_curso = ci.nro_curso AND cur.nom_plan = ci.nom_plan
		WHERE ci.nom_plan LIKE "Marketing 1" AND YEAR(cur.fecha_ini) = 2014
);
SELECT ins.cuil
	FROM inst_2014 ins
    WHERE ins.cuil NOT IN (
		SELECT DISTINCT ci.cuil
		FROM cursos_instructores ci
		INNER JOIN cursos cur ON cur.nro_curso = ci.nro_curso AND cur.nom_plan = ci.nom_plan
		WHERE ci.nom_plan LIKE "Marketing 1" AND YEAR(cur.fecha_ini) = 2015
);
-- 14
SELECT * FROM alumnos
	WHERE dni NOT IN (SELECT dni FROM cuotas WHERE fecha_pago IS NULL);
-- 15
DROP TEMPORARY TABLE IF EXISTS promedios; 
CREATE TEMPORARY TABLE promedios(
	SELECT nro_curso, nom_plan, avg(nota) prome
		FROM evaluaciones e
        GROUP BY nro_curso,nom_plan);
SELECT e.dni, concat(a.nombre, " ", a.apellido) nombre, avg(e.nota), prome
	FROM evaluaciones e
    INNER JOIN promedios ON e.nro_curso = promedios.nro_curso AND e.nom_plan = promedios.nom_plan
    INNER JOIN alumnos a ON e.dni = a.dni
    GROUP BY e.dni
    HAVING avg(nota) > prome
    ORDER BY nombre;
-- 16
DROP TEMPORARY TABLE IF EXISTS cursos_abril; 
CREATE TEMPORARY TABLE cursos_abril (
	SELECT cur.nom_plan, cur.nro_curso, cur.fecha_ini
		FROM cursos cur 
        WHERE fecha_ini >= "2014-04-01"
);
SELECT cur.nom_plan, cur.nro_curso, cur.salon, cur.cupo, count(i.dni), (cur.cupo - count(i.dni))
	FROM cursos cur 
    INNER JOIN inscripciones i ON i.nom_plan = cur.nom_plan AND i.nro_curso = cur.nro_curso
    INNER JOIN cursos_abril ca ON ca.nom_plan = cur.nom_plan AND ca.nro_curso = cur.nro_curso
    GROUP BY cur.nom_plan, cur.nro_curso
    HAVING (cur.cupo - count(i.dni)) >= ((cur.cupo * 80) / 100); 
-- 17
DROP TEMPORARY TABLE IF EXISTS ult_fecha; 
CREATE TEMPORARY TABLE ult_fecha (
	SELECT nom_plan, max(fecha_desde_plan) AS maxfecha, valor_plan
		FROM valores_plan
        WHERE fecha_desde_plan <= CURRENT_DATE()
        GROUP BY nom_plan
);
DROP TEMPORARY TABLE IF EXISTS  precio_actual;
CREATE TEMPORARY TABLE precio_actual (
	SELECT DISTINCT  vp.nom_plan, vp.valor_plan as valor_actual, uf.maxfecha
	FROM valores_plan vp
	INNER JOIN ult_fecha uf ON uf.maxfecha = vp.fecha_desde_plan AND uf.nom_plan = vp.nom_plan
);
DROP TEMPORARY TABLE IF EXISTS penult_fecha; 
CREATE TEMPORARY TABLE penult_fecha (
	SELECT vp.nom_plan, max(vp.fecha_desde_plan) AS antfecha
		FROM valores_plan vp
        LEFT JOIN precio_actual va ON va.nom_plan = vp.nom_plan
        WHERE fecha_desde_plan <= CURRENT_DATE() AND (va.maxfecha != vp.fecha_desde_plan OR vp.fecha_desde_plan IS NULL)
        GROUP BY nom_plan
);
DROP TEMPORARY TABLE IF EXISTS precio_ant;
CREATE TEMPORARY TABLE precio_ant (
	SELECT DISTINCT  vp.nom_plan, vp.valor_plan AS valor_anterior, pf.antfecha
	FROM valores_plan vp
	INNER JOIN penult_fecha pf ON pf.antfecha = vp.fecha_desde_plan AND pf.nom_plan = vp.nom_plan
);
SELECT pact.nom_plan, pact.maxfecha, pact.valor_actual, pant.antfecha, pant.valor_anterior, (pact.valor_actual - pant.valor_anterior) 'Diferencia'
FROM precio_actual pact
LEFT JOIN precio_ant pant ON pant.nom_plan = pact.nom_plan;