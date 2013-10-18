--What ARE THE queries that ARE running and TIME Remaining TO COMPLETE THE CURRENT?


WITH elapsed_time
     AS (  SELECT sid,
                  opname,
                  target,
                  TO_CHAR (start_time, 'DD-MON-YY HH24:MI') START_TIME,
                  time_remaining / 60 "Time Remaining in Mins",
                  username
             FROM v$session_longops
            WHERE time_remaining > 1
         ORDER BY time_remaining)
SELECT et.opname,
       et.target,
       et.START_TIME,
       et."Time Remaining in Mins",
       et.username,
       sesion.sid,
       sesion.username,
       sqlarea.optimizer_mode,
       sqlarea.hash_value,
       sqlarea.address,
       sqlarea.cpu_time,
       sqlarea.elapsed_time,
       sqlarea.sql_text
  FROM v$sqlarea sqlarea, v$session sesion, elapsed_time et
 WHERE     sesion.sql_hash_value = sqlarea.hash_value
       AND sesion.sql_address = sqlarea.address
       AND sesion.username IS NOT NULL
       AND et.sid(+) = sesion.sid;
/

