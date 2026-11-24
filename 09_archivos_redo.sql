-- =====================================================================
-- Actividad 2 - Script 09: archivos de redo y modo de funcionamiento
-- (ARCHIVELOG / NOARCHIVELOG).
-- Las vistas V$ y el comando ARCHIVE LOG LIST requieren privilegios de
-- administrador, por eso este script se ejecuta en SQL*Plus como SYS sobre
-- el contenedor raíz (los redo log pertenecen a toda la instancia):
--   sqlplus sys@localhost:1521/XE as sysdba
--   Introducir la contraseña cuando SQL*Plus la solicite.
--   @09_archivos_redo.sql
-- =====================================================================
SHOW USER
SHOW CON_NAME
SET LINESIZE 200
SET PAGESIZE 100
COLUMN member  FORMAT A60
COLUMN status  FORMAT A10
COLUMN log_mode FORMAT A12

-- 9.1 Modo de funcionamiento de la base de datos
SELECT name, log_mode FROM v$database;
ARCHIVE LOG LIST

-- 9.2 Grupos de redo log en línea, su secuencia y estado
SELECT group#, sequence#, bytes/1024/1024 AS mb, members, archived, status
FROM   v$log
ORDER  BY group#;

-- 9.3 Archivos físicos (miembros) de cada grupo
SELECT group#, member FROM v$logfile ORDER BY group#;

-- 9.4 Cambio manual de grupo: Oracle pasa a escribir en el siguiente grupo
--     (uso circular); el grupo anterior queda ACTIVE o INACTIVE.
ALTER SYSTEM SWITCH LOGFILE;

SELECT group#, sequence#, archived, status
FROM   v$log
ORDER  BY group#;
