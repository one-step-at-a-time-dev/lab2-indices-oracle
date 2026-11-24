-- =====================================================================
-- Actividad 2 - Script 05: crear el duplicado DEPARTMENTS2 e insertar
-- tres tuplas SIN confirmar la transacción.
-- Herramienta: SQL Developer, conexión HR. Ejecutar con F5.
-- Después de ejecutarlo: cerrar la sesión (Desconectar) SIN hacer COMMIT.
-- =====================================================================
SET AUTOCOMMIT OFF
SHOW AUTOCOMMIT
SET LINESIZE 200
SET PAGESIZE 100
COLUMN table_name      FORMAT A12
COLUMN constraint_name FORMAT A18
COLUMN tipo            FORMAT A4
COLUMN department_name FORMAT A24
COLUMN condicion       FORMAT A30

-- 5.0 Permite repetir el script: borra la copia si ya existía
DECLARE
  tabla_no_existe EXCEPTION;
  PRAGMA EXCEPTION_INIT(tabla_no_existe, -942);
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE departments2 PURGE';
EXCEPTION
  WHEN tabla_no_existe THEN NULL;
END;
/

-- 5.1 Duplicado de DEPARTMENTS (estructura + datos) con CREATE TABLE AS SELECT.
--     DDL válido sintácticamente confirma antes; si termina correctamente, después.
--     El DROP anterior también tiene este efecto sobre cualquier DML pendiente.
CREATE TABLE departments2 AS
SELECT * FROM departments;

SELECT COUNT(*) AS filas_departments2 FROM departments2;

-- 5.2 CTAS hereda NOT NULL explícitos, NOT DEFERRABLE y VALIDATED al
--     seleccionar directamente las columnas (en este caso, DEPARTMENT_NAME).
--     No hereda el NOT NULL implícito de la PK, ni PK, UK, FK o índices.
SELECT table_name, constraint_name, constraint_type AS tipo, search_condition_vc AS condicion
FROM   user_constraints
WHERE  table_name IN ('DEPARTMENTS', 'DEPARTMENTS2')
ORDER  BY table_name, constraint_type;

SELECT table_name, index_name
FROM   user_indexes
WHERE  table_name IN ('DEPARTMENTS', 'DEPARTMENTS2')
ORDER  BY table_name;

-- 5.3 Insertar tres tuplas (sin COMMIT)
INSERT INTO departments2 (department_id, department_name, manager_id, location_id)
VALUES (280, 'Analitica de Datos', NULL, 1700);

INSERT INTO departments2 (department_id, department_name, manager_id, location_id)
VALUES (290, 'Ciberseguridad', NULL, 1700);

INSERT INTO departments2 (department_id, department_name, manager_id, location_id)
VALUES (300, 'Transformacion Digital', NULL, 2400);

-- 5.4 En esta sesión se ven las tres filas nuevas: N + 3, donde N es el recuento inicial.
SELECT department_id, department_name, location_id
FROM   departments2
WHERE  department_id >= 280
ORDER  BY department_id;

SELECT COUNT(*) AS filas_departments2 FROM departments2;

-- Conservar el resultado antes de desconectar y observar la decisión de cierre.
SELECT DBMS_TRANSACTION.LOCAL_TRANSACTION_ID AS transaccion_pendiente
FROM dual;
