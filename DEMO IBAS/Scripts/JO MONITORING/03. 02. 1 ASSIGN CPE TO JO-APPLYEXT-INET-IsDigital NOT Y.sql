--PROSES assign_cpe_to_jo

lstr_jo.joNo 				= dw_jo.getitemstring(dw_jo.getrow(), "jono")
lstr_jo.serviceType 	= dw_jo.getitemstring(dw_jo.getrow(), "servicetype")
lstr_jo.isDigital		 	= dw_jo.getitemstring(dw_jo.getrow(), "isdigital")
lstr_jo.tranTypeCode 	= dw_jo.getitemstring(dw_jo.getrow(), "tranTypeCode")
lstr_jo.jostatuscode = dw_jo.getitemstring(dw_jo.getrow(), "jostatuscode")

if (lstr_jo.tranTypeCode = 'APPLYEXT' and lstr_jo.serviceType = 'INET' ) then
openwithparm(w_assign_cpe_to_jo_iptv, lstr_jo)
end if 

--QUERY DW HEAADER
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
-- END QUERY DW HEAADER

--QUERY DW_DETAIL
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
              

--END QUERY

--OPEN WINDOW POP UP

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
boolean hasPrimaryIPTV = False
long ll_ctr_iptv_mainline

string ls_acctNo


uo_ws luo_workstation
if luo_workstation.setComputerName(gs_loginWorkStation) then
	luo_workstation.getDefaultLocationCode(is_wsdeflocationCode)
end if		
		
dw_header.retrieve(is_joNo,gs_divisionCode, gs_companyCode)

ls_acctNo = dw_header.getItemString(1,'acctNo')

select count(*) into :ll_ctr_iptv_mainline
from subscriberCpeMaster
where acctNo = :ls_acctNo
and divisionCode = :gs_divisionCode
and companyCode = :gs_companyCode
and cpetypeCOde = 'IPTV'
and isprimary = 'Y'
using SQLCA;

if ll_ctr_iptv_mainline > 0 then
	hasPrimaryIPTV = True
end if


uo_subscriber_def luo_subscriber
luo_subscriber = create uo_subscriber_def

if not luo_subscriber.setacctno(dw_header.getitemstring(dw_header.getrow(),'acctno')) then
	guo_func.msgbox("Warning",luo_subscriber.lastSqlCode+'~r~n'+luo_subscriber.lastSqlErrtext)
	return
end if

dw_header.setitem(dw_header.getrow(),'subscribername',luo_subscriber.subscribername)

if is_isDigital  = 'Y' then
	dw_detail.dataObject = 'dw_assign_cpe_digital_IPTV'
else
	dw_detail.dataObject = 'dw_assign_cpe_digital_IPTV'
end if
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
	if is_isDigital = 'N' then
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
		
	elseif is_trantypecode = 'APPLYEXT' and is_servicetype = 'INET' then
		
		string ls_itemcode, ls_itemname, ls_serialno
		declare cur_addon cursor for
				select i.itemcode, i.itemname, a.serialno from sold_add_on_items a
				inner join itemmaster i on i.itemcode = a.itemcode and i.companycode = a.companycode
				where a.jono	= :is_jono and a.acctNo = :luo_subscriber.acctNo
				and a.divisionCode = :gs_divisionCode and a.companyCode = :gs_companyCode
				using SQLCA;
				open cur_addon;
			if SQLCA.sqlcode < 0 then
				guo_func.msgBox("ATTENTION", string(SQLCA.sqlcode)+ ' '+SQLCA.sqlerrtext)
				return 
			elseif SQLCA.sqlcode = 100 then
				close cur_addon;	
			else
				fetch cur_addon into :ls_itemcode, :ls_itemname, :ls_serialno;
				if SQLCA.sqlcode < 0 then
					guo_func.msgBox("ATTENTION", string(SQLCA.sqlcode)+ ' '+SQLCA.sqlerrtext)
					return 
				end if
				
				do while SQLCA.sqlcode = 0
					
					dw_detail.scrollToRow(dw_detail.insertRow(0))
					dw_detail.setItem(dw_detail.getRow(),'itemcode',ls_itemcode)
					dw_detail.setItem(dw_detail.getRow(),'itemname',ls_itemname)
					if not isnull(ls_serialno) then
						dw_detail.setItem(dw_detail.getRow(),'serialno',ls_serialno)
					end if
					fetch cur_addon into :ls_itemcode, :ls_itemname, :ls_serialno;
					if SQLCA.sqlcode < 0 then
						guo_func.msgBox("ATTENTION", string(SQLCA.sqlcode)+ ' '+SQLCA.sqlerrtext)
						return 
					end if	
				loop
		
				close cur_addon;
			end if
			
			pb_new.enabled 		= FALSE
		pb_save.enabled 		= TRUE
		pb_cancel.enabled 	= TRUE
		pb_close.enabled 		= TRUE
		
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

--END VALIDASI ue_postopen

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
end if


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

--is_serviceType = 'CTV' and is_isDigital <> 'Y'  then
--ue_save

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

--validasi data window header
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
        
--validasi data window detail Make Form Array

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
	ls_serialNo			= trim(dw_detail.object.serialNo[ll_row])	
	ls_newSerialNo	= trim(dw_detail.object.newSerialNo[ll_row])	
	
	if isnull(ls_serialNo) then continue
	//if not isnull(ls_newSerialNo) then continue
	
	ll_newRecords = ll_newRecords + 1
NEXT

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
	ls_isPrimary			   = trim(dw_detail.object.isprimary[ll_row])
	
	if isnull(ls_serialNo) or ls_serialNo = '' then continue

	if not iuo_cpe.setSerialNoAddOn(ls_serialNo) then
		is_msgno = "SM-0000001"
		is_msgtrail = iuo_cpe.lastSQLCode + "~r~n" + iuo_cpe.lastSQLErrText
		is_sugtrail = ""
		return -1
	end if	
	
	
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
	----------------------------------
	
	--VALIDASI iuo_cpe.setSerialNoAddOn(ls_serialNo)
	--if SERVICE TYPE = 'CTV'
	
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
	
	-----------------------
	

	update sold_add_on_items
	set serialno = :ls_newSerialNo
	where acctno = :luo_jo.acctNo
	and divisioncode = :gs_divisioncode
	and companycode = :gs_companycode
	and jono = :is_jono
	using SQLCA;
	
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
			// ====================================================
			// allow only 3 days before expiration for prepaid subs
			// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			ldt_nullDate = relativeDate(today(), 3)
		end IF
	end if
NEXT

is_msgno = "SM-0000002"
is_msgtrail = ""
is_sugtrail = ""
