--PROSES assign_cpe_to_jo

--lstr_jo.joNo 				= dw_jo.getitemstring(dw_jo.getrow(), "jono")
--lstr_jo.serviceType 	= dw_jo.getitemstring(dw_jo.getrow(), "servicetype")
--lstr_jo.isDigital		 	= dw_jo.getitemstring(dw_jo.getrow(), "isdigital")
--lstr_jo.tranTypeCode 	= dw_jo.getitemstring(dw_jo.getrow(), "tranTypeCode")
--lstr_jo.jostatuscode = dw_jo.getitemstring(dw_jo.getrow(), "jostatuscode")

--if lstr_jo.tranTypeCode = 'ADDONP'  or lstr_jo.tranTypeCode = 'ADDOND' or lstr_jo.tranTypeCode = 'ADDONDI' or lstr_jo.tranTypeCode = 'HBDO' or lstr_jo.tranTypeCode = 'HBDI' then 
--	openwithparm(w_assign_cpe_to_jo_add_on, lstr_jo)
--end if 


--SAVE BUTTON
--lstr_jo.joNo 				= dw_jo.getitemstring(dw_jo.getrow(), "jono")
--lstr_jo.serviceType 	= dw_jo.getitemstring(dw_jo.getrow(), "servicetype")
--lstr_jo.isDigital		 	= dw_jo.getitemstring(dw_jo.getrow(), "isdigital")
--lstr_jo.tranTypeCode 	= dw_jo.getitemstring(dw_jo.getrow(), "tranTypeCode")
--lstr_jo.jostatuscode = dw_jo.getitemstring(dw_jo.getrow(), "jostatuscode")

--is_joNo 			      = lstr_jo.joNo
--is_serviceType 		= lstr_jo.serviceType
--is_isDigital			= lstr_jo.isDigital
--is_tranTypeCode	   = lstr_jo.tranTypeCode
--is_jostatuscode		= lstr_jo.jostatuscode 

--if is_serviceType = 'CTV' and is_isDigital = 'Y' then
--ue_saveDigital

--uo_jo_nv luo_jo
-- VALIDASI JO NO if not luo_jo.setJoNo(is_joNo) then

	if isnull(as_joNo) or trim(as_joNo) = '' then
		lastSQLCode 	= '-2'
		lastSQLErrText = 'as_joNo passed does not contained any value.'
		return FALSE
	end if
	
	joNo = as_joNo
	select acctNo, linemanCode, joStatusCode, joDate, tranTypeCode, referenceNo, actionType, joMobStatusRemarks
	  into :acctNo, :linemanCode, :statusCode, :joDate, :tranTypeCode, :referenceNo, :actionType , :joMobStatusRemarks
	  from joTranHdr
	 where joNo = :joNo
	 and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
	using SQLCA;
	
	
	select serviceType, isDigital
	into :servicetype, :isDigital
	from arPackageMaster 
	inner join arAcctSubscriber on arPackageMaster.packageCode = arAcctSubscriber.packageCode
	where acctNo = :acctNo
	and arAcctSubscriber.divisionCode = :gs_divisionCode
	and arAcctSubscriber.companyCode = :gs_companyCode
	and arPackageMaster.divisionCode = :gs_divisionCode
	and arPackageMaster.companyCode = :gs_companyCode
		
	using SQLCA;
	if SQLCA.sqlcode < 0 then
		lastSQLCode = string(SQLCA.sqlcode)
		lastSQLErrText = SQLCA.sqlerrtext
		return FALSE
	end if
	
	string ls_objectname
	
	if serviceType = 'CTV' then
		ls_objectname = "uo_stb"
	elseif serviceType = 'INET' then
		ls_objectname = "uo_cm"
	end IF
	
	iuo_cpe = CREATE USING ls_objectname
	
	linemanCode = trim(linemanCode)
	statusCode = trim(statusCode)
	tranTypeCode = trim(tranTypeCode)
	
	RETURN true
	
	--VALIDASI uo_subscriber_def luo_subscriber
	--GET luo_subscriber.setAcctNo(luo_jo.acctNo) then	--THIS FOR VALUE luo_subscriber
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
	end IF
	
	--VARIABEL luo_subscriber
	--luo_subscriber.acctNo GET FROM SELECT arAcctSubscriber.acctNo,
	--luo_subscriber.packageCode GET FROM SELECT arAcctSubscriber.packageCode,
	--luo_subscriber.chargeTypeCode GET FROM SELECT arAcctSubscriber.chargeTypeCode,
	
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
	
	--prepaidSubscriber,
	--prepaidSubscriber,
	
	return TRUE
	
	--VALIDASI GET if not luo_jo.getNoOfRequiredSTB(ll_noOfRequiredSTB) then
	
	al_noOfRequiredSTB = 0
	if tranTypeCode = 'APPLYML' then
		select noOfRequiredSTB
		into   :al_noOfRequiredSTB
		from   arAcctSubscriber
		where acctno = :acctno
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using sqlca;
		if SQLCA.sqlcode <> 0 then
			lastSQLCode 	= string(SQLCA.sqlcode)
			lastSQLErrText = SQLCA.sqlerrtext
			al_noOfRequiredSTB = 0
			return FALSE
		end if
	elseif tranTypeCode = 'APPLYEXT' then
		select noOfRequiredSTB
		  into :al_noOfRequiredSTB
		  from applOfExtTranHdr
		 where tranNo = :referenceNo
		 and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;
		if SQLCA.sqlcode <> 0 then
			lastSQLCode 	= string(SQLCA.sqlcode)
			lastSQLErrText = SQLCA.sqlerrtext
			al_noOfRequiredSTB = 0
			return FALSE
		end if
	elseif tranTypeCode = 'APPLEXTHO' then
		select noOfRequiredSTB
		  into :al_noOfRequiredSTB
		  from applOfExtHOTELTranHdr
		 where tranNo = :referenceNo
		 and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;
		if SQLCA.sqlcode <> 0 then
			lastSQLCode 	= string(SQLCA.sqlcode)
			lastSQLErrText = SQLCA.sqlerrtext
			al_noOfRequiredSTB = 0
			return FALSE
		end if
	elseif tranTypeCode = 'APPLMLEXTREA' then
		select noOfRequiredSTB
		  into :al_noOfRequiredSTB
		  from applOfReactivationTranHdr
		 where tranNo = :referenceNo
		 and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;
		if SQLCA.sqlcode <> 0 then
			lastSQLCode 	= string(SQLCA.sqlcode)
			lastSQLErrText = SQLCA.sqlerrtext
			al_noOfRequiredSTB = 0
			return FALSE
		end if	
	elseif tranTypeCode = 'APPLEXTD' then
		select noOfRequiredSTB
		  into :al_noOfRequiredSTB
		  from applOfExtDiscTranHdr
		 where tranNo = :referenceNo
		 and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;
		if SQLCA.sqlcode <> 0 then
			lastSQLCode 	= string(SQLCA.sqlcode)
			lastSQLErrText = SQLCA.sqlerrtext
			al_noOfRequiredSTB = 0
			return FALSE
		end if	
	else
		al_noOfRequiredSTB = 0
	end if
	
	return TRUE
	
	--NEXT PROCESS
	--validasi data window
	
	-- QUEERY DW DETAIL MAKE FORM ARRAY LIST
	
	  SELECT joTranDtlAssignedCPE.serialNo,   
         joTranDtlAssignedCPE.itemCode,   
         joTranDtlAssignedCPE.originalAssignedCPE,   
         joTranDtlAssignedCPE.newSerialNo,   
         joTranDtlAssignedCPE.newItemCode, 
         serialNoMaster.controlNo, serialNoMaster.macAddress,  
         'N' newRecord,   
         joTranDtlAssignedCPE.acquisitionTypeCode,   
         '' selected, 
         joTranDtlAssignedCPE.isPrimary, 
         itemMaster.itemName,
         ''newItemName,
		  joTranDtlAssignedCPE.newCAItemCode,
		joTranDtlAssignedCPE.newCASerialNo,
		arPackageMaster.packageName,
		joTranDtlAssignedCPE.packageCode,
		  joTranDtlAssignedCPE.caItemCode,joTranDtlAssignedCPE.newMacAddress,
		joTranDtlAssignedCPE.caSerialNo, '' newCAItemName, i.itemname caItemName, 'N' isChecked,0 noOfrequiredSTB,
		joTranDtlAssignedCPE.lastassigneddate
	    FROM joTranDtlAssignedCPE  
	   INNER JOIN serialNoMaster on joTranDtlAssignedCPE.serialNo = serialNoMaster.serialNo 
	   AND serialNoMaster.divisionCode = joTranDtlAssignedCPE.divisionCode
	   AND serialNoMaster.companyCode = joTranDtlAssignedCPE.companyCode
	   INNER JOIN itemMaster on joTranDtlAssignedCPE.itemCode = itemMaster.itemCode
	   AND  serialNoMaster.itemCode = itemMaster.itemCode
	   AND itemMaster.companyCode = joTranDtlAssignedCPE.companyCode
	   INNER JOIN serialNoMaster s on joTranDtlAssignedCPE.caserialNo = s.serialNo 
	   AND s.divisionCode = joTranDtlAssignedCPE.divisionCode
	   AND s.companyCode = joTranDtlAssignedCPE.companyCode
	   INNER JOIN itemMaster i on joTranDtlAssignedCPE.caitemCode = i.itemCode
	   AND  s.itemCode = i.itemCode
	   AND i.companyCode = joTranDtlAssignedCPE.companyCode
	    LEFT JOIN arPackageMaster on joTranDtlAssignedCPE.packageCode = arPackageMaster.packageCode 
	   AND arPackageMaster.divisionCode = joTranDtlAssignedCPE.divisionCode
	   AND arPackageMaster.companyCode = joTranDtlAssignedCPE.companyCode
	   WHERE ( joTranDtlAssignedCPE.joNo = :as_jono ) AND  
	         ( joTranDtlAssignedCPE.newItemCode is null  and  joTranDtlAssignedCPE.newCAItemCode is null   )
     AND ( joTranDtlAssignedCPE.divisionCode = :as_division )      
     AND ( joTranDtlAssignedCPE.companyCode = :as_company )
	
	ll_newRecords = 0
	ll_records = dw_detail.rowcount()
	for ll_row = 1 to ll_records	
		ls_serialNo			= trim(dw_detail.object.serialNo[ll_row])	
		ls_caSerialNo		= trim(dw_detail.object.caserialNo[ll_row])	
		ls_newSerialNo	   = trim(dw_detail.object.newSerialNo[ll_row])	
		ls_newCASerialNo	= trim(dw_detail.object.newCASerialNo[ll_row])	
		
		if (isnull(ls_serialNo)  and not isNull(ls_caSerialNo) ) or  (not isnull(ls_serialNo)  and isNull(ls_caSerialNo) ) then
			is_msgno 	= "SM-0000001"
			is_msgtrail  = 'This  assigned CPE requires corresponding CA CARD or vice versa.'
			is_sugtrail	 = 'A pair of CPE and CA Card is required'
			return -1
		elseif (isnull(ls_newSerialNo)  and not isNull(ls_newCASerialNo)) or (not isnull(ls_newSerialNo)  and isNull(ls_newCASerialNo)) then
			is_msgno 	= "SM-0000001"
			is_msgtrail  = 'This  new assigned CPE requires corresponding CA CARD or vice versa.'
			is_sugtrail	 = 'A new pair of CPE and CA Card is required'
			return -1
		elseif (isnull(ls_serialNo)  and isNull(ls_caSerialNo) ) and  (isnull(ls_newSerialNo)  and isNull(ls_newCASerialNo) ) then
			continue
		end if
		
		ll_newRecords = ll_newRecords + 1
	next
	
	if ll_newRecords <> ll_noOfRequiredSTB then
		is_msgno = "SM-0000001"
		is_msgtrail = 'This J.O. being assigned CPE requires ' + string(ll_noOfRequiredSTB) + '~r~n' + &
							'Excess or less serial number is not necessary.'
		is_sugtrail = 'You may delete or add  some records to comply with the requirements.'
		return -1
	end IF
	
	--VALIDASI not iuo_cpe.getSCSRequestNextTranNo()
	
	--long ll_tranNo
	--string ls_errormsg
	--if not guo_func.get_nextnumber('SCSREQUEST', ll_tranno, 'WITH LOCK') then
	--	lastSQLCode = '-2'
	--	lastSQLErrText = 'Could not obtain the next SCS Request No.'
	--	Return False
	--end if
	scsRequestNextTranNo = ll_tranNo
	
	--VALIDASI iuo_cpe.decrementscsnexttranno( )
	scsRequestNextTranNo --
	
	
	--VALIDASI iuo_cpe.setSCSRequestSource('ASSIGNTOEJO')
	
	scsRequestSourceTransaction 	= as_sourceTransaction = 'ASSIGNTOEJO'
		
	
	Return TRUE
	
	is_joNo = dw_header.getitemstring(1, "jono")

	ll_records = dw_detail.rowcount()
	for ll_row = 1 to ll_records
		
		ls_serialNo 				= trim(dw_detail.object.serialNo[ll_row])
		ls_itemCode 				= trim(dw_detail.object.itemCode[ll_row])
		ls_caSerialNo 				= trim(dw_detail.object.caserialNo[ll_row])
		ls_caItemCode 				= trim(dw_detail.object.caitemCode[ll_row])
		ls_newItemCode			= trim(dw_detail.object.newItemCode[ll_row])
		ls_newSerialNo			= trim(dw_detail.object.newSerialNo[ll_row])
		ls_newCAItemCode		= trim(dw_detail.object.newcaItemCode[ll_row])
		ls_newCASerialNo			= trim(dw_detail.object.newcaSerialNo[ll_row])
		ls_origAssigned			= trim(dw_detail.object.originalassignedcpe[ll_row])
		ls_newRecord				= trim(dw_detail.object.newRecord[ll_row])
		ls_acquisitionTypeCode 	= trim(dw_detail.object.acquisitionTypeCode[ll_row])
		ls_selected					= trim(dw_detail.object.selected[ll_row])
		ls_packageCode			= trim(dw_detail.object.packageCode[ll_row])
		ls_isPrimary				= trim(dw_detail.object.isPrimary[ll_row])
		//if isnull(ls_serialNo) or ls_serialNo = "" then continue
		if (isnull(ls_serialNo)  and isNull(ls_caSerialNo) ) and  (isnull(ls_newSerialNo)  and isNull(ls_newCASerialNo) ) then
			continue
		end if
	
		if not iuo_cpe.setSerialNo(ls_serialNo) then
			is_msgno = "SM-0000001"
			is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
			is_sugtrail = ""
			return -1
		end if	
		
		--VALIDASI iuo_cpe.setSerialNo(ls_serialNo)
		serialNo = trim(as_serialno)

		// check if existing
		if gb_sharedInventory then
			select a.itemCode, a.barCode, a.controlNo, a.locationCode, a.serialNoStatusCode, a.acctNo, a.boxIdNo, b.itemName, 
						b.productLineCode, b.model, b.voltage, a.macAddress, isDigital
			  into :itemCode, :barCode, :controlNo, :locationCode, :statusCode, :acctNo, :boxIdNo, :itemName, 
						:productLineCode, :model, :voltage, :macAddress, :isDigital
			  from serialNoMaster a, itemMaster b
			 where a.itemCode = b.itemCode
				and a.divisionCode = :gs_divisionCode
				and a.companyCode = b.companyCode
				and a.serialNo = :serialNo
				and b.itemIsSTB = 'Y'
				and a.companyCode = :gs_companyCode
				and a.divisionCode in (select divisionCode
										     from   sysDivisionGroupMembersIC
											  where  divisionGroupCode = :gs_divisionGroupCode)
			 using SQLCA;
		else
			select a.itemCode, a.barCode, a.controlNo, a.locationCode, a.serialNoStatusCode, a.acctNo, a.boxIdNo, b.itemName, 
						b.productLineCode, b.model, b.voltage, a.macAddress, isDigital
			  into :itemCode, :barCode, :controlNo, :locationCode, :statusCode, :acctNo, :boxIdNo, :itemName, 
						:productLineCode, :model, :voltage, :macAddress, :isDigital
			  from serialNoMaster a, itemMaster b
			 where a.itemCode = b.itemCode
				and a.divisionCode = :gs_divisionCode
				and a.companyCode = :gs_companyCode
				and b.companyCode = :gs_companyCode
				and a.serialNo = :serialNo
				and b.itemIsSTB = 'Y'
				and a.companyCode = :gs_companyCode
			 using SQLCA;	
		end if	
		if SQLCA.sqlcode < 0 then
			lastSQLCode		= string(SQLCA.sqlcode)
			lastSQLErrText = SQLCA.sqlerrtext
			return FALSE
		elseif SQLCA.sqlcode = 100 then
			lastSQLCode		= string(SQLCA.sqlcode)
			lastSQLErrText = "The SetTOP Box with serial number " + serialNo + " does not exist!"
			return FALSE
		end if
		
		if not isnull(acctNo) and acctNo <> '' then
			select subscriberName
			  into :subscriberName
			  from arAcctSubscriber
			 where acctNo = :acctNo
			 and   companyCode = :gs_companyCode
			 and   divisionCode = :gs_divisionCode
			 using SQLCA;
			if SQLCA.sqlcode < 0 then
				lastSQLCode		= string(SQLCA.sqlcode)
				lastSQLErrText = SQLCA.sqlerrtext
				return FALSE
			elseif SQLCA.sqlcode = 100 then
				lastSQLCode		= '-2'
				lastSQLErrText = 'This SetTop Box was assigned to Acct. #: ' + acctNo + '~r~n~r~n' + &
										'However, the system was unable to get its corresponding subscriber name' + '~r~n~r~n' + &
										'You must report this to your supervisor immediately.'
				return FALSE
			end if	
		end if
		
		currAcctNo = acctNo
		isCaCard = 'N'
		if isnull(isDigital) then isDigital = 'N'
		
		select acquisitionTypeCode, acquiredBefore2003, cpeStatusCode, packageCode, isPrimary 
		  into :acquisitionTypeCode, :acquiredBefore2003, :subscriberCPEStatus, :packageCode, :isPrimary
		  from subscriberCPEMaster
		 where acctNo = :acctNo
		   and serialNo = :serialNo
			and companyCode = :gs_companyCode
			and divisionCode = :gs_divisionCode
		 using SQLCA;
		if SQLCA.sqlcode < 0 then
			lastSQLCode		= string(SQLCA.sqlcode)
			lastSQLErrText = SQLCA.sqlerrtext
			return FALSE
		elseif SQLCA.sqlcode = 100 then
			acquisitionTypeCode = ''
			subscriberCPEStatus = ''
			return TRUE 
		end if
		
		return TRUE
		----------------------------------------------
		
		
		if not iuo_cpe.preAssignToSubscriber(luo_subscriber.acctNo) then
			is_msgno = "SM-0000001"
			is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
			is_sugtrail = 'Object.Method: iuo_cpe.preAssignToSubscriber()'
			return -1
		end IF
		
		--VALIDASI iuo_cpe.preAssignToSubscriber(luo_subscriber.acctNo)
		acctNo = as_acctNo

			if isNull(as_locationCode) then as_locationCode = ''
			
			if trim(as_locationCode) = '' then
				update serialNoMaster
					set serialNoStatusCode = 'PA',
						 acctNo = :as_acctNo
				 where serialNo = :serialNo
				 	and divisionCode = :gs_divisionCode
					and companyCode = :gs_companyCode
				using SQLCA;
				if SQLCA.sqlcode < 0 then
					lastSQLCode = string(SQLCA.sqlcode)
					lastSQLErrText = SQLCA.sqlerrtext
					return FALSE
				end if
			else
				update serialNoMaster
					set serialNoStatusCode = 'PA',
						 acctNo = :as_acctNo,
						 locationCode = :as_locationCode
				 where serialNo = :serialNo
				 	and divisionCode = :gs_divisionCode
					and companyCode = :gs_companyCode
				using SQLCA;
				if SQLCA.sqlcode < 0 then
					lastSQLCode = string(SQLCA.sqlcode)
					lastSQLErrText = SQLCA.sqlerrtext
					return FALSE
				end if
			end if
			
			return TRUE
		
		if not iuo_cpe.setCASerialNo(ls_caSerialNo) then
			is_msgno = "SM-0000001"
			is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
			is_sugtrail = ""
			return -1
		end if	
		
		--VALIDASI iuo_cpe.setCASerialNo(ls_caSerialNo) 
		
		serialNo = trim(as_serialno)
		serialNo = UPPER(serialNo)
		
		--check if existing
		if gb_sharedInventory then
			select a.itemCode, a.barCode, a.controlNo, a.locationCode, a.serialNoStatusCode, a.acctNo, a.boxIdNo, b.itemName, 
						b.productLineCode, b.model, b.voltage, a.macAddress
			  into :itemCode, :barCode, :controlNo, :locationCode, :statusCode, :acctNo, :boxIdNo, :itemName, 
						:productLineCode, :model, :voltage, :macAddress
			  from serialNoMaster a, itemMaster b
			 where a.itemCode = b.itemCode
				and a.divisionCode = :gs_divisionCode
				and a.companyCode = b.companyCode
				and a.serialNo = :serialNo
				and b.isCACard = 'Y'
				and a.companyCode = :gs_companyCode
				and a.divisionCode in (select divisionCode
										     from   sysDivisionGroupMembersIC
											  where  divisionGroupCode = :gs_divisionGroupCode)
			 using SQLCA;
		else
			select a.itemCode, a.barCode, a.controlNo, a.locationCode, a.serialNoStatusCode, a.acctNo, a.boxIdNo, b.itemName, 
						b.productLineCode, b.model, b.voltage, a.macAddress
			  into :itemCode, :barCode, :controlNo, :locationCode, :statusCode, :acctNo, :boxIdNo, :itemName, 
						:productLineCode, :model, :voltage, :macAddress
			  from serialNoMaster a, itemMaster b
			 where a.itemCode = b.itemCode
				and a.divisionCode = :gs_divisionCode
				and a.companyCode = :gs_companyCode
				and b.companyCode = :gs_companyCode
				and a.serialNo = :serialNo
				and b.isCACard = 'Y'
				and a.companyCode = :gs_companyCode
			 using SQLCA;	
		end if	
		if SQLCA.sqlcode < 0 then
			lastSQLCode		= string(SQLCA.sqlcode)
			lastSQLErrText = SQLCA.sqlerrtext
			return FALSE
		elseif SQLCA.sqlcode = 100 then
			lastSQLCode		= string(SQLCA.sqlcode)
			lastSQLErrText = "The SetTOP Box with serial number " + serialNo + " does not exist!"
			return FALSE
		end if
		
		if not isnull(acctNo) and acctNo <> '' then
			select subscriberName
			  into :subscriberName
			  from arAcctSubscriber
			 where acctNo = :acctNo
			 and   companyCode = :gs_companyCode
			 and   divisionCode = :gs_divisionCode
			 using SQLCA;
			if SQLCA.sqlcode < 0 then
				lastSQLCode		= string(SQLCA.sqlcode)
				lastSQLErrText = SQLCA.sqlerrtext
				return FALSE
			elseif SQLCA.sqlcode = 100 then
				lastSQLCode		= '-2'
				lastSQLErrText = 'This SetTop Box was assigned to Acct. #: ' + acctNo + '~r~n~r~n' + &
										'However, the system was unable to get its corresponding subscriber name' + '~r~n~r~n' + &
										'You must report this to your supervisor immediately.'
				return FALSE
			end if	
		end if
		
		isDigital = 'N'
		isCaCard = 'Y'
		currAcctNo = acctNo
		
		return TRUE		
		
		--NEXT PROSESS
		if not isNull(ls_newItemCode)  or not isNull(ls_newCAItemCode) then
		
		update joTranDtlAssignedCPE 
			set newItemCode 			= :ls_newItemCode,
				 newSerialNo			= :ls_newSerialNo,
				 newCAItemCode 		= :ls_newCAItemCode,
				 newCASerialNo		= :ls_newCASerialNo,
				 acquisitionTypeCode    = :ls_acquisitionTypeCode,
				 lastAssignedBy		= :gs_username,
				 lastAssignedDate 	        = getdate()
		 where joNo = :is_joNo
		 	and serialNo = :ls_serialNo
			and divisionCode = :gs_divisionCode
			and companyCode = :gs_companyCode
		using SQLCA;
		if SQLCA.sqlcode <> 0 then
			is_msgno = "SM-0000001"
			is_msgtrail = string(SQLCA.sqlcode) + "~r~n" + SQLCA.sqlerrtext
			is_sugtrail = ""
			return -1
		end if
	
		/**OLD STB SERIAL NO */
		 if not iuo_cpe.setSerialNo(ls_serialNo) then
			is_msgno = "SM-0000001"
			is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
			is_sugtrail = ""
			return -1
		end if	
		--VALIDASI iuo_cpe.setSerialNo(ls_serialNo)
		RETURN TRUE
		
		if not iuo_cpe.cancelPreAssignment() then
			is_msgno = "SM-0000001"
			is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
			is_sugtrail = 'Object.Method: iuo_cpe.preAssignToSubscriber()'
			return -1
		end if	
		
		--VALIDASI iuo_cpe.cancelPreAssignment()		
		setNull(acctNo)

		if gb_sharedInventory then
			update serialNoMaster
				set serialNoStatusCode = 'AV',
					 acctNo = null
			 where serialNo = :serialNo
			 and   companyCode = :gs_companyCode
			 and   divisionCode in (select divisionCode 
			 					         from   sysDivisionGroupMembersIC
											where  divisionGroupCode = :gs_divisionGroupCode)									
			 using SQLCA;
		else
			update serialNoMaster
				set serialNoStatusCode = 'AV',
					 acctNo = null
			 	where serialNo = :serialNo
			 	and divisionCode = :gs_divisionCode
				and companyCode = :gs_companyCode
			using SQLCA;
		end if	
		if SQLCA.sqlcode < 0 then
			lastSQLCode = string(SQLCA.sqlcode)
			lastSQLErrText = SQLCA.sqlerrtext
			return FALSE
		end if
		
		return TRUE
		--
				
		iuo_cpe.incrementscsrequesttranno( )
		if not iuo_cpe.deactivate() then
			is_msgno = "SM-0000001"
			is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
			is_sugtrail = 'Error produced by iuo_cpe.deactivate()'
			return -1
		end IF
		
		--VALIDASI iuo_cpe.incrementscsrequesttranno
		scsRequestNextTranNo++
		-----
		
		
		if not iuo_cpe.deleteFromSTBPackages() then
			is_msgno = "SM-0000001"
			is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
			is_sugtrail = "Method: iuo_cpe.deleteFromSTBPackages()"
			return -1
		end IF
		--VALIDASI iuo_cpe.deleteFromSTBPackages()
		// ==================================================
		// Note: this must be executed before 
		// 		deleteFromSubscriberCPEMaster
		// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		delete from stbPackages
				where serialNo = :serialNo
				and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;
		if SQLCA.sqlcode <> 0 then
			lastSQLCode		= string(SQLCA.sqlcode)
			lastSQLErrText	= SQLCA.sqlerrtext
			return FALSE
		end if	 
		
		return TRUE
		------
		
		/***NEW STB SERIAL NO****/
		if not iuo_cpe.setSerialNo(ls_newSerialNo) then
			is_msgno = "SM-0000001"
			is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
			is_sugtrail = ""
			return -1
		end if	
		
		--VALIDASI iuo_cpe.setSerialNo(ls_newSerialNo)
		RETURN TRUE
		
		if is_joStatusCode = 'FR' then
			if upper(iuo_cpe.locationCode) <> upper(is_wsdeflocationCode) and iuo_cpe.statusCode <> 'AV' then //validating location of CPE | STB
				
				select locationName into :ls_currLocName
				from   locationMaster 
				where  locationCode = :iuo_cpe.locationCode
				and    companyCode  = :gs_companyCode
				using  SQLCA;
				if SQLCA.SQLCode <> 0 then
					guo_func.msgbox("Error in Select [LocationMaster]", SQLCA.SQLErrText)
					this.post dynamic event ue_set_column('serialno')			
					return 2
				end if	
			
				guo_func.msgBox('Warning!','Serial No. [' + ls_newSerialNo+ '] is currently in location [' + trim(ls_currLocName) + ']' )	
				return -1
			end if
			
		elseif is_joStatusCode = 'OG' then
			
			if upper(iuo_cpe.locationCode) <> upper(is_linemanCode) and iuo_cpe.statusCode <> 'AV' then //validating location of CPE | STB
				
				select locationName into :ls_currLocName
				from   locationMaster 
				where  locationCode = :iuo_cpe.locationCode
				and    companyCode  = :gs_companyCode
				using  SQLCA;
				if SQLCA.SQLCode <> 0 then
					guo_func.msgbox("Error in Select [LocationMaster]", SQLCA.SQLErrText)
					this.post dynamic event ue_set_column('serialno')			
					return 2
				end if	
			
				guo_func.msgBox('Warning!','Serial No. [' + ls_newSerialNo+ '] is currently in location [' + trim(ls_currLocName) + ']' )	
				return -1
			end if
			
		end if
		
		if not iuo_cpe.preAssignToSubscriber(luo_subscriber.acctNo) then
			is_msgno = "SM-0000001"
			is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
			is_sugtrail = 'Object.Method: iuo_cpe.preAssignToSubscriber()'
			return -1
		end IF		
		
		--VALIDASI iuo_cpe.preAssignToSubscriber(luo_subscriber.acctNo)
		acctNo = as_acctNo

			if isNull(as_locationCode) then as_locationCode = ''
			
			if trim(as_locationCode) = '' then
				update serialNoMaster
					set serialNoStatusCode = 'PA',
						 acctNo = :as_acctNo
				 where serialNo = :serialNo
				 	and divisionCode = :gs_divisionCode
					and companyCode = :gs_companyCode
				using SQLCA;
				if SQLCA.sqlcode < 0 then
					lastSQLCode = string(SQLCA.sqlcode)
					lastSQLErrText = SQLCA.sqlerrtext
					return FALSE
				end if
			else
				update serialNoMaster
					set serialNoStatusCode = 'PA',
						 acctNo = :as_acctNo,
						 locationCode = :as_locationCode
				 where serialNo = :serialNo
				 	and divisionCode = :gs_divisionCode
					and companyCode = :gs_companyCode
				using SQLCA;
				if SQLCA.sqlcode < 0 then
					lastSQLCode = string(SQLCA.sqlcode)
					lastSQLErrText = SQLCA.sqlerrtext
					return FALSE
				end if
			end if
			
			return TRUE
		
		
	  /***OLD ACCESS CARD ***/	
	  if not iuo_cpe.setCASerialNo(ls_caSerialNo) then
			is_msgno = "SM-0000001"
			is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
			is_sugtrail = ""
			return -1
		end if	
		
		--VALIDASI iuo_cpe.setCASerialNo(ls_caSerialNo)
		
		serialNo = trim(as_serialno)
		serialNo = UPPER(serialNo)
		
		// check if existing
		if gb_sharedInventory then
			select a.itemCode, a.barCode, a.controlNo, a.locationCode, a.serialNoStatusCode, a.acctNo, a.boxIdNo, b.itemName, 
						b.productLineCode, b.model, b.voltage, a.macAddress
			  into :itemCode, :barCode, :controlNo, :locationCode, :statusCode, :acctNo, :boxIdNo, :itemName, 
						:productLineCode, :model, :voltage, :macAddress
			  from serialNoMaster a, itemMaster b
			 where a.itemCode = b.itemCode
				and a.divisionCode = :gs_divisionCode
				and a.companyCode = b.companyCode
				and a.serialNo = :serialNo
				and b.isCACard = 'Y'
				and a.companyCode = :gs_companyCode
				and a.divisionCode in (select divisionCode
										     from   sysDivisionGroupMembersIC
											  where  divisionGroupCode = :gs_divisionGroupCode)
			 using SQLCA;
		else
			select a.itemCode, a.barCode, a.controlNo, a.locationCode, a.serialNoStatusCode, a.acctNo, a.boxIdNo, b.itemName, 
						b.productLineCode, b.model, b.voltage, a.macAddress
			  into :itemCode, :barCode, :controlNo, :locationCode, :statusCode, :acctNo, :boxIdNo, :itemName, 
						:productLineCode, :model, :voltage, :macAddress
			  from serialNoMaster a, itemMaster b
			 where a.itemCode = b.itemCode
				and a.divisionCode = :gs_divisionCode
				and a.companyCode = :gs_companyCode
				and b.companyCode = :gs_companyCode
				and a.serialNo = :serialNo
				and b.isCACard = 'Y'
				and a.companyCode = :gs_companyCode
			 using SQLCA;	
		end if	
		if SQLCA.sqlcode < 0 then
			lastSQLCode		= string(SQLCA.sqlcode)
			lastSQLErrText = SQLCA.sqlerrtext
			return FALSE
		elseif SQLCA.sqlcode = 100 then
			lastSQLCode		= string(SQLCA.sqlcode)
			lastSQLErrText = "The SetTOP Box with serial number " + serialNo + " does not exist!"
			return FALSE
		end if
		
		if not isnull(acctNo) and acctNo <> '' then
			select subscriberName
			  into :subscriberName
			  from arAcctSubscriber
			 where acctNo = :acctNo
			 and   companyCode = :gs_companyCode
			 and   divisionCode = :gs_divisionCode
			 using SQLCA;
			if SQLCA.sqlcode < 0 then
				lastSQLCode		= string(SQLCA.sqlcode)
				lastSQLErrText = SQLCA.sqlerrtext
				return FALSE
			elseif SQLCA.sqlcode = 100 then
				lastSQLCode		= '-2'
				lastSQLErrText = 'This SetTop Box was assigned to Acct. #: ' + acctNo + '~r~n~r~n' + &
										'However, the system was unable to get its corresponding subscriber name' + '~r~n~r~n' + &
										'You must report this to your supervisor immediately.'
				return FALSE
			end if	
		end if
		
		isDigital = 'N'
		isCaCard = 'Y'
		currAcctNo = acctNo
		
		return TRUE
		-----------------
		
		if not iuo_cpe.cancelPreAssignment() then
			is_msgno = "SM-0000001"
			is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
			is_sugtrail = 'Object.Method: iuo_cpe.preAssignToSubscriber()'
			return -1
		end IF
		
		--VALIDASI iuo_cpe.cancelPreAssignment()
		setNull(acctNo)

		if gb_sharedInventory then
			update serialNoMaster
				set serialNoStatusCode = 'AV',
					 acctNo = null
			 where serialNo = :serialNo
			 and   companyCode = :gs_companyCode
			 and   divisionCode in (select divisionCode 
			 					         from   sysDivisionGroupMembersIC
											where  divisionGroupCode = :gs_divisionGroupCode)									
			 using SQLCA;
		else
			update serialNoMaster
				set serialNoStatusCode = 'AV',
					 acctNo = null
			 	where serialNo = :serialNo
			 	and divisionCode = :gs_divisionCode
				and companyCode = :gs_companyCode
			using SQLCA;
		end if	
		if SQLCA.sqlcode < 0 then
			lastSQLCode = string(SQLCA.sqlcode)
			lastSQLErrText = SQLCA.sqlerrtext
			return FALSE
		end if
		
		return TRUE
		
		
		/***NEW ACCESS CARDS***/
		 if not iuo_cpe.setCASerialNo(ls_newCASerialNo) then
			is_msgno = "SM-0000001"
			is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
			is_sugtrail = ""
			return -1
		end if	
		
		--VALIDASI iuo_cpe.setCASerialNo(ls_newCASerialNo)
		serialNo = trim(as_serialno)
		serialNo = UPPER(serialNo)
		
		// check if existing
		if gb_sharedInventory then
			select a.itemCode, a.barCode, a.controlNo, a.locationCode, a.serialNoStatusCode, a.acctNo, a.boxIdNo, b.itemName, 
						b.productLineCode, b.model, b.voltage, a.macAddress
			  into :itemCode, :barCode, :controlNo, :locationCode, :statusCode, :acctNo, :boxIdNo, :itemName, 
						:productLineCode, :model, :voltage, :macAddress
			  from serialNoMaster a, itemMaster b
			 where a.itemCode = b.itemCode
				and a.divisionCode = :gs_divisionCode
				and a.companyCode = b.companyCode
				and a.serialNo = :serialNo
				and b.isCACard = 'Y'
				and a.companyCode = :gs_companyCode
				and a.divisionCode in (select divisionCode
										     from   sysDivisionGroupMembersIC
											  where  divisionGroupCode = :gs_divisionGroupCode)
			 using SQLCA;
		else
			select a.itemCode, a.barCode, a.controlNo, a.locationCode, a.serialNoStatusCode, a.acctNo, a.boxIdNo, b.itemName, 
						b.productLineCode, b.model, b.voltage, a.macAddress
			  into :itemCode, :barCode, :controlNo, :locationCode, :statusCode, :acctNo, :boxIdNo, :itemName, 
						:productLineCode, :model, :voltage, :macAddress
			  from serialNoMaster a, itemMaster b
			 where a.itemCode = b.itemCode
				and a.divisionCode = :gs_divisionCode
				and a.companyCode = :gs_companyCode
				and b.companyCode = :gs_companyCode
				and a.serialNo = :serialNo
				and b.isCACard = 'Y'
				and a.companyCode = :gs_companyCode
			 using SQLCA;	
		end if	
		if SQLCA.sqlcode < 0 then
			lastSQLCode		= string(SQLCA.sqlcode)
			lastSQLErrText = SQLCA.sqlerrtext
			return FALSE
		elseif SQLCA.sqlcode = 100 then
			lastSQLCode		= string(SQLCA.sqlcode)
			lastSQLErrText = "The SetTOP Box with serial number " + serialNo + " does not exist!"
			return FALSE
		end if
		
		if not isnull(acctNo) and acctNo <> '' then
			select subscriberName
			  into :subscriberName
			  from arAcctSubscriber
			 where acctNo = :acctNo
			 and   companyCode = :gs_companyCode
			 and   divisionCode = :gs_divisionCode
			 using SQLCA;
			if SQLCA.sqlcode < 0 then
				lastSQLCode		= string(SQLCA.sqlcode)
				lastSQLErrText = SQLCA.sqlerrtext
				return FALSE
			elseif SQLCA.sqlcode = 100 then
				lastSQLCode		= '-2'
				lastSQLErrText = 'This SetTop Box was assigned to Acct. #: ' + acctNo + '~r~n~r~n' + &
										'However, the system was unable to get its corresponding subscriber name' + '~r~n~r~n' + &
										'You must report this to your supervisor immediately.'
				return FALSE
			end if	
		end if
		
		isDigital = 'N'
		isCaCard = 'Y'
		currAcctNo = acctNo
		
		return TRUE
		----------------
		
		if is_joStatusCode = 'FR' then
			if upper(iuo_cpe.locationCode) <> upper(is_wsdeflocationCode) and iuo_cpe.statusCode <> 'AV' then //validating location of CPE | STB
				
				select locationName into :ls_currLocName
				from   locationMaster 
				where  locationCode = :iuo_cpe.locationCode
				and    companyCode  = :gs_companyCode
				using  SQLCA;
				if SQLCA.SQLCode <> 0 then
					guo_func.msgbox("Error in Select [LocationMaster]", SQLCA.SQLErrText)
					this.post dynamic event ue_set_column('serialno')			
					return 2
				end if	
			
				guo_func.msgBox('Warning!','Serial No. [' + ls_newCASerialNo+ '] is currently in location [' + trim(ls_currLocName) + ']' )	
				return -1
			end if
			
		elseif is_joStatusCode = 'OG' then
			
			if upper(iuo_cpe.locationCode) <> upper(is_linemanCode) and iuo_cpe.statusCode <> 'AV' then //validating location of CPE | STB
				
				select locationName into :ls_currLocName
				from   locationMaster 
				where  locationCode = :iuo_cpe.locationCode
				and    companyCode  = :gs_companyCode
				using  SQLCA;
				if SQLCA.SQLCode <> 0 then
					guo_func.msgbox("Error in Select [LocationMaster]", SQLCA.SQLErrText)
					this.post dynamic event ue_set_column('serialno')			
					return 2
				end if	
			
				guo_func.msgBox('Warning!','Serial No. [' + ls_newCASerialNo+ '] is currently in location [' + trim(ls_currLocName) + ']' )	
				return -1
			end if
			
		end if
			
		if not iuo_cpe.preAssignToSubscriber(luo_subscriber.acctNo) then
			is_msgno = "SM-0000001"
			is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
			is_sugtrail = 'Object.Method: iuo_cpe.preAssignToSubscriber()'
			return -1
		end IF
		
		--VALIDASI iuo_cpe.preAssignToSubscriber(luo_subscriber.acctNo)
		acctNo = as_acctNo

			if isNull(as_locationCode) then as_locationCode = ''
			
			if trim(as_locationCode) = '' then
				update serialNoMaster
					set serialNoStatusCode = 'PA',
						 acctNo = :as_acctNo
				 where serialNo = :serialNo
				 	and divisionCode = :gs_divisionCode
					and companyCode = :gs_companyCode
				using SQLCA;
				if SQLCA.sqlcode < 0 then
					lastSQLCode = string(SQLCA.sqlcode)
					lastSQLErrText = SQLCA.sqlerrtext
					return FALSE
				end if
			else
				update serialNoMaster
					set serialNoStatusCode = 'PA',
						 acctNo = :as_acctNo,
						 locationCode = :as_locationCode
				 where serialNo = :serialNo
				 	and divisionCode = :gs_divisionCode
					and companyCode = :gs_companyCode
				using SQLCA;
				if SQLCA.sqlcode < 0 then
					lastSQLCode = string(SQLCA.sqlcode)
					lastSQLErrText = SQLCA.sqlerrtext
					return FALSE
				end if
			end if
			
			return TRUE
			----------------
		
		
		// this portions 
		if luo_subscriber.chargeTypeCode = 'PPS' then
			if not iuo_cpe.takePlaceInSTBPPCLoad(ls_newSerialNo) then
				is_msgno = "SM-0000001"
				is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
				is_sugtrail = "Method: iuo_cpe.takePlaceInSTBPPCLoad()"
				return -1
			end if
		end if
		
	end if
	
	if ls_selected = 'Y' then
		ls_origAssigned 	= 'N'
		ls_serialNo 	 	= ls_newSerialNo
		ls_caSerialNo		= ls_newCASerialNo
		ls_itemCode		   = ls_newitemCode
		ls_caItemCode		= ls_newCAItemCode
	end if
	
	if ls_newRecord = 'Y' or not IsNull(ls_newSerialNo)  then
		
		insert into joTranDtlAssignedCPE (
						joNo,
						itemCode,
						serialNo,
						caitemCode,
						caserialNo,
						originalAssignedCPE,
						acquisitionTypeCode,
						lastAssignedBy,
						lastAssignedDate,
						divisionCode,
						companyCode,
						macAddress,
						packageCode,
						acctNo,
						isPrimary)
			  values (
						:is_joNo,
						:ls_itemCode,
						:ls_serialNo,
						:ls_caitemCode,
						:ls_caserialNo,
						:ls_origAssigned,
						:ls_acquisitionTypeCode,
						:gs_username,
						getdate(),
						:gs_divisionCode,
						:gs_companyCode,
						null,
						:ls_packageCode,
						:luo_jo.acctNo,
						:ls_isPrimary)
				using SQLCA;
		if SQLCA.sqlcode <> 0 then
			is_msgno = "SM-0000001"
			is_msgtrail = string(SQLCA.sqlcode) + "~r~n" + SQLCA.sqlerrtext
			is_sugtrail = ""
			return -1
		end if	
		
		
		insert into joTrandDtlAssignedCPETrail (
						joNo,
						itemCode,
						serialNo,
						caitemCode,
						caserialNo,
						originalAssignedCPE,
						acquisitionTypeCode,
						lastAssignedBy,
						lastAssignedDate,
						divisionCode,
						companyCode,
						macAddress,
						packageCode,
						acctNo,
						isPrimary)
			  values (
						:is_joNo,
						:ls_itemCode,
						:ls_serialNo,
						:ls_caitemCode,
						:ls_caserialNo,
						:ls_origAssigned,
						:ls_acquisitionTypeCode,
						:gs_username,
						getdate(),
						:gs_divisionCode,
						:gs_companyCode,
						null,
						:ls_packageCode,
						:luo_jo.acctNo,
						:ls_isPrimary)
				using SQLCA;
		if SQLCA.sqlcode <> 0 then
			is_msgno = "SM-0000001"
			is_msgtrail = string(SQLCA.sqlcode) + "~r~n" + SQLCA.sqlerrtext
			is_sugtrail = ""
			return -1
		end if	
	end if
	
NEXT

ll_records = dw_detail.rowcount()
for ll_row = 1 to ll_records
	
	ls_serialNo 				= trim(dw_detail.object.serialNo[ll_row])
	ls_caSerialNo 				= trim(dw_detail.object.caserialNo[ll_row])
	ls_newSerialNo			   = trim(dw_detail.object.newSerialNo[ll_row])
	ls_newCASerialNo			= trim(dw_detail.object.newcaSerialNo[ll_row])
	ls_newRecord				= trim(dw_detail.object.newRecord[ll_row])
	ls_selected					= trim(dw_detail.object.selected[ll_row])
	ls_packageCode			   = trim(dw_detail.object.packageCode[ll_row])
	
	if (isnull(ls_serialNo)  and isNull(ls_caSerialNo) ) and  (isnull(ls_newSerialNo)  and isNull(ls_newCASerialNo) ) then
		continue
	end if
	
	if ls_selected = 'Y' and not IsNull(ls_newSerialNo) then

		
		--zar 06222010
		if not iuo_cpe.takePlaceInJOAssignedDigiPick(ls_serialNo, ls_caSerialNo, ls_newSerialNo, ls_newCASerialNo, is_joNo) then
			is_msgno = "SM-0000001"
			is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
			is_sugtrail = ""
			return -1
		end if			
		
		ls_serialNo = ls_newSerialNo			
	end if
	
	if not iuo_cpe.setSerialNo(ls_serialNo) then
		is_msgno = "SM-0000001"
		is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
		is_sugtrail = ""
		return -1
	end IF
	
	--valdasi iuo_cpe.setSerialNo(ls_serialNo)
	RETURN TRUE
	
	if not iuo_cpe.insertIntoSTBPackages(luo_subscriber.acctNo, ls_packageCode, today(), ldt_nullDate, 'ASSIGN SBT TO E-JO') then
		is_msgno = "SM-0000001"
		is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
		is_sugtrail = 'Object.Method: iuo_cpe.insertIntoSTBPackages()'
		return -1
	end IF
	
	--VALIDASI iuo_cpe.insertIntoSTBPackages(luo_subscriber.acctNo, ls_packageCode, today(), ldt_nullDate, 'ASSIGN SBT TO E-JO')
	
	==================================================
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
	 	and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	and packageCode = :as_packageCode
	 using SQLCA;
	if SQLCA.sqlNRows <= 0 then 		
	
		insert into stbPackages (
						serialNo,
						packageCode,
						boxIdNo,
						itemCode,
						controlNo,
						acctNo,
						dateLoaded,
						expirationDate,
						remarks,
						divisionCode,
						companyCode)
			  values (
						:serialNo,
						:as_packageCode,
						:boxIdNo,
						:itemCode,
						:controlNo,
						:as_acctNo,
						:adt_dateLoaded,
						:adt_expirationDate,
						:as_remarks,
						:gs_divisionCode,
						:gs_companyCode)
				using SQLCA;
		if SQLCA.sqlcode < 0 then
			lastSQLCode 	= string(SQLCA.sqlCode)
			lastSQLErrText = SQLCA.sqlErrText
			return FALSE
		end if
		
	end if
	
	return TRUE
	----------------------------
	
	--iuo_cpe.incrementscsrequesttranno( )
	scsRequestNextTranNo++
	
	if not iuo_cpe.initialize() then
		is_msgno = 'SM-0000001'
		is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
		is_sugtrail = 'Error produced by iuo_cpe.initialize()'
	end IF
	
	---VALIDASI iuo_cpe.initialize()	
	if f_scsControllerEnabled() THEN
		--VALIDASI f_scsControllerEnabled
	
		long ll_count
		select count(*)
		  into :ll_count
		  from sysParamString
		 where itemName = 'STBCONTROLLER'
			and itemValue = 'SCS'
		 and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;
		if isNull(ll_count) then ll_count = 0
		if SQLCA.sqlCode = 0 and ll_count > 0 then
			Return True
		end if
		
		Return False		
		------------
		
		string 	lsa_line_details[], ls_convertedSno, ls_command, ls_boxNo
		string	as_channelType, ls_tiers
		integer 	li_ctr
		
		if boxIdNo < 1 then
			lastSQLCode = '-2'
			lastSQLErrText = 'Unable to initialize 0 box Id No.' + '~r~n~r~n' + &
									'Assigning of Box ID No. is required for newly received STB(s).'
			Return False
		end if
		
		--let's store 86 as default channel type
		--this is supposed to be an argument passed to this function
		as_channelType = '115'
		
		ls_convertedSno = convertSerialNo(serialNo)
		
		ls_command = ''
		generateBoxIDCommand(boxIdNo, ls_command)
		ls_command = trim(ls_command)
		ls_boxNo    = trim(string(boxIdNo))
		
		if isnull(as_channelType) or trim(as_channelType) = '' then	as_channelType = '86'
		
		li_ctr = 0
		
		lsa_line_details[upperbound(lsa_line_details) + 1] = "DE/"+ls_boxNo
		lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;93;" + ls_command 
		lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;5F;" + ls_command +";"+ ls_convertedSno + "D8;D0;C8;C0"
		lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4F;" + ls_command +";18;10;08;00"
		
		lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/F9;D8;D0;C8;C0;" + ls_command 
		lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/F9;D8;D0;C8;C0;" + ls_command 
		lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/F9;D8;D0;C8;C0;" + ls_command 
		lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;8C;"+ls_command+";7F;07;0A"
		lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FE;"+ls_command							
		lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;8D;"+ls_command
		lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;44;"+ls_command+";00;00"
		lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;95;"+ls_command+";40"
		lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;47;"+ls_command+";BF"		
		lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;96;"+ls_command+";0E"
		
		lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4A;"+ls_command+";FF"
		lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;49;"+ls_command+";00"
		lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;98;"+ls_command+";03;00;00;00"
		lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4B;"+ls_command+";BF"
		lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;48;"+ls_command+";00"
		lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/E9;"+ls_command+";FF"  
		lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/EA;"+ls_command+";FF"	 					  
		lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;8E;"+ls_command							  
		lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;50;"+ls_command+";00"
		lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4D;"+ls_command+";00;00;03;03;02;03;04;05;06;07"
		
		lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4D;"+ls_command+";01;00;08;09;0A;0B;0C;0D;0E;0F"
		lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4D;"+ls_command+";02;00;10;11;12;13;14;15;16;17"
		lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4D;"+ls_command+";03;00;18;19;1a;1b;1c;1d;1e;1f"
		lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4D;"+ls_command+";04;00;20;21;22;23;24;25;26;27"
		lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4D;"+ls_command+";05;00;28;29;2A;2B;2C;2D;2E;2F"
		lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4D;"+ls_command+";06;00;30;31;32;33;34;35;36;37"
		lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4D;"+ls_command+";07;00;38;39;3A;3B;3C;3D;3E;3F"				
		lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4D;"+ls_command+";08;00;40;41;42;43;44;45;46;47"
		lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4D;"+ls_command+";09;00;48;49;4A;4B;4C;4D;4E;4F"
		lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4D;"+ls_command+";0A;00;50;51;52;53;54;55;56;57"
		
		// line 41
		lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4D;"+ls_command+";0B;00;58;59;5A;5B;5C;5D;5E;5F" 
		
		Choose case as_channelType
			Case '115'
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4C;"+ls_command+";0C;00;60;62;62;63;64;65;66;67"		
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4C;"+ls_command+";0D;00;68;69;6A;6B;6C;6D;6E;6F"
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4C;"+ls_command+";0E;00;70;71;72;73;7F;7F;7F;7F"
			Case '102'
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4D;"+ls_command+";0C;00;60;62;62;63;64;65;66;7F"
			Case '100'
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4D;"+ls_command+";0C;00;60;62;62;63;64;7F;7F;7F"
			Case Else 
				//--86 channels
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4C;"+ls_command+";0C;0F;60;62;62;63;64;7F;7F;7F"
		End choose
			
		Choose case as_channelType
			Case '115'
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4D;"+ls_command+";1F;0F;7F;7F;7F;7F;02;03;73;73"
			Case '102'
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4C;"+ls_command+";1F;0F;7F;7F;7F;7F;02;03;66;66" 
			Case '100'
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4D;"+ls_command+";1F;0F;7F;7F;7F;7F;02;03;63;63"
			Case Else 
				//--86 channels
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4D;"+ls_command+";1F;0F;7F;7F;7F;7F;02;03;56;63"
		End choose
		
		lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4E;"+ls_command+";40"
		lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4E;"+ls_command+";18"
		lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/F9;"+ls_command+";D8;D0;C8;C0"
		lsa_line_details[upperbound(lsa_line_details) + 1] = "AU/"+ls_boxNo
		
		if isnull(tiers) or tiers = '' then	
			if not getTiers(tiers) then
				Return False
			end if
		end if
		
		tiers = trim(tiers)
		
		if tiers = '' then
			lastSQLCode = '-2'
			lastSQLErrText = 'Unable to continue. The box being initialized has no tier.' + '~r~n~r~n' + &
									'Check the package of the subscriber if it has tiers assigned.'
		
			string ls_packages
			integer i					
			for i = 1 to upperBound(str_stbPackages)
				ls_packages = '~t' + str_stbPackages[i].packageCode + '~r~n'
			next
			if isNull(ls_packages) then ls_packages = ''
			
			if ls_packages <> '' then
				lastSQLErrText = lastSQLErrText + '~r~n' + &
									  'Loaded Packages : ' + '~r~n' + &
									  ls_packages
			end if
									
			Return False
		end if
		
		lsa_line_details[upperbound(lsa_line_details) + 1] = "AD/"+ls_boxNo + ';' + tiers
		
		if not postSCSRequest(lsa_line_details, 'ST') then
			Return False
		end IF
		
		--VALIDASI postSCSRequest(lsa_line_details, 'ST')
		string ls_xacctNo

		if isnull(acctNo) then
			ls_xacctNo = ''
		else
			ls_xacctNo = acctNo
		end if

	    --==================================================
		--PRE-REQUISITE:
		--scsRequestSourceTransaction
		--scsRequestNextTranNo
		--let's check if the scsRequestSourceTransaction
		--and scsRequestNextTranNo was set.
		--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		if isnull(scsRequestSourceTransaction) or trim(scsRequestSourceTransaction) = '' then
			lastSQLCode 	= '-2'
			lastSQLErrText = "Unable to continue, scsRequestSourceTransaction was not set"
			Return False
		end if
		if isnull(scsRequestNextTranNo) or scsRequestNextTranNo < 0 then
			lastSQLCode 	= '-2'
			lastSQLErrText = "Unable to continue, scsRequestNextTranNo was not set"
			Return False
		end IF
		
		--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		
		string	ls_tranNo, ls_tranNo2
		datetime	ldt_tranDate
		scsRequestNextTranNo = scsRequestNextTranNo + 1
		ls_tranno 		= string(scsRequestNextTranNo, "00000000")
		ldt_tranDate 	= guo_func.get_server_date()
		
		--==================================================
		--set it to 'Y' by default to avoid immediate
		--processing
		--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		
		insert into scsRequestHdr (
						tranNo,
						tranDate,
						acctNo,
						boxIDNo,
						serialNo,
						sourceTransaction,
						uploaded,
						requestType,
						userAdd,
						dateAdd,
						companyCode,
						divisionCode)
			  values (
						:ls_tranNo,
						:ldt_tranDate,
						:acctNo,
						:boxIDNo,
						:serialNo,
						:scsRequestSourceTransaction,
						'Y',
						:as_requestType,
						:gs_userName,
						getdate(),
						:gs_companyCode,
						:gs_divisionCode)
				using SQLCA;
		if SQLCA.sqlcode <> 0 then
			lastSQLCode = string(SQLCA.sqlcode)
			lastSQLErrText = SQLCA.sqlerrtext + '~r~n' + 'insert into scsRequestHdr'
			Return False
		end if
		
		integer li_lineNo
		for li_lineNo = 1 to upperbound(as_lineDetails)
			insert into scsRequestDtl (
							tranNo,
							reqString,
							reqLineNo,
							companyCode,
							divisionCode)
				  values (
							:ls_tranNo,
							:as_lineDetails[li_lineNo],
							:li_lineNo,
							:gs_companyCode,
							:gs_divisionCode)
					using SQLCA;
			if SQLCA.sqlcode <> 0 then
				lastSQLCode = string(SQLCA.sqlcode)
				lastSQLErrText = SQLCA.sqlerrtext + '~r~n' + 'insert into scsRequestDtl'
				return FALSE
			end if
		next					
		
		--==================================================
		--do not allow the cable box from clc database to be
		--processed by the scs
		--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		
		long ll_scsMaxBoxID
		f_getSCSMaxBoxID(ll_scsMaxBoxID)
		
		--VALIDASI GET f_getSCSMaxBoxID(ll_scsMaxBoxID)
		
		select scsMaxBoxID
		  into :al_scsMaxBoxID
		  from systemParameter
		 where divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;
		if SQLCA.sqlCode < 0 then
			return FALSE	
		end if
		return TRUE
		--------------------------------------
				
		if isNull(ll_scsMaxBoxID) then ll_scsMaxBoxID = 0
		
		if boxIdNo > ll_scsMaxBoxID and ll_scsMaxBoxID > 0 then
			Return True
		end if
		
		if upper(gs_sourceDatabase) = 'IBAS_PROSAT' and boxIdNo < 66001 then
			Return True
		end IF
		
		--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		
		update scsRequestHdr
			set uploaded = 'N'
		 where tranNo = :ls_tranNo
		  and  companyCode = :gs_companyCode
		  and  divisionCode = :gs_divisionCode
		 using SQLCA;
		if SQLCA.sqlcode <> 0 then
			lastSQLCode = string(SQLCA.sqlcode)
			lastSQLErrText = SQLCA.sqlerrtext + '~r~n' + 'update scsRequestHdr'
			Return False
		end if
		
		Return TRUE
		-----------------------
		
	else	
		
		if isDigital = 'Y' or isCaCard = 'Y' then
			/// closed due to testing, hehehe
			if not entitle() then
				return false
			end if	
		else
			if not csbInitializeSTB() then
				Return False
			end if		
		end if	
	end if	
	
	Return TRUE
	-----------------------

	
next

if not iuo_cpe.setSCSRequestTranNo() then
	is_msgno = 'SM-0000001'
	is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
	is_sugtrail = 'Error produced by iuo_cpe.setSCSRequestTranNo()'
	return -1
end IF

--VALIDASI  iuo_cpe.setSCSRequestTranNo()
-- guo_func.set_number('SCSREQUEST', scsRequestNextTranNo)
--SET VALUE guo_func.set_number('SCSREQUEST', scsRequestNextTranNo)

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
---------------------------


is_msgno = "SM-0000002"
is_msgtrail = ""
is_sugtrail = ""

return 0

return 0




