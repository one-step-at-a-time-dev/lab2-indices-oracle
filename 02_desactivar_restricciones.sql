-- =====================================================================
-- Actividad 2 - Script 02: consultar y desactivar las restricciones de
-- EMPLOYEES y DEPARTMENTS.
-- Herramienta: SQL Developer, conexión HR. Ejecutar con F5.
-- =====================================================================
SET LINESIZE 200
SET PAGESIZE 100
COLUMN table_name        FORMAT A12
COLUMN constraint_name   FORMAT A18
COLUMN tipo              FORMAT A4
COLUMN status            FORMAT A9
COLUMN validated         FORMAT A13
COLUMN r_constraint_name FORMAT A14

-- 2.1 Restricciones antes de desactivarlas
--     Tipos: P = clave primaria, U = única, R = clave foránea, C = CHECK / NOT NULL
SELECT table_name, constraint_name, constraint_type AS tipo, status, validated, r_constraint_name
FROM   user_constraints
WHERE  table_name IN ('EMPLOYEES', 'DEPARTMENTS')
ORDER  BY table_name, constraint_type, constraint_name;

-- 2.2 Desactivar primero las claves foráneas propias de las dos tablas
ALTER TABLE employees   DISABLE CONSTRAINT emp_dept_fk;
ALTER TABLE employees   DISABLE CONSTRAINT emp_job_fk;
ALTER TABLE employees   DISABLE CONSTRAINT emp_manager_fk;
ALTER TABLE departments DISABLE CONSTRAINT dept_loc_fk;
ALTER TABLE departments DISABLE CONSTRAINT dept_mgr_fk;

-- 2.3 Desactivar las restricciones CHECK y NOT NULL
ALTER TABLE employees   DISABLE CONSTRAINT emp_salary_min;
ALTER TABLE employees   DISABLE CONSTRAINT emp_last_name_nn;
ALTER TABLE employees   DISABLE CONSTRAINT emp_email_nn;
ALTER TABLE employees   DISABLE CONSTRAINT emp_hire_date_nn;
ALTER TABLE employees   DISABLE CONSTRAINT emp_job_nn;
ALTER TABLE departments DISABLE CONSTRAINT dept_name_nn;

-- 2.4 Desactivar la restricción única y las claves primarias.
--     CASCADE desactiva también las claves foráneas de otras tablas que
--     apuntan a estas claves primarias (JOB_HISTORY.JHIST_EMP_FK y
--     JOB_HISTORY.JHIST_DEPT_FK); sin CASCADE Oracle devuelve ORA-02297.
ALTER TABLE employees   DISABLE CONSTRAINT emp_email_uk;
ALTER TABLE employees   DISABLE CONSTRAINT emp_emp_id_pk CASCADE;
ALTER TABLE departments DISABLE CONSTRAINT dept_id_pk CASCADE;

-- 2.5 Comprobación: todas deben aparecer como DISABLED
SELECT table_name, constraint_name, constraint_type AS tipo, status, validated
FROM   user_constraints
WHERE  table_name IN ('EMPLOYEES', 'DEPARTMENTS')
   OR  constraint_name IN ('JHIST_EMP_FK', 'JHIST_DEPT_FK')
ORDER  BY table_name, constraint_type, constraint_name;

-- 2.6 Comprobar qué índices permanecen después de desactivar PK y UK.
-- CONSTRAINT_INDEX indica si Oracle creó el índice como parte de una restricción.
-- Esta consulta permite comprobar la premisa de la prueba 3.4.
COLUMN index_name       FORMAT A18
COLUMN uniqueness       FORMAT A10
COLUMN constraint_index FORMAT A16
SELECT table_name, index_name, uniqueness, status, constraint_index
FROM   user_indexes
WHERE  table_name IN ('EMPLOYEES', 'DEPARTMENTS')
ORDER  BY table_name, index_name;
