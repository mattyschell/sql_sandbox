select e.edge_id, e.start_node_id, e.end_node_id from 
GEN_ST_EDGES_HI_10 a,
STATEFP10_RELATION$ r,
STATEFP10_EDGE$ e
where r.tg_layer_id = a.topogeom.tg_layer_id
and r.tg_id = a.topogeom.tg_id
and e.edge_id = r.topo_id

select * from STATEFP10_EDGE$
where edge_id = 149


select * from statefp10_edge$
where start_node_id = 114
or end_node_id = 114

select * from statefp10_edge$
where edge_id = 149

select e.edge_id, e.start_node_id, e.end_node_id from 
GEN_ST_EDGES_HI_10 a,
STATEFP10_RELATION$ r,
STATEFP10_EDGE$ e
where r.tg_layer_id = a.topogeom.tg_layer_id
and r.tg_id = a.topogeom.tg_id
and e.edge_id = r.topo_id


--all state edges and start + end nodes
select e.edge_id, e.start_node_id, e.end_node_id from 
GEN_ST_EDGES_HI_10 a,
STATEFP10_RELATION$ r,
STATEFP10_EDGE$ e
where r.tg_layer_id = a.topogeom.tg_layer_id
and r.tg_id = a.topogeom.tg_id
and e.edge_id = r.topo_id



--Find one, and only one edge, with the start node of my guy
--As start or end of another guy

select z.* from 
STATEFP10_EDGE$ e,
(
--all state edges and start + end nodes
select e.edge_id, e.start_node_id, e.end_node_id from 
GEN_ST_EDGES_HI_10 a,
STATEFP10_RELATION$ r,
STATEFP10_EDGE$ e
where r.tg_layer_id = a.topogeom.tg_layer_id
and r.tg_id = a.topogeom.tg_id
and e.edge_id = r.topo_id
) z
where e.edge_id = 149
and 
z.edge_id != e.edge_id
and (z.start_node_id = e.start_node_id or z.end_node_id = e.start_node_id)


select aa.edge_id, bb.* from 
(select e.edge_id, e.start_node_id, e.end_node_id from 
GEN_ST_EDGES_HI_10 a,
STATEFP10_RELATION$ r,
STATEFP10_EDGE$ e
where r.tg_layer_id = a.topogeom.tg_layer_id
and r.tg_id = a.topogeom.tg_id
and e.edge_id = r.topo_id
and e.edge_id = 149
) aa,
(select e.edge_id, e.start_node_id, e.end_node_id from 
GEN_ST_EDGES_HI_10 a,
STATEFP10_RELATION$ r,
STATEFP10_EDGE$ e
where r.tg_layer_id = a.topogeom.tg_layer_id
and r.tg_id = a.topogeom.tg_id
and e.edge_id = r.topo_id) bb
where 
aa.edge_id != bb.edge_id
and (aa.start_node_id = bb.start_node_id or aa.start_node_id = bb.end_node_id)



--Connect BY!

select edge_id, start_node_id, end_node_id, geometry  from 
(select e.edge_id, e.start_node_id, e.end_node_id, e.geometry from 
GEN_ST_EDGES_HI_10 a,
STATEFP10_RELATION$ r,
STATEFP10_EDGE$ e
where r.tg_layer_id = a.topogeom.tg_layer_id
and r.tg_id = a.topogeom.tg_id
and e.edge_id = r.topo_id) aa
start with aa.edge_id = 149
connect by nocycle (prior aa.end_node_id = aa.start_node_id) or (prior aa.end_node_id = aa.end_node_id)


select edge_id, start_node_id, end_node_id, geometry  from 
(select e.edge_id, e.start_node_id, e.end_node_id, e.geometry from 
GEN_ST_EDGES_HI_10 a,
STATEFP10_RELATION$ r,
STATEFP10_EDGE$ e
where r.tg_layer_id = a.topogeom.tg_layer_id
and r.tg_id = a.topogeom.tg_id
and e.edge_id = r.topo_id) aa
start with aa.edge_id = 149
connect by nocycle (prior aa.end_node_id = aa.end_node_id) or (prior aa.end_node_id = aa.start_node_id) 



select e.edge_id, e.start_node_id, e.end_node_id, e.geometry from 
GEN_ST_EDGES_HI_10 a,
STATEFP10_RELATION$ r,
STATEFP10_EDGE$ e
where r.tg_layer_id = a.topogeom.tg_layer_id
and r.tg_id = a.topogeom.tg_id
and e.edge_id = r.topo_id

select * from statefp10_edge$
where edge_id = 214








select SYS_CONNECT_BY_PATH(edge_id,'|'), LEVEL, CONNECT_BY_ISLEAF, edge_id, start_node_id, end_node_id, geometry  from 
(select e.edge_id, e.start_node_id, e.end_node_id, e.geometry from 
GEN_ST_EDGES_HI_10 a,
STATEFP10_RELATION$ r,
STATEFP10_EDGE$ e
where r.tg_layer_id = a.topogeom.tg_layer_id
and r.tg_id = a.topogeom.tg_id
and e.edge_id = r.topo_id) aa
start with aa.edge_id = 149
connect by nocycle prior aa.end_node_id = aa.start_node_id
--goes to edge 177

select SYS_CONNECT_BY_PATH(edge_id,'|'), LEVEL, CONNECT_BY_ISLEAF, edge_id, start_node_id, end_node_id, geometry  from 
(select e.edge_id, e.start_node_id, e.end_node_id, e.geometry from 
GEN_ST_EDGES_HI_10 a,
STATEFP10_RELATION$ r,
STATEFP10_EDGE$ e
where r.tg_layer_id = a.topogeom.tg_layer_id
and r.tg_id = a.topogeom.tg_id
and e.edge_id = r.topo_id) aa
start with aa.edge_id = 149
connect by nocycle prior aa.end_node_id = aa.start_node_id
--reverse root is 177






--return repetitive branches
select q.edge_id, q.start_node_id, q.end_node_id, LEVEL from (
select e.edge_id, e.start_node_id, e.end_node_id from 
GEN_ST_EDGES_HI_10 a,
STATEFP10_RELATION$ r,
STATEFP10_EDGE$ e
where r.tg_layer_id = a.topogeom.tg_layer_id
and r.tg_id = a.topogeom.tg_id
and e.edge_id = r.topo_id
) q
--start with q.edge_id = 149
connect by nocycle prior q.end_node_id = q.start_node_id




--subquery
select e.edge_id, e.start_node_id, e.end_node_id from 
GEN_ST_EDGES_HI_10 a,
STATEFP10_RELATION$ r,
STATEFP10_EDGE$ e
where r.tg_layer_id = a.topogeom.tg_layer_id
and r.tg_id = a.topogeom.tg_id
and e.edge_id = r.topo_id

select count(*) from (
select e.edge_id, e.start_node_id, e.end_node_id from 
GEN_ST_EDGES_HI_10 a,
STATEFP10_RELATION$ r,
STATEFP10_EDGE$ e
where r.tg_layer_id = a.topogeom.tg_layer_id
and r.tg_id = a.topogeom.tg_id
and e.edge_id = r.topo_id
)

--get start and end for our root
select e.start_node_id, e.end_node_id from 
GEN_ST_EDGES_HI_10 a,
STATEFP10_RELATION$ r,
STATEFP10_EDGE$ e
where r.tg_layer_id = a.topogeom.tg_layer_id
and r.tg_id = a.topogeom.tg_id
and e.edge_id = r.topo_id
and e.edge_id = 149


--dig as far as we can get
select l.edge_id, l.start_node_id, l.end_node_id, l.lev from (
select q.edge_id, q.start_node_id, q.end_node_id, level lev, CONNECT_BY_ISLEAF leaf FROM (
select e.edge_id, e.start_node_id, e.end_node_id from 
GEN_ST_EDGES_HI_10 a,
STATEFP10_RELATION$ r,
STATEFP10_EDGE$ e
where r.tg_layer_id = a.topogeom.tg_layer_id
and r.tg_id = a.topogeom.tg_id
and e.edge_id = r.topo_id
) q
start with q.edge_id = 149
connect by nocycle prior q.end_node_id = q.start_node_id
) l
where l.leaf > 0

-- 177 100 115 29


select q.edge_id, q.start_node_id, q.end_node_id from (
select e.edge_id, e.start_node_id, e.end_node_id from 
GEN_ST_EDGES_HI_10 a,
STATEFP10_RELATION$ r,
STATEFP10_EDGE$ e
where r.tg_layer_id = a.topogeom.tg_layer_id
and r.tg_id = a.topogeom.tg_id
and e.edge_id = r.topo_id
) q
where q.end_node_id = 115
and q.edge_id != 177

--214 (134, 115)


--dig as far as we can get
select l.edge_id, l.start_node_id, l.end_node_id, l.lev from (
--here to there duh
select q.edge_id, q.start_node_id, q.end_node_id, level lev, CONNECT_BY_ISLEAF leaf FROM (
select e.edge_id, e.start_node_id, e.end_node_id from 
GEN_ST_EDGES_HI_10 a,
STATEFP10_RELATION$ r,
STATEFP10_EDGE$ e
where r.tg_layer_id = a.topogeom.tg_layer_id
and r.tg_id = a.topogeom.tg_id
and e.edge_id = r.topo_id
) q
start with q.edge_id = 214
connect by nocycle prior q.start_node_id = q.end_node_id
--
) l
where l.leaf > 0

--187 114, 124 level 20   this is the edge prior to the "root"
--need to check the levels, they are off by 1 each I think