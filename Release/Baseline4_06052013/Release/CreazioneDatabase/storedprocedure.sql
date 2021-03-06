
  CREATE OR REPLACE PROCEDURE "GRUPPOROSSO"."AGGIUNGI_PRIVILEGI" 
(
  P_USERNAME IN VARCHAR2
) AS
BEGIN
  INSERT INTO GRUPPO_ACCOUNT VALUES('giornalista', P_USERNAME);
  COMMIT;
END AGGIUNGI_PRIVILEGI;
/
 
  CREATE OR REPLACE PROCEDURE "GRUPPOROSSO"."ANNULLA" 
(
  P_ID IN NUMBER
) AS
BEGIN
  UPDATE NOTIZIA SET stato='S', lock_n='N' WHERE id=P_ID;
  commit;
END ANNULLA;
/
 
  CREATE OR REPLACE PROCEDURE "GRUPPOROSSO"."ANNULLA_LISTA" 
(
 P_USER IN VARCHAR
) AS
BEGIN
  UPDATE NOTIZIA SET lock_n='N' WHERE ultimo_lock=P_USER;
  commit;
END ANNULLA_LISTA;
/
 
  CREATE OR REPLACE PROCEDURE "GRUPPOROSSO"."CANCELLA_ACCOUNT" 
(
  P_USERNAME IN VARCHAR2
) AS
BEGIN
  UPDATE ACCOUNT SET stato='C' WHERE username=P_USERNAME;
  DELETE FROM gruppo_account WHERE username=P_USERNAME;
  COMMIT;
END CANCELLA_ACCOUNT;
/
 
  CREATE OR REPLACE PROCEDURE "GRUPPOROSSO"."CANCELLAZIONE_NOTIZIA" 
(
  P_ID IN NUMBER
) AS
BEGIN
  UPDATE NOTIZIA SET stato='C' WHERE id=P_ID;
  COMMIT;
END CANCELLAZIONE_NOTIZIA;
/
 
  CREATE OR REPLACE PROCEDURE "GRUPPOROSSO"."CARICA_FUNZIONALITA" 
(
  P_NOME_GRUPPO IN VARCHAR2
, P_CURSOR OUT SYS_REFCURSOR
) AS
BEGIN
  OPEN P_CURSOR FOR
        SELECT * FROM funzionalita f, funzionalita_gruppo g WHERE f.sigla_funzionalita=g.sigla_funzionalita and g.nome_gruppo=P_NOME_GRUPPO;
END CARICA_FUNZIONALITA;
/
 
  CREATE OR REPLACE PROCEDURE "GRUPPOROSSO"."CERCA_ACCOUNT_USERNAME" 
(
  P_USERNAME IN VARCHAR2
, P_CURSOR OUT SYS_REFCURSOR
) AS
BEGIN
  OPEN P_CURSOR FOR
        SELECT * FROM account WHERE username=P_USERNAME;
END CERCA_ACCOUNT_USERNAME;
/
 
  CREATE OR REPLACE PROCEDURE "GRUPPOROSSO"."CERCA_NOTIZIA_AUTORE" (P_AUTORE IN VARCHAR2,P_MIN IN NUMBER, P_MAX IN NUMBER, P_CURSOR OUT SYS_REFCURSOR )
AS
BEGIN
    OPEN P_CURSOR FOR
	SELECT *
	FROM(select e.*, ROWNUM r_num
		FROM (SELECT * FROM notizia WHERE autore LIKE ('%'||P_AUTORE||'%') ORDER BY data_creazione DESC) e
		WHERE ROWNUM <= P_MAX)
		WHERE r_num >= P_MIN;
END CERCA_NOTIZIA_AUTORE;

/
 
  CREATE OR REPLACE PROCEDURE "GRUPPOROSSO"."CERCA_NOTIZIA_ID" (P_ID IN NUMBER, P_CURSOR OUT SYS_REFCURSOR )
AS
BEGIN
    OPEN P_CURSOR FOR
        SELECT * FROM notizia WHERE id=P_ID;
END CERCA_NOTIZIA_ID;
/
 
  CREATE OR REPLACE PROCEDURE "GRUPPOROSSO"."CERCA_NOTIZIA_STATO" (P_STATO IN VARCHAR2, P_MIN IN NUMBER, P_MAX IN NUMBER, P_CURSOR OUT SYS_REFCURSOR )
AS
BEGIN
    OPEN P_CURSOR FOR
	SELECT *
	FROM(select e.*, ROWNUM r_num
		FROM (SELECT * FROM notizia WHERE stato=P_STATO ORDER BY data_creazione DESC) e
		WHERE ROWNUM <= P_MAX)
		WHERE r_num >= P_MIN;
END CERCA_NOTIZIA_STATO;

/
 
  CREATE OR REPLACE PROCEDURE "GRUPPOROSSO"."CERCA_NOTIZIA_TITOLO" (P_TITOLO IN VARCHAR2,P_MIN IN NUMBER, P_MAX IN NUMBER, P_CURSOR OUT SYS_REFCURSOR )
AS
BEGIN
    OPEN P_CURSOR FOR
	SELECT *
	FROM(select e.*, ROWNUM r_num
		FROM (SELECT * FROM
		notizia WHERE titolo LIKE ('%'||P_TITOLO||'%') ORDER BY data_creazione DESC) e
		WHERE ROWNUM <= P_MAX)
		WHERE r_num >= P_MIN;
END CERCA_NOTIZIA_TITOLO;

/
 
  CREATE OR REPLACE PROCEDURE "GRUPPOROSSO"."CONTA_ACCOUNT" (
  P_COUNT OUT NUMBER
) AS
BEGIN
  SELECT COUNT(*) INTO P_COUNT FROM ACCOUNT WHERE stato <> 'C';
END CONTA_ACCOUNT;
/
 
  CREATE OR REPLACE PROCEDURE "GRUPPOROSSO"."CONTA_NOTIZIE" 
(
  P_COUNT OUT NUMBER
) AS
BEGIN
  SELECT COUNT(*) INTO P_COUNT FROM NOTIZIA;
END CONTA_NOTIZIE;
/
 
  CREATE OR REPLACE PROCEDURE "GRUPPOROSSO"."CONTA_NOTIZIE_AUTORE" 
(
  P_AUTORE IN VARCHAR2
, P_COUNT OUT NUMBER
) AS
BEGIN
  SELECT COUNT(*) INTO P_COUNT FROM NOTIZIA WHERE autore LIKE ('%'||P_AUTORE||'%');
END CONTA_NOTIZIE_AUTORE;
/
 
  CREATE OR REPLACE PROCEDURE "GRUPPOROSSO"."CONTA_NOTIZIE_ID" 
(
  P_ID IN NUMBER
, P_COUNT OUT NUMBER
) AS
BEGIN
  SELECT COUNT(*) INTO P_COUNT FROM NOTIZIA WHERE id=P_ID;
END CONTA_NOTIZIE_ID;
/
 
  CREATE OR REPLACE PROCEDURE "GRUPPOROSSO"."CONTA_NOTIZIE_STATO" 
(
  P_STATO IN VARCHAR2
, P_COUNT OUT NUMBER
) AS
BEGIN
  SELECT COUNT(*) INTO P_COUNT FROM NOTIZIA WHERE stato=P_STATO;
END CONTA_NOTIZIE_STATO;
/
 
  CREATE OR REPLACE PROCEDURE "GRUPPOROSSO"."CONTA_NOTIZIE_TITOLO" 
(
  P_TITOLO IN VARCHAR2
, P_COUNT OUT NUMBER
) AS
BEGIN
  SELECT COUNT(*) INTO P_COUNT FROM NOTIZIA WHERE titolo LIKE ('%'||P_TITOLO||'%');
END CONTA_NOTIZIE_TITOLO;
/
 
  CREATE OR REPLACE PROCEDURE "GRUPPOROSSO"."CONTROLLO_FUNZIONALITA" 
(
  P_NOME_GRUPPO IN VARCHAR2
, P_FUNZIONALITA IN VARCHAR2
, P_CURSOR OUT SYS_REFCURSOR
) AS
BEGIN
  OPEN P_CURSOR FOR
        SELECT * FROM funzionalita f, funzionalita_gruppo g
        WHERE f.sigla_funzionalita=g.sigla_funzionalita
        and g.nome_gruppo=P_NOME_GRUPPO
        and f.nome_funzionalita = P_FUNZIONALITA;
END CONTROLLO_FUNZIONALITA;
/
 
  CREATE OR REPLACE PROCEDURE "GRUPPOROSSO"."CREA_ACCOUNT" 
(
  P_NOME IN VARCHAR2
, P_COGNOME IN VARCHAR2
, P_USERNAME IN VARCHAR2
, P_PASSWORD IN VARCHAR2
, P_SIGLA_REDAZIONE IN VARCHAR2
, P_SIGLA_GIORNALISTA IN VARCHAR2
) AS
BEGIN
  INSERT INTO ACCOUNT (nome, cognome, username, password, sigla_redazione, sigla_giornalista) VALUES (P_NOME, P_COGNOME, P_USERNAME, P_PASSWORD, P_SIGLA_REDAZIONE, P_SIGLA_GIORNALISTA);
  INSERT INTO GRUPPO_ACCOUNT VALUES ('giornalista', P_USERNAME);
  COMMIT;
END CREA_ACCOUNT;
/
 
  CREATE OR REPLACE PROCEDURE "GRUPPOROSSO"."CREA_AMMINISTRATORE" 
(
  P_NOME IN VARCHAR2
, P_COGNOME IN VARCHAR2
, P_USERNAME IN VARCHAR2
, P_PASSWORD IN VARCHAR2
, P_SIGLA_REDAZIONE IN VARCHAR2
, P_SIGLA_GIORNALISTA IN VARCHAR2
) AS
BEGIN
  INSERT INTO ACCOUNT (nome, cognome, username, password, sigla_redazione, sigla_giornalista) VALUES (P_NOME, P_COGNOME, P_USERNAME, P_PASSWORD, P_SIGLA_REDAZIONE, P_SIGLA_GIORNALISTA);
  INSERT INTO GRUPPO_ACCOUNT VALUES ('amministratore', P_USERNAME);
  COMMIT;
END CREA_AMMINISTRATORE;
/
 
  CREATE OR REPLACE PROCEDURE "GRUPPOROSSO"."CREAZIONE_NOTIZIA" 
(
  P_TITOLO IN VARCHAR2
, P_SOTTOTITOLO IN VARCHAR2
, P_AUTORE IN VARCHAR2
, P_LUNGHEZZA_TESTO IN NUMBER
, P_TESTO IN NOTIZIA.testo%TYPE
) AS
BEGIN
  INSERT INTO NOTIZIA (titolo, sottotitolo, autore, lunghezza_testo, testo)
  VALUES
  (P_TITOLO, P_SOTTOTITOLO, P_AUTORE, P_LUNGHEZZA_TESTO, P_TESTO);
  COMMIT;
END CREAZIONE_NOTIZIA;
/
 
  CREATE OR REPLACE PROCEDURE "GRUPPOROSSO"."INSERISCI_NOTIZIA_ESTERNA" 
(
  P_TITOLO IN VARCHAR2
, P_SOTTOTITOLO IN VARCHAR2
, P_AUTORE IN VARCHAR2
, P_LUNGHEZZA_TESTO IN NUMBER
, P_TESTO IN NOTIZIA.testo%TYPE
, P_DATA_CREAZIONE IN DATE
) AS
BEGIN
  INSERT INTO NOTIZIA (titolo, sottotitolo, autore, lunghezza_testo, testo, data_creazione)
  VALUES
  (P_TITOLO, P_SOTTOTITOLO, P_AUTORE, P_LUNGHEZZA_TESTO, P_TESTO, P_DATA_CREAZIONE);
  COMMIT;
END INSERISCI_NOTIZIA_ESTERNA;
/
 
  CREATE OR REPLACE PROCEDURE "GRUPPOROSSO"."LISTA_ACCOUNT" 
(
  P_CURSOR OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN P_CURSOR FOR
        SELECT * FROM account a, gruppo_account g WHERE a.username=g.username;
END LISTA_ACCOUNT;
/
 
  CREATE OR REPLACE PROCEDURE "GRUPPOROSSO"."LISTA_ACCOUNT_2" (P_MIN IN NUMBER, P_MAX IN NUMBER, P_CURSOR OUT SYS_REFCURSOR)
AS
BEGIN
    OPEN P_CURSOR FOR
SELECT *
	FROM(select e.* , ROWNUM r_num
		FROM  (SELECT * FROM account WHERE stato <> 'C' ORDER BY username) e
		WHERE ROWNUM <= P_MAX)
		WHERE r_num >= P_MIN;
END LISTA_ACCOUNT_2;
/
 
  CREATE OR REPLACE PROCEDURE "GRUPPOROSSO"."LISTA_GIORNALISTI" 
(
  P_CURSOR OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN P_CURSOR FOR
        SELECT * FROM account a, gruppo_account g WHERE a.username=g.username AND g.nome_gruppo='giornalista';
END LISTA_GIORNALISTI;
/
 
  CREATE OR REPLACE PROCEDURE "GRUPPOROSSO"."LISTA_NOTIZIA" (P_MIN IN NUMBER, P_MAX IN NUMBER, P_CURSOR OUT SYS_REFCURSOR )
AS
BEGIN
    OPEN P_CURSOR FOR
	SELECT *
	FROM(select e.*, ROWNUM r_num
		FROM (SELECT * FROM notizia ORDER BY DATA_CREAZIONE desc) e
		WHERE ROWNUM <= P_MAX)
		WHERE r_num >= P_MIN;

END LISTA_NOTIZIA;

/
 
  CREATE OR REPLACE PROCEDURE "GRUPPOROSSO"."LOGIN" 
(
  P_USERNAME IN VARCHAR2
, P_PASSWORD IN VARCHAR2
, P_CURSOR OUT SYS_REFCURSOR
) AS
BEGIN
 OPEN P_CURSOR FOR
  SELECT * FROM account a, gruppo_account g WHERE a.username=P_USERNAME and a.password=P_PASSWORD and a.username=g.username;
END LOGIN;
/
 
  CREATE OR REPLACE PROCEDURE "GRUPPOROSSO"."MODIFICA_ACCOUNT" 
(
  P_USERNAME IN VARCHAR2
, P_PASSWORD IN VARCHAR2
, P_NOME IN VARCHAR2
, P_COGNOME IN VARCHAR2
, P_SIGLA_REDAZIONE IN VARCHAR2
, P_SIGLA_GIORNALISTA IN VARCHAR2
) AS
BEGIN
  UPDATE ACCOUNT
  SET
  nome=P_NOME, cognome=P_COGNOME, password=P_PASSWORD, sigla_redazione=P_SIGLA_REDAZIONE, sigla_giornalista=P_SIGLA_GIORNALISTA
  WHERE username=P_USERNAME;
  COMMIT;
END MODIFICA_ACCOUNT;
/
 
  CREATE OR REPLACE PROCEDURE "GRUPPOROSSO"."NOTIZIA_TRASMESSA" 
(
  P_ID IN NUMBER
) AS
BEGIN
  UPDATE NOTIZIA SET STATO='T' WHERE ID=P_ID;
  COMMIT;
END NOTIZIA_TRASMESSA;
/
 
  CREATE OR REPLACE PROCEDURE "GRUPPOROSSO"."PRENDI_NOTIZIA" 
(
  P_CURSOR OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN P_CURSOR FOR
        SELECT id, titolo, sottotitolo, autore, ultimo_digitatore, data_creazione, testo, data_trasmissione
        FROM NOTIZIA n WHERE n.stato= 'Q';
END PRENDI_NOTIZIA;
/
 
  CREATE OR REPLACE PROCEDURE "GRUPPOROSSO"."REGISTRA_NOTIZIE" 
(
  P_ID IN NUMBER
, P_TITOLO IN VARCHAR2
, P_SOTTOTITOLO IN VARCHAR2
, P_LUNGHEZZA_TESTO IN VARCHAR2
, P_TESTO IN CLOB
) AS
BEGIN
  UPDATE NOTIZIA
  SET titolo=P_TITOLO, sottotitolo=P_SOTTOTITOLO, lunghezza_testo=P_LUNGHEZZA_TESTO, testo=P_TESTO, lock_n='N', ULTIMO_DIGITATORE=ULTIMO_LOCK
  WHERE id=P_ID;
  COMMIT;
END REGISTRA_NOTIZIE;
/
 
  CREATE OR REPLACE PROCEDURE "GRUPPOROSSO"."RIMUOVI_PRIVILEGI" 
(
  P_USERNAME IN VARCHAR2
) AS
BEGIN
  DELETE FROM gruppo_account WHERE username=P_USERNAME and nome_gruppo='giornalista';
  COMMIT;
END RIMUOVI_PRIVILEGI;
/
 
  CREATE OR REPLACE PROCEDURE "GRUPPOROSSO"."SET_MODIFICA" 
(
  P_ID IN NUMBER
, P_USER IN VARCHAR2
) AS
BEGIN
  UPDATE NOTIZIA SET LOCK_N='Y', ultimo_lock=P_USER WHERE ID=P_ID;
  COMMIT;
END SET_MODIFICA;
/
 
  CREATE OR REPLACE PROCEDURE "GRUPPOROSSO"."STAMPA_ACCOUNT" 
(
  P_USERNAME IN VARCHAR2
, P_CURSOR OUT SYS_REFCURSOR
) AS
BEGIN
  OPEN P_CURSOR FOR
    SELECT * FROM ACCOUNT a, GRUPPO_ACCOUNT g WHERE a.username=P_USERNAME AND g.username=a.username;
END STAMPA_ACCOUNT;
/
 
  CREATE OR REPLACE PROCEDURE "GRUPPOROSSO"."TRASMETTI_NOTIZIA" 
(
  P_ID IN NUMBER
) AS
BEGIN
  UPDATE NOTIZIA SET stato='Q', data_trasmissione=CURRENT_TIMESTAMP WHERE id=P_ID;
  COMMIT;
END TRASMETTI_NOTIZIA;
/
 
  CREATE OR REPLACE PROCEDURE "GRUPPOROSSO"."VERIFICA_MODIFICA_NOTIZIA" 
(
  P_ID IN NUMBER
, P_USER IN VARCHAR2
, P_CURSOR OUT SYS_REFCURSOR
) AS
BEGIN
 OPEN P_CURSOR FOR
    SELECT * FROM NOTIZIA
    WHERE ID=P_ID
    AND ((LOCK_N='Y' AND ULTIMO_LOCK=P_USER) OR (LOCK_N='N'))
    AND STATO='S';
END VERIFICA_MODIFICA_NOTIZIA;
/
 