select tablespace "Permanent Tablespace", 
"Current(MB)",
"Max(MB)"
from
(select current_space.tablespace_name tablespace, 
nvl(sum_free, 0) "Free(MB)",
sum_current "Current(MB)",
sum_dbfs "Max(MB)",
round((sum_current - nvl(sum_free, 0))/sum_dbfs, 2)*100 PCT_USED
from
 (select tablespace_name,
  round(sum(bytes)/1024/1024) sum_current,
  round(sum(decode(maxbytes, 0, bytes, maxbytes))/1024/1024) sum_dbfs
  from dba_data_files
 group by tablespace_name) current_space,
 (select tablespace_name,
  round(sum(bytes)/1024/1024) sum_free
 from dba_free_space dfs group by tablespace_name) free_space
where free_space.tablespace_name(+) = current_space.tablespace_name
and current_space.tablespace_name like 'UNDO%')
order by tablespace;
