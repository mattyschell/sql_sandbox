DECLARE
retval VARCHAR2(4000);
BEGIN
retval := CPB_UTILITIES.CLOSED_LOOPS('GEN_ST_EDGES_HI_10','STATEFP10');
dbms_output.put_line(retval);
END;





--connect by attempt #2
--collecting edge ids

--subquery: all edges for our feature table
select e.edge_id, e.start_node_id, e.end_node_id from 
GEN_ST_EDGES_HI_10 a,
STATEFP10_RELATION$ r,
STATEFP10_EDGE$ e
where r.tg_layer_id = a.topogeom.tg_layer_id
and r.tg_id = a.topogeom.tg_id
and e.edge_id = r.topo_id


--tunnel as far as we can get
--end2start
--  0---->0---->0--->
select q.edge_id, q.start_node_id, q.end_node_id, CONNECT_BY_ISLEAF leaf FROM (
select e.edge_id, e.start_node_id, e.end_node_id from 
GEN_ST_EDGES_HI_10 a,
STATEFP10_RELATION$ r,
STATEFP10_EDGE$ e
where r.tg_layer_id = a.topogeom.tg_layer_id
and r.tg_id = a.topogeom.tg_id
and e.edge_id = r.topo_id
) q
--start with q.edge_id = 149
start with q.edge_id = 217
connect by nocycle prior q.end_node_id = q.start_node_id
--Root 149   114   101   0
--Leaf 177   100   115   1

---
--check that only one of our leafs is a 1
---

--IF YES
select qq.edge_id, qq.leaf from (
select q.edge_id, q.start_node_id, q.end_node_id, CONNECT_BY_ISLEAF leaf FROM (
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
) qq
where qq.leaf = 1 
and rownum = 1 





--check that our leaf is not the start
--not sure how this really works

--get the next edge
--end2start means switch to end2end node in where
--  0---->0---->0---><----0
select q.edge_id, q.start_node_id, q.end_node_id from (
select e.edge_id, e.start_node_id, e.end_node_id from 
GEN_ST_EDGES_HI_10 a,
STATEFP10_RELATION$ r,
STATEFP10_EDGE$ e
where r.tg_layer_id = a.topogeom.tg_layer_id
and r.tg_id = a.topogeom.tg_id
and e.edge_id = r.topo_id
) q
where q.end_node_id = 115  --or reverse
and q.edge_id != 177
--214   134   115   
--new start


--START2END
--  0<---0<---<---0
select q.edge_id, q.start_node_id, q.end_node_id, CONNECT_BY_ISLEAF leaf FROM (
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
--root   214    134    115  0
--leaf   187    114    124  1

---
--check that only one of our leafs is a 1
---



--get next edge
--start2end means switch to shared start node in where
--  0<---0<---<---00---->
select q.edge_id, q.start_node_id, q.end_node_id from (
select e.edge_id, e.start_node_id, e.end_node_id from 
GEN_ST_EDGES_HI_10 a,
STATEFP10_RELATION$ r,
STATEFP10_EDGE$ e
where r.tg_layer_id = a.topogeom.tg_layer_id
and r.tg_id = a.topogeom.tg_id
and e.edge_id = r.topo_id
) q
where q.start_node_id = 114 --or reverse
and q.edge_id != 187


--check that our leaf is not the start
--not sure how this really works
