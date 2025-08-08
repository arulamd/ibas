opensheetwithparm(w_application_extension_w_arg,'CTV', w_mdiFrame, 0, original!)

is_serviceType = message.stringParm

is_serviceType = 'CTV'

iuo_subscriber = create uo_subscriber_def

--QUERY FORM HEADER
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
			  0 noOfSTB, applofexttranhdr.packageCode, ''packageName
        FROM applofexttranhdr
        
--QUERY DITRIBUTE EXT
  SELECT  acquisitiontypemaster.acquisitiontypename ,           
applofexttrandtl.qty ,          
 applofexttrandtl.rate ,           
applofexttrandtl.amount ,          
 acquisitiontypemaster.priority ,          
 applofexttrandtl.acquisitiontypecode ,          
 '' requiresApproval, ''packageCode
FROM applofexttrandtl ,           
acquisitiontypemaster     
WHERE ( applofexttrandtl.acquisitiontypecode = acquisitiontypemaster.acquisitiontypecode )
 and          ( ( applofexttrandtl.tranno = :as_tranNo ) )  
 
 --QUERY REQUIRED INITIAL PAYMENT
  SELECT  subsinitialpayment.acctno , 
  subsinitialpayment.trantypecode , 
  subsinitialpayment.artypecode , 
  subsinitialpayment.tranno , 
  subsinitialpayment.trandate , 
  subsinitialpayment.priority , 
  subsinitialpayment.amount 
  FROM subsinitialpayment   
  
  
  --UE SEARCH ACCTNO
  
long ll_row, ll_success, ll_count
string ls_search, ls_result, ls_acctNo, ls_packageName

string ls_subscriberName, ls_serviceAddress, ls_billingAddress
string ls_package, ls_generalPackage
string ls_subscriberStatus, ls_chargeType
string ls_subscriberType, ls_subscriberUserType
decimal{2} ld_occupancyRate, ld_monthlyMlineFee, ld_monthlyExtFee
long ll_noOfExt, ll_noOfSTB, ll_noOfApplTransfer
string ls_subscode
str_search str_s

ls_search = trim(as_search)
ll_row = dw_header.getrow()


choose case ls_search
	case "acctno"
		str_s.serviceType = is_serviceType
		str_s.s_dataobject = "dw_aracct_russ"
		str_s.s_return_column = "acctno"
		str_s.s_title = "Search For Subscribers"
		
		--QUERY SEARCH ACCTNO
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
		
		--FILTER BY ACCTNO , DIVISION CODE, COMPANY CODE
				   
		openwithparm(w_search_subscriber,str_s)

		ls_result = trim(Message.StringParm)				
		if ls_result = '' or isNull(ls_result) then			
			return 		
		end if
		dw_header.setitem(ll_row,'acctno', ls_result)
		ls_acctNo = ls_result
		select subscriberStatusCode
		into :ls_subscode
		from arAcctSubscriber
		where acctno = :ls_result
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		
		using SQLCA;	
		
			
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
		end IF
		
		--uo_subscriber_def iuo_subscriber

		if not iuo_subscriber.setAcctNo(ls_acctNo) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + iuo_subscriber.lastSQLErrText)
			return
		end IF
		
		--VALIDASI SETACCTNO


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

		--END VALIDASI SETACCTNO
		
		is_isDigital = iuo_subscriber.isDigital
		if is_isDigital = 'Y' then
			dw_detail.dataObject = 'dw_digital_for_ext_dtl'
		else
			dw_detail.dataObject = 'dw_application_for_ext_dtl'
		end if
		dw_detail.setTransObject(SQLCA);
		
		--package code
		is_packagecode = iuo_subscriber.packagecode 
		
		select extinstfeeHD  into :id_extInstFeeHD
		from arpackagemaster 
		where packagecode = :is_packagecode
		and divisioncode = :gs_divisioncode
		and companycode = :gs_companycode
		using SQLCA;
		if SQLCA.SQLCode <> 0 then
			guo_func.MsgBox('Pending Application Found...', 'This account has a pending Application for [Extension],'+&
								 ' please verify the transaction on JO Monitoring...')
			return
		end if
				
		--subscrber name
		ls_subscriberName = iuo_subscriber.subscriberName 
		dw_header.setItem( 1, "subscriberName", ls_subscriberName )
		
		--service address
		if not iuo_subscriber.getServiceAddress(ls_serviceAddress) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText) 
			return
		end if
		dw_header.setItem( 1, "serviceAddress", ls_serviceAddress )
		
		--iuo_subscriber.getServiceAddress = iuo_subscriber.serviceAddressComplete;
		
		--billing address
		if not iuo_subscriber.getBillingAddress(ls_billingAddress) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return
		end if
		dw_header.setItem( 1, "billingAddress", ls_billingAddress )
		
		--iuo_subscriber.getBillingAddress =  iuo_subscriber.billingAddressComplete
		
		--package 
		if not iuo_subscriber.getPackageName(ls_package) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return
		end if
		dw_header.setItem( 1, "package", ls_package )	
		
		--VALIDASI GET PACKAGENAME
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
		
		--END 
		
		--general package 
		if not iuo_subscriber.getGeneralPackageName(ls_generalPackage) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return
		end if
		dw_header.setItem( 1, "generalPackage", ls_generalPackage )	
		
		--VALIDASI GET GENERAL PACKAGE NAME
		
		lastMethodAccessed = 'getGeneralPackageName'

		select distinct generalPackageMaster.generalPackageName
		  into :as_generalPackageName
		  from arPackageMaster, generalPackageMaster
		 where arPackageMaster.packageCode = :packageCode
		 and arPackageMaster.divisionCode = :gs_divisionCode
			and arPackageMaster.companyCode = :gs_companyCode
			and generalPackageMaster.divisionCode = :gs_divisionCode
			and generalPackageMaster.companyCode = :gs_companyCode
			and arPackageMaster.generalPackageCode = generalPackageMaster.generalPackageCode
		 using SQLCA;
		if SQLCA.sqlcode <> 0 then
			lastSQLCode = string(SQLCA.sqlcode)
			lastSQLErrText = SQLCA.sqlerrtext
			return FALSE
		end if
		return TRUE
		
		--END VALIDASI
		
		--subscriber status
		if not iuo_subscriber.getSubscriberStatusName(ls_subscriberStatus) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return
		end if
		dw_header.setItem( 1, "subscriberStatus", ls_subscriberStatus )	
		
		--VALIDASI GET SUBCRIBER STATUS NAME
		
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
			
		--END 
		
		--customer type
		if not iuo_subscriber.getchargeTypeName(ls_chargeType) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return
		end if
		dw_header.setItem( 1, "chargeType", ls_chargeType )	
		
		--VALIDASI GETCHANGERTYPENAME
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
			
		--END 
		
		--subscriber Type
		if not iuo_subscriber.getSubsTypeName(ls_subscriberType) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return
		end if
		dw_header.setItem( 1, "subscriberType", ls_subscriberType )	
		
		--VALIDASI GET SUBS TYPE NAME
		
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
			
		--END
		
		--subscriber User Type
		if not iuo_subscriber.getSubsUserTypeName(ls_subscriberUserType) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return
		end if
		dw_header.setItem( 1, "subscriberUserType", ls_subscriberUserType )	
		
		--VALIDASI GET SUBUSERTYPENAME
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
			
		--END
		
		--occupancy Rate
		ld_occupancyRate = iuo_subscriber.occupancyRate
		dw_header.setItem( 1, "occupancyRate", ld_occupancyRate )							
		
		--monthly Mline Fee
		if not iuo_subscriber.getMlineMonthlyRate(ld_monthlyMlineFee) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return
		end if
		dw_header.setItem( 1, "monthlyMlineFee", ld_monthlyMlineFee )	
		
		--VALIDASI GET MLINEMONTHLYRATE
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

		--END
		
		--monthly Ext Fee
		if not iuo_subscriber.getExtMonthlyRate(ld_monthlyExtFee) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return
		end if
		dw_header.setItem( 1, "monthlyExtFee", ld_monthlyExtFee )
		
		--VALIDASI GET EXTMONTHLYRATE
			lastMethodAccessed = 'getExtMonthlyRate'

			if isDigital  <> 'Y'  then
			
				select extMonthlyRate
				  into :ad_extMonthlyRate
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
				
			else
				
				select sum(monthlyRate)
				  into :ad_extMonthlyRate
				  from arPackageMaster
				  inner join subscriberCPEMaster on arPackageMaster.packageCode = subscriberCPEMaster.packageCode
				  	and arPackageMaster.divisionCode = subscriberCPEMaster.divisionCode
					and arPackageMaster.companyCode = subscriberCPEMaster.companyCode
				 //where arPackageMaster.packageCode <> :packageCode --zar 12/08/2009 12am
				 where subscriberCPEMaster.isPrimary <> 'Y'
				 and subscriberCPEMaster.acctNo = :acctNo
				 and arPackageMaster.divisionCode = :gs_divisionCode
				 and arPackageMaster.companyCode = :gs_companyCode
				using SQLCA;
				if SQLCA.sqlcode <> 0 then
					lastSQLCode = string(SQLCA.sqlcode)
					lastSQLErrText = SQLCA.sqlerrtext
					return FALSE
				end if
				
				if isnull(ad_extMonthlyRate) then ad_extMonthlyRate = 0
				
				
			end if
			return TRUE


		--END 
		
		--long ll_noOfExt
		if not iuo_subscriber.getnoofactiveext(ll_noOfExt) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return
		end if
		dw_header.setItem( 1, "noOfExt", ll_noOfExt )	
		
		--VALIDASI GET NOOF ACTIVE EXT
		lastMethodAccessed = 'getNoOfExt'

			select count(acctNo)
			  into :al_noofext
			  from subscriberCPEMaster
			 where acctNo = :acctNo and acctNo is not null
			 	and divisionCode = :gs_divisionCode
			and companyCode = :gs_companyCode
			and cpeStatusCode = 'AC'
			 group by acctNo 
			 using SQLCA;
			if SQLCA.sqlcode < 0 then
				lastSQLCode = string(SQLCA.sqlcode)
				lastSQLErrText = SQLCA.sqlerrtext
				return FALSE
			elseif SQLCA.sqlcode = 100 then
				al_noofext = 0
			end if
			
			if al_noofext > 0 then
				if substypecode <> 'CP' then
					al_noofext = al_noofext - 1
				else
					al_noofext = 0
				end if
				///al_noofext = al_noofext - 1
			end if
			return TRUE

		--END
		
		--ll_noOfSTB
		if not iuo_subscriber.getNoOfSTB(ll_noOfSTB) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return
		end if
		dw_header.setItem( 1, "noOfSTB", ll_noOfSTB )													
		dw_header.acceptText()
		
		--VALIDASI GET NO OF STB
		
		lastMethodAccessed = 'getNoOfSTB'

		select count(acctNo)
		  into :al_noofSTB
		  from subscriberCPEMaster
		 where acctNo = :acctNo and acctNo is not null
		 and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		group by acctNo 
		 using SQLCA;
		if SQLCA.sqlcode < 0 then
			lastSQLCode = string(SQLCA.sqlcode)
			lastSQLErrText = SQLCA.sqlerrtext
			return FALSE
		elseif SQLCA.sqlcode = 100 then
			al_noofstb = 0
		end if
		
		return TRUE

		--END 
		
		------------------------------------------------------------
		--validate policy on no of months a/r min requirement - start
		------------------------------------------------------------
		s_arrears_override_policy.refTranTypeCode = 'APPLYEXT'
		if not f_overrideArrearsPolicyType(iuo_subscriber, s_arrears_override_policy ) then
			trigger event ue_cancel()
			return
		end IF
		
		--VALIDASI F_OVERRIDEARREARSPOLICYTYPE
		
		decimal {2} ld_ARBalance

			--------------------------------------------------------------
			--validate policy on no of months a/r min requirement - start
			--------------------------------------------------------------
			
			
			ld_ARBalance = 0.00
			--check if subscriber has a/r balances
			
			if not iuo_subscriber.getARBalance(ld_ARBalance,1) then
				guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
					iuo_subscriber.lastSQLErrText)
			end if
			
			--pop up override policy window for authorization
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
					
					openwithparm(w_online_authorization,s_arrears_override_policy)	
					
					--VALIDASI W_ONLINE_AUTORIZATION
					
					string 	ls_remarks, ls_tranNo, ls_mobileNo, ls_policy, ls_userRemarks
						dateTime	ldt_date
						long 		ll_tranNo
						
						if dwo.name = 'b_request' then
							this.acceptText()
							
							if not guo_func.get_nextNumber_continous('OVERRIDE', ll_tranNo, 'WITH LOCK') then
								guo_func.msgBox("ATTENTION","Unable to get an authorization no.")
								return -1
							end IF
							
							--VALIDASI GET nextNumber_continous
								f_displayStatus("Retrieving next transaction # for " + as_trantype + "...")

								string	ls_lockedby
								
								select lockedUserName
								  		into :ls_lockedby
								from sysTransactionParam
								 		where tranTypeCode = :as_tranType
										and companyCode = :gs_companyCode
										and divisionCode = :gs_divisionCode
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
										   and companyCode = :gs_companyCode
										   and divisionCode = :gs_divisionCode
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
									 and companyCode = :gs_companyCode
										and divisionCode = :gs_divisionCode	
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
							--END get_nextNumber_continous
							
							if not guo_func.set_number_continous('OVERRIDE', ll_tranNo) then
								guo_func.msgBox("ATTENTION","Unable to set the authorization no.")
								return -1
							end IF
							
							--VALIDASI GET set_number_continous
								update sysTransactionParam
									set recordLocked = 'N',
										 lockedUserName = '',
										 lastTransactionNo = :al_tranno
								where recordLocked = 'Y' 
										and trantypecode = :as_trantype
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
								
								return true
							--END set_number_continous
							
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
					
					--END w_online_authorization
					 
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
				
			end if
			return true

		--END 
		
		----------------------------------------------------------			
		--validate policy on no of months a/r min requirement - end
		------------------------------------------------------------
		
		
		--check if there are pending installations mline and ext
		
		--DEFAULT FALSE
		
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

		--installation extension fee shall use succeedingExtInstallFee
		
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
				
	
end choose
return 

--BUTTON NEW IN FORM

string ls_AcctNo
long ll_row, ll_priority	
decimal{2} ld_amount, ld_stbdeposit, ld_materialsstbadvances, ld_installationfeesadvances, ld_totalrequiredinitialpayment


// insert rows to required initial payment
// insert OCDEQ - Deposit for STB

select priority 
into :ll_priority	
from arTypeMaster 	
where arTypeCode = 'OCDEQ' 	
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
idw_ReqInitPayment.setItem( ll_row, "arTypeCode", 'OCDEQ' )
idw_ReqInitPayment.setItem( ll_row, "amount", 0.00 )
idw_ReqInitPayment.setItem( ll_row, "priority", ll_priority )


// insert SALES - Advance Payment for Materials
select priority 
into :ll_priority	
from arTypeMaster 	
where arTypeCode = 'SALES' 	
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
idw_ReqInitPayment.setItem( ll_row, "arTypeCode", 'SALES' )
idw_ReqInitPayment.setItem( ll_row, "amount", 0.00 )
idw_ReqInitPayment.setItem( ll_row, "priority", ll_priority )

// insert EXTF - Advance Payment for Installation Fees
select priority 
into :ll_priority	
from arTypeMaster 	
where arTypeCode = 'SFEXT'
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
idw_ReqInitPayment.setItem( ll_row, "arTypeCode", 'SFEXT' )
idw_ReqInitPayment.setItem( ll_row, "amount", 0.00 )
idw_ReqInitPayment.setItem( ll_row, "priority", ll_priority )

idw_ReqInitPayment.acceptText()



long ll_currentRow, ll_acctno, ll_applExt
string ls_acctno, ls_applExt
datetime ldt_date, ldt_today 

dw_header.insertRow(0)

if not guo_func.get_nextnumber('APPLYEXT', ll_applExt, "") then
	return
end IF

--VALIDASI GET NEXTNUMBER
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

--END GET NEXT NUMBER

ls_applExt = string(ll_applExt, '00000000')
ll_currentRow = dw_header.getRow()

ldt_date = Datetime(today(),now())
ldt_today = guo_func.get_server_datetime()

--Set default Values
dw_header.setitem(1 , "tranNo", ls_applExt) 
dw_header.setitem(1 , "tranDate", guo_func.get_server_date()) 
dw_header.setitem(1,  "dateadd", ldt_date) 
--delete this //dw_header.setitem(ll_currentRow, "acctno", ls_acctno) 
dw_header.setitem(1 , "preferreddatetimefrom", ldt_today)
dw_header.setitem(1 , "preferreddatetimeto", ldt_today)

pb_new.enabled = false
pb_close.enabled = false

pb_save.enabled = true
pb_cancel.enabled = true

id_rateBreakdowns = id_empty

--BUTTON SAVE

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
end if


--Confirm
If messagebox('Confirmation', "You wish to save new application for Additional Extension?", Question!, OKCancel! ) <> 1 Then
	return -1
End If

if not guo_func.get_nextNumber(ls_tranTypeCode, ll_tranNo, "WITH LOCK") then			
	return -1
end if	

--VALIDASI guo_func.get_nextNumber
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
	
is_tranNo = string(ll_tranNo, '00000000')
ld_totalInstFee = 0
ls_acctNo = dw_header.getItemString( 1, "acctNo" )


--ALREADY  NOT USE GL_POSTER
==================================================
--NGLara | 03-31-2008
--Prepare GL Poster
if not iuo_glPoster.initialize(is_transactionID, is_tranNo, idt_tranDate) then
	is_msgno 	= 'SM-0000001'
	is_msgtrail = iuo_glPoster.errorMessage
	is_sugtrail = iuo_glPoster.suggestionRemarks
	return -1
end IF

uo_subs_advar.setGLPoster(iuo_glPoster)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

--create records on subsInitialPayment
if trigger event ue_save_subsInitialPayment(ls_acctno, is_tranNo, ld_totalInstFee) = -1 then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = "Saving subsInitialPayment ~nSQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
	return -1
end IF

--VALIDASI UE_SAVE_SUBSINITIALPAYMENT

long ll_priority, ll_row,  ll_rows, ll_loop
string ls_acctno, ls_arTypeCode, ls_tranNo, ls_currency
dec{2} ld_amount, ld_rate

ls_acctno = trim(as_acctno)
ls_tranNo = ''
ls_tranno = as_tranno

ll_rows = idw_ReqInitPayment.rowCount()
ad_totalextfee = 0
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
				ad_totalextfee = ad_totalextfee + ld_amount
		end choose
	end if		
next

return 0


--END VALIDASI

--save record to APPLEXTTRANHDRandDTL
if trigger event ue_save_applOfExtTrahHdrAndDtl(ls_acctno, ld_totalInstFee) = -1 then
   return -1
end IF

--VALIDASI UE_SAVE_APPLOFEXTTRAGDRANDDTL

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
	
	--Validation
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
	string ls_acquisitionTypeCode
	dec{2} ld_rate, ld_amount
	
	ll_rows = idw_application_for_ext_dtl.rowCount()
	
	for ll_loop = 1 to ll_rows
			
		ls_acquisitionTypeCode 	= idw_application_for_ext_dtl.getItemString(ll_loop, 'acquisitionTypeCode')
		ll_applOfExtTranDtl_qty 	= idw_application_for_ext_dtl.getItemNumber(ll_loop, 'applOfExtTranDtl_qty')
		ld_rate 						= idw_application_for_ext_dtl.getItemDecimal(ll_loop, 'rate')
		ld_amount 					= idw_application_for_ext_dtl.getItemDecimal(ll_loop, 'amount')
		ls_packageCode			= idw_application_for_ext_dtl.getItemString(ll_loop, 'packageCode')
		
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


--END VALIDASI

if	not guo_func.set_number(ls_tranTypeCode, ll_tranNo) then
	return -1	
end IF

--VALIDASI guo_func.set_number

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
	
	return true

--END VALIDASI

--==================================================
--Apply Open Credits
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if not uo_subs_advar.setAcctNo(ls_acctno) then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = uo_subs_advar.lastSQLCode + '~r~n' + uo_subs_advar.lastSQLErrText
	return -1
end IF

--VALIDASI uo_subs_advar.setAcctNo
	
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
	
	--added codes for currency
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
	--end
	
	return TRUE

--END VALIDASI

if	This.Event ue_applyOCBalances(ld_totalInstFee) <> 0 then
	return -1	
end IF

--VALIDASI UE_APPLUOCBALANCE

	if not uo_subs_advar.getOcNextTranNo() then
		is_msgno = 'SM-0000001'
		is_msgtrail = uo_subs_advar.lastSQLCode + "~r~n" + uo_subs_advar.lastSQLErrText
		is_sugtrail = 'Error produced by uo_subs_advar.getOcNextTranNo()'
		return -1
	end IF
	
	--VALIDASI uo_subs_advar.getOcNextTranNo()
	 
		lastMethodAccessed = 'getOCNextTranNo'

		long ll_tranNo
		if not guo_func.get_nextnumber('OPENCR', ll_tranNo, 'WITH LOCK') then	
			lastSQLCode = '-2'
			lastSQLErrText = 'Could not obtain the next OC No.'
			return FALSE
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
				
				return true
		--END guo_func.get_nextnumber
		
		
		ocTranNo = ll_tranNo - 1
		
		return TRUE
	
	--END VALIDASI  getOcNextTranNo
	
	if not uo_subs_advar.setParentTranNo(is_tranNo) then
		is_msgno = 'SM-0000001'
		is_msgtrail = uo_subs_advar.lastSQLCode + "~r~n" + uo_subs_advar.lastSQLErrText
		is_sugtrail = 'Error produced by uo_subs_advar.setParentTranNo()'
		return -1
	end IF
	
	--VALIDASI uo_subs_advar.setParentTranNo	
	parentTranNo = as_tranNo
	
	if not uo_subs_advar.setJoReferenceNo('') then
		is_msgno = 'SM-0000001'
		is_msgtrail = uo_subs_advar.lastSQLCode + "~r~n" + uo_subs_advar.lastSQLErrText
		is_sugtrail = 'Error produced by uo_subs_advar.setJoReferenceNo()'
		return -1
	end IF
	
	--VALIDASI SETJOREFRENCENO
	joRefTranNo = as_joRefNo
	return TRUE
	----	
	if not uo_subs_advar.setJoTranTypeCode(is_transactionID) then
		is_msgno = 'SM-0000001'
		is_msgtrail = uo_subs_advar.lastSQLCode + "~r~n" + uo_subs_advar.lastSQLErrText
		is_sugtrail = 'Error produced by uo_subs_advar.setJoTranTypeCode()'
		return -1
	end IF
	
	--VALIDASI SETJOTRANSTYPECODE
		joTranTypeCode = as_joTranTypeCode
		return TRUE
	--END VALIDASI
	
	if not uo_subs_advar.setParentTranTypeCode(is_transactionID) then
		is_msgno = 'SM-0000001'
		is_msgtrail = uo_subs_advar.lastSQLCode + "~r~n" + uo_subs_advar.lastSQLErrText
		is_sugtrail = 'Error produced by uo_subs_advar.setParentTranTypeCode()'
		return -1
	end IF
	
	--VALIDASI setParentTranTypeCode
	
		parentTranTypeCode = as_tranTypeCode
		return TRUE
	
	--END setParentTranTypeCode
	
	if not iuo_currency.setCurrencyCode(iuo_subscriber.currencyCode) then
		is_msgno = 'SM-0000001'
		is_msgtrail = iuo_currency.lastSQLCode + "~r~n" + iuo_currency.lastSQLErrText
		is_sugtrail = 'Error produced by iuo_currency.setCurrencyCode()'
		return -1
	end IF
	
	--VALIDASI SETCURRENCYCODE
		lastMethodAccessed = 'setCurrencyCode'
		
		if isnull(as_currencyCode) or trim(as_currencyCode) = '' then
			lastSQLCode = '-2'
			lastSQLErrText = 'Warning!' + '~r~n~r~n' + &
									'Unable to set currency code, the argument being passed is null.'
			return FALSE
		end if
		
		currencyCode = as_currencyCode
		
		return TRUE	
	--END VALIDASI
		
	if ad_applicationFee > 0 then
		if not uo_subs_advar.insertNewAr(is_tranno, is_transactionID, 'SFEXT', ad_applicationFee, idt_trandate, string(idt_trandate, 'mmm yyyy'), iuo_subscriber.currencyCode, iuo_currency.conversionRate) then
			is_msgno = 'SM-0000001'
			is_msgtrail = uo_subs_advar.lastSQLCode + "~r~n" + uo_subs_advar.lastSQLErrText
			is_sugtrail = 'Error produced by uo_subs_advar.insertNewAr()'
			return -1
		end if
	end IF
	
	--VALIDASI uo_subs_advar INSETNEWAR
		
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

	
	--END VALIDASI INSETNEWAR
	
	if not uo_subs_advar.applyOpenCreditMultiple('', '') then
		is_msgno = 'SM-0000001'
		is_msgtrail = uo_subs_advar.lastSQLCode + "~r~n" + uo_subs_advar.lastSQLErrText
		is_sugtrail = 'Error produced by uo_subs_advar.applyOcToBalances()'
		return -1
	end IF
	
	--VALIDASI APPLYOPENCREDITMULTIPLE
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
			
			if ls_refoctypecode = 'SUBSDEP' or ls_refoctypecode = 'SUBSDEQ' then continue
			if ls_refoctypecode = 'ADVDEP' or ls_refoctypecode = 'SECDEP' then continue  //for leasing -zar 03022010
			
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
				-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				if ls_refoctypecode = 'CM' and (ls_artypecode = 'OCADV' or ls_artypecode = 'OCDEP' or ls_artypecode = 'OCDEQ') then continue
				
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
		
					end if
					
					
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
						
					elseif ls_artypecode = 'SCDEP' and ld_ar_paidamt > 0 then	         // for leasing -zar-03022010
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
						end if
					
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
						end if
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
				--========================================================
				--end
				--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		
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
			

			--now, record the application header...
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
				--========================================================
				--end
				--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				
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
				--=======================================================
				-- 		insert GL Entry: Debit Applicant's Advances
				-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				if not getGLIAccount(ls_refOcTypecode, ls_openCreditAccount) then
					return FALSE
				end if
				if subsCurrencyCode = 'USD' then
					iuo_glPoster.insertGLEntryDebit('SAV-AOCM-DB', '', ls_openCreditAccount, ld_adv_balance_usd)
				else
					iuo_glPoster.insertGLEntryDebit('SAV-AOCM-DB', '', ls_openCreditAccount, ld_adv_balance)
				end IF
				
				--VALIDASI INSERTGLENTRYDEBIT
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
					dw_GLEntries.object.debit[ll_insertRow] 					= ad_amount
					dw_GLEntries.object.credit[ll_insertRow] 					= 0
					dw_GLEntries.object.recordNo[ll_insertRow] 				= ll_insertRow
					dw_GLEntries.object.remarks[ll_insertRow] 				= as_remarks(SET NULL)
					
					return TRUE
					
				--END
				--=======================================================
				-- 			end
				--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				
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
				--========================================================
				--end
				--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				
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
			--========================================================
			--end
			--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			
		next
		
		Return True

	
	--END VALIDASI
	
	if not uo_subs_advar.setOcTranNo() then
		is_msgno = 'SM-0000001'
		is_msgtrail = uo_subs_advar.lastSQLCode + "~r~n" + uo_subs_advar.lastSQLErrText
		is_sugtrail = 'Error produced by uo_subs_advar.setOcTranNo()'
		return -1
	end IF
	
	--VALIDASI SETOCTRANNO
		lastMethodAccessed = 'setOCTranNo'

		if not guo_func.set_number('OPENCR', ocTranNo) then	
			lastSQLCode = '-2'
			lastSQLErrText = 'Could not set the next OC No.'
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
			
			return true
		--END
		
		return TRUE
		
	--END VALIDASI
	
	if not uo_subs_advar.postOpenCreditUpdates() then
		is_msgno = 'SM-0000001'
		is_msgtrail = uo_subs_advar.lastSQLCode + "~r~n" + uo_subs_advar.lastSQLErrText
		is_sugtrail = 'Error produced by uo_subs_advar.postOpenCreditUpdates()'
		return -1
	end IF
	
	--VALIDASI postOpenCreditUpdates
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
							:ls_currencyCode,		--added codes
							:ld_conversionRate,
							:ls_refApplTranTypeCode,
							:ls_refApplTranNo,
							:gs_divisionCode,
							:gs_companyCode)	--for currency
					using SQLCA;
			if SQLCA.sqlcode <> 0 then
				lastSQLCode = string(SQLCA.sqlcode)
				lastSQLErrText = SQLCA.sqlerrtext
				return FALSE
			end if
		
			f_displayStatus('Posting Open Credit Updates...(insertGLEntry)')
		
			
			if subsCurrencyCode = 'USD' then
				ld_balance = ld_balance_usd * ld_conversionRate--conversionRate 8/23/2011-zar
			elseif subsCurrencyCode = 'PHP' then
				ld_balance = ld_balance * ld_conversionRate--conversionRate 8/23/2011-zar
			end if
			
		--==================================================
		--NGLara | 03-17-2008
		--Post GL Entry
		--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		if ls_newrecord = 'Y' then
			iuo_glPoster.insertGLEntryCredit('SAV-POC-CR', '', ls_openCreditAccount, ld_balance, 'increase subscriber advances')
		end if	
		
		--VALIDASI insertGLEntryCredit
		
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
			
			return True

		
		--END VALIDASI
		
		else
			
			--=======================================================
			--Note: the process of debitting the open credit is in
			--  		postApplicationOfOpenCredit
			--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~		
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
		-- ================================
		--  end of insert / update ...
		-- ================================
		
		return TRUE
		
		----END VALIDASI
		
		if not uo_subs_advar.postArUpdates() then
			is_msgno = 'SM-0000001'
			is_msgtrail = uo_subs_advar.lastSQLCode + "~r~n" + uo_subs_advar.lastSQLErrText
			is_sugtrail = 'Error produced by uo_subs_advar.postArUpdates()'
			return -1
		end IF
		
		----VALIDASI uo_subs_advar.postArUpdates
		
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
						end IF
						
						--VALIDASI INSERT INTOARTRANSHDR
						
						datetime ldt_serverDate

							if isNull(adt_trandate) then
								lastSQLCode = '-2'
								lastSQLErrText = 'Invalid transaction date' 
								return FALSE
							end if
							
							ldt_serverDate = adt_trandate
							
							string ls_packagecode
								select packagecode into: ls_packagecode
								from aracctsubscriber
								where acctno = :acctNo
								and divisionCode = :gs_divisionCode
								and companyCode = :gs_companyCode
								using SQLCA;
							
							insert into arTranHdr (
											tranno,   
											tranTypeCode,   
											arTypeCode,
											tranDate,   
											acctNo,
											arTypeCodePriority,   
											amount,
											paidAmt,
											balance,
											remarks,
											divisionCode,
											companyCode,
											packagecode,
											currencycode,
											conversionrate)  
								  values (
											:as_tranno,   
											:as_trantypecode,   
											:as_artypecode, 
											:ldt_serverDate,   
											:acctNo,   
											:ai_priority,   
											:ad_balance,   
											:ad_paidamt,   
											:ad_newbalance,  
											:as_remarks,
											:gs_divisionCode,
											:gs_companyCode,
											:ls_packagecode,
											:subsCurrencyCode,
											:conversionrate)
									using SQLCA;
							if SQLCA.sqlcode < 0 then
								lastSQLCode = string(SQLCA.sqlcode)
								lastSQLErrText = SQLCA.sqlerrtext
								return FALSE
							end if
							
							--=======================================================
							--insert GL Entry: Debit A/R
							--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
							
							string ls_arAccount
							if not f_getArTypeArAccount(as_artypecode, ls_arAccount, lastSQLErrText) then
								return FALSE
							end IF
							
							--ALREADY NOT USE IN  postGLEntries
							iuo_glPoster.insertGLEntryDebit('SAV-IAR-DB', '03-chrg', ls_arAccount, ad_balance)
							
							--=======================================================
							--insert GL Entry: Credit Unearned
							-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
							string ls_unearnedAccount
							if not f_getArTypeUnearnedAccount(as_artypecode, ls_unearnedAccount, lastSQLErrText) then
								return FALSE
							end IF
							
							--ALREADY NOT USE IN  postGLEntries
							iuo_glPoster.insertGLEntryCredit('SAV-IAR-DB', '04-chrg', ls_unearnedAccount, ad_balance)
							
							if ad_paidAmt > 0 then
								
								--ALREADY NOT USE IN  postGLEntries
								iuo_glPoster.insertGLEntryCredit('SAV-IAR-DB', '06-paid', ls_arAccount, ad_paidAmt)
								
								--ALREADY NOT USE IN  postGLEntries
								iuo_glPoster.insertGLEntryDebit('SAV-IAR-DB', '07-paid', ls_unearnedAccount, ad_paidAmt)
								
							end if
							
							return TRUE

						
						--END VALIDASI INSERT INTOARTRANSHDR
						
					else
						--SAME FUCNTION INSERT INTOARTRANSHDR
						if not insertIntoArTranHdr(ls_tranno, ls_trantypecode, ls_artypecode, li_priority, ld_balance, ld_paidamt, ld_newbalance, ls_remarks, ldtm_trandate, ldtm_periodFrom, ldtm_periodTo) then
							return FALSE
						end if
			
					end if	
				else	
					f_displayStatus('Posting AR Updates... (update subsDepositReceivable)')
					if ls_sourceTable = 'RIP' then
						--==================================================
						--update RIP's as processed, so they won't appear 
						--in collection entry again.
						--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
						-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
								ld_paidamt = ld_paidamt * ld_conversionRate--conversionRate 8/23/2011
							elseif subsCurrencyCode = 'PHP' then
								ld_paidamt = ld_paidamt * ld_conversionRate--conversionRate 8/23/2011
							end if
							
							string ls_arAccount
							
							if not f_getArTypeARAccount(ls_artypecode, ls_arAccount, lastSQLErrText) then
								return FALSE
							end IF
							
							--VALIDASI f_getArTypeARAccount
							if isnull(as_arTypeCode) then
									as_errorMsg = 'Null AR Type Code is invalid.'
									return False
								end if
								
								select arAccount
								  into :as_glAccountCode
								  from arTypeMaster
								 where arTypeCode = :as_arTypeCode
								 and divisionCode = :gs_divisionCode
								and companyCode = :gs_companyCode
								using SQLCA;
								if SQLCA.sqlcode = 100 then	// record not found
									as_errorMsg  = 'AR Type Code : [' + as_arTypeCode + '] doest not exist.'
									return False
								elseif SQLCA.sqlcode < 0 then
									as_errorMsg  = SQLCA.sqlerrtext
									return False
								end if
								
								if isnull(as_glAccountCode) or trim(as_glAccountCode) = '' then
									as_errorMsg = 'The AR Account obtained was empty or null. Check the AR Type Code : [' + as_arTypeCode + '] in AR Type Maintenance'
									return False
								end if
								
								Return True

							--END VALIDASI f_getArTypeARAccount
							
							--ALREADY NOT USE IN  postGLEntries
							iuo_glPoster.insertGLEntryCredit('SAV-PARU-CR', '06-paid', ls_arAccount, ld_paidamt, 'decrease AR')
							
							if not f_getArTypeUnearnedAccount(ls_artypecode, ls_unearnedAccount, lastSQLErrText) then
								return FALSE
							end IF
							
							--ALREADY NOT USE IN  postGLEntries
							iuo_glPoster.insertGLEntryDebit('SAV-PARU-CR', '07-paid', ls_unearnedAccount, ld_paidamt, 'decrease UNEARNED')
							
						end if
					end if			 
				end if
			next
			
			
			return TRUE
			
		--END uo_subs_advar.postArUpdates
		
		if not uo_subs_advar.postApplicationOfOpenCredit() then
			is_msgno = 'SM-0000001'
			is_msgtrail = uo_subs_advar.lastSQLCode + "~r~n" + uo_subs_advar.lastSQLErrText
			is_sugtrail = 'Error produced by uo_subs_advar.postApplicationOfOpenCredit()'
			return -1
		end IF
		
		--VALIDASI uo_subs_advar.postApplicationOfOpenCredit
		
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
				end IF
				
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
				--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				if not f_getOCTypeGLAccount(ls_octype, ls_openCreditAccount, lastSQLErrText) then
					return FALSE
				end if
			
				--ALREADY NOT USE postGLEntries
				--zar -08/09/2010 --we do not Debit INCENTIVE because it is not 
				--                  credited during collection
				if trim(ls_octype) <> 'INCENTIV' then
					iuo_glPoster.insertGLEntryDebit('SAV-PAOC-DB', '05-paid', ls_openCreditAccount, ld_appliedamt, 'decrease subscriber advances')
				end if		
					
				-- =======================================================
				-- end
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
			
							--========================================================
							--added codes for currency
							--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
							if subsCurrencyCode = 'USD' then
								ld_payment_usd	= dw_applofoc_dtl.getitemdecimal(ll_dtl_row, "appliedamt")
								ld_payment = ld_payment_usd
							elseif subsCurrencyCode = 'PHP' then
								ld_payment		= dw_applofoc_dtl.getitemdecimal(ll_dtl_row, "appliedamt")
							end if
							--========================================================
							--end
							--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
							
							ls_arremarks		= ""
							ls_currencyCode	= dw_applofoc_dtl.getitemString(ll_dtl_row, "currencycode")		//added codes
							ld_conversionRate	= dw_applofoc_dtl.getitemdecimal(ll_dtl_row, "conversionrate")	//for currency
							ld_forexAmount		= dw_applofoc_dtl.getitemdecimal(ll_dtl_row, "forexamount")		//
							
							--RAY 08/27/2015
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
							
							--touched - 03022010 - for leasing added verification for ADDEP|SCDEP
							if ld_payment > 0 and (ls_artypecode <> 'OCDEP' and &
							                       ls_artypecode <> 'OCDEQ' and &
														  ls_arTypeCode <> 'ADDEP' and &     
														  ls_arTypeCode <> 'SCDEP' ) then	 
								string ls_revenueAccount
								--=======================================================
								--insert GL Entry: Credit Revenue
								--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
								if not f_getArTypeRevAccount(ls_artypecode, ls_revenueAccount, lastSQLErrText) then
									return FALSE
								end if
								
								--ALREADY NOT USE postGLEntries
								--zar 08/09/2010 - If OCTYPE = INCENTIVE - no revenue must be realized
								if trim(ls_octype) <> 'INCENTIV' then
									iuo_glPoster.insertGLEntryCredit('SAV-PAOC-CR', '08-paid', ls_revenueAccount, ld_payment * conversionRate, 'increase revenue')
								end if	
								--=======================================================
								--end
								--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
			
			return True

		
		
		
		--END VALIDASI uo_subs_advar.postApplicationOfOpenCredit
		
		
		
		return 0


--END VALIDASI ue_applyOCBalances


--ALREADY NOT USE postGLEntries
if not iuo_glPoster.postGLEntries() then
	is_msgno 	= 'SM-0000001'
	is_msgtrail =  iuo_glPoster.errorMessage
	is_sugtrail = iuo_glPoster.suggestionRemarks
	return -1
end if


if not isNull(gb_authorizationNo) and gb_authorizationNo <> "" then

	update overridePolicy
	set refTranNo = :is_tranNo
	where tranNo = :gb_authorizationNo
	and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	and requestStatus = 'AP'
	using SQLCA;

end if	

ib_reqStatus = True
guo_func.msgBox("Saving Complete.", "You have successfully saved your entry.")
iw_parent.trigger dynamic event ue_cancel()
idw_ReqInitPayment.reset()

return 0
