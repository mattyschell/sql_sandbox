declare

   state          varchar2(32) := 'TAB10ST09.STATE';
   tile_divider   NUMBER := 100;
   out_table      varchar2(32) := 'MYWINDOWS';
   psql           varchar2(4000);
   big_g          sdo_geometry;
   full_g         sdo_geometry;
   test_window    sdo_geometry;
   tile_size      NUMBER;
   llx            NUMBER;
   lly            NUMBER;
   urx            NUMBER;
   ury            NUMBER;
   kount          PLS_INTEGER;
   total_kount    PLS_INTEGER := 0;

begin

   begin
      execute immediate 'drop table ' || out_table;
   exception when others then null;
   end;
   

   psql := 'CREATE TABLE ' || out_table || ' (SDOGEOMETRY SDO_GEOMETRY) ';
   execute immediate psql;

   psql := 'SELECT sdo_geom.sdo_mbr(a.sdogeometry), a.sdogeometry FROM '
        || state || ' a '
        || 'WHERE a.vintage = :p1 ';
   EXECUTE IMMEDIATE psql INTO big_g, full_g USING '90';
   
   EXECUTE IMMEDIATE 'INSERT INTO ' || out_table || ' VALUES (:p1) ' USING full_g;

   --initialize this guy
   test_window := big_g;
   
   --divide X dimension into 
   tile_size := ABS(big_g.sdo_ordinates(1) - big_g.sdo_ordinates(3))/tile_divider;
   
   llx := big_g.sdo_ordinates(1);
   lly := big_g.sdo_ordinates(2);
   urx := big_g.sdo_ordinates(1);
   ury := big_g.sdo_ordinates(2);
   
   --initialize spatial sql
   psql := 'SELECT COUNT(1) FROM '
        || state || ' a '
        || 'WHERE '
        || 'a.vintage = :p1 AND '
        || 'SDO_RELATE(a.sdogeometry, :p2, :p3) = :p4 ';
   
   LOOP

      --go up one grid in y dimension
      lly := ury;
      ury := ury + tile_size;

      LOOP

         --travel along the X dimension ---->
         llx := urx;
         urx := urx + tile_size;

         --we now have a tile position
         test_window.sdo_ordinates(1) := llx;
         test_window.sdo_ordinates(2) := lly;
         test_window.sdo_ordinates(3) := urx;
         test_window.sdo_ordinates(4) := ury;
         
         EXECUTE IMMEDIATE psql INTO kount USING '90',
                                                  test_window,
                                                 'mask=ANYINTERACT',
                                                 'TRUE';
               
         total_kount := total_kount + kount;     
         
         IF kount >= 1
         THEN
            EXECUTE IMMEDIATE 'INSERT INTO ' || out_table || ' VALUES (:p1) ' USING test_window;
            COMMIT;
         END IF;                
                               
         --always go past the X end before exiting
         IF urx >= big_g.sdo_ordinates(3)
         THEN

            --exit inner X loop
            EXIT;

         END IF;
         
      END LOOP;
         
      --carriage return the X
      llx := big_g.sdo_ordinates(1);
      urx := big_g.sdo_ordinates(1);

      --always go past the Y end before exit
      --ensures final tile hangs off the universe

      IF ury >=  big_g.sdo_ordinates(4)
      THEN

         --exit the top right hopefully
         dbms_output.put_line('total kount is ' || total_kount);
         EXIT;

      END IF;
      
   END LOOP;
   
END;