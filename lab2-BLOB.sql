CREATE TABLE MOVIES (
    ID NUMBER(12) PRIMARY KEY,
    TITLE VARCHAR2(400) NOT NULL,
    CATEGORY VARCHAR2(50),
    YEAR CHAR(4),
    CAST VARCHAR2(4000),
    DIRECTOR VARCHAR2(4000),
    STORY VARCHAR2(4000),
    PRICE NUMBER(5,2),
    COVER BLOB,
    MIME_TYPE VARCHAR2(50)
);

SELECT * FROM COVERS;
SELECT * FROM DESCRIPTIONS;

INSERT INTO MOVIES (ID, TITLE, CATEGORY, YEAR, CAST, DIRECTOR, STORY, PRICE, COVER, MIME_TYPE)
SELECT
d.ID ID,
d.TITLE TITLE,
d.CATEGORY CATEGORY,
TRIM(d.YEAR) YEAR,
d.CAST CAST,
d.DIRECTOR DIRECTOR,
d.STORY STORY,
d.PRICE PRICE,
c.IMAGE IMAGE,
c.MIME_TYPE MIME_TYPE FROM DESCRIPTIONS d LEFT OUTER JOIN COVERS c ON c.MOVIE_ID = d.ID
;

SELECT * FROM MOVIES;

SELECT ID, TITLE FROM MOVIES WHERE COVER is NULL;

SELECT ID, TITLE, length(COVER) FROM MOVIES WHERE COVER IS NOT NULL;

SELECT ID, TITLE, length(COVER) FROM MOVIES WHERE COVER is NULL;

--excercise 6
SELECT * FROM all_directories;
--excercise 7
UPDATE movies SET COVER = EMPTY_BLOB() WHERE id = 66;
COMMIT;

--excercise 8
SELECT ID, TITLE, length(COVER) FROM MOVIES WHERE ID = 66 OR ID = 65;

--excercise 9
DECLARE
    lobd blob;
    fils BFILE:=BFILENAME('ZSBD_DIR','escape.jpg');
BEGIN
 SELECT cover INTO lobd FROM movies where id = 66
 FOR UPDATE;
 DBMS_LOB.fileopen(fils, DBMS_LOB.file_readonly);
 DBMS_LOB.LOADFROMFILE(lobd, fils, DBMS_LOB.GETLENGTH(fils));
 DBMS_LOB.FILECLOSE(fils);
 COMMIT;
END;
--excercise 10
CREATE TABLE TEMP_COVERS(
    movie_id NUMBER(12),
    image BFILE,
    mime_type VARCHAR2(50)
)


INSERT INTO TEMP_COVERS SELECT (65, BFILENAME('ZSBD_DIR','eagles.jpg'), 'image/jpeg')