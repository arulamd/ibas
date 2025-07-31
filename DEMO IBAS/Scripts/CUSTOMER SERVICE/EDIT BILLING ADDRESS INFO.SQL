--QUERY FORM
  SELECT  arAcctSubscriber.acctno ,  
         		arAcctSubscriber.firstname , 
          		arAcctSubscriber.middlename , 
          		arAcctSubscriber.mothermaidenname ,
           		arAcctSubscriber.lastname ,       
    				arAcctSubscriber.sex ,           
					arAcctSubscriber.citizenshipcode ,           
					arAcctSubscriber.birthdate ,           
					arAcctSubscriber.civilstatus ,          
					arAcctSubscriber.telno ,           
					arAcctSubscriber.mobileno ,           
					arAcctSubscriber.faxno ,           
					arAcctSubscriber.emailaddress ,       
					arAcctSubscriber.emailaddress2 , 
					arAcctSubscriber.emailaddress3 ,     
					service.houseno ,           
					service.streetname ,          
					billing.contactNo ,     
					billing.contactName ,      
					billing.houseNo ,           
					billing.streetName ,         
					billing.lotNo ,           
					billing.blkNo ,           
					service.blkNo ,          
					service.phaseNo ,           
					service.district ,           
					service.purokNo ,          
					service.subdivisioncode ,        
					'' sSubdivisionName,          
					service.barangaycode ,    
					'' sbarangayName,         
					service.municipalitycode ,       
					'' smunicipalityName,          
					service.provincecode ,          
					'' sprovinceName,        
					billing.phaseno ,        
					billing.district ,     
					billing.purokNo ,   
					service.lotNo , 
					billing.SubdivisionCode ,
           		'' bSubdivisionName,           
					billing.BarangayCode ,           
					'' bbarangayName,           
					billing.MunicipalityCode ,           
					'' bmunicipalityName,          
 					billing.ProvinceCode ,           
					'' bprovinceName,           
					arAcctSubscriber.tranno ,          
					arAcctSubscriber.useradd ,          
					arAcctSubscriber.dateadd ,          
					'' serviceAddressComplete,           
					'' billingAddressComplete,           
               service.bldgName ,           
					billing.bldgName ,
					arAcctSubscriber.substypeCode,
					arAcctSubscriber.subscriberName ,
					arAcctSubscriber.mobileno2,
					arAcctSubscriber.mobileno3,
					arAcctSubscriber.nameofCompany,
					arAcctSubscriber.Guarantor,
					arAcctSubscriber.spouseName
FROM arAcctSubscriber
inner join vw_arAcctAddress billing on arAcctSubscriber.acctNo = billing.acctNo and billing.addressTypeCode = 'BILLING'
inner join vw_arAcctAddress service on arAcctSubscriber.acctNo = service.acctNo and service.addressTypeCode = 'SERVADR1'


--EVENT BUTTON CLICK

this.acceptText()
if dwo.name = "b_billname" then
	copybilledto()
elseif dwo.name = "b_billaddress" then	
	copyserviceaddressinfo()
elseif dwo.name = "b_search" then	
	this.trigger dynamic event ue_search('acctno')
elseif dwo.name = "b_copyfromaddresstemp" then	//Additional button by: LD
	this.trigger dynamic event ue_copy_from_arAcctAddressTemp()
	
	--VALADISI UE_COPY_FROM 
	--Wayli 03-18-2010
		string ls_acctno, ls_contactNo, ls_contactName, ls_confirmed_SERVADR1, ls_confirmed_BILLING
		string ls_sLotNo, ls_sBlkNo, ls_sPhaseNo, ls_sDistrict, ls_sSubdivisionCode, ls_sBarangayCode, ls_sMunicipalityCode, ls_sProvinceCode, ls_sStreetName,ls_sBldgName, ls_sHouseNo, ls_sPurokNo
		String ls_bLotNo, ls_bBlkNo, ls_bPhaseNo, ls_bDistrict, ls_bSubdivisionCode, ls_bBarangayCode, ls_bMunicipalityCode, ls_bProvinceCode, ls_bStreetName,ls_bBldgName, ls_bHouseNo, ls_bPurokNo
		long ll_row
		
		ll_row = dw_header.getRow()
		ls_acctno = dw_header.getitemstring(ll_row,"acctno")
		
		select confirmed
		into :ls_confirmed_SERVADR1
		from arAcctAddressTemp
		where acctNo = :ls_acctno
		and addressTypeCode = 'SERVADR1'
		Using SQLCA;
		
		select confirmed
		into :ls_confirmed_BILLING
		from arAcctAddressTemp
		where acctNo = :ls_acctno
		and addressTypeCode = 'BILLING'
		Using SQLCA;
		
		If ls_confirmed_SERVADR1 = 'N' or ls_confirmed_BILLING = 'N' then
			select lotNo,
					blkNo,
					phaseNo,
					district,
					subdivisionCode,
					barangayCode,
					municipalityCode,
					provinceCode,
					streetName,
					bldgName,
					houseNo,
					purokNo,
					contactNo,
					contactName
			into :ls_sLotNo,
				  :ls_sBlkNo,
				  :ls_sPhaseNo,
				  :ls_sDistrict,
				  :ls_sSubdivisionCode,
				  :ls_sBarangayCode,
				  :ls_sMunicipalityCode,
				  :ls_sProvinceCode,
				  :ls_sStreetName,
				  :ls_sBldgName,
				  :ls_sHouseNo,
				  :ls_sPurokNo,
				  :ls_contactNo,
				  :ls_contactName
			from arAcctAddressTemp
			where acctNo = :ls_acctNo and addressTypeCode = 'SERVADR1'
				and divisionCode = :gs_divisionCode
				and companyCode = :gs_companyCode
			using SQLCA;
			if sqlca.sqlcode <> 0 then
				guo_func.msgbox("Error in Select of arAcctAddressTemp!, SERVADR1",sqlca.sqlerrtext)	
				return -1
			end if
			
			select lotNo,
				blkNo,
				phaseNo,
				district,
				subdivisionCode,
				barangayCode,
				municipalityCode,
				provinceCode,
				streetName,
				bldgName,
				houseNo,
				purokNo
			into :ls_bLotNo,
				  :ls_bBlkNo,
				  :ls_bPhaseNo,
				  :ls_bDistrict,
				  :ls_bSubdivisionCode,
				  :ls_bBarangayCode,
				  :ls_bMunicipalityCode,
				  :ls_bProvinceCode,
				  :ls_bStreetName,
				  :ls_bBldgName,
				  :ls_bHouseNo,
				  :ls_bPurokNo
			from arAcctAddressTemp
			where acctNo = :ls_acctNo and addressTypeCode = 'BILLING'
				and divisionCode = :gs_divisionCode
				and companyCode = :gs_companyCode
			using SQLCA;
			if sqlca.sqlcode <> 0 then
				guo_func.msgbox("Error in Select of arAcctAddressTemp!, BILLING",sqlca.sqlerrtext)	
				return -1
			end if	
		
			dw_header.setitem(ll_row, "servicehouseno", ls_sHouseNo)
			dw_header.setitem(ll_row, "serviceblkno", ls_sBlkNo)
			dw_header.setitem(ll_row, "servicelotno", ls_sLotNo)
			dw_header.setitem(ll_row, "servicestreetname", ls_sStreetName)
			dw_header.setitem(ll_row, "servicebldgname", ls_sBldgName)
			dw_header.setitem(ll_row, "servicepurokno", ls_sPurokNo)
			dw_header.setitem(ll_row, "servicephaseno", ls_sPhaseNo)
			dw_header.setitem(ll_row, "servicedistrict", ls_sDistrict)
			dw_header.setitem(ll_row, "servicesubdivisioncode", ls_sSubdivisionCode)
			dw_header.setitem(ll_row, "servicebarangaycode", ls_sBarangayCode)
			dw_header.setitem(ll_row, "servicemunicipalitycode", ls_sMunicipalityCode)
			dw_header.setitem(ll_row, "serviceprovincecode", ls_sProvinceCode)
			dw_header.setitem(ll_row, "billingContactNo", ls_contactNo)
			dw_header.setitem(ll_row, "billingContactName", ls_contactName)
			
			dw_header.setitem(ll_row, "billinghouseno", ls_bHouseNo)
			dw_header.setitem(ll_row, "billingblkno", ls_bBlkNo)
			dw_header.setitem(ll_row, "billinglotno", ls_bLotNo)
			dw_header.setitem(ll_row, "billingstreetname", ls_bStreetName)
			dw_header.setitem(ll_row, "billingbldgname", ls_bBldgName)
			dw_header.setitem(ll_row, "billingpurokno", ls_bPurokNo)
			dw_header.setitem(ll_row, "billingphaseno", ls_bPhaseNo)
			dw_header.setitem(ll_row, "billingdistrict", ls_bDistrict)
			dw_header.setitem(ll_row, "billingsubdivisioncode", ls_bSubdivisionCode)
			dw_header.setitem(ll_row, "billingbarangaycode", ls_bBarangayCode)
			dw_header.setitem(ll_row, "billingmunicipalitycode", ls_bMunicipalityCode)
			dw_header.setitem(ll_row, "billingprovincecode", ls_bProvinceCode)
				
		//	copyserviceaddressinfo2()
		else
				guo_func.msgbox("NO RECENT UPDATE!!!", "There's no changes made to this account.", sqlca.sqlerrtext)	
				return -1
		end if

	
	--END VALIDASI 
elseif dwo.name = "b_subd" then	
	this.trigger dynamic event ue_search('sSubd')
elseif dwo.name = "b_brgy" then	
	this.trigger dynamic event ue_search('sBrgy')	
elseif dwo.name = "b_muni" then	
	this.trigger dynamic event ue_search('sMuni')	
elseif dwo.name = "b_prov" then	
	this.trigger dynamic event ue_search('sProv')		
elseif dwo.name = "b_bsubd" then	
	this.trigger dynamic event ue_search('bSubd')
elseif dwo.name = "b_bbrgy" then	
	this.trigger dynamic event ue_search('bBrgy')	
elseif dwo.name = "b_bmuni" then	
	this.trigger dynamic event ue_search('bMuni')	
elseif dwo.name = "b_bprov" then	
	this.trigger dynamic event ue_search('bProv')		
end IF

--BUTTON b_search

str_search str_s
string ls_result
if as_search = 'acctno' then
	string		ls_acctno
	str_s.s_dataobject = "dw_search_subscribers_all"
	str_s.s_return_column = "acctno"
	str_s.s_title = "Search For Subscribers"
	str_s.serviceType = is_serviceType
	
	--QUERY SEARCH ACCTNO
	
	SELECT  arAcctSubscriber.subscribername ,
           arAcctSubscriber.acctno ,
           arAcctSubscriber.subscriberstatuscode     
        FROM arAcctSubscriber   
        
     --END 
	
	openwithparm(w_search_subscriber,str_s)
	
	ls_acctno = trim(message.stringparm)
	if ls_acctno <> '' then
		this.setitem(this.getrow(), "acctno", ls_acctno)
		
		uo_subscriber_def luo_subscriber
		luo_subscriber = create uo_subscriber_def
	
		if not luo_subscriber.setAcctNo(ls_acctno) then
			guo_func.msgbox("Warning!",luo_subscriber.lastSqlCode + "~r~n" + &
												luo_subscriber.lastSqlErrText)
			return -1
		end IF
		
		--VALIDASI luo_subscriber.setAcctNo
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
		
		--END VALIDASI 
		
		dw_header.setitem(1,"firstname",luo_subscriber.firstname)
		dw_header.setitem(1, "lastname", luo_subscriber.lastname )		
		dw_header.setitem(1, "middlename", luo_subscriber.middlename )	
		dw_header.setitem(1,"subscribername",luo_subscriber.subscribername)
		dw_header.setitem(1, "mothermaidenname", luo_subscriber.mothermaidenname )
		dw_header.setitem(1,"substypecode",luo_subscriber.substypecode)
		dw_header.setitem(1, "sex", luo_subscriber.sex )		
		dw_header.setitem(1, "birthdate", luo_subscriber.birthdate )		
		dw_header.setitem(1, "civilstatus", luo_subscriber.civilstatus )
		dw_header.setitem(1, "telno", luo_subscriber.telno )		
		dw_header.setitem(1, "mobileno", luo_subscriber.mobileno )	
		dw_header.setitem(1, "mobileno2", luo_subscriber.mobileno2 )
		dw_header.setitem(1, "mobileno3", luo_subscriber.mobileno3 )
		dw_header.setitem(1, "faxno", luo_subscriber.faxno )
		dw_header.setitem(1, "emailaddress", luo_subscriber.emailaddress )
		dw_header.setitem(1, "emailaddress2", luo_subscriber.emailaddress2 )
		dw_header.setitem(1, "emailaddress3", luo_subscriber.emailaddress3)
		dw_header.setitem(1, "nameofcompany", luo_subscriber.nameofcompany )
		dw_header.setitem(1, "guarantor", luo_subscriber.guarantor )
		dw_header.setitem(1, "spousename", luo_subscriber.spousename )
		dw_header.setitem(1, "citizenshipcode", luo_subscriber.citizenshipcode )
		
		dw_header.setitem(1, "billinghouseno", luo_subscriber.billinghouseno)
		dw_header.setitem(1, "billingblkno", luo_subscriber.billingblockno)
		dw_header.setitem(1, "billinglotno", luo_subscriber.billinglotno)
		dw_header.setitem(1, "billingstreetname", luo_subscriber.billingstreetname)
		
		dw_header.setitem(1, "billingpurokno", luo_subscriber.billingpurok)
		dw_header.setitem(1, "billingphaseno", luo_subscriber.billingphase)
		dw_header.setitem(1, "billingdistrict", luo_subscriber.billingdistrict)
		dw_header.setitem(1, "billingsubdivisioncode", luo_subscriber.billingsubdivisioncode)
		dw_header.setitem(1, "billingbarangaycode", luo_subscriber.billingbarangaycode)
		dw_header.setitem(1, "billingmunicipalitycode", luo_subscriber.billingmunicipalitycode)
		dw_header.setitem(1, "billingprovincecode", luo_subscriber.billingprovincecode)
		dw_header.setitem(1, "billingbldgname", luo_subscriber.billingbldgcompapartmentname)
		dw_header.setitem(1,"billingcontactname", luo_subscriber.billingcontactname)
		dw_header.setitem(1,"billingcontactno", luo_subscriber.billingcontactno)
		
		dw_header.setitem(1, "servicehouseno", luo_subscriber.servicehouseno)
		dw_header.setitem(1, "serviceblkno", luo_subscriber.serviceblockno)
		dw_header.setitem(1, "servicelotno", luo_subscriber.servicelotno)
		dw_header.setitem(1, "servicestreetname", luo_subscriber.servicestreetname)
		dw_header.setitem(1, "servicebldgname", luo_subscriber.servicebldgcompapartmentname)
		dw_header.setitem(1, "servicepurokno", luo_subscriber.servicepurok)
		dw_header.setitem(1, "servicephaseno", luo_subscriber.servicephase)
		dw_header.setitem(1, "servicedistrict", luo_subscriber.servicedistrict)
		dw_header.setitem(1, "servicesubdivisioncode", luo_subscriber.servicesubdivisioncode)
		dw_header.setitem(1, "servicebarangaycode", luo_subscriber.servicebarangaycode)
		dw_header.setitem(1, "servicemunicipalitycode", luo_subscriber.servicemunicipalitycode)
		dw_header.setitem(1, "serviceprovincecode", luo_subscriber.serviceprovincecode)

	end if	
end if
choose case as_search
case 	'sSubd','bSubd'
		str_s.s_dataobject = "dw_search_subdivision"
		str_s.s_return_column = "subdivisionCode"
		str_s.s_title = "Search For Subdivision"
		
		--QUERY SERACH
		SELECT  subdivisionMaster.subdivisionName,
			subdivisionMaster.subdivisionCode
        FROM subdivisionMaster
        --END
        
		openwithparm(w_search_ancestor,str_s)
		
		ls_result = trim(message.stringparm)
		
		if ls_result <> '' then			
			if as_search = "sSubd" then
				this.setitem(1,'serviceSubdivisionCode', ls_result)		
			else
				this.setitem(1,'billingSubdivisioncode', ls_result)			
			end if
		end if

case 'sBrgy','bBrgy'
		str_s.s_dataobject = "dw_search_barangay_master_w_arg"
		str_s.s_return_column = "barangayCode"
		str_s.s_title = "Search For Barangay"
		
		str_s.s_1 = this.getItemString(1,'billingmunicipalitycode')
		
		if str_s.s_1 = '' or isNull(str_s.s_1) then
			guo_func.msgbox("ATTENTION","Required municipality, before selecting barangay..")
			return -1
		end IF
		
		--QUERY SEARCH
		SELECT  barangayname ,
			           barangaycode     
			        FROM barangaymaster  
			WHERE municipalityCode   = :as_municipality
		--END
			
		openwithparm(w_search_ancestor,str_s)
		
		ls_result = trim(message.stringparm)
		
		if ls_result <> '' then			
			if as_search = "sBrgy" then
				this.setitem(1,'servicebarangaycode', ls_result)		
			else
				this.setitem(1,'billingbarangaycode', ls_result)			
			end if
		end if

	case "sMuni","bMuni"
		str_s.s_dataobject = "dw_search_municipality_master_w_arg"
		str_s.s_return_column = "municipalityCode"
		str_s.s_title = "Search For Municipality"
		
		str_s.s_1 = this.getItemString(1,'billingprovincecode')
		
		if str_s.s_1 = '' or isNull(str_s.s_1) then
			guo_func.msgbox("ATTENTION","Required province, before selecting municipality..")
			return -1
		end IF
		
		--QUERY SEARCH
		SELECT  municipalityname ,
           municipalitycode     
        FROM municipalitymaster    
		where   provinceCode = :as_provinceCode
		
		--END
		
		openwithparm(w_search_ancestor,str_s)
		ls_result = trim(message.stringparm)
		
		if ls_result <> '' then			
			if as_search = "sMuni" then
				this.setitem(1,'servicemunicipalitycode', ls_result)		
			else
				this.setitem(1,'billingmunicipalitycode', ls_result)			
			end if
		end if

	case "sProv","bProv"
		str_s.s_dataobject = "dw_search_province_master"
		str_s.s_return_column = "provinceCode"
		str_s.s_title = "Search For Province"
		
		--QUERY SEARCH
		SELECT  provincename ,
           provincecode     
        FROM provincemaster    
		--END
		
		openwithparm(w_search_ancestor,str_s)
		ls_result = trim(message.stringparm)
		
		if ls_result <> '' then			
			if as_search = "sProv" then
				this.setitem(1,'serviceprovincecode', ls_result)		
			else
				this.setitem(1,'billingprovincecode', ls_result)			
			end if
		end if
	
end choose
return 0

--END BUTTON


--BUTTON NEW

dw_header.scrolltorow(dw_header.insertrow(0))
dw_header.setfocus()

long	ll_tranno
if not guo_func.get_nextnumber("EDITADDRESS", ll_tranno, "") then
	return
end IF

--VALIDASI guo_func.get_nextnumber
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

datetime ldt_trandate
ldt_trandate = guo_func.get_server_date()
dw_header.setitem(1, "tranno", string(ll_tranno, "00000000"))
dw_header.setitem(1, "dateadd", ldt_trandate)
dw_header.setitem(1, "useradd", gs_username)


--BUTTON SAVE

long ll_tranno
string ls_acctno, ls_tranno, ls_substypecode, ls_subscriber, ls_billingname, ls_billingcontactname
date	 ldt_date
datetime ldtme_dateadd
string ls_firstname, ls_lastname, ls_middlename, ls_subsname, ls_mothermaidenname, ls_sex, ls_civilstatus
string ls_telno, ls_mobileno, ls_faxno, ls_emailaddress, ls_citizenship, ls_chargeTypeCode
string ls_billingfirstname, ls_billinglastname, ls_billingmiddlename, ls_billingtelno
string ls_billinghouseno, ls_billingblockno, ls_billinglotno, ls_billingstreetname 
string ls_billingpurok, ls_billingphase, ls_billingdistrict, ls_servicehouseno
string ls_serviceblockno, ls_servicelotno, ls_servicestreetname, ls_servicepurok
string ls_servicephase, ls_servicedistrict, ls_serviceaddress, ls_billingaddress
string ls_billingSubdivisionCode, ls_billingBarangayCode, ls_billingMunicipalityCode, ls_billingProvinceCode
string ls_serviceSubdivisionCode, ls_serviceBarangayCode, ls_serviceMunicipalityCode, ls_serviceProvinceCode
string ls_serviceBldgCompApartmentName, ls_billingBldgCompApartmentName, ls_mobileno2, ls_mobileno3, ls_emailaddress2, ls_emailaddress3, ls_guarantor, ls_nameofcompany,ls_spousename

uo_subscriber_def luo_subscriber
luo_subscriber = create uo_subscriber_def

ls_acctno = dw_header.getitemstring(1,"acctno")
dw_header.acceptText()
if not guo_func.get_nextnumber('EDITADDRESS', ll_tranno, 'WITH LOCK') then
	return -1
end if
ls_tranno = string(ll_tranno,'00000000')
ldtme_dateadd = guo_func.get_Server_date()
dw_header.accepttext()

ls_firstname 	= dw_header.getItemString(1,"firstname")
ls_lastname  	= dw_header.getItemString(1, "lastname")		
ls_middlename	= dw_header.getItemString(1, "middlename")	
ls_subscriber 	= dw_header.getItemString(1, "subscribername")
ls_substypecode = dw_header.getItemString(1, "substypecode")
ls_mothermaidenname = dw_header.getItemString(1, "mothermaidenname")
ls_sex = dw_header.getItemString(1, "sex")		
ldt_date = DATE(dw_header.getItemDateTIME(1, "birthdate"))
ls_civilstatus = dw_header.getItemString(1, "civilstatus")
ls_telno = dw_header.getItemString(1, "telno")		
ls_mobileno = dw_header.getItemString(1, "mobileno")		
ls_mobileno2 = dw_header.getItemString(1, "mobileno2")	
ls_mobileno3 = dw_header.getItemString(1, "mobileno3")	
ls_faxno = dw_header.getItemString(1, "faxno")
ls_emailaddress = dw_header.getItemString(1, "emailaddress")
ls_emailaddress2 = dw_header.getItemString(1, "emailaddress2")
ls_emailaddress3 = dw_header.getItemString(1, "emailaddress3")
ls_nameofcompany = dw_header.getItemString(1, "nameofcompany")
ls_guarantor = dw_header.getItemString(1, "guarantor")
ls_spousename = dw_header.getItemString(1, "spousename")
ls_citizenship = dw_header.getItemString(1, "citizenshipcode")
ls_billinglastname = dw_header.getItemString(1, "billingcontactname")		
ls_billingfirstname = dw_header.getItemString(1, "subscriberName")		
ls_billingmiddlename = dw_header.getItemString(1, "middlename")
ls_billingtelno = dw_header.getItemString(1, "billingcontactno")
ls_billingcontactname = dw_header.getItemString(1, "billingcontactname")

if ls_substypecode = 'CO'or ls_substypecode = 'HO' or ls_firstName = "" then
	ls_subsname    = ls_subscriber
	ls_billinglastname = ""		
	ls_billingfirstname = ""		
	ls_billingmiddlename = ""
	ls_firstname 	= ""
	ls_lastname  	= ""	
	ls_middlename	= ""	
else
	ls_subsname    = ls_lastname+', '+ls_firstname+' '+ls_middlename
	if isNull(ls_subsname) then
		ls_subsname = ls_subscriber
	end if
	ls_billingname = ls_billinglastname+', '+ls_billingfirstname+' '+ls_billingmiddlename
	if isNull(ls_billingname) then
		ls_billingname = ls_billingcontactname
	end if
end if

ls_billinghouseno = dw_header.getItemString(1, "billinghouseno")
ls_billingblockno = dw_header.getItemString(1, "billingblkno")
ls_billinglotno = dw_header.getItemString(1, "billinglotno")
ls_billingstreetname = dw_header.getItemString(1, "billingstreetname")
ls_billingBldgCompApartmentName = dw_header.getItemString(1, "billingbldgname")
ls_billingpurok = dw_header.getItemString(1, "billingpurokno")
ls_billingphase = dw_header.getItemString(1, "billingphaseno")
ls_billingdistrict = dw_header.getItemString(1, "billingdistrict")
ls_billingSubdivisionCode = dw_header.getItemString(1, "billingSubdivisionCode")
ls_billingBarangayCode = dw_header.getItemString(1, "billingBarangayCode")
ls_billingMunicipalityCode = dw_header.getItemString(1, "billingMunicipalityCode")
ls_billingProvinceCode = dw_header.getItemString(1, "billingProvinceCode")

ls_servicehouseno = dw_header.getItemString(1, "servicehouseno")
ls_serviceblockno = dw_header.getItemString(1, "serviceblkno")
ls_servicelotno = dw_header.getItemString(1, "servicelotno")
ls_servicestreetname = dw_header.getItemString(1, "servicestreetname")
ls_serviceBldgCompApartmentName = dw_header.getItemString(1, "servicebldgname")
ls_servicepurok = dw_header.getItemString(1, "servicepurokno")
ls_servicephase = dw_header.getItemString(1, "servicephaseno")
ls_servicedistrict = dw_header.getItemString(1, "servicedistrict")
ls_serviceSubdivisionCode = dw_header.getItemString(1, "serviceSubdivisionCode")
ls_serviceBarangayCode = dw_header.getItemString(1, "serviceBarangayCode")
ls_serviceMunicipalityCode = dw_header.getItemString(1, "serviceMunicipalityCode")
ls_serviceProvinceCode = dw_header.getItemString(1, "serviceProvinceCode")


if not luo_subscriber.setAcctNo(ls_acctno) then
	guo_func.msgbox("Warning!",luo_subscriber.lastSqlCode + "~r~n" + &
						luo_subscriber.lastSqlErrText)
	return -1
end if

update arAcctSubscriber
set	 firstName 					= :ls_firstname,   
		middleName 			= :ls_middlename,   
		motherMaidenName 	= :ls_mothermaidenname,   
		lastName 				= :ls_lastname,   
		sex 						= :ls_sex,   
		citizenshipCode 		= :ls_citizenship,   
		birthDate 				= :ldt_date,   
		civilStatus 				= :ls_civilstatus,   
		telNo 						= :ls_telno,   
		mobileNo 				= :ls_mobileno,   
		mobileNo2 				= :ls_mobileno2, 
		mobileNo3 				= :ls_mobileno3, 
		faxNo						= :ls_faxno,   
		emailAddress 			= :ls_emailaddress,
		emailAddress2 			= :ls_emailaddress2,
		emailAddress3 			= :ls_emailaddress3,
		nameofcompany	     = :ls_nameofcompany,
		guarantor                  = :ls_guarantor,
         spousename              =:ls_spousename
 	where acctno = :ls_acctno
	and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
using sqlca;
if sqlca.sqlcode <> 0 then
	guo_func.msgbox("Error in Update arAcctSubscriber",sqlca.sqlerrtext)	
	rollback using SQLCA;
	return -1
end if

update arAcctAddress
set	 contactName			= :ls_billingName,
		HouseNo 			= :ls_billinghouseno,   
		StreetName 		= :ls_billingstreetname,   
		LotNo 				= :ls_billinglotno,   
		BlkNo 					= :ls_billingblockno,   
		BldgName 			= :ls_billingBldgCompApartmentName,
		PhaseNo 				= :ls_billingphase,   
		District 				= :ls_billingdistrict,   
		PurokNo 				= :ls_billingpurok,   
		SubdivisionCode 	= :ls_billingSubdivisionCode,
		BarangayCode 		= :ls_billingBarangayCode,
		MunicipalityCode 	= :ls_billingMunicipalityCode,
		ProvinceCode		= :ls_billingProvinceCode
where acctno = :ls_acctno and addressTypeCode = 'BILLING'
and divisionCode = :gs_divisionCode
and companyCode = :gs_companyCode
using sqlca;
if sqlca.sqlcode <> 0 then
	guo_func.msgbox("Error in Update arAcctAddress(BILLING)",sqlca.sqlerrtext)	
	rollback using SQLCA;
	return -1
end if

update arAcctAddress
set contactNo 				= :ls_telno,
      	//contactName		= :ls_subsname,
		HouseNo 			= :ls_serviceHouseNo,   
		StreetName 		= :ls_servicestreetname,   
		BlkNo 					= :ls_serviceblockno,   
		PhaseNo 				= :ls_servicephase,   
		District 				= :ls_servicedistrict,   
		PurokNo 				= :ls_servicepurok,   
		SubdivisionCode 	= :ls_serviceSubdivisionCode,
		BarangayCode 		= :ls_serviceBarangayCode,
		MunicipalityCode 	= :ls_serviceMunicipalityCode,
		ProvinceCode		= :ls_serviceProvinceCode,
		BldgName 			= :ls_serviceBldgCompApartmentName,
		LotNo 				= :ls_servicelotno
 where acctno = :ls_acctno and addressTypeCode = 'SERVADR1'
and divisionCode = :gs_divisionCode
and companyCode = :gs_companyCode
using sqlca;
if sqlca.sqlcode <> 0 then
	guo_func.msgbox("Error in Update arAcctAddress(SERVADR1)",sqlca.sqlerrtext)	
	rollback using SQLCA;
	return -1
end if

update arAcctAddress
set contactNo 				= :ls_telno,
     	//contactName		= :ls_subsname,
		HouseNo 			= :ls_serviceHouseNo,   
		StreetName 		= :ls_servicestreetname,   
		BlkNo 					= :ls_serviceblockno,   
		PhaseNo 				= :ls_servicephase,   
		District 				= :ls_servicedistrict,   
		PurokNo 				= :ls_servicepurok,   
		SubdivisionCode 	= :ls_serviceSubdivisionCode,
		BarangayCode 		= :ls_serviceBarangayCode,
		MunicipalityCode 	= :ls_serviceMunicipalityCode,
		ProvinceCode		= :ls_serviceProvinceCode,
		BldgName 			= :ls_serviceBldgCompApartmentName,
		LotNo 				= :ls_servicelotno
 where acctno = :ls_acctno and addressTypeCode = 'SERVADR1'
and divisionCode = :gs_divisionCode
and companyCode = :gs_companyCode
using sqlca;
if sqlca.sqlcode <> 0 then
	guo_func.msgbox("Error in Update arAcctAddress(SERVADR1)",sqlca.sqlerrtext)	
	rollback using SQLCA;
	return -1
end if

// LD 03-18-2010 For Billing Confirmation
update arAcctAddressTemp
set   confirmed = 'Y',
	   tranDate = getdate()
where acctno = :ls_acctno
and divisionCode = :gs_divisionCode
and companyCode = :gs_companyCode
using sqlca;
if sqlca.sqlcode <> 0 then
	guo_func.msgbox("Error in Update arAcctAddressTemp",sqlca.sqlerrtext)	
	rollback using SQLCA;
	return -1
end if
// End

insert into subsInfoHistory
	(
	tranNo,
	acctNo,
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
	mobileNo2,
	mobileNo3,	
	faxNo,
	emailAddress,
	emailAddress2,
	emailAddress3,
	nameofcompany,
	guarantor,
	spousename,
	serviceHouseNo,
	serviceStreetName,
	serviceBldgCompApartmentName,
	serviceLotNo,
	serviceBlockNo,
	servicePhase,
	serviceDistrict,
	servicePurok,
	serviceSubdivisionCode,
	serviceBarangayCode,
	serviceMunicipalityCode,
	serviceProvinceCode,
	billingLastName,
	billingFirstName,
	billingMiddleName,
	billingTelNo,
	billingHouseNo,
	billingStreetName,
	billingBldgCompApartmentName,
	billingLotNo,
	billingBlockNo,
	billingPhase,
	billingDistrict,
	billingPurok,
	billingSubdivisionCode,
	billingBarangayCode,
	billingMunicipalityCode,
	billingProvinceCode,
	useradd,
	dateadd,
	divisionCode,
	companyCode
	)
values
	(:ls_tranno,
	:ls_acctno,
	:ls_lastname, 
	:ls_firstname, 
	:ls_middlename, 
	:ls_mothermaidenname, 
	:ls_citizenship,
	:ls_sex, 
	:ldt_date,
	:ls_civilstatus,
	:ls_telno, 
	:ls_mobileno, 
	:ls_mobileno2, 
	:ls_mobileno3, 
	:ls_faxno, 
	:ls_emailaddress, 
	:ls_emailaddress2,
	:ls_emailaddress3,
	:ls_nameofcompany,
	:ls_guarantor,
     :ls_spousename,
	:ls_servicehouseno,
	:ls_servicestreetname,
	:ls_serviceBldgCompApartmentName,
	:ls_servicelotno, 
	:ls_serviceblockno, 
	:ls_servicephase, 
	:ls_servicedistrict,
	:ls_servicepurok,
	:ls_serviceSubdivisionCode,
	:ls_serviceBarangayCode,
	:ls_serviceMunicipalityCode,
	:ls_serviceProvinceCode,
	:ls_billinglastname, 
	:ls_billingfirstname, 
	:ls_billingmiddlename, 
	:ls_billingtelno,
	:ls_billinghouseno, 
	:ls_billingstreetname,
	:ls_billingBldgCompApartmentName,
	:ls_billinglotno, 
	:ls_billingblockno, 
	:ls_billingphase, 
	:ls_billingdistrict, 
	:ls_billingpurok, 
	:ls_billingSubdivisionCode,
	:ls_billingBarangayCode,
	:ls_billingMunicipalityCode,
	:ls_billingProvinceCode,
	:gs_username,
	getdate(),
	:gs_divisionCode,
	:gs_companyCode
	)
using sqlca;
if sqlca.sqlcode <> 0 then
	guo_func.msgbox("Error in Insert SubsINfoHIstory",sqlca.sqlerrtext)	
	rollback using SQLCA;
	return -1
end if

if not guo_func.set_number('EDITADDRESS', ll_tranno) then
	return -1
end if

commit using SQLCA;

guo_func.msgbox("Updating","Successfully Updated")
return 0