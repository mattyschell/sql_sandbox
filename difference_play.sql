--square A
select SDO_GEOMETRY(
    2003,  
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY(1,1003,1), 
    SDO_ORDINATE_ARRAY(0,0, 10,0, 10,10, 0,10, 0,0)
  ) from dual
  
  

 
--basic square B
    select SDO_GEOMETRY(
    2003,  
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY(1,1003,1), 
    SDO_ORDINATE_ARRAY(10,0, 20,0, 20,10, 10,10, 10,0)
  ) from dual
    
--square B with chunk 
   select SDO_GEOMETRY(
    2003,  
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY(1,1003,1), 
    SDO_ORDINATE_ARRAY(10,0, 20,0, 20,10, 10,10, 10,6, 11,5, 10,4, 10,0)
  ) from dual
  
  


  
  
  --A dif B tolerance 1...3
  --Doesnt matter, there are no ordinates to mess with at the difference spot
  SELECT SDO_GEOM.SDO_DIFFERENCE(SDO_GEOMETRY(
    2003,  
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY(1,1003,1), 
    SDO_ORDINATE_ARRAY(0,0, 10,0, 10,10, 0,10, 0,0)
  ), SDO_GEOMETRY(
    2003,  
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY(1,1003,1), 
    SDO_ORDINATE_ARRAY(10,0, 20,0, 20,10, 10,10, 10,6, 11,5, 10,4, 10,0)
  ), 2) from dual
  
  
  
--B diff A
--tolerance at 1.5 flattens the chunk

SELECT SDO_GEOM.SDO_DIFFERENCE(SDO_GEOMETRY(
    2003,  
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY(1,1003,1), 
    SDO_ORDINATE_ARRAY(10,0, 20,0, 20,10, 10,10, 10,6, 11,5, 10,4, 10,0)
  ), SDO_GEOMETRY(
    2003,  
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY(1,1003,1), 
    SDO_ORDINATE_ARRAY(0,0, 10,0, 10,10, 0,10, 0,0)
  ), .05) from dual
  
  
  
--make it more of a sliver
--same A
--new B
   select SDO_GEOMETRY(
    2003,  
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY(1,1003,1), 
    SDO_ORDINATE_ARRAY(10,0, 20,0, 20,10, 10,10, 10,6, 10.1,5, 10,4, 10,0)
  ) from dual
  
  
--A diff B
--huh works now
SELECT SDO_GEOM.SDO_DIFFERENCE(SDO_GEOMETRY(
    2003,  
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY(1,1003,1), 
    SDO_ORDINATE_ARRAY(0,0, 10,0, 10,10, 0,10, 0,0)
  ), SDO_GEOMETRY(
    2003,  
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY(1,1003,1), 
    SDO_ORDINATE_ARRAY(10,0, 20,0, 20,10, 10,10, 10,6, 10.1,5, 10,4, 10,0)
  ) , .05) from dual
  
--B diff A
--flattens at tolerance 2, or the distance of the entire sliver
--But not at ~.1 the sliver width
SELECT SDO_GEOM.SDO_DIFFERENCE(SDO_GEOMETRY(
    2003,  
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY(1,1003,1), 
    SDO_ORDINATE_ARRAY(10,0, 20,0, 20,10, 10,10, 10,6, 10.1,5, 10,4, 10,0)
  ),  SDO_GEOMETRY(
    2003,  
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY(1,1003,1), 
    SDO_ORDINATE_ARRAY(0,0, 10,0, 10,10, 0,10, 0,0)
  ) , .05) from dual

  
  

