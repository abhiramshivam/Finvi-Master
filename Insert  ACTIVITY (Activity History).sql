INSERT INTO  COM_FINVI_OASIS_ACCOUNT_ACTIVITY_{PP_TenantName}.ACTIVITY 
(
	ID 
	,TRANSACTION_ID 
	,USER_ID 
	,CONTEXT
	,CATEGORY
	,TYPE
	,DATA
	,DATA_VERSION
	,"TIMESTAMP" 
	,CREATED_ON
	,MODIFIED_ON
)
SELECT 
	ACTIVITY_ID AS ID
	,TRANSACTION_ID
    ,(SELECT IDPUSERID FROM COM_FINVI_OASIS_ACCOUNT_{PP_TenantName}.user_ WHERE USERNAME = 'etlmigrationuser@finvi.com') AS USER_ID	
	,CONTEXT
	,CATEGORY
	,TYPE
	,'null' AS DATA
	,0 AS DATA_VERSION
	,h.ACTIVITY_DATE + 0.5 AS "TIMESTAMP" 
	,h.ACTIVITY_DATE + 0.5 AS CREATED_ON
	,SYSDATE  AS MODIFIED_ON
 FROM ETL_OASIS_DATA_MIG_{PP_TenantName}.WRK_ACCOUNT_HIST h