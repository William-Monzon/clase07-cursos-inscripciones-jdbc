-- Clase 7 - Cursos e Inscripciones: relacion muchos-a-muchos (N:M)
-- Ejecuta este script ANTES de correr el proyecto Java.

CREATE DATABASE IF NOT EXISTS prog2_db;

USE prog2_db;

CREATE TABLE IF NOT EXISTS estudiantes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    carnet VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS cursos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    creditos INT NOT NULL
);

-- Tabla intermedia: un estudiante puede inscribirse en muchos cursos, y un
-- curso puede tener muchos estudiantes inscritos. Cada FILA de esta tabla
-- representa "este estudiante esta en este curso". La restriccion UNIQUE
-- evita que el mismo estudiante quede inscrito dos veces en el mismo curso.
CREATE TABLE IF NOT EXISTS inscripciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    estudiante_id INT NOT NULL,
    curso_id INT NOT NULL,
    nota DECIMAL(4,2) NULL,
    FOREIGN KEY (estudiante_id) REFERENCES estudiantes(id),
    FOREIGN KEY (curso_id) REFERENCES cursos(id),
    UNIQUE (estudiante_id, curso_id)
);

INSERT IGNORE INTO estudiantes (id, nombre, carnet) VALUES
    (1, 'Ana Lopez', '2024001'),
    (2, 'Carlos Perez', '2024002'),
    (3, 'Maria Gonzalez', '2024003'),
    (4, 'Luis Ramirez', '2024004');

INSERT IGNORE INTO cursos (id, nombre, creditos) VALUES
    (1, 'Programacion 2', 4),
    (2, 'Base de Datos 1', 3),
    (3, 'Matematica Discreta', 3);

-- nota NULL = todavia cursando / sin nota final registrada.
INSERT IGNORE INTO inscripciones (id, estudiante_id, curso_id, nota) VALUES
    (1, 1, 1, 90.00),
    (2, 1, 2, 85.00),
    (3, 2, 1, 78.50),
    (4, 3, 1, 95.00),
    (5, 3, 3, NULL),
    (6, 4, 2, NULL);

-- UPDATE: para actualizar la nota de una iscripción.
-- con el SET ingreso la nota y WHERE para indicar los el filtro que debe cumplir la fila.
UPDATE estudiantes SET nota = 88 WHERE estudiante_id = 3 AND curso_id = 3;

-- SELECT que devuelve los cursos de un estudiante, utilizando JOIN para unir tres tablas,
-- filtrando el carnet para buscar el estudiante coincidente con el carnet.
SELECT c.id, c.nombre, c.creditos 
FROM inscripciones i 
JOIN cursos c ON i.curso_id = c.id 
JOIN estudiantes e ON i.estudiante_id = e.id 
WHERE e.carnet = 2024001;

-- SELECT que devuelve los estudiantes que estan asignados a un curso
-- JOIN para unir las 3 tablas, utilizando un alias para ingresar a cada tabla
-- WHERE para buscar el los estudiantes por el nombre del curso asignado.
SELECT e.id, e.nombre, e.carnet
FROM inscripciones i
JOIN cursos c ON i.curso_id = c.id
JOIN estudiantes e ON i.estudiante_id = e.id
WHERE c.nombre = 'Programacion 2';

-- SELECT para calcular el promedio de todos los cursos de un estudiante.
-- AVG para calcular el promedio de la columna not, este ignora los null
-- al resultado se le da el alias de promedio.
SELECT AVG(i.nota) AS promedio
FROM inscripciones i
JOIN estudiantes e ON i.estudiante_id = e.id
WHERE e.carnet = 2024001;

-- SELECT que devuelve el nombre del curso que tiene más estudiantes inscritos.
-- GROUP BY agrupa según el nombre del curso
-- COUNT cuentas la cantidad de estudiantes en cada grupo
-- SE ordenan en forma descendente y con el LIMIT 1 se indica que devuelva solo la primera fila,
-- en este caso solo el curso con mayor estudiantes.
SELECT c.nombre, COUNT(*) AS total
FROM inscripciones i
JOIN cursos c ON i.curso_id = c.id
GROUP BY c.nombre
ORDER BY total DESC
LIMIT 1;
