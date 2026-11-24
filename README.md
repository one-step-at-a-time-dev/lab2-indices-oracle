# Actividad 2 – Índices y restricciones en Oracle

- **Curso:** Bases de Datos Avanzadas
- **Docente:** Deivis Eduard Ramírez Martínez
- **Estudiante:** Carlos Julian Valenzuela Garcia

Scripts ejecutados para la actividad sobre índices, restricciones, transacciones y archivos de redo en el esquema de ejemplo **HR**. Son exactamente los que aparecen en las capturas del informe.

## Entorno
- Oracle Database 21c Express Edition (contenedor `XEPDB1`)
- Esquema HR (db-sample-schemas v21.1)
- SQL Developer 26.2 y SQL*Plus 21c
- Scripts 01 a 08: usuario `HR` en `XEPDB1`, ejecutados con **F5** en SQL Developer
- Script 09: `SYS AS SYSDBA` en `CDB$ROOT`, ejecutado en SQL*Plus

## Scripts y resultados obtenidos

| Script | Qué hace | Resultado |
|---|---|---|
| `01_sesion_e_indices.sql` | Sesión e índices de EMPLOYEES y DEPARTMENTS | HR / XEPDB1; 8 índices (3 UNIQUE, 5 NONUNIQUE) |
| `02_desactivar_restricciones.sql` | Lista y desactiva las restricciones (PK con `CASCADE`) | 16 restricciones DISABLED; quedan 7 índices (DEPT_ID_PK y EMP_EMP_ID_PK siguen UNIQUE) |
| `03_insertar_tuplas_invalidas.sql` | Inserta filas que incumplen NOT NULL, CHECK y FK | Filas 280 y 300 insertadas; el departamento 10 repetido da ORA-00001 por el índice único |
| `04_reactivar_restricciones.sql` | ENABLE VALIDATE, ENABLE NOVALIDATE, limpieza y validación | ORA-02293 y ORA-02298 al validar; ORA-01400 con NOVALIDATE; al final 16 ENABLED / VALIDATED |
| `05_departments2_insertar.sql` | Crea DEPARTMENTS2 con CTAS e inserta 3 filas sin COMMIT | 27 filas copiadas, solo hereda el NOT NULL; 30 filas y transacción pendiente |
| `06_consultar_tras_cerrar_sesion.sql` | Consulta tras desconectar y reconectar | 30 filas: las inserciones se confirmaron al cerrar la conexión |
| `07_bloque_anonimo_transaccion.sql` | Bloque PL/SQL con inicio (`SET TRANSACTION`) y fin (`COMMIT`) | Fila 310 confirmada; sin transacción activa tras el COMMIT |
| `08_deshacer_transaccion.sql` | `ROLLBACK TO SAVEPOINT` y `ROLLBACK` | 31 → 32 → 31 filas |
| `09_archivos_redo.sql` | Modo de archivado, grupos de redo y cambio de grupo | NOARCHIVELOG; 3 grupos de 200 MB; el grupo actual pasa del 3 al 1 |

## Orden de ejecución
1. Conectarse en SQL Developer con el usuario `hr` (servicio `XEPDB1`).
2. Ejecutar del 01 al 05 con **F5**, en orden.
3. Desconectar la conexión HR, volver a conectarse y ejecutar el 06.
4. Ejecutar el 07 y el 08.
5. En SQL*Plus: `sqlplus sys@localhost:1521/XE as sysdba` y `@09_archivos_redo.sql`.

Nota: el script 05 borra y vuelve a crear DEPARTMENTS2, y repetir el 07 añade otra fila 310 (la copia no tiene clave primaria).
