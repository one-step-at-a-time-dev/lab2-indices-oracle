-- =====================================================================
-- Actividad 2 - Script 07: bloque anónimo PL/SQL que indica el comienzo y
-- la finalización de una transacción sobre DEPARTMENTS2.
-- Herramienta: SQL Developer, conexión HR. Ejecutar con F5.
-- =====================================================================
SET AUTOCOMMIT OFF
SET SERVEROUTPUT ON
SET LINESIZE 200
COLUMN department_name FORMAT A24

DECLARE
  v_filas NUMBER;
BEGIN
  -- Cierra cualquier transacción pendiente para que la siguiente sentencia
  -- sea la primera de una transacción nueva.
  COMMIT;

  -- COMIENZO: SET TRANSACTION debe ser la primera sentencia de la transacción
  SET TRANSACTION NAME 'tx_departments2';
  DBMS_OUTPUT.PUT_LINE('INICIO de la transaccion tx_departments2 - '
                       || TO_CHAR(SYSTIMESTAMP, 'DD/MM/YYYY HH24:MI:SS'));

  INSERT INTO departments2 (department_id, department_name, manager_id, location_id)
  VALUES (310, 'Gestion del Conocimiento', NULL, 1700);

  UPDATE departments2
  SET    location_id = 1800
  WHERE  department_id = 310;

  SELECT COUNT(*) INTO v_filas FROM departments2;
  DBMS_OUTPUT.PUT_LINE('Transaccion activa. ID: ' || DBMS_TRANSACTION.LOCAL_TRANSACTION_ID
                       || ' - filas en departments2: ' || v_filas);

  -- FINALIZACIÓN: COMMIT confirma los cambios y termina la transacción
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('FIN de la transaccion (COMMIT) - '
                       || TO_CHAR(SYSTIMESTAMP, 'DD/MM/YYYY HH24:MI:SS'));
  DBMS_OUTPUT.PUT_LINE('Transaccion activa despues del COMMIT: '
                       || NVL(DBMS_TRANSACTION.LOCAL_TRANSACTION_ID, 'ninguna'));
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;  -- si algo falla, la transacción termina deshaciendo los cambios
    DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM || ' -> ROLLBACK');
    RAISE; -- Propagar el error para que el cliente informe del fallo del bloque.
END;
/

-- Comprobación del resultado; interpretar junto con la salida y los errores del bloque.
SELECT department_id, department_name, location_id
FROM   departments2
WHERE  department_id = 310;
