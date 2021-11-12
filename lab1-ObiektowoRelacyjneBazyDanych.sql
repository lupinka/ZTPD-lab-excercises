DROP TABLE SAMOCHODY;
DROP TYPE SAMOCHOD;

-- excercise 1--
CREATE TYPE Samochod as Object(
MARKA VARCHAR2(20),
MODEL VARCHAR2(20),
KILOMETRY NUMBER,
DATA_PRODUKCJI DATE,
CENA NUMBER(10,2)
)

desc Samochod
create table Samochody of Samochod

INSERT ALL
INTO Samochody values (new Samochod('FIAT', 'Brava', 60000, '1999-11-30', 25000))
INTO Samochody values (new Samochod('Ford', 'Mondeo', 80000, '1997-05-10', 45000))
INTO Samochody values (new Samochod('Mazda', '323', 12000, '2000-09-22', 52000))
SELECT 1 FROM Dual;

SELECT * FROM Samochody;

--excercise 2--
CREATE TABLE Wlasciciele (
IMIE VARCHAR2(100),
NAZWISKO VARCHAR2(100),
AUTO Samochod
);

INSERT ALL
INTO Wlasciciele values ('Jan','Kowalski', new Samochod('Skoda', 'Fabia', 10000, '2011-01-01', 30000))
INTO Wlasciciele values ('Adam', 'Nowak', new Samochod('FIAT', 'Brava', 6000, '1999-11-30', 25000))
SELECT 1 FROM Dual;

SELECT * from Wlasciciele;

--excercise 3 --
ALTER TYPE Samochod REPLACE AS OBJECT
(
    MARKA VARCHAR2(20),
    MODEL VARCHAR2(20),
    KILOMETRY NUMBER,
    DATA_PRODUKCJI DATE,
    CENA NUMBER(10,2),
    MEMBER FUNCTION wartosc RETURN NUMBER,
    MEMBER FUNCTION wiek RETURN NUMBER
);

CREATE OR REPLACE TYPE BODY Samochod AS
MEMBER FUNCTION wiek RETURN NUMBER IS
    BEGIN  
        RETURN EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT (YEAR FROM data_produkcji);
    END wiek;
MEMBER FUNCTION wartosc RETURN NUMBER IS
    BEGIN  
        RETURN CENA * POWER(0.9, wiek());
    END wartosc;
END;
    
SELECT s.marka, s.cena, s.wartosc() FROM SAMOCHODY s;

-- excercise 4 --
ALTER TYPE Samochod REPLACE AS OBJECT
(
    MARKA VARCHAR2(20),
    MODEL VARCHAR2(20),
    KILOMETRY NUMBER,
    DATA_PRODUKCJI DATE,
    CENA NUMBER(10,2),
    MEMBER FUNCTION wartosc RETURN NUMBER,
    MEMBER FUNCTION wiek RETURN NUMBER,
    MAP MEMBER FUNCTION odwzoruj RETURN NUMBER
);

CREATE OR REPLACE TYPE BODY Samochod AS
MEMBER FUNCTION wiek RETURN NUMBER IS
    BEGIN  
        RETURN EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT (YEAR FROM data_produkcji);
    END wiek;
MEMBER FUNCTION wartosc RETURN NUMBER IS
    BEGIN  
        RETURN CENA * POWER(0.9, wiek());
    END wartosc;
MAP MEMBER FUNCTION odwzoruj RETURN NUMBER IS
    BEGIN
        RETURN KILOMETRY/1000 + wiek();
    END odwzoruj;
END;

SELECT * FROM SAMOCHODY s ORDER BY VALUE(s);

--excercise 5 --
CREATE OR REPLACE TYPE Wlasciciel as Object(
IMIE VARCHAR2(100),
NAZWISKO VARCHAR2(100)
);

ALTER TYPE Samochod REPLACE AS OBJECT
(
    MARKA VARCHAR2(20),
    MODEL VARCHAR2(20),
    KILOMETRY NUMBER,
    DATA_PRODUKCJI DATE,
    CENA NUMBER(10,2),
    MEMBER FUNCTION wartosc RETURN NUMBER,
    MEMBER FUNCTION wiek RETURN NUMBER,
    MAP MEMBER FUNCTION odwzoruj RETURN NUMBER,
    WLASCICIEL REF Wlasciciel
);

--excercise 6
SET SERVEROUTPUT ON;

DECLARE
	TYPE t_przedmioty IS VARRAY(10) OF VARCHAR2(20);
	moje_przedmioty t_przedmioty := t_przedmioty('');
BEGIN
	moje_przedmioty(1) := 'MATEMATYKA';
	moje_przedmioty.EXTEND(9);
	FOR i IN 2..10 LOOP
		moje_przedmioty(i) := 'PRZEDMIOT_' || i;
	END LOOP;
	FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
		DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
	END LOOP;
	moje_przedmioty.TRIM(2);
	FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
		DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
	END LOOP;
	DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
	DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
	moje_przedmioty.EXTEND();
	moje_przedmioty(9) := 9;
	DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
	DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
	moje_przedmioty.DELETE();
	DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
	DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
END;

--excercise 7
DECLARE
	TYPE t_books IS VARRAY(10) OF VARCHAR2(20);
	my_books t_books := t_books('');
BEGIN
	my_books(1) := 'Harry Potter';
    my_books.EXTEND(5);
     FOR i IN my_books.FIRST()..my_books.LAST() LOOP
		DBMS_OUTPUT.PUT_LINE(my_books(i));
	END LOOP;
    FOR i IN 2..6 LOOP
		my_books(i) := 'BOOK_' || i;
	END LOOP;
    DBMS_OUTPUT.PUT_LINE('Limit: ' || my_books.LIMIT());
    my_books(5) := 'Hobbit';
    FOR i IN my_books.FIRST()..my_books.LAST() LOOP
		DBMS_OUTPUT.PUT_LINE(my_books(i));
    END LOOP;
    my_books.DELETE();
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || my_books.COUNT());
END;

--excercise 8
DECLARE
	TYPE t_wykladowcy IS TABLE OF VARCHAR2(20);
	moi_wykladowcy t_wykladowcy := t_wykladowcy();
BEGIN
	moi_wykladowcy.EXTEND(2);
	moi_wykladowcy(1) := 'MORZY';
	moi_wykladowcy(2) := 'WOJCIECHOWSKI';
	moi_wykladowcy.EXTEND(8);
	FOR i IN 3..10 LOOP
		moi_wykladowcy(i) := 'WYKLADOWCA_' || i;
	END LOOP;
	FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
		DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
	END LOOP;
		moi_wykladowcy.TRIM(2);
	FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
		DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
	END LOOP;
		moi_wykladowcy.DELETE(5,7);
		DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
		DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
	FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
		IF moi_wykladowcy.EXISTS(i) THEN
			DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
		END IF;
	END LOOP;
	moi_wykladowcy(5) := 'ZAKRZEWICZ';
	moi_wykladowcy(6) := 'KROLIKOWSKI';
	moi_wykladowcy(7) := 'KOSZLAJDA';
	FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
		IF moi_wykladowcy.EXISTS(i) THEN
			DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
		END IF;
	END LOOP;
	DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
	DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
END;

--excercise 9
DECLARE
	TYPE t_miesiace IS TABLE OF VARCHAR2(20);
	moje_miesiace t_miesiace := t_miesiace();
BEGIN
	moje_miesiace.EXTEND(12);
	moje_miesiace(1) := 'styczeń';
    moje_miesiace(2) := 'luty';
    moje_miesiace(3) := 'marzec';
    moje_miesiace(4) := 'kwiecień';
    moje_miesiace(5) := 'maj';
    moje_miesiace(6) := 'czerwiec';
    moje_miesiace(7) := 'lipiec';
    moje_miesiace(8) := 'sierpień';
    moje_miesiace(9) := 'wrzesień';
    moje_miesiace(10) := 'październik';
    moje_miesiace(11) := 'listopad';
    moje_miesiace(12) := 'grudzień';

	FOR i IN moje_miesiace.FIRST()..moje_miesiace.LAST() LOOP
		DBMS_OUTPUT.PUT_LINE(moje_miesiace(i));
	END LOOP;
		moje_miesiace.TRIM(2);
	FOR i IN moje_miesiace.FIRST()..moje_miesiace.LAST() LOOP
		DBMS_OUTPUT.PUT_LINE(moje_miesiace(i));
	END LOOP;
		moje_miesiace.DELETE(5,7);
		DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_miesiace.LIMIT());
		DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_miesiace.COUNT());
	FOR i IN moje_miesiace.FIRST()..moje_miesiace.LAST() LOOP
		IF moje_miesiace.EXISTS(i) THEN
			DBMS_OUTPUT.PUT_LINE(moje_miesiace(i));
		END IF;
	END LOOP;
END;

--excercise 10
CREATE TYPE jezyki_obce AS VARRAY(10) OF VARCHAR2(20);
/
CREATE TYPE stypendium AS OBJECT (
	nazwa VARCHAR2(50),
	kraj VARCHAR2(30),
	jezyki jezyki_obce );
/
CREATE TABLE stypendia OF stypendium;
INSERT INTO stypendia VALUES
	('SOKRATES','FRANCJA',jezyki_obce('ANGIELSKI','FRANCUSKI','NIEMIECKI'));
INSERT INTO stypendia VALUES
	('ERASMUS','NIEMCY',jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI'));
SELECT * FROM stypendia;
SELECT s.jezyki FROM stypendia s;
UPDATE STYPENDIA
	SET jezyki = jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI','FRANCUSKI')
	WHERE nazwa = 'ERASMUS';
CREATE TYPE lista_egzaminow AS TABLE OF VARCHAR2(20);
/
CREATE TYPE semestr AS OBJECT (
	numer NUMBER,
	egzaminy lista_egzaminow );
/
CREATE TABLE semestry OF semestr
	NESTED TABLE egzaminy STORE AS tab_egzaminy;
INSERT INTO semestry VALUES
	(semestr(1,lista_egzaminow('MATEMATYKA','LOGIKA','ALGEBRA')));
INSERT INTO semestry VALUES
	(semestr(2,lista_egzaminow('BAZY DANYCH','SYSTEMY OPERACYJNE')));
SELECT s.numer, e.*
	FROM semestry s, TABLE(s.egzaminy) e;
SELECT e.*
	FROM semestry s, TABLE ( s.egzaminy ) e;
SELECT * FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=1 );
INSERT INTO TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 )
	VALUES ('METODY NUMERYCZNE');
UPDATE TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
	SET e.column_value = 'SYSTEMY ROZPROSZONE'
	WHERE e.column_value = 'SYSTEMY OPERACYJNE';
DELETE FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
	WHERE e.column_value = 'BAZY DANYCH';
	
--excercise 11
CREATE TYPE produkty AS TABLE OF VARCHAR2(20);

CREATE TYPE zakup AS OBJECT
(
    id               NUMBER,
    koszyk_produktow produkty
);

CREATE TABLE zakupy OF zakup
    NESTED TABLE koszyk_produktow STORE AS tab_koszyk_produktow;

INSERT INTO zakupy
	VALUES (zakup(1, produkty('MASŁO', 'CZEKOLADA', 'COLA')));
INSERT INTO zakupy
	VALUES (zakup(2, produkty('JAJKA', 'POMIDORY')));
INSERT INTO zakupy
	VALUES (zakup(3, produkty('JOGURT', 'COLA')));

SELECT s.*, e.*
FROM zakupy s,
     TABLE (s.koszyk_produktow) e;

SELECT e.*
FROM zakupy s,
     TABLE ( s.koszyk_produktow ) e;

DELETE
FROM zakupy s
where s.id IN (
    SELECT z.id
    FROM zakupy z,
         TABLE (z.koszyk_produktow) p
    WHERE p.column_value = 'COLA'
);

--excercise 12
CREATE TYPE instrument AS OBJECT (
 nazwa VARCHAR2(20),
 dzwiek VARCHAR2(20),
 MEMBER FUNCTION graj RETURN VARCHAR2 ) NOT FINAL;
CREATE TYPE BODY instrument AS
 MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN dzwiek;
 END;
END;
/
CREATE TYPE instrument_dety UNDER instrument (
	material VARCHAR2(20),
	OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2,
	MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 );
CREATE OR REPLACE TYPE BODY instrument_dety AS
	OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
	BEGIN
		RETURN 'dmucham: '||dzwiek;
	END;
	MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 IS
	BEGIN
		RETURN glosnosc||':'||dzwiek;
	END;
END;
/
CREATE TYPE instrument_klawiszowy UNDER instrument (
	producent VARCHAR2(20),
	OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 );
CREATE OR REPLACE TYPE BODY instrument_klawiszowy AS
	OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
	BEGIN
		RETURN 'stukam w klawisze: '||dzwiek;
	END;
END;
/
DECLARE
	tamburyn instrument := instrument('tamburyn','brzdek-brzdek');
	trabka instrument_dety := instrument_dety('trabka','tra-ta-ta','metalowa');
	fortepian instrument_klawiszowy := instrument_klawiszowy('fortepian','pingping','steinway');
BEGIN
	dbms_output.put_line(tamburyn.graj);
	dbms_output.put_line(trabka.graj);
	dbms_output.put_line(trabka.graj('glosno');
	dbms_output.put_line(fortepian.graj);
END;

--excercise 13
CREATE TYPE istota AS OBJECT (
	nazwa VARCHAR2(20),
	NOT INSTANTIABLE MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR )
	NOT INSTANTIABLE NOT FINAL;
CREATE TYPE lew UNDER istota (
	liczba_nog NUMBER,
	OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR );
CREATE OR REPLACE TYPE BODY lew AS
	OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR IS
	BEGIN
		RETURN 'upolowana ofiara: '||ofiara;
	END;
END;
DECLARE
	KrolLew lew := lew('LEW',4);
	InnaIstota istota := istota('JAKIES ZWIERZE');
BEGIN
	DBMS_OUTPUT.PUT_LINE( KrolLew.poluj('antylopa') );
END;

--excercise 14
DECLARE
	tamburyn instrument;
	 cymbalki instrument;
	 trabka instrument_dety;
	 saksofon instrument_dety;
BEGIN
	 tamburyn := instrument('tamburyn','brzdek-brzdek');
	 cymbalki := instrument_dety('cymbalki','ding-ding','metalowe');
	 trabka := instrument_dety('trabka','tra-ta-ta','metalowa');
	 -- saksofon := instrument('saksofon','tra-taaaa');
	 -- saksofon := TREAT( instrument('saksofon','tra-taaaa') AS instrument_dety);
END;

--excercise 15
CREATE TABLE instrumenty OF instrument;
INSERT INTO instrumenty VALUES ( instrument('tamburyn','brzdek-brzdek') );
INSERT INTO instrumenty VALUES ( instrument_dety('trabka','tra-ta-ta','metalowa'));
INSERT INTO instrumenty VALUES ( instrument_klawiszowy('fortepian','pingping','steinway') );
SELECT i.nazwa, i.graj() FROM instrumenty i;

--excercise 16
CREATE TABLE PRZEDMIOTY (
	NAZWA VARCHAR2(50),
	NAUCZYCIEL NUMBER REFERENCES PRACOWNICY(ID_PRAC)
);
INSERT INTO PRZEDMIOTY VALUES ('BAZY DANYCH',100);
INSERT INTO PRZEDMIOTY VALUES ('SYSTEMY OPERACYJNE',100);
INSERT INTO PRZEDMIOTY VALUES ('PROGRAMOWANIE',110);
INSERT INTO PRZEDMIOTY VALUES ('SIECI KOMPUTEROWE',110);
INSERT INTO PRZEDMIOTY VALUES ('BADANIA OPERACYJNE',120);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA',120);
INSERT INTO PRZEDMIOTY VALUES ('BAZY DANYCH',130);
INSERT INTO PRZEDMIOTY VALUES ('SYSTEMY OPERACYJNE',140);
INSERT INTO PRZEDMIOTY VALUES ('PROGRAMOWANIE',140);
INSERT INTO PRZEDMIOTY VALUES ('SIECI KOMPUTEROWE',140);
INSERT INTO PRZEDMIOTY VALUES ('BADANIA OPERACYJNE',150);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA',150);
INSERT INTO PRZEDMIOTY VALUES ('BAZY DANYCH',160);
INSERT INTO PRZEDMIOTY VALUES ('SYSTEMY OPERACYJNE',160);
INSERT INTO PRZEDMIOTY VALUES ('PROGRAMOWANIE',170);
INSERT INTO PRZEDMIOTY VALUES ('SIECI KOMPUTEROWE',180);
INSERT INTO PRZEDMIOTY VALUES ('BADANIA OPERACYJNE',180);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA',190);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA',200);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA',210);
INSERT INTO PRZEDMIOTY VALUES ('PROGRAMOWANIE',220);
INSERT INTO PRZEDMIOTY VALUES ('SIECI KOMPUTEROWE',220);
INSERT INTO PRZEDMIOTY VALUES ('BADANIA OPERACYJNE',230);

--excercise 17
CREATE TYPE ZESPOL AS OBJECT (
	ID_ZESP NUMBER,
	NAZWA VARCHAR2(50),
	ADRES VARCHAR2(100)
);

--excercise 18
CREATE OR REPLACE VIEW ZESPOLY_V OF ZESPOL
WITH OBJECT IDENTIFIER(ID_ZESP)
AS SELECT ID_ZESP, NAZWA, ADRES FROM ZESPOLY;

--excercise 19
CREATE TYPE PRZEDMIOTY_TAB AS TABLE OF VARCHAR2(100);
/
CREATE TYPE PRACOWNIK AS OBJECT (
	 ID_PRAC NUMBER,
	 NAZWISKO VARCHAR2(30),
	 ETAT VARCHAR2(20),
	 ZATRUDNIONY DATE,
	 PLACA_POD NUMBER(10,2),
	 MIEJSCE_PRACY REF ZESPOL,
	 PRZEDMIOTY PRZEDMIOTY_TAB,
	 MEMBER FUNCTION ILE_PRZEDMIOTOW RETURN NUMBER
);
/
CREATE OR REPLACE TYPE BODY PRACOWNIK AS
	 MEMBER FUNCTION ILE_PRZEDMIOTOW RETURN NUMBER IS
	 BEGIN
	 RETURN PRZEDMIOTY.COUNT();
	 END ILE_PRZEDMIOTOW;
END;

--excercise 20
CREATE OR REPLACE VIEW PRACOWNICY_V OF PRACOWNIK
	WITH OBJECT IDENTIFIER (ID_PRAC)
	AS SELECT ID_PRAC, NAZWISKO, ETAT, ZATRUDNIONY, PLACA_POD,
	MAKE_REF(ZESPOLY_V,ID_ZESP),
	CAST(MULTISET( SELECT NAZWA FROM PRZEDMIOTY WHERE NAUCZYCIEL=P.ID_PRAC ) AS
	PRZEDMIOTY_TAB )
	FROM PRACOWNICY P;
	
--excercise 21
SELECT *
FROM PRACOWNICY_V;
SELECT P.NAZWISKO, P.ETAT, P.MIEJSCE_PRACY.NAZWA
FROM PRACOWNICY_V P;
SELECT P.NAZWISKO, P.ILE_PRZEDMIOTOW()
FROM PRACOWNICY_V P;
SELECT *
FROM TABLE( SELECT PRZEDMIOTY FROM PRACOWNICY_V WHERE NAZWISKO='WEGLARZ' );
SELECT NAZWISKO, CURSOR( SELECT PRZEDMIOTY
FROM PRACOWNICY_V
WHERE ID_PRAC=P.ID_PRAC)
FROM PRACOWNICY_V P;

--excercise 22 - TODO:
CREATE TABLE PISARZE (
 ID_PISARZA NUMBER PRIMARY KEY,
 NAZWISKO VARCHAR2(20),
 DATA_UR DATE );
CREATE TABLE KSIAZKI (
 ID_KSIAZKI NUMBER PRIMARY KEY,
 ID_PISARZA NUMBER NOT NULL REFERENCES PISARZE,
 TYTUL VARCHAR2(50),
 DATA_WYDANIE DATE );
INSERT INTO PISARZE VALUES(10,'SIENKIEWICZ',DATE '1880-01-01');
INSERT INTO PISARZE VALUES(20,'PRUS',DATE '1890-04-12');
INSERT INTO PISARZE VALUES(30,'ZEROMSKI',DATE '1899-09-11');
INSERT INTO KSIAZKI(ID_KSIAZKI,ID_PISARZA,TYTUL,DATA_WYDANIA VALUES(10,10,'OGNIEM I
MIECZEM',DATE '1990-01-05');
INSERT INTO KSIAZKI(ID_KSIAZKI,ID_PISARZA,TYTUL,DATA_WYDANIA
VALUES(20,10,'POTOP',DATE '1975-12-09');
INSERT INTO KSIAZKI(ID_KSIAZKI,ID_PISARZA,TYTUL,DATA_WYDANIA VALUES(30,10,'PAN
WOLODYJOWSKI',DATE '1987-02-15');
INSERT INTO KSIAZKI(ID_KSIAZKI,ID_PISARZA,TYTUL,DATA_WYDANIA
VALUES(40,20,'FARAON',DATE '1948-01-21');
INSERT INTO KSIAZKI(ID_KSIAZKI,ID_PISARZA,TYTUL,DATA_WYDANIA
VALUES(50,20,'LALKA',DATE '1994-08-01');
INSERT INTO KSIAZKI(ID_KSIAZKI,ID_PISARZA,TYTUL,DATA_WYDANIA
VALUES(60,30,'PRZEDWIOSNIE',DATE '1938-02-02');

--excercise 23 -TODO:
CREATE TYPE AUTO AS OBJECT (
 MARKA VARCHAR2(20),
 MODEL VARCHAR2(20),
 KILOMETRY NUMBER,
 DATA_PRODUKCJI DATE,
 CENA NUMBER(10,2),
 MEMBER FUNCTION WARTOSC RETURN NUMBER
);
CREATE OR REPLACE TYPE BODY AUTO AS
 MEMBER FUNCTION WARTOSC RETURN NUMBER IS
 WIEK NUMBER;
 WARTOSC NUMBER;
 BEGIN
 WIEK := ROUND(MONTHS_BETWEEN(SYSDATE,DATA_PRODUKCJI)/12);
 WARTOSC := CENA - (WIEK * 0.1 * CENA);
 IF (WARTOSC < 0) THEN
 WARTOSC := 0;
 END IF;
 RETURN WARTOSC;
 END WARTOSC;
END;
CREATE TABLE AUTA OF AUTO;
INSERT INTO AUTA VALUES (AUTO('FIAT','BRAVA',60000,DATE '1999-11-30',25000));
INSERT INTO AUTA VALUES (AUTO('FORD','MONDEO',80000,DATE '1997-05-10',45000));
INSERT INTO AUTA VALUES (AUTO('MAZDA','323',12000,DATE '2000-09-22',52000));