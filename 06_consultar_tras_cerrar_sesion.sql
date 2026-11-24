-- =====================================================================
-- Actividad 2 - Script 06: consultar DEPARTMENTS2 después de cerrar la
-- sesión y volver a conectarse como HR.
-- Herramienta: SQL Developer, conexión HR. Ejecutar con F5.
-- =====================================================================
SET LINESIZE 200
COLUMN department_name FORMAT A24

-- La tabla existe (el CREATE TABLE es DDL y se confirmó solo), pero las tres
-- tuplas insertadas sin COMMIT solo aparecen si la transacción se confirmó
-- al cerrar la sesión.
SELECT COUNT(*) AS filas_departments2 FROM departments2;

SELECT department_id, department_name, location_id
FROM   departments2
WHERE  department_id >= 280
ORDER  BY department_id;
