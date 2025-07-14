SELECT  collectiontranhdr.tranno ,
		collectiontranhdr.companyCode,
           collectiontranhdr.trandate ,
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
		collectiontranhdr.universal_ar,
		collectiontranhdr.amount_psf,
		collectiontranhdr.amount_wht,
		collectiontranhdr.amount_whtv,
		collectiontranhdr.amount_vat,
		case when collectiontranhdr.amount - (collectiontranhdr.amount_wht + collectiontranhdr.amount_whtv)  < 0 then 0.00 
			   when collectiontranhdr.amount - (collectiontranhdr.amount_wht + collectiontranhdr.amount_whtv)  > 0 then collectiontranhdr.amount - (collectiontranhdr.amount_wht + collectiontranhdr.amount_whtv) 
			  end as amount_paid
        FROM collectiontranhdr ,
           arAcctSubscriber     
        WHERE ( collectiontranhdr.acctno = arAcctSubscriber.acctno )
		  and ( arAcctSubscriber.divisionCode = collectiontranhdr.divisionCode )
		  and ( arAcctSubscriber.companyCode = collectiontranhdr.companyCode )
		 and ( collectiontranhdr.divisionCode = 'NLZNT' )
        --and  ( collectiontranhdr.companyCode = :as_company )  
		  and  ( collectiontranhdr.acctno = '331626' ) 
        
        
       