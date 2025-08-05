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