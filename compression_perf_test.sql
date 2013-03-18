declare

compression varchar2(32) := '';
--compression varchar2(32) := 'COMPRESS FOR QUERY HIGH';
gets NUMBER := 400000;
table_name varchar2(32) := 'MYEDGENOCOMPRESS';
type strarray is table of number index by pls_integer;
edgez strarray;
psql varchar2(4000);
start_time date;
end_time date;
elapsed number;
geom sdo_geometry;
geomempty sdo_geometry;
tab_exists  pls_integer := 0;

begin 

   --create logger
   
   begin
   
      psql := 'CREATE TABLE COMPRESSTESTLOG '
           || '(compression varchar2(32), table_name VARCHAR2(32), gets NUMBER, time_seconds NUMBER, gets_per_second NUMBER)';
      execute immediate psql;
      exception
      when others then
         if sqlcode = -955
         then
            NULL;
         end if;
   end;

   
   psql := 'CREATE TABLE ' || table_name || ' '
        || '(edge_id NUMBER, start_node_id NUMBER, end_node_id NUMBER, next_left_edge_id NUMBER, '
        || 'prev_left_edge_id NUMBER, next_right_edge_id NUMBER, prev_right_edge_id NUMBER, '
        || 'left_face_id NUMBER, right_face_id NUMBER, geometry SDO_GEOMETRY, '
        || 'constraint ' || table_name || 'pkc PRIMARY KEY (edge_id)) '
        || 'NOLOGGING ' || compression || ' '; 
     
   begin   
      EXECUTE IMMEDIATE psql;
   exception
   when others then
      if sqlcode = -955
      then
         tab_exists := 1;
         --execute immediate 'drop table ' || table_name;
         --execute immediate psql;
      else
         raise;
      end if;
   end;

   
   if tab_exists = 0
   then
   
      gz_utilities.ADD_SPATIAL_INDEX(table_name,'GEOMETRY',8265,.05);
      
      --must be direct path
      psql := 'INSERT /*+ APPEND */  INTO ' || table_name || ' '
           || 'SELECT * FROM tab10st09.mt_edge$ ';
           
      execute immediate psql;
      commit;
      
   end if;
   
   --get a random set of "gets" edge ids
   psql := 'SELECT edge_id FROM '
        || '(SELECT edge_id FROM ' || table_name || ' '
        || 'ORDER BY dbms_random.value ) '
        || 'WHERE rownum < :p1 ';
   execute immediate psql BULK COLLECT INTO edgez USING gets;
   
   --timer on
   start_time := CURRENT_TIMESTAMP;
      
      
   --grab the geometry for each edge
   
   FOR i IN 1 .. edgez.COUNT
   LOOP
   
      psql := 'SELECT a.geometry '
           || 'FROM '
           || table_name || ' a '
           || 'WHERE a.edge_id = :p1 ';
      EXECUTE IMMEDIATE psql INTO geom USING edgez(i);
      
      --trash it
      --dbms_output.put_line('trashing ' || edgez(i));
      geom := geomempty;
      
   END LOOP;

   
   end_time := CURRENT_TIMESTAMP;
   elapsed := ROUND((end_time - start_time)*24*60*60);
   --dbms_output.put_line('elapsed time in seconds is ' || elapsed);
   
   psql := 'insert into COMPRESSTESTLOG VALUES(:p1,:p2,:p3,:p4,:p5)';
   execute immediate psql USING compression, table_name, gets, elapsed, gets/elapsed;
   commit; 
   
END;
   




