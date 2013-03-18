select sw.sid,
ses.username,
ses.osuser,
ses.sql_hash_value,
sw.event,
sw.p1,
sw.p1raw,
sw.p1text,
sw.p2,
sw.p2raw,
sw.p2text,
sw.p3,
sw.p3raw,
sw.p3text
from v$session_wait sw,
v$session ses
where sw.wait_time = 0
-- and sw.event not like 'SQL*%'
and sw.event not like 'rdbms%'
and sw.event not like 'pmon%'
and sw.event not like 'smon%'
and ses.sid = sw.sid
order by sw.sid,sw.event;