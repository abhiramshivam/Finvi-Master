UPDATE COM_FINVI_OASIS_ACCOUNT_{PP_TenantName}.CUSTOMERCONTACTADDRESS
SET ADDRESSLINE1PARSED=ADDRESSLINE1PARSED||' '
WHERE  ltrim(rtrim(ADDRESSLINE1PARSED)) LIKE '% %'