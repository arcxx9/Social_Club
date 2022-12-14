--PROCEDURA CHE ELIMINA IN AUTOMATICO DOPO 2 ANNI DALLA SCADENZA DELLA TESSERA, IL CLIENTE E QUEST'ULTIMA DAL DATABASE
CREATE OR REPLACE PROCEDURE ELIMINA_TESSERA IS
CURSOR C1 IS SELECT T.CF_CLIENTE,T.NUM_TESSERA, (TO_CHAR(SYSDATE,'YYYY')-(TO_CHAR(DATA_FINE,'YYYY'))) AS DATA_SCAD
			 FROM TESSERA T;

EMP_REC C1%ROWTYPE;
BEGIN

OPEN C1;
LOOP
FETCH C1 INTO EMP_REC;
EXIT WHEN C1 %NOTFOUND;
IF(EMP_REC.DATA_SCAD>=2) THEN 
DELETE FROM  TESSERA  WHERE CF_CLIENTE=EMP_REC.CF_CLIENTE AND NUM_TESSERA=EMP_REC.NUM_TESSERA;
DELETE FROM CLIENTE  WHERE CF_CLIENTE=EMP_REC.CF_CLIENTE;
END IF;
END LOOP;
CLOSE C1;
COMMIT;
END ELIMINA_TESSERA;
/


