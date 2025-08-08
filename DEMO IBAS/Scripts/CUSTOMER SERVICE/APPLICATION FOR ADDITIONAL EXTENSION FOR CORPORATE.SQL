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
    
--QUERY FROM DISTRIBUTE EXT
    
  SELECT  acquisitiontypemaster.acquisitiontypename , 
  applofexttrandtl.qty , 
  applofexttrandtl.rate ,
  applofexttrandtl.amount , 
  acquisitiontypemaster.priority , 
  applofexttrandtl.acquisitiontypecode , 
  '' requiresApproval    FROM applofexttrandtl , 
  acquisitiontypemaster
  WHERE ( applofexttrandtl.acquisitiontypecode = acquisitiontypemaster.acquisitiontypecode ) AND
  ( ( applofexttrandtl.tranno = :as_tranNo ) )    
  
 --QUERY FORM REQUIRED INITIAL PAYMENT
  
   SELECT  subsinitialpayment.acctno ,
   subsinitialpayment.trantypecode ,
   subsinitialpayment.artypecode , 
   subsinitialpayment.tranno , 
   subsinitialpayment.trandate , 
   subsinitialpayment.priority ,  
   subsinitialpayment.amount
   FROM subsinitialpayment  
   
   
 --EVENT OPEN FORM
 
idw_application_for_ext_dtl = dw_detail
idw_reqInitPayment = dw_reqinitpayment
iw_parent = this

dw_header.settransobject(SQLCA)
idw_application_for_ext_dtl.settransobject(SQLCA) 
idw_reqInitPayment.settransobject(SQLCA) 

is_serviceType = message.stringParm

is_serviceType = 'CTV'

iuo_subscriber = create uo_subscriber_def

--BUTTON NEW

string ls_AcctNo
long ll_row, ll_priority	
decimal{2} ld_amount, ld_stbdeposit, ld_materialsstbadvances, ld_installationfeesadvances, ld_totalrequiredinitialpayment


--insert rows to required initial payment
--insert OCDEQ - Deposit for STB

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


--insert SALES - Advance Payment for Materials
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

--insert EXTF - Advance Payment for Installation Fees
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

if not guo_func.get_nextnumber('APPLEXTHO', ll_applExt, "") then
	return
end IF

--validasi getNextnumber

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

--end validasi

ls_applExt = string(ll_applExt, '00000000')
ll_currentRow = dw_header.getRow()

ldt_date = Datetime(today(),now())
ldt_today = guo_func.get_server_datetime( )

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
pb_cancel.enabled = TRUE

--UE SEARCH ACCTNO

long ll_row, ll_success, ll_count
string ls_search, ls_result, ls_acctNo, ls_packagename

string ls_subscriberName, ls_serviceAddress, ls_billingAddress
string ls_package, ls_generalPackage
string ls_subscriberStatus, ls_chargeType
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
		
		select count(acctNo) into :ll_count from applOfExtHotelTranHdr
		where  acctNo = :ls_acctNo 
		and applicationStatusCode not in ('AC','CN')
		and divisioncode = :gs_divisioncode
		and companycode = :gs_companycode
		using  SQLCA;
		if SQLCA.SQLCode < 0 then
			guo_func.MsgBox('SM-0000001','SQL Error Code : ' + 	string(SQLCA.SQLCode) + &
							    '~r~nSQL Error Text ; ' + SQLCA.SQLErrText)
			return					 
		end if	
		
		if ll_count > 0 then
			guo_func.MsgBox('Pending Application Found...', 'This account has a pending Application for [Hotel Extension],'+&
								 ' please verify the transaction on JO Monitoring...')
			return					 
		end if	

		if not iuo_subscriber.setAcctNo(ls_acctNo) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + iuo_subscriber.lastSQLErrText)
			return
		end if
		
		is_isDigital = iuo_subscriber.isDigital
		
		if iuo_subscriber.substypecode <> 'CP' then
			guo_func.msgbox("Warning!", "Subscriber type must be Corporate.")
			return
		end if
		
		 if iuo_subscriber.substypecode <> 'CP' then
			guo_func.msgbox("Invalid Subscriber","Invalid subscriber!~r~nThe subscriber must be a corporate type.")
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
		dw_header.setitem(1,"packagecode",iuo_subscriber.packagecode)
		
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
		dw_header.setItem( 1, "noofrooms", iuo_subscriber.numberOfRooms)							
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
		
		--ll_noOfSTB
		if not iuo_subscriber.getNoOfSTB(ll_noOfSTB) then
			guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
				iuo_subscriber.lastSQLErrText)
			return
		end if
		dw_header.setItem( 1, "noOfSTB", ll_noOfSTB )													
		dw_header.acceptText()
		
		--------------------------------------------------------------
		--validate policy on no of months a/r min requirement - start
		--------------------------------------------------------------	
			
		s_arrears_override_policy.refTranTypeCode = 'APPLEXTHO'
		if not f_overrideArrearsPolicyType(iuo_subscriber, s_arrears_override_policy ) then
			trigger event ue_cancel()
			return
		end IF
		
		------------------------------------------------------------			
		-- validate policy on no of months a/r min requirement - end
		------------------------------------------------------------
		
		
		
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
			guo_func.MsgBox( 'SM-0000001',"Accessing arAcctSubscriber ~nSQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText)
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
			guo_func.MsgBox('SM-0000001',"Accessing applOfExtTranHdr ~nSQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText)
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
			guo_func.MsgBox('SM-0000001',"Accessing applOfTransferTranHdr ~nSQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText)
			return
		end if
		if isnull(ll_noOfApplTransfer) then ll_noOfApplTransfer = 0
		
		
		if ll_noOfExtApplications > 0 or ll_noOfMlineApplications > 0 or ll_noOfApplTransfer > 0 then
			ib_withPendingInstallations = TRUE
		end if
		
		--get inst rates first and succeeding
		--if is_isDigital  <>  'Y' then
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
				guo_func.MsgBox('SM-0000001',"select in arPackageMaster SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText)
				return
			end if		
			
			if isnull(id_extFirstSTBInstallFee) then id_extFirstSTBInstallFee = 0.00
			if isnull(id_extSucceedingSTBInstallFee) then  id_extSucceedingSTBInstallFee = 0.00
			if isnull(id_stbDepReqPerBox) then  id_stbDepReqPerBox = 0.00
			if isnull(id_stbPricePerBox) then 	id_stbPricePerBox = 0.00
		
			
		dw_header.setColumn( 'preferredDateTimeFrom' )
		
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
			
			dw_header.setitem(1,'packagecode', ls_result)	
			
			--get inst rates first and succeeding
			
			select packageName,extFirstSTBInstallFee, extSucceedingSTBInstallFee, stbDepReqPerBox, stbPricePerBox
			into  :ls_packagename, :id_extFirstSTBInstallFee, :id_extSucceedingSTBInstallFee, :id_stbDepReqPerBox, :id_stbPricePerBox
			FROM 		arPackageMaster
			WHERE 	packageCode = :ls_result
			and divisionCode = :gs_divisionCode
			and companyCode = :gs_companyCode
			USING SQLCA;			
			If SQLCA.SQLcode = -1 then
				guo_func.MsgBox('SM-0000001',"select in arPackageMaster SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText)
				return
			end if		
			
			if isnull(id_extFirstSTBInstallFee) then id_extFirstSTBInstallFee = 0.00
			if isnull(id_extSucceedingSTBInstallFee) then  id_extSucceedingSTBInstallFee = 0.00
			if isnull(id_stbDepReqPerBox) then  id_stbDepReqPerBox = 0.00
			if isnull(id_stbPricePerBox) then 	id_stbPricePerBox = 0.00
			
			dw_header.setItem(1,'packagename',ls_packagename )
			
		end if		
end choose
return 

--END UE_SEACH ACCTNO

--BUTTON SAVE

long 			ll_acctno, ll_tranNo, ll_additional, ll_extensions
string 			ls_acctno, ls_packageCode
decimal{2}		ld_totalInstFee

dw_detail.acceptText()
dw_header.acceptText()

--validate no of stbs against no of extension
ls_packageCode	= dw_header.getItemString(dw_header.getrow(), "packagecode")
ll_extensions 		= dw_header.getItemNumber(1, "noofextension") //--05122010 -zar
ll_additional 		= dw_detail.getItemNumber(dw_detail.getrow(), "cf_applofexttrandtl_qty")

if ll_additional <> ll_extensions then
	guo_func.msgBox("No. of Extensions Entry validation.", "No. of extensions entry is invalid.")
	return -1
end if

if ll_additional <= 0 or isNull(ll_additional) then
	guo_func.msgBox("No. of Addition Extentions.", "No. of Addition Extentions entry is invalid.")
	return -1
end if

if ll_extensions <= 0 then
	guo_func.msgBox("No. of Extensions Entry validation.", "No. of extensions entry is invalid.")
	return -1
end if

--Confirm
If messagebox('Confirmation', "You wish to save new application for Additional Rooms for Hotel?", Question!, OKCancel! ) <> 1 Then
	return -1
End If

if not guo_func.get_nextNumber(is_transactionID, ll_tranNo, "WITH LOCK") then
	return -1
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

return true

--END VALIDASI GET NEXT NUMBER

if	not guo_func.set_number(is_transactionID, ll_tranNo) then
	return -1	
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

--END VALIDASI SET NUMBER

idt_tranDate = guo_func.get_server_datetime()
is_tranNo = string(ll_tranNo, '00000000')

ls_acctNo = dw_header.getItemString( 1, "acctNo" )

--save record to APPLEXTTRANHDRandDTL

--==================================================
--NGLara | 03-31-2008
--Prepare GL Poster


--NOT USE AGAIN GLPOSTER
if not iuo_glPoster.initialize(is_transactionID, is_tranNo, idt_tranDate) then
	is_msgno 	= 'SM-0000001'
	is_msgtrail = iuo_glPoster.errorMessage
	is_sugtrail = iuo_glPoster.suggestionRemarks
	return -1
end IF

uo_subs_advar.setGLPoster(iuo_glPoster)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if trigger event ue_save_applOfExtTrahHdrAndDtl(ls_acctno) = -1 then
   return -1
end IF

--VALIDASI UE_SAVE_APPLOFEXTTRANHDRANDDTL

string 		ls_acctNo, ls_userAdd, ls_packageCode
long 		ll_noOfExtension
string 		ls_specialinstructions, ls_referenceJONo
datetime 	ldt_preferreddatetimefrom, ldt_preferreddatetimeto						
datetime 	ldt_dateadd 
long 		ll_row

ll_row = dw_header.getrow()

idw_application_for_ext_dtl.acceptText() 
idw_reqInitPayment.acceptText()


ls_acctNo 						= trim(as_acctno)
ll_noOfExtension				= il_noOfExtension
ls_specialinstructions			= trim(dw_header.getItemString(ll_row, "specialInstructions"))	
ls_packageCode				= trim(dw_header.getItemString(ll_row, "packagecode"))	
ldt_preferreddatetimefrom	= dw_header.getItemDateTime(ll_row, "preferreddatetimefrom")
ldt_preferreddatetimeto		= dw_header.getItemDateTime(ll_row, "preferreddatetimeto")

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
INSERT INTO applOfExtHotelTranHdr
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
		divisionCode,
		companyCode,
		packageCode
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
		:gs_divisionCode,
		:gs_companyCode,
		:ls_packageCode
		)
	USING SQLCA;
	
	if SQLCA.SQLCode = -1 then
		is_msgNo    = 'SM-0000001'
		is_msgTrail = "Saving ApplOfExtTranHdr ~nSQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
		return -1
	end if


--Insert record for applOfExtTranDtl
long ll_rows, ll_loop, ll_applOfExtTranDtl_qty
string ls_acquisitionTypeCode
dec{2} ld_rate, ld_amount


ll_rows = idw_application_for_ext_dtl.rowCount()

for ll_loop = 1 to ll_rows
		
	ls_acquisitionTypeCode = idw_application_for_ext_dtl.getItemString(ll_loop, "acquisitionTypeCode")
	ll_applOfExtTranDtl_qty = idw_application_for_ext_dtl.getItemNumber(ll_loop, "applOfExtTranDtl_qty")
	ld_rate 		= idw_application_for_ext_dtl.getItemDecimal(ll_loop, "rate")
	ld_amount 	= idw_application_for_ext_dtl.getItemDecimal(ll_loop, "amount")
	
	
	if ll_applOfExtTranDtl_qty > 0 then
		insert into applOfExtHotelTranDtl
			(tranNo,
			 acquisitionTypeCode,
			 qty,
			 rate,
			 amount,
			 divisionCode,
			 companyCode)
		values
			(:is_tranNo,
			 :ls_acquisitionTypeCode,
			 :ll_applOfExtTranDtl_qty,
			 :ld_rate,
			 :ld_amount,
			 :gs_divisionCode,
			 :gs_companyCode)
		using SQLCA;	
		if SQLCA.SQLCode <> 0 then
			is_msgNo    = 'SM-0000001'
			is_msgTrail = "insert in ApplOfExtTranDtl "+"SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
			return -1	
		end if	
	end if
	
next

return 0



--END VALIDASI UE_SAVE_APPLOFEXTTRANHDRANDDTL

--create records on subsInitialPayment
if trigger event ue_save_subsInitialPayment(ls_acctno, ld_totalInstFee) = -1 then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = "Saving subsInitialPayment ~nSQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
	return -1
end if


--VALIDASI ue_save_subsInitialPayment

long ll_priority, ll_row,  ll_rows, ll_loop
string ls_acctno, ls_tranTypeCode, ls_arTypeCode, ls_currency
datetime ldt_tranDate
dec{2} ld_amount, ld_rate

ls_acctno = trim(as_acctno)
ls_tranTypeCode = 'APPLYEXT'

ll_rows = idw_ReqInitPayment.rowCount()
ad_applicationFee = 0
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
					 :ls_tranTypeCode,
					 :ls_arTypeCode,
					 :is_tranNo,
					 getDate(),
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


--END VALIDASI ue_save_subsInitialPayment

--==================================================
-- Apply Open Credits
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

--END VALIDASI uo_subs_advar.setAcctNo

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

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		
--ALREADY NOT USE postGLEntries
if not iuo_glPoster.postGLEntries() then
	is_msgno 	= 'SM-0000001'
	is_msgtrail =  iuo_glPoster.errorMessage
	is_sugtrail = iuo_glPoster.suggestionRemarks
	return -1
end if

ib_reqStatus = True
guo_func.msgBox("Saving Complete.", "You have successfully saved your entry.")
iw_parent.trigger dynamic event ue_cancel()
idw_ReqInitPayment.reset()

return 0

--END BUTTON SAVE



