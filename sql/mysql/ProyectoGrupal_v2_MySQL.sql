-- ============================================================
-- Proyecto Grupal BBDD · Modelo v2 (Persona -> Alumno / Profesor)
-- Script para MySQL Workbench: crea las 10 tablas y carga los CSV.
-- ============================================================
DROP DATABASE IF EXISTS ProyectoGrupalV2;
CREATE DATABASE ProyectoGrupalV2 CHARACTER SET utf8mb4;
USE ProyectoGrupalV2;
SET NAMES utf8mb4;

-- ---------- Entidades ----------
CREATE TABLE persona (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50),
    email TEXT
);

-- Subclases: misma clave que persona (PK y FK a la vez). Herencia parcial y solapada.
CREATE TABLE alumnos (
    id_persona INTEGER PRIMARY KEY,
    FOREIGN KEY (id_persona) REFERENCES persona(id)
);

CREATE TABLE profesor (
    id_persona INTEGER PRIMARY KEY,
    rol VARCHAR(20),
    modalidad ENUM('presencial', 'online'),
    FOREIGN KEY (id_persona) REFERENCES persona(id)
);

-- MesPromocion es derivado: no se guarda, se calcula con MONTH(fechaPromocion).
CREATE TABLE promocion (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    fechaPromocion DATE,
    campus VARCHAR(20),
    vertical VARCHAR(20),
    tipoModalidad ENUM('presencial', 'online', 'hibrida')
);

CREATE TABLE proyecto (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    nombreProyecto VARCHAR(30)
);

-- ---------- Relaciones N:M ----------
-- Participa
CREATE TABLE alumnosPromocion (
    id_alumno INTEGER,
    id_promocion INTEGER,
    PRIMARY KEY (id_alumno, id_promocion),
    FOREIGN KEY (id_alumno) REFERENCES alumnos(id_persona),
    FOREIGN KEY (id_promocion) REFERENCES promocion(id)
);

-- Enseña
CREATE TABLE profesorPromocion (
    id_profesor INTEGER,
    id_promocion INTEGER,
    PRIMARY KEY (id_profesor, id_promocion),
    FOREIGN KEY (id_profesor) REFERENCES profesor(id_persona),
    FOREIGN KEY (id_promocion) REFERENCES promocion(id)
);

-- Realizan (con el atributo evaluacion)
CREATE TABLE alumnoProyecto (
    id_alumno INTEGER,
    id_proyecto INTEGER,
    evaluacion TEXT,
    PRIMARY KEY (id_alumno, id_proyecto),
    FOREIGN KEY (id_alumno) REFERENCES alumnos(id_persona),
    FOREIGN KEY (id_proyecto) REFERENCES proyecto(id)
);

-- Tienen
CREATE TABLE promocionProyecto (
    id_promocion INTEGER,
    id_proyecto INTEGER,
    PRIMARY KEY (id_promocion, id_proyecto),
    FOREIGN KEY (id_promocion) REFERENCES promocion(id),
    FOREIGN KEY (id_proyecto) REFERENCES proyecto(id)
);

-- Corrigen
CREATE TABLE profesorProyecto (
    id_profesor INTEGER,
    id_proyecto INTEGER,
    PRIMARY KEY (id_profesor, id_proyecto),
    FOREIGN KEY (id_profesor) REFERENCES profesor(id_persona),
    FOREIGN KEY (id_proyecto) REFERENCES proyecto(id)
);

-- ============================================================
-- Datos (sacados de clase_1..4.csv y claustro.csv)
-- ============================================================

-- 1. Promociones (6). Los CSV no traen la modalidad de la promocion; como los
--    alumnos tienen campus, se asume 'presencial'.
INSERT INTO promocion (id, fechaPromocion, campus, vertical, tipoModalidad) VALUES
    (1, '2023-09-18', 'Madrid', 'DS', 'presencial'),
    (2, '2024-02-12', 'Madrid', 'DS', 'presencial'),
    (3, '2023-09-18', 'Madrid', 'FS', 'presencial'),
    (4, '2024-02-12', 'Valencia', 'FS', 'presencial'),
    (5, '2023-09-18', 'Valencia', 'FS', 'presencial'),
    (6, '2024-02-12', 'Madrid', 'FS', 'presencial');

-- 2. Proyectos (10).
INSERT INTO proyecto (id, nombreProyecto) VALUES
    (1, 'HLF'),
    (2, 'EDA'),
    (3, 'BBDD'),
    (4, 'ML'),
    (5, 'Deployment'),
    (6, 'WebDev'),
    (7, 'FrontEnd'),
    (8, 'Backend'),
    (9, 'React'),
    (10, 'FullSatck');

-- 3. Personas (62): ids 1-52 alumnos, 53-62 profesores (claustro.csv no trae email).
INSERT INTO persona (id, nombre, email) VALUES
    (1, 'Jafet Casals', 'Jafet_Casals@gmail.com'),
    (2, 'Jorge Manzanares', 'Jorge_Manzanares@gmail.com'),
    (3, 'Onofre Adadia', 'Onofre_Adadia@gmail.com'),
    (4, 'Merche Prada', 'Merche_Prada@gmail.com'),
    (5, 'Pilar Abella', 'Pilar_Abella@gmail.com'),
    (6, 'Leoncio Tena', 'Leoncio_Tena@gmail.com'),
    (7, 'Odalys Torrijos', 'Odalys_Torrijos@gmail.com'),
    (8, 'Eduardo Caparrós', 'Eduardo_Caparrós@gmail.com'),
    (9, 'Ignacio Goicoechea', 'Ignacio_Goicoechea@gmail.com'),
    (10, 'Clementina Santos', 'Clementina_Santos@gmail.com'),
    (11, 'Daniela Falcó', 'Daniela_Falcó@gmail.com'),
    (12, 'Abraham Vélez', 'Abraham_Vélez@gmail.com'),
    (13, 'Maximiliano Menéndez', 'Maximiliano_Menéndez@gmail.com'),
    (14, 'Anita Heredia', 'Anita_Heredia@gmail.com'),
    (15, 'Eli Casas', 'Eli_Casas@gmail.com'),
    (16, 'Guillermo Borrego', 'Guillermo_Borrego@gmail.com'),
    (17, 'Sergio Aguirre', 'Sergio_Aguirre@gmail.com'),
    (18, 'Carlito Carrión', 'Carlito_Carrión@gmail.com'),
    (19, 'Haydée Figueroa', 'Haydée_Figueroa@gmail.com'),
    (20, 'Chita Mancebo', 'Chita_Mancebo@gmail.com'),
    (21, 'Joaquina Asensio', 'Joaquina_Asensio@gmail.com'),
    (22, 'Cristian Sarabia', 'Cristian_Sarabia@gmail.com'),
    (23, 'Isabel Ibáñez', 'Isabel_Ibáñez@gmail.com'),
    (24, 'Desiderio Jordá', 'Desiderio_Jordá@gmail.com'),
    (25, 'Rosalina Llanos', 'Rosalina_Llanos@gmail.com'),
    (26, 'Amor Larrañaga', 'Amor_Larrañaga@gmail.com'),
    (27, 'Teodoro Alberola', 'Teodoro_Alberola@gmail.com'),
    (28, 'Cleto Plana', 'Cleto_Plana@gmail.com'),
    (29, 'Aitana Sebastián', 'Aitana_Sebastián@gmail.com'),
    (30, 'Dolores Valbuena', 'Dolores_Valbuena@gmail.com'),
    (31, 'Julie Ferrer', 'Julie_Ferrer@gmail.com'),
    (32, 'Mireia Cabañas', 'Mireia_Cabañas@gmail.com'),
    (33, 'Flavia Amador', 'Flavia_Amador@gmail.com'),
    (34, 'Albino Macias', 'Albino_Macias@gmail.com'),
    (35, 'Ester Sánchez', 'Ester_Sánchez@gmail.com'),
    (36, 'Luis Miguel Galvez', 'Luis_Miguel_Galvez@gmail.com'),
    (37, 'Loida Arellano', 'Loida_Arellano@gmail.com'),
    (38, 'Heraclio Duque', 'Heraclio_Duque@gmail.com'),
    (39, 'Herberto Figueras', 'Herberto_Figueras@gmail.com'),
    (40, 'Teresa Laguna', 'Teresa_Laguna@gmail.com'),
    (41, 'Estrella Murillo', 'Estrella_Murillo@gmail.com'),
    (42, 'Ernesto Uriarte', 'Ernesto_Uriarte@gmail.com'),
    (43, 'Daniela Guitart', 'Daniela_Guitart@gmail.com'),
    (44, 'Timoteo Trillo', 'Timoteo_Trillo@gmail.com'),
    (45, 'Ricarda Tovar', 'Ricarda_Tovar@gmail.com'),
    (46, 'Alejandra Vilaplana', 'Alejandra_Vilaplana@gmail.com'),
    (47, 'Daniel Rosselló', 'Daniel_Rosselló@gmail.com'),
    (48, 'Rita Olivares', 'Rita_Olivares@gmail.com'),
    (49, 'Cleto Montes', 'Cleto_Montes@gmail.com'),
    (50, 'Marino Castilla', 'Marino_Castilla@gmail.com'),
    (51, 'Estefanía Valcárcel', 'Estefanía_Valcárcel@gmail.com'),
    (52, 'Noemí Vilanova', 'Noemí_Vilanova@gmail.com'),
    (53, 'Noa Yáñez', NULL),
    (54, 'Saturnina Benitez', NULL),
    (55, 'Anna Feliu', NULL),
    (56, 'Rosalva Ayuso', NULL),
    (57, 'Ana Sofía Ferrer', NULL),
    (58, 'Angélica Corral', NULL),
    (59, 'Ariel Lledó', NULL),
    (60, 'Mario Prats', NULL),
    (61, 'Luis Ángel Suárez', NULL),
    (62, 'María Dolores Diaz', NULL);

-- 4. Alumnos (52).
INSERT INTO alumnos (id_persona) VALUES
    (1),
    (2),
    (3),
    (4),
    (5),
    (6),
    (7),
    (8),
    (9),
    (10),
    (11),
    (12),
    (13),
    (14),
    (15),
    (16),
    (17),
    (18),
    (19),
    (20),
    (21),
    (22),
    (23),
    (24),
    (25),
    (26),
    (27),
    (28),
    (29),
    (30),
    (31),
    (32),
    (33),
    (34),
    (35),
    (36),
    (37),
    (38),
    (39),
    (40),
    (41),
    (42),
    (43),
    (44),
    (45),
    (46),
    (47),
    (48),
    (49),
    (50),
    (51),
    (52);

-- 5. Profesores (10).
INSERT INTO profesor (id_persona, rol, modalidad) VALUES
    (53, 'TA', 'presencial'),
    (54, 'TA', 'presencial'),
    (55, 'TA', 'presencial'),
    (56, 'TA', 'presencial'),
    (57, 'TA', 'presencial'),
    (58, 'TA', 'presencial'),
    (59, 'TA', 'presencial'),
    (60, 'LI', 'online'),
    (61, 'LI', 'online'),
    (62, 'LI', 'online');

-- 6. Participa: alumno-promocion (52).
INSERT INTO alumnosPromocion (id_alumno, id_promocion) VALUES
    (1, 1),
    (2, 1),
    (3, 1),
    (4, 1),
    (5, 1),
    (6, 1),
    (7, 1),
    (8, 1),
    (9, 1),
    (10, 1),
    (11, 1),
    (12, 1),
    (13, 1),
    (14, 1),
    (15, 1),
    (16, 2),
    (17, 2),
    (18, 2),
    (19, 2),
    (20, 2),
    (21, 2),
    (22, 2),
    (23, 2),
    (24, 2),
    (25, 2),
    (26, 3),
    (27, 3),
    (28, 3),
    (29, 3),
    (30, 3),
    (31, 3),
    (32, 3),
    (33, 3),
    (34, 3),
    (35, 3),
    (36, 3),
    (37, 3),
    (38, 3),
    (39, 3),
    (40, 4),
    (41, 4),
    (42, 4),
    (43, 4),
    (44, 4),
    (45, 4),
    (46, 4),
    (47, 4),
    (48, 4),
    (49, 4),
    (50, 4),
    (51, 4),
    (52, 4);

-- 7. Enseña: profesor-promocion (10).
INSERT INTO profesorPromocion (id_profesor, id_promocion) VALUES
    (53, 1),
    (54, 1),
    (55, 3),
    (56, 5),
    (57, 4),
    (58, 6),
    (59, 1),
    (60, 4),
    (61, 3),
    (62, 1);

-- 8. Tienen: promocion-proyecto (20).
INSERT INTO promocionProyecto (id_promocion, id_proyecto) VALUES
    (1, 1),
    (1, 2),
    (1, 3),
    (1, 4),
    (1, 5),
    (2, 1),
    (2, 2),
    (2, 3),
    (2, 4),
    (2, 5),
    (3, 6),
    (3, 7),
    (3, 8),
    (3, 9),
    (3, 10),
    (4, 6),
    (4, 7),
    (4, 8),
    (4, 9),
    (4, 10);

-- 9. Realizan: evaluacion de cada alumno en cada proyecto (260).
INSERT INTO alumnoProyecto (id_alumno, id_proyecto, evaluacion) VALUES
    (1, 1, 'Apto'),
    (1, 2, 'No Apto'),
    (1, 3, 'Apto'),
    (1, 4, 'Apto'),
    (1, 5, 'Apto'),
    (2, 1, 'Apto'),
    (2, 2, 'No Apto'),
    (2, 3, 'Apto'),
    (2, 4, 'Apto'),
    (2, 5, 'Apto'),
    (3, 1, 'Apto'),
    (3, 2, 'Apto'),
    (3, 3, 'Apto'),
    (3, 4, 'No Apto'),
    (3, 5, 'Apto'),
    (4, 1, 'Apto'),
    (4, 2, 'No Apto'),
    (4, 3, 'No Apto'),
    (4, 4, 'Apto'),
    (4, 5, 'No Apto'),
    (5, 1, 'Apto'),
    (5, 2, 'No Apto'),
    (5, 3, 'Apto'),
    (5, 4, 'Apto'),
    (5, 5, 'Apto'),
    (6, 1, 'Apto'),
    (6, 2, 'Apto'),
    (6, 3, 'Apto'),
    (6, 4, 'Apto'),
    (6, 5, 'Apto'),
    (7, 1, 'No Apto'),
    (7, 2, 'Apto'),
    (7, 3, 'Apto'),
    (7, 4, 'Apto'),
    (7, 5, 'Apto'),
    (8, 1, 'No Apto'),
    (8, 2, 'Apto'),
    (8, 3, 'Apto'),
    (8, 4, 'Apto'),
    (8, 5, 'Apto'),
    (9, 1, 'Apto'),
    (9, 2, 'Apto'),
    (9, 3, 'Apto'),
    (9, 4, 'No Apto'),
    (9, 5, 'Apto'),
    (10, 1, 'Apto'),
    (10, 2, 'No Apto'),
    (10, 3, 'Apto'),
    (10, 4, 'Apto'),
    (10, 5, 'Apto'),
    (11, 1, 'Apto'),
    (11, 2, 'Apto'),
    (11, 3, 'Apto'),
    (11, 4, 'Apto'),
    (11, 5, 'Apto'),
    (12, 1, 'Apto'),
    (12, 2, 'No Apto'),
    (12, 3, 'No Apto'),
    (12, 4, 'Apto'),
    (12, 5, 'Apto'),
    (13, 1, 'Apto'),
    (13, 2, 'No Apto'),
    (13, 3, 'Apto'),
    (13, 4, 'Apto'),
    (13, 5, 'Apto'),
    (14, 1, 'Apto'),
    (14, 2, 'Apto'),
    (14, 3, 'Apto'),
    (14, 4, 'Apto'),
    (14, 5, 'Apto'),
    (15, 1, 'Apto'),
    (15, 2, 'Apto'),
    (15, 3, 'Apto'),
    (15, 4, 'Apto'),
    (15, 5, 'Apto'),
    (16, 1, 'Apto'),
    (16, 2, 'No Apto'),
    (16, 3, 'No Apto'),
    (16, 4, 'Apto'),
    (16, 5, 'No Apto'),
    (17, 1, 'Apto'),
    (17, 2, 'No Apto'),
    (17, 3, 'Apto'),
    (17, 4, 'Apto'),
    (17, 5, 'No Apto'),
    (18, 1, 'Apto'),
    (18, 2, 'No Apto'),
    (18, 3, 'Apto'),
    (18, 4, 'Apto'),
    (18, 5, 'Apto'),
    (19, 1, 'Apto'),
    (19, 2, 'Apto'),
    (19, 3, 'Apto'),
    (19, 4, 'Apto'),
    (19, 5, 'Apto'),
    (20, 1, 'No Apto'),
    (20, 2, 'Apto'),
    (20, 3, 'No Apto'),
    (20, 4, 'Apto'),
    (20, 5, 'Apto'),
    (21, 1, 'No Apto'),
    (21, 2, 'No Apto'),
    (21, 3, 'Apto'),
    (21, 4, 'Apto'),
    (21, 5, 'Apto'),
    (22, 1, 'Apto'),
    (22, 2, 'Apto'),
    (22, 3, 'No Apto'),
    (22, 4, 'Apto'),
    (22, 5, 'Apto'),
    (23, 1, 'No Apto'),
    (23, 2, 'Apto'),
    (23, 3, 'No Apto'),
    (23, 4, 'Apto'),
    (23, 5, 'Apto'),
    (24, 1, 'No Apto'),
    (24, 2, 'Apto'),
    (24, 3, 'No Apto'),
    (24, 4, 'No Apto'),
    (24, 5, 'Apto'),
    (25, 1, 'Apto'),
    (25, 2, 'Apto'),
    (25, 3, 'Apto'),
    (25, 4, 'Apto'),
    (25, 5, 'Apto'),
    (26, 6, 'Apto'),
    (26, 7, 'Apto'),
    (26, 8, 'Apto'),
    (26, 9, 'Apto'),
    (26, 10, 'No Apto'),
    (27, 6, 'No Apto'),
    (27, 7, 'No Apto'),
    (27, 8, 'Apto'),
    (27, 9, 'No Apto'),
    (27, 10, 'Apto'),
    (28, 6, 'Apto'),
    (28, 7, 'No Apto'),
    (28, 8, 'Apto'),
    (28, 9, 'No Apto'),
    (28, 10, 'Apto'),
    (29, 6, 'Apto'),
    (29, 7, 'No Apto'),
    (29, 8, 'Apto'),
    (29, 9, 'No Apto'),
    (29, 10, 'Apto'),
    (30, 6, 'Apto'),
    (30, 7, 'Apto'),
    (30, 8, 'Apto'),
    (30, 9, 'Apto'),
    (30, 10, 'No Apto'),
    (31, 6, 'No Apto'),
    (31, 7, 'No Apto'),
    (31, 8, 'No Apto'),
    (31, 9, 'Apto'),
    (31, 10, 'No Apto'),
    (32, 6, 'No Apto'),
    (32, 7, 'Apto'),
    (32, 8, 'Apto'),
    (32, 9, 'Apto'),
    (32, 10, 'Apto'),
    (33, 6, 'Apto'),
    (33, 7, 'Apto'),
    (33, 8, 'No Apto'),
    (33, 9, 'Apto'),
    (33, 10, 'Apto'),
    (34, 6, 'No Apto'),
    (34, 7, 'Apto'),
    (34, 8, 'Apto'),
    (34, 9, 'Apto'),
    (34, 10, 'Apto'),
    (35, 6, 'No Apto'),
    (35, 7, 'Apto'),
    (35, 8, 'Apto'),
    (35, 9, 'No Apto'),
    (35, 10, 'Apto'),
    (36, 6, 'No Apto'),
    (36, 7, 'Apto'),
    (36, 8, 'Apto'),
    (36, 9, 'Apto'),
    (36, 10, 'Apto'),
    (37, 6, 'Apto'),
    (37, 7, 'Apto'),
    (37, 8, 'Apto'),
    (37, 9, 'Apto'),
    (37, 10, 'Apto'),
    (38, 6, 'Apto'),
    (38, 7, 'Apto'),
    (38, 8, 'No Apto'),
    (38, 9, 'No Apto'),
    (38, 10, 'No Apto'),
    (39, 6, 'Apto'),
    (39, 7, 'Apto'),
    (39, 8, 'Apto'),
    (39, 9, 'Apto'),
    (39, 10, 'Apto'),
    (40, 6, 'Apto'),
    (40, 7, 'Apto'),
    (40, 8, 'Apto'),
    (40, 9, 'Apto'),
    (40, 10, 'Apto'),
    (41, 6, 'Apto'),
    (41, 7, 'Apto'),
    (41, 8, 'No Apto'),
    (41, 9, 'Apto'),
    (41, 10, 'Apto'),
    (42, 6, 'Apto'),
    (42, 7, 'Apto'),
    (42, 8, 'Apto'),
    (42, 9, 'Apto'),
    (42, 10, 'Apto'),
    (43, 6, 'Apto'),
    (43, 7, 'No Apto'),
    (43, 8, 'No Apto'),
    (43, 9, 'Apto'),
    (43, 10, 'Apto'),
    (44, 6, 'No Apto'),
    (44, 7, 'Apto'),
    (44, 8, 'Apto'),
    (44, 9, 'Apto'),
    (44, 10, 'No Apto'),
    (45, 6, 'Apto'),
    (45, 7, 'Apto'),
    (45, 8, 'Apto'),
    (45, 9, 'Apto'),
    (45, 10, 'Apto'),
    (46, 6, 'No Apto'),
    (46, 7, 'No Apto'),
    (46, 8, 'No Apto'),
    (46, 9, 'Apto'),
    (46, 10, 'Apto'),
    (47, 6, 'No Apto'),
    (47, 7, 'No Apto'),
    (47, 8, 'Apto'),
    (47, 9, 'No Apto'),
    (47, 10, 'No Apto'),
    (48, 6, 'No Apto'),
    (48, 7, 'No Apto'),
    (48, 8, 'No Apto'),
    (48, 9, 'Apto'),
    (48, 10, 'Apto'),
    (49, 6, 'Apto'),
    (49, 7, 'Apto'),
    (49, 8, 'No Apto'),
    (49, 9, 'Apto'),
    (49, 10, 'Apto'),
    (50, 6, 'No Apto'),
    (50, 7, 'No Apto'),
    (50, 8, 'Apto'),
    (50, 9, 'No Apto'),
    (50, 10, 'No Apto'),
    (51, 6, 'Apto'),
    (51, 7, 'Apto'),
    (51, 8, 'No Apto'),
    (51, 9, 'No Apto'),
    (51, 10, 'Apto'),
    (52, 6, 'Apto'),
    (52, 7, 'No Apto'),
    (52, 8, 'No Apto'),
    (52, 9, 'Apto'),
    (52, 10, 'Apto');

-- 10. Corrigen: profesor-proyecto (18). Datos INVENTADOS: los CSV no dicen quien
--     corrige cada proyecto. Criterio: los TA corrigen los primeros proyectos de su
--     vertical y los LI los mas avanzados. Rosalva (promo 5) y Angelica (promo 6) no
--     tienen alumnos en su promocion y ayudan a corregir proyectos de otra: eso el
--     modelo anterior no podia guardarlo.
INSERT INTO profesorProyecto (id_profesor, id_proyecto) VALUES
    -- Data Science: 1 HLF, 2 EDA, 3 BBDD, 4 ML, 5 Deployment
    (53, 1), (53, 2),   -- Noa Yáñez (TA)
    (54, 2), (54, 3),   -- Saturnina Benitez (TA)
    (59, 1), (59, 3),   -- Ariel Lledó (TA)
    (62, 4), (62, 5),   -- María Dolores Diaz (LI)
    -- Full Stack: 6 WebDev, 7 FrontEnd, 8 Backend, 9 React, 10 FullSatck
    (55, 6), (55, 7),   -- Anna Feliu (TA)
    (57, 6), (57, 8),   -- Ana Sofía Ferrer (TA)
    (56, 7),            -- Rosalva Ayuso (TA, apoyo desde la promo 5)
    (58, 8),            -- Angélica Corral (TA, apoyo desde la promo 6)
    (61, 9), (61, 10),  -- Luis Ángel Suárez (LI)
    (60, 9), (60, 10);  -- Mario Prats (LI)

-- ============================================================
-- Comprobaciones
-- ============================================================
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

-- Notas de Jafet: ahora el nombre esta en persona.
SELECT pe.nombre, pr.vertical, pr.campus, MONTH(pr.fechaPromocion) AS mesPromocion,
       py.nombreProyecto, ap.evaluacion
FROM persona pe
    JOIN alumnos a           ON a.id_persona = pe.id
    JOIN alumnosPromocion apr ON apr.id_alumno = a.id_persona
    JOIN promocion pr         ON pr.id = apr.id_promocion
    JOIN alumnoProyecto ap    ON ap.id_alumno = a.id_persona
    JOIN proyecto py          ON py.id = ap.id_proyecto
WHERE pe.nombre LIKE 'Jafet%';

-- Profesorado de cada promocion.
SELECT pr.id AS promocion, pr.vertical, pr.campus, pe.nombre AS profesor, p.rol, p.modalidad
FROM promocion pr
    JOIN profesorPromocion pp ON pp.id_promocion = pr.id
    JOIN profesor p           ON p.id_persona = pp.id_profesor
    JOIN persona pe           ON pe.id = p.id_persona
ORDER BY pr.id, p.rol DESC;
