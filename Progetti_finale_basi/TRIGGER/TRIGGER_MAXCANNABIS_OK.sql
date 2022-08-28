-- UN CLIENTE PUO ACQUISTARE UN MASSIMO DI 3 TIPI DI CANNABIS AL GIORNO
CREATE OR REPLACE TRIGGER MAXCANNABIS
BEFORE INSERT ON CONTIENE
FOR EACH ROW
DECLARE
ERROR_MAXS EXCEPTION;
RIS  NUMBER;
NCOD VARCHAR(20);
QTC NUMBER;
NTESS VARCHAR(20);
BEGIN

-- PRENDO IL NUOVO NUMERO SCONTRINO
NCOD:=:NEW.COD_BARRE;
QTC:=:NEW.QUANTITA_C;

-- PRENDO LA QUANTITA DAL NUOVO SCONTRINO
IF((NCOD = 'COD_BARRE001' OR
NCOD='COD_BARRE002' OR 
NCOD='COD_BARRE003' OR 
NCOD='COD_BARRE004' OR
NCOD='COD_BARRE005' OR
NCOD='COD_BARRE016' OR
NCOD='COD_BARRE017' OR
NCOD='COD_BARRE018' OR
NCOD='COD_BARRE019') AND QTC>3) THEN 
RAISE ERROR_MAXS;
END IF;

SELECT S.NUM_TESSERA INTO NTESS
FROM TESSERA T JOIN SCONTRINO S ON(T.NUM_TESSERA=S.NUM_TESSERA)
WHERE S.NUM_SCONTRINO=:NEW.NUM_SCONTRINO;


-- CONFRONTO IL CODICE A BARRE DELLE CANNABIS E CONTO QUANTE VOLTE E' STATA ACQUISTATA NEL GIORNO CORRENTE 
SELECT SUM(QUANTITA_C) INTO RIS
FROM SCONTRINO S JOIN CONTIENE C ON (S.NUM_SCONTRINO=C.NUM_SCONTRINO)
WHERE TO_CHAR(DATA_ORA,'DD-MM-YYYY')=TO_CHAR(SYSDATE,'DD-MM-YYYY') AND S.NUM_TESSERA=NTESS AND (NCOD = 'COD_BARRE001' OR
NCOD='COD_BARRE002' OR
NCOD='COD_BARRE003' OR 
NCOD='COD_BARRE004' OR
NCOD='COD_BARRE005' OR
NCOD='COD_BARRE016' OR
NCOD='COD_BARRE017' OR
NCOD='COD_BARRE018' OR
NCOD='COD_BARRE019');
IF((RIS+QTC)>3) THEN 
RAISE ERROR_MAXS;
END IF;

EXCEPTION
WHEN NO_DATA_FOUND THEN NULL;
WHEN ERROR_MAXS THEN
RAISE_APPLICATION_ERROR(-20032, 'PUOI ACQUISTARE UN MASSIMO DI 3 QUANTITA DI CANNABIS AL GIORNO');
END;
/



