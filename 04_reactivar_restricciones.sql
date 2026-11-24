-- =====================================================================
-- Actividad 2 - Script 04: volver a establecer las restricciones.
-- Herramienta: SQL Developer, conexión HR. Ejecutar con F5 después del 03.
-- Algunos errores son ESPERADOS y forman parte de lo que se documenta.
-- =====================================================================
SET LINESIZE 200
SET PAGESIZE 100
COLUMN table_name      FORMAT A12
COLUMN constraint_name FORMAT A18
COLUMN tipo            FORMAT A4
COLUMN status          FORMAT A9
COLUMN validated       FORMAT A13

-- 4.1 Intento normal (ENABLE = ENABLE VALIDATE): Oracle revisa las filas
--     existentes. Primero las claves primarias y la única (no hay datos que
--     las violen), después CHECK / NOT NULL y por último las foráneas.
ALTER TABLE departments ENABLE CONSTRAINT dept_id_pk;
ALTER TABLE employees   ENABLE CONSTRAINT emp_emp_id_pk;
ALTER TABLE employees   ENABLE CONSTRAINT emp_email_uk;
ALTER TABLE employees   ENABLE CONSTRAINT emp_job_nn;
ALTER TABLE departments ENABLE CONSTRAINT dept_name_nn;     -- esperado: ORA-02296
ALTER TABLE employees   ENABLE CONSTRAINT emp_last_name_nn; -- esperado: ORA-02296
ALTER TABLE employees   ENABLE CONSTRAINT emp_email_nn;     -- esperado: ORA-02296
ALTER TABLE employees   ENABLE CONSTRAINT emp_hire_date_nn; -- esperado: ORA-02296
ALTER TABLE employees   ENABLE CONSTRAINT emp_salary_min;   -- esperado: ORA-02293
ALTER TABLE departments ENABLE CONSTRAINT dept_loc_fk;      -- esperado: ORA-02298
ALTER TABLE departments ENABLE CONSTRAINT dept_mgr_fk;      -- esperado: ORA-02298
ALTER TABLE employees   ENABLE CONSTRAINT emp_dept_fk;      -- esperado: ORA-02298
ALTER TABLE employees   ENABLE CONSTRAINT emp_job_fk;       -- esperado: ORA-02298
ALTER TABLE employees   ENABLE CONSTRAINT emp_manager_fk;   -- esperado: ORA-02298
ALTER TABLE job_history ENABLE CONSTRAINT jhist_emp_fk;
ALTER TABLE job_history ENABLE CONSTRAINT jhist_dept_fk;

-- 4.2 Alternativa: ENABLE NOVALIDATE. La restricción vuelve a aplicarse a
--     las inserciones y modificaciones sometidas a la regla; no valida el histórico.
ALTER TABLE departments ENABLE NOVALIDATE CONSTRAINT dept_name_nn;
ALTER TABLE employees   ENABLE NOVALIDATE CONSTRAINT emp_last_name_nn;
ALTER TABLE employees   ENABLE NOVALIDATE CONSTRAINT emp_email_nn;
ALTER TABLE employees   ENABLE NOVALIDATE CONSTRAINT emp_hire_date_nn;
ALTER TABLE employees   ENABLE NOVALIDATE CONSTRAINT emp_salary_min;
ALTER TABLE departments ENABLE NOVALIDATE CONSTRAINT dept_loc_fk;
ALTER TABLE departments ENABLE NOVALIDATE CONSTRAINT dept_mgr_fk;
ALTER TABLE employees   ENABLE NOVALIDATE CONSTRAINT emp_dept_fk;
ALTER TABLE employees   ENABLE NOVALIDATE CONSTRAINT emp_job_fk;
ALTER TABLE employees   ENABLE NOVALIDATE CONSTRAINT emp_manager_fk;

-- Evidencia del estado intermedio, antes de eliminar las filas inválidas.
SELECT table_name, constraint_name, constraint_type AS tipo, status, validated
FROM   user_constraints
WHERE  table_name IN ('EMPLOYEES', 'DEPARTMENTS')
ORDER  BY table_name, constraint_type, constraint_name;

-- Prueba: una nueva fila inválida ya es rechazada (esperado: ORA-01400)
INSERT INTO departments (department_id, department_name) VALUES (281, NULL);

-- 4.3 Corregir los datos: eliminar las tuplas inválidas del script 03 y
--     validar todas las restricciones sobre los datos existentes.
DELETE FROM employees   WHERE employee_id   = 300;
DELETE FROM departments WHERE department_id = 280;
COMMIT;

ALTER TABLE departments MODIFY CONSTRAINT dept_name_nn     VALIDATE;
ALTER TABLE employees   MODIFY CONSTRAINT emp_last_name_nn VALIDATE;
ALTER TABLE employees   MODIFY CONSTRAINT emp_email_nn     VALIDATE;
ALTER TABLE employees   MODIFY CONSTRAINT emp_hire_date_nn VALIDATE;
ALTER TABLE employees   MODIFY CONSTRAINT emp_salary_min   VALIDATE;
ALTER TABLE departments MODIFY CONSTRAINT dept_loc_fk      VALIDATE;
ALTER TABLE departments MODIFY CONSTRAINT dept_mgr_fk      VALIDATE;
ALTER TABLE employees   MODIFY CONSTRAINT emp_dept_fk      VALIDATE;
ALTER TABLE employees   MODIFY CONSTRAINT emp_job_fk       VALIDATE;
ALTER TABLE employees   MODIFY CONSTRAINT emp_manager_fk   VALIDATE;

-- 4.4 Estado final: todas ENABLED y VALIDATED
SELECT table_name, constraint_name, constraint_type AS tipo, status, validated
FROM   user_constraints
WHERE  table_name IN ('EMPLOYEES', 'DEPARTMENTS')
   OR  constraint_name IN ('JHIST_EMP_FK', 'JHIST_DEPT_FK')
ORDER  BY table_name, constraint_type, constraint_name;
