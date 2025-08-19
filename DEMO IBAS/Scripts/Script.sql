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
 
 SELECT * FROM SUBSINITIALPAYMENT s 
 
 SELECT * FROM ARTYPEMASTER a 
 
 SELECT * FROM (SELECT a.*, ROWNUM AS RNUM FROM (SELECT * FROM (SELECT 
                        sysTransactionParam.tranTypeName,
                        arTypeMaster.arTypeName,
                        subsInitialPayment.tranNo,
                        subsInitialPayment.tranDate,
                        subsInitialPayment.priority,
                        subsInitialPayment.amount,
                        subsInitialPayment.paidAmt,
                        subsInitialPayment.processed,
                        subsInitialPayment.cancelled
                 FROM subsInitialPayment JOIN arTypeMaster 
                        ON arTypeMaster.arTypeCode = subsInitialPayment.arTypeCode 
                        AND arTypeMaster.divisionCode = subsInitialPayment.divisionCode 
                        AND arTypeMaster.companyCode = subsInitialPayment.companyCode JOIN sysTransactionParam       
                        ON sysTransactionParam.tranTypeCode = subsInitialPayment.tranTypeCode 
                        AND sysTransactionParam.divisionCode = subsInitialPayment.divisionCode 
                        AND sysTransactionParam.companyCode = subsInitialPayment.companyCode 
                 WHERE subsInitialPayment.acctNo = '168550' AND subsInitialPayment.companyCode = 'COMCL'
                 AND subsInitialPayment.divisionCode = 'ISG' ORDER BY subsInitialPayment.tranDate ASC) s) a  WHERE ROWNUM <= 10) WHERE RNUM > 0
                 
                 
                 SELECT processed, SUM(amount) AS amount, SUM(paidamt) AS paid_amt FROM subsInitialPayment JOIN arTypeMaster
                        ON arTypeMaster.arTypeCode = subsInitialPayment.arTypeCode
                        AND arTypeMaster.divisionCode = subsInitialPayment.divisionCode
                        AND arTypeMaster.companyCode = subsInitialPayment.companyCode JOIN sysTransactionParam       
                        ON sysTransactionParam.tranTypeCode = subsInitialPayment.tranTypeCode
                        AND sysTransactionParam.divisionCode = subsInitialPayment.divisionCode
                        AND sysTransactionParam.companyCode = subsInitialPayment.companyCode 
                        WHERE subsInitialPayment.acctNo = '168550' AND subsInitialPayment.companyCode = 'COMCL'
                        AND subsInitialPayment.divisionCode = 'ISG'
                        GROUP BY processed
                        --ORDER BY subsInitialPayment.TRANDATE  ASC
                        
                        
  SELECT itemMaster.itemcode ,
       itemmaster.itemname ,
       serialNoMaster.controlno ,
       subscriberCPEMaster.serialno ,
       subscriberCPEMaster.macaddress ,
       itemMaster.price ,
       subscriberCPEMaster.dateadd ,
       subscriberCPEMaster.useradd,
	  subscriberCPEMaster.cpestatuscode,
	  subscriberCPEMaster.acctno,
	  subscriberCPEMaster.divisionCode,
	  subscriberCPEMaster.companyCode,
	  ' ' packageName,
	  ' 'isPrimary, '' SELECTED,
case when subscriberCPEMaster.itemcode in (select item_code from warranty_months) then 
  case when add_months(subscriberCPEMaster.dateacquired ,(select no_of_months from warranty_months where rownum < 2)) > sysdate then 
    'Y' 
  else 
    'N' end 
  else 
   null 
  end in_warranty
  FROM itemmaster,
       subscriberCPEMaster,
       serialNoMaster
WHERE  itemMaster.itemCode = subscriberCPEMaster.itemCode and
       serialNoMaster.itemCode = subscriberCPEMaster.itemCode and
		 serialNoMaster.serialNo = subscriberCPEMaster.serialNo and 
    ( itemmaster.companyCode = subscriberCPEMaster.companyCode )
AND ( serialNoMaster.divisionCode = subscriberCPEMaster.divisionCode )
AND ( serialNoMaster.companyCode = subscriberCPEMaster.companyCode )
AND ( subscriberCPEMaster.acctno = '038184' ) 
AND ( subscriberCPEMaster.divisionCode = 'ISG' )
AND ( subscriberCPEMaster.companyCode = 'COMCL' ) 


SELECT * FROM (SELECT a.*, ROWNUM AS RNUM FROM (SELECT * FROM (SELECT * FROM (SELECT
                        itemMaster.itemcode as ITEMCODE,
                        itemMaster.itemname as ITEMNAME,
                        serialNoMaster.controlno as CONTROLNO,
                        subscriberCPEMaster.serialno as SERIALNO,
                        subscriberCPEMaster.macaddress as MACADDRESS,
                        itemMaster.price as PRICE,
                        subscriberCPEMaster.dateadd as DATEADD,
                        subscriberCPEMaster.useradd as USERADD,
                        subscriberCPEMaster.cpestatuscode as CPESTATUSCODE,
                        COALESCE(
                                (SELECT b.packageName
                                 FROM arPackageMaster b
                                 WHERE b.packageCode = subscriberCPEMaster.packageCode
                                   AND b.divisionCode = subscriberCPEMaster.divisionCode),
                                (SELECT a.packageName
                                 FROM arAcctSubscriber s
                                 JOIN arPackageMaster a
                                   ON a.packageCode = s.packageCode AND a.divisionCode = s.divisionCode
                                 WHERE s.acctNo = ? AND s.divisionCode = ? AND s.companyCode = ?)
                        ) AS PACKAGENAME,
                        '' as ISPRIMARY,
                        '' as SELECTED,
                        CASE
                                WHEN subscriberCPEMaster.itemcode IN (SELECT item_code FROM warranty_months)
                                THEN CASE
                                        WHEN ADD_MONTHS(subscriberCPEMaster.dateacquired,(SELECT no_of_months FROM warranty_months WHERE ROWNUM < 2)) > SYSDATE
                                        THEN 'Y' ELSE 'N' END
                                ELSE NULL END as IN_WARRANTY
                 FROM subscriberCPEMaster JOIN itemMaster
                        ON itemMaster.itemCode = subscriberCPEMaster.itemCode
                        AND itemMaster.companyCode = subscriberCPEMaster.companyCode JOIN serialNoMaster
                        ON serialNoMaster.itemCode = subscriberCPEMaster.itemCode
                        AND serialNoMaster.serialNo = subscriberCPEMaster.serialNo
                        AND serialNoMaster.divisionCode = subscriberCPEMaster.divisionCode
                        AND serialNoMaster.companyCode = subscriberCPEMaster.companyCode WHERE subscriberCPEMaster.acctNo = '038184' AND subscriberCPEMaster.divisionCode = 'ISG' AND subscriberCPEMaster.companyCode = 'COMCL') UNION ALL (SELECT
                        itemMaster.itemcode as ITEMCODE,
                        itemMaster.itemname as ITEMNAME,
                        serialNoMaster.controlno as CONTROLNO,
                        serialNoMaster.serialno as SERIALNO,
                        serialNoMaster.macaddress as MACADDRESS,
                        itemMaster.price as PRICE,
                        joTranDtlAssignedCPE.lastAssignedDate as DATEADD,
                        joTranDtlAssignedCPE.lastAssignedBy as USERADD,
                        '' as CPESTATUSCODE,
                        '' as PACKAGENAME,
                        '' as ISPRIMARY,
                        '' as SELECTED,
                        '' as IN_WARRANTY
                 FROM joTranDtlAssignedCPE JOIN joTranHdr
                        ON joTranDtlAssignedCPE.joNo = joTranHdr.joNo
                        AND joTranDtlAssignedCPE.divisionCode = joTranHdr.divisionCode
                        AND joTranDtlAssignedCPE.companyCode = joTranHdr.companyCode JOIN serialNoMaster
                        ON joTranDtlAssignedCPE.serialno = serialNoMaster.serialno
                        AND joTranDtlAssignedCPE.macAddress = serialNoMaster.macAddress
                        AND joTranDtlAssignedCPE.divisionCode = serialNoMaster.divisionCode
                        AND joTranDtlAssignedCPE.companyCode = serialNoMaster.companyCode JOIN itemMaster
                        ON itemMaster.itemCode = serialNoMaster.itemCode
                        AND serialNoMaster.companyCode = itemMaster.companyCode WHERE joTranHdr.acctNo = '038184' AND joTranDtlAssignedCPE.divisionCode = 'ISG' AND joTranDtlAssignedCPE.companyCode = 'COMCL' AND serialNoMaster.serialNoStatusCode = 'PA')) s) a  WHERE ROWNUM <= 10) WHERE RNUM > 0