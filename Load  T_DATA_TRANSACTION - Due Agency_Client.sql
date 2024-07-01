INSERT INTO COM_FINVI_OASIS_MACRO_ACCOUNT_{PP_TenantName}.T_DATA_TRANSACTION
( 
	VERSION,
	CREATE_DATE,
	MODIFIED_ON,	
	CREATE_BY,
	MODIFIED_BY,
	TYPE,
	CHARGE_ITEM_ID,
	TXN_AMT,
	CREDIT,
	EFFECTIVE_DATE,
	REMIT_OVERPYMT_TO_CLIENT,
	PAYMENT_ID,
	POSTED_DATE,
	SETTLEMENT_UNAPPROVED,
	LINE_OF_BUSINESS,
	BUSINESS_CLASS,
	WORKFLOW_STATUS,
	CHARGE_ITEM_BALANCE_DUE,
	ACCOUNT_BALANCE_DUE,
	SHARED_ACCOUNT_BALANCE_DUE,
	CLIENT_ACCOUNT_BALANCE_DUE,
	CLIENT_COMBINED_BALANCE_DUE,
	AGENCY_ACCOUNT_BALANCE_DUE,
	OVERPAYMENT_AMOUNT,
	NET_OFFSET_ADJUSTMENT,
	ACCOUNT_ID,
	FORWARD_COMMISSION_OVERRIDE,
	ATTORNEY_COMMISSION_OVERRIDE,
	LEGAL_PHASE_TYPE_ID,
	REMIT_OVERPYMT_TO_CLIENT_DUP,
	TRANSACTION_UUID,
	ACCOUNT_UUID,
	MIG_SRC_ACCT_ID,
	MIG_SRC_TRAN_ID,
	TRUST_ACCOUNT_ID,
	BUSINESS_TRANSACTION_ID,
	POSTED_AS_DEFERRED,
	DEFERRED_CASH, 
	COMMISSION_FLAT_AMOUNT,
	CMSN_PERCENT
)
WITH CTE_AMT AS (
	SELECT 
		SOURCETRANSACTIONID ,  
		ACCOUNTID , 
		AFTREFFDTE,
		AFTRACCTDTE, 
		AFTRTYP ,
		AFSCOVERAMT ,
		TRN_AMT,
	CASE 
		WHEN DESCRIPTION IN ('PRNAPPLYAMT', 'PRNDUEAGENCY', 'PRNDUECLIENT') THEN PRN_PERCENT
		WHEN DESCRIPTION IN ('INTAPPLYAMT', 'INTDUEAGENCY', 'INTDUECLIENT' ) THEN INT_PERCENT
		WHEN DESCRIPTION IN ('LI3BALAPPLYAMT', 'LI3BALDUEAGENCY', 'LI3BALDUECLIENT' ) THEN LI3_PERCENT
		WHEN DESCRIPTION IN ('LI4BALAPPLYAMT', 'LI4BALDUEAGENCY', 'LI4BALDUECLIENT' ) THEN LI4_PERCENT
		WHEN DESCRIPTION IN ('AININTAPPLYAMT', 'AININTDUEAGENCY', 'AININTDUECLIENT' ) THEN AIN_PERCENT
	END AS CMSN_PERCENT,
	CASE 
		WHEN DESCRIPTION IN ('PRNAPPLYAMT', 'PRNDUEAGENCY', 'PRNDUECLIENT') THEN PRN_DEFERRED_CASH
		WHEN DESCRIPTION IN ('INTAPPLYAMT', 'INTDUEAGENCY', 'INTDUECLIENT' ) THEN INT_DEFERRED_CASH
		WHEN DESCRIPTION IN ('LI3BALAPPLYAMT', 'LI3BALDUEAGENCY', 'LI3BALDUECLIENT' ) THEN LI3_DEFERRED_CASH
		WHEN DESCRIPTION IN ('LI4BALAPPLYAMT', 'LI4BALDUEAGENCY', 'LI4BALDUECLIENT' ) THEN LI4_DEFERRED_CASH
		WHEN DESCRIPTION IN ('AININTAPPLYAMT', 'AININTDUEAGENCY', 'AININTDUECLIENT' ) THEN AIN_DEFERRED_CASH
	END AS DEFERRED_CASH,
	CASE 
		WHEN DESCRIPTION IN ('PRNAPPLYAMT', 'PRNDUEAGENCY', 'PRNDUECLIENT') THEN 'PRN'
		WHEN DESCRIPTION IN ('INTAPPLYAMT', 'INTDUEAGENCY', 'INTDUECLIENT' ) THEN 'INT'
		WHEN DESCRIPTION IN ('LI3BALAPPLYAMT', 'LI3BALDUEAGENCY', 'LI3BALDUECLIENT' ) THEN 'LI3'
		WHEN DESCRIPTION IN ('LI4BALAPPLYAMT', 'LI4BALDUEAGENCY', 'LI4BALDUECLIENT' ) THEN 'LI4'
		WHEN DESCRIPTION IN ('AININTAPPLYAMT', 'AININTDUEAGENCY', 'AININTDUECLIENT' ) THEN 'AIN'
	END AS DESCRIPTION,
	CASE 
		WHEN DESCRIPTION IN ('PRNAPPLYAMT', 'INTAPPLYAMT', 'LI3BALAPPLYAMT', 'LI4BALAPPLYAMT', 'AININTAPPLYAMT') THEN 330
		WHEN DESCRIPTION IN ('PRNDUEAGENCY', 'INTDUEAGENCY', 'LI3BALDUEAGENCY', 'LI4BALDUEAGENCY' , 'AININTDUEAGENCY') THEN 210
		WHEN DESCRIPTION IN ('PRNDUECLIENT', 'INTDUECLIENT', 'LI3BALDUECLIENT', 'LI4BALDUECLIENT' , 'AININTDUECLIENT') THEN 230
	END AS "TYPE"
	FROM ( 
		SELECT SOURCETRANSACTIONID , ACCOUNTID , AFTREFFDTE,AFTRACCTDTE, AFTRTYP ,AFSCOVERAMT,
			PRNAPPLYAMT , INTAPPLYAMT, LI3BALAPPLYAMT, LI4BALAPPLYAMT, AININTAPPLYAMT,
			PRNDUEAGENCY, INTDUEAGENCY, LI3BALDUEAGENCY, LI4BALDUEAGENCY , AININTDUEAGENCY,
			PRNAPPLYAMT - PRNDUEAGENCY AS PRNDUECLIENT, 
			INTAPPLYAMT - INTDUEAGENCY AS INTDUECLIENT, 
			LI3BALAPPLYAMT - LI3BALDUEAGENCY AS LI3BALDUECLIENT, 
			LI4BALAPPLYAMT - LI4BALDUEAGENCY AS LI4BALDUECLIENT, 
			AININTAPPLYAMT - AININTDUEAGENCY AS AININTDUECLIENT,
			PRNDUEAGENCY / NULLIF(PRNAPPLYAMT, 0) AS PRN_PERCENT,
			INTDUEAGENCY / NULLIF(INTAPPLYAMT, 0) AS INT_PERCENT,
			LI3BALDUEAGENCY / NULLIF(LI3BALAPPLYAMT, 0) AS LI3_PERCENT,
			LI4BALDUEAGENCY / NULLIF(LI4BALAPPLYAMT, 0) AS LI4_PERCENT,
			AININTDUEAGENCY / NULLIF(AININTAPPLYAMT, 0) AS AIN_PERCENT,
			PRNDUEAGENCY AS PRN_DEFERRED_CASH, 
			INTDUEAGENCY AS INT_DEFERRED_CASH, 
			LI3BALDUEAGENCY LI3_DEFERRED_CASH, 
			LI4BALDUEAGENCY LI4_DEFERRED_CASH, 
			AININTDUEAGENCY AIN_DEFERRED_CASH
		FROM ETL_OASIS_DATA_MIG_{PP_TenantName}.ETL_STG_TRAN_HIST STG	 
	)
	UNPIVOT 
	(  
		TRN_AMT
		FOR  DESCRIPTION
		IN ( PRNAPPLYAMT, INTAPPLYAMT, LI3BALAPPLYAMT, LI4BALAPPLYAMT, AININTAPPLYAMT, PRNDUEAGENCY, INTDUEAGENCY, LI3BALDUEAGENCY, LI4BALDUEAGENCY , AININTDUEAGENCY, PRNDUECLIENT, INTDUECLIENT, LI3BALDUECLIENT, LI4BALDUECLIENT , AININTDUECLIENT)	
	)
	WHERE AFTRTYP IN 
	(
		SELECT code 
		FROM COM_FINVI_OASIS_TRANSACTIONCODES_{PP_TenantName}.AJ_CORE_TRANSACTION_CODE TC
		WHERE TC.TRANSACTION_TYPE NOT IN ('Adjustment','Reversal')  
	)
), CTE_FINAL AS 
(
	SELECT SOURCETRANSACTIONID, TDT.TRANSACTION_ID AS BUSINESS_TRANSACTION_ID, ACCOUNTID , AFTREFFDTE,AFTRACCTDTE, AFTRTYP ,AFSCOVERAMT ,TRN_AMT, STG.DESCRIPTION, STG.TYPE , PAYMENT_ID, SYS_GUID() AS TRAN_UUID, STG.DEFERRED_CASH, STG.CMSN_PERCENT
	FROM CTE_AMT STG
	INNER JOIN COM_FINVI_OASIS_MACRO_ACCOUNT_{PP_TenantName}.T_DATA_TRANSACTION TDT 
		ON TDT.MIG_SRC_TRAN_ID = STG.SOURCETRANSACTIONID
		AND TDT.PAYMENT_ID IS NOT NULL 
		AND TDT.CHARGE_ITEM_ID IS NOT NULL 
	INNER JOIN COM_FINVI_OASIS_MACRO_ACCOUNT_{PP_TenantName}.T_DATA_CHARGE_ITEM TDCI 
		ON TDCI.CHARGE_ITEM_ID = TDT.CHARGE_ITEM_ID 
		AND TDCI.DESCRIPTION = STG.DESCRIPTION
	UNION
	SELECT SOURCETRANSACTIONID, TDT.TRANSACTION_ID AS BUSINESS_TRANSACTION_ID, ACCOUNTID , AFTREFFDTE, AFTRACCTDTE, AFTRTYP ,AFSCOVERAMT ,TRN_AMT, STG.DESCRIPTION, 220 AS TYPE , PAYMENT_ID, SYS_GUID() AS TRAN_UUID, STG.DEFERRED_CASH, STG.CMSN_PERCENT
	FROM CTE_AMT STG
	INNER JOIN COM_FINVI_OASIS_MACRO_ACCOUNT_{PP_TenantName}.T_DATA_TRANSACTION TDT 
		ON TDT.MIG_SRC_TRAN_ID = STG.SOURCETRANSACTIONID
		AND TDT.PAYMENT_ID IS NOT NULL 
		AND CHARGE_ITEM_ID IS NOT NULL 
	INNER JOIN COM_FINVI_OASIS_MACRO_ACCOUNT_{PP_TenantName}.T_DATA_CHARGE_ITEM TDCI 
		ON TDCI.CHARGE_ITEM_ID = TDT.CHARGE_ITEM_ID 
		AND TDCI.DESCRIPTION = STG.DESCRIPTION
	WHERE STG.TYPE = 210
)
SELECT 
	0 AS VERSION,
	SYSDATE CREATE_DATE,
	SYSDATE MODIFIED_ON,	
    (
		SELECT IDPUSERID 
		FROM COM_FINVI_OASIS_ACCOUNT_{PP_TenantName}.user_ 
		WHERE USERNAME = 'etlmigrationuser@finvi.com'
	) AS CREATE_BY,	
    (
		SELECT IDPUSERID 
		FROM COM_FINVI_OASIS_ACCOUNT_{PP_TenantName}.user_ 
		WHERE USERNAME = 'etlmigrationuser@finvi.com'
	) AS MODIFIED_BY,			
	TYPE,
	NULL AS CHARGE_ITEM_ID,
	TRN.TRN_AMT  ,
	CASE WHEN TRN.TYPE IN (210,230) THEN 1 ELSE 0 END AS CREDIT,
	TRN.AFTREFFDTE AS EFFECTIVE_DATE,
	0 AS REMIT_OVERPYMT_TO_CLIENT,
	TRN.PAYMENT_ID AS PAYMENT_ID,
	TRN.AFTRACCTDTE AS POSTED_DATE,
	0 AS SETTLEMENT_UNAPPROVED,
	NULL LINE_OF_BUSINESS,	
	NULL AS BUSINESS_CLASS,
	NULL AS WORKFLOW_STATUS,
	NULL AS CHARGE_ITEM_BALANCE_DUE,
	A.BALANCE AS ACCOUNT_BALANCE_DUE,				 
	A.BALANCE AS SHARED_ACCOUNT_BALANCE_DUE,
	0 AS CLIENT_ACCOUNT_BALANCE_DUE,
	A.BALANCE AS CLIENT_COMBINED_BALANCE_DUE,
	0 AS AGENCY_ACCOUNT_BALANCE_DUE,
	NULL AS OVERPAYMENT_AMOUNT,
	0 AS NET_OFFSET_ADJUSTMENT,
	TDA.ACCOUNT_ID AS ACCOUNT_ID,
	0 AS FORWARD_COMMISSION_OVERRIDE,
	0 AS ATTORNEY_COMMISSION_OVERRIDE,
	1 AS LEGAL_PHASE_TYPE_ID,
	'N' AS REMIT_OVERPYMT_TO_CLIENT_DUP,
	LOWER(SUBSTR(TRAN_UUID,1,8) || '-' || SUBSTR(TRAN_UUID,9,4) || '-' || SUBSTR(TRAN_UUID,13,4) || '-' || SUBSTR(TRAN_UUID,17,4) || '-' || SUBSTR(TRAN_UUID,21)) AS TRANSACTION_UUID,
	TDA.ACCOUNT_UUID AS ACCOUNT_UUID,	
	TRN.ACCOUNTID AS MIG_SRC_ACCT_ID,
	SOURCETRANSACTIONID AS MIG_SRC_TRAN_ID	, 
	NULL AS TRUST_ACCOUNT_ID,
	TRN.BUSINESS_TRANSACTION_ID,
	1 AS POSTED_AS_DEFERRED,
	CASE WHEN TYPE = 330 THEN DEFERRED_CASH ELSE NULL END AS DEFERRED_CASH, 
	NULL AS COMMISSION_FLAT_AMOUNT,
	CASE WHEN TYPE = 210 THEN CMSN_PERCENT ELSE NULL END AS CMSN_PERCENT
FROM CTE_FINAL TRN
INNER JOIN COM_FINVI_OASIS_ACCOUNT_{PP_TenantName}.ACCOUNT A 
	ON A.MIGRATION_SOURCE_ID = TRN.ACCOUNTID
INNER JOIN COM_FINVI_OASIS_MACRO_ACCOUNT_{PP_TenantName}.T_DATA_ACCOUNT TDA 
	ON A.MIGRATION_SOURCE_ID= TDA.MIG_SRC_ACCT_ID 
