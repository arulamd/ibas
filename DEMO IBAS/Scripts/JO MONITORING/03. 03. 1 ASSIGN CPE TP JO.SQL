str_acctNo_joNo lstr_jo
lstr_jo = message.powerObjectParm

is_joNo 			      = lstr_jo.joNo
is_serviceType 		= lstr_jo.serviceType
is_isDigital			= lstr_jo.isDigital
is_tranTypeCode	   = lstr_jo.tranTypeCode
is_jostatuscode		= lstr_jo.jostatuscode

string ls_objectname

if is_serviceType = 'CTV' then
	ls_objectname = "uo_stb"
elseif is_serviceType = 'INET' then
	ls_objectname = "uo_cm"
end if
iuo_cpe = CREATE USING ls_objectname

this.triggerevent("ue_postopen")

--VALIDASI ue_postopen

string 	ls_packageCode, ls_packageName, ls_isPrimary
long 	ll_noOfRequiredSTB, ll_qty
integer	li_ctr, li_noOfReqSTB, li_loop
		

uo_ws luo_workstation
if luo_workstation.setComputerName(gs_loginWorkStation) then
	luo_workstation.getDefaultLocationCode(is_wsdeflocationCode)
end if	

--QUERY DW HEADER
SELECT  joTranHdr.joNo ,
           joTranHdr.joDate ,
           joTranHdr.tranTypeCode ,
           joTranHdr.acctNo ,
           joTranHdr.linemanCode ,
           joTranHdr.referenceNo ,
           joTranHdr.joStatusCode,
			  '' subscribername ,
	 arPackageMaster.packageName    
        FROM joTranHdr      
	inner join arAcctSubscriber  on joTranHdr.acctno = arAcctSubscriber.acctNo 
		and joTranHdr.divisionCode = arAcctSubscriber.divisionCode and joTranHdr.companyCode = arAcctSubscriber.companyCode
	inner join arPackageMaster  on arAcctSubscriber.packageCode = arPackageMaster.packageCode 
		and arPackageMaster.divisionCode = arAcctSubscriber.divisionCode and arPackageMaster.companyCode = arAcctSubscriber.companyCode
        WHERE ( joTranHdr.joNo = :as_jono ) and (joTranHdr.divisionCode = :as_division) and (joTranHdr.companyCode = :as_company)  
--END QUERY		
dw_header.retrieve(is_joNo,gs_divisionCode, gs_companyCode)

uo_subscriber_def luo_subscriber
luo_subscriber = create uo_subscriber_def

if not luo_subscriber.setacctno(dw_header.getitemstring(dw_header.getrow(),'acctno')) then
	guo_func.msgbox("Warning",luo_subscriber.lastSqlCode+'~r~n'+luo_subscriber.lastSqlErrtext)
	return
end IF

--VALIDASI uo_subscriber.setacctno

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

--END VALIDASI

dw_header.setitem(dw_header.getrow(),'subscribername',luo_subscriber.subscribername)

if is_isDigital  = 'Y' then
	dw_detail.dataObject = 'dw_assign_cpe_digital'
else
	dw_detail.dataObject = 'dw_assign_sbt_to_jo_dtl'
end IF

--QUERY DW DETAIL IF is_isDigital  = 'Y'
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
              


--END QUERY DW DETAIL IF is_isDigital  = 'Y'
         
 --QUERY DW DETAIL IF is_isDigital  <> 'Y'
       SELECT joTranDtlAssignedCPE.serialNo,   
         joTranDtlAssignedCPE.itemCode,   
         joTranDtlAssignedCPE.originalAssignedCPE,   
         joTranDtlAssignedCPE.newSerialNo,   
         joTranDtlAssignedCPE.newItemCode, 
         serialNoMaster.controlNo, serialNoMaster.macAddress,  
         'N' newRecord,   
         joTranDtlAssignedCPE.acquisitionTypeCode,   
         '' selected,
         itemMaster.itemName,
         ''newItemName,joTranDtlAssignedCPE.newMacAddress ,
			joTranDtlAssignedCPE.lastassigneddate 
    FROM joTranDtlAssignedCPE  
   INNER JOIN serialNoMaster on joTranDtlAssignedCPE.serialNo = serialNoMaster.serialNo 
   AND serialNoMaster.divisionCode = joTranDtlAssignedCPE.divisionCode
   AND serialNoMaster.companyCode = joTranDtlAssignedCPE.companyCode
   INNER JOIN itemMaster on joTranDtlAssignedCPE.itemCode = itemMaster.itemCode
      AND itemMaster.companyCode = joTranDtlAssignedCPE.companyCode
   WHERE ( joTranDtlAssignedCPE.joNo = :as_jono ) AND  
         ( joTranDtlAssignedCPE.newItemCode is null )
         AND ( joTranDtlAssignedCPE.divisionCode = :as_division ) 
         AND ( joTranDtlAssignedCPE.companyCode = :as_company )
                  
 --END QUERY DW DETAIL

dw_detail.setTransObject(SQLCA);

if dw_detail.retrieve(is_joNo, gs_divisionCode, gs_companyCode) > 0 then
	ib_hasSTBAlready = TRUE	
	if is_isDigital = 'Y' then
		pb_new.enabled 		= FALSE
		pb_save.enabled 		= TRUE
		pb_cancel.enabled 	= TRUE
		pb_close.enabled 		= TRUE
		
		is_msgNo = ''
		is_msgTrail = ''
		is_sugTrail = ''
	else
		pb_new.trigger event clicked()
	end if
else
	if is_isDigital = 'Y' then
		if is_tranTypeCode = 'APPLYML' then
			select b.packageCode, c.packageName
			into :ls_packageCode, :ls_packageName
			from arAcctSubscriber b
			inner join arPackageMaster c on b.packageCode = c.packageCode
				 and c.divisionCode = b.divisionCode and c.companyCode = b.companyCode
			where b.referenceJONo = :is_joNo
			and b.divisionCode = :gs_divisionCode and b.companyCode = :gs_companyCode
			using SQLCA;
			if SQLCA.sqlcode < 0 then
				guo_func.msgBox("ATTENTION", string(SQLCA.sqlcode)+ ' '+SQLCA.sqlerrtext)
				return 
			end if			
			
			select noOfRequiredSTB into :li_noOfReqSTB 
			from   arAcctSubscriber 
			where  acctNo = :luo_subscriber.acctNo
		   and    divisionCode = :gs_divisionCode 
			and    companyCode  = :gs_companyCode
			using  SQLCA;
			if SQLCA.sqlcode < 0 then
				guo_func.msgBox("ATTENTION", string(SQLCA.sqlcode)+ ' '+SQLCA.sqlerrtext)
				return 
			end if
			
			if li_noOfReqSTB= 0 then li_noOfReqSTB	= 1						
			if isnull(li_noOfReqSTB) then li_noOfReqSTB	= 1						
			
			for li_loop = 1 to li_noOfReqSTB				
				dw_detail.scrollToRow(dw_detail.insertRow(0))
				dw_detail.setItem(dw_detail.getRow(),'packageCode',ls_packageCode)
				dw_detail.setItem(dw_detail.getRow(),'packageName',ls_packageName)
				dw_detail.setItem(dw_detail.getRow(),'isprimary','Y')				
			next	
				
		elseIf is_tranTypeCode = 'APPLEXTHO' then
		
			declare cur_CPE_hotel cursor for
				select a.packageCode, c.packageName, a.noOfRequiredSTB, b.qty
				from applOfExtHotelTranhdr a
				inner join applOfExtHotelTrandtl b on a.tranNo = b.tranNo
					 and a.divisionCode = b.divisionCode and a.companyCode = b.companyCode
				inner join arPackageMaster c on a.packageCode = c.packageCode
					 and c.divisionCode = b.divisionCode and c.companyCode = b.companyCode
				where a.referenceJONo = :is_joNo
				and a.divisionCode = :gs_divisionCode and a.companyCode = :gs_companyCode
				 using SQLCA;
			open cur_CPE_hotel;
			if SQLCA.sqlcode < 0 then
				guo_func.msgBox("ATTENTION", string(SQLCA.sqlcode)+ ' '+SQLCA.sqlerrtext)
				return 
			end if
			
			fetch cur_CPE_hotel into :ls_packageCode, :ls_packageName, :ll_noOfRequiredSTB, :ll_qty;
			if SQLCA.sqlcode < 0 then
				guo_func.msgBox("ATTENTION", string(SQLCA.sqlcode)+ ' '+SQLCA.sqlerrtext)
				return 
			end if
			
			do while SQLCA.sqlcode = 0
				for li_ctr = 1 to ll_qty
					dw_detail.scrollToRow(dw_detail.insertRow(0))
					dw_detail.setItem(dw_detail.getRow(),'packageCode',ls_packageCode)
					dw_detail.setItem(dw_detail.getRow(),'packageName',ls_packageName)
					dw_detail.setItem(dw_detail.getRow(),'noOfRequiredSTB',ll_noOfRequiredSTB)
				next
				fetch cur_CPE_hotel into :ls_packageCode, :ls_packageName, :ll_noOfRequiredSTB, :ll_qty;
				if SQLCA.sqlcode < 0 then
					guo_func.msgBox("ATTENTION", string(SQLCA.sqlcode)+ ' '+SQLCA.sqlerrtext)
					return 
				end if	
			loop
	
			close cur_CPE_hotel;
			
			
		elseIf is_tranTypeCode = 'APPLYEXT' then
				
			declare cur_CPE cursor for
				select b.packageCode, c.packageName, a.noOfRequiredSTB, b.qty
				from applOfExtTranHdr a
				inner join applOfExtTranDtl b on a.tranNo = b.tranNo
					 and a.divisionCode = b.divisionCode and a.companyCode = b.companyCode
				inner join arPackageMaster c on b.packageCode = c.packageCode
					 and c.divisionCode = b.divisionCode and c.companyCode = b.companyCode
				where a.referenceJONo = :is_joNo
				and a.divisionCode = :gs_divisionCode and a.companyCode = :gs_companyCode
				 using SQLCA;
			open cur_CPE;
			if SQLCA.sqlcode < 0 then
				guo_func.msgBox("ATTENTION", string(SQLCA.sqlcode)+ ' '+SQLCA.sqlerrtext)
				return 
			end if
			
			fetch cur_CPE into :ls_packageCode, :ls_packageName, :ll_noOfRequiredSTB, :ll_qty;
			if SQLCA.sqlcode < 0 then
				guo_func.msgBox("ATTENTION", string(SQLCA.sqlcode)+ ' '+SQLCA.sqlerrtext)
				return 
			end if
			
			do while SQLCA.sqlcode = 0
				for li_ctr = 1 to ll_qty
					dw_detail.scrollToRow(dw_detail.insertRow(0))
					dw_detail.setItem(dw_detail.getRow(),'packageCode',ls_packageCode)
					dw_detail.setItem(dw_detail.getRow(),'packageName',ls_packageName)
					dw_detail.setItem(dw_detail.getRow(),'noOfRequiredSTB',ll_noOfRequiredSTB)
				next
				fetch cur_CPE into :ls_packageCode, :ls_packageName, :ll_noOfRequiredSTB, :ll_qty;
				if SQLCA.sqlcode < 0 then
					guo_func.msgBox("ATTENTION", string(SQLCA.sqlcode)+ ' '+SQLCA.sqlerrtext)
					return 
				end if	
			loop
	
			close cur_CPE;
			
		elseIf is_tranTypeCode = 'APPLMLEXTREA' then
			
			s_appldeacinfo str_appldeacinfo
			if not luo_subscriber.getApplDeacInfo(str_appldeacinfo) then
				guo_func.msgBox("ATTENTION",  luo_subscriber.lastSQLCode + '~r~n' + luo_subscriber.lastSQLErrText + &
								  '~r~n Method Name : luo_subscriber.getApplDeacInfo()')
				return
			end if
			
			declare cur_reac cursor for
				select b.packageCode, c.packageName, b.isPrimary
				from applOfDeactivationTranHdr a
				inner join deactivationTranHdr d on a.referenceJoNo = d.jobOrderNo
					 and a.acctNo = d.acctNo
					 and a.divisionCode = d.divisionCode and a.companyCode = d.companyCode
				inner join deactivationTranDtl b on d.tranNo = b.tranNo
					 and d.divisionCode = b.divisionCode and d.companyCode = b.companyCode
				inner join arPackageMaster c on b.packageCode = c.packageCode
					 and c.divisionCode = b.divisionCode and c.companyCode = b.companyCode
				where a.referenceJONo = :str_appldeacinfo.joNo and a.acctNo = :luo_subscriber.acctNo
				and a.divisionCode = :gs_divisionCode and a.companyCode = :gs_companyCode
				
				union all
				
				select b.packageCode, c.packageName, b.isPrimary
				from applOfDeactivationTranHdr a
				inner join deactivationTranHdr d on a.tranDate = d.tranDate
					 and a.acctNo = d.acctNo
					 and a.divisionCode = d.divisionCode and a.companyCode = d.companyCode
				inner join deactivationTranDtl b on d.tranNo = b.tranNo
					 and d.divisionCode = b.divisionCode and d.companyCode = b.companyCode
				inner join arPackageMaster c on b.packageCode = c.packageCode
					 and c.divisionCode = b.divisionCode and c.companyCode = b.companyCode
				where a.referenceJONo = :str_appldeacinfo.joNo  and d.jobOrderNo = '00000000' and a.acctNo = :luo_subscriber.acctNo
				and a.divisionCode = :gs_divisionCode and a.companyCode = :gs_companyCode
				
				using SQLCA;
			open cur_reac;
			if SQLCA.sqlcode < 0 then
				guo_func.msgBox("ATTENTION", string(SQLCA.sqlcode)+ ' '+SQLCA.sqlerrtext)
				return 
			elseif SQLCA.sqlcode = 100 then
				close cur_reac;	
			else
				fetch cur_reac into :ls_packageCode, :ls_packageName, :ls_isPrimary;
				if SQLCA.sqlcode < 0 then
					guo_func.msgBox("ATTENTION", string(SQLCA.sqlcode)+ ' '+SQLCA.sqlerrtext)
					return 
				end if
				
				do while SQLCA.sqlcode = 0
					
					dw_detail.scrollToRow(dw_detail.insertRow(0))
					dw_detail.setItem(dw_detail.getRow(),'packageCode',ls_packageCode)
					dw_detail.setItem(dw_detail.getRow(),'packageName',ls_packageName)
					dw_detail.setItem(dw_detail.getRow(),'isPrimary',ls_isPrimary)
				
					fetch cur_reac into :ls_packageCode, :ls_packageName, :ls_isPrimary;
					if SQLCA.sqlcode < 0 then
						guo_func.msgBox("ATTENTION", string(SQLCA.sqlcode)+ ' '+SQLCA.sqlerrtext)
						return 
					end if	
				loop
		
				close cur_reac;	
			end if
			
		end if	
		pb_new.enabled 		= FALSE
		pb_save.enabled 		= TRUE
		pb_cancel.enabled 	= TRUE
		pb_close.enabled 		= TRUE
		
		is_msgNo = ''
		is_msgTrail = ''
		is_sugTrail = ''
	else
		pb_new.trigger event clicked()
	end if
end if

--VALIDASI ue_postopen

--EVENT SCRIPT ON DW_DETAIL BUTTON_CLICK

long 	ll_row
string 	ls_serialNo, ls_caSerialNo, ls_newSerialNo, ls_newCASerialNo,ls_oldSerialNo, ls_packageCode, ls_dateapplied, ls_today
string 	ls_acctNo, ls_selected, ls_newitemCode, ls_acctnorep
long	ll_noOfRereshedSTB, ll_records, ll_datediff
date	ldt_nullDate, ldt_lastassigneddate


if dwo.name = "b_replace" then

	str_replace_jo_stb istr_replace_jo_stb
	istr_replace_jo_stb.joNo 			= dw_header.getitemstring(1, "jono")
	istr_replace_jo_stb.serialNo 		= this.getitemstring(row, "serialno")
	istr_replace_jo_stb.servicetype 	= is_serviceType
	istr_replace_jo_stb.isDigital	 	= is_isDigital
	
	//Applied w/in 5 days for replace cpe
	select acctno into :ls_acctnorep
	from jotranhdr
	where jono = :istr_replace_jo_stb.joNo
	and divisioncode = :gs_divisionCode
	and companycode = :gs_companyCode
	using SQLCA;
	
	select trunc(getdate - dateapplied) into :ll_datediff
	from aracctsubscriber
	where acctno = :ls_acctnorep
	and divisioncode = :gs_divisionCode
	and companyCode = :gs_companyCode
	using SQLCA;
	
	if ll_datediff <= 5 then 
	
	openwithparm(w_replace_jo_stb_oaat, istr_replace_jo_stb)

	istr_replace_jo_stb = message.powerobjectparm
	if istr_replace_jo_stb.response = "OK" then
		
		if not isNull(istr_replace_jo_stb.newSerialNo) then
		
			if not iuo_cpe.setSerialNo(istr_replace_jo_stb.newSerialNo) then
				guo_func.msgbox("Error in SetTop Box Object", iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText)
				this.setitem(row,"selected",'N')
				return
			end if
			
			if not iuo_cpe.available() then
				guo_func.msgbox('Warning!', iuo_cpe.lastSQLCode + '~r~n~r~n' + iuo_cpe.lastSQLErrText)
				this.setitem(row,"selected",'N')
				return 
			end if
			
			this.setitem(row, "newSerialNo", istr_replace_jo_stb.newSerialNo)
			this.setitem(row, "newItemCode", istr_replace_jo_stb.newItemCode)
			this.setitem(row, "newitemname", istr_replace_jo_stb.newitemName )
			this.setitem(row, "newMacAddress", istr_replace_jo_stb.newMacAddress )
			
			// check for duplicates
			ll_row = this.find("serialNo = '" + istr_replace_jo_stb.newSerialNo + "'", 1, this.rowcount())
			if ll_row > 0 then
				guo_func.msgbox("Warning!", "The serial number you've just entered already exist")
				return
			end if
			
		end if
		
		if is_isDigital = 'Y' then
		
			if not iuo_cpe.setCASerialNo(istr_replace_jo_stb.newCASerialNo) then
				guo_func.msgbox("Error in SetTop Box Object", iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText)
				this.setitem(row,"selected",'N')
				return
			end if
			
			if not iuo_cpe.available() then
				guo_func.msgbox('Warning!', iuo_cpe.lastSQLCode + '~r~n~r~n' + iuo_cpe.lastSQLErrText)
				this.setitem(row,"selected",'N')
				return 
			end if
			
			this.setitem(row, "newCASerialNo", istr_replace_jo_stb.newCASerialNo)
			this.setitem(row, "newCAItemCode", istr_replace_jo_stb.newCAItemCode)
			this.setitem(row, "newCAitemname", istr_replace_jo_stb.newCAitemName )
			
			// check for duplicates
			ll_row = this.find("caserialNo = '" + istr_replace_jo_stb.newCASerialNo + "'", 1, this.rowcount())
			if ll_row > 0 then
				guo_func.msgbox("Warning!", "The serial number you've just entered is already exist")
				return
			end if
			
		end if
		
		//this.post dynamic event ue_add_replacement(istr_replace_jo_stb.newSerialNo, istr_replace_jo_stb.newItemCode, &
		//												istr_replace_jo_stb.newControlNo, istr_replace_jo_stb.newCASerialNo, istr_replace_jo_stb.newCAItemCode)
	end if
	
else 
	guo_func.msgbox("Warning!", "The Subscriber is 5 Days Old therefore it's cpe cannot be replaced.")
end if 
	
elseif dwo.name = 'b_digipick' then
	s_assigned_digipick str_digi
	
	if getItemString(row,'isprimary') = 'Y' then
		guo_func.msgbox("Warning!", "Cannot Load DigiPick Packages into a Primary CPE... Please select an extension.")		
		return 2
	end if	
		
	str_digi.joNo   		= dw_header.getitemstring(1, "jono")
	str_digi.acctNo 	   = dw_header.getitemstring(1, "acctno")
	str_digi.stbSerialNo	= getItemString(row,'serialno')
	str_digi.stbItemCode	= getItemString(row,'itemcode')
	str_digi.caSerialNo	= getItemString(row,'caserialno')
	str_digi.caItemCode  = getItemString(row,'caitemcode')
	
	openwithparm(w_digipick_packages_for_reactivation,str_digi)	

elseif dwo.name = 'b_refresh' then
		
	setNull(ldt_nullDate)
	
	ll_noOfRereshedSTB = 0
	
	ll_records = this.RowCount()
	for ll_row = 1 to ll_records
		ls_selected = this.GetItemString(ll_row, 'selected')
		if isnull(ls_selected) then ls_selected = 'N'
		
		if ls_selected = 'Y' then
			
			ll_noOfRereshedSTB += 1
			ls_oldSerialNo = this.GetItemString(ll_row, 'serialNo')
			ls_newSerialNo = this.GetItemString(ll_row, 'newserialNo')
			ls_newitemCode = this.GetItemString(ll_row, 'newItemCode')
			ls_acctNo	   = dw_header.GetItemString(1, 'acctNo')
			
			
			if is_isDigital = 'Y' then
				if not isNull(ls_newitemCode) then				
					ls_serialNo = ls_newSerialNo				
					ls_newCASerialNo 	= this.GetItemString(ll_row, 'newcaserialNo')				
				else
					ls_serialNo = ls_oldSerialNo
					ls_newCASerialNo 	= this.GetItemString(ll_row, 'caserialNo'	)  //i just used 1 variable -zar				
				end if
			else
				if isnull(ls_newSerialNo) or trim(ls_newSerialNo) = "" then 
					ls_serialNo = ls_oldSerialNo
				else
					ls_serialNo = ls_newSerialNo
				end if	
			end if	
			
			if iuo_cpe.setSerialNo(ls_serialNo) then
				
				uo_subscriber_def luo_subscriber
				luo_subscriber = create uo_subscriber_def
				
				if not luo_subscriber.setAcctNo(ls_acctNo) then
					guo_func.msgbox('SM-0000001', luo_subscriber.lastSQLCode + "~r~n" + luo_subscriber.lastSQLErrText, &
															'Method: luo_subscriber.setAcctNo()')
					return -1
				end if
				
				if luo_subscriber.chargeTypeCode = 'PPS' then
					--====================================================
					--allow only 3 days before expiration for prepaid subs
					--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
					ldt_nullDate = relativeDate(today(), 3)
				end if
				if is_serviceType = 'CTV'  and is_isDigital <> 'Y' then
					if not iuo_cpe.refresh(luo_subscriber.acctNo, luo_subscriber.packageCode, today(), ldt_nullDate, 'MANUAL REFRESH', luo_subscriber.subscriberStatusCode, luo_subscriber.chargeTypeCode) then
//						rollback using SQLCA;
						guo_func.msgbox('SM-0000001', iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText, &
																'Method: iuo_cpe.refresh()')
						return -1
					end if
				elseif is_serviceType = 'CTV'  and is_isDigital = 'Y' then
					
					ls_packageCode 	= this.GetItemString(ll_row, 'packagecode')
					
					
					iuo_cpe.setSCSRequestSource('ASSIGNTOEJO')
					if not iuo_cpe.entitle_jo_assignment(ls_serialNo,ls_newCaSerialNo, ls_packageCode, ls_acctNo) then
						guo_func.msgbox('SM-0000001', iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText, &
																'Method: iuo_cpe.entitle_assignment()')
						return -1
					end if
					
					
					string ls_packageCodes[]
					long   ll_dgRows, ll_dgLoop
					
					if not iuo_cpe.getJoAssignedDigiPick(is_joNo,ls_serialNo,ls_newCASerialNo,ls_packageCodes) then
						guo_func.msgbox('SM-0000001', iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText, &
																'Method: iuo_cpe.entitle_assignment()')						
						return -1
					end if
					
					ll_dgRows = upperBound(ls_packageCodes)
					for ll_dgLoop = 1 to ll_dgRows
						
						if not iuo_cpe.entitle_jo_assignment(ls_serialNo,ls_newCaSerialNo, ls_packageCodes[ll_dgLoop], ls_acctNo) then
							guo_func.msgbox('SM-0000001', iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText, &
																	'Method: iuo_cpe.entitle_assignment()')
							return -1
						end if						
					
					next
					
					
					/*if not iuo_cpe.setSCSRequestTranNo() then
						guo_func.msgbox('SM-0000001', iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText, &
																'Method: iuo_cpe.setSCSRequestTranNo - afer [entitle_jo_assignment]') 
						return -1
					end if*/
					
				elseif is_serviceType = 'INET' then
					string ls_errormsg
					
					update ipMaster
					set acctNo       = null, macAddress = null
					where macAddress = :iuo_cpe.macAddress
					and acctNo       = :luo_subscriber.acctNo
					and divisionCode = :gs_divisionCode
					and companyCode  = :gs_companyCode
					using SQLCA;
					
					if not uf_insertIntoMPThrilRequestMaster(luo_subscriber.acctNo, luo_subscriber.subsUserName, luo_subscriber.password, 'REFRESH', '', 'ACTIVATE', &
						iuo_cpe.serialNo, iuo_cpe.macAddress, ls_errormsg) then
						guo_func.msgbox('SM-0000002', ls_errormsg, is_sugtrail)
						return -1
					end if
				end if
			end if	
			
		end if
		
	next
	
	if ll_noOfRereshedSTB > 0 then
		guo_func.msgbox('Refresh CPE...', &
								'Your CPE has been qeued, please wait because this may take a minute')
		commit using SQLCA;
	end if

end IF

--END SCRIPT DW_DETAIL EVENT BUTTONCLIK


--BUTTON NEW

pb_new.enabled 		= FALSE
pb_save.enabled 		= TRUE
pb_cancel.enabled 	= TRUE
pb_close.enabled 		= TRUE

is_msgNo = ''
is_msgTrail = ''
is_sugTrail = ''

pb_add_line_item.enabled = TRUE
pb_delete_line_item.enabled = TRUE


uo_ws luo_workstation
if luo_workstation.setComputerName(gs_loginWorkStation) then
	luo_workstation.getDefaultLocationCode(is_wsdeflocationCode)
end if

if ib_hasSTBAlready <> TRUE then
	pb_add_line_item.triggerevent(Clicked!)
end IF

--END BUTTON NEW

--BUTTON SAVE
string	ls_itemCode, ls_controlNo, ls_serialNo, ls_origAssigned, ls_macAddress, ls_selected
string	ls_newItemCode, ls_newControlNo, ls_newSerialNo, ls_newRecord, ls_acquisitionTypeCode, ls_isPrimary
long		ll_records, ll_row, ll_tranno, ll_newRecords, ll_noOfRequiredSTB
date		ldt_nullDate

setNull(ldt_nullDate)
dw_detail.acceptText()

uo_jo_nv luo_jo
if not luo_jo.setJoNo(is_joNo) then
	is_msgno = "SM-0000001"
	is_msgtrail = luo_jo.lastSQLCode + "~r~n" + luo_jo.lastSQLErrText
	is_sugtrail = 'Error produced by luo_jo.setJoNo()'
	return -1
end IF

--validasi luo_jo.setJoNo(is_joNo)
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
--end validasi setJoNo

uo_subscriber_def luo_subscriber
luo_subscriber = create uo_subscriber_def

if not luo_subscriber.setAcctNo(luo_jo.acctNo) then
	is_msgno = "SM-0000001"
	is_msgtrail = luo_subscriber.lastSQLCode + "~r~n" + luo_subscriber.lastSQLErrText
	is_sugtrail = 'Error produced by luo_subscriber.setAcctNo()'
	return -1
end IF

--validasi luo_subriber.setAcctNo


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

--end validasi

if not luo_jo.getNoOfRequiredSTB(ll_noOfRequiredSTB) then
	is_msgno = "SM-0000001"
	is_msgtrail = luo_jo.lastSQLCode + "~r~n" + luo_jo.lastSQLErrText
	is_sugtrail = 'Error produced by luo_jo.getNoOfRequiredSTB()'
	return -1
end IF

--validasi  luo_jo.getNoOfRequiredSTB(ll_noOfRequiredSTB)
	al_noOfRequiredSTB = 0
	if tranTypeCode = 'APPLYML' then
		select noOfRequiredSTB
		into   :al_noOfRequiredSTB
		from   arAcctSubscriber
		where acctno = :acctno
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using sqlca;
		if SQLCA.sqlcode <> 0 then
			lastSQLCode 	= string(SQLCA.sqlcode)
			lastSQLErrText = SQLCA.sqlerrtext
			al_noOfRequiredSTB = 0
			return FALSE
		end if
	elseif tranTypeCode = 'APPLYEXT' then
		select noOfRequiredSTB
		  into :al_noOfRequiredSTB
		  from applOfExtTranHdr
		 where tranNo = :referenceNo
		 and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;
		if SQLCA.sqlcode <> 0 then
			lastSQLCode 	= string(SQLCA.sqlcode)
			lastSQLErrText = SQLCA.sqlerrtext
			al_noOfRequiredSTB = 0
			return FALSE
		end if
	elseif tranTypeCode = 'APPLEXTHO' then
		select noOfRequiredSTB
		  into :al_noOfRequiredSTB
		  from applOfExtHOTELTranHdr
		 where tranNo = :referenceNo
		 and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;
		if SQLCA.sqlcode <> 0 then
			lastSQLCode 	= string(SQLCA.sqlcode)
			lastSQLErrText = SQLCA.sqlerrtext
			al_noOfRequiredSTB = 0
			return FALSE
		end if
	elseif tranTypeCode = 'APPLMLEXTREA' then
		select noOfRequiredSTB
		  into :al_noOfRequiredSTB
		  from applOfReactivationTranHdr
		 where tranNo = :referenceNo
		 and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;
		if SQLCA.sqlcode <> 0 then
			lastSQLCode 	= string(SQLCA.sqlcode)
			lastSQLErrText = SQLCA.sqlerrtext
			al_noOfRequiredSTB = 0
			return FALSE
		end if	
	elseif tranTypeCode = 'APPLEXTD' then
		select noOfRequiredSTB
		  into :al_noOfRequiredSTB
		  from applOfExtDiscTranHdr
		 where tranNo = :referenceNo
		 and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;
		if SQLCA.sqlcode <> 0 then
			lastSQLCode 	= string(SQLCA.sqlcode)
			lastSQLErrText = SQLCA.sqlerrtext
			al_noOfRequiredSTB = 0
			return FALSE
		end if	
	else
		al_noOfRequiredSTB = 0
	end if
	
	return TRUE
-- end validasi 


ll_newRecords = 0
ll_records = dw_detail.rowcount()
for ll_row = 1 to ll_records	
	ls_serialNo			= trim(dw_detail.object.serialNo[ll_row])	
	ls_newSerialNo	= trim(dw_detail.object.newSerialNo[ll_row])	
	
	if isnull(ls_serialNo) then continue
	--if not isnull(ls_newSerialNo) then continue
	
	ll_newRecords = ll_newRecords + 1
next

if ll_newRecords <> ll_noOfRequiredSTB then
	is_msgno = "SM-0000001"
	is_msgtrail = 'This J.O. being assigned CPE requires ' + string(ll_noOfRequiredSTB) + '~r~n' + &
						'Excess or less serial number is not necessary.'
	is_sugtrail = 'You may delete or add  some records to comply with the requirements.'
	return -1
end if

if not iuo_cpe.getSCSRequestNextTranNo() then
	is_msgno = 'SM-0000001'
	is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
	is_sugtrail = 'Error produced by iuo_cpe.getSCSRequestNextTranNo()'
	return -1
end if	

--validasi iuo_cpe.getSCSRequestNextTranNo()
	long ll_tranNo
	string ls_errormsg
	if not guo_func.get_nextnumber('SCSREQUEST', ll_tranno, 'WITH LOCK') then
		lastSQLCode = '-2'
		lastSQLErrText = 'Could not obtain the next SCS Request No.'
		Return False
	end IF
	
	--validasi guo_func.get_nextnumber('SCSREQUEST', ll_tranno, 'WITH LOCK')
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
		
	--end validasi guo_func.get_nextnumber
	
	scsRequestNextTranNo = ll_tranNo
	
	Return TRUE
	
--end validasi 


iuo_cpe.decrementscsnexttranno( )

--validasi iuo_cpe.decrementscsnexttranno
	scsRequestNextTranNo --
--end validasi


iuo_cpe.setSCSRequestSource('ASSIGNTOEJO')

--validasi iuo_cpe.setSCSRequestSource
	scsRequestSourceTransaction 	= as_sourceTransaction --(ASSIGNTOEJO)
--end validasi

--------[ end of prerequisite (#1) ]-------- 

is_joNo = dw_header.getitemstring(1, "jono")

ll_records = dw_detail.rowcount()
for ll_row = 1 to ll_records
	
	ls_serialNo 				= trim(dw_detail.object.serialNo[ll_row])
	ls_itemCode 				= trim(dw_detail.object.itemCode[ll_row])
	ls_macAddress 				= trim(dw_detail.object.macAddress[ll_row])
	ls_newItemCode			= trim(dw_detail.object.newItemCode[ll_row])
	ls_newSerialNo			= trim(dw_detail.object.newSerialNo[ll_row])
	ls_origAssigned			= trim(dw_detail.object.originalassignedcpe[ll_row])
	ls_newRecord				= trim(dw_detail.object.newRecord[ll_row])
	ls_acquisitionTypeCode 	= trim(dw_detail.object.acquisitionTypeCode[ll_row])
	ls_selected				 	= trim(dw_detail.object.selected[ll_row])
	ls_isPrimary			   = 'Y' //trim(dw_detail.object.isprimary[ll_row])
	
	if isnull(ls_serialNo) or ls_serialNo = '' then continue

	if not iuo_cpe.setSerialNo(ls_serialNo) then
		is_msgno = "SM-0000001"
		is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
		is_sugtrail = ""
		return -1
	end if	
	
	--validasi setSerialNo if serviceType = 'CVT'
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
		--end if serviceType = 'CVT'
			
	     -- VALIDASI IF SERVICEyPE = 'INET'
			
			serialNo = trim(as_serialno)

				--check if existing
				if gb_sharedInventory then
					messagebox('1','1')
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
					messagebox('2','2')
					
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
	     --END VALIDASI 


	if not iuo_cpe.preAssignToSubscriber(luo_subscriber.acctNo) then
		is_msgno = "SM-0000001"
		is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
		is_sugtrail = 'Object.Method: iuo_cpe.preAssignToSubscriber()'
		return -1
	end IF
	
	--validasi preAssignToSubscriber
	 
	acctNo = as_acctNo

		if isNull(as_locationCode) then as_locationCode = ''
		
		if trim(as_locationCode) = '' then
			update serialNoMaster
				set serialNoStatusCode = 'PA',
					 acctNo = :as_acctNo
			 where serialNo = :serialNo
			 	and divisionCode = :gs_divisionCode
				and companyCode = :gs_companyCode
			using SQLCA;
			if SQLCA.sqlcode < 0 then
				lastSQLCode = string(SQLCA.sqlcode)
				lastSQLErrText = SQLCA.sqlerrtext
				return FALSE
			end if
		else
			update serialNoMaster
				set serialNoStatusCode = 'PA',
					 acctNo = :as_acctNo,
					 locationCode = :as_locationCode
			 where serialNo = :serialNo
			 	and divisionCode = :gs_divisionCode
				and companyCode = :gs_companyCode
			using SQLCA;
			if SQLCA.sqlcode < 0 then
				lastSQLCode = string(SQLCA.sqlcode)
				lastSQLErrText = SQLCA.sqlerrtext
				return FALSE
			end if
		end if
		
		return TRUE	
	--end validasi 
	
	if not isNull(ls_newItemCode) then
		
		update joTranDtlAssignedCPE 
			set newItemCode 			= :ls_newItemCode,
				 newSerialNo			= :ls_newSerialNo,
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
		end IF
		
		--validasi cancelPreAssignment
		setNull(acctNo)

			if gb_sharedInventory then
				update serialNoMaster
					set serialNoStatusCode = 'AV',
						 acctNo = null
				 where serialNo = :serialNo
				 and   companyCode = :gs_companyCode
				 and   divisionCode in (select divisionCode 
				 					         from   sysDivisionGroupMembersIC
												where  divisionGroupCode = :gs_divisionGroupCode)									
				 using SQLCA;
			else
				update serialNoMaster
					set serialNoStatusCode = 'AV',
						 acctNo = null
				 	where serialNo = :serialNo
				 	and divisionCode = :gs_divisionCode
					and companyCode = :gs_companyCode
				using SQLCA;
			end if	
			if SQLCA.sqlcode < 0 then
				lastSQLCode = string(SQLCA.sqlcode)
				lastSQLErrText = SQLCA.sqlerrtext
				return FALSE
			end if
			
			return TRUE
		--end validasi
		
		
		if not iuo_cpe.setSerialNo(ls_newserialNo) then
			is_msgno = "SM-0000001"
			is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
			is_sugtrail = ""
			return -1
		end if	
		
		--validasi setSerialNo if serviceType = 'CVT'
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
		--end if serviceType = 'CVT'
			
	     -- VALIDASI IF SERVICEyPE = 'INET'
			
			serialNo = trim(as_serialno)

				--check if existing
				if gb_sharedInventory then
					messagebox('1','1')
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
					messagebox('2','2')
					
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
	     --END VALIDASI 		
	
	
	   string ls_currLocName
		
		messagebox('is_wsdeflocationCode',is_wsdeflocationCode)
	
		if is_joStatusCode = 'FR' then
		
			if upper(iuo_cpe.locationCode) <> upper(is_wsdeflocationCode) then
				
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
			
				guo_func.msgBox('Warning!','Serial No. [' + ls_newSerialNo+ '] is currently in location [' + trim(ls_currLocName) + ']' )	
				return -1	
				
			end if
			
		elseif is_joStatusCode = 'OG' then
			
			if upper(iuo_cpe.locationCode) <> upper(luo_jo.lineManCode) then
				
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
			
				guo_func.msgBox('Warning!','Serial No. [' + ls_newSerialNo+ '] is currently in location [' + trim(ls_currLocName) + ']' )	
				return -1
			end if
			
		end if	
		
		if not iuo_cpe.preAssignToSubscriber(luo_subscriber.acctNo) then
			is_msgno = "SM-0000001"
			is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
			is_sugtrail = 'Object.Method: iuo_cpe.preAssignToSubscriber()'
			return -1
		end if
		--now, we have to deactivate replaced box 
		--PRE-REQUISITE: scsRequestNextTranNo and scsRequestSourceTransaction (#2)
		--must be set outside the loop if any
		
		iuo_cpe.incrementscsrequesttranno( )
		if not iuo_cpe.deactivate() then
			is_msgno = "SM-0000001"
			is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
			is_sugtrail = 'Error produced by iuo_cpe.deactivate()'
			return -1
		end if
		--------[ end of prerequisite (#2) ]--------
		
		if not iuo_cpe.deleteFromSTBPackages() then
			is_msgno = "SM-0000001"
			is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
			is_sugtrail = "Method: iuo_cpe.deleteFromSTBPackages()"
			return -1
		end if
		
		--this portions 
		if luo_subscriber.chargeTypeCode = 'PPS' then
			if not iuo_cpe.takePlaceInSTBPPCLoad(ls_newSerialNo) then
				is_msgno = "SM-0000001"
				is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
				is_sugtrail = "Method: iuo_cpe.takePlaceInSTBPPCLoad()"
				return -1
			end if
		end IF
		
		--valid
		
	end if
	
	if ls_selected = 'Y' then
		ls_origAssigned 	= 'N'
		ls_serialNo 	 	= ls_newSerialNo
	end if
	
	if ls_newRecord = 'Y' or not IsNull(ls_newSerialNo)  then
		
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
						macAddress,
						packageCode,
						isPrimary)
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
						null,
						:luo_subscriber.packageCode,
						:ls_isPrimary)
				using SQLCA;
		if SQLCA.sqlcode <> 0 then
			is_msgno = "SM-0000001"
			is_msgtrail = string(SQLCA.sqlcode) + "~r~n" + SQLCA.sqlerrtext
			is_sugtrail = ""
			return -1
		end if
		
		
		insert into JOTRANDDTLASSIGNEDCPETRAIL (
						joNo,
						itemCode,
						serialNo,
						originalAssignedCPE,
						acquisitionTypeCode,
						lastAssignedBy,
						lastAssignedDate,
						divisionCode,
						companyCode,
						macAddress,
						packageCode,
						isPrimary)
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
						null,
						:luo_subscriber.packageCode,
						:ls_isPrimary)
				using SQLCA;
		if SQLCA.sqlcode <> 0 then
			is_msgno = "SM-0000001"
			is_msgtrail = string(SQLCA.sqlcode) + "~r~n" + SQLCA.sqlerrtext
			is_sugtrail = ""
			return -1
		end if
		
		if luo_subscriber.chargeTypeCode = 'PPS' then
			--====================================================
			--allow only 3 days before expiration for prepaid subs
			--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			ldt_nullDate = relativeDate(today(), 3)
		end if

		if not iuo_cpe.insertIntoSTBPackages(luo_subscriber.acctNo, luo_subscriber.packageCode, today(), ldt_nullDate, 'ASSIGN SBT TO E-JO') then
			is_msgno = "SM-0000001"
			is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
			is_sugtrail = 'Object.Method: iuo_cpe.insertIntoSTBPackages()'
			return -1
		end IF
		
		--validasi iuo_cpe.insertIntoSTBPackages
			--==================================================
			--Note:
			--this uses the as_acctNo argument 'coz sometimes 
			--the STB is not yet assigned to a subscriber
			--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		
			if not isnull(adt_expirationDate) then
				if adt_dateLoaded > adt_expirationDate then
					lastSQLCode 	= '-2'
					lastSQLErrText = 'Unable to continue. The date loaded is greater than the expiration date.'
					return FALSE
				end if
			end if
			
			update stbPackages
				set dateLoaded 	 = :adt_dateLoaded,
					 expirationDate = :adt_expirationDate,
					 remarks			 = :as_remarks
			 where serialNo = :serialNo
			 	and divisionCode = :gs_divisionCode
			and companyCode = :gs_companyCode
			and packageCode = :as_packageCode
			 using SQLCA;
			if SQLCA.sqlNRows <= 0 then 		
			
				insert into stbPackages (
								serialNo,
								packageCode,
								boxIdNo,
								itemCode,
								controlNo,
								acctNo,
								dateLoaded,
								expirationDate,
								remarks,
								divisionCode,
								companyCode)
					  values (
								:serialNo,
								:as_packageCode,
								:boxIdNo,
								:itemCode,
								:controlNo,
								:as_acctNo,
								:adt_dateLoaded,
								:adt_expirationDate,
								:as_remarks,
								:gs_divisionCode,
								:gs_companyCode)
						using SQLCA;
				if SQLCA.sqlcode < 0 then
					lastSQLCode 	= string(SQLCA.sqlCode)
					lastSQLErrText = SQLCA.sqlErrText
					return FALSE
				end if
				
			end if
			
			return TRUE
		
		--end validasi iuo_cpe.insertIntoSTBPackages
		
		--====================================================
		--since this box is just assigned, let's initialize it
		-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		
		--PRE-REQUISITE: scsRequestNextTranNo and scsRequestSourceTransaction (#2)
		--must be set outside the loop if any
		iuo_cpe.incrementscsrequesttranno( )
		
		--VALIDASI incrementscsrequesttranno
			scsRequestNextTranNo++
		--END VALIDASI
		
		if not iuo_cpe.initialize() then
			is_msgno = "SM-0000001"
			is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
			is_sugtrail = 'Error produced by iuo_cpe.initialize()'
			return -1
		end IF
		
		--validasi iuo_cpe.initialize()
		if f_scsControllerEnabled() then
				string 	lsa_line_details[], ls_convertedSno, ls_command, ls_boxNo
				string	as_channelType, ls_tiers
				integer 	li_ctr
				
				if boxIdNo < 1 then
					lastSQLCode = '-2'
					lastSQLErrText = 'Unable to initialize 0 box Id No.' + '~r~n~r~n' + &
											'Assigning of Box ID No. is required for newly received STB(s).'
					Return False
				end if
				
				--let's store 86 as default channel type
				--this is supposed to be an argument passed to this function
				as_channelType = '115'
				
				ls_convertedSno = convertSerialNo(serialNo)
				
				ls_command = ''
				generateBoxIDCommand(boxIdNo, ls_command)
				ls_command = trim(ls_command)
				ls_boxNo    = trim(string(boxIdNo))
				
				if isnull(as_channelType) or trim(as_channelType) = '' then	as_channelType = '86'
				
				li_ctr = 0
				
				lsa_line_details[upperbound(lsa_line_details) + 1] = "DE/"+ls_boxNo
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;93;" + ls_command 
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;5F;" + ls_command +";"+ ls_convertedSno + "D8;D0;C8;C0"
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4F;" + ls_command +";18;10;08;00"
				
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/F9;D8;D0;C8;C0;" + ls_command 
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/F9;D8;D0;C8;C0;" + ls_command 
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/F9;D8;D0;C8;C0;" + ls_command 
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;8C;"+ls_command+";7F;07;0A"
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FE;"+ls_command							
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;8D;"+ls_command
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;44;"+ls_command+";00;00"
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;95;"+ls_command+";40"
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;47;"+ls_command+";BF"		
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;96;"+ls_command+";0E"
				
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4A;"+ls_command+";FF"
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;49;"+ls_command+";00"
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;98;"+ls_command+";03;00;00;00"
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4B;"+ls_command+";BF"
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;48;"+ls_command+";00"
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/E9;"+ls_command+";FF"  
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/EA;"+ls_command+";FF"	 					  
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;8E;"+ls_command							  
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;50;"+ls_command+";00"
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4D;"+ls_command+";00;00;03;03;02;03;04;05;06;07"
				
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4D;"+ls_command+";01;00;08;09;0A;0B;0C;0D;0E;0F"
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4D;"+ls_command+";02;00;10;11;12;13;14;15;16;17"
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4D;"+ls_command+";03;00;18;19;1a;1b;1c;1d;1e;1f"
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4D;"+ls_command+";04;00;20;21;22;23;24;25;26;27"
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4D;"+ls_command+";05;00;28;29;2A;2B;2C;2D;2E;2F"
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4D;"+ls_command+";06;00;30;31;32;33;34;35;36;37"
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4D;"+ls_command+";07;00;38;39;3A;3B;3C;3D;3E;3F"				
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4D;"+ls_command+";08;00;40;41;42;43;44;45;46;47"
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4D;"+ls_command+";09;00;48;49;4A;4B;4C;4D;4E;4F"
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4D;"+ls_command+";0A;00;50;51;52;53;54;55;56;57"
				
				--line 41
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4D;"+ls_command+";0B;00;58;59;5A;5B;5C;5D;5E;5F" 
				
				Choose case as_channelType
					Case '115'
						lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4C;"+ls_command+";0C;00;60;62;62;63;64;65;66;67"		
						lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4C;"+ls_command+";0D;00;68;69;6A;6B;6C;6D;6E;6F"
						lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4C;"+ls_command+";0E;00;70;71;72;73;7F;7F;7F;7F"
					Case '102'
						lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4D;"+ls_command+";0C;00;60;62;62;63;64;65;66;7F"
					Case '100'
						lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4D;"+ls_command+";0C;00;60;62;62;63;64;7F;7F;7F"
					Case Else 
						//--86 channels
						lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4C;"+ls_command+";0C;0F;60;62;62;63;64;7F;7F;7F"
				End choose
					
				Choose case as_channelType
					Case '115'
						lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4D;"+ls_command+";1F;0F;7F;7F;7F;7F;02;03;73;73"
					Case '102'
						lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4C;"+ls_command+";1F;0F;7F;7F;7F;7F;02;03;66;66" 
					Case '100'
						lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4D;"+ls_command+";1F;0F;7F;7F;7F;7F;02;03;63;63"
					Case Else 
						//--86 channels
						lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4D;"+ls_command+";1F;0F;7F;7F;7F;7F;02;03;56;63"
				End choose
				
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4E;"+ls_command+";40"
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/FD;4E;"+ls_command+";18"
				lsa_line_details[upperbound(lsa_line_details) + 1] = "ST/F9;"+ls_command+";D8;D0;C8;C0"
				lsa_line_details[upperbound(lsa_line_details) + 1] = "AU/"+ls_boxNo
				
				if isnull(tiers) or tiers = '' then	
					if not getTiers(tiers) then
						Return False
					end if
				end if
				
				tiers = trim(tiers)
				
				if tiers = '' then
					lastSQLCode = '-2'
					lastSQLErrText = 'Unable to continue. The box being initialized has no tier.' + '~r~n~r~n' + &
											'Check the package of the subscriber if it has tiers assigned.'
				
					string ls_packages
					integer i					
					for i = 1 to upperBound(str_stbPackages)
						ls_packages = '~t' + str_stbPackages[i].packageCode + '~r~n'
					next
					if isNull(ls_packages) then ls_packages = ''
					
					if ls_packages <> '' then
						lastSQLErrText = lastSQLErrText + '~r~n' + &
											  'Loaded Packages : ' + '~r~n' + &
											  ls_packages
					end if
											
					Return False
				end if
				
				lsa_line_details[upperbound(lsa_line_details) + 1] = "AD/"+ls_boxNo + ';' + tiers
				
				if not postSCSRequest(lsa_line_details, 'ST') then
					Return False
				end if
			else	
				
				if isDigital = 'Y' or isCaCard = 'Y' then
					--closed due to testing, hehehe
					if not entitle() then
						return false
					end if	
				else
					if not csbInitializeSTB() then
						Return False
					end if		
				end if	
			end if	
			
			Return True

		--end validasi initialize
		
		--------[ end of prerequisite (#2) ]--------
				
	end if
next

if not iuo_cpe.setSCSRequestTranNo() then
	is_msgno = 'SM-0000001'
	is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
	is_sugtrail = 'Error produced by iuo_cpe.setSCSRequestTranNo()'
	return -1
end if	

--VALIDASI  setSCSRequestTranNo

if not guo_func.set_number('SCSREQUEST', scsRequestNextTranNo) then	
	lastSQLCode = '-2'
	lastSQLErrText = 'Could not set the next SCS Request No.'
	Return False
end IF

	--VALIDASI guo_func.set_number('SCSREQUEST', scsRequestNextTranNo)
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

--END VALIDASI setSCSRequestTranNo

is_msgno = "SM-0000002"
is_msgtrail = ""
is_sugtrail = ""

return 0
--END BUTTON SAVE

