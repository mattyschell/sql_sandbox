DECLARE

   psql        varchar2(4000);
   type        starray is table of varchar2(4000) index by pls_integer;
   topos       starray;
   statechunks pls_integer;
   islandkount pls_integer;
   bunkedges   starray;

BEGIN

   --get 220 recent topologies, GZACS12.ZxxxLS, ex GZACS12.Z601LS
   psql := 'select distinct topology from all_sdo_topo_info '
        || 'where owner = :p1 '
        || 'AND topology LIKE :p2 '
        || 'order by 1 ';
       
   execute immediate psql bulk collect into topos USING 'GZACS12', '%LS';
   
   FOR i IN 1 .. topos.COUNT
   LOOP
   
      --count the number of external rings for the state sdogeometry
      psql := 'select SDO_UTIL.GETNUMELEM(a.sdogeometry) '
           || 'from gzacs12.' || topos(i) || '_fsl040v a';

      execute immediate psql into statechunks;
      
      --count the number of edge ids listed on the -1 face
      psql := 'select count(1) from ('
           || 'select t.* from gzacs12.' || topos(i) || '_face$ a,'
           || 'table(a.island_edge_id_list) t '
           || 'where a.face_id = -1) ';
           
      execute immediate psql into islandkount;
      
      IF islandkount <> statechunks
      THEN
      
         dbms_output.put_line(topos(i) || ': Island kount not equal to state chunk kount');
      
      END IF;
      
      --check that all the -1 face edge_ids are also edge$
      psql := 'select t.* from gzacs12.' || topos(i) || '_face$ a, '
           || 'table(a.island_edge_id_list) t '
           || 'where a.face_id = -1 '
           || 'AND abs(t.column_value) not in (select edge_id from gzacs12.' || topos(i) || '_edge$) ';
           
      execute immediate psql bulk collect into bunkedges;
      
      IF bunkedges.COUNT > 0
      THEN
      
         dbms_output.put_line(topos(i) || ': has bunk edges like ' || bunkedges(1));
      
      END IF;
   
   END LOOP;
  
END;
