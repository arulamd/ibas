SELECT * FROM GL WHERE TRANTYPECODE ='JO'



select custom_hash('pardo') FROM DUAL;


SELECT u.PASSWORD, 
	(SELECT custom_hash('pardo') FROM dual)
	FROM USERMASTER u WHERE u.USERNAME = 'PARDO'

UPDATE USERMASTER
SET PASSWORD = (select custom_hash('???') FROM dual)
WHERE USERNAME = '????'


SELECT * FROM AGENTMASTER a WHERE a.AGENTCODE ='AGT001'

SELECT * FROM COLLECTORMASTER c WHERE c.DIVISIONCODE ='ISG' AND c.COMPANYCODE = 'COMCL'

SELECT COLLECTORCODE, COLLECTORNAME, COLLECTORTYPECODE,
                                      ACTIVE,PRINTDOCUMENT,COMPANYCODE, DIVISIONCODE
                          FROM COLLECTORMASTER
                          WHERE COLLECTORCODE = '88001' AND COMPANYCODE = 'COMCL' AND DIVISIONCODE = 'NCRNT'
  SELECT  collectorTypeMaster.collectorTypeName ,           collectorTypeMaster.collectorTypeCode     FROM collectorTypeMaster    

SELECT  collectiontranhdr.tranno ,
		  collectiontranhdr.trandate ,
		  collectiontranhdr.acctno ,
		  collectiontranhdr.documenttypecode ,
		  collectiontranhdr.receiptno ,
		  collectiontranhdr.refnotype ,
		  collectiontranhdr.refno ,
		  collectiontranhdr.checkno ,
		  collectiontranhdr.checkdate ,
		  collectiontranhdr.checkstatuscode ,
		  collectiontranhdr.bankCode ,

		  collectiontranhdr.amount ,

		  collectiontranhdr.acctCurrencyCode,
		  collectiontranhdr.acctConversionRate,

		  collectiontranhdr.tranCurrencyCode,
		  collectiontranhdr.tranConversionRate,

		  collectiontranhdr.acctBasedAmount,

		  collectiontranhdr.collectorcode ,
		  ''collectorName,
		  collectiontranhdr.tranTypeCode,
		  collectiontranhdr.paymenttypecode ,
		  collectiontranhdr.paymentstatus ,
		  collectiontranhdr.workstationcode ,
		  collectiontranhdr.workStationLocationCode ,
		  collectiontranhdr.useradd ,
		  collectiontranhdr.dateadd ,
		 collectiontranhdr.card_payment_type ,
		collectiontranhdr.auth_code ,
	     '' acctName,
		  '' acctAddress,
			'' subscriberStatusName,
        0.000000000000000000000000 c_remaining,
		  0.00 originalAmountTendered,
		  0.00 collectorFee	,
		collectiontranhdr.remarks,
		'' telNo,
		'' contactNo,
		'' mobileNo,
		getDate() dateInstalled,
		getDate() lastInfoUpdate
   FROM collectiontranhdr
  WHERE 1=2	
  
  select *  
  from currencyMaster
 where currencyCode = :as_currencyCode
 
 
 SELECT * FROM SYSTRANSACTIONPARAM s 
