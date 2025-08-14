SELECT  collectiontranhdr.tranno ,
           collectiontranhdr.trandate ,
           collectiontranhdr.companyCode,
           collectiontranhdr.acctno ,
           collectiontranhdr.documenttypecode ,
           collectiontranhdr.receiptno ,
           collectiontranhdr.refno ,
           collectiontranhdr.amount ,
           collectiontranhdr.paymenttypecode ,
           collectiontranhdr.checkno ,
           collectiontranhdr.checkdate ,
           collectiontranhdr.bankcode ,
           collectiontranhdr.checkstatuscode ,
           collectiontranhdr.checkStanding ,
           collectiontranhdr.paymentstatus ,
           collectiontranhdr.trantypecode ,
           collectiontranhdr.collectorcode ,
           collectiontranhdr.workstationcode ,
           arAcctSubscriber.subscribername,     
		collectiontranhdr.trancurrencyCode,
		collectiontranhdr.universal_or,
		collectiontranhdr.refnotype,
		collectiontranhdr.universal_ar
        FROM collectiontranhdr ,
           arAcctSubscriber     
        WHERE ( collectiontranhdr.acctno = arAcctSubscriber.acctno )
		  and ( arAcctSubscriber.divisionCode = collectiontranhdr.divisionCode )
		  and ( arAcctSubscriber.companyCode = collectiontranhdr.companyCode )
		  and ( collectiontranhdr.divisionCode = 'NCRNT' )
        --and  ( collectiontranhdr.companyCode = 'NCRT' )  
		  and  ( collectiontranhdr.acctno = '001205' )  ;
        
        
   SELECT * FROM ARACCTSUBSCRIBER a WHERE a.OLDACCTNO  = '001205'  
   
    SELECT * FROM (
                SELECT a.*, ROWNUM rnum FROM (
                        SELECT
                                ct.TRANNO,
                                ct.TRANDATE,
                                ct.ACCTNO,
                                ct.DOCUMENTTYPECODE,
                                ct.RECEIPTNO,
                                ct.REFNO,
                                ct.AMOUNT,
                                ct.PAYMENTTYPECODE,
                                ct.CHECKNO,
                                ct.CHECKDATE,
                                ct.BANKCODE,
                                ct.CHECKSTATUSCODE,
                                ct.CHECKSTANDING,
                                ct.PAYMENTSTATUS,
                                ct.TRANTYPECODE,
                                ct.COLLECTORCODE,
                                ct.WORKSTATIONCODE,
                                s.SUBSCRIBERNAME,
                                ct.TRANCURRENCYCODE,
                                ct.UNIVERSAL_OR,
                                ct.REFNOTYPE,
                                ct.UNIVERSAL_AR,
                                ct.AMOUNT_PSF,
                                ct.AMOUNT_WHT,
                                ct.AMOUNT_WHTV,
                                ct.AMOUNT_VAT,
                                CASE
                                        WHEN ct.AMOUNT - (ct.AMOUNT_WHT + ct.AMOUNT_WHTV) < 0 THEN 0.00
                                        ELSE ct.AMOUNT - (ct.AMOUNT_WHT + ct.AMOUNT_WHTV)
                                END AS AMOUNT_PAID
                        FROM collectiontranhdr ct
                        JOIN arAcctSubscriber s
                                ON ct.ACCTNO = s.ACCTNO
                                AND ct.DIVISIONCODE = s.DIVISIONCODE
                                AND ct.COMPANYCODE = s.COMPANYCODE
                        WHERE ct.DIVISIONCODE = 'ISG'
                                AND ct.COMPANYCODE = 'COMCL'
                                AND ct.ACCTNO = '168550'
                        ORDER BY ct.TRANDATE DESC
                ) a WHERE ROWNUM <= 10
        ) WHERE rnum > 0
        
        
        
        SELECT * FROM COLLECTIONTRANHDR ct WHERE ct.DIVISIONCODE = 'ISG'
                                AND ct.COMPANYCODE = 'COMCL'
                                AND ct.ACCTNO = '168550' ORDER BY ct.TRANDATE DESC
                                
                                
                                
        SELECT COUNT(*)
        FROM artranhdr
        LEFT OUTER JOIN systransactionparam
                ON systransactionparam.tranTypeCode = arTranHdr.trantypecode
                AND systransactionparam.divisionCode = arTranHdr.divisionCode
                AND systransactionparam.companyCode = arTranHdr.companyCode
        LEFT OUTER JOIN artypemaster
                ON arTypeMaster.arTypeCode = arTranHdr.arTypeCode
                AND arTypeMaster.divisionCode = arTranHdr.divisionCode
                AND arTypeMaster.companyCode = arTranHdr.companyCode
        WHERE artranhdr.acctno = '168550'
                AND arTranHdr.divisionCode = 'ISG'
                AND arTranHdr.companyCode = 'COMCL'
                AND (artranhdr.balance <> 0 OR ? = 'Y')