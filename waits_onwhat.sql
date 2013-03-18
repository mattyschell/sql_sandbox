select sw.sid,
ses.username,
ses.osuser,
ses.sql_hash_value,
sw.event,
decode( sw.event,
'db file sequential read', (select segment_type||'
: '||owner||'.'||segment_name
from dba_extents
where file_id = sw.p1
and
sw.p2 between
block_id and (block_id + blocks-1)
), -- This query is SLOW !
'db file scattered read', (select segment_type||'
: '||owner||'.'||segment_name||
'('||sw.p3||' blocks)'
from dba_extents
where file_id = sw.p1
and
sw.p2 between
block_id and (block_id + blocks-1)
), -- This query is SLOW !
'buffer busy waits', (select segment_type||'
: '||owner||'.'||segment_name
from dba_extents
where file_id = sw.p1
and
sw.p2 between
block_id and (block_id + blocks-1)
), -- This query is SLOW !
'free buffer waits', 'DBWR too slow ?,
BUFER_CACHE too small ?',
'latch free', (select 'LATCH :
'||name||' Sleeps : '||sw.p3
from v$latchname
where latch# = sw.p2),
'enqueue', (select 'WAITING ON
(FIRST OBJECT ONLY)'||o.object_type||' : '||

o.owner||'.'||o.object_name||
' SINCE
'||to_char(sysdate-l.ctime/86400, 'dd/mm/yy hh24:mi')||')'
from dba_objects o,
v$locked_object
lo,
v$lock l
where o.object_id =
lo.object_id
and l.id1 = sw.p2
and l.id2 = sw.p3
and l.sid = sw.sid
and lo.session_id =
sw.sid
and rownum < 2), -- This query is SLOW !
sw.event
) as waiting_on_what,
sw.p1,
sw.p1raw,
sw.p1text,
sw.p2,
sw.p2raw,
sw.p3text,
sw.p3,
sw.p3raw,
sw.p3text
from v$session_wait sw,
v$session ses
where sw.wait_time = 0
and sw.event not like 'SQL*%'
and sw.event not like 'rdbms%'
and sw.event not like 'pmon%'
and sw.event not like 'smon%'
and ses.sid = sw.sid
order by sw.sid,
sw.event