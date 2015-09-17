BEGIN
  FOR i IN (SELECT TABLE_NAME FROM USER_TABLES WHERE TABLE_NAME LIKE 'CMN_%') 
  LOOP 
        EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER '|| SUBSTR(i.table_name,5) ||'_TRG BEFORE INSERT ON '|| i.table_name || '
        FOR EACH ROW 
                BEGIN
                        IF :NEW.INTERNAL_ID IS NULL THEN
                          :NEW.INTERNAL_ID := '|| SUBSTR(i.table_name,5) ||'_SEQ.NEXTVAL;
                        END IF;
                END;';
  END LOOP;
  COMMIT;
END;
