INSERT INTO COM_FINVI_OASIS_ACCOUNT_{PP_TenantName}.LETTERCHANNELACTUALRESULT
(
	CREATEDATE,
	STATUS,
	STRATEGYDATE,
	LASTUPDATEDATE,
	LETTERDATA1,
	LETTERDATA2,
	LETTERDATA3,
	LETTERDATA4,
	LETTERDATA5,
	LETTERDATA6,
	LETTERDATA7,
	LETTERDATA8,
	LETTERDATA9,
	ACCOUNTNUM,
	RESPONSIBLEID,
	LETTERRESULTID,
	UUID
)
SELECT
	SYSDATE  AS CREATEDATE,
	'SENT' AS STATUS, 
	slh.ARLHPRTDTE + 0.5 AS STRATEGYDATE,
	slh.ARLHPRTDTE + 0.5 AS LASTUPDATEDATE,
	slh.ARLHADR AS LETTERDATA1,
	'' AS LETTERDATA2,
	slh.ARLHCTY AS LETTERDATA3,
	slh.ARLHST AS LETTERDATA4,
	slh.ARLHZIP AS LETTERDATA5,
	slh.ARLHPRTDTE AS LETTERDATA6,
	'' AS LETTERDATA7,
	'' AS LETTERDATA8,
	slh.ARLHLTR AS LETTERDATA9,
	a.ACCOUNTNUM AS ACCOUNTNUM,
	l.RESPONSIBLEID,
	l.LETTERRESULTID AS LETTERRESULTID,
	SYS_GUID() AS UUID
FROM ETL_OASIS_DATA_MIG_{PP_TenantName}.ETL_STG_PRTY_LTR_HIST_INFO slh
INNER JOIN COM_FINVI_OASIS_ACCOUNT_{PP_TenantName}.ACCOUNT a ON a.MIGRATION_SOURCE_ID=slh.ACCOUNTID
LEFT JOIN COM_FINVI_OASIS_ACCOUNT_{PP_TenantName}.LETTERCHANNELRESULT l ON l.BCNODEID = slh.SEQ_NUM