-- =====================================================================
-- Actividad 2 - Script 08: cómo deshacer una transacción en Oracle
-- (ROLLBACK y ROLLBACK TO SAVEPOINT) con un ejemplo sobre DEPARTMENTS2.
-- Herramienta: SQL Developer, conexión HR. Ejecutar con F5.
-- =====================================================================
SET AUTOCOMMIT OFF
SET LINESIZE 200
COLUMN department_name FORMAT A24

COMMIT;  -- punto de partida limpio

-- Paso 1: insertar un departamento y marcar un punto de guardado
INSERT INTO departments2 (department_id, department_name, manager_id, location_id)
VALUES (320, 'Innovacion', NULL, 1700);

SAVEPOINT sp_despues_insert;

-- Paso 2: dos cambios más dentro de la misma transacción
UPDATE departments2 SET department_name = 'Innovacion y Desarrollo' WHERE department_id = 320;
DELETE FROM departments2 WHERE department_id = 10;

SELECT COUNT(*) AS filas, 'tras INSERT, UPDATE y DELETE' AS momento FROM departments2;
SELECT department_id, department_name FROM departments2 WHERE department_id IN (10, 320) ORDER BY 1;

-- Paso 3: deshacer solo lo posterior al SAVEPOINT (UPDATE y DELETE)
ROLLBACK TO SAVEPOINT sp_despues_insert;

SELECT COUNT(*) AS filas, 'tras ROLLBACK TO SAVEPOINT' AS momento FROM departments2;
SELECT department_id, department_name FROM departments2 WHERE department_id IN (10, 320) ORDER BY 1;

-- Paso 4: deshacer toda la transacción (también el INSERT)
ROLLBACK;

SELECT COUNT(*) AS filas, 'tras ROLLBACK' AS momento FROM departments2;
SELECT department_id, department_name FROM departments2 WHERE department_id IN (10, 320) ORDER BY 1;
