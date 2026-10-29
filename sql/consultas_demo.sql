-- Consultas de demostración del modelo v2 (PostgreSQL / Supabase).
-- Ejecutar después de postgresql/ProyectoGrupal_v2_PostgreSQL.sql.
SET search_path TO v2;

-- 0. Comprobación: número de filas por tabla (total esperado: 500).
SELECT 'persona' AS tabla, COUNT(*) AS filas FROM persona
UNION ALL SELECT 'alumnos', COUNT(*) FROM alumnos
UNION ALL SELECT 'profesor', COUNT(*) FROM profesor
UNION ALL SELECT 'promocion', COUNT(*) FROM promocion
UNION ALL SELECT 'proyecto', COUNT(*) FROM proyecto
UNION ALL SELECT 'alumnosPromocion', COUNT(*) FROM alumnosPromocion
UNION ALL SELECT 'profesorPromocion', COUNT(*) FROM profesorPromocion
UNION ALL SELECT 'alumnoProyecto', COUNT(*) FROM alumnoProyecto
UNION ALL SELECT 'promocionProyecto', COUNT(*) FROM promocionProyecto
UNION ALL SELECT 'profesorProyecto', COUNT(*) FROM profesorProyecto;

-- 1. ¿Cuántos alumnos tiene cada promoción? (LEFT JOIN para ver también las que no tienen alumnos)
SELECT pr.id, pr.vertical, pr.campus, pr.fechaPromocion,
       EXTRACT(MONTH FROM pr.fechaPromocion) AS mesPromocion,
       COUNT(apr.id_alumno) AS num_alumnos
FROM promocion pr
    LEFT JOIN alumnosPromocion apr ON pr.id = apr.id_promocion
GROUP BY pr.id, pr.vertical, pr.campus, pr.fechaPromocion
ORDER BY pr.id;

-- 2. Quién corrige cada proyecto y porcentaje de aptos.
SELECT py.nombreProyecto AS proyecto,
       string_agg(DISTINCT pe.nombre || ' (' || p.rol || ')', ', ') AS corrigen,
       ROUND(100.0 * COUNT(DISTINCT ap.id_alumno) FILTER (WHERE ap.evaluacion = 'Apto')
             / COUNT(DISTINCT ap.id_alumno)) AS porcentaje_aptos
FROM proyecto py
    JOIN profesorProyecto pp ON pp.id_proyecto = py.id
    JOIN profesor p          ON p.id_persona = pp.id_profesor
    JOIN persona pe          ON pe.id = p.id_persona
    JOIN alumnoProyecto ap   ON ap.id_proyecto = py.id
GROUP BY py.id, py.nombreProyecto
ORDER BY py.id;

-- 3. Ficha de un alumno: promoción y notas. El nombre ahora está en persona.
SELECT pe.nombre, pr.vertical, pr.campus, py.nombreProyecto AS proyecto, ap.evaluacion
FROM persona pe
    JOIN alumnos a            ON a.id_persona = pe.id
    JOIN alumnosPromocion apr ON apr.id_alumno = a.id_persona
    JOIN promocion pr         ON pr.id = apr.id_promocion
    JOIN alumnoProyecto ap    ON ap.id_alumno = a.id_persona
    JOIN proyecto py          ON py.id = ap.id_proyecto
WHERE pe.nombre LIKE 'Jafet%'
ORDER BY py.id;

-- 4. Profesorado de cada promoción y su modalidad.
SELECT pr.id AS promocion, pr.vertical, pr.campus, pr.fechaPromocion,
       pe.nombre AS profesor, p.rol, p.modalidad
FROM promocion pr
    JOIN profesorPromocion pp ON pp.id_promocion = pr.id
    JOIN profesor p           ON p.id_persona = pp.id_profesor
    JOIN persona pe           ON pe.id = p.id_persona
ORDER BY pr.id, p.rol DESC, pe.nombre;

-- 5. Profesores que corrigen proyectos de una promoción en la que no enseñan.
SELECT DISTINCT pe.nombre AS profesor, p.rol, py.nombreProyecto AS proyecto
FROM profesorProyecto pp
    JOIN profesor p   ON p.id_persona = pp.id_profesor
    JOIN persona pe   ON pe.id = p.id_persona
    JOIN proyecto py  ON py.id = pp.id_proyecto
WHERE NOT EXISTS (
    SELECT 1
    FROM profesorPromocion ppr
        JOIN promocionProyecto prp ON prp.id_promocion = ppr.id_promocion
    WHERE ppr.id_profesor = pp.id_profesor AND prp.id_proyecto = pp.id_proyecto
)
ORDER BY pe.nombre;

-- 6. Personas que son alumno y profesor a la vez (herencia solapada).
--    Con los datos de los CSV sale vacía; prueba antes:
--    INSERT INTO profesor (id_persona, rol, modalidad) VALUES (1, 'TA', 'presencial');
SELECT pe.id, pe.nombre
FROM persona pe
    JOIN alumnos a  ON a.id_persona = pe.id
    JOIN profesor p ON p.id_persona = pe.id;

-- 7. Resumen por campus y vertical.
SELECT pr.campus, pr.vertical,
       COUNT(DISTINCT apr.id_alumno)   AS alumnos,
       COUNT(DISTINCT pp.id_profesor)  AS profesores
FROM promocion pr
    LEFT JOIN alumnosPromocion apr  ON pr.id = apr.id_promocion
    LEFT JOIN profesorPromocion pp  ON pr.id = pp.id_promocion
GROUP BY pr.campus, pr.vertical
ORDER BY pr.campus, pr.vertical;
