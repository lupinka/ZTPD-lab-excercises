--execercise 1a
CREATE TABLE FIGURY (
    ID number(1),
    KSZTALT MDSYS.SDO_GEOMETRY
);

--execercise 1b
--circle
INSERT INTO FIGURY VALUES(
  1,
  SDO_GEOMETRY(
    2003,
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY(1,1003,4),
    SDO_ORDINATE_ARRAY(3,5, 5,3, 7,5)
  )
);

--sqare
INSERT INTO FIGURY VALUES(
  2,
  SDO_GEOMETRY(
    2003,  -- two-dimensional polygon
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY(1,1003,3), -- one rectangle (1003 = exterior)
    SDO_ORDINATE_ARRAY(1,1, 5,5) -- only 2 points needed to
          -- define rectangle (lower left and upper right) with
          -- Cartesian-coordinate data
  )
);

--line
INSERT INTO FIGURY VALUES(
  3,
  SDO_GEOMETRY(
    2002,
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY(1,4,2, 1,2,1, 5,2,2), -- compound line string
    SDO_ORDINATE_ARRAY(3,2, 6,2, 7,3, 8,2, 7,1)
  )
);

--excercise 1c

--wrong sqare
INSERT INTO FIGURY VALUES(
  4,
  SDO_GEOMETRY(
    2003,  -- two-dimensional polygon
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY(1,1003,3), -- one rectangle (1003 = exterior)
    SDO_ORDINATE_ARRAY(1,1) -- only 2 points needed to
          -- define rectangle (lower left and upper right) with
          -- Cartesian-coordinate data
  )
);

SELECT f.id, SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(f.KSZTALT, 0.005) FROM FIGURY f;