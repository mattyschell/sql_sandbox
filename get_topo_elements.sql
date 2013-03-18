select e.geometry, e.edge_id from 
acs09gh.fsl400 a, 
TABLE(a.topogeom.GET_TOPO_ELEMENTS()) t, 
acs09gh.mt_face$ f,
acs09gh.mt_edge$ e
where a.uace = '05167'
and f.face_id = t.topo_id
and (e.left_face_id = f.face_id
or e.right_face_id = f.face_id)

