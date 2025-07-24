--FORM QUERY
SELECT  vw_applications_for_jo.tranDate ,
		  vw_applications_for_jo.tranTypeCode ,
		  vw_applications_for_jo.tranNo ,
		  vw_applications_for_jo.acctNo ,
			vw_applications_for_jo.serviceCallSubTypeCode,
		  '' linemancode,
		  '' jodate,
		  arAcctSubscriber.subscribername,
		  systransactionParam.tranTypeName,
        vw_arAcctAddress.completeAddress,
        vw_applications_for_jo.teamcode,
        vw_applications_for_jo.teammembercode
FROM vw_applications_for_jo, arAcctSubscriber, systransactionParam, vw_arAcctAddress
where (vw_applications_for_jo.acctNo = arAcctSubscriber.acctno)
and (vw_applications_for_jo.tranTypeCode = systransactionParam.tranTypeCode) 
and (vw_applications_for_jo.divisionCode = arAcctSubscriber.divisionCode)
and (vw_applications_for_jo.companyCode = arAcctSubscriber.companyCode)
and (vw_applications_for_jo.divisionCode = systransactionParam.divisionCode)
and (vw_applications_for_jo.companyCode = systransactionParam.companyCode)
and (vw_applications_for_jo.acctNo = vw_arAcctAddress.acctno)
and (vw_applications_for_jo.divisionCode = vw_arAcctAddress.divisionCode)
and (vw_applications_for_jo.companyCode = vw_arAcctAddress.companyCode)
and (vw_arAcctAddress.addressTypeCode = 'SERVADR1')
and (( vw_applications_for_jo.companyCode = :as_company)
and ( vw_applications_for_jo.divisionCode = :as_division))
--BUTTON NEW

if dw_header.retrieve(gs_divisionCode, gs_companyCode) <= 0 then
	guo_func.msgbox("Oppsss...","There is no application created yet!", gc_Information, gc_OkOnly, "")
	return
end if

pb_new.default = FALSE

pb_new.enabled = FALSE
pb_close.enabled = FALSE
pb_cancel.enabled = TRUE
pb_createjo.enabled = TRUE

-- BUTTON CREATE JO

dw_header.SelectRow(dw_header.GetRow(), TRUE)

parent.Event ue_createjo()

--VALIDASI UE_CREATEJO
string ls_tranTypeCode, ls_tranNo, ls_acctNo
datetime ldt_joDate

ls_tranTypeCode 	= trim(dw_header.GetItemString(dw_header.GetRow(), 'tranTypeCode'))
ls_tranNo			= trim(dw_header.GetItemString(dw_header.GetRow(), 'tranNo'))
ls_acctNo			= trim(dw_header.GetItemString(dw_header.GetRow(), 'acctNo'))

ls_acctNo = trim(ls_acctNo)
if not iuo_subscriber.setAcctNo( ls_acctNo ) then
	guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + iuo_subscriber.lastSQLErrText)
end IF

--VALIDASI IUO_SUBSCRIBER.SETACCTNO
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

--prepaidSubscriber,
--:prepaidSubscriber,

return TRUE
----END VALIDASI 

uf_get_preferredDateTime_bsg(ls_tranTypeCode, ls_tranNo, ldt_joDate)

--VALIDASI uf_get_preferredDateTime_bsg

if as_tranTypeCode = 'APPLYML' then
	select preferreddatetimefrom
	  into :adt_date
	  from arApplicationTranHdr
	 where tranNo = :as_tranNo
	 and divisionCode = :gs_divisionCode
	 and companyCode = :gs_companyCode
	using SQLCA;
	if SQLCA.sqlcode <> 0 then
		return FALSE
	end if
elseif as_tranTypeCode = 'SERVCALL' then
	select scheduledDateTime
	  into :adt_date
	  from serviceCallTranHdr
	 where tranNo = :as_tranNo
	 and divisionCode = :gs_divisionCode
	 and companyCode = :gs_companyCode
	using SQLCA;
	if SQLCA.sqlcode <> 0 then
		return FALSE
	end if
	
elseif as_tranTypeCode = 'APPLYTRANSFR' then
	select preferreddatetimefrom
	  into :adt_date
	  from applOfTransferTranHdr
	 where tranNo = :as_tranNo
	 and divisionCode = :gs_divisionCode
	 and companyCode = :gs_companyCode
	using SQLCA;
	if SQLCA.sqlcode <> 0 then
		return FALSE
	end if	

elseif as_tranTypeCode = 'APPLYDEAC' then
	select preferreddatetimefrom
	  into :adt_date
	  from applOfDeactivationTranHdr
	 where tranNo = :as_tranNo
	 and divisionCode = :gs_divisionCode
	 and companyCode = :gs_companyCode
	using SQLCA;
	if SQLCA.sqlcode <> 0 then
		return FALSE
	end if	
	
elseif as_tranTypeCode = 'APPLYPD' then
	select preferreddatetimefrom
	  into :adt_date
	  from applOfPermanentDiscTranHdr
	 where tranNo = :as_tranNo
	 and divisionCode = :gs_divisionCode
	 and companyCode = :gs_companyCode
	using SQLCA;
	if SQLCA.sqlcode <> 0 then
		return FALSE
	end if	
	
elseif as_tranTypeCode = 'APPLMLEXTREA' then
	select preferreddatetimefrom
	  into :adt_date
	  from applOfReactivationTranHdr
	 where tranNo = :as_tranNo
	 and divisionCode = :gs_divisionCode
	 and companyCode = :gs_companyCode
	using SQLCA;
	if SQLCA.sqlcode <> 0 then
		return FALSE
	end if	
end if

return TRUE

--END VALIDASI

openwithparm(w_jo_assign_lineman_schedule, string(ldt_joDate, 'mm/dd/yyyy')) //, w_mdiframe, 1, original!)

istr_jo = message.powerobjectparm
if istr_jo.response = 'OK' then
	pb_save.enabled = TRUE
	pb_createjo.enabled = FALSE
	dw_header.setitem(dw_header.GetRow(), "linemancode", istr_jo.linemancode)
	dw_header.setitem(dw_header.GetRow(), "jodate", string(istr_jo.jodate, 'mmm. dd, yyyy'))
else
	dw_header.setitem(dw_header.GetRow(), "linemancode", '')
	dw_header.setitem(dw_header.GetRow(), "jodate", '')
end if

return 0


--END VALIDASI 


dw_header.SelectRow(dw_header.GetRow(), FALSE)



--SAVE BUTTON 

string		ls_acctNo, ls_lineManCode, ls_referenceNo, ls_joStatusCode, ls_trantype
string		ls_sqlcode, ls_sqlerrtext, ls_refno, ls_specialInstructions, ls_batch, ls_tranNo, ls_serialNo, ls_scSubTypeCode
datetime		ldt_joDate, ldt_preferredDatetimeFrom, ldt_preferredDatetimeTo
long			ll_ans, ll_joNo, ll_tranNo
integer		li_noOfSTB

ll_ans = guo_func.msgbox("AR-0000002")
if ll_ans = 2 then
	return -1
end if
	
if not guo_func.get_nextnumber("JO", ll_joNo, "WITH LOCK") then
	return -1
end IF

--VALIDATION guo_func.get_nextnumber("JO", ll_joNo, "WITH LOCK")
	
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
	
	--END VALIDATION guo_func.get_nextnumber


is_joNo 			= string(ll_joNo, "00000000")
ldt_joDate 			= istr_jo.jodate
is_tranTypeCode 	= trim(dw_header.getitemstring(dw_header.getrow(), "trantypecode"))
ls_acctNo			= trim(dw_header.getitemstring(dw_header.getrow(), "acctno"))
ls_lineManCode		= trim(istr_jo.linemancode)
ls_referenceNo		= trim(dw_header.getitemstring(dw_header.getrow(), "tranno"))
ls_scSubTypeCode	= trim(dw_header.getItemString(dw_header.getRow(), 'servicecallsubtypecode'))
ls_joStatusCode 	= "FR"

uf_get_applPreferences_bsg(is_tranTypeCode, ls_referenceNo, ldt_preferredDatetimeFrom, ldt_preferredDatetimeTo, ls_specialInstructions)

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
				serviceCallSubTypeCode,
				userAdd,
				dateAdd,
				divisionCode,
				companyCode)
	  values (
				:is_joNo,
				:ldt_joDate,
				:is_tranTypeCode,
				:ls_acctNo,
				:ls_lineManCode,
				:ls_referenceNo,
				:ls_joStatusCode,
				:ldt_preferredDatetimeFrom,
				:ldt_preferredDatetimeTo,
				:ls_specialInstructions,
				:ls_scSubTypeCode,
				:gs_username,
				getdate(),
				:gs_divisionCode,
				:gs_companyCode)
		using SQLCA;
if SQLCA.sqlcode <> 0 then
	is_msgno = "SM-0000001"
	is_msgtrail = string(SQLCA.sqlcode) + "~r~n" + &
					  SQLCA.sqlerrtext
	is_sugtrail = ""
	return -1
end if


if not uf_set_referenceJoNo_bsg(is_tranTypeCode, ls_referenceNo, is_joNo) then
	is_msgno = "SM-0000001"
	is_msgtrail = string(SQLCA.sqlcode) + "~r~n" + &
					  SQLCA.sqlerrtext
	is_sugtrail = ""
	return -1
end IF

--VALIDASI uf_set_referenceJoNo_bsg

if as_trantypecode = 'APPLYML' then
	update arApplicationTranHdr
		set referenceJONo = :as_jono
	 where tranNo = :as_tranno
	 and divisionCode = :gs_divisionCode
	 and companyCode = :gs_companyCode
	using SQLCA;
	 
	 update arAcctSubscriber
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
elseif as_trantypecode = 'APPLYTRANSFR' then
	update applOfTransferTranHdr
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
elseif as_trantypecode = 'APPLYPD' then
	update applOfPermanentDiscTranHdr
		set referenceJONo = :as_jono
	 where tranNo = :as_tranno
	 and divisionCode = :gs_divisionCode
	 and companyCode = :gs_companyCode
	using SQLCA;
elseif as_tranTypeCode = 'APPLMLEXTREA' then
	update applOfReactivationTranHdr
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
--END VALIDASI uf_set_referenceJoNo_bsg

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

--END VALIDASI guo_func.set_number("JO", ll_joNo)

ls_trantype = trim(dw_header.getitemstring(dw_header.getrow(),"trantypecode"))
ls_refno		= trim(dw_header.getitemstring(dw_header.getrow(),"tranno"))

wf_updateApplicationStatus(ls_trantype, ls_acctNo, 'FR')

--VALIDASI wf_updateApplicationStatus

choose case as_tranTypeCode 

	case 'APPLYML'			//#1
		update arApplicationTranHdr
		set applicationStatusCode = :as_statusCode
		where acctno = :as_acctno
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using sqlca;
		if sqlca.sqlcode < 0 then
			is_msgno = "SM-0000001"
			is_msgtrail = string(SQLCA.sqlcode) + "~r~n" + &
							  SQLCA.sqlerrtext
			is_sugtrail = ""
			return -1
		end if
		
	case	'APPLYEXT'		//#2
		update applOfExtTranHdr
		set applicationStatusCode = :as_statusCode
		where acctno = :as_acctno
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using sqlca;
		if sqlca.sqlcode < 0 then
			is_msgno = "SM-0000001"
			is_msgtrail = string(SQLCA.sqlcode) + "~r~n" + &
							  SQLCA.sqlerrtext
			is_sugtrail = ""
			return -1
		end if
		
	case	'APPLYPD'		//#3
		update applOfPermanentDiscTranHdr
		set applicationStatusCode = :as_statusCode
		where acctno = :as_acctno
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using sqlca;
		if sqlca.sqlcode < 0 then
			is_msgno = "SM-0000001"
			is_msgtrail = string(SQLCA.sqlcode) + "~r~n" + &
							  SQLCA.sqlerrtext
			is_sugtrail = "APPLYPD"
			return -1
		end if
			
	case	'APPLYTRANSFR'	//#4
		update applOfTransferTranHdr
		set applicationStatusCode = :as_statusCode
		where acctno = :as_acctno
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using sqlca;
		if sqlca.sqlcode < 0 then
			is_msgno = "SM-0000001"
			is_msgtrail = string(SQLCA.sqlcode) + "~r~n" + &
							  SQLCA.sqlerrtext
			is_sugtrail = ""
			return -1
		end if
		
	case 'APPLMLEXTREA'	//#5
		update applOfReactivationTranHdr
		set applicationStatusCode = :as_statusCode
		where acctno = :as_acctno
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using sqlca;
		if sqlca.sqlcode < 0 then
			is_msgno = "SM-0000001"
			is_msgtrail = string(SQLCA.sqlcode) + "~r~n" + &
							  SQLCA.sqlerrtext
			is_sugtrail = ""
			return -1
		end if
		
	case	'SERVCALL'		//#6
		update serviceCallTranHdr
		set applicationStatusCode = :as_statusCode
		where acctno = :as_acctno
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using sqlca;
		if sqlca.sqlcode < 0 then
			is_msgno = "SM-0000001"
			is_msgtrail = string(SQLCA.sqlcode) + "~r~n" + &
							  SQLCA.sqlerrtext
			is_sugtrail = "SERVCALL"
			return -1
		end if
	
	case	'APPLYXTDSRVC'	//#7
		update applExtendedServicesTranHdr
		set applicationStatusCode = :as_statusCode
		where acctno = :as_acctno
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using sqlca;
		if sqlca.sqlcode < 0 then
			is_msgno = "SM-0000001"
			is_msgtrail = string(SQLCA.sqlcode) + "~r~n" + &
							  SQLCA.sqlerrtext
			is_sugtrail = ""
			return -1
		end if
		
	case	'APPLEXTD'		//#8
		update applOfExtDiscTranHdr
		set applicationStatusCode = :as_statusCode
		where acctno = :as_acctno
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using sqlca;
		if sqlca.sqlcode < 0 then
			is_msgno = "SM-0000001"
			is_msgtrail = string(SQLCA.sqlcode) + "~r~n" + &
							  SQLCA.sqlerrtext
			is_sugtrail = "APPLEXTD"
			return -1
		end if
	
	case	'APPLYDEAC'		//#9
		update applOfDeactivationTranHdr
		set applicationStatusCode = :as_statusCode
		where acctno = :as_acctno
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using sqlca;
		if sqlca.sqlcode < 0 then
			is_msgno = "SM-0000001"
			is_msgtrail = string(SQLCA.sqlcode) + "~r~n" + &
							  SQLCA.sqlerrtext
			is_sugtrail = "APPLYDEAC"
			return -1
		end if
	
	case	'APPLEXTHO'		//#10
		update applOfExtHotelTranHdr
		set applicationStatusCode = :as_statusCode
		where acctno = :as_acctno
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using sqlca;
		if sqlca.sqlcode < 0 then
			is_msgno = "SM-0000001"
			is_msgtrail = string(SQLCA.sqlcode) + "~r~n" + &
							  SQLCA.sqlerrtext
			is_sugtrail = ""
			return -1
		end if
		
end choose

return 0

--END VALIDASI

is_msgno = "SM-0000002"

return 0

integer li_ok

if ib_transactionWasSaved then
	dw_header.reset()
	pb_new.default = TRUE
	pb_new.enabled = TRUE
	pb_save.enabled = FALSE
	pb_cancel.enabled = FALSE
	pb_close.enabled = TRUE
	pb_createjo.enabled = FALSE
	
	uf_sendemail_w_attachment(is_joNo, iuo_subscriber.acctNo, is_tranTypeCode)
	
end IF

--VALIDASI uf_sendemail_w_attachment (is_joNo, iuo_subscriber.acctNo, is_tranTypeCode)

string ls_prospect, ls_project, ls_fileserver, ls_email, ls_attachment[], ls_emailList[]
int li_count
string ls_item, ls_string, ls_dw, ls_tranTypeName

select itemValue
into :ls_fileserver
from sysParamString
where itemName = 'JOBSGFILE'
and divisionCode = :gs_divisionCode
and companyCode = :gs_companyCode
using SQLCA;

CHOOSE CASE as_tranType

CASE 'APPLYML','APPLYPD','APPLYDEAC','APPLYTRANSFR','APPLMLEXTREA'
		ls_item = 'JOINCHARGE'
		ls_string = "JO_"

CASE 'SERVCALL'
		ls_item = 'SERVICEINCHARGE'
		ls_string = "SERVICE_"
//		ls_dw = "dw_jo_slip_maintenance_bsg"
END CHOOSE

declare cur_email cursor for
	select itemValue
	from sysParamString
	where itemName = :ls_item
	and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	using SQLCA;
open cur_email;
if SQLCA.sqlcode <> 0 then
	return -1
end if

fetch cur_email into :ls_email;
do while SQLCA.sqlcode = 0
	li_count = li_count + 1
	ls_emailList[li_count] = ls_email
	fetch cur_email into :ls_email;
loop
close cur_email;

select tranTypeName
into :ls_tranTypeName
from sysTransactionParam
where tranTypeCode = :as_tranType
and divisionCode = :gs_divisionCode
and companyCode = :gs_companyCode
using SQLCA;

mailSession				mSes
mailReturnCode			mRet
mailMessage				mMsg
mailFileDescription	mAttach 

int		li_index, li_nrecipients, li_no, li_email, li_ctr
boolean 	lb_noerrors
string   ls_accountOfficialName, ls_pcProjectName, ls_rtsNo
string   ls_joNo, ls_acctNo, ls_specialInstruction
dateTime ldt_joDate, ldt_preferredDateTimeFrom

mSes = create mailSession 
mRet = mSes.mailLogon (mailNewSession!)

If mRet <> mailReturnSuccess! Then
	mRet = mSes.mailLogoff( )
	If mRet <> mailReturnSuccess! Then
		guo_func.msgbox("ATTENTION","Sending EMAIL failed. Pls. contact MIS Department.")
	End If
	destroy mSes
	return -1
End If

SetPointer(HourGlass!)
//li_no 	= upperbound(ls_attachment)
li_email = upperbound(ls_emailList)

for li_ctr = 1 to li_email
	mMsg.Recipient[li_ctr].Name = ls_emailList[li_ctr]
	mMsg.Recipient[li_ctr].Address = ls_emailList[li_ctr]
next
mMsg.Subject	= "New JO has been created. (JO No. "+ as_joNo +")"

select prospectClientCode, pcProjectCode
into :ls_prospect, :ls_project
from prospectClientProjects
where acctNo = :as_acctNo
and divisionCode = :gs_divisionCode
and companyCode = :gs_companyCode
using SQLCA;

select a.accountOfficialName,
       b.pcProjectName,
       m.joNo, m.joDate, m.acctNo, 
       n.specialInstruction, n.preferredDateTimeFrom
into  :ls_accountOfficialName,
      :ls_pcProjectName,
      :ls_joNo, :ldt_joDate, :ls_acctNo, 
      :ls_specialInstruction, :ldt_preferredDateTimeFrom
from prospectClientMaster a
inner join prospectClientProjects b on a.prospectClientCode = b.prospectClientCode and b.divisionCode = :gs_divisionCode and b.companyCode = :gs_companyCode
inner join joTranHdr m on b.acctNo = m.acctNo and m.divisionCode = :gs_divisionCode and m.companyCode = :gs_companyCode
inner join arApplicationTranHdr n on m.acctNo = n.acctNo and n.divisionCode = :gs_divisionCode and n.companyCode = :gs_companyCode
where a.prospectClientCode = :ls_prospect and b.pcProjectCode = :ls_project
and b.divisionCode = :gs_divisionCode
	 and b.companyCode = :gs_companyCode
	using SQLCA;

mMsg.notetext  =  "Project Name: " + ls_pcProjectName + '~r~n' + &
						"Customer: " + ls_accountOfficialName + '~r~n' + &
			         "Type : " + ls_tranTypeName + '~r~n' + '~r~n' +&
						"Acct. No.: " + ls_acctNo + '~r~n' + &
						"JO No.: "+ ls_acctNo + '~r~n'+ &
						"JO Date: "+ string(ldt_joDate, "mm/dd/yyyy") + '~r~n' + &
						"Installation Date: "+ string(ldt_preferredDateTimeFrom, "mm/dd/yyyy") + '~r~n' +'~r~n' + &
						"Special Instructions: "+ ls_specialInstruction + '~r~n' + '~r~n' //+ &
						//'~r~n' + '~r~n' + "Please see attachment for more details..." 


If UpperBound ( mMsg.Recipient ) < 1 Then 
   mRet = mSes.mailLogoff( )

	If mRet <> mailReturnSuccess! Then
		guo_func.msgbox("ATTENTION","Mail must included at least 1 recipient.")
	End If
	destroy mSes
   return -1
End If
mRet = mSes.mailSend( mMsg )									
mRet = mSes.mailLogoff( )

If mRet <> mailReturnSuccess! Then
	destroy mSes
	guo_func.msgbox("ATTENTION","Sending EMAIL failed. Pls. contact MIS Department.")
	return - 1
else
	destroy mSes
End If

return 0


