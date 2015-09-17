/*
  suffix _V for all views
  semi-colon on newline
  A view of Employees currently employed by Sembcorp
*/
CREATE OR REPLACE FORCE VIEW CMN.CMN_CURR_EMPLS_V 
(UUID
, company_code
, department_code
, employee_no
, full_name
, start_dt
, end_dt
, is_main_job
, is_active
, payroll_status
, gender
, employee_grade
, employee_position
, employee_type
, employee_category
, employee_salary_type
, job_code
, employee_class
, employ_type
, location
, reporting_to_position
) 
AS 
SELECT 
    rownum AS UUID
    , company_code
    , department_code
    , employee_no
    , full_name
    , start_dt
    , end_dt
    , is_main_job
    , is_active
    , payroll_status
    , gender
    , employee_grade
    , employee_position
    , employee_type
    , employee_category
    , employee_salary_type
    , job_code
    , employee_class
    , employ_type
    , location
    , reporting_to_position
FROM
    (
    SELECT ROW_NUMBER() OVER(PARTITION BY empl.company_code, empl.department_code, empl.employee_no, empl.is_main_job ORDER BY empl.effective_from DESC, empl.is_main_job DESC) AS rn
    , empl.company_code
    , empl.department_code
    , empl.employee_no
    , e.full_name
    , empl.effective_from as start_dt
    , empl.effective_to as end_dt
    , empl.is_main_job
    , empl.is_active
    , empl.payroll_status
    , e.gender
    , empl.employee_grade
    , empl.employee_position
    , empl.employee_type
    , empl.employee_category
    , empl.employee_salary_type
    , empl.job_code
    , empl.employee_class
    , empl.employ_type
    , empl.location
    , empl.reporting_to_position
    FROM CMN_EMPLOYMENTS empl
    LEFT JOIN CMN_EMP e ON e.employee_no = empl.employee_no 
    WHERE (empl.is_main_job IS NOT NULL OR empl.is_main_job = 'P')         -- P means this employment is the Primary role
        AND (empl.is_active IS NOT NULL AND empl.is_active = 'A')           -- A means HR_STATUS is Active
        AND (empl.payroll_status IS NOT NULL AND empl.payroll_status = 'A') -- T means employment is terminated
        AND (empl.effective_from IS NOT NULL)
        AND (empl.effective_from < sysdate)
        AND (empl.effective_to IS NULL OR effective_to > sysdate)
    )
WHERE rn = 1 AND employee_no IS NOT NULL
ORDER BY company_code, department_code, employee_no
WITH READ ONLY
;
