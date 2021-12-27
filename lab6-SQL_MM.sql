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