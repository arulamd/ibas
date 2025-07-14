--PROSES assign_cpe_to_jo

--lstr_jo.joNo 				= dw_jo.getitemstring(dw_jo.getrow(), "jono")
--lstr_jo.serviceType 	= dw_jo.getitemstring(dw_jo.getrow(), "servicetype")
--lstr_jo.isDigital		 	= dw_jo.getitemstring(dw_jo.getrow(), "isdigital")
--lstr_jo.tranTypeCode 	= dw_jo.getitemstring(dw_jo.getrow(), "tranTypeCode")
--lstr_jo.jostatuscode = dw_jo.getitemstring(dw_jo.getrow(), "jostatuscode")

--if lstr_jo.tranTypeCode = 'ADDONP'  or lstr_jo.tranTypeCode = 'ADDOND' or lstr_jo.tranTypeCode = 'ADDONDI' or lstr_jo.tranTypeCode = 'HBDO' or lstr_jo.tranTypeCode = 'HBDI' then 
--openwithparm(w_assign_cpe_to_jo_add_on, lstr_jo)
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

--if is_serviceType = 'CTV' and is_isDigital <> 'Y' then
--if parent.trigger Event ue_save() = 0 then

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
	end if
	iuo_cpe = CREATE USING ls_objectname
	
	linemanCode = trim(linemanCode)
	statusCode = trim(statusCode)
	tranTypeCode = trim(tranTypeCode)
	
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
	
	
	
	----NEXT PROSESS
	
	-- QUEERY Dw HEADER 
	 SELECT  joTranHdr.joNo ,
           joTranHdr.joDate ,
           joTranHdr.tranTypeCode ,
           joTranHdr.acctNo ,
           joTranHdr.linemanCode ,
           joTranHdr.referenceNo ,
           joTranHdr.joStatusCode,
			  '' subscribername ,
	 arPackageMaster.packageName    
        FROM joTranHdr      
	inner join arAcctSubscriber  on joTranHdr.acctno = arAcctSubscriber.acctNo 
		and joTranHdr.divisionCode = arAcctSubscriber.divisionCode and joTranHdr.companyCode = arAcctSubscriber.companyCode
	inner join arPackageMaster  on arAcctSubscriber.packageCode = arPackageMaster.packageCode 
		and arPackageMaster.divisionCode = arAcctSubscriber.divisionCode and arPackageMaster.companyCode = arAcctSubscriber.companyCode
        WHERE ( joTranHdr.joNo = :as_jono ) and (joTranHdr.divisionCode = :as_division) and (joTranHdr.companyCode = :as_company) 
        
	 -- QUEERY Dw detail
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
		ls_newSerialNo	= trim(dw_detail.object.newSerialNo[ll_row])	
		
		if isnull(ls_serialNo) then continue
		//if not isnull(ls_newSerialNo) then continue
		
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
	
	Return TRUE
	
	--GET NEXT NUMBER if not guo_func.get_nextnumber('SCSREQUEST', ll_tranno, 'WITH LOCK')
	
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
				--if SQLCA.sqlnrows < 1 then
				--	if guo_func.msgbox("SM-0000011", ls_lockedby, "") = 2 then
				--		f_closeStatus()
				--		return false
		 		--	end if
				--else
				--	exit
				--end if
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
		--f_closeStatus()
		
		--return true
		
		--VALIDASI iuo_cpe.decrementscsnexttranno( )
		scsRequestNextTranNo --
		
		
		--VALIDASI iuo_cpe.setSCSRequestSource('ASSIGNTOEJO')
		
		scsRequestSourceTransaction 	= as_sourceTransaction -- 'ASSIGNTOEJO'
		
		--PROSES CPE TO JO		
		is_joNo = dw_header.getitemstring(1, "jono")

		ll_records = dw_detail.rowcount()
		for ll_row = 1 to ll_records
			
			ls_serialNo 				= trim(dw_detail.object.serialNo[ll_row])
			ls_itemCode 				= trim(dw_detail.object.itemCode[ll_row])
			ls_macAddress 				= trim(dw_detail.object.macAddress[ll_row])
			ls_newItemCode			= trim(dw_detail.object.newItemCode[ll_row])
			ls_newSerialNo			= trim(dw_detail.object.newSerialNo[ll_row])
			ls_origAssigned			= trim(dw_detail.object.originalassignedcpe[ll_row])
			ls_newRecord				= trim(dw_detail.object.newRecord[ll_row])
			ls_acquisitionTypeCode 	= trim(dw_detail.object.acquisitionTypeCode[ll_row])
			ls_selected				 	= trim(dw_detail.object.selected[ll_row])
			ls_isPrimary			   = 'Y' //trim(dw_detail.object.isprimary[ll_row])
			
			if isnull(ls_serialNo) or ls_serialNo = '' then continue
		
			if not iuo_cpe.setSerialNo(ls_serialNo) then
				is_msgno = "SM-0000001"
				is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
				is_sugtrail = ""
				return -1
			end if	
			
			--IF SERVICE TYPE = 'INET'
			--VALIDASI iuo_cpe.setSerialNo(ls_serialNo)
			
			serialNo = trim(as_serialno)

			// check if existing
			if gb_sharedInventory then
				select a.itemCode, a.barCode, a.controlNo, a.locationCode, a.serialNoStatusCode, a.acctNo, a.macAddress, b.itemName, 
							b.productLineCode, b.model, b.voltage, a.boxIdNo, b.isiptv
				  into :itemCode, :barCode, :controlNo, :locationCode, :statusCode, :acctNo, :macAddress, :itemName, 
						 :productLineCode, :model, :voltage, :boxIdNo, :isiptv
				  from serialNoMaster a, itemMaster b
				 where a.itemCode = b.itemCode
					and a.serialNo = :serialNo
					and b.itemIsCableModem = 'Y'
					and b.companyCode = :gs_companyCode
					and a.companyCode = :gs_companyCode		
					and a.divisionCode in (select divisionCode
												  from   sysDivisionGroupMembersIC
												  where  divisionGroupCode = :gs_divisionGroupCode)
			 using SQLCA;
			else
				select a.itemCode, a.barCode, a.controlNo, a.locationCode, a.serialNoStatusCode, a.acctNo, a.macAddress, b.itemName, 
							b.productLineCode, b.model, b.voltage, a.boxIdNo, b.isiptv
				  into :itemCode, :barCode, :controlNo, :locationCode, :statusCode, :acctNo, :macAddress, :itemName, 
						 :productLineCode, :model, :voltage, :boxIdNo, :isiptv
				  from serialNoMaster a, itemMaster b
				 where a.itemCode = b.itemCode
				 	and a.companyCode = b.companyCode
					and a.serialNo = :serialNo
					and b.itemIsCableModem = 'Y'
					and a.divisionCode = :gs_divisionCode
					and b.companyCode = :gs_companyCode
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
			
			select acquisitionTypeCode, cpeStatusCode 
			into :acquisitionTypeCode, :subscriberCPEStatus
			from subscriberCPEMaster    
			where serialNo = :serialNo
			and   companyCode = :gs_companyCode
			and   divisionCode = :gs_divisionCode
			using SQLCA;
			if SQLCA.sqlcode < 0 then
				lastSQLCode		= string(SQLCA.sqlcode)
				lastSQLErrText = SQLCA.sqlerrtext
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
			
			select acquisitionTypeCode, dateAcquired, packageCode, isPrimary 
			  into :acquisitionTypeCode, :dateAcquired, :packageCode, :isPrimary
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
				return TRUE
			end if
			
			currAcctNo = acctNo
			cpeType = 'CM'
			return TRUE
			-----------------------
			
			--IF SERVICE TYPE = 'CTV'
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
			------------------------
		
		
			if not iuo_cpe.preAssignToSubscriber(luo_subscriber.acctNo) then
				is_msgno = "SM-0000001"
				is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
				is_sugtrail = 'Object.Method: iuo_cpe.preAssignToSubscriber()'
				return -1
			end IF
			
			--VALIDASI iuo_cpe.preAssignToSubscriber(luo_subscriber.acctNo)
			
			acctNo = as_acctNo --luo_subscriber.acctNo

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
			--------------------------------
			
			if not isNull(ls_newItemCode) then
				
				update joTranDtlAssignedCPE 
					set newItemCode 			= :ls_newItemCode,
						 newSerialNo			= :ls_newSerialNo,
						 acquisitionTypeCode 	= :ls_acquisitionTypeCode,
						 lastAssignedBy		= :gs_username,
						 lastAssignedDate 		= getdate()
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
				 
				if not iuo_cpe.cancelPreAssignment() then
					is_msgno = "SM-0000001"
					is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
					is_sugtrail = 'Object.Method: iuo_cpe.preAssignToSubscriber()'
					return -1
				end if
				if not iuo_cpe.setSerialNo(ls_newserialNo) then
					is_msgno = "SM-0000001"
					is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
					is_sugtrail = ""
					return -1
				end if	
			
			
			   string ls_currLocName
			
				if is_joStatusCode = 'FR' then
				
					if upper(iuo_cpe.locationCode) <> upper(is_wsdeflocationCode) then
						
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
					
					if upper(iuo_cpe.locationCode) <> upper(luo_jo.lineManCode) then
						
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
				acctNo = as_acctNo --luo_subscriber.acctNo

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
				---------------------
				
				--now, we have to deactivate replaced box 
				--PRE-REQUISITE: scsRequestNextTranNo and scsRequestSourceTransaction (#2)
				--must be set outside the loop if any
				
				--iuo_cpe.incrementscsrequesttranno( )
				--if not iuo_cpe.deactivate() then
				--	is_msgno = "SM-0000001"
				--	is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
				--	is_sugtrail = 'Error produced by iuo_cpe.deactivate()'
				--	return -1
				--end if
				// --------[ end of prerequisite (#2) ]--------
				
				--VALIDASI iuo_cpe.incrementscsrequesttranno( )
				scsRequestNextTranNo++
				
				--VALIDASI iuo_cpe.deactivate()
				
				--CHECK VALIDASI f_scsControllerEnabled
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
				
				Return FALSE
				
				--IF TRUE THEN CONTINUE f_scsControllerEnabled
				If f_scsControllerEnabled() then
					string	lsa_line_details[]
					lsa_line_details[1] = 'DE/'+trim(string(boxIDNo))
					if not postSCSRequest(lsa_line_details, 'DE') then
						Return False
					end IF	
					
					--VALIDASI if not postSCSRequest(lsa_line_details, 'DE') 
					
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
					end if
					// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
					
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
					
					--GET VALUE f_getSCSMaxBoxID(ll_scsMaxBoxID)
			
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
					---------------------------
					
					if isNull(ll_scsMaxBoxID) then ll_scsMaxBoxID = 0
					
					if boxIdNo > ll_scsMaxBoxID and ll_scsMaxBoxID > 0 then
						Return True
					end if
					
					if upper(gs_sourceDatabase) = 'IBAS_PROSAT' and boxIdNo < 66001 then
						Return True
					end if
					// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
					
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
					
					Return True
					----------------------
					
					string ls_xacctNo

					if isnull(acctNo) then
						ls_xacctNo = ''
					else
						ls_xacctNo = acctNo
					end if
					
					if isnull(scsRequestSourceTransaction) or trim(scsRequestSourceTransaction) = '' then
						lastSQLCode 	= '-2'
						lastSQLErrText = "Unable to continue, scsRequestSourceTransaction was not set"
						Return False
					end if
					if isnull(scsRequestNextTranNo) or scsRequestNextTranNo < 0 then
						lastSQLCode 	= '-2'
						lastSQLErrText = "Unable to continue, scsRequestNextTranNo was not set"
						Return False
					end if
					
					string	ls_tranNo, ls_tranNo2
					datetime	ldt_tranDate
					scsRequestNextTranNo = scsRequestNextTranNo + 1
					ls_tranno 		= string(scsRequestNextTranNo, "00000000")
					ldt_tranDate 	= guo_func.get_server_date()
					
					
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
					
				
					long ll_scsMaxBoxID
					f_getSCSMaxBoxID(ll_scsMaxBoxID)
					if isNull(ll_scsMaxBoxID) then ll_scsMaxBoxID = 0
					
					if boxIdNo > ll_scsMaxBoxID and ll_scsMaxBoxID > 0 then
						Return True
					end if
					
					if upper(gs_sourceDatabase) = 'IBAS_PROSAT' and boxIdNo < 66001 then
						Return True
					end if
					
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
					
					Return True
										
				else	
					if isDigital = 'Y' or isCaCard = 'Y' then
						/// closed for a while due to testing, hehehehe
						if not unEntitle() then
							return false
						end if	
					else	
						if not csbShutDownSTB() then
							return FALSE
						end if
					end if
				end if
					
				Return True
				
				
				
				--if not iuo_cpe.deleteFromSTBPackages() then
				--	is_msgno = "SM-0000001"
				--	is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
				--	is_sugtrail = "Method: iuo_cpe.deleteFromSTBPackages()"
				--	return -1
				--end IF
				
				--VALIDASI  not iuo_cpe.deleteFromSTBPackages()
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
				
				
				--VALIDASI luo_subscriber.chargeTypeCode = 'PPS'
				if luo_subscriber.chargeTypeCode = 'PPS' then
					--if not iuo_cpe.takePlaceInSTBPPCLoad(ls_newSerialNo) then
					--	is_msgno = "SM-0000001"
					--	is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
					--	is_sugtrail = "Method: iuo_cpe.takePlaceInSTBPPCLoad()"
					--	return -1
					--end IF
					
					--VALIDASI if not iuo_cpe.takePlaceInSTBPPCLoad(ls_newSerialNo)
					--as_newSerialNo = ls_newSerialNo
					
					update cpePrepaidLoad
						set serialNo = :as_newSerialNo
					 where serialNo = :serialNo
					 and divisionCode = :gs_divisionCode
					and companyCode = :gs_companyCode
					using SQLCA;
					if SQLCA.sqlcode < 0 then
						lastSQLCode		= string(SQLCA.sqlcode)
						lastSQLErrText = SQLCA.sqlerrtext
						return FALSE
					end if
					
					return TRUE
					
				end if
				
			end if
			
			if ls_selected = 'Y' then
				ls_origAssigned 	= 'N'
				ls_serialNo 	 	= ls_newSerialNo
			end if
			
			if ls_newRecord = 'Y' or not IsNull(ls_newSerialNo)  then
				
				insert into joTranDtlAssignedCPE (
								joNo,
								itemCode,
								serialNo,
								originalAssignedCPE,
								acquisitionTypeCode,
								lastAssignedBy,
								lastAssignedDate,
								divisionCode,
								companyCode,
								macAddress,
								packageCode,
								isPrimary)
					  values (
								:is_joNo,
								:ls_itemCode,
								:ls_serialNo,
								:ls_origAssigned,
								:ls_acquisitionTypeCode,
								:gs_username,
								getdate(),
								:gs_divisionCode,
								:gs_companyCode,
								null,
								:luo_subscriber.packageCode,
								:ls_isPrimary)
						using SQLCA;
				if SQLCA.sqlcode <> 0 then
					is_msgno = "SM-0000001"
					is_msgtrail = string(SQLCA.sqlcode) + "~r~n" + SQLCA.sqlerrtext
					is_sugtrail = ""
					return -1
				end if
				
				
				insert into JOTRANDDTLASSIGNEDCPETRAIL (
								joNo,
								itemCode,
								serialNo,
								originalAssignedCPE,
								acquisitionTypeCode,
								lastAssignedBy,
								lastAssignedDate,
								divisionCode,
								companyCode,
								macAddress,
								packageCode,
								isPrimary)
					  values (
								:is_joNo,
								:ls_itemCode,
								:ls_serialNo,
								:ls_origAssigned,
								:ls_acquisitionTypeCode,
								:gs_username,
								getdate(),
								:gs_divisionCode,
								:gs_companyCode,
								null,
								:luo_subscriber.packageCode,
								:ls_isPrimary)
						using SQLCA;
				if SQLCA.sqlcode <> 0 then
					is_msgno = "SM-0000001"
					is_msgtrail = string(SQLCA.sqlcode) + "~r~n" + SQLCA.sqlerrtext
					is_sugtrail = ""
					return -1
				end if
				
				if luo_subscriber.chargeTypeCode = 'PPS' then
					// ====================================================
					// allow only 3 days before expiration for prepaid subs
					// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
					ldt_nullDate = relativeDate(today(), 3)
				end if
		
				if not iuo_cpe.insertIntoSTBPackages(luo_subscriber.acctNo, luo_subscriber.packageCode, today(), ldt_nullDate, 'ASSIGN SBT TO E-JO') then
					is_msgno = "SM-0000001"
					is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
					is_sugtrail = 'Object.Method: iuo_cpe.insertIntoSTBPackages()'
					return -1
				end IF
				
				--VALIDASI iuo_cpe.insertIntoSTBPackages(luo_subscriber.acctNo, luo_subscriber.packageCode, today(), ldt_nullDate, 'ASSIGN SBT TO E-JO')
				
				--string as_acctno
				--string as_packagecode
				--date adt_dateloaded
				--adt_expirationdate
				--as_remarks
				 
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
				
				--====================================================
				--since this box is just assigned, let's initialize it
				 
				
				--PRE-REQUISITE: scsRequestNextTranNo and scsRequestSourceTransaction (#2)
				--must be set outside the loop if any

				iuo_cpe.incrementscsrequesttranno( )
				if not iuo_cpe.initialize() then
					is_msgno = "SM-0000001"
					is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
					is_sugtrail = 'Error produced by iuo_cpe.initialize()'
					return -1
				end IF
				
				--VALIDASI iuo_cpe.incrementscsrequesttranno( )
				scsRequestNextTranNo++
				
				
						
			end if
		next

		--if not iuo_cpe.setSCSRequestTranNo() then
		--	is_msgno = 'SM-0000001'
		--	is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
		--	is_sugtrail = 'Error produced by iuo_cpe.setSCSRequestTranNo()'
		--	return -1
		--end if	
	
		
		--VALIDASI if not iuo_cpe.setSCSRequestTranNo()
		
		--if not guo_func.set_number('SCSREQUEST', scsRequestNextTranNo) then	
		--	lastSQLCode = '-2'
		--	lastSQLErrText = 'Could not set the next SCS Request No.'
		--	Return False
		--end if		
		
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



