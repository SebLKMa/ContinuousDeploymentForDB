BEGIN
-- REMOVE ALL and start from fresh, DROP USER will fail if there are still unknown connections to the schema
BEGIN 
   EXECUTE IMMEDIATE 'DROP USER cmn CASCADE';
EXCEPTION 
   WHEN OTHERS THEN 
	  IF SQLCODE != -942 THEN -- ignore only ORA-00942
		 RAISE; 
	  END IF; 
END;

/*
 ***** DROP USER will fail if there are still unknown connections to the schema
 ***** Kill those connections as follows:
 SQL> SELECT s.sid, s.serial#, s.status, p.spid FROM v$session s, v$process p WHERE s.username = 'CMN';
 SQL> ALTER SYSTEM KILL SESSION '<SID>, <SERIAL>';
 If your WebLogic Server is connected to the database, you may have to shut them down too.
*/

/*
 create user
 three separate commands, so the create user command 
 will succeed regardless of the existence of the 
 DEMO and TEMP tablespaces 
*/

BEGIN
EXECUTE IMMEDIATE 'CREATE USER cmn IDENTIFIED BY cmn DEFAULT TABLESPACE users TEMPORARY TABLESPACE temp';
END;

BEGIN
EXECUTE IMMEDIATE 'ALTER USER cmn IDENTIFIED BY cmn Account Unlock QUOTA UNLIMITED ON users';
END;

BEGIN
EXECUTE IMMEDIATE 'GRANT CREATE SESSION, CREATE VIEW, ALTER SESSION, CREATE SEQUENCE TO cmn';
EXECUTE IMMEDIATE 'GRANT CREATE SYNONYM, CREATE DATABASE LINK, RESOURCE TO cmn';
-- grants from system schema
EXECUTE IMMEDIATE 'GRANT execute ON sys.dbms_stats TO cmn';
END;

END;
