--QUERY FORM

  SELECT a.acctNo, a.subscriberName, v.completeAddress installationAddr, a.nodeNo, ''selected, ''allSelect,
	a.subscriberStatusCode, i.vlan
from arAcctSubscriber a
inner join vw_arAcctAddress v on a.acctNo = v.acctNo and v.addressTypeCode = 'SERVADR1'
	and a.divisionCode = v.divisionCode and a.companyCode = v.companyCode
inner join arPackageMaster p on a.packageCode = p.packageCode
	and a.divisionCode = p.divisionCode and a.companyCode = p.companyCode
inner join ipMaster i on a.acctNo = i.acctNo
	and a.divisionCode = i.divisionCode and a.companyCode = i.companyCode
where a.divisionCode = :as_division and a.companyCode = :as_company
	and a.nodeNo = :ai_node and (a.subscriberStatusCode = :as_status or :as_allStatus = 'Y')
	and p.packageTypeCode = 'CMD'

	
--BUTTON FILTER 
	
string ls_status, ls_allStatus
long ll_node


ll_node = long(em_node.text)
if ll_node <= 0 or isNull(ll_node) then
	guo_func.msgBox("ATTENTION","Node No. is required.")
	return -1
end if

if rb_act.checked = True then
	ls_status = 'ACT'
	ls_allStatus = 'N'
elseif rb_pds.checked = True then
	ls_status = 'PDS'
	ls_allStatus = 'N'
elseif rb_ads.checked = True then
	ls_status = 'ADS'
	ls_allStatus = 'N'
elseif rb_apl.checked = True then
	ls_status = 'APL'
	ls_allStatus = 'N'
elseif rb_dea.checked = True then
	ls_status = 'DEA'
	ls_allStatus = 'N'
elseif rb_etl.checked = True then
	ls_status = 'ETL'
	ls_allStatus = 'N'
elseif rb_all.checked = True then
	ls_status = 'N'
	ls_allStatus = 'Y'
end if

if dw_1.retrieve(ll_node, ls_status, ls_allStatus, gs_divisionCode, gs_companyCode) > 0 then
	pb_save.enabled = True
else
	pb_save.enabled = False
end if
rb_no.checked = TRUE

--BUTTON SAVE

string ls_acctNo, ls_macAddress, ls_ipAddress, ls_oldipAddress, ls_selected
int li_nodeNo, li_vLan, li_oldNodeNo, li_newVLan
long ll_ctr

dw_1.acceptText()

li_newVLan = integer(em_vlan.text)

if li_newVLan <= 0 or isNull(li_newVLan) then
	guo_func.msgBox("ATTENTION","New VLAN  is required.")
	return -1
end if

for ll_ctr = 1 to dw_1.rowCount()
	ls_selected = dw_1.getItemString(ll_ctr,'selected')
	
	if ls_selected = 'Y' then
		ls_acctNo = dw_1.getItemString(ll_ctr,'acctNo')
		li_nodeNo = dw_1.getItemNumber(ll_ctr,'nodeNo')
		
		if ( isnull(ls_acctNo) or ls_acctNo = "" ) or ( isnull(li_nodeNo) or li_nodeNo = 0 ) then
			guo_func.msgBox("ATTENTION","Account and Node No. are required.")
			return -1
		end if
		
		if not iuo_subscriber.setAcctNo(ls_acctNo) then
			guo_func.msgbox('SM-0000001', iuo_subscriber.lastSQLCode + "~r~n" + iuo_subscriber.lastSQLErrText, &
													'Method: iuo_subscriber.setAcctNo()')
			return -1
		end IF
		
		--VALIDASI iuo_subscriber.setAcctNo		
		

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
	
		
		return TRUE

		--END VALIDASI
		
		select macAddress, vlan, ipAddress
		into :ls_macAddress, :li_vLan, :ls_oldipAddress
		from ipMaster
		where acctNo = :ls_acctNo
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		and rownum < 2
		using SQLCA;
			
		select ipAddress
		into :ls_ipAddress
		from ipMaster
		where vlan = :li_newVLan
		and macAddress is null
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		and rownum < 2
		using SQLCA;
		if SQLCA.sqlcode <> 0 then
			rollback using SQLCA;
			guo_func.msgBox("ATTENTION",string(SQLCA.sqlcode) + '. ' + SQLCA.sqlerrtext)
			return -1
		end if
		
		
		
		update ipMaster
		set macAddress = null,
			 acctNo = null
		where macAddress = :ls_macAddress
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;
		
		update ipMaster
		set macAddress = :ls_macAddress,
			 acctNo = :ls_acctNo
		where vlan = :li_newVLan
		and ipAddress = :ls_ipAddress
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;
				
		insert into ipMasterHistory
			(	acctNo,
				ipAddress,
				vLAN,
				nodeNo,
				userAdd,
				dateAdd,
				divisionCode,
				companyCode
			)
		values
			(
				:ls_acctNo,
				:ls_oldipAddress,
				:li_vLan,
				:li_nodeNo,
				:gs_userCode,
				getDate(),
				:gs_divisionCode,
				:gs_companyCode
			)
		using SQLCA;
		if SQLCA.sqlcode <> 0 then
			guo_func.msgbox("SM-0000001",string(SQLCA.sqlcode) + "~r~n" + SQLCA.sqlerrtext)
			rollback using SQLCA;
			return -1
		end if
		
		if not iuo_subscriber.refreshCableModem() then
			rollback using SQLCA;
			guo_func.msgbox('Warning!', iuo_subscriber.lastSQLCode + '~r~n~r~n' + iuo_subscriber.lastSQLErrText)
			return -1
		end IF
		
		--VALIDASI iuo_subscriber.refreshCableModem()
		
		string ls_package
			if isnull(subsUserName) then subsUserName = ''
			if isnull(password) then password = ''
			
			if uf_isAllowedInMpthrill(packageTypeCode) or uf_isAllowedInCMLRadius(packageTypeCode) THEN
				
				--VALIDASI uf_isAllowedInMpthrill
			
					string ls_validPackageTypeCode[]

					if not uf_getAllowedPackageTypeCode('MPTHRILL', ls_validPackageTypeCode) then
						return FALSE
					end if
					
					--VALIDASI uf_getAllowedPackageTypeCode
					
					declare cur_packageType cursor for
							select packageTypeCode
							  from sysAllowedPackageTypes
							 where tranTypeCode = :as_tranTypeCode
							 and divisionCode = :gs_divisionCode
							and companyCode = :gs_companyCode
						using SQLCA;
						if SQLCA.sqlcode <> 0 then
							message.stringparm = string(SQLCA.sqlcode)+"(1)" + '~r~n~r~n' + SQLCA.sqlerrtext
							close cur_packageType;	
							return FALSE
						end if
						
						
							 
						open cur_packageType;
						if SQLCA.sqlcode <> 0 then
							message.stringparm = string(SQLCA.sqlcode)+"(1)" + '~r~n~r~n' + SQLCA.sqlerrtext
							close cur_packageType;	
							return FALSE
						end if
						
						fetch cur_packageType into :as_packageTypeCode[upperbound(as_packageTypeCode) + 1];
						if SQLCA.sqlcode <> 0 then
							message.stringparm = string(SQLCA.sqlcode)+"(2)"  + '~r~n~r~n' + SQLCA.sqlerrtext
							close cur_packageType;	
							return FALSE
						end if
						
						do while SQLCA.sqlcode = 0
							fetch cur_packageType into :as_packageTypeCode[upperbound(as_packageTypeCode) + 1];
						loop
						
						close cur_packageType;
						
						return TRUE
						
					--END VALIDASI uf_getAllowedPackageTypeCode
					
					int li_element
					for li_element = 1 to upperbound(ls_validPackageTypeCode)
						if trim(as_packageTypeCode) = trim(ls_validPackageTypeCode[li_element]) then
							return TRUE
						end if
					next
					
					return FALSE
					
				--END VALIDASI uf_isAllowedInMpthrill
			
				str_assignedcpe s_assignedModems[]
				
				if subscriberStatusCode <> 'APL'  then
					if not getAssignedModem(s_assignedModems) then
						return FALSE
					end if	
				elseif subscriberStatusCode = 'APL' then
					if not getAssignedModemFromJO(s_assignedModems) then
						return FALSE
					end IF
					
				end if
				
				--=============================================================
				--this will activate the most recently assign to the subscriber
				--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
								if ls_package = '' or isNull(ls_package) THEN
								
									if not uf_insertIntoMPThrilRequestMaster(acctNo, subsUserName, password, 'REFRESH', '', 'DEACTIVATE', &
												s_assignedModems[1].serialNo, s_assignedModems[1].macAddress, lastSQLErrText) then
										return FALSE
									end IF
									
									--VALIDASI  uf_insertIntoMPThrilRequestMaster
										
									long ll_reqno, ll_year, ll_month
									string ls_reqno, ls_year, ls_month ,ls_clientclassvalue, ls_subscribername, ls_subscriberstatuscode, ls_telno, ls_workphoneno
									string ls_companyid, ls_divisionid , ls_packagecode, ls_model, ls_address_line1, ls_address_line2, ls_municipalityname, ls_zipcode, ls_provincename, ls_itemcode , ls_approachtype
									int li_year, li_month, li_nodeno
									
									string ls_isaurora, ls_isfiberhome , ls_servicecode
									string ls_appr_type2		
											
									 select companyid, divisionprefix , servicecode
									 into :ls_companyid, :ls_divisionid, :ls_servicecode
									 from systemparameter
									 where divisioncode = :gs_divisioncode
									 using SQLCA;
									
									select b.appr_type into :ls_appr_type2
									FROM SERIALNOMASTER a
									inner join itemmaster  b on b.itemcode = a.itemcode
									and b.companycode = a.companycode
									where a.serialno = :as_serialno
									and a.divisioncode = :gs_divisioncode
									using SQLCA;
									
									if ls_appr_type2 <> 'DOCSIS' then
										return TRUE;
									end if									 									 
									
									ls_divisionid = right(ls_divisionid,2)
 

									insert into mpthrilRequestMaster (
													acctno, 
													subsUserName, 
													password, 
													status, 
													refTranTypeCode,
													refTranNo,
													insertType,
													serialNo,
													macAddress,
													ipAddress,
													errorMsg,
													dateadd,
													divisionCode,
													companyCode)
										  values (
													:as_acctNo, 
													:as_subsUserName, 
													:as_password, 
													'PENDING', 
													:as_refTranTypeCode,
													:as_refTranNo,
													:as_insertType,
													:as_serialNo,
													:as_macAddress,
													null,
													:as_errormsg,
													getdate(),
													:gs_divisionCode,
													:gs_companyCode)
											using SQLCA;
									if SQLCA.SQLCode <> 0 then
										if isnull(as_errormsg) then as_errormsg = ''
										as_errormsg = as_errormsg + '~r~n~r~n' + 'CIB Warning: ' + string(SQLCA.sqlcode) + '~r~n' + SQLCA.sqlerrtext
										return FALSE
									end if

									-------------------BANONG---------------------//
									string ls_convertedmacaddress
									
									 if isnull(as_macaddress) then return FALSE
									 
									 ls_convertedmacaddress = as_macaddress

									SELECT SUBSTR(cpe.MACADDRESS,1,2) ||':' || SUBSTR
									(cpe.MACADDRESS,3,2) ||':' || SUBSTR(cpe.MACADDRESS,5,2) || ':' || SUBSTR(cpe.MACADDRESS,7,2) ||':' ||SUBSTR
									(cpe.MACADDRESS,9,2) ||':' || SUBSTR(cpe.MACADDRESS,11,2) MAC_ADDRESS
									into :ls_convertedmacaddress
									FROM serialnomaster CPE
									WHERE MACADDRESS = :as_macaddress
									//and acctno = :as_acctno
									and divisioncode = :gs_divisioncode
									and companycode = :gs_companycode
									and rownum = 1
									using SQLCA;
									
									
									if gs_divisioncode = 'DAGNT' then
										gs_divisioncode = 'DAGNT'
									end if 


									--check muna kung allowed sa bcc, para hindi siya lagi nag coconnect
									if f_ifallowedinbccserver(as_acctno) then	
										uo_ipcomm_mon luo_ipcomm								
										
										if not	luo_ipcomm.getsubscribername(as_acctno,ls_subscribername, ls_subscriberstatuscode) then
											as_errormsg = as_errormsg + '~r~n~r~n' + 'Warning: ' + string(SQLCA.sqlcode) + '~r~n' + SQLCA.sqlerrtext
											return FALSE
										end IF
										
										--validasi luo_ipcomm.getsubscribername
										string ls_packagecode,ls_ubrType
											int li_nodeNo
											
											select translate(subscribername, '[0-9]#$&:&!_()/@\"','[0-9]') , subscriberstatuscode
											into :as_subscribername, :as_subscriberstatuscode
											from arAcctSubscriber
											where acctNo = :as_acctNo 
											and companyCode = :gs_companyCode
											and divisionCode = :gs_divisionCode
											using SQLCA;
											if SQLCA.sqlcode < 0 then
												lastSQLCode = string(SQLCA.sqlcode)
												lastSQLErrText = SQLCA.sqlerrtext
												return FALSE
											elseif SQLCA.sqlcode = 100 then
												lastSQLCode = string(SQLCA.sqlcode) 
												lastSQLErrText = "Cannot get subscribername from table [ARACCTSUBSCRIBER] "
												return FALSE
											end if
											
											
											return TRUE
										
										--end validasi luo_ipcomm.getsubscribername
										
										if not	luo_ipcomm.getpackagecode(as_acctno,ls_packagecode) then
											as_errormsg = as_errormsg + '~r~n~r~n' + 'Warning: ' + string(SQLCA.sqlcode) + '~r~n' + SQLCA.sqlerrtext
											return FALSE
										end IF
										
										--validasi luo_ipcomm.getpackagecode
										
										select packageCode 
											into :as_packageCode
											from arAcctSubscriber
											where acctNo = :as_acctno
											and companycode = :gs_companycode
											and divisioncode = :gs_divisioncode
											using SQLCA;
											
											if SQLCA.sqlcode < 0 then
												lastSQLCode = string(SQLCA.sqlcode)
												lastSQLErrText = SQLCA.sqlerrtext
												return FALSE
											elseif SQLCA.sqlcode = 100 then
												lastSQLCode = string(SQLCA.sqlcode) 
												lastSQLErrText = "Cannot get packagecode "
												return TRUE
											end if
											
											return TRUE
											
										--end validasi luo_ipcomm.getpackagecode
										
										if not	luo_ipcomm.getclientclassnamenew(ls_packagecode,ls_clientclassvalue,as_acctno, ls_approachtype) then
											as_errormsg = as_errormsg + '~r~n~r~n' + 'Warning: ' + string(SQLCA.sqlcode) + '~r~n' + SQLCA.sqlerrtext
											return FALSE
										end if 
										
										--validasi getclientclassnamenew
										
										
											string ls_packagecode,ls_ubrType , ls_docsistype , LS_PACKAGETYPECODE , ls_approachtype , ls_reqnap, ls_reqnode , ls_packagedesc , ls_oltcode , ls_cocode
											int li_nodeNo
											string ls_itemcode
											string ls_nodebased
											 
											select packagecode,nodeNo 
											into :ls_packagecode,:li_nodeNo
											from arAcctSubscriber
											where acctNo = :as_acctNo 
											and companyCode = :gs_companyCode
											and divisionCode = :gs_divisionCode
											using SQLCA;
											
											if SQLCA.sqlcode < 0 then
												lastSQLCode = string(SQLCA.sqlcode)
												lastSQLErrText = SQLCA.sqlerrtext
												return FALSE
											elseif SQLCA.sqlcode = 100 then
												lastSQLCode = string(SQLCA.sqlcode) 
												lastSQLErrText = "Cannot get packagecode "
												return FALSE
											end if
											
											select ubrType , docsistype
											into :ls_ubrType, :ls_docsistype
											from nodesInIpCommander
											where nodeNo = :li_nodeNo
											and companyCode = :gs_companyCode
											and divisionCode = :gs_divisionCode
											using SQLCA;
											
											if SQLCA.sqlcode < 0 then
												lastSQLCode = string(SQLCA.sqlcode)
												lastSQLErrText = SQLCA.sqlerrtext
												return FALSE
											
											end if
											
											SELECT PACKAGETYPECODE, isnodereq, isnapreq , node_based INTO :LS_PACKAGETYPECODE , :ls_reqnode , :ls_reqnap , :ls_nodebased
											FROM ARPACKAGEMASTER
											WHERE PACKAGECOdE = :AS_PACKAGECODE
											and divisioncode = :gs_divisioncode
											and companycode = :gs_companycode
											using SQLCA;
											if SQLCA.sqlcode < 0 then
												lastSQLCode = string(SQLCA.sqlcode)
												lastSQLErrText = SQLCA.sqlerrtext
												return FALSE
											elseif SQLCA.sqlcode = 100 then
												lastSQLCode = string(SQLCA.sqlcode) 
												lastSQLErrText = "CANNOT GET PACKAGETYPECODE FOR THIS PACKAGE "
												return FALSE
											end if
											
											
											select a.itemcode into :ls_itemcode from serialnomaster a
											inner join itemmaster b on b.itemcode = a.itemcode and b.companycode = a.companycode
											where a.acctno = :as_acctno
											and a.divisioncode = :gs_divisioncode
											and a.companycode = :gs_companycode
											and (b.itemiscablemodem = 'Y')
											
											using SQLCA;
											
											
											string ls_devicemodel
											
											
											select appr_type into :as_approach from itemmaster
											where itemcode = :ls_itemcode
											and companyCOde = :gs_companycode
											using SQLCA;
											
											
											
											
											
												
												if as_approach = 'TR-069' and ls_packagetypecode = 'GEP' then
												
												select cocode , oltcode into :ls_cocode,  :ls_oltcode from aracctsubscriber
												where acctno = :as_acctno 
												and divisioncode = :gs_divisioncode 
												and companycode = :gs_companycode
												using SQLCA;
												
												select plan_name into :ls_packagedesc
												from arpackagemaster
												where packagecode = :as_packagecode
												and divisioncode = :gs_divisioncode
												and companycode = :gs_companycode
												using SQLCA;
												
												
												as_clientclassname = trim(ls_oltcode + '-' + ls_packagedesc)
												return true
												
												end if
												
												IF as_approach = 'DOCSIS' and ls_packagetypecode = 'GEP' then
													
												select clientclassvalue into :as_clientclassname
												from arpackagemaster
												where packagecode = :as_packagecode
												and divisioncode = :gs_divisioncode
												and companycode = :gs_companycode
												using SQLCA;
												
												return true
												
												end if
												
												IF as_approach = 'DOCSIS' then
											
												if ls_nodebased = 'Y' then
												
												select SUBSTR(clientclassvalue,3,20) into :as_clientclassname
												from arpackagemaster
												where packagecode = :as_packagecode
												and divisioncode = :gs_divisioncode
												and companycode = :gs_companycode
												using SQLCA;
												
												if SQLCA.sqlcode < 0 then
													lastSQLCode = string(SQLCA.sqlcode)
													lastSQLErrText = SQLCA.sqlerrtext
													return FALSE
												elseif SQLCA.sqlcode = 100 then
													lastSQLCode = string(SQLCA.sqlcode) 
													lastSQLErrText = "Cannot get ClientClassValue for this Package "
													return FALSE
												end if
												
												as_approach = 'DOCSIS'
												as_clientclassname =TRIM( ls_docsistype + as_clientclassname)
												return true
												
												else 
												
												select clientclassvalue into :as_clientclassname
												from arpackagemaster
												where packagecode = :as_packagecode
												and divisioncode = :gs_divisioncode
												and companycode = :gs_companycode
												using SQLCA;
												
												return true
													
												end if
											
											end if 
										--end validasi 
										
										select itemcode into :ls_itemcode
										from serialnomaster
										where serialno = :as_serialNo
										and divisioncode = :gs_divisioncode
										and companycode = :gs_companycode
										using SQLCA;
										
										
										
										select model  into :ls_model 
										from itemmaster
										where itemcode = :ls_itemcode
										and companycode = :gs_companycode
										using SQLCA;
										
										select substr(translate(telno, '[0-9]#$&&!_()/@\"ABCDEFGHIJKLMNOPQRSTUVWXYZ','[0-9]'),1,11), substr(translate(mobileno, '[0-9]#$&&!_()/@\"ABCDEFGHIJKLMNOPQRSTUVWXYZ','[0-9]'),1,11)
										into :ls_telno, :ls_workphoneno
										from aracctsubscriber
										where acctno = :as_acctno
										and divisioncode = :gs_divisioncode
										and companycode = :gs_companycode
										using SQLCA;
										
										select houseno ||' ' || blkno  || ' ' || lotno || ' ' || streetname, subdivisionname || ' ' || barangayname, municipalityname, provincename, zipcode
										into	:ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode
										from vw_aracctaddress
										where acctno = :as_acctno
										and addresstypecode = 'SERVADR1'
										and divisioncode = :gs_divisioncode
										and companycode = :gs_companycode
										using SQLCA;
										
										
										
										select month(getdate()), year(getdate())
										into :li_month, :li_year
										from systemparameter
										where divisioncode = :gs_divisioncode
										using SQLCA;
										
										ls_month = string(li_month,'00')
										ls_year = string(li_year,'0000')
	
										string ls_subkeylist[], ls_result
										integer li_rtn, li_rtnvalue
										li_rtn = RegistryKeys("HKEY_LOCAL_MACHINE\Software\ODBC\ODBC.INI\ODBC Data Sources", ls_subkeylist)
										
										string ls_valuearray[]
										li_rtn = RegistryValues("HKEY_LOCAL_MACHINE\Software\ODBC\ODBC.INI\BCCDSN", ls_valuearray)
										
										li_rtnvalue = RegistryGet("HKEY_LOCAL_MACHINE\Software\ODBC\ODBC.INI\ODBC Data Sources", 'iBAST4', RegString!, ls_result)
										
										if ls_result = 'Oracle in instantclient_11_2' then 
														  
											li_rtn = registrySet("HKEY_LOCAL_MACHINE\Software\ODBC\ODBC.INI\ODBC Data Sources", 'BCCDSN', RegString!, 'Oracle in instantclient_11_2')
											li_rtn = registrySet("HKEY_LOCAL_MACHINE\Software\ODBC\ODBC.INI\BCCDSN", 'Driver', RegString!, 'C:\oracle\instantclient_11_2\SQORA32.dll')
											li_rtn = registrySet("HKEY_LOCAL_MACHINE\Software\ODBC\ODBC.INI\BCCDSN", 'Database', RegString!, 'BCCDSN')
											li_rtn = registrySet("HKEY_LOCAL_MACHINE\Software\ODBC\ODBC.INI\BCCDSN", 'Server', RegString!, '192.168.99.16')
											li_rtn = registrySet("HKEY_LOCAL_MACHINE\Software\ODBC\ODBC.INI\BCCDSN", 'LastUser', RegString!, 'bcc_user')
											li_rtn = registrySet("HKEY_LOCAL_MACHINE\Software\ODBC\ODBC.INI\BCCDSN", 'Password', RegString!, 'bcc_user')
											li_rtn = registrySet("HKEY_LOCAL_MACHINE\Software\ODBC\ODBC.INI\BCCDSN", 'ServerName', RegString!, 'BCCDSN')
										
										elseif 	ls_result = 'Oracle in OraClient11g_home1' then
										
										li_rtn = registrySet("HKEY_LOCAL_MACHINE\Software\ODBC\ODBC.INI\ODBC Data Sources", 'BCCDSN', RegString!, 'Oracle in OraClient11g_home1')
										li_rtn = registrySet("HKEY_LOCAL_MACHINE\Software\ODBC\ODBC.INI\BCCDSN", 'Driver', RegString!, 'C:\app\||gs_loginworkstation||\product\11.2.0\client_1\SQORA32.dll')
										li_rtn = registrySet("HKEY_LOCAL_MACHINE\Software\ODBC\ODBC.INI\BCCDSN", 'Database', RegString!, 'BCCDSN')
										li_rtn = registrySet("HKEY_LOCAL_MACHINE\Software\ODBC\ODBC.INI\BCCDSN", 'Server', RegString!, '192.168.99.16')
										li_rtn = registrySet("HKEY_LOCAL_MACHINE\Software\ODBC\ODBC.INI\BCCDSN", 'LastUser', RegString!, 'bcc_user')
										li_rtn = registrySet("HKEY_LOCAL_MACHINE\Software\ODBC\ODBC.INI\BCCDSN", 'Password', RegString!, 'bcc_user')
										li_rtn = registrySet("HKEY_LOCAL_MACHINE\Software\ODBC\ODBC.INI\BCCDSN", 'ServerName', RegString!, 'BCCDSN')
										
										end if 

	
										BCCTRANS = create Transaction
										
										// Profile BCCDSN
										BCCTRANS.DBMS = "ODBC"
										BCCTRANS.AutoCommit = False
										BCCTRANS.DBParm = "ConnectString='DSN=BCCDSN;UID=bcc_user;PWD=bcc_user'"
										
										connect using BCCTRANS;

	
										if BCCTRANS.SQLCode <> 0 then
											as_errormsg = string(BCCTRANS.SQLCode) + BCCTRANS.SQLErrText
											disconnect using BCCTRANS;
											destroy BCCTRANS;
											return false
										end if	
											
										
										--001 - ADD SUB
										--002 - ADD MAC
										--003 - DEL MAC
										--004 - RES MAC


	
							if ls_approachtype = 'DOCSIS' then	
								
								
								if trim(as_reftrantypecode) = 'ADS' or trim(as_reftrantypecode) = 'APPLYPD' then
									
									if not guo_func.get_nextNumber('BCCREQUESTNO',ll_reqno,'WITH LOCK') then 
										return FALSE
									end IF
									
									-VALIDASI GET NEXT NUMBER
														
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
													
													return TRUE
													
												--END VALIDASI
									
									ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000')  
									
									// DEL MAC + DEL SUB
									insert into BCC_DOCSIS_REQUEST
									(request_no, request_date, mac_address, serial_no, client_class, remarks, ref_trantype_code, ref_tran_no, parent_request_no, request_type_code, node_no /*provinceName*/ , user_name_add, date_add, division_code, company_code, processed, error_code, error_msg, processed_date, bcc_server_code, acct_no, subscriber_name, description, 
									subscriber_status_code, new_acct_no, new_sub_name, NEW_ACCT_DESC,
									CONTACT_PERSON,PACKAGE_CODE,DEVICE_MODEL,LAST_NAME,BATCH_NO,
									HOME_PHONE,WORK_PHONE,ADDRESS_1,ADDRESS_2,CITY,STATE,ZIP_CODE,IP_ADDRESS)
									values
									(:ls_reqno, getdate(), :ls_convertedmacaddress, :as_serialno, :ls_clientclassvalue, :as_reftrantypecode || '-' || :as_inserttype,  :as_reftrantypecode, :as_reftranno ,null, '011' , :li_nodeno, :gs_username, getdate(), :gs_divisioncode, :gs_companycode, 'N', null, null, null, '0000003', 'IBAS-'||:ls_companyid || :ls_divisionid || :ls_servicecode|| :as_acctno,  :ls_subscribername, 'DELMAC+DELSUB' , 
									:ls_subscriberstatuscode, null, null, null, substr(:ls_subscribername, 0,40), :ls_packagecode, :ls_model, substr(:ls_subscribername, 0,40),
									'001', substr(:ls_telno,1,11), :ls_workphoneno, :ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode,:gs_ipaddress)
									using BCCTRANS;		
							
							
									if not guo_func.set_Number('BCCREQUESTNO',ll_reqno) then
										return FALSE
									end if	
									
									--VALIDASI SET NUMBER
														
											update sysTransactionParam
												set recordLocked = 'N',
													 lockedUserName = '',
													 lastTransactionNo = :al_tranno
											where recordLocked = 'Y' 
											       and divisionCode = :gs_divisionCode
													and companyCode = :gs_companyCode
													and tranTypeCode = :as_tranType
													using SQLCA;
											if SQLCA.sqlnrows < 1 then
												guo_func.msgbox("SM-0000010", as_tranType 	+ "~r~n" + &
																	string(SQLCA.sqlcode) 	+ "~r~n" + &
																	SQLCA.sqlerrtext, "")
												return false
											elseif SQLCA.sqlcode <> 0 then
												guo_func.msgbox("SM-0000001", "UPDATE - sysTransactionParam" + "~r~n" + &
																					  string(SQLCA.sqlcode) 	+ "~r~n" + &
																					  SQLCA.sqlerrtext, "Transaction Type: [" + as_tranType + "]")
												return FALSE
											end if
											
											commit using SQLCA;
											
											return TRUE
											
										--END VALIDASI
									
									commit using SQLCA;
									
								elseif trim(as_reftrantypecode) = 'ASSIGNEDCPE' then
										
									if not guo_func.get_nextNumber('BCCREQUESTNO',ll_reqno,'WITH LOCK') then 
										return FALSE
									end IF
									
									--VALIDASI GET NEXT NUMBER
														
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
													
													return TRUE
													
												--END VALIDASI
									
									IF TRIM(AS_INSERTTYPE) = 'DEACTIVATE' THEN
									
										ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000') 
									
										// DEL MAC + DEL SUB
										insert into BCC_DOCSIS_REQUEST
										(request_no, request_date, mac_address, serial_no, client_class, remarks, ref_trantype_code, ref_tran_no, parent_request_no, request_type_code, node_no /*provinceName*/ , user_name_add, date_add, division_code, company_code, processed, error_code, error_msg, processed_date, bcc_server_code, acct_no, subscriber_name, description, 
										subscriber_status_code, new_acct_no, new_sub_name, NEW_ACCT_DESC,
										CONTACT_PERSON,PACKAGE_CODE,DEVICE_MODEL,LAST_NAME,BATCH_NO,
										HOME_PHONE,WORK_PHONE,ADDRESS_1,ADDRESS_2,CITY,STATE,ZIP_CODE,IP_ADDRESS)
										values
										(:ls_reqno, getdate(), :ls_convertedmacaddress, :as_serialno, :ls_clientclassvalue, :as_reftrantypecode || '-' || :as_inserttype,  :as_reftrantypecode, :as_reftranno ,null, '011' , :li_nodeno, :gs_username, getdate(), :gs_divisioncode, :gs_companycode, 'N', null, null, null, '0000003', 'IBAS-'||:ls_companyid || :ls_divisionid || :ls_servicecode|| :as_acctno,  :ls_subscribername, 'DELMAC+DELSUB' , 
										:ls_subscriberstatuscode, null, null, null, substr(:ls_subscribername, 0,40), :ls_packagecode, :ls_model, substr(:ls_subscribername, 0,40),
										'001', :ls_telno, :ls_workphoneno, :ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode,:gs_ipaddress)
										using BCCTRANS;
										
										if not guo_func.set_Number('BCCREQUESTNO',ll_reqno) then
											return FALSE
										end if		
										
									END IF
									
									IF  TRIM(AS_INSERTTYPE) = 'ACTIVATE' THEN
										
										ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000') 
										
										insert into BCC_DOCSIS_REQUEST
										(request_no, request_date, mac_address, serial_no, client_class, remarks, ref_trantype_code, ref_tran_no, parent_request_no, request_type_code, node_no /*provinceName*/ , user_name_add, date_add, division_code, company_code, processed, error_code, error_msg, processed_date, bcc_server_code, acct_no, subscriber_name, description, 
										subscriber_status_code, new_acct_no, new_sub_name, NEW_ACCT_DESC,
										CONTACT_PERSON,PACKAGE_CODE,DEVICE_MODEL,LAST_NAME,BATCH_NO,
										HOME_PHONE,WORK_PHONE,ADDRESS_1,ADDRESS_2,CITY,STATE,ZIP_CODE,IP_ADDRESS)
										values
										(:ls_reqno, getdate(), :ls_convertedmacaddress, :as_serialno, :ls_clientclassvalue, :as_reftrantypecode || '-' || :as_inserttype,  :as_reftrantypecode, :as_reftranno ,null, '010' , :li_nodeno, :gs_username, getdate(), :gs_divisioncode, :gs_companycode, 'N', null, null, null, '0000003', 'IBAS-'||:ls_companyid || :ls_divisionid || :ls_servicecode|| :as_acctno,  :ls_subscribername, 'ADDSUB+ADDMACINV+ADDMAC' , 
										:ls_subscriberstatuscode, null, null, null, substr(:ls_subscribername, 0,40), :ls_packagecode, :ls_model, substr(:ls_subscribername, 0,40),
										'001', :ls_telno, :ls_workphoneno, :ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode,:gs_ipaddress)
										using BCCTRANS;
							
										if not guo_func.set_Number('BCCREQUESTNO',ll_reqno) then
											return FALSE
										end if	
										
										--VALIDASI SET NUMBER
														
											update sysTransactionParam
												set recordLocked = 'N',
													 lockedUserName = '',
													 lastTransactionNo = :al_tranno
											where recordLocked = 'Y' 
											       and divisionCode = :gs_divisionCode
													and companyCode = :gs_companyCode
													and tranTypeCode = :as_tranType
													using SQLCA;
											if SQLCA.sqlnrows < 1 then
												guo_func.msgbox("SM-0000010", as_tranType 	+ "~r~n" + &
																	string(SQLCA.sqlcode) 	+ "~r~n" + &
																	SQLCA.sqlerrtext, "")
												return false
											elseif SQLCA.sqlcode <> 0 then
												guo_func.msgbox("SM-0000001", "UPDATE - sysTransactionParam" + "~r~n" + &
																					  string(SQLCA.sqlcode) 	+ "~r~n" + &
																					  SQLCA.sqlerrtext, "Transaction Type: [" + as_tranType + "]")
												return FALSE
											end if
											
											commit using SQLCA;
											
											return TRUE
											
										--END VALIDASI
									END IF
								elseif  trim(as_reftrantypecode) = 'REACTIVATE' then
									
									if not guo_func.get_nextNumber('BCCREQUESTNO',ll_reqno,'WITH LOCK') then 
										return FALSE
									end if	
									
									--VALIDASI GET NEXT NUMBER
														
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
												
												return TRUE
												
											--END VALIDASI
									
										ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000') 
										
										ll_reqno  = ll_reqno + 1
										ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000') 
							
							
										--ADD SUB + ADD MAC INV + ADD MAC
										insert into BCC_DOCSIS_REQUEST
										(request_no, request_date, mac_address, serial_no, client_class, remarks, ref_trantype_code, ref_tran_no, parent_request_no, request_type_code, node_no /*provinceName*/ , user_name_add, date_add, division_code, company_code, processed, error_code, error_msg, processed_date, bcc_server_code, acct_no, subscriber_name, description, 
										subscriber_status_code, new_acct_no, new_sub_name, NEW_ACCT_DESC,
										CONTACT_PERSON,PACKAGE_CODE,DEVICE_MODEL,LAST_NAME,BATCH_NO,
										HOME_PHONE,WORK_PHONE,ADDRESS_1,ADDRESS_2,CITY,STATE,ZIP_CODE,IP_ADDRESS)
										values
										(:ls_reqno, getdate(), :ls_convertedmacaddress, :as_serialno, :ls_clientclassvalue, :as_reftrantypecode || '-' || :as_inserttype,  :as_reftrantypecode, :as_reftranno ,null, '010' , :li_nodeno, :gs_username, getdate(), :gs_divisioncode, :gs_companycode, 'N', null, null, null, '0000003', 'IBAS-'||:ls_companyid || :ls_divisionid || :ls_servicecode|| :as_acctno,  :ls_subscribername, 'ADDSUB+ADDMACINV+ADDMAC' , 
										:ls_subscriberstatuscode, null, null, null, substr(:ls_subscribername, 0,40), :ls_packagecode, :ls_model, substr(:ls_subscribername, 0,40),
										'001', :ls_telno, :ls_workphoneno, :ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode,:gs_ipaddress)
										using BCCTRANS;
									
										if not guo_func.set_Number('BCCREQUESTNO',ll_reqno) then
											return FALSE
										end if	
										
										--VALIDASI SET NUMBER
														
											update sysTransactionParam
												set recordLocked = 'N',
													 lockedUserName = '',
													 lastTransactionNo = :al_tranno
											where recordLocked = 'Y' 
											       and divisionCode = :gs_divisionCode
													and companyCode = :gs_companyCode
													and tranTypeCode = :as_tranType
													using SQLCA;
											if SQLCA.sqlnrows < 1 then
												guo_func.msgbox("SM-0000010", as_tranType 	+ "~r~n" + &
																	string(SQLCA.sqlcode) 	+ "~r~n" + &
																	SQLCA.sqlerrtext, "")
												return false
											elseif SQLCA.sqlcode <> 0 then
												guo_func.msgbox("SM-0000001", "UPDATE - sysTransactionParam" + "~r~n" + &
																					  string(SQLCA.sqlcode) 	+ "~r~n" + &
																					  SQLCA.sqlerrtext, "Transaction Type: [" + as_tranType + "]")
												return FALSE
											end if
											
											commit using SQLCA;
											
											return TRUE
											
										--END VALIDASI
							
								elseif trim(as_reftrantypecode) = 'REFRESH' then
									
									if ls_subscriberstatuscode = 'APL' or ls_subscriberstatuscode = 'ACT' then
										
										if not guo_func.get_nextNumber('BCCREQUESTNO',ll_reqno,'WITH LOCK') then 
											return FALSE
										end if	
										
										--VALIDASI GET NEXT NUMBER
														
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
													
													return TRUE
													
												--END VALIDASI
										
										ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000') 
							
										//DEL SUB + DEL MAC
										insert into BCC_DOCSIS_REQUEST
										(request_no, request_date, mac_address, serial_no, client_class, remarks, ref_trantype_code, ref_tran_no, parent_request_no, request_type_code, node_no /*provinceName*/ , user_name_add, date_add, division_code, company_code, processed, error_code, error_msg, processed_date, bcc_server_code, acct_no, subscriber_name, description, 
										subscriber_status_code, new_acct_no, new_sub_name, NEW_ACCT_DESC,
										CONTACT_PERSON,PACKAGE_CODE,DEVICE_MODEL,LAST_NAME,BATCH_NO,
										HOME_PHONE,WORK_PHONE,ADDRESS_1,ADDRESS_2,CITY,STATE,ZIP_CODE,IP_ADDRESS)
										values
										(:ls_reqno, getdate(), :ls_convertedmacaddress, :as_serialno, :ls_clientclassvalue, :as_reftrantypecode || '-' || :as_inserttype,  :as_reftrantypecode, :as_reftranno ,null, '011' , :li_nodeno, :gs_username, getdate(), :gs_divisioncode, :gs_companycode, 'N', null, null, null, '0000003', 'IBAS-'||:ls_companyid || :ls_divisionid || :ls_servicecode|| :as_acctno,  :ls_subscribername, 'DELMAC+DELSUB' , 
										:ls_subscriberstatuscode, null, null, null, substr(:ls_subscribername, 0,40), :ls_packagecode, :ls_model, substr(:ls_subscribername, 0,40),
										'001', :ls_telno, :ls_workphoneno, :ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode,:gs_ipaddress)
										using BCCTRANS;
										
										ll_reqno  = ll_reqno + 1
										ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000') 
										
							
										
										
										// ADD SUB + ADD MAC INV + ADD MAC
										insert into BCC_DOCSIS_REQUEST
										(request_no, request_date, mac_address, serial_no, client_class, remarks, ref_trantype_code, ref_tran_no, parent_request_no, request_type_code, node_no /*provinceName*/ , user_name_add, date_add, division_code, company_code, processed, error_code, error_msg, processed_date, bcc_server_code, acct_no, subscriber_name, description, 
										subscriber_status_code, new_acct_no, new_sub_name, NEW_ACCT_DESC,
										CONTACT_PERSON,PACKAGE_CODE,DEVICE_MODEL,LAST_NAME,BATCH_NO,
										HOME_PHONE,WORK_PHONE,ADDRESS_1,ADDRESS_2,CITY,STATE,ZIP_CODE,IP_ADDRESS)
										values
										(:ls_reqno, getdate(), :ls_convertedmacaddress, :as_serialno, :ls_clientclassvalue, :as_reftrantypecode || '-' || :as_inserttype,  :as_reftrantypecode, :as_reftranno ,null, '010' , :li_nodeno, :gs_username, getdate(), :gs_divisioncode, :gs_companycode, 'N', null, null, null, '0000003', 'IBAS-'||:ls_companyid || :ls_divisionid || :ls_servicecode|| :as_acctno,  :ls_subscribername, 'ADDSUB+ADDMACINV+ADDMAC' , 
										:ls_subscriberstatuscode, null, null, null, substr(:ls_subscribername, 0,40), :ls_packagecode, :ls_model, substr(:ls_subscribername, 0,40),
										'001', :ls_telno, :ls_workphoneno, :ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode,:gs_ipaddress)
										using BCCTRANS;
												
										if not guo_func.set_Number('BCCREQUESTNO',ll_reqno) then
											return FALSE
										end if	
										
										--VALIDASI SET NUMBER
														
											update sysTransactionParam
												set recordLocked = 'N',
													 lockedUserName = '',
													 lastTransactionNo = :al_tranno
											where recordLocked = 'Y' 
											       and divisionCode = :gs_divisionCode
													and companyCode = :gs_companyCode
													and tranTypeCode = :as_tranType
													using SQLCA;
											if SQLCA.sqlnrows < 1 then
												guo_func.msgbox("SM-0000010", as_tranType 	+ "~r~n" + &
																	string(SQLCA.sqlcode) 	+ "~r~n" + &
																	SQLCA.sqlerrtext, "")
												return false
											elseif SQLCA.sqlcode <> 0 then
												guo_func.msgbox("SM-0000001", "UPDATE - sysTransactionParam" + "~r~n" + &
																					  string(SQLCA.sqlcode) 	+ "~r~n" + &
																					  SQLCA.sqlerrtext, "Transaction Type: [" + as_tranType + "]")
												return FALSE
											end if
											
											commit using SQLCA;
											
											return TRUE
											
										--END VALIDASI
							
									else //if not APPLIED or ACTIVE ---> DEACTIVATE
										
										if not guo_func.get_nextNumber('BCCREQUESTNO',ll_reqno,'WITH LOCK') then 
											return FALSE
										end if	
										
										--VALIDASI GET NEXT NUMBER
														
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
													
													return TRUE
													
												--END VALIDASI
										
										ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000') 
							
										//DEL SUB + DEL MAC
							
										insert into BCC_DOCSIS_REQUEST
										(request_no, request_date, mac_address, serial_no, client_class, remarks, ref_trantype_code, ref_tran_no, parent_request_no, request_type_code, node_no /*provinceName*/ , user_name_add, date_add, division_code, company_code, processed, error_code, error_msg, processed_date, bcc_server_code, acct_no, subscriber_name, description, 
										subscriber_status_code, new_acct_no, new_sub_name, NEW_ACCT_DESC,
										CONTACT_PERSON,PACKAGE_CODE,DEVICE_MODEL,LAST_NAME,BATCH_NO,
										HOME_PHONE,WORK_PHONE,ADDRESS_1,ADDRESS_2,CITY,STATE,ZIP_CODE,IP_ADDRESS)
										values
										(:ls_reqno, getdate(), :ls_convertedmacaddress, :as_serialno, :ls_clientclassvalue, :as_reftrantypecode || '-' || :as_inserttype,  :as_reftrantypecode, :as_reftranno ,null, '011' , :li_nodeno, :gs_username, getdate(), :gs_divisioncode, :gs_companycode, 'N', null, null, null, '0000003', 'IBAS-'||:ls_companyid || :ls_divisionid || :ls_servicecode|| :as_acctno,  :ls_subscribername, 'DELMAC+DELSUB' , 
										:ls_subscriberstatuscode, null, null, null, substr(:ls_subscribername, 0,40), :ls_packagecode, :ls_model,substr(:ls_subscribername, 0,40),
										'001', :ls_telno, :ls_workphoneno, :ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode,:gs_ipaddress)
										using BCCTRANS;
										
										if not guo_func.set_Number('BCCREQUESTNO',ll_reqno) then
											return FALSE
										end if	
										
										--VALIDASI SET NUMBER
														
												update sysTransactionParam
													set recordLocked = 'N',
														 lockedUserName = '',
														 lastTransactionNo = :al_tranno
												where recordLocked = 'Y' 
												       and divisionCode = :gs_divisionCode
														and companyCode = :gs_companyCode
														and tranTypeCode = :as_tranType
														using SQLCA;
												if SQLCA.sqlnrows < 1 then
													guo_func.msgbox("SM-0000010", as_tranType 	+ "~r~n" + &
																		string(SQLCA.sqlcode) 	+ "~r~n" + &
																		SQLCA.sqlerrtext, "")
													return false
												elseif SQLCA.sqlcode <> 0 then
													guo_func.msgbox("SM-0000001", "UPDATE - sysTransactionParam" + "~r~n" + &
																						  string(SQLCA.sqlcode) 	+ "~r~n" + &
																						  SQLCA.sqlerrtext, "Transaction Type: [" + as_tranType + "]")
													return FALSE
												end if
												
												commit using SQLCA;
												
												return TRUE
												
											--END VALIDASI
									end if
								
								elseif  trim(as_reftrantypecode) = 'REACTIVATE' or trim(as_reftrantypecode) = 'ACTIVATEPDS' or trim(as_reftrantypecode) = 'ACTIVATEADS' then
									
										if not guo_func.get_nextNumber('BCCREQUESTNO',ll_reqno,'WITH LOCK') then 
											return FALSE
										end if	
										
										--VALIDASI GET NEXT NUMBER
														
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
													
													return TRUE
													
												--END VALIDASI
										
										ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000') 
										ll_reqno  = ll_reqno + 1
										ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000') 
							
										
										// ADD SUB + ADD MAC INV + ADD MAC
							
										insert into BCC_DOCSIS_REQUEST
										(request_no, request_date, mac_address, serial_no, client_class, remarks, ref_trantype_code, ref_tran_no, parent_request_no, request_type_code, node_no /*provinceName*/ , user_name_add, date_add, division_code, company_code, processed, error_code, error_msg, processed_date, bcc_server_code, acct_no, subscriber_name, description, 
										subscriber_status_code, new_acct_no, new_sub_name, NEW_ACCT_DESC,
										CONTACT_PERSON,PACKAGE_CODE,DEVICE_MODEL,LAST_NAME,BATCH_NO,
										HOME_PHONE,WORK_PHONE,ADDRESS_1,ADDRESS_2,CITY,STATE,ZIP_CODE,IP_ADDRESS)
										values
										(:ls_reqno, getdate(), :ls_convertedmacaddress, :as_serialno, :ls_clientclassvalue, :as_reftrantypecode || '-' || :as_inserttype,  :as_reftrantypecode, :as_reftranno ,null, '010' , :li_nodeno, :gs_username, getdate(), :gs_divisioncode, :gs_companycode, 'N', null, null, null, '0000003', 'IBAS-'||:ls_companyid || :ls_divisionid || :ls_servicecode|| :as_acctno,  :ls_subscribername, 'ADDSUB+ADDMACINV+ADDMAC' , 
										:ls_subscriberstatuscode, null, null, null, substr(:ls_subscribername, 0,40), :ls_packagecode, :ls_model, substr(:ls_subscribername, 0,40),
										'001', :ls_telno, :ls_workphoneno, :ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode,:gs_ipaddress)
										using BCCTRANS;
										
										if not guo_func.set_Number('BCCREQUESTNO',ll_reqno) then
											return FALSE
										end if	
										
										--VALIDASI SET NUMBER
														
												update sysTransactionParam
													set recordLocked = 'N',
														 lockedUserName = '',
														 lastTransactionNo = :al_tranno
												where recordLocked = 'Y' 
												       and divisionCode = :gs_divisionCode
														and companyCode = :gs_companyCode
														and tranTypeCode = :as_tranType
														using SQLCA;
												if SQLCA.sqlnrows < 1 then
													guo_func.msgbox("SM-0000010", as_tranType 	+ "~r~n" + &
																		string(SQLCA.sqlcode) 	+ "~r~n" + &
																		SQLCA.sqlerrtext, "")
													return false
												elseif SQLCA.sqlcode <> 0 then
													guo_func.msgbox("SM-0000001", "UPDATE - sysTransactionParam" + "~r~n" + &
																						  string(SQLCA.sqlcode) 	+ "~r~n" + &
																						  SQLCA.sqlerrtext, "Transaction Type: [" + as_tranType + "]")
													return FALSE
												end if
												
												commit using SQLCA;
												
												return TRUE
												
											--END VALIDASI
											
										
								elseif  trim(as_reftrantypecode) = 'CHANGEPACK'  then
										
										if not guo_func.get_nextNumber('BCCREQUESTNO',ll_reqno,'WITH LOCK') then 
											return FALSE
										end if	
										
										--VALIDASI GET NEXT NUMBER
														
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
													
													return TRUE
													
												--END VALIDASI
										
										ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000') 
										
										insert into BCC_DOCSIS_REQUEST
										(request_no, request_date, mac_address, serial_no, client_class, remarks, ref_trantype_code, ref_tran_no, parent_request_no, request_type_code, node_no /*provinceName*/ , user_name_add, date_add, division_code, company_code, processed, error_code, error_msg, processed_date, bcc_server_code, acct_no, subscriber_name, description, 
										subscriber_status_code, new_acct_no, new_sub_name, NEW_ACCT_DESC,
										CONTACT_PERSON,PACKAGE_CODE,DEVICE_MODEL,LAST_NAME,BATCH_NO,
										HOME_PHONE,WORK_PHONE,ADDRESS_1,ADDRESS_2,CITY,STATE,ZIP_CODE,IP_ADDRESS)
										values
										(:ls_reqno, getdate(), :ls_convertedmacaddress, :as_serialno, :ls_clientclassvalue, :as_reftrantypecode || '-' || :as_inserttype,  :as_reftrantypecode, :as_reftranno ,null, '012' , :li_nodeno, :gs_username, getdate(), :gs_divisioncode, :gs_companycode, 'N', null, null, null, '0000003', 'IBAS-'||:ls_companyid || :ls_divisionid || :ls_servicecode|| :as_acctno,  :ls_subscribername, 'ADDSUB+ADDMACINV+ADDMAC' , 
										:ls_subscriberstatuscode, null, null, null, substr(:ls_subscribername, 0,40), :ls_packagecode, :ls_model, substr(:ls_subscribername, 0,40),
										'001', :ls_telno, :ls_workphoneno, :ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode,:gs_ipaddress)
										using BCCTRANS;
										
										if not guo_func.set_Number('BCCREQUESTNO',ll_reqno) then
											return FALSE
										end IF
										
										--VALIDASI SET NUMBER
														
												update sysTransactionParam
													set recordLocked = 'N',
														 lockedUserName = '',
														 lastTransactionNo = :al_tranno
												where recordLocked = 'Y' 
												       and divisionCode = :gs_divisionCode
														and companyCode = :gs_companyCode
														and tranTypeCode = :as_tranType
														using SQLCA;
												if SQLCA.sqlnrows < 1 then
													guo_func.msgbox("SM-0000010", as_tranType 	+ "~r~n" + &
																		string(SQLCA.sqlcode) 	+ "~r~n" + &
																		SQLCA.sqlerrtext, "")
													return false
												elseif SQLCA.sqlcode <> 0 then
													guo_func.msgbox("SM-0000001", "UPDATE - sysTransactionParam" + "~r~n" + &
																						  string(SQLCA.sqlcode) 	+ "~r~n" + &
																						  SQLCA.sqlerrtext, "Transaction Type: [" + as_tranType + "]")
													return FALSE
												end if
												
												commit using SQLCA;
												
												return TRUE
												
											--END VALIDASI
									
										
									elseif trim(as_reftrantypecode) = 'REPLACECM' then
											
											if not guo_func.get_nextNumber('BCCREQUESTNO',ll_reqno,'WITH LOCK') then 
												return FALSE
											end if	
											
											--VALIDASI GET NEXT NUMBER
														
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
													
													return TRUE
													
												--END VALIDASI
										
											ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000') 
											
											if trim(as_inserttype) = 'DEACTIVATE' then
							
												insert into BCC_DOCSIS_REQUEST
												(request_no, request_date, mac_address, serial_no, client_class, remarks, ref_trantype_code, ref_tran_no, parent_request_no, request_type_code, node_no /*provinceName*/ , user_name_add, date_add, division_code, company_code, processed, error_code, error_msg, processed_date, bcc_server_code, acct_no, subscriber_name, description, 
												subscriber_status_code, new_acct_no, new_sub_name, NEW_ACCT_DESC,
												CONTACT_PERSON,PACKAGE_CODE,DEVICE_MODEL,LAST_NAME,BATCH_NO,
												HOME_PHONE,WORK_PHONE,ADDRESS_1,ADDRESS_2,CITY,STATE,ZIP_CODE,IP_ADDRESS)
												values
												(:ls_reqno, getdate(), :ls_convertedmacaddress, :as_serialno, :ls_clientclassvalue, :as_reftrantypecode || '-' || :as_inserttype,  :as_reftrantypecode, :as_reftranno ,null, '011' , :li_nodeno, :gs_username, getdate(), :gs_divisioncode, :gs_companycode, 'N', null, null, null, '0000003', 'IBAS-'||:ls_companyid || :ls_divisionid || :ls_servicecode|| :as_acctno,  :ls_subscribername, 'DELMAC+DELSUB' , 
												:ls_subscriberstatuscode, null, null, null, substr(:ls_subscribername, 0,40), :ls_packagecode, :ls_model,substr(:ls_subscribername, 0,40),
												'001', :ls_telno, :ls_workphoneno, :ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode,:gs_ipaddress)
												using BCCTRANS;
												
												if not guo_func.set_Number('BCCREQUESTNO',ll_reqno) then
													return FALSE
												end if 
												
												--VALIDASI SET NUMBER
														
												update sysTransactionParam
													set recordLocked = 'N',
														 lockedUserName = '',
														 lastTransactionNo = :al_tranno
												where recordLocked = 'Y' 
												       and divisionCode = :gs_divisionCode
														and companyCode = :gs_companyCode
														and tranTypeCode = :as_tranType
														using SQLCA;
												if SQLCA.sqlnrows < 1 then
													guo_func.msgbox("SM-0000010", as_tranType 	+ "~r~n" + &
																		string(SQLCA.sqlcode) 	+ "~r~n" + &
																		SQLCA.sqlerrtext, "")
													return false
												elseif SQLCA.sqlcode <> 0 then
													guo_func.msgbox("SM-0000001", "UPDATE - sysTransactionParam" + "~r~n" + &
																						  string(SQLCA.sqlcode) 	+ "~r~n" + &
																						  SQLCA.sqlerrtext, "Transaction Type: [" + as_tranType + "]")
													return FALSE
												end if
												
												commit using SQLCA;
												
												return TRUE
												
											--END VALIDASI
												
												
											elseif  trim(as_inserttype) = 'ACTIVATE' then
												
												insert into BCC_DOCSIS_REQUEST
												(request_no, request_date, mac_address, serial_no, client_class, remarks, ref_trantype_code, ref_tran_no, parent_request_no, request_type_code, node_no /*provinceName*/ , user_name_add, date_add, division_code, company_code, processed, error_code, error_msg, processed_date, bcc_server_code, acct_no, subscriber_name, description, 
												subscriber_status_code, new_acct_no, new_sub_name, NEW_ACCT_DESC,
												CONTACT_PERSON,PACKAGE_CODE,DEVICE_MODEL,LAST_NAME,BATCH_NO,
												HOME_PHONE,WORK_PHONE,ADDRESS_1,ADDRESS_2,CITY,STATE,ZIP_CODE,IP_ADDRESS)
												values
												(:ls_reqno, getdate(), :ls_convertedmacaddress, :as_serialno, :ls_clientclassvalue, :as_reftrantypecode || '-' || :as_inserttype,  :as_reftrantypecode, :as_reftranno ,null, '010' , :li_nodeno, :gs_username, getdate(), :gs_divisioncode, :gs_companycode, 'N', null, null, null, '0000003', 'IBAS-'||:ls_companyid || :ls_divisionid || :ls_servicecode|| :as_acctno,  :ls_subscribername, 'ADDSUB+ADDMACINV+ADDMAC' , 
												:ls_subscriberstatuscode, null, null, null, substr(:ls_subscribername, 0,40), :ls_packagecode, :ls_model, substr(:ls_subscribername, 0,40),
												'001', :ls_telno, :ls_workphoneno, :ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode,:gs_ipaddress)
												using BCCTRANS;
												
												if not guo_func.set_Number('BCCREQUESTNO',ll_reqno) then
													return FALSE
												end IF
												
												--VALIDASI SET NUMBER
														
												update sysTransactionParam
													set recordLocked = 'N',
														 lockedUserName = '',
														 lastTransactionNo = :al_tranno
												where recordLocked = 'Y' 
												       and divisionCode = :gs_divisionCode
														and companyCode = :gs_companyCode
														and tranTypeCode = :as_tranType
														using SQLCA;
												if SQLCA.sqlnrows < 1 then
													guo_func.msgbox("SM-0000010", as_tranType 	+ "~r~n" + &
																		string(SQLCA.sqlcode) 	+ "~r~n" + &
																		SQLCA.sqlerrtext, "")
													return false
												elseif SQLCA.sqlcode <> 0 then
													guo_func.msgbox("SM-0000001", "UPDATE - sysTransactionParam" + "~r~n" + &
																						  string(SQLCA.sqlcode) 	+ "~r~n" + &
																						  SQLCA.sqlerrtext, "Transaction Type: [" + as_tranType + "]")
													return FALSE
												end if
												
												commit using SQLCA;
												
												return TRUE
												
											--END VALIDASI
											
										
									end if 
									
									
								
								END IF
									if bcctrans.sqlcode <> 0 then									
									end if 
									commit using BCCTRANS;
									disconnect using BCCTRANS;
									destroy BCCTRANS;
							
							end if


								if ls_approachtype = 'TR-069' THEN
										
										
										if trim(as_reftrantypecode) = 'ADS' or trim(as_reftrantypecode) = 'APPLYPD' or trim(as_reftrantypecode) = 'APPLYDEAC' then
										
												if not guo_func.get_nextNumber('BCCREQUESTNO',ll_reqno,'WITH LOCK') then 
													return FALSE
												end if	
												
												--VALIDASI GET NEXT NUMBER
														
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
													
													return TRUE
													
												--END VALIDASI
												
												ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000') 
												
												insert into BCC_DOCSIS_REQUEST
												(request_no, request_date, mac_address, serial_no, client_class, remarks, ref_trantype_code, ref_tran_no, parent_request_no, request_type_code, node_no /*provinceName*/ , user_name_add, date_add, division_code, company_code, processed, error_code, error_msg, processed_date, bcc_server_code, acct_no, subscriber_name, description, 
												subscriber_status_code, new_acct_no, new_sub_name, NEW_ACCT_DESC,
												CONTACT_PERSON,PACKAGE_CODE,DEVICE_MODEL,LAST_NAME,BATCH_NO,
												HOME_PHONE,WORK_PHONE,ADDRESS_1,ADDRESS_2,CITY,STATE,ZIP_CODE,IP_ADDRESS)
												values
												(:ls_reqno, getdate(), :as_macaddress, :as_serialno, 'FH-Locked', :as_reftrantypecode || '-' || :as_inserttype,  :as_reftrantypecode, :as_reftranno ,null, '016' , :li_nodeno, :gs_username, getdate(), :gs_divisioncode, :gs_companycode, 'N', null, null, null, '0000003', 'IBAS-'||:ls_companyid || :ls_divisionid || :ls_servicecode|| :as_acctno,  :ls_subscribername, 'ADS-APPLYPD FH-LOCKED' , 
												:ls_subscriberstatuscode, null, null, null, substr(:ls_subscribername, 0,40), :ls_packagecode, :ls_model, substr(:ls_subscribername, 0,40),
												'001', :ls_telno, :ls_workphoneno, :ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode,:gs_ipaddress)
												using BCCTRANS;	
											
												ll_reqno  = ll_reqno + 1
												ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000')
												
												insert into BCC_DOCSIS_REQUEST
												(request_no, request_date, mac_address, serial_no, client_class, remarks, ref_trantype_code, ref_tran_no, parent_request_no, request_type_code, node_no /*provinceName*/ , user_name_add, date_add, division_code, company_code, processed, error_code, error_msg, processed_date, bcc_server_code, acct_no, subscriber_name, description, 
												subscriber_status_code, new_acct_no, new_sub_name, NEW_ACCT_DESC,
												CONTACT_PERSON,PACKAGE_CODE,DEVICE_MODEL,LAST_NAME,BATCH_NO,
												HOME_PHONE,WORK_PHONE,ADDRESS_1,ADDRESS_2,CITY,STATE,ZIP_CODE,IP_ADDRESS)
												values
												(:ls_reqno, getdate(), :as_macaddress, :as_serialno,'FH-Locked' , :as_reftrantypecode || '-' || :as_inserttype,  :as_reftrantypecode, :as_reftranno ,null, '015' , :li_nodeno, :gs_username, getdate(), :gs_divisioncode, :gs_companycode, 'P', null, null, null, '0000003', 'IBAS-'||:ls_companyid || :ls_divisionid || :ls_servicecode|| :as_acctno,  :ls_subscribername, 'ADS-APPLYPD FH-LOCKED' , 
												:ls_subscriberstatuscode, null, null, null, substr(:ls_subscribername, 0,40), :ls_packagecode, :ls_model, substr(:ls_subscribername, 0,40),
												'001', :ls_telno, :ls_workphoneno, :ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode,:gs_ipaddress)
												using BCCTRANS;	
												
												if not guo_func.set_Number('BCCREQUESTNO',ll_reqno) then
													return FALSE
												end if	
												
												--VALIDASI SET NUMBER
														
												update sysTransactionParam
													set recordLocked = 'N',
														 lockedUserName = '',
														 lastTransactionNo = :al_tranno
												where recordLocked = 'Y' 
												       and divisionCode = :gs_divisionCode
														and companyCode = :gs_companyCode
														and tranTypeCode = :as_tranType
														using SQLCA;
												if SQLCA.sqlnrows < 1 then
													guo_func.msgbox("SM-0000010", as_tranType 	+ "~r~n" + &
																		string(SQLCA.sqlcode) 	+ "~r~n" + &
																		SQLCA.sqlerrtext, "")
													return false
												elseif SQLCA.sqlcode <> 0 then
													guo_func.msgbox("SM-0000001", "UPDATE - sysTransactionParam" + "~r~n" + &
																						  string(SQLCA.sqlcode) 	+ "~r~n" + &
																						  SQLCA.sqlerrtext, "Transaction Type: [" + as_tranType + "]")
													return FALSE
												end if
												
												commit using SQLCA;
												
												return TRUE
												
												--END VALIDASI
										
										elseif trim(as_reftrantypecode) = 'ASSIGNEDCPE' then
											
												if not guo_func.get_nextNumber('BCCREQUESTNO',ll_reqno,'WITH LOCK') then 
													return FALSE
												end if	
												
												--VALIDASI GET NEXT NUMBER
														
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
													
													return TRUE
													
												--END VALIDASI
												
												ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000') 
												
												insert into BCC_DOCSIS_REQUEST
												(request_no, request_date, mac_address, serial_no, client_class, remarks, ref_trantype_code, ref_tran_no, parent_request_no, request_type_code, node_no /*provinceName*/ , user_name_add, date_add, division_code, company_code, processed, error_code, error_msg, processed_date, bcc_server_code, acct_no, subscriber_name, description, 
												subscriber_status_code, new_acct_no, new_sub_name, NEW_ACCT_DESC,
												CONTACT_PERSON,PACKAGE_CODE,DEVICE_MODEL,LAST_NAME,BATCH_NO,
												HOME_PHONE,WORK_PHONE,ADDRESS_1,ADDRESS_2,CITY,STATE,ZIP_CODE,IP_ADDRESS)
												values
												(:ls_reqno, getdate(), :as_macaddress, :as_serialno, :ls_clientclassvalue, :as_reftrantypecode || '-' || :as_inserttype,  :as_reftrantypecode, :as_reftranno ,null, '014' , :li_nodeno, :gs_username, getdate(), :gs_divisioncode, :gs_companycode, 'N', null, null, null, '0000003', 'IBAS-'||:ls_companyid || :ls_divisionid || :ls_servicecode|| :as_acctno,  :ls_subscribername, 'ASSIGNEDCPE 014' , 
												:ls_subscriberstatuscode, null, null, null, substr(:ls_subscribername, 0,40), :ls_packagecode, :ls_model, substr(:ls_subscribername, 0,40),
												'001', :ls_telno, :ls_workphoneno, :ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode,:gs_ipaddress)
												using BCCTRANS;	
												
												if not guo_func.set_Number('BCCREQUESTNO',ll_reqno) then
													return FALSE
												end IF
												
												--VALIDASI SET NUMBER
														
												update sysTransactionParam
													set recordLocked = 'N',
														 lockedUserName = '',
														 lastTransactionNo = :al_tranno
												where recordLocked = 'Y' 
												       and divisionCode = :gs_divisionCode
														and companyCode = :gs_companyCode
														and tranTypeCode = :as_tranType
														using SQLCA;
												if SQLCA.sqlnrows < 1 then
													guo_func.msgbox("SM-0000010", as_tranType 	+ "~r~n" + &
																		string(SQLCA.sqlcode) 	+ "~r~n" + &
																		SQLCA.sqlerrtext, "")
													return false
												elseif SQLCA.sqlcode <> 0 then
													guo_func.msgbox("SM-0000001", "UPDATE - sysTransactionParam" + "~r~n" + &
																						  string(SQLCA.sqlcode) 	+ "~r~n" + &
																						  SQLCA.sqlerrtext, "Transaction Type: [" + as_tranType + "]")
													return FALSE
												end if
												
												commit using SQLCA;
												
												return TRUE
												
												--END VALIDASI
												
										elseif  trim(as_reftrantypecode) = 'REACTIVATE' or trim(as_reftrantypecode) = 'ACTIVATEPDS' or trim(as_reftrantypecode) = 'ACTIVATEADS' then
											
												if not guo_func.get_nextNumber('BCCREQUESTNO',ll_reqno,'WITH LOCK') then 
													return FALSE
												end if	
												
												--VALIDASI GET NEXT NUMBER
														
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
													
													return TRUE
													
												--END VALIDASI
												
												ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000') 
												
												insert into BCC_DOCSIS_REQUEST
												(request_no, request_date, mac_address, serial_no, client_class, remarks, ref_trantype_code, ref_tran_no, parent_request_no, request_type_code, node_no /*provinceName*/ , user_name_add, date_add, division_code, company_code, processed, error_code, error_msg, processed_date, bcc_server_code, acct_no, subscriber_name, description, 
												subscriber_status_code, new_acct_no, new_sub_name, NEW_ACCT_DESC,
												CONTACT_PERSON,PACKAGE_CODE,DEVICE_MODEL,LAST_NAME,BATCH_NO,
												HOME_PHONE,WORK_PHONE,ADDRESS_1,ADDRESS_2,CITY,STATE,ZIP_CODE,IP_ADDRESS)
												values
												(:ls_reqno, getdate(), :as_macaddress, :as_serialno, :ls_clientclassvalue, :as_reftrantypecode || '-' || :as_inserttype,  :as_reftrantypecode, :as_reftranno ,null, '014' , :li_nodeno, :gs_username, getdate(), :gs_divisioncode, :gs_companycode, 'N', null, null, null, '0000003', 'IBAS-'||:ls_companyid || :ls_divisionid || :ls_servicecode|| :as_acctno,  :ls_subscribername, 'ASSIGNEDCPE 014' , 
												:ls_subscriberstatuscode, null, null, null, substr(:ls_subscribername, 0,40), :ls_packagecode, :ls_model, substr(:ls_subscribername, 0,40),
												'001', :ls_telno, :ls_workphoneno, :ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode,:gs_ipaddress)
												using BCCTRANS;					
								
												if not guo_func.set_Number('BCCREQUESTNO',ll_reqno) then
													return FALSE
												end if	
												
												--VALIDASI SET NUMBER
														
												update sysTransactionParam
													set recordLocked = 'N',
														 lockedUserName = '',
														 lastTransactionNo = :al_tranno
												where recordLocked = 'Y' 
												       and divisionCode = :gs_divisionCode
														and companyCode = :gs_companyCode
														and tranTypeCode = :as_tranType
														using SQLCA;
												if SQLCA.sqlnrows < 1 then
													guo_func.msgbox("SM-0000010", as_tranType 	+ "~r~n" + &
																		string(SQLCA.sqlcode) 	+ "~r~n" + &
																		SQLCA.sqlerrtext, "")
													return false
												elseif SQLCA.sqlcode <> 0 then
													guo_func.msgbox("SM-0000001", "UPDATE - sysTransactionParam" + "~r~n" + &
																						  string(SQLCA.sqlcode) 	+ "~r~n" + &
																						  SQLCA.sqlerrtext, "Transaction Type: [" + as_tranType + "]")
													return FALSE
												end if
												
												commit using SQLCA;
												
												return TRUE
													
												--END VALIDASI
												
										elseif  trim(as_reftrantypecode) = 'CHANGEPACK' or trim(as_reftrantypecode) = 'REPLACECM' then
											
												if not guo_func.get_nextNumber('BCCREQUESTNO',ll_reqno,'WITH LOCK') then 
													return FALSE
												end IF
												
												--VALIDASI GET NEXT NUMBER
														
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
													
													return TRUE
													
												--END VALIDASI
												
												ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000') 
												
															IF as_inserttype = 'DEACTIVATE' then
															
																ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000') 
															
																insert into BCC_DOCSIS_REQUEST
																(request_no, request_date, mac_address, serial_no, client_class, remarks, ref_trantype_code, ref_tran_no, parent_request_no, request_type_code, node_no /*provinceName*/ , user_name_add, date_add, division_code, company_code, processed, error_code, error_msg, processed_date, bcc_server_code, acct_no, subscriber_name, description, 
																subscriber_status_code, new_acct_no, new_sub_name, NEW_ACCT_DESC,
																CONTACT_PERSON,PACKAGE_CODE,DEVICE_MODEL,LAST_NAME,BATCH_NO,
																HOME_PHONE,WORK_PHONE,ADDRESS_1,ADDRESS_2,CITY,STATE,ZIP_CODE,IP_ADDRESS)
																values
																(:ls_reqno, getdate(), :as_macaddress, :as_serialno, :ls_clientclassvalue, :as_reftrantypecode || '-' || :as_inserttype,  :as_reftrantypecode, :as_reftranno ,null, '015' , :li_nodeno, :gs_username, getdate(), :gs_divisioncode, :gs_companycode, 'N', null, null, null, '0000003', 'IBAS-'||:ls_companyid || :ls_divisionid || :ls_servicecode|| :as_acctno,  :ls_subscribername, 'ADS-APPLYPD FH-LOCKED' , 
																:ls_subscriberstatuscode, null, null, null, substr(:ls_subscribername, 0,40), :ls_packagecode, :ls_model, substr(:ls_subscribername, 0,40),
																'001', :ls_telno, :ls_workphoneno, :ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode,:gs_ipaddress)
																using BCCTRANS;	
													
																if not guo_func.set_Number('BCCREQUESTNO',ll_reqno) then
																	return FALSE
																end if	
														
															end if					
												
															
															if  trim(as_inserttype) = 'ACTIVATE' then
																
																insert into BCC_DOCSIS_REQUEST
																(request_no, request_date, mac_address, serial_no, client_class, remarks, ref_trantype_code, ref_tran_no, parent_request_no, request_type_code, node_no /*provinceName*/ , user_name_add, date_add, division_code, company_code, processed, error_code, error_msg, processed_date, bcc_server_code, acct_no, subscriber_name, description, 
																subscriber_status_code, new_acct_no, new_sub_name, NEW_ACCT_DESC,
																CONTACT_PERSON,PACKAGE_CODE,DEVICE_MODEL,LAST_NAME,BATCH_NO,
																HOME_PHONE,WORK_PHONE,ADDRESS_1,ADDRESS_2,CITY,STATE,ZIP_CODE,IP_ADDRESS)
																values
																(:ls_reqno, getdate(), :as_macaddress, :as_serialno, :ls_clientclassvalue, :as_reftrantypecode || '-' || :as_inserttype,  :as_reftrantypecode, :as_reftranno ,null, '016' , :li_nodeno, :gs_username, getdate(), :gs_divisioncode, :gs_companycode, 'N', null, null, null, '0000003', 'IBAS-'||:ls_companyid || :ls_divisionid || :ls_servicecode|| :as_acctno,  :ls_subscribername, 'ASSIGNEDCPE 014' , 
																:ls_subscriberstatuscode, null, null, null, substr(:ls_subscribername, 0,40), :ls_packagecode, :ls_model, substr(:ls_subscribername, 0,40),
																'001', :ls_telno, :ls_workphoneno, :ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode,:gs_ipaddress)
																using BCCTRANS;	
																
																if not guo_func.set_Number('BCCREQUESTNO',ll_reqno) then
																	return FALSE
																end IF
																
																--VALIDASI SET NUMBER
														
																update sysTransactionParam
																	set recordLocked = 'N',
																		 lockedUserName = '',
																		 lastTransactionNo = :al_tranno
																where recordLocked = 'Y' 
																       and divisionCode = :gs_divisionCode
																		and companyCode = :gs_companyCode
																		and tranTypeCode = :as_tranType
																		using SQLCA;
																if SQLCA.sqlnrows < 1 then
																	guo_func.msgbox("SM-0000010", as_tranType 	+ "~r~n" + &
																						string(SQLCA.sqlcode) 	+ "~r~n" + &
																						SQLCA.sqlerrtext, "")
																	return false
																elseif SQLCA.sqlcode <> 0 then
																	guo_func.msgbox("SM-0000001", "UPDATE - sysTransactionParam" + "~r~n" + &
																										  string(SQLCA.sqlcode) 	+ "~r~n" + &
																										  SQLCA.sqlerrtext, "Transaction Type: [" + as_tranType + "]")
																	return FALSE
																end if
																
																commit using SQLCA;
																
																return TRUE
																	
																--END VALIDASI
															
															END IF
												
												
										elseif trim(as_reftrantypecode) = 'REFRESH' then			
										
													
													
														IF as_inserttype = 'DEACTIVATE' then
															
															if not guo_func.get_nextNumber('BCCREQUESTNO',ll_reqno,'WITH LOCK') then 
															return FALSE
															end if	
															
															--VALIDASI GET NEXT NUMBER
														
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
																
																return TRUE
																
															--END VALIDASI
													
															ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000') 
														
															insert into BCC_DOCSIS_REQUEST
															(request_no, request_date, mac_address, serial_no, client_class, remarks, ref_trantype_code, ref_tran_no, parent_request_no, request_type_code, node_no /*provinceName*/ , user_name_add, date_add, division_code, company_code, processed, error_code, error_msg, processed_date, bcc_server_code, acct_no, subscriber_name, description, 
															subscriber_status_code, new_acct_no, new_sub_name, NEW_ACCT_DESC,
															CONTACT_PERSON,PACKAGE_CODE,DEVICE_MODEL,LAST_NAME,BATCH_NO,
															HOME_PHONE,WORK_PHONE,ADDRESS_1,ADDRESS_2,CITY,STATE,ZIP_CODE,IP_ADDRESS)
															values
															(:ls_reqno, getdate(), :as_macaddress, :as_serialno, 'FH-Locked', :as_reftrantypecode || '-' || :as_inserttype,  :as_reftrantypecode, :as_reftranno ,null, '016' , :li_nodeno, :gs_username, getdate(), :gs_divisioncode, :gs_companycode, 'N', null, null, null, '0000003', 'IBAS-'||:ls_companyid || :ls_divisionid || :ls_servicecode|| :as_acctno,  :ls_subscribername, 'ADS-APPLYPD FH-LOCKED' , 
															:ls_subscriberstatuscode, null, null, null, substr(:ls_subscribername, 0,40), :ls_packagecode, :ls_model, substr(:ls_subscribername, 0,40),
															'001', :ls_telno, :ls_workphoneno, :ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode,:gs_ipaddress)
															using BCCTRANS;	
															
															ll_reqno  = ll_reqno + 1
															ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000')
															
															insert into BCC_DOCSIS_REQUEST
															(request_no, request_date, mac_address, serial_no, client_class, remarks, ref_trantype_code, ref_tran_no, parent_request_no, request_type_code, node_no /*provinceName*/ , user_name_add, date_add, division_code, company_code, processed, error_code, error_msg, processed_date, bcc_server_code, acct_no, subscriber_name, description, 
															subscriber_status_code, new_acct_no, new_sub_name, NEW_ACCT_DESC,
															CONTACT_PERSON,PACKAGE_CODE,DEVICE_MODEL,LAST_NAME,BATCH_NO,
															HOME_PHONE,WORK_PHONE,ADDRESS_1,ADDRESS_2,CITY,STATE,ZIP_CODE,IP_ADDRESS)
															values
															(:ls_reqno, getdate(), :as_macaddress, :as_serialno, :ls_clientclassvalue, :as_reftrantypecode || '-' || :as_inserttype,  :as_reftrantypecode, :as_reftranno ,null, '015' , :li_nodeno, :gs_username, getdate(), :gs_divisioncode, :gs_companycode, 'P', null, null, null, '0000003', 'IBAS-'||:ls_companyid || :ls_divisionid || :ls_servicecode|| :as_acctno,  :ls_subscribername, 'ADS-APPLYPD FH-LOCKED' , 
															:ls_subscriberstatuscode, null, null, null, substr(:ls_subscribername, 0,40), :ls_packagecode, :ls_model, substr(:ls_subscribername, 0,40),
															'001', :ls_telno, :ls_workphoneno, :ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode,:gs_ipaddress)
															using BCCTRANS;	
												
															if not guo_func.set_Number('BCCREQUESTNO',ll_reqno) then
																return FALSE
															end IF
															
															--VALIDASI SET NUMBER
														
																update sysTransactionParam
																	set recordLocked = 'N',
																		 lockedUserName = '',
																		 lastTransactionNo = :al_tranno
																where recordLocked = 'Y' 
																       and divisionCode = :gs_divisionCode
																		and companyCode = :gs_companyCode
																		and tranTypeCode = :as_tranType
																		using SQLCA;
																if SQLCA.sqlnrows < 1 then
																	guo_func.msgbox("SM-0000010", as_tranType 	+ "~r~n" + &
																						string(SQLCA.sqlcode) 	+ "~r~n" + &
																						SQLCA.sqlerrtext, "")
																	return false
																elseif SQLCA.sqlcode <> 0 then
																	guo_func.msgbox("SM-0000001", "UPDATE - sysTransactionParam" + "~r~n" + &
																										  string(SQLCA.sqlcode) 	+ "~r~n" + &
																										  SQLCA.sqlerrtext, "Transaction Type: [" + as_tranType + "]")
																	return FALSE
																end if
																
																commit using SQLCA;
																
																return TRUE
																	
														--END VALIDASI
														
													else
														
													
															
														if not guo_func.get_nextNumber('BCCREQUESTNO',ll_reqno,'WITH LOCK') then 
															return FALSE
														end IF
														
														--VALIDASI GET NEXT NUMBER
														
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
															
															return TRUE
															
														--END VALIDASI
														
														ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000') 
												
														insert into BCC_DOCSIS_REQUEST
														(request_no, request_date, mac_address, serial_no, client_class, remarks, ref_trantype_code, ref_tran_no, parent_request_no, request_type_code, node_no /*provinceName*/ , user_name_add, date_add, division_code, company_code, processed, error_code, error_msg, processed_date, bcc_server_code, acct_no, subscriber_name, description, 
														subscriber_status_code, new_acct_no, new_sub_name, NEW_ACCT_DESC,
														CONTACT_PERSON,PACKAGE_CODE,DEVICE_MODEL,LAST_NAME,BATCH_NO,
														HOME_PHONE,WORK_PHONE,ADDRESS_1,ADDRESS_2,CITY,STATE,ZIP_CODE,IP_ADDRESS)
														values
														(:ls_reqno, getdate(), :as_macaddress, :as_serialno, :ls_clientclassvalue, :as_reftrantypecode || '-' || :as_inserttype,  :as_reftrantypecode, :as_reftranno ,null, '015' , :li_nodeno, :gs_username, getdate(), :gs_divisioncode, :gs_companycode, 'N', null, null, null, '0000003', 'IBAS-'||:ls_companyid || :ls_divisionid || :ls_servicecode|| :as_acctno,  :ls_subscribername, 'ADD - REFRESH' , 
														:ls_subscriberstatuscode, null, null, null, substr(:ls_subscribername, 0,40), :ls_packagecode, :ls_model, substr(:ls_subscribername, 0,40),
														'001', :ls_telno, :ls_workphoneno, :ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode,:gs_ipaddress)
														using BCCTRANS;
														
															ll_reqno  = ll_reqno + 1
															ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000') 
												
														insert into BCC_DOCSIS_REQUEST
														(request_no, request_date, mac_address, serial_no, client_class, remarks, ref_trantype_code, ref_tran_no, parent_request_no, request_type_code, node_no /*provinceName*/ , user_name_add, date_add, division_code, company_code, processed, error_code, error_msg, processed_date, bcc_server_code, acct_no, subscriber_name, description, 
														subscriber_status_code, new_acct_no, new_sub_name, NEW_ACCT_DESC,
														CONTACT_PERSON,PACKAGE_CODE,DEVICE_MODEL,LAST_NAME,BATCH_NO,
														HOME_PHONE,WORK_PHONE,ADDRESS_1,ADDRESS_2,CITY,STATE,ZIP_CODE,IP_ADDRESS)
														values
														(:ls_reqno, getdate(), :as_macaddress, :as_serialno, :ls_clientclassvalue, :as_reftrantypecode || '-' || :as_inserttype,  :as_reftrantypecode, :as_reftranno ,null, '014' , :li_nodeno, :gs_username, getdate(), :gs_divisioncode, :gs_companycode, 'N', null, null, null, '0000003', 'IBAS-'||:ls_companyid || :ls_divisionid || :ls_servicecode|| :as_acctno,  :ls_subscribername, 'ADD - REFRESH' , 
														:ls_subscriberstatuscode, null, null, null, substr(:ls_subscribername, 0,40), :ls_packagecode, :ls_model, substr(:ls_subscribername, 0,40),
														'001', :ls_telno, :ls_workphoneno, :ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode,:gs_ipaddress)
														using BCCTRANS;
														
														if not guo_func.set_Number('BCCREQUESTNO',ll_reqno) then
															return FALSE
															end if												
														
														END IF
														
														--VALIDASI SET NUMBER
														
														update sysTransactionParam
															set recordLocked = 'N',
																 lockedUserName = '',
																 lastTransactionNo = :al_tranno
														where recordLocked = 'Y' 
														       and divisionCode = :gs_divisionCode
																and companyCode = :gs_companyCode
																and tranTypeCode = :as_tranType
																using SQLCA;
														if SQLCA.sqlnrows < 1 then
															guo_func.msgbox("SM-0000010", as_tranType 	+ "~r~n" + &
																				string(SQLCA.sqlcode) 	+ "~r~n" + &
																				SQLCA.sqlerrtext, "")
															return false
														elseif SQLCA.sqlcode <> 0 then
															guo_func.msgbox("SM-0000001", "UPDATE - sysTransactionParam" + "~r~n" + &
																								  string(SQLCA.sqlcode) 	+ "~r~n" + &
																								  SQLCA.sqlerrtext, "Transaction Type: [" + as_tranType + "]")
															return FALSE
														end if
														
														commit using SQLCA;
														
														return TRUE
															
														--END VALIDASI
												
												end if
											end if 				
														
										end if
										
										
									if ls_approachtype = 'IPTV' THEN
										
										string ls_url
										blob lblb_args
										long ll_length
										string ls_cont
										
										iir_msgbox = CREATE n_ir_msgbox  
										iinet = CREATE n_inet										
										ls_url = "http://192.168.253.149:11223/v1/converge/provisioning_json/activateINET?brand=BCC&acctNo=&subscriberName="+ls_subscribername+"&nodeNo=0&macAddress="+as_macaddress+"&deviceModel=DPC2100R2&productId=IPTV_CLK"
										lblb_args = blob(ls_cont)
										ll_length = Len(lblb_args)
										
										iinet.GetURL(ls_url, iir_msgbox) 								
																		
								
									END IF 
								
								
										
								
								return TRUE

									
								--END VALIDASI uf_insertIntoMPThrilRequestMaster
									
								else
									if not uf_insertIntoMPThrilRequestMaster(acctNo, subsUserName, password, 'REFRESH', '', 'ACTIVATE', &
												s_assignedModems[1].serialNo, s_assignedModems[1].macAddress, lastSQLErrText) then
										return FALSE
									end IF
									
									--this is same function call before use that
								end IF
								
							else
								if not uf_insertIntoMPThrilRequestMaster(acctNo, subsUserName, password, 'REFRESH', '', 'ACTIVATE', &
											s_assignedModems[1].serialNo, s_assignedModems[1].macAddress, lastSQLErrText) then
									return FALSE
								end IF
								
								--this is same function call before use that
							end if			
						
					end if
				else		
					if upperbound(s_assignedModems) > 0 then
						if not uf_insertIntoMPThrilRequestMaster(acctNo, subsUserName, password, 'REFRESH', '', 'DEACTIVATE', &
									s_assignedModems[1].serialNo, s_assignedModems[1].macAddress, lastSQLErrText) then
							return FALSE
						end IF
						
						--this is same function call before use that
					end if
				end if
				
				/**added by zar  02/16/2009 */
				if not isnull(bundledCTVAcctNo) then
					if not setBundledAcctStatus(subscriberStatusCode) then
						return FALSE			
					end if	
				end if	
				
			end if
			
			return TRUE
 
		--END VALIDASI
	end if
next
commit using SQLCA;
guo_func.msgBox("ATTENTION","All VLAN where successfully moved.")


