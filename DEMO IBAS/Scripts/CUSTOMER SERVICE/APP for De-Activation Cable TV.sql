if gs_divisioncode = 'DAINT' or gs_divisioncode = 'DACTV' or gs_divisioncode = 'ACINT' then
	opensheetwithparm(w_application_mlineext_deactivation_datelcom, 'CTV', w_mdiFrame, 0, original!)
else 
	opensheetwithparm(w_application_mlineext_deactivation, 'CTV', w_mdiFrame, 0, original!)
end IF

-- VALIDASI IF  gs_divisioncode = 'DAINT' or gs_divisioncode = 'DACTV' or gs_divisioncode = 'ACINT'


--EVENT OPEN FORM 
is_serviceType = message.stringParm

is_serviceType = 'CTV'
idw_application_for_ext_dtl = dw_detail
idw_reqInitPayment = dw_reqinitpayment
iw_parent = this

dw_header.settransobject(SQLCA)
idw_reqInitPayment.settransobject(SQLCA) 

iuo_subscriber = create uo_subscriber_def

--QUERY FORM DW_HEADER
SELECT  	applOfDeactivationTranHdr.tranno,
		  	applOfDeactivationTranHdr.trandate,
		  	applOfDeactivationTranHdr.acctno,
		  	applOfDeactivationTranHdr.locationCode,
		  	applOfDeactivationTranHdr.chargeTypeCode,
		  	applOfDeactivationTranHdr.subsUserTypeCode,
		  	applOfDeactivationTranHdr.packageCode,
		  	applOfDeactivationTranHdr.subscriberStatusCode,
		  	applOfDeactivationTranHdr.subsTypeCode,
		  	applOfDeactivationTranHdr.numberOfRooms,
		  	applOfDeactivationTranHdr.occupancyRate,
		  	applOfDeactivationTranHdr.noOfExtension,
		  	applOfDeactivationTranHdr.noOfSTBDeActivated,
		  	applOfDeactivationTranHdr.noOfSTBPulledOut,
		  	applOfDeactivationTranHdr.disconnectionType,
		  	applOfDeactivationTranHdr.mlinecurrentDailyRate,
		  	applOfDeactivationTranHdr.baseAmount,
		  	applOfDeactivationTranHdr.daysConsumption,
		  	applOfDeactivationTranHdr.mlinecurrentMonthlyRate,
		  	applOfDeactivationTranHdr.amount,
		  	applOfDeactivationTranHdr.mLineExtDeAcFee,
		  	applOfDeactivationTranHdr.mLineExtDeAcFeeDiscount,
		  	applOfDeactivationTranHdr.extendedFeeAmount,
		  	applOfDeactivationTranHdr.processed,
		  	applOfDeactivationTranHdr.reason,
		   applOfDeactivationTranHdr.disconnectionRemarksCode,
		  	applOfDeactivationTranHdr.activationIntendedDate,
		  	applOfDeactivationTranHdr.referenceJONo,
		  	applOfDeactivationTranHdr.specialInstructions,
		  	applOfDeactivationTranHdr.preferreddatetimefrom,
		  	applOfDeactivationTranHdr.preferreddatetimeto,
		  	applOfDeactivationTranHdr.requestedBy,
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
		  	0 noOfSTB,
			getdate() graceperioddate,
		  	applOfDeactivationTranHdr.useradd ,
		  	applOfDeactivationTranHdr.dateadd
FROM 		applOfDeactivationTranHdr    

--END QUERY DW_HEADER

--QUERY FORM DW_DETAIL

  SELECT  deactivationTranDtl.tranno ,           
deactivationTranDtl.itemcode ,           
deactivationTranDtl.boxidno ,           
deactivationTranDtl.serialno ,           
deactivationTranDtl.acquisitiontypecode     
FROM deactivationTranDtl    

--END QUERY DW_DETAIL

--QUERY FORM dw_subscriber_stb

SELECT  subscriberCPEMaster.serialno ,
		  subscriberCPEMaster.boxidno ,
		  subscriberCPEMaster.acquisitionTypeCode , caSerialNo, packagecode,caItemCode,
		  '' scanned, isPrimary    
	FROM subscriberCPEMaster      
  WHERE (subscriberCPEMaster.cpeTypeCode = 'STB') and (subscriberCPEMaster.acctno = :as_acctno )   

--END QUERY dw_subscriber_stb
  
--BUTTON NEW
  
  string ls_AcctNo
long ll_row, ll_priority	
decimal{2} ld_amount, ld_stbdeposit, ld_materialsstbadvances, ld_installationfeesadvances, ld_totalrequiredinitialpayment

--reset datawinw so no duplicates will happen
dw_detail.reset()
dw_subscriber_stb.reset()
idw_ReqInitPayment.reset()

--insert EXTF - Advance Payment for Installation Fees
select priority 
into :ll_priority	
from arTypeMaster 	
where arTypeCode = 'DEACF' 	
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
idw_ReqInitPayment.setItem( ll_row, "arTypeCode", 'DEACF' )
idw_ReqInitPayment.setItem( ll_row, "amount", 0.00 )
idw_ReqInitPayment.setItem( ll_row, "priority", ll_priority )

idw_ReqInitPayment.acceptText()

long ll_currentRow, ll_acctno, ll_applExt
string ls_acctno, ls_applExt
datetime ldt_date, ldt_today 

dw_header.reset()
dw_header.insertRow(0)

dw_detail.reset()
dw_subscriber_stb.reset()
idw_ReqInitPayment.reset()


if not guo_func.get_nextnumber('APPLYDEAC', ll_applExt, "") then
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

return TRUE

--END VALIDASI GET_NEXTNUMBER

ls_applExt = string(ll_applExt, '00000000')
ll_currentRow = dw_header.getRow()

ldt_date = Datetime(today(),now())
ldt_today = guo_func.get_server_datetime()

--Set default Values
dw_header.setitem(1 , "tranNo", ls_applExt) 
dw_header.setitem(1 , "tranDate", guo_func.get_server_date()) 
dw_header.setitem(1,  "dateadd", ldt_date) 

dw_header.setItem( 1, "preferreddatetimefrom", ldt_today)
dw_header.setItem( 1, "preferreddatetimeto", ldt_today)

pb_new.enabled = false
pb_close.enabled = false

pb_save.enabled = true
pb_cancel.enabled = true

--END BUTTON NEW  

--EVENT BUTTON SEARCH ACCTNO

long ll_row, ll_success, ll_count
string ls_search, ls_result, ls_acctNo
string lastSQLCode, lastSQLErrText
string ls_subscriberName, ls_serviceAddress, ls_billingAddress
string ls_package, ls_generalPackage
string ls_subscriberStatus, ls_chargeType
string ls_subscriberType, ls_subscriberUserType
decimal{2} ld_occupancyRate, ld_monthlyMlineFee, ld_monthlyExtFee
long ll_noOfExt, ll_noOfSTB

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
		
		--query search for ACCTNO
		
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
		
		--end query
		
		openwithparm(w_search_subscriber,str_s)

		ls_result = trim(Message.StringParm)				
		if ls_result = '' or isNull(ls_result) then			
			return	
		end if
		dw_header.setitem(ll_row,'acctno', ls_result)	
		ls_acctNo = trim(ls_result)

		select count(acctNo) into :ll_count 
		  from applOfDeactivationTranHdr
		 where acctNo = :ls_acctNo and applicationStatusCode not in ('AC', 'CN')
		 and divisionCode = :gs_divisionCode
		 and companyCode = :gs_companyCode
		using SQLCA;
		if SQLCA.SQLCode < 0 then
			guo_func.MsgBox('SM-0000001','SQL Error Code : ' + 	string(SQLCA.SQLCode) + &
							    '~r~nSQL Error Text ; ' + SQLCA.SQLErrText)
			return					 
		end if	
		
		select subscriberStatusCode
		into :ls_subscode
		from arAcctSubscriber
		where acctno = :ls_result
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		
		using SQLCA;
		
		if ls_subscode = 'APL' then
				guo_func.MsgBox('Error.. ' ,+&
									 'This Account Status is Applied..  please select another Account and Click OK to continue...')
				return 				 
		end if	
		
		if ll_count > 0 then
			guo_func.MsgBox('Pending Application Found...', 'This account has a pending Application for [Mainline/Extension Disconnection],'+&
								 ' please verify the transaction on JO Monitoring...')
			return					 
		end if	

		if not iuo_subscriber.setAcctNo(ls_acctNo) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + iuo_subscriber.lastSQLErrText)
			return
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
		
		dw_header.setItem( 1, "subscriberName", iuo_subscriber.subscribername )
		
		is_isDigital = iuo_subscriber.isDigital
		if is_isDigital = 'Y' then
			dw_subscriber_stb.dataObject = 'dw_subscriber_deac_digital'
			dw_detail.dataObject 			= 'dw_subscriber_unit_disc_dtl'
			
			--QUERY dw_subscriber_stb IF is_isDigital = 'Y'
			
			SELECT  subscriberCPEMaster.serialno ,
				  subscriberCPEMaster.boxidno ,
				  subscriberCPEMaster.acquisitionTypeCode , caSerialNo, packagecode,caItemCode,
				  '' scanned, isPrimary    
			FROM subscriberCPEMaster      
		  WHERE (subscriberCPEMaster.cpeTypeCode = 'STB') and (subscriberCPEMaster.acctno = :as_acctno )   
		  
			--END QUERY 
		  
		  --QUERY dw_detail IF is_isDigital = 'Y'
		  
		    SELECT  ''tranno ,           
			itemcode ,           
			caSerialNo , caItemCode, subscriberCPEMaster.packageCode, packageName,          
			serialno , acquisitionTypeCode, boxIDNo
			FROM subscriberCPEMaster   
			inner join arPackageMaster on  subscriberCPEMaster.packageCode = arPackageMaster.packageCode
				and subscriberCPEMaster.divisionCode = arPackageMaster.divisionCode
				and subscriberCPEMaster.companyCode = arPackageMaster.companyCode
			where acctNo = :as_acctNo
			and subscriberCPEMaster.divisionCode = :as_division
			and subscriberCPEMaster.companyCode = :as_company
			and isPrimary <> 'Y'
			
		  --END QUERY is_isDigital = 'Y'
		else
			dw_subscriber_stb.dataObject = 'dw_subscriber_ext_disc_stb'
			dw_detail.dataObject 			= 'dw_subscriber_ext_disc_dtl'
			
			--QUERY dw_subscriber_stb IF is_isDigital <> 'Y'
			SELECT  subscriberCPEMaster.serialno ,
			           subscriberCPEMaster.boxidno ,
						  subscriberCPEMaster.acquisitionTypeCode ,		
			           '' scanned    
			        FROM subscriberCPEMaster      
			        WHERE (subscriberCPEMaster.cpeTypeCode = 'STB') 
				and ( subscriberCPEMaster.acctno = :as_acctno ) 
			--END QUERY
				
			--QUERY dw_detail IF is_isDigital <> 'Y'
				 SELECT  deactivationTranDtl.tranno ,           
				deactivationTranDtl.itemcode ,           
				deactivationTranDtl.boxidno ,           
				deactivationTranDtl.serialno ,           
				'' acquisitionTypeCode    
				FROM deactivationTranDtl   
			--END QUERY	
			
		end IF
		
		dw_subscriber_stb.setTransObject(SQLCA);
		
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
		
		--general package 
		if not iuo_subscriber.getGeneralPackageName(ls_generalPackage) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return
		end IF
		
		--validasi getGeneralPackageName
		
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
		
		--end validasi getGeneralPackageName
		
		dw_header.setItem( 1, "generalPackage", ls_generalPackage )		
		
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
		
		--end validasi
		
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
		
		--occupancy Rate
		ld_occupancyRate = iuo_subscriber.occupancyRate
		dw_header.setItem( 1, "occupancyRate", ld_occupancyRate )							
		
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
		
		dw_header.setItem( 1, "monthlyMlineFee", ld_monthlyMlineFee )							
		
		--monthly Ext Fee
		if not iuo_subscriber.getExtMonthlyRate(ld_monthlyExtFee) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return
		end IF
		
		--VALIDASI getExtMonthlyRate
		
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
				 --where arPackageMaster.packageCode <> :packageCode --zar 12/08/2009 12am
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

		--END VALIDASI getExtMonthlyRate
			
		dw_header.setItem( 1, "monthlyExtFee", ld_monthlyExtFee )							
		
		--long ll_noOfExt
		if not iuo_subscriber.getnoofactiveext(ll_noOfExt) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return
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
				
			end if
			return TRUE

		
		--END VALIDASI GETNOOFACTIVEEEXT
			
		dw_header.setItem( 1, "noOfExt", ll_noOfExt )									
		
		--ll_noOfSTB
		if not iuo_subscriber.getNoOfSTB(ll_noOfSTB) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return
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
		
		dw_header.setItem( 1, "noOfSTB", ll_noOfSTB )											
		il_noOfSTB = ll_noOfSTB
		
		dw_header.acceptText()
		
		--id_mLineExtDeAcFee
		if not iuo_subscriber.getMLineExtDeacFee(id_mLineExtDeAcFee) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return
		end IF
		
		--VALIDASI GETMLINEEXTDEACFEE
		lastMethodAccessed = 'getMLineExtDeacFee'

		select deactivationFee
		  into :ad_mLineExtDeAcFee
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

		--END VALIDASI
		
		dw_header.setitem(1,'extendedfeeamount',id_mLineExtDeAcFee)
		
		--populate registere STB serial nos.
		--step 1 check if populated already then delete all
		ll_row = dw_subscriber_stb.getRow()
		if isnull(ll_row) then ll_row = 0
		if ll_row>0 then
			dw_subscriber_stb.reset()			
		end if
		
		--step 2 now populate
		string	ls_serialNo, ls_boxIdNo, ls_caSerialNo, ls_packageCode, ls_isPrimary, ls_caItemCode		
			
		declare cur_subscriber_stbs cursor for
			select serialNo, boxIdNo, caSerialNo, packageCode, isPrimary, caItemCode
			from subscriberCPEMaster
			where acctNo = :ls_acctNo
			and divisionCode = :gs_divisionCode
			and companyCode = :gs_companyCode
			and cpeTypeCode = 'STB'
		using SQLCA;
			
		open cur_subscriber_stbs;
		if SQLCA.sqlcode <> 0 then
			guo_func.msgbox("Warning!", string(SQLCA.SQLCode) + "~r~n" + &
				SQLCA.SQLErrText)
			return
		end if
		
		fetch cur_subscriber_stbs 
			into :ls_serialNo, :ls_boxIdNo, :ls_caSerialNo, :ls_packageCode, :ls_isPrimary, :ls_caItemCode;

		long ll_curRow
		do while SQLCA.sqlcode = 0
			--insert to stb list
			ll_curRow = dw_subscriber_stb.insertRow(0)
			dw_subscriber_stb.setItem( ll_curRow, "serialNo", ls_serialNo )
			if is_isDigital <> 'Y' then
				dw_subscriber_stb.setItem( ll_curRow, "boxidno", ls_boxIdNo )
			else
				dw_subscriber_stb.setItem( ll_curRow, "caserialNo", ls_caserialNo )
				dw_subscriber_stb.setItem( ll_curRow, "packageCode", ls_packageCode )
				dw_subscriber_stb.setItem( ll_curRow, "isPrimary", ls_isPrimary )
				dw_subscriber_stb.setItem( ll_curRow, "caItemCode", ls_caItemCode )
			end if
			--insert to stb for scanning
			ll_curRow = dw_detail.insertRow(0)
			
			fetch cur_subscriber_stbs into :ls_serialNo, :ls_boxIdNo,:ls_caSerialNo, :ls_packageCode, :ls_isPrimary, :ls_caItemCode;
		loop
		
		close cur_subscriber_stbs;
		--messagebox("",ls_subscriberStatus)
		if ls_subscriberStatus <> 'Active' then
			guo_func.msgbox("Warning!", "Subscriber must be on ACTIVE STATUS.")	
			triggerevent("ue_new")
			return
		end if
		
		--PREPARE REQUIRED INITIAL PAYMENT
		uf_prepare_required_initial_payment()
		
		--VALIDASI UF_PREPARE_REQUIRED_INITIAL_PAYMENT
		
			--call compute required initial payment
			long ll_rows, ll_success
			string ls_subsTypeCode, ls_packageCode, ls_chargeTypeCode, ls_acquisitionTypeCode
			
			ls_subsTypeCode  = iuo_subscriber.subsTypeCode
			ls_packageCode = iuo_subscriber.packageCode
			ls_chargeTypeCode = iuo_subscriber.chargeTypeCode
			
			ll_rows = idw_ReqInitPayment.rowCount()
			
			if not isnull(ls_subsTypeCode) then
				if not isnull(ls_packageCode) then
					if not isnull(ls_chargeTypeCode) then	
							if ll_rows > 0 then
								ll_success = uf_compute_req_init_pay_mlineext_deacwjo(	&
									   ls_chargeTypeCode, &
										id_mLineExtDeAcFee, &		
										idw_ReqInitPayment )
										
								--VALIDASI UF_COMPUTE_REQ_INIKT_PAY_MLINEEXT_DEACWJO
										
										--acquisitionTypeCode based fees
									long ll_row
									decimal{2} ld_amount_DEACF, ld_percentDiscount,ld_amountDiscount
									
									ld_amount_DEACF = 0.00
									
									ld_amount_DEACF = ad_mLineExtDeAcFee
									
									--DEACF - Deactivation Fee Required Initial Payment
									ld_percentDiscount = 0.00 
									ld_amountDiscount = 0.00
									
									SELECT 	percentDiscount
									INTO 		:ld_percentDiscount
									FROM 		chargeTypeDiscountMaster
									WHERE 	chargeTypeCode = :as_chargeTypeCode and arTypeCode = 'DEACF'
									and divisionCode = :gs_divisionCode
									and companyCode = :gs_companyCode
									USING SQLCA;			
									If SQLCA.SQLcode = -1 then
										messagebox('SM-0000001',"select in chargeTypeMaster SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText)
										return -1
									end if
									
									if isnull(ld_percentDiscount) then ld_percentDiscount = 0.00 
									if ld_percentDiscount > 0.00 then
										ld_amountDiscount = ( ld_amount_DEACF * (ld_percentDiscount/100) )
										ld_amount_DEACF = ld_amount_DEACF - ld_amountDiscount
										if ld_amount_DEACF < 0.00 then 
											ld_amount_DEACF = 0.00
										end if
									end if
									
									
									--update datawindow for required initial payment
									
									ll_row = adw_ReqInitPayment.find("arTypeCode='DEACF'",1,adw_ReqInitPayment.rowCount())		
									adw_ReqInitPayment.scrollToRow( ll_row )						
									if ll_row > 0 then
										adw_ReqInitPayment.setItem( ll_row, "amount", ld_amount_DEACF )
									end if		
									
									adw_ReqInitPayment.acceptText()
									
									return 0
								--END VALIDASI UF_COMPUTE_REQ		
							end if
						end if
				end if
			end if
								
			return 0
			
		--END VALIDASI

		dw_header.setColumn("locationCode")

		dw_subscriber_stb.acceptText()
		dw_subscriber_stb.scrolltorow(1)

		dw_detail.acceptText()
		dw_detail.scrolltorow(1)
		
		--------------------------------------------------------------
		--validate policy on no of months a/r min requirement - start
		--------------------------------------------------------------		
		s_arrears_override_policy.refTranTypeCode = 'APPLYDEAC'
		
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
	
		------------------------------------------------------------			
		--validate policy on no of months a/r min requirement - end
		------------------------------------------------------------
		
				
end choose
return 

--END EVENT BUTTON SEARCH ACCTNO

--EVENT ITEMCHANGE DW_HEADER

long ll_row, ll_success, ll_noOfSTB
string ls_search, ls_result, ls_acctNo, lastSQLCode, lastSQLErrText

string ls_subscriberName, ls_serviceAddress, ls_billingAddress
string ls_package, ls_generalPackage
string ls_subscriberStatus, ls_chargeType
string ls_subscriberType, ls_subscriberUserType
decimal{2} ld_occupancyRate, ld_monthlyMlineFee, ld_monthlyExtFee
long ll_noOfExt

if dwo.name = 'activationintendeddate' then


	date ldt_activationintendeddate, ldt_getserverdatetime
	
	ldt_activationintendeddate = date(left(data,10))
	
	ldt_getserverdatetime = date(this.GetItemDateTime(row, 'preferredDateTimeFrom')) //date(guo_func.get_server_date())

	--==================================================
	--this portion obtains the Minimum/Maximum Allowable 
	--Temporary De-Activation Period
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
	string	ls_errormsg
	integer 	li_mindays, li_maxdays
	if not f_getNoOfDaysMINATDAP(li_mindays, ls_errormsg) then
		guo_func.msgbox("Warning!", ls_errormsg)
		post dynamic event ue_set_column("activationintendeddate")
		dw_header.setFocus()
		return 2
	end IF
	
	--VALIDASI F_GETNOOFDAYSMINATDAP
	
	string last_sqlcode, last_sqlerrtext
	
	select noOfDays
	  into :ai_noOfDays
	  from sysDaysParam
	 where dayParamName = 'MINATMPDEACP'
	 and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	using SQLCA;
	if SQLCA.sqlcode < 0 then
		as_errormsg = 'SQL Code: ' + string(SQLCA.sqlCode) + '~r~n' + SQLCA.sqlErrText
		return FALSE
	elseif SQLCA.sqlcode = 100 then
		as_errormsg = 'SQL Code: ' + string(SQLCA.sqlCode) + '~r~n' + 'The code [MINATMPDEACP] does not exist!'
		return FALSE
	end if
	return TRUE
		
	--END VALIDASI F_GETNOOFDAYSMINATDAP
	
	if not f_getNoOfDaysMAXATDAP(li_maxdays, ls_errormsg) then
		guo_func.msgbox("Warning!", ls_errormsg)
		post dynamic event ue_set_column("activationintendeddate")
		dw_header.setFocus()
		return 2
	end IF
	
	--VALIDASI F_GETNOOFDAYSMAXTDAP
	
	string last_sqlcode, last_sqlerrtext
	select noOfDays
	  into :ai_noOfDays
	  from sysDaysParam
	 where dayParamName = 'MAXATMPDEACP'
	 and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	using SQLCA;
	if SQLCA.sqlcode < 0 then
		as_errormsg = 'SQL Code: ' + string(SQLCA.sqlCode) + '~r~n' + SQLCA.sqlErrText
		return FALSE
	elseif SQLCA.sqlcode = 100 then
		as_errormsg = 'SQL Code: ' + string(SQLCA.sqlCode) + '~r~n' + 'The code [MAXATMPDEACP] does not exist!'
		return FALSE
	end if
	return TRUE
	
	--END VALIDASI F_GETNOOFDAYSMAXTDAP
	
	
	if  ( ldt_activationintendeddate >= relativeDate(date(ldt_getserverdatetime), li_mindays) and ldt_activationintendeddate <= relativeDate(date(ldt_getserverdatetime), li_maxdays) ) then
		
		post dynamic event ue_set_column("requestedBy")
		dw_header.setFocus()
	else
		guo_func.msgbox("Invalid Deactivation Period!!!", &
							"The allowable intended reactivation dates are between :" + &										
							string( relativeDate(date(ldt_getserverdatetime), li_mindays), "mm/dd/yyyy")+ "  and  " + &
							string( relativeDate(date(ldt_getserverdatetime), li_maxdays), "mm/dd/yyyy"), &
							gc_Information, &
							gc_OKOnly, &
							"The minimum no. of days for deactivation is "+string(li_mindays)+"days while maximum is "+string(li_maxdays) +"days.")
		
		post dynamic event ue_set_column("activationintendeddate")
		dw_header.setFocus()
		return 2
	end if
	
	dw_header.setColumn("locationCode")

elseif dwo.name = 'preferreddatetimefrom' then
	
		date ld_currentDate, ld_preferdtfrom
		ld_preferdtfrom = date(left(data,10))
		ld_currentDate = date(guo_func.get_server_date())
		
		if ld_currentDate > ld_preferdtfrom then
			guo_func.msgbox('Date Invalid!', 'Please check your date...')
			post dynamic event ue_set_column("preferreddatetimefrom")
			dw_header.setFocus()
			return 2
		end if
		
elseif dwo.name = 'preferreddatetimeto' then

		date ld_preferdtto
		ld_preferdtto = date(left(data,10))
		ld_currentDate = date(guo_func.get_server_date())
		
		if ld_currentDate > ld_preferdtto then
			guo_func.msgbox('Date Invalid!', 'Please check your date...')
			post dynamic event ue_set_column("preferreddatetimeto")
			dw_header.setFocus()
			return 2
		end if
	
elseif dwo.name = 'requestedBy' then	
	dw_detail.setFocus()
end IF

--END EVENT ITEMCHANGE DW_HEADER

--EVENT ITEMCHANGE DW_DETAIL

string ls_serialNo, ls_caSerialNo, ls_itemCode, ls_caItemCode, ls_packageCode
long ll_row, ll_boxIdNo
boolean as_hasstb
ll_boxIdNo = 0
uo_stb xuo_stb
xuo_stb = create using "uo_stb"

ls_serialNo = trim(data)

if dwo.name = 'serialno' then
	if dynamic trigger event ue_validate_serialno(ls_serialNo) = -1 then
		guo_func.msgbox("Duplicate of serial no.","You have entered serial no.{ "+ls_serialNo+" } already!")
		return 2
	end IF
	
	--VALIDASI ue_validate_serialno
		long ll_ret

		ll_ret = this.Find("serialno = '"+as_serialno+"'",1,this.rowcount()) 
		
		if ll_ret > 0 then
			return -1
		end if

		return 0
		
	--END VALIDASI ue_validate_serialno
	
	--hasstbserialno	
	if not iuo_Subscriber.hasSTBSerialNo(ls_serialNo, 'Y', as_hasstb) then
		guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + iuo_subscriber.lastSQLErrText)
	end IF
	
	--VALIDASI HAS_STB_SERIAL_NO
	
	lastMethodAccessed = 'hasSTBSerialNo'

		string ls_serialNo, ls_allSTB
		long ll_noofSTB
		ls_serialNo = trim(as_serialno)
		
		if as_allSTB = 'Y' then
			ls_allSTB = 'Y'
		else
			ls_allSTB = 'N'
		end if
		
		if isDigital <> 'Y' then
			select count(acctNo)
			  into :ll_noofSTB
			  from subscriberCPEMaster
			 where acctNo = :acctNo and acctNo is not null 
				and divisionCode = :gs_divisionCode
			and companyCode = :gs_companyCode
			and rtrim(ltrim(serialNo)) = ltrim(rtrim(:as_serialNo))
			 group by acctNo 
			 using SQLCA;
			if SQLCA.sqlcode <> 0 then
				lastSQLCode = string(SQLCA.sqlcode)
				lastSQLErrText = SQLCA.sqlerrtext
				return FALSE
			end if
		else
			select count(acctNo)
			  into :ll_noofSTB
			  from subscriberCPEMaster
			 where acctNo = :acctNo and acctNo is not null and ( isPrimary in (:ls_allSTB) or :as_allSTB = 'Y')
				and divisionCode = :gs_divisionCode
			and companyCode = :gs_companyCode
			and rtrim(ltrim(serialNo)) = ltrim(rtrim(:as_serialNo))
			 group by acctNo 
			 using SQLCA;
			if SQLCA.sqlcode <> 0 then
				lastSQLCode = string(SQLCA.sqlcode)
				lastSQLErrText = SQLCA.sqlerrtext
				return FALSE
			end if
		end if
		
		if isnull(ll_noofSTB) then ll_noofSTB = 0
		if ll_noofSTB > 0 then
			ab_hasSTB = TRUE
		else
			ab_hasSTB = FALSE
		end if
		
		return true
	
	--END VALIDASI HAS _STB_SRIAL_NO
	
	if as_hasstb then
		
		SELECT boxIdNo, caSerialNo, caItemCode, itemCode, packageCode
		INTO   :ll_boxIdNo,  :ls_caSerialNo, :ls_caItemCode, :ls_itemCode, :ls_packageCode
		from   subscriberCPEMaster
		where  serialno =:ls_serialNo
		and    divisionCode = :gs_divisionCode
		and    companyCode = :gs_companyCode 
		using sqlca;
		if sqlca.sqlcode <> 0 then
			guo_func.msgbox("Error in SQL",sqlca.sqlerrtext)
			return 2
		end if
		
		ll_row = dw_subscriber_stb.find("serialNo='"+ls_serialNo+"'",1,dw_subscriber_stb.rowCount())		
		dw_subscriber_stb.scrollToRow( ll_row )	
	
		if ll_row > 0 then
			dw_subscriber_stb.setItem( ll_row, "scanned", 'Y' )
			this.setitem(row,'boxidno', ll_boxidno)
			if  is_isDigital = 'Y' then
				dw_detail.setItem( row, "caserialno", ls_caSerialNo )
				dw_detail.setItem( row, "caItemCode", ls_caItemCode )
				dw_detail.setItem( row, "itemCode", ls_itemCode )
				dw_detail.setItem( row, "packageCode", ls_packageCode )
			end if
		end if	
		
		if not xuo_stb.setSerialNo(ls_serialNo) then
			guo_func.msgbox("Warning!", xuo_stb.lastSQLCode + "~r~n" + xuo_stb.lastSQLErrText)		
		end IF
		
		--VALIDASI XUO_STB.SETSRIALNO
		
		serialNo = trim(as_serialno)

			--check if existing
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
					
		--END VALIDASI XUO_STB.SETSRIALNO
		
		dw_subscriber_stb.acceptText()
		dw_subscriber_stb.scrollToRow( ll_row )		
		
	else
		guo_func.msgBox("No. of Extension(s) Validation Error", "Serial No. not Assigned to this Subscriber" )
		return 2
	end if
end if
--END EVENT ITEMCHANGE DW_DETAIL

--BUTTON SAVE

long ll_acctno, ll_tranNo, ll_noOfStbRows, ll_row, ll_noOfStbRowsScanned,  ll_stbVariance
string ls_acctno
datetime ldt_preferdtfrom, ldt_preferdtto
date	ld_preferdtfrom, ld_preferdtto
decimal{2} ld_deacFee

dw_header.accepttext()
dw_subscriber_stb.accepttext()
dw_detail.accepttext()

--idt_tranDate	= guo_func.get_server_datetime()
idt_tranDate	= dw_header.getItemDateTime(1, 'trandate')
ldt_preferdtfrom = dw_header.getItemDateTime(1, 'preferreddatetimefrom')
ldt_preferdtto = dw_header.getItemDateTime(1, 'preferreddatetimeto')
ld_preferdtfrom = date(ldt_preferdtfrom)
ld_preferdtto = date(ldt_preferdtto)

ll_noOfStbRows = dw_subscriber_stb.rowCount()

for ll_row = 1 to ll_noOfStbRows
	dw_subscriber_stb.scrollToRow(ll_row)	
	if dw_subscriber_stb.getItemString( ll_row, "scanned") = 'Y' then
		ll_noOfStbRowsScanned = ll_noOfStbRowsScanned + 1	
	end if	
next 

If messagebox('Confirmation', "You wish to save new application for ML/Ext Deactivation?", Question!, OKCancel! ) <> 1 Then
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

return true

--END VALIDASI

if	not guo_func.set_number(is_transactionID, ll_tranNo) then
	return -1	
end IF

--validasi set_number
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

	--end validasi set_number

is_tranno = string(ll_tranno, '00000000')
ls_acctno = trim( dw_header.getItemString( 1, 'acctno' ) )


--NOT USER ANY MORE
--==================================================
--NGLara | 03-31-2008
--Prepare GL Poster
if not iuo_glPoster.initialize(is_transactionID, is_tranNo, idt_tranDate) then
	is_msgno 	= 'SM-0000001'
	is_msgtrail = iuo_glPoster.errorMessage
	is_sugtrail = iuo_glPoster.suggestionRemarks
	return -1
end IF

uo_subs_advar.setGLPoster(iuo_glPoster)


if isnull(ld_preferdtfrom) or isnull(ld_preferdtto) then
	is_msgNo		= 'SM-0000001'
	is_msgTrail = 'Please input Preferred Date/Time From and Preferred Date/Time To...'
	return -1
end if

if trigger event ue_save_deacmlineexttranhdranddtl(ls_acctno, is_transactionID) = -1 then
   return -1
end IF

--VALIDASI UE_SAVE_DEACMLINEEXTTRANHDRANDDTL

string 		ls_scanned, ls_surrendered, ls_serialNo, ls_caSerialNo, ls_itemCode, ls_caItemCode 
string 		ls_acctNo, ls_userAdd, ls_trantypecode, ls_acquiredBefore2003
string 		ls_reason, ls_requestedBy, ls_packageCode, ls_locationCode, ls_disconnectionRemarksCode
string 		ls_chargeTypeCode, ls_subsUserTypeCode, ls_subscriberStatusCode, ls_subsTypeCode
long 		ll_numberOfRooms
decimal{2} ld_occupancyRate, ld_totExtAmt
datetime 	ldt_activationIntendedDate
datetime 	ldt_dateadd, ldtme_graceperioddatefrom, ldtme_graceperioddateto, ldtme_startOfAutoPermDiscDate
string 		ls_specialinstructions, ls_referenceJONo
datetime 	ldt_preferreddatetimefrom, ldt_preferreddatetimeto						
decimal{2} ld_extendedfeeamount, ld_DiscountRateMLMSF, ld_DiscountRateEXMSF, ld_MLineExtDeAcFeeDiscount
long 		ll_row, ll_stbRows, ll_stbRow, ll_stbNotBuy
long 		ll_noOfExtension, ll_noOfSTBDeActivated, ll_noOfSTBPulledOut


ls_trantypecode = trim(as_trantypecode)
ll_row = dw_header.getrow()

idw_application_for_ext_dtl.acceptText() 

--get subscriber information
--idt_tranDate 						= guo_func.get_server_datetime()
idt_tranDate 						= dw_header.getItemDateTime( ll_row, "trandate" )
if isnull(idt_tranDate) then
	guo_func.msgbox('Warning!','Please enter transaction date. Thank you.')
	return -1
end if
ls_acctNo 							= trim(as_acctno)
ls_locationCode					= trim(dw_header.getItemString( ll_row, "locationCode") )	
ls_reason							= trim(dw_header.getItemString( ll_row, "reason" ) )	
ls_disconnectionRemarksCode		= trim(dw_header.getItemString( ll_row, "disconnectionRemarksCode" ) )	
ls_requestedBy					= trim(dw_header.getItemString( ll_row, "requestedBy" ) )	
ldt_activationIntendedDate		= dw_header.getItemDateTime( ll_row, "activationIntendedDate" )
ld_extendedfeeamount			= dw_header.getItemDecimal( ll_row, "extendedfeeamount" )
ll_noOfExtension					= dw_header.getItemDecimal( ll_row, "noofext" )
ls_specialinstructions				= trim(dw_header.getItemString(ll_row, "specialInstructions"))	
ldt_preferreddatetimefrom		= dw_header.getItemDateTime( ll_row, "preferreddatetimefrom")
ldt_preferreddatetimeto			= dw_header.getItemDateTime( ll_row, "preferreddatetimeto")
ls_packageCode 					= iuo_subscriber.packageCode
ld_MLineExtDeAcFeeDiscount 		= dw_header.getItemDecimal( ll_row, "mlineextdeacfeediscount" )

--get the stb info from scanned stbs
ll_noOfSTBDeActivated		= dw_header.getItemDecimal( ll_row, "noofstb" )
--EDITED
ll_noOfSTBPulledOut			= dw_subscriber_stb.getItemDecimal( 1, "compute_2" ) (--count(serialNo for all))

--==================================================
--this portion obtains the Minimum/Maximum Allowable 
--Temporary De-Activation Period
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
string	ls_errormsg
integer 	li_mindays, li_maxdays, li_MAXRGPFRIRD
if not f_getNoOfDaysMINATDAP(li_mindays, ls_errormsg) then
	guo_func.msgbox("Warning!", ls_errormsg)
	post dynamic event ue_set_column("activationintendeddate")
	dw_header.setFocus()
	return -1
end IF

--VALIDASI F_GETNOOFDAYSMINATDAP
	
	string last_sqlcode, last_sqlerrtext
	
	select noOfDays
	  into :ai_noOfDays
	  from sysDaysParam
	 where dayParamName = 'MINATMPDEACP'
	 and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	using SQLCA;
	if SQLCA.sqlcode < 0 then
		as_errormsg = 'SQL Code: ' + string(SQLCA.sqlCode) + '~r~n' + SQLCA.sqlErrText
		return FALSE
	elseif SQLCA.sqlcode = 100 then
		as_errormsg = 'SQL Code: ' + string(SQLCA.sqlCode) + '~r~n' + 'The code [MINATMPDEACP] does not exist!'
		return FALSE
	end if
	return TRUE
		
	--END VALIDASI F_GETNOOFDAYSMINATDAP
	
	if not f_getNoOfDaysMAXATDAP(li_maxdays, ls_errormsg) then
		guo_func.msgbox("Warning!", ls_errormsg)
		post dynamic event ue_set_column("activationintendeddate")
		dw_header.setFocus()
		return 2
	end IF
	
--VALIDASI F_GETNOOFDAYSMAXTDAP
	
	string last_sqlcode, last_sqlerrtext
	select noOfDays
	  into :ai_noOfDays
	  from sysDaysParam
	 where dayParamName = 'MAXATMPDEACP'
	 and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	using SQLCA;
	if SQLCA.sqlcode < 0 then
		as_errormsg = 'SQL Code: ' + string(SQLCA.sqlCode) + '~r~n' + SQLCA.sqlErrText
		return FALSE
	elseif SQLCA.sqlcode = 100 then
		as_errormsg = 'SQL Code: ' + string(SQLCA.sqlCode) + '~r~n' + 'The code [MAXATMPDEACP] does not exist!'
		return FALSE
	end if
	return TRUE
	
	--END VALIDASI F_GETNOOFDAYSMAXTDAP


if not f_getNoOfDaysMAXRGPFRIRD(li_MAXRGPFRIRD, ls_errormsg) then
	guo_func.msgbox("Warning!", ls_errormsg)
	post dynamic event ue_set_column("activationintendeddate")
	dw_header.setFocus()
	return -1	
end IF

--VALIDASI F_GETNOOFDAYSMAXGPFRIRD

string last_sqlcode, last_sqlerrtext
select noOfDays
  into :ai_noOfDays
  from sysDaysParam
 where dayParamName = 'MAXRGPFRIRD'
 and divisionCode = :gs_divisionCode
and companyCode = :gs_companyCode
using SQLCA;
if SQLCA.sqlcode < 0 then
	as_errormsg = 'SQL Code: ' + string(SQLCA.sqlCode) + '~r~n' + SQLCA.sqlErrText
	return FALSE
elseif SQLCA.sqlcode = 100 then
	as_errormsg = 'SQL Code: ' + string(SQLCA.sqlCode) + '~r~n' + 'The code [MAXRGPFRIRD] does not exist!'
	return FALSE
end if
return TRUE

--END VALDIASI


/**-zar 05312010 - to avoid partial surrender of CPE **/
string ls_selected
int    li_ctr

for ll_row = 1 to dw_subscriber_stb.rowCount()
	ls_serialNo 		= trim(dw_subscriber_stb.object.serialNo[ll_row])
	ls_selected       = trim(dw_subscriber_stb.object.scanned[ll_row])
	
	if trim(ls_selected) = 'Y' then
		li_ctr++
	end if			
next	

if li_ctr > 0 and li_ctr < dw_subscriber_stb.rowCount() then
	is_msgno 	= 'Transaction error'
	is_msgtrail = "Surrendered CPE must be equal to the total number of subscribers' CPE." + &
					  "~r~nIf partially surrendered, please use Extension Disconnection w/o J.O prior to Application of P.D."
	is_sugtrail = 'Event : ue_save_applofmlineextpermdischdranddtl'
	return -1
end if	
/*********************************************************/


ldtme_graceperioddatefrom 	 	= datetime(relativeDate(date(guo_func.get_server_date()), li_mindays))	
ldtme_graceperioddateto 	 	= datetime(relativeDate(date(guo_func.get_server_date()), li_maxdays))	
ldtme_startOfAutoPermDiscDate = datetime(relativeDate(date(ldt_activationIntendedDate), li_MAXRGPFRIRD + 1))	

ll_stbRows = dw_detail.rowCount() 
if isnull(ll_stbRows) then ll_stbRows = 0
for ll_stbRow = 1 to ll_stbRows
	if trim(dw_detail.getItemString(ll_stbRow, "acquisitionTypeCode")) <> 'BUY' then
		ll_stbNotBuy	= ll_stbNotBuy	+ 1
	end if	
next
if isnull(ll_stbNotBuy) then ll_stbNotBuy = 0

ll_noOfSTBDeActivated = ll_stbRows
ll_noOfSTBPulledOut = ll_stbNotBuy

--Validation
if ls_acctno = '' or isnull(ls_acctno) then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = "Saving Subscriber Master : ~r~n Cannot save with unknown Account No."
	return -1
end if	

// preparation of columns
decimal{2} ld_mLineExtDeAcFee
decimal{2} ld_mLineCurrentMonthlyRate, ld_previousMonthlyRate, ld_DiscountRateDEACF
decimal{2} ld_extCurrentMonthlyRate, ld_extCurrentDailyRate, ld_mLineCurrentDailyRate
long ll_daysConsumed, ll_noOfDaysOfTheMonth 

decimal{2} ld_previousDailyRate, ld_mLineBaseDayRate, ld_extBaseDayRate, ld_amount

ld_mLineExtDeAcFee 			= 0.00
ld_MLineExtDeAcFeeDiscount 	= 0.00

--=====================================================================================================================
--
-- 												Saving of Installation, Sales and JO Details STB Serial Nos Tables
--
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


--perform computation here for billing purposes
if not iuo_subscriber.setAcctNo(ls_acctNo) then
	guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + iuo_subscriber.lastSQLErrText)
end if

ls_chargeTypeCode 			= iuo_subscriber.chargeTypeCode
ls_subsUserTypeCode 			= iuo_subscriber.subsUserTypeCode
ls_subscriberStatusCode 		= iuo_subscriber.subscriberStatusCode
ls_subsTypeCode 				= iuo_subscriber.subsTypeCode
ll_numberOfRooms 			= iuo_subscriber.numberOfRooms
ld_occupancyRate 				= iuo_subscriber.occupancyRate
ld_mLineCurrentMonthlyRate 	= iuo_subscriber.mLineCurrentMonthlyRate
ld_extCurrentMonthlyRate 	= iuo_subscriber.extCurrentMonthlyRate

if not iuo_subscriber.getmLineExtDeAcFee(ld_mLineExtDeAcFee) then
	is_msgno = 'SM-0000001'
	is_msgtrail = iuo_subscriber.lastSQLCode + "~r~n" + iuo_subscriber.lastSQLErrText
	is_sugtrail = 'Error produced by iuo_subscriber.getmLineInstallationFee()'
	return -1
end IF

--VALIDASI GETMLINEEXTDEACFEE
	
		lastMethodAccessed = 'getMLineExtDeacFee'
	
	select deactivationFee
	  into :ad_mLineExtDeAcFee
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

--END VALIDASI GETMLINEEXTDEACFEE

if not iuo_subscriber.getPercentDiscount('DEACF', ld_DiscountRateDEACF) then
	is_msgno = 'SM-0000001'
	is_msgtrail = iuo_subscriber.lastSQLCode + "~r~n" + iuo_subscriber.lastSQLErrText
	is_sugtrail = 'Error produced by iuo_subscriber.getPercentDiscount()'
	return -1
end IF

--VALIDASI GETPERCENTDISCOUNT
	
	lastMethodAccessed = 'getPercentDiscount'

	select percentDiscount
	  into :ad_percent
	  from chargeTypeDiscountMaster
	 where chargeTypeCode = :chargeTypeCode
	 	and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	and arTypeCode = :as_arTypeCode
	 using SQLCA;
	if SQLCA.sqlcode < 0 then
		lastSQLCode = string(SQLCA.sqlcode)
		lastSQLErrText = SQLCA.sqlerrtext
		return FALSE
	elseif SQLCA.sqlcode = 100 then
		ad_percent = 0
	end if
	return TRUE
	
--END VALIDASI GETPERCENTDISCOUNT

ld_DiscountRateMLMSF = 0.00
if not iuo_subscriber.getPercentDiscount('MLMSF', ld_DiscountRateMLMSF) then
	is_msgno = 'SM-0000001'
	is_msgtrail = iuo_subscriber.lastSQLCode + "~r~n" + iuo_subscriber.lastSQLErrText
	is_sugtrail = 'Error produced by iuo_subscriber.getPercentDiscount()'
	return -1
end IF

-VALIDASI GETPERCENTDISCOUNT
	
lastMethodAccessed = 'getPercentDiscount'

select percentDiscount
  into :ad_percent
  from chargeTypeDiscountMaster
 where chargeTypeCode = :chargeTypeCode
 	and divisionCode = :gs_divisionCode
and companyCode = :gs_companyCode
and arTypeCode = :as_arTypeCode
 using SQLCA;
if SQLCA.sqlcode < 0 then
	lastSQLCode = string(SQLCA.sqlcode)
	lastSQLErrText = SQLCA.sqlerrtext
	return FALSE
elseif SQLCA.sqlcode = 100 then
	ad_percent = 0
end if
return TRUE

--END VALIDASI GETPERCENTDISCOUNT

ld_DiscountRateEXMSF = 0.00
if not iuo_subscriber.getPercentDiscount('EXMSF', ld_DiscountRateEXMSF) then
	is_msgno = 'SM-0000001'
	is_msgtrail = iuo_subscriber.lastSQLCode + "~r~n" + iuo_subscriber.lastSQLErrText
	is_sugtrail = 'Error produced by iuo_subscriber.getPercentDiscount()'
	return -1
end IF

--VALIDASI GETPERCENTDISCOUNT
	
	lastMethodAccessed = 'getPercentDiscount'

	select percentDiscount
	  into :ad_percent
	  from chargeTypeDiscountMaster
	 where chargeTypeCode = :chargeTypeCode
	 	and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	and arTypeCode = :as_arTypeCode
	 using SQLCA;
	if SQLCA.sqlcode < 0 then
		lastSQLCode = string(SQLCA.sqlcode)
		lastSQLErrText = SQLCA.sqlerrtext
		return FALSE
	elseif SQLCA.sqlcode = 100 then
		ad_percent = 0
	end if
	return TRUE
	
	--END VALIDASI GETPERCENTDISCOUNT

integer li_billingDayOfMonth
if not f_getBillingDayOfMonth(li_billingDayOfMonth) then
	is_msgNo 	= 'SM-0000001'
	is_msgTrail = string(SQLCA.sqlCode) + '~r~n' + &
					  SQLCA.sqlErrText
	is_sugTrail = 'Function: f_getBillingDayOfMonth()'
	return -1
end IF

--VALIDASI F_GETBILLINGDAYOFMONTH
	select billingDayOfMonth
	  into :ad_day
	  from systemParameter
	  where divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	and rownum < 2
	using SQLCA;
	if SQLCA.sqlCode < 0 then
		return FALSE
	end if
	
	--default to every 10th of the month
	if isnull(ad_day) or ad_day = 0 then ad_day = 10
	
	return TRUE
	
--END VALIDASI F_GETBILLINGDAYOFMONTH

if integer(string(ldt_preferreddatetimefrom, 'dd')) < li_billingDayOfMonth then
	ll_daysConsumed = integer(string(ldt_preferreddatetimefrom, 'dd')) - 1
else
	ll_daysConsumed =	0 - guo_func.getDaysConsumedFromGivenDate(ldt_preferreddatetimefrom)
end IF

--VALIDASI GETDAYSCOMSUEDFROMGIVENDATE
	date ldt_currentDate, ldt_noOfDays
	long li_year, li_month, li_day, li_days
	
	ldt_currentDate 			= 	date(adtm_date)
	li_year						=	year(ldt_currentDate) 
	li_month 					=	month(ldt_currentDate) 
	li_day						=	day(ldt_currentDate) 
	if li_month = 12 then
		li_year = li_year + 1
		li_month = 1
	else
		li_month 					=	li_month + 1
	end if
	ldt_noOfDays 				=	date(li_year, li_month, 1) 
	li_days						=	DaysAfter(ldt_currentDate, ldt_noOfDays)
	
	return li_days 
	
--END VALIDASI GETDAYSCOMSUEDFROMGIVENDATE

--ll_daysConsumed			=	guo_func.getDaysConsumedFromGivenDate(idt_tranDate)
ll_noOfDaysOfTheMonth	=	guo_func.get_month_days2(idt_tranDate)

--VALIDASI GET_MONTH_DAYS2
	long ll_return 
	date ld_lastDayofNextMonth
	integer li_month, li_year, li_nextMonth, li_nextMonthYear
	
	li_month = month(date(adtm_date))
	li_year = year(date(adtm_date))
	
	if li_month = 12 then
		li_nextMonth = 1
		li_nextMonthYear = li_year + 1
	else
		li_nextMonth = li_month + 1
		li_nextMonthYear = li_year
	end if
	
	ld_lastDayofNextMonth = RelativeDate(date(string(li_nextMonth) + '/1/' + string(li_nextMonthYear)), -1)
	ll_return = day(ld_lastDayofNextMonth) 
	
	return ll_return

--END VALIDASI GET_MONTH_DAYS2
		
if is_isDigital  <> 'Y' then

	ld_mLineCurrentDailyRate	= 	(ld_mLineCurrentMonthlyRate / ll_noOfDaysOfTheMonth)
	ld_extCurrentDailyRate 	= 	(ld_extCurrentMonthlyRate / ll_noOfDaysOfTheMonth)
	ld_mLineBaseDayRate		= 	ld_mLineCurrentDailyRate
	ld_extBaseDayRate			= 	ld_extCurrentDailyRate
	ld_amount					=	( ll_daysConsumed * ( ld_mLineBaseDayRate - (ld_mLineBaseDayRate * (ld_DiscountRateEXMSF/100)) ) ) + &
										( ll_daysConsumed * ( ld_extBaseDayRate - (ld_extBaseDayRate * (ld_DiscountRateEXMSF/100)) ) )
else
	for ll_row = 1 to dw_detail.rowCount()
		ls_serialNo 		= trim(dw_detail.object.serialNo[ll_row])
		if not isnull(ls_serialNo)  and ls_serialNo <> '' then 
			ls_packageCode 	= dw_detail.object.packageCode[ll_row]
			ls_caSerialNo	 	= dw_detail.object.caSerialNo[ll_row]
			ls_itemCode	 	= dw_detail.object.itemCode[ll_row]
			ls_caItemCode	 	= dw_detail.object.caItemCode[ll_row]
			if not iuo_subscriber.setAcctNoDigital(as_acctNo,ls_packageCode) then
				is_msgNo 	= 'SM-0000001'
				is_msgTrail = iuo_subscriber.lastSQLCode + '~r~n' + &
								  iuo_subscriber.lastSQLErrText
				is_sugTrail = 'Object/Method: iuo_subscriber.setAcctNo()'
				return -1
			end IF
			
			--VALIDASI SETACCTNODIGITAL
			
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
			bundledINETAcctNo
			
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
			:bundledINETAcctNo
			from arAcctSubscriber
			inner join vw_arAcctAddress billing on arAcctSubscriber.acctNo = billing.acctNo and billing.addressTypeCode = 'BILLING' and arAcctSubscriber.divisionCode = billing.divisionCode and arAcctSubscriber.companyCode = billing.companyCode
			inner join vw_arAcctAddress service on arAcctSubscriber.acctNo = service.acctNo and service.addressTypeCode = 'SERVADR1' and arAcctSubscriber.divisionCode = service.divisionCode and arAcctSubscriber.companyCode = service.companyCode
			left join vw_arAcctAddress b on arAcctSubscriber.acctNo = b.acctNo and b.addressTypeCode = 'SERVADR2' and arAcctSubscriber.divisionCode = b.divisionCode and arAcctSubscriber.companyCode = b.companyCode
			left join vw_arAcctAddress c on arAcctSubscriber.acctNo = c.acctNo and c.addressTypeCode = 'BUSINESS' and arAcctSubscriber.divisionCode = c.divisionCode and arAcctSubscriber.companyCode = c.companyCode
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
			
			packageCode = as_packageCode
			
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
			
			select a.packageName, a.generalPackageCode, b.generalPackageName, a.packageDescription, a.monthlyRate
			  into :packageName, :generalPackageCode, :generalPackageName, :packageDescription, :mLineCurrentMonthlyRate
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
			
			return TRUE

			--END VALIDASI SETACCTNODIGITAL
			
			ld_mlineCurrentMonthlyRate		= 	iuo_subscriber.mLineCurrentMonthlyRate
			ld_mlineCurrentDailyRate 			= 	(ld_mlineCurrentMonthlyRate / ll_noOfDaysOfTheMonth)
			ld_mLineBaseDayRate				= 	ld_mlineCurrentDailyRate
			ld_amount							=	(ll_daysConsumed * ( ld_mLineBaseDayRate - (ld_mLineBaseDayRate * (ld_DiscountRateEXMSF/100)) ) )
			ld_totExtAmt 						=	ld_totExtAmt + ld_amount
						
			insert into proRatedBillTranDtl (
						tranNo,
						tranDate,
						acctNo,
						packageCode,
						caSerialNo,
						caItemCode,
						stbItemCode,
						stbSerialNo,
						baseDailyRate,
						tranTypeCode,
						processed,
						daysConsumption,
						consumptionAmount,
						divisionCode,
						companyCode)
				values (
						:is_tranNo,
						:idt_tranDate,
						:as_acctNo,
						:ls_packageCode,
						:ls_caSerialNo,
						:ls_caItemCode,
						:ls_itemCode,
						:ls_serialNo,
						:ld_mLineBaseDayRate,
						'DEACSUBS',
						'Y',
						:ll_daysConsumed,
						:ld_amount,
						:gs_divisionCode,
						:gs_companyCode)
				using SQLCA;
				if SQLCA.SQLCode < 0 Then
					is_msgno = "SM-0000001"
					is_msgtrail = "Inserting record at proRatedBillTranDtl(1) ~r~nSQLErrCode : " + String(SQLCA.SQLCode) +  "~r~nSQLErrText : " + SQLCA.SQLErrText
					is_sugtrail = "Call your system administrator."
					return -1	
				end If
		else
			continue
		end if	
	next
	ld_amount = ld_totExtAmt 
	ld_extCurrentMonthlyRate			=     0.00
	ld_extCurrentDailyRate			=	0.00
	ld_extBaseDayRate					=	0.00
	
	//zar 06042010 -
	/***************moved here inside the Digital Case***************/
	/***************for analog, must be inserted during cron process*/
	string 	ls_tranNo
	long 	ll_tranNo
	
	if not guo_func.get_nextnumber('DEACSUBS', ll_tranNo, 'WITH LOCK') then
		return -1
	end if
	
	ls_tranNo = string(ll_tranNo, '00000000')
	insert into deactivationTranHdr (
					tranno,
					tranDate,
					acctNo,
					locationCode,
					packageCode,
					disconnectionType,
					jobOrderNo,
					noOfExtension,
					noOfSTBDeActivated,
					noOfSTBPulledOut,
					mLineCurrentMonthlyRate,
					mLineCurrentDailyRate,
					mLineBaseDailyRate,
					mLineAmount,
					extCurrentMonthlyRate,
					extCurrentDailyRate,
					extBaseDailyRate,
					extAmount,
					daysConsumption,
					mLineExtDeAcFee,
					mLineExtDeAcFeeDiscount,
					extendedFeeAmount,
					processed,
					useradd,
					dateadd,
					divisionCode,
					companyCode,
					deactivationFee,
					deacFeeDiscount,
					applRefNo)
		  values (
					:ls_tranNo,
					:idt_tranDate,
					:ls_acctNo,
					:ls_locationCode,
					:ls_packageCode,
					'MAN',
					'00000000',
					:ll_noOfExtension,
					:ll_noOfSTBDeActivated,
					:ll_noOfSTBPulledOut,
					:ld_mLineCurrentMonthlyRate,
					:ld_mLineCurrentDailyRate,
					:ld_mLineBaseDayRate,
					:ld_amount,
					:ld_extCurrentMonthlyRate,
					:ld_extCurrentDailyRate,
					:ld_extBaseDayRate,
					:ld_amount,
					:ll_daysConsumed,
					0.00,
					0.00,
					0.00,
					'N',
					:gs_username,
					getdate(),
					:gs_divisionCode,
					:gs_companyCode,
					0.00,
					0.00,
					:is_tranNo)
			using SQLCA;
	if SQLCA.SQLCode < 0 Then
		is_msgno = "SM-0000001"
		is_msgtrail = "Inserting record at deactivationTranHdr(1) ~r~nSQLErrCode : " + String(SQLCA.SQLCode) +  "~r~nSQLErrText : " + SQLCA.SQLErrText
		is_sugtrail = "Call your system administrator."
		return -1	
	end If
	
	if not guo_func.set_number('DEACSUBS', ll_tranNo) then
		return -1
	end if
	//*************moved to here*******************/	
	
end if


INSERT INTO applOfDeactivationTranHdr
	(
		tranNo,
		tranDate,
		acctNo,
		locationCode,
		chargeTypeCode,
		subsUserTypeCode,
		packageCode,
		subscriberStatusCode,
		subsTypeCode,
		numberOfRooms,
		occupancyRate,
		noOfExtension,
		noOfSTBDeActivated,
		noOfSTBPulledOut,	
		disconnectionType,
		baseAmount,
		daysConsumption,
		amount,
		mLineExtDeAcFee,
		mLineExtDeAcFeeDiscount, 
		extendedFeeAmount,
		processed,
		reason,
		disconnectionRemarksCode,
		activationIntendedDate,
		graceperioddatefrom,
		graceperioddateto,
		startOfAutoPermDiscDate,
		requestedBy,
		mLineCurrentMonthlyRate,
		extCurrentMonthlyRate,
		mlineCurrentDailyRate,
		extCurrentDailyRate,	
		referenceJONo,
		specialInstructions,
		applicationStatusCode,
		preferreddatetimefrom,
		preferreddatetimeto,
		dateadd,
		useradd,
		divisionCode,
		companyCode,
		deactivationFee,
		deacFeeDiscount
	)
VALUES
	(
		:is_tranNo,
		:idt_tranDate,
		:ls_acctNo,
		:ls_locationCode,
		:ls_chargeTypeCode,
		:ls_subsUserTypeCode,
		:ls_packageCode,	
		:ls_subscriberStatusCode,
		:ls_subsTypeCode,
		:ll_numberOfRooms,
		:ld_occupancyRate,
		:ll_noOfExtension,
		:ll_noOfSTBDeActivated,
		:ll_noOfSTBPulledOut,
		'DEA',
		:ld_mLineBaseDayRate,
		:ll_daysConsumed,
		:ld_amount,
		:ld_mLineExtDeAcFee,
		:ld_mLineExtDeAcFeeDiscount, 
		:ld_extendedFeeAmount,
		'N',
		:ls_reason,
		:ls_disconnectionRemarksCode,
		:ldt_activationIntendedDate,
		:ldtme_graceperioddatefrom,
		:ldtme_graceperioddateto,
		:ldtme_startOfAutoPermDiscDate,
		:ls_requestedBy,
		:ld_mLineCurrentMonthlyRate,
		:ld_extCurrentMonthlyRate,
		:ld_mlineCurrentDailyRate,
		:ld_extCurrentDailyRate,
		null,
		:ls_specialInstructions,
		'FJ',
		:ldt_preferreddatetimefrom,
		:ldt_preferreddatetimeto,
		getdate(),
		:gs_UserName,
		:gs_divisionCode,
		:gs_companyCode,
		0.00,
		0.00
	)
USING SQLCA;

if SQLCA.SQLCode = -1 then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = "Saving applOfDeactivationTranHdr ~nSQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
	return -1
end if


long ll_rows, ll_loop, ll_applOfExtTranDtl_qty
string ls_acquisitionTypeCode
dec{2} ld_rate

string ls_controlNo, ls_isPrimary
long ll_BoxIDNo


ll_rows = dw_subscriber_stb.rowCount()
uo_stb luo_stb
luo_stb = create using "uo_stb"

--==================================================
--all stbs scanned must be deactivated, 
--removed from stbPackages and locationCode updated 
--to userLocation
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

for ll_loop = 1 to ll_rows
		
	ls_serialNo = trim(dw_subscriber_stb.getItemString(ll_loop, 'serialNo'))
	ls_scanned 	= dw_subscriber_stb.getItemString(ll_loop, 'scanned')
	
	if not isnull(ls_serialNo) and ls_serialNo <> '' then 

		if not luo_stb.setSerialNo(ls_serialNo) then
			guo_func.msgbox("Warning!", luo_stb.lastSQLCode + "~r~n" + luo_stb.lastSQLErrText)		
			return -1
		end IF
		
		--VALIDASI IUO_STB.SETSERIALNO
		
		serialNo = trim(as_serialno)

			--check if existing
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
		
		--END VALIDASI IUO_STB.SETSERIALNO

		ls_itemCode 				= luo_stb.itemCode
		ll_BoxIDNo 				= luo_stb.BoxIdNo	
		ls_acquisitionTypeCode 	= luo_stb.acquisitionTypeCode 
		ls_acquiredBefore2003   	= luo_stb.acquiredBefore2003
				
		ls_surrendered = ls_scanned
	
		--==================================================
		--deactivation of stb will be done via cron
		--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		insert into applOfDeactivationTranDtl
			(tranNo,
			 itemCode,
			 boxIDNo,
			 serialNo,
			 acquisitionTypeCode,
			 acquiredBefore2003,
			 surrendered,
			 divisionCode,
			 companyCode)
		values
			(:is_tranNo,
			 :ls_itemCode,
			 :ll_boxIDNo,
			 :ls_serialNo,
			 :ls_acquisitionTypeCode,
			 :ls_acquiredBefore2003,
			 :ls_surrendered,
			 :gs_divisionCode,
			 :gs_companyCode)
		using SQLCA;	
		if SQLCA.SQLCode <> 0 then
			is_msgNo    = 'SM-0000001'
			is_msgTrail = "insert in applOfDeactivationTranDtl "+"SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
			return -1	
		end if	
		
		if ls_scanned = 'Y' then 
			
			if is_isDigital  =  'Y' then
				ls_packageCode	= dw_subscriber_stb.getItemString(ll_loop, 'packageCode')
				ls_isPrimary		= dw_subscriber_stb.getItemString(ll_loop, 'isPrimary')
				
				insert into deactivationTranDtl (
						tranNo,
						itemCode,
						boxIdNo,
						serialNo,
						acquisitionTypeCode,
						divisionCode,
						companyCode,
						packageCode,
						isPrimary)
				  values (
						:ls_tranNo,
						:ls_itemCode,
						:ll_boxIDNo,
						:ls_serialNo,
						 :ls_acquisitionTypeCode,
						:gs_divisionCode,
						:gs_companyCode,
						:ls_packageCode,
						:ls_isPrimary)
				using SQLCA;
				if SQLCA.SQLCode <> 0 Then	
					is_msgno = "SM-0000001"
					is_msgtrail = "Inserting record at deactivationTranDtl ~r~nSQLErrCode : " + String(SQLCA.SQLCode) +  "~r~nSQLErrText : " + SQLCA.SQLErrText
					is_sugtrail = "Call your system administrator."
					return -1
				end If				
						
			else
				setNull(ls_packageCode)
				setNull(ls_isPrimary)							
			end if
					
			if not luo_stb.getSCSRequestNextTranNo() then
				is_msgno = 'SM-0000001'
				is_msgtrail = luo_stb.lastSQLCode + "~r~n" + luo_stb.lastSQLErrText
				is_sugtrail = 'Error produced by luo_stb.getSCSRequestNextTranNo()'
				return -1
			end IF
			
			--VALIDASI GETSCCREQUESTNEXTTRANNO
			long ll_tranNo
			string ls_errormsg
			if not guo_func.get_nextnumber('SCSREQUEST', ll_tranno, 'WITH LOCK') then
				lastSQLCode = '-2'
				lastSQLErrText = 'Could not obtain the next SCS Request No.'
				Return False
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
				
				return TRUE
				
			--END VALIDASI GET_NEXTNUMBER
			
			scsRequestNextTranNo = ll_tranNo
			
			Return True

			--END VALIDASI GETSCCREQUESTNEXTTRANNO
		 
			luo_stb.setSCSRequestSource(ls_tranTypeCode)
			
			--VALIDASI setSCSRequestSource
			scsRequestSourceTransaction 	= as_sourceTransaction
		 
			--step 2
			--now deactivate stb
			if not luo_stb.deActivate() then
				guo_func.msgbox("Warning!", luo_stb.lastSQLCode + "~r~n" + luo_stb.lastSQLErrText)		
			end if
			
			--update tranno for scsRequest
			if not luo_stb.setSCSRequestTranNo() then
				is_msgno = 'SM-0000001'
				is_msgtrail = luo_stb.lastSQLCode + "~r~n" + luo_stb.lastSQLErrText
				is_sugtrail = 'Error produced by luo_stb.setSCSRequestTranNo()'
				return -1
			end IF
			
			--VALIDASI IUO_STB.SETSCSREQUESTTRANSNO
			
				if not guo_func.set_number('SCSREQUEST', scsRequestNextTranNo) then	
					lastSQLCode = '-2'
					lastSQLErrText = 'Could not set the next SCS Request No.'
					Return False
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
				
				--END VALIDASI 
				
				Return True
			
			--END VALIDASI IUO_STB.SETSCSREQUESTTRANSNO
			
			if ls_acquisitionTypeCode <> 'BUY' then
				
				update serialNoMaster 
					set locationCode = :ls_locationCode,
						 serialNoStatusCode = 'AV',
						 acctNo = null
				 where serialNo = :ls_serialNo
					and itemCode = :ls_itemCode
				 	and divisionCode = :gs_divisionCode
					and companyCode = :gs_companyCode
				using SQLCA;		
				if SQLCA.SQLCode = -1 then
					is_msgNo    = 'SM-0000001'
					is_msgTrail = "Error updating serialNoMaster. "+"SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
					return -1	
				end if	
				
				if is_isDigital = 'Y' then
					
					ls_caserialNo 	= dw_subscriber_stb.getItemString(ll_loop, 'caserialNo')
					ls_caItemCode	= dw_subscriber_stb.getItemString(ll_loop, 'caitemCode')
					
					update serialNoMaster 
						set locationCode = :ls_locationCode,
							 serialNoStatusCode = 'AV',
							 acctNo = null
					 where serialNo = :ls_caserialNo
						and itemCode = :ls_caItemCode
						and divisionCode = :gs_divisionCode
						and companyCode = :gs_companyCode
					using SQLCA;		
					if SQLCA.SQLCode = -1 then
						is_msgNo    = 'SM-0000001'
						is_msgTrail = "Error updating serialNoMaster. "+"SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
						return -1	
					end if	
					
				end if
				
				--zar 06212010 -for digipick
				if is_isdigital = 'Y' then
					
					--snap shot muna
					insert into applOfDeactivationTranDtlDGP
						(tranNo, 
						 stbItemCode, 
						 stbSerialNo, 
						 caItemCode, 
						 caSerialNo, 
						 packageCode, 
						 monthlyRate, 
						 divisionCode, 
						 companyCode)
					select :ls_tranNo, 
							 cpe.itemCode, 
							 cpe.serialNo, 
							 cpe.caItemCode, 
							 cpe.caSerialNo, 
							 spc.packageCode, 
							 pm.monthlyRate, 
							 :gs_divisioNCode,
							 :gs_companyCode
					from   subscriberCPEMaster cpe 
							 inner join subsSTBSPChanMaster spc on spc.itemCode = cpe.itemCode
																		  and spc.serialNo = cpe.serialNo
																		  and spc.divisionCode = cpe.divisionCode
																		  and spc.companyCode  = cpe.companyCode
							 inner join arPackageMaster pm on pm.packageCode = spc.packageCode
																		  and pm.divisionCode = spc.divisionCode
																		  and pm.companyCode  = spc.companyCode
					where  cpe.serialNo = :ls_serialNo
					and    cpe.acctNo   = :ls_acctNo
					and    cpe.divisionCode = :gs_divisionCode
					and    cpe.companyCode  = :gs_companyCode
					using  SQLCA;
					if SQLCA.SQLCode < 0 then
						is_msgNo    = 'SM-0000001'
						is_msgTrail = "Error in SNAP SHOT of DIGIPICK - PACKAGES..."+ &
										  "~r~nSQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
						return -1						
					end if						
					
					
					if not trigger event ue_deactivate_digipick(luo_stb, ls_acctNo, ls_tranNo) then
						return -1
					end if		
					
				end if
				

				delete from subscriberCPEMaster 
					where acctNo = :ls_acctNo 
					and serialNo = :ls_serialNo 
					and itemCode = :ls_itemCode	
					and divisionCode = :gs_divisionCode
					and companyCode = :gs_companyCode
				using SQLCA;			
				if SQLCA.SQLCode = -1 then
					is_msgNo    = 'SM-0000001'
					is_msgTrail = "Error deleteing record from subscriberCPEMaster. "+"SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
					return -1	
				end if	
				
			end if
			
			delete from stbPackages
				where serialNo = :ls_serialNo
				and divisionCode = :gs_divisionCode
				and companyCode = :gs_companyCode
			using SQLCA;
			if SQLCA.SQLCode = -1 then
				is_msgNo    = 'SM-0000001'
				is_msgTrail = "Error deleteing record from stbPackages. "+"SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
				return -1	
			end if	
								
					
		end if
		
	end if
	
next

return 0



--END VALIDASI UE_SAVE_DEA

if trigger event ue_save_subsInitialPayment(ls_acctno, ld_deacFee) = -1 then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = "Saving subsInitialPayment ~nSQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
	return -1
end IF

--VALIDASI UE_SAVE_SUBINITIALPAYMENT

long ll_priority, ll_row,  ll_rows, ll_loop
string ls_acctno, ls_arTypeCode, ls_currency
dec{2} ld_amount, ld_rate

ls_acctno = trim(as_acctno)

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
				ad_applicationFee = ad_applicationFee + ld_amount
		end choose
	end if
next

return 0


--END VALIDASI UE_SAVE_SUBINITIALPAYMENT

--==================================================
--Apply Open Credits
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if not uo_subs_advar.setAcctNo(ls_acctno) then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = uo_subs_advar.lastSQLCode + '~r~n' + uo_subs_advar.lastSQLErrText
	return -1
end IF

--VALIDASI UO_SUBS_ADVAR.SETACCTNO

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

--END VALIDASI UE-SUBS_ADVAR.SETACCNO 

if	This.Event ue_applyOCBalances(ld_deacFee) <> 0 then
	return -1	
end IF

--VALIDASI UE_APPLYOCBALANCES

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
--END VALIDASI 

if not uo_subs_advar.setJoReferenceNo('') then
	is_msgno = 'SM-0000001'
	is_msgtrail = uo_subs_advar.lastSQLCode + "~r~n" + uo_subs_advar.lastSQLErrText
	is_sugtrail = 'Error produced by uo_subs_advar.setJoReferenceNo()'
	return -1
end IF

--VALIDASI SETJOREFRENCENO
	joRefTranNo = as_joRefNo
	return TRUE
--END VALIDASI	 SETJOREFRENCENO

if not uo_subs_advar.setJoTranTypeCode(is_transactionID) then
	is_msgno = 'SM-0000001'
	is_msgtrail = uo_subs_advar.lastSQLCode + "~r~n" + uo_subs_advar.lastSQLErrText
	is_sugtrail = 'Error produced by uo_subs_advar.setJoTranTypeCode()'
	return -1
end IF

--VALIDASI SETJOTRANSTYPECODE
	joTranTypeCode = as_joTranTypeCode
	return TRUE
--END VALIDASI SETJOTRANSTYPECODE

if not uo_subs_advar.setParentTranTypeCode(is_transactionID) then
	is_msgno = 'SM-0000001'
	is_msgtrail = uo_subs_advar.lastSQLCode + "~r~n" + uo_subs_advar.lastSQLErrText
	is_sugtrail = 'Error produced by uo_subs_advar.setParentTranTypeCode()'
	return -1
end if

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
	if not uo_subs_advar.insertNewAr(is_tranno, is_transactionID, 'DEACF', ad_applicationFee, idt_trandate, string(idt_trandate, 'mmm yyyy'), &
												iuo_subscriber.currencyCode, iuo_currency.conversionRate) then
		is_msgno = 'SM-0000001'
		is_msgtrail = uo_subs_advar.lastSQLCode + "~r~n" + uo_subs_advar.lastSQLErrText
		is_sugtrail = 'Error produced by uo_subs_advar.insertNewAr()'
		return -1
	end if
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


--END VALIDASI APPLYOPENCREDITMULTIPLE

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
	
--END VALIDASI SETOCTRANNO

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

--END VALIDASI UE_APPLUOCBALANCE

--NOT USE ANYMORE
if not iuo_glPoster.postGLEntries() then
	is_msgno 	= 'SM-0000001'
	is_msgtrail =  iuo_glPoster.errorMessage
	is_sugtrail = iuo_glPoster.suggestionRemarks
	return -1
end if


if ll_noOfStbRowsScanned <> ll_noOfStbRows then
	ll_stbVariance = (ll_noOfStbRows - ll_noOfStbRowsScanned)
	guo_func.msgBox("Scanned STB Variance.", String( ll_stbVariance  ,"###,###")+" STB(s) for this subscriber has not been scanned.")	
end if



return 0

--END BUTTON SAVE



--END VALIDASI IF  gs_divisioncode = 'DAINT' or gs_divisioncode = 'DACTV' or gs_divisioncode = 'ACINT'



-- VALIDASI IF  gs_divisioncode <> 'DAINT' or gs_divisioncode <> 'DACTV' or gs_divisioncode <> 'ACINT'

is_serviceType = message.stringParm
is_serviceType = 'CTV'
idw_application_for_ext_dtl = dw_detail
idw_reqInitPayment = dw_reqinitpayment
iw_parent = this

dw_header.settransobject(SQLCA)
idw_reqInitPayment.settransobject(SQLCA) 

iuo_subscriber = create uo_subscriber_def

--QUERY FORM DW_HEADER
SELECT  	applOfDeactivationTranHdr.tranno,
		  	applOfDeactivationTranHdr.trandate,
		  	applOfDeactivationTranHdr.acctno,
		  	applOfDeactivationTranHdr.locationCode,
		  	applOfDeactivationTranHdr.chargeTypeCode,
		  	applOfDeactivationTranHdr.subsUserTypeCode,
		  	applOfDeactivationTranHdr.packageCode,
		  	applOfDeactivationTranHdr.subscriberStatusCode,
		  	applOfDeactivationTranHdr.subsTypeCode,
		  	applOfDeactivationTranHdr.numberOfRooms,
		  	applOfDeactivationTranHdr.occupancyRate,
		  	applOfDeactivationTranHdr.noOfExtension,
		  	applOfDeactivationTranHdr.noOfSTBDeActivated,
		  	applOfDeactivationTranHdr.noOfSTBPulledOut,
		  	applOfDeactivationTranHdr.disconnectionType,
		  	applOfDeactivationTranHdr.mlinecurrentDailyRate,
		  	applOfDeactivationTranHdr.baseAmount,
		  	applOfDeactivationTranHdr.daysConsumption,
		  	applOfDeactivationTranHdr.mlinecurrentMonthlyRate,
		  	applOfDeactivationTranHdr.amount,
		  	applOfDeactivationTranHdr.mLineExtDeAcFee,
		  	applOfDeactivationTranHdr.mLineExtDeAcFeeDiscount,
		  	applOfDeactivationTranHdr.extendedFeeAmount,
		  	applOfDeactivationTranHdr.processed,
		  	applOfDeactivationTranHdr.reason,
		   applOfDeactivationTranHdr.disconnectionRemarksCode,
		  	applOfDeactivationTranHdr.activationIntendedDate,
		  	applOfDeactivationTranHdr.referenceJONo,
		  	applOfDeactivationTranHdr.specialInstructions,
		  	applOfDeactivationTranHdr.preferreddatetimefrom,
		  	applOfDeactivationTranHdr.preferreddatetimeto,
		  	applOfDeactivationTranHdr.requestedBy,
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
		  	0 noOfSTB,
			getdate() graceperioddate,
		  	applOfDeactivationTranHdr.useradd ,
		  	applOfDeactivationTranHdr.dateadd
FROM 		applOfDeactivationTranHdr    

--END QUERY DW_HEADER

--QUERY DW_DETAIL
  SELECT  deactivationTranDtl.tranno ,           
deactivationTranDtl.itemcode ,           
deactivationTranDtl.boxidno ,           
deactivationTranDtl.serialno ,           
deactivationTranDtl.acquisitiontypecode     
FROM deactivationTranDtl    
--END QUERY DW_DETAIL

--QUEERY dw_subscriber_stb

SELECT  subscriberCPEMaster.serialno ,
		  subscriberCPEMaster.boxidno ,
		  subscriberCPEMaster.acquisitionTypeCode , caSerialNo, packagecode,caItemCode,
		  '' scanned, isPrimary    
	FROM subscriberCPEMaster      
  WHERE (subscriberCPEMaster.cpeTypeCode = 'STB') and (subscriberCPEMaster.acctno = :as_acctno )   

--END QUERY dw_subscriber_stb
  
--EVENT UE_SEARCH ACCTNO
  
  long ll_row, ll_success, ll_count
string ls_search, ls_result, ls_acctNo
string lastSQLCode, lastSQLErrText
string ls_subscriberName, ls_serviceAddress, ls_billingAddress
string ls_package, ls_generalPackage
string ls_subscriberStatus, ls_chargeType
string ls_subscriberType, ls_subscriberUserType
decimal{2} ld_occupancyRate, ld_monthlyMlineFee, ld_monthlyExtFee
long ll_noOfExt, ll_noOfSTB

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
		
		--END QUERY ACCTNO
				   
		openwithparm(w_search_subscriber,str_s)

		ls_result = trim(Message.StringParm)				
		if ls_result = '' or isNull(ls_result) then			
			return	
		end if
		dw_header.setitem(ll_row,'acctno', ls_result)	
		ls_acctNo = trim(ls_result)

		select count(acctNo) into :ll_count 
		  from applOfDeactivationTranHdr
		 where acctNo = :ls_acctNo and applicationStatusCode not in ('AC', 'CN')
		 and divisionCode = :gs_divisionCode
		 and companyCode = :gs_companyCode
		using SQLCA;
		if SQLCA.SQLCode < 0 then
			guo_func.MsgBox('SM-0000001','SQL Error Code : ' + 	string(SQLCA.SQLCode) + &
							    '~r~nSQL Error Text ; ' + SQLCA.SQLErrText)
			return					 
		end if	
		
		select subscriberStatusCode
		into :ls_subscode
		from arAcctSubscriber
		where acctno = :ls_result
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		
		using SQLCA;
		
		if ls_subscode = 'APL' then
				guo_func.MsgBox('Error.. ' ,+&
									 'This Account Status is Applied..  please select another Account and Click OK to continue...')
				return 				 
		end if	
		
		if ll_count > 0 then
			guo_func.MsgBox('Pending Application Found...', 'This account has a pending Application for [Mainline/Extension Disconnection],'+&
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
		
		--END VALIDASI setAcctNo
		
		dw_header.setItem( 1, "subscriberName", iuo_subscriber.subscribername )
		
		is_isDigital = iuo_subscriber.isDigital
		if is_isDigital = 'Y' then
			dw_subscriber_stb.dataObject = 'dw_subscriber_deac_digital'
			dw_detail.dataObject 			= 'dw_subscriber_unit_disc_dtl'
			
			--QUERY dw_subscriber_stb IF is_isDigital = 'Y'
			
			SELECT  subscriberCPEMaster.serialno ,
		  		subscriberCPEMaster.boxidno ,
				  subscriberCPEMaster.acquisitionTypeCode , caSerialNo, packagecode,caItemCode,
				  '' scanned, isPrimary    
			FROM subscriberCPEMaster      
		  WHERE (subscriberCPEMaster.cpeTypeCode = 'STB') and (subscriberCPEMaster.acctno = :as_acctno )   
		  
			--END QUERY dw_subscriber_stb
		  
		  --QUERY dw_detail IF is_isDigital = 'Y'
		  
		    SELECT  ''tranno ,           
			itemcode ,           
			caSerialNo , caItemCode, subscriberCPEMaster.packageCode, packageName,          
			serialno , acquisitionTypeCode, boxIDNo
			FROM subscriberCPEMaster   
			inner join arPackageMaster on  subscriberCPEMaster.packageCode = arPackageMaster.packageCode
				and subscriberCPEMaster.divisionCode = arPackageMaster.divisionCode
				and subscriberCPEMaster.companyCode = arPackageMaster.companyCode
			where acctNo = :as_acctNo
			and subscriberCPEMaster.divisionCode = :as_division
			and subscriberCPEMaster.companyCode = :as_company
			and isPrimary <> 'Y'
			
		  --END dw_detail
		else
			dw_subscriber_stb.dataObject = 'dw_subscriber_ext_disc_stb'
			dw_detail.dataObject 			= 'dw_subscriber_ext_disc_dtl'
			
			--QUERY dw_subscriber_stb IF is_isDigital <> 'Y'
				SELECT  subscriberCPEMaster.serialno ,
		           subscriberCPEMaster.boxidno ,
					  subscriberCPEMaster.acquisitionTypeCode ,		
		           '' scanned    
		        FROM subscriberCPEMaster      
		        WHERE (subscriberCPEMaster.cpeTypeCode = 'STB') 
			and ( subscriberCPEMaster.acctno = :as_acctno )   
			--END QUERY dw_subscriber_stb
			
			--QUERY dw_detail IF is_isDigital <> 'Y'
			  SELECT  deactivationTranDtl.tranno ,           
				deactivationTranDtl.itemcode ,           
				deactivationTranDtl.boxidno ,           
				deactivationTranDtl.serialno ,           
				'' acquisitionTypeCode    
				FROM deactivationTranDtl  
				
			--END QUERY dw_detail
			
		end if
		dw_subscriber_stb.setTransObject(SQLCA);
		
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
		
		--general package 
		if not iuo_subscriber.getGeneralPackageName(ls_generalPackage) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return
		end IF
		
		--validasi getGeneralPackageName
		
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
		
		--end validasi getGeneralPackageName
		
		dw_header.setItem( 1, "generalPackage", ls_generalPackage )		
		
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
		
		--end validasi
		
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
		
		--occupancy Rate
		ld_occupancyRate = iuo_subscriber.occupancyRate
		dw_header.setItem( 1, "occupancyRate", ld_occupancyRate )							
		
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
		
		dw_header.setItem( 1, "monthlyMlineFee", ld_monthlyMlineFee )							
		
		--monthly Ext Fee
		if not iuo_subscriber.getExtMonthlyRate(ld_monthlyExtFee) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return
		end IF
		
		--VALIDASI getExtMonthlyRate
		
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

		--END VALIDASI getExtMonthlyRate
			
		dw_header.setItem( 1, "monthlyExtFee", ld_monthlyExtFee )							
		
		--long ll_noOfExt
		if not iuo_subscriber.getnoofactiveext(ll_noOfExt) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return
		end IF
		
		--VALIDASI getnoofactiveext
		
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
			
		end if
		return TRUE

		--END getnoofactiveext
		
		dw_header.setItem( 1, "noOfExt", ll_noOfExt )									
		
		--ll_noOfSTB
		if not iuo_subscriber.getNoOfSTB(ll_noOfSTB) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return
		end IF
		
		--VALIDASI getNoOfSTB
		
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

		--END getNoOfSTB
		
		dw_header.setItem( 1, "noOfSTB", ll_noOfSTB )											
		il_noOfSTB = ll_noOfSTB
		
		dw_header.acceptText()
		
		--id_mLineExtDeAcFee
		if not iuo_subscriber.getMLineExtDeacFee(id_mLineExtDeAcFee) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return
		end IF
		
		--VALIDASI GETmLINEEXTDEACFEE
		lastMethodAccessed = 'getMLineExtDeacFee'

		select deactivationFee
		  into :ad_mLineExtDeAcFee
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

		--END VALIDASI GETmLINEEXTDEACFEE
		
		dw_header.setitem(1,'extendedfeeamount',id_mLineExtDeAcFee)
		
		--populate registere STB serial nos.
		--step 1 check if populated already then delete all
		ll_row = dw_subscriber_stb.getRow()
		if isnull(ll_row) then ll_row = 0
		if ll_row>0 then
			dw_subscriber_stb.reset()			
		end if
		
		--step 2 now populate
		string	ls_serialNo, ls_boxIdNo, ls_caSerialNo, ls_packageCode, ls_isPrimary, ls_caItemCode		
			
		declare cur_subscriber_stbs cursor for
			select serialNo, boxIdNo, caSerialNo, packageCode, isPrimary, caItemCode
			from subscriberCPEMaster
			where acctNo = :ls_acctNo
			and divisionCode = :gs_divisionCode
			and companyCode = :gs_companyCode
			and cpeTypeCode = 'STB'
		using SQLCA;
			
		open cur_subscriber_stbs;
		if SQLCA.sqlcode <> 0 then
			guo_func.msgbox("Warning!", string(SQLCA.SQLCode) + "~r~n" + &
				SQLCA.SQLErrText)
			return
		end if
		
		fetch cur_subscriber_stbs 
			into :ls_serialNo, :ls_boxIdNo, :ls_caSerialNo, :ls_packageCode, :ls_isPrimary, :ls_caItemCode;

		long ll_curRow
		do while SQLCA.sqlcode = 0
			--insert to stb list
			ll_curRow = dw_subscriber_stb.insertRow(0)
			dw_subscriber_stb.setItem( ll_curRow, "serialNo", ls_serialNo )
			if is_isDigital <> 'Y' then
				dw_subscriber_stb.setItem( ll_curRow, "boxidno", ls_boxIdNo )
			else
				dw_subscriber_stb.setItem( ll_curRow, "caserialNo", ls_caserialNo )
				dw_subscriber_stb.setItem( ll_curRow, "packageCode", ls_packageCode )
				dw_subscriber_stb.setItem( ll_curRow, "isPrimary", ls_isPrimary )
				dw_subscriber_stb.setItem( ll_curRow, "caItemCode", ls_caItemCode )
			end if
			--insert to stb for scanning
			ll_curRow = dw_detail.insertRow(0)
			
			fetch cur_subscriber_stbs into :ls_serialNo, :ls_boxIdNo,:ls_caSerialNo, :ls_packageCode, :ls_isPrimary, :ls_caItemCode;
		loop
		
		close cur_subscriber_stbs;
		--messagebox("",ls_subscriberStatus)
		if ls_subscriberStatus <> 'Active' then
			guo_func.msgbox("Warning!", "Subscriber must be on ACTIVE STATUS.")	
			triggerevent("ue_new")
			return
		end if
		
		--PREPARE REQUIRED INITIAL PAYMENT
		uf_prepare_required_initial_payment()
		
		--VALIDASI UF_PREAPATE_REQUIRED_INITIAL_PAYMENT
		
		--call compute required initial payment
			long ll_rows, ll_success
			string ls_subsTypeCode, ls_packageCode, ls_chargeTypeCode, ls_acquisitionTypeCode
			
			ls_subsTypeCode  = iuo_subscriber.subsTypeCode
			ls_packageCode = iuo_subscriber.packageCode
			ls_chargeTypeCode = iuo_subscriber.chargeTypeCode
			
			ll_rows = idw_ReqInitPayment.rowCount()
			
			if not isnull(ls_subsTypeCode) then
				if not isnull(ls_packageCode) then
					if not isnull(ls_chargeTypeCode) then	
							if ll_rows > 0 then
								ll_success = uf_compute_req_init_pay_mlineext_deacwjo(	&
									   ls_chargeTypeCode, &
										id_mLineExtDeAcFee, &		
										idw_ReqInitPayment )
								
										--VALIDASI UF_COMPUTE_REQ_INIT_PAY_MLINEEXT_DEACWJO
										
										--acquisitionTypeCode based fees
											long ll_row
											decimal{2} ld_amount_DEACF, ld_percentDiscount,ld_amountDiscount
											
											ld_amount_DEACF = 0.00
											
											ld_amount_DEACF = ad_mLineExtDeAcFee
											
											--DEACF - Deactivation Fee Required Initial Payment
											ld_percentDiscount = 0.00 
											ld_amountDiscount = 0.00
											
											SELECT 	percentDiscount
											INTO 		:ld_percentDiscount
											FROM 		chargeTypeDiscountMaster
											WHERE 	chargeTypeCode = :as_chargeTypeCode and arTypeCode = 'DEACF'
											and divisionCode = :gs_divisionCode
											and companyCode = :gs_companyCode
											USING SQLCA;			
											If SQLCA.SQLcode = -1 then
												messagebox('SM-0000001',"select in chargeTypeMaster SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText)
												return -1
											end if
											
											if isnull(ld_percentDiscount) then ld_percentDiscount = 0.00 
											if ld_percentDiscount > 0.00 then
												ld_amountDiscount = ( ld_amount_DEACF * (ld_percentDiscount/100) )
												ld_amount_DEACF = ld_amount_DEACF - ld_amountDiscount
												if ld_amount_DEACF < 0.00 then 
													ld_amount_DEACF = 0.00
												end if
											end if
											
											
											--update datawindow for required initial payment
											
											ll_row = adw_ReqInitPayment.find("arTypeCode='DEACF'",1,adw_ReqInitPayment.rowCount())		
											adw_ReqInitPayment.scrollToRow( ll_row )						
											if ll_row > 0 then
												adw_ReqInitPayment.setItem( ll_row, "amount", ld_amount_DEACF )
											end if		
											
											adw_ReqInitPayment.acceptText()
											
											return 0

										--END VALIDASI UF_COMPUTE_REQ_INIT_PAY_MLINEEXT_DEACWJO
							end if
						end if
				end if
			end if
								
			return 0
		
		--END VALIDAS UF_PREAPATE_REQUIRED_INITIAL_PAYMENT

		dw_header.setColumn("locationCode")

		dw_subscriber_stb.acceptText()
		dw_subscriber_stb.scrolltorow(1)

		dw_detail.acceptText()
		dw_detail.scrolltorow(1)
		
		--------------------------------------------------------------
		--validate policy on no of months a/r min requirement - start
		--------------------------------------------------------------		
		s_arrears_override_policy.refTranTypeCode = 'APPLYDEAC'
		
		if not f_overrideArrearsLockIn(iuo_subscriber, s_arrears_override_policy ) then
			triggerevent("ue_cancel")
			return
		end IF
		
		--VALIDASI F_OVERRIDEARREARSLOCKIN
		
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
		end if
		
		ls_msg = f_lockInPeriod(iuo_subscriber.acctNo)
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
		end if
		--pop up override policy window for authorization
		
		if guo_func.msgbox("Policy Override!!!", ls_remarks, &										
								gc_Question, gc_yesNo, "Please secure an authorization for overriding this policy.") = 1 then
			
			openwithparm(w_online_authorization,s_arrears_override_policy)	
			 
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
		------------------------------------------------------------			
		--validate policy on no of months a/r min requirement - end
		------------------------------------------------------------
		
		--END VALIDASI F_OVERRIDEARREARSLOCKIN
	
		------------------------------------------------------------			
		--validate policy on no of months a/r min requirement - end
		------------------------------------------------------------
		
				
end choose
return 

--END EVENT UE_SEARCH_ACCTNO

--EVENT ITEMCHANGE DW_HEADER
long ll_row, ll_success, ll_noOfSTB
string ls_search, ls_result, ls_acctNo, lastSQLCode, lastSQLErrText

string ls_subscriberName, ls_serviceAddress, ls_billingAddress
string ls_package, ls_generalPackage
string ls_subscriberStatus, ls_chargeType
string ls_subscriberType, ls_subscriberUserType
decimal{2} ld_occupancyRate, ld_monthlyMlineFee, ld_monthlyExtFee
long ll_noOfExt

if dwo.name = 'activationintendeddate' then


	date ldt_activationintendeddate, ldt_getserverdatetime
	
	ldt_activationintendeddate = date(left(data,10))
	
	ldt_getserverdatetime = date(this.GetItemDateTime(row, 'preferredDateTimeFrom')) //date(guo_func.get_server_date())

	--==================================================
	--this portion obtains the Minimum/Maximum Allowable 
	--Temporary De-Activation Period
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	string	ls_errormsg
	integer 	li_mindays, li_maxdays
	if not f_getNoOfDaysMINATDAP(li_mindays, ls_errormsg) then
		guo_func.msgbox("Warning!", ls_errormsg)
		post dynamic event ue_set_column("activationintendeddate")
		dw_header.setFocus()
		return 2
	end IF
	
	--VALIDASI F_GETNOOFDAYSMINATDAP
	
	string last_sqlcode, last_sqlerrtext
	
	select noOfDays
	  into :ai_noOfDays
	  from sysDaysParam
	 where dayParamName = 'MINATMPDEACP'
	 and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	using SQLCA;
	if SQLCA.sqlcode < 0 then
		as_errormsg = 'SQL Code: ' + string(SQLCA.sqlCode) + '~r~n' + SQLCA.sqlErrText
		return FALSE
	elseif SQLCA.sqlcode = 100 then
		as_errormsg = 'SQL Code: ' + string(SQLCA.sqlCode) + '~r~n' + 'The code [MINATMPDEACP] does not exist!'
		return FALSE
	end if
	return TRUE
		
	--END VALIDASI F_GETNOOFDAYSMINATDAP
	
	if not f_getNoOfDaysMAXATDAP(li_maxdays, ls_errormsg) then
		guo_func.msgbox("Warning!", ls_errormsg)
		post dynamic event ue_set_column("activationintendeddate")
		dw_header.setFocus()
		return 2
	end IF
	
	--VALIDASI F_GETNOOFDAYSMAXTDAP
	
	string last_sqlcode, last_sqlerrtext
	select noOfDays
	  into :ai_noOfDays
	  from sysDaysParam
	 where dayParamName = 'MAXATMPDEACP'
	 and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	using SQLCA;
	if SQLCA.sqlcode < 0 then
		as_errormsg = 'SQL Code: ' + string(SQLCA.sqlCode) + '~r~n' + SQLCA.sqlErrText
		return FALSE
	elseif SQLCA.sqlcode = 100 then
		as_errormsg = 'SQL Code: ' + string(SQLCA.sqlCode) + '~r~n' + 'The code [MAXATMPDEACP] does not exist!'
		return FALSE
	end if
	return TRUE
	
	--END VALIDASI F_GETNOOFDAYSMAXTDAP
	
	--==================================================
	--end
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
	
	if  ( ldt_activationintendeddate >= relativeDate(date(ldt_getserverdatetime), li_mindays) and ldt_activationintendeddate <= relativeDate(date(ldt_getserverdatetime), li_maxdays) ) then
		//messageBox("between nga", "daw")
		post dynamic event ue_set_column("requestedBy")
		dw_header.setFocus()
	else
		guo_func.msgbox("Invalid Deactivation Period!!!", &
							"The allowable intended reactivation dates are between :" + &										
							string( relativeDate(date(ldt_getserverdatetime), li_mindays), "mm/dd/yyyy")+ "  and  " + &
							string( relativeDate(date(ldt_getserverdatetime), li_maxdays), "mm/dd/yyyy"), &
							gc_Information, &
							gc_OKOnly, &
							"The minimum no. of days for deactivation is "+string(li_mindays)+"days while maximum is "+string(li_maxdays) +"days.")
		
		post dynamic event ue_set_column("activationintendeddate")
		dw_header.setFocus()
		return 2
	end if
	
	dw_header.setColumn("locationCode")

elseif dwo.name = 'preferreddatetimefrom' then
	
		date ld_currentDate, ld_preferdtfrom
		ld_preferdtfrom = date(left(data,10))
		ld_currentDate = date(guo_func.get_server_date())
		
		if ld_currentDate > ld_preferdtfrom then
			guo_func.msgbox('Date Invalid!', 'Please check your date...')
			post dynamic event ue_set_column("preferreddatetimefrom")
			dw_header.setFocus()
			return 2
		end if
		
elseif dwo.name = 'preferreddatetimeto' then

		date ld_preferdtto
		ld_preferdtto = date(left(data,10))
		ld_currentDate = date(guo_func.get_server_date())
		
		if ld_currentDate > ld_preferdtto then
			guo_func.msgbox('Date Invalid!', 'Please check your date...')
			post dynamic event ue_set_column("preferreddatetimeto")
			dw_header.setFocus()
			return 2
		end if
	
elseif dwo.name = 'requestedBy' then	
	dw_detail.setFocus()
end if

--END EVENT ITEMCHANGE DW_HEADER

--EVENT ITEMCHANGE DW_DETAIL

string ls_serialNo, ls_caSerialNo, ls_itemCode, ls_caItemCode, ls_packageCode
long ll_row, ll_boxIdNo
boolean as_hasstb
ll_boxIdNo = 0
uo_stb xuo_stb
xuo_stb = create using "uo_stb"

ls_serialNo = trim(data)

if dwo.name = 'serialno' then
	if dynamic trigger event ue_validate_serialno(ls_serialNo) = -1 then
		guo_func.msgbox("Duplicate of serial no.","You have entered serial no.{ "+ls_serialNo+" } already!")
		return 2
	end IF
	
	--VALIDASI UE_VALIDATE_SERIALNO
		long ll_ret
	
		ll_ret = this.Find("serialno = '"+as_serialno+"'",1,this.rowcount()) 
		
		if ll_ret > 0 then
			return -1
		end if
		
		return 0
	
	--END VALDIASI 
	--hasstbserialno	
	if not iuo_Subscriber.hasSTBSerialNo(ls_serialNo, 'Y', as_hasstb) then
		guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + iuo_subscriber.lastSQLErrText)
	end IF
	
	--VALIDASI HAS_STB_SERIAL_NO
	
	lastMethodAccessed = 'hasSTBSerialNo'

		string ls_serialNo, ls_allSTB
		long ll_noofSTB
		ls_serialNo = trim(as_serialno)
		
		if as_allSTB = 'Y' then
			ls_allSTB = 'Y'
		else
			ls_allSTB = 'N'
		end if
		
		if isDigital <> 'Y' then
			select count(acctNo)
			  into :ll_noofSTB
			  from subscriberCPEMaster
			 where acctNo = :acctNo and acctNo is not null 
				and divisionCode = :gs_divisionCode
			and companyCode = :gs_companyCode
			and rtrim(ltrim(serialNo)) = ltrim(rtrim(:as_serialNo))
			 group by acctNo 
			 using SQLCA;
			if SQLCA.sqlcode <> 0 then
				lastSQLCode = string(SQLCA.sqlcode)
				lastSQLErrText = SQLCA.sqlerrtext
				return FALSE
			end if
		else
			select count(acctNo)
			  into :ll_noofSTB
			  from subscriberCPEMaster
			 where acctNo = :acctNo and acctNo is not null and ( isPrimary in (:ls_allSTB) or :as_allSTB = 'Y')
				and divisionCode = :gs_divisionCode
			and companyCode = :gs_companyCode
			and rtrim(ltrim(serialNo)) = ltrim(rtrim(:as_serialNo))
			 group by acctNo 
			 using SQLCA;
			if SQLCA.sqlcode <> 0 then
				lastSQLCode = string(SQLCA.sqlcode)
				lastSQLErrText = SQLCA.sqlerrtext
				return FALSE
			end if
		end if
		
		if isnull(ll_noofSTB) then ll_noofSTB = 0
		if ll_noofSTB > 0 then
			ab_hasSTB = TRUE
		else
			ab_hasSTB = FALSE
		end if
		
		return true
	
	--END VALIDASI HAS _STB_SRIAL_NO
	
	if as_hasstb then
		
		SELECT boxIdNo, caSerialNo, caItemCode, itemCode, packageCode
		INTO   :ll_boxIdNo,  :ls_caSerialNo, :ls_caItemCode, :ls_itemCode, :ls_packageCode
		from   subscriberCPEMaster
		where  serialno =:ls_serialNo
		and    divisionCode = :gs_divisionCode
		and    companyCode = :gs_companyCode 
		using sqlca;
		if sqlca.sqlcode <> 0 then
			guo_func.msgbox("Error in SQL",sqlca.sqlerrtext)
			return 2
		end if
		
		ll_row = dw_subscriber_stb.find("serialNo='"+ls_serialNo+"'",1,dw_subscriber_stb.rowCount())		
		dw_subscriber_stb.scrollToRow( ll_row )	
	
		if ll_row > 0 then
			dw_subscriber_stb.setItem( ll_row, "scanned", 'Y' )
			this.setitem(row,'boxidno', ll_boxidno)
			if  is_isDigital = 'Y' then
				dw_detail.setItem( row, "caserialno", ls_caSerialNo )
				dw_detail.setItem( row, "caItemCode", ls_caItemCode )
				dw_detail.setItem( row, "itemCode", ls_itemCode )
				dw_detail.setItem( row, "packageCode", ls_packageCode )
			end if
		end if	
		
		if not xuo_stb.setSerialNo(ls_serialNo) then
			guo_func.msgbox("Warning!", xuo_stb.lastSQLCode + "~r~n" + xuo_stb.lastSQLErrText)		
		end IF
		
		--VALIDASI XUO_STB.SETSRIALNO
		
		serialNo = trim(as_serialno)

			--check if existing
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
					
		--END VALIDASI XUO_STB.SETSRIALNO
		
		dw_subscriber_stb.acceptText()
		dw_subscriber_stb.scrollToRow( ll_row )		
		
	else
		guo_func.msgBox("No. of Extension(s) Validation Error", "Serial No. not Assigned to this Subscriber" )
		return 2
	end if
end IF

--END EVENT ITEMCHANGE DW_DETAIL

--BUTTON SAVE

long ll_acctno, ll_tranNo, ll_noOfStbRows, ll_row, ll_noOfStbRowsScanned,  ll_stbVariance
string ls_acctno
datetime ldt_preferdtfrom, ldt_preferdtto
date	ld_preferdtfrom, ld_preferdtto
decimal{2} ld_deacFee

dw_header.accepttext()
dw_subscriber_stb.accepttext()
dw_detail.accepttext()

idt_tranDate	= guo_func.get_server_datetime()
ldt_preferdtfrom = dw_header.getItemDateTime(1, 'preferreddatetimefrom')
ldt_preferdtto = dw_header.getItemDateTime(1, 'preferreddatetimeto')
ld_preferdtfrom = date(ldt_preferdtfrom)
ld_preferdtto = date(ldt_preferdtto)

ll_noOfStbRows = dw_subscriber_stb.rowCount()

for ll_row = 1 to ll_noOfStbRows
	dw_subscriber_stb.scrollToRow(ll_row)	
	if dw_subscriber_stb.getItemString( ll_row, "scanned") = 'Y' then
		ll_noOfStbRowsScanned = ll_noOfStbRowsScanned + 1	
	end if	
next 

If messagebox('Confirmation', "You wish to save new application for ML/Ext Deactivation?", Question!, OKCancel! ) <> 1 Then
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

return true

--END VALIDASI GET_NEXTNUMBER

if	not guo_func.set_number(is_transactionID, ll_tranNo) then
	return -1	
end IF

--validasi set_number
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

--end validasi set_number

is_tranno = string(ll_tranno, '00000000')
ls_acctno = trim( dw_header.getItemString( 1, 'acctno' ) )


--NO USE ANYMORE
--==================================================
--NGLara | 03-31-2008
--Prepare GL Poster
if not iuo_glPoster.initialize(is_transactionID, is_tranNo, idt_tranDate) then
	is_msgno 	= 'SM-0000001'
	is_msgtrail = iuo_glPoster.errorMessage
	is_sugtrail = iuo_glPoster.suggestionRemarks
	return -1
end IF

uo_subs_advar.setGLPoster(iuo_glPoster)

if isnull(ld_preferdtfrom) or isnull(ld_preferdtto) then
	is_msgNo		= 'SM-0000001'
	is_msgTrail = 'Please input Preferred Date/Time From and Preferred Date/Time To...'
	return -1
end if

if trigger event ue_save_deacmlineexttranhdranddtl(ls_acctno, is_transactionID) = -1 then
   return -1
end IF

--VALIDASI UE_SAVE_DEACMLINEEXTTRANHDRANDDTL

string 		ls_scanned, ls_surrendered, ls_serialNo, ls_caSerialNo, ls_itemCode, ls_caItemCode 
string 		ls_acctNo, ls_userAdd, ls_trantypecode, ls_acquiredBefore2003
string 		ls_reason, ls_requestedBy, ls_packageCode, ls_locationCode, ls_disconnectionRemarksCode
string 		ls_chargeTypeCode, ls_subsUserTypeCode, ls_subscriberStatusCode, ls_subsTypeCode
long 		ll_numberOfRooms
decimal{2} ld_occupancyRate, ld_totExtAmt
datetime 	ldt_activationIntendedDate
datetime 	ldt_dateadd, ldtme_graceperioddatefrom, ldtme_graceperioddateto, ldtme_startOfAutoPermDiscDate
string 		ls_specialinstructions, ls_referenceJONo
datetime 	ldt_preferreddatetimefrom, ldt_preferreddatetimeto						
decimal{2} ld_extendedfeeamount, ld_DiscountRateMLMSF, ld_DiscountRateEXMSF, ld_MLineExtDeAcFeeDiscount
long 		ll_row, ll_stbRows, ll_stbRow, ll_stbNotBuy
long 		ll_noOfExtension, ll_noOfSTBDeActivated, ll_noOfSTBPulledOut


ls_trantypecode = trim(as_trantypecode)
ll_row = dw_header.getrow()

idw_application_for_ext_dtl.acceptText() 

--get subscriber information
idt_tranDate 						= guo_func.get_server_datetime()
ls_acctNo 							= trim(as_acctno)
ls_locationCode					= trim(dw_header.getItemString( ll_row, "locationCode") )	
ls_reason							= trim(dw_header.getItemString( ll_row, "reason" ) )	
ls_disconnectionRemarksCode		= trim(dw_header.getItemString( ll_row, "disconnectionRemarksCode" ) )	
ls_requestedBy					= trim(dw_header.getItemString( ll_row, "requestedBy" ) )	
ldt_activationIntendedDate		= dw_header.getItemDateTime( ll_row, "activationIntendedDate" )
ld_extendedfeeamount			= dw_header.getItemDecimal( ll_row, "extendedfeeamount" )
ll_noOfExtension					= dw_header.getItemDecimal( ll_row, "noofext" )
ls_specialinstructions				= trim(dw_header.getItemString(ll_row, "specialInstructions"))	
ldt_preferreddatetimefrom		= dw_header.getItemDateTime( ll_row, "preferreddatetimefrom")
ldt_preferreddatetimeto			= dw_header.getItemDateTime( ll_row, "preferreddatetimeto")
ls_packageCode 					= iuo_subscriber.packageCode
ld_MLineExtDeAcFeeDiscount 		= dw_header.getItemDecimal( ll_row, "mlineextdeacfeediscount" )

--get the stb info from scanned stbs
ll_noOfSTBDeActivated		= dw_header.getItemDecimal( ll_row, "noofstb" )

ll_noOfSTBPulledOut			= dw_subscriber_stb.getItemDecimal( 1, "compute_2" ) (--COUNT SERIALNO FOR ALL)

--==================================================
--this portion obtains the Minimum/Maximum Allowable 
--Temporary De-Activation Period
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
string	ls_errormsg
integer 	li_mindays, li_maxdays, li_MAXRGPFRIRD
if not f_getNoOfDaysMINATDAP(li_mindays, ls_errormsg) then
	guo_func.msgbox("Warning!", ls_errormsg)
	post dynamic event ue_set_column("activationintendeddate")
	dw_header.setFocus()
	return -1
end IF

--VALIDASI F_GETNOOFDAYSMINATDAP
	
	string last_sqlcode, last_sqlerrtext
	
	select noOfDays
	  into :ai_noOfDays
	  from sysDaysParam
	 where dayParamName = 'MINATMPDEACP'
	 and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	using SQLCA;
	if SQLCA.sqlcode < 0 then
		as_errormsg = 'SQL Code: ' + string(SQLCA.sqlCode) + '~r~n' + SQLCA.sqlErrText
		return FALSE
	elseif SQLCA.sqlcode = 100 then
		as_errormsg = 'SQL Code: ' + string(SQLCA.sqlCode) + '~r~n' + 'The code [MINATMPDEACP] does not exist!'
		return FALSE
	end if
	return TRUE
		
--END VALIDASI F_GETNOOFDAYSMINATDAP

if not f_getNoOfDaysMAXATDAP(li_maxdays, ls_errormsg) then
	guo_func.msgbox("Warning!", ls_errormsg)
	post dynamic event ue_set_column("activationintendeddate")
	dw_header.setFocus()
	return -1	
end IF

--VALIDASI F_GETNOOFDAYSMAXTDAP
	
	string last_sqlcode, last_sqlerrtext
	select noOfDays
	  into :ai_noOfDays
	  from sysDaysParam
	 where dayParamName = 'MAXATMPDEACP'
	 and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	using SQLCA;
	if SQLCA.sqlcode < 0 then
		as_errormsg = 'SQL Code: ' + string(SQLCA.sqlCode) + '~r~n' + SQLCA.sqlErrText
		return FALSE
	elseif SQLCA.sqlcode = 100 then
		as_errormsg = 'SQL Code: ' + string(SQLCA.sqlCode) + '~r~n' + 'The code [MAXATMPDEACP] does not exist!'
		return FALSE
	end if
	return TRUE
	
--END VALIDASI F_GETNOOFDAYSMAXTDAP

if not f_getNoOfDaysMAXRGPFRIRD(li_MAXRGPFRIRD, ls_errormsg) then
	guo_func.msgbox("Warning!", ls_errormsg)
	post dynamic event ue_set_column("activationintendeddate")
	dw_header.setFocus()
	return -1	
end IF

--VALIDASI F_GETNOOFDAYSMAXGPFRIRD

string last_sqlcode, last_sqlerrtext
select noOfDays
  into :ai_noOfDays
  from sysDaysParam
 where dayParamName = 'MAXRGPFRIRD'
 and divisionCode = :gs_divisionCode
and companyCode = :gs_companyCode
using SQLCA;
if SQLCA.sqlcode < 0 then
	as_errormsg = 'SQL Code: ' + string(SQLCA.sqlCode) + '~r~n' + SQLCA.sqlErrText
	return FALSE
elseif SQLCA.sqlcode = 100 then
	as_errormsg = 'SQL Code: ' + string(SQLCA.sqlCode) + '~r~n' + 'The code [MAXRGPFRIRD] does not exist!'
	return FALSE
end if
return TRUE

--END VALDIASI

--==================================================
--end
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

/**-zar 05312010 - to avoid partial surrender of CPE **/
string ls_selected
int    li_ctr

for ll_row = 1 to dw_subscriber_stb.rowCount()
	ls_serialNo 		= trim(dw_subscriber_stb.object.serialNo[ll_row])
	ls_selected       = trim(dw_subscriber_stb.object.scanned[ll_row])
	
	if trim(ls_selected) = 'Y' then
		li_ctr++
	end if			
next	

if li_ctr > 0 and li_ctr < dw_subscriber_stb.rowCount() then
	is_msgno 	= 'Transaction error'
	is_msgtrail = "Surrendered CPE must be equal to the total number of subscribers' CPE." + &
					  "~r~nIf partially surrendered, please use Extension Disconnection w/o J.O prior to Application of P.D."
	is_sugtrail = 'Event : ue_save_applofmlineextpermdischdranddtl'
	return -1
end if	
/*********************************************************/


ldtme_graceperioddatefrom 	 	= datetime(relativeDate(date(guo_func.get_server_date()), li_mindays))	
ldtme_graceperioddateto 	 	= datetime(relativeDate(date(guo_func.get_server_date()), li_maxdays))	
ldtme_startOfAutoPermDiscDate = datetime(relativeDate(date(ldt_activationIntendedDate), li_MAXRGPFRIRD + 1))	

ll_stbRows = dw_detail.rowCount() 
if isnull(ll_stbRows) then ll_stbRows = 0
for ll_stbRow = 1 to ll_stbRows
	if trim(dw_detail.getItemString(ll_stbRow, "acquisitionTypeCode")) <> 'BUY' then
		ll_stbNotBuy	= ll_stbNotBuy	+ 1
	end if	
next
if isnull(ll_stbNotBuy) then ll_stbNotBuy = 0

ll_noOfSTBDeActivated = ll_stbRows
ll_noOfSTBPulledOut = ll_stbNotBuy

--Validation
if ls_acctno = '' or isnull(ls_acctno) then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = "Saving Subscriber Master : ~r~n Cannot save with unknown Account No."
	return -1
end if	

--preparation of columns
decimal{2} ld_mLineExtDeAcFee
decimal{2} ld_mLineCurrentMonthlyRate, ld_previousMonthlyRate, ld_DiscountRateDEACF
decimal{2} ld_extCurrentMonthlyRate, ld_extCurrentDailyRate, ld_mLineCurrentDailyRate
long ll_daysConsumed, ll_noOfDaysOfTheMonth 

decimal{2} ld_previousDailyRate, ld_mLineBaseDayRate, ld_extBaseDayRate, ld_amount

ld_mLineExtDeAcFee 			= 0.00
ld_MLineExtDeAcFeeDiscount 	= 0.00

--=====================================================================================================================
--
-- 												Saving of Installation, Sales and JO Details STB Serial Nos Tables
--
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


--perform computation here for billing purposes
if not iuo_subscriber.setAcctNo(ls_acctNo) then
	guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + iuo_subscriber.lastSQLErrText)
end if

ls_chargeTypeCode 			= iuo_subscriber.chargeTypeCode
ls_subsUserTypeCode 			= iuo_subscriber.subsUserTypeCode
ls_subscriberStatusCode 		= iuo_subscriber.subscriberStatusCode
ls_subsTypeCode 				= iuo_subscriber.subsTypeCode
ll_numberOfRooms 			= iuo_subscriber.numberOfRooms
ld_occupancyRate 				= iuo_subscriber.occupancyRate
ld_mLineCurrentMonthlyRate 	= iuo_subscriber.mLineCurrentMonthlyRate
ld_extCurrentMonthlyRate 	= iuo_subscriber.extCurrentMonthlyRate

if not iuo_subscriber.getmLineExtDeAcFee(ld_mLineExtDeAcFee) then
	is_msgno = 'SM-0000001'
	is_msgtrail = iuo_subscriber.lastSQLCode + "~r~n" + iuo_subscriber.lastSQLErrText
	is_sugtrail = 'Error produced by iuo_subscriber.getmLineInstallationFee()'
	return -1
end IF

--VALIDASI GETMLINEEXTDEACFEE
	
			lastMethodAccessed = 'getMLineExtDeacFee'
		
		select deactivationFee
		  into :ad_mLineExtDeAcFee
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
	
	--END VALIDASI GETMLINEEXTDEACFEE

if not iuo_subscriber.getPercentDiscount('DEACF', ld_DiscountRateDEACF) then
	is_msgno = 'SM-0000001'
	is_msgtrail = iuo_subscriber.lastSQLCode + "~r~n" + iuo_subscriber.lastSQLErrText
	is_sugtrail = 'Error produced by iuo_subscriber.getPercentDiscount()'
	return -1
end IF

--VALIDASI GETPERCENTDISCOUNT
	
	lastMethodAccessed = 'getPercentDiscount'

	select percentDiscount
	  into :ad_percent
	  from chargeTypeDiscountMaster
	 where chargeTypeCode = :chargeTypeCode
	 	and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	and arTypeCode = :as_arTypeCode
	 using SQLCA;
	if SQLCA.sqlcode < 0 then
		lastSQLCode = string(SQLCA.sqlcode)
		lastSQLErrText = SQLCA.sqlerrtext
		return FALSE
	elseif SQLCA.sqlcode = 100 then
		ad_percent = 0
	end if
	return TRUE
	
--END VALIDASI GETPERCENTDISCOUNT

ld_DiscountRateMLMSF = 0.00
if not iuo_subscriber.getPercentDiscount('MLMSF', ld_DiscountRateMLMSF) then
	is_msgno = 'SM-0000001'
	is_msgtrail = iuo_subscriber.lastSQLCode + "~r~n" + iuo_subscriber.lastSQLErrText
	is_sugtrail = 'Error produced by iuo_subscriber.getPercentDiscount()'
	return -1
end IF

--VALIDASI GETPERCENTDISCOUNT
	
	lastMethodAccessed = 'getPercentDiscount'

	select percentDiscount
	  into :ad_percent
	  from chargeTypeDiscountMaster
	 where chargeTypeCode = :chargeTypeCode
	 	and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	and arTypeCode = :as_arTypeCode
	 using SQLCA;
	if SQLCA.sqlcode < 0 then
		lastSQLCode = string(SQLCA.sqlcode)
		lastSQLErrText = SQLCA.sqlerrtext
		return FALSE
	elseif SQLCA.sqlcode = 100 then
		ad_percent = 0
	end if
	return TRUE
	
	--END VALIDASI GETPERCENTDISCOUNT

ld_DiscountRateEXMSF = 0.00
if not iuo_subscriber.getPercentDiscount('EXMSF', ld_DiscountRateEXMSF) then
	is_msgno = 'SM-0000001'
	is_msgtrail = iuo_subscriber.lastSQLCode + "~r~n" + iuo_subscriber.lastSQLErrText
	is_sugtrail = 'Error produced by iuo_subscriber.getPercentDiscount()'
	return -1
end IF

--VALIDASI GETPERCENTDISCOUNT
	
	lastMethodAccessed = 'getPercentDiscount'

	select percentDiscount
	  into :ad_percent
	  from chargeTypeDiscountMaster
	 where chargeTypeCode = :chargeTypeCode
	 	and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	and arTypeCode = :as_arTypeCode
	 using SQLCA;
	if SQLCA.sqlcode < 0 then
		lastSQLCode = string(SQLCA.sqlcode)
		lastSQLErrText = SQLCA.sqlerrtext
		return FALSE
	elseif SQLCA.sqlcode = 100 then
		ad_percent = 0
	end if
	return TRUE
	
	--END VALIDASI GETPERCENTDISCOUNT

integer li_billingDayOfMonth
if not f_getBillingDayOfMonth(li_billingDayOfMonth) then
	is_msgNo 	= 'SM-0000001'
	is_msgTrail = string(SQLCA.sqlCode) + '~r~n' + &
					  SQLCA.sqlErrText
	is_sugTrail = 'Function: f_getBillingDayOfMonth()'
	return -1
end IF

--VALIDASI F_GETBILLINGDAYOFMONTH
		select billingDayOfMonth
		  into :ad_day
		  from systemParameter
		  where divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		and rownum < 2
		using SQLCA;
		if SQLCA.sqlCode < 0 then
			return FALSE
		end if
		
		--default to every 10th of the month
		if isnull(ad_day) or ad_day = 0 then ad_day = 10
		
		return TRUE
		
	--END VALIDASI F_GETBILLINGDAYOFMONTH

if integer(string(ldt_preferreddatetimefrom, 'dd')) < li_billingDayOfMonth then
	ll_daysConsumed = integer(string(ldt_preferreddatetimefrom, 'dd')) - 1
else
	ll_daysConsumed =	0 - guo_func.getDaysConsumedFromGivenDate(ldt_preferreddatetimefrom)
end IF

--VALIDASI GETDAYSCOMSUEDFROMGIVENDATE
		date ldt_currentDate, ldt_noOfDays
		long li_year, li_month, li_day, li_days
		
		ldt_currentDate 			= 	date(adtm_date)
		li_year						=	year(ldt_currentDate) 
		li_month 					=	month(ldt_currentDate) 
		li_day						=	day(ldt_currentDate) 
		if li_month = 12 then
			li_year = li_year + 1
			li_month = 1
		else
			li_month 					=	li_month + 1
		end if
		ldt_noOfDays 				=	date(li_year, li_month, 1) 
		li_days						=	DaysAfter(ldt_currentDate, ldt_noOfDays)
		
		return li_days 
		
	--END VALIDASI GETDAYSCOMSUEDFROMGIVENDATE



ll_noOfDaysOfTheMonth	=	guo_func.get_month_days2(idt_tranDate)

--VALIDASI GET_MONTH_DAYS2
		long ll_return 
		date ld_lastDayofNextMonth
		integer li_month, li_year, li_nextMonth, li_nextMonthYear
		
		li_month = month(date(adtm_date))
		li_year = year(date(adtm_date))
		
		if li_month = 12 then
			li_nextMonth = 1
			li_nextMonthYear = li_year + 1
		else
			li_nextMonth = li_month + 1
			li_nextMonthYear = li_year
		end if
		
		ld_lastDayofNextMonth = RelativeDate(date(string(li_nextMonth) + '/1/' + string(li_nextMonthYear)), -1)
		ll_return = day(ld_lastDayofNextMonth) 
		
		return ll_return
	
	--END VALIDASI GET_MONTH_DAYS2

if is_isDigital  <> 'Y' then

	ld_mLineCurrentDailyRate	= 	(ld_mLineCurrentMonthlyRate / ll_noOfDaysOfTheMonth)
	ld_extCurrentDailyRate 	= 	(ld_extCurrentMonthlyRate / ll_noOfDaysOfTheMonth)
	ld_mLineBaseDayRate		= 	ld_mLineCurrentDailyRate
	ld_extBaseDayRate			= 	ld_extCurrentDailyRate
	ld_amount					=	( ll_daysConsumed * ( ld_mLineBaseDayRate - (ld_mLineBaseDayRate * (ld_DiscountRateEXMSF/100)) ) ) + &
										( ll_daysConsumed * ( ld_extBaseDayRate - (ld_extBaseDayRate * (ld_DiscountRateEXMSF/100)) ) )
else
	for ll_row = 1 to dw_detail.rowCount()
		ls_serialNo 		= trim(dw_detail.object.serialNo[ll_row])
		if not isnull(ls_serialNo)  and ls_serialNo <> '' then 
			ls_packageCode 	= dw_detail.object.packageCode[ll_row]
			ls_caSerialNo	 	= dw_detail.object.caSerialNo[ll_row]
			ls_itemCode	 	= dw_detail.object.itemCode[ll_row]
			ls_caItemCode	 	= dw_detail.object.caItemCode[ll_row]
			if not iuo_subscriber.setAcctNoDigital(as_acctNo,ls_packageCode) then
				is_msgNo 	= 'SM-0000001'
				is_msgTrail = iuo_subscriber.lastSQLCode + '~r~n' + &
								  iuo_subscriber.lastSQLErrText
				is_sugTrail = 'Object/Method: iuo_subscriber.setAcctNo()'
				return -1
			end if
			
			ld_mlineCurrentMonthlyRate		= 	iuo_subscriber.mLineCurrentMonthlyRate
			ld_mlineCurrentDailyRate 			= 	(ld_mlineCurrentMonthlyRate / ll_noOfDaysOfTheMonth)
			ld_mLineBaseDayRate				= 	ld_mlineCurrentDailyRate
			ld_amount							=	(ll_daysConsumed * ( ld_mLineBaseDayRate - (ld_mLineBaseDayRate * (ld_DiscountRateEXMSF/100)) ) )
			ld_totExtAmt 						=	ld_totExtAmt + ld_amount
						
			insert into proRatedBillTranDtl (
						tranNo,
						tranDate,
						acctNo,
						packageCode,
						caSerialNo,
						caItemCode,
						stbItemCode,
						stbSerialNo,
						baseDailyRate,
						tranTypeCode,
						processed,
						daysConsumption,
						consumptionAmount,
						divisionCode,
						companyCode)
				values (
						:is_tranNo,
						:idt_tranDate,
						:as_acctNo,
						:ls_packageCode,
						:ls_caSerialNo,
						:ls_caItemCode,
						:ls_itemCode,
						:ls_serialNo,
						:ld_mLineBaseDayRate,
						'DEACSUBS',
						'Y',
						:ll_daysConsumed,
						:ld_amount,
						:gs_divisionCode,
						:gs_companyCode)
				using SQLCA;
				if SQLCA.SQLCode < 0 Then
					is_msgno = "SM-0000001"
					is_msgtrail = "Inserting record at proRatedBillTranDtl(1) ~r~nSQLErrCode : " + String(SQLCA.SQLCode) +  "~r~nSQLErrText : " + SQLCA.SQLErrText
					is_sugtrail = "Call your system administrator."
					return -1	
				end If
		else
			continue
		end if	
	next
	ld_amount = ld_totExtAmt 
	ld_extCurrentMonthlyRate			=     0.00
	ld_extCurrentDailyRate			=	0.00
	ld_extBaseDayRate					=	0.00
	
	--zar 06042010 -
	/***************moved here inside the Digital Case***************/
	/***************for analog, must be inserted during cron process*/
	string 	ls_tranNo
	long 	ll_tranNo
	
	if not guo_func.get_nextnumber('DEACSUBS', ll_tranNo, 'WITH LOCK') then
		return -1
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
		
		return TRUE
		
	--END VALLIDASI GET_NEXTNUMBER
	
	ls_tranNo = string(ll_tranNo, '00000000')
	insert into deactivationTranHdr (
					tranno,
					tranDate,
					acctNo,
					locationCode,
					packageCode,
					disconnectionType,
					jobOrderNo,
					noOfExtension,
					noOfSTBDeActivated,
					noOfSTBPulledOut,
					mLineCurrentMonthlyRate,
					mLineCurrentDailyRate,
					mLineBaseDailyRate,
					mLineAmount,
					extCurrentMonthlyRate,
					extCurrentDailyRate,
					extBaseDailyRate,
					extAmount,
					daysConsumption,
					mLineExtDeAcFee,
					mLineExtDeAcFeeDiscount,
					extendedFeeAmount,
					processed,
					useradd,
					dateadd,
					divisionCode,
					companyCode,
					deactivationFee,
					deacFeeDiscount,
					applRefNo)
		  values (
					:ls_tranNo,
					:idt_tranDate,
					:ls_acctNo,
					:ls_locationCode,
					:ls_packageCode,
					'MAN',
					'00000000',
					:ll_noOfExtension,
					:ll_noOfSTBDeActivated,
					:ll_noOfSTBPulledOut,
					:ld_mLineCurrentMonthlyRate,
					:ld_mLineCurrentDailyRate,
					:ld_mLineBaseDayRate,
					:ld_amount,
					:ld_extCurrentMonthlyRate,
					:ld_extCurrentDailyRate,
					:ld_extBaseDayRate,
					:ld_amount,
					:ll_daysConsumed,
					0.00,
					0.00,
					0.00,
					'N',
					:gs_username,
					getdate(),
					:gs_divisionCode,
					:gs_companyCode,
					0.00,
					0.00,
					:is_tranNo)
			using SQLCA;
	if SQLCA.SQLCode < 0 Then
		is_msgno = "SM-0000001"
		is_msgtrail = "Inserting record at deactivationTranHdr(1) ~r~nSQLErrCode : " + String(SQLCA.SQLCode) +  "~r~nSQLErrText : " + SQLCA.SQLErrText
		is_sugtrail = "Call your system administrator."
		return -1	
	end If
	
	if not guo_func.set_number('DEACSUBS', ll_tranNo) then
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
	
	--END VALIASI SET_NUMBER
	//*************moved to here*******************/	
	
end if


INSERT INTO applOfDeactivationTranHdr
	(
		tranNo,
		tranDate,
		acctNo,
		locationCode,
		chargeTypeCode,
		subsUserTypeCode,
		packageCode,
		subscriberStatusCode,
		subsTypeCode,
		numberOfRooms,
		occupancyRate,
		noOfExtension,
		noOfSTBDeActivated,
		noOfSTBPulledOut,	
		disconnectionType,
		baseAmount,
		daysConsumption,
		amount,
		mLineExtDeAcFee,
		mLineExtDeAcFeeDiscount, 
		extendedFeeAmount,
		processed,
		reason,
		disconnectionRemarksCode,
		activationIntendedDate,
		graceperioddatefrom,
		graceperioddateto,
		startOfAutoPermDiscDate,
		requestedBy,
		mLineCurrentMonthlyRate,
		extCurrentMonthlyRate,
		mlineCurrentDailyRate,
		extCurrentDailyRate,	
		referenceJONo,
		specialInstructions,
		applicationStatusCode,
		preferreddatetimefrom,
		preferreddatetimeto,
		dateadd,
		useradd,
		divisionCode,
		companyCode,
		deactivationFee,
		deacFeeDiscount
	)
VALUES
	(
		:is_tranNo,
		:idt_tranDate,
		:ls_acctNo,
		:ls_locationCode,
		:ls_chargeTypeCode,
		:ls_subsUserTypeCode,
		:ls_packageCode,	
		:ls_subscriberStatusCode,
		:ls_subsTypeCode,
		:ll_numberOfRooms,
		:ld_occupancyRate,
		:ll_noOfExtension,
		:ll_noOfSTBDeActivated,
		:ll_noOfSTBPulledOut,
		'DEA',
		:ld_mLineBaseDayRate,
		:ll_daysConsumed,
		:ld_amount,
		:ld_mLineExtDeAcFee,
		:ld_mLineExtDeAcFeeDiscount, 
		:ld_extendedFeeAmount,
		'N',
		:ls_reason,
		:ls_disconnectionRemarksCode,
		:ldt_activationIntendedDate,
		:ldtme_graceperioddatefrom,
		:ldtme_graceperioddateto,
		:ldtme_startOfAutoPermDiscDate,
		:ls_requestedBy,
		:ld_mLineCurrentMonthlyRate,
		:ld_extCurrentMonthlyRate,
		:ld_mlineCurrentDailyRate,
		:ld_extCurrentDailyRate,
		null,
		:ls_specialInstructions,
		'FJ',
		:ldt_preferreddatetimefrom,
		:ldt_preferreddatetimeto,
		getdate(),
		:gs_UserName,
		:gs_divisionCode,
		:gs_companyCode,
		0.00,
		0.00
	)
USING SQLCA;

if SQLCA.SQLCode = -1 then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = "Saving applOfDeactivationTranHdr ~nSQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
	return -1
end if


long ll_rows, ll_loop, ll_applOfExtTranDtl_qty
string ls_acquisitionTypeCode
dec{2} ld_rate

string ls_controlNo, ls_isPrimary
long ll_BoxIDNo


ll_rows = dw_subscriber_stb.rowCount()
uo_stb luo_stb
luo_stb = create using "uo_stb"

--==================================================
--all stbs scanned must be deactivated, 
--removed from stbPackages and locationCode updated 
--to userLocation
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

for ll_loop = 1 to ll_rows
		
	ls_serialNo = trim(dw_subscriber_stb.getItemString(ll_loop, 'serialNo'))
	ls_scanned 	= dw_subscriber_stb.getItemString(ll_loop, 'scanned')
	
	if not isnull(ls_serialNo) and ls_serialNo <> '' then 

		if not luo_stb.setSerialNo(ls_serialNo) then
			guo_func.msgbox("Warning!", luo_stb.lastSQLCode + "~r~n" + luo_stb.lastSQLErrText)		
			return -1
		end IF
		
		--VALIDASI IUO_STB.SETSERIALNO
		
		serialNo = trim(as_serialno)

			--check if existing
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
		
		--END VALIDASI IUO_STB.SETSERIALNO

		ls_itemCode 				= luo_stb.itemCode
		ll_BoxIDNo 				= luo_stb.BoxIdNo	
		ls_acquisitionTypeCode 	= luo_stb.acquisitionTypeCode 
		ls_acquiredBefore2003   	= luo_stb.acquiredBefore2003
				
		ls_surrendered = ls_scanned
	
		--==================================================
		--deactivation of stb will be done via cron
		--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		insert into applOfDeactivationTranDtl
			(tranNo,
			 itemCode,
			 boxIDNo,
			 serialNo,
			 acquisitionTypeCode,
			 acquiredBefore2003,
			 surrendered,
			 divisionCode,
			 companyCode)
		values
			(:is_tranNo,
			 :ls_itemCode,
			 :ll_boxIDNo,
			 :ls_serialNo,
			 :ls_acquisitionTypeCode,
			 :ls_acquiredBefore2003,
			 :ls_surrendered,
			 :gs_divisionCode,
			 :gs_companyCode)
		using SQLCA;	
		if SQLCA.SQLCode <> 0 then
			is_msgNo    = 'SM-0000001'
			is_msgTrail = "insert in applOfDeactivationTranDtl "+"SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
			return -1	
		end if	
		
		if ls_scanned = 'Y' then 
			
			if is_isDigital  =  'Y' then
				ls_packageCode	= dw_subscriber_stb.getItemString(ll_loop, 'packageCode')
				ls_isPrimary		= dw_subscriber_stb.getItemString(ll_loop, 'isPrimary')
				
				insert into deactivationTranDtl (
						tranNo,
						itemCode,
						boxIdNo,
						serialNo,
						acquisitionTypeCode,
						divisionCode,
						companyCode,
						packageCode,
						isPrimary)
				  values (
						:ls_tranNo,
						:ls_itemCode,
						:ll_boxIDNo,
						:ls_serialNo,
						 :ls_acquisitionTypeCode,
						:gs_divisionCode,
						:gs_companyCode,
						:ls_packageCode,
						:ls_isPrimary)
				using SQLCA;
				if SQLCA.SQLCode <> 0 Then	
					is_msgno = "SM-0000001"
					is_msgtrail = "Inserting record at deactivationTranDtl ~r~nSQLErrCode : " + String(SQLCA.SQLCode) +  "~r~nSQLErrText : " + SQLCA.SQLErrText
					is_sugtrail = "Call your system administrator."
					return -1
				end If				
						
			else
				setNull(ls_packageCode)
				setNull(ls_isPrimary)							
			end if
					
			if not luo_stb.getSCSRequestNextTranNo() then
				is_msgno = 'SM-0000001'
				is_msgtrail = luo_stb.lastSQLCode + "~r~n" + luo_stb.lastSQLErrText
				is_sugtrail = 'Error produced by luo_stb.getSCSRequestNextTranNo()'
				return -1
			end IF 
			
			--validasi getSCSRequstNextTranNo
			long ll_tranNo
			string ls_errormsg
			if not guo_func.get_nextnumber('SCSREQUEST', ll_tranno, 'WITH LOCK') then
				lastSQLCode = '-2'
				lastSQLErrText = 'Could not obtain the next SCS Request No.'
				Return False
			end IF
			
			--validasi get_nextNumber
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
			
			--end validasi get_nextNumber
			
			
			scsRequestNextTranNo = ll_tranNo
			
			Return True
			
			--end validasi getSCSRequestNextTranNo
		 
			luo_stb.setSCSRequestSource(ls_tranTypeCode)	 	
		 
			--step 2
			-- now deactivate stb
			if not luo_stb.deActivate() then
				guo_func.msgbox("Warning!", luo_stb.lastSQLCode + "~r~n" + luo_stb.lastSQLErrText)		
			end if
			
			-- update tranno for scsRequest
			if not luo_stb.setSCSRequestTranNo() then
				is_msgno = 'SM-0000001'
				is_msgtrail = luo_stb.lastSQLCode + "~r~n" + luo_stb.lastSQLErrText
				is_sugtrail = 'Error produced by luo_stb.setSCSRequestTranNo()'
				return -1
			end IF
			
			--VALIDASI IUO_STB.SETSCSREQUESTTRANNO
			
			if not guo_func.set_number('SCSREQUEST', scsRequestNextTranNo) then	
				lastSQLCode = '-2'
				lastSQLErrText = 'Could not set the next SCS Request No.'
				Return False
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
			
			Return TRUE
			
			--END VALIDASI SETSCSREQUESTTRANNO
			
			if ls_acquisitionTypeCode <> 'BUY' then
				
				update serialNoMaster 
					set locationCode = :ls_locationCode,
						 serialNoStatusCode = 'AV',
						 acctNo = null
				 where serialNo = :ls_serialNo
					and itemCode = :ls_itemCode
				 	and divisionCode = :gs_divisionCode
					and companyCode = :gs_companyCode
				using SQLCA;		
				if SQLCA.SQLCode = -1 then
					is_msgNo    = 'SM-0000001'
					is_msgTrail = "Error updating serialNoMaster. "+"SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
					return -1	
				end if	
				
				if is_isDigital = 'Y' then
					
					ls_caserialNo 	= dw_subscriber_stb.getItemString(ll_loop, 'caserialNo')
					ls_caItemCode	= dw_subscriber_stb.getItemString(ll_loop, 'caitemCode')
					
					update serialNoMaster 
						set locationCode = :ls_locationCode,
							 serialNoStatusCode = 'AV',
							 acctNo = null
					 where serialNo = :ls_caserialNo
						and itemCode = :ls_caItemCode
						and divisionCode = :gs_divisionCode
						and companyCode = :gs_companyCode
					using SQLCA;		
					if SQLCA.SQLCode = -1 then
						is_msgNo    = 'SM-0000001'
						is_msgTrail = "Error updating serialNoMaster. "+"SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
						return -1	
					end if	
					
				end if
				
				--zar 06212010 -for digipick
				if is_isdigital = 'Y' then
					
					--snap shot muna
					insert into applOfDeactivationTranDtlDGP
						(tranNo, 
						 stbItemCode, 
						 stbSerialNo, 
						 caItemCode, 
						 caSerialNo, 
						 packageCode, 
						 monthlyRate, 
						 divisionCode, 
						 companyCode)
					select :ls_tranNo, 
							 cpe.itemCode, 
							 cpe.serialNo, 
							 cpe.caItemCode, 
							 cpe.caSerialNo, 
							 spc.packageCode, 
							 pm.monthlyRate, 
							 :gs_divisioNCode,
							 :gs_companyCode
					from   subscriberCPEMaster cpe 
							 inner join subsSTBSPChanMaster spc on spc.itemCode = cpe.itemCode
																		  and spc.serialNo = cpe.serialNo
																		  and spc.divisionCode = cpe.divisionCode
																		  and spc.companyCode  = cpe.companyCode
							 inner join arPackageMaster pm on pm.packageCode = spc.packageCode
																		  and pm.divisionCode = spc.divisionCode
																		  and pm.companyCode  = spc.companyCode
					where  cpe.serialNo = :ls_serialNo
					and    cpe.acctNo   = :ls_acctNo
					and    cpe.divisionCode = :gs_divisionCode
					and    cpe.companyCode  = :gs_companyCode
					using  SQLCA;
					if SQLCA.SQLCode < 0 then
						is_msgNo    = 'SM-0000001'
						is_msgTrail = "Error in SNAP SHOT of DIGIPICK - PACKAGES..."+ &
										  "~r~nSQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
						return -1						
					end if						
					
					
					if not trigger event ue_deactivate_digipick(luo_stb, ls_acctNo, ls_tranNo) then
						return -1
					end if	
					
					--VALIDASI UE_DEACTIVATE_DIGIPICK
					
					long   ll_loop, ll_rows, ll_daysConsumption, ll_noOfDaysOfTheMonth
					string ls_packageCode, ls_itemCode, ls_serialNo, ls_tranNo, ls_caItemCode, ls_caSerialNo
					dec{2} ld_totPackageMonthlyRate, ld_totPackageDailyRate, ld_totExtendedAmount
					dec{2} ld_packageMonthlyRate, ld_packageDailyRate, ld_extendedAmount
					
					long 	 ll_tranNo
					string ls_deacTranNo
					
					
					datastore 			 ds_digiPickPackage 
					ds_digiPickpackage = create datastore
					ds_digiPickpackage.DataObject = "ds_subs_digipickpackage"
					ds_digiPickpackage.setTransObject(SQLCA)
					
					--validasi query ds_subs_digipickpackage
					  SELECT subsSTBSpChanMaster.acctNo,   
					         subsSTBSpChanMaster.tranNo,   
					         subsSTBSpChanMaster.PackageCode,   
					         subsSTBSpChanMaster.serialNo,   
					         subsSTBSpChanMaster.itemCode,   
					         subscriberCPEMaster.caSerialNo,   
					         subscriberCPEMaster.caItemCode  
					    FROM subsSTBSpChanMaster,   
					         subscriberCPEMaster  ,
							arpackagemaster
					   WHERE ( subscriberCPEMaster.acctno = subsSTBSpChanMaster.acctNo ) and  
					         ( subscriberCPEMaster.serialNo = subsSTBSpChanMaster.serialNo ) and  
					         ( subscriberCPEMaster.itemCode = subsSTBSpChanMaster.itemCode ) and  
							( arpackagemaster.packagecode = subsSTBSpChanMaster.packagecode) and
					         ( ( subsSTBSpChanMaster.acctNo = :as_acctNo ) AND  
					         ( subsSTBSpChanMaster.serialNo = :as_serialNo ) AND  
							( arpackagemaster.isdigital = 'Y') and
							( subsSTBSpChanMaster.expirationdate < getdate()) and
					         ( subsSTBSpChanMaster.divisionCode = :as_divisionCode ) AND  
					         ( subsSTBSpChanMaster.companyCode = :as_companyCode ) )    and
						(subsstbspchanmaster.trantypecode = 'ADDDIGIPICK ')
					--end validasi ds_subs_digipickpackage
					
					ll_rows = ds_digiPickPackage.retrieve(as_acctNo, auo_stb.serialNo, gs_divisionCode, gs_companyCode)
					if ll_rows = 0 then
						return true
					end if	
					
					if not guo_func.get_nextnumber('DEACDIGIPICK', ll_tranNo, 'WITH LOCK') then
						return false
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
						
				--END guo_func.get_nextnumber
					
					ls_deacTranNo = string(ll_tranNo,'00000000')
					
					if not guo_func.set_number('DEACDIGIPICK', ll_tranNo) then
						return false
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
						
					--END set_number
					
					
					integer li_billingDayOfMonth
					if not f_getBillingDayOfMonth(li_billingDayOfMonth) then
						is_msgNo 	= 'SM-0000001'
						is_msgTrail = string(SQLCA.sqlCode) + '~r~n' + &
										  SQLCA.sqlErrText
						is_sugTrail = 'Function: f_getBillingDayOfMonth()'
						return false
					end IF
					
					--validasi f_getbillingDayOfMonth
					select billingDayOfMonth
					  into :ad_day
					  from systemParameter
					  where divisionCode = :gs_divisionCode
					and companyCode = :gs_companyCode
					and rownum < 2
					using SQLCA;
					if SQLCA.sqlCode < 0 then
						return FALSE
					end if
					
					--default to every 10th of the month
					if isnull(ad_day) or ad_day = 0 then ad_day = 10
					
					return TRUE
					
					--end validasi f_getbillingDayOfMonth
					
					if integer(string(date(guo_func.get_server_date()), 'dd')) < li_billingDayOfMonth then
						ll_daysConsumption = integer(string(date(guo_func.get_server_date()), 'dd')) - 1
					else
						ll_daysConsumption =	0 - guo_func.getDaysConsumedFromGivenDate(guo_func.get_server_date())
					end IF
					
					--validasi getDaysConsumedFromGivenDate
					date ldt_currentDate, ldt_noOfDays
					long li_year, li_month, li_day, li_days
					
					ldt_currentDate 			= 	date(adtm_date)
					li_year						=	year(ldt_currentDate) 
					li_month 					=	month(ldt_currentDate) 
					li_day						=	day(ldt_currentDate) 
					if li_month = 12 then
						li_year = li_year + 1
						li_month = 1
					else
						li_month 					=	li_month + 1
					end if
					ldt_noOfDays 				=	date(li_year, li_month, 1) 
					li_days						=	DaysAfter(ldt_currentDate, ldt_noOfDays)
					
					return li_days 
				
					--end getDaysConsumedFromGivenDate
	
					ll_noOfDaysOfTheMonth =	guo_func.get_month_days2(guo_func.get_server_date())
					
					--validasi get_month_days2
	
					long ll_return 
					date ld_lastDayofNextMonth
					integer li_month, li_year, li_nextMonth, li_nextMonthYear
					
					li_month = month(date(adtm_date))
					li_year = year(date(adtm_date))
					
					if li_month = 12 then
						li_nextMonth = 1
						li_nextMonthYear = li_year + 1
					else
						li_nextMonth = li_month + 1
						li_nextMonthYear = li_year
					end if
					
					ld_lastDayofNextMonth = RelativeDate(date(string(li_nextMonth) + '/1/' + string(li_nextMonthYear)), -1)
					ll_return = day(ld_lastDayofNextMonth) 
					
					return ll_return
				
					--end get_month_days2
					
					ld_totPackageMonthlyRate = 0
					ld_totPackageDailyRate   = 0
					ld_totExtendedAmount     = 0
					
					
					for ll_loop = 1 to ll_rows
						
						ls_packageCode = ds_digiPickpackage.object.packagecode[ll_loop] 
						ls_itemcode    = ds_digiPickpackage.object.itemcode[ll_loop]
						ls_serialNo    = ds_digiPickpackage.object.serialno[ll_loop]
						
						ls_caItemCode	= ds_digiPickpackage.object.caitemcode[ll_loop]
						ls_caSerialNo	= ds_digiPickpackage.object.caserialno[ll_loop]	
						ls_tranNo		= ds_digiPickpackage.object.tranno[ll_loop]
							
						select monthlyRate into :ld_packageMonthlyRate
						from   arpackageMaster
						where  packageCode = :ls_packageCode
						and    divisionCode = :gs_divisionCode
						and    companyCode  = :gs_companyCode
						using  SQLCA;
						if SQLCA.SQLCode <> 0 then
							is_msgNo 	= 'SM-0000001'
							is_msgTrail = string(SQLCA.SQLCode) + '~r~n' + SQLCA.SQLErrText + &
											 '~r~nerror from ue_deactivate_digipick()'+ &
											 'select record to table [arpackageMaster]'
							return false
						end if		
						
						--ld_packageMonthlyRate   = dw_curr_pack.getItemDecimal(ll_loop,'monthlyrate')
						ld_packageDailyRate	   = (ld_packageMonthlyRate / ll_noOfDaysOfTheMonth)
						ld_extendedAmount		   = ld_packageDailyRate * ll_daysConsumption
						
						ld_totPackageMonthlyRate = ld_totPackageMonthlyRate + ld_packageMonthlyRate
						ld_totPackageDailyRate   = ld_totPackageDailyRate + ld_packageDailyRate
						ld_totExtendedAmount     = ld_totExtendedAmount + ld_extendedAmount
					
						insert into digiPickDeactivationTranDtl
							(tranNo,
							 packageCode,
							 stbItemCode,
							 stbSerialNo,
							 caItemCode,
							 caSerialNo,
							 daysConsumption,
							 packageMonthlyRate,
							 packageDailyRate,
							 extendedAmount,
							 companyCode,
							 divisionCode)
						values
							(:ls_deacTranNo,
							 :ls_packageCode,
							 :ls_itemCode,
							 :ls_serialNo,
							 :ls_caItemCode,
							 :ls_caSerialNo,
							 :ll_daysConsumption,
							 :ld_packageMonthlyRate,
							 :ld_packageDailyRate,
							 :ld_extendedAmount,
							 :gs_companyCode,
							 :gs_divisionCode)
						using SQLCA;	 
						if SQLCA.SQLCode <> 0 then
							is_msgNo			= 'SM-0000001'
							is_msgTrail		= 'Error in SQL-INSERT [digiPickActivationTranDtl]...' + &
												  '~r~n~r~nSQL Error Code : ' + string(SQLCA.SQLCode) + &
												  '~r~nSQL Error Text : ' + SQLCA.SQLErrText
							is_sugTrail	= 'error from [ue_deactivate_digipick]... Please inform your system administrator.'
							return false
						end if
						
						delete from subsSTBSpChanMaster
						where  tranNo = :ls_tranNo
						and    tranTypeCode = 'ADDDIGIPICK'
						and    packageCode  = :ls_packageCode
						and    acctNo       = :as_acctNo
						using  SQLCA;
						if SQLCA.SQLCode <> 0 then
							is_msgNo 	= 'SM-0000001'
							is_msgTrail = string(SQLCA.SQLCode) + '~r~n' + SQLCA.SQLErrText + &
											 '~r~nerror from ue_deactivate_digipick()'+ &
											 'delete record to table [subsSTBSpChanMaster]'
							return false
						end if		
						
					next
					
					insert into digiPickDeactivationTranHdr
						(tranNo,
						 tranTypeCode,
						 refTranNo,
						 tranDate,
						 acctNo,
						 userAdd,
						 dateAdd,
						 companyCode,
						 divisionCode,
						 daysConsumption,
						 additionalPackageFee,
						 packageMonthlyRate,
						 packageDailyRate,
						 extendedAmount,
						 preferredDateStart,
						 processed,
						 processedByCron)
					values
						(:ls_deacTranNo,
						 'DEACSUBS',
						 :as_tranNo,
						 :idt_tranDate,
						 :as_acctNo,
						 :gs_userName,
						 getDate(),
						 :gs_companyCode,
						 :gs_divisionCode,
						 :ll_daysConsumption,
						 0,
						 :ld_totPackageMonthlyRate,
						 :ld_totPackageDailyRate,
						 :ld_totExtendedAmount,
						 :idt_tranDate,
						 'N',
						 'Y')
					using SQLCA;	 
					if SQLCA.SQLCode <> 0 then
						is_msgNo			= 'SM-0000001'
						is_msgTrail		= 'Error in SQL-INSERT [digiPickActivationTranHdr]...' + &
											  '~r~n~r~nSQL Error Code : ' + string(SQLCA.SQLCode) + &
											  '~r~nSQL Error Text : ' + SQLCA.SQLErrText
						is_sugTrail	= 'error from [ue_deactivateDigiPick]... Please inform your system administrator.'
						return false
					end if
					
					return TRUE
					
					--END VALIDASI UE_DEACTIVATE_DIGIPICK
					
				end if
				

				delete from subscriberCPEMaster 
					where acctNo = :ls_acctNo 
					and serialNo = :ls_serialNo 
					and itemCode = :ls_itemCode	
					and divisionCode = :gs_divisionCode
					and companyCode = :gs_companyCode
				using SQLCA;			
				if SQLCA.SQLCode = -1 then
					is_msgNo    = 'SM-0000001'
					is_msgTrail = "Error deleteing record from subscriberCPEMaster. "+"SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
					return -1	
				end if	
				
			end if
			
			delete from stbPackages
				where serialNo = :ls_serialNo
				and divisionCode = :gs_divisionCode
				and companyCode = :gs_companyCode
			using SQLCA;
			if SQLCA.SQLCode = -1 then
				is_msgNo    = 'SM-0000001'
				is_msgTrail = "Error deleteing record from stbPackages. "+"SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
				return -1	
			end if	
								
					
		end if
		
	end if
	
next

return 0


--END VALIDASI

if trigger event ue_save_subsInitialPayment(ls_acctno, ld_deacFee) = -1 then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = "Saving subsInitialPayment ~nSQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
	return -1
end IF

--VALIDASI UE_SAVE_SUBINITIALPAYMENT

long ll_priority, ll_row,  ll_rows, ll_loop
string ls_acctno, ls_arTypeCode, ls_currency
dec{2} ld_amount, ld_rate

ls_acctno = trim(as_acctno)

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
				ad_applicationFee = ad_applicationFee + ld_amount
		end choose
	end if
next

return 0


--END VALIDASI UE_SAVE_SUBINITIALPAYMENT

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
--end

return TRUE

--end validasi uo_subs_advar.setAcctNo

if	This.Event ue_applyOCBalances(ld_deacFee) <> 0 then
	return -1	
end IF

--VALIDASI UE_APPLYOCBALANCE

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
end if

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
	if not uo_subs_advar.insertNewAr(is_tranno, is_transactionID, 'DEACF', ad_applicationFee, idt_trandate, string(idt_trandate, 'mmm yyyy'), &
												iuo_subscriber.currencyCode, iuo_currency.conversionRate) then
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
								
								--validasi f_getArTypeRevAccount
								
								--==================================================
									--NGLara | 04-26-2008
									--This function is primarily being used by Billing
									--- computation...
									--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
									
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
									
									Return True

								
								--end validasi f_getArType_revAccount
								
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
				
				--validasi set_number

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
				
				--end validasi set_number
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


if ll_noOfStbRowsScanned <> ll_noOfStbRows then
	ll_stbVariance = (ll_noOfStbRows - ll_noOfStbRowsScanned)
	guo_func.msgBox("Scanned STB Variance.", String( ll_stbVariance  ,"###,###")+" STB(s) for this subscriber has not been scanned.")	
end if



return 0


--END BUTTON SAVE

--END VALIDASI IF  gs_divisioncode <> 'DAINT' or gs_divisioncode <> 'DACTV' or gs_divisioncode <> 'ACINT'