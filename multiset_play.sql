declare

type fsl_type is record (oid varchar2(4000), primitive NUMBER);
type fsl_tab is table of fsl_type;

--type fsl_higher is record(oid varchar2(4000), nested_fsl_tab fsl_tab);
--type fsl_higher_Tab is table of fsl_higher;

begin

   execute immediate 'create table test_fsl (oid varchar2(4000), mynested fsl_tab) NESTED TABLE mynested STORE AS mynested_store';
   
   
end;


create or replace type fsl_type5  record (oid varchar2(4000), primitive NUMBER);

create or replace type fsl_tab as table of fsl_type;

create table test_fsl (oid varchar2(4000), mynested fsl_tab) NESTED TABLE mynested STORE AS mynested_store

select * from test_fsl

insert into test_fsl

desc fsl_type

select * from user_objects
where object_name LIKE 'FSL%'

drop table test_fsl

--------------------------------
declare

psql varchar2(4000);
kount pls_integer;
p_topo   varchar2(32) := 'Z601IN';
p_topo2  varchar2(32) := 'Z602IN';

begin

   psql := 'SELECT count(*) FROM '
        || 'user_objects a '
        || 'WHERE '
        || 'a.object_name = :p1 AND '
        || 'a.object_type = :p2 ';
   EXECUTE IMMEDIATE psql INTO kount USING 'OUTPUT_PRIMITIVE', 
                                           'TYPE'; 
   
   IF kount = 0
   THEN
      
      EXECUTE IMMEDIATE 'CREATE OR REPLACE TYPE output_primitive AS OBJECT (oid varchar2(4000))';
   
   END IF;
   
   EXECUTE IMMEDIATE psql INTO kount uSING 'OUTPUT_SET',
                                           'TYPE';
                                           
                                      
   IF kount = 0
   THEN
      
      EXECUTE IMMEDIATE 'CREATE OR REPLACE TYPE output_set AS TABLE OF output_primitive';
   
   END IF;
   
   psql := 'CREATE TABLE ' || p_topo || '_OUTPUT_SPLITS (base VARCHAR2(4000), superior VARCHAR2(4000), primitives output_set) '
        || 'NESTED TABLE primitives STORE AS ' || p_topo || '_primitives_store ';
        
   begin
      EXECUTE IMMEDIATE psql;
   exception 
   when others then
      execute immediate 'drop table ' || p_topo || '_output_splits ';
      execute immediate psql;
   end;
   
   --is the index necessary?
   --CREATE INDEX z601in_primitives_idx ON z601in_primitives_store(oid);
   
   
   psql := 'CREATE TABLE ' || p_topo2 || '_OUTPUT_SPLITS (base VARCHAR2(4000), superior VARCHAR2(4000), primitives output_set) '
        || 'NESTED TABLE primitives STORE AS ' || p_topo2 || '_primitives_store ';
        
   
   begin
      EXECUTE IMMEDIATE psql;
   exception 
   when others then
      execute immediate 'drop table ' || p_topo2 || '_output_splits ';
      execute immediate psql;
   end;

   
   
   
END;
----------------------------------


http://www.oracle.com/pls/db112/to_URL?remark=ranked&urlname=http:%2F%2Fdownload.oracle.com%2Fdocs%2Fcd%2FE11882_01%2Fappdev.112%2Fe11822%2Fadobjcol.htm%23ADOBJ7298

select * from z601in_output_splits

select * from z602in_output_splits

select * from z601in_primitive_store

--works
select aa.incplace, 
CAST(MULTISET(SELECT b.face_id FROM Z009I2_face b WHERE b.incplace = aa.incplace) AS output_set)
FROM (
select distinct a.incplace from Z009I2_face a
where a.incplace IS NOT NULL
) aa


--No.  Expects an entire column
SELECT a.incplace, CAST(COLLECT(a.face_id) AS output_set) setty
from Z009I2_face a
where a.incplace is not null

--still no?
SELECT CAST(COLLECT(face_id) AS output_set) setty
from Z009I2_face a
where a.incplace is not null


--works
select CAST(MULTISET(SELECT face_id from Z009I2_face) AS output_set) from dual


--works
insert into z601in_output_splits
(base, primitives) 
select aa.incplace, 
CAST(MULTISET(SELECT b.face_id FROM Z009I2_face b WHERE b.incplace = aa.incplace) AS output_set)
FROM (
select distinct a.incplace from Z009I2_face a
where a.incplace IS NOT NULL
) aa




select a.base, a.primitives MULTISET INTERSECT b.primitives
from z601in_output_splits a,
z601in_output_splits b
where a.base = 27890338937956 and
b.base = 27890331922597


select a.base, a.primitives MULTISET UNION b.primitives
from z601in_output_splits a,
z601in_output_splits b
where a.base = 27890338937956 and
b.base = 27890331922597


select a.base, a.primitives MULTISET EXCEPT b.primitives
from z601in_output_splits a,
z601in_output_splits b
where a.base = 27890338937956 and
b.base = 27890331922597


--count of elements
select base,  primitives, cardinality(primitives) from z601in_output_splits
where base = 27890338937956


--no.  How to get out?
select CAST(UNNEST(primitives) AS NUMBER) from z601in_output_splits
where base = 27890338937956

--http://docs.oracle.com/cd/B19306_01/appdev.102/b14260/adobjcol.htm

--UNNEST remember the order matters
SELECT b.* 
  FROM z601in_output_splits a, 
  TABLE(a.primitives) b
where a.base = 27890338937956

--works if subquery return just one result
SELECT *
  FROM TABLE(SELECT d.primitives 
               FROM z601in_output_splits d
               WHERE d.base = 27890338937956);



-----06/05/12

drop type output_prim_set

drop type output_prim_obj

desc  output_prim_set



CREATE OR REPLACE TYPE output_prim_obj AS OBJECT (face_id NUMBER);

--CREATE OR REPLACE TYPE output_primitive AS OBJECT (oid varchar2(4000))
--ORA-02303: cannot drop or replace a type with type or table dependents

CREATE OR REPLACE TYPE output_prim_set AS TABLE OF output_prim_obj


select * from z609in_output_tracking
order by end_time desc

ORA-00904: "V"."SPLIT_PRIMITIVES": invalid identifier
ORA-06512: at "SCHEL010.GZ_OUTPUT", line 4052
ORA-06512: at "SCHEL010.GZ_OUTPUT", line 5077
ORA-06512: at "SCHEL010.GZ_OUTPUT", line 6912


ORA-20001: ORA-06512: at "SCHEL010.GZ_OUTPUT", line 3004

/* Formatted on 6/5/2012 12:06:00 PM (QP5 v5.163.1008.3004) */

select * from 
Z609IN_FSL050V

drop table Z609IN_FSL050V

CREATE TABLE Z609IN_FSL050V
(
   oid_base           VARCHAR2 (4000),
   oid_superior       VARCHAR2 (4000),
   source_base        VARCHAR2 (64),
   source_superior    VARCHAR2 (64),
   key_base           VARCHAR2 (32),
   split_primitives   OUTPUT_PRIM_SET,
   GEO_ID             VARCHAR2 (60),
   STATE              VARCHAR2 (2),
   COUNTY             VARCHAR2 (3),
   NAME               VARCHAR2 (90),
   LSAD               VARCHAR2 (7),
   SDOGEOMETRY        SDO_GEOMETRY,
   TOPOGEOM           SDO_TOPO_GEOMETRY
) NESTED TABLE split_primitives STORE AS Z609IN_FSL050V_store



CREATE TABLE Z609IN_FSL099V
(
   oid_base           VARCHAR2 (4000),
   oid_superior       VARCHAR2 (4000),
   source_base        VARCHAR2 (64),
   source_superior    VARCHAR2 (64),
   key_base           VARCHAR2 (32),
   split_primitives   OUTPUT_PRIM_SET,
   GEO_ID             VARCHAR2 (60),
   STATE              VARCHAR2 (2),
   COUNTY             VARCHAR2 (3),
   NAME               VARCHAR2 (90),
   LSAD               VARCHAR2 (7),
   SDOGEOMETRY        SDO_GEOMETRY,
   TOPOGEOM           SDO_TOPO_GEOMETRY
) NESTED TABLE split_primitives STORE AS z609in_primitives_store

ORA-06512: at "SCHEL010.GZ_OUTPUT", line 3031
ORA-06512: at "SCHEL010.GZ_OUTPUT", line 3153
ORA-06512: at "SCHEL010.GZ_OUTPUT", line 3248
ORA-06512: at "SCHEL010.GZ_OUTPUT", line 6583



select * from user_sdo_topo_info
where topology = 'Z609IN'

ORA-20001: ORA-06512: at "SCHEL010.GZ_OUTPUT", line 3004
ORA-06512: at "SCHEL010.GZ_OUTPUT", line 3031
ORA-06512: at "SCHEL010.GZ_OUTPUT", line 3153
ORA-06512: at "SCHEL010.GZ_OUTPUT", line 3248
ORA-06512: at "SCHEL010.GZ_OUTPUT", line 6583


EXECUTE SDO_TOPO.DELETE_TOPO_GEOMETRY_LAYER('Z609IN', 'Z609IN_FSL155V', 'TOPOGEOM');

--------------------------------------------
select * from gzcpb1.sdt98in_build_tracking
order by end_time desc
--------------------------------------------


ERROR:
0|From tile 171 we have 1 NULL or wrong gtype sdogeometries |From tile 846 we have 1 NULL or wrong gtype sdogeometries |From tile 989 we have 1 NULL or wrong gtype sdogeometries |From tile 1148 we have 1 NULL or wrong gtype sdogeometries |From tile 1238 we have 1 NULL or wrong gtype sdogeometries |From tile 1963 we have 1 NULL or wrong gtype sdogeometries | We have some invalid face sdogeometries 







select * from gz_layers_out
where release = 'A12'
and gen_project_id = 'Z6'

select * from gz_layers_subset
where release = 'A12'
and gen_project_id = 'Z6'

select * from gz_layers_hierarchical
where release = 'A12'
and gen_project_id = 'Z6'

select * from gz_layers_aggregate
where release = 'A12'

select * from gz_layers_split
where release = 'A12'

select * from gz_layers_fields

select * from gz_layers_geoid

------------------------------------
declare
retval varchar2(4000);
begin
retval := GZ_OUTPUT.GENERALIZATION_OUTPUT('A12','Z6','TAB10ST09','MT','Z609IN','YYYYYYYYYY','N',NULL,10,8265,.05,'N');
end;
-------------------------------------

select * from z609in_output_tracking
order by end_time desc

select * from Z609IN_FSL155V

select * from Z609IN_FSL160V

select a.topogeom.get_geometry() from Z609IN_FSL160V a

select * from Z609IN_FSL050V


desc Z609IN_FSL040V_sto


select * from z609in_fsl160v

select * from z609in_fsl155v

SELECT a.oid_base, a.source_base, a.key_base
from z609in_fsl155v a

select a.oid_base, t.topo_id from 
z609in_fsl160v a,
TABLE(a.topogeom.get_topo_elements()) t

select CAST(MULTISET(SELECT face_id from Z009I2_face) AS output_set) from dual

select aa.incplace, 
CAST(MULTISET(SELECT b.face_id FROM Z009I2_face b WHERE b.incplace = aa.incplace) AS output_set)
FROM (
select distinct a.incplace from Z009I2_face a
where a.incplace IS NOT NULL
) aa

--Si
select a.oid_base, 
CAST(MULTISET(SELECT b.face_id FROM Z609IN_face b WHERE b.face_id = t.topo_id) AS OUTPUT_PRIM_SET) from 
z609in_fsl160v a,
TABLE(a.topogeom.get_topo_elements()) t



--si si
select  a.oid_base,
CAST(MULTISET(SELECT t.topo_id FROM dual) AS OUTPUT_PRIM_SET) from 
z609in_fsl160v a,
TABLE(a.topogeom.get_topo_elements()) t



select * from z609in_fsl155v

update z609in_fsl155v aa
set aa.split_primitives = (
select 
CAST(MULTISET(SELECT t.topo_id FROM dual) AS OUTPUT_PRIM_SET) from 
z609in_fsl160v a,
TABLE(a.topogeom.get_topo_elements()) t
where aa.oid_base = a.oid_base
)

update z609in_fsl155v aa
set aa.source_superior = (
select 
a.oid_base from 
z609in_fsl160v a
where aa.oid_base = a.oid_base
)


delete from Z609IN_FSL155V

--142

/* Formatted on 6/5/2012 3:13:47 PM (QP5 v5.163.1008.3004) */
INSERT                                                           /*+ APPEND */
      INTO                Z609IN_FSL155V (oid_base, source_base, key_base)
   SELECT f.oid_base, f.source_base, f.key_base
     FROM Z609IN_FSL160V f



INSERT                                                           /*+ APPEND */
      INTO                Z609IN_FSL155V (oid_base, source_base, key_base, split_primitives)
   SELECT f.oid_base, f.source_base, f.key_base,
          CAST(MULTISET(SELECT t.topo_id FROM dual) AS OUTPUT_PRIM_SET)
     FROM Z609IN_FSL160V f,
         TABLE(f.topogeom.get_topo_elements()) t
         
         
         
         select * from Z609IN_FSL155V where oid_base
         not in (SELECT f.oid_base
     FROM Z609IN_FSL160V f)
     
     28090334230863
28090334230863


select  a.oid_base,
CAST(MULTISET(SELECT t.topo_id FROM dual) AS OUTPUT_PRIM_SET) from 
z609in_fsl160v a,
TABLE(a.topogeom.get_topo_elements()) t
where a.oid_base = 28090334230863



select a.oid_base, 
CAST(MULTISET(SELECT b.face_id FROM Z609in_face b WHERE b.face_id = t.topo_id) AS OUTPUT_PRIM_SET)
from 
z609in_fsl160v a,
TABLE(a.topogeom.get_topo_elements()) t
where a.oid_base = 28090334230863


select * from z609in_fsl160v
where oid_base = 28090334230863


--good no dupes
/* Formatted on 6/5/2012 3:37:29 PM (QP5 v5.163.1008.3004) */
SELECT CAST (
          MULTISET (SELECT sub.topo_id
                      FROM (SELECT a.oid_base, t.topo_id
                              FROM z609in_fsl160v a,
                                   TABLE (a.topogeom.get_topo_elements ()) t
                             WHERE a.oid_base = 28090334230863) sub) AS OUTPUT_PRIM_SET)
  FROM DUAL

select * from z609in_fsl155v

update z609in_fsl155v aa set aa.split_primitives = (
select CAST(MULTISET(SELECT sub.topo_id FROM 
(select a.oid_base, t.topo_id from 
z609in_fsl160v a,
TABLE(a.topogeom.get_topo_elements()) t
where a.oid_base = aa.oid_base
) sub
) AS OUTPUT_PRIM_SET) from dual
)


update z609in_fsl155v v
set v.split_primitives = 
(SELECT CAST (
          MULTISET (SELECT sub.topo_id
                      FROM (SELECT a.oid_base, t.topo_id
                              FROM z609in_fsl160v a,
                                   TABLE (a.topogeom.get_topo_elements ()) t
                             WHERE a.oid_base = 28090334230863) sub) AS OUTPUT_PRIM_SET)
  FROM DUAL)
where v.oid_base = 28090334230863

delete from z609in_fsl155v

select * from z609in_fsl155v v
where v.oid_base = 28090334230863

select * from z609in_fsl155v v
where v.oid_base = 27890338937959

select * from z609in_face
where incplace = 27890338937959

SELECT f.face_id
                              FROM z609in_face f
                              WHERE f.incplace = 27890338937959

/* Formatted on 6/13/2012 4:11:43 PM (QP5 v5.163.1008.3004) */
UPDATE z609in_fsl155v v
   SET v.split_primitives =
          (SELECT CAST (
                     MULTISET (SELECT f.face_id
                                 FROM z609in_face f
                                WHERE f.incplace = 27890338937959) AS OUTPUT_PRIM_SET)
             FROM DUAL)
 WHERE v.oid_base = 27890338937959



select count(*) from bas12.sduni a
where a.vintage = '90'


select * from z609in_fsl155v v
where v.oid_base = 28090334230863

select * from TAB10ST09.CDP a
where a.oid = 28090334230863

select a.topogeom.get_geometry() from Z609IN_FSL160V a
where a.oid_base = '28090334230863'

select * from gz_layers_out
where release = 'A12'
and gen_project_id = 'Z6'



select * from gz_layers_split
where release = 'A12'

select gz_output.GET_DEEP_SOURCE ('A12','Z6','Z609IN','050','TABLE') from dual
--COUNTY
select gz_output.GET_DEEP_SOURCE ('A12','Z6','Z609IN','050','KEY') from dual
--oid

--base INCPLACE
select * from Z609IN_FSL160V

--superior COUNTY
select * from Z609IN_FSL050V

select * from Z609IN_FSL155V



select a.topogeom.get_geometry() from Z609IN_FSL160V a
where a.oid_base = '28090334230863'

select oid_superior from Z609IN_FSL155V

select a.oid from
TAB10ST09.COUNTY a,
Z609IN_FSL050V b
where SDO_RELATE(a.sdogeometry, (select a.topogeom.get_geometry() from Z609IN_FSL160V a
where a.oid_base = '28090334230863'), 'mask=INSIDE+COVEREDBY+CONTAINS+COVERS+OVERLAPBDYINTERSECT+EQUAL+OVERLAPBDYDISJOINT') = 'TRUE'
and b.oid_base = a.oid
--and b.oid_base NOT IN (select oid_superior from Z609IN_FSL155V WHERE oid_superior IS NOT NULL)
--27590334171251

select * from 
Z609IN_FSL160V b

AND a.oid = b.oid_base


Z609IN_FSL050V

select * from Z609IN_FSL155V



select a.topogeom.get_topo_elements() from Z609IN_FSL050V a
where a.oid_base = 27590334171251


  
  (SELECT CAST (
          MULTISET(SELECT  t.topo_id
                              FROM Z609IN_FSL050V a,
                                   TABLE (a.topogeom.get_topo_elements ()) t
                             WHERE a.oid_base = 27590334171251) AS OUTPUT_PRIM_SET)
  FROM DUAL)

/* Formatted on 6/14/2012 12:02:02 PM (QP5 v5.163.1008.3004) */
INSERT INTO Z609IN_FSL155V (oid_superior, source_superior, split_primitives)
     VALUES (
               27590334171251,
               'TAB10ST09.COUNTY',
               (SELECT CAST (
                          MULTISET (
                             SELECT t.topo_id
                               FROM Z609IN_FSL050V a,
                                    TABLE (a.topogeom.get_topo_elements ()) t
                              WHERE a.oid_base = 27590334171251) AS OUTPUT_PRIM_SET)
                  FROM DUAL))                  


INSERT INTO Z609IN_FSL155V (oid_superior, source_superior, split_primitives)
     VALUES ( SELECT
               CAST(27590334171251 AS NUMBER),
               CAST('TAB10ST09.COUNTY' AS VARCHAR2(64)),
               (SELECT CAST (
                          MULTISET (
                             SELECT t.topo_id
                               FROM Z609IN_FSL050V a,
                                    TABLE (a.topogeom.get_topo_elements ()) t
                              WHERE a.oid_base = 27590334171251) AS OUTPUT_PRIM_SET)
                  FROM DUAL) FROM Z609IN_FSL155V WHERE oid_superior <> 27590334171251
              )       
              
              SELECt * FROM Z609IN_FSL155V WHERE oid_superior = 27590334171251

     

select * from Z609IN_FSL155V

select * from z609in_fsl155v v
where v.oid_base = 28090334230863
or v.oid_superior = 27590334171251



select a.oid_base, a.split_primitives MULTISET INTERSECT b.split_primitives
from z609in_fsl155v a,
z609in_fsl155v b
where  a.oid_base = 28090334230863
and b.oid_superior = 27590334171251

select split_primitives from z609in_fsl155v where oid_base = 28090334230863

select split_primitives from z609in_fsl155v where oid_superior = 27590334171251

(select (select split_primitives from z609in_fsl155v where oid_base = 28090334230863) 
MULTISET INTERSECT
(select split_primitives from z609in_fsl155v where oid_superior = 27590334171251) from dual)
 
/* Formatted on 6/14/2012 12:42:12 PM (QP5 v5.163.1008.3004) */
INSERT INTO z609in_fsl155v (oid_base,
                            oid_superior,
                            source_base,
                            source_superior,
                            key_base,
                            split_primitives)
     VALUES (
               28090334230863,
               27590334171251,
               'TAB10ST09.CDP',
               'TAB10ST09.COUNTY',
               'oid',
               (SELECT (SELECT split_primitives
                          FROM z609in_fsl155v
                         WHERE oid_base = 28090334230863)
                          MULTISET INTERSECT (SELECT split_primitives
                                                FROM z609in_fsl155v
                                               WHERE oid_superior =
                                                        27590334171251)
                  FROM DUAL))
                  
select * from z609in_fsl155v v
where v.oid_base = 28090334230863
or v.oid_superior = 27590334171251

/*
update z609in_fsl155v set split_primitives = (
select split_primitives from z609in_fsl155v
where oid_base = 28090334230863 and oid_superior = 27590334171251
) where oid_base = 28090334230863 and oid_superior is null
*/




 
 --delete from looped superior using seed base
 UPDATE z609in_fsl155v v
   SET v.split_primitives =
          (SELECT (SELECT split_primitives
                     FROM z609in_fsl155v
                    WHERE oid_superior = 27590334171251 AND oid_base IS NULL)
                     MULTISET EXCEPT (SELECT split_primitives
                                        FROM z609in_fsl155v
                                       WHERE oid_base = 28090334230863
                                             AND oid_superior = 27590334171251)
             FROM DUAL)
 WHERE v.oid_superior = 27590334171251 AND v.oid_base IS NULL
 
 
 --delete from seed base using what weve added to the split record
 UPDATE z609in_fsl155v v
   SET v.split_primitives =
          (SELECT (SELECT split_primitives
                     FROM z609in_fsl155v
                    WHERE oid_base = 28090334230863 AND oid_superior IS NULL)
                     MULTISET EXCEPT (SELECT split_primitives
                                        FROM z609in_fsl155v
                                       WHERE oid_superior = 27590334171251
                                             AND oid_base = 28090334230863)
             FROM DUAL)
 WHERE v.oid_base = 28090334230863 AND v.oid_superior IS NULL

select cardinality(split_primitives), v.* from z609in_fsl155v v
where v.oid_base = 28090334230863
or v.oid_superior = 27590334171251

SELECT CARDINALITY(v.split_primitives) from z609in_fsl155v v
where v.oid_base = 28090334230863
and v.oid_superior IS NULL


delete from z609in_fsl155v v
where v.oid_base = 28090334230863
and v.oid_superior IS NULL


DELETE from z609in_fsl155v v
where v.oid_superior = 27590334171251
and v.oid_base IS NULL
and CARDINALITY(v.split_primitives) = 0


DELETE FROM z609in_fsl155v v
WHERE oid_superior IS NOT NULL
AND oid_base IS NULL












