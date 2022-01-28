--zad1
--a
select lpad('-',2*(level-1),'|-') || t.owner||'.'||t.type_name||'
(FINAL:'||t.final||', INSTANTIABLE:'||t.instantiable||', ATTRIBUTES:'||t.attributes||', METHODS:'||t.methods||')'
from   all_types t
start with t.type_name = 'ST_GEOMETRY'
connect by prior t.type_name = t.supertype_name
and prior t.owner = t.owner;

--b
select distinct m.method_name
from   all_type_methods m
where  m.type_name like 'ST_POLYGON'
and    m.owner = 'MDSYS' order by 1;

--c
create table MYST_MAJOR_CITIES (
    FIPS_CNTRY VARCHAR2(2),
    CITY_NAME VARCHAR2(40),
    STGEOM ST_POINT
);

--d
insert into MYST_MAJOR_CITIES (FIPS_CNTRY, CITY_NAME, STGEOM)
    SELECT FIPS_CNTRY, CITY_NAME, TREAT(ST_POINT.FROM_SDO_GEOM(GEOM) AS ST_POINT) STGEOM
        from MAJOR_CITIES;

--zad2
--a
insert into MYST_MAJOR_CITIES (FIPS_CNTRY, CITY_NAME, STGEOM)
    values(
    'PL',
    'Szczyrk',
    treat(ST_Point.From_WKT('POINT(-71.064544 42.28787)') as ST_Point));

--b
SELECT r.NAME, r.GEOM.GET_WKT() as WKT FROM RIVERS r;

--c
SELECT SDO_UTIL.TO_GMLGEOMETRY(ST_POINT.get_SDO_Geom(m.STGEOM)) FROM MYST_MAJOR_CITIES m where m.city_name = 'Szczyrk';

--zad3
--a
create table MYST_COUNTRY_BOUNDARIES  (
    FIPS_CNTRY VARCHAR2(2),
    CNTRY_NAME VARCHAR2(40),
    STGEOM ST_MULTIPOLYGON
);

--b
insert into MYST_COUNTRY_BOUNDARIES (FIPS_CNTRY, CNTRY_NAME, STGEOM)
    SELECT FIPS_CNTRY, CNTRY_NAME, ST_MULTIPOLYGON(GEOM) STGEOM
        from COUNTRY_BOUNDARIES;

--c
select B.STGEOM.ST_GEOMETRYTYPE() as TYP_OBIEKTU,
       COUNT(B.CNTRY_NAME)        as ILE
from MYST_COUNTRY_BOUNDARIES B
group by B.STGEOM.ST_GEOMETRYTYPE();

--d
select B.STGEOM.ST_ISSIMPLE()
from MYST_COUNTRY_BOUNDARIES B;
-- zad 4
-- a
delete from MYST_MAJOR_CITIES where CITY_NAME = 'Szczyrk';
select B.CNTRY_NAME,
       COUNT(*)
from MYST_COUNTRY_BOUNDARIES B,
     MYST_MAJOR_CITIES C
where C.STGEOM.ST_WITHIN(B.STGEOM) = 1
group by B.CNTRY_NAME;

-- b
select B1.CNTRY_NAME A_NAME,
       B2.CNTRY_NAME B_NAME
from MYST_COUNTRY_BOUNDARIES B1,
     MYST_COUNTRY_BOUNDARIES B2
where B1.STGEOM.ST_TOUCHES(B2.STGEOM) = 1
  and B2.CNTRY_NAME = 'Czech Republic';

-- c
select DISTINCT B.CNTRY_NAME,
                R.NAME
from MYST_COUNTRY_BOUNDARIES B,
     RIVERS R
where ST_LINESTRING(R.GEOM).ST_INTERSECTS(B.STGEOM) = 1
  and B.CNTRY_NAME = 'Czech Republic';

-- d
select TREAT(B1.STGEOM.ST_UNION(B2.STGEOM) as ST_POLYGON).ST_Area() POWIERZCHNIA
from MYST_COUNTRY_BOUNDARIES B1,
     MYST_COUNTRY_BOUNDARIES B2
where B1.CNTRY_NAME = 'Czech Republic'
  and B2.CNTRY_NAME = 'Slovakia';

-- e
select B.STGEOM.ST_DIFFERENCE(ST_GEOMETRY(W.GEOM)).ST_GEOMETRYTYPE() as WEGRY_BEZ
from MYST_COUNTRY_BOUNDARIES B,
     WATER_BODIES W
where B.CNTRY_NAME = 'Hungary'
  and W.name = 'Balaton';

-- Zad 5 
-- a
select COUNT(*)
from MYST_COUNTRY_BOUNDARIES B,
     MYST_MAJOR_CITIES C
where SDO_WITHIN_DISTANCE(B.STGEOM, C.STGEOM, 'distance=100 unit=km') = 'TRUE'
  and B.CNTRY_NAME = 'Poland'
group by B.CNTRY_NAME;

-- b
insert into USER_SDO_GEOM_METADATA
values ('MYST_COUNTRY_BOUNDARIES',
        'STGEOM',
        MDSYS.SDO_DIM_ARRAY(
                MDSYS.SDO_DIM_ELEMENT('X', 19.036107, 21.001011, 0.01),
                MDSYS.SDO_DIM_ELEMENT('Y', 50.28437, 52.079731, 0.01)
            ),
        8307);

-- c
create index MYST_COUNTRY_BOUNDARIES_IDX
    ON MYST_COUNTRY_BOUNDARIES (STGEOM) indextype
    IS MDSYS.SPATIAL_INDEX;

-- d

EXPLAIN PLAN FOR
select B.CNTRY_NAME A_NAME,
       count(*)
from MYST_COUNTRY_BOUNDARIES B,
     MYST_MAJOR_CITIES C
where SDO_WITHIN_DISTANCE(C.STGEOM, B.STGEOM, 'distance=100 unit=km') = 'TRUE'
  and B.CNTRY_NAME = 'Poland'
group by B.CNTRY_NAME;


SELECT plan_table_output
FROM table(dbms_xplan.display('plan_table', null, 'basic'));