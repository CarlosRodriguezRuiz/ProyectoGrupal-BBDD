-- Consultas de demostración (PostgreSQL / Supabase).
-- Ejecutar después de ProyectoGrupal_PostgreSQL.sql.

-- 0. Comprobación: número de filas por tabla (total esperado: 420).
SELECT 'promocion' AS tabla, COUNT(*) AS filas FROM promocion
UNION ALL SELECT 'alumnos', COUNT(*) FROM alumnos
UNION ALL SELECT 'proyectos', COUNT(*) FROM proyectos
UNION ALL SELECT 'alumnosPromocion', COUNT(*) FROM alumnosPromocion
UNION ALL SELECT 'promocionProyectos', COUNT(*) FROM promocionProyectos
UNION ALL SELECT 'alumnosProyectos', COUNT(*) FROM alumnosProyectos
UNION ALL SELECT 'claustro', COUNT(*) FROM claustro
UNION ALL SELECT 'promocionClaustro', COUNT(*) FROM promocionClaustro;

-- 1. ¿Cuántos alumnos tiene cada promoción? (LEFT JOIN para ver también las que no tienen alumnos)
SELECT pr.id, pr.vertical, pr.campus, pr.fecha_comienzo,
       COUNT(apr.id_alumnos) AS num_alumnos
FROM promocion pr
    LEFT JOIN alumnosPromocion apr ON pr.id = apr.id_promocion
GROUP BY pr.id, pr.vertical, pr.campus, pr.fecha_comienzo
ORDER BY pr.id;

-- 2. Porcentaje de aptos por proyecto.
SELECT p.nombre AS proyecto,
       COUNT(*) AS evaluados,
       SUM(CASE WHEN ap.evaluacion = 'Apto' THEN 1 ELSE 0 END) AS aptos,
       ROUND(100.0 * SUM(CASE WHEN ap.evaluacion = 'Apto' THEN 1 ELSE 0 END) / COUNT(*), 1) AS porcentaje_aptos
FROM alumnosProyectos ap
    JOIN proyectos p ON ap.id_proyectos = p.id
GROUP BY p.id, p.nombre
ORDER BY porcentaje_aptos DESC;

-- 3. Ficha de un alumno: promoción y notas.
SELECT a.nombre, pr.vertical, pr.campus, p.nombre AS proyecto, ap.evaluacion
FROM alumnos a
    JOIN alumnosPromocion apr ON a.id = apr.id_alumnos
    JOIN promocion pr        ON apr.id_promocion = pr.id
    JOIN alumnosProyectos ap ON a.id = ap.id_alumnos
    JOIN proyectos p         ON ap.id_proyectos = p.id
WHERE a.nombre LIKE 'Jafet%'
ORDER BY p.id;

-- 4. Profesorado de cada promoción y su modalidad.
SELECT pr.id AS promocion, pr.vertical, pr.campus, pr.fecha_comienzo,
       c.nombre AS docente, c.rol, c.modalidad
FROM promocion pr
    JOIN promocionClaustro pc ON pr.id = pc.id_promocion
    JOIN claustro c           ON pc.id_claustro = c.id
ORDER BY pr.id, c.rol DESC, c.nombre;

-- 5. Alumnos que han aprobado todos sus proyectos.
SELECT a.nombre, pr.vertical, pr.campus
FROM alumnos a
    JOIN alumnosPromocion apr ON a.id = apr.id_alumnos
    JOIN promocion pr        ON apr.id_promocion = pr.id
    JOIN alumnosProyectos ap ON a.id = ap.id_alumnos
GROUP BY a.id, a.nombre, pr.vertical, pr.campus
HAVING SUM(CASE WHEN ap.evaluacion = 'No Apto' THEN 1 ELSE 0 END) = 0
ORDER BY a.nombre;

-- 6. Resumen por campus y vertical.
SELECT pr.campus, pr.vertical,
       COUNT(DISTINCT apr.id_alumnos) AS alumnos,
       COUNT(DISTINCT pc.id_claustro) AS docentes
FROM promocion pr
    LEFT JOIN alumnosPromocion apr ON pr.id = apr.id_promocion
    LEFT JOIN promocionClaustro pc ON pr.id = pc.id_promocion
GROUP BY pr.campus, pr.vertical
ORDER BY pr.campus, pr.vertical;
