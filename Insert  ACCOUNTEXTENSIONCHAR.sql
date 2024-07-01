INSERT INTO COM_FINVI_OASIS_ACCOUNT_{PP_TenantName}.ACCOUNTEXTENSIONCHAR
(
	ACCOUNTNUM, 
	CREATEDATE,
	LASTUPDATEDATE,
	CLIENTDEFINEDCHAR6,
	CLIENTDEFINEDCHAR7,
	CLIENTDEFINEDCHAR9,
	CLIENTDEFINEDCHAR10,
	CLIENTDEFINEDCHAR16,
	CLIENTDEFINEDCHAR8,
	CLIENTDEFINEDCHAR15,
	CLIENTDEFINEDCHAR13,
	CLIENTDEFINEDCHAR14,
	CLIENTDEFINEDCHAR12,
	CLIENTDEFINEDCHAR11,
	CLIENTDEFINEDCHAR17,
	CLIENTDEFINEDCHAR18,
	CLIENTDEFINEDCHAR1
)
SELECT 
	a.ACCOUNTNUM AS ACCOUNTNUM, 
	SYSDATE AS CREATEDATE,
	SYSDATE AS LASTUPDATEDATE,
	sca.CUSTOMFLD2 AS CLIENTDEFINEDCHAR6,
	sca.CUSTOMFLD3 AS CLIENTDEFINEDCHAR7,
	sca.CUSTOMFLD8 AS CLIENTDEFINEDCHAR9,
	sca.CUSTOMFLD9 AS CLIENTDEFINEDCHAR10,
	sca.CUSTOMFLD15 AS CLIENTDEFINEDCHAR16,
	sca.CUSTOMFLD4 AS CLIENTDEFINEDCHAR8,
	sca.CUSTOMFLD14 AS CLIENTDEFINEDCHAR15,
	sca.CUSTOMFLD12 AS CLIENTDEFINEDCHAR13,
	sca.CUSTOMFLD13 AS CLIENTDEFINEDCHAR14,
	sca.CUSTOMFLD11 AS CLIENTDEFINEDCHAR12,
	sca.CUSTOMFLD10 AS CLIENTDEFINEDCHAR11,
	sca.CUSTOMFLD5 AS CLIENTDEFINEDCHAR17,
	sca.CUSTOMFLD6 AS CLIENTDEFINEDCHAR18,
	sca.CUSTOMFLD1 AS CLIENTDEFINEDCHAR1
FROM ETL_OASIS_DATA_MIG_{PP_TenantName}.ETL_STG_CUSTOM_ACCOUNT sca
	INNER JOIN COM_FINVI_OASIS_ACCOUNT_{PP_TenantName}.ACCOUNT a ON a.MIGRATION_SOURCE_ID = sca.ACCOUNTID 
WHERE sca.CUSTOMFLD1 IS NOT NULL OR sca.CUSTOMFLD2 IS NOT NULL 
