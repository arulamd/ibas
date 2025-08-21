opensheetwithparm(w_application_transfer, 'CTV', w_mdiFrame, 0, original!)

--EVENT OPEN FORM

is_serviceType = message.stringParm
is_serviceType = CTV
uo_center_window luo_center_window
luo_center_window = create uo_center_window
luo_center_window.f_center(this)
// ---**** end ***--- //

idw_reqInitPayment = tab_1.tabpage_3.dw_reqinitpayment
idw_reqInitPayment.settransobject(SQLCA) 

tab_1.tabpage_3.dw_napandport.settransobject(SQLCA) 

iuo_subscriber = create uo_subscriber_def

--END EVENT

--QUERY FORM DW_SERVICE_HEADER

SELECT  arAcctSubscriber.tranno ,
	  arAcctAddress.acctNo ,
	  arAcctAddress.servicehomeownership ,
	  arAcctAddress.houseNo ,
	  arAcctAddress.blkNo ,
	  arAcctAddress.lotNo ,
	  arAcctAddress.bldgName ,
	  arAcctAddress.streetName ,
	  arAcctAddress.purokNo ,
	  arAcctAddress.subdivisioncode,
	  arAcctAddress.phaseNo ,
	  arAcctAddress.district ,
	  arAcctAddress.barangaycode ,
	  arAcctAddress.municipalitycode ,
	  arAcctAddress.provincecode ,
	  arAcctAddress.serviceLessorOwnerName ,
	  arAcctAddress.serviceLessorOwnerContactNo ,
	  arAcctAddress.serviceYearsResidency ,
	  arAcctAddress.serviceExpirationDate ,
	  arAcctSubscriber.dateadd,
	  arAcctSubscriber.subscribername,
	  '' completeaddress
  FROM arAcctSubscriber inner join arAcctAddress on arAcctSubscriber.acctNo = arAcctAddress.acctNo and arAcctAddress.addressTypeCode = 'SERVADR1'

--END QUERY FORM DW_SERVICE_HEADER
  
  --QUERY FORM DW_SERVICE_DETAIL
  
   SELECT arAcctSubscriber.acctno,   
         arAcctAddress.servicehomeownership,   
         arAcctAddress.houseNo,   
         arAcctAddress.blkNo,   
         arAcctAddress.lotNo,   
         arAcctAddress.bldgName,   
         arAcctAddress.streetName,   
         arAcctAddress.purokNo,
         arAcctAddress.subdivisioncode,   
			arAcctAddress.phaseNo,
			arAcctAddress.district,
         arAcctAddress.barangaycode,   
         arAcctAddress.municipalitycode,   
         arAcctAddress.provincecode,
			arAcctAddress.serviceLessorOwnerName,
			arAcctAddress.serviceLessorOwnerContactNo,
			arAcctAddress.serviceYearsResidency,
			arAcctAddress.serviceExpirationDate, arAcctAddress.contactName, arAcctAddress.contactNo
    FROM arAcctSubscriber  
    inner join arAcctAddress on arAcctSubscriber.acctNo = arAcctAddress.acctNo 
         and arAcctAddress.addressTypeCode = 'SERVADR1' 

  
  --END QUERY FORM DW_SERVICE_DETAIL
         
 --QUERY FORM DW_BILLING_HEADER
         
   SELECT 0 as sameSubscriberBilling,   
         0 as sameSubscriberAddress,   
         arAcctSubscriber.acctNo,
         vw_arAcctAddress.ContactName,   
         vw_arAcctAddress.HouseNo,   
         vw_arAcctAddress.LotNo,   
         vw_arAcctAddress.BlkNo,   
         vw_arAcctAddress.StreetName,   
         vw_arAcctAddress.PurokNo,   
         vw_arAcctAddress.SubdivisionCode,   
         vw_arAcctAddress.BarangayCode,   
         vw_arAcctAddress.MunicipalityCode,   
         vw_arAcctAddress.ProvinceCode,   
         vw_arAcctAddress.PhaseNo,   
         vw_arAcctAddress.District,   
         vw_arAcctAddress.ContactNo,
         vw_arAcctAddress.BldgName
    FROM arAcctSubscriber  
		inner join vw_arAcctAddress on arAcctSubscriber.acctNo = vw_arAcctAddress.acctNo and vw_arAcctAddress.addressTypeCode = 'BILLING'
         and arAcctSubscriber.divisionCode = vw_arAcctAddress.divisionCode
			and arAcctSubscriber.companyCode = vw_arAcctAddress.companyCode
   WHERE (arAcctSubscriber.acctno = :as_acctno)  
   AND   (arAcctSubscriber.divisionCode = :as_division)  AND (arAcctSubscriber.companyCode = :as_company)  

 --END QUERY DW_BILLING_HEADER  
 
   --QUERY FORM DW_BILLING_DETAIL
   
   SELECT arAcctSubscriber.acctno,   
		vw_arAcctAddress.contactname,   
		vw_arAcctAddress.houseno,   
		vw_arAcctAddress.lotno,   
		vw_arAcctAddress.blkno,   
		vw_arAcctAddress.BldgName,   
		vw_arAcctAddress.streetname,   
		vw_arAcctAddress.purokNo,   
		vw_arAcctAddress.subdivisioncode,   
		vw_arAcctAddress.barangaycode,   
		vw_arAcctAddress.municipalitycode,   
		vw_arAcctAddress.provincecode,
		vw_arAcctAddress.ContactNo,
		vw_arAcctAddress.PhaseNo,
		vw_arAcctAddress.District,
		0 as sameSubscriberBilling, 
		0 as sameSubscriberAddress
 FROM arAcctSubscriber inner join vw_arAcctAddress on arAcctSubscriber.acctNo = vw_arAcctAddress.acctNo and vw_arAcctAddress.addressTypeCode = 'BILLING'
   
   --END QUERY DW_BILLING_DETAIL
 
 --QUERY FORM DW_TRANSFER_INFO
   SELECT arAcctSubscriber.acctno,   
         arAcctSubscriber.substypecode,
         arAcctSubscriber.chargeTypecode,   
         arAcctSubscriber.subsusertypecode,   
         arAcctSubscriber.packagecode,   
         arAcctSubscriber.subscriberstatuscode,   
         space(255) as specialinstructions,   
			0.00 as sameSubscriberBilling, 
			0 as sameSubscriberAddress,
			0.00 as transferFee,
			0.00 as discountAmount,
			0.00 as extendedAmount,
			getdate() as preferedDateTimeFrom,
			getdate() as preferedDateTimeTo,
			0 noOfStb,
			0 noOfExt,
         '' packageName
    FROM arAcctSubscriber   

 --END QUERY 
    
 --QUERY FORM DW_INITIALPAYMENT
   SELECT  subsinitialpayment.acctno ,
   subsinitialpayment.trantypecode ,  
   subsinitialpayment.artypecode ,
   subsinitialpayment.tranno ,  
   subsinitialpayment.trandate , 
   subsinitialpayment.priority , 
   subsinitialpayment.amount
   FROM subsinitialpayment

--END DW_INITIALPAYMENT
   
   
--QUERY dw_napandport
select ''y, ''napcode , '' portno from dual
--END QUERY   

--EVENT UE_SEARCH ACCTNO

long ll_row, ll_count, ll_getRow, ll_napport
string ls_search, ls_result, ls_acctno
string ls_cust_type_requires_approval, ls_acquisition_type_requires_approval
string ls_chargeTypeCode
string ls_barangayName, ls_municipalityName, ls_provinceName, ls_servicesubdivisionName
long ll_noOfExt, ll_noOfStb
decimal{2} ld_firstTransferFee, ld_succeedingTransferFee, ld_transferFee
str_search str_s
string ls_barangayCode, ls_serviceBarangay, ls_municipalityCode
dateTime ldt_today
string ls_subscode

--ll_noOfExtension = 0

ls_search = trim(as_search)
ll_row = idw_serv_hdr.getrow()
--ll_napport = tab_1.tabpage_3.dw_1.getrow()
ldt_today = guo_func.get_server_dateTime()

--VALIDASI GET_SERVER_DATE

datetime ldt_datetime
date		ldt_date
select sysdate into :ldt_datetime 
from systemparameter 
where divisionCode = :gs_divisionCode
and companyCode = :gs_companyCode
using SQLCA;
if SQLCA.sqlcode <> 0 then
	select sysdate into :ldt_datetime from DUAL where rownum < 2 using SQLCA;
	if SQLCA.sqlcode < 0 then
		guo_func.msgbox('Warning!', 'Unable to get server date')
		lastSQLCode	= string(SQLCA.SQLCode)
		lastSQLErrText	= SQLCA.SQLErrText
	end if
end if
ldt_date = date(ldt_datetime)
ldt_datetime = datetime(ldt_date)
return ldt_datetime

--END VALIDASI GET_SERVER_DATE

choose case ls_search
	case "acct_no"
		str_s.serviceType = is_serviceType
		
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

		
		--END QUERY ACCTNO
		
		openwithparm(w_search_subscriber, str_s)
		ls_result = trim(message.stringparm)
		
		select subscriberStatusCode
		into :ls_subscode
		from arAcctSubscriber
		where acctno = :ls_result
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		
		using SQLCA;
		
		select napcode, portno into :is_napcode , :is_portno
		from aracctsubscriber
		where acctno = :ls_result
		and companycode = :gs_companycode
		and divisioncode = :gs_divisioncode
		using SQLCA;
		
		
		if ls_subscode = 'APL' then
				guo_func.MsgBox('Error.. ' ,+&
									 'This Account Status is Applied..  please select another Account and Click OK to continue...')
				return -1				 
			end if	
			
			
		
		if ls_result <> '' then			
			ls_acctNo = ls_result 
			
			select count(acctNo) into :ll_count from applOfTransferTranHdr
			where  acctNo = :ls_acctNo 
			and applicationStatusCode not in ('AC','CN')
			and divisionCode = :gs_divisionCode
			and companyCode = :gs_companyCode
			using  SQLCA;
			if SQLCA.SQLCode < 0 then
				guo_func.MsgBox('SM-0000001','SQL Error Code : ' + 	string(SQLCA.SQLCode) + &
									 '~r~nSQL Error Text ; ' + SQLCA.SQLErrText)
				return -1
			end if	
			
			if ll_count > 0 then
				guo_func.MsgBox('Pending Application Found...', 'This account has a pending Application for [Transfer],'+&
									 ' please verify the transaction on JO Monitoring...')
				return -1				 
			end if	
			
			if not iuo_subscriber.setAcctNo(ls_result ) then
				guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + iuo_subscriber.lastSQLErrText)
			end IF
			
			--VALIDASI IUO_SUBCRIBER.SETACCTNO
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
			
			select barangayname into :ls_barangayName 
			from barangayMaster 
			where barangaycode = :iuo_subscriber.servicebarangaycode
			using SQLCA;
			
			select municipalityname into :ls_municipalityName 
			from municipalityMaster 
			where municipalityCode = :iuo_subscriber.servicemunicipalitycode
			using SQLCA;
			
			select provinceName into :ls_provinceName 
			from provinceMaster 
			where provinceCode = :iuo_subscriber.serviceprovincecode
			using SQLCA;

			select subdivisionName into :ls_servicesubdivisionName
			from subdivisionMaster 
			where subdivisionCode = :iuo_subscriber.servicesubdivisionCode
			using SQLCA;
			
			select napcode, portno into :is_oldnapcode, :is_oldportno
			from arAcctSubscriber
			where acctno = :ls_acctNo
			and divisionCode = :gs_divisionCode
			and companyCode = :gs_companyCode
			using SQLCA;			
			
			--idw_serv_hdr.object.t_address.text = iuo_subscriber.servicehouseno + ' ' + iuo_subscriber.serviceBldgCompApartmentName + ' ' + iuo_subscriber.servicestreetname + ' ' + iuo_subscriber.serviceblockno + ' ' + iuo_subscriber.servicelotno + ' ' + iuo_subscriber.servicepurok + ' ' + ls_servicesubdivisionName + ' ' + iuo_subscriber.servicephase + ' ' + iuo_subscriber.servicedistrict + ' ' + ls_barangayName + ' ' + ls_municipalityName + ' ' + ls_provinceName
			tab_1.tabpage_3.st_account.text = 'Subscriber Name : ' + ls_result + ' - ' + iuo_subscriber.subscriberName
			
			--NAPPORT
			tab_1.tabpage_3.dw_napandport.retrieve() 
			--tab_1.tabpage_3.dw_napandpor.insertRow(0);
			tab_1.tabpage_3.dw_napandport.setItem(1,'napcode', is_oldnapcode)
			tab_1.tabpage_3.dw_napandport.setItem(1,'portno', is_oldportno)
			
			idw_serv_hdr.setitem(ll_row,'acctno', ls_result)	
			idw_serv_hdr.setitem(ll_row,'subscribername', iuo_subscriber.subscribername)	
			idw_serv_hdr.setitem(ll_row,'serviceYearsResidency', iuo_subscriber.serviceYearsResidency)	
			idw_serv_hdr.setitem(ll_row,'servicelessorownername', iuo_subscriber.servicelessorownername)	
			idw_serv_hdr.setitem(ll_row,'serviceexpirationdate', iuo_subscriber.serviceexpirationdate)	
			idw_serv_hdr.setitem(ll_row,'servicelessorownercontactno', iuo_subscriber.servicelessorownercontactno)	
			idw_serv_hdr.setitem(ll_row,'completeaddress', iuo_subscriber.serviceaddresscomplete)	
			idw_bill_hdr.retrieve(ls_result, gs_divisionCode, gs_companyCode)
			idw_bill_dtl.insertRow(0);
			idw_trans_info.insertRow(0);
			idw_trans_info.setitem(ll_row,'packagename', iuo_subscriber.packageName)	
			idw_trans_info.setitem(ll_row,'chargeTypeCode', iuo_subscriber.chargeTypeCode)	
			idw_trans_info.setitem(ll_row,'subsUserTypeCode', iuo_subscriber.subsUserTypeCode)
						
			--idw_serv_dtl.insertRow(0);
			ll_getRow = idw_serv_dtl.getRow()
			idw_serv_dtl.setItem(ll_getRow, 'servicesubdivisioncode', 'N/A')
			idw_serv_dtl.setItem(ll_getRow, 'servicebarangaycode', 'N/A')
			idw_serv_dtl.setItem(ll_getRow, 'servicemunicipalitycode', '000001')
			idw_serv_dtl.setItem(ll_getRow, 'serviceprovincecode', '000001')
			
			iuo_subscriber.packageCode = trim(iuo_subscriber.packageCode)
			
			string ls_subscriberStatus, ls_subscriberType
		
			if not iuo_subscriber.getSubscriberStatusName(ls_subscriberStatus) then
				guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
					iuo_subscriber.lastSQLErrText)
			end if	
			
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
			
			if not iuo_subscriber.getnoofactiveext(ll_noOfExt) then
				guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
					iuo_subscriber.lastSQLErrText)
			end IF
			
			--VALIDASI GETNOOFACTIVEEXT
		
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

		
		--END VALIDASI GETNOOFACTIVEEXT
			
			idw_trans_info.setitem(ll_row,'noofext', ll_noOfExt)	
			
			if not iuo_subscriber.getNoOfSTB(ll_noOfSTB) then
				guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
					iuo_subscriber.lastSQLErrText)
			end IF
			
			--VALIDASI GETNOOFSTB
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

		--END VALIDASI GETNOOFSTB
			
			idw_trans_info.setitem(ll_row,'noofStb', ll_noOfSTB)			
			
			if ll_noOfSTB > 0 then 
				--get first transfer Fee
				if not iuo_subscriber.getTransferFeeForFirstSTB(ld_firstTransferFee) then
					guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &	
					iuo_subscriber.lastSQLErrText)
				end if	
				
				--VALIDASI GETTRANSFERFEEFORFIRSTSTB
				
				lastMethodAccessed = 'getTransferFeeForFirstSTB'

				select firstSTBTransferFee
				  into :ad_transferFee
				  from arPackageMaster
				 where packageCode = :packageCode
				 and divisionCode = :gs_divisionCode
				and companyCode = :gs_companyCode
				using SQLCA;
				if SQLCA.sqlcode < 0 then
					lastSQLCode = string(SQLCA.sqlcode)
					lastSQLErrText = SQLCA.sqlerrtext
					return FALSE
				elseif SQLCA.sqlcode = 100 then
					lastSQLCode = string(SQLCA.sqlcode)
					lastSQLErrText = "The package code: " + packageCode + " does not exist in arPackageMaster table "
					return FALSE
				end if
				return TRUE
				
				--END GETTRANSFERFEEFORFIRSTSTB 
				
				if isnull(ld_firstTransferFee) then ld_firstTransferFee = 0.00
				if ld_firstTransferFee > 0 then
					ld_transferFee = ld_firstTransferFee
				end if
			end if
				
			if ll_noOfExt > 0 then 
				--get succeeding Transfer Fee
				if not iuo_subscriber.getTransferFeeForSucceedingSTB(ld_succeedingTransferFee) then
					guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &	
					iuo_subscriber.lastSQLErrText)
				end IF
				
				--VALIDASI getTransferFeeForSucceedingSTB
				lastMethodAccessed = 'getTransferFeeForSucceedingSTB'

				select succeedingSTBTransferFee
				  into :ad_transferFee
				  from arPackageMaster
				 where packageCode = :packageCode
				 and divisionCode = :gs_divisionCode
				and companyCode = :gs_companyCode
				using SQLCA;
				if SQLCA.sqlcode < 0 then
					lastSQLCode = string(SQLCA.sqlcode)
					lastSQLErrText = SQLCA.sqlerrtext
					return FALSE
				elseif SQLCA.sqlcode = 100 then
					lastSQLCode = string(SQLCA.sqlcode)
					lastSQLErrText = "The package code: " + packageCode + " does not exist in arPackageMaster table "
					return FALSE
				end if
				return TRUE

				--END VALIDASI  getTransferFeeForSucceedingSTB
				if isnull(ld_succeedingTransferFee) then ld_succeedingTransferFee = 0.00
				if ld_succeedingTransferFee > 0 then
					ld_transferFee = ld_transferFee + ( ld_succeedingTransferFee * ll_noOfExt )
				end if
			end if			
			
			--------------------------------------------------------------
			--validate policy on no of months a/r min requirement - start
			--------------------------------------------------------------	
			s_arrears_override_policy.refTranTypeCode = 'APPLYTRANSFR'
			if not f_overrideArrearsPolicyType(iuo_subscriber, s_arrears_override_policy ) then
				trigger event ue_cancel()
				return -1
			end IF
			
			--VALIDASI F_OVERRIDEARREARSPOLICYTYPE
		
		decimal {2} ld_ARBalance

			//------------------------------------------------------------
			// validate policy on no of months a/r min requirement - start
			//------------------------------------------------------------
			
			
			ld_ARBalance = 0.00
			// check if subscriber has a/r balances
			
			if not iuo_subscriber.getARBalance(ld_ARBalance,1) then
				guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
					iuo_subscriber.lastSQLErrText)
			end if
			
			// pop up override policy window for authorization
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
			------------------------------------------------------------			
			--validate policy on no of months a/r min requirement - end
			----------------------------------------------------------
		
		--END VALIDASI F_OVERIDE
			
			------------------------------------------------------------			
 			--validate policy on no of months a/r min requirement - end
			------------------------------------------------------------


			
			--now compute for initial required payment
			uf_prepare_required_initial_payment(ld_transferFee)
			
			--VALIDASI UF_PREPARE_REQUIRED_INITIAL_PAYMENT
			
			--call compute required initial payment
				long ll_rows, ll_success
				string ls_subsTypeCode, ls_packageCode, ls_chargeTypeCode
				
				if isnull(ad_transferFee) then	ad_transferFee = 0.00
					
				ls_subsTypeCode  		= iuo_subscriber.subsTypeCode
				ls_packageCode 		= iuo_subscriber.packageCode
				ls_chargeTypeCode 	= iuo_subscriber.chargeTypeCode
				
				ll_rows = idw_ReqInitPayment.rowCount()
				
				if not isnull(ls_subsTypeCode) then
					if not isnull(ls_packageCode) then
						if not isnull(ls_chargeTypeCode) then	
							if not isnull(ad_transferFee) then	
								if ll_rows > 0 then
									ll_success = uf_compute_req_init_payment_transfer(	&
											ls_subsTypeCode, &
											ls_packageCode, &
											ls_chargeTypeCode, &
											ad_transferFee, &
											idw_ReqInitPayment )
											
									--VALIDASI UF_COMPUTE_REQ_INIT_PAYMENT_TRANSFER
											
											
										decimal{2} ld_amount_TRANSF
										long ll_row
										
										ld_amount_TRANSF = ad_transferFee
										
										--chargeType based fees (discounts)
										decimal{2} ld_percentDiscount, ld_amountDiscount
										ld_percentDiscount = 0.00 
										ld_amountDiscount = 0.00
										
										--TRANSF - Transfer Fees Required Initial Payment
										ld_percentDiscount = 0.00 
										ld_amountDiscount = 0.00
										
										SELECT 	percentDiscount
										INTO 		:ld_percentDiscount
										FROM 		chargeTypeDiscountMaster
										WHERE 	chargeTypeCode = :as_chargeTypeCode and arTypeCode = 'TRANF'
										and divisionCode = :gs_divisionCode
										and companyCode = :gs_companyCode
										USING SQLCA;			
										If SQLCA.SQLcode = -1 then
											messagebox('SM-0000001',"select in chargeTypeMaster SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText)
											return -1
										end if
										
										if isnull(ld_percentDiscount) then ld_percentDiscount = 0.00 
										if ld_percentDiscount > 0.00 then
											ld_amountDiscount = ( ld_amount_TRANSF * (ld_percentDiscount/100) )
											ld_amount_TRANSF = ld_amount_TRANSF - ld_amountDiscount
											if ld_amount_TRANSF < 0.00 then 
												ld_amount_TRANSF = 0.00
											end if
										end if
										
										--update datawindow for required initial payment
										ll_row = adw_ReqInitPayment.find("arTypeCode='TRANF'", 1, adw_ReqInitPayment.rowCount())		
										adw_ReqInitPayment.scrollToRow( ll_row )						
										if ll_row > 0 then
											adw_ReqInitPayment.setItem( ll_row, "amount", ld_amount_TRANSF )
										end if		
										
										adw_ReqInitPayment.acceptText()
										
										return 0


									
									--END VALIDASI UF_COMPUTE
											
								end if
							end if
						end if
					end if
				end if
									
				return 0
			
			--END VALIDASI UF_PREPARE
			
	end if

	case "barangaycode1","barangaycode2"
		str_s.s_dataobject = "dw_search_barangay_master"
		str_s.s_return_column = "barangayCode"
		str_s.s_title = "Search For Barangay"
		
		--QUERY SEARCH BARANGAYCODE1
			SELECT  barangayname ,
	           barangaycode     
	        FROM barangaymaster 
		--END QUERY 
		
		openwithparm(w_search_ancestor,str_s)
		
		ls_result = trim(message.stringparm)
		
		if ls_result <> '' then			
			if ls_search = "barangaycode1" then
				idw_serv_dtl.setitem(ll_row,'servicebarangaycode', ls_result)		
			else
				idw_bill_dtl.setitem(ll_row,'billingbarangaycode', ls_result)			
			end if
		end if

		select municipalityCode
		into :ls_municipalityCode
		from barangayMaster
		where barangayCode = :ls_result
		using SQLCA;
		
		idw_serv_dtl.setitem(ll_row,'servicemunicipalitycode', ls_municipalityCode)

	case "municipalitycode1","municipalitycode2"
		str_s.s_dataobject = "dw_search_municipality_master"
		str_s.s_return_column = "municipalityCode"
		str_s.s_title = "Search For Municipality"
		
		--QUERY SEARCH municipalitycode1
			SELECT  municipalityname ,
           municipalitycode     
        	FROM municipalitymaster    
		--END QUERY 
		
		openwithparm(w_search_ancestor,str_s)
		ls_result = trim(message.stringparm)

		if ls_result <> '' then			
			if ls_search = "municipalitycode1" then
				idw_serv_dtl.setitem(ll_row,'servicemunicipalitycode', ls_result)		
			else
				idw_bill_dtl.setitem(ll_row,'billingmunicipalitycode', ls_result)			
			end if
		end if
		
		ls_barangayCode = idw_serv_dtl.getItemString(idw_serv_dtl.getRow(), 'servicebarangaycode')
		
		select barangayName
		into :ls_serviceBarangay
		from barangayMaster
		where barangayCode = :ls_barangayCode
		using SQLCA;

		if ls_result = '000002' and ls_serviceBarangay = '' then
			idw_serv_dtl.setItem(idw_serv_dtl.getRow(), 'servicebarangaycode', 'N/A2')
		elseif ls_result = '000001' and ls_serviceBarangay = '' then
			idw_serv_dtl.setItem(idw_serv_dtl.getRow(), 'servicebarangaycode', 'N/A')
		end if

	case "provincecode1","provincecode2"
		str_s.s_dataobject = "dw_search_province_master"
		str_s.s_return_column = "provinceCode"
		str_s.s_title = "Search For Province"
		
		--QUERY SEARCH provincecode1
			SELECT  provincename ,
           provincecode     
        FROM provincemaster       
		--END QUERY provincecode1
		
		
		openwithparm(w_search_ancestor,str_s)
		ls_result = trim(message.stringparm)
		
		if ls_result <> '' then			
			if ls_search = "provincecode1" then
				idw_serv_dtl.setitem(ll_row,'serviceprovincecode', ls_result)		
			else
				idw_bill_dtl.setitem(ll_row,'billingprovincecode', ls_result)			
			end if
		end if

	case "subdivisioncode1", "subdivisioncode2"
		str_s.s_dataobject = "dw_subdivisionmaster"
		str_s.s_return_column = "subdivisioncode"
		str_s.s_title = "Search For Subdivision"
		
		--QUERY SEARCH subdivisioncode1
			  SELECT  subdivisionmaster.subdivisionname ,
			  subdivisionmaster.subdivisioncode 
			  FROM subdivisionmaster      
		--END QUERY provincecode1
		
		openwithparm(w_search_ancestor,str_s)
		ls_result = trim(message.stringparm)
		
		if ls_result <> '' then			
			if ls_search = "subdivisioncode1" then
				idw_serv_dtl.setitem(ll_row,'servicesubdivisioncode', ls_result)		
			else
				idw_bill_dtl.setitem(ll_row,'billingsubdivisioncode', ls_result)			
			end if	
		end if

end choose

return 0

--END EVENT UE_SEARCH

--BUTTON NEW

string ls_AcctNo
long ll_row, ll_priority	
decimal{2} ld_amount, ld_transferfeesadvances, ld_totalrequiredinitialpayment
--insert rows to required initial payment
--insert TRANSF - Advance Payment for Extended Service Fees
select priority
into :ll_priority
from arTypeMaster
where arTypeCode = 'TRANF'
and divisionCode = :gs_divisionCode
and companyCode = :gs_companyCode
using SQLCA;
if SQLCA.SQLCode <> 0 then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = 'AR type code [TRANF] does not exist in master file.'
	guo_func.msgbox(is_msgNo, is_msgTrail)
	return -1	
end if	

ll_row = idw_ReqInitPayment.insertRow(0)
idw_ReqInitPayment.scrollToRow( ll_row )
idw_ReqInitPayment.setItem(ll_row, "arTypeCode", 'TRANF')
idw_ReqInitPayment.setItem(ll_row, "amount", 0.00)
idw_ReqInitPayment.setItem(ll_row, "priority", ll_priority)

idw_ReqInitPayment.acceptText()

string ls_tranNo
long ll_tranNo
datetime ldt_dateadd

ldt_dateadd	= guo_func.get_server_date()

this.tab_1.tabpage_1.dw_service_header.setTransObject(SQLCA);
this.tab_1.tabpage_1.dw_service_detail.setTransObject(SQLCA);
this.tab_1.tabpage_2.dw_billing_header.setTransObject(SQLCA);
this.tab_1.tabpage_2.dw_billing_detail.setTransObject(SQLCA);
this.tab_1.tabpage_3.dw_transfer_info.setTransObject(SQLCA);

idw_serv_hdr 			= this.tab_1.tabpage_1.dw_service_header
idw_serv_dtl 			= this.tab_1.tabpage_1.dw_service_detail
idw_bill_hdr 			= this.tab_1.tabpage_2.dw_billing_header
idw_bill_dtl 			= this.tab_1.tabpage_2.dw_billing_detail
idw_trans_info 		= this.tab_1.tabpage_3.dw_transfer_info
idw_serv_hdr.insertRow(0);

if not guo_func.get_nextnumber('APPLYTRANSFR', ll_tranNo, "") then
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
			
			return true
	--END guo_func.get_nextnumber

ls_tranNo = string(ll_tranNo, '00000000')
idw_serv_hdr.setitem(idw_serv_hdr.getrow(), 'tranNo', ls_tranNo) 
idw_serv_hdr.setitem(idw_serv_hdr.getrow(), 'dateadd', ldt_dateadd)


--END BUTTON NEW


--BUTTON SAVE

string ls_packageCode
long ll_tranNo, ll_napporttrail
datetime ldt_tranDate
idw_trans_info.accepttext()

-- service Address
string ls_servicehomeownership, ls_servicehouseno, ls_serviceblockno, ls_servicelotno, ls_serviceBldgCompApartmentName, ls_servicestreetname, ls_newnapcode, ls_newportno
string ls_servicepurok, ls_servicesubdivisionCode,   ls_servicePhase,ls_serviceDistrict, ls_servicebarangaycode   
string ls_servicemunicipalitycode, ls_serviceprovincecode, ls_serviceLessorOwnerName, ls_serviceLessorOwnerContactNo
string ls_acctno, ls_servicePostno, ls_servicecontactName, ls_servicecontactNo
datetime ldt_serviceExpirationDate
long ll_serviceYearsResidency 
int ll_serviceNode

-- billing Address
string ls_billingcontactname, ls_billingcontactno
string ls_billinglotno, ls_billingblockno, ls_billingBldgCompApartmentName, ls_billingstreetname, ls_billingpurok, ls_billinghouseno
string ls_billingsubdivisionCode,ls_billingSubdivisionName,  ls_billingbarangaycode, ls_billingmunicipalitycode, ls_billingprovincecode
string ls_billingPhase, ls_billingDistrict
string ls_oldInstallationAddress	
string ls_oldInstallationTelNo 
string ls_OldBillingAddress, ls_billingTelNo

--APPLYTRANSFR Info
string ls_specialinstructions
datetime ldt_prefereddatetimefrom, ldt_prefereddatetimeTo
decimal{2} ld_transferFee, ld_discountamount	, ld_extAmt


is_transactionID = 'APPLYTRANSFR'

if not guo_func.get_nextNumber(is_transactionID, ll_tranNo, "WITH LOCK") then			
	return -1
end if	

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

if not guo_func.get_nextNumber('NAPPORTTRAIL', ll_napporttrail, "WITH LOCK") then			
	return -1
end if	

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

is_tranNo = string (ll_tranNo, '00000000')
is_napporttrailtranno = string (ll_napporttrail, '00000000')
ldt_tranDate	= guo_func.get_server_datetime()

--VALIDASI GET-SERVER_DATETIME

datetime ldt_datetime
select sysdate into :ldt_datetime 
from systemparameter 
where divisionCode = :gs_divisionCode
and companyCode = :gs_companyCode
using SQLCA;
if SQLCA.sqlcode <> 0 then
	select sysdate into :ldt_datetime from systemparameter where rownum < 2 using SQLCA;
	if SQLCA.sqlcode < 0 then
		guo_func.msgbox('Warning!', 'Unable to get server date')
		lastSQLCode	= string(SQLCA.SQLCode)
		lastSQLErrText	= SQLCA.SQLErrText
	end if
end if

return ldt_datetime


--END VALIASI GET_SERVER_DATETIME

--NOT USER ANYMORE
--==================================================
--NGLara | 03-31-2008
--Prepare GL Poster
if not iuo_glPoster.initialize(is_transactionID, is_tranNo, ldt_tranDate) then
	is_msgno 	= 'SM-0000001'
	is_msgtrail = iuo_glPoster.errorMessage
	is_sugtrail = iuo_glPoster.suggestionRemarks
	return -1
end if
uo_subs_advar.setGLPoster(iuo_glPoster)


//-- records from SERVICE address
ls_acctno											= trim(idw_serv_hdr.getitemString(idw_serv_dtl.getrow(), 'acctno'))  
ls_servicecontactname							= trim(idw_serv_dtl.getitemString(idw_serv_dtl.getrow(), 'servicecontactname'))  
ls_servicecontactno								= trim(idw_serv_dtl.getitemString(idw_serv_dtl.getrow(), 'servicecontactno'))

ls_servicehomeownership							= trim(idw_serv_dtl.getitemString(idw_serv_dtl.getrow(), 'servicehomeownership'))  
ls_servicehouseno									= trim(idw_serv_dtl.getitemString(idw_serv_dtl.getrow(), 'servicehouseno'))
ls_serviceblockno									= trim(idw_serv_dtl.getitemString(idw_serv_dtl.getrow(), 'serviceblockno')) 
ls_servicelotno									= trim(idw_serv_dtl.getitemString(idw_serv_dtl.getrow(), 'servicelotno'))  
ls_serviceBldgCompApartmentName				= trim(idw_serv_dtl.getitemString(idw_serv_dtl.getrow(), 'serviceBldgCompApartmentName'))  
ls_servicestreetname								= trim(idw_serv_dtl.getitemString(idw_serv_dtl.getrow(), 'servicestreetname')) 
ls_servicepurok									= trim(idw_serv_dtl.getitemString(idw_serv_dtl.getrow(), 'servicepurok'))
ls_servicePhase									= trim(idw_serv_dtl.getitemString(idw_serv_dtl.getrow(), 'servicePhase'))
ls_serviceDistrict								= trim(idw_serv_dtl.getitemString(idw_serv_dtl.getrow(), 'serviceDistrict'))
ls_serviceLessorOwnerName						= trim(idw_serv_dtl.getitemString(idw_serv_dtl.getrow(), 'serviceLessorOwnerName'))
ls_serviceLessorOwnerContactNo				= trim(idw_serv_dtl.getitemString(idw_serv_dtl.getrow(), 'serviceLessorOwnerContactNo'))
ll_serviceYearsResidency						= idw_serv_dtl.getitemNumber(idw_serv_dtl.getrow(), 'serviceYearsResidency')
ls_servicesubdivisionCode						= trim(idw_serv_dtl.getitemString(idw_serv_dtl.getrow(), 'servicesubdivisionCode'))
ls_servicebarangaycode 							= trim(idw_serv_dtl.getitemString(idw_serv_dtl.getrow(), 'servicebarangaycode'))
ls_servicemunicipalitycode						= trim(idw_serv_dtl.getitemString(idw_serv_dtl.getrow(), 'servicemunicipalitycode'))
ls_serviceprovincecode							= trim(idw_serv_dtl.getitemString(idw_serv_dtl.getrow(), 'serviceprovincecode'))
ls_servicePostno									= ' '
ll_serviceNode										= 0
ldt_serviceExpirationDate						= idw_serv_dtl.getitemDatetime(idw_serv_dtl.getrow(), 'serviceExpirationDate')

//--records from BILLING address
ls_billingcontactname							= trim(idw_bill_dtl.getitemString(idw_bill_dtl.getrow(), 'billingcontactname'))  
ls_billingcontactno								= trim(idw_bill_dtl.getitemString(idw_bill_dtl.getrow(), 'billingcontactno'))

ls_billinghouseno									= trim(idw_bill_dtl.getitemString(idw_bill_dtl.getrow(),'billinghouseno'))
ls_billinglotno									= trim(idw_bill_dtl.getitemString(idw_bill_dtl.getrow(),'billinglotno'))
ls_billingblockno									= trim(idw_bill_dtl.getitemString(idw_bill_dtl.getrow(),'billingblockno'))
ls_billingBldgCompApartmentName				= trim(idw_bill_dtl.getitemString(idw_bill_dtl.getrow(),'billingBldgCompApartmentName'))
ls_billingstreetname								= trim(idw_bill_dtl.getitemString(idw_bill_dtl.getrow(),'billingstreetname'))
ls_billingpurok									= trim(idw_bill_dtl.getitemString(idw_bill_dtl.getrow(),'billingpurok'))
ls_billingsubdivisionCode						= trim(idw_bill_dtl.getitemString(idw_bill_dtl.getrow(),'billingsubdivisionCode'))
ls_billingbarangaycode							= trim(idw_bill_dtl.getitemString(idw_bill_dtl.getrow(),'billingbarangaycode'))
ls_billingmunicipalitycode						= trim(idw_bill_dtl.getitemString(idw_bill_dtl.getrow(),'billingmunicipalitycode'))
ls_billingprovincecode							= trim(idw_bill_dtl.getitemString(idw_bill_dtl.getrow(),'billingprovincecode'))
ls_billingPhase									= trim(idw_bill_dtl.getitemString(idw_bill_dtl.getrow(),'billingPhase'))
ls_billingDistrict								= trim(idw_bill_dtl.getitemString(idw_bill_dtl.getrow(),'billingDistrict'))
ls_billingtelno									= trim(idw_bill_dtl.getitemString(idw_bill_dtl.getrow(),'billingContactNo'))

ls_oldInstallationAddress	=	trim(idw_serv_hdr.getitemstring(1,'completeaddress')) 

//-- APPLYTRANSFR Info

ldt_prefereddatetimefrom						= idw_trans_info.getItemDateTime(idw_trans_info.getrow(), 'prefereddatetimefrom')
ldt_prefereddatetimeto							= idw_trans_info.getItemDateTime(idw_trans_info.getrow(), 'prefereddatetimeto')
ls_specialinstructions							= trim(idw_trans_info.getitemString(idw_trans_info.getrow(), 'specialinstructions'))
ld_transferFee										= idw_reqInitPayment.getitemDecimal(idw_trans_info.getrow(), 'cf_total_transferfee')
ld_discountamount						 			= 0
ld_extAmt											= ld_transferFee

--NAPCODE AND PORTNO
ls_newnapcode 									= tab_1.tabpage_3.dw_napandport.getItemString(1,'napcode')
ls_newportno										= tab_1.tabpage_3.dw_napandport.getItemString(1,'portno')

if isnull(ldt_prefereddatetimefrom) then
	guo_func.msgbox('Invalid!','Please specify preferred date time (FROM)...')
	return -1
end if

if isnull(ldt_prefereddatetimeto) then
	guo_func.msgbox('Invalid!','Please specify preferred date time (TO)... ')
	return -1
end if


uo_subscriber luo_subscriber
if not luo_subscriber.setAcctNo(ls_acctNo) then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = luo_subscriber.lastSQLCode + '~r~n' + luo_subscriber.lastSQLErrText
	return -1
end if

select packagecode 
into :ls_packageCode 
from arAcctSubscriber 
where acctno = :ls_acctno 
and divisionCode = :gs_divisionCode
and companyCode = :gs_companyCode
using SQLCA;

if SQLCA.SQLCode = -1 then
	guo_func.msgbox('SM-0000001', "Error ing ue_save_service_tab"+"SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText)
	return -1	
elseif  SQLCA.SQLCode = 100 then
	guo_func.msgbox('SM-0000001', "No Record FOUND"+"SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText)
	return -1	
end if

select telNo 
into :ls_oldInstallationTelNo 
from arAcctSubscriber 
where acctno = :ls_acctno 
and divisionCode = :gs_divisionCode
and companyCode = :gs_companyCode
using SQLCA;

if SQLCA.SQLCode = -1 then
	guo_func.msgbox('SM-0000001', "Error in select arAcctSubscriber"+"SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText)
	return -1	
end if

select subdivisionname 
into :ls_billingSubdivisionName 
from subdivisionMaster 
where subdivisionCode = :ls_billingSubdivisionCode 
using SQLCA;

if SQLCA.SQLCode = -1 then
	guo_func.msgbox('SM-0000001', "Error in select subdivisionmaster"+"SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText)
	return -1	
end if

ls_OldBillingAddress = luo_subscriber.billingAddressComplete


--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~SERVICE ADDRESS~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if isNull(ls_serviceHouseNo) then
	guo_func.msgbox('SM-0000001', 'Unable to continue, the Service House No field is empty.')
	return -1	
end if

if isNull(ls_serviceBldgCompApartmentName) then
	guo_func.msgbox('SM-0000001', 'Unable to continue, the Service Apartment/Compound/Building is empty.')
	return -1	
end if

if isNull(ls_serviceStreetName) then
	guo_func.msgbox('SM-0000001', 'Unable to continue, the Service Street Name field is empty.')
	return -1	
end if

if isNull(ls_serviceBlockNo) then
	guo_func.msgbox('SM-0000001', 'Unable to continue, the Service Block No field is empty.')
	return -1	
end if

if isNull(ls_serviceLotNo) then
	guo_func.msgbox('SM-0000001', 'Unable to continue, the Service Lot No field is empty.')
	return -1	
end if

if isNull(ls_servicePurok) then
	guo_func.msgbox('SM-0000001', 'Unable to continue, the Service Purok field is empty.')
	return -1	
end if

if isNull(ls_serviceSubdivisionCode) then
	guo_func.msgbox('SM-0000001', 'Unable to continue, the Service Subdivision field is empty.')
	return -1	
end if

if isNull(ls_servicePhase) then
	guo_func.msgbox('SM-0000001', 'Unable to continue, the Service Phase field is empty.')
	return -1	
end if

if isNull(ls_serviceDistrict) then
	guo_func.msgbox('SM-0000001', 'Unable to continue, the Service District field is empty.')
	return -1	
end if

if isNull(ls_serviceBarangayCode) then
	guo_func.msgbox('SM-0000001', 'Unable to continue, the Service Barangay field is empty.')
	return -1	
end if

if isNull(ls_serviceMunicipalityCode) then
	guo_func.msgbox('SM-0000001', 'Unable to continue, the Service Municipality field is empty.')
	return -1	
end if

if isNull(ls_serviceProvinceCode) then
	guo_func.msgbox('SM-0000001', 'Unable to continue, the Service Provice field is empty.')
	return -1	
end if

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~BILLING ADDRESS~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if isNull(ls_billingHouseNo) then
	guo_func.msgbox('SM-0000001', 'Unable to continue, the Billing House No field is empty.')
	return -1	
end if

if isNull(ls_billingBldgCompApartmentName) then
	guo_func.msgbox('SM-0000001', 'Unable to continue, the Billing Apartment/Compound/Building is empty.')
	return -1	
end if

if isNull(ls_billingStreetName) then
	guo_func.msgbox('SM-0000001', 'Unable to continue, the Billing Street field is empty.')
	return -1	
end if

if isNull(ls_billingBlockNo) then
	guo_func.msgbox('SM-0000001', 'Unable to continue, the Billing Block No field is empty.')
	return -1	
end if

if isNull(ls_billingLotNo) then
	guo_func.msgbox('SM-0000001', 'Unable to continue, the Billing Lot No field is empty.')
	return -1	
end if

if isNull(ls_billingPurok) then
	guo_func.msgbox('SM-0000001', 'Unable to continue, the Billing Purok field is empty.')
	return -1	
end if

if isNull(ls_billingSubdivisionCode) then
	guo_func.msgbox('SM-0000001', 'Unable to continue, the Billing Subdivision field is empty.')
	return -1	
end if

if isNull(ls_billingPhase) then
	guo_func.msgbox('SM-0000001', 'Unable to continue, the Billing Phase field is empty.')
	return -1	
end if

if isNull(ls_billingDistrict) then
	guo_func.msgbox('SM-0000001', 'Unable to continue, the Billing District field is empty.')
	return -1	
end if

if isNull(ls_billingBarangayCode) then
	guo_func.msgbox('SM-0000001', 'Unable to continue, the Billing Barangay field is empty.')
	return -1	
end if

if isNull(ls_billingMunicipalityCode) then
	guo_func.msgbox('SM-0000001', 'Unable to continue, the Billing Municipality field is empty.')
	return -1	
end if

if isNull(ls_billingProvinceCode) then
	guo_func.msgbox('SM-0000001', 'Unable to continue, the Billing Provice field is empty.')
	return -1	
end if

insert into	applOfTransferTranHdr
		(tranno,   
		 tranDate,                                               
		 acctNo, 
		 packageCode, 
		 oldInstallationAddress,                                                                                                                                                                                   
		 oldInstallationTelNo,                               
		 oldBillingAddress,                                                                                                                                                                                        
		 oldBillingTelNo,                                    
		 serviceHomeOwnerShip, 
		 serviceLessorOwnerName,                                                                               
		 serviceLessorOwnerContactNo,                        
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
		 serviceNode, 
		 servicePostNo, 
		 serviceYearsResidency,
	    serviceExpirationDate,
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
		 preferredDatetimeFrom,
		 preferredDatetimeTo,
		 specialInstructions,
		 noOfExtension,
		 transferFee,
		 discountAmount,
		 extendedAmount,
		 referenceJONo,
		 applicationStatusCode,
		 useradd,
		 dateadd,
		 serviceContactName,
		 serviceContactNo,
		 billingContactName,
		 billingContactNo,
		 divisionCode,
		 companyCode,
		 napcode,
		 portNo)
values
		(:is_tranNo,
		 :ldt_tranDate,
		 :ls_acctNo,
		 :ls_packageCode,
		 :ls_oldInstallationAddress,	
		 :ls_oldInstallationTelNo,
		 :ls_oldBillingAddress,
		 :ls_billingTelNo,
		 :ls_servicehomeownership,
		 :ls_serviceLessorOwnerName,
		 :ls_serviceLessorOwnerContactNo,
		 :ls_servicehouseno,
		 :ls_servicestreetname,
		 :ls_serviceBldgCompApartmentName,
		 :ls_servicelotno,
		 :ls_serviceblockno,
		 :ls_servicePhase,
		 :ls_serviceDistrict,
		 :ls_servicepurok,
		 :ls_servicesubdivisionCode,
		 :ls_servicebarangaycode,
		 :ls_servicemunicipalitycode,
		 :ls_serviceprovincecode,
		 :ll_serviceNode,
		 :ls_servicePostno,
		 :ll_serviceYearsResidency,
		 :ldt_serviceExpirationDate,
		 :ls_billinghouseno,
		 :ls_billingstreetname,
		 :ls_billingBldgCompApartmentName,
		 :ls_billinglotno,
		 :ls_billingblockno,
		 :ls_billingPhase,
		 :ls_billingDistrict,
		 :ls_billingpurok,
		 :ls_billingsubdivisionCode,
		 :ls_billingbarangaycode,
		 :ls_billingmunicipalitycode,
		 :ls_billingprovincecode, 
		 :ldt_prefereddatetimefrom,
		 :ldt_prefereddatetimeTo,
		 :ls_specialInstructions,
		 :ll_noOfExtension,
 		 :ld_transferFee,
		 :ld_discountamount, 
		 :ld_extAmt,
		 null,
		 'FJ',
		 :gs_username,
		 :ldt_tranDate,
		 :ls_serviceContactName,
		 :ls_serviceContactNo,
		 :ls_billingContactName,
		 :ls_billingContactNo,
		 :gs_divisionCode,
		 :gs_companyCode,
		 :is_napcode,
		 :is_portno)
using SQLCA;	
if SQLCA.SQLCode <> 0 then
	guo_func.msgbox('SM-0000001', "Insert in TRANSFERTranHdr"+"SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText)
	return -1	
end if		


if isnull(ls_newnapcode) or ls_newnapcode = '' then
	
	
else
	

	
	insert into NAPPORTAUDITRAIL
			(tranno,
			 acctno,
			 oldnapcode,
			 oldportno,
			 newnapcode,
			 newportno,
			 useradd,
			 dateadd,
			 divisioncode,
			 companycode)
	values
			(:is_napporttrailtranno,
			 :ls_acctNo,
			 :is_oldnapcode,
			 :is_oldportno, 
			 :ls_newnapcode,
			 :ls_newportno,
			 :gs_username,
			 :ldt_tranDate,
			 :gs_divisionCode,
			 :gs_companyCode)
	using SQLCA;	
	if SQLCA.SQLCode <> 0 then
		guo_func.msgbox('SM-0000001', "Insert in NAPPORTAUDITRAIL"+"SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText)
		return -1	
	end if				 
	
	update arAcctSubscriber
	set napcode = :ls_newnapcode, oldnapcode = :is_oldnapcode
		 portno = :ls_newportno, oldportno = :is_oldportno
	where acctno = :ls_acctNo
	and  divisioncode = :gs_divisionCode
	and companycode = :gs_companyCode
	using SQLCA;

end if 	

--create records on subsInitialPayment
if trigger event ue_save_subsInitialPayment(ls_acctno, is_tranno) = -1 then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = "Saving subsInitialPayment ~nSQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
	return -1
end IF

--VALIDASI ue_save_subsInitialPayment

long ll_priority, ll_row,  ll_rows, ll_loop
string ls_acctno, ls_arTypeCode, ls_currency
datetime ldt_tranDate
dec{2} ld_amount, ld_rate

ls_acctno = trim(as_acctno)

ldt_tranDate	= guo_func.get_server_datetime()

ll_rows = idw_ReqInitPayment.rowCount()

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
					 :is_tranNo,
					 :ldt_tranDate,
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

--end validasi uo_subs_advar.setAcctNo

if	This.Event ue_applyOCBalances(ld_transferFee) <> 0 then
	return -1	
end IF

--VALIDASI ue_applyOCBalances

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
		
--END VALIDASI SETCURRENCYCODE
		
if ad_applicationFee > 0 then
	
	if not uo_subs_advar.insertNewAr(is_tranno, is_transactionID, 'TRANF', ad_applicationFee, idt_trandate, 'Initial Payment Requirement', &
											   iuo_subscriber.currencyCode, iuo_currency.conversionRate) then
		is_msgno = 'SM-0000001'
		is_msgtrail = uo_subs_advar.lastSQLCode + "~r~n" + uo_subs_advar.lastSQLErrText
		is_sugtrail = 'Error produced by uo_subs_advar.insertNewAr()'
		return -1
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
		
end if

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
	
--END VALIDASI setOcTranNo

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
		
----END VALIDASI postOpenCreditUpdates

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
					
					--VALIDASI F_GETARTYPEUNEARNEDACCOUNT
					
					--==================================================
					--NGLara | 04-26-2008
					--This function is primarily being used by Billing
					--computation...
					--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
					
					if isnull(as_arTypeCode) then
						as_errorMsg = 'Null AR Type Code is invalid.'
						return FALSE  
					end if  
					   
					select unEarnedRevAccount
					  into :as_glAccountCode
					  from arTypeMaster
					 where arTypeCode = :as_arTypeCode
					 and divisionCode = :gs_divisionCode
					and companyCode = :gs_companyCode
					using SQLCA;
					if SQLCA.sqlcode = 100 then	// record not found
						as_errorMsg  = 'AR Type Code : [' + as_arTypeCode + '] doest not exist.'
						return FALSE
					elseif SQLCA.sqlcode < 0 then
						as_errorMsg  = SQLCA.sqlerrtext
						return FALSE
					end if
					
					if isnull(as_glAccountCode) or trim(as_glAccountCode) = '' then
						as_errorMsg = 'The AR Account obtained was empty or null. Check the AR Type Code : [' + as_arTypeCode + '] in AR Type Maintenance'
						return FALSE
					end if
					
					Return True

					
					--END VALIDASI F_GETARTYPEUNEARNERDACCOUNT
					
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
						end IF
						
						-VALIDASI F_GETARTYPEREVACCOUNT
								
						if isnull(as_arTypeCode) then
							as_errorMsg = 'Null AR Type Code is invalid.'
							return False
						end if
						
						select revenueAccount
						  into :as_glAccountCode
						  from arTypeMaster
						 where arTypeCode = :as_arTypeCode
						 and divisionCode = :gs_divisionCode
						and companyCode = :gs_companyCode
						using SQLCA;
						if SQLCA.sqlcode = 100 then
							as_errorMsg = 'AR Type Code : [' + as_arTypeCode + '] doest not exist.'
							return False
						elseif SQLCA.sqlcode < 0 then
							as_errorMsg = string(SQLCA.sqlcode) + '~r~n' + SQLCA.sqlerrtext
							return False
						end if
						
						if isnull(as_glAccountCode) or trim(as_glAccountCode) = '' then
							as_errorMsg = 'The Revenue Account obtained was empty or null. Check the AR Type Code : [' + as_arTypeCode + '] in AR Type Maintenance'
							return False
						end if
						
						Return TRUE
						
						--END VALIDASI F_GETARTYPEREVACCOUNT
						
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
			
			return true
		
		--END VALIDASI SET_NUMBER
	end if
	
	return True




--END VALIDASI uo_subs_advar.postApplicationOfOpenCredit


return 0

--END VALIDASI UE_APPLYOCBALANCE


--NOT USE ANYMORE
if not iuo_glPoster.postGLEntries() then
	is_msgno 	= 'SM-0000001'
	is_msgtrail =  iuo_glPoster.errorMessage
	is_sugtrail = iuo_glPoster.suggestionRemarks
	return -1
end if

if	not guo_func.set_number(is_transactionID, ll_tranNo) then
	return -1	
end if

if	not guo_func.set_number('NAPPORTTRAIL', ll_napporttrail) then
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

return true

--END VALIDASI SET_NUMBER

return 0
--END BUTTON SAVE