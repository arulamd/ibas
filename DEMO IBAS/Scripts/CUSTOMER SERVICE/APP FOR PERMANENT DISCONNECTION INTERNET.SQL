opensheetwithparm(w_application_perm_disc, 'INET',w_mdiFrame, 0, original!)

--EVENT OPEN FORM W_APPLICATION_PERM)DISC

is_serviceType = message.stringParm

is_serviceType = INET

--center the window
uo_center_window luo_center_window
luo_center_window = create uo_center_window
luo_center_window.f_center(this)
---**** end ***--- //


idw_reqInitPayment = dw_reqinitpayment
iw_parent = this

dw_header.settransobject(SQLCA)
idw_reqInitPayment.settransobject(SQLCA) 

iuo_subscriber = create uo_subscriber_def

--QUERY FORM DW_HEADER

SELECT  applOfPermanentDiscTranHdr.tranno ,
		  applOfPermanentDiscTranHdr.trandate ,
		  applOfPermanentDiscTranHdr.acctno ,
		  applOfPermanentDiscTranHdr.locationCode ,
		  applOfPermanentDiscTranHdr.reason ,           
		  applOfPermanentDiscTranHdr.disconnectionremarkscode ,
		  applOfPermanentDiscTranHdr.disconnectionsubremarkscode ,
		  applOfPermanentDiscTranHdr.specialInstructions,
		  applOfPermanentDiscTranHdr.referencejono ,           
		  applOfPermanentDiscTranHdr.preferreddatetimefrom ,
		  applOfPermanentDiscTranHdr.preferreddatetimeto ,
		  applOfPermanentDiscTranHdr.applicationStatusCode ,
		  applOfPermanentDiscTranHdr.useradd ,
		  applOfPermanentDiscTranHdr.dateadd ,
		  0.00 cmDeposit,
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
		  '' billingAddress,
		  0.00 monthlyRate,
		  '' packageType
	  FROM applOfPermanentDiscTranHdr 
	  
--QUERY FORM SUBCRIBER CABLE MODEM dw_DETAIL
	  	  
select a.locationCode, a.serialNoStatusCode, 
       a.serialNo, a.macAddress, b.itemName, ''isReturnCm
 from serialNoMaster a, itemMaster b
 where a.itemCode = b.itemCode
	and a.companyCode = b.companyCode
	and a.divisionCode = :as_division
	and a.companyCode = :as_company
   and a.acctNo = :as_acctNo
 	and b.itemIsCableModem = 'Y'
 	
--QUERY FORM REQUIRED INITIAL PAYMENT dw_reqinitpayment
 	
SELECT  subsinitialpayment.acctno , 
subsinitialpayment.trantypecode , 
subsinitialpayment.artypecode , 
subsinitialpayment.tranno ,  
subsinitialpayment.trandate ,
subsinitialpayment.priority ,    
subsinitialpayment.amount
FROM subsinitialpayment    

----EVENT BUTTON SEARCH ACCTNO

long ll_row, ll_success, ll_count
string ls_search, ls_result, ls_acctNo, lastSQLCode, lastSQLErrText

string ls_subscriberName, ls_serviceAddress, ls_billingAddress
string ls_package, ls_packageType
string ls_subscriberStatus, ls_chargeType
string ls_subscriberType, ls_subscriberUserType
decimal{2} ld_occupancyRate, ld_monthlyMlineFee, ld_monthlyExtFee
long ll_noOfExt, ll_noOfSTB

str_search str_s

ls_search = trim(as_search)
ll_row = dw_header.getrow()
str_subscriber_filter lstr_filter

choose case ls_search
	case "acctno"
		lstr_filter.acctno = ' '
		str_s.serviceType = is_serviceType
		openwithParm(w_search_subscriber, str_s)
		ls_result = trim(Message.StringParm)
				
		if ls_result = '' or isNull(ls_result)then
			return
		end if
		
		ls_acctNo = trim(ls_result)
		dw_header.setitem(ll_row,'acctno', ls_acctNo)
		
		select count(acctNo) into :ll_count 
		from applOfPermanentDiscTranHdr
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
			guo_func.MsgBox('Pending Application Found...', 'This account has a pending Application for [Mainline/Extension Permanent Disconnection],'+&
								 ' please verify the transaction on JO Monitoring...')
			return					 
		end if	

		if not iuo_subscriber.setAcctNo(ls_acctNo) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + iuo_subscriber.lastSQLErrText)
			return
		end IF
		
		--VALIDASI setAcctNo
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
		
		~~~~~~~~~~~~~~~~~~CURRENCY~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
		
		--END VALIDASI setAcctNo
		
		--subscrber name
		ls_subscriberName = iuo_subscriber.subscriberName 
		dw_header.setItem( 1, "subscriberName", ls_subscriberName )
		
		--(take FROM ue_subcriber.setaccno.subscriberName)
		
		--service address
		if not iuo_subscriber.getServiceAddress(ls_serviceAddress) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
				return
		end IF	
		
		--validasi getServiceAddress
		lastMethodAccessed = 'getServiceAddress'

		as_serviceAddress = serviceAddressComplete (take FROM ue_subcriber.setaccno.serviceAddressComplete)
		
		--end getServiceAddress
				
		dw_header.setItem( 1, "serviceAddress", ls_serviceAddress )
		
		--billing address
		if not iuo_subscriber.getBillingAddress(ls_billingAddress) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
				return
		end IF
		
		--validasi getBillingAddress
		lastMethodAccessed = 'getBillingAddress'

		as_billingaddress = billingAddressComplete (take FROM ue_subcriber.setaccno.billingAddressComplete)
		
		--end getBillingAddress
		
		dw_header.setItem( 1, "billingAddress", ls_billingAddress )
		
		--package 
		if not iuo_subscriber.getPackageName(ls_package) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
				return
		end IF
		
		--validasi getPackageName
		
		lastMethodAccessed = 'getPackageName'

			select packageName
			  into :as_packageName
			  from arPackageMaster
			 where packageCode = :packageCode
			 	and divisionCode = :gs_divisionCode
				and companyCode = :gs_companyCode
			using SQLCA;
			if SQLCA.sqlcode <> 0 then
				lastSQLCode = string(SQLCA.sqlcode)
				lastSQLErrText = SQLCA.sqlerrtext
				return FALSE
			end if
			return TRUE

		--end validasi
			
		dw_header.setItem( 1, "package", ls_package )		
		
		--package Type 
		if not iuo_subscriber.getPackageTypeName(ls_packageType) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
				return
		end IF
		
		--VALIDASI GETPACKAGEtYPENAME
		
		lastMethodAccessed = 'getPackageTypeName'
		
		select distinct PackageTypeMaster.packageTypeName
		  into :as_packageTypeName
		  from arPackageMaster, packageTypeMaster
		 where arPackageMaster.packageCode = :packageCode
		 and arPackageMaster.divisionCode = :gs_divisionCode
			and packageTypeMaster.companyCode = :gs_companyCode
		and arPackageMaster.companyCode = :gs_companyCode
		and arPackageMaster.packageTypeCode = packageTypeMaster.packageTypeCode
		 using SQLCA;
		if SQLCA.sqlcode <> 0 then
			lastSQLCode = string(SQLCA.sqlcode)
			lastSQLErrText = SQLCA.sqlerrtext
			return FALSE
		end if
		return TRUE
		
		--END VALIDASI GETPACKAGEtYPENAME
		
		
		dw_header.setItem( 1, "packageType", ls_packageType )		
		
		--subscriber status
		if not iuo_subscriber.getSubscriberStatusName(ls_subscriberStatus) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
				return
		end IF
		
		--validasi getSubscriberStatusName
		
		lastMethodAccessed = 'getSubscriberStatusName'

		select subscriberStatusName
		  into :as_subscriberStatusName
		  from subscriberStatusMaster
		 where subscriberStatusCode = :subscriberStatusCode
		 using SQLCA;
		if SQLCA.sqlcode <> 0 then
			lastSQLCode = string(SQLCA.sqlcode)
			lastSQLErrText = SQLCA.sqlerrtext
			return FALSE
		end if
		return TRUE
		
		--end validasi getSubscriberStatusName
		
		dw_header.setItem( 1, "subscriberStatus", ls_subscriberStatus )				
		
		--charge type
		if not iuo_subscriber.getchargeTypeName(ls_chargeType) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
				return
		end IF
		
			--VALIDASI GETCHARGETYPENAME
		
		lastMethodAccessed = 'getchargeTypeName'

		select chargeTypeName
		  into :as_chargeTypeName
		  from chargeTypeMaster
		 where chargeTypeCode = :chargeTypeCode
		 using SQLCA;
		if SQLCA.sqlcode <> 0 then
			lastSQLCode = string(SQLCA.sqlcode)
			lastSQLErrText = SQLCA.sqlerrtext
			return FALSE
		end if
		return TRUE

		--END GETCHARGETYPENAME
		
		dw_header.setItem( 1, "chargeType", ls_chargeType )				
		
		--subscriber Type
		if not iuo_subscriber.getSubsTypeName(ls_subscriberType) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
				return
		end IF
		
		--VALIDASI GET getSubsTypeName
		
		  lastMethodAccessed = 'getSubsTypeName'

			select subsTypeName
			  into :as_subsTypeName
			  from subscriberTypeMaster
			 where subsTypeCode = :subsTypeCode
			 and companyCode = :gs_companyCode
			using SQLCA;
			if SQLCA.sqlcode <> 0 then
				lastSQLCode = string(SQLCA.sqlcode)
				lastSQLErrText = SQLCA.sqlerrtext
				return FALSE
			end if
			return TRUE
			
		--END getSubsTypeName
			
		dw_header.setItem( 1, "subscriberType", ls_subscriberType )				
		
		--subscriber User Type
		if not iuo_subscriber.getSubsUserTypeName(ls_subscriberUserType) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
				return
		end IF
		
		--VALIDASI getSubsUserTypeName
		
			lastMethodAccessed = 'getSubsUserTypeName'

			select subsUserTypeName
			  into :as_subsUserTypeName
			  from subsUserTypeMaster
			 where subsUserTypeCode = :subsUserTypeCode
			 using SQLCA;
			if SQLCA.sqlcode <> 0 then
				lastSQLCode = string(SQLCA.sqlcode)
				lastSQLErrText = SQLCA.sqlerrtext
				return FALSE
			end if
			return TRUE

		--END getSubsUserTypeName
			
		dw_header.setItem( 1, "subscriberUserType", ls_subscriberUserType )				
		
		--monthly Mline Fee
		if not iuo_subscriber.getMlineMonthlyRate(ld_monthlyMlineFee) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
				return
		end IF
		
		--VALIDASI getMlineMonthlyRate
		lastMethodAccessed = 'getMLineMonthlyRate'

		select monthlyRate
		  into :ad_mlineMonthlyRate
		  from arPackageMaster
		 where packageCode = :packageCode
		 and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;
		if SQLCA.sqlcode <> 0 then
			lastSQLCode = string(SQLCA.sqlcode)
			lastSQLErrText = SQLCA.sqlerrtext
			return FALSE
		end if
		return TRUE

		--END getMlineMonthlyRate
		
		dw_header.setItem( 1, "monthlyrate", ld_monthlyMlineFee )															
		
		dw_header.acceptText()
		
		--get permanent disconnection fees 
		string ls_packageCode
		ls_packageCode = iuo_subscriber.packageCode
		
		id_mLineExtPermanentDiscFee = 0.00
		
		select permanentDiscFee
		into :id_mLineExtPermanentDiscFee
		FROM 		arPackageMaster
		WHERE 	packageCode = :ls_packageCode
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		USING SQLCA;			
		If SQLCA.SQLcode = -1 then
			messagebox('SM-0000001',"select in arpackageMaster SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText)
			return
		end if		
		
		if isnull(id_mLineExtPermanentDiscFee) then id_mLineExtPermanentDiscFee = 0.00
	
		dw_detail.retrieve(ls_acctNo, gs_divisionCode, gs_companyCode)	
				
		--------------------------------------------------------------
		--validate policy on no of months a/r min requirement - start
		--------------------------------------------------------------		
		s_arrears_override_policy.refTranTypeCode = 'APPLYPD'
		
		if not f_overrideArrearsLockIn(iuo_subscriber, s_arrears_override_policy ) then
			triggerevent("ue_cancel")
			return
		end IF
		
		--VALIDASI f_overrideArrearsLockIn
		
		decimal {2} ld_ARBalance
			string ls_msg, ls_remarks
			
			--------------------------------------------------------------
			-- validate policy on no of months a/r min requirement - start
			--------------------------------------------------------------
			
			
			ld_ARBalance = 0.00
			--check if subscriber has a/r balances
			
			if not iuo_subscriber.getARBalance(ld_ARBalance,1) then
				guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
					iuo_subscriber.lastSQLErrText)
			end IF
			
			--VALIDASI GETARBALANCE
			
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
			
			--END VALIDASI GETARBALANCE
			
			ls_msg = f_lockInPeriod(iuo_subscriber.acctNo)
			
			--validasi f_lockInPeriod
			
			integer li_no, li_lockIn, li_year, li_month, li_day, li_addyear
				string ls_msg
				date ld_lockin, ld_today, ld_dateinstalled
				
				select TRUNC(months_between(sysdate, dateinstalled)) DP_MONTH, lockInPeriod ,dateinstalled
				into :li_no, :li_lockIn,:ld_dateinstalled
				from arAcctSubscriber
				where acctNo = :as_acctNo
				and divisionCode = :gs_divisionCode
				and companyCode = :gs_companyCode
				and rownum < 2
				using SQLCA;
				if SQLCA.sqlCode <> 0 then
					ls_msg = string(SQLCA.sqlCode) + ' ' + SQLCA.sqlerrText
					return ls_msg
				end if
				
				li_addyear = (month(ld_dateinstalled) + li_lockin) / 12
				li_year = li_addyear + year(ld_dateinstalled)
				li_month = month(ld_dateinstalled) + li_lockin
				if li_month > 12 then
					li_month = li_month - (li_addyear *  12)
					if li_month = 0 then
						li_month = 12
					end if
				end if
				li_day = f_getlastdayofmonth(li_month,li_year)
				if day(ld_dateinstalled) > li_day then
					li_day = li_day
				else
					li_day = day(ld_dateinstalled)
				end if
				
				ld_lockin = date(li_year,li_month,li_day)
				ld_today = today()
				
				
				select  ( (add_months(dateinstalled,lockInPeriod) - dateinstalled )) DP_DAY  , TRUNC(SYSDATE -dateinstalled) DP_DAY 
				into :li_lockin,:li_no
				from aracctsubscriber
				where acctno = :as_acctno
				and divisioncode = :gs_divisioncode
				and companycode = :gs_companycode
				and rownum < 2
				using SQLCA;
				if SQLCA.sqlCode <> 0 then
					ls_msg = string(SQLCA.sqlCode) + ' ' + SQLCA.sqlerrText
					return ls_msg
				end if
				
				if li_no > li_lockIn then
					select  nvl(( (add_months(DATERELOCKIN,24) - DATERELOCKIN )),0) DP_DAY  , nvl(TRUNC(SYSDATE -DATERELOCKIN),0) DP_DAY 
					into :li_lockin,:li_no
					from aracctsubscriber
					where acctno = :as_acctno
					and divisioncode = :gs_divisioncode
					and companycode = :gs_companycode
					and rownum < 2
					using SQLCA;
					
					if li_lockin = 0 then
						return 'NO'
					end if
					
					if li_no > li_lockIn then
						ls_msg = 'NO'
					else
						ls_msg = 'YES'
					end if
				else 
					ls_msg = 'YES'
				end if
				
				return ls_msg
			
			--end validasi f_lockInPeriod
			
			if ls_msg <> 'NO' and ls_msg <> 'YES' then
				guo_func.msgBox("ERROR",ls_msg)
				return False
			end if
			
			s_arrears_override_policy.acctNo 						= iuo_subscriber.acctNo
			s_arrears_override_policy.arBalance 					= ld_ARBalance
			s_arrears_override_policy.subscriberName				= iuo_subscriber.subscriberName
			
			if ld_ARBalance > 0.00 and ls_msg = 'NO' then
				s_arrears_override_policy.overridePolicyTypeCode 	= '001'
				ls_remarks = "The current subscriber has a/r balances.  You can not continue with this request.  Do you want to override this policy?"
				s_arrears_override_policy.policyCode = '001'
			elseif ld_ARBalance > 0.00 and ls_msg = 'YES' then
				s_arrears_override_policy.overridePolicyTypeCode 	= '005'
				ls_remarks = "The current subscriber is in lock in period and has a/r balances.  You can not continue with this request.  Do you want to override this policy?"
				s_arrears_override_policy.policyCode = '004'
			elseif ld_ARBalance = 0.00 and ls_msg = 'YES' then
				s_arrears_override_policy.overridePolicyTypeCode 	= '003'
				ls_remarks = "The current subscriber is in lock in period.  You can not continue with this request.  Do you want to override this policy?"
				s_arrears_override_policy.policyCode = '005'
			else
				return True
			end IF
			
			--pop up override policy window for authorization
			
			if guo_func.msgbox("Policy Override!!!", ls_remarks, &										
									gc_Question, gc_yesNo, "Please secure an authorization for overriding this policy.") = 1 then
				
				openwithparm(w_online_authorization,s_arrears_override_policy)	
				
				--event open w_online_authorization
					string ls_remarks
						long ll_tranNo
						int li_noOfArrears = 0, li_subscription, li_ads
						dateTime ldt_date
						
						istr_override_policy = message.powerObjectParm
						
						if f_getPolicy(istr_policy, istr_override_policy.policyCode, istr_override_policy.refTranTypeCode) <> 0 then
							closeWithReturn(this,'ER')
						else
						
							dw_1.setTransObject(SQLCA);
							dw_2.setTransObject(SQLCA);
							dw_1.insertRow(0)
							
							if not guo_func.get_nextNumber_continous('OVERRIDE', ll_tranNo, '') then
								closeWithReturn(this,'ER')
							end if
							
							dw_1.setItem(1,'tranNo',string(ll_tranNo, '0000000000'))
							dw_1.setItem(1,'requestedby',gs_ufullname)
							
							select datediff(mm, dateInsTalled, getdate())
							into :li_subscription
							from arAcctSubscriber
							where acctNo = :istr_override_policy.acctNo
							and divisionCode = :gs_divisionCode
							and companyCode = :gs_companyCode
							using SQLCA;
							
							if isNull(li_subscription) then li_subscription = 0
							
							ldt_date = dateTime(RelativeDate(date(guo_func.get_server_datetime()), li_subscription))
							
							select count(*)
							into :li_ads
							from adsTranHdr
							where tranDate between :ldt_date and getDate()
							and acctNo = :istr_override_policy.acctNo
							and divisionCode = :gs_divisionCode
							and companyCode = :gs_companyCode
							using SQLCA;
							
							if isNull(li_ads) then li_ads = 0
							
							li_noOfArrears = f_getSubsNoOfMonthArrears(istr_override_policy.acctNo)
							
							if istr_override_policy.policyCode  = '001' then
								ls_remarks = 'Trans.: '+ upper(istr_policy.tranTypeName) + ' Subs.: ' + &
												 upper(istr_override_policy.subscriberName) + ' Bal.: ' + &
												 string(istr_override_policy.arBalance,'###,###,###,##0.00') + &
												 ' Arrears: ' + string(li_noOfArrears) + ' Lock In: NO '+'Subsription: ' + &
												 string(li_subscription) + ' mos. '+'ADS: ' +string(li_ads)
							elseif istr_override_policy.policyCode  = '005' then
								ls_remarks = 'Trans.: '+ upper(istr_policy.tranTypeName) + ' Subs.: ' + &
												 upper(istr_override_policy.subscriberName) + ' Bal.: ' + &
												 string(istr_override_policy.arBalance,'###,###,###,##0.00') + &
												 ' Arrears:  '+ string(li_noOfArrears) + ' Lock In: YES Subsription: ' + &
												 string(li_subscription) + ' mos. '+'ADS: ' +string(li_ads)
							elseif istr_override_policy.policyCode  = '003' then
								ls_remarks = 'Trans.: '+ upper(istr_policy.tranTypeName) + ' Subs.: ' + &
												 upper(istr_override_policy.subscriberName) + ' Bal.: ' + &
												 string(istr_override_policy.arBalance,'###,###,###,##0.00') + &
												 ' Arrears:  0 Lock In: YES Subsription: ' + &
												 string(li_subscription) + ' mos. '+'ADS: ' +string(li_ads)
							elseif istr_override_policy.policyCode = '004' then
								ls_remarks = 'Trans.: '+ upper(istr_policy.tranTypeName) + ' Subs.: ' + &
												 upper(istr_override_policy.subscriberName) + ' RIP: ' + &
												 string(istr_override_policy.arBalance,'###,###,###,##0.00') 
							elseif istr_override_policy.policyCode = '002'  and istr_override_policy.reqType = 'APPLYML' then
								ls_remarks = 'Trans.: '+ upper(istr_policy.tranTypeName) + ' Subs.: ' + &
												 upper(istr_override_policy.subscriberName) + ' Charge Type: '+istr_override_policy.chargeType 
							elseif istr_override_policy.policyCode = '002'  and istr_override_policy.reqType = 'CHARGETYPE' then
								ls_remarks = 'Trans.:  CHANGE CHARGE TYPE Subs.: ' + &
												 upper(istr_override_policy.subscriberName) +  ' Charge Type: '+istr_override_policy.chargeType +&
												 'Bal.: '+string(istr_override_policy.arBalance,'###,###,###,##0.00') +&
												 ' Arrears: ' + string(li_noOfArrears) 
							elseif istr_override_policy.policyCode = '006' then
								ls_remarks = 'Trans.: '+ upper(istr_policy.tranTypeName) + ' Subs.: ' + &
												 upper(istr_override_policy.subscriberName) + ' Orig. CPE Fee: ' + &
												 string(istr_override_policy.origFee,'###,##0.00 ' ) + &
												 ' Request CPE Fee: ' + string(istr_override_policy.cpeRepFee,'###,##0.00 ')
							elseif  istr_override_policy.policyCode = '010' then
												ls_remarks = 'Trans: JO BACKDATE'
							end if			
							dw_1.setItem(1,'remarks',ls_remarks)
							dw_1.setItem(1,'policyName',istr_policy.policyName)
							dw_1.setItem(1,'arBalance',istr_override_policy.arBalance)
							dw_1.setItem(1,'lockinperiod','N')
						end IF
						
					--end open w_online_authorization
						
					--event button click w_open_autorization
						
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
							end if	
							
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
							
						end if
							
					--end event  button click
				 
				if message.stringParm = 'CN' then
					guo_func.msgbox("Policy Override!!!", &
									"You have cancelled the authorization.  This will cancel your transaction.", &										
									gc_Information, &
									gc_OKOnly, &
									"Please secure an authorization for overriding this policy.")
									
					--reset entry
					return false
				elseif message.stringParm = 'DP' then
					return false
				elseif message.stringParm = 'ER' then
					return false
				end if
			else  --policy ignored close window transaction
				guo_func.msgbox("Policy Override!!!", &
								"You have cancelled the authorization.  This will cancel your transaction.", &										
								gc_Information, &
								gc_OKOnly, &
								"Please secure an authorization for overriding this policy.")
								
				// reset entry		
				return false
			end if
			return true
			
		
		--END VALIDASI f_overrideArrearsLockIn
		

		uf_prepare_required_initial_payment()	
		
		--validasi uf_prepare_required_initial_payment
		
		string 	ls_subsTypeCode, ls_packageCode, ls_chargeTypeCode, ls_acquisitionTypeCode, ls_arTypeCode
			long 		ll_rows, ll_success
			decimal	ld_penalty
			int      li_priority
			
			ls_subsTypeCode  = iuo_subscriber.subsTypeCode
			ls_packageCode = iuo_subscriber.packageCode
			ls_chargeTypeCode = iuo_subscriber.chargeTypeCode
			
			--==================================================
			-- let's compute for the penalty first
			-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			if not iuo_subscriber.computeForPenaltyApplyPD(ls_arTypeCode, ld_penalty) then
				guo_func.msgbox('Warning!', iuo_subscriber.lastSQLCode + '~r~n' + iuo_subscriber.lastSQLErrText)
				return -1
			end IF
			
			--validasi computeForPenaltyApplyPd
			
			datetime ldt_today

				ldt_today = guo_func.get_server_date()
				
				if subscriberStatusCode = 'DEA' then	
					
					s_applDeacInfo lstr_applDeacInfo
					
					if not getApplDeacInfo(lstr_applDeacInfo) then
						return FALSE
					end if
					
					if ldt_today < lstr_applDeacInfo.activationIntendedDate then
						as_arTypeCode = 'PBIRD'
						ad_penalty = 100
					elseif (ldt_today >= lstr_applDeacInfo.gracePeriodDateFrom) and (ldt_today <= lstr_applDeacInfo.gracePeriodDateTo) then
						as_arTypeCode = 'PWRGP'
						ad_penalty = 200
					end if
					
				else
					
					ad_penalty = 0
					
				end IF
				
			--end validasi computeForPenaltyApplyPd
			
			if not f_getArTypePriority(ls_arTypeCode, li_priority) then
				guo_func.msgbox('Warning!', 'Unable To get Priority of Ar-Type [' + trim(ls_arTypeCode) + ']')	
				return -1
			end if	
			
			--validasi f_getArTypePriority
			
			if isnull(as_arTypeCode) then return FALSE

			select priority
			  into :ai_priority
			  from arTypeMaster
			 where arTypeCode = :as_arTypeCode
			 and divisionCode = :gs_divisionCode
			and companyCode = :gs_companyCode
			using SQLCA;
			if SQLCA.sqlCode < 0 then
				return FALSE
			end if
			
			return TRUE
						
			--end validasi 
			
			if ld_penalty > 0 then
				ll_rows = idw_ReqInitPayment.InsertRow(0)
				idw_ReqInitPayment.SetItem(ll_rows, 'arTypeCode', ls_arTypeCode)
				idw_ReqInitPayment.SetItem(ll_rows, 'amount', ld_penalty)
				idw_ReqInitPayment.SetItem(ll_rows, 'priority', li_priority) // I added this
			end if
			--==================================================
			--end
			--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			
			ll_rows = idw_ReqInitPayment.rowCount()
			
			if not isnull(ls_subsTypeCode) then
				if not isnull(ls_packageCode) then
					if not isnull(ls_chargeTypeCode) then				
							if ll_rows > 0 then
								ll_success = uf_compute_req_init_payment_pd(	&
										ls_subsTypeCode, &
										ls_packageCode, &
										ls_chargeTypeCode, &
			 							id_mLineExtPermanentDiscFee, &
										idw_ReqInitPayment )
										
								--validasi uf_compujte_eq_init_payment_pd
										
									--subscriberType based fees
									--mLineExtPermanentDiscFee
									decimal{2} ld_mLineExtPermanentDiscFee
									
									
									--acquisitionTypeCode based fees
									long ll_row
									decimal{2} ld_amount_PDF
									
									ld_amount_PDF = 0.00
									ld_amount_PDF = ad_mlineextpermanentdiscfee
									
									--chargeType based fees (discounts)
									
									--PDF - Permanent Disconnection Fees Required Initial Payment
									decimal{2} ld_percentDiscount, ld_amountDiscount
									ld_percentDiscount = 0.00 
									ld_amountDiscount = 0.00
									
									SELECT 	percentDiscount
									INTO 		:ld_percentDiscount
									FROM 		chargeTypeDiscountMaster
									WHERE 	chargeTypeCode = :as_chargeTypeCode and arTypeCode = 'PDF'
									and divisionCode = :gs_divisionCode
									and companyCode = :gs_companyCode
									USING SQLCA;			
									If SQLCA.SQLcode = -1 then
										messagebox('SM-0000001',"select in chargeTypeMaster SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText)
										return -1
									end if
									
									if isnull(ld_percentDiscount) then ld_percentDiscount = 0.00 
									if ld_percentDiscount > 0.00 then
										ld_amountDiscount = ( ld_amount_PDF * (ld_percentDiscount/100) )
										ld_amount_PDF = ld_amount_PDF - ld_amountDiscount
										if ld_amount_PDF < 0.00 then 
											ld_amount_PDF = 0.00
										end if
									end if
									
									
									--update datawindow for required initial payment
									ll_row = adw_ReqInitPayment.find("arTypeCode='PDF'",1,adw_ReqInitPayment.rowCount())		
									adw_ReqInitPayment.scrollToRow( ll_row )						
									if ll_row > 0 then
										adw_ReqInitPayment.setItem( ll_row, "amount", ld_amount_PDF )
									end if		
									
									adw_ReqInitPayment.acceptText()
									
									
									return 0


								
								--end validasi
							end if			
					end if
				end if
			end if
								
			return 0
		
		--end validasi uf_prepare_required_initial_payment
		
		
		
end choose
return 

--END UE SEARCH ACCTNO

--EVENT ITEMCHANGE COLUMN IN FORM

long ll_row, ll_success
string ls_search, ls_result, ls_acctNo

string ls_subscriberName, ls_serviceAddress, ls_billingAddress
string ls_package, ls_packagetype
string ls_subscriberStatus, ls_chargeType
string ls_subscriberType, ls_subscriberUserType
decimal{2} ld_monthlyMlineFee

if dwo.name = "acctno" then

	ls_acctNo = trim(data)
	if not iuo_subscriber.setAcctNo(ls_acctNo) then
		guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + iuo_subscriber.lastSQLErrText)
	end IF
	
	--VALIDASI CHECK IUO_SUBRIBER.SETACCTNO
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
	
	--END VALIASI CHECK IUO_SUBRIBER.SETACCTNO
	
	--subscrber name
	ls_subscriberName = iuo_subscriber.subscriberName 
	dw_header.setItem( 1, "subscriberName", ls_subscriberName )
	
	--service address
	if not iuo_subscriber.getServiceAddress(ls_serviceAddress) then
		guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
			iuo_subscriber.lastSQLErrText)
	end IF
	
	--validasi getServiceAddress
	lastMethodAccessed = 'getServiceAddress'

	as_serviceAddress = serviceAddressComplete (take FROM ue_subcriber.setaccno.serviceAddressComplete)
	
	--end getServiceAddress
		
	dw_header.setItem( 1, "serviceAddress", ls_serviceAddress )
	
	--billing address
	if not iuo_subscriber.getBillingAddress(ls_billingAddress) then
		guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
			iuo_subscriber.lastSQLErrText)
	end IF
	
	--validasi getBillingAddress
		lastMethodAccessed = 'getBillingAddress'
	
		as_billingaddress = billingAddressComplete (take FROM ue_subcriber.setaccno.billingAddressComplete)
	
	--end getBillingAddress
		
	dw_header.setItem( 1, "billingAddress", ls_billingAddress )
	
	--package 
	if not iuo_subscriber.getPackageName(ls_package_code) then
		guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
			iuo_subscriber.lastSQLErrText)
	end IF
	
	--validasi getPackageName
		
	lastMethodAccessed = 'getPackageName'

		select packageName
		  into :as_packageName
		  from arPackageMaster
		 where packageCode = :packageCode
		 	and divisionCode = :gs_divisionCode
			and companyCode = :gs_companyCode
		using SQLCA;
		if SQLCA.sqlcode <> 0 then
			lastSQLCode = string(SQLCA.sqlcode)
			lastSQLErrText = SQLCA.sqlerrtext
			return FALSE
		end if
		return TRUE

	--end validasi
			
	dw_header.setItem( 1, "package", ls_package )		
	
	--package type
	if not iuo_subscriber.getPackageTypeName(ls_packagetype) then
		guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
			iuo_subscriber.lastSQLErrText)
	end IF
	
	--validasi getPackageTypeName
	lastMethodAccessed = 'getPackageTypeName'

	select distinct PackageTypeMaster.packageTypeName
	  into :as_packageTypeName
	  from arPackageMaster, packageTypeMaster
	 where arPackageMaster.packageCode = :packageCode
	 and arPackageMaster.divisionCode = :gs_divisionCode
		and packageTypeMaster.companyCode = :gs_companyCode
	and arPackageMaster.companyCode = :gs_companyCode
	and arPackageMaster.packageTypeCode = packageTypeMaster.packageTypeCode
	 using SQLCA;
	if SQLCA.sqlcode <> 0 then
		lastSQLCode = string(SQLCA.sqlcode)
		lastSQLErrText = SQLCA.sqlerrtext
		return FALSE
	end if
	return TRUE

	--end validasi
	
	dw_header.setItem( 1, "packageType", ls_packagetype )		
	
	--subscriber status
	if not iuo_subscriber.getSubscriberStatusName(ls_subscriberStatus) then
		guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
			iuo_subscriber.lastSQLErrText)
	end IF
	
	--validasi getSubscriberStatusName
		
	lastMethodAccessed = 'getSubscriberStatusName'

	select subscriberStatusName
	  into :as_subscriberStatusName
	  from subscriberStatusMaster
	 where subscriberStatusCode = :subscriberStatusCode
	 using SQLCA;
	if SQLCA.sqlcode <> 0 then
		lastSQLCode = string(SQLCA.sqlcode)
		lastSQLErrText = SQLCA.sqlerrtext
		return FALSE
	end if
	return TRUE
	
	--end validasi getSubscriberStatusName
		
	dw_header.setItem( 1, "subscriberStatus", ls_subscriberStatus )				
	
	--customer type
	if not iuo_subscriber.getchargeTypeName(ls_chargeType) then
		guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
			iuo_subscriber.lastSQLErrText)
	end IF
	
	--VALIDASI GETCHARGETYPENAME
		
		lastMethodAccessed = 'getchargeTypeName'

		select chargeTypeName
		  into :as_chargeTypeName
		  from chargeTypeMaster
		 where chargeTypeCode = :chargeTypeCode
		 using SQLCA;
		if SQLCA.sqlcode <> 0 then
			lastSQLCode = string(SQLCA.sqlcode)
			lastSQLErrText = SQLCA.sqlerrtext
			return FALSE
		end if
		return TRUE

		--END GETCHARGETYPENAME
		
	dw_header.setItem( 1, "chargeType", ls_chargeType )				
	
	--subscriber Type
	if not iuo_subscriber.getSubsTypeName(ls_subscriberType) then
		guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
			iuo_subscriber.lastSQLErrText)
	end IF
	
	--VALIDASI GET getSubsTypeName
		
	  lastMethodAccessed = 'getSubsTypeName'

		select subsTypeName
		  into :as_subsTypeName
		  from subscriberTypeMaster
		 where subsTypeCode = :subsTypeCode
		 and companyCode = :gs_companyCode
		using SQLCA;
		if SQLCA.sqlcode <> 0 then
			lastSQLCode = string(SQLCA.sqlcode)
			lastSQLErrText = SQLCA.sqlerrtext
			return FALSE
		end if
		return TRUE
		
	--END getSubsTypeName
			
	dw_header.setItem( 1, "subscriberType", ls_subscriberType )				
	
	--subscriber User Type
	if not iuo_subscriber.getSubsUserTypeName(ls_subscriberUserType) then
		guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
			iuo_subscriber.lastSQLErrText)
	end IF
	
	--VALIDASI getSubsUserTypeName
	
		lastMethodAccessed = 'getSubsUserTypeName'

		select subsUserTypeName
		  into :as_subsUserTypeName
		  from subsUserTypeMaster
		 where subsUserTypeCode = :subsUserTypeCode
		 using SQLCA;
		if SQLCA.sqlcode <> 0 then
			lastSQLCode = string(SQLCA.sqlcode)
			lastSQLErrText = SQLCA.sqlerrtext
			return FALSE
		end if
		return TRUE

	--END getSubsUserTypeName
			
	dw_header.setItem( 1, "subscriberUserType", ls_subscriberUserType )				
	
	--monthly Mline Fee
	if not iuo_subscriber.getMlineMonthlyRate(ld_monthlyMlineFee) then
		guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
			iuo_subscriber.lastSQLErrText)
	end IF
	
	--VALIDASI getMlineMonthlyRate
	lastMethodAccessed = 'getMLineMonthlyRate'

	select monthlyRate
	  into :ad_mlineMonthlyRate
	  from arPackageMaster
	 where packageCode = :packageCode
	 and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	using SQLCA;
	if SQLCA.sqlcode <> 0 then
		lastSQLCode = string(SQLCA.sqlcode)
		lastSQLErrText = SQLCA.sqlerrtext
		return FALSE
	end if
	return TRUE

	--END getMlineMonthlyRate
		
	dw_header.setItem( 1, "monthlyrate", ld_monthlyMlineFee )							
	
	dw_header.acceptText()
		
	id_mLineExtPermanentDiscFee = 0.00
	
	select permanentDiscFee
	into :id_mLineExtPermanentDiscFee
	FROM 		arpackageMaster
	WHERE 	packageCode = :iuo_subscriber.packageCode
	and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	USING SQLCA;			
	If SQLCA.SQLcode = -1 then
		messagebox('SM-0000001',"select in arpackageMaster SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText)
	end if		
	
	if isnull(id_mLineExtPermanentDiscFee) then id_mLineExtPermanentDiscFee = 0.00	
	
	uf_prepare_required_initial_payment()
	
elseif dwo.name = 'disconnectionremarkscode' then	
	
-	--QUERY TO GET LIST DISCONNECTION REMARK CODE
		SELECT  disconnectionremarksmaster.disconnectionremarkscode ,
				  disconnectionremarksmaster.disconnectionremarksname     
			  FROM disconnectionremarksmaster    
		where companycode = 'VISIB'
	--END 
	dataWindowChild dwc_dcSubCode
	this.getChild('disconnectionsubremarkscode', dwc_dcSubCode)
	dwc_dcSubCode.setTransObject(SQLCA)
	dwc_dcSubCode.retrieve(trim(data),is_serviceType, gs_divisionCode, gs_companyCode)
	this.setItem(row, 'disconnectionsubremarkscode', '')
	
	trigger event ue_set_column('disconnectionsubremarkscode')	
	
end if

--END EVENT ITEMCHANGE OLUMN IN FORM

--BUTTON NEW

long ll_currentRow, ll_acctno, ll_applExt
string ls_acctno, ls_applExt
datetime ldt_date, ldt_today


dataWindowChild ldwc_location
dw_header.getChild("locationcode", ldwc_location)
ldwc_location.setTransObject(SQLCA)
ldwc_location.retrieve(gs_companycode)


dw_header.insertRow(0)

if not guo_func.get_nextnumber('APPLYPD', ll_applExt, "") then
	return
end IF

--VALIDASI GET_NEXTNUMBER

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

--END VALIDASI GET_NEXTNUMBER

ls_applExt = string(ll_applExt, '00000000')
ll_currentRow = dw_header.getRow()

ldt_date = Datetime(today(),now())
ldt_today = guo_func.get_server_datetime()

--Set default Values
dw_header.setitem(1 , "tranNo", ls_applExt) 
dw_header.setitem(1 , "tranDate", guo_func.get_server_date()) 
dw_header.setitem(1,  "dateadd", ldt_date) 

dw_header.setitem(1 , "preferreddatetimefrom", ldt_today)
dw_header.setitem(1 , "preferreddatetimeto", ldt_today)

pb_new.enabled = false
pb_close.enabled = false

pb_save.enabled = true
pb_cancel.enabled = TRUE

string ls_AcctNo
long ll_row, ll_priority	
decimal{2} ld_amount, ld_stbdeposit, ld_materialsstbadvances, ld_installationfeesadvances, ld_totalrequiredinitialpayment

--insert rows to required initial payment
--insert PDF - Advance Payment for Permanent Disconnection Fees
select priority 
into :ll_priority	
from arTypeMaster 	
where arTypeCode = 'PDF' 	
and divisionCode = :gs_divisionCode
and companyCode = :gs_companyCode
using SQLCA;
if SQLCA.SQLCode <> 0 then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = "select in arTypeMaster"+"SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
	return -1	
end if	

ll_row = idw_ReqInitPayment.insertRow(0)
idw_ReqInitPayment.scrollToRow( ll_row )
idw_ReqInitPayment.setItem( ll_row, "arTypeCode", 'PDF' )
idw_ReqInitPayment.setItem( ll_row, "amount", 0.00 )
idw_ReqInitPayment.setItem( ll_row, "priority", ll_priority )

idw_ReqInitPayment.acceptText()


--END BUTTON NEW

--BUTTON SAVE

long ll_acctno, ll_tranNo
string ls_acctno
decimal{2} ld_pdFee

--Confirm
If guo_func.msgbox('Confirmation', "You wish to save application for Permanent Disconnection?", gc_question, gc_okCancel,'Click OK to Proceed') <> 1 Then
	return -1
End If

if not guo_func.get_nextNumber(is_transactionID, ll_tranNo, "WITH LOCK") then			
	return -1
end if	

--VALIDASI GET_NEXTNUMBER

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

--END VALIDASI GET_NEXTNUMBER
 
idt_tranDate = guo_func.get_server_datetime()

is_tranNo = string(ll_tranNo, '00000000')

ls_acctNo = iuo_subscriber.acctNo

--==================================================
--NGLara | 03-31-2008
--Prepare GL Poster

--NOT USE ANYMORE
if not iuo_glPoster.initialize(is_transactionID, is_tranNo, idt_tranDate) then
	is_msgno 	= 'SM-0000001'
	is_msgtrail = iuo_glPoster.errorMessage
	is_sugtrail = iuo_glPoster.suggestionRemarks
	return -1
end IF

--NOT USE ANYMORE
uo_subs_advar.setGLPoster(iuo_glPoster)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

--save record to applofmlineextpermdischdranddtl
if trigger event ue_save_applofmlineextpermdischdranddtl(ls_acctno, is_tranno) = -1 then
   return -1
end IF

--VALIDASI UE_SAVE_APPLOFMLINEEXTPERMDISCHDRANDDTL

string 	ls_tranNo, ls_locationCode, ls_errormsg
string 	ls_acctNo, ls_userAdd, ls_tranTypeCode
datetime ldt_tranDate
string 	ls_specialInstructions, ls_macAddress
string 	ls_reason, ls_disconnectionreasonCode, ls_referenceJONo, ls_dcSubremarksCode
datetime ldt_preferreddatetimefrom, ldt_preferreddatetimeto						
datetime ldt_dateadd 
long 		ll_row


ls_tranTypeCode = "APPLYPD"
ll_row = dw_header.getrow()
ls_tranno = as_tranno

--idw_application_for_ext_dtl.acceptText() 
--idw_reqInitPayment.acceptText()


--get subscriber information
ldt_tranDate 					= guo_func.get_server_date()
ls_acctNo 						= trim(as_acctno)
ls_locationCode				= trim(dw_header.getItemString(ll_row, "locationCode"))	
ls_reason						= trim(dw_header.getItemString(ll_row, "reason"))	
ls_disconnectionreasonCode = trim(dw_header.getItemString(ll_row, "disconnectionremarkscode"))	
ls_dcSubremarksCode 	= trim(dw_header.getItemString(ll_row, "disconnectionsubremarkscode"))
ldt_preferreddatetimefrom	= dw_header.getItemDateTime(ll_row, "preferreddatetimefrom")
ldt_preferreddatetimeto		= dw_header.getItemDateTime(ll_row, "preferreddatetimeto")
ls_specialInstructions		= dw_header.getItemString(ll_row, "specialInstructions")

--Validation
if ls_acctno = '' or isnull(ls_acctno) then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = "Saving Subscriber Master : ~r~n Cannot save with unknown Account No."
	return -1
end if	

if ldt_preferredDateTimeto < ldt_preferredDateTimeFrom or isNull(ldt_preferredDateTimeTo) then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = "Please check your date... Invalid Preferred DateTime To!"
	return -1
end if

if ls_dcSubremarksCode = '' or isnull(ls_dcSubremarksCode) then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = "Saving Subscriber Master : ~r~n Cannot save with unknown Disconnection Sub Remarks Code."
	return -1
end if	

if ls_disconnectionreasonCode = '' or isnull(ls_disconnectionreasonCode) then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = "Saving Subscriber Master : ~r~n Cannot save with unknown Disconnection Remarks Code."
	return -1
end if	

--validate preferred date time from < to

--Insert record for applOfExtTranHdr
INSERT INTO applOfPermanentDiscTranHdr
		(
		tranNo,
		tranDate,
		acctNo,
		reason, 
		locationcode,
		disconnectionremarkscode,	
		disconnectionsubremarkscode,
		specialinstructions,
		referenceJONo,
		preferreddatetimefrom, 
		preferreddatetimeto,	
		applicationStatusCode,
		currentSubscriberStatusCode,
		dateadd,
		useradd,
		divisionCode,
		companyCode
		)
VALUES
		(
		:ls_tranNo,
		:ldt_tranDate,
		:ls_acctNo,
		:ls_reason, 
		:ls_locationCode,
		:ls_disconnectionreasonCode,
		:ls_dcSubremarksCode,
		:ls_specialInstructions,
		null,
		:ldt_preferreddatetimefrom, 
		:ldt_preferreddatetimeto,						
		'FJ',
		:iuo_subscriber.subscriberStatusCode,
		getdate(),
		:gs_UserName,
		:gs_divisionCode,
		:gs_companyCode
		)
USING SQLCA;
	
if SQLCA.SQLCode = -1 then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = "Saving ApplOfMlineExtPermDiscTranHdr ~nSQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
	return -1
end if

if dw_detail.rowCount() > 0 then

	--Insert record for applOfMlineExtPermDiscTranHdr
	long ll_rows, ll_loop, ll_tranNo
	string ls_scanned, ls_acquisitionTypeCode, ls_acquiredBefore2003, ls_surrendered
	dec{2} ld_rate
	
	string ls_itemCode, ls_serialNo
	long ll_BoxIDNo
	
	uo_cm luo_cableModem
	luo_cableModem = create using "uo_cm"
	
	ls_serialNo 	= dw_detail.GetItemString(1, "serialNo")
	ls_surrendered = dw_detail.GetItemString(1, "isreturncm")
	if isnull(ls_surrendered) or ls_surrendered = '' then ls_surrendered = 'N'
	
	if not luo_cableModem.setSerialNo(ls_serialNo) then
		guo_func.msgbox("Warning!", luo_cableModem.lastSQLCode + "~r~n" + luo_cableModem.lastSQLErrText)		
		return -1
	end IF
	
	--VALIDASI SETSERIALNO
	
	serialNo = trim(as_serialno)

		--check if existing
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
		
		messagebox(' SQLCA.sqlcode ',string(SQLCA.sqlcode))
		
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
	
	--END VALIDASI SETSERIALNO
	
	ls_itemCode 			  = luo_cableModem.itemCode
	ls_macAddress 			  = luo_cableModem.macAddress	
	ls_acquisitionTypeCode = luo_cableModem.acquisitionTypeCode
			
	if not isnull(ls_serialNo) and trim(ls_serialNo) <> '' then 	
	
		if ls_surrendered = 'Y' then			
			--update serialno location to receivedBy (location)
			--serialNoMaster.locationCode = ls_locationCode		
			if ls_acquisitionTypeCode <> 'BUY' then // we donot pull out stb which were bought by subscribers
				update serialNoMaster 
					set locationCode = :ls_locationCode, serialNoStatusCode = 'AV'
				where serialNo = :ls_serialNo and itemCode = :ls_itemCode
				and   companyCode = :gs_companyCode
				and   divisionCode = :gs_divisionCode
				using SQLCA;
			
				if SQLCA.SQLCode = -1 then
					is_msgNo    = 'SM-0000001'
					is_msgTrail = "Error updating serialNoMaster. "+"SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
					return -1	
				end if	
			end if
			
			if not iuo_subscriber.insertintompthrilrequestmaster(is_transactionId, ls_tranNo, 'DEACTIVATE', ls_errormsg, TRUE) then
				is_msgNo    = 'SM-0000001'
				is_msgTrail = ls_errormsg
				return -1
			end if
			
			if ls_acquisitionTypeCode <> 'BUY' then 
				delete from subscriberCPEMaster 
					where acctNo = :ls_acctNo and serialNo = :ls_serialNo and macAddress = :ls_macAddress 
				using SQLCA;
			
				if SQLCA.SQLCode = -1 then
					is_msgNo    = 'SM-0000001'
					is_msgTrail = "Error deleteing record from subscriberCPEMaster. "+"SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
					return -1	
				end if	
			end if
		end if
		
	end if
	insert into applOfPermanentDiscTranDtl
		(tranNo,
		 itemCode,
		 macAddress,
		 boxIDNo,
		 serialNo,
		 acquisitionTypeCode,
		 acquiredBefore2003,
		 surrendered,
		 divisionCode,
		 companyCode)
	values
		(:ls_tranNo,
		 :ls_itemCode,
		 :luo_cableModem.macAddress,
		 null,
		 :ls_serialNo,
		 :ls_acquisitionTypeCode,
		 null,
		 :ls_surrendered,
		 :gs_divisionCode,
		 :gs_companyCode)
	using SQLCA;	
	if SQLCA.SQLCode <> 0 then
		is_msgNo    = 'SM-0000001'
		is_msgTrail = "insert in applOfPermanentDiscTranDtl "+"SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
		return -1	
	end if
	
end if

RETURN 0

--END VALIDASI UE_SAVE_APPLOFMLINEEXTPERMDISCHDRANDDTL

--create records on subsInitialPayment
if trigger event ue_save_subsInitialPayment(ls_acctno, ld_pdFee) = -1 then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = "Saving subsInitialPayment ~nSQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
	return -1
end IF

--VALIDASI ue_save_subsInitialPayment

long ll_priority, ll_row,  ll_rows, ll_loop
string ls_acctno, ls_arTypeCode, ls_tranNo, ls_currency
dec{2} ld_amount, ld_rate

ls_acctno = trim(as_acctno)

ll_rows = idw_ReqInitPayment.rowCount()
ad_pdFee = 0
for ll_loop = 1 to ll_rows
		
	ls_arTypeCode = idw_ReqInitPayment.getItemString(ll_loop, "arTypeCode")
	ld_amount = idw_ReqInitPayment.getItemDecimal(ll_loop, "amount")
	ll_priority = idw_ReqInitPayment.getItemNumber(ll_loop, "priority")
	
	if ld_amount > 0.00 then
		choose case ls_arTypeCode
			case 'OCADV', 'OCDEP', 'OCDEQ'
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
					 :ls_arTypeCode,
					 :ls_tranNo,
					 :idt_tranDate,
					 :ll_priority,
					 :ld_amount,
					 0,
					 :ld_amount,
					 'N',
					 :gs_divisionCode,
					 :gs_companyCode)
				using SQLCA;	
				if SQLCA.SQLCode <> 0 then
					is_msgNo    = 'SM-0000001'
					is_msgTrail = "insert in SubsInitialPayment "+"SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
					return -1	
				end if
			case else
				ad_pdFee = ad_pdFee + ld_amount
		end choose
	end if	
next

return 0



--END VALIDASI ue_save_subsInitialPayment

--==================================================
--Apply Open Credits
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if not uo_subs_advar.setAcctNo(ls_acctno) then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = uo_subs_advar.lastSQLCode + '~r~n' + uo_subs_advar.lastSQLErrText
	return -1
end if
if	This.Event ue_applyOCBalances(ld_pdFee) <> 0 then
	return -1	
end IF

--validasi uo_subs_advar.setAcctNo

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

return TRUE

--end validasi uo_subs_advar.setAcctNo

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

--not use anymore
if not iuo_glPoster.postGLEntries() then
	is_msgno 	= 'SM-0000001'
	is_msgtrail =  iuo_glPoster.errorMessage
	is_sugtrail = iuo_glPoster.suggestionRemarks
	return -1
end if


if	not guo_func.set_number(is_transactionID, ll_tranNo) then
	return -1	
end IF

--VALIDASI SET_NUMBER

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


dw_reqinitpayment.reset()
dw_detail.reset()
return 0


--END BUTTON SAVE




	