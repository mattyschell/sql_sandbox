DECLARE

psql varchar2(4000);
tabs cr_stringarray.stringarray;
kount pls_integer;

BEGIN

   psql := 'select table_tag from table_pool_tracker ';
            --WHERE...
   execute immediate psql bulk collect into tabs;
   
   FOR i in 1 .. tabs.COUNT
   LOOP          
         --call the camps worktable, sdo metadata, and sequence cleanup procedure
         --override third option fakes table pool tag as if it is <projcode><entitycode>
         
         BEGIN
         
            CR_TABLE_RULES.cleanup_worktables( NULL, NULL, tabs(i) ) ;
            
            psql := 'DELETE from table_pool_tracker where table_tag = :p1 ';
            EXECUTE IMMEDIATE psql USING tabs(i);
            commit;
         
            EXCEPTION 
            WHEN OTHERS THEN
               NULL;
         
         END; 
   
   
   END LOOP;
   
END;
     