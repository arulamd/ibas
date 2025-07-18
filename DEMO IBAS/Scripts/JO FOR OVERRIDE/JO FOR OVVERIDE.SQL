

--DW HEADER
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

select groupcode 
into :is_Groupcode
from groupmembers 
where usercode = :gs_usercode
using SQLCA;

if dw_header.retrieve(gs_divisionCode, gs_companyCode,is_groupCode) <= 0 then
	guo_func.msgbox("Oppsss...","There is no application created yet!", gc_Information, gc_OkOnly, "")
	return
end if

pb_new.default = FALSE

pb_new.enabled = FALSE
pb_close.enabled = FALSE
pb_cancel.enabled = TRUE
pb_createjo.enabled = TRUE

dw_1.accepttext()

trigger event ue_check_jos()

---VALIDASI event ue_check_jos()

long ll_ctr , ll_addrow, ll_addrow2 , ll_count

string ls_trantypecode , ls_tranno , ls_acctno    , ls_subscriberstatuscode
decimal{4} ld_ripbalance , ld_subsAdvBalance
datetime ldt_trandate

string ls_subscribername , ls_trantypename , ls_completeaddress  , ls_requeststatus


STRING LS_SUBSADVBALANCE
STRING LS_RIPBALANCE

for ll_ctr =1 to  dw_header.rowcount() 
		
		 ld_subsAdvBalance = 0
		 ld_ripbalance = 0
		
		ls_trantypecode = dw_header.getitemstring(ll_ctr,'trantypecode')
		ls_tranno = dw_header.getitemstring(ll_ctr,'tranno')
		ls_acctno = dw_header.getitemstring(ll_ctr,'acctno')
		ldt_trandate = dw_header.getItemDateTime(ll_ctr,'trandate')
		ls_subscribername = dw_header.getItemString(ll_ctr,'aracctsubscriber_subscribername')
		ls_trantypename = dw_header.getItemString(ll_ctr,'vw_aracctaddress_completeaddress')
		ls_completeaddress = dw_header.getItemString(ll_ctr,'systransactionparam_trantypename')
	
		select subscriberstatuscode into :ls_subscriberstatuscode
		from aracctsubscriber
		where acctno = :ls_acctno
		and divisioncode = :gs_divisioncode
		and companycode= :gs_companycode
		using SQLCA;
		

select sum(amount-paidAmt) 
  into :ld_ripbalance
  from subsInitialPayment
 where acctNo = :ls_acctno 
   and divisionCode = :gs_divisioncode
	and companyCode = :gs_companycode
	and tranTypeCode = :ls_trantypecode 
	and tranNo = :ls_tranno
	and processed <> 'Y'
 using SQLCA;

string 		ls_ocTypeCode

if ls_subscriberStatusCode = 'APL' then
	ls_ocTypeCode = 'APPLADV'
else
	ls_ocTypeCode = 'SUBSADV'
end if

select sum(balance)
  into :ld_subsAdvBalance
  from arOpenCreditMaster
 where acctNo = :ls_acctno
	and divisionCode = :gs_divisioncode
	and companyCode = :gs_companycode
	and ocTypeCode = :ls_ocTypeCode
 using SQLCA;
	
if isnull(ld_subsAdvBalance) then ld_subsAdvBalance = 0
if isnull(ld_ripbalance) then ld_ripbalance = 0
LS_SUBSADVBALANCE = STRING(ld_subsAdvBalance)
LS_RIPBALANCE = STRING(ld_ripbalance)

select count(*) into :ll_count
from overridepolicy
where overridepolicytypecode = '004'
AND REFTRANTYPECODE = :ls_trantypecode
AND REFTRANNO = :ls_tranno
AND ACCTNO = :ls_acctno
and divisioncode = :gs_divisioncode
and companycode = :gs_companycode
and requeststatus = 'AP'
using SQLCA;

if ll_count > 0  then continue

if ld_subsAdvBalance >= ld_ripbalance then
	ld_ripbalance = 0	
	
else 
	
	ll_addrow = dw_1.insertRow(0)
	dw_1.setItem(ll_addrow,'trantypecode',ls_trantypecode)
	dw_1.setItem(ll_addrow,'tranno', ls_tranno)
	dw_1.setItem(ll_addrow,'acctno',ls_acctno)
	dw_1.setItem(ll_addrow,'trandate',ldt_trandate)
	dw_1.setItem(ll_addrow,'vw_aracctaddress_completeaddress',ls_completeaddress)
	dw_1.setItem(ll_addrow,'systransactionparam_trantypename',ls_trantypename)
	dw_1.setItem(ll_addrow,'aracctsubscriber_subscribername',ls_subscribername)

end if

next 

---END VALIDASI event ue_check_jos()



--BUTTON REQUEST JO

dw_header.SelectRow(dw_header.GetRow(), TRUE)

parent.Event ue_createjo()

--VALIDASI ue_createjo()

string ls_tranTypeCode, ls_tranNo, ls_acctNo
datetime ldt_joDate

ls_tranTypeCode 	= trim(dw_1.GetItemString(dw_header.GetRow(), 'tranTypeCode'))
ls_tranNo			= trim(dw_1.GetItemString(dw_header.GetRow(), 'tranNo'))
ls_acctNo			= trim(dw_1.GetItemString(dw_header.GetRow(), 'acctNo'))


ls_acctNo = trim(ls_acctNo)
if not iuo_subscriber.setAcctNo( ls_acctNo ) then
	guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + iuo_subscriber.lastSQLErrText)
end IF

--VALIDASI IUO_SUBRCIBER.SETACCTNO

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

--~~~~~~~~~~~~~~~~~~END~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

--prepaidSubscriber,
--:prepaidSubscriber,

return TRUE
---END VALIDASI

--------------------------------------------------------------
--validate policy on no of months a/r min requirement - start
--------------------------------------------------------------		
s_rip_override_policy = s_rip_override_policy_blank

if not f_overrideRIPPolicyType(iuo_subscriber, s_rip_override_policy, ls_acctNo, ls_tranTypeCode, ls_tranNo) then
	--trigger event ue_close()
	return -1
end IF

--VALIDASI f_overrideRIPPolicyType

decimal {2} ld_RIPBalance
boolean lb_allowedToOverride

-----------------------------------------------------------------
--validate policy on no Subs Initial Payment Requirement - start
-----------------------------------------------------------------


ld_RIPBalance = 0.00
--check if subscriber subs initial payment balances
if not iuo_subscriber.getCsrRipBalance(as_acctNo, as_tranTypeCode, as_tranNo, ld_RIPBalance) then
	guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
		iuo_subscriber.lastSQLErrText)
end if

if ld_RIPBalance > 0.00 then
	if guo_func.msgbox("Policy Override!!!", &
							"The current subscriber has required initial payment balance for this service request.  You can not apply for this request.  Do you want to override this policy?", &										
							gc_Question, &
							gc_yesNo, &
							"Please secure an authorization for overriding this policy.") = 1 then
		
		s_rip_override_policy.overridePolicyTypeCode 	= '004'
		s_rip_override_policy.policyCode 					= '004'
		s_rip_override_policy.acctNo 						= iuo_subscriber.acctNo
		s_rip_override_policy.subscriberName				= iuo_subscriber.subscriberName
		s_rip_override_policy.refTranTypeCode			= as_tranTypeCode
		s_rip_override_policy.arBalance 					= ld_RIPBalance
		s_rip_override_policy.refTranNo					= as_tranNo
		
		openwithparm(w_online_authorization,s_rip_override_policy)
		
		---ACTION IN FORM OPEN WITHPARM W_ONLINE_AUTORIZATION
		
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
		
		--END OF ACTION
		 
		if message.stringParm = 'CN' then
			guo_func.msgbox("Policy Override!!!", &
							"You have cancelled the authorization.  This will cancel your transaction.", &										
							gc_Information, &
							gc_OKOnly, &
							"Please secure an authorization for overriding this policy.")
							
			--reset entry
			return false
		elseif message.stringParm = 'ER' then
			return false
		elseif message.stringParm = 'DP' then
			return false
		end if
		
	else  --policy ignored close window transaction
		guo_func.msgbox("Policy Override!!!", &
						"You have cancelled the authorization.  This will cancel your transaction.", &										
						gc_Information, &
						gc_OKOnly, &
						"Please secure an authorization for overriding this policy.")
						
		--reset entry		
		return false
	end if
	
end if
return true

---------------------------------------------------------------
--validate policy on no Subs Initial Payment Requirement - end
---------------------------------------------------------------

--END VALIDASI f_overrideRIPPolicyType

pb_save.enabled = TRUE
pb_createjo.enabled = FALSE

return 0

--END VALIDASI ue_createjo()

dw_header.SelectRow(dw_header.GetRow(), FALSE)

--BUTTON SAVE

update overridePolicy
set refTranNo = :is_tranNo
where tranNo = :gb_authorizationNo
and divisionCode = :gs_divisionCode
and companyCode = :gs_companyCode
and requestStatus = 'AP'
using SQLCA;

commit using SQLCA;

pb_new.default = TRUE
pb_new.enabled = TRUE
pb_save.enabled = FALSE
pb_cancel.enabled = FALSE
pb_close.enabled = TRUE
pb_createjo.enabled = FALSE

--BUTTON CANCEL
if not ib_reqStatus and gb_authorizationNo <> "" and not isNull(gb_authorizationNo) then

	update overridePolicy
	set requestStatus = 'CN'
	where tranNo = :gb_authorizationNo
	and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	and requestStatus = 'AP'
	using SQLCA;
	
	commit using SQLCA;
	dw_1.reset()
end if	

pb_createjo.enabled = FALSE

--BUTTON CLOSE
close(this)



