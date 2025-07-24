--PROSES assign_cpe_to_jo

--lstr_jo.joNo 				= dw_jo.getitemstring(dw_jo.getrow(), "jono")
--lstr_jo.serviceType 	= dw_jo.getitemstring(dw_jo.getrow(), "servicetype")
--lstr_jo.isDigital		 	= dw_jo.getitemstring(dw_jo.getrow(), "isdigital")
--lstr_jo.tranTypeCode 	= dw_jo.getitemstring(dw_jo.getrow(), "tranTypeCode")
--lstr_jo.jostatuscode = dw_jo.getitemstring(dw_jo.getrow(), "jostatuscode")

--if lstr_jo.tranTypeCode = 'ADDONP'  or lstr_jo.tranTypeCode = 'ADDOND' or lstr_jo.tranTypeCode = 'ADDONDI' or lstr_jo.tranTypeCode = 'HBDO' or lstr_jo.tranTypeCode = 'HBDI' then 
--	openwithparm(w_assign_cpe_to_jo_add_on, lstr_jo)
--end if 


--SAVE BUTTON
lstr_jo.joNo 				= dw_jo.getitemstring(dw_jo.getrow(), "jono")
lstr_jo.serviceType 	= dw_jo.getitemstring(dw_jo.getrow(), "servicetype")
lstr_jo.isDigital		 	= dw_jo.getitemstring(dw_jo.getrow(), "isdigital")
lstr_jo.tranTypeCode 	= dw_jo.getitemstring(dw_jo.getrow(), "tranTypeCode")
lstr_jo.jostatuscode = dw_jo.getitemstring(dw_jo.getrow(), "jostatuscode")

is_joNo 			      = lstr_jo.joNo
is_serviceType 		= lstr_jo.serviceType
is_isDigital			= lstr_jo.isDigital
is_tranTypeCode	   = lstr_jo.tranTypeCode
is_jostatuscode		= lstr_jo.jostatuscode 

--if is_serviceType = 'INET' then
--ue_save_cm

--uo_jo_nv luo_jo
-- VALIDASI JO NO if not luo_jo.setJoNo(is_joNo) then

if isnull(as_joNo) or trim(as_joNo) = '' then
	lastSQLCode 	= '-2'
	lastSQLErrText = 'as_joNo passed does not contained any value.'
	return FALSE
end if

joNo = as_joNo
select acctNo, linemanCode, joStatusCode, joDate, tranTypeCode, referenceNo, actionType, joMobStatusRemarks
  into :acctNo, :linemanCode, :statusCode, :joDate, :tranTypeCode, :referenceNo, :actionType , :joMobStatusRemarks
  from joTranHdr
 where joNo = :joNo
 and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
using SQLCA;
if SQLCA.sqlcode = 100 then
	lastSQLCode = string(SQLCA.sqlcode)
	lastSQLErrText = "Invalid J.O. #"
	return FALSE
elseif SQLCA.sqlcode < 0 then
	lastSQLCode = string(SQLCA.sqlcode)
	lastSQLErrText = SQLCA.sqlerrtext
	return FALSE
end if


select serviceType, isDigital
into :servicetype, :isDigital
from arPackageMaster 
inner join arAcctSubscriber on arPackageMaster.packageCode = arAcctSubscriber.packageCode
where acctNo = :acctNo
and arAcctSubscriber.divisionCode = :gs_divisionCode
and arAcctSubscriber.companyCode = :gs_companyCode
and arPackageMaster.divisionCode = :gs_divisionCode
and arPackageMaster.companyCode = :gs_companyCode
using SQLCA;
if SQLCA.sqlcode < 0 then
	lastSQLCode = string(SQLCA.sqlcode)
	lastSQLErrText = SQLCA.sqlerrtext
	return FALSE
end if

string ls_objectname

if serviceType = 'CTV' then
	ls_objectname = "uo_stb"
elseif serviceType = 'INET' then
	ls_objectname = "uo_cm"
end if
iuo_cpe = CREATE USING ls_objectname

linemanCode = trim(linemanCode)
statusCode = trim(statusCode)
tranTypeCode = trim(tranTypeCode)

return TRUE
--------------------------

--VALIDASI uo_subscriber_def luo_subscriber
--GET luo_subscriber.setAcctNo(luo_jo.acctNo) then	--THIS FOR VALUE luo_subscriber

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
--prepaidSubscriber,

return TRUE
---------------------------

--NEXT PROCESS
--validasi data window

-- QUEERY DW DETAIL MAKE FORM ARRAY LIST

  SELECT joTranDtlAssignedCPE.serialNo,   
     joTranDtlAssignedCPE.itemCode,   
     joTranDtlAssignedCPE.originalAssignedCPE,   
     joTranDtlAssignedCPE.newSerialNo,   
     joTranDtlAssignedCPE.newItemCode, 
     serialNoMaster.controlNo, serialNoMaster.macAddress,  
     'N' newRecord,   
     joTranDtlAssignedCPE.acquisitionTypeCode,   
     '' selected, 
     joTranDtlAssignedCPE.isPrimary, 
     itemMaster.itemName,
     ''newItemName,
	  joTranDtlAssignedCPE.newCAItemCode,
	joTranDtlAssignedCPE.newCASerialNo,
	arPackageMaster.packageName,
	joTranDtlAssignedCPE.packageCode,
	  joTranDtlAssignedCPE.caItemCode,joTranDtlAssignedCPE.newMacAddress,
	joTranDtlAssignedCPE.caSerialNo, '' newCAItemName, i.itemname caItemName, 'N' isChecked,0 noOfrequiredSTB,
	joTranDtlAssignedCPE.lastassigneddate
    FROM joTranDtlAssignedCPE  
   INNER JOIN serialNoMaster on joTranDtlAssignedCPE.serialNo = serialNoMaster.serialNo 
   AND serialNoMaster.divisionCode = joTranDtlAssignedCPE.divisionCode
   AND serialNoMaster.companyCode = joTranDtlAssignedCPE.companyCode
   INNER JOIN itemMaster on joTranDtlAssignedCPE.itemCode = itemMaster.itemCode
   AND  serialNoMaster.itemCode = itemMaster.itemCode
   AND itemMaster.companyCode = joTranDtlAssignedCPE.companyCode
   INNER JOIN serialNoMaster s on joTranDtlAssignedCPE.caserialNo = s.serialNo 
   AND s.divisionCode = joTranDtlAssignedCPE.divisionCode
   AND s.companyCode = joTranDtlAssignedCPE.companyCode
   INNER JOIN itemMaster i on joTranDtlAssignedCPE.caitemCode = i.itemCode
   AND  s.itemCode = i.itemCode
   AND i.companyCode = joTranDtlAssignedCPE.companyCode
    LEFT JOIN arPackageMaster on joTranDtlAssignedCPE.packageCode = arPackageMaster.packageCode 
   AND arPackageMaster.divisionCode = joTranDtlAssignedCPE.divisionCode
   AND arPackageMaster.companyCode = joTranDtlAssignedCPE.companyCode
   WHERE ( joTranDtlAssignedCPE.joNo = :as_jono ) AND  
         ( joTranDtlAssignedCPE.newItemCode is null  and  joTranDtlAssignedCPE.newCAItemCode is null   )
 AND ( joTranDtlAssignedCPE.divisionCode = :as_division )      
 AND ( joTranDtlAssignedCPE.companyCode = :as_company )

ll_newRecords = 0
ll_records = dw_detail.rowcount()
for ll_row = 1 to ll_records	
	ls_serialNo		= trim(dw_detail.object.serialNo[ll_row])	
	ls_newSerialNo	= trim(dw_detail.object.newSerialNo[ll_row])	
	if isnull(ls_serialNo) then continue
	//if not isnull(ls_newSerialNo) then continue
	ll_newRecords = ll_newRecords + 1
NEXT

is_joNo = dw_header.getitemstring(1, "jono")

ll_records = dw_detail.rowcount()
for ll_row = 1 to ll_records
	
	ls_serialNo 				= trim(dw_detail.object.serialNo[ll_row])
	ls_itemCode 				= trim(dw_detail.object.itemCode[ll_row])
	ls_newItemCode			= trim(dw_detail.object.newItemCode[ll_row])
	ls_newSerialNo			= trim(dw_detail.object.newSerialNo[ll_row])
	ls_origAssigned			= trim(dw_detail.object.originalassignedcpe[ll_row])
	ls_newRecord				= trim(dw_detail.object.newRecord[ll_row])
	ls_acquisitionTypeCode 	= trim(dw_detail.object.acquisitionTypeCode[ll_row])
	ls_selected				 	= trim(dw_detail.object.selected[ll_row])
	ls_macAddress			 	= trim(dw_detail.object.macAddress[ll_row])
	ls_newmacAddress		 	= trim(dw_detail.object.newMacAddress[ll_row])
	
	if isnull(ls_serialNo) or ls_serialNo = "" then continue

	if not iuo_cpe.setSerialNoAddOn(ls_serialNo) then
		is_msgno = "SM-0000001"
		is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
		is_sugtrail = ""
		return -1
	end IF
	
	--VALIDASI iuo_cpe.setSerialNoAddOn(ls_serialNo)
	
	--if serviceType = 'INET'
	
	serialNo = trim(as_serialno)

	// check if existing
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
			and a.divisionCode = :gs_divisionCode
			and b.companyCode = :gs_companyCode
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
	
	--VALIDASI iuo_cpe.setSerialNoAddOn(ls_serialNo)
	--if SERVICE TYPE = 'CTV'
	
	serialNo = trim(as_serialno)
	// check if existing
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
	
	-----------------------
	
	string ls_currLocName
	if is_joStatusCode = 'FR' then
		
		if iuo_cpe.locationCode <> is_wsdeflocationCode then
			
			select locationName into :ls_currLocName
			from   locationMaster 
			where  locationCode = :iuo_cpe.locationCode
			and    companyCode  = :gs_companyCode
			using  SQLCA;
			if SQLCA.SQLCode <> 0 then
				guo_func.msgbox("Error in Select [LocationMaster]", SQLCA.SQLErrText)
				this.post dynamic event ue_set_column('serialno')			
				return 2
			end if	
		
			guo_func.msgBox('Warning!','Serial No. [' + ls_serialNo+ '] is currently in location [' + trim(ls_currLocName) + ']' )	
			return -1
			
		end if
		
	elseif is_joStatusCode = 'OG' then
		
		if iuo_cpe.locationCode <> luo_jo.lineManCode then
			
			select locationName into :ls_currLocName
			from   locationMaster 
			where  locationCode = :iuo_cpe.locationCode
			and    companyCode  = :gs_companyCode
			using  SQLCA;
			if SQLCA.SQLCode <> 0 then
				guo_func.msgbox("Error in Select [LocationMaster]", SQLCA.SQLErrText)
				this.post dynamic event ue_set_column('serialno')			
				return 2
			end if	
		
			guo_func.msgBox('Warning!','Serial No. [' + ls_serialNo+ '] is currently in location [' + trim(ls_currLocName) + ']' )	
			return -1
			
		end if
		
	end if		
	
	
	if not iuo_cpe.preAssignToSubscriber(luo_subscriber.acctNo) then
		is_msgno = "SM-0000001"
		is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
		is_sugtrail = 'Object.Method: iuo_cpe.preAssignToSubscriber()'
		return -1
	end IF
	
	--VALIDASI iuo_cpe.preAssignToSubscriber(luo_subscriber.acctNo)
	return preassigntosubscriber(as_acctNo, '')	
	
	
	if not isNull(ls_newItemCode) then
		
		update joTranDtlAssignedCPE 
			set newItemCode 			= :ls_newItemCode,
				 newSerialNo			= :ls_newSerialNo,
				 newMacAddress		= :ls_newMacAddress,
				 acquisitionTypeCode 	= :ls_acquisitionTypeCode,
				 lastAssignedBy		= :gs_username,
				 lastAssignedDate 		= getdate()
		 where joNo = :is_joNo
		 	and serialNo = :ls_serialNo
		 	and divisionCode = :gs_divisionCode
			and companyCode = :gs_companyCode
		using SQLCA;
		if SQLCA.sqlcode <> 0 then
			is_msgno = "SM-0000001"
			is_msgtrail = string(SQLCA.sqlcode) + "~r~n" + SQLCA.sqlerrtext
			is_sugtrail = ""
			return -1
		end if
		if not iuo_cpe.cancelPreAssignment() then
			is_msgno = "SM-0000001"
			is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
			is_sugtrail = 'Object.Method: iuo_cpe.preAssignToSubscriber()'
			return -1
		end if
		if not iuo_cpe.setSerialNoAddOn(ls_newserialNo) then
			is_msgno = "SM-0000001"
			is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
			is_sugtrail = ""
			return -1
		end if	
	
		if not iuo_cpe.preAssignToSubscriber(luo_subscriber.acctNo) then
			is_msgno = "SM-0000001"
			is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
			is_sugtrail = 'Object.Method: iuo_cpe.preAssignToSubscriber()'
			return -1
		end if
		// this portions 
		if luo_subscriber.chargeTypeCode = 'PPS' then
			if not iuo_cpe.takePlaceInSTBPPCLoad(ls_newSerialNo) then
				is_msgno = "SM-0000001"
				is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
				is_sugtrail = "Method: iuo_cpe.takePlaceInSTBPPCLoad()"
				return -1
			end if
		end if
		
	end if
	
	ls_isiptv = iuo_cpe.isiptv
	
	if ls_selected = 'Y' then
		
		
		if ls_isiptv <> 'Y' then
			if not uf_insertIntoMPThrilRequestMaster(luo_jo.acctNo, luo_subscriber.subsUserName, luo_subscriber.password, ls_tranTypeCode, luo_jo.joNo, 'DEACTIVATE', &
				ls_serialNo, ls_macAddress, ls_errormsg) then
				is_msgno = "SM-0000001"
				is_msgtrail = string(SQLCA.sqlcode) + "~r~n" + SQLCA.sqlerrtext
				is_sugtrail = ""
				return -1
			end if
		end if
		
		ls_origAssigned 	= 'N'
		ls_serialNo 	 	= ls_newSerialNo
		ls_macAddress		= ls_newMacAddress
		
	end if
	
	if ls_newRecord = 'Y' or ls_selected = 'Y' then
		
		insert into joTranDtlAssignedCPE (
						joNo,
						itemCode,
						serialNo,
						originalAssignedCPE,
						acquisitionTypeCode,
						lastAssignedBy,
						lastAssignedDate,
						divisionCode,
						companyCode,
						acctNo,
						macAddress)
			  values (
						:is_joNo,
						:ls_itemCode,
						:ls_serialNo,
						:ls_origAssigned,
						:ls_acquisitionTypeCode,
						:gs_username,
						getdate(),
						:gs_divisionCode,
						:gs_companyCode,
						:luo_jo.acctNo,
						:ls_macAddress)
				using SQLCA;
		if SQLCA.sqlcode <> 0 then
			is_msgno = "SM-0000001"
			is_msgtrail = string(SQLCA.sqlcode) + "~r~n" + SQLCA.sqlerrtext
			is_sugtrail = ""
			return -1
		end if
		
		
		insert into joTranDDtlAssignedCPETrail (
						joNo,
						itemCode,
						serialNo,
						originalAssignedCPE,
						acquisitionTypeCode,
						lastAssignedBy,
						lastAssignedDate,
						divisionCode,
						companyCode,
						acctNo,
						macAddress)
			  values (
						:is_joNo,
						:ls_itemCode,
						:ls_serialNo,
						:ls_origAssigned,
						:ls_acquisitionTypeCode,
						:gs_username,
						getdate(),
						:gs_divisionCode,
						:gs_companyCode,
						:luo_jo.acctNo,
						:ls_macAddress)
				using SQLCA;
		if SQLCA.sqlcode <> 0 then
			is_msgno = "SM-0000001"
			is_msgtrail = string(SQLCA.sqlcode) + "~r~n" + SQLCA.sqlerrtext
			is_sugtrail = ""
			return -1
		end if
		
		if luo_subscriber.chargeTypeCode = 'PPS' then
			// ====================================================
			// allow only 3 days before expiration for prepaid subs
			// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			ldt_nullDate = relativeDate(today(), 3)
		end if

		if ls_isiptv <> 'Y' then
			if not uf_insertIntoMPThrilRequestMaster(luo_jo.acctNo, luo_subscriber.subsUserName, luo_subscriber.password, ls_tranTypeCode, luo_jo.joNo, 'ACTIVATE', &
						iuo_cpe.serialNo, iuo_cpe.macAddress, ls_errormsg) then
				is_msgno = "SM-0000001"
				is_msgtrail = string(SQLCA.sqlcode) + "~r~n" + SQLCA.sqlerrtext
				is_sugtrail = ""
				return -1
			end IF
			
			--VALIDASI uf_insertIntoMPThrilRequestMaster(luo_jo.acctNo, luo_subscriber.subsUserName, luo_subscriber.password, ls_tranTypeCode, luo_jo.joNo, 'ACTIVATE', &
			--			iuo_cpe.serialNo, iuo_cpe.macAddress, ls_errormsg)
			
			long ll_reqno, ll_year, ll_month
			string ls_reqno, ls_year, ls_month ,ls_clientclassvalue, ls_subscribername, ls_subscriberstatuscode, ls_telno, ls_workphoneno
			string ls_companyid, ls_divisionid , ls_packagecode, ls_model, ls_address_line1, ls_address_line2, ls_municipalityname, ls_zipcode, ls_provincename, ls_itemcode , ls_approachtype
			int li_year, li_month, li_nodeno
			
			string ls_isaurora, ls_isfiberhome , ls_servicecode
			string ls_appr_type2		
					
			 select companyid, divisionprefix , servicecode
			 into :ls_companyid, :ls_divisionid, :ls_servicecode
			 from systemparameter
			 where divisioncode = :gs_divisioncode
			 using SQLCA;
			
			select b.appr_type into :ls_appr_type2
			FROM SERIALNOMASTER a
			inner join itemmaster  b on b.itemcode = a.itemcode
			and b.companycode = a.companycode
			where a.serialno = :as_serialno
			and a.divisioncode = :gs_divisioncode
			using SQLCA;
			
			if ls_appr_type2 <> 'DOCSIS' then
				return TRUE;
			end if			 
			 			
			ls_divisionid = right(ls_divisionid,2)
 

			insert into mpthrilRequestMaster (
							acctno, 
							subsUserName, 
							password, 
							status, 
							refTranTypeCode,
							refTranNo,
							insertType,
							serialNo,
							macAddress,
							ipAddress,
							errorMsg,
							dateadd,
							divisionCode,
							companyCode)
				  values (
							:as_acctNo, 
							:as_subsUserName, 
							:as_password, 
							'PENDING', 
							:as_refTranTypeCode,
							:as_refTranNo,
							:as_insertType,
							:as_serialNo,
							:as_macAddress,
							null,
							:as_errormsg,
							getdate(),
							:gs_divisionCode,
							:gs_companyCode)
					using SQLCA;
			if SQLCA.SQLCode <> 0 then
				if isnull(as_errormsg) then as_errormsg = ''
				as_errormsg = as_errormsg + '~r~n~r~n' + 'CIB Warning: ' + string(SQLCA.sqlcode) + '~r~n' + SQLCA.sqlerrtext
				return FALSE
			end if
			// 


			//-------------------BANONG---------------------//
			string ls_convertedmacaddress
			
			//if not f_convert_mac(as_macaddress,ls_convertedmacaddress) then
			//	as_errormsg = as_errormsg + '~r~n~r~n' + 'Warning: Unable to convert macaddress to new format'
			//	return FALSE
			//end if
			
			 if isnull(as_macaddress) then return FALSE
			 
			 ls_convertedmacaddress = as_macaddress
			
			SELECT SUBSTR(cpe.MACADDRESS,1,2) ||':' || SUBSTR
			(cpe.MACADDRESS,3,2) ||':' || SUBSTR(cpe.MACADDRESS,5,2) || ':' || SUBSTR(cpe.MACADDRESS,7,2) ||':' ||SUBSTR
			(cpe.MACADDRESS,9,2) ||':' || SUBSTR(cpe.MACADDRESS,11,2) MAC_ADDRESS
			into :ls_convertedmacaddress
			FROM serialnomaster CPE
			WHERE MACADDRESS = :as_macaddress
			//and acctno = :as_acctno
			and divisioncode = :gs_divisioncode
			and companycode = :gs_companycode
			and rownum = 1
			using SQLCA;
			
			
			if gs_divisioncode = 'DAGNT' then
				gs_divisioncode = 'DAGNT'
			end if 

		
		--VALIDASI f_ifallowedinbccserver
		string ls_provinceCode, ls_nodeno, ls_bccactivated

		select bccprovince.provinceCode  into :ls_provinceCode
		from aracctaddress a
		inner join bccprovince on bccprovince.provinceCode = a.provincecode
		and bccprovince.divisioncode = a.divisioncode
		and bccprovince.companycode = a.companycode
		where a.acctno = :as_acctno
		and a.divisioncode= :gs_divisioncode
		and a.companycode = :gs_companycode
		and a.addresstypecode = 'SERVADR1'
		using SQLCA;
		if SQLCA.SQLcode <> 0 then
			//Not existing or Not intended for BCC
			return FALSE
		end if
		
		select nodeno into :ls_nodeno
		from aracctsubscriber 
		where acctno = :as_acctno
		and divisioncode= :gs_divisioncode
		and companycode = :gs_companycode
		using SQLCA;
		if SQLCA.SQLcode <> 0 then
			//No Assign Nodeno
			return FALSE
		end if
		
		select bccactivated into :ls_bccactivated 
		from nodesinipcommander
		where divisioncode = :gs_divisioncode
		and companycode = :gs_companycode
		and nodeno = :ls_nodeno
		using SQLCA;
		
		if isnull(ls_bccactivated) or ls_bccactivated = '' or ls_bccactivated = 'N'  then
			return FALSE
		end if	
			
		//For BCC
		return TRUE
			
				
		--check muna kung allowed sa bcc, para hindi siya lagi nag coconnect
		if f_ifallowedinbccserver(as_acctno) THEN (--IF TRUE THEN CONTINUE)	
			uo_ipcomm_mon luo_ipcomm
							
			if not	luo_ipcomm.getsubscribername(as_acctno,ls_subscribername, ls_subscriberstatuscode) then
				as_errormsg = as_errormsg + '~r~n~r~n' + 'Warning: ' + string(SQLCA.sqlcode) + '~r~n' + SQLCA.sqlerrtext
				return FALSE
			end if
			
			if not	luo_ipcomm.getpackagecode(as_acctno,ls_packagecode) then
				as_errormsg = as_errormsg + '~r~n~r~n' + 'Warning: ' + string(SQLCA.sqlcode) + '~r~n' + SQLCA.sqlerrtext
				return FALSE
			end if
			
			if not	luo_ipcomm.getclientclassnamenew(ls_packagecode,ls_clientclassvalue,as_acctno, ls_approachtype) then
				as_errormsg = as_errormsg + '~r~n~r~n' + 'Warning: ' + string(SQLCA.sqlcode) + '~r~n' + SQLCA.sqlerrtext
				return FALSE
			end if 
			
			select itemcode into :ls_itemcode
			from serialnomaster
			where serialno = :as_serialNo
			and divisioncode = :gs_divisioncode
			and companycode = :gs_companycode
			using SQLCA;			
		
			select model  into :ls_model 
			from itemmaster
			where itemcode = :ls_itemcode
			and companycode = :gs_companycode
			using SQLCA;
			
			select substr(translate(telno, '[0-9]#$&&!_()/@\"ABCDEFGHIJKLMNOPQRSTUVWXYZ','[0-9]'),1,11), substr(translate(mobileno, '[0-9]#$&&!_()/@\"ABCDEFGHIJKLMNOPQRSTUVWXYZ','[0-9]'),1,11)
			into :ls_telno, :ls_workphoneno
			from aracctsubscriber
			where acctno = :as_acctno
			and divisioncode = :gs_divisioncode
			and companycode = :gs_companycode
			using SQLCA;
			
			select houseno ||' ' || blkno  || ' ' || lotno || ' ' || streetname, subdivisionname || ' ' || barangayname, municipalityname, provincename, zipcode
			into	:ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode
			from vw_aracctaddress
			where acctno = :as_acctno
			and addresstypecode = 'SERVADR1'
			and divisioncode = :gs_divisioncode
			and companycode = :gs_companycode
			using SQLCA;			
			
			
			select month(getdate()), year(getdate())
			into :li_month, :li_year
			from systemparameter
			where divisioncode = :gs_divisioncode
			using SQLCA;
			
			ls_month = string(li_month,'00')
			ls_year = string(li_year,'0000')
	
			string ls_subkeylist[], ls_result
			integer li_rtn, li_rtnvalue
			li_rtn = RegistryKeys("HKEY_LOCAL_MACHINE\Software\ODBC\ODBC.INI\ODBC Data Sources", ls_subkeylist)
			
			string ls_valuearray[]
			li_rtn = RegistryValues("HKEY_LOCAL_MACHINE\Software\ODBC\ODBC.INI\BCCDSN", ls_valuearray)
			
			li_rtnvalue = RegistryGet("HKEY_LOCAL_MACHINE\Software\ODBC\ODBC.INI\ODBC Data Sources", 'iBAST4', RegString!, ls_result)
			
			if ls_result = 'Oracle in instantclient_11_2' then 
							  
				li_rtn = registrySet("HKEY_LOCAL_MACHINE\Software\ODBC\ODBC.INI\ODBC Data Sources", 'BCCDSN', RegString!, 'Oracle in instantclient_11_2')
				li_rtn = registrySet("HKEY_LOCAL_MACHINE\Software\ODBC\ODBC.INI\BCCDSN", 'Driver', RegString!, 'C:\oracle\instantclient_11_2\SQORA32.dll')
				li_rtn = registrySet("HKEY_LOCAL_MACHINE\Software\ODBC\ODBC.INI\BCCDSN", 'Database', RegString!, 'BCCDSN')
				li_rtn = registrySet("HKEY_LOCAL_MACHINE\Software\ODBC\ODBC.INI\BCCDSN", 'Server', RegString!, '192.168.99.16')
				li_rtn = registrySet("HKEY_LOCAL_MACHINE\Software\ODBC\ODBC.INI\BCCDSN", 'LastUser', RegString!, 'bcc_user')
				li_rtn = registrySet("HKEY_LOCAL_MACHINE\Software\ODBC\ODBC.INI\BCCDSN", 'Password', RegString!, 'bcc_user')
				li_rtn = registrySet("HKEY_LOCAL_MACHINE\Software\ODBC\ODBC.INI\BCCDSN", 'ServerName', RegString!, 'BCCDSN')
			
			elseif 	ls_result = 'Oracle in OraClient11g_home1' then
			
			li_rtn = registrySet("HKEY_LOCAL_MACHINE\Software\ODBC\ODBC.INI\ODBC Data Sources", 'BCCDSN', RegString!, 'Oracle in OraClient11g_home1')
			li_rtn = registrySet("HKEY_LOCAL_MACHINE\Software\ODBC\ODBC.INI\BCCDSN", 'Driver', RegString!, 'C:\app\||gs_loginworkstation||\product\11.2.0\client_1\SQORA32.dll')
			li_rtn = registrySet("HKEY_LOCAL_MACHINE\Software\ODBC\ODBC.INI\BCCDSN", 'Database', RegString!, 'BCCDSN')
			li_rtn = registrySet("HKEY_LOCAL_MACHINE\Software\ODBC\ODBC.INI\BCCDSN", 'Server', RegString!, '192.168.99.16')
			li_rtn = registrySet("HKEY_LOCAL_MACHINE\Software\ODBC\ODBC.INI\BCCDSN", 'LastUser', RegString!, 'bcc_user')
			li_rtn = registrySet("HKEY_LOCAL_MACHINE\Software\ODBC\ODBC.INI\BCCDSN", 'Password', RegString!, 'bcc_user')
			li_rtn = registrySet("HKEY_LOCAL_MACHINE\Software\ODBC\ODBC.INI\BCCDSN", 'ServerName', RegString!, 'BCCDSN')
			
			end if 

	
			BCCTRANS = create Transaction
			
			--Profile BCCDSN
			BCCTRANS.DBMS = "ODBC"
			BCCTRANS.AutoCommit = False
			BCCTRANS.DBParm = "ConnectString='DSN=BCCDSN;UID=bcc_user;PWD=bcc_user'"
			
			connect using BCCTRANS;
			
			if BCCTRANS.SQLCode <> 0 then
				as_errormsg = string(BCCTRANS.SQLCode) + BCCTRANS.SQLErrText
				disconnect using BCCTRANS;
				destroy BCCTRANS;
				return false
			end if	
			
			
		if ls_approachtype = 'DOCSIS' then	
	
	
			if trim(as_reftrantypecode) = 'ADS' or trim(as_reftrantypecode) = 'APPLYPD' then
				
				if not guo_func.get_nextNumber('BCCREQUESTNO',ll_reqno,'WITH LOCK') then 
					return FALSE
				end if	
				
				ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000')  
				
				// DEL MAC + DEL SUB
				insert into BCC_DOCSIS_REQUEST
				(request_no, request_date, mac_address, serial_no, client_class, remarks, ref_trantype_code, ref_tran_no, parent_request_no, request_type_code, node_no /*provinceName*/ , user_name_add, date_add, division_code, company_code, processed, error_code, error_msg, processed_date, bcc_server_code, acct_no, subscriber_name, description, 
				subscriber_status_code, new_acct_no, new_sub_name, NEW_ACCT_DESC,
				CONTACT_PERSON,PACKAGE_CODE,DEVICE_MODEL,LAST_NAME,BATCH_NO,
				HOME_PHONE,WORK_PHONE,ADDRESS_1,ADDRESS_2,CITY,STATE,ZIP_CODE,IP_ADDRESS)
				values
				(:ls_reqno, getdate(), :ls_convertedmacaddress, :as_serialno, :ls_clientclassvalue, :as_reftrantypecode || '-' || :as_inserttype,  :as_reftrantypecode, :as_reftranno ,null, '011' , :li_nodeno, :gs_username, getdate(), :gs_divisioncode, :gs_companycode, 'N', null, null, null, '0000003', 'IBAS-'||:ls_companyid || :ls_divisionid || :ls_servicecode|| :as_acctno,  :ls_subscribername, 'DELMAC+DELSUB' , 
				:ls_subscriberstatuscode, null, null, null, substr(:ls_subscribername, 0,40), :ls_packagecode, :ls_model, substr(:ls_subscribername, 0,40),
				'001', substr(:ls_telno,1,11), :ls_workphoneno, :ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode,:gs_ipaddress)
				using BCCTRANS;		
		
		
				if not guo_func.set_Number('BCCREQUESTNO',ll_reqno) then
					return FALSE
				end if			
				
				commit using SQLCA;
				
			elseif trim(as_reftrantypecode) = 'ASSIGNEDCPE' then
			
			if not guo_func.get_nextNumber('BCCREQUESTNO',ll_reqno,'WITH LOCK') then 
				return FALSE
			end if	
		
			IF TRIM(AS_INSERTTYPE) = 'DEACTIVATE' THEN
			
				ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000') 
			
				// DEL MAC + DEL SUB
				insert into BCC_DOCSIS_REQUEST
				(request_no, request_date, mac_address, serial_no, client_class, remarks, ref_trantype_code, ref_tran_no, parent_request_no, request_type_code, node_no /*provinceName*/ , user_name_add, date_add, division_code, company_code, processed, error_code, error_msg, processed_date, bcc_server_code, acct_no, subscriber_name, description, 
				subscriber_status_code, new_acct_no, new_sub_name, NEW_ACCT_DESC,
				CONTACT_PERSON,PACKAGE_CODE,DEVICE_MODEL,LAST_NAME,BATCH_NO,
				HOME_PHONE,WORK_PHONE,ADDRESS_1,ADDRESS_2,CITY,STATE,ZIP_CODE,IP_ADDRESS)
				values
				(:ls_reqno, getdate(), :ls_convertedmacaddress, :as_serialno, :ls_clientclassvalue, :as_reftrantypecode || '-' || :as_inserttype,  :as_reftrantypecode, :as_reftranno ,null, '011' , :li_nodeno, :gs_username, getdate(), :gs_divisioncode, :gs_companycode, 'N', null, null, null, '0000003', 'IBAS-'||:ls_companyid || :ls_divisionid || :ls_servicecode|| :as_acctno,  :ls_subscribername, 'DELMAC+DELSUB' , 
				:ls_subscriberstatuscode, null, null, null, substr(:ls_subscribername, 0,40), :ls_packagecode, :ls_model, substr(:ls_subscribername, 0,40),
				'001', :ls_telno, :ls_workphoneno, :ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode,:gs_ipaddress)
				using BCCTRANS;
				
				if not guo_func.set_Number('BCCREQUESTNO',ll_reqno) then
					return FALSE
				end if		
				
			END IF
		
			IF  TRIM(AS_INSERTTYPE) = 'ACTIVATE' THEN
				
				ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000') 
				
				insert into BCC_DOCSIS_REQUEST
				(request_no, request_date, mac_address, serial_no, client_class, remarks, ref_trantype_code, ref_tran_no, parent_request_no, request_type_code, node_no /*provinceName*/ , user_name_add, date_add, division_code, company_code, processed, error_code, error_msg, processed_date, bcc_server_code, acct_no, subscriber_name, description, 
				subscriber_status_code, new_acct_no, new_sub_name, NEW_ACCT_DESC,
				CONTACT_PERSON,PACKAGE_CODE,DEVICE_MODEL,LAST_NAME,BATCH_NO,
				HOME_PHONE,WORK_PHONE,ADDRESS_1,ADDRESS_2,CITY,STATE,ZIP_CODE,IP_ADDRESS)
				values
				(:ls_reqno, getdate(), :ls_convertedmacaddress, :as_serialno, :ls_clientclassvalue, :as_reftrantypecode || '-' || :as_inserttype,  :as_reftrantypecode, :as_reftranno ,null, '010' , :li_nodeno, :gs_username, getdate(), :gs_divisioncode, :gs_companycode, 'N', null, null, null, '0000003', 'IBAS-'||:ls_companyid || :ls_divisionid || :ls_servicecode|| :as_acctno,  :ls_subscribername, 'ADDSUB+ADDMACINV+ADDMAC' , 
				:ls_subscriberstatuscode, null, null, null, substr(:ls_subscribername, 0,40), :ls_packagecode, :ls_model, substr(:ls_subscribername, 0,40),
				'001', :ls_telno, :ls_workphoneno, :ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode,:gs_ipaddress)
				using BCCTRANS;
	
				if not guo_func.set_Number('BCCREQUESTNO',ll_reqno) then
					return FALSE
				end if	
			END IF
		elseif  trim(as_reftrantypecode) = 'REACTIVATE' then
			
			if not guo_func.get_nextNumber('BCCREQUESTNO',ll_reqno,'WITH LOCK') then 
				return FALSE
			end if	
			
				ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000') 
				
				ll_reqno  = ll_reqno + 1
				ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000') 
	
	
				// ADD SUB + ADD MAC INV + ADD MAC
				insert into BCC_DOCSIS_REQUEST
				(request_no, request_date, mac_address, serial_no, client_class, remarks, ref_trantype_code, ref_tran_no, parent_request_no, request_type_code, node_no /*provinceName*/ , user_name_add, date_add, division_code, company_code, processed, error_code, error_msg, processed_date, bcc_server_code, acct_no, subscriber_name, description, 
				subscriber_status_code, new_acct_no, new_sub_name, NEW_ACCT_DESC,
				CONTACT_PERSON,PACKAGE_CODE,DEVICE_MODEL,LAST_NAME,BATCH_NO,
				HOME_PHONE,WORK_PHONE,ADDRESS_1,ADDRESS_2,CITY,STATE,ZIP_CODE,IP_ADDRESS)
				values
				(:ls_reqno, getdate(), :ls_convertedmacaddress, :as_serialno, :ls_clientclassvalue, :as_reftrantypecode || '-' || :as_inserttype,  :as_reftrantypecode, :as_reftranno ,null, '010' , :li_nodeno, :gs_username, getdate(), :gs_divisioncode, :gs_companycode, 'N', null, null, null, '0000003', 'IBAS-'||:ls_companyid || :ls_divisionid || :ls_servicecode|| :as_acctno,  :ls_subscribername, 'ADDSUB+ADDMACINV+ADDMAC' , 
				:ls_subscriberstatuscode, null, null, null, substr(:ls_subscribername, 0,40), :ls_packagecode, :ls_model, substr(:ls_subscribername, 0,40),
				'001', :ls_telno, :ls_workphoneno, :ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode,:gs_ipaddress)
				using BCCTRANS;
			
				if not guo_func.set_Number('BCCREQUESTNO',ll_reqno) then
					return FALSE
				end if	
		
		elseif trim(as_reftrantypecode) = 'REFRESH' then
			
			if ls_subscriberstatuscode = 'APL' or ls_subscriberstatuscode = 'ACT' then
				
				if not guo_func.get_nextNumber('BCCREQUESTNO',ll_reqno,'WITH LOCK') then 
					return FALSE
				end if	
				
				ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000') 
	
				//DEL SUB + DEL MAC
				insert into BCC_DOCSIS_REQUEST
				(request_no, request_date, mac_address, serial_no, client_class, remarks, ref_trantype_code, ref_tran_no, parent_request_no, request_type_code, node_no /*provinceName*/ , user_name_add, date_add, division_code, company_code, processed, error_code, error_msg, processed_date, bcc_server_code, acct_no, subscriber_name, description, 
				subscriber_status_code, new_acct_no, new_sub_name, NEW_ACCT_DESC,
				CONTACT_PERSON,PACKAGE_CODE,DEVICE_MODEL,LAST_NAME,BATCH_NO,
				HOME_PHONE,WORK_PHONE,ADDRESS_1,ADDRESS_2,CITY,STATE,ZIP_CODE,IP_ADDRESS)
				values
				(:ls_reqno, getdate(), :ls_convertedmacaddress, :as_serialno, :ls_clientclassvalue, :as_reftrantypecode || '-' || :as_inserttype,  :as_reftrantypecode, :as_reftranno ,null, '011' , :li_nodeno, :gs_username, getdate(), :gs_divisioncode, :gs_companycode, 'N', null, null, null, '0000003', 'IBAS-'||:ls_companyid || :ls_divisionid || :ls_servicecode|| :as_acctno,  :ls_subscribername, 'DELMAC+DELSUB' , 
				:ls_subscriberstatuscode, null, null, null, substr(:ls_subscribername, 0,40), :ls_packagecode, :ls_model, substr(:ls_subscribername, 0,40),
				'001', :ls_telno, :ls_workphoneno, :ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode,:gs_ipaddress)
				using BCCTRANS;
				
				ll_reqno  = ll_reqno + 1
				ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000')
						
			
				// ADD SUB + ADD MAC INV + ADD MAC
				insert into BCC_DOCSIS_REQUEST
				(request_no, request_date, mac_address, serial_no, client_class, remarks, ref_trantype_code, ref_tran_no, parent_request_no, request_type_code, node_no /*provinceName*/ , user_name_add, date_add, division_code, company_code, processed, error_code, error_msg, processed_date, bcc_server_code, acct_no, subscriber_name, description, 
				subscriber_status_code, new_acct_no, new_sub_name, NEW_ACCT_DESC,
				CONTACT_PERSON,PACKAGE_CODE,DEVICE_MODEL,LAST_NAME,BATCH_NO,
				HOME_PHONE,WORK_PHONE,ADDRESS_1,ADDRESS_2,CITY,STATE,ZIP_CODE,IP_ADDRESS)
				values
				(:ls_reqno, getdate(), :ls_convertedmacaddress, :as_serialno, :ls_clientclassvalue, :as_reftrantypecode || '-' || :as_inserttype,  :as_reftrantypecode, :as_reftranno ,null, '010' , :li_nodeno, :gs_username, getdate(), :gs_divisioncode, :gs_companycode, 'N', null, null, null, '0000003', 'IBAS-'||:ls_companyid || :ls_divisionid || :ls_servicecode|| :as_acctno,  :ls_subscribername, 'ADDSUB+ADDMACINV+ADDMAC' , 
				:ls_subscriberstatuscode, null, null, null, substr(:ls_subscribername, 0,40), :ls_packagecode, :ls_model, substr(:ls_subscribername, 0,40),
				'001', :ls_telno, :ls_workphoneno, :ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode,:gs_ipaddress)
				using BCCTRANS;
						
				if not guo_func.set_Number('BCCREQUESTNO',ll_reqno) then
					return FALSE
				end if	
	
			else //if not APPLIED or ACTIVE ---> DEACTIVATE
				
				if not guo_func.get_nextNumber('BCCREQUESTNO',ll_reqno,'WITH LOCK') then 
					return FALSE
				end if	
				
				ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000') 
	
				//DEL SUB + DEL MAC
	
				insert into BCC_DOCSIS_REQUEST
				(request_no, request_date, mac_address, serial_no, client_class, remarks, ref_trantype_code, ref_tran_no, parent_request_no, request_type_code, node_no /*provinceName*/ , user_name_add, date_add, division_code, company_code, processed, error_code, error_msg, processed_date, bcc_server_code, acct_no, subscriber_name, description, 
				subscriber_status_code, new_acct_no, new_sub_name, NEW_ACCT_DESC,
				CONTACT_PERSON,PACKAGE_CODE,DEVICE_MODEL,LAST_NAME,BATCH_NO,
				HOME_PHONE,WORK_PHONE,ADDRESS_1,ADDRESS_2,CITY,STATE,ZIP_CODE,IP_ADDRESS)
				values
				(:ls_reqno, getdate(), :ls_convertedmacaddress, :as_serialno, :ls_clientclassvalue, :as_reftrantypecode || '-' || :as_inserttype,  :as_reftrantypecode, :as_reftranno ,null, '011' , :li_nodeno, :gs_username, getdate(), :gs_divisioncode, :gs_companycode, 'N', null, null, null, '0000003', 'IBAS-'||:ls_companyid || :ls_divisionid || :ls_servicecode|| :as_acctno,  :ls_subscribername, 'DELMAC+DELSUB' , 
				:ls_subscriberstatuscode, null, null, null, substr(:ls_subscribername, 0,40), :ls_packagecode, :ls_model,substr(:ls_subscribername, 0,40),
				'001', :ls_telno, :ls_workphoneno, :ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode,:gs_ipaddress)
				using BCCTRANS;
				
				if not guo_func.set_Number('BCCREQUESTNO',ll_reqno) then
					return FALSE
				end if	
			end if
	
		elseif  trim(as_reftrantypecode) = 'REACTIVATE' or trim(as_reftrantypecode) = 'ACTIVATEPDS' or trim(as_reftrantypecode) = 'ACTIVATEADS' then
			
				if not guo_func.get_nextNumber('BCCREQUESTNO',ll_reqno,'WITH LOCK') then 
					return FALSE
				end if	
				
				ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000') 
				ll_reqno  = ll_reqno + 1
				ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000') 
	
				
				// ADD SUB + ADD MAC INV + ADD MAC
	
				insert into BCC_DOCSIS_REQUEST
				(request_no, request_date, mac_address, serial_no, client_class, remarks, ref_trantype_code, ref_tran_no, parent_request_no, request_type_code, node_no /*provinceName*/ , user_name_add, date_add, division_code, company_code, processed, error_code, error_msg, processed_date, bcc_server_code, acct_no, subscriber_name, description, 
				subscriber_status_code, new_acct_no, new_sub_name, NEW_ACCT_DESC,
				CONTACT_PERSON,PACKAGE_CODE,DEVICE_MODEL,LAST_NAME,BATCH_NO,
				HOME_PHONE,WORK_PHONE,ADDRESS_1,ADDRESS_2,CITY,STATE,ZIP_CODE,IP_ADDRESS)
				values
				(:ls_reqno, getdate(), :ls_convertedmacaddress, :as_serialno, :ls_clientclassvalue, :as_reftrantypecode || '-' || :as_inserttype,  :as_reftrantypecode, :as_reftranno ,null, '010' , :li_nodeno, :gs_username, getdate(), :gs_divisioncode, :gs_companycode, 'N', null, null, null, '0000003', 'IBAS-'||:ls_companyid || :ls_divisionid || :ls_servicecode|| :as_acctno,  :ls_subscribername, 'ADDSUB+ADDMACINV+ADDMAC' , 
				:ls_subscriberstatuscode, null, null, null, substr(:ls_subscribername, 0,40), :ls_packagecode, :ls_model, substr(:ls_subscribername, 0,40),
				'001', :ls_telno, :ls_workphoneno, :ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode,:gs_ipaddress)
				using BCCTRANS;
				
				if not guo_func.set_Number('BCCREQUESTNO',ll_reqno) then
					return FALSE
				end if	
					
				
		elseif  trim(as_reftrantypecode) = 'CHANGEPACK'  then
				
				if not guo_func.get_nextNumber('BCCREQUESTNO',ll_reqno,'WITH LOCK') then 
					return FALSE
				end if	
				
				ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000') 
				
				insert into BCC_DOCSIS_REQUEST
				(request_no, request_date, mac_address, serial_no, client_class, remarks, ref_trantype_code, ref_tran_no, parent_request_no, request_type_code, node_no /*provinceName*/ , user_name_add, date_add, division_code, company_code, processed, error_code, error_msg, processed_date, bcc_server_code, acct_no, subscriber_name, description, 
				subscriber_status_code, new_acct_no, new_sub_name, NEW_ACCT_DESC,
				CONTACT_PERSON,PACKAGE_CODE,DEVICE_MODEL,LAST_NAME,BATCH_NO,
				HOME_PHONE,WORK_PHONE,ADDRESS_1,ADDRESS_2,CITY,STATE,ZIP_CODE,IP_ADDRESS)
				values
				(:ls_reqno, getdate(), :ls_convertedmacaddress, :as_serialno, :ls_clientclassvalue, :as_reftrantypecode || '-' || :as_inserttype,  :as_reftrantypecode, :as_reftranno ,null, '012' , :li_nodeno, :gs_username, getdate(), :gs_divisioncode, :gs_companycode, 'N', null, null, null, '0000003', 'IBAS-'||:ls_companyid || :ls_divisionid || :ls_servicecode|| :as_acctno,  :ls_subscribername, 'ADDSUB+ADDMACINV+ADDMAC' , 
				:ls_subscriberstatuscode, null, null, null, substr(:ls_subscribername, 0,40), :ls_packagecode, :ls_model, substr(:ls_subscribername, 0,40),
				'001', :ls_telno, :ls_workphoneno, :ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode,:gs_ipaddress)
				using BCCTRANS;
				
				if not guo_func.set_Number('BCCREQUESTNO',ll_reqno) then
					return FALSE
				end if
			
				
			elseif trim(as_reftrantypecode) = 'REPLACECM' then
					
					if not guo_func.get_nextNumber('BCCREQUESTNO',ll_reqno,'WITH LOCK') then 
						return FALSE
					end if	
				
					ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000') 
					
					if trim(as_inserttype) = 'DEACTIVATE' then
	
						insert into BCC_DOCSIS_REQUEST
						(request_no, request_date, mac_address, serial_no, client_class, remarks, ref_trantype_code, ref_tran_no, parent_request_no, request_type_code, node_no /*provinceName*/ , user_name_add, date_add, division_code, company_code, processed, error_code, error_msg, processed_date, bcc_server_code, acct_no, subscriber_name, description, 
						subscriber_status_code, new_acct_no, new_sub_name, NEW_ACCT_DESC,
						CONTACT_PERSON,PACKAGE_CODE,DEVICE_MODEL,LAST_NAME,BATCH_NO,
						HOME_PHONE,WORK_PHONE,ADDRESS_1,ADDRESS_2,CITY,STATE,ZIP_CODE,IP_ADDRESS)
						values
						(:ls_reqno, getdate(), :ls_convertedmacaddress, :as_serialno, :ls_clientclassvalue, :as_reftrantypecode || '-' || :as_inserttype,  :as_reftrantypecode, :as_reftranno ,null, '011' , :li_nodeno, :gs_username, getdate(), :gs_divisioncode, :gs_companycode, 'N', null, null, null, '0000003', 'IBAS-'||:ls_companyid || :ls_divisionid || :ls_servicecode|| :as_acctno,  :ls_subscribername, 'DELMAC+DELSUB' , 
						:ls_subscriberstatuscode, null, null, null, substr(:ls_subscribername, 0,40), :ls_packagecode, :ls_model,substr(:ls_subscribername, 0,40),
						'001', :ls_telno, :ls_workphoneno, :ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode,:gs_ipaddress)
						using BCCTRANS;
						
						if not guo_func.set_Number('BCCREQUESTNO',ll_reqno) then
							return FALSE
						end if 
						
					elseif  trim(as_inserttype) = 'ACTIVATE' then
						
						insert into BCC_DOCSIS_REQUEST
						(request_no, request_date, mac_address, serial_no, client_class, remarks, ref_trantype_code, ref_tran_no, parent_request_no, request_type_code, node_no /*provinceName*/ , user_name_add, date_add, division_code, company_code, processed, error_code, error_msg, processed_date, bcc_server_code, acct_no, subscriber_name, description, 
						subscriber_status_code, new_acct_no, new_sub_name, NEW_ACCT_DESC,
						CONTACT_PERSON,PACKAGE_CODE,DEVICE_MODEL,LAST_NAME,BATCH_NO,
						HOME_PHONE,WORK_PHONE,ADDRESS_1,ADDRESS_2,CITY,STATE,ZIP_CODE,IP_ADDRESS)
						values
						(:ls_reqno, getdate(), :ls_convertedmacaddress, :as_serialno, :ls_clientclassvalue, :as_reftrantypecode || '-' || :as_inserttype,  :as_reftrantypecode, :as_reftranno ,null, '010' , :li_nodeno, :gs_username, getdate(), :gs_divisioncode, :gs_companycode, 'N', null, null, null, '0000003', 'IBAS-'||:ls_companyid || :ls_divisionid || :ls_servicecode|| :as_acctno,  :ls_subscribername, 'ADDSUB+ADDMACINV+ADDMAC' , 
						:ls_subscriberstatuscode, null, null, null, substr(:ls_subscribername, 0,40), :ls_packagecode, :ls_model, substr(:ls_subscribername, 0,40),
						'001', :ls_telno, :ls_workphoneno, :ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode,:gs_ipaddress)
						using BCCTRANS;
						
						if not guo_func.set_Number('BCCREQUESTNO',ll_reqno) then
							return FALSE
						end if
					
				
			end if 
			
			
		
		END IF
			if bcctrans.sqlcode <> 0 then
			//	messagebox('','')
			end if 
			commit using BCCTRANS;
			disconnect using BCCTRANS;
			destroy BCCTRANS;
	
	end if


		if ls_approachtype = 'TR-069' THEN
				
				
				if trim(as_reftrantypecode) = 'ADS' or trim(as_reftrantypecode) = 'APPLYPD' or trim(as_reftrantypecode) = 'APPLYDEAC' then
				
						if not guo_func.get_nextNumber('BCCREQUESTNO',ll_reqno,'WITH LOCK') then 
							return FALSE
						end if	
						
						ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000') 
						
						insert into BCC_DOCSIS_REQUEST
						(request_no, request_date, mac_address, serial_no, client_class, remarks, ref_trantype_code, ref_tran_no, parent_request_no, request_type_code, node_no /*provinceName*/ , user_name_add, date_add, division_code, company_code, processed, error_code, error_msg, processed_date, bcc_server_code, acct_no, subscriber_name, description, 
						subscriber_status_code, new_acct_no, new_sub_name, NEW_ACCT_DESC,
						CONTACT_PERSON,PACKAGE_CODE,DEVICE_MODEL,LAST_NAME,BATCH_NO,
						HOME_PHONE,WORK_PHONE,ADDRESS_1,ADDRESS_2,CITY,STATE,ZIP_CODE,IP_ADDRESS)
						values
						(:ls_reqno, getdate(), :as_macaddress, :as_serialno, 'FH-Locked', :as_reftrantypecode || '-' || :as_inserttype,  :as_reftrantypecode, :as_reftranno ,null, '016' , :li_nodeno, :gs_username, getdate(), :gs_divisioncode, :gs_companycode, 'N', null, null, null, '0000003', 'IBAS-'||:ls_companyid || :ls_divisionid || :ls_servicecode|| :as_acctno,  :ls_subscribername, 'ADS-APPLYPD FH-LOCKED' , 
						:ls_subscriberstatuscode, null, null, null, substr(:ls_subscribername, 0,40), :ls_packagecode, :ls_model, substr(:ls_subscribername, 0,40),
						'001', :ls_telno, :ls_workphoneno, :ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode,:gs_ipaddress)
						using BCCTRANS;	
					
						ll_reqno  = ll_reqno + 1
						ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000')
						
						insert into BCC_DOCSIS_REQUEST
						(request_no, request_date, mac_address, serial_no, client_class, remarks, ref_trantype_code, ref_tran_no, parent_request_no, request_type_code, node_no /*provinceName*/ , user_name_add, date_add, division_code, company_code, processed, error_code, error_msg, processed_date, bcc_server_code, acct_no, subscriber_name, description, 
						subscriber_status_code, new_acct_no, new_sub_name, NEW_ACCT_DESC,
						CONTACT_PERSON,PACKAGE_CODE,DEVICE_MODEL,LAST_NAME,BATCH_NO,
						HOME_PHONE,WORK_PHONE,ADDRESS_1,ADDRESS_2,CITY,STATE,ZIP_CODE,IP_ADDRESS)
						values
						(:ls_reqno, getdate(), :as_macaddress, :as_serialno,'FH-Locked' , :as_reftrantypecode || '-' || :as_inserttype,  :as_reftrantypecode, :as_reftranno ,null, '015' , :li_nodeno, :gs_username, getdate(), :gs_divisioncode, :gs_companycode, 'P', null, null, null, '0000003', 'IBAS-'||:ls_companyid || :ls_divisionid || :ls_servicecode|| :as_acctno,  :ls_subscribername, 'ADS-APPLYPD FH-LOCKED' , 
						:ls_subscriberstatuscode, null, null, null, substr(:ls_subscribername, 0,40), :ls_packagecode, :ls_model, substr(:ls_subscribername, 0,40),
						'001', :ls_telno, :ls_workphoneno, :ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode,:gs_ipaddress)
						using BCCTRANS;	
						
						if not guo_func.set_Number('BCCREQUESTNO',ll_reqno) then
							return FALSE
						end if		
				
				elseif trim(as_reftrantypecode) = 'ASSIGNEDCPE' then
					
						if not guo_func.get_nextNumber('BCCREQUESTNO',ll_reqno,'WITH LOCK') then 
							return FALSE
						end if	
						
						ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000') 
						
						insert into BCC_DOCSIS_REQUEST
						(request_no, request_date, mac_address, serial_no, client_class, remarks, ref_trantype_code, ref_tran_no, parent_request_no, request_type_code, node_no /*provinceName*/ , user_name_add, date_add, division_code, company_code, processed, error_code, error_msg, processed_date, bcc_server_code, acct_no, subscriber_name, description, 
						subscriber_status_code, new_acct_no, new_sub_name, NEW_ACCT_DESC,
						CONTACT_PERSON,PACKAGE_CODE,DEVICE_MODEL,LAST_NAME,BATCH_NO,
						HOME_PHONE,WORK_PHONE,ADDRESS_1,ADDRESS_2,CITY,STATE,ZIP_CODE,IP_ADDRESS)
						values
						(:ls_reqno, getdate(), :as_macaddress, :as_serialno, :ls_clientclassvalue, :as_reftrantypecode || '-' || :as_inserttype,  :as_reftrantypecode, :as_reftranno ,null, '014' , :li_nodeno, :gs_username, getdate(), :gs_divisioncode, :gs_companycode, 'N', null, null, null, '0000003', 'IBAS-'||:ls_companyid || :ls_divisionid || :ls_servicecode|| :as_acctno,  :ls_subscribername, 'ASSIGNEDCPE 014' , 
						:ls_subscriberstatuscode, null, null, null, substr(:ls_subscribername, 0,40), :ls_packagecode, :ls_model, substr(:ls_subscribername, 0,40),
						'001', :ls_telno, :ls_workphoneno, :ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode,:gs_ipaddress)
						using BCCTRANS;	
						
						if not guo_func.set_Number('BCCREQUESTNO',ll_reqno) then
							return FALSE
						end if		
						
				elseif  trim(as_reftrantypecode) = 'REACTIVATE' or trim(as_reftrantypecode) = 'ACTIVATEPDS' or trim(as_reftrantypecode) = 'ACTIVATEADS' then
					
						if not guo_func.get_nextNumber('BCCREQUESTNO',ll_reqno,'WITH LOCK') then 
							return FALSE
						end if	
						
						ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000') 
						
						insert into BCC_DOCSIS_REQUEST
						(request_no, request_date, mac_address, serial_no, client_class, remarks, ref_trantype_code, ref_tran_no, parent_request_no, request_type_code, node_no /*provinceName*/ , user_name_add, date_add, division_code, company_code, processed, error_code, error_msg, processed_date, bcc_server_code, acct_no, subscriber_name, description, 
						subscriber_status_code, new_acct_no, new_sub_name, NEW_ACCT_DESC,
						CONTACT_PERSON,PACKAGE_CODE,DEVICE_MODEL,LAST_NAME,BATCH_NO,
						HOME_PHONE,WORK_PHONE,ADDRESS_1,ADDRESS_2,CITY,STATE,ZIP_CODE,IP_ADDRESS)
						values
						(:ls_reqno, getdate(), :as_macaddress, :as_serialno, :ls_clientclassvalue, :as_reftrantypecode || '-' || :as_inserttype,  :as_reftrantypecode, :as_reftranno ,null, '014' , :li_nodeno, :gs_username, getdate(), :gs_divisioncode, :gs_companycode, 'N', null, null, null, '0000003', 'IBAS-'||:ls_companyid || :ls_divisionid || :ls_servicecode|| :as_acctno,  :ls_subscribername, 'ASSIGNEDCPE 014' , 
						:ls_subscriberstatuscode, null, null, null, substr(:ls_subscribername, 0,40), :ls_packagecode, :ls_model, substr(:ls_subscribername, 0,40),
						'001', :ls_telno, :ls_workphoneno, :ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode,:gs_ipaddress)
						using BCCTRANS;				
						
						if not guo_func.set_Number('BCCREQUESTNO',ll_reqno) then
							return FALSE
						end if		
						
				elseif  trim(as_reftrantypecode) = 'CHANGEPACK' or trim(as_reftrantypecode) = 'REPLACECM' then
					
						if not guo_func.get_nextNumber('BCCREQUESTNO',ll_reqno,'WITH LOCK') then 
							return FALSE
						end if	
						
						ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000') 
						
									IF as_inserttype = 'DEACTIVATE' then
									
										ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000') 
									
										insert into BCC_DOCSIS_REQUEST
										(request_no, request_date, mac_address, serial_no, client_class, remarks, ref_trantype_code, ref_tran_no, parent_request_no, request_type_code, node_no /*provinceName*/ , user_name_add, date_add, division_code, company_code, processed, error_code, error_msg, processed_date, bcc_server_code, acct_no, subscriber_name, description, 
										subscriber_status_code, new_acct_no, new_sub_name, NEW_ACCT_DESC,
										CONTACT_PERSON,PACKAGE_CODE,DEVICE_MODEL,LAST_NAME,BATCH_NO,
										HOME_PHONE,WORK_PHONE,ADDRESS_1,ADDRESS_2,CITY,STATE,ZIP_CODE,IP_ADDRESS)
										values
										(:ls_reqno, getdate(), :as_macaddress, :as_serialno, :ls_clientclassvalue, :as_reftrantypecode || '-' || :as_inserttype,  :as_reftrantypecode, :as_reftranno ,null, '015' , :li_nodeno, :gs_username, getdate(), :gs_divisioncode, :gs_companycode, 'N', null, null, null, '0000003', 'IBAS-'||:ls_companyid || :ls_divisionid || :ls_servicecode|| :as_acctno,  :ls_subscribername, 'ADS-APPLYPD FH-LOCKED' , 
										:ls_subscriberstatuscode, null, null, null, substr(:ls_subscribername, 0,40), :ls_packagecode, :ls_model, substr(:ls_subscribername, 0,40),
										'001', :ls_telno, :ls_workphoneno, :ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode,:gs_ipaddress)
										using BCCTRANS;	
							
										if not guo_func.set_Number('BCCREQUESTNO',ll_reqno) then
											return FALSE
										end if	
								
									end if					
						
									
									if  trim(as_inserttype) = 'ACTIVATE' then
										
										insert into BCC_DOCSIS_REQUEST
										(request_no, request_date, mac_address, serial_no, client_class, remarks, ref_trantype_code, ref_tran_no, parent_request_no, request_type_code, node_no /*provinceName*/ , user_name_add, date_add, division_code, company_code, processed, error_code, error_msg, processed_date, bcc_server_code, acct_no, subscriber_name, description, 
										subscriber_status_code, new_acct_no, new_sub_name, NEW_ACCT_DESC,
										CONTACT_PERSON,PACKAGE_CODE,DEVICE_MODEL,LAST_NAME,BATCH_NO,
										HOME_PHONE,WORK_PHONE,ADDRESS_1,ADDRESS_2,CITY,STATE,ZIP_CODE,IP_ADDRESS)
										values
										(:ls_reqno, getdate(), :as_macaddress, :as_serialno, :ls_clientclassvalue, :as_reftrantypecode || '-' || :as_inserttype,  :as_reftrantypecode, :as_reftranno ,null, '016' , :li_nodeno, :gs_username, getdate(), :gs_divisioncode, :gs_companycode, 'N', null, null, null, '0000003', 'IBAS-'||:ls_companyid || :ls_divisionid || :ls_servicecode|| :as_acctno,  :ls_subscribername, 'ASSIGNEDCPE 014' , 
										:ls_subscriberstatuscode, null, null, null, substr(:ls_subscribername, 0,40), :ls_packagecode, :ls_model, substr(:ls_subscribername, 0,40),
										'001', :ls_telno, :ls_workphoneno, :ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode,:gs_ipaddress)
										using BCCTRANS;	
										
										if not guo_func.set_Number('BCCREQUESTNO',ll_reqno) then
											return FALSE
										end if
									
									END IF
						
						
				elseif trim(as_reftrantypecode) = 'REFRESH' then				
						
					
							
								IF as_inserttype = 'DEACTIVATE' then
									
									if not guo_func.get_nextNumber('BCCREQUESTNO',ll_reqno,'WITH LOCK') then 
									return FALSE
									end if	
							
									ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000') 
								
									insert into BCC_DOCSIS_REQUEST
									(request_no, request_date, mac_address, serial_no, client_class, remarks, ref_trantype_code, ref_tran_no, parent_request_no, request_type_code, node_no /*provinceName*/ , user_name_add, date_add, division_code, company_code, processed, error_code, error_msg, processed_date, bcc_server_code, acct_no, subscriber_name, description, 
									subscriber_status_code, new_acct_no, new_sub_name, NEW_ACCT_DESC,
									CONTACT_PERSON,PACKAGE_CODE,DEVICE_MODEL,LAST_NAME,BATCH_NO,
									HOME_PHONE,WORK_PHONE,ADDRESS_1,ADDRESS_2,CITY,STATE,ZIP_CODE,IP_ADDRESS)
									values
									(:ls_reqno, getdate(), :as_macaddress, :as_serialno, 'FH-Locked', :as_reftrantypecode || '-' || :as_inserttype,  :as_reftrantypecode, :as_reftranno ,null, '016' , :li_nodeno, :gs_username, getdate(), :gs_divisioncode, :gs_companycode, 'N', null, null, null, '0000003', 'IBAS-'||:ls_companyid || :ls_divisionid || :ls_servicecode|| :as_acctno,  :ls_subscribername, 'ADS-APPLYPD FH-LOCKED' , 
									:ls_subscriberstatuscode, null, null, null, substr(:ls_subscribername, 0,40), :ls_packagecode, :ls_model, substr(:ls_subscribername, 0,40),
									'001', :ls_telno, :ls_workphoneno, :ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode,:gs_ipaddress)
									using BCCTRANS;	
									
									ll_reqno  = ll_reqno + 1
									ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000')
									
									insert into BCC_DOCSIS_REQUEST
									(request_no, request_date, mac_address, serial_no, client_class, remarks, ref_trantype_code, ref_tran_no, parent_request_no, request_type_code, node_no /*provinceName*/ , user_name_add, date_add, division_code, company_code, processed, error_code, error_msg, processed_date, bcc_server_code, acct_no, subscriber_name, description, 
									subscriber_status_code, new_acct_no, new_sub_name, NEW_ACCT_DESC,
									CONTACT_PERSON,PACKAGE_CODE,DEVICE_MODEL,LAST_NAME,BATCH_NO,
									HOME_PHONE,WORK_PHONE,ADDRESS_1,ADDRESS_2,CITY,STATE,ZIP_CODE,IP_ADDRESS)
									values
									(:ls_reqno, getdate(), :as_macaddress, :as_serialno, :ls_clientclassvalue, :as_reftrantypecode || '-' || :as_inserttype,  :as_reftrantypecode, :as_reftranno ,null, '015' , :li_nodeno, :gs_username, getdate(), :gs_divisioncode, :gs_companycode, 'P', null, null, null, '0000003', 'IBAS-'||:ls_companyid || :ls_divisionid || :ls_servicecode|| :as_acctno,  :ls_subscribername, 'ADS-APPLYPD FH-LOCKED' , 
									:ls_subscriberstatuscode, null, null, null, substr(:ls_subscribername, 0,40), :ls_packagecode, :ls_model, substr(:ls_subscribername, 0,40),
									'001', :ls_telno, :ls_workphoneno, :ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode,:gs_ipaddress)
									using BCCTRANS;	
						
									if not guo_func.set_Number('BCCREQUESTNO',ll_reqno) then
										return FALSE
									end if	
								
							else
								
							
									
								if not guo_func.get_nextNumber('BCCREQUESTNO',ll_reqno,'WITH LOCK') then 
									return FALSE
								end if	
								
								ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000') 
						
								insert into BCC_DOCSIS_REQUEST
								(request_no, request_date, mac_address, serial_no, client_class, remarks, ref_trantype_code, ref_tran_no, parent_request_no, request_type_code, node_no /*provinceName*/ , user_name_add, date_add, division_code, company_code, processed, error_code, error_msg, processed_date, bcc_server_code, acct_no, subscriber_name, description, 
								subscriber_status_code, new_acct_no, new_sub_name, NEW_ACCT_DESC,
								CONTACT_PERSON,PACKAGE_CODE,DEVICE_MODEL,LAST_NAME,BATCH_NO,
								HOME_PHONE,WORK_PHONE,ADDRESS_1,ADDRESS_2,CITY,STATE,ZIP_CODE,IP_ADDRESS)
								values
								(:ls_reqno, getdate(), :as_macaddress, :as_serialno, :ls_clientclassvalue, :as_reftrantypecode || '-' || :as_inserttype,  :as_reftrantypecode, :as_reftranno ,null, '015' , :li_nodeno, :gs_username, getdate(), :gs_divisioncode, :gs_companycode, 'N', null, null, null, '0000003', 'IBAS-'||:ls_companyid || :ls_divisionid || :ls_servicecode|| :as_acctno,  :ls_subscribername, 'ADD - REFRESH' , 
								:ls_subscriberstatuscode, null, null, null, substr(:ls_subscribername, 0,40), :ls_packagecode, :ls_model, substr(:ls_subscribername, 0,40),
								'001', :ls_telno, :ls_workphoneno, :ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode,:gs_ipaddress)
								using BCCTRANS;
								
									ll_reqno  = ll_reqno + 1
									ls_reqno = ls_year + ls_month + string(ll_reqno,'00000000') 
						
								insert into BCC_DOCSIS_REQUEST
								(request_no, request_date, mac_address, serial_no, client_class, remarks, ref_trantype_code, ref_tran_no, parent_request_no, request_type_code, node_no /*provinceName*/ , user_name_add, date_add, division_code, company_code, processed, error_code, error_msg, processed_date, bcc_server_code, acct_no, subscriber_name, description, 
								subscriber_status_code, new_acct_no, new_sub_name, NEW_ACCT_DESC,
								CONTACT_PERSON,PACKAGE_CODE,DEVICE_MODEL,LAST_NAME,BATCH_NO,
								HOME_PHONE,WORK_PHONE,ADDRESS_1,ADDRESS_2,CITY,STATE,ZIP_CODE,IP_ADDRESS)
								values
								(:ls_reqno, getdate(), :as_macaddress, :as_serialno, :ls_clientclassvalue, :as_reftrantypecode || '-' || :as_inserttype,  :as_reftrantypecode, :as_reftranno ,null, '014' , :li_nodeno, :gs_username, getdate(), :gs_divisioncode, :gs_companycode, 'N', null, null, null, '0000003', 'IBAS-'||:ls_companyid || :ls_divisionid || :ls_servicecode|| :as_acctno,  :ls_subscribername, 'ADD - REFRESH' , 
								:ls_subscriberstatuscode, null, null, null, substr(:ls_subscribername, 0,40), :ls_packagecode, :ls_model, substr(:ls_subscribername, 0,40),
								'001', :ls_telno, :ls_workphoneno, :ls_address_line1, :ls_address_line2, :ls_municipalityname, :ls_provincename, :ls_zipcode,:gs_ipaddress)
								using BCCTRANS;
		
		
								
								if not guo_func.set_Number('BCCREQUESTNO',ll_reqno) then
									return FALSE
									end if
								
								
								END IF
						
						end if
					end if 				
								
				end if
				
				
			if ls_approachtype = 'IPTV' THEN
				
				string ls_url
				blob lblb_args
				long ll_length
				string ls_cont
				
				iir_msgbox = CREATE n_ir_msgbox  
				iinet = CREATE n_inet
				//ls_url = "http://192.168.236.33/russel.php?"
				ls_url = "http://192.168.253.149:11223/v1/converge/provisioning_json/activateINET?brand=BCC&acctNo=&subscriberName="+ls_subscribername+"&nodeNo=0&macAddress="+as_macaddress+"&deviceModel=DPC2100R2&productId=IPTV_CLK"
				lblb_args = blob(ls_cont)
				ll_length = Len(lblb_args)
				
				iinet.GetURL(ls_url, iir_msgbox) 
				
				//"http://192.168.253.149:11223/v1/converge/provisioning_json/activateINET?brand=BCC&acctNo=""&subscriberName="+substr(ls_subscribername, 0,40)+"&nodeNo=0&macAddress="+as_macaddress+"&deviceModel=DPC2100R2&productId=IPTV_CLK"
			
		
			END IF 
		
		
				
		
		return TRUE

----------------------------------------------------		
			
		else
			//provisioning for iptv
		end if
						
	end if
next

is_msgno = "SM-0000002"
is_msgtrail = ""
is_sugtrail = ""

return 0


