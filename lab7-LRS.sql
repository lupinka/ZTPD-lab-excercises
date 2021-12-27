--a
create table A6_LRS (
    GEOM SDO_GEOMETRY
);

--b
insert into A6_LRS
select GEOM
from streets_and_railroads
where sdo_within_distance(
    geom,
    (select geom from major_cities where city_name like 'Koszalin' and rownum=1),
    'distance = 10 unit=km') = 'TRUE';
    
select s.GEOM.GET_WKT() as WKT from A6_LRS s;

--c
select SDO_GEOM.SDO_LENGTH(A.GEOM, 1, 'unit=km') DISTANCE, ST_LINESTRING(A.GEOM) .ST_NUMPOINTS() ST_NUMPOINTS
from  A6_LRS A

--d
update A6_LRS
set GEOM = SDO_LRS.CONVERT_TO_LRS_GEOM(GEOM, 0, 276.681);

--e
INSERT INTO USER_SDO_GEOM_METADATA
VALUES (
    'A6_LRS',
    'GEOM',
    MDSYS.SDO_DIM_ARRAY(
        MDSYS.SDO_DIM_ELEMENT('X', 18.5, 54.51667, 1),
        MDSYS.SDO_DIM_ELEMENT('Y', 14.87555, 53.60957, 1),
        MDSYS.SDO_DIM_ELEMENT('Y', 0, 300, 1) ),
    8307
);

--f
CREATE INDEX street_idx
ON A6_LRS(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX;

--a
select SDO_LRS.VALID_MEASURE(GEOM, 1000) VALID_1000
from A6_LRS;

--b
select SDO_LRS.GEOM_SEGMENT_END_PT(GEOM) END_PT
from A6_LRS;