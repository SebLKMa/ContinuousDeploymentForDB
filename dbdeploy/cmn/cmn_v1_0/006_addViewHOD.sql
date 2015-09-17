/*
  suffix _V for all views
  semi-colon on newline
*/
CREATE OR REPLACE FORCE VIEW CMN.CMN_HOD_V 
(UUID, COMPANY_CODE, COMPANY_NAME, DEPARTMENT_CODE, DEPARTMENT_NAME, EMPLOYEE_NO, FULL_NAME) 
AS 
SELECT 
  rownum AS UUID
,  company_code
, company_name
, department_code
, department_name
, employee_no
, full_name
  FROM
  (
    SELECT ROW_NUMBER() OVER(PARTITION BY empl.company_code, empl.department_code, empl.employee_no ORDER BY empl.effective_from DESC, empl.PS_RECORD_NO DESC) AS rn
    , empl.company_code
	, empl.company_name
    , empl.department_code
	, empl.department_name
    , empl.employee_no
    , e.full_name
    , empl.effective_from
    FROM CMN_EMPLOYMENTS empl
    LEFT JOIN CMN_EMP e ON e.employee_no = empl.employee_no 
	WHERE UPPER(empl.employee_position) = UPPER('HOD') 
	  AND empl.is_active = 1 -- 1 is active
	  AND (empl.effective_from IS NOT NULL)
	  AND (empl.effective_from < sysdate)
	  AND (empl.effective_to IS NULL OR effective_to > sysdate)
  )
  WHERE rn = 1 
    AND department_code IS NOT NULL
  ORDER BY company_code
WITH READ ONLY
;
