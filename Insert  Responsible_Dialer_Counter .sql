INSERT INTO COM_FINVI_OASIS_RESTRICTIONS_{PP_TenantName}.RESPONSIBLE_DIALER_COUNTER
(
	RESPONSIBLE_ID,
	DIALER_COUNTER_ID
)
SELECT 
	RESPONSIBLE_ID,
	DIALER_COUNTER_ID 
FROM ETL_OASIS_DATA_MIG_{PP_TenantName}.ETL_WRK_CALLHIST_DIALER_COUNTER  WCHDC 
JOIN DIALER_COUNTER  DC ON DC.CREATED_ON =WCHDC.CREATED_ON
	AND DC.MODIFIED_ON= WCHDC.MODIFIED_ON 
	AND DC.DIALER_RESULT_ID=WCHDC.DIALER_RESULT_ID