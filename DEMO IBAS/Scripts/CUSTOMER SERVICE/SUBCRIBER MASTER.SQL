--WHEN OPEN FORM W_SUBRIBER_MAITENANCE
string ls_right

select rightsCode
into :ls_right
from userRightsMaster
where userCode = :gs_usercode and rightsCode = 'SM300'
using SQLCA;
if SQLCA.SQLCode = 100 then
	pb_activate.visible = false
else
	pb_activate.visible = true
end IF

--BUTTON SERACH FIND ACCTNO

	--QUERY FIND ACCTNO
	select aracctsubscriber.acctno,
	 					   aracctsubscriber.subscribername,
	arAcctSubscriber.subscribername,   
			vw_arAcctAddress.contactNo,   
			arAcctSubscriber.mobileno,   
			vw_arAcctAddress.municipalityCode,   
			arAcctSubscriber.packagecode,   
			arAcctSubscriber.subscriberstatuscode,   
			vw_arAcctAddress.completeAddress,
	 subscriberStatusMaster.subscriberStatusName,
	      arPackageMaster.packageName
							 from
							 aracctsubscriber
	 inner join vw_arAcctAddress 
			   on  vw_arAcctAddress.acctNo = arAcctSubscriber.acctNo
	            and vw_arAcctAddress.addressTypeCode = 'SERVADR1' 
	            and vw_arAcctAddress.divisionCode = arAcctSubscriber.divisionCode
	            and vw_arAcctAddress.companyCode = arAcctSubscriber.companyCode
	inner join arPackageMaster  
			   on  arPackageMaster.packageCode = arAcctSubscriber.packageCode
	            and arPackageMaster.divisionCode = arAcctSubscriber.divisionCode
	            and arPackageMaster.companyCode = arAcctSubscriber.companyCode
	inner join subscriberStatusMaster 
			   on  subscriberStatusMaster.subscriberstatuscode = arAcctSubscriber.subscriberstatuscode

--CLICK BUTTON SEARCH TO FIND ACCTNO RETURN ISACCTNO
			   
if is_acctNo <> '' then
	
	il_clicked = 1
	is_serviceType = f_getServiceType()
	tab_1.tp_subsInfo.dw_info.Reset()
	tab_1.tp_subsInfo.dw_info.Retrieve(is_acctNo, gs_divisionCode, gs_companyCode)
	
	wf_enabledisable_buttons('search, retrieveall, close')
	
	f_displayStatus('Retrieving...')
	
	tab_1.tp_payments.dw_payments.enabled = true
	tab_1.tp_payments.dw_payments.retrieve(is_acctNo, gs_divisionCode, gs_companyCode)

	tab_1.tp_arbalance.dw_arbalance.retrieve(trim(is_acctNo), is_displayZeroBal, gs_divisionCode,gs_companyCode)
	
	tab_1.tp_depLedger.dw_deposit.retrieve(is_acctNo, gs_divisionCode, gs_companyCode)
	computeBalanceDRCR(tab_1.tp_depLedger.dw_deposit, 'CR')
	
	tab_1.tp_job_orders.dw_job_orders.retrieve(is_acctNo, gs_divisionCode, gs_companyCode)
	tab_1.tp_vas.dw_vas.retrieve(is_acctNo, gs_divisionCode, gs_companyCode)

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

	tab_1.tp_initialpayment.dw_subsinitialPayment.retrieve(is_acctNo, gs_divisionCode, gs_companyCode)
	tab_1.tp_prepaid.dw_prepaid.retrieve(is_acctNo, gs_divisionCode, gs_companyCode)

	tab_1.tp_unprocesstrans.dw_unproctrans.Retrieve(is_acctNo, gs_divisionCode, gs_companyCode)
	tab_1.tp_charrefs.dw_charRefs.retrieve(is_acctNo, gs_divisionCode, gs_companyCode)
	tab_1.tp_packagehistory.dw_packagehistory.retrieve(is_acctNo, gs_divisionCode, gs_companyCode) // LD - 05/06/2010 For additional filter for package history.

	
	tab_1.tp_edigipick.dw_enrolleddigipick.retrieve(is_acctNo, gs_divisionCode, gs_companyCode) // LD - 06/25/2010 For Enrolled Digi-Pick.

	select installationRemarksCode , installationRemarksGroupCode, lockInPeriod, isSoaPrinting, iscableboxemail, isemailsending, issmssending, mobileNo2, mobileNo3, emailaddress2, emailaddress3, nameofcompany, guarantor, spousename
	into :ls_installationRemarksCode ,:ls_installationRemarksGroupCode, :li_lockInPeriod, :ls_isSoaPrinting, :ls_isCableBoxSending, :ls_isEmailSending, :ls_isSMSSending, :ls_mobileNo2, :ls_mobileNo3, :ls_emailaddress2, :ls_emailaddress3, :ls_nameofcompany, :ls_guarantor, :ls_spousename
	from aracctsubscriber
	where acctno = :is_acctno
	and divisioncode = :gs_divisioncode
	and companycode = :gs_companycode
	using SQLCA;

	select installationRemarksName
	into :ls_installationRemarksName
	from installationRemarksMaster
	where installationRemarksCode = :ls_installationRemarksCode
	and Installationremarksgroupcode = :ls_installationRemarksGroupCode
	using SQLCA;
	
	string ls_nodedesc, ls_sweldo_mo_acctno
	long ll_nodeno	
	
	select nodeno, sweldomo_acctno into :ll_nodeno, :ls_sweldo_mo_acctno
	from arAcctSubscriber
	where acctno = :is_acctno
	and divisioncode = :gs_divisioncode
	and companycode = :gs_companycode
	using SQLCA; 
	
	
	select nodedesc, docsistype into :ls_nodedesc, :ls_docsistype
	from nodesInIpcommander
	where nodeno = :ll_nodeno
	and divisioncode = :gs_divisioncode
	and companycode = :gs_companycode
	using SQLCA; 
	
	//-----Retrieve Clientclassvalue-----//
	
	select packagecode into :ls_packagecode
	from aracctsubscriber
	where acctno = :is_acctno
	and divisioncode = :gs_divisioncode
	and companycode = :gs_companycode
	using SQLCA;
	
	string ls_clientclassvalue , ls_packagetypecode
	
	select packagetypecode into :ls_packagetypecode
	from arpackagemaster
	where packagecode = :ls_packagecode
	and divisioncode = :gs_divisioncode
	and companycode= :gs_companycode
	using SQLCA;
	
	long ll_ctr_redgreen_tag
	
	select count(*) into :ll_ctr_redgreen_tag
	from temp_GREENflagpackages
	where inetpackagecode = :ls_packagecode
	using SQLCA;
	
	if ll_ctr_redgreen_tag > 0 then
		tab_1.tp_subsinfo.dw_info.setItem(tab_1.tp_subsinfo.dw_info.getrow(),"greenflagtagging",'Y')
	end if
	
	if ls_packagetypecode  = 'GEP' then
		
		select clientclassvalue into :ls_clientclassvalue
		from arpackagemaster
		where packagecode = :ls_packagecode
		and divisioncode = :gs_divisioncode
		and companycode = :gs_companycode
		using SQLCA;
		
		tab_1.tp_subsinfo.dw_info.setItem(tab_1.tp_subsinfo.dw_info.getrow(),"clientclassvalue",ls_clientclassvalue)
		
	else
		
		select SUBSTR(clientclassvalue,3,20) into :ls_clientclassvalue
		from arpackagemaster
		where packagecode = :ls_packagecode
		and divisioncode = :gs_divisioncode
		and companycode = :gs_companycode
		using SQLCA;
		
		ls_clientclassvalue = ls_docsistype + ls_clientclassvalue
		tab_1.tp_subsinfo.dw_info.setItem(tab_1.tp_subsinfo.dw_info.getrow(),"clientclassvalue",ls_clientclassvalue)
	end if 
	
	//-----END Retrieve Clientclassvalue-----//
	
	
	//tab_1.tp_subsinfo.dw_info.object.t_sweldomo.text = ls_sweldo_mo_acctno
	tab_1.tp_subsinfo.dw_info.object.t_nodeno.text = string(ll_nodeno)
	tab_1.tp_subsinfo.dw_info.object.t_nodedesc.text = ls_nodedesc
			
	tab_1.tp_subsinfo.dw_info.object.t_installationoriginname.text = ls_installationRemarksName
	tab_1.tp_subsinfo.dw_info.setItem(tab_1.tp_subsinfo.dw_info.getrow(),"lockinperiod",li_lockInperiod)
	
	tab_1.tp_subsinfo.dw_info.setItem(tab_1.tp_subsinfo.dw_info.getrow(),"isSoaPrinting",ls_isSoaPrinting)
	tab_1.tp_subsinfo.dw_info.setItem(tab_1.tp_subsinfo.dw_info.getrow(),"iscableboxemail",ls_isCableBoxSending)
	tab_1.tp_subsinfo.dw_info.setItem(tab_1.tp_subsinfo.dw_info.getrow(),"isemailsending",ls_isEmailSending)
	tab_1.tp_subsinfo.dw_info.setItem(tab_1.tp_subsinfo.dw_info.getrow(),"issmssending",ls_isSMSSending)
	tab_1.tp_subsinfo.dw_info.setItem(tab_1.tp_subsinfo.dw_info.getrow(),"mobileNo2",ls_mobileNo2)
	tab_1.tp_subsinfo.dw_info.setItem(tab_1.tp_subsinfo.dw_info.getrow(),"mobileNo3",ls_mobileNo3)
	tab_1.tp_subsinfo.dw_info.setItem(tab_1.tp_subsinfo.dw_info.getrow(),"emailaddress2",ls_emailaddress2)
	tab_1.tp_subsinfo.dw_info.setItem(tab_1.tp_subsinfo.dw_info.getrow(),"emailaddress3",ls_emailaddress3)
	tab_1.tp_subsinfo.dw_info.setItem(tab_1.tp_subsinfo.dw_info.getrow(),"nameofcompany",ls_nameofcompany)
	tab_1.tp_subsinfo.dw_info.setItem(tab_1.tp_subsinfo.dw_info.getrow(),"guarantor",ls_guarantor)
	Tab_1.Tp_Subsinfo.Dw_Info.Setitem(Tab_1.Tp_Subsinfo.Dw_Info.Getrow(),"spousename",Ls_Spousename)
	
	ll_adsrow = tab_1.tp_adsinfo.dw_adsinfo.retrieve(is_acctno,gs_divisioncode,gs_companycode)
	if ll_adsrow > 0 then
		tab_1.tp_subsinfo.dw_info.setitem(tab_1.tp_subsinfo.dw_info.getrow(),"withadshistory",'Y')
	else 
		tab_1.tp_subsinfo.dw_info.setitem(tab_1.tp_subsinfo.dw_info.getrow(),"withadshistory",'N')
	end if
	is_digital = tab_1.tp_subsInfo.dw_info.getitemstring(tab_1.tp_subsInfo.dw_info.getrow(),'isDigital')
	
	tab_1.tabpage_amortized_ar.dw_amortized_ar.retrieve(is_acctNo, gs_divisionCode, gs_companyCode)
	
	if is_serviceType = 'INET' then
		tab_1.tp_assignedstb.dw_assignedcm.visible = True
		tab_1.tp_assignedstb.dw_assignedcm.setposition(ToTop!)
		tab_1.tp_circuit.enabled = True
		tab_1.tp_mailbox.enabled = True
		tab_1.tp_mailbox.dw_mailbox.retrieve(is_acctNo,gs_divisionCode,gs_companyCode)
	else
		if is_digital = 'Y' then
			tab_1.tp_assignedstb.dw_assignedstb_digital.visible = True
			tab_1.tp_assignedstb.dw_assignedstb_digital.setposition(ToTop!)
			tab_1.tp_assignedSTB.dw_assignedstb_digital.retrieve(is_acctNo, gs_divisionCode, gs_companyCode)
		else			
			tab_1.tp_assignedstb.dw_assignedstb_digital.visible = FALSE
			tab_1.tp_assignedSTB.dw_assignedstb.retrieve(is_acctNo, gs_divisionCode, gs_companyCode)	
		end if
	end IF	
	

--******************************************************************
--	uo_subscriber luo_subscriber
--
--	luo_subscriber.setAcctNo(is_acctNo)
--	if luo_subscriber.subscriberStatusCode = 'ADS' then
--		pb_activate.enabled = true
--	else
--		pb_activate.enabled = false
--	end if
--******************************************************************

	f_closeStatus()

--banong 2009/10/10 set item arotheraccount

	
	select a.arothacctno, b.acctname
	into :ls_arothacctno, :ls_acctname
	from araccountmaster a
	inner join araccountmaster b on b.acctno = a.arothacctno
					and b.divisioncode = a.divisioncode
					and b.companycode = a.companyCode
	where a.acctno = :is_acctno
	and a.companycode = :gs_companyCode
	and a.divisioncode = :gs_divisioncode
	using SQLCA;
	if SQLCA.SQLCode < 0 then
		guo_func.msgBox('Error!', string(SQLCA.SQLCode) + SQLCA.SQLErrText)
		return
	end if
	
	tab_1.tp_subsinfo.dw_info.setitem(1,'arothacctno',ls_arothacctno)
	tab_1.tp_subsinfo.dw_info.setitem(1,'arothacctname',ls_acctname)
//banong end

end if

//----------------------------------------------------------------------------
tab_1.tp_images.cb_updateImage.visible = True



if not isnull(is_acctNo) and  is_acctNo <> "" then
	s_applmlinecam s_cam
	long ll_count
	
	select companyId into :ls_compID
	from systemParameter
	where divisionCode = :gs_divisionCode
			and companyCode = :gs_companyCode
	using SQLCA;

	select itemValue into :ls_fileServer
	from sysParamString
	where itemName = 'IMAGEPATH'
	and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	using SQLCA;


	long ll_pos1, ll_pos2
	string ls_mid1, ls_mid2
	
	ll_pos1 = pos(ls_fileServer, '\\')
	ls_mid1 = mid(ls_fileServer, 3, len(ls_fileServer))
	ll_pos2 = pos(ls_mid1, '\')
	ls_mid2 = mid(ls_mid1, ll_pos2, len(ls_fileServer))
	ls_fileServer = '\\' + gs_ImageServerIPAddress + ls_mid2
	
	ll_count = tab_1.tp_subsinfo.dw_info.rowcount()
	
	if ll_count > 0 then
		ldt_date = tab_1.tp_subsinfo.dw_info.getItemDateTime(1,"dateAdd")
		ls_year = string(year(date(ldt_date)))
		ls_month = string(month(date(ldt_date)),"00")
		ls_directory = trim(ls_year)+trim(ls_month)
		ls_acctNo = tab_1.tp_subsinfo.dw_info.getItemString(tab_1.tp_subsinfo.dw_info.getRow(),"acctNo")
		ls_path = ls_fileServer+ls_directory
		ls_parentwindow = "w_subscriber_maintenance"
		
		s_cam.ss_fileserver = ls_fileServer
		s_cam.ss_acctno = ls_acctNo
		s_cam.ss_directory = ls_directory
		s_cam.si_nosuffix = ii_noSuffix
		s_cam.ss_compid = ls_compID
		s_cam.ss_parentWindow = ls_parentWindow
		lb_dirExists = DirectoryExists(ls_path)
		if lb_direxists = false then
		//	CreateDirectory(ls_path + '\')
		end if
	end if 
end if

string ls_lastInfoUpdate, ls_contactNo

select lastInfoUpdate, contactNo
into :ls_lastInfoUpdate, :ls_contactNo
from arAcctAddress
where acctNo = :is_acctno
and addressTypeCode = 'SERVADR1'
and divisionCode = :gs_divisionCode
and companyCode = :gs_companyCode
using SQLCA;

tab_1.tp_subsinfo.dw_info.setitem(1,'lastInfoUpdate',ls_lastInfoUpdate)
tab_1.tp_subsinfo.dw_info.setitem(1,'contactNo',ls_contactNo)
			   
--END SEEARCH			   
			   

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
        
        --EVENT BUTTON CLICKED
        
        
			string ls_serialno , ls_selected , ls_cpetypecode, ls_productid, is_acctNofull, ls_itemcode, ls_subscriberName
			
			if dwo.name = 'b_load' then
				this.retrieve(is_acctNo, gs_divisionCode, gs_companyCode)	
				
				long ll_ctr
				string  ls_packagecode, ls_packageName, ls_isPrimary
				for ll_ctr = 1 to this.rowcount()
					ls_packageCode = ''
					ls_packageName = ''
					ls_isprimary = ''
					
					ls_serialNo = this.getItemString(ll_ctr,'subscribercpemaster_serialno')
					
					select a.packageCode, b.packageName, a.isprimary into :ls_packageCode, :ls_packageName, :ls_isPrimary
					from subscriberCpeMaster a
					inner join arPackageMaster b on b.packageCode = a.packageCode and b.divisionCode = a.divisionCode
					where a.serialNo = :ls_serialNo
					and a.divisionCode = :gs_divisionCode
					and a.companyCode = :gs_companyCode
					using SQLCA;
					
					if isNull(ls_isPrimary) or ls_isPrimary = '' then ls_isPrimary = 'N'
					
					if isNull(ls_packageName) or ls_packageName = '' then
					
						select a.packageName into :ls_packageName
						from arAcctSubscriber b 
						inner join arPackageMaster a on a.packageCode = b.packageCode and a.divisionCOde = b.divisionCode
						where b.acctNo = :is_acctNo
						and b.divisionCode = :gs_divisionCode
						and b.companyCode = :gs_companyCode
						using SQLCA;
						
						ls_isPrimary = 'Y'
					
					end if 
					
					this.setItem(ll_ctr,'packageName',ls_packageName)
					this.setItem(ll_ctr,'isprimary',ls_isprimary)
				next 
			
			elseif dwo.name = 'b_refresh' then
				string ls_status , ls_responsecode , ls_responsetext
				uo_subscriber_def luo_subscriber
				luo_subscriber = create using "uo_subscriber_def"
				
				 long ll_row
				 
				 for ll_row = 1 to this.rowCount()
					ls_selected = this.GetItemString(ll_row,'selected')
					
					if ls_selected <> 'Y' then 
						continue
					end if
					
					ls_serialno = this.GetItemString(ll_row,'subscribercpemaster_serialno')
					ls_itemcode = this.GetItemString(ll_row,'itemmaster_itemcode')
					
					select cpetypecode , packagecode into :ls_cpetypecode, :ls_packagecode
					from subscriberCpeMaster
					where serialNo = :ls_serialNo
					and divisioncode = :gs_divisioncode
					and companycode = :gs_companycode
					using SQLCA;
					
					if ls_cpetypecode = 'IPTV' then
						
						
						select productId into :ls_productid
						from arPackageMaster
						where packageCode = :ls_packageCode
						and divisionCode = :gs_divisionCode
						and companyCode = :gs_companyCode
						using SQLCA;
						
						select acctNo, subscriberName into :is_acctNofull , :ls_subscriberName
						from vw_fullAcctNo
						where ibas_acctNo = :is_acctNo
						and divisionCode = :gs_divisionCode
						and companyCode = :gs_companycode
						using SQLCA;
						
			
				insert into iptv_provisioning_tran
				(acct_no, item_code, subscriber_name, stb_serial_no, product_id, processed, trantypecode, dateadd)
				values
				(:is_acctNofull, :ls_itemCode, :ls_subscriberName, :ls_serialno, :ls_productId, 'N', 'ACTIVATE', sysdate)
				USING SQLCA;
				
				COMMIT USING SQLCA;
					else
				
						if not	luo_subscriber.setAcctNo(is_acctNo) then
								guo_func.msgbox('SM-0000001', luo_subscriber.lastSQLCode + "~r~n" + luo_subscriber.lastSQLErrText, &
																				'Method: luo_subscriber.setAcctNo()')
								return -1
						end IF
						
						--validasi luo_subscriber.setAcctNo
						


							lastMethodAccessed = 'setAcctNo'
							
							acctNo = as_acctNo
							
							select 
							tranNo,
							arAcctSubscriber.acctNo,
							subscriberName,
							typeOfBusiness,
							lastName,
							firstName,
							middleName,
							motherMaidenName,
							citizenshipCode,
							sex,
							birthDate,
							civilStatus,
							telNo,
							mobileNo,
							faxNo,
							emailAddress,
							service.serviceHomeOwnerShip, 
							service.serviceLessorOwnerName,
							service.serviceLessorOwnerContactNo,
							service.serviceYearsResidency,
							service.serviceExpirationDate,
							service.HouseNo, 
							service.StreetName, 
							service.BldgName,
							service.LotNo,
							service.BlkNo,
							service.Phaseno,
							service.District,
							service.Purokno,
							service.SubdivisionCode,
							service.BarangayCode,
							service.MunicipalityCode,
							service.ProvinceCode,
							circuitID,
							service.CompleteAddress,
							service.contactName,
							service.contactNo,
							billing.contactName,
							billing.contactNo,
							billing.HouseNo,
							billing.StreetName,
							billing.BldgName,
							billing.LotNo,
							billing.BlkNo,
							billing.PhaseNo,
							billing.District,
							billing.Purokno,
							billing.SubdivisionCode,
							billing.BarangayCode,
							billing.MunicipalityCode,
							billing.ProvinceCode,
							billing.CompleteAddress,
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
							nvl(numberOfRooms,0),
							nvl(occupancyRate,0),
							nvl(mLineCurrentMonthlyRate,0), 
							nvl(mLinePreviousMonthlyRate,0),
							nvl(extCurrentMonthlyRate,0) ,
							nvl(extPreviousMonthlyRate,0),
							withAdvances,
							locked,
							lockedBy,
							lockedWithTrans,
							referenceJONo,
							acquisitionTypeCode,
							agentCode,
							useradd,
							dateadd,
							currencyCode,
							password,
							subsUserName,
							nodeNo,
							servicePostNo,
							service.CompleteAddress,
							b.completeAddress,
							c.completeAddress,
							billing.CompleteAddress,
							bundledCTVAcctNo,
							bundledINETAcctNo,
							lockinperiod,
							mobileno2,
							mobileno3,
							emailaddress2,
							emailaddress3,
							nameofcompany,
							guarantor,
							spousename,
							lockinPeriod,
							daterelockin,
							from_NOCOICOP
							
							into 
							
							:tranNo,
							:acctNo,
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
							:telNo,
							:mobileNo,
							:faxNo,
							:emailAddress,
							:serviceHomeOwnerShip,
							:serviceLessorOwnerName,
							:serviceLessorOwnerContactNo,
							:serviceYearsResidency,
							:serviceExpirationDate,
							:serviceHouseNo,
							:serviceStreetName,
							:serviceBldgCompApartmentName,
							:serviceLotNo,
							:serviceBlockNo,
							:servicePhase,
							:serviceDistrict,
							:servicePurok,
							:serviceSubdivisionCode,
							:serviceBarangayCode,
							:serviceMunicipalityCode,
							:serviceProvinceCode,
							:circuitID,
							:serviceAddressComplete,
							:serviceContactName,
							:serviceContactNo,
							:billingContactName,
							:billingContactNo,
							:billingHouseNo,
							:billingStreetName,
							:billingBldgCompApartmentName,
							:billingLotNo,
							:billingBlockNo,
							:billingPhase,
							:billingDistrict,
							:billingPurok,
							:billingSubdivisionCode,
							:billingBarangayCode,
							:billingMunicipalityCode,
							:billingProvinceCode,
							:billingAddressComplete,
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
							:agentCode,
							:useradd,
							:dateadd,
							:currencyCode,
							:password,
							:subsUserName,
							:nodeNo,
							:servicePostNo,
							:siteA,
							:siteB,
							:businessAdd,
							:billingAdd,
							:bundledCTVAcctNo,
							:bundledINETAcctNo,
							:lockinperiod,
							:mobileno2,
							:mobileno3,
							:emailaddress2,
							:emailaddress3,
							:nameofcompany,
							:guarantor,
							:spousename,
							:lockinPeriod,
							:daterelockin,
							:from_NOCOICOP
							from arAcctSubscriber
							inner join vw_arAcctAddress billing on billing.acctNo  = arAcctSubscriber.acctNo 
								and billing.addressTypeCode = 'BILLING' 
								and billing.divisionCode  = arAcctSubscriber.divisionCode 
								and billing.companyCode = arAcctSubscriber.companyCode 
							inner join vw_arAcctAddress service on service.acctNo  = arAcctSubscriber.acctNo 
								and service.addressTypeCode = 'SERVADR1' 
								and service.divisionCode  = arAcctSubscriber.divisionCode 
								and service.companyCode = arAcctSubscriber.companyCode 
							left join vw_arAcctAddress b on b.acctNo  = arAcctSubscriber.acctNo
								and b.addressTypeCode = 'SERVADR2' 
								and b.divisionCode  = arAcctSubscriber.divisionCode 
								and b.companyCode = arAcctSubscriber.companyCode 
							left join vw_arAcctAddress c on c.acctNo  = arAcctSubscriber.acctNo 
								and c.addressTypeCode = 'BUSINESS' 
								and c.divisionCode  = arAcctSubscriber.divisionCode 
								and c.companyCode = arAcctSubscriber.companyCode 
							
							
							where arAcctSubscriber.acctNo = :acctNo
							and arAcctSubscriber.divisionCode = :gs_divisionCode 
							and arAcctSubscriber.companyCode = :gs_companyCode
							AND ARACCTSUBSCRIBER.DBDIRECTION <> 'HOBS'
							and rownum < 2
							
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
								lastSQLErrText	= "The customer type code [" + chargeTypeCode + "] does not exist."
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
							
							select serviceType, isDigital
							into :serviceType, :isDigital
							from arPackageMaster
							where packageCode = :packageCode
							and divisionCode = :gs_divisionCode
							and companyCode = :gs_companyCode
							using SQLCA;
							
							if serviceType = 'CTV' then
								select a.packageName, a.generalPackageCode, b.generalPackageName, a.packageDescription
								  into :packageName, :generalPackageCode, :generalPackageName, :packageDescription
								  from arPackageMaster a, generalPackageMaster b
								 where a.generalPackageCode = b.generalPackageCode
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
							elseif serviceType = 'INET' then
								select a.packageName, a.packageTypeCode, b.packageTypename, a.cmProfileCode, a.limited, a.hoursFree, a.excessPerMinuteRate, a.ppoeCode, a.shortName, a.packageDescription
								  into :packageName, :packageTypeCode, :packageTypeName, :cmProfileCode, :limited, :hoursFree, :excessPerMinuteRate, :ppoeCode, :shortName, :packageDescription
								  from arPackageMaster a, packageTypeMaster b
								 where a.packageTypeCode = b.packageTypeCode
									and a.divisionCode = :gs_divisionCode
									and a.companyCode = :gs_companyCode
									and b.companyCode = :gs_companyCode
									and b.divisionCode = :gs_divisionCode
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
								
								if not isnull(cmProfileCode) then
							
									select ubrType
									into :ubrType
									from nodesInIPCommander
									where nodeNo = :nodeNo
									and divisionCode = :gs_divisionCode
									and companyCode = :gs_companyCode
									using SQLCA;
									
									select clientClassValue
									into :clientClassValue
									from clientClassValueMaster
									where cmProfileCode = :cmProfileCode
									and ubrType = :ubrType
									and divisionCode = :gs_divisionCode
									and companyCode = :gs_companyCode
									using SQLCA;		
							
									select cmProfileName, vLan
									  into :cmProfileName, :vLan
									  from cmProfileMaster
									 where cmProfileCode = :cmProfileCode
									 and divisionCode = :gs_divisionCode
									and companyCode = :gs_companyCode
									using SQLCA;
									if SQLCA.sqlcode = 100 then 
										lastSQLCode = string(SQLCA.sqlcode)
										lastSQLErrText = 'Record does not exist in CM Profile.' + '~r~n~r~n' + 'CM Profile Code : ' + cmProfileCode
										return FALSE	
									elseif SQLCA.sqlcode < 0 then 
										lastSQLCode = string(SQLCA.sqlcode)
										lastSQLErrText = 'SQL Error :' + '~r~n~r~n' + SQLCA.sqlerrtext
										return FALSE	
									end if
								
								end if
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
								currencyCode = 'PHP'
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
							
							select conversionRate
							into :dollarRate
							from currencyMaster
							where currencyCode = 'USD'
							using SQLCA;
							if SQLCA.SQLCode < 0 then
								lastSQLCode	= string(SQLCA.SQLCode)
								lastSQLErrText	= SQLCA.SQLErrText
								return FALSE
							end if
							
							
							select acctNo into :fullAccountNumber
							from vw_fullAcctNo
							where ibas_acctNo = :as_acctNo
							and divisionCode = :gs_divisionCode
							and companyCode = :gs_companyCode
							using SQLCA;
							
							//~~~~~~~~~~~~~~~~~~END~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
							
							//prepaidSubscriber,
							//:prepaidSubscriber,
							
							return TRUE

						--end validasi
						
						ls_status = luo_subscriber.subscriberstatuscode
						
						if ls_status <> 'APL' then
							if luo_subscriber.refreshCableModem() then
								commit using SQLCA;
								guo_func.msgbox('Notice...', 'You have refreshed the cable modem, your request will be processed in just a moment. Please wait!')
							else
								rollback using SQLCA;
								guo_func.msgbox('Warning!', luo_subscriber.lastSQLCode + '~r~n~r~n' + luo_subscriber.lastSQLErrText)
							end if
						else
								guo_func.msgbox('Invalid!', 'Unable to continue.. CPE of Applied Accounts can only be refreshed in JO Monitoring Transaction ,please proceed to JO Monitoring.. Thank you')
						end IF
						
						--VALIDASI refreshCableModem
						
						string ls_package
								if isnull(subsUserName) then subsUserName = ''
								if isnull(password) then password = ''
								
								if uf_isAllowedInMpthrill(packageTypeCode) or uf_isAllowedInCMLRadius(packageTypeCode) then
									str_assignedcpe s_assignedModems[]
									if subscriberStatusCode <> 'APL'  then
										if not getAssignedModem(s_assignedModems) then
											return FALSE
										end if	
									elseif subscriberStatusCode = 'APL' then
										if not getAssignedModemFromJO(s_assignedModems) then
											return FALSE
										end if	
									end if
									
									// =============================================================
									// this will activate the most recently assign to the subscriber
									// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
									if (subscriberStatusCode = 'ACT' or subscriberStatusCode = 'APL')  and s_assignedModems[1].cpestatuscode = 'AC' then	
										if upperbound(s_assignedModems) > 0 then
									
												if shortName = 'TRANSIENT' then
													select packageCode
													into :ls_package
													from cpePrepaidLoad
													where acctNo = :acctNo
													and divisionCode = :gs_divisionCode
													and companyCode = :gs_companyCode
													and dateRemoved is null
													and rownum < 2
													order by dateLoaded asc
													using SQLCA;
													if ls_package = '' or isNull(ls_package) then
														if not uf_insertIntoMPThrilRequestMaster(acctNo, subsUserName, password, 'REFRESH', '', 'DEACTIVATE', &
																	s_assignedModems[1].serialNo, s_assignedModems[1].macAddress, lastSQLErrText) then
															return FALSE
														end IF
														--SEE THE FUNCTION ADD VLAN MAINTENANCE
													else
														if not uf_insertIntoMPThrilRequestMaster(acctNo, subsUserName, password, 'REFRESH', '', 'ACTIVATE', &
																	s_assignedModems[1].serialNo, s_assignedModems[1].macAddress, lastSQLErrText) then
															return FALSE
														end IF
														--SEE THE FUNCTION ADD VLAN MAINTENANCE
													end if
												else
													if not uf_insertIntoMPThrilRequestMaster(acctNo, subsUserName, password, 'REFRESH', '', 'ACTIVATE', &
																s_assignedModems[1].serialNo, s_assignedModems[1].macAddress, lastSQLErrText) then
														return FALSE
													end IF
													--SEE THE FUNCTION ADD VLAN MAINTENANCE
												end if			
											
										end if
									else		
										if upperbound(s_assignedModems) > 0 then
											if not uf_insertIntoMPThrilRequestMaster(acctNo, subsUserName, password, 'REFRESH', '', 'DEACTIVATE', &
														s_assignedModems[1].serialNo, s_assignedModems[1].macAddress, lastSQLErrText) then
												return FALSE
											end if
										end if
									end if
									
									/**added by zar  02/16/2009 */
									if not isnull(bundledCTVAcctNo) then
										if not setBundledAcctStatus(subscriberStatusCode) then
											return FALSE			
										end if	
									end if	
									
									--VALIDASI setBundledAcctStatus
										
									string ls_serialNos[], ls_serialNo, ls_packageCode, ls_chargeTypeCode, ls_stbStat
									long   ll_loop, ll_rows
									date   ldt_nullExpiryDate
									
									string ls_parm, ls_bundleCo, ls_bundleDiv, ls_bundleServer, ls_bundleDatabase, ls_isMultiDivision
									string ls_INIFile, ls_username, ls_e_password, ls_password
									
									select  bundleCompanyCode, bundleDivisionCode, bundleDatabaseName, bundleServerName, isMultiDivision
									into    :ls_bundleCo, :ls_bundleDiv, :ls_bundleDatabase, :ls_bundleServer, :ls_isMultiDivision
									from    sysCompanyBundles
									where   parentCompanyCode = :gs_companyCode 
									  and   parentDivisionCode = :gs_divisionCode
									using   SQLCA;  
									if SQLCA.SQLCode <> 0 then
										guo_func.MsgBox('SQL Error...','Unable to locate parameter for service bundling ' + &
														    '~r~nSelect from table [sysCompanyBundle] returned error...' + &
															 '~r~n~r~nSQL Error Code : ' + string(SQLCA.SQLCode) + &
															 '~r~nSQL Error Text : ' + SQLCA.SQLErrText)
															 return false
									end if	
									
									
									ACCTN = create TRANSACTION
									
									
									ls_INIFile 		 = "SYSTEM.INI"	
									ls_username 	 = ProfileString(ls_INIFile, "LOGIN", "username", "")
									ls_e_password 	 = ProfileString(ls_INIFile, "LOGIN", "password", "")
									ls_password 	 = guo_func.decrypt(ls_e_password)
									// Profile Oracle
									ACCTN.DBMS = "ODBC"
									ACCTN.AutoCommit = False
									ACCTN.DBParm = "ConnectString='DSN=iBAST4;UID=" + ls_username + ";PWD=" + ls_password + "'"
									
									
									connect using ACCTN;
										
									if ACCTN.SQLCode <> 0 then
										lastSQLCode    = string(ACCTN.SQLCode)
										lastSQLErrText = ACCTN.SQLErrText
										disconnect using ACCTN;
										destroy ACCTN;
										return false
									end if	
									
									if ls_isMultiDivision = 'N' THEN
									else	
										update arAcctSubscriber
										set    subscriberStatusCode = :as_status
										where  acctNo = :bundledCTVAcctNo
										and    companyCode = :ls_bundleCo
										and    divisionCode = :ls_bundleDiv
										using  ACCTN;
										if ACCTN.SQLCode < 0 then
											lastSQLCode 	= string(ACCTN.SQLCode)
											lastSQLErrText = ACCTN.SQLErrText
											rollback using ACCTN;
											disconnect using ACCTN;
											destroy ACCTN;
											return false
										end if	
									end if
									
									if pos(as_status,'APL') > 0 then
										ls_stbStat = 'AC'
									end if	
									
									if pos(as_status,'ACT') > 0 then
										ls_stbStat = 'AC'
									end if	
									
									if pos(as_status,'DEA') > 0 then
										ls_stbStat = 'DE'
									end if	
									
									if pos(as_status,'ADS') > 0 then
										ls_stbStat = 'DE'
									end if	
									
									if pos(as_status,'PDS') > 0 then  
										ls_stbStat = 'DE'
									end if	
									
									if pos(as_status,'ETL') > 0 then
										ls_stbStat = 'DE'
									end if	
									
									
									if ls_isMultiDivision = 'N' THEN
									else
										update subscriberCPEMaster 
										set    cpeStatusCode = :ls_stbStat
										where  acctNo = :bundledCTVAcctNo
										and    companyCode = :ls_bundleCo
										and    divisionCode = :ls_bundleDiv
										using  ACCTN;
										if ACCTN.SQLCode < 0 then
											lastSQLCode 	= string(ACCTN.SQLCode)
											lastSQLErrText = ACCTN.SQLErrText
											rollback using ACCTN;
											disconnect using ACCTN;
											destroy ACCTN;
											return false
										end if		
									end IF
									
									uo_setTopBox luo_stb
									uo_stb_bundle luo_stbb
									
									if ls_isMultiDivision = 'N' THEN
									else
										select packageCode, chargeTypeCode into :ls_packageCode, :ls_chargeTypeCode 
										from   arAcctSubscriber
										where  acctNo = :bundledCTVAcctNo 
										and    companyCode = :ls_bundleCo
										and    divisionCode = :ls_bundleDiv
										using ACCTN;
										if ACCTN.SQLCode < 0 then
											lastSQLCode 	= string(ACCTN.SQLCode)
											lastSQLErrText = ACCTN.SQLErrText
											rollback using ACCTN;
											disconnect using ACCTN;
											destroy ACCTN;
											return false
										end if
									end if	
									
									if ls_isMultiDivision = 'N' THEN
									else
	
										luo_stbb = create using "uo_stb_bundle"
										
										if not luo_stbb.connect_bundle() then
											rollback using ACCTN;
											disconnect using ACCTN;											
											destroy ACCTN;
											
											return false
										end if	
									
										
										declare cur_stbs2 cursor for
											select serialNo from subscriberCPEMaster
											where  acctNo = :bundledCTVAcctNo 
											and    companyCode = :ls_bundleCo  
											and    divisionCode = :ls_bundleDiv
											using   ACCTN;
										
										open cur_stbs2;
											
										fetch cur_stbs2 into :ls_serialNo;
										
										Do while ACCTN.SQLCOde = 0 	
											ls_serialNos[upperBound(ls_serialNos) + 1] = ls_serialNo	
											fetch cur_stbs2 into :ls_serialNo;	
										loop	
										
										close cur_stbs2;
										/** now loop through and initialize one by one **/
										
										ll_rows = upperBound(ls_serialNos)
										
										for ll_loop = 1 to ll_rows
													
											luo_stbb.is_companyCode  = ls_bundleCo
											luo_stbb.is_divisionCode = ls_bundleDiv
											if not luo_stbb.setSerialNo(ls_serialNos[ll_loop]) then
												continue
											end if	
											
											setNull(ldt_nullExpiryDate)
											
											if not luo_stbb.refresh(bundledCTVAcctNo, ls_packageCode, today(), ldt_nullExpiryDate, 'MANUAL REFRESH', as_status, ls_chargeTypeCode) then
												lastSQLCode 	= luo_stbb.lastSQLCode
												lastSQLErrText	= luo_stbb.lastSQLErrText
												rollback using ACCTN;
												disconnect using ACCTN;												
												destroy ACCTN;												
												return true
											end IF
											
											--VALADISAI LUO_STBB.REFRESH
											
												deleteFromSTBPackages()
												
												---VALIDASI DELETEFROMSTBpACKAGES
												delete from stbPackages
														where serialNo = :serialNo
														using ACCTN;
												if ACCTN.sqlcode <> 0 then
													lastSQLCode		= string(ACCTN.sqlcode)
													lastSQLErrText	= ACCTN.sqlerrtext
													return FALSE
												end if	 
												
												return TRUE
												
												--END VALIDASI DELETEFROMSTBpACKAGES

												if as_accountTypeCode <> 'PPS' then
													if not insertIntoSTBPackages(as_acctNo, as_packageCode, adt_dateLoad, adt_expiryDate, as_remarks) then
														Return False
													end if
												end IF
												
												--VALIDASI INSERT INTO STB PACKAGE
												--==================================================
												--Note:
												--this uses the as_acctNo argument 'coz sometimes 
												--the STB is not yet assigned to a subscriber
												--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
												if not isnull(adt_expirationDate) then
													if adt_dateLoaded > adt_expirationDate then
														lastSQLCode 	= '-2'
														lastSQLErrText = 'Unable to continue. The date loaded is greater than the expiration date.'
														return FALSE
													end if
												end if
												
												update stbPackages
													set dateLoaded 	 = :adt_dateLoaded,
														 expirationDate = :adt_expirationDate,
														 remarks			 = :as_remarks
												 where serialNo = :serialNo
												 	and packageCode = :as_packageCode
												 using ACCTN;
												if ACCTN.sqlNRows <= 0 then 		
												
													insert into stbPackages (
																	serialNo,
																	packageCode,
																	boxIdNo,
																	itemCode,
																	controlNo,
																	acctNo,
																	dateLoaded,
																	expirationDate,
																	remarks )
														  values (
																	:serialNo,
																	:as_packageCode,
																	:boxIdNo,
																	:itemCode,
																	:controlNo,
																	:as_acctNo,
																	:adt_dateLoaded,
																	:adt_expirationDate,
																	:as_remarks )
															using ACCTN;
													if ACCTN.sqlcode < 0 then
														lastSQLCode 	= string(ACCTN.sqlCode)
														lastSQLErrText = ACCTN.sqlErrText
														return FALSE
													end if
													
												end if
												
												return TRUE
												--END VALIDASI
												
												if as_subsStatus = 'APL' and as_accountTypeCode = 'PPS' then
													if not insertIntoSTBPackages(as_acctNo, as_packageCode, adt_dateLoad, adt_expiryDate, as_remarks) then
														Return False
													end if
												end IF
												
												--SAME WITH BEFORE
													
												if not getSCSRequestNextTranNo() then
													Return False
												end if	
												
												--VALIDASI GETSCSREQUESTNEXTTRANSNO
												long ll_tranNo
													if not guo_func.get_nextnumber('SCSREQUEST', ll_tranno, 'WITH LOCK') then
														lastSQLCode = '-2'
														lastSQLErrText = 'Could not obtain the next SCS Request No.'
														Return False
													end if
													scsRequestNextTranNo = ll_tranNo
													
													Return TRUE
													
												--END GETSCSREQUESTNEXTTRANSNO
													
												--TAKE THE NUMBER FROM guo_func.get_nextnumber
													
													f_displayStatus("Retrieving next transaction # for " + as_trantype + "...")

													string	ls_lockedby
													
													if as_tranType = 'SCSREQUEST' then
														
														update systransactionparam
														set recordlocked = 'N',
														lockedusername = ''
														where tranTypeCode = :as_tranType 
																and divisionCode = :gs_divisionCode
																and companyCode = :gs_companyCode
																and  recordlocked = 'Y'
														using SQLCA;
														
													end if 
													
													select lockedUserName
													  		into :ls_lockedby
													from sysTransactionParam
													 		where tranTypeCode = :as_tranType 
													 		and divisionCode = :gs_divisionCode
													 		and companyCode = :gs_companyCode
													using SQLCA;
													if SQLCA.sqlcode = 100 then
														guo_func.msgbox("SM-0000010", as_tranType, "")
														f_closeStatus()
														return false
													elseif SQLCA.sqlcode <> 0 then
														guo_func.msgbox("SM-0000001", "Select error in sysTransactionParam" + "~r~n" + &
																							  string(SQLCA.sqlcode) 	+ "~r~n" + &
																							  SQLCA.sqlerrtext, "")
														f_closeStatus()
														return false
													end if
													
													if as_getmode = "WITH LOCK" then
														do while true
															update sysTransactionParam
																set recordLocked = 'Y',
																	 lockedUserName = :gs_username
															   where recordLocked = 'N' 
															   and tranTypeCode = :as_tranType
															   and divisionCode = :gs_divisionCode
													 		   and companyCode = :gs_companyCode		 
															using SQLCA;
															if SQLCA.sqlnrows < 1 then
																if guo_func.msgbox("SM-0000011", ls_lockedby, "") = 2 then
																	f_closeStatus()
																	return false
													 			end if
															else
																exit
															end if
														loop
													end if
													
													select lastTransactionNo, tranYear
													      into :al_tranNo, :ii_tranYear
													from sysTransactionParam
													      where tranTypeCode = :as_tranType
													      and divisionCode = :gs_divisionCode
													 		and companyCode = :gs_companyCode
													using SQLCA;
													if SQLCA.sqlcode = 100 then	// record not found
														guo_func.msgbox("SM-0000010", as_tranType, "")
														f_closeStatus()
														return false
													elseif SQLCA.sqlcode <> 0 then
														guo_func.msgbox("SM-0000001", "Select error in sysTransactionParam" + "~r~n" + &
																							  string(SQLCA.sqlcode) 	+ "~r~n" + &
																							  SQLCA.sqlerrtext, "")
														f_closeStatus()
														return false
													end if
													
													al_tranNo = al_tranNo + 1
													f_closeStatus()
													
													return true
												--END 
												
												setSCSRequestSource('MANREFRESH')
												
												--VALIDASI setSCSRequestSource
													scsRequestSourceTransaction 	= as_sourceTransaction
												--END VALIDASI
												
												if as_subsStatus = 'APL' or as_subsStatus = 'ACT' then
													if not initialize() then
														Return False
													end if
													incrementSCSRequestTranNo()
												elseif as_subsStatus = 'ADS' then													
													if not deactivate() then
														Return False
													end if	
													incrementSCSRequestTranNo()
													
													--VALIDASI incrementSCSRequestTranNo
													scsRequestNextTranNo++
												else
													if not deactivate() then
														Return False
													end if
													incrementSCSRequestTranNo()
												end if
												
												if not setSCSRequestTranNo() then
													Return False
												end IF
												
												--VALIDASI setSCSRequestTranNo
												
												if not guo_func.set_number('SCSREQUEST', scsRequestNextTranNo) then	
														lastSQLCode = '-2'
														lastSQLErrText = 'Could not set the next SCS Request No.'
														Return False
													end if
													
													Return True
												--END VALIDASI
												
												Return True

											--END VALIDASI
											
										next		
										
									end if	
									
									commit using ACCTN;
									disconnect using ACCTN;
									destroy ACCTN;
									
									
									return true
																			
									--END VALIDASI
									
								end if
								
								return TRUE

						
						--END VALIDASI 
						
						if ls_status = 'ACT' then
							
							if not uf_dynamicprovisioning(is_acctNo, 'ACTIVATEINET', ls_responsecode , ls_responsetext,'','') then
									return -1
							else
									guo_func.msgbox('SM-0000001', 'ACTIVATEINET '+ ls_responsecode+ "~r~n" + ls_responsetext)
							end if
						
						end if
						
						if ls_status <> 'ACT' then
							
							if not uf_dynamicprovisioning(is_acctNo, 'DEACTIVATEINET', ls_responsecode , ls_responsetext,'','') then
									return -1
							else
									guo_func.msgbox('SM-0000001', 'DEACTIVATEINET '+ ls_responsecode+ "~r~n" + ls_responsetext)
							end if
						
						end IF
						
						--VALIDASI FUNCTION uf_dynamicprovisioning
										

							string ls_subscribername , ls_subscriberstatuscode, ls_clientclassvalue , ls_productid
							string ls_packagecode , ls_entitlefrom , ls_entitleTo
								STRING ls_provincecode	, ls_trantype, LS_SERIALNO
							
							long li_recs , li_loop
							uo_ipcomm_mon luo_ipcomm
							
							
							
							string ls_servicetype , ls_json , ls_response
							long ll_tranno
							
							select servicetype into :ls_servicetype
							from divisionmaster
							where divisioncode = :gs_divisioncode
							and companycode = :gs_companycode 
							using SQLCA;
							
							
							long ll_pos
							string ls_source
								
								ll_pos = LastPos(as_trantype,'-')
							
							if ll_pos > 0 then
							
								ls_trantype =mid(as_trantype,1,ll_pos - 1)
								ls_source = mid(as_trantype,ll_pos + 1,len(as_trantype))
								
								as_trantype = ls_trantype
							
							else
								
								as_trantype= as_trantype
								
							end if
							
								if not	luo_ipcomm.setprovparams(as_acctno,ls_servicetype) then
										
										return FALSE
										
								end if 
							
							
							if as_trantypecode = 'APPLYTRANSFR' and as_trantype = 'DEACTIVATEINET' then
								
									luo_ipcomm.p_napcode = luo_ipcomm.p_oldnapcode
								
							end if						
							
														
													
							long rVal, lLog
							real amount
							
							
							string str_endpoint 
							
							str_endpoint = "http://192.168.180.138:81/WebService1.asmx"
							
							
							select DYNAMIC_PROVSEQ.nextval into :ll_tranno from dual using SQLCA;
							
							if isnull(luo_ipcomm.p_napcode) then 
								luo_ipcomm.p_napcode ='-'
							end if
							
							if luo_ipcomm.p_brand = 'DOCSIS' then 
									
									luo_ipcomm.p_acctno = luo_ipcomm.p_acctno
								
							end if
							
							
							if isnull(as_serialno) or as_serialno = "" then 
							
								luo_ipcomm.p_ontSerialNumber = luo_ipcomm.p_ontSerialNumber
							else
								luo_ipcomm.p_ontSerialNumber = as_serialno
								
							end if
							
							if as_trantype= 'ACTIVATEINET' then					
													
								
								
								ls_json= '{' +&
									'"ItemCode": "'+luo_ipcomm.p_itemcode+'",'+&
									'"brand": "'+luo_ipcomm.p_brand+'",'+& 
									'"acctNo": "'+luo_ipcomm.p_acctno+'",'+&
									'"napCode": "'+luo_ipcomm.p_napcode+'",'+&
									'"subscriberName": "'+luo_ipcomm.p_subscribername+'",'+&
									'"nodeNo": "'+luo_ipcomm.p_nodeno+'",'+&
									'"ontSerialNumber": "'+luo_ipcomm.p_ontSerialNumber+'",'+&
									'"macAddress": "'+luo_ipcomm.p_macaddress+'",'+&
									'"deviceModel": "'+luo_ipcomm.p_devicemodel+'",'+&
									'"productID": "'+luo_ipcomm.p_productid+'"'+&
									'}'
									
								//ls_response = proxy_obj.activateInet(ls_json)
								
								insert into DYNAMIC_PROV_REQUEST
								(tranno , trantypecode , itemcode , brand , acctno , subscribername , nodeno , ontserialno , macaddress , devicemodel , productid , apiresponse, PROCESSED, jsonparam, username)
								values
								(:ll_tranno , :as_trantype, :luo_ipcomm.p_itemcode , :luo_ipcomm.p_brand , :luo_ipcomm.p_acctno , :luo_ipcomm.p_subscribername , :luo_ipcomm.p_nodeno , :luo_ipcomm.p_ontSerialNumber , :luo_ipcomm.p_macaddress , :luo_ipcomm.p_devicemodel , :luo_ipcomm.p_productid , :ls_response, 'N', :ls_json, :gs_username)
								using SQLCA;
								if SQLCA.SQLCode <> 0 then
										
									as_responsecode = string(ll_tranno)
									as_responsetext = SQLCA.sqlerrtext
									return false
									
								else
									
									as_responsecode = string(ll_tranno)
									as_responsetext = ls_response
									
									commit using SQLCA;
									
									return true
								
								end if 
								
							elseif as_trantype= 'ACTIVATEIPTV' then
								
								
								string ls_jono  ,ls_macaddress
								
								select jono into :ls_jono
								from jotranhdr
								where acctno = :as_Acctno 
								and divisioncode = :gs_divisioncode
								and companycode = :gs_companycode
								and trantypecode = 'ADDFIBERTV'
								and jostatuscode not in ('CL','CN')
								using SQLCA;
								
								
								select serialno, macaddress into :ls_serialno , :ls_macaddress
								from jotrandtlassignedcpe
								where jono = :ls_jono
								and divisioncode = :gs_divisioncode
								and companycode = :gs_companycode
								using SQLCA;
								
								select b.packagecode into :ls_packagecode
								from applofvastranhdr a
								inner join applofvastrandtl b on b.tranno = a.tranno and b.divisioncode = a.divisioncode 
								where a.referencejono = :ls_jono
								and a.divisioncode = :gs_divisioncode
								using SQLCA;
								
								
								
								
								select provincecode into :ls_provincecode from aracctaddress 
								where acctno = :as_acctno and divisioncode= :gs_divisioncode and addresstypecode = 'SERVADR1' using SQLCA;
								
								
								if ls_provincecode = '000004' then
									
									ls_clientclassvalue = 'IPTV_REL'
								
								else
									
									ls_clientclassvalue = 'IPTV_CLK'
								 
								END IF 
								
								select   to_char(sysdate,'YYYY-MM-DD') ||'T00:00:00' into   :ls_entitlefrom
								from aracctsubscriber
								where acctno = :as_acctno
								and divisioncode = :Gs_divisioncode
								and companycode = :gs_companycode
								using SQLCA;
								
								select  productid into   :ls_productid
								from arpackagemaster
								where packagecode = :ls_packagecode
								and divisioncode = :gs_divisioncode
								and companycode = :gs_companycode
								using SQLCA;
								
								select to_char(itemValue,'YYYY-MM-DD') ||'T00:00:00' into :ls_entitleTo from sysParamDate where itemName = 'CASENTITLEEXPIRE' using SQLCA;  
								
								ls_json= '{' +&
											'"itemCode": "CPE00000151",' + &
											'"caBrand": "IPTVSTB - SUMAVISION and BCC",' +&
											'"acctNo": "'+luo_ipcomm.p_acctno+'",'+&
											'"napCode": "'+luo_ipcomm.p_napcode+'",'+&
											'"subscriberName": "'+luo_ipcomm.p_subscribername+'",'+&
											'"macAddress": "'+ls_macaddress+'",'+&
											'"managementId": "'+ls_clientclassvalue+'",'+&
											'"username": "'+ls_serialno+'",'+&
											'"password": "'+ls_serialno+'",'+&
											'"stbSerialNo": "'+ls_serialno+'",'+&
											'"productIDs": ['+&
											'"'+ls_productid+'"'+&
											'],'+&
											'"entitlementFrom": "'+ls_entitlefrom+'",' +&
											'"entitlementTo": "'+ls_entitleTo+'"' +&
											'}'
											
											insert into DYNAMIC_PROV_REQUEST
											(tranno , trantypecode , itemcode , brand , acctno , subscribername , nodeno , ontserialno , macaddress , devicemodel , productid , apiresponse, PROCESSED, jsonparam, username)
											values
											(:ll_tranno , :as_trantype, :luo_ipcomm.p_itemcode , :luo_ipcomm.p_brand , :luo_ipcomm.p_acctno , :luo_ipcomm.p_subscribername , :luo_ipcomm.p_nodeno , :luo_ipcomm.p_ontSerialNumber , :luo_ipcomm.p_macaddress , :luo_ipcomm.p_devicemodel , :luo_ipcomm.p_productid , :ls_response, 'N', :ls_json, :gs_username)
											using SQLCA;
											if SQLCA.SQLCode <> 0 then
													
												as_responsecode = STRING(ll_tranno)
												as_responsetext = SQLCA.sqlerrtext
											
											else
												
												as_responsecode = string(ll_tranno)
												as_responsetext = ls_response
												
												commit using SQLCA;
											
											end if 
								
								
							
							elseif as_trantype= 'DEACTIVATEINET' then
								
								ls_json= '{' +&
									'"ItemCode": "'+luo_ipcomm.p_itemcode+'",'+&
									'"brand": "'+luo_ipcomm.p_brand+'",'+&
									'"acctNo": "'+luo_ipcomm.p_acctno+'",'+&
									'"napCode": "'+luo_ipcomm.p_napcode+'",'+&
									'"subscriberName": "'+luo_ipcomm.p_subscribername+'",'+&
									'"nodeNo": "'+luo_ipcomm.p_nodeno+'",'+&
									'"ontSerialNumber": "'+luo_ipcomm.p_ontSerialNumber+'",'+&
									'"macAddress": "'+luo_ipcomm.p_macaddress+'",'+&
									'"deviceModel": "'+luo_ipcomm.p_devicemodel+'",'+&
									'"productID": "'+luo_ipcomm.p_productid+'"'+&
									'}'
									
									
								//ls_response = proxy_obj.deactivateInet(ls_json)
							
								insert into DYNAMIC_PROV_REQUEST
								(tranno , trantypecode , itemcode , brand , acctno , subscribername , nodeno , ontserialno , macaddress , devicemodel , productid , apiresponse, PROCESSED, jsonparam, username)
								values
								(:ll_tranno , :as_trantype, :luo_ipcomm.p_itemcode , :luo_ipcomm.p_brand , :luo_ipcomm.p_acctno , :luo_ipcomm.p_subscribername , :luo_ipcomm.p_nodeno , :luo_ipcomm.p_ontSerialNumber , :luo_ipcomm.p_macaddress , :luo_ipcomm.p_devicemodel , :luo_ipcomm.p_productid , :ls_response, 'N', :ls_json, :gs_username)
								using SQLCA;
								if SQLCA.SQLCode <> 0 then
										
									as_responsecode = STRING(ll_tranno)
									as_responsetext = SQLCA.sqlerrtext
								
								else
									
									as_responsecode = string(ll_tranno)
									as_responsetext = ls_response
									
									commit using SQLCA;
								
								end if 
								
							
							elseif as_trantype = 'DEACTIVATEIPTV' then
								
								
								select provincecode into :ls_provincecode from aracctaddress 
								where acctno = :as_acctno and divisioncode= :gs_divisioncode and addresstypecode = 'SERVADR1' using SQLCA;
								
								if ls_provincecode = '000004' then
									
									ls_clientclassvalue = 'IPTV_REL'
								
								else
									
									ls_clientclassvalue = 'IPTV_CLK'
								 
								END IF 
								
								select  packagecode , to_char(sysdate,'YYYY-MM-DD') ||'T00:00:00' into  :ls_packagecode , :ls_entitlefrom
								from aracctsubscriber
								where acctno = :as_acctno
								and divisioncode = :Gs_divisioncode
								and companycode = :gs_companycode
								using SQLCA;
								
								select  productid into   :ls_productid
								from arpackagemaster
								where packagecode = :ls_packagecode
								and divisioncode = :gs_divisioncode
								and companycode = :gs_companycode
								using SQLCA;
								
								select to_char(itemValue,'YYYY-MM-DD') ||'T00:00:00' into :ls_entitleTo from sysParamDate where itemName = 'CASENTITLEEXPIRE' using SQLCA;  
								
								ls_json= '{' +&
											'"itemCode": "CPE00000151",' + &
											'"caBrand": "IPTVSTB - SUMAVISION and BCC",' +&
											'"acctNo": "'+luo_ipcomm.p_acctno+'",'+&
											'"napCode": "'+luo_ipcomm.p_napcode+'",'+&
											'"subscriberName": "'+luo_ipcomm.p_subscribername+'",'+&
											'"macAddress": "'+luo_ipcomm.p_macaddress+'",'+&
											'"managementId": "'+ls_clientclassvalue+'",'+&
											'"username": "'+luo_ipcomm.p_ontSerialNumber+'",'+&
											'"password": "'+luo_ipcomm.p_ontSerialNumber+'",'+&
											'"stbSerialNo": "'+luo_ipcomm.p_ontSerialNumber+'",'+&
											'"productIDs": ['+&
											'"'+ls_productid+'"'+&
											'],'+&
											'"entitlementFrom": "'+ls_entitlefrom+'",' +&
											'"entitlementTo": "'+ls_entitleTo+'"' +&
											'}'
											
											insert into DYNAMIC_PROV_REQUEST
											(tranno , trantypecode , itemcode , brand , acctno , subscribername , nodeno , ontserialno , macaddress , devicemodel , productid , apiresponse, PROCESSED, jsonparam, username)
											values
											(:ll_tranno , :as_trantype, :luo_ipcomm.p_itemcode , :luo_ipcomm.p_brand , :luo_ipcomm.p_acctno , :luo_ipcomm.p_subscribername , :luo_ipcomm.p_nodeno , :luo_ipcomm.p_ontSerialNumber , :luo_ipcomm.p_macaddress , :luo_ipcomm.p_devicemodel , :luo_ipcomm.p_productid , :ls_response, 'N', :ls_json, :gs_username)
											using SQLCA;
											if SQLCA.SQLCode <> 0 then
													
												as_responsecode = STRING(ll_tranno)
												as_responsetext = SQLCA.sqlerrtext
											
											else
												
												as_responsecode = string(ll_tranno)
												as_responsetext = ls_response
												
												commit using SQLCA;
											
											end if 
								
								
								
							
							elseif as_trantype= 'PAIRCTV' then
								
							
							elseif as_trantype= 'UNPAIRCTV' then
								
							
							elseif as_trantype= 'ACTIVATECTV' then
								
								string   ls_packageCodes[], ls_entFrom[] ,ls_entTo[] , ls_emptyentfrom[] , ls_emptyentto[] , ls_emptyPackageCodes[] 
								
								if ls_source = 'REFRESH' then
									//ppv refresh
									declare cur_ppv2 cursor for
										select packageCode, to_char(dateLoaded,'YYYY-MM-DD') ||'T00:00:00', to_char(expirationdate,'YYYY-MM-DD') ||'T00:00:00'
										from   cpePrepaidLoad 
										where  serialNo = :luo_ipcomm.p_ontSerialNumber
										and    acctNo   = :as_acctno
										and    dateRemoved is null
										and    divisionCode = :gs_divisionCode 
										and    companyCode  = :gs_companyCode
										using  SQLCA;
										
									open cur_ppv2;
									
									fetch cur_ppv2 into :ls_packageCode, :ls_entitlefrom, :ls_entitleto;
									
									ls_packageCodes = ls_emptyPackageCodes
									ls_entFrom = ls_emptyentfrom
									ls_entTo = ls_emptyentto
									
									Do While SQLCA.SQLCode = 0
										
										ls_packageCodes[upperBound(ls_packageCodes) + 1] = ls_packageCode
										ls_entFrom[upperBound(ls_entFrom) + 1] = ls_entitlefrom
										ls_entTo[upperBound(ls_entTo) + 1] = ls_entitleto		
										
										fetch cur_ppv2 into :ls_packageCode, :ls_entitlefrom, :ls_entitleto;
									loop
									
									close cur_ppv2;
									
									li_recs = upperBound(ls_packageCodes)
									
									for li_loop = 1 to li_recs
										
											ls_packageCode   = ls_packageCodes[li_loop]
											ls_entitlefrom =  ls_entFrom[li_loop]
											ls_entitleTo =  ls_entTo[li_loop]
											
											select productID into :ls_productID 
											from   arPackageMaster 
											where  packageCode = :ls_packageCode 
											and    divisionCode = :gs_divisionCode
											and    companyCode = :gs_companyCode
											using  SQLCA;
											
											
												ls_json = '{' +&
															'"itemCode": "TEST-CAS2",' +&
															'"stbSerialNo": "' + luo_ipcomm.p_ontSerialNumber +'",' +&
															'"acctNo": "' +luo_ipcomm.p_acctno+'",' +&
															'"subscriberName": "'+luo_ipcomm.p_subscribername+'",' +&
															'"productIDs": ["'+ls_productID+'"],'+&
															'"entitlementFrom": "'+ ls_entitlefrom+'",' +&
															'"entitlementTo": "' +ls_entitleTo+'",' +&
															'"title": "",' +&
															'"message": ""' +&
															'}'
										
										
											insert into DYNAMIC_PROV_REQUEST
											(tranno , trantypecode , itemcode , brand , acctno , subscribername , nodeno , ontserialno , macaddress , devicemodel , productid , apiresponse, PROCESSED, jsonparam, username)
											values
											(:ll_tranno , :as_trantype, :luo_ipcomm.p_itemcode , :luo_ipcomm.p_brand , :luo_ipcomm.p_acctno , :luo_ipcomm.p_subscribername , :luo_ipcomm.p_nodeno , :luo_ipcomm.p_ontSerialNumber , :luo_ipcomm.p_macaddress , :luo_ipcomm.p_devicemodel , :luo_ipcomm.p_productid , :ls_response, 'N', :ls_json, :gs_username)
											using SQLCA;
											if SQLCA.SQLCode <> 0 then
													
												as_responsecode = STRING(ll_tranno)
												as_responsetext = SQLCA.sqlerrtext
											
											else
												
												as_responsecode = string(ll_tranno)
												as_responsetext = ls_response
												
												commit using SQLCA;
											
											end if 
										
									
									
									next 
									//special channels refresh
										declare cur_spc cursor for
										select packageCode, to_char(trandate,'YYYY-MM-DD') ||'T00:00:00', to_char(expirationdate,'YYYY-MM-DD') ||'T00:00:00'
										from   subsSTBSpChanMaster
										where  serialNo = :luo_ipcomm.p_ontSerialNumber
										and    acctNo   = :as_acctno
										and    dateRemoved is null
										and    divisionCode = :gs_divisionCode 
										and    companyCode  = :gs_companyCode
										using  SQLCA;
											
										open cur_spc;
										
										fetch cur_spc into  :ls_packageCode, :ls_entitlefrom, :ls_entitleto;
									
										ls_packageCodes = ls_emptyPackageCodes
										ls_entFrom = ls_emptyentfrom
										ls_entTo = ls_emptyentto	
										
										Do While SQLCA.SQLCode = 0
											
											ls_packageCodes[upperBound(ls_packageCodes) + 1] = ls_packageCode
											ls_entFrom[upperBound(ls_entFrom) + 1] = ls_entitlefrom
											ls_entTo[upperBound(ls_entTo) + 1] = ls_entitleto	
											
											fetch cur_spc into :ls_packageCode, :ls_entitlefrom, :ls_entitleto;
										loop
										
										close cur_spc;
										
										li_recs = upperBound(ls_packageCodes)
										for li_loop = 1 to li_recs
											
											ls_packageCode   = ls_packageCodes[li_loop]
											ls_entitlefrom =  ls_entFrom[li_loop]
											ls_entitleTo =  ls_entTo[li_loop]
											
											select productID into :ls_productID 
											from   arPackageMaster 
											where  packageCode = :ls_packageCode 
											and    divisionCode = :gs_divisionCode
											and    companyCode = :gs_companyCode
											using  SQLCA;
											
											
												ls_json = '{' +&
															'"itemCode": "TEST-CAS2",' +&
															'"stbSerialNo": "' + luo_ipcomm.p_ontSerialNumber +'",' +&
															'"acctNo": "' +luo_ipcomm.p_acctno+'",' +&
															'"subscriberName": "'+luo_ipcomm.p_subscribername+'",' +&
															'"productIDs": ["'+ls_productID+'"],'+&
															'"entitlementFrom": "'+ ls_entitlefrom+'",' +&
															'"entitlementTo": "' +ls_entitleTo+'",' +&
															'"title": "",' +&
															'"message": ""' +&
															'}'
										
										
											insert into DYNAMIC_PROV_REQUEST
											(tranno , trantypecode , itemcode , brand , acctno , subscribername , nodeno , ontserialno , macaddress , devicemodel , productid , apiresponse, PROCESSED, jsonparam, username)
											values
											(:ll_tranno , :as_trantype, :luo_ipcomm.p_itemcode , :luo_ipcomm.p_brand , :luo_ipcomm.p_acctno , :luo_ipcomm.p_subscribername , :luo_ipcomm.p_nodeno , :luo_ipcomm.p_ontSerialNumber , :luo_ipcomm.p_macaddress , :luo_ipcomm.p_devicemodel , :luo_ipcomm.p_productid , :ls_response, 'N', :ls_json, :gs_username)
											using SQLCA;
											if SQLCA.SQLCode <> 0 then
													
												as_responsecode = STRING(ll_tranno)
												as_responsetext = SQLCA.sqlerrtext
											
											else
												
												as_responsecode = string(ll_tranno)
												as_responsetext = ls_response
												
												commit using SQLCA;
											
											end if 
										
										
										next 
										
										select  packagecode , to_char(sysdate,'YYYY-MM-DD') ||'T00:00:00' into  :ls_packagecode , :ls_entitlefrom
										from aracctsubscriber
										where acctno = :as_acctno
										and divisioncode = :Gs_divisioncode
										and companycode = :gs_companycode
										using SQLCA;
										
										select  productid into   :ls_productid
										from arpackagemaster
										where packagecode = :ls_packagecode
										and divisioncode = :gs_divisioncode
										and companycode = :gs_companycode
										using SQLCA;
										
										select to_char(itemValue,'YYYY-MM-DD') ||'T00:00:00' into :ls_entitleTo from sysParamDate where itemName = 'CASENTITLEEXPIRE' using SQLCA; 
										
											ls_json = '{' +&
														'"itemCode": "TEST-CAS2",' +&
														'"stbSerialNo": "' + luo_ipcomm.p_ontSerialNumber +'",' +&
														'"acctNo": "' +luo_ipcomm.p_acctno+'",' +&
														'"subscriberName": "'+luo_ipcomm.p_subscribername+'",' +&
														'"productIDs": ["'+ls_productid+'"],'+&
														'"entitlementFrom": "'+ ls_entitlefrom+'",' +&
														'"entitlementTo": "' +ls_entitleTo+'",' +&
														'"title": "",' +&
														'"message": ""' +&
														'}'
										
											insert into DYNAMIC_PROV_REQUEST
											(tranno , trantypecode , itemcode , brand , acctno , subscribername , nodeno , ontserialno , macaddress , devicemodel , productid , apiresponse, PROCESSED, jsonparam, username)
											values
											(:ll_tranno , :as_trantype, :luo_ipcomm.p_itemcode , :luo_ipcomm.p_brand , :luo_ipcomm.p_acctno , :luo_ipcomm.p_subscribername , :luo_ipcomm.p_nodeno , :luo_ipcomm.p_ontSerialNumber , :luo_ipcomm.p_macaddress , :luo_ipcomm.p_devicemodel , :luo_ipcomm.p_productid , :ls_response, 'N', :ls_json, :gs_username)
											using SQLCA;
											if SQLCA.SQLCode <> 0 then
													
												as_responsecode = STRING(ll_tranno)
												as_responsetext = SQLCA.sqlerrtext
											
											else
												
												as_responsecode = string(ll_tranno)
												as_responsetext = ls_response
												
												commit using SQLCA;
											
											end if 
										
									
								
							else
								
								select  packagecode , to_char(sysdate,'YYYY-MM-DD') ||'T00:00:00' into  :ls_packagecode , :ls_entitlefrom
								from aracctsubscriber
								where acctno = :as_acctno
								and divisioncode = :Gs_divisioncode
								and companycode = :gs_companycode
								using SQLCA;
								
								select  productid into   :ls_productid
								from arpackagemaster
								where packagecode = :ls_packagecode
								and divisioncode = :gs_divisioncode
								and companycode = :gs_companycode
								using SQLCA;
								
								
								if ls_source = 'JOBORDER' then
								
									select to_char(sysdate + 3,'YYYY-MM-DD') ||'T00:00:00' into :ls_entitleTo from dual using SQLCA;  
								
								else
									select to_char(itemValue,'YYYY-MM-DD') ||'T00:00:00' into :ls_entitleTo from sysParamDate where itemName = 'CASENTITLEEXPIRE' using SQLCA;  
								
								end if
								
								string ls_packagecode_digipick
								
								ls_json = '{' +&
								'"itemCode": "TEST-CAS2",' +&
								'"stbSerialNo": "' + luo_ipcomm.p_ontSerialNumber +'",' +&
								'"acctNo": "' +luo_ipcomm.p_acctno+'",' +&
								'"subscriberName": "'+luo_ipcomm.p_subscribername+'",' +&
								'"productIDs": ["'+ls_productid+'"],'+&
								'"entitlementFrom": "'+ ls_entitlefrom+'",' +&
								'"entitlementTo": "' +ls_entitleTo+'",' +&
								'"title": "",' +&
								'"message": ""' +&
								'}'
								
								if ls_source = 'ADDDIGIPICK' then
									
										ll_pos = LastPos(as_serialno,'-')
							
										if ll_pos > 0 then
										
											ls_serialno =mid(as_serialno,1,ll_pos - 1)
											ls_packagecode_digipick = mid(as_serialno,ll_pos + 1,len(as_serialno))
											
											select  productid into   :ls_productid
											from arpackagemaster
											where packagecode = :ls_packagecode_digipick
											and divisioncode = :gs_divisioncode
											and companycode = :gs_companycode
											using SQLCA;
											
												ls_json = '{' +&
												'"itemCode": "TEST-CAS2",' +&
												'"stbSerialNo": "' +ls_serialno +'",' +&
												'"acctNo": "' +luo_ipcomm.p_acctno+'",' +&
												'"subscriberName": "'+luo_ipcomm.p_subscribername+'",' +&
												'"productIDs": ["'+ls_productid+'"],'+&
												'"entitlementFrom": "'+ ls_entitlefrom+'",' +&
												'"entitlementTo": "' +ls_entitleTo+'",' +&
												'"title": "",' +&
												'"message": ""' +&
												'}'
										
										else
											
											as_serialno= as_serialno
											
										end if
								
								
								end if
								
								
							
								
								insert into DYNAMIC_PROV_REQUEST
											(tranno , trantypecode , itemcode , brand , acctno , subscribername , nodeno , ontserialno , macaddress , devicemodel , productid , apiresponse, PROCESSED, jsonparam, username)
											values
											(:ll_tranno , :as_trantype, :luo_ipcomm.p_itemcode , :luo_ipcomm.p_brand , :luo_ipcomm.p_acctno , :luo_ipcomm.p_subscribername , :luo_ipcomm.p_nodeno , :luo_ipcomm.p_ontSerialNumber , :luo_ipcomm.p_macaddress , :luo_ipcomm.p_devicemodel , :luo_ipcomm.p_productid , :ls_response, 'N', :ls_json, :gs_username)
											using SQLCA;
											if SQLCA.SQLCode <> 0 then
													
												as_responsecode = STRING(ll_tranno)
												as_responsetext = SQLCA.sqlerrtext
											
											else
												
												as_responsecode = string(ll_tranno)
												as_responsetext = ls_response
												
												commit using SQLCA;
											
											end if 
								
								end if
								
							
							elseif as_trantype= 'DEACTIVATECTV' then
								
								select  packagecode , to_char(sysdate,'YYYY-MM-DD') ||'T00:00:00' into  :ls_packagecode , :ls_entitlefrom
								from aracctsubscriber
								where acctno = :as_acctno
								and divisioncode = :Gs_divisioncode
								and companycode = :gs_companycode
								using SQLCA;
								
								select  productid into   :ls_productid
								from arpackagemaster
								where packagecode = :ls_packagecode
								and divisioncode = :gs_divisioncode
								and companycode = :gs_companycode
								using SQLCA;
								
								select to_char(itemValue,'YYYY-MM-DD') ||'T00:00:00' into :ls_entitleTo from sysParamDate where itemName = 'CASENTITLEEXPIRE' using SQLCA;  
								
								ls_json = '{' +&
								'"itemCode": "TEST-CAS2",' +&
								'"stbSerialNo": "' + luo_ipcomm.p_ontSerialNumber +'",' +&
								'"acctNo": "' +luo_ipcomm.p_acctno+'",' +&
								'"subscriberName": "'+luo_ipcomm.p_subscribername+'",' +&
								'"productIDs": ["'+ls_productid+'"],'+&
								'"entitlementFrom": "'+ ls_entitleTo+'",' +&
								'"entitlementTo": "' +ls_entitleTo+'",' +&
								'"title": "",' +&
								'"message": ""' +&
								'}'
								
								insert into DYNAMIC_PROV_REQUEST
											(tranno , trantypecode , itemcode , brand , acctno , subscribername , nodeno , ontserialno , macaddress , devicemodel , productid , apiresponse, PROCESSED, jsonparam, username)
											values
											(:ll_tranno , :as_trantype, :luo_ipcomm.p_itemcode , :luo_ipcomm.p_brand , :luo_ipcomm.p_acctno , :luo_ipcomm.p_subscribername , :luo_ipcomm.p_nodeno , :luo_ipcomm.p_ontSerialNumber , :luo_ipcomm.p_macaddress , :luo_ipcomm.p_devicemodel , :luo_ipcomm.p_productid , :ls_response, 'N', :ls_json, :gs_username)
											using SQLCA;
											if SQLCA.SQLCode <> 0 then
													
												as_responsecode = STRING(ll_tranno)
												as_responsetext = SQLCA.sqlerrtext
											
											else
												
												as_responsecode = string(ll_tranno)
												as_responsetext = ls_response
												
												commit using SQLCA;
											
											end if 
								
							
							elseif as_trantype= 'CHANGEPACKAGEINET' then
								
								ls_json= '{' +&
									'"ItemCode": "'+luo_ipcomm.p_itemcode+'",'+&
									'"brand": "'+luo_ipcomm.p_brand+'",'+&
									'"acctNo": "'+luo_ipcomm.p_acctno+'",'+&
									'"napCode": "'+luo_ipcomm.p_napcode+'",'+&
									'"ontSerialNumber": "'+luo_ipcomm.p_ontSerialNumber+'",'+&
									'"subscriberName": "'+luo_ipcomm.p_subscribername+'",'+&
									'"macAddress": "'+luo_ipcomm.p_macaddress+'",'+&
									'"productID": "'+luo_ipcomm.p_productid+'"'+&
									'}'
								
									//ls_response = proxy_obj.changepackageinet(ls_json)
							
										insert into DYNAMIC_PROV_REQUEST
										(tranno , trantypecode , itemcode , brand , acctno , subscribername , nodeno , ontserialno , macaddress , devicemodel , productid , apiresponse, processed , jsonparam, username)
										values
										(:ll_tranno , :as_trantype, :luo_ipcomm.p_itemcode , :luo_ipcomm.p_brand , :luo_ipcomm.p_acctno , :luo_ipcomm.p_subscribername , :luo_ipcomm.p_nodeno , :luo_ipcomm.p_ontSerialNumber , :luo_ipcomm.p_macaddress , :luo_ipcomm.p_devicemodel , :luo_ipcomm.p_productid , :ls_response , 'N', :ls_json, :gs_username)
										using SQLCA;
										if SQLCA.SQLCode <> 0 then
										
									as_responsecode = string(SQLCA.SQLCode)
									as_responsetext = SQLCA.sqlerrtext
								
								else
									
									as_responsecode = string(SQLCA.SQLCode)
									as_responsetext = ls_response
									
									commit using SQLCA;
								
								end if 
								
								
							
							end if 
							
							
							
							
							
							return true
						
						--END FUNCTION
					end if
				next 
			end if
        
        --END EVENT
        
        
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

	--QUERY LIST DW_SIRCUIT ID
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
  
  --QUERY dw_circuit_dtl
   SELECT  circuitDetails.circuitID,
     		circuitDetails.equipment,
			circuitDetails.brand,
      	circuitDetails.model,
     		circuitDetails.interface,
			circuitDetails.ipAddress,
         circuitDetails.description
FROM circuitDetails      
WHERE ( circuitDetails.circuitID = :as_circuit )

	--QUERY dw_party
 SELECT  otherPartyCircuitDtl.refcircuitID,
     		otherPartyCircuitDtl.equipment,
			otherPartyCircuitDtl.brand,
      	otherPartyCircuitDtl.model,
     		otherPartyCircuitDtl.interface,
			otherPartyCircuitDtl.ipAddress,
         otherPartyCircuitDtl.description
FROM otherPartyCircuitDtl      
WHERE ( otherPartyCircuitDtl.circuitID = :as_circuit )

--BUTTON LOAD CIRCUID ID

integer li_ctr, li_row1
string ls_imagePath, ls_circuitID

li_row1 = dw_circuit.retrieve(is_acctno)

if li_row1 > 0 then
	ls_circuitID = dw_circuit.getItemString(1, 'circuitid')
	lb_circuit.reset()
	declare cur_circuit cursor for
		select imagepath
		from circuitBuilderImageMaster
		where circuitID = :ls_circuitid
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;	
	open cur_circuit;
	fetch cur_circuit into :ls_imagepath;
	do while SQLCA.sqlcode = 0
		li_ctr++
		lb_circuit.insertitem( ls_imagepath, li_ctr)
		fetch cur_circuit into :ls_imagepath;
	loop
	close cur_circuit;
	if lb_circuit.TotalItems ( ) > 0 then
		lb_circuit.selectItem(1)
		ole_circuit.insertFile(lb_circuit.text(1))
	else
		ole_circuit.clear()
	end if
else
	ole_circuit.clear()
	lb_circuit.reset()
	dw_circuit_dtl.reset()
	dw_party.reset()
	st_description.text = ''
end if	

--BUTTON PB_ACTIVE 

string ls_acctNo

ls_acctNo = idw_info.getItemString(idw_info.getRow(), 'acctno')

uo_subscriber_def luo_subscriber
luo_subscriber = create uo_subscriber_def

luo_subscriber.setAcctNo(trim(ls_acctNo))
if luo_subscriber.subscriberStatusCode = 'ADS' then
	if luo_subscriber.activateADSIfQualified('ACTIVATEADS') then
		commit using SQLCA;
		guo_func.msgbox('Notice', 'This account has now been activated from its ADS status! ' + &
											'assigned set top box(s) for this account are now being reactivated. Thank you!')
	else
		rollback using SQLCA;			
		guo_func.msgbox('Warning...', 'There was a problem while trying to check the credit standing of the subscriber.' + '~r~n' + &
												luo_subscriber.lastSQLErrText)
	end if
end IF

--TAB PREPAID CARD LOAD

--QUERY FORM 
select h.tranDate, h.acctNo, i.itemName, d.price, d.discountAmt, d.newPrice 
from salesTranDtl d
	inner join itemMaster i on i.itemCode = d.itemCode
		and i.companyCode = d.companyCode
	inner join salesTranHdr h on h.tranNo = d.tranNo
		and h.divisionCode = d.divisionCode and h.companyCode = d.companyCode
where i.itemIsPrepaidCard = 'Y'
	and h.acctNo = :as_acctno 
   and d.divisionCode = :as_division 
   and d.companyCode = :as_company
	
--TAB ADS INFO
   
 --QUERY FORM
   
select a.tranNo,a.tranDate as ADSDATE ,
a.subscriptionDepositBalance,a.arrearBalance,
a.mLineCurrentMonthlyRate,a.mLineCurrentDailyRate,
a.mLineAmount,a.extCurrentMonthlyRate,
a.extCurrentDailyRate,a.extAmount,
a.daysConsumption,a.noOfExtension,
a.processed,a.divisionCode,a.companyCode
from adstranhdr a
inner join aracctsubscriber b on b.acctno = a.acctno
    and b.divisioncode = a.divisioncode
    and b.companycode = a.companycode
where a.acctno = :as_acctno
    and a.divisioncode = :as_division
    and a.companycode = :as_company
order by a.trandate asc


--TAB AMORTIZE AR

--QUERY FORM

  SELECT  amortizedArTranHdr.tranNo , 
  amortizedArTranHdr.tranDate ,
  amortizedArTranHdr.refTranNo ,
  amortizedArTranHdr.refTranTypeCode ,  
  amortizedArTranHdr.startOfBilling ,   
  amortizedArTranHdr.noOfMonths ,
  amortizedArTranHdr.arTypeCode ,  
  arTypeMaster.arTypeName , 
  amortizedArTranHdr.amount , 
  amortizedArTranHdr.status ,  
  amortizedArTranHdr.userAdd , 
  amortizedArTranHdr.remarks ,  
  amortizedARTranDtl.dateOfBilling ,  
  amortizedARTranDtl.amount , 
  amortizedARTranDtl.billed 
  FROM amortizedARTranDtl ,   
  amortizedArTranHdr , 
  arTypeMaster 
  WHERE ( amortizedARTranDtl.tranNo = amortizedArTranHdr.tranNo ) AND
  ( amortizedARTranDtl.divisionCode = amortizedArTranHdr.divisionCode ) and 
  ( amortizedARTranDtl.companyCode = amortizedArTranHdr.companyCode ) and 
  ( arTypeMaster.arTypeCode = amortizedArTranHdr.arTypeCode ) and   
  ( arTypeMaster.divisionCode = amortizedArTranHdr.divisionCode ) and  
  ( arTypeMaster.companyCode = amortizedArTranHdr.companyCode ) and 
  ( ( amortizedArTranHdr.acctNo = :as_acctNo ) And   
  ( amortizedArTranHdr.divisionCode = :as_divisionCode ) and  
  ( amortizedARTranDtl.companyCode = :as_companyCode ) )  

  
  --TAB PACKAGE HISTORY
  
     select c.acctNo, c.tranNo,c.tranDate, c.oldPackageCode, c.newPackageCode, c.mLineCurrentMonthlyRate, c.mLinePreviousMonthlyRate, c.stbSerialNo, '' as serialNo,
   n.packagename newpackagename, o.packagename oldpackagename, c.useradd
from changePackageTranHDr c
inner join arPackageMaster n on n.packageCode = c.newPackageCode
            and n.divisionCode = c.divisionCode
            and n.companyCode = c.companyCode
inner join arPackageMaster o on o.packageCode = c.oldpackagecode
            and o.divisionCode = c.divisionCode
            and o.companyCode = c.companyCode 
where ( c.acctNo = :as_acctNo )
	and ( c.divisionCode = :as_division )
	and ( c.companyCode = :as_company )

UNION

select rh.acctNo, rh.tranNo, rh.tranDate, rd.oldPackageCode, rd.packageCode, n.monthlyRate, 0 as mLinePreviousMonthlyRate, rd.newSerialNo, rd.oldSerialNo,
  n.packagename newpackagename, o.packagename oldpackagename, rh.useradd
from replaceSubsCPETranHdr rh
inner join replaceSubsCPETranDtl rd on rd.tranNo = rh.tranNo
            and rd.divisionCode = rh.divisionCode
            and rd.companyCode = rh.companyCode
inner join arPackageMaster n on n.packageCode = rd.packageCode
            and n.divisionCode = rh.divisionCode
            and n.companyCode = rh.companyCode
inner join arPackageMaster o on o.packageCode = rd.oldpackageCode
            and o.divisionCode = rh.divisionCode
            and o.companyCode = rh.companyCode
where ( rh.acctNo = :as_acctNo )
	and ( rh.divisionCode = :as_division )
	and ( rh.companyCode = :as_company )


--TAB ENROLLED DIGI PICK
	
select sp.serialNo,
       cpe.caSerialNo,
       sp.packageCode,
       p.packageName,
       p.monthlyRate,
		 sp.useradd
  from subsSTBSPChanMaster sp
       inner join subscriberCPEMaster cpe on cpe.acctNo = sp.acctNo
              and cpe.serialNo = sp.serialNo
              and cpe.itemCode = sp.itemCode
              and cpe.divisionCode = sp.divisionCode
              and cpe.companyCode = sp.companyCode
       inner join arPackageMaster p on p.packageCode = sp.packageCode
              and p.divisionCode = sp.divisionCode
              and p.companyCode = sp.companyCode
 where sp.acctNo       = :as_acctNo
   and sp.divisionCode = :as_divisionCode
   and sp.companyCode  = :as_companyCode
 and sp.trantypecode = 'ADDDIGIPICK'

--TAB AR AGING
 
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
WHERE s.divisionCode = :as_division AND s.companyCode = :as_company
      and a.acctNo = :as_acctno
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
	 
--TAB END ON HARD BUNDLE EQUIPMENT
	 
SELECT itemMaster.itemcode ,
       itemmaster.itemname ,
       serialNoMaster.controlno ,
       subscriberaddonmaster.serialno ,
       subscriberaddonmaster.macaddress ,
       itemMaster.price ,
       subscriberaddonmaster.dateadd ,
       subscriberaddonmaster.useradd 
  FROM itemmaster,
       subscriberaddonmaster,
       serialNoMaster
WHERE  itemMaster.itemCode = subscriberaddonmaster.itemCode and
       serialNoMaster.itemCode = subscriberaddonmaster.itemCode and
		 serialNoMaster.serialNo = subscriberaddonmaster.serialNo and 
    ( itemmaster.companyCode = subscriberaddonmaster.companyCode )
AND ( serialNoMaster.divisionCode = subscriberaddonmaster.divisionCode )
AND ( serialNoMaster.companyCode = subscriberaddonmaster.companyCode )
AND ( ( subscriberaddonmaster.acctno = :as_acctNo ) 
AND ( subscriberaddonmaster.divisionCode = :as_division )
AND ( subscriberaddonmaster.companyCode = :as_company )) 
AND (subscriberaddonmaster.USED = 'N' or subscriberaddonmaster.used is null)

--TAB JOB ORDER

select a.jono , a.jodate , b.trantypename , jj.jostatusname, l.linemanname from jotranhdr a 
inner join systransactionparam b on b.trantypecode = a.trantypecode and b.divisioncode = a.divisioncode
inner join jostatusmaster jj on jj.jostatuscode = a.jostatuscode
inner join linemanmaster l on l.linemancode = a.linemancode and l.companycode = a.companycode
where a.acctno = :as_acctno and a.divisioncode = :as_division and a.companycode = :as_company


--TAB VALUE ADDED SERVICE

select * from vw_vas
where acctno = :As_acctno and divisioncode = :as_division
and companycode = :as_company
	 
	