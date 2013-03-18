select status, INST_ID, sid, serial#, process, username, schemaname, osuser, machine, 
service_name, module, action , client_info, logon_time, sql_id, event, seconds_in_wait
from gv$session
where username not in ('SYSTEM','SYS','DBSNMP')
and STATUS = 'ACTIVE'
--and username = 'SCHEL010'
--AND INST_ID = 6
order by inst_id, 
username , module  