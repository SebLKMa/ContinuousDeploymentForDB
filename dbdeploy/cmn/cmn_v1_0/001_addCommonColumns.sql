-- GENERIC FIELDs, Iterates all tables in CMN and add these common columns
-- NOTE: must be done after all tables are created !!!
BEGIN
  FOR i IN (SELECT TABLE_NAME FROM USER_TABLES WHERE TABLE_NAME LIKE 'CMN_%') 
  LOOP 
  BEGIN
	EXECUTE IMMEDIATE 'ALTER TABLE '|| i.table_name ||' add ROW_STATUS NUMBER(1,0) DEFAULT 0 NOT NULL CHECK (ROW_STATUS in (0,1))';
	EXECUTE IMMEDIATE 'ALTER TABLE '|| i.table_name ||' add ROW_VERSION NUMBER DEFAULT 0 ';
	EXECUTE IMMEDIATE 'ALTER TABLE '|| i.table_name ||' add CREATED_ON DATE ';
	EXECUTE IMMEDIATE 'ALTER TABLE '|| i.table_name ||' add CREATED_BY VARCHAR2(50) ';
	EXECUTE IMMEDIATE 'ALTER TABLE '|| i.table_name ||' add MODIFIED_ON DATE ';
	EXECUTE IMMEDIATE 'ALTER TABLE '|| i.table_name ||' add MODIFIED_BY VARCHAR2(50) ';
    EXECUTE IMMEDIATE 'ALTER TABLE '|| i.table_name ||' add SYNC_ON DATE ';
	EXCEPTION 
  WHEN OTHERS THEN 
    IF SQLCODE != -1430 THEN -- ignore only ORA-01430 column already exists
      RAISE; 
    END IF; 
  END;
  END LOOP;
  COMMIT;
END;