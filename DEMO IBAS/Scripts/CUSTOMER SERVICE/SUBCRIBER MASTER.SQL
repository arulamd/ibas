--QUERY TAB SUBSCRIBER INFO

SELECT arAcctSubscriber.acctno ,
           arAcctSubscriber.subscribername ,
           arAcctSubscriber.lastname ,
           arAcctSubscriber.firstname ,
           arAcctSubscriber.middlename ,
           arAcctSubscriber.mothermaidenname ,
           arAcctSubscriber.citizenshipcode ,
           arAcctSubscriber.sex ,
           arAcctSubscriber.birthdate ,
           arAcctSubscriber.civilstatus ,
           arAcctSubscriber.typeofbusiness ,
           arAcctSubscriber.telno ,
           arAcctSubscriber.mobileno ,
           arAcctSubscriber.faxno ,
           arAcctSubscriber.emailaddress ,
           service.serviceHomeOwnerShip ,
           service.serviceLessorOwnerName ,
           service.serviceLessorOwnerContactNo ,
           service.serviceYearsResidency ,
           service.serviceExpirationDate ,
           service.contactName,
           service.contactNo,
           service.HouseNo ,
           service.streetName ,
           service.bldgName ,
           service.LotNo ,
           service.BlkNo ,
           service.PhaseNo ,
           service.District ,
           service.PurokNo ,
           service.SubdivisionCode ,
           service.BarangayCode ,
           service.MunicipalityCode ,
           service.ProvinceCode ,
           arAcctSubscriber.circuitID,
           billing.contactName,
		  billing.contactNo,
           billing.HouseNo ,
           billing.StreetName ,
           billing.bldgName ,
           billing.LotNo ,
           billing.BlkNo ,
           billing.PhaseNo ,
           billing.District ,
           billing.PurokNo ,
           billing.SubdivisionCode ,
           billing.BarangayCode ,
           billing.MunicipalityCode ,
           billing.ProvinceCode ,
           arAcctSubscriber.chargeTypecode ,
           arAcctSubscriber.subsusertypecode ,
           arAcctSubscriber.packagecode ,
           arAcctSubscriber.subscriberstatuscode ,
           arAcctSubscriber.substypecode ,
           arAcctSubscriber.dateapplied ,
           arAcctSubscriber.dateinstalled ,
           arAcctSubscriber.dateautodeactivated ,
           arAcctSubscriber.datemanualdeactivated ,
           arAcctSubscriber.datepermanentlydisconnected ,
           arAcctSubscriber.datereactivated ,
           arAcctSubscriber.qtyacquiredstb ,
           arAcctSubscriber.totalboxesbeforedeactivation ,
           arAcctSubscriber.numberofrooms ,
           arAcctSubscriber.occupancyrate ,
           arAcctSubscriber.mLineCurrentMonthlyRate ,
           arAcctSubscriber.mLinePreviousMonthlyRate ,
           arAcctSubscriber.extCurrentMonthlyRate ,
           arAcctSubscriber.extPreviousMonthlyRate ,
           arAcctSubscriber.withadvances ,
           arAcctSubscriber.locked ,
           arAcctSubscriber.lockedby ,
           arAcctSubscriber.lockedwithtrans ,
           0 noOfBoxMLine,
           0 noOfBoxExt,
           0.00 insuranceFee,
           0.00 rentalFee,
           0.00 regMonthlyBill,
           arAcctSubscriber.userAdd,
           arAcctSubscriber.dateAdd,
			  arAcctSubscriber.tranNo,
			  arAcctSubscriber.oldAcctNo,
			  arAcctSubscriber.noOfMonthArrears,
			  arAcctSubscriber.noOfMonthArrearsAllowed,
			  arAcctSubscriber.acquisitionTypeCode,
           arAcctSubscriber.handle,
			  arAcctSubscriber.xpos,
			  arAcctSubscriber.ypos,
			  arAcctSubscriber.subsUserName,
			  arAcctSubscriber.password,
			  service.lastInfoUpdate,
			  '' as contactNo,
			  arPackageMaster.packageName,
			  arPackageMaster.isBundledServiceType,
			  arPackageMaster.isDigital,
				'' arothacctno,
				'' arothacctname,
			'N' withadshistory,
			AracctSubscriber.bundledCTVAcctno,
			aracctsubscriber.lockinperiod,
			aracctsubscriber.isSoaPrinting,
			aracctsubscriber.isCableBoxEmail,
			aracctsubscriber.isSMSSending,
			aracctsubscriber.isEmailSending,
			arAcctSubscriber.mobileno2,
			arAcctSubscriber.mobileno3,
			arAcctSubscriber.emailaddress2,
			arAcctSubscriber.emailaddress3,
			arAcctSubscriber.guarantor,
			arAcctSubscriber.spousename,
			arAcctSubscriber.nameofcompany,
			nodesInIpCommander.nodeno,
			nodesInIpCommander.nodedesc, 
			arpackagemaster.clientclassvalue,
			arAccountMaster.isvat,
			arAccountMaster.isnonvat,
			arAccountMaster.iswhtagent,
			arAcctSubscriber.TIN,
			arAcctSubscriber.BSTRADENAME,
			arAcctSubscriber.ISAPPLIEDAUTODEBIT,
			applicationautodebittranhdr.trandate,
			applicationautodebittranhdr.useradd,
			subsusertypemaster.subsusertypename,
			arAcctSubscriber.isprintcomclark,
			arAcctSubscriber.isprintconverge,
			systemparameter.companyid,
			systemparameter.divisionprefix,
			systemparameter.servicecode,
			agentmaster.agentname,
			arAcctSubscriber.napcode,
			arAcctSubscriber.portno,
			applcancelautodebittranhdr.dateadd,
			applcancelautodebittranhdr.useradd,
			datelcomservicetypemaster.ServiceTypeName as DatelcomServiceTypeName,
			arAcctSubscriber.datelcomtelno,
		 	arAcctSubscriber.iptvacctno,
			arAcctsubscriber.iptvdivisioncode,
			arAcctSubscriber.iptvcompanycode,
			arAcctSubscriber.daterelockin,
			arAcctSubscriber.relockintrigger,
			aracctsubscriber.tagno,
		    arAcctsubscriber.bssacctno, 
			arAcctsubscriber.migratedbsstoibasacctno,
arAcctSubscriber.NOCOICOP,
0.00 iptvmainlinerate,
0.00 iptvextensionrate,
ADD_MONTHS(nvl(arAcctSubscriber.daterelockin,arAcctSubscriber.dateinstalled) , arAcctSubscriber.LOCKINPERIOD) lockinperiod_end,
arAcctSubscriber.billingcycle,
arAcctSubscriber.migratedfromacctno,
arAcctSubscriber.migratedtoacctno,
systemparameterfrom.companyid,
			systemparameterfrom.divisionprefix,
			systemparameterfrom.servicecode,
systemparameterto.companyid,
			systemparameterto.divisionprefix,
			systemparameterto.servicecode,
			'N' greenFlagTagging,
			arAcctSubscriber.sweldomo_acctno,
case when arAcctSubscriber.payment_option = 0 then 'Pay via Pay Partners' 
	   when arAcctSubscriber.payment_option = 1 then 'Pay via Installers'
	   else 'Pay via Pay Partners' end as payment_option,
	aracctsubscriber.networkactivationdate,
	arAcctSubscriber.application_type
        FROM arAcctSubscriber 
		  inner join arAcctAddress billing on arAcctSubscriber.acctNo = billing.acctNo 
              and billing.addresstypeCode = 'BILLING' 
              and billing.divisionCode = :as_division 
              and billing.companyCode = :as_company
        inner join arAcctAddress service on arAcctSubscriber.acctNo = service.acctNo 
              and service.addresstypeCode = 'SERVADR1' 
              and service.divisionCode = :as_division 
              and service.companyCode = :as_company
		  inner join arPackageMaster on arPackageMaster.packageCode = arAcctSubscriber.packageCode
		  		  and arPackageMaster.divisionCode = arAcctSubscriber.divisionCode
				  and arPackageMaster.companyCode = arAcctSubscriber.companyCode
		 left join nodesInIpCommander on nodesInIpCommander.nodeno = arAcctSubscriber.nodeno
		 		and nodesInIpCommander.divisionCode = arAcctSubscriber.divisionCode
				  and nodesInIpCommander.companyCode = arAcctSubscriber.companyCode
		inner join arAccountMaster on arAccountMaster.acctNo =  arAcctSubscriber.acctNo
				and arAccountMaster.divisionCode = arAcctSubscriber.divisionCode
				and arAccountMaster.companyCode = arAcctSubscriber.companyCode
		left join applicationautodebittranhdr on applicationautodebittranhdr.acctno = arAcctSubscriber.acctno
				and applicationautodebittranhdr.divisionCode = arAcctSubscriber.divisionCode
				and applicationautodebittranhdr.companyCode = arAcctSubscriber.companyCode 
		left join applcancelautodebittranhdr on applcancelautodebittranhdr.acctno = arAcctSubscriber.acctno
				and applcancelautodebittranhdr.divisionCode = arAcctSubscriber.divisionCode
				and applcancelautodebittranhdr.companyCode = arAcctSubscriber.companyCode 
		inner join subsusertypemaster on subsusertypemaster.subsusertypecode = arAcctSubscriber.subsusertypecode
		inner join systemparameter on systemparameter.divisioncode = arAcctSubscriber.divisioncode and systemparameter.companycode = arAcctSubscriber.companycode
    left join systemparameter systemparameterfrom on systemparameterfrom.divisioncode = arAcctSubscriber.migratedfromdivisioncode and systemparameterfrom.companycode = arAcctSubscriber.migratedfromcompanycode
    left join systemparameter systemparameterto on systemparameterto.divisioncode = arAcctSubscriber.migratedtodivisioncode and systemparameterto.companycode = arAcctSubscriber.migratedtocompanycode
		left join agentmaster on agentmaster.agentcode = arAcctSubscriber.agentcode
				and agentmaster.divisioncode = arAcctSubscriber.divisioncode
				and agentmaster.companycode = arAcctSubscriber.companycode
		left join datelcomservicetypemaster on datelcomservicetypemaster.servicetypecode = arAcctSubscriber.datelcomServTypeCode and datelcomservicetypemaster.divisionCode = arAcctSubscriber.divisionCode 
		  WHERE (( arAcctSubscriber.acctno = :as_acctno ))
		  AND ( arAcctSubscriber.divisionCode = :as_division ) 
        and ( arAcctSubscriber.companyCode = :as_company)
	and rownum < 2
	
	

	
	--QUERY TAB PAYMENT
	
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
		  and (( collectiontranhdr.divisionCode = :as_division )
        and  ( collectiontranhdr.companyCode = :as_company )  
		  and  ( collectiontranhdr.acctno = :s_accountno ) ) 
        
        
--TAB AR BALANCE
		  
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

--TAB AR LEDGER

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
          
--TAB SUBSCRIBER ANDVANCES LEDGER
          
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
  
  --TAB SUBCRIBER DEPOSIT LEDGER
  
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

--TAB INSENTIVES LEDGER

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

 --TAB ASSIGNED EQUIPMENT
 
   SELECT  subscriberCPEMaster.itemcode ,
           subscriberCPEMaster.cpeTypeCode ,
           subscriberCPEMaster.serialNo ,
           subscriberCPEMaster.boxIdNo ,
           subscriberCPEMaster.cpestatuscode ,
           subscriberCPEMaster.dateAcquired ,
           subscriberCPEMaster.acquisitionTypeCode ,
           subscriberCPEMaster.acquiredBefore2003 ,
           itemMaster.model ,
           itemMaster.voltage ,
           itemMaster.stbType ,
           subscriberCPEMaster.acctNo,
           '' as selected
        FROM subscriberCPEMaster ,
           itemMaster     
        WHERE ( subscriberCPEMaster.itemcode = itemMaster.itemCode ) 
        and  ( subscriberCPEMaster.cpeTypeCode = 'STB' ) 
        and ( subscriberCPEMaster.acctno = :as_acctNo ) 
        and  ( subscriberCPEMaster.divisionCode = :as_division ) 
        and  ( subscriberCPEMaster.companyCode = :as_company )
        and  ( itemMaster.companyCode = :as_company )
        
--TAB TRANSACTION
        
SELECT rpad(' ', 10,' ') as trandate ,
	 rpad(' ', 8, ' ') as tranno,
   rpad(' ', 300, ' ') as particulars,
  0.00 amount
FROM dual  

---FILTER TRANSACTION TYPE

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
end IF

--VALIDASI f_modifytable

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
           arTypeMaster.arTypeName ,
           arAcctSubscriber.subscriberName ,
           vw_arAcctAddress.completeAddress ,
           arAcctSubscriber.acctNo ,
           arAcctSubscriber.subsTypeCode,
           arPackageMaster.packageName ,
           chargeTypeMaster.chargeTypeName ,
           vw_arAcctAddress.contactNo ,
           arAcctSubscriber.mobileNo ,
           vw_arAcctAddress.houseNo ,
           vw_arAcctAddress.streetName ,
           vw_arAcctAddress.SubdivisionCode ,
           vw_arAcctAddress.BarangayCode ,
           (arAcctSubscriber.mLineCurrentMonthlyRate + arAcctSubscriber.extCurrentMonthlyRate) currentMontlyRate,
           provinceMaster.provinceName ,
           municipalityMaster.municipalityName ,
           barangayMaster.barangayName ,
           subdivisionMaster.subdivisionName ,
           arTranHdr.balance totalDueNgeni ,
           arTranHdr.balance totalDueDati ,
           arAcctSubscriber.billingMinimumDue,
			  systemParameter.companyID,
			  systemParameter.divisionPrefix,
			  systemParameter.serviceCode,
			utils.convert_to_varchar2(arTranHdr.periodFrom,12,p_style=>0) ||  ' to '  || utils.convert_to_varchar2(arTranHdr.periodTo,12,p_style=>0) as coverage,
			arTranHdr.periodFrom,
			arTranHdr.periodTo
        FROM arTranHdr 
		  	  inner join arTypeMaster 			on arTypeMaster.arTypeCode = arTranHdr.arTypeCode 
                 and arTypeMaster.divisionCode = arTranHdr.divisionCode
                 and arTypeMaster.companyCode = arTranHdr.companyCode
			  inner join arAcctSubscriber 	on arAcctSubscriber.acctNo = arTranHdr.acctNo 
                 and arAcctSubscriber.divisionCode = arTranHdr.divisionCode
                 and arAcctSubscriber.companyCode = arTranHdr.companyCode
			  inner join vw_arAcctAddress    on vw_arAcctAddress.acctNo  = arAcctSubscriber.acctNo and vw_arAcctAddress.addressTypeCode = 'BILLING'
        		   and vw_arAcctAddress.divisionCode = arAcctSubscriber.divisionCode
                 and vw_arAcctAddress.companyCode = arAcctSubscriber.companyCode
           inner join arPackageMaster 		on arPackageMaster.packageCode = arAcctSubscriber.packageCode 
                 and arPackageMaster.divisionCode = arAcctSubscriber.divisionCode
                 and arPackageMaster.companyCode = arAcctSubscriber.companyCode
			  inner join systemParameter     on systemParameter.divisionCode = arTranHdr.divisionCode 
					and  systemParameter.companyCode =  arTranHdr.companyCode 
			  inner join chargeTypeMaster 	on chargeTypeMaster.chargeTypeCode = arAcctSubscriber.chargeTypeCode 
			  inner join provinceMaster 		on provinceMaster.provinceCode = vw_arAcctAddress.provinceCode 
			  inner join municipalityMaster 	on municipalityMaster.municipalityCode = vw_arAcctAddress.municipalityCode 
			  inner join barangayMaster 		on barangayMaster.barangayCode = vw_arAcctAddress.BarangayCode
			  inner join subdivisionMaster 	on subdivisionMaster.subdivisionCode = vw_arAcctAddress.SubdivisionCode 
		 WHERE ( arTranHdr.balance > 0) and arAcctSubscriber.acctNo = :as_acctNo
           and arTranHdr.divisionCode = :as_division and arTranHdr.companyCode = :as_company

           
-- TAB UNPROCESS TRANS

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
   
   
-- TAB REFUND ADVISE

     SELECT refundAdvise.acctNo,   
         refundAdvise.packageCode,   
         refundAdvise.totalAdvDep,   
         refundAdvise.pdFee,   
         refundAdvise.arBalance,   
         refundAdvise.pdDate,   
         refundAdvise.daysConsumption,   
         refundAdvise.noOfMainLine,   
         refundAdvise.noOfExtension,   
         refundAdvise.mLineMonthlyRate,   
         refundAdvise.extMonthlyRate,   
         refundAdvise.mLineDailyRate,   
         refundAdvise.extDailyRate,   
         refundAdvise.insuranceAmount,   
         refundAdvise.rentalAmount,   
         refundAdvise.billingAmount,   
         refundAdvise.refundableAmount,   
         arAcctSubscriber.subscriberName,   
         vw_arAcctAddress.completeAddress,   
         arPackageMaster.packageName,
         arPackageMaster.serviceType
    FROM refundAdvise,   
         arAcctSubscriber,   
         arPackageMaster,
			vw_arAcctAddress 
   WHERE ( refundAdvise.acctNo = arAcctSubscriber.acctNo ) 
   and  (arAcctSubscriber.divisionCode = refundAdvise.divisionCode)
   and  (arAcctSubscriber.companyCode = refundAdvise.companyCode)
   and  (arAcctSubscriber.acctNo = vw_arAcctAddress.acctNo) 
   and  (arAcctSubscriber.divisionCode = vw_arAcctAddress.divisionCode)
   and  (arAcctSubscriber.companyCode = vw_arAcctAddress.companyCode)
   and  (vw_arAcctAddress.addressTypeCode = 'SERVADR1') 
   and  (arAcctSubscriber.packageCode = arPackageMaster.packageCode) 
   and  (arAcctSubscriber.divisionCode = arPackageMaster.divisionCode)
   and  (arAcctSubscriber.companyCode = arPackageMaster.companyCode) 
   and  ( ( refundAdvise.acctNo = :as_acctNo )  and (refundAdvise.divisionCode = :as_division)
          and (refundAdvise.companyCode = :as_company) )    

  --SUB FORM TABLE REFUND ADVICE  DW_SUB_ADV_DEP 
  
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

--SUB FORM TABLE REFUND ADVICE dw_sub_subsstbforpullout

	SELECT subscriberCPEMaster.serialNo  
    FROM subscriberCPEMaster  
   WHERE ( subscriberCPEMaster.cpeTypeCode = :as_cpeType ) AND ( subscriberCPEMaster.acctno = :as_acctno ) AND  
			( subscriberCPEMaster.divisionCode = :as_division ) AND ( subscriberCPEMaster.companyCode = :as_company ) AND
         ( subscriberCPEMaster.acquisitionTypeCode <> 'BUY' ) 
         
-- END TAB REFUND ADVISE     

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
       
 --TAB CHARACTER REFERENCE
 
  SELECT subscriberApplicationCharRefs.charFullName,   
         subscriberApplicationCharRefs.charRelationship,   
         subscriberApplicationCharRefs.charAddress,   
         subscriberApplicationCharRefs.charContactNo,   
         arAcctSubscriber.subscriberName  
    FROM subscriberApplicationCharRefs,   
         arAcctSubscriber  
   WHERE ( arAcctSubscriber.acctNo = subscriberApplicationCharRefs.acctno ) and  
         ( ( subscriberApplicationCharRefs.acctno = :acctno ) ) 
   AND ( subscriberApplicationCharRefs.divisionCode = :as_division )
   AND ( subscriberApplicationCharRefs.companyCode = :as_company )  
   AND ( arAcctSubscriber.divisionCode = :as_division )
   AND ( arAcctSubscriber.companyCode = :as_company )  
   
 --TAB IMAGES
   
 --QUUERY FORM TO RETRIVE DATA IMAGES  
 select b.imagetypename , b.imagetypename , a.imagepath, a.acctno
 from subscriberimagemaster a
 inner join imagetypemaster b on a.imagetypecode = b.imagetypecode
 where a.acctno = :as_acctno
 and a.divisioncode = :as_divisioncode
 and a.companyCode = :as_companyCode
 
 --EVENT ROW FOCUS SELECT ROW
 
 string ls_preview, ls_imageType, ls_imageTypeName, ls_default = 'noPicAvailable.jpg', ls_new_preview, ls_workstationip2, ls_workstationip, ls_finalserverip, ls_imagename
int li_count, li_imagename = 0, li_posimage = 0, li_len_is_preview = 0
long ll_height,ll_width , ll_ctr_jo_imagetype
string ls_image_path , ls_jomobile_enabled

select count(*) into :li_count
from subscriberImageMaster
where acctNo = :is_acctNo
and companycode = :gs_companyCode
and divisioncode = :gs_divisionCode
using SQLCA;

if li_count > 0 then
	if currentrow = 0 or isnull(currentrow) then
		currentrow = 1
	end if

	
	is_preview = tab_1.tp_images.dw_images.getitemstring(currentrow,"imagePath")
	ls_image_path = tab_1.tp_images.dw_images.getitemstring(currentrow,"imagePath")
	
	li_imagename = 0
	li_posimage = 0
	li_len_is_preview = 0
	
	li_len_is_preview = len(is_preview) 
	
	li_posimage = pos(is_preview, '\image$\') + 23
	
	li_imagename = li_len_is_preview - li_posimage + 1
	
    ls_imagename = right(is_preview, li_imagename)
	 
	 select '%\\'||substr(:gs_ipAddress,1,4)||'%' into :ls_workstationip
	 from sysParamString
	 where  itemname = 'IMAGEPATH'
	 and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	and rownum < 2
	using SQLCA;
	
	select itemvalue into :ls_finalserverip
	from sysParamString
	where itemvalue like :ls_workstationip
	and  divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	and itemname = 'IMAGEPATH'
	and rownum < 2
	using SQLCA;

	
	ls_imageType = tab_1.tp_images.dw_images.getitemstring(currentrow,"imageTypecode")
	
	select count(*) into :ll_ctr_jo_imagetype
	from jomobileimagetypes
	where imagetypecode = :ls_imageType
	using SQLCA;
	
	if ll_ctr_jo_imagetype > 0 then
		
		ls_imagename = is_preview
		ls_new_preview = is_preview
		
	end if
	
	select imageTypeName, jomobile_enabled into :ls_imageTypeName, :ls_jomobile_enabled
	from imageTypeMAster
	where imagetypeCode = :ls_imageType
	using SQLCA;
	if SQLCA.SQLCode <> 0 then
		return
	end if
	
	string lsFileName
	long li_pos_image_jomobile, li_len_file
	
	li_pos_image_jomobile = pos(is_preview, 'jomobile-lite.convergeict.com/backend/Images/') + 45
	li_len_file = len(is_preview)
			
	lsFilename = mid(is_preview,li_pos_image_jomobile,li_len_file)
	
	if ls_jomobile_enabled = 'Y' then
		
		if FileExists('C:\ibas oracle 10\jomobile\cache\'+lsFilename) then
			is_preview = 'C:\ibas oracle 10\jomobile\cache\'+lsFilename
		else
			string lsCommand
			string lsUrl
		
			string lsDestImageAndFolder
			int li_rc;
			
			
	
			lsUrl = is_preview
			lsDestImageAndFolder = "C:\ibas oracle 10\jomobile\cache\"+lsFileName
			lsCommand = "C:\ibas oracle 10\RegDLL.bat "+lsUrl+" "+lsDestImageAndFolder;
			li_rc = run(lsCommand,Minimized!);
		end if
	end if
	
	tab_1.tp_images.pb_1.pictureName = is_preview
	ll_height = tab_1.tp_images.pb_1.height
	ll_width = tab_1.tp_images.pb_1.width
	
	tab_1.tp_images.dw_2.object.t_imageType.text = ls_imageTypeName
	tab_1.tp_images.dw_2.object.p_1.fileName = is_preview
	tab_1.tp_images.dw_2.Object.datawindow.Detail.Height = ll_height + 400
	tab_1.tp_images.dw_2.object.p_1.width = ll_width
	tab_1.tp_images.dw_2.object.p_1.height = ll_height
	tab_1.tp_images.dw_2.object.b_copy.visible = True
	tab_1.tp_images.dw_2.object.b_print.visible = True
else
	tab_1.tp_images.dw_2.object.p_1.fileName = ls_default
	tab_1.tp_images.dw_2.object.b_copy.visible = False
	tab_1.tp_images.dw_2.object.b_print.visible = False
end if

return 0

--BUTTON RETRIEVE IMAGES
w_subscriber_Maintenance.trigger event ue_retrieveImage(is_acctNo)

int li_ctr,li_rowCount,li_pic
string ls_imageTypeCode,ls_imagetypename

tab_1.tp_images.dw_images.reset()
li_rowCount = tab_1.tp_images.dw_images.retrieve(as_acctNo,gs_divisioncode,gs_companyCode)
tab_1.tp_images.plb_1.reset()
tab_1.tp_images.plb_1.deletepictures( )

--QUERY DW_IMAGE
	SELECT subscriberImageMaster.acctNo,   
	         subscriberImageMaster.imageTypeCode,   
	         subscriberImageMaster.imagePath  
	    FROM subscriberImageMaster   
	where subscriberImageMaster.acctNo = :as_acctNo  and 
	      subscriberImageMaster.divisionCode = :as_division and
	      subscriberImageMaster.companyCode = :as_company
	order by imageTypeCode 
	--END QUERY DW_IMAGE

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

tab_1.tp_images.dw_tv.retrieve(as_acctno,gs_divisioncode,gs_companycode)

--QUERY DW_TV
 select b.imagetypename , b.imagetypename , a.imagepath, a.acctno
 from subscriberimagemaster a
 inner join imagetypemaster b on a.imagetypecode = b.imagetypecode
 where a.acctno = :as_acctno
 and a.divisioncode = :as_divisioncode
 and a.companyCode = :as_companyCode

changeDirectory(APPLICATION_PATH)
tab_1.tp_images.plb_1.triggerEvent(selectionChanged!)

--BUTTON UPLOAD

string ls_pathName, ls_fileName,ls_directory
int li_rtn

tab_1.tp_images.uo_upload.visible = true
tab_1.tp_images.uo_upload.bringtoTop = true
tab_1.tp_images.uo_upload.dw_1.setTransObject(SQLCA)
tab_1.tp_images.uo_upload.dw_1.insertRow(0)
tab_1.tp_images.uo_upload.dw_1.retrieve()


--BUTTON UPDATE IMAGE


string ls_acctNo,ls_fileServer,ls_year, ls_month, ls_directory,ls_path,ls_name,ls_file,ls_compID,ls_parentWindow, ls_workstationip
datetime ldt_date
boolean lb_dirExists
		
s_applmlinecam s_cam

select companyId into :ls_compID 
from systemParameter
where companyCode = :gs_companyCode
and divisionCode = :gs_divisionCode
using SQLCA;
if SQLCA.SQLCode <> 0 then
	return -1
end if

 	select '%\\'||substr(:gs_ipAddress,1,4)||'%' into :ls_workstationip
	 from sysParamString
	 where  divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	and rownum < 2
	using SQLCA;
	
	select itemvalue into :ls_fileServer
	from sysParamString
	where itemvalue like :ls_workstationip
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

ldt_date = tab_1.tp_subsinfo.dw_info.getItemDateTime(tab_1.tp_subsinfo.dw_info.getRow(),"dateAdd")
ls_year = string(year(date(ldt_date)))
ls_month = string(month(date(ldt_date)),"00")
ls_directory = trim(ls_year)+trim(ls_month)
ls_acctNo = tab_1.tp_subsinfo.dw_info.getItemString(tab_1.tp_subsinfo.dw_info.getRow(),"acctNo")
ls_path = ls_fileServer+ls_directory

s_cam.ss_fileserver = ls_fileServer
s_cam.ss_acctno = ls_acctNo
s_cam.ss_directory = ls_directory
s_cam.si_nosuffix = ii_noSuffix
s_cam.ss_compid = ls_compID
s_cam.ss_issubs = 'Y'
s_cam.ss_parentwindow = "w_subscriber_maintenance"


lb_dirExists = directoryExists(ls_path)
if lb_dirExists = false then 
	CreateDirectory(ls_path + '\')
end if

OpenWithParm(w_camerawindow,s_cam)

--VALIDASI W_CAMERAWINDOW

s_applmlinecam s_cam
s_cam = message.Powerobjectparm

is_imageTypeCode = 'IPD'
is_compID = s_cam.ss_compid
is_acctNo = s_cam.ss_acctno
is_directory = s_cam.ss_directory
is_fileServer = s_cam.ss_fileserver
is_parentWindow = s_cam.ss_parentwindow
is_issubs = s_cam.ss_issubs

select count(*) into :ii_noSuffix 
from subscriberImageMaster
where acctNo = :is_acctNo and imageTypeCode = 'IPD'
and companyCode = :gs_companyCode and divisionCode = :gs_divisioncode
using SQLCA;

ii_noSuffix++

is_noSuffix = string(s_cam.si_noSuffix+ii_noSuffix,"00")
is_picturePath = is_fileServer+is_directory+'\'+is_imageTypeCode+is_compId+is_acctNo+is_noSuffix+'.jpg'


ole_1.object.snapShotJPEG(is_picturepath,100)
ole_1.object.stop()

if is_issubs = 'Y' then
	insert into subscriberImageMaster (
		acctNo,
		imageTypeCode,
		imagePath,
		companycode,
		divisionCode
		) 
	values (
		:is_acctNo,
		:is_imageTypeCode,
		:is_picturePath,
		:gs_companyCode,
		:gs_divisionCode
	)
	using SQLCA;
	if SQLCA.SQLCode <> 0 then
		this.trigger event ue_undo()
		rollback using sqlca;
		guo_func.msgbox('Error!','Error while inserting values to table subscriberImageMaster...')
		return
	else
		commit using SQLCA;
	end if
else
	update patientmaster
	set photoPath = :is_picturepath
	where patientCode = :is_acctno
	and companycode = :gs_companyCode
	and divisioncode = :gs_divisionCode
	using SQLCA;
	if SQLCA.SQLCode <> 0 then
		rollback using sqlca;
		guo_func.msgbox('Error!','Error while update table patientmaster...')
		return
	else
		commit using SQLCA;
	end if
end if

ii_clicked = 1
This.trigger event ue_preview()

if is_parentWindow = "w_subscriber_maintenance" then
	w_subscriber_maintenance.trigger dynamic event ue_retrieveimage(is_acctno)
elseif 	is_parentWindow = "w_patientmaster_tab" then
	w_patientmaster_tab.trigger dynamic event ue_retrieveimage(is_acctno)
end if


--TAB SIRCUIT INFO

	--QUERY LIST SIRCUIT ID
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

	--QUERY REFERENCE SIRCUIT ID
 SELECT  otherPartyCircuitDtl.refcircuitID,
     		otherPartyCircuitDtl.equipment,
			otherPartyCircuitDtl.brand,
      	otherPartyCircuitDtl.model,
     		otherPartyCircuitDtl.interface,
			otherPartyCircuitDtl.ipAddress,
         otherPartyCircuitDtl.description
FROM otherPartyCircuitDtl      
WHERE ( otherPartyCircuitDtl.circuitID = :as_circuit )





         
	