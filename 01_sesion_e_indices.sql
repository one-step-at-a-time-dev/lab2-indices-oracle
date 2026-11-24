-- =====================================================================
-- Actividad 2 - Índices y restricciones en Oracle
-- Script 01: comprobar la sesión del usuario HR y consultar los índices
--            de las tablas EMPLOYEES y DEPARTMENTS.
-- Herramienta: SQL Developer, conexión HR (servicio XEPDB1). Ejecutar con F5.
-- =====================================================================
SET LINESIZE 200
SET PAGESIZE 100
COLUMN usuario      FORMAT A10
COLUMN contenedor   FORMAT A12
COLUMN table_name   FORMAT A12
COLUMN index_name   FORMAT A18
COLUMN index_type   FORMAT A10
COLUMN uniqueness   FORMAT A10
COLUMN columnas     FORMAT A30

-- 1.1 Usuario y contenedor de la sesión actual
SELECT USER                              AS usuario,
       SYS_CONTEXT('USERENV','CON_NAME') AS contenedor
FROM   dual;

-- 1.2 Índices de EMPLOYEES y DEPARTMENTS con sus columnas
SELECT i.table_name,
       i.index_name,
       i.index_type,
       i.uniqueness,
       LISTAGG(c.column_name, ', ') WITHIN GROUP (ORDER BY c.column_position) AS columnas
FROM   user_indexes i
       JOIN user_ind_columns c ON c.index_name = i.index_name
WHERE  i.table_name IN ('EMPLOYEES', 'DEPARTMENTS')
GROUP  BY i.table_name, i.index_name, i.index_type, i.uniqueness
ORDER  BY i.table_name, i.index_name;
