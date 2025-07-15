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
       
---FORM DETAIL
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

--SAVE BUTTON

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
// save record to APPLEXTTRANHDRandDTL
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
-------------------------------------

if	not guo_func.set_number(ls_tranTypeCode, ll_tranNo) then
	return -1	
end IF

--VALIDASI guo_func.set_number(ls_tranTypeCode, ll_tranNo)

==================================================
--Apply Open Credits
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if not uo_subs_advar.setAcctNo(ls_acctno) then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = uo_subs_advar.lastSQLCode + '~r~n' + uo_subs_advar.lastSQLErrText
	return -1
end if
if	This.Event ue_applyOCBalances(ld_totalInstFee) <> 0 then
	return -1	
end if

if not iuo_glPoster.postGLEntries() then
	is_msgno 	= 'SM-0000001'
	is_msgtrail =  iuo_glPoster.errorMessage
	is_sugtrail = iuo_glPoster.suggestionRemarks
	return -1
end if

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

-----------END VALIDASI

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
	
	------------END VALIDASI
	
	ls_joNo 				= string(ll_joNo, "00000000")
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
	end if
	
	if not guo_func.set_number("JO", ll_joNo) then
		return -1
	end if
	
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
	--END VALIDASI


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



 