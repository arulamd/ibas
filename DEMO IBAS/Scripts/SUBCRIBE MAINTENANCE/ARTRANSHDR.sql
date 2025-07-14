SELECT artranhdr.tranno,   
	artranhdr.trantypecode,   
	artranhdr.artypecode,   
	artranhdr.trandate,   
	artranhdr.acctno,   
	artranhdr.amount,   
	artranhdr.paidamt,   
	artranhdr.balance,   
	artranhdr.remarks,
	systransactionparam.trantypename,
	artypemaster.artypename,
	artypemaster.priority,
	to_char(arTranHdr.periodFrom,'MON/DD/YYYY') || ' to ' || to_char(arTranHdr.periodTo,'MON/DD/YYYY') as coverage,
	arTranHdr.periodFrom,
	arTranHdr.periodTo
FROM artranhdr left outer join systransactionparam on systransactionparam.tranTypeCode = arTranHdr.trantypecode 
               and  systransactionparam.divisionCode = arTranHdr.divisionCode 
	 				and  systransactionparam.companyCode = arTranHdr.companyCode 
left outer join artypemaster on arTypeMaster.arTypeCode = arTranHdr.arTypeCode  
			      and  arTypeMaster.divisionCode = arTranHdr.divisionCode
					and  arTypeMaster.companyCode = arTranHdr.companyCode 	      
WHERE artranhdr.acctno = '039475'
AND   arTranHdr.divisionCode = 'ISG'
--AND   arTranHdr.companyCode = :as_companyCode
AND (artranhdr.balance <> 0 )
