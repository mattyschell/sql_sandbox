

SELECT 
geometry, 
node_id, 
LAG(node_id) OVER (ORDER BY node_id) 
FROM (    
   SELECT 
   a.geometry, 
   node_id   
   FROM (  
      SELECT 
      a.edge_id,   
      MAX(DECODE(b.topo_id, a.left_face_id, a.start_node_id, a.right_face_id, a.end_node_id)) node_id
      FROM 
      acs09gh.mt_edge$ a,  
      ( 
         SELECT 
         topo_id 
         FROM 
         acs09gh.mt_relation$ b  
         WHERE 
         tg_layer_id = 59 AND  
         tg_id = 3639 AND  
         topo_type =  3 
      )  b  
      WHERE  
      ( a.left_face_id = b.topo_id OR a.right_face_id = b.topo_id) AND 
      a.left_face_id <> a.right_face_id  
      GROUP BY  
      a.edge_id 
      HAVING 
      COUNT(*) < 2 
   ) b, 
   acs09gh.mt_edge$ a 
   WHERE 
   a.edge_id = b.edge_id   )