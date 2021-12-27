-- 1.a
SELECT * FROM USER_SDO_GEOM_METADATA;

INSERT INTO USER_SDO_GEOM_METADATA
VALUES (
    'FIGURY',
    'KSZTALT',
    MDSYS.SDO_DIM_ARRAY(
        MDSYS.SDO_DIM_ELEMENT('X', 0, 9, 0.01),
        MDSYS.SDO_DIM_ELEMENT('Y', 0, 9, 0.01)
        ),
    null);
    
-- 1.b
SELECT SDO_TUNE.ESTIMATE_RTREE_INDEX_SIZE(3000000,8192,10,2,0) FROM DUAL;

-- 1.c
create index FIGURY_IDX on FIGURY(KSZTALT) INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2;
-- 1.d
select ID from FIGURY where SDO_FILTER(KSZTALT,SDO_GEOMETRY(2001,null,SDO_POINT_TYPE(3,3,null),null,null)) = 'TRUE';
-- 1.e
select ID from FIGURY where SDO_RELATE(KSZTALT,SDO_GEOMETRY(2001,null,SDO_POINT_TYPE(3,3,null),null,null),'mask=ANYINTERACT') = 'TRUE';

-- 2.a
select A.CITY_NAME as MIASTO, SDO_NN_DISTANCE(1) as ODL
from MAJOR_CITIES A,
     MAJOR_CITIES B
where SDO_NN(
              A.GEOM, B.GEOM,
              'sdo_num_res=10 unit=km', 1) = 'TRUE'
  and B.CITY_NAME = 'Warsaw'
  and A.CITY_NAME <> 'Warsaw';

-- 2.b
select A.CITY_NAME as MIASTO
from MAJOR_CITIES A,
     MAJOR_CITIES B
where SDO_WITHIN_DISTANCE(
              A.GEOM, B.GEOM, 'distance=100 unit=km') = 'TRUE'
  and B.CITY_NAME = 'Warsaw'
  and A.CITY_NAME <> 'Warsaw';
 
-- 2.c
select distinct B.CNTRY_NAME, R.name
from   COUNTRY_BOUNDARIES B, RIVERS R where  B.CNTRY_NAME = 'Slovakia';

-- 2.d
select A.CNTRY_NAME as PANSTWO,
       SDO_GEOM.SDO_DISTANCE(A.GEOM, B.GEOM, 1, 'unit=km') as ODL
from COUNTRY_BOUNDARIES A,
     COUNTRY_BOUNDARIES B
where SDO_RELATE(A.GEOM, B.GEOM, 'mask=ANYINTERACT') <> 'TRUE'
  and B.CNTRY_NAME = 'Poland';