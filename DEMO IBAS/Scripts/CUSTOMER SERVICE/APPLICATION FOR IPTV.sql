---FORM HEADER
SELECT  applofexttranhdr.tranno ,
           applofexttranhdr.trandate ,
           applofexttranhdr.acctno ,
           applofexttranhdr.noofextension ,
           applofexttranhdr.specialInstructions ,
           applofexttranhdr.referencejono ,
           applofexttranhdr.useradd ,
           applofexttranhdr.dateadd ,
           applofexttranhdr.preferreddatetimefrom ,
           applofexttranhdr.preferreddatetimeto ,
           0.00 stbDeposit,
           0.00 materialsStbAdvances,
           0.00 installationFeesAdvances,
           0.00 totalRequiredInitialPayment,
           '' serviceAddress,
           '' package,
           '' chargeType,
           '' subscriberType,
           '' subscriberUserType,
           '' subscriberStatus,
           '' subscriberName,
           0 noOfExt,
           '' billingAddress,
           0.00 monthlyMlineFee,
           0.00 monthlyExtFee,
           '' generalPackage,
           0 noOfRooms,
           0.00 occupancyRate, 
			  0 noOfSTB,  '' packageCode, ''packageName, '' modeofpayment, '' noofmonths, '' installtype, '' is_conversion
        FROM applofexttranhdr 
        
        --SET DATA HEADER FROM 
        
        openwithparm(w_search_subscriber,str_s)

		ls_result = trim(Message.StringParm)				
		if ls_result = '' or isNull(ls_result) then			
			return 		
		end if
		dw_header.setitem(ll_row,'acctno', ls_result)
		ls_acctNo = ls_result
				
		select count(acctNo) into :ll_count from applOfExtTranHdr
		where  acctNo = :ls_acctNo 
		and applicationStatusCode not in ('AC','CN')
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using  SQLCA;
		
		if SQLCA.SQLCode < 0 then
			guo_func.MsgBox('SM-0000001','SQL Error Code : ' + 	string(SQLCA.SQLCode) + &
							    '~r~nSQL Error Text ; ' + SQLCA.SQLErrText)
			return					 
		end if	
		
		if ll_count > 0 then	
			guo_func.MsgBox('Pending Application Found...', 'This account has a pending Application for [Extension],'+&
								 ' please verify the transaction on JO Monitoring...')
			return					 
		end if	

		if not iuo_subscriber.setAcctNo(ls_acctNo) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + iuo_subscriber.lastSQLErrText)
			return
		end IF
		
		--VALIDASI iuo_subscriber.setAcctNo(ls_acctNo)
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
		
		// subscrber name
		ls_subscriberName = iuo_subscriber.subscriberName 
		dw_header.setItem( 1, "subscriberName", ls_subscriberName )
		
		// service address
		if not iuo_subscriber.getServiceAddress(ls_serviceAddress) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText) 
			return
		end if
		
		dw_header.setItem( 1, "serviceAddress", ls_serviceAddress )
		
		// billing address
		if not iuo_subscriber.getBillingAddress(ls_billingAddress) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return
		end if
	
		dw_header.setItem( 1, "billingAddress", ls_billingAddress )
		
		// package 
		if not iuo_subscriber.getPackageName(ls_package) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return
		end if
				
		dw_header.setItem( 1, "package", ls_package )		
		
		// general package 
		if not iuo_subscriber.getGeneralPackageName(ls_generalPackage) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return
		end if
		
		dw_header.setItem( 1, "generalPackage", ls_generalPackage )		
		
		// subscriber status
		if not iuo_subscriber.getSubscriberStatusName(ls_subscriberStatus) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return
		end if
		
		dw_header.setItem( 1, "subscriberStatus", ls_subscriberStatus )				
		
		// customer type
		if not iuo_subscriber.getchargeTypeName(ls_chargeType) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return
		end if
		
		dw_header.setItem( 1, "chargeType", ls_chargeType )				
		
		// subscriber Type
		if not iuo_subscriber.getSubsTypeName(ls_subscriberType) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return
		end if
			
		dw_header.setItem( 1, "subscriberType", ls_subscriberType )				
		
		// subscriber User Type
		if not iuo_subscriber.getSubsUserTypeName(ls_subscriberUserType) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return
		end if		
				
		dw_header.setItem( 1, "subscriberUserType", ls_subscriberUserType )				
		
		// occupancy Rate
		ld_occupancyRate = iuo_subscriber.occupancyRate
		dw_header.setItem( 1, "occupancyRate", ld_occupancyRate )							
		
		// monthly Mline Fee
		if not iuo_subscriber.getMlineMonthlyRate(ld_monthlyMlineFee) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return
		end if		
	
		dw_header.setItem( 1, "monthlyMlineFee", ld_monthlyMlineFee )							
		
		// monthly Ext Fee
		if not iuo_subscriber.getExtMonthlyRate(ld_monthlyExtFee) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return
		end if		
				
		dw_header.setItem( 1, "monthlyExtFee", ld_monthlyExtFee )							
		
		// long ll_noOfExt
		if not iuo_subscriber.getnoofactiveext(ll_noOfExt) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return
		end if		
				
		dw_header.setItem( 1, "noOfExt", ll_noOfExt )									
		
		// ll_noOfSTB
		if not iuo_subscriber.getNoOfSTB(ll_noOfSTB) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return
		end if	
		
		long ll_ctr_stb
		
		select count(a.serialno) into :ll_ctr_stb
		from subscriberaddonmaster a
		where a.acctno = :ls_acctNo 
		and divisioncode = :gs_divisioncode
		and companycode = :gs_companycode
		and isiptv = 'Y' AND USED = 'N'
		and tranno_ext is null
		and jono_iptv is null
		using SQLCA;	
				
		dw_header.setItem( 1, "noOfSTB", ll_noOfSTB )		
		dw_header.setItem( 1, "noofextension",ll_ctr_stb)		
		
		DWObject dwo_column
		if ll_ctr_stb > 0 then
		dw_header.event ItemChanged(1,dwo_column,'noofextension')
		end if 
		
		s_arrears_override_policy.refTranTypeCode = 'APPLYEXT'
		if not f_overrideArrearsPolicyType(iuo_subscriber, s_arrears_override_policy ) then
			trigger event ue_cancel()
			return
		end if		
		
		--VALIDASI f_overrideArrearsPolicyType(iuo_subscriber, s_arrears_override_policy )
		decimal {2} ld_ARBalance

		//------------------------------------------------------------
		// validate policy on no of months a/r min requirement - start
		//------------------------------------------------------------
		
		
		ld_ARBalance = 0.00
		--check if subscriber has a/r balances
		
		if not iuo_subscriber.getARBalance(ld_ARBalance,1) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
		end IF
		
		--VALIDASI iuo_subscriber.getARBalance(ld_ARBalance,1)
		
		lastMethodAccessed = 'getARBalance'
		datetime ldt_cutOffDate, ldt_lastBillingDate
		
		integer li_currentMonthNo, li_monthNoSearch, li_currentYearNoSearch, li_yearNoSearch
		
		if subsTypeCode <> 'CP' then
			select billingDate into :ldt_lastBillingDate
			from systemParameter 
			where divisionCode = :gs_divisionCode
			and companyCode = :gs_companyCode
			using SQLCA;
			if isnull(ldt_lastBillingDate) then
				li_monthNoSearch = month( date( guo_func.get_server_date() ) )
				li_yearNoSearch = year( date( guo_func.get_server_date() ) )
			else
				li_monthNoSearch = month( date( ldt_lastBillingDate ) )
				li_yearNoSearch = year( date( ldt_lastBillingDate ) )
			end if
			
			li_currentMonthNo = ( li_monthNoSearch - ai_noofbillingmonths )// + 1
			if li_currentMonthNo <= 0 then
				li_currentMonthNo = 12 + li_currentMonthNo	
				li_yearNoSearch = li_yearNoSearch - 1		
			end if
		else
			select billingDateCP into :ldt_lastBillingDate
			from systemParameter 
			where divisionCode = :gs_divisionCode
			and companyCode = :gs_companyCode
			using SQLCA;
			if isnull(ldt_lastBillingDate) then
				li_monthNoSearch = month( date( guo_func.get_server_date() ) )
				li_yearNoSearch = year( date( guo_func.get_server_date() ) )
			else
				li_monthNoSearch = month( date( ldt_lastBillingDate ) )
				li_yearNoSearch = year( date( ldt_lastBillingDate ) )
			end if
			
			li_currentMonthNo = ( li_monthNoSearch - ai_noofbillingmonths )// + 1
			if li_currentMonthNo <= 0 then
				li_currentMonthNo = 12 + li_currentMonthNo	
				li_yearNoSearch = li_yearNoSearch - 1		
			end if	
		end if
		
		
		
		ldt_cutOffDate = datetime( date(trim(string(li_currentMonthNo))+ &
												'/11/'+ &
			      						trim(string(li_yearNoSearch)) ), time('00:00:00') )
		
		
		select sum(balance)
		  into :ad_balance
		  from arTranHdr
		 where acctNo = :acctNo and tranDate < :ldt_cutOffDate
		 and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;
		if SQLCA.sqlcode < 0 then
			lastSQLCode = string(SQLCA.sqlcode)
			lastSQLErrText = SQLCA.sqlerrtext
			return FALSE
		end if
		
		if isnull(ad_balance) then ad_balance = 0
		
		return TRUE
		
		----END VALIDASI iuo_subscriber.getARBalance(ld_ARBalance,1)
		
		--POP UP override policy window for authorization
		
		if ld_ARBalance > 0.00 then
			if guo_func.msgbox("Policy Override!!!", &
									"The current subscriber has a/r balances.  You can not continue with this request.  Do you want to override this policy?", &										
									gc_Question, &
									gc_yesNo, &
									"Please secure an authorization for overriding this policy.") = 1 then
				
				s_arrears_override_policy.overridePolicyTypeCode 	= '001'
				s_arrears_override_policy.policyCode 					= '001'
				s_arrears_override_policy.reqType						= 'arrears'
				s_arrears_override_policy.acctNo 						= iuo_subscriber.acctNo
				s_arrears_override_policy.arBalance 					= ld_ARBalance
				s_arrears_override_policy.subscriberName			= iuo_subscriber.subscriberName
				
				----OPEN WINDOW POP UP TO SET AUTORIZATION
				openwithparm(w_online_authorization,s_arrears_override_policy)	
				
				--IF CLICK BUTTON REQUEST FOR APPROPAL THEN ACTION THIS
				--THE VISUAL FORM COLUMN
				 SELECT space(10) tranNo,   
			         space(50) requestedBy,   
			         space(255) remarks,
			         space(255) policyName,
				space(255) userRemarks,
			        0.00 arBalance,
				space(1) lockInPeriod
	
				string 	ls_remarks, ls_tranNo, ls_mobileNo, ls_policy, ls_userRemarks
				dateTime	ldt_date
				long 		ll_tranNo
				
				if dwo.name = 'b_request' then
					this.acceptText()
					
					if not guo_func.get_nextNumber_continous('OVERRIDE', ll_tranNo, 'WITH LOCK') then
						guo_func.msgBox("ATTENTION","Unable to get an authorization no.")
						return -1
					end if
					
					if not guo_func.set_number_continous('OVERRIDE', ll_tranNo) then
						guo_func.msgBox("ATTENTION","Unable to set the authorization no.")
						return -1
					end if
					
					ls_tranNo  		= string(ll_tranNo, '0000000000')
					is_tranNo  		= ls_tranNo
					ls_remarks 		= trim(this.getItemString(row,'remarks'))
					ls_userRemarks = trim(this.getItemString(row,'userremarks'))
					ls_policy  		= trim(this.getItemString(row,'policyName'))
					
					if isNull(ls_userRemarks) and ls_userRemarks = "" then
						guo_func.msgBox("ATTENTION","User remarks is required.")
						return -1
					end if
					
					ldt_date 	= guo_func.get_server_dateTime()
					//ls_policy 	= ls_policy +' User Remarks: '+ ls_userRemarks
					
					insert into overridePolicy
						(
							tranNo,
							tranDate,
							overridePolicyTypeCode,
							refTranTypeCode,
							refTranNo,
							acctNo,
							requestedBy,
							expirationDate,
							remarks,
							useradd,
							dateadd,
							dateApproved,
							approvedBy,
							requestStatus,
							divisionCode,
							companyCode
						)
					values
						(
							:is_tranNo,
							:ldt_date,
							:istr_override_policy.overridepolicytypecode,
							:istr_override_policy.refTranTypeCode,
							:istr_override_policy.reftranno,
							:istr_override_policy.acctNo,
							:gs_ufullName,
							null,
							:ls_userRemarks,
							:gs_userName,
							:ldt_date,
							:ldt_date,
							'',
							'OG',
							:gs_divisionCode,
							:gs_companyCode
						)
					using SQLCA;
					if SQLCA.SQLCode <> 0 then
						guo_func.msgBox('SM-0000001','Insert in overridePolicy '+'SQLCode    : '+string(SQLCA.SQLCode) + 'SQLErrText : ' + SQLCA.SQLErrText)
						return -1	
					end if	
					commit using SQLCA;
					/* remarked by vincent
					if parent.trigger Event ue_sendSMS(ls_remarks, istr_policy.policyCode) = 0 then
						commit using SQLCA_SMS;
					else
						rollback using SQLCA_SMS;
					end if
					
					disconnect using SQLCA_SMS; */
					
					this.object.b_request.enabled 	= False
					this.object.remarks.tabSequence 	= 0
					
					st_1.text = 'Waiting for approval. Please wait...'
					
					timer(3)
							
				elseif dwo.name = 'b_cancel' then
					
					update overridePolicy
					set requestStatus = 'CN'
					where tranNo = :is_tranNo
					and divisionCode = :gs_divisionCode
					and companyCode = :gs_companyCode
					using SQLCA;
					
					commit using SQLCA;
					
					gb_authorizationNo = is_tranNo
					
					closeWithReturn(parent, 'CN')
					
				elseif dwo.name = 'b_reset' then
					this.setitem(1,'remarks',is_remarks)
				end IF
				
				------END WINDOW POP UP SEND REQUEST
				
				--IF CLICK BUTTON PROCESS
				--THE VISUAL FORM COLUMN
				SELECT  overridePolicy.tranNo ,
				overridePolicy.approvedBy ,
				overridePolicy.managerRemarks ,
				overridePolicy.dateApproved ,
				overridePolicy.requestStatus 
				FROM overridePolicy
				WHERE ( overridePolicy.tranNo = :as_tranNo ) AND
				( overridePolicy.divisionCode = :as_division ) AND
				( overridePolicy.companyCode = :as_company ) and 
				( overridePolicy.requestStatus not in ('SM','OG','CN') )  
				
				
				if dwo.name = 'b_proceed' then
					this.acceptText()
					
				   istr_override_policy.tranNo 			= is_tranNo
					istr_override_policy.requestStatus 	=	this.getItemString(row,'requestStatus')
					istr_override_policy.remarks			=  trim(this.getItemString(row,'managerremarks'))
					istr_override_policy.dateApproved	= 	this.getItemdateTime(row,'dateApproved')
					istr_override_policy.approvedBy		=  trim(this.getItemString(row,'approvedBy'))
					
					update overridePolicy
					set dateApproved = :istr_override_policy.dateApproved,
						 managerRemarks = :istr_override_policy.remarks,
						 approvedBy = :istr_override_policy.approvedBy,
						 requestStatus = :istr_override_policy.requestStatus
					where tranNo = :is_tranNo
					and divisionCode = :gs_divisionCode
					and companyCode = :gs_companyCode
					using SQLCA;
					
					commit using SQLCA;
					
					gb_authorizationNo = is_tranNo
					
					closeWithReturn(parent, istr_override_policy.requestStatus)
					
				end IF
				
				----END WINDOW POP UP PROCESS				
				
				--FEEDBACK RETURN WHEN FORM POP UP CLOSE 
				if message.stringParm = 'CN' then
					guo_func.msgbox("Policy Override!!!", &
									"You have cancelled the authorization.  This will cancel your transaction.", &										
									gc_Information, &
									gc_OKOnly, &
									"Please secure an authorization for overriding this policy.")
									
					// reset entry
					return false
				elseif message.stringParm = 'DP' then
					return false
				elseif message.stringParm = 'ER' then
					return false
					end if
				else  // policy ignored close window transaction
					guo_func.msgbox("Policy Override!!!", &
									"You have cancelled the authorization.  This will cancel your transaction.", &										
									gc_Information, &
									gc_OKOnly, &
									"Please secure an authorization for overriding this policy.")
									
					// reset entry		
					return false
				end if			
		end if
		return true
		--END VALIDASI
		
		--CONTINUE PROCESS
		
		ib_withPendingInstallations = FALSE
		
		long ll_noOfMlineApplications
		ll_noOfMlineApplications = 0
		select count(*) 
		into :ll_noOfMlineApplications
		from arAcctSubscriber
		where acctNo = :ls_acctNo 
		and applicationStatusCode not in ('AC', 'CN')
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;

		if SQLCA.SQLCode = -1 Then
			guo_func.msgBox('SM-0000001',"Accessing arAcctSubscriber ~nSQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText)
			return
		end if
		if isnull(ll_noOfMlineApplications) then ll_noOfMlineApplications = 0
		
		long ll_noOfExtApplications
		ll_noOfExtApplications = 0
		select count(*) 
		into :ll_noOfExtApplications
		from applOfExtTranHdr
		where acctNo = :ls_acctNo 
		and applicationStatusCode not in ('AC', 'CN')
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;

		if SQLCA.SQLCode = -1 Then
			guo_func.msgBox('SM-0000001',"Accessing arAcctSubscriber ~nSQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText)
			return
		end if
		if isnull(ll_noOfExtApplications) then ll_noOfExtApplications = 0		
		
		select count(*) 
		into :ll_noOfApplTransfer
		from applOfTransferTranHdr
		where acctNo = :ls_acctNo 
		and applicationStatusCode not in ('AC', 'CN')
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;
		if SQLCA.SQLCode = -1 Then
			guo_func.msgBox('SM-0000001',"Accessing applOfTransferTranHdr ~nSQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText)
			return
		end if
		if isnull(ll_noOfApplTransfer) then ll_noOfApplTransfer = 0

		// installation extension fee shall use succeedingExtInstallFee
		
		if ll_noOfExtApplications > 0 or ll_noOfMlineApplications > 0 or ll_noOfApplTransfer > 0 then
			ib_withPendingInstallations = TRUE
		end if
		
		string ls_packageCode
		ls_packageCode = iuo_subscriber.packageCode
		
		select extFirstSTBInstallFee, extSucceedingSTBInstallFee, stbDepReqPerBox, stbPricePerBox
		into :id_extFirstSTBInstallFee, :id_extSucceedingSTBInstallFee, :id_stbDepReqPerBox, :id_stbPricePerBox
		FROM 		arPackageMaster
		WHERE 	packageCode = :ls_packageCode
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		USING SQLCA;			
		If SQLCA.SQLcode = -1 then
			guo_func.msgBox('SM-0000001',"select in arPackageMaster SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText)
			return
		end if		
		
		if isnull(id_extFirstSTBInstallFee) then id_extFirstSTBInstallFee = 0.00
		if isnull(id_extSucceedingSTBInstallFee) then  id_extSucceedingSTBInstallFee = 0.00
		if isnull(id_stbDepReqPerBox) then  id_stbDepReqPerBox = 0.00
		if isnull(id_stbPricePerBox) then 	id_stbPricePerBox = 0.00
				
		dw_header.setColumn( 'preferredDateTimeFrom' )
		
		--END PROCESS GET HEADER DATA
       
---FORM DETAIL KEY IN DATA
		
  SELECT  acquisitiontypemaster.acquisitiontypename ,           
	applofexttrandtl.qty ,          
	 applofexttrandtl.rate ,           
	applofexttrandtl.amount ,          
	 acquisitiontypemaster.priority ,          
	 applofexttrandtl.acquisitiontypecode ,          
	 '' requiresApproval, ''packageCode, ''packagename
	FROM applofexttrandtl ,           
	acquisitiontypemaster     
	WHERE ( applofexttrandtl.acquisitiontypecode = acquisitiontypemaster.acquisitiontypecode )
	 and          ( ( applofexttrandtl.tranno = :as_tranNo ) ) 
	 
	--KEY IN VALUE noofextension TO KEY IN DATA
	 
	long ll_noOfExtensions, ll_noOfApplTransfer

	long ll_row, ll_success
	string ls_search, ls_result, ls_acctNo, ls_requiresApproval 
	string ls_reqApp_RND 	, ls_requiresApproval_RWD
	
	ls_requiresApproval = ''
	ls_reqApp_RND 	= ''
	ls_requiresApproval_RWD = ''
	
	s_stbPackages lstr_packages
	
	string ls_subscriberName, ls_serviceAddress, ls_billingAddress
	string ls_package, ls_generalPackage
	string ls_subscriberStatus, ls_chargeType
	string ls_subscriberType, ls_subscriberUserType
	decimal{2} ld_occupancyRate, ld_monthlyMlineFee, ld_monthlyExtFee
	long ll_noOfExt, ll_noOfSTB, ll_rows, ll_priority
	
	
	ls_acctNo = dw_header.GetItemString(1,'acctNo')
	
	string ls_mop
	
	if data = 'S' then
		
			this.object.noofmonths.visible = True
			this.setitem(getrow(),'noofmonths','24')
			
		else
			
			this.object.noofmonths.visible = False
			
	
	end if
	
	
	if data = 'noofextension' then
		ll_noOfExtensions = this.getItemNumber(1,'noofextension')
		if ll_noOfExtensions > 0 THEN
			dw_detail.reset()
			
			
		--OPEN WINDOW POP UP FORM
		
		openWithParm(w_digital_packages_IPTV,ll_noOfExtensions)
		
		--THE FORM COLUMN WHEN OPEN RETRIEVE WITH PARAMATER as_division , as_company
		 SELECT arPackageMaster.packageName,   
         	arPackageMaster.packageCode,
         	''selected --(CHECK BOX TO SELECT )
		   FROM arPackageMaster
		   WHERE ( arPackageMaster.divisionCode = :as_division ) AND  
		         ( arPackageMaster.companyCode = :as_company ) AND
		         ( arPackageMaster.isiptvpackage = 'Y')
		         
		 --SELECT THE PACKANGE THEN CLICK BUTTON OK
		  	int li_row, li_ctr
			string ls_selected
			
			istr_packages = istr_empty
			
			dw_1.acceptText()
			
			for li_row = 1 to dw_1.rowCount()
				ls_selected = dw_1.getItemString(li_row,'selected')
				if ls_selected = 'Y' then
					li_ctr ++
					istr_packages.codepackage[li_ctr] = dw_1.getItemString(li_row,'packageCode')
					istr_packages.namepackage[li_ctr] = dw_1.getItemString(li_row,'packageName')
				end if
			next
			if li_ctr > il_noOfextension then
				guo_func.msgBox("ATTENTION","You are only allowed to select  not more than "+string(il_noOfExtension,'#,###')+' packages.')
				return
			elseif  li_ctr > 1  then
				guo_func.msgBox("ATTENTION","You are required to select ONLY 1 package")
				return
			elseif li_ctr = 0 then
				guo_func.msgBox("ATTENTION","You are required to select ONLY 1 package")
				return
			end if
			istr_packages.remarks = 'OK'
			closeWithReturn(parent, istr_packages) 
			
			-----END WINDOW POP UP PROCESS
			
			lstr_packages = message.powerObjectParm				
			
			if lstr_packages.remarks <> 'OK' then			
				guo_func.msgBox("ATTENTION","You must select packages for your extensions.")	
				return 2
			end if
			
			--insert 'RND' option rent no deposit
			
			for ll_row = 1 to upperBound(lstr_packages.codepackage)
				dw_detail.insertRow(0)
				dw_detail.scrollToRow( ll_row )
				dw_detail.setItem( ll_row, "acquisitionTypeCode", 'RND' )
				dw_detail.setItem( ll_row, "requiresApproval", 'N' 	)
				dw_detail.setItem( ll_row, "applofexttrandtl_qty", 0 )
				dw_detail.setItem( ll_row, "rate", 0.00 )
				dw_detail.setItem( ll_row, "amount", 0.00 )
				dw_detail.setItem( ll_row, "priority", 3 )
				dw_detail.setItem( ll_row, "packageCode", lstr_packages.codepackage[ll_row] )
				dw_detail.setItem( ll_row, "packagename", lstr_packages.namepackage[ll_row] )				
			next
		
		else
			// noofextension must be greater than zero
			guo_func.msgBox("No of Extension Error.", "No of extension must be greater than zero")
			return 2
		end if
		
		return 0
	end if 
	
	if dwo.name = 'noofextension' then
	
		ll_noOfExtensions = long(data)	
		if ll_noOfExtensions > 0 THEN
		
		ll_rows = dw_detail.getRow()
		if ll_rows > 0 then
			dw_detail.reset()
		end if
		
		dw_detail.scrollToRow( ll_row )
		dw_detail.setItem( ll_row, "acquisitionTypeCode", 'BUY' )
		dw_detail.setItem( ll_row, "requiresApproval", ls_requiresApproval)
		dw_detail.setItem( ll_row, "applofexttrandtl_qty", 0 )
		dw_detail.setItem( ll_row, "rate", id_stbPricePerBox )
		dw_detail.setItem( ll_row, "amount", 0.00 )
		dw_detail.setItem( ll_row, "priority", ll_priority )
		dw_detail.setItem( ll_row, "packageCode", '00000')
		
		select priority, requiresApproval 
		into :ll_priority, :ls_reqApp_RND 	
		from acquisitionTypeMaster 	
		where acquisitionTypeCode = 'RND'
		using SQLCA;
		if SQLCA.SQLCode <> 0 then
			is_msgNo    = 'SM-0000001'
			is_msgTrail = "select in acquisitionTypeMaster"+"SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
			return -1	
		end if	
		
		long ll_ctr_iptv
		string ls_packageCode_mainline_iptv, ls_packageName_mainlne_iptv
		
		select count(a.serialNo), a.packagecode , b.packageName into :ll_ctr_iptv, :ls_packageCode_mainline_iptv, :ls_packageName_mainlne_iptv
		from subscriberCPEmaster a
		inner join arPackageMaster b on b.packageCode = a.packageCode and b.divisionCode = a.divisionCode
		where a.acctNo = :ls_acctNo
		and a.divisionCode = :gs_divisionCode
		and a.companyCode = :gs_companyCode
		and a.cpetypecode = 'IPTV'
		AND a.ISPRIMARY = 'Y'
		group by a.packageCode, b.packageName
		using SQLCA;
		
		--OPEN WINDOW POP UP FORM
		
		openWithParm(w_digital_packages_IPTV,ll_noOfExtensions)
		
		--THE FORM COLUMN WHEN OPEN RETRIEVE WITH PARAMATER as_division , as_company
		 SELECT arPackageMaster.packageName,   
         	arPackageMaster.packageCode,
         	''selected --(CHECK BOX TO SELECT )
		   FROM arPackageMaster
		   WHERE ( arPackageMaster.divisionCode = :as_division ) AND  
		         ( arPackageMaster.companyCode = :as_company ) AND
		         ( arPackageMaster.isiptvpackage = 'Y')
		         
		 --SELECT THE PACKANGE THEN CLICK BUTTON OK
		  	int li_row, li_ctr
			string ls_selected
			
			istr_packages = istr_empty
			
			dw_1.acceptText()
			
			for li_row = 1 to dw_1.rowCount()
				ls_selected = dw_1.getItemString(li_row,'selected')
				if ls_selected = 'Y' then
					li_ctr ++
					istr_packages.codepackage[li_ctr] = dw_1.getItemString(li_row,'packageCode')
					istr_packages.namepackage[li_ctr] = dw_1.getItemString(li_row,'packageName')
				end if
			next
			if li_ctr > il_noOfextension then
				guo_func.msgBox("ATTENTION","You are only allowed to select  not more than "+string(il_noOfExtension,'#,###')+' packages.')
				return
			elseif  li_ctr > 1  then
				guo_func.msgBox("ATTENTION","You are required to select ONLY 1 package")
				return
			elseif li_ctr = 0 then
				guo_func.msgBox("ATTENTION","You are required to select ONLY 1 package")
				return
			end if
			istr_packages.remarks = 'OK'
			closeWithReturn(parent, istr_packages) 
			
			-----END WINDOW POP UP PROCESS
		        
		
		lstr_packages = message.powerObjectParm
		
		if lstr_packages.remarks <> 'OK' then			
			guo_func.msgBox("ATTENTION","You must select packages for your extensions.")	
			return 2
		end IF
		
		for ll_row = 1 to upperBound(lstr_packages.codepackage)
			dw_detail.insertRow(0)
			dw_detail.scrollToRow( ll_row )
			dw_detail.setItem( ll_row, "acquisitionTypeCode", 'BUY' )
			dw_detail.setItem( ll_row, "requiresApproval", 'N' 	)
			dw_detail.setItem( ll_row, "applofexttrandtl_qty", 0 )
			dw_detail.setItem( ll_row, "rate", 0.00 )
			dw_detail.setItem( ll_row, "amount", 0.00 )
			dw_detail.setItem( ll_row, "priority", 3 )
			dw_detail.setItem( ll_row, "packageCode", lstr_packages.codepackage[ll_row] )
			dw_detail.setItem( ll_row, "packageName", lstr_packages.namepackage[ll_row] )				
		next
	 else
		guo_func.msgBox("No of Extension Error.", "No of extension must be greater than zero")
		return 2
	end if	
end IF

----END KEY IN DW DETAIL

	 
--WHEN ALL DONE JEY IN THEN GO TO PROCESS BUTTON	 
----SAVE BUTTON
long 			ll_acctno, ll_tranNo, ll_extensions
string 			ls_acctno, ls_tranTypeCode, ls_packageCode
decimal{2}		ld_totalInstFee

dw_header.acceptText()
dw_detail.acceptText()

idt_tranDate = guo_func.get_server_datetime()
ls_tranTypeCode = is_transactionID

ll_extensions 		= dw_detail.getItemNumber(1, "cf_applofexttrandtl_qty")

if il_noOfExtension <> ll_extensions then
	guo_func.msgBox("No. of Extensions Entry validation.", "No. of extensions entry is invalid.")
	return -1
end if

if il_noOfExtension <= 0 or isNull(il_noOfExtension) then
	guo_func.msgBox("No. of Addition Extentions.", "No. of Addition Extentions entry is invalid.")
	return -1
end if

if ll_extensions <= 0 then
	guo_func.msgBox("No. of Extensions Entry validation.", "No. of extensions entry is invalid.")
	return -1
end IF


// Confirm
If messagebox('Confirmation', "You wish to save new application for Additional Extension?", Question!, OKCancel! ) <> 1 Then
	return -1
End If

if not guo_func.get_nextNumber(ls_tranTypeCode, ll_tranNo, "WITH LOCK") then			
	return -1
end if	

---GET VALIDASI guo_func.get_nextNumber(ls_tranTypeCode, ll_tranNo, "WITH LOCK")
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
-----------------------------------

is_tranNo = string(ll_tranNo, '00000000')
ld_totalInstFee = 0
ls_acctNo = dw_header.getItemString( 1, "acctNo" )

--Prepare GL Poster
if not iuo_glPoster.initialize(is_transactionID, is_tranNo, idt_tranDate) then
	is_msgno 	= 'SM-0000001'
	is_msgtrail = iuo_glPoster.errorMessage
	is_sugtrail = iuo_glPoster.suggestionRemarks
	return -1
end IF

--VALIDASI iuo_glPoster.initialize(is_transactionID, is_tranNo, idt_tranDate)

initialized = True
dw_GLEntries.reset()--DATASTORE
as_tranTypeCode = is_transactionID
as_tranNo = is_tranNo

if isNull(as_tranTypeCode) or as_tranTypeCode = '' then
	errorMessage = 'GL Poster could be initialized. The transaction type being passed is empty.'
	suggestionRemarks = 'Please contact your system administrator'
	return False
end if

if isNull(as_tranNo) or as_tranNo = '' then
	errorMessage = 'GL Poster could be initialized. The transaction number being passed is empty.'
	suggestionRemarks = 'Please contact your system administrator'
	return False
end if

tranTypeCode 	= as_tranTypeCode
tranNo 			= as_tranNo
tranDate 		= adt_tranDate

return TRUE
-----------------
--uo_subs_advar.setGLPoster(iuo_glPoster)

---VALIDASI setGLPoster(iuo_glPoster)
iuo_glPoster = auo_glPoster


ls_packageCode			= idw_application_for_ext_dtl.getItemString(1, 'packageCode')

decimal{2} ld_noOfMonthsAdvDepReq , ld_monthlyrate , ld_advance_mrc

select noOfMonthsAdvDepReq , monthlyRate into :ld_noOfMonthsAdvDepReq , :ld_monthlyrate
from arpackagemaster
where packagecode = :ls_packagecode and divisioncode = :gs_divisioncode and companycode = :gs_companycode
using SQLCA;

ld_advance_mrc = ld_noOfMonthsAdvDepReq * ld_monthlyrate

if ld_advance_mrc > 0 then


---create records on subsInitialPayment
	if trigger event ue_save_subsInitialPayment(ls_acctno, is_tranNo, ld_advance_mrc) = -1 then
		is_msgNo    = 'SM-0000001'
		is_msgTrail = "Saving subsInitialPayment ~nSQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
		return -1
	end IF
	
	--VALIDASI ue_save_subsInitialPayment(ls_acctno, is_tranNo, ld_advance_mrc)
	
	long ll_priority, ll_row,  ll_rows, ll_loop
		string ls_acctno, ls_arTypeCode, ls_tranNo, ls_currency
		dec{2} ld_amount, ld_rate
		
		ls_acctno = trim(as_acctno)
		ls_tranNo = ''
		ls_tranno = as_tranno
		
		
						insert into subsInitialPayment
							(acctNo,
							 tranTypeCode,
							 arTypeCode,
							 tranNo,
							 tranDate,
							 priority,
							 amount,
							 paidAmt,
							 balance,
							 processed,
							 divisionCode,
							 companyCode)
						values
							(:ls_acctNo,
							 :is_transactionID,
							 'OCADV',
							 :ls_tranNo,
							 :idt_tranDate,
							 :ll_priority,
							 :ad_totalextfee,
							 0,
							 :ad_totalextfee,
							 'N',
							 :gs_divisionCode,
							 :gs_companyCode)
						using SQLCA;	
						if SQLCA.SQLCode <> 0 then
							is_msgNo    = 'SM-0000001'
							is_msgTrail = "insert in SubsInitialPayment "+"SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
							return -1	
						end if
				
		
		return 0
		----------------------------
	
end if 

--save record to APPLEXTTRANHDRandDTL
if trigger event ue_save_applOfExtTrahHdrAndDtl(ls_acctno, ld_totalInstFee) = -1 then
   return -1
end IF

---VALIDASI ue_save_applOfExtTrahHdrAndDtl(ls_acctno, ld_totalInstFee)
string 		ls_acctNo, ls_userAdd, ls_packageCode
long 		ll_noOfExtension
string 		ls_specialinstructions, ls_referenceJONo
datetime	ldt_preferreddatetimefrom, ldt_preferreddatetimeto						
datetime 	ldt_dateadd 
long 		ll_row

ll_row = dw_header.getrow()
idw_application_for_ext_dtl.acceptText() 
idw_reqInitPayment.acceptText()


--get subscriber information
idt_tranDate 					= guo_func.get_server_date()
ls_acctNo 						= trim(as_acctno)
ll_noOfExtension				= il_noOfExtension
ls_specialinstructions			= trim(dw_header.getItemString(ll_row, 'specialInstructions'))	
ldt_preferreddatetimefrom	= dw_header.getItemDateTime(ll_row, 'preferreddatetimefrom')
ldt_preferreddatetimeto		= dw_header.getItemDateTime(ll_row, 'preferreddatetimeto')

if ls_acctno = '' or isnull(ls_acctno) then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = 'Saving Subscriber Master : ~r~n Cannot save with unknown Account No.'
	return -1
end if

if ldt_preferredDateTimeto < ldt_preferredDateTimeFrom or isNull(ldt_preferredDateTimeTo) then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = "Please check your date... Invalid Preferred DateTime To!"
	return -1
end if

--==================================================
--the variable ld_extInstallFeeForFirstExt must be
--saved into the application table, so that update 
--jo can compute the exact amount of extension
--installation fee 
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

decimal{2}	ld_extInstallFeeForFirstExt
if ib_withPendingInstallations then
	ld_extInstallFeeForFirstExt = id_extSucceedingSTBInstallFee
else
	ld_extInstallFeeForFirstExt = id_extFirstSTBInstallFee
end if

--Check if netflix plans and mainline packages
string ls_mainline_package, ls_clientclass_value
string ls_province_name , ls_municipality_name

boolean lb_high_speed_plans = False
boolean lb_pa_area = False

long ll_ctr_pa_area

select packagecode into :ls_mainline_package
from aracctsubscriber
where acctno = :ls_acctno
and divisioncode = :gs_divisioncode
and companycode = :gs_companycode
using SQLCA;

select clientclassvalue into :ls_clientclass_value
from arpackagemaster 
where packagecode = :ls_mainline_package
and divisioncode = :gs_divisioncode
and companycode = :gs_companycode
using SQLCA;

select provincename , municipalityname into :ls_province_name, :ls_municipality_name
from vw_aracctaddress 
where acctno = :ls_acctno
and divisioncode = :gs_divisioncode
and companycode = :gs_companycode
and addresstypecode = 'SERVADR1'
using SQLCA;

IF Pos(ls_clientclass_value, '1000') > 0 THEN
   lb_high_speed_plans = True
END IF

select count(*) into :ll_ctr_pa_area
from iptv_area_mapping
where municipalityname = :ls_municipality_name
and provincename = :ls_province_name
using SQLCA;

if ll_ctr_pa_area > 0 or  Pos(ls_province_name,'MANILA') > 0 then
	lb_pa_area = True
end if


--Insert record for applOfExtTranHdr
INSERT INTO applOfExtTranHdr
		(
		tranNo,
		tranDate,
		acctNo,
		noOfRequiredSTB,
		noOfExtension,
		specialinstructions, 
		referenceJONo,
		preferreddatetimefrom, 
		preferreddatetimeto,	
		applicationStatusCode,
		installFeeForFirstExt,
		dateadd,
		useradd,
		instFee,
		divisionCode,
		companyCode
		)
	VALUES
		(
		:is_tranNo,
		:idt_tranDate,
		:ls_acctNo,
		:ll_noOfExtension,
		:ll_noOfExtension,
		:ls_specialinstructions, 
		null,
		:ldt_preferreddatetimefrom, 
		:ldt_preferreddatetimeto,						
		'FJ', 
		:ld_extInstallFeeForFirstExt,
		getdate(),
		:gs_UserName,
		:ad_totalInstFee,
		:gs_divisionCode,
		:gs_companyCode
		)
	USING SQLCA;
	
	if SQLCA.SQLCode = -1 then
		is_msgNo    = 'SM-0000001'
		is_msgTrail = 'Saving ApplOfExtTranHdr ~nSQLCode    : '+string(SQLCA.SQLCode) + 'SQLErrText : ' + SQLCA.SQLErrText
		return -1
	end if


--Insert record for applOfExtTranDtl
long ll_rows, ll_loop, ll_applOfExtTranDtl_qty
string ls_acquisitionTypeCode, ls_package_code_new
dec{2} ld_rate, ld_amount

ll_rows = idw_application_for_ext_dtl.rowCount()
is_netflix = False

for ll_loop = 1 to ll_rows
		
	ls_acquisitionTypeCode 	= idw_application_for_ext_dtl.getItemString(ll_loop, 'acquisitionTypeCode')
	ll_applOfExtTranDtl_qty 	= idw_application_for_ext_dtl.getItemNumber(ll_loop, 'applOfExtTranDtl_qty')
	ld_rate 						= idw_application_for_ext_dtl.getItemDecimal(ll_loop, 'rate')
	ld_amount 					= idw_application_for_ext_dtl.getItemDecimal(ll_loop, 'amount')
	ls_packageCode			= idw_application_for_ext_dtl.getItemString(ll_loop, 'packageCode')
	ls_package_code_new = ''
	
	if lb_high_speed_plans then 
		CHOOSE CASE ls_packageCode
			 CASE "NFB04", "JM003", "NFB06", "JM005", "NFB05", "JM004"
				  is_netflix = True
		END CHOOSE
		
		CHOOSE CASE ls_packagecode
			case "JM003", "NFB04"
					ls_package_code_new = 'JM901'
			case "JM004", "NFB05"
				if lb_pa_area then
					ls_package_code_new = 'JM802'
				else
					ls_package_code_new = 'JM801'
				end if
				
			case "JM005", "NFB06"
				if lb_pa_area then
					ls_package_code_new = 'JM702'
				else
					ls_package_code_new = 'JM701'
				end if
		end choose
	end if
	
	if ls_package_code_new = '' THEN
		ls_packagecode = ls_packagecode
	else
		ls_packagecode = ls_package_code_new
	end if
	
	if ll_applOfExtTranDtl_qty > 0 then
		insert into applOfExtTranDtl
			(tranNo,
			 acquisitionTypeCode,
			 qty,
			 rate,
			 amount,
			 divisionCode,
			 companyCode,
			 packageCode)
		values
			(:is_tranNo,
			 :ls_acquisitionTypeCode,
			 :ll_applOfExtTranDtl_qty,
			 :ld_rate,
			 :ld_amount,
			 :gs_divisionCode,
			 :gs_companyCode,
			 :ls_packageCode)
		using SQLCA;	
		if SQLCA.SQLCode <> 0 then
			is_msgNo    = 'SM-0000001'
			is_msgTrail = 'insert in ApplOfExtTranDtl '+'SQLCode    : '+string(SQLCA.SQLCode) + 'SQLErrText : ' + SQLCA.SQLErrText
			return -1	
		end if	
	end if
	
next

for ll_loop = 1 to upperBound(id_rateBreakdowns)
	insert into applOfExtTranFeeBreakdown (
					tranNo,
					extInstFee,
					divisionCode,
					companyCode)
		  values (
		  			:is_tranNo,
					:id_rateBreakdowns[ll_loop],
					:gs_divisionCode,
					:gs_companyCode)
			using SQLCA;
	if SQLCA.sqlCode < 0 then
		is_msgNo    = 'SM-0000001'
		is_msgTrail = 'insert in applOfExtTranFeeBreakdown'+'SQLCode    : '+string(SQLCA.SQLCode) + 'SQLErrText : ' + SQLCA.SQLErrText
		return -1	
	end if
	open(w_relax) // just to avoid primary key violation of dateAdd column
next

return 0
--END VALIDASI------------------

if	not guo_func.set_number(ls_tranTypeCode, ll_tranNo) then
	return -1	
end IF

--VALIDASI guo_func.set_number(ls_tranTypeCode, ll_tranNo)
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

----END VALIDASI---------------

==================================================
--Apply Open Credits
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if not uo_subs_advar.setAcctNo(ls_acctno) then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = uo_subs_advar.lastSQLCode + '~r~n' + uo_subs_advar.lastSQLErrText
	return -1
end IF

--VALIDASI uo_subs_advar.setAcctNo(ls_acctno)

	acctNo = as_acctNo
	dw_ar.reset()
	dw_adv.reset()
	dw_applofoc_hdr.reset()
	dw_applofoc_dtl.reset()
	dw_glentries.reset()
	
	select accountTypeCode, currencyCode into :accountTypeCode, :subsCurrencyCode
	from   arAccountMaster 
	where  acctNo = :acctNo
	and    companyCode = :gs_companyCode
	and    divisionCode = :gs_divisionCode
	using  SQLCA;
	if SQLCA.sqlcode < 0 then
		lastSQLCode		= string(SQLCA.sqlcode)
		lastSQLErrText	= SQLCA.sqlerrtext + ' - {arAccountmaster}'
		return FALSE
	elseif SQLCA.sqlcode = 100 then
		lastSQLCode		= string(SQLCA.sqlcode)
		lastSQLErrText	= "The account number you've just entered does not exist. - {arAccountMaster}"
		return FALSE
	end if
	
	if trim(accountTypeCode) = 'ARSUB' then
		
		select arAcctSubscriber.dateApplied,
				 arAcctSubscriber.dateInstalled, 
				 arAcctSubscriber.dateAutoDeactivated,
				 arAcctSubscriber.dateManualDeactivated,
				 arAcctSubscriber.datePermanentlyDisconnected,
				 arAcctSubscriber.dateReactivated,
				 arAcctSubscriber.subscriberStatusCode,
				 arAcctAddress.municipalityCode,
				 arAccountMaster.currencyCode	//added codes
		  into :dateApplied,
				 :dateInstalled,
				 :dateAutoDeactivated,
				 :dateManualDeactivated,
				 :datePermanentlyDisconnected,
				 :dateReactivated,
				 :subscriberStatusCode,
				 :municipalityCode,
				 :subsCurrencyCode	//added codes
		  from arAcctSubscriber
				 inner join arAccountMaster on  arAccountMaster.acctNo  = arAcctSubscriber.acctNo 
						  and arAccountMaster.divisionCode = arAcctSubscriber.divisioncode
						  and arAccountMaster.companyCode = arAcctSubscriber.companycode
				 inner join arAcctAddress on arAcctAddress.acctNo  = arAcctSubscriber.acctNo
						  and arAcctAddress.addressTypeCode = 'SERVADR1' 
						  and arAcctAddress.divisionCode = aracctsubscriber.divisioncode
						  and arAcctAddress.companyCode = aracctsubscriber.companycode
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
		
	end if	
	
	select subjectToVat
	  into :subjectToVat
	  from municipalityMaster
	 where municipalityCode = :municipalityCode
	 using SQLCA;
	if SQLCA.sqlcode < 0 then
		lastSQLCode		= string(SQLCA.sqlcode)
		lastSQLErrText	= SQLCA.sqlerrtext
		return FALSE
	elseif SQLCA.sqlcode = 100 then
		subjectToVat = 'N'
	end if
	
	//added codes for currency
	select conversionRate
	into   :conversionRate
	from   currencyMaster
	where  currencyCode = :subsCurrencyCode
	using  SQLCA;
	if SQLCA.SQLCode < 0 then
		lastSQLCode	= string(SQLCA.SQLCode)
		lastSQLErrText	= SQLCA.SQLErrText
		return FALSE
	elseif SQLCA.SQLCode = 100 then
		lastSQLCode	= string(SQLCA.SQLCode)
		lastSQLErrText	= 'The currencyCode [ ' + subsCurrencyCode + ' ] does not exist.'
		return FALSE
	end if
	
	select conversionRate
	into   :dollarRate
	from   currencyMaster
	where  currencyCode = 'USD'
	using SQLCA;
	if SQLCA.SQLCode < 0 then
		lastSQLCode	= string(SQLCA.SQLCode)
		lastSQLErrText	= SQLCA.SQLErrText
		return FALSE
	end if
	//end
	
	return TRUE
	-------------END VALIDASI

if	This.Event ue_applyOCBalances(ld_totalInstFee) <> 0 then
	return -1	
end IF

--VALIDASI ue_applyOCBalances(ld_totalInstFee)
if not uo_subs_advar.getOcNextTranNo() then
	is_msgno = 'SM-0000001'
	is_msgtrail = uo_subs_advar.lastSQLCode + "~r~n" + uo_subs_advar.lastSQLErrText
	is_sugtrail = 'Error produced by uo_subs_advar.getOcNextTranNo()'
	return -1
end IF

	--VALIDASI uo_subs_advar.getOcNextTranNo()
	astMethodAccessed = 'getOCNextTranNo'
	
	long ll_tranNo
	if not guo_func.get_nextnumber('OPENCR', ll_tranNo, 'WITH LOCK') then	
		lastSQLCode = '-2'
		lastSQLErrText = 'Could not obtain the next OC No.'
		return FALSE
	end IF	
	
	--VALIDASI guo_func.get_nextnumber('OPENCR', ll_tranNo, 'WITH LOCK')
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
-------END VALIDASI --------------------------

--decrement to 1 to avoid jumping of transaction number
--incase there is an error in saving later on
ocTranNo = ll_tranNo - 1

return TRUE
--END VALIDASI-----------------------

	if not uo_subs_advar.setParentTranNo(is_tranNo) then
		is_msgno = 'SM-0000001'
		is_msgtrail = uo_subs_advar.lastSQLCode + "~r~n" + uo_subs_advar.lastSQLErrText
		is_sugtrail = 'Error produced by uo_subs_advar.setParentTranNo()'
		return -1
	end IF
	
	---VALIDASI uo_subs_advar.setParentTranNo(is_tranNo)
	parentTranNo = as_tranNo
	return TRUE
	--END VALIDASI

if not uo_subs_advar.setJoReferenceNo('') then
	is_msgno = 'SM-0000001'
	is_msgtrail = uo_subs_advar.lastSQLCode + "~r~n" + uo_subs_advar.lastSQLErrText
	is_sugtrail = 'Error produced by uo_subs_advar.setJoReferenceNo()'
	return -1
end IF

---VALIDASI uo_subs_advar.setJoReferenceNo('')
joRefTranNo = as_joRefNo
return TRUE
--END VALIDASI

if not uo_subs_advar.setJoTranTypeCode(is_transactionID) then
	is_msgno = 'SM-0000001'
	is_msgtrail = uo_subs_advar.lastSQLCode + "~r~n" + uo_subs_advar.lastSQLErrText
	is_sugtrail = 'Error produced by uo_subs_advar.setJoTranTypeCode()'
	return -1
end IF

---VALIDASI uo_subs_advar.setJoTranTypeCode(is_transactionID)
	joTranTypeCode = as_joTranTypeCode
	return TRUE
--END VALIDASI

if not uo_subs_advar.setParentTranTypeCode(is_transactionID) then
	is_msgno = 'SM-0000001'
	is_msgtrail = uo_subs_advar.lastSQLCode + "~r~n" + uo_subs_advar.lastSQLErrText
	is_sugtrail = 'Error produced by uo_subs_advar.setParentTranTypeCode()'
	return -1
end IF

---VALIDASI uo_subs_advar.setParentTranTypeCode(is_transactionID)
	parentTranTypeCode = as_tranTypeCode
	return TRUE
--END VALIDASI

if not iuo_currency.setCurrencyCode(iuo_subscriber.currencyCode) then
	is_msgno = 'SM-0000001'
	is_msgtrail = iuo_currency.lastSQLCode + "~r~n" + iuo_currency.lastSQLErrText
	is_sugtrail = 'Error produced by iuo_currency.setCurrencyCode()'
	return -1
end IF

---VALIDASI iuo_currency.setCurrencyCode(iuo_subscriber.currencyCode)
	lastMethodAccessed = 'setCurrencyCode'

	select currencyName, conversionRate, currencyType
	into :currencyName, :conversionRate, :currencyType
	from currencyMaster
	where currencyCode = :as_currencyCode
	using SQLCA;
	if SQLCA.SQLCode < 0 then
		lastSQLCode	= string(SQLCA.SQLCode)
		lastSQLErrText	= SQLCA.SQLErrText
		return FALSE
	elseif SQLCA.SQLCode = 100 then
		lastSQLCode	= string(SQLCA.SQLCode)
		lastSQLErrText	= 'The currency code [' + as_currencyCode + '] does not exist'
		return FALSE
	end if
	
	return TRUE
--END VALIDASI
	
if ad_applicationFee > 0 then
	if not uo_subs_advar.insertNewAr(is_tranno, is_transactionID, 'SFEXT', ad_applicationFee, idt_trandate, string(idt_trandate, 'mmm yyyy'), iuo_subscriber.currencyCode, iuo_currency.conversionRate) then
		is_msgno = 'SM-0000001'
		is_msgtrail = uo_subs_advar.lastSQLCode + "~r~n" + uo_subs_advar.lastSQLErrText
		is_sugtrail = 'Error produced by uo_subs_advar.insertNewAr()'
		return -1
	end IF
	
	--VALIDASI uo_subs_advar.insertNewAr(is_tranno, is_transactionID, 'SFEXT', ad_applicationFee, idt_trandate, string(idt_trandate, 'mmm yyyy'), iuo_subscriber.currencyCode, iuo_currency.conversionRate)
	--==================================================
	--NGLara | 06/14/2007
	--This is the latest method, the old one may be
	--removed after we finalized all updates
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
	string	ls_glAccountCode
	long		ll_row
	integer	li_priority
	
	lastMethodAccessed = 'insertNewAR'
	
	
	select priority
	  into :li_priority
	  from arTypeMaster
	 where arTypeCode = :as_arTypeCode
	 and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	using SQLCA;
	if SQLCA.sqlcode < 0 then
		lastSQLCode = string(SQLCA.sqlcode)
		lastSQLErrText = SQLCA.sqlerrtext
		return FALSE
	elseif SQLCA.sqlcode = 100 then
		lastSQLCode = string(SQLCA.sqlcode)
		lastSQLErrText = 'Unable to get the level of priority of AR Type Code: ' + as_arTypeCode
		return FALSE
	end if
	
	ll_row = dw_ar.insertrow(0)
	dw_ar.setitem(ll_row, "tranno"				, as_tranno			)
	dw_ar.setitem(ll_row, "trantypecode"		, as_trantypecode	)
	dw_ar.setitem(ll_row, "artypecode"			, as_artypecode	)
	dw_ar.setitem(ll_row, "artypecodepriority", li_priority		)
	dw_ar.setitem(ll_row, "balance"				, ad_balance		)
	dw_ar.setitem(ll_row, "newbalance"			, ad_balance		)
	dw_ar.setitem(ll_row, "trandate"				, adt_trandate		)
	dw_ar.setitem(ll_row, "remarks"				, as_remarks		)
	dw_ar.setitem(ll_row, "artypename"			, ''					)
	dw_ar.setitem(ll_row, "newrecord"			, 'Y'					)
	dw_ar.setitem(ll_row, "transactionid"		, ''					)
	dw_ar.setitem(ll_row, "groupsort"			, 3					)
	dw_ar.setitem(ll_row, "currencyCode"		, as_currencyCode )
	dw_ar.setitem(ll_row, "conversionRate"		, ad_conversionRate )
	
	return TRUE
	--END VALIDASI
	
end if

	if not uo_subs_advar.applyOpenCreditMultiple('', '') then
		is_msgno = 'SM-0000001'
		is_msgtrail = uo_subs_advar.lastSQLCode + "~r~n" + uo_subs_advar.lastSQLErrText
		is_sugtrail = 'Error produced by uo_subs_advar.applyOcToBalances()'
		return -1
	end IF
	
	--VALIDASI uo_subs_advar.applyOpenCreditMultiple('', '')
	--========================================================================================================================
	--NGLara | 06/23/2007
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	string		ls_glAccountCode, ls_glForex
	string		ls_refoctranno, ls_refoctypecode, ls_documentno, ls_trantypecode, ls_artypecode, ls_octranno, ls_ocTranTypecode
	string		ls_sourceOcTypeCode, ls_sourceOcRefTranNo, ls_sourceOcTranTypeCode, ls_xoctranno, ls_sourcetable
	decimal{2}	ld_adv_balance, ld_adv_appliedamt
	decimal{2}	ld_ar_curr_newbalance, ld_ar_balance
	decimal{2}	ld_ar_curr_paidamt, ld_ar_paidamt, ld_appliedToRIP
	long			ll_adv_records, ll_adv_row
	long			ll_ar_records, ll_ar_row, ll_applofoc_row, ll_row
	boolean		lb_ocapplied
	
	string		ls_currencyCode, ls_ocCurrencyCode										//
	decimal{2}	ld_conversionRate, ld_ocConversionRate, ld_forexAmount			//added codes for currency
	decimal{30} ld_adv_appliedamt_usd, ld_adv_balance_usd, ld_ar_paidamt_usd	//
	
	lastMethodAccessed = 'applyOpenCreditMultiple'
	
	if isnull(parentTranNo) or isnull(parentTranTypeCode) then
		lastSQLCode = '-2'
		lastSQLErrText = 'Unable to continue, parentTranNo and parentTranTypeCode must have been set a value.'
		return FALSE
	end if

	if isNull(tranCurrencyCode) then
		tranCurrencyCode = subsCurrencyCode
		tranConversionRate = 1
	end if
	
	f_displayStatus('Extracting Advances...')
	if as_refTranTypeCode = '' and as_refTranNo = '' then
		if not extractSubsAdvAndCM() then
			return FALSE
		end if
	else
		if not extractSubsAdvAndCMExcept(as_refTranTypeCode, as_refTranNo) then
			return FALSE
		end if
	end if
	
	f_displayStatus('Extacting AR Balances...')
	if not extractArBalances() then
		return FALSE
	end if
	
	dw_ar.SetSort('groupSort A, tranDate A, arTypeCodePriority A, tranNo A')
	dw_ar.Sort()
	
	dw_applofoc_hdr.reset()
	dw_applofoc_dtl.reset()
	
	ll_adv_records = dw_adv.rowcount()
	dw_adv.setsort('trandate A, octypecodepriority A')
	dw_adv.sort()
for ll_adv_row = 1 to ll_adv_records
	
	f_displayStatus('Applying OC Type [' + ls_refOcTypecode + ']...')

	lb_ocapplied = FALSE
		
	--========================================================
	--added codes for currency
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	if subsCurrencyCode = 'USD' then
		ld_adv_appliedamt_usd	= dw_adv.object.appliedAmt[ll_adv_row]
		ld_adv_balance_usd		= dw_adv.object.newBalance[ll_adv_row]
	elseif subsCurrencyCode = 'PHP' then
		ld_adv_appliedamt 	= dw_adv.object.appliedAmt[ll_adv_row]
		ld_adv_balance 		= dw_adv.object.newBalance[ll_adv_row]
	end if	
	--========================================================
	--end
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
	ls_xoctranno				= trim(dw_adv.object.tranNo[ll_adv_row])
	ls_refOctranNo				= trim(dw_adv.object.refTranNo[ll_adv_row])
	ls_refOcTypecode			= trim(dw_adv.object.octypecode[ll_adv_row])
	ls_ocTranTypecode			= trim(dw_adv.object.trantypecode[ll_adv_row])
	ls_sourceOcTypeCode		= trim(dw_adv.object.sourceOcTypeCode[ll_adv_row])
	ls_sourceOcRefTranNo		= trim(dw_adv.object.sourceOcRefTranNo[ll_adv_row])
	ls_sourceOcTranTypeCode	= trim(dw_adv.object.sourceOcTranTypeCode[ll_adv_row])
	ls_ocCurrencyCode			= trim(dw_adv.object.currencyCode[ll_adv_row])
	ld_ocConversionRate		= dw_adv.object.conversionRate[ll_adv_row]
	
	--==================================================
	--basically, this is being used by w_reapply_oc
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
	if isnull(parentTranNo) or parentTranNo = '' then
		parentTranNo = ls_refOctranNo
	end if	
	if isnull(parentTranTypeCode) or parentTranTypeCode = '' then
		parentTranTypeCode = ls_ocTranTypeCode
	end if
	--==================================================
	--end
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	

	--==============================================================
	--Just to make sure that subscription and equipment deposits and 
	--incentive will not be applied to any accounts receivables
	--
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	if ls_refoctypecode = 'SUBSDEP' or ls_refoctypecode = 'SUBSDEQ' then continue
	if ls_refoctypecode = 'ADVDEP' or ls_refoctypecode = 'SECDEP' then continue  --//for leasing -zar 03022010
	
	ll_ar_records = dw_ar.rowcount()
		for ll_ar_row = 1 to ll_ar_records
			
			f_displayStatus('Applying OC Type [' + ls_refOcTypecode + '] to [' + ls_artypecode + ']...')
	
			ld_ar_paidamt 			= 0
			ld_ar_paidamt_usd		= 0	//added codes for currency
	
			ls_documentno			= dw_ar.getitemstring(ll_ar_row, 'tranno'				)
			ls_trantypecode		= dw_ar.getitemstring(ll_ar_row, 'trantypecode'		)
			ls_artypecode			= trim(dw_ar.getitemstring(ll_ar_row, 'artypecode'	))
			
			ld_ar_curr_paidamt 	= dw_ar.getitemdecimal(ll_ar_row, 'paidamt'			)
			ld_ar_curr_newbalance= dw_ar.getitemdecimal(ll_ar_row, 'newbalance'		)
			
			ls_sourcetable			= dw_ar.getitemstring(ll_ar_row, 'sourcetable'		)
			
			ls_currencyCode		= dw_ar.getitemString(ll_ar_row, 'currencycode'		)		//added codes
			ld_conversionRate		= dw_ar.getitemDecimal(ll_ar_row, 'conversionrate'	)	//for currency
			
			
			
			--added codes for verification of account types - ARCUS | ARLES | AROTH Does not automatically
			--apply OC not unless arTypeCode is a DEPOSIT Receivable
			if (ls_arTypeCode <> 'SCDEP' and  ls_arTypeCode <> 'ADDEP') and &
				 ( accountTypeCode = 'ARLES' or &
	 			   accountTypeCode = 'ARCUS' or &
				   accountTypeCode = 'AROTH' ) then continue
					
			--Meaning if accountype = 'ARLES|AROTH|ARCUS' and arType = 'SCDEP|ADDEP' - it will proceed application
				 		
			--==================================================
			--if the ls_refoctypecode is INCENTIVE, it should be
			--applied to monthly subscribtion fee only.
			--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			if ls_refoctypecode = 'INCENTIV' and &
				(ls_artypecode <> 'MAINF' and ls_artypecode <> 'EXTF' and ls_artypecode <> 'INSUF') then continue
			--==================================================
			--end
			--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			
			
			--==================================================
			--if the ls_refoctypecode is CM, it should not be
			--applied to RIP for Advances and Deposit Req's
			--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			if ls_refoctypecode = 'CM' and (ls_artypecode = 'OCADV' or ls_artypecode = 'OCDEP' or ls_artypecode = 'OCDEQ') then continue
			--==================================================
			--end
			--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
			if isnull(ld_ar_curr_paidamt) then ld_ar_curr_paidamt = 0
			if isnull(ld_ar_curr_newbalance) then ld_ar_curr_newbalance = 0
			
			ld_ar_curr_newbalance = ld_ar_curr_newbalance
			
			if (ld_ar_curr_newbalance) > 0 then	// para next time pamagbalik na...
				
				--========================================================
				--added codes for currency
				--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				if subsCurrencyCode = 'USD' then //here
					if (ld_adv_balance_usd) >= ld_ar_curr_newbalance then
						ld_ar_paidamt_usd	= ld_ar_curr_newbalance
						ld_ar_curr_newbalance = 0
					else
						ld_ar_paidamt_usd	= (ld_adv_balance_usd)
						ld_ar_curr_newbalance = ld_ar_curr_newbalance - ld_ar_paidamt_usd
					end if
	
					dw_ar.setitem(ll_ar_row, 'paidamt', ld_ar_paidamt_usd + ld_ar_curr_paidamt)
					dw_ar.setitem(ll_ar_row, 'newbalance', ld_ar_curr_newbalance)
				elseif subsCurrencyCode = 'PHP' then
					if (ld_adv_balance) >= ld_ar_curr_newbalance then
						ld_ar_paidamt 		= ld_ar_curr_newbalance
						ld_ar_curr_newbalance = 0
					else
						ld_ar_paidamt 		= (ld_adv_balance)
						ld_ar_curr_newbalance = ld_ar_curr_newbalance - ld_ar_paidamt	
					end if
	
					dw_ar.setitem(ll_ar_row, 'paidamt', ld_ar_paidamt + ld_ar_curr_paidamt)
					dw_ar.setitem(ll_ar_row, 'newbalance', ld_ar_curr_newbalance)
				end if	
				--========================================================
				--end
				--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
				--let's record the application detail first...
				ll_applofoc_row = dw_applofoc_dtl.insertrow(0)
				dw_applofoc_dtl.scrolltorow(ll_applofoc_row)
				dw_applofoc_dtl.setitem(ll_applofoc_row, 'documentno'		, ls_documentno	)
				dw_applofoc_dtl.setitem(ll_applofoc_row, 'trantypecode'	, ls_trantypecode	)
				dw_applofoc_dtl.setitem(ll_applofoc_row, 'artypecode'		, ls_artypecode	)
	
				--========================================================
				--added codes for currency
				--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				if subsCurrencyCode = 'USD' then
					
	
					if not f_getGLIAccount('GLOFCADJR',ls_glForex,lastSQLErrText) then
						lastSQLCode = '-2'					
						return FALSE
					end if	
					
					dw_applofoc_dtl.setitem(ll_applofoc_row, 'appliedamt'		, ld_ar_paidamt_usd	)
	
					ld_forexAmount = (ld_ar_paidamt_usd * dollarRate)/*current*/ - (ld_ar_paidamt_usd * ld_conversionRate)/*previous*/
					dw_applofoc_dtl.setitem(ll_applofoc_row, 'forexamount', ld_forexAmount)
	
					if ld_forexAmount < 0 then //loss				
						ld_forexAmount = ld_forexAmount * -1
						iuo_glPoster.insertGLEntryDebit('', '', ls_glForex, ld_forexAmount)										
					else                       //gain
						iuo_glPoster.insertGLEntryCredit('', '', ls_glForex, ld_forexAmount)				  																
					end if
	
				elseif subsCurrencyCode = 'PHP' then
		
					dw_applofoc_dtl.setitem(ll_applofoc_row, 'appliedamt'		, ld_ar_paidamt	)
					dw_applofoc_dtl.setitem(ll_applofoc_row, 'forexamount', 0)
	
				end IF
				
				--========================================================
				--end
				--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				
				dw_applofoc_dtl.setitem(ll_applofoc_row, 'recordnumber'	, ll_adv_row		)
				dw_applofoc_dtl.setitem(ll_applofoc_row, 'currencycode'	, ls_currencyCode )	//added codes
				dw_applofoc_dtl.setitem(ll_applofoc_row, 'conversionrate', ld_conversionRate)	//for currency
	
				lb_ocapplied = TRUE
	
				--========================================================
				--added codes for currency
				--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				if subsCurrencyCode = 'USD' then
					ld_adv_balance_usd		= ld_adv_balance_usd - ld_ar_paidamt_usd
					ld_adv_appliedamt_usd	= ld_adv_appliedamt_usd + ld_ar_paidamt_usd
					ld_ar_paidamt = ld_ar_paidamt_usd
				elseif subsCurrencyCode = 'PHP' then
					ld_adv_balance 	= ld_adv_balance - ld_ar_paidamt
					ld_adv_appliedamt = ld_adv_appliedamt + ld_ar_paidamt
				end if	
				--========================================================
				--end
				--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
			end if
			
			if ls_sourcetable = 'SDR' or ls_sourcetable = 'RIP' then
				if ls_artypecode = 'OCDEP' and ld_ar_paidamt > 0 then
					ocTranNo = ocTranNo + 1
					ls_octranno = string(ocTranNo, '00000000')		
					ll_row = dw_adv.insertrow(0)
					dw_adv.scrolltorow(ll_row)
					dw_adv.setitem(ll_row, 'tranno'			, ls_octranno			)
					dw_adv.setitem(ll_row, 'octypecode'		, 'SUBSDEP'				)
					dw_adv.setitem(ll_row, 'appliedamt'		, 0						)
	
					--========================================================
					--added codes for currency
					--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
					if subsCurrencyCode = 'USD' then
						dw_adv.setitem(ll_row, 'balance'			, ld_ar_paidamt_usd	)
						dw_adv.setitem(ll_row, 'newbalance'		, ld_ar_paidamt_usd	)
					elseif subsCurrencyCode = 'PHP' then
						dw_adv.setitem(ll_row, 'balance'			, ld_ar_paidamt		)
						dw_adv.setitem(ll_row, 'newbalance'		, ld_ar_paidamt		)
					end if
					--========================================================
					--end
					--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
					dw_adv.setitem(ll_row, 'newrecord'		, 'Y'								)
					dw_adv.setitem(ll_row, 'reftranno'		, parentTranNo					)
					dw_adv.setitem(ll_row, 'trantypecode'	, parentTranTypeCode			)
					dw_adv.setitem(ll_row, 'sourceOcTypeCode'	, ls_refOcTypecode 		)
					dw_adv.setitem(ll_row, 'sourceOcRefTranNo', ls_refOctranNo 			)
					dw_adv.setitem(ll_row, 'sourceOcTranTypeCode', ls_ocTranTypeCode 	)
					dw_adv.setitem(ll_row, 'currencyCode', ls_ocCurrencyCode 			)
					dw_adv.setitem(ll_row, 'conversionRate', ld_ocConversionRate 		)
					dw_adv.setitem(ll_row, 'refApplTranTypeCode', ls_trantypecode		)
					dw_adv.setitem(ll_row, 'refApplTranNo', ls_documentNo			 		)
					
					
				elseif ls_artypecode = 'OCDEQ' and ld_ar_paidamt > 0 then
					ocTranNo = ocTranNo + 1
					ls_octranno = string(ocTranNo, '00000000')		
					ll_row = dw_adv.insertrow(0)
					dw_adv.scrolltorow(ll_row)
					dw_adv.setitem(ll_row, 'tranno'			, ls_octranno					)
					dw_adv.setitem(ll_row, 'octypecode'		, 'SUBSDEQ'						)
					dw_adv.setitem(ll_row, 'appliedamt'		, 0								)
	
					--========================================================
					--added codes for currency
					--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
					if subsCurrencyCode = 'USD' then
						dw_adv.setitem(ll_row, 'balance'			, ld_ar_paidamt_usd		)
						dw_adv.setitem(ll_row, 'newbalance'		, ld_ar_paidamt_usd		)
					elseif subsCurrencyCode = 'PHP' then
						dw_adv.setitem(ll_row, 'balance'			, ld_ar_paidamt			)
						dw_adv.setitem(ll_row, 'newbalance'		, ld_ar_paidamt			)
					end if
					--========================================================
					--end
					--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
					
					dw_adv.setitem(ll_row, 'newrecord'		, 'Y'								)
					dw_adv.setitem(ll_row, 'reftranno'		, parentTranNo					)
					dw_adv.setitem(ll_row, 'trantypecode'	, parentTranTypeCode			)
					dw_adv.setitem(ll_row, 'sourceOcTypeCode'	, ls_refOcTypecode 		)
					dw_adv.setitem(ll_row, 'sourceOcRefTranNo', ls_refOctranNo 			)
					dw_adv.setitem(ll_row, 'sourceOcTranTypeCode', ls_ocTranTypeCode 	)
					dw_adv.setitem(ll_row, 'currencyCode', ls_ocCurrencyCode 			)
					dw_adv.setitem(ll_row, 'conversionRate', ld_ocConversionRate 		)
					dw_adv.setitem(ll_row, 'refApplTranTypeCode', ls_trantypecode		)
					dw_adv.setitem(ll_row, 'refApplTranNo', ls_documentNo			 		)
					
				elseif ls_artypecode = 'ADDEP' and ld_ar_paidamt > 0 then             // for leasing -zar-03022010
					ocTranNo = ocTranNo + 1
					ls_octranno = string(ocTranNo, '00000000')		
					ll_row = dw_adv.insertrow(0)
					dw_adv.scrolltorow(ll_row)
					dw_adv.setitem(ll_row, 'tranno'			, ls_octranno					)
					dw_adv.setitem(ll_row, 'octypecode'		, 'ADVDEP'						)
					dw_adv.setitem(ll_row, 'appliedamt'		, 0								)
	
					--========================================================
					--added codes for currency
					--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
					if subsCurrencyCode = 'USD' then
						dw_adv.setitem(ll_row, 'balance'			, ld_ar_paidamt_usd		)
						dw_adv.setitem(ll_row, 'newbalance'		, ld_ar_paidamt_usd		)
					elseif subsCurrencyCode = 'PHP' then
						dw_adv.setitem(ll_row, 'balance'			, ld_ar_paidamt			)
						dw_adv.setitem(ll_row, 'newbalance'		, ld_ar_paidamt			)
					end if
					--========================================================
					--end
					--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
					
					dw_adv.setitem(ll_row, 'newrecord'		, 'Y'								)
					dw_adv.setitem(ll_row, 'reftranno'		, parentTranNo					)
					dw_adv.setitem(ll_row, 'trantypecode'	, parentTranTypeCode			)
					dw_adv.setitem(ll_row, 'sourceOcTypeCode'	, ls_refOcTypecode 		)
					dw_adv.setitem(ll_row, 'sourceOcRefTranNo', ls_refOctranNo 			)
					dw_adv.setitem(ll_row, 'sourceOcTranTypeCode', ls_ocTranTypeCode 	)
					dw_adv.setitem(ll_row, 'currencyCode', ls_ocCurrencyCode 			)
					dw_adv.setitem(ll_row, 'conversionRate', ld_ocConversionRate 		)
					dw_adv.setitem(ll_row, 'refApplTranTypeCode', ls_trantypecode		)
					dw_adv.setitem(ll_row, 'refApplTranNo', ls_documentNo			 		)
					
				elseif ls_artypecode = 'SCDEP' and ld_ar_paidamt > 0 then	         --// for leasing -zar-03022010
					ocTranNo = ocTranNo + 1
					ls_octranno = string(ocTranNo, '00000000')		
					ll_row = dw_adv.insertrow(0)
					dw_adv.scrolltorow(ll_row)
					dw_adv.setitem(ll_row, 'tranno'			, ls_octranno					)
					dw_adv.setitem(ll_row, 'octypecode'		, 'SECDEP'						)
					dw_adv.setitem(ll_row, 'appliedamt'		, 0								)
	
					--========================================================
					--added codes for currency
					--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
					if subsCurrencyCode = 'USD' then
						dw_adv.setitem(ll_row, 'balance'			, ld_ar_paidamt_usd		)
						dw_adv.setitem(ll_row, 'newbalance'		, ld_ar_paidamt_usd		)
					elseif subsCurrencyCode = 'PHP' then
						dw_adv.setitem(ll_row, 'balance'			, ld_ar_paidamt			)
						dw_adv.setitem(ll_row, 'newbalance'		, ld_ar_paidamt			)
					end IF
					
					--========================================================
					--end
					--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
					
					dw_adv.setitem(ll_row, 'newrecord'		, 'Y'								)
					dw_adv.setitem(ll_row, 'reftranno'		, parentTranNo					)
					dw_adv.setitem(ll_row, 'trantypecode'	, parentTranTypeCode			)
					dw_adv.setitem(ll_row, 'sourceOcTypeCode'	, ls_refOcTypecode 		)
					dw_adv.setitem(ll_row, 'sourceOcRefTranNo', ls_refOctranNo 			)
					dw_adv.setitem(ll_row, 'sourceOcTranTypeCode', ls_ocTranTypeCode 	)
					dw_adv.setitem(ll_row, 'currencyCode', ls_ocCurrencyCode 			)
					dw_adv.setitem(ll_row, 'conversionRate', ld_ocConversionRate 		)
					dw_adv.setitem(ll_row, 'refApplTranTypeCode', ls_trantypecode		)
					dw_adv.setitem(ll_row, 'refApplTranNo', ls_documentNo			 		)
				elseif ls_arTypeCode = 'OCADV' and ld_ar_paidamt > 0 then
					
					ocTranNo = ocTranNo + 1
					ls_octranno = string(ocTranNo, '00000000')		
					ll_row = dw_adv.insertrow(0)
					dw_adv.scrolltorow(ll_row)
					dw_adv.setitem(ll_row, 'tranno'			, ls_octranno					)
					dw_adv.setitem(ll_row, 'octypecode'		, 'SUBSADV'						)
					dw_adv.setitem(ll_row, 'appliedamt'		, 0								)
	
					--========================================================
					--added codes for currency
					--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
					
					if subsCurrencyCode = 'USD' then
						dw_adv.setitem(ll_row, 'balance'			, ld_ar_paidamt_usd		)
						dw_adv.setitem(ll_row, 'newbalance'		, ld_ar_paidamt_usd		)
					elseif subsCurrencyCode = 'PHP' then
						dw_adv.setitem(ll_row, 'balance'			, ld_ar_paidamt			)
						dw_adv.setitem(ll_row, 'newbalance'		, ld_ar_paidamt			)
					end IF
					
					--========================================================
					--end
					--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
					
					dw_adv.setitem(ll_row, 'newrecord'		, 'R'								)
					dw_adv.setitem(ll_row, 'reftranno'		, parentTranNo					)
					dw_adv.setitem(ll_row, 'trantypecode'	, parentTranTypeCode			)
					dw_adv.setitem(ll_row, 'sourceOcTypeCode'	, ls_refOcTypecode 		)
					dw_adv.setitem(ll_row, 'sourceOcRefTranNo', ls_refOctranNo 			)
					dw_adv.setitem(ll_row, 'sourceOcTranTypeCode', ls_ocTranTypeCode 	)
					dw_adv.setitem(ll_row, 'currencyCode', ls_ocCurrencyCode 			)
					dw_adv.setitem(ll_row, 'conversionRate', ld_ocConversionRate 		)
					dw_adv.setitem(ll_row, 'refApplTranTypeCode', ls_trantypecode		)
					dw_adv.setitem(ll_row, 'refApplTranNo', ls_documentNo			 		)				
								
				end if		
			end if
			
			--========================================================
			--added codes for currency
			--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			if subsCurrencyCode = 'USD' then
				if (ld_adv_balance_usd) <= 0 then exit
			elseif subsCurrencyCode = 'PHP' then
				if (ld_adv_balance) <= 0 then exit
			end if	
			
		next
	
		--========================================================
		--added codes for currency
		--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		if subsCurrencyCode = 'USD' then
			dw_adv.setitem(ll_adv_row, 'appliedamt', ld_adv_appliedamt_usd)
			dw_adv.setitem(ll_adv_row, 'newbalance', ld_adv_balance_usd)
		elseif subsCurrencyCode = 'PHP' then
			dw_adv.setitem(ll_adv_row, 'appliedamt', ld_adv_appliedamt)
			dw_adv.setitem(ll_adv_row, 'newbalance', ld_adv_balance)
		end if	
		
		if lb_ocapplied then
			ll_applofoc_row = dw_applofoc_hdr.insertrow(0)
			dw_applofoc_hdr.scrolltorow(ll_applofoc_row)
	
			--========================================================
			--added codes for currency
			--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			
			if subsCurrencyCode = 'USD' then
				dw_applofoc_hdr.setitem(ll_applofoc_row, 'ocamt'			, ld_adv_balance_usd + ld_adv_appliedamt_usd)
				dw_applofoc_hdr.setitem(ll_applofoc_row, 'appliedocamt'	, ld_adv_appliedamt_usd						)
			elseif subsCurrencyCode = 'PHP' then
				dw_applofoc_hdr.setitem(ll_applofoc_row, 'ocamt'			, ld_adv_balance + ld_adv_appliedamt)
				dw_applofoc_hdr.setitem(ll_applofoc_row, 'appliedocamt'	, ld_adv_appliedamt						)
			end if
			
			if not tranCurrencyCode = '' then
				ls_currencyCode = tranCurrencyCode
			end if
			
			if not tranConversionRate = 0 then
				ld_conversionRate = tranConversionRate
			end if
			
			
			dw_applofoc_hdr.setitem(ll_applofoc_row, 'refoctranno'	, ls_xoctranno								)
			dw_applofoc_hdr.setitem(ll_applofoc_row, 'refoctypecode'	, ls_refoctypecode						)
			dw_applofoc_hdr.setitem(ll_applofoc_row, 'recordnumber'	, ll_adv_row								)
			dw_applofoc_hdr.setitem(ll_applofoc_row, 'currencycode'	, ls_ocCurrencyCode						)
			dw_applofoc_hdr.setitem(ll_applofoc_row, 'conversionrate', ld_ocConversionRate					)
		end if
		
		--========================================================
		--NGLara | 12-19-2007
		--If in case there is a remaining balance no the applied
		--applicant's advance
		--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		if (ld_adv_balance > 0 or ld_adv_balance_usd > 0) and ls_refOcTypecode = 'APPLADV' then
			
			string ls_openCreditAccount
			// =======================================================
			// 		insert GL Entry: Debit Applicant's Advances
			// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			if not getGLIAccount(ls_refOcTypecode, ls_openCreditAccount) then
				return FALSE
			end if
			if subsCurrencyCode = 'USD' then
				iuo_glPoster.insertGLEntryDebit('SAV-AOCM-DB', '', ls_openCreditAccount, ld_adv_balance_usd)
			else
				iuo_glPoster.insertGLEntryDebit('SAV-AOCM-DB', '', ls_openCreditAccount, ld_adv_balance)
			end if
			
			
			ocTranNo = ocTranNo + 1
			ls_octranno = string(ocTranNo, '00000000')		
			ll_row = dw_adv.insertrow(0)
			dw_adv.scrolltorow(ll_row)
			dw_adv.setitem(ll_row, 'tranno'			, ls_octranno					)
			dw_adv.setitem(ll_row, 'octypecode'		, 'SUBSADV'						)
			dw_adv.setitem(ll_row, 'appliedamt'		, 0								)
	
			--========================================================
			--added codes for currency
			--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			if subsCurrencyCode = 'USD' then
				dw_adv.setitem(ll_row, 'balance'			, ld_adv_balance_usd		)
				dw_adv.setitem(ll_row, 'newbalance'		, ld_adv_balance_usd		)
			elseif subsCurrencyCode = 'PHP' then
				dw_adv.setitem(ll_row, 'balance'			, ld_adv_balance			)
				dw_adv.setitem(ll_row, 'newbalance'		, ld_adv_balance			)
			end if
			
			dw_adv.setitem(ll_row, 'newrecord'		, 'Y'								)
			dw_adv.setitem(ll_row, 'reftranno'		, ls_xoctranno					)
			dw_adv.setitem(ll_row, 'trantypecode'	, ls_ocTranTypeCode			)
			dw_adv.setitem(ll_row, 'sourceOcTypeCode'	, ls_refOcTypecode 		)
			dw_adv.setitem(ll_row, 'sourceOcRefTranNo', ls_refOcTranNo			)
			dw_adv.setitem(ll_row, 'sourceOcTranTypeCode', ls_ocTranTypeCode 	)
			dw_adv.setitem(ll_row, 'currencyCode', ls_ocCurrencyCode 			)
			dw_adv.setitem(ll_row, 'conversionRate', ld_ocConversionRate 		)
			
			if subsCurrencyCode = 'USD' then
				dw_adv.setitem(ll_adv_row, 'appliedamt', ld_adv_appliedamt_usd + ld_adv_balance_usd)
				dw_adv.setitem(ll_adv_row, 'newbalance', 0)
			elseif subsCurrencyCode = 'PHP' then
				dw_adv.setitem(ll_adv_row, 'appliedamt', ld_adv_appliedamt + ld_adv_balance)
				dw_adv.setitem(ll_adv_row, 'newbalance', 0)
			end if	
		else
			if subsCurrencyCode = 'USD' then
				dw_adv.setitem(ll_adv_row, 'appliedamt', ld_adv_appliedamt_usd)
				dw_adv.setitem(ll_adv_row, 'newbalance', ld_adv_balance_usd)
			elseif subsCurrencyCode = 'PHP' then
				dw_adv.setitem(ll_adv_row, 'appliedamt', ld_adv_appliedamt)
				dw_adv.setitem(ll_adv_row, 'newbalance', ld_adv_balance)
			end if	
		end if
		
	next
	
	Return TRUE
	
	--END VALIDASI

	if not uo_subs_advar.setOcTranNo() then
		is_msgno = 'SM-0000001'
		is_msgtrail = uo_subs_advar.lastSQLCode + "~r~n" + uo_subs_advar.lastSQLErrText
		is_sugtrail = 'Error produced by uo_subs_advar.setOcTranNo()'
		return -1
	end IF
	
	--VALIDASI uo_subs_advar.setOcTranNo()
	lastMethodAccessed = 'setOCTranNo'

		if not guo_func.set_number('OPENCR', ocTranNo) then	
			lastSQLCode = '-2'
			lastSQLErrText = 'Could not set the next OC No.'
			return FALSE
		end IF
		
		--VALIDASI guo_func.set_number('OPENCR', ocTranNo)
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
		--END VALIDASI guo_func.set_number('OPENCR', ocTranNo)
	
	return TRUE
	
	---END VALIDASI

	if not uo_subs_advar.postOpenCreditUpdates() then
		is_msgno = 'SM-0000001'
		is_msgtrail = uo_subs_advar.lastSQLCode + "~r~n" + uo_subs_advar.lastSQLErrText
		is_sugtrail = 'Error produced by uo_subs_advar.postOpenCreditUpdates()'
		return -1
	end IF
	
	--VALIDASI uo_subs_advar.postOpenCreditUpdates()
	
	string		ls_octranno, ls_octypecode, ls_reftrantype, ls_sourceOcTypeCode, ls_sourceOcRefTranNo, ls_sourceOcTranTypeCode
	string 		ls_debitAccount, ls_openCreditAccount
	string		ls_reftranno, ls_reftrantypecode, ls_newrecord, ls_currencyCode, ls_refApplTranTypeCode, ls_refApplTranNo
	decimal{2}	ld_balance, ld_appliedamt, ld_newbalance, ld_conversionRate
	long			ll_records, ll_row, ll_octranno
	datetime		ldt_serverDate
	
	decimal{30} ld_balance_usd, ld_appliedamt_usd, ld_newbalance_usd	//added codes for currency
	
	lastMethodAccessed = 'postOpenCreditUpdates'
	
	ldt_serverDate = guo_func.get_server_date()
	
	--=========================================================
	--insert the new advances into ar open credit master if any,
	--update existing advances at the same time.
	--=========================================================
	
	f_displayStatus('Posting Open Credit Updates...')
	
	ll_records = dw_adv.rowcount()
	for ll_row = 1 to ll_records
		ls_octranno					= trim(dw_adv.getitemstring(ll_row, "tranno"						))
		ls_octypecode 				= trim(dw_adv.getitemstring(ll_row, "octypecode"				))
		ls_reftranno				= trim(dw_adv.getitemstring(ll_row, "reftranno"					))
		ls_reftrantypecode		= trim(dw_adv.getitemstring(ll_row, "trantypecode"				))
		ls_sourceOcTypeCode		= trim(dw_adv.getitemstring(ll_row, "sourceoctypecode"		))
		ls_sourceOcRefTranNo		= trim(dw_adv.getitemstring(ll_row, "sourceocreftranno"		))
		ls_sourceOcTranTypeCode	= trim(dw_adv.getitemstring(ll_row, "sourceoctrantypecode"	))
		ls_refApplTranTypeCode  = trim(dw_adv.getitemstring(ll_row, "refApplTranTypeCode"	))
		ls_refApplTranNo			= trim(dw_adv.getitemstring(ll_row, "refApplTranNo"			))
		ls_newrecord 				= dw_adv.getitemstring(ll_row, "newrecord"						)
		
		--=======================================================
		--
		--insert GL Entry: Credit Applicant/Subscription Advances
		--
		-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		
		if not f_getOCTypeGLAccount(ls_octypecode, ls_openCreditAccount, lastSQLErrText) then
			return FALSE
		end if
	
		--========================================================
		--added codes for currency
		--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		if subsCurrencyCode = 'USD' then
			ld_balance_usd			= dw_adv.getitemdecimal(ll_row, "balance"		)
			ld_balance = ld_balance_usd
		elseif subsCurrencyCode = 'PHP' then
			ld_balance				= dw_adv.getitemdecimal(ll_row, "balance"		)
		end if
		--========================================================
		--end
		--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		
		ld_appliedamt				= dw_adv.getitemdecimal(ll_row, "appliedamt"	)
		ld_newbalance				= dw_adv.getitemdecimal(ll_row, "newbalance"	)
		ls_currencyCode			= trim(dw_adv.getItemString(ll_row, "currencycode"	))
		ld_conversionRate			= dw_adv.getItemdecimal(ll_row, "conversionrate"	)
		
		if ls_newrecord = 'Y' or ls_newrecord = 'R' then
										 //R is when OCADV becomes SUBSADV
			f_displayStatus('Posting Open Credit Updates...(insert into arOpenCreditMaster)')
			insert into arOpenCreditMaster (
							tranno,   
							trandate,   
							acctNo,
							amount,   
							appliedamt,   
							balance,   
							octypeCode,   
							reftranno,   
							trantypecode,   
							sourceOcTypeCode, 
							sourceOcRefTranNo, 
							sourceOcTranTypeCode,
							useradd,   
							dateadd,
							currencyCode,
							conversionRate,
							refApplTranTypeCode,
							refApplTranNo,
							divisionCode,
							companyCode)
				  values (
				  			:ls_octranno,   
							:ldt_serverDate, 
							:acctNo, 
							:ld_balance,   
							:ld_appliedamt,   
							:ld_newbalance,   
							:ls_octypecode,   
							:ls_reftranno,   
							:ls_reftrantypecode,  
							:ls_sourceOcTypeCode, 
							:ls_sourceOcRefTranNo, 
							:ls_sourceOcTranTypeCode,
							:gs_username,   
							getdate(),
							:ls_currencyCode,		//added codes
							:ld_conversionRate,
							:ls_refApplTranTypeCode,
							:ls_refApplTranNo,
							:gs_divisionCode,
							:gs_companyCode)	//for currency
					using SQLCA;
			if SQLCA.sqlcode <> 0 then
				lastSQLCode = string(SQLCA.sqlcode)
				lastSQLErrText = SQLCA.sqlerrtext
				return FALSE
			end if
			
			f_displayStatus('Posting Open Credit Updates...(insertGLEntry)')
			
			--========================================================
			--added codes for currency
			--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			if subsCurrencyCode = 'USD' then
				ld_balance = ld_balance_usd * ld_conversionRate//conversionRate 8/23/2011-zar
			elseif subsCurrencyCode = 'PHP' then
				ld_balance = ld_balance * ld_conversionRate//conversionRate 8/23/2011-zar
			end if
			--========================================================
			--end
			--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			
			--==================================================
			--NGLara | 03-17-2008
			--Post GL Entry
			--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			if ls_newrecord = 'Y' then
				iuo_glPoster.insertGLEntryCredit('SAV-POC-CR', '', ls_openCreditAccount, ld_balance, 'increase subscriber advances')
			end if	
			--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
		else
			
			--=======================================================
			--Note: the process of debitting the open credit is in
			--  		postApplicationOfOpenCredit
			-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~		
			f_displayStatus('Posting Open Credit Updates...(update arOpenCreditMaster)')
			update arOpenCreditMaster
				set appliedAmt = appliedAmt + :ld_appliedamt,
					 balance = balance - :ld_appliedamt
			 where tranNo = :ls_octranno
			 and divisionCode = :gs_divisionCode
			and companyCode = :gs_companyCode
			using SQLCA;
			if SQLCA.sqlcode <> 0 then
				lastSQLCode = string(SQLCA.sqlcode)
				lastSQLErrText = SQLCA.sqlerrtext
				return FALSE
			end if		
			
		end if
	next
	--================================
	--end of insert / update ...
	--================================
	
	return TRUE
	
	--END VALIDASI
	
	
	if not uo_subs_advar.postArUpdates() then
		is_msgno = 'SM-0000001'
		is_msgtrail = uo_subs_advar.lastSQLCode + "~r~n" + uo_subs_advar.lastSQLErrText
		is_sugtrail = 'Error produced by uo_subs_advar.postArUpdates()'
		return -1
	end IF
	
	--VALIDASI uo_subs_advar.postArUpdates()
	dateTime ldt_tranDate(paramater)
	return postARUpdates(ldt_tranDate)
	
	string		ls_newrecord, ls_artranno, ls_trantypecode, ls_artypecode, ls_remarks
	string		ls_tranno, ls_sourceTable, ls_ripPaidOut
	decimal{2}	ld_balance, ld_paidamt, ld_newbalance, ld_conversionRate
	long			ll_records, ll_row, ll_artranno
	integer		li_priority
	boolean		lb_firsttime = TRUE
	
	datetime    ldtm_periodFrom, ldtm_periodTo, ldtm_trandate
	
	lastMethodAccessed = 'postARUpdates'
	
	f_displayStatus('Posting AR Updates...')
	
	ll_records = dw_ar.rowcount()
	for ll_row = 1 to ll_records
		
		ls_tranno 			= dw_ar.getitemstring(ll_row, "tranno")
		ls_trantypecode 	= trim(dw_ar.getitemstring(ll_row, "trantypecode"))
		ls_artypecode 		= trim(dw_ar.getitemstring(ll_row, "artypecode"))	
		ls_remarks 			= trim(dw_ar.getitemstring(ll_row, "remarks"))
		ls_newrecord		= dw_ar.getitemstring(ll_row, "newrecord")
		li_priority				= dw_ar.getitemnumber(ll_row, "artypecodepriority")
		ld_balance			= dw_ar.getitemdecimal(ll_row, "balance")
		ld_paidamt			= dw_ar.getitemdecimal(ll_row, "paidamt")
		ld_newbalance		= dw_ar.getitemdecimal(ll_row, "newbalance")	
		ls_sourceTable		= dw_ar.getitemstring(ll_row, "sourcetable")	
		ldtm_periodFrom	= dw_ar.getItemDateTime(ll_row, "periodfrom")
		ldtm_periodTo		= dw_ar.getItemDateTime(ll_row, "periodto")
		ldtm_trandate		= dw_ar.getItemDateTime(ll_row, "trandate")
		
		ld_conversionRate = dw_ar.getitemdecimal(ll_row, "conversionrate") //zar 8/23/2011
		
		if ld_newbalance = 0 then
			ls_ripPaidOut = 'Y'
		else
			ls_ripPaidOut = 'N'
		end if
		if isNull(ld_balance) 		then ld_balance = 0
		if isNull(ld_paidamt) 		then ld_paidamt = 0
		if isNull(ld_newbalance) 	then ld_newbalance = 0
		if isNull(ls_newrecord) 	then ls_newrecord = 'N'
	
		if ls_newrecord = 'Y' then
			f_displayStatus('Posting AR Updates... (insertIntoArTranHdr)')
			
			if isNull(ldtm_periodFrom) or string(ldtm_periodFrom, 'mm-dd-yyyy') = '01-01-1900' then
			
				if isNull(adt_trandate) or string(adt_trandate, 'mm-dd-yyyy') = '01-01-1900' then
					if not insertIntoArTranHdr(ls_tranno, ls_trantypecode, ls_artypecode, li_priority, ld_balance, ld_paidamt, ld_newbalance, ls_remarks) then
						return FALSE
					end if
				else
					if not insertIntoArTranHdr(ls_tranno, ls_trantypecode, ls_artypecode, li_priority, ld_balance, ld_paidamt, ld_newbalance, ls_remarks, adt_tranDate) then
						return FALSE
					end if
				end if
				
			else
				
				if not insertIntoArTranHdr(ls_tranno, ls_trantypecode, ls_artypecode, li_priority, ld_balance, ld_paidamt, ld_newbalance, ls_remarks, ldtm_trandate, ldtm_periodFrom, ldtm_periodTo) then
					return FALSE
				end if
	
			end if	
		else	
			f_displayStatus('Posting AR Updates... (update subsDepositReceivable)')
			if ls_sourceTable = 'RIP' then
				// ==================================================
				// update RIP's as processed, so they won't appear 
				// in collection entry again.
				// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				f_displayStatus('Posting AR Updates... (update subsInitialPayment)')
				if ld_paidamt > 0 then
					update subsInitialPayment
						set processed = :ls_ripPaidOut,
							 paidAmt = paidAmt + :ld_paidamt,
							 balance = balance - :ld_paidamt
					 where acctNo 		  = :acctNo
						and divisionCode = :gs_divisionCode
						and companyCode = :gs_companyCode
						and tranNo 		  = :ls_tranNo
						and tranTypeCode = :ls_tranTypecode
						and arTypeCode   = :ls_arTypeCode
						and processed = 'N'
					 using SQLCA;
					if SQLCA.sqlCode < 0 then
						lastSQLCode 	= string(SQLCA.sqlCode)
						lastSQLErrText	= SQLCA.sqlErrText
						return FALSE
					end if
				end if
			else			
				--==================================================
				--if it goes here, that means the source table of 
				--the balance is AR
				--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				f_displayStatus('Posting AR Updates... (update arTranHdr)')
				if ld_paidamt > 0 then
					date ldt_datefullypaid
					
					if ld_newbalance = 0.00 or ld_newbalance = 0 then
						select sysdate into :ldt_datefullypaid from dual using SQLCA;
					else
						setnull(ldt_datefullypaid)
					end if
					
					update arTranHdr
						set paidAmt = paidAmt + :ld_paidamt,
							 balance = balance - :ld_paidamt,
							 dateFullyPaid = :ldt_datefullypaid
	
					 where tranNo = :ls_tranno
						and divisionCode = :gs_divisionCode
						and companyCode = :gs_companyCode
						and tranTypeCode = :ls_trantypecode
						and arTypeCode = :ls_artypecode
						and acctNo = :acctNo
					 using SQLCA;
					if SQLCA.sqlCode < 0 then
						lastSQLCode 	= string(SQLCA.sqlCode)
						lastSQLErrText	= SQLCA.sqlErrText
						return FALSE
					end if
					
					if subsCurrencyCode = 'USD' then
						ld_paidamt = ld_paidamt * ld_conversionRate --//conversionRate 8/23/2011
					elseif subsCurrencyCode = 'PHP' then
						ld_paidamt = ld_paidamt * ld_conversionRate --//conversionRate 8/23/2011
					end if
					
					string ls_arAccount
					--=======================================================
					--insert GL Entry: Credit AR
					--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
					if not f_getArTypeARAccount(ls_artypecode, ls_arAccount, lastSQLErrText) then
						return FALSE
					end IF
					
					iuo_glPoster.insertGLEntryCredit('SAV-PARU-CR', '06-paid', ls_arAccount, ld_paidamt, 'decrease AR')
					--=======================================================
					--end
					--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
					
					string ls_unearnedAccount
					--=======================================================
					--insert GL Entry: Debit Unearned
					--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
					
					if not f_getArTypeUnearnedAccount(ls_artypecode, ls_unearnedAccount, lastSQLErrText) then
						return FALSE
					end IF
					
					iuo_glPoster.insertGLEntryDebit('SAV-PARU-CR', '07-paid', ls_unearnedAccount, ld_paidamt, 'decrease UNEARNED')
					
					--VALIDASI iuo_glPoster.insertGLEntryDebit
					long ll_insertRow

					if not initialized then
						errorMessage = 'Cannot execute InsertGLEntry method for the GL Post Object is not yet initialized.'
						suggestionRemarks = 'The Initialize method must be performed before calling any other methods.'
						return False
					end if
					
					ll_insertRow = dw_GLEntries.insertRow(0)
					if isNull(as_sourceTranTypeCode) or as_sourceTranTypeCode = '' then
						dw_GLEntries.object.sourceTranTypeCode[ll_insertRow] 	= tranTypeCode
					else
						dw_GLEntries.object.sourceTranTypeCode[ll_insertRow] 	= as_sourceTranTypeCode
					end if
					if isNull(as_sourceTranNo) or as_sourceTranNo = '' then
						dw_GLEntries.object.sourceTranNo[ll_insertRow] 	= tranNo
					else
						dw_GLEntries.object.sourceTranNo[ll_insertRow] 	= as_sourceTranNo
					end if
					dw_GLEntries.object.glAccountCode[ll_insertRow] 		= as_glAccountCode
					dw_GLEntries.object.debit[ll_insertRow] 				= ad_amount
					dw_GLEntries.object.credit[ll_insertRow] 				= 0
					dw_GLEntries.object.recordNo[ll_insertRow] 				= ll_insertRow
					dw_GLEntries.object.remarks[ll_insertRow] 				= as_remarks
					
					return True

					--END VALIDASI iuo_glPoster.insertGLEntryDebit
					
					--=======================================================
					--end
					-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
					
					--=======================================================
					-- NGLara | 04-05-2008
					-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
					-- The revenue account for this AR TYPE will be debitted
					-- in postApplicationOfOpenCredit event
					-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~				
	
				end if
			end if			 
		end if
	next
	--================================
	--end of insert / update ...
	--================================
	
	return TRUE
	
	--END VALIDASI 

	if not uo_subs_advar.postApplicationOfOpenCredit() then
		is_msgno = 'SM-0000001'
		is_msgtrail = uo_subs_advar.lastSQLCode + "~r~n" + uo_subs_advar.lastSQLErrText
		is_sugtrail = 'Error produced by uo_subs_advar.postApplicationOfOpenCredit()'
		return -1
	end IF

	---VALIDASI uo_subs_advar.postApplicationOfOpenCredit()
	string		ls_glAccountCode
	string		ls_applyoctranno, ldt_trandate, ls_acctno
	string		ls_octranno, ls_octype, ls_tranno
	string		ls_artranno, ls_trantypecode, ls_artypecode, ls_arremarks, ls_taxProfileCode
	string		ls_currencyCode
	decimal{2}	ld_conversionRate, ld_forexAmount
	decimal{2}	ld_amount, ld_appliedamt, ld_payment, ld_vatAmt, ld_vatPercent
	long			ll_hdr_records, ll_hdr_row, ll_dtl_records, ll_dtl_row, ll_recordnumber
	long			ll_applyoctranno, ll_find_row, ll_dtl_recno
	boolean		lb_firsttime = TRUE
	
	decimal{30} ld_appliedamt_usd, ld_payment_usd	//added codes for currency
	
	lastMethodAccessed = 'postApplicationOfOpenCredit'
	
	if not f_getSysParam_VAT(ld_vatPercent) then
		lastSQLCode 	= string(SQLCA.sqlCode)
		lastSQLErrText = SQLCA.sqlErrText
		return FALSE
	end if
	
	f_displayStatus('Posting Application of Open Credits...')

	ll_hdr_records = dw_applofoc_hdr.rowcount()
	for ll_hdr_row = 1 to ll_hdr_records
	
		ls_octranno			= dw_applofoc_hdr.getitemstring(ll_hdr_row, "refoctranno")
		ls_octype			= dw_applofoc_hdr.getitemstring(ll_hdr_row, "refoctypecode")
		ll_recordnumber 	= dw_applofoc_hdr.getitemnumber(ll_hdr_row, "recordnumber")
		ld_amount			= dw_applofoc_hdr.getitemdecimal(ll_hdr_row, "ocamt")
	
		--========================================================
		--added codes for currency
		--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		if subsCurrencyCode = 'USD' then
			ld_appliedamt_usd = dw_applofoc_hdr.getitemdecimal(ll_hdr_row, "appliedocamt")
			ld_appliedamt = ld_appliedamt_usd
		elseif subsCurrencyCode = 'PHP' then
			ld_appliedamt		= dw_applofoc_hdr.getitemdecimal(ll_hdr_row, "appliedocamt")
		end if
		--========================================================
		--end
		--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		
		ls_currencyCode	= dw_applofoc_hdr.getitemString(ll_hdr_row, "currencycode")		//added codes
		ld_conversionRate	= dw_applofoc_hdr.getitemdecimal(ll_hdr_row, "conversionrate")	//for currency
		
		if lb_firsttime then
			lb_firsttime = FALSE
			if not guo_func.get_nextnumber("APPLYOC", ll_applyoctranno, "WITH LOCK") then
				return FALSE
			end if
		else
			ll_applyoctranno = ll_applyoctranno + 1
		end if
	
		f_displayStatus('Posting Application of Open Credits (INSERT INTO arApplOfOcTranHdr)...')
	
		ls_applyoctranno = string(ll_applyoctranno, "00000000")
		INSERT INTO arApplOfOcTranHdr  
						( tranno,   
						trandate,   
						acctno,   
						ocamt,   
						appliedocamt,   
						applicationoctype,   
						refoctranno,   
						refoctypeCode,
						useradd,   
						dateadd,
						currencyCode,		//added codes
						conversionRate,   //for currency
						triggeredByTranNo,         //01/07/2009 -zar
						triggeredByTranTypeCode,   //01/07/2009 -zar
						divisionCode,
						companyCode
						)	
			VALUES ( :ls_applyoctranno,   
						getdate(),   
						:acctNo,   
						:ld_amount,   
						:ld_appliedamt,   
						'A',   
						:ls_octranno,   
						:ls_octype,   
						:gs_username,   
						getdate(),
						:ls_currencyCode,		//added codes
						:ld_conversionRate,  //for currency
						:parentTranNo,             //01/07/2009 -zar
						:parentTranTypeCode,       //01/07/2009 -zar 
						:gs_divisionCode,
						:gs_companyCode
						)	
				using SQLCA;
				
		if SQLCA.sqlcode <> 0 then
			lastSQLCode = '-2'
			lastSQLErrText = 'Insert error in arApplOfOcTranHdr' + '~r~n' + &
								  string(SQLCA.sqlCode) + '~r~n' + &
								  SQLCA.sqlErrText
			return FALSE
		end if
		--========================================================
		--added codes for currency
		--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		if subsCurrencyCode = 'USD' then
			ld_appliedamt = ld_appliedamt_usd * conversionRate
		elseif subsCurrencyCode = 'PHP' then
			ld_appliedamt = ld_appliedamt * conversionRate
		end if
		--========================================================
		--end
		--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
		string ls_openCreditAccount
		--=======================================================
		-- 		insert GL Entry: Debit Subscription Advances
		-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		if not f_getOCTypeGLAccount(ls_octype, ls_openCreditAccount, lastSQLErrText) then
			return FALSE
		end IF
		
		--VALIDASI f_getOCTypeGLAccount(ls_octype, ls_openCreditAccount, lastSQLErrText)
		
		--==================================================
		--NGLara | 08-08-2008
		--First user of this function is the refund entry
		--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		
		if isnull(as_ocTypeCode) then
			as_errorMsg = 'Null OC Type Code is invalid.'
			return False
		end if
		
		select glAccountCode
		  into :as_glAccountCode
		  from ocTypeMaster
		 where ocTypeCode = :as_ocTypeCode
		 and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;
		if SQLCA.sqlcode = 100 then
			as_errorMsg = 'OC Type Code : [' + as_ocTypeCode + '] doest not exist.'
			return False
		elseif SQLCA.sqlcode < 0 then
			as_errorMsg = string(SQLCA.sqlcode) + '~r~n' + SQLCA.sqlerrtext
			return False
		end if
		
		if isnull(as_glAccountCode) or trim(as_glAccountCode) = '' then
			as_errorMsg = 'The GL Account obtained was empty or null. Check the OC Type Code : [' + as_ocTypeCode + '] in OC Type Maintenance'
			return False
		end if
		
		Return TRUE
		
		--END VALIDASI f_getOCTypeGLAccount(ls_octype, ls_openCreditAccount, lastSQLErrText)

	
		--zar -08/09/2010 --we do not Debit INCENTIVE because it is not 
		--                  credited during collection
		if trim(ls_octype) <> 'INCENTIV' THEN
		
			iuo_glPoster.insertGLEntryDebit('SAV-PAOC-DB', '05-paid', ls_openCreditAccount, ld_appliedamt, 'decrease subscriber advances')
			
			--VALIADASI iuo_glPoster.insertGLEntryDebit('SAV-PAOC-DB', '05-paid', ls_openCreditAccount, ld_appliedamt, 'decrease subscriber advances')
			
			long ll_insertRow

			if not initialized then
				errorMessage = 'Cannot execute InsertGLEntry method for the GL Post Object is not yet initialized.'
				suggestionRemarks = 'The Initialize method must be performed before calling any other methods.'
				return False
			end if
			
			ll_insertRow = dw_GLEntries.insertRow(0)
			if isNull(as_sourceTranTypeCode) or as_sourceTranTypeCode = '' then
				dw_GLEntries.object.sourceTranTypeCode[ll_insertRow] 	= tranTypeCode
			else
				dw_GLEntries.object.sourceTranTypeCode[ll_insertRow] 	= as_sourceTranTypeCode
			end if
			if isNull(as_sourceTranNo) or as_sourceTranNo = '' then
				dw_GLEntries.object.sourceTranNo[ll_insertRow] 	= tranNo
			else
				dw_GLEntries.object.sourceTranNo[ll_insertRow] 	= as_sourceTranNo
			end if
			dw_GLEntries.object.glAccountCode[ll_insertRow] 		= as_glAccountCode
			dw_GLEntries.object.debit[ll_insertRow] 					= 0
			dw_GLEntries.object.credit[ll_insertRow] 					= ad_amount
			dw_GLEntries.object.recordNo[ll_insertRow] 				= ll_insertRow
			dw_GLEntries.object.remarks[ll_insertRow] 				= as_remarks
			
			return TRUE
			
			--END VALIDASI VALIADASI iuo_glPoster.insertGLEntryDebit('SAV-PAOC-DB', '05-paid', ls_openCreditAccount, ld_appliedamt, 'decrease subscriber advances')

		end if	
		
		
			
		--=======================================================
		-- 			end
		--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		
		f_displayStatus('Posting Application of Open Credits (insertGLEntry)...')
	
		ll_dtl_records = dw_applofoc_dtl.rowcount()
		ll_find_row 	= dw_applofoc_dtl.find("recordnumber = " + string(ll_recordnumber), 1, ll_dtl_records)
		if ll_find_row > 0 then
			for ll_dtl_row = ll_find_row to ll_dtl_records
				
				ll_dtl_recno = dw_applofoc_dtl.getitemnumber(ll_dtl_row, "recordnumber")
				if ll_dtl_recno = ll_recordnumber then
					
					ls_artranno 		= trim(dw_applofoc_dtl.getitemstring(ll_dtl_row, "documentno"))
					ls_trantypecode 	= trim(dw_applofoc_dtl.getitemstring(ll_dtl_row, "trantypecode"))
					ls_artypecode		= trim(dw_applofoc_dtl.getitemstring(ll_dtl_row, "artypecode"))
	
					//========================================================
					//added codes for currency
					//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
					if subsCurrencyCode = 'USD' then
						ld_payment_usd	= dw_applofoc_dtl.getitemdecimal(ll_dtl_row, "appliedamt")
						ld_payment = ld_payment_usd
					elseif subsCurrencyCode = 'PHP' then
						ld_payment		= dw_applofoc_dtl.getitemdecimal(ll_dtl_row, "appliedamt")
					end if
					//========================================================
					//end
					//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
					
					ls_arremarks		= ""
					ls_currencyCode	= dw_applofoc_dtl.getitemString(ll_dtl_row, "currencycode")		//added codes
					ld_conversionRate	= dw_applofoc_dtl.getitemdecimal(ll_dtl_row, "conversionrate")	//for currency
					ld_forexAmount		= dw_applofoc_dtl.getitemdecimal(ll_dtl_row, "forexamount")		//
					
					//RAY 08/27/2015
					select taxProfileCode into :ls_taxProfileCode
					from arAccountMaster
					where acctno = :acctNo
					and divisionCode = :gs_divisionCode
					and companyCode = :gs_companyCode
					using SQLCA;
					
					if ls_taxProfileCode = '001' then
						if isNull(ld_vatPercent) or ld_vatPercent  = 0 then
							ld_vatAmt = 0
						else
							ld_vatAmt = ld_payment * (1/ld_vatPercent)
						end if
					else
						ld_vatAmt = 0		
					end if				
	
					
					dw_applofoc_dtl.SetItem(ll_dtl_row, "vatAmt", ld_vatAmt)
	
					f_displayStatus('Posting Application of Open Credits (INSERT INTO arApplOfOcTranDtl)...')
					INSERT INTO arApplOfOcTranDtl
									( tranno,   
									documentNo,   
									trantypecode,   
									artypecode,   
									appliedOCAmt,
									remarks,
									vatAmt,
									userAdd,
									dateAdd,
									arCurrencyCode,	//added codes
									arConversionRate,	//for currency
									forexAmount,
									divisionCode,
									companyCode)		//
						VALUES ( :ls_applyoctranno,   
									:ls_artranno,   
									:ls_trantypecode,   
									:ls_artypecode,   
									:ld_payment,
									:ls_arremarks,
									:ld_vatAmt,
									:gs_username,
									getdate(),
									:ls_currencyCode,		//added codes
									:ld_conversionRate,	//for currency
									:ld_forexAmount,
									:gs_divisionCode,
									:gs_companyCode)		//
					using SQLCA;
					if SQLCA.sqlcode <> 0 then
						lastSQLCode = '-2'
						lastSQLErrText = 'Insert error in arApplOfOcTranHdr' + '~r~n' + &
											  string(SQLCA.sqlCode) + '~r~n' + &
											  SQLCA.sqlErrText
						return FALSE
					end if
					
					//touched - 03022010 - for leasing added verification for ADDEP|SCDEP
					if ld_payment > 0 and (ls_artypecode <> 'OCDEP' and &
					                       ls_artypecode <> 'OCDEQ' and &
												  ls_arTypeCode <> 'ADDEP' and &     
												  ls_arTypeCode <> 'SCDEP' ) then	 
						string ls_revenueAccount
						// =======================================================
						// insert GL Entry: Credit Revenue
						// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
						if not f_getArTypeRevAccount(ls_artypecode, ls_revenueAccount, lastSQLErrText) then
							return FALSE
						end if
						
						//--zar 08/09/2010 - If OCTYPE = INCENTIVE - no revenue must be realized
						if trim(ls_octype) <> 'INCENTIV' then
							iuo_glPoster.insertGLEntryCredit('SAV-PAOC-CR', '08-paid', ls_revenueAccount, ld_payment * conversionRate, 'increase revenue')
						end if	
						// =======================================================
						// end
						// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
					end if
				else
					exit
				end if
				
			next
		end if
	
	next
	
	if not lb_firsttime then
		if not guo_func.set_number("APPLYOC", ll_applyoctranno) then
			return FALSE
		end if
	end if
	
	return TRUE
	
	--END VALIDASI



return 0
-----END VALIDASI


if not isNull(gb_authorizationNo) and gb_authorizationNo <> "" then

	update overridePolicy
	set refTranNo = :is_tranNo
	where tranNo = :gb_authorizationNo
	and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	and requestStatus = 'AP'
	using SQLCA;

end if	


uo_subscriber luo_subscriber

string ls_jono_iptv

if not luo_subscriber.setAcctNo(ls_acctno) then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = luo_subscriber.lastSQLCode + '~r~n' + luo_subscriber.lastSQLErrText
	return -1
end if 

	---VALIDASI luo_subscriber.setAcctNo(ls_acctno)
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
	agentCode,
	useradd,
	dateadd,
	currencyCode,
	nodeNo,
	servicePostNo,
	subsUserName,
	password,
	bundledCTVAcctNo,
	bundledINETAcctNo,
	from_nocoicop,
	NOCOICOP
	
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
	:nodeNo,
	:servicePostNo,
	:subsUserName,
	:password,
	:bundledCTVAcctNo,
	:bundledINETAcctNo,
	:from_nocoicop,
	:NOCOICOP
	
	from
	
	arAcctSubscriber
	inner join vw_arAcctAddress billing on arAcctSubscriber.acctNo = billing.acctNo
	      and billing.addressTypeCode = 'BILLING' 
			and billing.divisionCode = :gs_divisionCode
			and billing.companyCode = :gs_companyCode
	inner join vw_arAcctAddress service on arAcctSubscriber.acctNo = service.acctNo 
	      and service.addressTypeCode = 'SERVADR1' 
			and service.divisionCode = :gs_divisionCode
			and service.companyCode = :gs_companyCode	
	where arAcctSubscriber.acctNo = :acctNo
	and arAcctSubscriber.divisionCode = :gs_divisionCode
	and arAcctSubscriber.companyCode = :gs_companyCode
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
	
	select serviceType
	into :serviceType
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
		
		if not isnull(cmProfileCode) then
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
	
	//prepaidSubscriber,
	//:prepaidSubscriber,
	
	return TRUE

-----------END VALIDASI--------------------

if luo_subscriber.autocreatejo_IPTV(is_tranNo, ls_jono_iptv) < 0 then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = luo_subscriber.lastSQLCode + '~r~n' + luo_subscriber.lastSQLErrText
	return -1
end if 

	---VALIDASI luo_subscriber.autocreatejo_IPTV(is_tranNo, ls_jono_iptv)
	decimal ld_balance, ld_accepted_rip_amt, ld_balance_rip 
	date ld_jodate
	
	string		ls_joNo, ls_tranTypeCode, ls_acctNo, ls_lineManCode, ls_referenceNo, ls_joStatusCode, ls_trantype, ls_teamcode, ls_teammembercode
	string		ls_sqlcode, ls_sqlerrtext, ls_refno, ls_specialInstructions, ls_batch, ls_tranNo, ls_serialNo, ls_NOCOICOP
	datetime		ldt_joDate, ldt_preferredDatetimeFrom, ldt_preferredDatetimeTo
	long			ll_ans, ll_joNo, ll_tranNo
	integer		li_noOfSTB
	
	string ls_from_nocoicop, LS_SUBSCRIBERSTATUSCODE
	
	boolean is_nocoicop
	
	long ll_count
	
	uo_jo_nv luo_jo
			
		
	STRING ls_napcode , ls_portno
	
	boolean is_minimum
	
	select napcode , portno,  preferreddatetimefrom, tranno, subscriberstatuscode into :ls_napcode , :ls_portno , :ld_jodate, :ls_referenceNo, :LS_SUBSCRIBERSTATUSCODE
	from aracctsubscriber
	where acctno = :acctNo
	and divisioncode = :gs_divisioncode
	and companycode = :gs_companycode
	using SQLCA;
	
	ls_joStatusCode 	= "OG"
	
	if LS_SUBSCRIBERSTATUSCODE = 'APL' then
		ls_jostatuscode = 'OQ'
	end IF
	
		if not guo_func.get_nextnumber("JO", ll_joNo, "WITH LOCK") then
			return -1
		end IF
		
		--VALIDASI guo_func.get_nextnumber("JO", ll_joNo, "WITH LOCK")
		
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
		
		---END VALIDASI guo_func.get_nextnumber("JO", ll_joNo, "WITH LOCK")
	
	
	ls_joNo 			= string(ll_joNo, "00000000")
	ls_tranTypeCode 	= 'APPLYEXT'
	ls_lineManCode		= '00013'

	
	insert into joTranHdr (
					joNo,
					joDate,
					tranTypeCode,
					acctNo,
					lineManCode,
					referenceNo,
					joStatusCode,
					preferredDatetimeFrom,
					preferredDatetimeTo,
					specialInstructions,
					userAdd,
					dateAdd,
					divisionCode,
					companyCode,
					teamcode,
					teammembercode,
					napcode,
					portno,
					remarks,
					IS_AUTO_CREATE,
					NOCOICOP)
		  values (
					:ls_joNo,
					getDate(),
					:ls_tranTypeCode,
					:acctNo,
					:ls_lineManCode,
					:as_tranno_ext,
					:ls_joStatusCode,
					:ldt_preferredDatetimeFrom,
					:ldt_preferredDatetimeTo,
					:ls_specialInstructions,
					:gs_username,
					getdate(),
					:gs_divisionCode,
					:gs_companyCode,
					:ls_teamcode,
					:ls_teammembercode,
					:ls_napcode,
					:ls_portno,
					'AUTO CREATE JO VIA IBAS',
					'Y',
					:ls_NOCOICOP)
			using SQLCA;
	if SQLCA.sqlcode <> 0 then
		return -1
	end if
	
	if not uf_set_referenceJoNo(ls_tranTypeCode, as_tranno_ext, ls_joNo) then
		return -1
	end IF
	
	--VALIDASI uf_set_referenceJoNo(ls_tranTypeCode, as_tranno_ext, ls_joNo) 
	
	if as_trantypecode = 'APPLYML' then
	update arAcctSubscriber
		set referenceJONo = :as_jono
	 where tranNo = :as_tranno
	 and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	using SQLCA;
	elseif as_trantypecode = 'CONVD2F' then
		update conversiondoctofibtran
			set referenceJONo = :as_jono
		 where tranNo = :as_tranno
		 and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;
	elseif as_trantypecode = 'CONVD2DF' then
		update CONVERSIONDSLTODOCFIBTRAN
			set referenceJONo = :as_jono
		 where tranNo = :as_tranno
		 and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;
	elseif as_trantypecode = 'APPLYEXT' then
		update applOfExtTranHdr
			set referenceJONo = :as_jono
		 where tranNo = :as_tranno
		 and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;
	elseif as_trantypecode = 'APPLEXTHO' then
		update applOfExtHotelTranHdr
			set referenceJONo = :as_jono
		 where tranNo = :as_tranno
		 and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;
	elseif as_trantypecode = 'APPLYPD' then
		update applOfPermanentDiscTranHdr
			set referenceJONo = :as_jono
		 where tranNo = :as_tranno
		 and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;
	elseif as_trantypecode = 'APPLYTRANSFR' then
		update applOfTransferTranHdr
			set referenceJONo = :as_jono
		 where tranNo = :as_tranno
		 and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;
	elseif as_trantypecode = 'APPLYXTDSRVC' then
		update applExtendedServicesTranHdr
			set referenceJONo = :as_jono
		 where tranNo = :as_tranno
		 and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;
	elseif as_trantypecode = 'PULLOUTADS' then
		update adsTranHdr
			set referenceJONo = :as_jono
		 where tranNo = :as_tranno
		 and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;
	elseif as_trantypecode = 'APPLEXTD' then
		update applOfExtDiscTranHdr
			set referenceJONo = :as_jono
		 where tranNo = :as_tranno
		 and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;
	elseif as_trantypecode = 'APPLYDEAC' then
		update applOfDeactivationTranHdr
			set referenceJONo = :as_jono
		 where tranNo = :as_tranno
		 and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;
	elseif as_trantypecode = 'APPLMLEXTREA' then
		update applOfReactivationTranHdr
			set referenceJONo = :as_jono
		 where tranNo = :as_tranno
		 and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;
	elseif as_trantypecode = 'SERVCALL' then
		update serviceCallTranHdr
			set referenceJONo = :as_jono
		 where tranNo = :as_tranno
		 and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;
	elseif as_trantypecode = 'REPANADIGI' then
		update AppOfDigitalConversionTranHdr
			set referenceJONo = :as_jono
		 where tranNo = :as_tranno
		 and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;
	elseif as_trantypecode = 'SERVMGMT' then
		update serviceCallMaster
			set referenceJONo = :as_jono
		 where tranNo = :as_tranno
		 and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;	
	elseif as_trantypecode = 'ADDFIBERTV' then
		update APPLOFVASTRANHDR
			set referenceJONo = :as_jono
		 where tranNo = :as_tranno
		 and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;	
	end if
	if SQLCA.sqlcode <> 0 then
		return FALSE
	end if
	
	return TRUE
	
	--END VALIDASI uf_set_referenceJoNo(ls_tranTypeCode, as_tranno_ext, ls_joNo)
	
	
	if not guo_func.set_number("JO", ll_joNo) then
		return -1
	end IF
	
	--VALIDASI guo_func.set_number("JO", ll_joNo)
	
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
		
	--END VALIDASI SET NUMBER
	
	update subscriberaddonmaster
	set jono_iptv = :ls_joNo, TRANNO_EXT = :as_tranno_ext
	where acctno = :acctNo
	and divisioncode = :gs_divisioncode
	and companycode = :gs_companycode
	and isiptv = 'Y'
	and used = 'N' and jono_iptv is null
	using SQLCA;
	
	commit using SQLCA;
	
	update applofexttranhdr
	set referencejono = :ls_joNo , applicationstatuscode = 'OG'
	where tranno = :as_tranno_ext
	and divisioncode= :gs_divisioncode
	and companycode = :gs_companycode
	using SQLCA;
	
	commit using SQLCA;
	
	as_jono = ls_jono
	
	return 0
	
	--END VALIDASI guo_func.set_number("JO", ll_joNo)-----------------


if trigger event ue_salesaddontranhdr(ls_acctno, ll_extensions, ls_mop, ls_installtype, ls_jono_iptv, long(ls_no_of_months) ) = -1 then
   return -1
end if 

---VALIDASI ue_salesaddontranhdr(ls_acctno, ll_extensions, ls_mop, ls_installtype, ls_jono_iptv, long(ls_no_of_months)

	long ll_tranno
	SELECT sales_seq.nextval into :ll_tranno from dual using SQLCA;
	
	string ls_tranno
	ls_tranno		=	'AO'+string(ll_tranNo, '000000')
	
	long li_addon_id
	string ls_packagecode, ls_itemcode
	
	decimal ld_total_amount, ld_outright_price, ld_staggered_price ,ld_delivery_fee, ld_setup_fee , ld_total_delivery_fee
	decimal ld_total_setup_fee
	
	ld_total_amount = 0.00
	ld_total_delivery_fee = 0.00
	ld_total_setup_fee = 0.00
	
	INT i
	
	string ls_mop , ls_mode_of_delivery
	
	ls_packagecode = dw_detail.getItemString(dw_detail.getrow(),'packageCode')
		
	
	for i = 1 to al_noofextensions
		
		
		select addon_id into :li_addon_id from arpackagemaster
		where packagecode = :ls_packagecode
		and divisioncode = :Gs_divisioncode
		and companycode = :gs_companycode
		using SQLCA;
		
		
		select outright_price, delivery_fee, setup_fee, itemcode into :ld_outright_price, :ld_delivery_fee, :ld_setup_fee, :ls_itemcode
		from dynamic_pricing_ao
		where id = :li_addon_id
		using SQLCA;
		
		ls_mop = 'staggered'
		if as_mop = 'O' then
			ld_total_amount = ld_total_amount + ld_outright_price
			ls_mop = 'outright'
		end if
		
		ld_total_delivery_fee = ld_total_delivery_fee + ld_delivery_fee
		
		ls_mode_of_delivery = 'delivery only'
		
		if as_install_type = 'INSTALL' then
			ld_total_setup_fee = ld_total_setup_fee + ld_setup_fee + ld_delivery_fee
			ls_mode_of_delivery = 'deliver and install'
		end if
			
		
		INSERT INTO SOLD_ADD_ON_ITEMS
		(TRANNO,acctno, ITEMCODE, SERIALNO, DIVISIONCODE, COMPANYCODE, USERADD, DATEADD, JONO, ISIPTV, USED, addon_id, mop, mode_of_delivery )
		VALUES
		(:ls_tranno, :as_acctno,:ls_itemCode, '', :gs_divisioncode, :Gs_companycode, :gs_username, sysdate, :as_jono, 'Y', 'N', :li_addon_id, :ls_mop, :ls_mode_of_delivery)
		using SQLCA;
		
	next
	
	--is_tranNo 		= string(ll_tranNo, '00000000')
	i_dt_timestamp	= guo_func.get_server_date()
	
	
	insert into salesaddontranhdr (
					tranNo,
					tranDate,
					acctno,
					refNo,
					amount,
					discountAmount,
					extendedAmount,
					tranTypeCode,
					locationCode,
					useradd,
					dateadd,
					divisionCode,
					companyCode,
					jono,
					applicationstatusCODE,
					modeofpayment,
					noofmonths,
					delivery_options,
					installation_type,
					deliveryfee,
					installationfee
					)
		  values (
		  			:ls_tranno,
					sysdate,
					:as_acctno,
					:is_tranno,
					:ld_total_amount,
					0.00,
					:ld_total_amount,	
					'SALES',
					null,
					:gs_username,
					sysdate,
					:gs_divisionCode,
					:gs_companyCode,
					:as_jono,
					'OG',
					:as_mop,
					:ai_noofmonths,
					'DELIVERY',
					:as_install_type,
					:ld_total_delivery_fee,
					:ld_total_setup_fee)
			using SQLCA;
	if SQLCA.SQLCode <> 0 then 
		is_msgNo    = 'SM-0000001' 
		is_msgTrail = 'Error inserting into salesTranHdr' + &
						  '~r~nSQLCode     : ' + string(SQLCA.SQLCode)   + & 
						  '~r~nSQLErrText  : ' + SQLCA.SQLErrText        + &	
						  '~r~nSQLDBCode   : ' + String(SQLCA.SQLDBCode) + &
						  '~r~n~r~nA RollBack will Follow...'
	  return -1		
	end if	
	
	RETURN 1
---------------------END VALIDASI------


--Wifi6 Checking

long ll_ctr_wifi5
long ll_wifi6_tranno

ll_ctr_wifi5 = 0

select count(*) into :ll_ctr_wifi5
from subscribercpemaster
where acctno = :ls_acctno
and divisioncode = :gs_divisioncode
and companycode = :gs_companycode
and cpetypecode= 'CM'
and itemcode in ('00030501',
'00030419',
'00030781',
'00030750',
'00030762',
'00030763',
'00030779',
'00030771',
'00030338',
'00030405',
'00030311',
'00030779',
'00030754') 
using SQLCA;

if ll_ctr_wifi5 > 0 then
	
	if is_netflix then
		select ADDON_WIFI6.NEXTVAL into :ll_wifi6_tranno from dual using SQLCA;
		
		insert into wifi6onsitetran (acctno, divisioncode, companycode, trandate, referencejono,onsite_charge,equipment_charge, id)
		values (:ls_acctno, :gs_Divisioncode, :gs_companycode, sysdate, :ll_wifi6_tranno, 0, 0, :ll_wifi6_tranno)
		using SQLCA;
		
		
		
		
		insert into JoTranHdr (jono, jodate, trantypecode, acctno, linemancode, referenceno, jostatuscode, useradd, dateadd, divisioncode, companycode, is_auto_create, remarks, specialinstructions)
		values (:ll_wifi6_tranno, sysdate, 'WIFI6TA', :ls_acctno, '00013', :ll_wifi6_tranno, 'FR', :gs_username, SYSDATE, :GS_DIVISIONCODE, :GS_COMPANYCODE, 'Y', 'Free Wifi6','')
		using SQLCA;
	end if 
else
	
	string ls_tranno_amort
	long ll_ctr_amort
	
	ll_ctr_amort = 0
	
	select count(*) into :ll_ctr_amort
	from amortizedarTranhdr
	where acctno = :ls_acctno
	and divisioncode = :gs_divisioncode
	and companycode = :Gs_companycode and artypecode = 'DUFEE'
	AND REMARKS LIKE 'WIFI6%'
	group by tranno
	USING SQLCA;
	
	if ll_ctr_amort > 0 then
		update amortizedartrandtl
		set billed = 'W'
		where tranno in (select tranno from amortizedartranhdr
								where acctno = :ls_acctno
								and divisioncode = :gs_divisioncode
								and companycode = :gs_companycode
								and artypecode = 'DUFEE' AND REMARKS LIKE 'WIFI6%')
		and billed = 'N'
		using SQLCA;
		
	end if

end if




ib_reqStatus = True
guo_func.msgBox("Saving Complete.", "You have successfully saved your entry.")
iw_parent.trigger dynamic event ue_cancel()
idw_ReqInitPayment.reset()

return 0



 