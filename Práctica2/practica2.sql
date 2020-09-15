-- practica 2 - JOINS
-- DB: Agencia Personal
-- INNER JOIN
-- 1
SELECT per.nombre, per.apellido, con.sueldo, con.dni
	FROM contratos con
	INNER JOIN personas per on con.dni = per.dni
	WHERE con.nro_contrato = 5;
-- 2
SELECT per.dni, con.nro_contrato, con.fecha_incorporacion, concat(con.fecha_solicitud," -- ", ifnull(con.fecha_caducidad, "Sin fecha")) "Fecha Solicitud y Fecha Caducidad", em.razon_social -- si es nulo, cambia por el valor entre comillas
	FROM contratos con
	INNER JOIN personas per ON con.dni = per.dni
	INNER JOIN empresas em ON em.cuit = con.cuit
	WHERE em.razon_social like "Viejos Amigos" OR em.razon_social = "Traigame Eso"
	ORDER BY fecha_incorporacion, razon_social; -- ordenar por
-- 3
SELECT em.razon_social, em.direccion, em.e_mail, car.desc_cargo, sol.anios_experiencia
	FROM solicitudes_empresas sol
    INNER JOIN empresas em ON em.cuit = sol.cuit
    INNER JOIN cargos car ON car.cod_cargo = sol.cod_cargo
    ORDER BY sol.fecha_solicitud, car.desc_cargo;
-- 4
SELECT per.dni, per.nombre, per.apellido, t.desc_titulo
	FROM personas per
    INNER JOIN personas_titulos pert ON pert.dni = per.dni
    INNER JOIN titulos t ON t.cod_titulo = pert.cod_titulo
    WHERE t.desc_titulo like "Bachiller" OR t.tipo_titulo LIKE "Educacion no formal";
-- 5
SELECT per.nombre, per.apellido, t.desc_titulo
	FROM personas per
    INNER JOIN personas_titulos pert ON pert.dni = per.dni
    INNER JOIN titulos t ON t.cod_titulo = pert.cod_titulo;
-- 6
SELECT concat(per.apellido, ", ", per.nombre, " tiene como referencia a ", ifnull(ant.persona_contacto, "No tiene contacto"), " y cuando trabajo en ", em.razon_social)
	FROM antecedentes ant
	INNER JOIN personas per ON per.dni = ant.dni
    INNER JOIN empresas em ON em.cuit = ant.cuit
    WHERE (ant.persona_contacto IS NULL) OR (ant.persona_contacto LIKE "Armando Esteban Quito") OR (ant.persona_contacto LIKE "Felipe Rojas");
-- 7
SELECT em.razon_social "Empresa", en.fecha_solicitud "Fecha Solicitud", car.desc_cargo "Cargo", ifnull(sol.edad_minima , "Sin especificar") "Edad Min", ifnull(sol.edad_maxima , "Sin especificar") "Edad Max", en.resultado_final "Puntaje total en c/entrevista"
	FROM entrevistas en
    INNER JOIN empresas em ON em.cuit = en.cuit
    INNER JOIN solicitudes_empresas sol ON sol.fecha_solicitud = en.fecha_solicitud AND sol.cuit = en.cuit AND sol.cod_cargo = en.cod_cargo
    INNER JOIN cargos car ON car.cod_cargo = en.cod_cargo
    WHERE em.razon_social LIKE "Viejos Amigos";
-- 8
SELECT concat(per.nombre, " ", per.apellido) "Postulante (Nombre y Apellido)", car.desc_cargo "Cargo (Descripción del cargo)"
	FROM antecedentes an
    INNER JOIN personas per ON per.dni = an.dni
    INNER JOIN cargos car ON car.cod_cargo = an.cod_cargo;
-- 9
SELECT em.razon_social "Empresa", car.desc_cargo "Cargo", ev.desc_evaluacion "Desc Evaluacion", enev.resultado "Resultado"
FROM entrevistas en
INNER JOIN empresas em ON em.cuit = en.cuit
INNER JOIN cargos car ON car.cod_cargo = en.cod_cargo
INNER JOIN entrevistas_evaluaciones enev ON enev.nro_entrevista = en.nro_entrevista
INNER JOIN evaluaciones ev ON ev.cod_evaluacion = enev.cod_evaluacion
ORDER BY em.razon_social ASC, car.desc_cargo DESC;
-- LEFT/RIGHT JOIN
-- 10
SELECT emp.cuit, emp.razon_social, ifnull(se.fecha_solicitud, "Sin solicitud") "Fecha Solicitud", ifnull(car.desc_cargo, "Sin solicitud") "Cargp"
	FROM empresas emp
    LEFT JOIN solicitudes_empresas se ON emp.cuit = se.cuit
    LEFT JOIN cargos car ON se.cod_cargo = car.cod_cargo;
-- 11
SELECT DISTINCT emp.cuit, emp.razon_social, car.desc_cargo, ifnull(per.dni, "Sin contrato") "DNI", ifnull(per.apellido, "Sin contrato") "Apellido", ifnull(per.nombre, "Sin contrato") "Nombre"
	FROM solicitudes_empresas se
    INNER JOIN empresas emp ON emp.cuit = se.cuit
    INNER JOIN cargos car ON car.cod_cargo = se.cod_cargo
    LEFT JOIN contratos con ON con.cuit = se.cuit AND con.cod_cargo = se.cod_cargo AND con.fecha_solicitud = se.fecha_solicitud
    LEFT JOIN personas per ON per.dni = con.dni
    ORDER BY emp.cuit;
-- 12
SELECT emp.cuit, emp.razon_social, car.desc_cargo
	FROM solicitudes_empresas se
    INNER JOIN empresas emp ON emp.cuit = se.cuit
    INNER JOIN cargos car ON car.cod_cargo = se.cod_cargo
    LEFT JOIN contratos con ON con.cuit = se.cuit AND con.cod_cargo = se.cod_cargo AND con.fecha_solicitud = se.fecha_solicitud
    WHERE con.dni is null;
-- 13
SELECT car.desc_cargo, ifnull(per.dni, "Sin antecedente") "DNI", ifnull(per.apellido, "Sin antecedente") "Apellido", ifnull(emp.razon_social, "Sin antecedente")
	FROM cargos car
    LEFT JOIN antecedentes ant ON ant.cod_cargo = car.cod_cargo
    LEFT JOIN personas per ON per.dni = ant.dni
    LEFT JOIN empresas emp ON emp.cuit = ant.cuit;
-- DB: AFATSE
-- SELF JOIN
-- 14
SELECT ins1.cuil "Cuil Instructor", ins1.nombre "Nombre Instructor", ins1.apellido "Apellido Instructor", ins2.cuil "Cuil Supervisor", ins2.nombre "Nombre Supervisor", ins2.apellido "Apellido Supervisor"
	FROM instructores ins1
    INNER JOIN instructores ins2 ON ins1.cuil_supervisor = ins2.cuil
    WHERE ins1.cuil_supervisor IS NOT NULL
    ORDER BY ins1.cuil;
-- 15
SELECT ins1.cuil "Cuil Instructor", ins1.nombre "Nombre Instructor", ins1.apellido "Apellido Instructor", ifnull(ins2.cuil,"") "Cuil Supervisor", ifnull(ins2.nombre, "") "Nombre Supervisor", ifnull(ins2.apellido, "") "Apellido Supervisor"
	FROM instructores ins1
    LEFT JOIN instructores ins2 ON ins1.cuil_supervisor = ins2.cuil
    ORDER BY ins1.cuil;
-- 16
SELECT ifnull(ins2.cuil, "") "Cuil Supervisor", ifnull(ins2.nombre, "") "Nombre Supervisor", ifnull(ins2.apellido, "") "Apellido Supervisor", ins1.nombre "Nombre Instructor", ins1.apellido "Apellido Instructor", ev.nom_plan, ev.nro_curso, a.nombre, a.apellido, ev.nro_examen, ev.fecha_evaluacion, ev.nota
	FROM instructores ins1
    LEFT JOIN instructores ins2 ON ins1.cuil_supervisor = ins2.cuil
    INNER JOIN evaluaciones ev ON ev.cuil = ins1.cuil
    INNER JOIN alumnos a ON a.dni = ev.dni
    WHERE year(fecha_evaluacion) = 2014
    ORDER BY ins2.apellido ASC, ins2.nombre ASC, ev.fecha_evaluacion DESC;