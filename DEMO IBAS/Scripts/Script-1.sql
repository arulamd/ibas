    Select A.Currencycode,
			  a.acctNo,
        A.Acctname,  
        C.Tranno,
        C.Trantypecode,
        C.Artypecode,
        C.Remarks,
        C.Trandate,
        a.contactNo,
        P.Packagename,
         sum(c.currentdue),   
         sum(c.over30),   
         sum(c.over60),   
         Sum(C.Over90),   
         Sum(C.Over120),
         Sum(C.Over150),
         Sum(C.Over180),
         Sum(C.Over210),
         Sum(C.Over240),
         Sum(C.Over270),
         Sum(C.Over300),
         Sum(C.Over330),
         sum(c.over365),
         sum(c.over730),
         Sum(C.Over1095),
		c.morethan3yrs,
         dt.tranDate,
         dt.amount,
		trunc(sysdate) - TRUNC(c.trandate) noOfDays	
    From Araccountmaster A 
inner join vw_arAgingDetailedPerAcct2 c on c.acctNo = a.acctNo 
				and c.divisionCode = a.divisionCode and c.companyCode = a.companyCode				
inner join arAcctSubscriber s on s.acctNo = a.acctNo 
				and s.divisionCode = a.divisionCode and s.companyCode = a.companyCode
left join arPackageMaster p on p.packagecode = s.packageCode
				and p.divisionCode = s.divisionCode and p.companyCode = s.companyCode
left join   ( select dt1.acctNo, dt1.trandate, dt1.amount, dt1.divisionCode, dt1.companyCode
                       		 from collectionTranHdr dt1 inner join
															( select  acctNo, divisionCode, companyCode, max(tranNo) as maxTranNo 
															 from collectionTRanHdr
															 group by acctNo, divisionCode, companyCode ) dt2 on dt1.tranNo = dt2.maxTranNo  
																															and dt1.divisionCode = dt2.divisionCode ) dt on dt.acctNo = a.acctNo
                                                                                                                          and dt.divisionCode = a.divisionCode
                                                                                                                          and dt.companycode = a.companycode
WHERE s.divisionCode = 'NLZNT' --AND s.companyCode = 'COMCL'
      and a.acctNo = '331626'
group by a.currencyCode,
			a.acctNo,
         A.Acctname,  
        C.Tranno,
        C.Trantypecode,
        C.Artypecode,
        C.Remarks,
        C.Trandate,
         a.contactNo,
	p.packageName,
	c.morethan3yrs,
		 dt.tranDate,
         dt.amount,
	 trunc(sysdate) - TRUNC(c.trandate)