---exercise 1
CREATE TABLE DOKUMENTY (
    ID NUMBER(12) PRIMARY KEY,
    DOKUMENT CLOB
);

---excercise 2
DECLARE
    dane CLOB;
BEGIN
    for i in 1..10000
        LOOP
            dane := CONCAT(dane, 'Oto tekst. ');
        END LOOP;
        INSERT into DOKUMENTY
        values(1, dane);
END;

--excercise 3
SELECT * FROM DOKUMENTY;
SELECT upper(DOKUMENT) FROM DOKUMENTY;
SELECT length(DOKUMENT) FROM DOKUMENTY;
SELECT dbms_lob.getlength(DOKUMENT) FROM DOKUMENTY;
SELECT substr(DOKUMENT, 5, 1000) FROM DOKUMENTY;
SELECT dbms_lob.substr(DOKUMENT, 1000, 5) FROM DOKUMENTY;

--excercise 4
INSERT into DOKUMENTY values(2, EMPTY_CLOB());
--excercise 5
INSERT into DOKUMENTY values(3, null);

--excercise 7
SELECT * FROM all_directories;

--excercise 8
DECLARE
    lobd clob;
    fils BFILE:=BFILENAME('ZSBD_DIR','dokument.txt');
    doffset integer:=1;
    soffset integer:=1;
    langctx integer:=0;
    warn integer:=null;
BEGIN
 SELECT dokument INTO lobd FROM DOKUMENTY where id = 2
 FOR UPDATE;
 DBMS_LOB.fileopen(fils,DBMS_LOB.file_readonly);
 DBMS_LOB.LOADCLOBFROMFILE(lobd,fils,DBMS_LOB.LOBMAXSIZE,doffset,soffset,873,langctx,warn);
 DBMS_LOB.FILECLOSE(fils);
 COMMIT;
 DBMS_OUTPUT.PUT_LINE('Status operacji:'||warn);
END;

--excercise 9
UPDATE DOKUMENTY
SET dokument = TO_CLOB(BFILENAME('ZSBD_DIR','dokument.txt'))
WHERE id = 3;
--excercise 10
SELECT * FROM DOKUMENTY;

--excercise 11
SELECT length(DOKUMENT) FROM DOKUMENTY;
SELECT dbms_lob.getlength(DOKUMENT) FROM DOKUMENTY;

--excercise 12
DROP TABLE DOKUMENTY;

--excercise 13 - TODO: 
CREATE PROCEDURE CLOB_CENSOR(doc IN CLOB, text IN VARCHAR2)
IS
BEGIN
    DBMS_LOB.WRITE (doc, length(text), INSTR(doc, text), text);
END;
