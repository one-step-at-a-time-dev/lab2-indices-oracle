-- =====================================================================
-- Actividad 2 - Script 03: insertar tuplas que NO cumplen las restricciones
-- (que están desactivadas).
-- Herramienta: SQL Developer, conexión HR. Ejecutar con F5 después del 02.
-- =====================================================================
SET LINESIZE 200
COLUMN department_name FORMAT A16
COLUMN last_name       FORMAT A10
COLUMN email           FORMAT A8
COLUMN job_id          FORMAT A8

-- 3.1 DEPARTMENTS: nombre NULL (DEPT_NAME_NN), jefe 999 que no existe en
--     EMPLOYEES (DEPT_MGR_FK) y ubicación 9999 que no existe en LOCATIONS
--     (DEPT_LOC_FK).
INSERT INTO departments (department_id, department_name, manager_id, location_id)
VALUES (280, NULL, 999, 9999);

-- 3.2 EMPLOYEES: apellido, email y fecha de contratación NULL (restricciones
--     NOT NULL), salario negativo (EMP_SALARY_MIN), cargo inexistente
--     (EMP_JOB_FK), jefe 999 inexistente (EMP_MANAGER_FK) y departamento
--     999 inexistente (EMP_DEPT_FK).
INSERT INTO employees (employee_id, first_name, last_name, email, phone_number,
                       hire_date, job_id, salary, commission_pct, manager_id, department_id)
VALUES (300, 'Prueba', NULL, NULL, NULL,
        NULL, 'XX_JOB', -500, NULL, 999, 999);

COMMIT;

-- 3.3 Las filas quedaron guardadas aunque violan las reglas
SELECT department_id, department_name, manager_id, location_id
FROM   departments
WHERE  department_id = 280;

SELECT employee_id, first_name, last_name, email, hire_date, job_id, salary, manager_id, department_id
FROM   employees
WHERE  employee_id = 300;

-- 3.4 Comprobar el rechazo de un id de departamento repetido.
--     HR v21.1 crea DEPT_ID_PK mediante CREATE UNIQUE INDEX antes de la PK.
--     Si la consulta 2.6 muestra el índice UNIQUE y VALID, sigue impidiendo
--     duplicados con la PK desactivada. Resultado esperado: ORA-00001.
--     Si la fila se inserta, revisar ese resultado antes de ejecutar el 04.
INSERT INTO departments (department_id, department_name)
VALUES (10, 'Departamento duplicado');
