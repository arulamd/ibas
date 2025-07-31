--QUERY SEARCH ACCTNO
--WHEN OPEN MENU SUBRCIBER MAINTENANCE CORPORATE , CLICK BUTTON SUEARCH TO FIND ACCTNO

--THIS IS QUERY TO FIND ACCTNO
SELECT arAcctSubscriber.acctno,   
		arAcctSubscriber.subscribername,   
		w.contactNo,   
		w.municipalitycode,   
		arAcctSubscriber.packagecode,
		arPackageMaster.packageName,
		arAcctSubscriber.subscriberstatuscode,   
		w. completeAddress serviceaddresscomplete  
 FROM arAcctSubscriber  
 inner join vw_arAcctAddress w on arAcctSubscriber.acctNo = w.acctNo  and w.addressTypeCode = 'SERVADR1'
        and arAcctSubscriber.divisionCode = w.divisionCode 
        and arAcctSubscriber.companyCode = w.companyCode
inner join arPackageMaster  on  arPackageMaster.packageCode = arAcctSubscriber.packageCode
            and arPackageMaster.divisionCode = arAcctSubscriber.divisionCode
            and arPackageMaster.companyCode = arAcctSubscriber.companyCode

--KEY IN THE ACCTNO THEN CLICK BUTTON SEARCH
String s_search, ls_searchBy
 	
integer li_kawnt

s_search = trim(sle_search.text)
s_search = trim(s_search)

ls_searchBy = ddlb_searchby.text

string ls_select, ls_where, ls_retrieve

if pos(s_OriginalSelect,'WHERE') > 0 then
	ls_where = " AND arAcctSubscriber." + ls_searchBy + " LIKE '%"+s_search+"%'" +  " AND arAcctSubscriber.divisionCode = '"+gs_divisionCode+"'"  +  " AND arAcctSubscriber.companyCode = '"+gs_companyCode+"'"
else	
	ls_where = " WHERE arAcctSubscriber." + ls_searchBy + " LIKE '%"+s_search+"%'" + " AND arAcctSubscriber.divisionCode = '"+gs_divisionCode+"'"  +  " AND arAcctSubscriber.companyCode = '"+gs_companyCode+"'"
end if	

dw_1.modify('DataWindow.Table.Select ="' +s_OriginalSelect+ls_where+'"')

if len(s_search) > 1 then
	if dw_1.retrieve(s_search) > 0 then
		dw_1.setfocus()
		pb_3.default = TRUE
	end if	
elseif len(s_search) <> 0 then
	guo_func.msgbox('SM-0000025')
end IF

--QUERY WILL FIND OUT THE DATA BASE ON TYPE DROWDOWN,AFTER DATA APPEAR CLICK SELECT , THE DATA WILL SHOW ALL TAB

if is_acctNo <> '' then
	
	il_clicked = 1
	is_alldates = 'Y'
	
	tab_1.tp_subsInfo.dw_info.Reset()
	tab_1.tp_subsInfo.dw_info.Retrieve(is_acctNo, gs_divisionCode, gs_companyCode)
	wf_enabledisable_buttons('search, retrieveall, close')
	
	f_displayStatus('Retrieving...')
	
	tab_1.tp_payments.dw_payments.enabled = true
	tab_1.tp_payments.dw_payments.retrieve(is_acctNo, gs_divisionCode, gs_companyCode)

	tab_1.tp_arbalance.dw_arbalance.retrieve(trim(is_acctNo), is_displayZeroBal, gs_divisionCode, gs_companyCode)

	tab_1.tp_advances.dw_op.retrieve(is_acctNo, is_displayZeroBalAdv, gs_divisionCode, gs_companyCode)

	tab_1.tp_depLedger.dw_deposit.retrieve(is_acctNo, gs_divisionCode, gs_companyCode)
	computeBalanceDRCR(tab_1.tp_depLedger.dw_deposit, 'CR')

	tab_1.tp_incLedger.dw_incentives.retrieve(is_acctNo, gs_divisionCode, gs_companyCode)	
	computeBalanceDRCR(tab_1.tp_incLedger.dw_incentives, 'CR')

	tab_1.tp_eqDepLedger.dw_equipmentdeposit.retrieve(is_acctNo, gs_divisionCode, gs_companyCode)	
	computeBalanceDRCR(tab_1.tp_eqDepLedger.dw_equipmentdeposit, 'CR')

	tab_1.tp_subscriberTransaction.dw_subscriberTransaction.reset()
	tab_1.tp_subscriberTransaction.dw_trantype.reset()
	tab_1.tp_subscriberTransaction.dw_trantype.retrieve(gs_companyCode)
	
	dataWindowChild dwc_1
   tab_1.tp_subscriberTransaction.dw_trantype.getChild('trantypeCode',dwc_1)
   dwc_1.setTransObject(SQLCA)
   dwc_1.retrieve(gs_companyCode, gs_divisionCode)

	tab_1.tp_unprocesstrans.dw_unproctrans.Retrieve(is_acctNo, gs_divisionCode, gs_companyCode)
	tab_1.tp_initialPayment.dw_subsinitialPayment.Retrieve(is_acctNo, gs_divisionCode, gs_companyCode)
	
	select isPrintComclark, isPrintConverge, isPrintSME into :ls_isPrintComckark, :ls_isPrintConverge, :ls_isPrintSME
	from arAcctSubscriber
	where acctNo = :is_acctNo
	and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	using SQLCA;
	if SQLCA.SQLCode <> 0 then
		guo_func.msgbox('Error!', 'Error while selecting values from table arAcctSubscriber.. ' + SQLCA.SQLErrText)
		return 
	end if
	
if ls_isPrintComckark = 'Y' then 
		
	tab_1.tp_soa.dw_soa.dataObject = 'dw_statement_of_acct_bsg2'
	tab_1.tp_soa.dw_soa.setTransObject(SQLCA);
	tab_1.tp_soa.dw_soa.Object.DataWindow.Print.Preview="yes"
	tab_1.tp_soa.dw_soa.Object.DataWindow.Print.Preview.Rulers="yes"
	
	--QUERY DW_STATEMENT_OF_ACCT_BSG2
	
	SELECT  arTranHdr.tranTypeCode ,
           arTranHdr.tranNo ,
           arTranHdr.arTypeCode ,
           arTranHdr.tranDate ,
           arTranHdr.balance ,
           arTranHdr.remarks ,
			  arTranHdr.periodFrom,
			  arTranHdr.periodTo,
           arTypeMaster.arTypeName ,
           arAcctSubscriber.subscriberName ,
           vw_arAcctAddress.completeAddress ,
           arAcctSubscriber.acctNo ,
           subsUserTypeMaster.subsUserTypeName,
           arPackageMaster.packageName ,
           arPackageMaster.packageDescription,
           chargeTypeMaster.chargeTypeName ,
           vw_arAcctAddress.contactNo ,
           vw_arAcctAddress.floorNo ,
           vw_arAcctAddress.bldgName ,
           vw_arAcctAddress.streetName ,
           vw_arAcctAddress.subdivisionCode ,
           vw_arAcctAddress.barangayCode ,
           arAcctSubscriber.mLineCurrentMonthlyRate currentMontlyRate,
           provinceMaster.provinceName ,
           municipalityMaster.municipalityName ,
           barangayMaster.barangayName ,
           subdivisionMaster.subdivisionName ,
           arTranHdr.balance totalDueNgeni ,
           arTranHdr.balance totalDueDati ,
           arAcctSubscriber.billingMinimumDue,
           A.completeAddress siteA, B.completeAddress siteB, vw_arAcctAddress.contactName,
           upper(arAccountMaster.currencyCode) currencyCode, subscriberCirCuitId.circuitID,
		  arAcctSubscriber.acctno||'-'||to_char(getdate(),'MM')||to_char(getdate(),'YY') as reference,
			  systemParameter.companyID,
			  systemParameter.divisionPrefix,
			  systemParameter.serviceCode
        FROM arTranHdr
           inner join arAcctSubscriber		on arTranHdr.acctNo = arAcctSubscriber.acctNo 
					and arTranHdr.divisionCode = arAcctSubscriber.divisionCode
               and arTranHdr.companyCode  = arAcctSubscriber.companyCode
		  	  inner join arTypeMaster 			on arTranHdr.arTypeCode = arTypeMaster.arTypeCode
			  		and arTranHdr.divisionCode = arTypeMaster.divisionCode
               and arTranHdr.companyCode  = arTypeMaster.companyCode
		  	  inner join vw_arAcctAddress 	on arTranHdr.acctNo = vw_arAcctAddress.acctNo and vw_arAcctAddress.addressTypeCode = 'BILLING'
			  		and arTranHdr.divisionCode = vw_arAcctAddress.divisionCode
               and arTranHdr.companyCode  = vw_arAcctAddress.companyCode
		  	  inner join vw_arAcctAddress  A	on arTranHdr.acctNo = A.acctNo and A.addressTypeCode = 'SERVADR1'
			  		and arTranHdr.divisionCode = a.divisionCode
               and arTranHdr.companyCode  = a.companyCode
		  	  left join vw_arAcctAddress  B	on arTranHdr.acctNo = B.acctNo and B.addressTypeCode = 'SERVADR2'
			  		and arTranHdr.divisionCode = b.divisionCode
               and arTranHdr.companyCode  = b.companyCode
		  	  inner join arPackageMaster 		on arAcctSubscriber.packageCode = arPackageMaster.packageCode
			  		and arPackageMaster.divisionCode = arAcctSubscriber.divisionCode
               and arPackageMaster.companyCode  = arAcctSubscriber.companyCode
		  	  inner join chargeTypeMaster 	on arAcctSubscriber.chargeTypeCode = chargeTypeMaster.chargeTypeCode
			  inner join provinceMaster 		on vw_arAcctAddress.provinceCode = provinceMaster.provinceCode
			  inner join municipalityMaster 	on vw_arAcctAddress.municipalityCode = municipalityMaster.municipalityCode
			  inner join barangayMaster 		on vw_arAcctAddress.barangayCode = barangayMaster.barangayCode
			  left  join subdivisionMaster 	on vw_arAcctAddress.subdivisionCode = subdivisionMaster.subdivisionCode
			  inner join subsUserTypeMaster  on arAcctSubscriber.subsUserTypeCode = subsUserTypeMaster.subsUserTypeCode
			 inner join systemParameter	 	on systemparameter.divisionCode = arTranHdr.divisionCode 
					and systemParameter.companyCode = arTranHdr.companyCode
           inner join arAccountMaster     on arAcctSubscriber.acctNo = arAccountMaster.acctNo
           		and arAccountMaster.divisionCode = arAcctSubscriber.divisionCode
               and arAccountMaster.companyCode  = arAcctSubscriber.companyCode
		  	  inner join joTranHdr           on arAcctSubscriber.acctNo = joTranHdr.acctNo  and joTranHdr.tranTypeCode = 'APPLYML'
				and jotranhdr.jostatuscode = 'CL'
           		and joTranHdr.divisionCode = arAcctSubscriber.divisionCode
               and joTranHdr.companyCode  = arAcctSubscriber.companyCode
		  	  left join subscriberCircuitID on arAccountMaster.acctNo = subscriberCircuitID.acctNo
		 			and arAccountMaster.divisionCode = subscriberCircuitID.divisionCode
               and arAccountMaster.companyCode  = subscriberCircuitID.companyCode
		  	  WHERE ( arTranHdr.balance > 0) and (arAcctSubscriber.acctNo = :as_acctNo) and (arTranHdr.divisionCode = :as_division) and (arTranHdr.companyCode = :as_company)
					and ((month(arTranHdr.tranDate) = :ai_month and year(arTranHdr.tranDate) = :ai_year) or :as_allDates = 'Y') and (arAcctSubscriber.isPrintComclark = 'Y')
	
	--END
	
	elseif ls_isPrintConverge = 'Y' then 
		
	tab_1.tp_soa.dw_soa.dataObject = 'dw_statement_of_acct_bsg_converge'
	tab_1.tp_soa.dw_soa.setTransObject(SQLCA);
	tab_1.tp_soa.dw_soa.Object.DataWindow.Print.Preview="yes"
	tab_1.tp_soa.dw_soa.Object.DataWindow.Print.Preview.Rulers="yes"
	
	--QUERY dw_statement_of_acct_bsg_converge
		SELECT  arTranHdr.tranTypeCode ,
           arTranHdr.tranNo ,
           arTranHdr.arTypeCode ,
           arTranHdr.tranDate ,
           arTranHdr.balance ,
           arTranHdr.remarks ,
			  arTranHdr.periodFrom,
			  arTranHdr.periodTo,
           arTypeMaster.arTypeName ,
           arAcctSubscriber.subscriberName ,
           vw_arAcctAddress.completeAddress ,
           arAcctSubscriber.acctNo ,
           subsUserTypeMaster.subsUserTypeName,
           arPackageMaster.packageName ,
           arPackageMaster.packageDescription,
           chargeTypeMaster.chargeTypeName ,
           vw_arAcctAddress.contactNo ,
           vw_arAcctAddress.floorNo ,
           vw_arAcctAddress.bldgName ,
           vw_arAcctAddress.streetName ,
           vw_arAcctAddress.subdivisionCode ,
           vw_arAcctAddress.barangayCode ,
           arAcctSubscriber.mLineCurrentMonthlyRate currentMontlyRate,
           provinceMaster.provinceName ,
           municipalityMaster.municipalityName ,
           barangayMaster.barangayName ,
           subdivisionMaster.subdivisionName ,
           arTranHdr.balance totalDueNgeni ,
           arTranHdr.balance totalDueDati ,
           arAcctSubscriber.billingMinimumDue,
           A.completeAddress siteA, B.completeAddress siteB, vw_arAcctAddress.contactName,
           upper(arAccountMaster.currencyCode) currencyCode, subscriberCirCuitId.circuitID,
		  arAcctSubscriber.acctno||'-'||to_char(getdate(),'MM')||to_char(getdate(),'YY') as reference,
			  systemParameter.companyID,
			  systemParameter.divisionPrefix,
			  systemParameter.serviceCode,
			b.contactno,
             arAcctSubscriber.mobileno
        FROM arTranHdr
           inner join arAcctSubscriber		on arTranHdr.acctNo = arAcctSubscriber.acctNo 
					and arTranHdr.divisionCode = arAcctSubscriber.divisionCode
               and arTranHdr.companyCode  = arAcctSubscriber.companyCode
		  	  inner join arTypeMaster 			on arTranHdr.arTypeCode = arTypeMaster.arTypeCode
			  		and arTranHdr.divisionCode = arTypeMaster.divisionCode
               and arTranHdr.companyCode  = arTypeMaster.companyCode
		  	  inner join vw_arAcctAddress 	on arTranHdr.acctNo = vw_arAcctAddress.acctNo and vw_arAcctAddress.addressTypeCode = 'BILLING'
			  		and arTranHdr.divisionCode = vw_arAcctAddress.divisionCode
               and arTranHdr.companyCode  = vw_arAcctAddress.companyCode
		  	  inner join vw_arAcctAddress  A	on arTranHdr.acctNo = A.acctNo and A.addressTypeCode = 'SERVADR1'
			  		and arTranHdr.divisionCode = a.divisionCode
               and arTranHdr.companyCode  = a.companyCode
		  	  left join vw_arAcctAddress  B	on arTranHdr.acctNo = B.acctNo and B.addressTypeCode = 'SERVADR2'
			  		and arTranHdr.divisionCode = b.divisionCode
               and arTranHdr.companyCode  = b.companyCode
		  	  inner join arPackageMaster 		on arAcctSubscriber.packageCode = arPackageMaster.packageCode
			  		and arPackageMaster.divisionCode = arAcctSubscriber.divisionCode
               and arPackageMaster.companyCode  = arAcctSubscriber.companyCode
		  	  inner join chargeTypeMaster 	on arAcctSubscriber.chargeTypeCode = chargeTypeMaster.chargeTypeCode
			  inner join provinceMaster 		on vw_arAcctAddress.provinceCode = provinceMaster.provinceCode
			  inner join municipalityMaster 	on vw_arAcctAddress.municipalityCode = municipalityMaster.municipalityCode
			  inner join barangayMaster 		on vw_arAcctAddress.barangayCode = barangayMaster.barangayCode
			  left  join subdivisionMaster 	on vw_arAcctAddress.subdivisionCode = subdivisionMaster.subdivisionCode
			  inner join subsUserTypeMaster  on arAcctSubscriber.subsUserTypeCode = subsUserTypeMaster.subsUserTypeCode
				inner join systemParameter	 	on systemparameter.divisionCode = arTranHdr.divisionCode 
					and systemParameter.companyCode = arTranHdr.companyCode
           inner join arAccountMaster     on arAcctSubscriber.acctNo = arAccountMaster.acctNo
           		and arAccountMaster.divisionCode = arAcctSubscriber.divisionCode
               and arAccountMaster.companyCode  = arAcctSubscriber.companyCode
		  	  inner join joTranHdr           on arAcctSubscriber.acctNo = joTranHdr.acctNo  and joTranHdr.tranTypeCode = 'APPLYML'
				and jotranhdr.jostatuscode = 'CL'
           		and joTranHdr.divisionCode = arAcctSubscriber.divisionCode
               and joTranHdr.companyCode  = arAcctSubscriber.companyCode
		  	  left join subscriberCircuitID on arAccountMaster.acctNo = subscriberCircuitID.acctNo
		 			and arAccountMaster.divisionCode = subscriberCircuitID.divisionCode
               and arAccountMaster.companyCode  = subscriberCircuitID.companyCode
		  	  WHERE ( arTranHdr.balance > 0) and (arAcctSubscriber.acctno = :as_acctno ) and (arTranHdr.divisionCode = :as_division) and (arTranHdr.companyCode = :as_company)
					and ((month(arTranHdr.tranDate) = :ai_month and year(arTranHdr.tranDate) = :ai_year) or :as_allDates = 'Y')  and (arAcctSubscriber.isPrintConverge = 'Y')
	--END 
	
	elseif ls_isPrintSME = 'Y' then 
		
	tab_1.tp_soa.dw_soa.dataObject = 'dw_statement_of_acct_bsg_sme'
	tab_1.tp_soa.dw_soa.setTransObject(SQLCA);
	tab_1.tp_soa.dw_soa.Object.DataWindow.Print.Preview="yes"
	tab_1.tp_soa.dw_soa.Object.DataWindow.Print.Preview.Rulers="yes"	
	
	--QUERY dw_statement_of_acct_bsg_sme
		SELECT  arTranHdr.tranTypeCode ,
           arTranHdr.tranNo ,
           arTranHdr.arTypeCode ,
           arTranHdr.tranDate ,
           arTranHdr.balance ,
           arTranHdr.remarks ,
			  arTranHdr.periodFrom,
			  arTranHdr.periodTo,
           arTypeMaster.arTypeName ,
           arAcctSubscriber.subscriberName ,
           vw_arAcctAddress.completeAddress ,
           arAcctSubscriber.acctNo ,
           subsUserTypeMaster.subsUserTypeName,
           arPackageMaster.packageName ,
           arPackageMaster.packageDescription,
           chargeTypeMaster.chargeTypeName ,
           vw_arAcctAddress.contactNo ,
           vw_arAcctAddress.floorNo ,
           vw_arAcctAddress.bldgName ,
           vw_arAcctAddress.streetName ,
           vw_arAcctAddress.subdivisionCode ,
           vw_arAcctAddress.barangayCode ,
           arAcctSubscriber.mLineCurrentMonthlyRate currentMontlyRate,
           provinceMaster.provinceName ,
           municipalityMaster.municipalityName ,
           barangayMaster.barangayName ,
           subdivisionMaster.subdivisionName ,
           arTranHdr.balance totalDueNgeni ,
           arTranHdr.balance totalDueDati ,
           arAcctSubscriber.billingMinimumDue,
           A.completeAddress siteA, B.completeAddress siteB, vw_arAcctAddress.contactName,
           upper(arAccountMaster.currencyCode) currencyCode, subscriberCirCuitId.circuitID,
		  arAcctSubscriber.acctno||'-'||to_char(getdate(),'MM')||to_char(getdate(),'YY') as reference,
			  systemParameter.companyID,
			  systemParameter.divisionPrefix,
			  systemParameter.serviceCode
        FROM arTranHdr
           inner join arAcctSubscriber		on arTranHdr.acctNo = arAcctSubscriber.acctNo 
					and arTranHdr.divisionCode = arAcctSubscriber.divisionCode
               and arTranHdr.companyCode  = arAcctSubscriber.companyCode
		  	  inner join arTypeMaster 			on arTranHdr.arTypeCode = arTypeMaster.arTypeCode
			  		and arTranHdr.divisionCode = arTypeMaster.divisionCode
               and arTranHdr.companyCode  = arTypeMaster.companyCode
		  	  inner join vw_arAcctAddress 	on arTranHdr.acctNo = vw_arAcctAddress.acctNo and vw_arAcctAddress.addressTypeCode = 'BILLING'
			  		and arTranHdr.divisionCode = vw_arAcctAddress.divisionCode
               and arTranHdr.companyCode  = vw_arAcctAddress.companyCode
		  	  inner join vw_arAcctAddress  A	on arTranHdr.acctNo = A.acctNo and A.addressTypeCode = 'SERVADR1'
			  		and arTranHdr.divisionCode = a.divisionCode
               and arTranHdr.companyCode  = a.companyCode
		  	  left join vw_arAcctAddress  B	on arTranHdr.acctNo = B.acctNo and B.addressTypeCode = 'SERVADR2'
			  		and arTranHdr.divisionCode = b.divisionCode
               and arTranHdr.companyCode  = b.companyCode
		  	  inner join arPackageMaster 		on arAcctSubscriber.packageCode = arPackageMaster.packageCode
			  		and arPackageMaster.divisionCode = arAcctSubscriber.divisionCode
               and arPackageMaster.companyCode  = arAcctSubscriber.companyCode
		  	  inner join chargeTypeMaster 	on arAcctSubscriber.chargeTypeCode = chargeTypeMaster.chargeTypeCode
			  inner join provinceMaster 		on vw_arAcctAddress.provinceCode = provinceMaster.provinceCode
			  inner join municipalityMaster 	on vw_arAcctAddress.municipalityCode = municipalityMaster.municipalityCode
			  inner join barangayMaster 		on vw_arAcctAddress.barangayCode = barangayMaster.barangayCode
			  left  join subdivisionMaster 	on vw_arAcctAddress.subdivisionCode = subdivisionMaster.subdivisionCode
			  inner join subsUserTypeMaster  on arAcctSubscriber.subsUserTypeCode = subsUserTypeMaster.subsUserTypeCode
			  inner join systemParameter	 	on systemparameter.divisionCode = arTranHdr.divisionCode 
					and systemParameter.companyCode = arTranHdr.companyCode
           inner join arAccountMaster     on arAcctSubscriber.acctNo = arAccountMaster.acctNo
           		and arAccountMaster.divisionCode = arAcctSubscriber.divisionCode
               and arAccountMaster.companyCode  = arAcctSubscriber.companyCode
		  	  inner join joTranHdr           on arAcctSubscriber.acctNo = joTranHdr.acctNo  and joTranHdr.tranTypeCode = 'APPLYML'
				and jotranhdr.jostatuscode = 'CL'
           		and joTranHdr.divisionCode = arAcctSubscriber.divisionCode
               and joTranHdr.companyCode  = arAcctSubscriber.companyCode
		  	  left join subscriberCircuitID on arAccountMaster.acctNo = subscriberCircuitID.acctNo
		 			and arAccountMaster.divisionCode = subscriberCircuitID.divisionCode
               and arAccountMaster.companyCode  = subscriberCircuitID.companyCode
		  	  WHERE ( arTranHdr.balance > 0) and (arAcctSubscriber.acctNo = :as_acctNo) and (arTranHdr.divisionCode = :as_division) and (arTranHdr.companyCode = :as_company)
					and ((month(arTranHdr.tranDate) = :ai_month and year(arTranHdr.tranDate) = :ai_year) or :as_allDates = 'Y')  and (arAcctSubscriber.isPrintSME = 'Y')
	--END 
	
end if 
	
	
--******************************************************************
	iuo_subscriber.setAcctNo(is_acctNo)
	if iuo_subscriber.subscriberStatusCode = 'ADS' then
		pb_activate.enabled = true
	else
		pb_activate.enabled = false
	end if
--******************************************************************
	
--VALIDASI iuo_subscriber.setAcctNo
	
lastMethodAccessed = 'setAcctNo'

acctNo = as_acctNo

select 
tranNo,
acctName,
typeOfBusiness,
lastName,
firstName,
middleName,
motherMaidenName,
citizenshipCode,
sex,
birthDate,
civilStatus,
chargeTypeCode, 
subsUserTypeCode,
packageCode, 
subscriberStatusCode,  
subsTypeCode,  
dateApplied,
dateInstalled, 
dateAutoDeactivated,
dateManualDeactivated,
datePermanentlyDisconnected,
dateReactivated,
qtyAcquiredSTB,
totalBoxesBeforeDeactivation,
numberOfRooms,
occupancyRate, 
mLineCurrentMonthlyRate, 
mLinePreviousMonthlyRate,
extCurrentMonthlyRate, 
extPreviousMonthlyRate,
withAdvances,
locked,
lockedBy,
lockedWithTrans,
referenceJONo,
acquisitionTypeCode,
arAccountMaster.accountTypeCode,
agentCode,
useradd,
dateadd,
arAccountMaster.contactNo,
emailAdd,
arAccountMaster.currencyCode,
a.completeAddress,
b.completeAddress,
c.completeAddress,
d.completeAddress

into 

:tranNo,
:subscriberName,
:typeOfBusiness,
:lastName,
:firstName,
:middleName,
:motherMaidenName,
:citizenshipCode,
:sex,
:birthDate,
:civilStatus,
:chargeTypeCode,
:subsUserTypeCode,
:packageCode,
:subscriberStatusCode,
:subsTypeCode,
:dateApplied,
:dateInstalled,
:dateAutoDeactivated,
:dateManualDeactivated,
:datePermanentlyDisconnected,
:dateReactivated,
:qtyAcquiredSTB,
:totalBoxesBeforeDeactivation,
:numberOfRooms,
:occupancyRate,
:mLineCurrentMonthlyRate,
:mLinePreviousMonthlyRate,
:extCurrentMonthlyRate,
:extPreviousMonthlyRate,
:withAdvances,
:locked,
:lockedBy,
:lockedWithTrans,
:referenceJONo,
:acquisitionTypeCode,
:accountTypeCode,
:agentCode,
:useradd,
:dateadd,
:contactNo,
:emailAdd,
:currencyCode,
:siteA,
:siteB,
:businessAdd,
:billingAdd
from
arAcctSubscriber
inner join arAccountMaster on arAccountMaster.acctNo = arAcctSubscriber.acctNo
	and arAccountMaster.divisionCode = arAcctSubscriber.divisionCode
	and arAccountMaster.companyCode = arAcctSubscriber.companyCode
inner join vw_arAcctAddress a on a.acctNo = arAcctSubscriber.acctNo and a.addressTypeCode = 'SERVADR1' 
	and a.divisionCode  = arAcctSubscriber.divisionCode
	and a.companyCode = arAcctSubscriber.companyCode
left join vw_arAcctAddress b on b.acctNo = arAcctSubscriber.acctNo and b.addressTypeCode = 'SERVADR2' 
	and b.divisionCode = arAcctSubscriber.divisionCode
	and b.companyCode = arAcctSubscriber.companyCode
left join vw_arAcctAddress c on c.acctNo = arAcctSubscriber.acctNo and c.addressTypeCode = 'BUSINESS' 
	and c.divisionCode = arAcctSubscriber.divisionCode
	and c.companyCode = arAcctSubscriber.companyCode
inner join vw_arAcctAddress d on d.acctNo = arAcctSubscriber.acctNo and d.addressTypeCode = 'BILLING' 
	and d.divisionCode = arAcctSubscriber.divisionCode
	and d.companyCode = arAcctSubscriber.companyCode
where arAcctSubscriber.acctNo = :acctNo
and arAcctSubscriber.divisionCode = :gs_divisionCode 
and arAcctSubscriber.companyCode = :gs_companyCode

using SQLCA;
if SQLCA.sqlcode < 0 then
	lastSQLCode		= string(SQLCA.sqlcode)
	lastSQLErrText	= SQLCA.sqlerrtext
	return FALSE
elseif SQLCA.sqlcode = 100 then
	lastSQLCode		= string(SQLCA.sqlcode)
	lastSQLErrText	= "The account number you've just entered does not exist."
	return FALSE
end if

select accountTypeCode
into :accountTypeCode
from arAccountMaster
where acctNo = :acctNo
and divisionCode = :gs_divisionCode
and companyCode = :gs_companyCode
using SQLCA;
if SQLCA.sqlcode < 0 then
	lastSQLCode		= string(SQLCA.sqlcode)
	lastSQLErrText	= SQLCA.sqlerrtext
	return FALSE
elseif SQLCA.sqlcode = 100 then
	lastSQLCode		= string(SQLCA.sqlcode)
	lastSQLErrText	= "The account number you've just entered does not exist."
	return FALSE
end if

select chargeTypeName
  into :chargeTypeName
  from chargeTypeMaster
 where chargeTypeCode = :chargeTypeCode
 using SQLCA;
if SQLCA.sqlcode < 0 then
	lastSQLCode		= string(SQLCA.sqlcode)
	lastSQLErrText	= SQLCA.sqlerrtext
	return FALSE
elseif SQLCA.sqlcode = 100 then
	lastSQLCode		= string(SQLCA.sqlcode)
	lastSQLErrText	= "The charge type code [" + chargeTypeCode + "] does not exist."
	return FALSE
end if

select subsTypeName
  into :subsTypeName
  from subscriberTypeMaster
 where subsTypeCode = :subsTypeCode
and companyCode = :gs_companyCode
using SQLCA;
if SQLCA.sqlcode < 0 then
	lastSQLCode		= string(SQLCA.sqlcode)
	lastSQLErrText	= SQLCA.sqlerrtext
	return FALSE
elseif SQLCA.sqlcode = 100 then
	lastSQLCode		= string(SQLCA.sqlcode)
	lastSQLErrText	= "The subscriber type code [" + subsTypeCode + "] does not exist."
	return FALSE
end if

select subsUserTypeName
  into :subsUserTypeName
  from subsUserTypeMaster
 where subsUserTypeCode = :subsUserTypeCode
 using SQLCA;
if SQLCA.sqlcode < 0 then
	lastSQLCode		= string(SQLCA.sqlcode)
	lastSQLErrText	= SQLCA.sqlerrtext
	return FALSE
elseif SQLCA.sqlcode = 100 then
	lastSQLCode		= string(SQLCA.sqlcode)
	lastSQLErrText	= "The subscriber user type code [" + subsUserTypeCode + "] does not exist."
	return FALSE
end if

select a.packageName, a.packageTypeCode, b.packageTypeName, a.servTypeCode
  into :packageName, :packageTypeCode, :packageTypeName, :servTypeCode
  from arPackageMaster a, packageTypeMaster b
 where a.packageTypeCode = b.packageTypeCode
 	and a.divisionCode = :gs_divisionCode
	and a.companyCode = :gs_companyCode
	and b.divisionCode = :gs_divisionCode
		and b.companyCode = :gs_companyCode
		and a.packageCode = :packageCode
 using SQLCA;
if SQLCA.sqlcode < 0 then
	lastSQLCode		= string(SQLCA.sqlcode)
	lastSQLErrText	= SQLCA.sqlerrtext
	return FALSE
elseif SQLCA.sqlcode = 100 then
	lastSQLCode		= string(SQLCA.sqlcode)
	lastSQLErrText	= "The package code [" + packageCode + "] does not exist."
	return FALSE
end if

select subscriberStatusName
  into :subscriberStatusName
  from subscriberStatusMaster
 where subscriberStatusCode = :subscriberStatusCode
 using SQLCA;
if SQLCA.sqlcode < 0 then
	lastSQLCode		= string(SQLCA.sqlcode)
	lastSQLErrText	= SQLCA.sqlerrtext
	return FALSE
elseif SQLCA.sqlcode = 100 then
	lastSQLCode		= string(SQLCA.sqlcode)
	lastSQLErrText	= "The subscriber status code [" + subscriberStatusCode + "] does not exist."
	return FALSE
end if

//~~~~~~~~~~~~~~~~~~CURRENCY~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if isNull(currencyCode) then
	currencyCode = ''
end if

select conversionRate
into :conversionRate
from currencyMaster
where currencyCode = :currencyCode
using SQLCA;
if SQLCA.sqlcode < 0 then
	lastSQLCode	= string(SQLCA.sqlcode)
	lastSQLErrText	= SQLCA.sqlerrtext
	return FALSE
elseif SQLCA.sqlcode = 100 then
	lastSQLCode	= string(SQLCA.sqlcode)
	lastSQLErrText	= "The currency code [" + currencyCode + "] does not exist."
	return FALSE
end if
//~~~~~~~~~~~~~~~~~~END~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

return TRUE


--END VALIDASI 

	f_closeStatus()

end if


--TAB SUBCRIBER INFO

select a.acctNo, a.tranNo, a.terrCode, z.fullName, a.dateApplied, b.dateInstalled, a.contractValidity, c.packageName,
       t.acctName, b.typeOfBusiness, d.subscriberStatusName, e.chargeTypeName, c.monthlyRate, f.dateofAcceptance,
       v.completeAddress billingAddress, v.contactName billingContactName, v.contactNo billingContactNo, v.designation billingDesignation,
       w.completeAddress businessAddress, w.contactName businessContactName, w.contactNo businessContactNo, w.designation businessDesignation,
       x.completeAddress serviceAddress1, x.contactName serviceContactName1, x.contactNo serviceContactNo1, x.designation serviceDesignation1,
       y.completeAddress serviceAddress2, y.contactName serviceContactName2, y.contactNo serviceContactNo2, y.designation serviceDesignation2,
       b.subscriberStatusCode, u.subsUserTypeName, s.currencyname, a.dateAdd, c.packageCode, b.isPrintComclark, b.isPrintConverge, b.isPrintSME, t.isvat , t.isnonvat , t.iswhtagent, b.tin , b.bstradename, b.bssacctno, b.MIGRATEDBSSTOIBASACCTNO
from arApplicationTranHdr a

inner join arAccountMaster t on t.acctNo = a.acctNo
	and t.divisionCode = a.divisionCode
	and t.companyCode = a.companyCode
inner join arAcctSubscriber b on b.acctNo = a.acctNo
	and b.divisionCode = a.divisionCode
	and b.companyCode = a.companyCode
left join contractAcceptanceTranHdr f on f.acctNo = a.acctNo and f.dataTest = 'P' and f.bertTest = 'P'
	and f.divisionCode = a.divisionCode
	and f.companyCode = a.companyCode
inner join arPackageMaster c on c.packageCode = b.packageCode
	and b.divisionCode = c.divisionCode
	and b.companyCode = c.companyCode
inner join subscriberStatusMaster d on d.subscriberStatusCode = b.subscriberStatusCode
inner join chargeTypeMaster e on e.chargeTypeCode = b.chargeTypeCode
inner join vw_arAcctAddress v on v.acctNo = a.acctNo and v.addressTypeCode = 'BILLING'
	and v.divisionCode = a.divisionCode
	and v.companyCode = a.companyCode
left join vw_arAcctAddress w on w.acctNo = a.acctNo and w.addressTypeCode = 'BUSINESS'
	and w.divisionCode = a.divisionCode
	and w.companyCode = a.companyCode
left join vw_arAcctAddress x on x.acctNo = a.acctNo and x.addressTypeCode = 'SERVADR1'
	and x.divisionCode = a.divisionCode
	and x.companyCode = a.companyCode
left join vw_arAcctAddress y on y.acctNo = a.acctNo and y.addressTypeCode = 'SERVADR2'
	and y.divisionCode = a.divisionCode
	and y.companyCode = a.companyCode
left join agentMaster z on z.agentCode = b.agentCode
	 and z.companyCode = b.companyCode
inner join subsUserTypeMaster u on u.subsUserTypeCode = b.subsUserTypeCode
inner join currencyMaster s on s.currencyCode = t.currencyCode
where a.acctno = :as_acctno
and a.divisionCode = :as_division
and a.companyCode = :as_company

--EVENT BUTTON CLICK

long 	 ll_xPos, ll_yPos
string   ls_handle,ls_acctNo

ls_acctNo = this.getItemString(row,"acctNo")

if dwo.name = 'b_view' then
	opensheetwithparm(w_subscriber_char_refs,getItemString(row,'acctno'),w_mdiFrame,0,original!)
end if	

if dwo.name = 'b_1'(Edit TIN and Business Trade Name) then
		
		
openwithparm(w_edit_tin_bstradename,is_acctNo)

--VALIDASI WINDOW OPEN W_EDIT_TIN_BSTRADENAME

--EVENT OPEN

string ls_tin, ls_bstradename

is_acctNo = trim(message.stringparm)


select tin , bstradename into :ls_tin , :ls_bstradename
from arAcctSubscriber
where acctNo = :is_acctno 
and divisionCode = :gs_divisionCode
and companyCode = :gs_companyCode
using SQLCA;

sle_currenttin.text = ls_tin
sle_currentbusinesstradename.text = ls_bstradename

--SAVE BUTTION

string ls_newtin , ls_newbstradename

ls_newtin = sle_newtin.text
ls_newbstradename = sle_newbusinesstradename.text

update aracctSubscriber
set tin = :ls_newtin,
	bstradename = :ls_newbstradename
where acctno = :is_acctno
and divisioncode = :gs_divisioncode
and companycode = :gs_companycode
using SQLCA;

commit using SQLCA;

close(w_edit_tin_bstradename)
	
		
elseif dwo.name = 'b_2'	 then
	
	ls_handle = this.getItemString(row,"handle")
	ll_xPos = this.getItemNumber(row,"xpos")
	ll_ypos = this.getItemNumber(row,"ypos")

	ole_1.object.xposition = ll_xPos
	ole_1.object.yposition = ll_yPos
	ole_1.object.magnification = 500
	ole_1.object.Locate()	
	
	ole_1.object.apptivate()

end if	


--TAB PAYMENT

SELECT  collectiontranhdr.tranno ,
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
collectiontranhdr.universal_ar
FROM collectiontranhdr ,
   arAcctSubscriber     
WHERE ( collectiontranhdr.acctno = arAcctSubscriber.acctno )
  and ( arAcctSubscriber.divisionCode = collectiontranhdr.divisionCode )
  and ( arAcctSubscriber.companyCode = collectiontranhdr.companyCode )
  and (( collectiontranhdr.divisionCode = :as_division )
and  ( collectiontranhdr.companyCode = :as_company )  
  and  ( collectiontranhdr.acctno = :s_accountno ) ) 
  
--TAB A/R BALANCE
  
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
WHERE artranhdr.acctno = :as_account 
AND   arTranHdr.divisionCode = :as_divisionCode
AND   arTranHdr.companyCode = :as_companyCode
AND (artranhdr.balance <> 0 or :as_includeZeroBalance = 'Y')

--TAB A/R LEDGER

SELECT vw_subsLedgerAR.trandate,   
		vw_subsLedgerAR.tranno,   
		vw_subsLedgerAR.particulars,   
		vw_subsLedgerAR.credit,   
		vw_subsLedgerAR.debit,
		0.00 as balance,
		vw_subsLedgerAR.dateadd
FROM vw_subsLedgerAR   
WHERE acctno = :as_acctno
AND divisionCode = :as_division
AND companyCode = :as_company
ORDER BY trandate ASC, dateadd ASC

--EVENT BUTTON b_refresh

if dwo.name = 'b_refresh' then
	tab_1.tp_arLedger.dw_ar.retrieve(is_acctNo, gs_divisionCode, gs_companyCode)
	computeBalanceDRCR(tab_1.tp_arLedger.dw_ar, 'DR')
end IF

--VALIDASI  computeBalanceDRCR
long ll_rows, ll_row
dec ld_balance, ld_credit, ld_debit

ll_rows = adw_data.rowcount()
ld_balance = 0

for ll_row = 1 to ll_rows
	ld_debit = adw_data.getItemNumber(ll_row, 'debit')
	ld_credit = adw_data.getItemNumber(ll_row, 'credit')
	
	if as_normalside = 'CR' then
		ld_balance = ld_balance + (ld_credit - ld_debit)
	else
		ld_balance = ld_balance + (ld_debit - ld_credit)		
	end if
	adw_data.setItem(ll_row, 'balance', ld_balance)	
NEXT

--END VALIDASI computeBalanceDRCR

ChangeDirectory(APPLICATION_PATH)


--TAB ADVANCES 

SELECT  aropencreditmaster.tranno ,
   aropencreditmaster.trandate ,
   aropencreditmaster.acctno ,
   aropencreditmaster.amount ,
   aropencreditmaster.appliedamt ,
   aropencreditmaster.balance ,
   aropencreditmaster.octypecode ,
   aropencreditmaster.reftranno ,
   aropencreditmaster.trantypecode ,
   arAcctSubscriber.subscribername ,
   octypemaster.octypename,
   octypemaster.priority ,
   systransactionparam.trantypename
FROM aropencreditmaster 
INNER JOIN arAcctSubscriber ON aropencreditmaster.acctNo = arAcctSubscriber.acctNo
      and aropencreditmaster.divisionCode = arAcctSubscriber.divisionCode
      and aropencreditmaster.companyCode = arAcctSubscriber.companyCode
INNER JOIN octypemaster ON aropencreditmaster.octypecode = octypemaster.octypecode
		  and aropencreditmaster.divisionCode = octypemaster.divisionCode
      and aropencreditmaster.companyCode = octypemaster.companyCode
INNER JOIN systransactionparam ON aropencreditmaster.tranTypeCode = systransactionparam.trantypecode
      and aropencreditmaster.divisionCode = systransactionparam.divisionCode
      and systransactionparam.companyCode = aropencreditmaster.companyCode
WHERE ( aropencreditmaster.acctno = :as_acctno )  
  AND ( aropencreditmaster.balance <> 0 or :as_includeZeroBalance = 'Y' )
	 AND ( aropencreditmaster.divisionCode = :as_division )
  AND ( aropencreditmaster.companyCode = :as_company )
  
 --ON CHANGE CHECK DISPLAY ZERO BALANCE

  if this.checked then
	is_displayZeroBalAdv = 'Y'
	tab_1.tp_advances.dw_op.retrieve(trim(is_acctNo), is_displayZeroBalAdv, gs_divisionCode, gs_companyCode)
else
	is_displayZeroBalAdv = 'N'
	tab_1.tp_advances.dw_op.retrieve(trim(is_acctNo), is_displayZeroBalAdv, gs_divisionCode, gs_companyCode)
end if


--SUBCRIBTION ADVANCE LEDGER

  SELECT vw_subsLedgerSubsAdv.acctno,   
         vw_subsLedgerSubsAdv.trandate,   
         vw_subsLedgerSubsAdv.tranno,   
         vw_subsLedgerSubsAdv.particulars,   
         vw_subsLedgerSubsAdv.debit,  
         vw_subsLedgerSubsAdv.credit,   
			0.00 as balance
  FROM vw_subsLedgerSubsAdv   
  WHERE acctno = :as_acctno
  AND   divisionCode = :as_divisionCode
  AND   companyCode = :as_companyCode 
  ORDER BY trandate ASC

  
--EVENT BUTTON CLICK
  
if dwo.name = 'b_refresh' then

tab_1.tp_advLedger.dw_advances.retrieve(trim(is_acctNo), gs_divisionCode, gs_companyCode)
computeBalanceDRCR(tab_1.tp_advLedger.dw_advances, 'CR')

end IF

--VALIDASI computeBalanceDRCR
long ll_rows, ll_row
dec ld_balance, ld_credit, ld_debit

ll_rows = adw_data.rowcount()
ld_balance = 0

for ll_row = 1 to ll_rows
	ld_debit = adw_data.getItemNumber(ll_row, 'debit')
	ld_credit = adw_data.getItemNumber(ll_row, 'credit')
	
	if as_normalside = 'CR' then
		ld_balance = ld_balance + (ld_credit - ld_debit)
	else
		ld_balance = ld_balance + (ld_debit - ld_credit)		
	end if
	adw_data.setItem(ll_row, 'balance', ld_balance)	
next


--END VALIDASI

--TAB SUBCRIBTION DEPOSIT LEDGER

SELECT vw_subsLedgerSubsDep.acctno,   
         vw_subsLedgerSubsDep.trandate,   
         vw_subsLedgerSubsDep.tranno,   
         vw_subsLedgerSubsDep.particulars,   
         vw_subsLedgerSubsDep.debit,  
         vw_subsLedgerSubsDep.credit,   
			0.00 as balance
    FROM vw_subsLedgerSubsDep  
   WHERE ( acctno = :as_acctno ) 
   AND   ( divisionCode = :as_division )
   AND	( companyCode = :as_company )
ORDER BY vw_subsLedgerSubsDep.trandate ASC   


--TAB INCENTIVES LEDGER

 SELECT vw_subsLedgerSubsInc.acctno,   
         vw_subsLedgerSubsInc.trandate,   
         vw_subsLedgerSubsInc.tranno,   
         vw_subsLedgerSubsInc.particulars,   
         vw_subsLedgerSubsInc.credit,  
         vw_subsLedgerSubsInc.debit,  
			0.00 as balance    
  FROM vw_subsLedgerSubsInc   
  WHERE acctno = :as_acctno
  AND divisionCode = :as_division
  AND companyCode = :as_company
  ORDER BY trandate ASC
  
--TAB EQUIPMENT DEPOSIT LEDGER
  
SELECT vw_subsLedgerEquipDep.acctno,   
         vw_subsLedgerEquipDep.trandate,   
         vw_subsLedgerEquipDep.tranno,   
         vw_subsLedgerEquipDep.particulars,   
         vw_subsLedgerEquipDep.debit,   
         vw_subsLedgerEquipDep.credit,   
         0.00 balance  
    FROM vw_subsLedgerEquipDep  
   WHERE ( acctno = :as_acctno )
   AND divisionCode = :as_division
   AND companyCode = :as_company    
   
   
--TAB TRANSACTION
 
SELECT rpad(' ', 10,' ') as trandate ,
	 rpad(' ', 8, ' ') as tranno,
   rpad(' ', 300, ' ') as particulars,
  0.00 amount
FROM dual 

--FILTER TRANSACTION TYPE

string mod_string, rc

if f_modifytable(is_acctNo, as_trantype) <> "" then
	
	mod_string = 'DataWindow.Table.Select="' &
		  + f_modifytable(is_acctNo, as_trantype) + '"'
	rc = tab_1.tp_subscribertransaction.dw_subscriberTransaction.Modify(mod_string)
	IF rc = "" THEN
		  tab_1.tp_subscribertransaction.dw_subscriberTransaction.retrieve()
	ELSE
		  MessageBox("Status", "Modify Failed ->"+as_trantype +"<- " +rc)
	END IF
else
	tab_1.tp_subscribertransaction.dw_subscriberTransaction.reset()
end if

--VALIDASI F_MODIFYTABLE


  string ls_table

//ray 02162013 converted script to oracle	
if	as_trantype =	'APPLYPD'	then
	ls_table = "select 	utils.convert_to_varchar2(a.tranDate,10,p_style=>101) as tranDate,"+&
					"a.tranNo as tranNo,"+&
					"'No of Exts Applied : ' || cast(case when count(c.tranNo) = 0 then 1 else count(c.tranNo) end as char(4)) || ' Status : ' || a.applicationStatusCode || '   By : ' || upper(a.userAdd) as particulars, "+&
					"case when b.amount is null then 0 else b.amount end as amount "+&
					"from applOfPermanentDiscTranHdr a "+&
					"left join applOfPermanentDiscTranDtl c on a.tranNo = c.tranNo "+ " AND c.divisionCode = '"+gs_divisionCode+"'" +  " AND c.companyCode = '"+gs_companyCode+"'"+&
        			"left join arTranHdr b on a.tranNo = b.tranNo and b.tranTypeCode = '"+as_trantype+"' and a.acctNo = b.acctNo "+  " AND b.divisionCode = '"+gs_divisionCode+"'" +  " AND b.companyCode = '"+gs_companyCode+"'"+&
					"where a.acctNo = '"+as_acctNo+"' "+  " AND a.divisionCode = '"+gs_divisionCode+"'" +  " AND a.companyCode = '"+gs_companyCode+"'"+&
					"group by utils.convert_to_varchar2(a.tranDate,10,p_style=>101), a.tranNo, b.amount, a.applicationStatusCode, a.userAdd "

//ray 02162013 converted script to oracle	
elseif	as_trantype =	'APPLMLEXTREA'	then
	ls_table = "select 	utils.convert_to_varchar2(a.tranDate,10,p_style=>101) as tranDate,"+&
					"a.tranNo as tranNo,"+&
					"'No of Exts Applied : ' || cast(min(a.noOfExtension) as char(4)) || ' Status : ' || a.applicationStatusCode || '   By : ' || upper(a.userAdd) as particulars, "+&
					"case when b.amount is null then 0 else b.amount end as amount "+&
					"from applOfReactivationTranHdr a "+&
        			"left join arTranHdr b on a.tranNo = b.tranNo and b.tranTypeCode = '"+as_trantype+"' and a.acctNo = b.acctNo "+  " AND b.divisionCode = '"+gs_divisionCode+"'" +  " AND b.companyCode = '"+gs_companyCode+"'"+&
					"where a.acctNo = '"+as_acctNo+"' "+  " AND a.divisionCode = '"+gs_divisionCode+"'" +  " AND a.companyCode = '"+gs_companyCode+"'"+ &
					"group by utils.convert_to_varchar2(a.tranDate,10,p_style=>101), a.tranNo, b.amount, a.applicationStatusCode, a.userAdd "

//ray 02142013 converted script to oracle	
elseif	as_trantype =	'APPLYEXT'	then
	ls_table = "select 	utils.convert_to_varchar2(a.tranDate,10,p_style=>101) as tranDate,"+&
					"a.tranNo as tranNo,"+&
					"'No of Exts Applied : ' || cast(min(a.noOfExtension) as char(4)) || ' Status : ' || a.applicationStatusCode || '   By : ' || upper(a.userAdd) as particulars, "+&
					"case when b.amount is null then 0 else b.amount end as amount "+&
					"from applOfExtTranHdr a "+&
        			"left join arTranHdr b on a.tranNo = b.tranNo and b.tranTypeCode = '"+as_trantype+"' and a.acctNo = b.acctNo "+  " AND b.divisionCode = '"+gs_divisionCode+"'" +  " AND b.companyCode = '"+gs_companyCode+"'"+&
					"where a.acctNo = '"+as_acctNo+"' "+  " AND a.divisionCode = '"+gs_divisionCode+"'" +  " AND a.companyCode = '"+gs_companyCode+"'"+ &
					"group by utils.convert_to_varchar2(a.tranDate,10,p_style=>101), a.tranNo, b.amount, a.applicationStatusCode, upper(a.userAdd) "

//ray 02132013 converted script to oracle	
elseif	as_trantype =	'APPLYML'	then
	ls_table = 	'select utils.convert_to_varchar2(arAcctSubscriber.dateApplied,10,p_style=>101) as tranDate, '+&
					'arAcctSubscriber.tranNo as tranNo, '+&
					"'By : ' || upper(arAcctSubscriber.userAdd) as particulars, "+&
					'sum(arTranHdr.amount) as amount ' +&
					'from arAcctSubscriber, arPackageMaster, arTranHdr ' +&
					'where  	arAcctSubscriber.acctNo = arTranHdr.acctNo '+& 
					'and arAcctSubscriber.packageCode = arPackageMaster.packageCode ' +&
					'and arAcctSubscriber.tranNo = arTranHdr.tranNo '+&
					"and arTranHdr.acctNo = '"+as_acctno+"'" +  " AND arPackageMaster.divisionCode = '"+gs_divisionCode+"'" +  " AND arPackageMaster.companyCode = '"+gs_companyCode+"'"+&
					"and arTranHdr.tranTypeCode = 'APPLYML' " +  " AND arTranHdr.divisionCode = '"+gs_divisionCode+"'" +  " AND arTranHdr.companyCode = '"+gs_companyCode+"'"+&
					"and arTranHdr.arTypeCode = 'INSTF' "+  " AND arAcctSubscriber.divisionCode = '"+gs_divisionCode+"'" +  " AND arAcctSubscriber.companyCode = '"+gs_companyCode+"'"+ &
					"group by utils.convert_to_varchar2(arAcctSubscriber.dateApplied,10,p_style=>101), "+&
					"arAcctSubscriber.tranNo, upper(arAcctSubscriber.userAdd) "

//ray 02162013 converted script to oracle		
elseif	as_trantype =	'APPLYTRANSFR'	then					
	ls_table = 	'select 	utils.convert_to_varchar2(a.tranDate,10,p_style=>101), '+&
					'a.tranNo as tranNo, '+&
					"'Old Address: ' || a.oldInstallationAddress || "+&
               "'      Status : ' || a.applicationStatusCode || '   By : ' || upper(a.userAdd) as particulars, "+&
					'b.amount as amount '+&
					'from applOfTransferTranHdr a '+&
               "left join arTranHdr b on a.tranNo = b.tranNo and b.tranTypeCode = '"+as_trantype+"' and a.acctNo = b.acctNo "+  " AND b.divisionCode = '"+gs_divisionCode+"'" +  " AND b.companyCode = '"+gs_companyCode+"'"+&
				   "where a.acctNo = '"+as_acctNo+"' "+  " AND a.divisionCode = '"+gs_divisionCode+"'" +  " AND a.companyCode = '"+gs_companyCode+"'"

//ray 02162013 converted script to oracle
elseif	as_trantype =	'APPLYXTDSRVC'	then
	ls_table = "select 	utils.convert_to_varchar2(a.tranDate,10,p_style=>101) as tranDate,"+&
					"a.tranNo as tranNo,"+&
					"'EXTENDED SERVICE; Status : ' || a.applicationStatusCode || '   By : ' || upper(a.userAdd) as particulars, "+&
					"0 as amount "+&
					"from applExtendedServicesTranHdr a "+&
        			"where a.acctNo = '"+as_acctNo+"' "+  " AND a.divisionCode = '"+gs_divisionCode+"'" +  " AND a.companyCode = '"+gs_companyCode+"'"+ &
					"group by utils.convert_to_varchar2(a.tranDate,10,p_style=>101), a.tranNo, a.applicationStatusCode, a.userAdd "				

//ray 02162013 converted script to oracle
elseif	as_trantype =	'APPLYOC'	then
	ls_table	=	'select 	utils.convert_to_varchar2(arApplOfOCTranHdr.tranDate,10,p_style=>101) as tranDate, ' +&
					'arApplOfOCTranHdr.tranNo as tranNo, '+&
					"'From: '||rtrim(arApplOfOCTranHdr.refOcTranNo)||' '||ocTypeMaster.ocTypeName ||'   By : ' || upper(arApplOfOCTranHdr.userAdd) as particular, "+&
					'arApplOfOCTranHdr.appliedOCAmt as amount '+&
					'from arApplOfOCTranHdr, ocTypeMaster '+&
					"where  	arApplOfOCTranHdr.acctNo = '"+as_AcctNo+"' "+  " AND arApplOfOCTranHdr.divisionCode = '"+gs_divisionCode+"'" +  " AND arApplOfOCTranHdr.companyCode = '"+gs_companyCode+"'"+  " AND ocTypeMaster.divisionCode = '"+gs_divisionCode+"'" +  " AND ocTypeMaster.companyCode = '"+gs_companyCode+"'"+&
					'and arApplOfOCTranHdr.refOcTypeCode = ocTypeMaster.ocTypeCode '

//ray 02162013 converted script to oracle
elseif	as_trantype =	'ARCHKCLR'	then
	ls_table	= 	'select 	utils.convert_to_varchar2(checkClearingTranHdr.tranDate,10,p_style=>101) as tranDate, '+&
					'checkClearingTranHdr.tranNo as tranNo, '+&
					"'Check Details: ' || checkClearingTranHdr.checkNo || ' ' || "+&
					"utils.convert_to_varchar2(checkClearingTranHdr.checkDate,10,p_style=>101) || ' Bank: ' || "+&
					"bankMaster.bankName ||'   By : ' || upper(checkClearingTranHdr.userAdd) AS PARTICULAR, "+&
					'checkClearingTranHdr.amount as amount '+&
					'from checkClearingTranHdr, bankMaster '+&
					"where checkClearingTranHdr.acctNo = '"+ as_AcctNo+"' "+  " AND checkClearingTranHdr.divisionCode = '"+gs_divisionCode+"'" +  " AND checkClearingTranHdr.companyCode = '"+gs_companyCode+"'"+  " AND bankMaster.companyCode = '"+gs_companyCode+"'"+&
					'and checkClearingTranHdr.bankCode = bankMaster.bankCode'
	
//ray 02162013 converted script to oracle	
elseif	as_trantype =	'ARDEBITMEMO'	then
	ls_table = 	'select 	utils.convert_to_varchar2(arDebitMemoTranHdr.tranDate,10,p_style=>101) as tranDate, '+&
					'arDebitMemoTranHdr.tranNo as tranNo, '+&
					"'REMARKS : ' || rtrim(arDebitMemoTranHdr.remarks) ||'   By : ' || upper(arDebitMemoTranHdr.userAdd) as particular, "+&
					'arDebitMemoTranHdr.totalAmount as amount '+&
					'from arDebitMemoTranHdr '+&
					"where arDebitMemoTranHdr.acctNo = '"+ as_AcctNo+"' "+  " AND arDebitMemoTranHdr.divisionCode = '"+gs_divisionCode+"'" +  " AND arDebitMemoTranHdr.companyCode = '"+gs_companyCode+"'"

//ray 02132013 converted script to oracle	
elseif	as_trantype =	'BILLING'	then
	ls_table = 	'select utils.convert_to_varchar2(billingTranHdr.billingdate,10,p_style=>101) as tranDate, '+&
					'billingTranHdr.tranNo as tranNo, '+&
					"'Period Covered: ' || utils.convert_to_varchar2(billingTranHdr.billingPeriodFrom,30,p_style=>101) || ' to ' || "+&
					"utils.convert_to_varchar2(billingTranHdr.billingPeriodTo,30,p_style=>101) ||'   By : ' || upper(billingTranHdr.userAdd) as particular, "+&
					'billingTranHdr.extendedTotalBill as amount '+&
					'from billingTranHdr '+&
					"where billingTranHdr.acctNo = '"+as_AcctNo+"'"+  " AND billingTranHdr.divisionCode = '"+gs_divisionCode+"'" +  " AND billingTranHdr.companyCode = '"+gs_companyCode+"'"

//ray 02132013 converted script to oracle
elseif	as_trantype =	'BOUNCNGCHK'	then
	ls_table	=	'select 	utils.convert_to_varchar2(bouncingCheckTranHdr.tranDate,10,p_style=>101) as tranDate, '+&
					'bouncingCheckTranHdr.tranNo as tranNo, '+&
					"'Check Details: ' || bouncingCheckTranHdr.checkNo || ' Bank: ' || "+&
					"bankMaster.bankName ||'   By : ' || upper(bouncingCheckTranHdr.userAdd) AS PARTICULAR,	"+&
					'bouncingCheckTranHdr.amount as amount '+&
					'from bouncingCheckTranHdr, bankMaster, bankAccountMaster '+&
					"where bouncingCheckTranHdr.acctNo = '"+as_AcctNo+"'"+  " AND bouncingCheckTranHdr.divisionCode = '"+gs_divisionCode+"'" +  " AND bouncingCheckTranHdr.companyCode = '"+gs_companyCode+"'"+&
					' and bouncingCheckTranHdr.bankAccountNo = bankAccountMaster.bankAccountNo '+  " AND bankAccountMaster.divisionCode = '"+gs_divisionCode+"'" +  " AND bankAccountMaster.companyCode = '"+gs_companyCode+"'"+ " AND bankMaster.companyCode = '"+gs_companyCode+"'"+&
					' and bankAccountMaster.bankCode = bankMaster.bankCode'

//ray 02132013 converted script to oracle 
elseif	as_trantype =	'CARCPTFRSUBS'	then
	ls_table	=	'select utils.convert_to_varchar2(collectiontranhdr.tranDate,10,p_style=>101)  as tranDate, '+&
					'collectiontranhdr.tranNo as tranNo, '+&
					"'Payment Details: ' || collectiontranhdr.documenttypecode || '#: ' || "+&
					"collectiontranhdr.receiptno ||'   By : ' || upper(collectiontranhdr.userAdd) AS PARTICULAR, "+&
					'collectiontranhdr.amount AS amount	'+&					
					'from collectiontranhdr '+&					
					"where collectiontranhdr.acctNo = '"+as_AcctNo+"' and "  +&
					"collectiontranhdr.paymenttypecode ='CA'"+  " AND collectiontranhdr.divisionCode = '"+gs_divisionCode+"'" +  " AND collectiontranhdr.companyCode = '"+gs_companyCode+"'"

//ray 02132013 converted script to oracle
elseif	as_trantype =	'CHANGEPACK'	then
	ls_table = 	'select 	utils.convert_to_varchar2(changePackageTranHdr.tranDate,10,p_style=>101) as tranDate, '+&
					'changePackageTranHdr.tranNo as tranNo, '+&
					"'Old Package : '|| arPackageMaster.packageName ||'   By : ' || upper(changePackageTranHdr.userAdd) as particular, "+&
					'changePackageTranHdr.extendedFeeAmount as amount '+&
					'from changePackageTranHdr, arPackageMaster '+&
					"where changePackageTranHdr.acctNo = '"+as_AcctNo+"' "+  " AND changePackageTranHdr.divisionCode = '"+gs_divisionCode+"'" +  " AND changePackageTranHdr.companyCode = '"+gs_companyCode+"'"+&
					'and changePackageTranHdr.oldPackageCode = arPackageMaster.packageCode'+  " AND arPackageMaster.divisionCode = '"+gs_divisionCode+"'" +  " AND arPackageMaster.companyCode = '"+gs_companyCode+"'" + &		
               		"UNION ALL " +&		
					'select 	utils.convert_to_varchar2(changePackageTranHdr_apl.tranDate,10,p_style=>101) as tranDate, '+&
					'changePackageTranHdr_apl.tranNo as tranNo, '+&
					"'Old Package : '|| arPackageMaster.packageName ||'   By : ' || upper(changePackageTranHdr_apl.userAdd) as particular, "+&
					'changePackageTranHdr_apl.extendedFeeAmount as amount '+&
					'from changePackageTranHdr_apl, arPackageMaster '+&
					"where changePackageTranHdr_apl.acctNo = '"+as_AcctNo+"' "+  " AND changePackageTranHdr_apl.divisionCode = '"+gs_divisionCode+"'" +  " AND changePackageTranHdr_apl.companyCode = '"+gs_companyCode+"'"+&
					'and changePackageTranHdr_apl.oldPackageCode = arPackageMaster.packageCode'+  " AND arPackageMaster.divisionCode = '"+gs_divisionCode+"'" +  " AND arPackageMaster.companyCode = '"+gs_companyCode+"'"

//ray 02162013 converted script to oracle
elseif	as_trantype =	'CREDITMEMO'	then
	ls_table =	'select 	utils.convert_to_varchar2(cmTranHdr.tranDate,10,p_style=>101) as tranDate, '+&
					'cmTranHdr.tranNo as tranNo, '+&
					"'Remarks : '|| rtrim(cmTranHdr.remarks) ||'   By : ' || upper(cmTranHdr.userAdd) as particular, "+&
					'amount as amount '+&
					'from 	cmTranHdr '+&
					"where 	cmTranHdr.acctNo = '"+as_AcctNo+"'"+  " AND cmTranHdr.divisionCode = '"+gs_divisionCode+"'" +  " AND cmTranHdr.companyCode = '"+gs_companyCode+"'"

//ray 02162013 converted script to oracle
elseif	as_trantype =	'DEACSUBS'	then
	ls_table =  'select 	utils.convert_to_varchar2(deactivationTranHdr.tranDate,10,p_style=>101) as tranDate, '+&
				 	'deactivationTranHdr.tranNo as tranNo, '+&
					"'No of ext: ' || rtrim( utils.convert_to_varchar2(deactivationTranHdr.noOfSTBDeactivated,10,p_style=>101) ) || "+&
					"'  DEACTIVATED;  By : ' || upper(deactivationTranHdr.userAdd) as particular, "+&
					'extendedFeeAmount as amount '+&
					'from 	deactivationTranHdr '+&
					"where 	deactivationTranHdr.acctNo ='"+ as_AcctNo+"'"+  " AND deactivationTranHdr.divisionCode = '"+gs_divisionCode+"'" +  " AND deactivationTranHdr.companyCode = '"+gs_companyCode+"'"

//ray 02162013 converted script to oracle
elseif	as_trantype =	'DEED'	then
	ls_table = 	'select 	utils.convert_to_varchar2(deedOfAssignTranHdr.tranDate,10,p_style=>101) as tranDate, '+&
					'deedOfAssignTranHdr.tranNo as tranNo, '+&
					"'Old Subscriber Name : ' || rtrim(deedOfAssignTranHdr.oldSubscriberName) ||'   By : ' || upper(deedOfAssignTranHdr.userAdd) as particular, "+&
					'0.00 as amount '+&
					'from 	deedOfAssignTranHdr '+&
					"where 	deedOfAssignTranHdr.acctNo ='"+ as_AcctNo+"'"+  " AND deedOfAssignTranHdr.divisionCode = '"+gs_divisionCode+"'" +  " AND deedOfAssignTranHdr.companyCode = '"+gs_companyCode+"'"

//ray 02162013 converted script to oracle
elseif	as_trantype =	'DISCEXT'	then 
	ls_table = 	'select 	utils.convert_to_varchar2(discPermExtTranHdr.tranDate,10,p_style=>101) as tranDate, '+&
				  	'discPermExtTranHdr.tranNo as tranNo, '+&
					"rtrim(discPermExtTranHdr.reason) ||'   By : ' || upper(discPermExtTranHdr.userAdd) as particular, "+&
					'extendedFeeAmount as amount '+&
					'from 	discPermExtTranHdr '+&
					"where 	discPermExtTranHdr.acctNo ='"+ as_AcctNo +"'"+  " AND discPermExtTranHdr.divisionCode = '"+gs_divisionCode+"'" +  " AND discPermExtTranHdr.companyCode = '"+gs_companyCode+"'"
					
//ray 02162013 converted script to oracle
elseif	as_trantype =	'EXTINSTALL'	then
	ls_table = 	'select 	utils.convert_to_varchar2(instExtTranHdr.tranDate,10,p_style=>101) as tranDate, '+&
					'instExtTranHdr.tranNo as tranNo, '+&
					"'No of Ext: ' || rtrim(cast(noOfExtension as char(4) ) ) || "+&
					"'  Job Order No: ' || rtrim(instExtTranHdr.jobOrderNo) ||'   By : ' || upper(instExtTranHdr.userAdd) as particular, "+&
					'instExtTranHdr.extendedFeeAmount as amount '+&
					'from 	instExtTranHdr '+&
					"where 	instExtTranHdr.acctNo = '"+as_AcctNo+"'"+  " AND instExtTranHdr.divisionCode = '"+gs_divisionCode+"'" +  " AND instExtTranHdr.companyCode = '"+gs_companyCode+"'"

//ray 02162013 converted script to oracle
elseif	as_trantype =	'EXTSERVICES'	then 
	ls_table =	'select 	utils.convert_to_varchar2(extendedServiceTranHdr.tranDate,10,p_style=>101) as tranDate, '+&
					'extendedServiceTranHdr.tranNo as tranNo, '+&
					"'Action Taken : ' || rtrim(extendedServiceTranHdr.actionTaken) ||'   By : ' || upper(extendedServiceTranHdr.userAdd) as particular, "+&
					'extendedServiceTranHdr.extendedFeeAmount as amount '+&
					'from 	extendedServiceTranHdr '+&
					"where	extendedServiceTranHdr.acctNo = '"+as_AcctNo+"'"+  " AND extendedServiceTranHdr.divisionCode = '"+gs_divisionCode+"'" +  " AND extendedServiceTranHdr.companyCode = '"+gs_companyCode+"'"

//ray 02162013 converted script to oracle
elseif	as_trantype =	'MLINEINSTALL'	then
	ls_table = 	'select 	utils.convert_to_varchar2(instMainlineTranHdr.tranDate,10,p_style=>101) as tranDate, '+&
					'instMainlineTranHdr.tranNo as tranNo, '+&
					"'Package : ' || rtrim(arPackageMaster.packageName) || ' J.O. No.: ' || "+&
					"rtrim(instMainlineTranHdr.jobOrderNo) ||'   By : ' || upper(instMainlineTranHdr.userAdd) as particular, "+&
					'instMainlineTranHdr.extendedFeeAmount as amount '+&
					'from 	instMainlineTranHdr, arPackageMaster '+&
					"where	instMainlineTranHdr.acctNo ='"+as_AcctNo+"' "+  " AND arPackageMaster.divisionCode = '"+gs_divisionCode+"'" +  " AND arPackageMaster.companyCode = '"+gs_companyCode+"'"+&
					'and instMainlineTranHdr.packageCode = arPackageMaster.packageCode '+  " AND instMainlineTranHdr.divisionCode = '"+gs_divisionCode+"'" +  " AND instMainlineTranHdr.companyCode = '"+gs_companyCode+"'"
					
//ray 02162013 converted script to oracle					
elseif	as_trantype =	'ORCANCEL'	then 
	ls_table =	'select 	utils.convert_to_varchar2(orCancellationTranHdr.tranDate,10,p_style=>101) as tranDate, '+&
					'orCancellationTranHdr.tranNo as tranNo, '+&
					"'O.R. No.: ' || rtrim(orCancellationTranHdr.refOrNo) || ' Reason : ' || "+&
					"rtrim(orCancellationTranHdr.remarks) ||'   By : ' || upper(orCancellationTranHdr.userAdd) as particular, "+&
					'orCancellationTranHdr.amount as amount '+&
					'from 	orCancellationTranHdr '+&
					"where	orCancellationTranHdr.acctNo ='"+as_AcctNo+"'"+  " AND orCancellationTranHdr.divisionCode = '"+gs_divisionCode+"'" +  " AND orCancellationTranHdr.companyCode = '"+gs_companyCode+"'"
					
//ray 02162013 converted script to oracle					
elseif	as_trantype =	'PERMDISCMLX'	then 
	ls_table = 'select 		utils.convert_to_varchar2(permanentDiscTranHdr.tranDate,10,p_style=>101) as tranDate, '+&
					'permanentDiscTranHdr.tranNo as tranNo, '+&
					"'J.O. No.: '|| rtrim(permanentDiscTranHdr.jobOrderNo) || "+&
					"	' Remarks : ' || rtrim(permanentDiscTranHdr.remarks) ||'   By : ' || upper(permanentDiscTranHdr.userAdd) as particular, "+&
					'permanentDiscTranHdr.extendedFeeAmount as amount '+&
					'from 	permanentDiscTranHdr '+&
					"where	permanentDiscTranHdr.acctNo = '"+ as_AcctNo+"'"+  " AND permanentDiscTranHdr.divisionCode = '"+gs_divisionCode+"'" +  " AND permanentDiscTranHdr.companyCode = '"+gs_companyCode+"'"

//ray 02162013 converted script to oracle
elseif	as_trantype =	'REACTIVATION'	then
	ls_table = 	'select 	utils.convert_to_varchar2(reactivationTranHdr.tranDate,10,p_style=>101) as tranDate, '+&
					'reactivationTranHdr.tranNo as tranNo, '+&
					"' J.O. No.: ' || rtrim(reactivationTranHdr.jobOrderNo) || "+&
					"' No. of Ext. : ' || rtrim(cast(reactivationTranHdr.noOfExtension as char(4) ) )||'   By : ' || upper(reactivationTranHdr.userAdd)  as particular, "+&
					'reactivationTranHdr.extendedFeeAmount '+&
					'from reactivationTranHdr '+&
					"where 	reactivationTranHdr.acctNo = '"+as_AcctNo+"'"+  " AND reactivationTranHdr.divisionCode = '"+gs_divisionCode+"'" +  " AND reactivationTranHdr.companyCode = '"+gs_companyCode+"'"

//ray 02132013 converted script to oracle 
elseif	as_trantype =	'REFUND'	then
	ls_table =	'select 	utils.convert_to_varchar2(refundTranHdr.tranDate,10,p_style=>101) as tranDate, '+&
					'refundTranHdr.tranNo as tranNo, '+&
					"'SUBSCRIBER ;   By : ' || upper(refundTranHdr.userName) as particular, "+&
					'refundTranHdr.totalRefundAmount as amount '+&
					'from 	refundTranHdr '+&
					"where 	refundTranHdr.acctNo ='"+as_AcctNo +"'"+  " AND refundTranHdr.divisionCode = '"+gs_divisionCode+"'" +  " AND refundTranHdr.companyCode = '"+gs_companyCode+"'"
					
//ray 02132013 converted script to oracle 					
elseif	as_trantype =	'SALES'	then
	ls_table =	'select 	utils.convert_to_varchar2(salesTranHdr.tranDate,10,p_style=>101) as tranDate, '+&
					'salesTranHdr.tranNo as tranNo, '+&
					"'From Trans: ' || rtrim(sysTransactionParam.tranTypeName) || 'Ref No: ' ||  "+&
					"rtrim(salesTranHdr.refNo)||'   By : ' || upper(salesTranHdr.userAdd) as particular, "+&
					'salesTranHdr.amount as amount '+&
					'from    salesTranHdr, sysTransactionParam '+&
					"where 	salesTranHdr.acctNo = '"+as_AcctNo+"'"+  " AND sysTransactionParam.divisionCode = '"+gs_divisionCode+"'" +  " AND sysTransactionParam.companyCode = '"+gs_companyCode+"'"+&
					'and salesTranHdr.tranTypeCode = sysTransactionParam.tranTypeCode '+  " AND salesTranHdr.divisionCode = '"+gs_divisionCode+"'" +  " AND salesTranHdr.companyCode = '"+gs_companyCode+"'"
					
//ray 02132013 converted script to oracle 					
elseif	as_trantype =	'SERVCALL'	then
	ls_table =	'select 	utils.convert_to_varchar2(serviceCallTranHdr.tranDate,10,p_style=>101) as tranDate, '+&
					'serviceCallTranHdr.tranNo as tranNo, '+&
					"rtrim(serviceCallTranHdr.troubleRemarks) || ' Status : ' ||  "+&
					"rtrim(scStatusMaster.scStatusName) ||'   By : ' || upper(serviceCallTranHdr.userAdd) as particular, "+&
					'0.00 as amount '+&
					'from 	serviceCallTranHdr, scStatusMaster '+&
					"where 	serviceCallTranHdr.acctNo = '"+as_AcctNo+"'"+&
					'and serviceCallTranHdr.scStatusCode = scStatusMaster.scStatusCode '+  " AND serviceCallTranHdr.divisionCode = '"+gs_divisionCode+"'" +  " AND serviceCallTranHdr.companyCode = '"+gs_companyCode+"'"
					
//ray 02132013 converted script to oracle 					
elseif	as_trantype =	'TRANSFER'	then	
	ls_table = 'select 	utils.convert_to_varchar2(transferTranHdr.tranDate,10,p_style=>101) as tranDate, '+&
					'transferTranHdr.tranNo as tranNo, '+&
					"'J.O. No.: '|| rtrim(transferTranHdr.jobOrderNo) ||  "+&
					"' Remarks : ' || rtrim(transferTranHdr.remarks) ||'   By : ' || upper(transferTranHdr.userAdd) as particular, "+&
					'transferTranHdr.extendedFeeAmount as amount	'+&
					'from 	transferTranHdr '+&
					"where 	transferTranHdr.acctNo = '"+as_AcctNo+"'"+  " AND transferTranHdr.divisionCode = '"+gs_divisionCode+"'" +  " AND transferTranHdr.companyCode = '"+gs_companyCode+"'"

//ray 02132013 converted script to oracle
elseif	as_trantype =	'REPLACECM'	then	
	ls_table = 'select 	utils.convert_to_varchar2(replaceSubsCPETranHdr.tranDate,10,p_style=>101) as tranDate, '+&
					'replaceSubsCPETranHdr.tranNo as tranNo, '+&
					"'Old Serial: '|| rtrim(replaceSubsCPETranDtl.oldSerialNo) ||  "+&
					"' New Serial: ' || rtrim(replaceSubsCPETranDtl.newSerialNo) ||'   By : ' || upper(replaceSubsCPETranHdr.userAdd) as particular, "+&
					'replaceSubsCPETranHdr.replacementFee as amount	'+&
					'from 	replaceSubsCPETranHdr '+&
					'inner join replaceSubsCPETranDtl on replaceSubsCPETranHdr.tranNo = replaceSubsCPETranDtl.tranNo ' +&
					"where 	replaceSubsCPETranHdr.acctNo = '"+as_AcctNo+"'"+  " AND replaceSubsCPETranHdr.divisionCode = '"+gs_divisionCode+"'" +  " AND replaceSubsCPETranHdr.companyCode = '"+gs_companyCode+"'"
					
//ray 02132013 converted script to oracle					
elseif	as_tranType = 'REPANADIGI' then
ls_table = 'select 	utils.convert_to_varchar2(replaceSubsCPETranHdr.tranDate,10,p_style=>101) as tranDate, '+&
					'replaceSubsCPETranHdr.tranNo as tranNo, '+&
					"'Old Serial: '|| rtrim(replaceSubsCPETranDtl.oldSerialNo) ||  "+&
					"' New Serial: ' || rtrim(replaceSubsCPETranDtl.newSerialNo) ||'   By : ' || upper(replaceSubsCPETranHdr.userAdd) as particular, "+&
					'replaceSubsCPETranHdr.replacementFee as amount	'+&
					'from 	replaceSubsCPETranHdr '+&
					'inner join replaceSubsCPETranDtl on replaceSubsCPETranHdr.tranNo = replaceSubsCPETranDtl.tranNo ' +&
					"where 	replaceSubsCPETranHdr.acctNo = '"+as_AcctNo+"'"+  " AND replaceSubsCPETranHdr.divisionCode = '"+gs_divisionCode+"'" +  " AND replaceSubsCPETranHdr.companyCode = '"+gs_companyCode+"' " +&					
					"AND replaceSubsCPETranDtl.replRemarksCode = '0004'" + &							
               "UNION ALL " +&					
               'select 	utils.convert_to_varchar2(AppOfDigitalConversionTranHdr.tranDate,10,p_style=>101) as tranDate, ' +&
					'AppOfDigitalConversionTranHdr.tranNo as tranNo, ' +&
               " rtrim(AppOfDigitalConversionTranHdr.specialInstructions) || ' | requested by : ' || " + " rtrim(AppOfDigitalConversionTranHdr.requestedby)  || '   By : ' || upper(AppOfDigitalConversionTranHdr.userAdd) as particular, " +&
               'AppOfDigitalConversionTranHdr.replacementFee as amount ' +&
               'from AppOfDigitalConversionTranHdr ' +&
               "where AppOfDigitalConversionTranHdr.acctNo = '" + as_AcctNo + "'" +  " AND AppOfDigitalConversionTranHdr.divisionCode = '"+gs_divisionCode+"'" +  " AND AppOfDigitalConversionTranHdr.companyCode = '"+gs_companyCode+"'" 


elseif	as_tranType = 'UPDATELOCKIN' then
		ls_table = "select updatelockinperiodtranhdr.dateadd  tranDate, updatelockinperiodtranhdr.tranno as tranNo, 'Updated By:  '|| useradd || ' Old Lock In Period : ' || oldlockinperiod   || ',' || 'New Lockin Period : '  || newlockinperiod  , 0.00  amount  from updatelockinperiodtranhdr "  +&
			"where acctno ='" + as_AcctNo +"' and divisioncode = '"+gs_divisionCode+"' and companycode ='"+gs_companyCode+"'"
			
elseif	as_tranType = 'CONVD2F' then
	ls_table = 'select 	utils.convert_to_varchar2(replaceSubsCPETranHdr.tranDate,10,p_style=>101) as tranDate, '+&
					'replaceSubsCPETranHdr.tranNo as tranNo, '+&
					"'Old Serial: '|| rtrim(replaceSubsCPETranDtl.oldSerialNo) ||  "+&
					"' New Serial: ' || rtrim(replaceSubsCPETranDtl.newSerialNo) ||'   By : ' || upper(replaceSubsCPETranHdr.userAdd) as particular, "+&
					'replaceSubsCPETranHdr.replacementFee as amount	'+&
					'from 	replaceSubsCPETranHdr '+&
					'inner join replaceSubsCPETranDtl on replaceSubsCPETranHdr.tranNo = replaceSubsCPETranDtl.tranNo ' +&
					"where 	replaceSubsCPETranHdr.acctNo = '"+as_AcctNo+"'"+  " AND replaceSubsCPETranHdr.divisionCode = '"+gs_divisionCode+"'" +  " AND replaceSubsCPETranHdr.companyCode = '"+gs_companyCode+"' " +&					
					"AND replaceSubsCPETranDtl.replRemarksCode = '0005'" + &							
               "UNION ALL " +&					
               'select 	utils.convert_to_varchar2(conversiondoctofibtran.tranDate,10,p_style=>101) as tranDate, ' +&
					'conversiondoctofibtran.tranNo as tranNo, ' +&
               " rtrim(conversiondoctofibtran.specialInstructions) || ' | requested by : ' || " + " rtrim(conversiondoctofibtran.requestedby)  || '   By : ' || upper(conversiondoctofibtran.userAdd) as particular, " +&
               'conversiondoctofibtran.replacementFee as amount ' +&
               'from conversiondoctofibtran ' +&
               "where conversiondoctofibtran.acctNo = '" + as_AcctNo + "'" +  " AND conversiondoctofibtran.divisionCode = '"+gs_divisionCode+"'" +  " AND conversiondoctofibtran.companyCode = '"+gs_companyCode+"'" 
ELSEIF AS_TRANTYPE = 'SALESADDON' THEN
					ls_table = 'select utils.convert_to_varchar2(s.trandate,10,p_style=>101) as trandate, ' +&
								 ' s.tranno as tranno' +&
								 "'Serial Number:' || ss.serialno as particular, " +&
								 's.amount as amount ' +&
								 'from salesaddontranhdr s ' +&
								 'inner join SOLD_ADD_ON_ITEMS ss on ss.tranno = s.tranno and ss.divisioncode = s.divisioncode '+&
								 "where s.acctno ='" + as_acctNo + "' and divisioncode = '" + gs_divisioncode + "'"
end if 

return ls_table

--END VALIDASI
  
--TAB STATEMENT OF ACCOUNT

SELECT  arTranHdr.tranTypeCode ,
   arTranHdr.tranNo ,
   arTranHdr.arTypeCode ,
   arTranHdr.tranDate ,
   arTranHdr.balance ,
   arTranHdr.remarks ,
	  arTranHdr.periodFrom,
	  arTranHdr.periodTo,
   arTypeMaster.arTypeName ,
   arAcctSubscriber.subscriberName ,
   vw_arAcctAddress.completeAddress ,
   arAcctSubscriber.acctNo ,
   subsUserTypeMaster.subsUserTypeName,
   arPackageMaster.packageName ,
   arPackageMaster.packageDescription,
   chargeTypeMaster.chargeTypeName ,
   vw_arAcctAddress.contactNo ,
   vw_arAcctAddress.floorNo ,
   vw_arAcctAddress.bldgName ,
   vw_arAcctAddress.streetName ,
   vw_arAcctAddress.subdivisionCode ,
   vw_arAcctAddress.barangayCode ,
   arAcctSubscriber.mLineCurrentMonthlyRate currentMontlyRate,
   provinceMaster.provinceName ,
   municipalityMaster.municipalityName ,
   barangayMaster.barangayName ,
   subdivisionMaster.subdivisionName ,
   arTranHdr.balance totalDueNgeni ,
   arTranHdr.balance totalDueDati ,
   arAcctSubscriber.billingMinimumDue,
   A.completeAddress siteA, B.completeAddress siteB, vw_arAcctAddress.contactName,
   upper(arAccountMaster.currencyCode) currencyCode, subscriberCirCuitId.circuitID
FROM arTranHdr
   inner join arAcctSubscriber		on arTranHdr.acctNo = arAcctSubscriber.acctNo 
			and arTranHdr.divisionCode = arAcctSubscriber.divisionCode
       and arTranHdr.companyCode  = arAcctSubscriber.companyCode
  	  inner join arTypeMaster 			on arTranHdr.arTypeCode = arTypeMaster.arTypeCode
	  		and arTranHdr.divisionCode = arTypeMaster.divisionCode
       and arTranHdr.companyCode  = arTypeMaster.companyCode
  	  inner join vw_arAcctAddress 	on arTranHdr.acctNo = vw_arAcctAddress.acctNo and vw_arAcctAddress.addressTypeCode = 'BILLING'
  		and arTranHdr.divisionCode = vw_arAcctAddress.divisionCode
   and arTranHdr.companyCode  = vw_arAcctAddress.companyCode
  inner join vw_arAcctAddress  A	on arTranHdr.acctNo = A.acctNo and A.addressTypeCode = 'SERVADR1'
  		and arTranHdr.divisionCode = a.divisionCode
   and arTranHdr.companyCode  = a.companyCode
  left join vw_arAcctAddress  B	on arTranHdr.acctNo = B.acctNo and B.addressTypeCode = 'SERVADR2'
	  		and arTranHdr.divisionCode = b.divisionCode
       and arTranHdr.companyCode  = b.companyCode
  	  inner join arPackageMaster 		on arAcctSubscriber.packageCode = arPackageMaster.packageCode
	  		and arPackageMaster.divisionCode = arAcctSubscriber.divisionCode
       and arPackageMaster.companyCode  = arAcctSubscriber.companyCode
  	  inner join chargeTypeMaster 	on arAcctSubscriber.chargeTypeCode = chargeTypeMaster.chargeTypeCode
	  inner join provinceMaster 		on vw_arAcctAddress.provinceCode = provinceMaster.provinceCode
	  inner join municipalityMaster 	on vw_arAcctAddress.municipalityCode = municipalityMaster.municipalityCode
	  inner join barangayMaster 		on vw_arAcctAddress.barangayCode = barangayMaster.barangayCode
	  left  join subdivisionMaster 	on vw_arAcctAddress.subdivisionCode = subdivisionMaster.subdivisionCode
	  inner join subsUserTypeMaster  on arAcctSubscriber.subsUserTypeCode = subsUserTypeMaster.subsUserTypeCode
   inner join arAccountMaster     on arAcctSubscriber.acctNo = arAccountMaster.acctNo
   		and arAccountMaster.divisionCode = arAcctSubscriber.divisionCode
       and arAccountMaster.companyCode  = arAcctSubscriber.companyCode
  	  inner join joTranHdr           on arAcctSubscriber.acctNo = joTranHdr.acctNo  and joTranHdr.tranTypeCode = 'APPLYML'
	and jotranhdr.jostatuscode = 'CL'
	and joTranHdr.divisionCode = arAcctSubscriber.divisionCode
   and joTranHdr.companyCode  = arAcctSubscriber.companyCode
  left join subscriberCircuitID on arAccountMaster.acctNo = subscriberCircuitID.acctNo
		and arAccountMaster.divisionCode = subscriberCircuitID.divisionCode
   and arAccountMaster.companyCode  = subscriberCircuitID.companyCode
  WHERE ( arTranHdr.balance > 0) and (arAcctSubscriber.acctNo = :as_acctNo)
   and (arTranHdr.divisionCode = :as_division) and (arTranHdr.companyCode = :as_company)
		and ((month(arTranHdr.tranDate) = :ai_month and year(arTranHdr.tranDate) = :ai_year) or :as_allDates = 'Y')
		

--TAB UNPROCESS TRANS
		
  SELECT vw_unprocessedTransactions.tranMonth,   
         vw_unprocessedTransactions.tranYear,   
         vw_unprocessedTransactions.mLineAmount,   
         vw_unprocessedTransactions.extAmount,   
         vw_unprocessedTransactions.daysConsumption,   
         vw_unprocessedTransactions.mLineBaseDailyRate,   
         vw_unprocessedTransactions.extBaseDailyRate,   
         sysTransactionParam.tranTypeName,   
         vw_unprocessedTransactions.trandate,   
         vw_unprocessedTransactions.processed  
    FROM vw_unprocessedTransactions,   
         sysTransactionParam  
   WHERE ( vw_unprocessedTransactions.trantypecode = sysTransactionParam.tranTypeCode )     
   AND ( vw_unprocessedTransactions.divisionCode = sysTransactionParam.divisionCode )
   AND ( vw_unprocessedTransactions.companyCode = sysTransactionParam.companyCode )
   AND ( ( vw_unprocessedTransactions.acctNo = :as_acctNo ) 
   AND ( sysTransactionParam.divisionCode = :as_division )
   AND ( sysTransactionParam.companyCode = :as_company ))


   --TAB REFUND ADVISE
   
     SELECT  refundAdvise.acctNo ,           
			 refundAdvise.packageCode ,           
			refundAdvise.totalAdvDep ,           
			refundAdvise.pdFee ,           
			refundAdvise.arBalance ,           
			refundAdvise.pdDate ,           
			refundAdvise.daysConsumption ,           
			refundAdvise.noOfMainLine ,           
			refundAdvise.noOfExtension ,           
			refundAdvise.mLineMonthlyRate ,           
			refundAdvise.extMonthlyRate ,           
			refundAdvise.mLineDailyRate ,           
			refundAdvise.extDailyRate ,           
			refundAdvise.insuranceAmount ,           
			refundAdvise.rentalAmount ,           
			refundAdvise.billingAmount ,           
			refundAdvise.refundableAmount ,          
			 arAcctSubscriber.subscriberName ,           
			vw_arAcctAddress.completeAddress ,           
			arPackageMaster.packageName,
		   arPackageMaster.serviceType
FROM refundAdvise ,           
		arAcctSubscriber ,           
		arPackageMaster ,
      vw_arAcctAddress    
WHERE ( refundAdvise.acctNo = arAcctSubscriber.acctNo ) 
and   ( refundAdvise.divisionCode = arAcctSubscriber.divisionCode )
and	( refundAdvise.companyCode = arAcctSubscriber.companyCode )
and   ( arAcctSubscriber.packageCode = arPackageMaster.packageCode ) 
and   ( arPackageMaster.divisionCode = arAcctSubscriber.divisionCode )
and	( arPackageMaster.companyCode = arAcctSubscriber.companyCode )
and   ( vw_arAcctAddress.acctNo = arAcctSubscriber.acctNo  and vw_arAcctAddress.addressTypeCode = 'BUSINESS' )
and   ( vw_arAcctAddress.divisionCode = arAcctSubscriber.divisionCode )
and	( vw_arAcctAddress.companyCode = arAcctSubscriber.companyCode )
and   ( ( refundAdvise.acctNo = :as_acctNo ) and (refundAdvise.divisionCode = :as_division)
         and (refundAdvise.companyCode = :as_company) )  
         
 --SUB QUERY REPPORT dw_sub_advdep

  SELECT ocTypeMaster.ocTypeName,   
         sum(balance) as balance  
    FROM arOpenCreditMaster,   
         ocTypeMaster  
   WHERE ( arOpenCreditMaster.ocTypeCode = ocTypeMaster.ocTypeCode ) and  
         ( arOpenCreditMaster.divisionCode = ocTypeMaster.divisionCode ) and
         ( arOpenCreditMaster.companyCode = ocTypeMaster.companyCode ) and
         (( arOpenCreditMaster.recordStatus is null OR  
            arOpenCreditMaster.recordStatus = 'N') AND  
          ( arOpenCreditMaster.balance > 0 ) AND  
          ( arOpenCreditMaster.acctNo = :as_acctno ) AND  
          ( arOpenCreditMaster.ocTypeCode in (select itemValue from sysparamstring where itemGroup = 'ALLOWEDOCTYPES' and itemName = 'OCFORREFUND' and sysparamstring.divisionCode = :as_division and sysparamstring.companyCode = :as_company) ) AND
          ( arOpenCreditMaster.divisionCode = :as_division ) AND
          ( arOpenCreditMaster.companyCode = :as_company ) ) 
GROUP BY ocTypeMaster.ocTypeName   

--SUB QUERY REPPORT dw_sub_subsstbforpullout

SELECT subscriberCPEMaster.serialNo  
    FROM subscriberCPEMaster  
   WHERE ( subscriberCPEMaster.cpeTypeCode = :as_cpeType ) AND ( subscriberCPEMaster.acctno = :as_acctno ) AND  
			( subscriberCPEMaster.divisionCode = :as_division ) AND ( subscriberCPEMaster.companyCode = :as_company ) AND
         ( subscriberCPEMaster.acquisitionTypeCode <> 'BUY' )    


--BUTTON CLICK REFRESH/REVIEW

string ls_errorMsg

if not f_preComputeRefundAmount_bsg(is_acctNo, ls_errorMsg) then
	rollback using SQLCA;
	guo_func.msgBox('Warning!', ls_errorMsg)
	return
end IF

--VALADISI F_PRECOMPUTEREFUNDAMOUNT

decimal{2} 	ld_totalAdv, ld_totalDep, ld_totalEqDep, ld_totalRIP, ld_arBalance
decimal{2}	ld_mLineDailyRate, ld_extDailyRate, ld_billingAmount, ld_arIncludingPDF, ld_currentMonthlyBill
long 			ll_count, ll_noOfDaysOfTheMonth, ll_daysConsumed, ll_noOfExtension
integer		li_currentMonth, li_currentYear
boolean		lb_gotBilledThisMonth=FALSE, ab_billingPeriodExists=FALSE

ld_arIncludingPDF = 0

select count(*)
  into: ll_count
  from refundAdvise
 where acctNo = :as_acctNo
 and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	using SQLCA;
if SQLCA.sqlCode < 0 then
	as_errorMsg = string(SQLCA.sqlCode) + '~r~n' + SQLCA.sqlErrText
	return FALSE
end if

if isNull(ll_count) then ll_count = 0

if ll_count = 0 then
	insert into refundAdvise ( acctNo, divisionCode, companyCode ) 
		  values ( :as_acctNo, :gs_divisionCode, :gs_companyCode ) 
		   using SQLCA;
	if SQLCA.sqlCode < 0 then
		as_errorMsg = string(SQLCA.sqlCode) + '~r~n' + SQLCA.sqlErrText
		return FALSE
	end if
end if

uo_subscriber_bsg luo_subscriber
if not luo_subscriber.setAcctNo(as_acctNo) then
	as_errorMsg = string(luo_subscriber.lastSQLCode) + '~r~n' + luo_subscriber.lastSQLErrText
	return FALSE
end IF

--VALIDASI SETACCTNO
lastMethodAccessed = 'setAcctNo'

acctNo = as_acctNo

select 
tranNo,
acctName,
typeOfBusiness,
lastName,
firstName,
middleName,
motherMaidenName,
citizenshipCode,
sex,
birthDate,
civilStatus,
chargeTypeCode, 
subsUserTypeCode,
packageCode, 
subscriberStatusCode,  
subsTypeCode,  
dateApplied,
dateInstalled, 
dateAutoDeactivated,
dateManualDeactivated,
datePermanentlyDisconnected,
dateReactivated,
qtyAcquiredSTB,
totalBoxesBeforeDeactivation,
numberOfRooms,
occupancyRate, 
mLineCurrentMonthlyRate, 
mLinePreviousMonthlyRate,
extCurrentMonthlyRate, 
extPreviousMonthlyRate,
withAdvances,
locked,
lockedBy,
lockedWithTrans,
referenceJONo,
acquisitionTypeCode,
arAccountMaster.accountTypeCode,
agentCode,
useradd,
dateadd,
arAccountMaster.contactNo,
emailAdd,
arAccountMaster.currencyCode,
a.completeAddress,
b.completeAddress,
c.completeAddress,
d.completeAddress

into 

:tranNo,
:subscriberName,
:typeOfBusiness,
:lastName,
:firstName,
:middleName,
:motherMaidenName,
:citizenshipCode,
:sex,
:birthDate,
:civilStatus,
:chargeTypeCode,
:subsUserTypeCode,
:packageCode,
:subscriberStatusCode,
:subsTypeCode,
:dateApplied,
:dateInstalled,
:dateAutoDeactivated,
:dateManualDeactivated,
:datePermanentlyDisconnected,
:dateReactivated,
:qtyAcquiredSTB,
:totalBoxesBeforeDeactivation,
:numberOfRooms,
:occupancyRate,
:mLineCurrentMonthlyRate,
:mLinePreviousMonthlyRate,
:extCurrentMonthlyRate,
:extPreviousMonthlyRate,
:withAdvances,
:locked,
:lockedBy,
:lockedWithTrans,
:referenceJONo,
:acquisitionTypeCode,
:accountTypeCode,
:agentCode,
:useradd,
:dateadd,
:contactNo,
:emailAdd,
:currencyCode,
:siteA,
:siteB,
:businessAdd,
:billingAdd
from
arAcctSubscriber
inner join arAccountMaster on arAccountMaster.acctNo = arAcctSubscriber.acctNo
	and arAccountMaster.divisionCode = arAcctSubscriber.divisionCode
	and arAccountMaster.companyCode = arAcctSubscriber.companyCode
inner join vw_arAcctAddress a on a.acctNo = arAcctSubscriber.acctNo and a.addressTypeCode = 'SERVADR1' 
	and a.divisionCode  = arAcctSubscriber.divisionCode
	and a.companyCode = arAcctSubscriber.companyCode
left join vw_arAcctAddress b on b.acctNo = arAcctSubscriber.acctNo and b.addressTypeCode = 'SERVADR2' 
	and b.divisionCode = arAcctSubscriber.divisionCode
	and b.companyCode = arAcctSubscriber.companyCode
left join vw_arAcctAddress c on c.acctNo = arAcctSubscriber.acctNo and c.addressTypeCode = 'BUSINESS' 
	and c.divisionCode = arAcctSubscriber.divisionCode
	and c.companyCode = arAcctSubscriber.companyCode
inner join vw_arAcctAddress d on d.acctNo = arAcctSubscriber.acctNo and d.addressTypeCode = 'BILLING' 
	and d.divisionCode = arAcctSubscriber.divisionCode
	and d.companyCode = arAcctSubscriber.companyCode
where arAcctSubscriber.acctNo = :acctNo
and arAcctSubscriber.divisionCode = :gs_divisionCode 
and arAcctSubscriber.companyCode = :gs_companyCode

using SQLCA;
if SQLCA.sqlcode < 0 then
	lastSQLCode		= string(SQLCA.sqlcode)
	lastSQLErrText	= SQLCA.sqlerrtext
	return FALSE
elseif SQLCA.sqlcode = 100 then
	lastSQLCode		= string(SQLCA.sqlcode)
	lastSQLErrText	= "The account number you've just entered does not exist."
	return FALSE
end if

select accountTypeCode
into :accountTypeCode
from arAccountMaster
where acctNo = :acctNo
and divisionCode = :gs_divisionCode
and companyCode = :gs_companyCode
using SQLCA;
if SQLCA.sqlcode < 0 then
	lastSQLCode		= string(SQLCA.sqlcode)
	lastSQLErrText	= SQLCA.sqlerrtext
	return FALSE
elseif SQLCA.sqlcode = 100 then
	lastSQLCode		= string(SQLCA.sqlcode)
	lastSQLErrText	= "The account number you've just entered does not exist."
	return FALSE
end if

select chargeTypeName
  into :chargeTypeName
  from chargeTypeMaster
 where chargeTypeCode = :chargeTypeCode
 using SQLCA;
if SQLCA.sqlcode < 0 then
	lastSQLCode		= string(SQLCA.sqlcode)
	lastSQLErrText	= SQLCA.sqlerrtext
	return FALSE
elseif SQLCA.sqlcode = 100 then
	lastSQLCode		= string(SQLCA.sqlcode)
	lastSQLErrText	= "The charge type code [" + chargeTypeCode + "] does not exist."
	return FALSE
end if

select subsTypeName
  into :subsTypeName
  from subscriberTypeMaster
 where subsTypeCode = :subsTypeCode
and companyCode = :gs_companyCode
using SQLCA;
if SQLCA.sqlcode < 0 then
	lastSQLCode		= string(SQLCA.sqlcode)
	lastSQLErrText	= SQLCA.sqlerrtext
	return FALSE
elseif SQLCA.sqlcode = 100 then
	lastSQLCode		= string(SQLCA.sqlcode)
	lastSQLErrText	= "The subscriber type code [" + subsTypeCode + "] does not exist."
	return FALSE
end if

select subsUserTypeName
  into :subsUserTypeName
  from subsUserTypeMaster
 where subsUserTypeCode = :subsUserTypeCode
 using SQLCA;
if SQLCA.sqlcode < 0 then
	lastSQLCode		= string(SQLCA.sqlcode)
	lastSQLErrText	= SQLCA.sqlerrtext
	return FALSE
elseif SQLCA.sqlcode = 100 then
	lastSQLCode		= string(SQLCA.sqlcode)
	lastSQLErrText	= "The subscriber user type code [" + subsUserTypeCode + "] does not exist."
	return FALSE
end if

select a.packageName, a.packageTypeCode, b.packageTypeName, a.servTypeCode
  into :packageName, :packageTypeCode, :packageTypeName, :servTypeCode
  from arPackageMaster a, packageTypeMaster b
 where a.packageTypeCode = b.packageTypeCode
 	and a.divisionCode = :gs_divisionCode
	and a.companyCode = :gs_companyCode
	and b.divisionCode = :gs_divisionCode
		and b.companyCode = :gs_companyCode
		and a.packageCode = :packageCode
 using SQLCA;
if SQLCA.sqlcode < 0 then
	lastSQLCode		= string(SQLCA.sqlcode)
	lastSQLErrText	= SQLCA.sqlerrtext
	return FALSE
elseif SQLCA.sqlcode = 100 then
	lastSQLCode		= string(SQLCA.sqlcode)
	lastSQLErrText	= "The package code [" + packageCode + "] does not exist."
	return FALSE
end if

select subscriberStatusName
  into :subscriberStatusName
  from subscriberStatusMaster
 where subscriberStatusCode = :subscriberStatusCode
 using SQLCA;
if SQLCA.sqlcode < 0 then
	lastSQLCode		= string(SQLCA.sqlcode)
	lastSQLErrText	= SQLCA.sqlerrtext
	return FALSE
elseif SQLCA.sqlcode = 100 then
	lastSQLCode		= string(SQLCA.sqlcode)
	lastSQLErrText	= "The subscriber status code [" + subscriberStatusCode + "] does not exist."
	return FALSE
end if

//~~~~~~~~~~~~~~~~~~CURRENCY~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if isNull(currencyCode) then
	currencyCode = ''
end if

select conversionRate
into :conversionRate
from currencyMaster
where currencyCode = :currencyCode
using SQLCA;
if SQLCA.sqlcode < 0 then
	lastSQLCode	= string(SQLCA.sqlcode)
	lastSQLErrText	= SQLCA.sqlerrtext
	return FALSE
elseif SQLCA.sqlcode = 100 then
	lastSQLCode	= string(SQLCA.sqlcode)
	lastSQLErrText	= "The currency code [" + currencyCode + "] does not exist."
	return FALSE
end if
//~~~~~~~~~~~~~~~~~~END~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

return TRUE

--END VALIDASI SETACCTNO

if not luo_subscriber.getSubscriptionDeposit(ld_totalDep) then
	as_errorMsg = string(luo_subscriber.lastSQLCode) + '~r~n' + luo_subscriber.lastSQLErrText
	return FALSE
end IF

--VALIDASI getSubscriptionDeposit

	select sum(balance)
  into :ad_amount
  from arOpenCreditMaster
 where acctNo = :acctNo
 	and divisionCode = :gs_divisionCode
and companyCode = :gs_companyCode
and ocTypeCode = 'SUBSDEP'
	and (recordStatus is null or recordStatus <> 'V')
 using SQLCA;
if SQLCA.sqlcode < 0 then
	lastSQLCode 	= string(SQLCA.sqlCode)
	lastSQLErrText = SQLCA.sqlErrText
	return FALSE
end if

if isnull(ad_amount) then ad_amount = 0

return TRUE

--END VALIDASI

if not luo_subscriber.getSubscriptionAdvances(ld_totalAdv) then
	as_errorMsg = string(luo_subscriber.lastSQLCode) + '~r~n' + luo_subscriber.lastSQLErrText
	return FALSE
end IF

--validasi getSubscriptionAdvances

select sum(balance)
  into :ad_amount
  from arOpenCreditMaster
 where acctNo = :acctNo
 	and divisionCode = :gs_divisionCode
and companyCode = :gs_companyCode
and ocTypeCode = 'SUBSADV'
	and (recordStatus is null or recordStatus <> 'V')
 using SQLCA;
if SQLCA.sqlcode < 0 then
	lastSQLCode 	= string(SQLCA.sqlCode)
	lastSQLErrText = SQLCA.sqlErrText
	return FALSE
end if

if isnull(ad_amount) then ad_amount = 0

Return True


--end validasi getSubscriptionAdvances

if not luo_subscriber.getSubsEquipmentDeposit(ld_totalEqDep) then
	as_errorMsg = string(luo_subscriber.lastSQLCode) + '~r~n' + luo_subscriber.lastSQLErrText
	return FALSE
end IF

--valodasi getSubsEquipmentDeposit
select sum(balance)
  into :ad_amount
  from arOpenCreditMaster
 where acctNo = :acctNo
 	and divisionCode = :gs_divisionCode
and companyCode = :gs_companyCode
and ocTypeCode = 'SUBSDEQ'
	and (recordStatus is null or recordStatus <> 'V')
 using SQLCA;
if SQLCA.sqlcode < 0 then
	lastSQLCode 	= string(SQLCA.sqlCode)
	lastSQLErrText = SQLCA.sqlErrText
	return FALSE
end if

if isnull(ad_amount) then ad_amount = 0

return TRUE

--end validasi 

s_applPermDiscInfo lstr_applPermDiscInfo
if not luo_subscriber.getApplPermDiscInfo(lstr_applPermDiscInfo) then
	as_errorMsg = string(luo_subscriber.lastSQLCode) + '~r~n' + luo_subscriber.lastSQLErrText
	return FALSE
end IF

--validasi getApplPermDiscInfo


    select tranNo,
  			tranDate,
			currentSubscriberStatusCode,
			preferredDateTimeFrom
  	 into :as_applPermDiscInfo.tranNo,
  		 	:as_applPermDiscInfo.tranDate,
			:as_applPermDiscInfo.currentSubscriberStatusCode,
			:as_applPermDiscInfo.preferredDateTimeFrom
from (	  select tranNo,
  			tranDate,
			currentSubscriberStatusCode,
			preferredDateTimeFrom		
  	 from applOfPermanentDiscTranHdr
  	where acctNo = :acctNo
	  and divisionCode = :gs_divisionCode
and companyCode = :gs_companyCode
and applicationStatusCode <> 'CN'
order by tranNo desc)
where rownum < 2

	using SQLCA;
if SQLCA.sqlCode = 0 then
	select count(*)
	  into :as_applPermDiscInfo.noOfSTB
	  from applOfPermanentDiscTranHdr, applOfPermanentDiscTranDtl
	 where applOfPermanentDiscTranHdr.tranNo       = applOfPermanentDiscTranDtl.tranNo
		and applOfPermanentDiscTranHdr.divisionCode = applOfPermanentDiscTranDtl.divisionCode
		and applOfPermanentDiscTranHdr.companyCode  = applOfPermanentDiscTranDtl.companyCode	 
		
		and applOfPermanentDiscTranHdr.divisionCode = :gs_divisionCode
		and applOfPermanentDiscTranHdr.companyCode = :gs_companyCode
		
		and applOfPermanentDiscTranHdr.tranNo = :as_applPermDiscInfo.tranNo
		
	 using SQLCA;
	if SQLCA.sqlcode < 0 then
		lastSQLCode = string(SQLCA.sqlcode)
		lastSQLErrText = SQLCA.sqlerrtext
		return FALSE
	elseif SQLCA.sqlcode = 100 then
		as_applPermDiscInfo.noOfSTB = 0
	end if
end if

return TRUE

--end validasi 

if not luo_subscriber.getUnprocessedRIPAmount(ld_totalRIP) then
	as_errorMsg = string(luo_subscriber.lastSQLCode) + '~r~n' + luo_subscriber.lastSQLErrText
	return FALSE
end IF

--validasi getUnprocessedRIPAmount
lastMethodAccessed = 'getUnprocessedRIPAmount'

select sum(amount - paidAmt)
  into :ad_amount
  from subsInitialPayment
 where acctNo = :acctNo
 	and divisionCode = :gs_divisionCode
and companyCode = :gs_companyCode
and balance > 0
 using SQLCA;
if SQLCA.sqlcode < 0 then
	lastSQLCode = string(SQLCA.sqlcode)
	lastSQLErrText = SQLCA.sqlerrtext
	Return False
end if

if isNull(ad_amount) then ad_amount = 0

Return True

--end validasi 

if not luo_subscriber.getARBalance(ld_arBalance) then
	as_errorMsg = string(luo_subscriber.lastSQLCode) + '~r~n' + luo_subscriber.lastSQLErrText
	return FALSE
end IF

--validasi getARBalance
lastMethodAccessed = 'getARBalance'
select sum(balance)
  into :ad_balance
  from arTranHdr
 where acctNo = :acctNo
 	and divisionCode = :gs_divisionCode
and companyCode = :gs_companyCode
and balance > 0
 using SQLCA;
if SQLCA.sqlcode < 0 then
	lastSQLCode = string(SQLCA.sqlcode)
	lastSQLErrText = SQLCA.sqlerrtext
	return FALSE
end if

if isnull(ad_balance) then ad_balance = 0

return TRUE

--end validasi

li_currentMonth = month(date(guo_func.get_server_date()))
li_currentYear  = year(date(guo_func.get_server_date()))

--==================================================
--portion to get the no of days consumption
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
dateTime ldt_billingDate, ldt_billingDateFrom, ldt_billingDateTo

if not f_getBillingInfo(month(date(lstr_applPermDiscInfo.preferredDateTimeFrom)), year(date(lstr_applPermDiscInfo.preferredDateTimeFrom)), &
								ldt_billingDate, ldt_billingDateFrom, ldt_billingDateTo) then
	as_errorMsg = string(SQLCA.sqlCode) + '~r~n' + SQLCA.sqlErrText
	return FALSE
end IF

--validasi f_getbillingInfo

select billingDate,
		 billingPeriodFrom,
		 billingPeriodTo
  into :adt_billingDate,
		 :adt_billingPeriodFrom,
		 :adt_billingPeriodTo
  from billingPeriods
 where billingMonth = :ai_month
 	and billingYear = :ai_year
 and divisionCode = :gs_divisionCode
and companyCode = :gs_companyCode
using SQLCA;
if SQLCA.sqlCode < 0 then
	return FALSE	
end if

return TRUE

--end validasi

ll_noOfDaysOfTheMonth	=	guo_func.get_month_days2(lstr_applPermDiscInfo.preferredDateTimeFrom)

if not f_computeBillingWasPerformed(month(date(lstr_applPermDiscInfo.preferredDateTimeFrom)), &
										  year(date(lstr_applPermDiscInfo.preferredDateTimeFrom)), &
										  ab_billingPeriodExists) then
	as_errorMsg = string(SQLCA.sqlCode) + '~r~n' + SQLCA.sqlErrText
	return FALSE
end IF

--validasi f_computeBillingWasPerformed

datetime ldt_billingDate

select billingDate
  into :ldt_billingDate
  from billingPeriods
 	where billingMonth = :ai_month
 	and billingYear = :ai_year
 	and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
using SQLCA;
if SQLCA.sqlCode < 0 then
	return FALSE
elseif SQLCA.sqlCode = 100 then
	ab_billingPeriodExists = FALSE
else
	ab_billingPeriodExists = TRUE
end if

return TRUE

--end validasi

if ab_billingPeriodExists then
	if (lstr_applPermDiscInfo.preferredDateTimeFrom < ldt_billingDate) or isNull(ldt_billingDate) or (date(ldt_billingDate) = date('1900/1/1')) then
		ll_daysConsumed = integer(string(lstr_applPermDiscInfo.preferredDateTimeFrom, 'dd')) - 1
	else
		ll_daysConsumed =	0 - ((ll_noOfDaysOfTheMonth - Day(Date(lstr_applPermDiscInfo.preferredDateTimeFrom))) + 1)
	end if
else
	ll_daysConsumed = integer(string(lstr_applPermDiscInfo.preferredDateTimeFrom, 'dd')) - 1
end if
--==================================================
-- end of portion to get the no of days consumption
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

lb_gotBilledThisMonth = luo_subscriber.gotBilledThisMonth(ldt_billingDate)

--==================================================
--get the no of box subject for insuance and rental
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

ld_mLineDailyRate = luo_subscriber.mLineCurrentMonthlyRate / ll_noOfDaysOfTheMonth
ld_extDailyRate	= luo_subscriber.extCurrentMonthlyRate / ll_noOfDaysOfTheMonth
ld_billingAmount 	= (ld_mLineDailyRate * ll_daysConsumed) + (ll_noOfExtension * ld_extDailyRate * ll_daysConsumed)

ld_billingAmount	= ld_billingAmount //+ ld_insuranceAmtBefore2003 + ld_rentalAmt

if ld_billingAmount < 0 then ld_billingAmount = 0

if lb_gotBilledThisMonth then
	ld_billingAmount 				= 0
end if

ld_arIncludingPDF = ld_arIncludingPDF + ld_totalRIP + ld_arBalance + ld_billingAmount

update refundAdvise
	set packageCode = :luo_subscriber.packageCode,
		 totalAdvDep = :ld_totalDep + :ld_totalAdv,
		 pdFee		 = :ld_totalRIP,
		 arBalance	 = :ld_arBalance,
		 pdDate		 = :lstr_applPermDiscInfo.preferredDateTimeFrom,
		 daysConsumption = :ll_daysConsumed,
		 noOfMainLine	  = 1,
		 noOfExtension	  = :ll_noOfExtension,
		 mLineMonthlyRate= :luo_subscriber.mLineCurrentMonthlyRate,
		 extMonthlyRate  = :luo_subscriber.extCurrentMonthlyRate,
		 mLineDailyRate  = :ld_mLineDailyRate,
		 extDailyRate	  = :ld_extDailyRate,
		 insuranceAmount = 0 /*:ld_insuranceAmtBefore2003*/,
		 rentalAmount	  = 0 /*:ld_rentalAmt*/,
		 billingAmount	  = :ld_billingAmount,
		 refundableAmount= (:ld_totalDep + :ld_totalAdv + :ld_totalEqDep) - (:ld_arIncludingPDF)
 where acctNo = :as_acctNo
 and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	using SQLCA;
if SQLCA.sqlCode < 0 then
	as_errorMsg = string(SQLCA.sqlCode) + '~r~n' + SQLCA.sqlErrText
	return FALSE
end if

return TRUE

--END VALIDASI

commit using SQLCA;

dw_refundAdvise.setTransObject(SQLCA)
dw_refundAdvise.retrieve(is_acctNo)
dw_refundAdvise.object.t_preparedby.text = gs_ufullname

 --TAB IMAGE

--BUTTON RETRIEVE

int li_ctr,li_rowCount,li_pic
string ls_imageTypeCode,ls_imagetypename

tab_1.tp_images.dw_images.reset()
li_rowCount = tab_1.tp_images.dw_images.retrieve(as_acctNo,gs_divisioncode,gs_companyCode)
tab_1.tp_images.plb_1.reset()
tab_1.tp_images.plb_1.deletepictures( )

for li_ctr = 1 to li_rowCount
	tab_1.tp_images.plb_1.pictureHeight = 100
	tab_1.tp_images.plb_1.pictureWidth = 100
	
	ls_imageTypeCode =	tab_1.tp_images.dw_images.getItemString(li_ctr,"imageTypecode")
	
	select imagetypename 
	into :ls_imageTypeName
	from imagetypemaster
	where imagetypecode = :ls_imageTypeCode
	using SQLCA;
	if SQLCA.SQLCode <> 0 then
			is_msgNo 	= 'Error in Select..' 
			is_msgTrail	= 'SQL Error Code : ' + string(SQLCA.SQLCode) + &
					  'SQL Error Text : ' + SQLCA.SQLErrText
		return 
	end if	
	
	
	tab_1.tp_images.plb_1.AddItem(ls_imagetypename,li_ctr)
next

changeDirectory(APPLICATION_PATH)
tab_1.tp_images.plb_1.triggerEvent(selectionChanged!)

--AFTER THE DATA SHOW , DOUBLE CLICK THEN WILL SHOW WINDOW POP UP IMAGE

--BUTTON UPLOAD
 SELECT  imageTypeMaster.imageTypeCode , 
 imageTypeMaster.imageTypeName
 FROM imageTypeMaster   
 
 --BROWSE IMAGE
 string ls_pathName, ls_fileName, ls_imageType,ls_imagePath, ls_workstationip
int li_rtn
long ll_noSuffix
string ls_acctNo,ls_fileServer,ls_year, ls_month, ls_directory,ls_path,ls_name,ls_file,ls_compID
datetime ldt_date
long ll_height, ll_width
boolean lb_dirExists

this.accepttext()

ls_imageType = this.getItemString(row,"imageType")


if ls_imageType <> '' or not  isNull(ls_imageType) then
		
	select count(*) into :ll_nosuffix
	from subscriberImageMaster
	where imageTypeCode = :ls_imageType
	and companyCode = :gs_companyCode
	and divisionCode = :gs_divisionCode
	using SQLCA;
	if SQLCA.SQLCode <> 0 then
		
		return
	end if
	
	ll_noSuffix++
	
	select companyID into :ls_compId
	from systemParameter
	where companyCode = :gs_companyCode
	and divisionCode = :gs_divisionCode
	using SQLCA;
	if SQLCA.SQLCode <> 0 then
		return
	end if
	
	select '%\\'||substr(:gs_ipAddress,1,4)||'%' into :ls_workstationip
	 from sysParamString
	 where  itemname = 'IMAGEPATH'
	 and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	and rownum < 2
	using SQLCA;
	
	select itemvalue into :ls_fileServer
	from sysParamString
	where itemvalue like :ls_workstationip
	and itemname = 'IMAGEPATH'
	and  divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	and rownum < 2
	using SQLCA;
	
	long ll_pos1, ll_pos2
	string ls_mid1, ls_mid2
	
	ll_pos1 = pos(ls_fileServer, '\\')
	ls_mid1 = mid(ls_fileServer, 3, len(ls_fileServer))
	ll_pos2 = pos(ls_mid1, '\')
	ls_mid2 = mid(ls_mid1, ll_pos2, len(ls_fileServer))
	ls_fileServer = '\\' + gs_ImageServerIPAddress + ls_mid2	
	
	li_rtn = GetFileOpenName ("Select a file..", ls_pathname, ls_filename,"img","Graphic Files (*.bmp;*.gif;*.jpg;*.jpeg),*.bmp;*.gif;*.jpg;*.jpeg" )

	if gs_divisionCode <> 'BSG' then
		ldt_date = w_subscriber_Maintenance.tab_1.tp_subsinfo.dw_info.getItemDateTime(w_subscriber_maintenance.tab_1.tp_subsinfo.dw_info.getRow(),"dateAdd")
	else
		ldt_date = w_subscriber_Maintenance_bsg.tab_1.tp_subsinfo.dw_info.getItemDateTime(w_subscriber_maintenance_bsg.tab_1.tp_subsinfo.dw_info.getRow(),"dateAdd")	
	end if
	ls_year = string(year(date(ldt_date)))
	ls_month = string(month(date(ldt_date)),"00")
	ls_directory = trim(ls_year)+trim(ls_month)
	if gs_divisionCode <> 'BSG' then
		ls_acctNo = w_subscriber_maintenance.tab_1.tp_subsinfo.dw_info.getItemString(w_subscriber_maintenance.tab_1.tp_subsinfo.dw_info.getRow(),"acctNo")
	else
		ls_acctNo = w_subscriber_maintenance_Bsg.tab_1.tp_subsinfo.dw_info.getItemString(w_subscriber_maintenance_bsg.tab_1.tp_subsinfo.dw_info.getRow(),"acctNo")
	end if
	ls_path = ls_fileServer+ls_directory
	
	if lb_direxists = false then
		CreateDirectory(ls_path + '\')
	end if
	
	ls_imagePath = ls_path+'\'+ls_imageType+ls_compID+ls_acctNo+string(ll_noSuffix,"00")+'.jpg'
	
	if li_rtn = 1 then
	
	if gs_divisionCode <> 'BSG' then
		w_subscriber_Maintenance.tab_1.tp_images.pb_1.pictureName = ls_imagePAth
		w_subscriber_Maintenance.tab_1.tp_images.pb_1.originalSize = True
	else
		w_subscriber_Maintenance_bsg.tab_1.tp_images.pb_1.pictureName = ls_imagePAth
		w_subscriber_Maintenance_bsg.tab_1.tp_images.pb_1.originalSize = True
	end if		
		//-----------COPY / RENAME IMAGES
		FileCopy (ls_fileName ,ls_imagePath, FALSE)
		changeDirectory(APPLICATION_PATH)
			
			//---------LOG TRANSACTION
			insert into subscriberImageMaster (
					acctNo,
					ImageTypeCode,
					ImagePath,
					divisionCode,
					companyCode
				)
				values (
					:ls_acctNo,
					:ls_imageType,
					:ls_imagePath,
					:gs_divisionCode,
					:gs_companyCode
				)
			using SQLCA;
			
			if SQLCA.SQLCode <> 0 then
				rollback using sqlca;
				guo_func.msgbox('Error!','Error while inserting values to table subscriberImageMaster...')
				return
			else
				commit using SQLCA;
			end if
					
			changeDirectory(APPLICATION_PATH)
			guo_func.msgbox('Success!','File ' + ls_imageType+ls_acctNo+string(ll_noSuffix,"00")+'.jpg'+' was successfully uploaded...')		
			if gs_divisionCode <> 'BSG' then
				w_subscriber_maintenance.trigger dynamic event ue_retrieveImage(ls_acctNo)
			else
				w_subscriber_maintenance_bsg.trigger dynamic event ue_retrieveImage(ls_acctNo)
			end if
			cb_1.triggerEvent(clicked!)

	end if
else
	guo_func.msgbox('Warning!', 'Please select Image Type before you can upload a file!, Thank you...')		
	
end if
 

--TAB REQUIRED INITIAL PAYMENT    

SELECT  sysTransactionParam.tranTypeName ,
       arTypeMaster.arTypeName ,
       subsInitialPayment.tranNo ,
       subsInitialPayment.tranDate ,
       subsInitialPayment.priority ,
       subsInitialPayment.amount ,
       subsInitialPayment.paidAmt ,
       subsInitialPayment.processed ,
        subsInitialPayment.cancelled
    FROM subsInitialPayment ,
       sysTransactionParam ,
       arTypeMaster     
    WHERE ( arTypeMaster.arTypeCode = subsInitialPayment.arTypeCode ) 
   and ( arTypeMaster.divisionCode = subsInitialPayment.divisionCode )
   and ( arTypeMaster.companyCode = subsInitialPayment.companyCode )
   and ( sysTransactionParam.tranTypeCode = subsInitialPayment.tranTypeCode ) 
	 and ( sysTransactionParam.divisionCode = subsInitialPayment.divisionCode )
   and ( sysTransactionParam.companyCode = subsInitialPayment.companyCode )
   and ( ( subsInitialPayment.acctNo = :as_acctNo ) )
   and ( subsInitialPayment.companyCode = :as_company )
   and ( subsInitialPayment.divisionCode = :as_division )

  
 -- TAB SIRCUIT ID
   
 --QUERY LIST OF SIRCUIT ID
   
 SELECT  subscriberCircuitID.acctNo , 
 subscriberCircuitID.circuitID ,  
 circuitMaster.description ,  
 subscriberCircuitID.site 
 FROM subscriberCircuitID , 
 circuitMaster 
 WHERE ( subscriberCircuitID.circuitID = circuitMaster.circuitID ) and 
 ( subscriberCircuitID.divisionCode = circuitMaster.divisionCode ) and   
 ( subscriberCircuitID.companyCode = circuitMaster.companyCode ) and 
 ( ( acctNo = :as_acctNo ) ) 
 
 --QUERY SIRCUIT ID INFO
 
 SELECT  circuitDetails.circuitID,
     		circuitDetails.equipment,
			circuitDetails.brand,
      	circuitDetails.model,
     		circuitDetails.interface,
			circuitDetails.ipAddress,
         circuitDetails.description
FROM circuitDetails      
WHERE ( circuitDetails.circuitID = :as_circuit )

--QUERY REFRENCE SIRCUIT ID

 SELECT  otherPartyCircuitDtl.refcircuitID,
     		otherPartyCircuitDtl.equipment,
			otherPartyCircuitDtl.brand,
      	otherPartyCircuitDtl.model,
     		otherPartyCircuitDtl.interface,
			otherPartyCircuitDtl.ipAddress,
         otherPartyCircuitDtl.description
FROM otherPartyCircuitDtl      
WHERE ( otherPartyCircuitDtl.circuitID = :as_circuit )

--BUTTON LOAD SIRCUIT ID

integer li_ctr, li_row1, li_row2
string ls_imagePath, ls_circuitIDA, ls_circuitIDB

li_row1 = tab_info.tp_circuit.dw_circuit.retrieve(is_acctNo)

if li_row1 > 0 then
	ls_circuitIDA = tab_info.tp_circuit.dw_circuit.getItemString(1, 'circuitid')
	tab_info.tp_circuit.lb_circuit.reset()
	declare cur_siteA cursor for
		select imagepath
		from circuitBuilderImageMaster
		where circuitID = :ls_circuitidA
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;	
	open cur_siteA;
	fetch cur_siteA into :ls_imagepath;
	do while SQLCA.sqlcode = 0
		li_ctr++
		tab_info.tp_circuit.lb_circuit.insertitem( ls_imagepath, li_ctr)
		fetch cur_siteA into :ls_imagepath;
	loop
	close cur_siteA;
	if tab_info.tp_circuit.lb_circuit.TotalItems ( ) > 0 then
		tab_info.tp_circuit.lb_circuit.selectItem(1)
		tab_info.tp_circuit.ole_circuit.insertFile(tab_info.tp_circuit.lb_circuit.text(1))
	else
		tab_info.tp_circuit.ole_circuit.clear()
	end if
else
	tab_info.tp_circuit.ole_circuit.clear()
	tab_info.tp_circuit.lb_circuit.reset()
	tab_1.tp_circuitid.tab_info.tp_circuit.dw_circuitdtl.reset()
	tab_1.tp_circuitid.tab_info.tp_circuit.dw_party.reset()
	tab_info.tp_circuit.st_description.text = ''
end if	
	

  