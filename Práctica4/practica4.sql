-- Práctica 4: GROUP BY - HAVING
-- DB: agencia_personal
-- 1
SELECT em.razon_social, sum(com.importe_comision)
	FROM contratos con
    INNER JOIN empresas em ON em.cuit = con.cuit
    INNER JOIN comisiones com ON com.nro_contrato = con.nro_contrato
    WHERE em.razon_social LIKE "%Traigame Eso%"
    GROUP BY em.cuit;
-- 2
SELECT em.razon_social, sum(com.importe_comision)
	FROM contratos con
    INNER JOIN empresas em ON em.cuit = con.cuit
    INNER JOIN comisiones com ON com.nro_contrato = con.nro_contrato
    GROUP BY em.cuit;
-- 3
SELECT en.nombre_entrevistador, enev.cod_evaluacion, AVG(enev.resultado), std(enev.resultado), variance(enev.resultado)
	FROM entrevistas en
    INNER JOIN entrevistas_evaluaciones enev ON enev.nro_entrevista = en.nro_entrevista
    GROUP BY enev.cod_evaluacion, en.nombre_entrevistador
    ORDER BY AVG(enev.resultado) ASC, std(enev.resultado) DESC;
-- 4
SELECT en.nombre_entrevistador, enev.cod_evaluacion, AVG(enev.resultado), std(enev.resultado), variance(enev.resultado)
	FROM entrevistas en
    INNER JOIN entrevistas_evaluaciones enev ON enev.nro_entrevista = en.nro_entrevista
    WHERE en.nombre_entrevistador LIKE "%Angelica Doria%"
    GROUP BY enev.cod_evaluacion, en.nombre_entrevistador
    HAVING AVG(enev.resultado) > 71
    ORDER BY enev.cod_evaluacion;
-- 5
SELECT en.nombre_entrevistador, count(*) 'Cantidad de Entrevistas'
	FROM entrevistas en 
    WHERE YEAR(en.fecha_entrevista) = 2014 AND MONTH(en.fecha_entrevista) = 10
    GROUP BY en.nombre_entrevistador;
-- 6
SELECT en.nombre_entrevistador, enev.cod_evaluacion, count(*), AVG(enev.resultado), std(enev.resultado), variance(enev.resultado)
	FROM entrevistas en
    INNER JOIN entrevistas_evaluaciones enev ON enev.nro_entrevista = en.nro_entrevista
    GROUP BY enev.cod_evaluacion, en.nombre_entrevistador
    HAVING AVG(enev.resultado) > 71
    ORDER BY count(en.nro_entrevista);
-- 7
SELECT en.nombre_entrevistador, enev.cod_evaluacion, count(*), AVG(enev.resultado), std(enev.resultado), variance(enev.resultado)
	FROM entrevistas en
    INNER JOIN entrevistas_evaluaciones enev ON enev.nro_entrevista = en.nro_entrevista
    GROUP BY enev.cod_evaluacion, en.nombre_entrevistador
    HAVING count(*) > 1
    ORDER BY en.nombre_entrevistador DESC, enev.cod_evaluacion ASC;
-- 8
SELECT nro_contrato, count(*) 'Total', count(fecha_pago) 'Pagadas', count(*) - count(fecha_pago) 'A pagar'
	FROM comisiones
    GROUP BY nro_contrato;
-- 9
SELECT nro_contrato, count(*) 'Total', count(fecha_pago)*100/count(*) 'Pagadas', (count(*) - count(fecha_pago))*100/count(*) 'A pagar'
	FROM comisiones
    GROUP BY nro_contrato;
-- 10
SELECT count(DISTINCT cuit) 'Cantidad', count(*) - count(DISTINCT cuit) 'Diferencia'
	FROM solicitudes_empresas;
-- 11
SELECT solem.cuit, em.razon_social, count(*)
	FROM solicitudes_empresas solem
    INNER JOIN empresas em ON em.cuit = solem.cuit
    GROUP BY solem.cuit;
-- 12
SELECT solem.cuit, em.razon_social, solem.cod_cargo, count(*)
	FROM solicitudes_empresas solem
    INNER JOIN empresas em ON em.cuit = solem.cuit
    GROUP BY solem.cuit, solem.cod_cargo;
-- LEFT/RIGHT JOIN
-- 13
SELECT em.cuit, em.razon_social, count(DISTINCT ant.dni) 'Cantidad de Personas'
	FROM empresas em
    LEFT JOIN antecedentes ant ON ant.cuit = em.cuit
    GROUP BY em.cuit;
-- 14
SELECT car.cod_cargo, car.desc_cargo, count(solem.fecha_solicitud) 'Cantidad de Solicitudes'
	FROM cargos car
    LEFT JOIN solicitudes_empresas solem ON solem.cod_cargo = car.cod_cargo
    GROUP BY car.cod_cargo
    ORDER BY count(solem.fecha_solicitud) DESC;
-- 15
SELECT car.cod_cargo, car.desc_cargo, count(se.cod_cargo) "Cant de Solicitudes"
	FROM cargos car
	LEFT JOIN solicitudes_empresas se ON car.cod_cargo = se.cod_cargo
	GROUP BY car.cod_cargo, car.desc_cargo
	HAVING count(*) < 2;