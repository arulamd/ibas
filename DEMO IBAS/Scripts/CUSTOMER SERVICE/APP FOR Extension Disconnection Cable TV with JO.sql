opensheetwithparm(w_application_for_extension_discwjo,'CTV', w_mdiFrame, 0, original!)

---EVENT OPEN FORM

is_serviceType = message.stringParm
is_serviceType = CTV

--center the window
uo_center_window luo_center_window
luo_center_window = create uo_center_window
luo_center_window.f_center(this)
// ---**** end ***--- //

idw_application_for_ext_dtl = dw_detail
idw_reqInitPayment = dw_reqinitpayment
iw_parent = this

dw_header.settransobject(SQLCA)
idw_application_for_ext_dtl.settransobject(SQLCA) 
idw_reqInitPayment.settransobject(SQLCA) 

iuo_subscriber = create uo_subscriber_def

--QUERY FORM DW_HEADER

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
			  0 noOfSTB,  ''packageName, space(5)locationCode, space(50) requestedBy, space(100) reason
        FROM applofexttranhdr    

--END QUERY FORM DW_HEADER
        
--QUERY FORM DW_DETAIL
        
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

--END QUERY FORM DW_DETAIL


--QUERY FORM DW_SUBCRIBER_STB

SELECT  subscriberCPEMaster.serialno ,
		  subscriberCPEMaster.boxidno ,
		  subscriberCPEMaster.acquisitionTypeCode , caSerialNo, packagecode,caItemCode,
		  '' scanned, isPrimary    
	FROM subscriberCPEMaster      
  WHERE (subscriberCPEMaster.cpeTypeCode = 'STB') and (subscriberCPEMaster.acctno = :as_acctno )   

--END QUERY DW_SUBCRIBER_STB
  
  
--BUTTON NEW
  
  string ls_AcctNo
long ll_row, ll_priority	
decimal{2} ld_amount, ld_stbdeposit, ld_materialsstbadvances, ld_installationfeesadvances, ld_totalrequiredinitialpayment

--reset datawinw so no duplicates will happen
idw_ReqInitPayment.reset()

--insert EXTF - Advance Payment for Installation Fees
select priority 
into :ll_priority	
from arTypeMaster 	
where arTypeCode = 'EXTDF' 	
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
idw_ReqInitPayment.setItem( ll_row, "arTypeCode", 'EXTDF' )
idw_ReqInitPayment.setItem( ll_row, "amount", 0.00 )
idw_ReqInitPayment.setItem( ll_row, "priority", ll_priority )

idw_ReqInitPayment.acceptText()

long ll_currentRow, ll_acctno, ll_applExt
string ls_acctno, ls_applExt
datetime ldt_date

dw_header.insertRow(0)

if not guo_func.get_nextnumber('APPLEXTD', ll_applExt, "") then
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

--END GET_NEXTNUMBER

ls_applExt = string(ll_applExt, '00000000')
ll_currentRow = dw_header.getRow()

ldt_date = Datetime(today(),now())

--Set default Values
dw_header.setitem(1 , "tranNo", ls_applExt) 
dw_header.setitem(1 , "tranDate", guo_func.get_server_date()) 
dw_header.setitem(1,  "dateadd", ldt_date) 

dataWindowChild ldw_location
dw_header.getChild("locationCode", ldw_location)
ldw_location.setTransObject(SQLCA);
ldw_location.retrieve(gs_companyCode)

pb_new.enabled = false
pb_close.enabled = false

pb_save.enabled = true
pb_cancel.enabled = true


--END BUTTON NEW

--EVENT SEARCH BUTTON ACCTNO

long ll_row, ll_success, ll_count, ll_ctr
string ls_search, ls_result, ls_acctNo, ls_packageName

string ls_subscriberName, ls_serviceAddress, ls_billingAddress
string ls_package, ls_generalPackage
string ls_subscriberStatus, ls_chargeType, ls_primary
string ls_subscriberType, ls_subscriberUserType
decimal{2} ld_occupancyRate, ld_monthlyMlineFee, ld_monthlyExtFee
long ll_noOfExt, ll_noOfSTB, ll_noOfApplTransfer

str_search str_s

ls_search = trim(as_search)
ll_row = dw_header.getrow()


choose case ls_search
	case "acctno"
		str_s.serviceType = is_serviceType
		str_s.s_dataobject = "dw_search_acctno_subsname"
		str_s.s_return_column = "acctno"
		str_s.s_title = "Search For Subscribers"
		openwithparm(w_search_subscriber,str_s)

		ls_result = trim(Message.StringParm)				
		if ls_result = '' or isNull(ls_result)then			
			return
		end if
		dw_header.setitem(ll_row,'acctno', ls_result)
		ls_acctNo = ls_result
		
		select count(acctNo) into :ll_count from applOfExtDiscTranHdr
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
			guo_func.MsgBox('Pending Application Found...', 'This account has a pending Application for [Extension Disconnection],'+&
								 ' please verify the transaction on JO Monitoring...')
			return					 
		end if	

		if not iuo_subscriber.setAcctNo(ls_acctNo) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + iuo_subscriber.lastSQLErrText)
			return					 
		end if
		
		is_isDigital = iuo_subscriber.isDigital
		if is_isDigital = 'Y' then
			dw_subscriber_stb.dataObject = 'dw_subscriber_deac_digital'
			dw_detail.dataObject 			= 'dw_subscriber_unit_disc_dtl'
			ls_primary = 'N'
			//openwithparm(w_digital_subs_package,iuo_subscriber.acctNo)
		else
			dw_subscriber_stb.dataObject = 'dw_subscriber_ext_disc_stb'
			dw_detail.dataObject 			= 'dw_subscriber_ext_disc_dtl'
			ls_primary = 'Y'
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
		
		--billing address
		if not iuo_subscriber.getBillingAddress(ls_billingAddress) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return					 
		end if
		dw_header.setItem( 1, "billingAddress", ls_billingAddress )
		
		--package 
		if not iuo_subscriber.getPackageName(ls_package) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return					 
		end if
		dw_header.setItem( 1, "package", ls_package )		
		
		--general package 
		if not iuo_subscriber.getGeneralPackageName(ls_generalPackage) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return					 
		end if
		dw_header.setItem( 1, "generalPackage", ls_generalPackage )		
		
		--subscriber status
		if not iuo_subscriber.getSubscriberStatusName(ls_subscriberStatus) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return					 
		end if
		dw_header.setItem( 1, "subscriberStatus", ls_subscriberStatus )				
		
		--customer type
		if not iuo_subscriber.getchargeTypeName(ls_chargeType) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return					 
		end if
		dw_header.setItem( 1, "chargeType", ls_chargeType )				
		
		--subscriber Type
		if not iuo_subscriber.getSubsTypeName(ls_subscriberType) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return					 
		end if
		dw_header.setItem( 1, "subscriberType", ls_subscriberType )				
		
		--subscriber User Type
		if not iuo_subscriber.getSubsUserTypeName(ls_subscriberUserType) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return					 
		end if
		dw_header.setItem( 1, "subscriberUserType", ls_subscriberUserType )				
		
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
		
		--monthly Ext Fee
		if not iuo_subscriber.getExtMonthlyRate(ld_monthlyExtFee) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return					 
		end if
		dw_header.setItem( 1, "monthlyExtFee", ld_monthlyExtFee )							
		
		--long ll_noOfExt
		if not iuo_subscriber.getnoofactiveext(ll_noOfExt) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return					 
		end if
		dw_header.setItem( 1, "noOfExt", ll_noOfExt )
		il_noOfExtAllowableForDisc = 0
		il_noOfExtAllowableForDisc = ll_noOfExt

		
		--ll_noOfSTB
		if not iuo_subscriber.getNoOfSTB(ll_noOfSTB) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return					 
		end if
		dw_header.setItem( 1, "noOfSTB", ll_noOfSTB )	
		
		if ll_noOfSTB < 2 then
			guo_func.msgbox("Warning!", "This subscriber has no more allowable extension for disconnection!")
			event ue_new()
			return
		end if
		
		dw_header.acceptText()
		
		--------------------------------------------------------------
		-- validate policy on no of months a/r min requirement - start
		--------------------------------------------------------------		
		s_arrears_override_policy.refTranTypeCode = 'APPLEXTD'
		if not f_overrideArrearsPolicyType(iuo_subscriber, s_arrears_override_policy ) then
			trigger event ue_cancel()
			return
		end if
		------------------------------------------------------------			
		-- validate policy on no of months a/r min requirement - end
		------------------------------------------------------------
		
		
		--check if there are pending installations mline and ext
		
		-- DEFAULT FALSE
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
			guo_func.msgBox('SM-0000001', "Accessing arAcctSubscriber ~nSQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText)
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
			guo_func.msgBox('SM-0000001',"Accessing applOfExtTranHdr ~nSQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText)
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
		
		--application extension disconnection with JO
		long ll_noOfExtApplForDisc
		ll_noOfExtApplForDisc = 0
		select sum(noOfExtension) 
		into :ll_noOfExtApplForDisc
		from applOfExtDiscTranHdr
		where acctNo = :ls_acctNo 
		and applicationStatusCode not in ('AC', 'CN')
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;

		if SQLCA.SQLCode = -1 Then
			guo_func.msgBox('SM-0000001', "Accessing applOfExtDiscTranHdr ~nSQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText)
			return
		end if
		if isnull(ll_noOfExtApplForDisc) then ll_noOfExtApplForDisc = 0	
		
		--scripts below validates if this is still > 0
		--if not do not allow user to allpy for extension disconnection
		--otherwise check if he/she has a black box or blacklisted box
		il_noOfExtAllowableForDisc = il_noOfExtAllowableForDisc - ll_noOfExtApplForDisc
		if isnull(il_noOfExtAllowableForDisc) then il_noOfExtAllowableForDisc = 0

		--installation extension fee shall use succeedingExtInstallFee
		if ll_noOfExtApplications > 0 or ll_noOfMlineApplications > 0 &
			or ll_noOfApplTransfer > 0 or ll_noOfExtApplForDisc > 0 then
			ib_withPendingInstallations = TRUE
		end if
		
		--get inst rates first and succeeding
		string ls_packageCode
		ls_packageCode = iuo_subscriber.packageCode
		
		--extFirstSTBInstallFee
		select extDiscFeeWithJO, extSucceedingSTBInstallFee, stbDepReqPerBox, stbPricePerBox
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
			
		dw_header.setItem(1,'totalRequiredInitialPayment',id_extFirstSTBInstallFee)
		
		--populate registere STB serial nos.
		--step 1 check if populated already then delete all
		ll_row = dw_subscriber_stb.getRow()
		if isnull(ll_row) then ll_row = 0
		if ll_row>0 then
			dw_subscriber_stb.reset()			
		end if
		
		--step 2 now populate
		string	ls_serialNo, ls_boxIdNo, ls_caSerialNo, ls_acquisitionTypeCode
			
		declare cur_subscriber_stbs cursor for
			select serialNo, boxIdNo, caSerialNo, acquisitionTypeCode
			from subscriberCPEMaster
			where acctNo = :ls_acctNo and isPrimary = :ls_primary
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
			into :ls_serialNo, :ls_boxIdNo, :ls_caSerialNo, :ls_acquisitionTypeCode;

		long ll_curRow
		do while SQLCA.sqlcode = 0
			--insert to stb list
			ll_curRow = dw_subscriber_stb.insertRow(0)
			dw_subscriber_stb.setItem( ll_curRow, "serialNo", ls_serialNo )
			if is_isDigital =  'Y' then
				dw_subscriber_stb.setItem( ll_curRow, "caserialNo", ls_caserialNo )
			else
				dw_subscriber_stb.setItem( ll_curRow, "boxidno", ls_boxIdNo )
				dw_subscriber_stb.setItem( ll_curRow, "acquisitionTypeCode", ls_acquisitionTypeCode )
			end if
			--insert to stb for scanning
			ll_curRow = dw_detail.insertRow(0)
			
			fetch cur_subscriber_stbs into :ls_serialNo, :ls_boxIdNo,:ls_caSerialNo, :ls_acquisitionTypeCode;
		loop
		
		close cur_subscriber_stbs;
		--messagebox("",ls_subscriberStatus)
		if ls_subscriberStatus <> 'Active' then
			guo_func.msgbox("Warning!", "Subscriber must be on ACTIVE STATUS.")	
			triggerevent("ue_new")
			return
		end if
		
		dw_header.setColumn( 'locationcode' )
	case "package"	
		
		str_s.s_dataobject = "dw_search_package_master"
		str_s.s_return_column = "packageCode"
		str_s.s_title = "Search For Package"
		str_s.s_1 = 'N'
		
		str_s.s_3 = gs_divisionCode
		str_s.s_2 = is_serviceType
		str_s.s_4 = is_isDigital
		
		openwithparm(w_search_ancestor,str_s)
		ls_result = trim(message.stringparm)
	
		if ls_result <> '' then	
			
			select count(*)
			into :ll_ctr
			from subscriberCPEMaster
			where isPrimary <> 'Y'
			and packageCode = :ls_result
			and acctNo = :iuo_subscriber.acctNo
			and divisionCode = :gs_divisionCode
			and companyCode = :gs_companyCode
			using SQLCA;
			
			if ll_ctr = 0 or isNull(ll_ctr) then
				guo_func.msgBox('ATTENTION',"There are no assigned CPE for this package.")
				return
			end if
			
			dw_header.setitem(1,'packagecode', ls_result)	
			--get inst rates first and succeeding
			
			select packageName,extDiscFeeWithJO, extSucceedingSTBInstallFee, stbDepReqPerBox, stbPricePerBox
			into  :ls_packagename, :id_extFirstSTBInstallFee, :id_extSucceedingSTBInstallFee, :id_stbDepReqPerBox, :id_stbPricePerBox
			FROM 		arPackageMaster
			WHERE 	packageCode = :ls_result
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
			
			dw_header.setItem(1,'noofextension',1)
			dw_header.event itemChanged (1,dw_header.Object.noofextension,'1')
			dw_header.setItem(1,'packagename',ls_packagename )
			
		end if			
end choose
return 

--END SEARCH BUTTON ACCTNO


--EVENT ITEMCHANGE COLUMN DW_HEADER
long ll_noOfExtensions, ll_noOfApplTransfer

long ll_row, ll_success
string ls_search, ls_result, ls_acctNo, ls_requiresApproval 
string ls_reqApp_RND 	, ls_requiresApproval_RWD

ls_requiresApproval = ''
ls_reqApp_RND 	= ''
ls_requiresApproval_RWD = ''

string ls_subscriberName, ls_serviceAddress, ls_billingAddress
string ls_package, ls_generalPackage
string ls_subscriberStatus, ls_chargeType
string ls_subscriberType, ls_subscriberUserType
decimal{2} ld_occupancyRate, ld_monthlyMlineFee, ld_monthlyExtFee
long ll_noOfExt, ll_noOfSTB, ll_loop

if dwo.name = 'noofextension' then
	
	ll_noOfExtensions = long(data)	
	if ll_noOfExtensions > 0 then
		
		--check if ll_noOfExtensions is greater than il_noOfExtAllowableForDisc 
		
		
			this.accepttext()
			il_noOfExtension = ll_noOfExtensions
			uf_prepare_required_initial_payment()
		
		dw_detail.reset()
		for ll_loop = 1 to ll_noOfExtensions
			
			dw_detail.insertRow(0)
			
		next			
		dw_detail.scrollToRow(1)
		dw_detail.setFocus()
		
	else
		--noofextension must be greater than zero
		guo_func.msgBox("No of Extension Error.", "No of extension must be greater than zero")
		return 2
	end if
				
	
end IF

--END EVENT ITEMCHANGE DW_HEADER


--EVENT ITEMCHANGE DW_DETAIL

string ls_serialNo, ls_itemCode, ls_caSerialNo, ls_caItemCode, ls_packageCode
long ll_row
long ll_boxidno
boolean as_hasstb

if dwo.name = 'serialno' then
	ls_serialNo = trim(data)
	ls_itemCode = ''
		
	if dynamic trigger event ue_validate_serialno(ls_serialNo) = -1 then
		guo_func.msgbox("Duplicate of serial no.","You have entered serial no.{ "+ls_serialNo+" } already!")
		return 2
	end if
	//hasstbserialno
	if not iuo_Subscriber.hasSTBSerialNo(ls_serialNo, 'N', as_hasstb) then
		guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + iuo_subscriber.lastSQLErrText)
		return 2
	end if
	
	if as_hasstb then
		// mark regisetered stb as unScanned
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
	else
		guo_func.msgBox("No. of Extension(s) Validation Error", "Serial No. not Assigned to this Subscriber" )
		return 2
	end if
			
end if

--END EVENT ITEMCHANGE DW_DETAIL