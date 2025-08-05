str_subsinfo lstr_subsInfo

lstr_subsInfo.subsTypeCode = 'CO'
lstr_subsInfo.serviceType	= 'INET'

--EVENT OPEN WINDOW MENU

str_subsinfo lstr_subsInfo
lstr_subsInfo = message.powerObjectParm

is_subsTypeCode 	= lstr_subsInfo.substypecode
is_serviceType  	= lstr_subsInfo.serviceType

--center the window
uo_center_window luo_center_window
luo_center_window = create uo_center_window
luo_center_window.f_center(this)
---**** end ***--- //

idw_genInfo 		 	= tabForm.tabpage_1.dw_newapplicationForm02
idw_servAdd 		 	= tabForm.tabpage_2.dw_newapplicationForm03
idw_billAdd			= tabForm.tabpage_3.dw_newapplicationForm04
idw_InstallInfo 	 	= tabForm.tabpage_4.dw_newapplicationForm05
idw_ReqInitPayment	= tabForm.tabpage_4.dw_newapplicationForm05Dtl
idw_charRefs       		= tabForm.tabpage_5.dw_char_refs 
idw_hardbundle_packages = tabForm.tabpage_4.dw_hard_bundle_packages

if is_subsTypeCode = 'RE' then
	idw_genInfo.dataObject = 'dw_new_application_residential'
	idw_genInFo.x = 1211
	idw_genInFo.y = 156
	idw_genInFo.height = 1392
	
	--QUERY FORM  is_subsTypeCode = 'RE' dw_newapplicationForm02
	
	SELECT arAcctSubscriber.acctno,   
         arAcctSubscriber.subscribername,   
			arAcctSubscriber.typeOfBusiness,
         arAcctSubscriber.lastname,   
         arAcctSubscriber.firstname,   
         arAcctSubscriber.middlename,
			motherMaidenName,   
         arAcctSubscriber.citizenshipcode,   
         arAcctSubscriber.sex,   
         arAcctSubscriber.birthdate,   
         arAcctSubscriber.civilstatus,   
         arAcctSubscriber.telno,   
         arAcctSubscriber.mobileno,   
         arAcctSubscriber.faxno,   
         arAcctSubscriber.emailaddress,   
         arAcctSubscriber.numberofrooms,   
         arAcctSubscriber.occupancyrate,
         arAcctSubscriber.substypecode, 
			'' isPersonal,
			arAcctSubscriber.forAcceptance,
			arAcctSubscriber.isSoaPrinting,
			arAcctSubscriber.isemailsending,	
			arAcctSubscriber.issmssending,
			arAcctSubscriber.iscableboxemail,
			arAcctSubscriber.mobileno2,
			arAcctSubscriber.mobileno3,
			arAcctSubscriber.emailaddress2,
			arAcctSubscriber.emailaddress3,
			arAcctSubscriber.guarantor,
			arAcctSubscriber.spousename,
			arAcctSubscriber.nameOfCompany,
			arAcctSubscriber.oldacctno
    FROM arAcctSubscriber  
    
	--END 
elseif is_subsTypeCode = 'CO' then
	idw_genInfo.dataObject = 'dw_new_application_commercial'
	idw_genInFo.x = 78
	idw_genInFo.y = 156
	idw_genInFo.height = 1392
	
	--QUERY FORM  is_subsTypeCode = 'CO' dw_newapplicationForm03
	 SELECT arAcctSubscriber.acctno,   
         arAcctSubscriber.subscribername,   
			arAcctSubscriber.typeOfBusiness,
         arAcctSubscriber.lastname,   
         arAcctSubscriber.firstname,   
         arAcctSubscriber.middlename,
			motherMaidenName,   
         arAcctSubscriber.citizenshipcode,   
         arAcctSubscriber.sex,   
         arAcctSubscriber.birthdate,   
         arAcctSubscriber.civilstatus,   
         arAcctSubscriber.telno,   
         arAcctSubscriber.mobileno,   
         arAcctSubscriber.faxno,   
         arAcctSubscriber.emailaddress,   
         arAcctSubscriber.numberofrooms,   
         arAcctSubscriber.occupancyrate,
         arAcctSubscriber.substypecode, 
			'' isPersonal,
			arAcctSubscriber.forAcceptance,
			arAcctSubscriber.mobileno2,
			arAcctSubscriber.mobileno3,
			arAcctSubscriber.emailaddress2,
			arAcctSubscriber.emailaddress3,
			arAcctSubscriber.spousename,
			arAcctSubscriber.guarantor,
			arAcctSubscriber.nameofcompany,
			arAcctSubscriber.isSoaPrinting,
			arAcctSubscriber.isemailsending,	
			arAcctSubscriber.issmssending,
			arAcctSubscriber.iscableboxemail,
			arAcctSubscriber.oldacctno
    FROM arAcctSubscriber   
    
    --END 
else 
	idw_genInfo.dataObject = 'dw_new_application_corporate'
	idw_genInFo.x = 137
	idw_genInFo.y = 336
	idw_genInFo.height = 800
	
	--QUERY FORM 
	  SELECT arAcctSubscriber.acctno,   
         arAcctSubscriber.subscribername,   
			arAcctSubscriber.typeOfBusiness,
         arAcctSubscriber.lastname,   
         arAcctSubscriber.firstname,   
         arAcctSubscriber.middlename,
			motherMaidenName,   
         arAcctSubscriber.citizenshipcode,   
         arAcctSubscriber.sex,   
         arAcctSubscriber.birthdate,   
         arAcctSubscriber.civilstatus,   
         arAcctSubscriber.telno,   
         arAcctSubscriber.mobileno,   
         arAcctSubscriber.faxno,   
         arAcctSubscriber.emailaddress,   
         arAcctSubscriber.numberofrooms,   
         arAcctSubscriber.occupancyrate,
         arAcctSubscriber.substypecode, 
			'' isPersonal,
			arAcctSubscriber.forAcceptance,
			arAcctSubscriber.mobileno2,
			arAcctSubscriber.mobileno3,
			arAcctSubscriber.emailaddress2,
			arAcctSubscriber.emailaddress3,
			arAcctSubscriber.spousename,
			arAcctSubscriber.guarantor,
			arAcctSubscriber.nameofcompany,
			arAcctSubscriber.oldacctno
    FROM arAcctSubscriber  
    
	--END
    
end if

iw_parent = this
is_prepaidSubscriber = 'N'

dw_header.settransobject(SQLCA)
idw_genInfo.settransobject(SQLCA)
idw_servAdd.settransobject(SQLCA)
idw_billAdd.settransobject(SQLCA)
idw_InstallInfo.settransobject(SQLCA) 
idw_ReqInitPayment.settransobject(SQLCA)
idw_hardbundle_packages.settransobject(SQLCA)


if is_serviceType <> 'INET' then
	
		idw_InstallInfo.object.noofmonthsamort.visible = false
		idw_InstallInfo.object.isstaggered.visible = false
	
else
	if gs_divisioncode = 'HEINT' or gs_divisioncode = 'BAINT' or gs_divisioncode = 'DPINT' or gs_divisioncode = 'SATNT' or gs_divisioncode = 'ABINT' then
		
		idw_InstallInfo.object.noofmonthsamort.visible = false
		idw_InstallInfo.object.isstaggered.visible = false
	
	else
		idw_InstallInfo.object.noofmonthsamort.visible = true
		idw_InstallInfo.object.isstaggered.visible = true
	end if
end if
		



if gs_application = 'POS' then
	this.title = 'Mainline Application' + ' - ' + gs_company + ' - ' + gs_sourceDatabase + ' - ' + gs_uFullName
end IF

--QUERY FORM DW_HEARDER
  SELECT arAcctSubscriber.dateapplied,
			'' as acctno,
			chargeTypeCode,
			subsUserTypeCode,	
			subsTypeCode, 
			agentCode,
			tranNo,
			dateadd,
			installationremarkscode,
			'' as installationsubremarks,
			salessource,
			'' as agenttypecode,
			referredby,
			'' as agentname,
			'' as instantkabit
 FROM arAcctSubscriber 
 
 --QUERY DW_FORM02 GENERAL INFORMATION
 --QUERY FORM  is_subsTypeCode = 'CO' dw_newapplicationForm03
 SELECT arAcctSubscriber.acctno,   
     arAcctSubscriber.subscribername,   
		arAcctSubscriber.typeOfBusiness,
     arAcctSubscriber.lastname,   
     arAcctSubscriber.firstname,   
     arAcctSubscriber.middlename,
		motherMaidenName,   
     arAcctSubscriber.citizenshipcode,   
     arAcctSubscriber.sex,   
     arAcctSubscriber.birthdate,   
     arAcctSubscriber.civilstatus,   
     arAcctSubscriber.telno,   
     arAcctSubscriber.mobileno,   
     arAcctSubscriber.faxno,   
     arAcctSubscriber.emailaddress,   
     arAcctSubscriber.numberofrooms,   
     arAcctSubscriber.occupancyrate,
     arAcctSubscriber.substypecode, 
		'' isPersonal,
		arAcctSubscriber.forAcceptance,
		arAcctSubscriber.mobileno2,
		arAcctSubscriber.mobileno3,
		arAcctSubscriber.emailaddress2,
		arAcctSubscriber.emailaddress3,
		arAcctSubscriber.spousename,
		arAcctSubscriber.guarantor,
		arAcctSubscriber.nameofcompany,
		arAcctSubscriber.isSoaPrinting,
		arAcctSubscriber.isemailsending,	
		arAcctSubscriber.issmssending,
		arAcctSubscriber.iscableboxemail,
		arAcctSubscriber.oldacctno
FROM arAcctSubscriber   

--END 
 

--QUERY FROM SERVICE ADDRESS
  SELECT arAcctAddress.acctNo,   
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
			arAcctAddress.serviceExpirationDate, arAcctAddress.contactNo, arAcctAddress.contactName, arAcctAddress.gpscoordinatee longitude , arAcctAddress.gpscoordinaten latitude
    FROM arAcctAddress where arAcctAddress.addressTypeCode = 'SERVADR1'
    
--BILLING ADDRESS
  SELECT arAcctSubscriber.acctno, 
			vw_arAcctAddress.contactName,
         vw_arAcctAddress.contactNo,  
         vw_arAcctAddress.houseno,   
         vw_arAcctAddress.lotno,   
         vw_arAcctAddress.blkno,   
         vw_arAcctAddress.bldgname,   
         vw_arAcctAddress.streetname,   
         vw_arAcctAddress.purokno,   
         vw_arAcctAddress.subdivisioncode,   
         vw_arAcctAddress.barangaycode,   
         vw_arAcctAddress.municipalitycode,   
         vw_arAcctAddress.provincecode,   
			vw_arAcctAddress.PhaseNo,
			vw_arAcctAddress.District,
			0 as sameSubscriberBilling, 
			0 as sameSubscriberAddress
    FROM arAcctSubscriber inner join vw_arAcctAddress on arAcctSubscriber.acctNo = vw_arAcctAddress.acctNo and vw_arAcctAddress.addressTypeCode = 'BILLING'   
    
    --QUERY INSTALATION INFORMATION
      SELECT arAcctSubscriber.acctno,   
         arAcctSubscriber.substypecode,
         arAcctSubscriber.chargeTypecode,   
		'REG' chagetypecode,
         arAcctSubscriber.subsusertypecode,   
         arAcctSubscriber.packagecode,   
         arAcctSubscriber.subscriberstatuscode,   	
			arAcctSubscriber.acquisitiontypecode,   	
			arAcctSubscriber.preferredDateTimeFrom,
			arAcctSubscriber.preferredDateTimeTo,
         arAcctSubscriber.specialinstructions, 
         arAcctSubscriber.nodeNo,  
			space(8) subsUserName,
			space(8) password,
			space(8) confirmed,
			0 as sameSubscriberBilling, 
			0 as sameSubscriberAddress,
			0 as materials,
			0 as installationfee,
			0 as deposit,'' packageName,
         space(80) packagedesc, arAcctSubscriber.lockInPeriod,
         ''isDigital,
		'' isOpenIDD,
		'' isOpenNDD,
		''isOA,
		'' isRFP,
		'' isStaggered,
		'' noofmonthsamort,
		space(20) napcode,
		space(2) portno,
		'' payment_option
    FROM arAcctSubscriber 
    
    --QUERY INSTALATION INFORMATION PACKAGE
    SELECT a.bundle_packagecode, b.packagename , '' selected  FROM HARD_BUNDLE_PACKAGES_CHOICES A
INNER JOIN ARPACKAGEMASTER B ON B.PACKAGECODE = A.bundle_PACKAGECODE
where b.divisioncode = :as_divisioncode and A.MAINLINE_PACKAGECODE = :as_packagecode
and (pa_area_enabled = 'N' or :as_all_hb_package = 'Y')


--QUERY ADDITIONAL MRC

  SELECT  subsinitialpayment.acctno , 
  subsinitialpayment.trantypecode , 
  subsinitialpayment.artypecode , 
  subsinitialpayment.tranno , 
  subsinitialpayment.trandate , 
  subsinitialpayment.priority , 
  subsinitialpayment.amount 
  FROM subsinitialpayment   
  
  --QUERY TAB CHARACTER REFERENCE
   SELECT  subscriberApplicationCharRefs.charFullName ,
   subscriberApplicationCharRefs.charRelationship ,  
   subscriberApplicationCharRefs.charAddress , 
   subscriberApplicationCharRefs.charContactNo
   FROM subscriberApplicationCharRefs    

--EVENT BUTTON CLICK IN DW_HEADER
str_search str_s

string ls_agenttypecode , ls_agentname, ls_agentCode
string ls_result
string ls_search

long ll_row

if dwo.name = 'b_searchagent' then
	str_s.s_dataobject = "dw_search_agents_2"
	str_s.s_return_column = "agentcode"
	str_s.s_title = "Search For Agents"
	str_s.s_1 = gs_companycode
	str_s.s_2  = gs_divisioncode
	str_s.s_3 = this.GetItemString(this.GetRow(),'agenttypecode')
	
	--QUERY SEARCH AGENT
	  SELECT agentmaster.agentname,
			agentmaster.agentcode
    FROM agentmaster
  WHERE agentMaster.companyCode = :as_company
and agentmaster.agenttypecode = :as_agenttypecode
and agentmaster.divisioncode = :as_division
	
	openwithparm(w_search_ancestor,str_s)
	
	ls_result = trim(message.stringparm)
	
	if ls_result <> '' then			
		
		select agentname, agentCode into :ls_agentname, :ls_agentCode
		from agentmaster
		where divisioncode = :gs_divisioncode
		and companycode = :gs_companycode
		and agentcode = :ls_result
		using SQLCA;
		
		this.setItem(this.getRow(),'agentname',ls_agentName)
		this.setItem(this.getRow(),'agentcode',ls_agentCode)
				
		
	end if
	
end if  

--DROPDOWN CHOOSE CHANNEL AGENTTYPECODE
select agenttypecode , agenttypename from agenttypemaster

--DROPDOWN CHOOSE CAMPAIN
select salessourcecode , salessourcename , requiredreferredby from salessourcemaster 



--BUTTON NEW 

long ll_row, ll_priority	

--insert OCDEQ - Deposit for STB
is_checkServiceabilityChecked = false;

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


--insert OCDEP - Deposit for Subscription 
select priority 
	into :ll_priority	
	from arTypeMaster 	
	where arTypeCode = 'OCDEP' 	
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
idw_ReqInitPayment.setItem( ll_row, "arTypeCode", 'OCDEP' )
idw_ReqInitPayment.setItem( ll_row, "amount", 0.00 )
idw_ReqInitPayment.setItem( ll_row, "priority", ll_priority )

--insert OCADV - Deposit for Subscription Advances
select priority 
into :ll_priority	
from arTypeMaster 	
where arTypeCode = 'OCADV' 	
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
idw_ReqInitPayment.setItem( ll_row, "arTypeCode", 'OCADV' )
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

--insert INSTF - Advance Payment for Installation Fees
select priority 
into :ll_priority	
from arTypeMaster 	
where arTypeCode = 'INSTF' 	
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
idw_ReqInitPayment.setItem( ll_row, "arTypeCode", 'INSTF' )
idw_ReqInitPayment.setItem( ll_row, "amount", 0.00 )
idw_ReqInitPayment.setItem( ll_row, "priority", ll_priority )

idw_ReqInitPayment.acceptText()
cb_1.visible = TRUE

--BUTTON SAVE

int li_press, li_row

s_verifylist lstr_list

openwithparm(w_application_verification,parent)

li_press = message.doubleparm

--VALIDASI QUERRY w_application_verification

DataWindowChild subs_id
int li_row, li_find
string ls_name, ls_first, ls_last, ls_middle, ls_code, ls_protect, ls_subs
iw_parent = message.powerObjectParm
dw_1.setTransObject(SQLCA);

for li_row = 1 to 10
	dw_1.insertrow(0)
	dw_1.setitem(li_row, 'verify', 'N')
next	
dw_1.setitem(1, 'texttitle', iw_parent.dw_header.object.t_1.text)
dw_1.setitem(1, 'columntext', iw_parent.dw_header.getitemstring(1,'acctno'))
dw_1.setitem(1, 'verify', 'Y')
ls_subs = iw_parent.dw_header.getitemstring(1, 'substypecode')
dw_1.setitem(2, 'texttitle', 'Subscriber Complete Name :')
if ls_subs =  "RE" then
	ls_first = iw_parent.tabform.tabpage_1.dw_newapplicationform02.getitemstring(1,'firstname')
	ls_last = iw_parent.tabform.tabpage_1.dw_newapplicationform02.getitemstring(1,'lastname')
	ls_middle = iw_parent.tabform.tabpage_1.dw_newapplicationform02.getitemstring(1,'middlename')
	ls_name = ls_last + ', ' + ls_first + ', ' + ls_middle
else
	ls_name = iw_parent.tabform.tabpage_1.dw_newapplicationform02.getitemstring(1,'subscribername')
end if
dw_1.setitem(2, 'columntext', ls_name)

ls_code = iw_parent.dw_header.getitemstring(1, 'substypecode')
iw_parent.dw_header.object.substypecode.dddw.datacolumn = "substypename"
iw_parent.dw_header.GetChild ("substypecode", subs_id)
subs_id.SetTransObject (SQLCA)
subs_id.Retrieve ( )
li_find = subs_id.Find( "substypecode = '" + ls_code + "'", 1, subs_id.rowcount())
dw_1.setitem(3, 'texttitle', iw_parent.dw_header.object.t_2.text)
dw_1.setitem(3, 'columntext', subs_id.getitemstring(li_find,'substypename'))
iw_parent.dw_header.object.substypecode.dddw.datacolumn = "substypecode"
iw_parent.dw_header.GetChild ("substypecode", subs_id)
subs_id.SetTransObject (SQLCA)
subs_id.Retrieve ( )

ls_code = iw_parent.tabform.tabpage_4.dw_newapplicationform05.getitemstring(1, 'packagename')

dw_1.setitem(4, 'texttitle', 'Package :')
dw_1.setitem(4, 'columntext', ls_code ) //subs_id.getitemstring(li_find,'packagename'))

dw_1.setitem(5, 'texttitle', 'Charge Type :')
dw_1.setitem(5, 'columntext',iw_parent.tabform.tabpage_4.dw_newapplicationform05.getitemstring(1,"chargeTypecode"))

ls_code = iw_parent.tabform.tabpage_4.dw_newapplicationform05.getitemstring(1, 'subsusertypecode_1')
iw_parent.tabform.tabpage_4.dw_newapplicationform05.object.subsusertypecode_1.dddw.datacolumn = "subsusertypename"
iw_parent.tabform.tabpage_4.dw_newapplicationform05.GetChild ("subsusertypecode_1", subs_id)
subs_id.SetTransObject (SQLCA)
subs_id.Retrieve ( )
li_find = subs_id.Find( "subsusertypecode = '" + ls_code + "'", 1, subs_id.rowcount())
dw_1.setitem(6, 'texttitle', 'Subscriber User Type :')
dw_1.setitem(6, 'columntext', subs_id.getitemstring(li_find,'subsusertypename'))
iw_parent.tabform.tabpage_4.dw_newapplicationform05.object.subsusertypecode_1.dddw.datacolumn = "subsusertypecode"
iw_parent.tabform.tabpage_4.dw_newapplicationform05.GetChild ("subsusertypecode_1", subs_id)
subs_id.SetTransObject (SQLCA)
subs_id.Retrieve ( )

ls_code = iw_parent.tabform.tabpage_4.dw_newapplicationform05.getitemstring(1, 'acquisitiontypecode')
iw_parent.tabform.tabpage_4.dw_newapplicationform05.object.acquisitiontypecode.dddw.datacolumn = "acquisitiontypename"
iw_parent.tabform.tabpage_4.dw_newapplicationform05.GetChild ("acquisitiontypecode", subs_id)
subs_id.SetTransObject (SQLCA)
subs_id.Retrieve ( )
li_find = subs_id.Find( "acquisitiontypecode = '" + ls_code + "'", 1, subs_id.rowcount())
dw_1.setitem(7, 'texttitle', 'CPE Acquisition Type :')
dw_1.setitem(7, 'columntext', subs_id.getitemstring(li_find,'acquisitiontypename'))
iw_parent.tabform.tabpage_4.dw_newapplicationform05.object.acquisitiontypecode.dddw.datacolumn = "acquisitiontypecode"
iw_parent.tabform.tabpage_4.dw_newapplicationform05.GetChild ("acquisitiontypecode", subs_id)
subs_id.SetTransObject (SQLCA)
subs_id.Retrieve ( )

dw_1.setitem(8, 'texttitle', 'Equipment Deposit :')
dw_1.setitem(8, 'columntext', string(iw_parent.tabform.tabpage_4.dw_newapplicationform05dtl.getitemdecimal(1, 'amount')))

dw_1.setitem(9, 'texttitle', 'Subscriber Deposit :')
dw_1.setitem(9, 'columntext', string(iw_parent.tabform.tabpage_4.dw_newapplicationform05dtl.getitemdecimal(2, 'amount')))

dw_1.setitem(10, 'texttitle', 'MLINE Installation Fee :')
dw_1.setitem(10, 'columntext', string(iw_parent.tabform.tabpage_4.dw_newapplicationform05dtl.getitemdecimal(5, 'amount')))


--SAVE FOR VERIFICATION
int li_row
string ls_check
this.accepttext( )
if dwo.name = 'b_edit' then
	closewithreturn(parent, 1)
elseif dwo.name = 'b_save' then
	this.setitem(1, 'verify', 'Y')
	for li_row = 1 to 10
		ls_check = this.getitemstring(li_row,'verify')
		if ls_check = 'N' or isnull(ls_check)then
			guo_func.msgbox("ATTENTION", "VERIFICATION is needed, to continue!")
			exit
		end if
	next
	if ls_check = 'Y' then
		closewithreturn(parent, 0)
	end if
end if

--END

--END OPEN VERIFICATION

if li_press = 0 then
	
	if parent.trigger Event ue_save() = 0 then
		commit using SQLCA;
		if is_msgno <> '' then
			guo_func.msgbox(is_msgno, is_msgtrail, is_sugtrail)
		end if
		ib_TransactionWasSaved = TRUE
	else
		rollback using SQLCA;
		if is_msgno <> '' then
			guo_func.msgbox(is_msgno, is_msgtrail, is_sugtrail)
			of_setfocus(is_msgno)
		end if
		
		ib_TransactionWasSaved = FALSE
	end if
	
	if ib_TransactionWasSaved then
		ib_reqStatus = True
		parent.triggerevent('ue_cancel')
		guo_func.msgBox("Saving Complete.", "You have successfully saved your entry.")
		
		string ls_message
		if isNull(is_mobileNo) or is_mobileNo = '' then
			return
		end if
	
		
	end if
	
end if
cb_1.visible = FALSE
tabform.tabpage_1.cb_upload.enabled = FALSE

--VALIDASI UE_SAVE

long 			ll_acctno, ll_jono, ll_tranNo, ll_cnt
string 		ls_acctno, ls_jono, ls_tranNo, ls_TranTypeCode, ls_installationRemarksCode, ls_instantkabit , ls_agentcode
decimal{2}	ld_instFee

dw_header.accepttext()

ls_TranTypeCode = is_transactionID

ls_installationRemarksCode = dw_header.getitemstring(1,"installationremarkscode")
ls_agentcode = dw_header.getitemstring(1,"agentcode")

if isnull(ls_installationRemarksCode) or ls_installationRemarksCode = '' then
	guo_func.msgBox('Invalid!','The System cannot continue processing your transaction. Please enter Installation Origin before saving.. Thank you...')
	return -1
end if

ls_acctno = dw_header.getitemstring(1,"acctno")
ls_instantkabit = dw_header.getitemstring(1,"instantkabit")

if isnull(ls_acctno) or ls_acctno = '' then
		guo_func.msgBox('Invalid!','The System cannot continue processing your transaction. Please enter "Account No." before saving.. Thank you...')
		return -1
end if 

if ls_instantkabit = 'Y' then 
	if isnull(ls_acctno) or ls_acctno = '' then
		guo_func.msgBox('Invalid!','The System cannot continue processing your transaction. Please enter "Instant Kabit Account No." before saving.. Thank you...')
		return -1
	else
		select count(*) into :ll_cnt
		from INSTANTKABITACCTNO
		where acctno = :ls_acctno
		and divisioncode = :gs_divisioncode
		and agentcode = :ls_agentcode
		and used = 'N'
		using SQLCA;
		if SQLCA.SQLCode = 100 then
			guo_func.msgbox('SM-0000001', "Invalid Instant Kabit acctno"+"SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText)
			return -1	
		elseif SQLCA.SQLCode < 0 then
			guo_func.msgbox('SM-0000001', "Error in Select [INSTANTKABITACCTNO]"+"SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText)
			return -1	
		end if	
		
		if ll_cnt = 0 then 
			guo_func.msgbox('SM-0000001', "Invalid reserved acctno"+"SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText)
			return -1	
		end if
		
		
	end if
	
	
end IF

idt_trandate = guo_func.get_server_datetime()

is_trantype = ls_trantypecode

is_tranno = is_applml 
ls_acctNo = is_acctNo

if trigger event ue_save_subsInitialPayment(ls_acctno, ld_instFee) = -1 then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = "Saving subsInitialPayment ~nSQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
	return -1
end IF

--VALIDASI UE_SAVE_SUBINITIALPAYMENT
long ll_priority, ll_row,  ll_rows, ll_loop, ll_row2, ll_noofmonthsamort
string ls_acctno, ls_tranTypeCode, ls_arTypeCode, ls_tranNo, ls_currency, ls_noofmonthsamort
datetime ldt_tranDate
dec{2} ld_amount, ld_rate

ls_acctno = trim(as_acctno)
ls_tranTypeCode = is_transactionID
ls_tranNo = ''

ls_tranNo		= is_tranNo
ldt_tranDate	= guo_func.get_server_datetime()

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
					 :ls_tranNo,
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
			case else
				ad_applicationFee = ad_applicationFee + ld_amount
		end choose
	end if
	
next

return 0


--END VALIDASI

if trigger event ue_save_subscriberMaster(ls_acctno, ld_instFee) = -1 then
	return -1
end IF

--VALIDASI UE_SAVE_SUBRIBERMASTER

string 		ls_acctNo, ls_subscriberName, ls_typeOfBusiness, ls_lastName,	ls_firstName, ls_middleName, ls_motherMaidenName	
string 		ls_citizenshipCode, ls_sex, ls_agentCode, ls_specialinstructions, ls_acqusitiontypecode,ls_imagepath
string 		ls_civilStatus, ls_telNo, ls_mobileNo, ls_faxNo, ls_emailAddress, ls_currencyCode, ls_password
string 		ls_serviceHomeOwnerShip, ls_serviceLessorOwnerName, ls_serviceLessorOwnerContactNo
string 		ls_serviceHouseNo, ls_serviceStreetName, ls_serviceBldgCompApartmentName, ls_serviceLotNo
string 		ls_serviceBlockNo, ls_servicePhase, ls_serviceDistrict, ls_servicePurok, ls_serviceSubdivisionCode
string 		ls_serviceBarangayCode, ls_serviceMunicipalityCode, ls_serviceProvinceCode, ls_serviceNode, ls_servicePostNo
string 		ls_billingContactName, ls_billingContactNo, ls_servicecontactName, ls_serviceContactNo, ls_acceptance
string 		ls_billingHouseNo, ls_billingStreetName, ls_billingBldgCompApartmentName, ls_billingLotNo
string 		ls_billingBlockNo, ls_billingPhase, ls_billingDistrict, ls_billingPurok, ls_billingSubdivisionCode
string 		ls_billingBarangayCode, ls_billingMunicipalityCode, ls_billingProvinceCode
string 		ls_prepaidSubscriber, ls_username, ls_packageTypeCode, ls_dbdirection
string 		ls_tranNo, lastSQLCode, lastSQLErrText,ls_installationremarkscode, ls_oldacctno
string 		ls_chargeTypeCode, ls_subsUserTypeCode, ls_packageCode, ls_subscriberStatusCode, ls_isSoaPrinting, ls_isCableBoxSending, ls_isEmailSending, ls_isSMSSending
string 		ls_mobileno2, ls_mobileno3, ls_nameofcompany, ls_guarantor, ls_emailAddress2, ls_emailAddress3, ls_spousename, ls_installationsubremarks
string			ls_isPrintComclark, ls_isPrintConverge, ls_isPrintSME, ls_typeOfComis_isstaggeredpany, ls_taxprofilecode, ls_isVat, ls_isNonVat, ls_isWhtAgent,  ls_noofmonthsamort , ls_typeOfCompany
string 	    ls_longitude, ls_latitude

long 	 	ll_qtyAcquiredSTB, ll_totalBoxesBeforeDeactivation, ll_numberOfRooms
long 		ll_row, ll_noofrequiredSTB
long 		ll_payment_option

long ll_noofmonthsamort

decimal{2} ld_occupancyRate, ld_currentMonthlyRate, ld_previousMonthlyRate, ld_subscriptionDepositReceivable
decimal{2} ld_mLineCurrentMonthlyRate, ld_mLinePreviousMonthlyRate
decimal{2} ld_extCurrentMonthlyRate, ld_extPreviousMonthlyRate

datetime	ldt_birthDate, ldt_preferreddatetimefrom, ldt_preferreddatetimeto
datetime 	ldt_dateApplied    
datetime	ldt_serviceExpirationDate
datetime	ldt_dateadd, ldt_lastupdatetags
date ld_today, ld_birthDate

int    		li_serviceYearsResidency, li_noOfExtraSTB, li_nodeNo, li_lockIn


string ls_salessourcecode , ls_referredby , ls_napcode , ls_portno, ls_fromnocoicop

ldt_dateadd = guo_func.get_server_date()

ldt_lastupdatetags = guo_func.get_server_datetime()

ld_today = today()

ll_row = dw_header.getrow()

idw_genInfo.accepttext()
idw_servAdd.accepttext()
idw_billAdd.accepttext()
idw_InstallInfo.accepttext()

--get package details
ls_packageCode	= trim(idw_InstallInfo.getItemString(1, "packageCode"))

select  nocoicop 
	into  :ls_fromnocoicop
	from systemParameter 
	where divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	using SQLCA;

SELECT monthlyRate, extMonthlyRate, currencyCode, packageTypeCode
INTO :ld_mLineCurrentMonthlyRate, :ld_extCurrentMonthlyRate, :ls_currencyCode, :ls_packageTypeCode
FROM arPackageMaster
WHERE packageCode = :ls_packageCode
AND divisionCode =:gs_divisionCode
AND companyCode = :gs_companyCode
USING SQLCA;
IF SQLCA.SQLCode = -1 Then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = "Selecting in arPackageMaster ~nSQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
	return -1
end if
ld_previousMonthlyRate = 0

--get subscriber information
ls_acctNo					 = trim(as_acctno)

ldt_dateApplied 			= dw_header.getItemDateTime(ll_row, 'dateApplied')
ls_agentCode				= dw_header.getItemString(ll_row, 'agentCode')
ls_tranNo				 	= is_tranno
ls_installationremarkscode		= dw_header.getitemstring(ll_row,'installationremarkscode')
ls_installationsubremarks =  dw_header.getitemstring(ll_row,'installationsubremarks')
ls_salessourcecode 		 = dw_header.getItemString(ll_row,'salessource')
ls_referredby				 = dw_header.getItemString(ll_row,'referredby')

if isnull(ls_referredby) then ls_referredby = ''

ls_lastName 				= trim(idw_genInfo.getItemString(ll_row, "lastname"))
ls_firstName 				= trim(idw_genInfo.getItemString(ll_row, "firstname"))	
ls_middleName  			= trim(idw_genInfo.getItemString(ll_row, "middlename"))
ls_motherMaidenName  	= trim(idw_genInfo.getItemString(ll_row, "motherMaidenName"))	
ls_acceptance  				= idw_genInfo.getItemString(ll_row, "foracceptance")

if ls_acceptance = '' or isNull(ls_acceptance) then
	ls_acceptance = 'N'
end if

if is_substypecode <> 'CO' and is_substypecode <> 'CP'then
	ls_subscriberName = ls_lastName + ", " + ls_firstName + " " + ls_middleName
else
	ls_subscriberName = trim(idw_genInfo.getItemString(ll_row, "subscriberName"))	
end if


--modified by ray
ls_typeOfBusiness	 		= trim(idw_genInfo.getItemString(ll_row, "typeOfBusiness"))	
ls_citizenshipCode			= trim(idw_genInfo.getItemString(ll_row, "citizenshipCode"))	
ls_sex	 					= trim(idw_genInfo.getItemString(ll_row, "sex"))
ls_oldacctno					= trim(idw_genInfo.getItemString(ll_row, "oldacctno"))
ldt_birthDate	 			= idw_genInfo.getItemDatetime(ll_row, "birthdate")

ls_civilStatus	 			= trim(idw_genInfo.getItemString(ll_row, "civilStatus"))	
ls_telNo	 				= trim(idw_genInfo.getItemString(ll_row, "telNo"))	
is_mobileNo 				= trim(idw_genInfo.getItemString(ll_row, "mobileNo"))	
ls_mobileNo2 				= trim(idw_genInfo.getItemString(ll_row, "mobileno2"))
ls_mobileNo3 				= trim(idw_genInfo.getItemString(ll_row, "mobileno3"))
ls_faxNo	 				= trim(idw_genInfo.getItemString(ll_row, "faxNo"))	
ls_emailAddress	 		= trim(idw_genInfo.getItemString(ll_row, "emailAddress"))
ls_emailAddress2	 		= trim(idw_genInfo.getItemString(ll_row, "emailAddress2"))
ls_emailAddress3	 		= trim(idw_genInfo.getItemString(ll_row, "emailAddress3"))
ls_spousename	 		= trim(idw_genInfo.getItemString(ll_row, "spousename"))
ls_nameofcompany	= trim(idw_genInfo.getItemString(ll_row, "nameofcompany"))
ls_guarantor	 		= trim(idw_genInfo.getItemString(ll_row, "guarantor"))
ll_numberOfRooms		= idw_genInfo.getItemNumber(ll_row, "numberOfRooms")	
ld_occupancyRate		= idw_genInfo.getItemDecimal(ll_row, "occupancyRate")	


if is_subsTypeCode = 'RE' then
	ls_isSoaPrinting	 		= trim(idw_genInfo.getItemString(ll_row, "isSoaPrinting"))	
	ls_isCableBoxSending = trim(idw_genInfo.getItemString(ll_row, "iscableboxemail"))	
	ls_isSMSSending = trim(idw_genInfo.getItemString(ll_row, "issmssending"))	
	ls_isEmailSending = trim(idw_genInfo.getItemString(ll_row, "isemailsending"))	

elseif is_subsTypeCode = 'CO' then
	ls_isSoaPrinting	 		= trim(idw_genInfo.getItemString(ll_row, "isSoaPrinting"))	
	ls_isCableBoxSending = trim(idw_genInfo.getItemString(ll_row, "iscableboxemail"))	
	ls_isSMSSending = trim(idw_genInfo.getItemString(ll_row, "issmssending"))	
	ls_isEmailSending = trim(idw_genInfo.getItemString(ll_row, "isemailsending"))	
else 
end IF

ll_noofrequiredSTB		= 1

--For GEPON Corporate Wee 05-15-15
if is_substypecode = "CP"  Then
	li_noOfExtraSTB = 0
	ll_noofrequiredSTB = 1
	ls_sex = ' '
	ldt_birthDate = DateTime(DATE('01/01/1900'),time('00:00'))
	ls_civilStatus = ' '
	ls_citizenshipCode = ' '
end IF

ls_serviceHomeOwnerShip						= trim(idw_servAdd.getItemString(ll_row, "serviceHomeOwnerShip"))	
if ls_serviceHomeOwnerShip = 'O' then
	setnull(ls_serviceLessorOwnerName)
	setnull(ls_serviceLessorOwnerContactNo)
	setnull(ldt_serviceExpirationDate)
else
	ls_serviceLessorOwnerName				= trim(idw_servAdd.getItemString(ll_row, "serviceLessorOwnerName"))	
	ls_serviceLessorOwnerContactNo		= trim(idw_servAdd.getItemString(ll_row, "serviceLessorOwnerContactNo"))		
	ldt_serviceExpirationDate					= idw_servAdd.getItemDatetime(ll_row, "serviceExpirationDate")	
end if

li_serviceYearsResidency						= idw_servAdd.getItemNumber(ll_row, "serviceYearsResidency")	
ls_serviceHouseNo								= trim(idw_servAdd.getItemString(ll_row, "serviceHouseNo"))	
ls_serviceStreetName							= trim(idw_servAdd.getItemString(ll_row, "serviceStreetName"))	
ls_serviceBldgCompApartmentName			= trim(idw_servAdd.getItemString(ll_row, "serviceBldgCompApartmentName"))	
ls_serviceLotNo								= trim(idw_servAdd.getItemString(ll_row, "serviceLotNo"))	
ls_serviceBlockNo								= trim(idw_servAdd.getItemString(ll_row, "serviceBlockNo"))	
ls_servicePhase								= trim(idw_servAdd.getItemString(ll_row, "servicePhase"))	
ls_serviceDistrict								= trim(idw_servAdd.getItemString(ll_row, "serviceDistrict"))	
ls_servicePurok								= trim(idw_servAdd.getItemString(ll_row, "servicePurok"))	
ls_serviceSubdivisionCode						= trim(idw_servAdd.getItemString(ll_row, "serviceSubdivisionCode"))	
ls_serviceBarangayCode						= trim(idw_servAdd.getItemString(ll_row, "serviceBarangayCode"))	
ls_serviceMunicipalityCode					= trim(idw_servAdd.getItemString(ll_row, "serviceMunicipalityCode"))	
ls_serviceProvinceCode						= trim(idw_servAdd.getItemString(ll_row, "serviceProvinceCode"))	
ls_serviceNode									= ''	
ls_servicePostNo								= ''	

 ls_longitude= trim(idw_servAdd.getItemString(ll_row, "longitude"))	
 ls_latitude= trim(idw_servAdd.getItemString(ll_row, "latitude"))	
 
ls_billingcontactName							= trim(idw_billAdd.getItemString(ll_row, "billingContactName"))	
ls_billingcontactno								= trim(idw_billAdd.getItemString(ll_row, "billingContactNo"))	
ls_serviceContactName   						= trim(idw_servAdd.getItemString(ll_row, "serviceContactName"))	
ls_serviceContactNo							= trim(idw_servAdd.getItemString(ll_row, "serviceContactNo"))	

ls_billingHouseNo								= trim(idw_billAdd.getItemString(ll_row, "billingHouseNo"))	
ls_billingStreetName							= trim(idw_billAdd.getItemString(ll_row, "billingStreetName"))		
ls_billingBldgCompApartmentName			= trim(idw_billAdd.getItemString(ll_row, "billingBldgCompApartmentName"))	
ls_billingLotNo									= trim(idw_billAdd.getItemString(ll_row, "billingLotNo"))	
ls_billingBlockNo								= trim(idw_billAdd.getItemString(ll_row, "billingBlockNo"))	
ls_billingPhase									= trim(idw_billAdd.getItemString(ll_row, "billingPhase"))	
ls_billingDistrict									= trim(idw_billAdd.getItemString(ll_row, "billingDistrict"))	
ls_billingPurok									= trim(idw_billAdd.getItemString(ll_row, "billingPurok"))
ls_billingSubdivisionCode						= trim(idw_billAdd.getItemString(ll_row, "billingSubdivisionCode"))	
ls_billingBarangayCode						= trim(idw_billAdd.getItemString(ll_row, "billingBarangayCode"))	
ls_billingMunicipalityCode						= trim(idw_billAdd.getItemString(ll_row, "billingMunicipalityCode"))	
ls_billingProvinceCode							= trim(idw_billAdd.getItemString(ll_row, "billingProvinceCode"))	



li_lockIn										= idw_InstallInfo.getItemNumber(ll_row, "lockinperiod")
li_nodeNo										= idw_InstallInfo.getItemNumber(ll_row, "nodeno")

--LONG LL_noofmonthsamort	

if is_isstaggered = 'S'  then
	
	ls_noofmonthsamort										= idw_InstallInfo.getItemString(ll_row, "noofmonthsamort")
	
	ll_noofmonthsamort = long(ls_noofmonthsamort)
	if ll_noofmonthsamort = 0 then
		is_msgNo    = 'SM-0000001'
			is_msgTrail	= 'Unable to continue, invalid number of months amortized.'
			return -1
	end if

end if 

if gs_divisioncode = 'BDANT' then
	is_isstaggered = 'O'
end if

ls_chargeTypeCode							= trim(idw_InstallInfo.getItemString(ll_row, "chargeTypeCode"))	
ls_subsUserTypeCode							= trim(idw_InstallInfo.getItemString(ll_row, "subsUserTypeCode"))	
ldt_preferreddatetimefrom					= idw_InstallInfo.getItemDateTime(ll_row, "preferreddatetimefrom")
ldt_preferreddatetimeto						= idw_InstallInfo.getItemDateTime(ll_row, "preferreddatetimeto")
ls_specialinstructions							= trim(idw_InstallInfo.getItemString(ll_row, "specialinstructions"))	
ls_acqusitiontypecode							= trim(idw_InstallInfo.getItemString(ll_row, "acquisitiontypecode"))	
ls_napcode							= trim(idw_InstallInfo.getItemString(ll_row, "napcode"))
ls_portno							= trim(idw_InstallInfo.getItemString(ll_row, "portno"))

if isNull(ls_acqusitiontypecode) or ls_acqusitiontypecode= '' then
		is_msgNo    = 'SM-0000001'
		is_msgTrail = 'Required CPE Acqusition Type...'
		return -1
end if

string ls_payment_opt
ls_payment_opt = idw_InstallInfo.getItemString(1, "payment_option")


if isNull(ls_payment_opt) or ls_payment_opt= '' then
		is_msgNo    = 'SM-0000001'
		is_msgTrail = 'Required Payment Option..'
		return -1
end if

ll_payment_option = long (ls_payment_opt)

ls_subscriberStatusCode						= 'APL'	
ll_qtyAcquiredSTB								= 0
ll_totalBoxesBeforeDeactivation				= 0
ld_subscriptionDepositReceivable 				= 0
ls_prepaidSubscriber							= is_PrepaidSubscriber

ls_username									= '-'
ls_password									= '-'

if isNull(li_nodeNo) then li_nodeNo = 0 
if isNull(li_lockIn) then li_lockIn = 0 

--get type of company
if gs_divisionCode = 'ACCTN' then
	ls_isPrintComclark = 'N'
	ls_isPrintConverge = 'N'
	ls_isPrintSME = 'N' 
	ls_typeOfCompany = '004'
elseif 	gs_divisionCode = 'ISG' then
	ls_isPrintComclark = 'N'
	ls_isPrintConverge = 'Y'
	ls_isPrintSME = 'N' 
	ls_typeOfCompany = '002' 
elseif 	gs_divisionCode = 'BSG' then
	ls_isPrintComclark = 'N'
	ls_isPrintConverge = 'Y'
	ls_isPrintSME = 'N' 
	ls_typeOfCompany = '002' 	
else 
	ls_isPrintComclark = 'N'
	ls_isPrintConverge = 'Y'
	ls_isPrintSME = 'N' 
	ls_typeOfCompany = '002' 
end if 	

if is_serviceType = 'INET' then
	
	string ls_userNamePrefix,ls_divisionPrefix
	
	select userNamePrefix,divisionPrefix, nocoicop 
	into :ls_userNamePrefix,:ls_divisionPrefix , :ls_fromnocoicop
	from systemParameter 
	where divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	using SQLCA;

	if trim(ls_userNamePrefix) = "" then 
		is_msgNo    = 'SM-0000001'
		is_msgTrail = "Please set {USER NAME PREFIX in SYSTEM PARAMETER} "
		return -1	
	end if	
	if isnull(ls_userNamePrefix) then  
		is_msgNo    = 'SM-0000001'
		is_msgTrail = "Please set {USER NAME PREFIX in SYSTEM PARAMETER} "
		return -1		
	end if	
	if isnull(li_nodeNo) then  
		is_msgNo    = 'SM-0000001'
		is_msgTrail = "Please set {NODE NO IN INSTALLATION INFORMATION} "
		return -1		
	end if	
	
	if uf_isAllowedInOneWirelessRadius(ls_packageTypeCode) then
		ls_userName = trim(ls_userNamePrefix) + trim(ls_acctNo)
		ls_password = ls_userName
		
		idw_InstallInfo.setItem(idw_InstallInfo.getrow(),'subsUserName',ls_userName)
		idw_InstallInfo.setItem(idw_InstallInfo.getrow(),'password',ls_password )
					
	end IF
	
	--VALIDASI uf_isAllowedInOneWirelessRadius
	
	string ls_validPackageTypeCode[]


		if not uf_getAllowedPackageTypeCode('ONEWIRELESS', ls_validPackageTypeCode) then
			return FALSE
		end IF
		
		--VALIDASI uf_getAllowedPackageTypeCode
		
		declare cur_packageType cursor for
				select packageTypeCode
				  from sysAllowedPackageTypes
				 where tranTypeCode = :as_tranTypeCode
				 and divisionCode = :gs_divisionCode
				and companyCode = :gs_companyCode
			using SQLCA;
			if SQLCA.sqlcode <> 0 then
				message.stringparm = string(SQLCA.sqlcode)+"(1)" + '~r~n~r~n' + SQLCA.sqlerrtext
				close cur_packageType;	
				return FALSE
			end if
			
			
				 
			open cur_packageType;
			if SQLCA.sqlcode <> 0 then
				message.stringparm = string(SQLCA.sqlcode)+"(1)" + '~r~n~r~n' + SQLCA.sqlerrtext
				close cur_packageType;	
				return FALSE
			end if
			
			fetch cur_packageType into :as_packageTypeCode[upperbound(as_packageTypeCode) + 1];
			if SQLCA.sqlcode <> 0 then
				message.stringparm = string(SQLCA.sqlcode)+"(2)"  + '~r~n~r~n' + SQLCA.sqlerrtext
				close cur_packageType;	
				return FALSE
			end if
			
			do while SQLCA.sqlcode = 0
				fetch cur_packageType into :as_packageTypeCode[upperbound(as_packageTypeCode) + 1];
			loop
			
			close cur_packageType;
			
			return TRUE
		
		--END VALIDASI uf_getAllowedPackageTypeCode
		
		int li_element
		for li_element = 1 to upperbound(ls_validPackageTypeCode)
			if trim(as_packageTypeCode) = trim(ls_validPackageTypeCode[li_element]) then
				return TRUE
			end if
		next
		
		return FALSE  
	
	--END VALIDASI uf_isAllowedInOneWirelessRadius
	
	
	if isnull(ls_agentCode) then
	
		is_msgNo    = 'SM-0000001'
		is_msgTrail = "Please set {AGENTCODE IN INSTALLATION INFORMATION} "
		return -1		
	
	
	end if
	
	
	
	--FIT
	if uf_isAllowedInFITRadius(ls_packageTypeCode) then
		
		--VALIDASI uf_isAllowedInFITRadius
		string ls_validPackageTypeCode[]		
		
		if not uf_getAllowedPackageTypeCode('FITRADIUS', ls_validPackageTypeCode) then
			return FALSE
		end IF
		
		--VALIDASI uf_getAllowedPackageTypeCode
		
		declare cur_packageType cursor for
				select packageTypeCode
				  from sysAllowedPackageTypes
				 where tranTypeCode = :as_tranTypeCode
				 and divisionCode = :gs_divisionCode
				and companyCode = :gs_companyCode
			using SQLCA;
			if SQLCA.sqlcode <> 0 then
				message.stringparm = string(SQLCA.sqlcode)+"(1)" + '~r~n~r~n' + SQLCA.sqlerrtext
				close cur_packageType;	
				return FALSE
			end if
			
			
				 
			open cur_packageType;
			if SQLCA.sqlcode <> 0 then
				message.stringparm = string(SQLCA.sqlcode)+"(1)" + '~r~n~r~n' + SQLCA.sqlerrtext
				close cur_packageType;	
				return FALSE
			end if
			
			fetch cur_packageType into :as_packageTypeCode[upperbound(as_packageTypeCode) + 1];
			if SQLCA.sqlcode <> 0 then
				message.stringparm = string(SQLCA.sqlcode)+"(2)"  + '~r~n~r~n' + SQLCA.sqlerrtext
				close cur_packageType;	
				return FALSE
			end if
			
			do while SQLCA.sqlcode = 0
				fetch cur_packageType into :as_packageTypeCode[upperbound(as_packageTypeCode) + 1];
			loop
			
			close cur_packageType;
			
			return TRUE
		
		--END VALIDASI uf_getAllowedPackageTypeCode
		
		int li_element
		for li_element = 1 to upperbound(ls_validPackageTypeCode)
			if trim(as_packageTypeCode) = trim(ls_validPackageTypeCode[li_element]) then
				return TRUE
			end if
		next
		
		return FALSE
				
		--END VALIDASI uf_isAllowedInFITRadius
		
		select itemValue, itemDescription
		into :ls_userNamePrefix, :ls_password
		from sysParamString
		where itemName = 'FITUSERPREFIX'
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;
		
		string ls_disp, ls_code = ''
		String ls_passval[70] = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','1','2','3','4','5','6','7','8','9','0'}
		integer ls_limit
		string ls_fitacctNo, ls_newPassword , ls_errMsg
		ls_limit = 8

		DO WHILE (Len(ls_code) < ls_limit)
		ls_code = ls_code + ls_passval[rand(65)+1]
		LOOP
		ls_password = ls_code 
		
		ls_userName = trim(ls_userNamePrefix) + trim(ls_divisionPrefix) + trim(ls_acctNo)
		idw_InstallInfo.setItem(idw_InstallInfo.getrow(),'subsUserName',ls_userName )
		idw_InstallInfo.setItem(idw_InstallInfo.getrow(),'password',ls_password )
	
		
	end if
	
	if uf_isAllowedInAAA(ls_packageTypeCode) or uf_isAllowedInCMLRadius(ls_packageTypeCode) THEN
		
		--VALIDASI uf_isAllowedInAAA
			string ls_validPackageTypeCode[]
	
			if not uf_getAllowedPackageTypeCode('AAA', ls_validPackageTypeCode) then
				return FALSE
			end IF
			
			--VALIDASI uf_getAllowedPackageTypeCode
		
			declare cur_packageType cursor for
					select packageTypeCode
					  from sysAllowedPackageTypes
					 where tranTypeCode = :as_tranTypeCode
					 and divisionCode = :gs_divisionCode
					and companyCode = :gs_companyCode
				using SQLCA;
				if SQLCA.sqlcode <> 0 then
					message.stringparm = string(SQLCA.sqlcode)+"(1)" + '~r~n~r~n' + SQLCA.sqlerrtext
					close cur_packageType;	
					return FALSE
				end if
				
				
					 
				open cur_packageType;
				if SQLCA.sqlcode <> 0 then
					message.stringparm = string(SQLCA.sqlcode)+"(1)" + '~r~n~r~n' + SQLCA.sqlerrtext
					close cur_packageType;	
					return FALSE
				end if
				
				fetch cur_packageType into :as_packageTypeCode[upperbound(as_packageTypeCode) + 1];
				if SQLCA.sqlcode <> 0 then
					message.stringparm = string(SQLCA.sqlcode)+"(2)"  + '~r~n~r~n' + SQLCA.sqlerrtext
					close cur_packageType;	
					return FALSE
				end if
				
				do while SQLCA.sqlcode = 0
					fetch cur_packageType into :as_packageTypeCode[upperbound(as_packageTypeCode) + 1];
				loop
				
				close cur_packageType;
				
				return TRUE
			
			--END VALIDASI uf_getAllowedPackageTypeCode
			
			int li_element
			for li_element = 1 to upperbound(ls_validPackageTypeCode)
				if trim(as_packageTypeCode) = trim(ls_validPackageTypeCode[li_element]) then
					return TRUE
				end if
			next
			
			return FALSE
			
		--END VALIDASI uf_isAllowedInAAA
			
		--VALIDASI uf_isAllowedInCMLRadius
			
			string ls_validPackagetypeCode[]

			if not uf_getAllowedPackagetypeCode('CMLRADIUS', ls_validPackagetypeCode) then
				if not uf_getAllowedPackagetypeCode('WLSRADIUS', ls_validPackagetypeCode) then
					return FALSE
				end if
			end if
			
			if not uf_getAllowedPackagetypeCode('WLSRADIUS', ls_validPackagetypeCode) then
				return FALSE
			end IF
			
			--VALIDASI uf_getAllowedPackageTypeCode
		
				declare cur_packageType cursor for
					select packageTypeCode
					  from sysAllowedPackageTypes
					 where tranTypeCode = :as_tranTypeCode
					 and divisionCode = :gs_divisionCode
					and companyCode = :gs_companyCode
				using SQLCA;
				if SQLCA.sqlcode <> 0 then
					message.stringparm = string(SQLCA.sqlcode)+"(1)" + '~r~n~r~n' + SQLCA.sqlerrtext
					close cur_packageType;	
					return FALSE
				end if
				
				
					 
				open cur_packageType;
				if SQLCA.sqlcode <> 0 then
					message.stringparm = string(SQLCA.sqlcode)+"(1)" + '~r~n~r~n' + SQLCA.sqlerrtext
					close cur_packageType;	
					return FALSE
				end if
				
				fetch cur_packageType into :as_packageTypeCode[upperbound(as_packageTypeCode) + 1];
				if SQLCA.sqlcode <> 0 then
					message.stringparm = string(SQLCA.sqlcode)+"(2)"  + '~r~n~r~n' + SQLCA.sqlerrtext
					close cur_packageType;	
					return FALSE
				end if
				
				do while SQLCA.sqlcode = 0
					fetch cur_packageType into :as_packageTypeCode[upperbound(as_packageTypeCode) + 1];
				loop
				
				close cur_packageType;
				
				return TRUE
			
			--END VALIDASI uf_getAllowedPackageTypeCode
			
			int li_element
			for li_element = 1 to upperbound(ls_validPackagetypeCode)
				if trim(as_packageTypecode) = trim(ls_validPackagetypeCode[li_element]) then
					return TRUE
				end if
			next
			
			return FALSE
			
		--END VALIDASI	
	
		ls_username								= trim(idw_InstallInfo.getItemString(ll_row, "subsusername"))
		ls_password								= trim(idw_InstallInfo.getItemString(ll_row, "password"))
		if isNull(ls_userName) or ls_username = "" then
			is_msgNo    = 'SM-0000001'
			is_msgTrail	= 'Unable to continue, invalid username.'
			return -1
		end if
		if isNull(ls_password) or ls_password = "" then
			is_msgNo    = 'SM-0000001'
			is_msgTrail	= 'Unable to continue, invalid password.'
			return -1
		end if
		integer li_count
		select count(*)
		  into :li_count
		  from arAcctSubscriber
	 	where subsUserName = :ls_username
	 	and divisionCode = :gs_divisionCode
	 	and companyCode = :gs_companyCode
	 	using SQLCA;
		if SQLCA.SQLCode < 0 then
			is_msgNo    = 'SM-0000001'
			is_msgTrail = string(SQLCA.SQLCode) + '~r~n' + SQLCA.SQLErrText
			return -1	
		end if
		
		if isNull(li_count) then li_count = 0
		if li_count > 0 then
			is_msgNo    = 'SM-0000001'
			is_msgTrail	= 'Unable to continue, the username [' + ls_username + '] is already exists.'
			return -1
		end if
		
		string ls_errorMsg
		if uf_isAllowedInCMLRadius(ls_packageTypeCode) then  
			f_cml_radius_adduser(ls_acctNo, ls_errorMsg)
		end if
		
	end if
	 
end if





	if gs_divisioncode = 'ISG' or gs_divisioncode = 'SFINT' then
	
	
	if is_isstaggered = '' or isnull(is_isstaggered) then
		is_msgNo    = 'SM-0000001'
		is_msgTrail = "Saving Subscriber Master : ~r~n Cannot save without mode of payment (Outright/Staggered)."
		return -1
	end if

		
	end if
	
	
	if is_isstaggered = '' or isnull(is_isstaggered) then is_isstaggered = 'N'

	if is_isstaggered = 'O' then is_isstaggered = 'N' 
	if is_isstaggered = 'S' then is_isstaggered = 'Y' 


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

if ls_subscriberName = '' or isnull(ls_subscriberName) then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = "Saving Subscriber Master : ~r~n Cannot save with unknown Subscriber."
	return -1
end if	

if ls_chargeTypeCode = '' or isnull(ls_chargeTypeCode) then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = "Saving Subscriber Master : ~r~n Cannot save with unknown Customer Type."
	return -1
end if	

if ls_subsUserTypeCode = '' or isnull(ls_subsUserTypeCode) then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = "Saving Subscriber Master : ~r~n Cannot save with unknown Subscriber User Type."
	return -1
end if	

if ls_packageCode = '' or isnull(ls_packageCode) then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = "Saving Subscriber Master : ~r~n Cannot save with unknown Package Code."
	return -1
end if	

if ls_acqusitiontypecode = '' or isnull(ls_acqusitiontypecode) then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = "Saving Subscriber Master : ~r~n Cannot save with unknown Acquisition Type."
	return -1
end if

if ls_installationremarkscode = '' or isnull(ls_installationremarkscode) then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = "Saving Subscriber Master : ~r~n Cannot save with unknown Installation Origin Type."
	return -1
end if

if ls_installationsubremarks = '' or isnull(ls_installationsubremarks) then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = "Saving Subscriber Master : ~r~n Cannot save with unknown Installation Sub Origin Type."
	return -1
end if


if  ls_emailAddress = '' or isnull(ls_emailAddress)  then
	idw_genInfo.SetColumn("emailAddress")
	is_msgNo    = 'RS-0000001'
	is_msgTrail = "Saving Subscriber Master : ~r~n Cannot save without Email Address 1(Required)."
	return -1
end if

if not of_validateEmail(ls_emailAddress) then
	idw_genInfo.SetColumn("emailAddress")
	is_msgNo    = 'RS-0000001'
	is_msgTrail = "Saving Subscriber Master : ~r~n Email Address 1 is invalid."
	return -1
end IF

--VALIDASI EMAIL of_validateEmail

boolean isMatch;
string domainValidation
int emailMinLength,domainLength
string regEx 
regEx =  "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z][a-zA-Z][a-zA-Z]*[a-zA-Z]*$"
emailMinLength = 6
domainLength = 4
isMatch = match(as_emailaddress, regEx)
if Pos(as_emailAddress,"..") > 0  or Pos(as_emailAddress,"@.") > 0 or Pos(as_emailAddress,".@") > 0 or Pos(as_emailAddress,"@@")  > 0 then
	isMatch = false;
end if
if len(as_emailAddress) < emailMinLength then
	return false;
end if
domainValidation = trim(right(as_emailAddress,domainLength))
if POS(domainValidation, ".") = 0  or POS(domainValidation,".") > 2 then
	isMatch = false;
end if
return isMatch;

-- END VALIDASI EMAIL


if not ls_emailAddress2 = '' and not isnull(ls_emailAddress2) then
	if not of_validateEmail(ls_emailAddress2) then
		idw_genInfo.SetColumn("emailAddress2")
		is_msgNo    = 'RS-0000002'
		is_msgTrail = "Saving Subscriber Master : ~r~n Email Address 2 is invalid."
		return -1
	end IF
	
	--VALIDASI EMAIL of_validateEmail

	boolean isMatch;
	string domainValidation
	int emailMinLength,domainLength
	string regEx 
	regEx =  "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z][a-zA-Z][a-zA-Z]*[a-zA-Z]*$"
	emailMinLength = 6
	domainLength = 4
	isMatch = match(as_emailaddress, regEx)
	if Pos(as_emailAddress,"..") > 0  or Pos(as_emailAddress,"@.") > 0 or Pos(as_emailAddress,".@") > 0 or Pos(as_emailAddress,"@@")  > 0 then
		isMatch = false;
	end if
	if len(as_emailAddress) < emailMinLength then
		return false;
	end if
	domainValidation = trim(right(as_emailAddress,domainLength))
	if POS(domainValidation, ".") = 0  or POS(domainValidation,".") > 2 then
		isMatch = false;
	end if
	return isMatch;
	
	-- END VALIDASI EMAIL
end if 

if not ls_emailAddress3 = '' and not isnull(ls_emailAddress3) then
	if not of_validateEmail(ls_emailAddress3) then
		idw_genInfo.SetColumn("emailAddress3")
		is_msgNo    = 'RS-0000003'
		is_msgTrail = "Saving Subscriber Master : ~r~n Email Address 3 is invalid."
		return -1
	end IF
	--VALIDASI EMAIL of_validateEmail

	boolean isMatch;
	string domainValidation
	int emailMinLength,domainLength
	string regEx 
	regEx =  "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z][a-zA-Z][a-zA-Z]*[a-zA-Z]*$"
	emailMinLength = 6
	domainLength = 4
	isMatch = match(as_emailaddress, regEx)
	if Pos(as_emailAddress,"..") > 0  or Pos(as_emailAddress,"@.") > 0 or Pos(as_emailAddress,".@") > 0 or Pos(as_emailAddress,"@@")  > 0 then
		isMatch = false;
	end if
	if len(as_emailAddress) < emailMinLength then
		return false;
	end if
	domainValidation = trim(right(as_emailAddress,domainLength))
	if POS(domainValidation, ".") = 0  or POS(domainValidation,".") > 2 then
		isMatch = false;
	end if
	return isMatch;
	
	-- END VALIDASI EMAIL
end if 

if upper(ls_emailAddress) = upper(ls_emailAddress2) then
	idw_genInfo.SetColumn("emailAddress2")
	is_msgNo    = 'RS-0000002'
	is_msgTrail = "Saving Subscriber Master : ~r~n Email Address 2 already exists. Please enter a different Email address."
	return -1 
end if 

if upper(ls_emailAddress) = upper(ls_emailAddress3) then
	idw_genInfo.SetColumn("emailAddress3")
	is_msgNo    = 'RS-0000003'
	is_msgTrail = "Saving Subscriber Master : ~r~n Email Address 3 already exists. Please enter a different Email address."
	return -1
end if 

if (not ls_emailAddress3 = '' and not isnull(ls_emailAddress3)) and (not ls_emailAddress2 = '' and not isnull(ls_emailAddress2))  then
	if upper(ls_emailAddress2) = upper(ls_emailAddress3) then
		idw_genInfo.SetColumn("emailAddress3")
		is_msgNo    = 'RS-0000003'
		is_msgTrail = "Saving Subscriber Master : ~r~n Email Address 3 already exists. Please enter a different Email address"
		return -1
	end if 
end if 

if  is_mobileNo = '' or isnull(is_mobileNo)  then
	is_msgNo    = 'RS-0000004'
	is_msgTrail = "Saving Subscriber Master : ~r~n Cannot save without Mobile No. 1(Required)."
	return -1
end if

if not of_validatemobile(is_mobileno) then
	is_msgNo    = 'RS-0000004'
	is_msgTrail = "Saving Subscriber Master : ~r~n Mobile Number  1 " + is_mobileno + " is invalid."
	return -1
end IF

--VALIDASI OF_VALIDATEMOBILE

	int result
	string lsPhoneEntered
	string lsPathAndFileToValidate
	integer li_FileNum
	string ls_PhoneValidationInput
	lsPhoneEntered = "https://192.168.180.138:9090/api/validateNumber?id="+ as_phonenumber;
	lsPathAndFileToValidate = "C:\ibas_oracle_10\PhoneValid.Txt";
	
	long li_fileNumLog
	
	string regEx 
	boolean isMatch;
	regEx =  "^[0-9+]*$"
	isMatch = match(as_phonenumber, regEx)
	
	if not isMatch then
		return false
	end if
	
	if len(trim(as_phonenumber)) > 13 then
		return false
	end if
	if len(trim(as_phonenumber)) <= 10 and (pos(as_phonenumber,"+") > 0)  then
		return false
	end if
	if FileExists('val.bat') then
		FileDelete('val.bat')
	end if 
	li_fileNumLog = fileOpen('val.bat', LineMode!, Write!, LockWrite!, Append!)
		fileWrite(li_fileNumLog, '@echo off')
		fileWrite(li_fileNumLog, 'IF EXIST '+ lsPathAndFileToValidate +' ( del '+ lsPathAndFileToValidate +')')
		fileWrite(li_fileNumLog, 'Powershell.exe $result = (Invoke-WebRequest -Uri '+lsPhoneEntered+ ').Content; New-Item '+lsPathAndFileToValidate+'; Set-Content '+lsPathAndFileToValidate+' $result')
		fileClose(li_fileNumLog)
	result = run("val.bat", Minimized!)
	if result = 1 then
		sleep(10);
		li_FileNum = FileOpen(lsPathAndFileToValidate ,LineMode!)
		FileRead(li_FileNum, ls_PhoneValidationInput)
		FileClose(li_FileNum);
		
		long pos_1 , pos_2
		
		pos_1 = Pos(ls_PhoneValidationInput,'"')
		
		ls_PhoneValidationInput = Replace(ls_PhoneValidationInput,pos_1,1,'')
		
		pos_2 = Pos(ls_PhoneValidationInput,'"')
		
		ls_PhoneValidationInput = Replace(ls_PhoneValidationInput,pos_2,1,'')
		
		if (ls_PhoneValidationInput) = 'Valid' then		
			return True
		else
			boolean isValidPhone;
	
			int counter;
			int prefixFound ;
			string phoneToValidate
			string phonePrefix
			isValidPhone= false;
			
			phoneToValidate = right(as_phoneNumber,11)
			if len(trim(phoneToValidate)) < 11 then
				return isValidPhone
			end if
			if left(phoneToValidate,1) <> "0" then
				phoneToValidate = "0"+mid(phoneToValidate,2,10)
			end if
			phonePrefix = mid(phoneToValidate,1,4) 			
			
			Select Count(PrefixNo) 
			INTO : prefixFound
			From PhonePrefix
			Where PrefixNo = : phonePrefix using sqlca;
			if integer(prefixFound) > 0 then
				isValidPhone = true;
			end if
			return isValidPhone;
					return False
			end if
		
	end if
--END VALIDASI MOBILE

if not ls_mobileno2 = '' and not isnull(ls_mobileno2) then
	if not of_validatemobile(ls_mobileno2) then
		is_msgNo    = 'RS-0000005'
		is_msgTrail = "Saving Subscriber Master : ~r~n Mobile Number 2 " + ls_mobileno2 + " is invalid."
		return -1
	end if
end IF

--VALIDASI OF_VALIDATEMOBILE

	int result
	string lsPhoneEntered
	string lsPathAndFileToValidate
	integer li_FileNum
	string ls_PhoneValidationInput
	lsPhoneEntered = "https://192.168.180.138:9090/api/validateNumber?id="+ as_phonenumber;
	lsPathAndFileToValidate = "C:\ibas_oracle_10\PhoneValid.Txt";
	
	long li_fileNumLog
	
	string regEx 
	boolean isMatch;
	regEx =  "^[0-9+]*$"
	isMatch = match(as_phonenumber, regEx)
	
	if not isMatch then
		return false
	end if
	
	if len(trim(as_phonenumber)) > 13 then
		return false
	end if
	if len(trim(as_phonenumber)) <= 10 and (pos(as_phonenumber,"+") > 0)  then
		return false
	end if
	if FileExists('val.bat') then
		FileDelete('val.bat')
	end if 
	li_fileNumLog = fileOpen('val.bat', LineMode!, Write!, LockWrite!, Append!)
		fileWrite(li_fileNumLog, '@echo off')
		fileWrite(li_fileNumLog, 'IF EXIST '+ lsPathAndFileToValidate +' ( del '+ lsPathAndFileToValidate +')')
		fileWrite(li_fileNumLog, 'Powershell.exe $result = (Invoke-WebRequest -Uri '+lsPhoneEntered+ ').Content; New-Item '+lsPathAndFileToValidate+'; Set-Content '+lsPathAndFileToValidate+' $result')
		fileClose(li_fileNumLog)
	result = run("val.bat", Minimized!)
	if result = 1 then
		sleep(10);
		li_FileNum = FileOpen(lsPathAndFileToValidate ,LineMode!)
		FileRead(li_FileNum, ls_PhoneValidationInput)
		FileClose(li_FileNum);
		
		long pos_1 , pos_2
		
		pos_1 = Pos(ls_PhoneValidationInput,'"')
		
		ls_PhoneValidationInput = Replace(ls_PhoneValidationInput,pos_1,1,'')
		
		pos_2 = Pos(ls_PhoneValidationInput,'"')
		
		ls_PhoneValidationInput = Replace(ls_PhoneValidationInput,pos_2,1,'')
		
		if (ls_PhoneValidationInput) = 'Valid' then		
			return True
		else
			boolean isValidPhone;
	
			int counter;
			int prefixFound ;
			string phoneToValidate
			string phonePrefix
			isValidPhone= false;
			
			phoneToValidate = right(as_phoneNumber,11)
			if len(trim(phoneToValidate)) < 11 then
				return isValidPhone
			end if
			if left(phoneToValidate,1) <> "0" then
				phoneToValidate = "0"+mid(phoneToValidate,2,10)
			end if
			phonePrefix = mid(phoneToValidate,1,4) 			
			
			Select Count(PrefixNo) 
			INTO : prefixFound
			From PhonePrefix
			Where PrefixNo = : phonePrefix using sqlca;
			if integer(prefixFound) > 0 then
				isValidPhone = true;
			end if
			return isValidPhone;
					return False
			end if
		
	end if
--END VALIDASI MOBILE

if not ls_mobileno3 = '' and not isnull(ls_mobileno3) then
	if not of_validatemobile(ls_mobileno3) then
		is_msgNo    = 'RS-0000006'
		is_msgTrail = "Saving Subscriber Master : ~r~n Mobile Number 3 "+ ls_mobileno3+" is invalid."
		return -1
	end if
end IF

--VALIDASI OF_VALIDATEMOBILE

	int result
	string lsPhoneEntered
	string lsPathAndFileToValidate
	integer li_FileNum
	string ls_PhoneValidationInput
	lsPhoneEntered = "https://192.168.180.138:9090/api/validateNumber?id="+ as_phonenumber;
	lsPathAndFileToValidate = "C:\ibas_oracle_10\PhoneValid.Txt";
	
	long li_fileNumLog
	
	string regEx 
	boolean isMatch;
	regEx =  "^[0-9+]*$"
	isMatch = match(as_phonenumber, regEx)
	
	if not isMatch then
		return false
	end if
	
	if len(trim(as_phonenumber)) > 13 then
		return false
	end if
	if len(trim(as_phonenumber)) <= 10 and (pos(as_phonenumber,"+") > 0)  then
		return false
	end if
	if FileExists('val.bat') then
		FileDelete('val.bat')
	end if 
	li_fileNumLog = fileOpen('val.bat', LineMode!, Write!, LockWrite!, Append!)
		fileWrite(li_fileNumLog, '@echo off')
		fileWrite(li_fileNumLog, 'IF EXIST '+ lsPathAndFileToValidate +' ( del '+ lsPathAndFileToValidate +')')
		fileWrite(li_fileNumLog, 'Powershell.exe $result = (Invoke-WebRequest -Uri '+lsPhoneEntered+ ').Content; New-Item '+lsPathAndFileToValidate+'; Set-Content '+lsPathAndFileToValidate+' $result')
		fileClose(li_fileNumLog)
	result = run("val.bat", Minimized!)
	if result = 1 then
		sleep(10);
		li_FileNum = FileOpen(lsPathAndFileToValidate ,LineMode!)
		FileRead(li_FileNum, ls_PhoneValidationInput)
		FileClose(li_FileNum);
		
		long pos_1 , pos_2
		
		pos_1 = Pos(ls_PhoneValidationInput,'"')
		
		ls_PhoneValidationInput = Replace(ls_PhoneValidationInput,pos_1,1,'')
		
		pos_2 = Pos(ls_PhoneValidationInput,'"')
		
		ls_PhoneValidationInput = Replace(ls_PhoneValidationInput,pos_2,1,'')
		
		if (ls_PhoneValidationInput) = 'Valid' then		
			return True
		else
			boolean isValidPhone;
	
			int counter;
			int prefixFound ;
			string phoneToValidate
			string phonePrefix
			isValidPhone= false;
			
			phoneToValidate = right(as_phoneNumber,11)
			if len(trim(phoneToValidate)) < 11 then
				return isValidPhone
			end if
			if left(phoneToValidate,1) <> "0" then
				phoneToValidate = "0"+mid(phoneToValidate,2,10)
			end if
			phonePrefix = mid(phoneToValidate,1,4) 			
			
			Select Count(PrefixNo) 
			INTO : prefixFound
			From PhonePrefix
			Where PrefixNo = : phonePrefix using sqlca;
			if integer(prefixFound) > 0 then
				isValidPhone = true;
			end if
			return isValidPhone;
					return False
			end if
		
	end if
--END VALIDASI MOBILE

if not isnull(is_mobileno) and not is_mobileno = '' then
	is_mobileno =	of_fixToInternationalFormat(is_mobileno)
end IF

--VALIDASI OF_FIXINTERNATIONALFORMAT

	string lsRightFormat
	string lsNewPhone
	int liCtr
	lsNewPhone = ""
	for liCtr = 1 to len(as_phoneNumber) 
		if trim(mid(as_PhoneNumber,liCtr,1))  <> ""and trim(mid(as_PhoneNumber,liCtr,1)) <> "+"  and trim(mid(as_PhoneNumber,liCtr,1)) <> "-"  then
			lsNewPhone+= mid(as_PhoneNumber,liCtr,1)
		end if
	next
	lsRightFormat = lsNewPhone;
	
	boolean isValidPhone;
	
	int counter;
	int prefixFound ;
	string phoneToValidate
	string phonePrefix
	isValidPhone= false;
	
	if left(lsRightFormat,1) <> "0" then
		lsRightFormat = "0"+lsRightFormat
	end if
	phonePrefix = mid(lsRightFormat,1,4) 
	
	
	Select Count(PrefixNo) 
	INTO : prefixFound
	From PhonePrefix
	Where PrefixNo = : phonePrefix using sqlca;
	if integer(prefixFound) > 0 then
		if left(lsRightFormat,1) = "+" then
			return  lsRightFormat
		end if
		if left(lsRightFormat,1) = "0" then
			return "+63"+mid(lsRightFormat,2,15)
		end if
		if left(lsRightFormat,2) = "63" then
			return "+"+mid(lsRightFormat,1,15)
		end if
			return "+63"+lsRightFormat;
	else
		if left(as_PhoneNumber,1) = "+" then
			return  as_PhoneNumber
		end if
		return "+" + as_PhoneNumber
	end if 



--END VALIDASI FORMAT

if not isnull(ls_mobileno2) and not ls_mobileno2 = '' then
	 ls_mobileno2 =	of_fixToInternationalFormat(ls_mobileno2)
end IF

--VALIDASI OF_FIXINTERNATIONALFORMAT

	string lsRightFormat
	string lsNewPhone
	int liCtr
	lsNewPhone = ""
	for liCtr = 1 to len(as_phoneNumber) 
		if trim(mid(as_PhoneNumber,liCtr,1))  <> ""and trim(mid(as_PhoneNumber,liCtr,1)) <> "+"  and trim(mid(as_PhoneNumber,liCtr,1)) <> "-"  then
			lsNewPhone+= mid(as_PhoneNumber,liCtr,1)
		end if
	next
	lsRightFormat = lsNewPhone;
	
	boolean isValidPhone;
	
	int counter;
	int prefixFound ;
	string phoneToValidate
	string phonePrefix
	isValidPhone= false;
	
	if left(lsRightFormat,1) <> "0" then
		lsRightFormat = "0"+lsRightFormat
	end if
	phonePrefix = mid(lsRightFormat,1,4) 
	
	
	Select Count(PrefixNo) 
	INTO : prefixFound
	From PhonePrefix
	Where PrefixNo = : phonePrefix using sqlca;
	if integer(prefixFound) > 0 then
		if left(lsRightFormat,1) = "+" then
			return  lsRightFormat
		end if
		if left(lsRightFormat,1) = "0" then
			return "+63"+mid(lsRightFormat,2,15)
		end if
		if left(lsRightFormat,2) = "63" then
			return "+"+mid(lsRightFormat,1,15)
		end if
			return "+63"+lsRightFormat;
	else
		if left(as_PhoneNumber,1) = "+" then
			return  as_PhoneNumber
		end if
		return "+" + as_PhoneNumber
	end if 



--END VALIDASI FORMAT

if not isnull(ls_mobileno3) and not ls_mobileno3 = '' then
	 ls_mobileno3 =	of_fixToInternationalFormat(ls_mobileno3)
end IF

--VALIDASI OF_FIXINTERNATIONALFORMAT

	string lsRightFormat
	string lsNewPhone
	int liCtr
	lsNewPhone = ""
	for liCtr = 1 to len(as_phoneNumber) 
		if trim(mid(as_PhoneNumber,liCtr,1))  <> ""and trim(mid(as_PhoneNumber,liCtr,1)) <> "+"  and trim(mid(as_PhoneNumber,liCtr,1)) <> "-"  then
			lsNewPhone+= mid(as_PhoneNumber,liCtr,1)
		end if
	next
	lsRightFormat = lsNewPhone;
	
	boolean isValidPhone;
	
	int counter;
	int prefixFound ;
	string phoneToValidate
	string phonePrefix
	isValidPhone= false;
	
	if left(lsRightFormat,1) <> "0" then
		lsRightFormat = "0"+lsRightFormat
	end if
	phonePrefix = mid(lsRightFormat,1,4) 
	
	
	Select Count(PrefixNo) 
	INTO : prefixFound
	From PhonePrefix
	Where PrefixNo = : phonePrefix using sqlca;
	if integer(prefixFound) > 0 then
		if left(lsRightFormat,1) = "+" then
			return  lsRightFormat
		end if
		if left(lsRightFormat,1) = "0" then
			return "+63"+mid(lsRightFormat,2,15)
		end if
		if left(lsRightFormat,2) = "63" then
			return "+"+mid(lsRightFormat,1,15)
		end if
			return "+63"+lsRightFormat;
	else
		if left(as_PhoneNumber,1) = "+" then
			return  as_PhoneNumber
		end if
		return "+" + as_PhoneNumber
	end if 



--END VALIDASI FORMAT

if not isnull(ls_serviceContactNo) and not ls_serviceContactNo = '' then
	 ls_serviceContactNo =	of_fixToInternationalFormat(ls_serviceContactNo)
end IF

--VALIDASI OF_FIXINTERNATIONALFORMAT

	string lsRightFormat
	string lsNewPhone
	int liCtr
	lsNewPhone = ""
	for liCtr = 1 to len(as_phoneNumber) 
		if trim(mid(as_PhoneNumber,liCtr,1))  <> ""and trim(mid(as_PhoneNumber,liCtr,1)) <> "+"  and trim(mid(as_PhoneNumber,liCtr,1)) <> "-"  then
			lsNewPhone+= mid(as_PhoneNumber,liCtr,1)
		end if
	next
	lsRightFormat = lsNewPhone;
	
	boolean isValidPhone;
	
	int counter;
	int prefixFound ;
	string phoneToValidate
	string phonePrefix
	isValidPhone= false;
	
	if left(lsRightFormat,1) <> "0" then
		lsRightFormat = "0"+lsRightFormat
	end if
	phonePrefix = mid(lsRightFormat,1,4) 
	
	
	Select Count(PrefixNo) 
	INTO : prefixFound
	From PhonePrefix
	Where PrefixNo = : phonePrefix using sqlca;
	if integer(prefixFound) > 0 then
		if left(lsRightFormat,1) = "+" then
			return  lsRightFormat
		end if
		if left(lsRightFormat,1) = "0" then
			return "+63"+mid(lsRightFormat,2,15)
		end if
		if left(lsRightFormat,2) = "63" then
			return "+"+mid(lsRightFormat,1,15)
		end if
			return "+63"+lsRightFormat;
	else
		if left(as_PhoneNumber,1) = "+" then
			return  as_PhoneNumber
		end if
		return "+" + as_PhoneNumber
	end if 



--END VALIDASI FORMAT


if not isnull(ls_billingcontactNo) and not ls_billingcontactNo = '' then
	 ls_billingcontactNo =	of_fixToInternationalFormat(ls_billingcontactNo)
end IF

--VALIDASI OF_FIXINTERNATIONALFORMAT

	string lsRightFormat
	string lsNewPhone
	int liCtr
	lsNewPhone = ""
	for liCtr = 1 to len(as_phoneNumber) 
		if trim(mid(as_PhoneNumber,liCtr,1))  <> ""and trim(mid(as_PhoneNumber,liCtr,1)) <> "+"  and trim(mid(as_PhoneNumber,liCtr,1)) <> "-"  then
			lsNewPhone+= mid(as_PhoneNumber,liCtr,1)
		end if
	next
	lsRightFormat = lsNewPhone;
	
	boolean isValidPhone;
	
	int counter;
	int prefixFound ;
	string phoneToValidate
	string phonePrefix
	isValidPhone= false;
	
	if left(lsRightFormat,1) <> "0" then
		lsRightFormat = "0"+lsRightFormat
	end if
	phonePrefix = mid(lsRightFormat,1,4) 
	
	
	Select Count(PrefixNo) 
	INTO : prefixFound
	From PhonePrefix
	Where PrefixNo = : phonePrefix using sqlca;
	if integer(prefixFound) > 0 then
		if left(lsRightFormat,1) = "+" then
			return  lsRightFormat
		end if
		if left(lsRightFormat,1) = "0" then
			return "+63"+mid(lsRightFormat,2,15)
		end if
		if left(lsRightFormat,2) = "63" then
			return "+"+mid(lsRightFormat,1,15)
		end if
			return "+63"+lsRightFormat;
	else
		if left(as_PhoneNumber,1) = "+" then
			return  as_PhoneNumber
		end if
		return "+" + as_PhoneNumber
	end if 



--END VALIDASI FORMAT

if is_mobileno = ls_mobileno2 then
		idw_genInfo.SetColumn("mobileNo2")
		is_msgNo    = 'RS-0000005'
		is_msgTrail = "Saving Subscriber Master : ~r~n . Mobile Number 2 already exists. Please enter a different number."
		return -1
end if

if is_mobileno = ls_mobileno3 then
		is_msgNo    = 'RS-0000006'
		is_msgTrail = "Saving Subscriber Master : ~r~n Mobile Number 3 already exists. Please enter a different number."
		return -1
end if

if (not ls_mobileno2 = '' AND not isnull(ls_mobileno2)) and (not ls_mobileno3 = '' AND not isnull(ls_mobileno3))  then
	if ls_mobileno2 = ls_mobileno3 then
		is_msgNo    = 'RS-0000006'
		is_msgTrail = "Saving Subscriber Master : ~r~n Mobile Number 3 already exists. Please enter a different number."
		return -1
	end if 
end if 

if ls_installationremarkscode = '051' and ls_installationsubremarks = '014' then

	if isnull(ls_oldacctno) then
		is_msgNo    = 'SM-0000001'
		is_msgTrail = "Saving Subscriber Master : ~r~n Cannot save without Old Acctno."
		return -1
	end if 

end if 	

ls_installationremarkscode		= dw_header.getitemstring(ll_row,'installationremarkscode')
ls_installationsubremarks =  dw_header.getitemstring(ll_row,'installationsubremarks')



//---- check if codes entered are valid
if execute_sql("SELECT * FROM citizenshipMaster WHERE citizenshipCode = '" + ls_citizenshipCode + "'") <> 0 Then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = "Saving Subscriber Master : ~r~n Cannot save with invalid Citizenship Code."
	return -1
end if	

if execute_sql("SELECT * FROM barangayMaster WHERE barangayCode = '" + ls_serviceBarangayCode + "'") <> 0 Then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = "Saving Subscriber Master : ~r~n Cannot save with invalid service Barangay Code."
	return -1
end if	

if execute_sql("SELECT * FROM agentMaster WHERE agentCode = '" + ls_agentCode + "'") <> 0 Then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = "Saving Subscriber Master : ~r~n Cannot save with invalid agent code."
	return -1
end if	

if execute_sql("SELECT * FROM municipalityMaster WHERE municipalityCode = '" + ls_serviceMunicipalityCode + "'") <> 0 Then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = "Saving Subscriber Master : ~r~n Cannot save with invalid service Municipality Code."
	return -1
end if	
if execute_sql("SELECT * FROM provinceMaster WHERE provinceCode = '" + ls_serviceProvinceCode + "'") <> 0 Then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = "Saving Subscriber Master : ~r~n Cannot save with invalid service province Code."
	return -1
end if	

if execute_sql("SELECT * FROM barangayMaster WHERE barangayCode = '" + ls_billingBarangayCode + "'") <> 0 Then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = "Saving Subscriber Master : ~r~n Cannot save with invalid Billing Barangay Code."
	return -1
end if	
if execute_sql("SELECT * FROM municipalityMaster WHERE municipalityCode = '" + ls_billingMunicipalityCode + "'") <> 0 Then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = "Saving Subscriber Master : ~r~n Cannot save with invalid Billing Municipality Code."
	return -1
end if	
if execute_sql("SELECT * FROM provinceMaster WHERE provinceCode = '" + ls_billingProvinceCode + "'") <> 0 Then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = "Saving Subscriber Master : ~r~n Cannot save with invalid Billing province Code."
	return -1
end if	

if execute_sql("SELECT * FROM chargeTypeMaster WHERE chargeTypeCode = '" + ls_chargeTypeCode + "'") <> 0 Then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = "Saving Subscriber Master : ~r~n Cannot save with invalid Customer Type Code."
	return -1
end if	

if execute_sql("SELECT * FROM subsUserTypeMaster WHERE subsUserTypeCode = '" + ls_subsUserTypeCode + "'") <> 0 Then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = "Saving Subscriber Master : ~r~n Cannot save with invalid Subscriber User Type Code."
	return -1
end if	

if execute_sql("SELECT * FROM arPackageMaster WHERE packageCode = '" + ls_packageCode + "'" + " AND divisionCode = '"+gs_divisionCode+"'" +  " AND companyCode = '"+gs_companyCode+"'" ) <> 0 Then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = "Saving Subscriber Master : ~r~n Cannot save with invalid service Package Code."
	return -1
end if	
if execute_sql("SELECT * FROM subscriberStatusMaster WHERE subscriberStatusCode = '" + ls_subscriberStatusCode + "'") <> 0 Then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = "Saving Subscriber Master : ~r~n Cannot save with invalid service Subscriber Status Code."
	return -1
end if	
if execute_sql("SELECT * FROM subscriberTypeMaster WHERE subsTypeCode = '" + is_substypecode + "'") <> 0 Then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = "Saving Subscriber Master : ~r~n Cannot save with invalid service Subscriber Type Code."
	return -1
end if

// added for staggered payment russ 1/22/2018


update napport_assignment_latest
set status = 'RS' , acctno = :ls_acctno , client_name = :ls_subscribername
where nap_code = :ls_napcode
and port_no = :ls_portno
using SQLCA;
	

if is_isstaggered = 'O' then is_isstaggered = 'N' 
if is_isstaggered = 'S' then
	
	if ll_noofmonthsamort = 0 or isnull(ll_noofmonthsamort) then

		is_msgNo    = 'SM-0000001'
		is_msgTrail = "Saving Subscriber Master : ~r~n Cannot save record with 0 months Staggered"
		return -1
	end if
	
	is_isstaggered = 'Y' 
end IF

--Insert record to arAcctSubscriber
INSERT INTO arAcctSubscriber
		(tranNo,
		acctNo,
		subscriberName,
		typeOfBusiness	,
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
		mobileNo2,
		mobileNo3,
		faxNo,
		emailAddress,
		emailAddress2,
		emailAddress3,
		spousename,
		nameofcompany,
		guarantor,
		chargeTypeCode,
		subsUserTypeCode,
		packageCode,
		subscriberStatusCode,
		substypecode,
		dateApplied,
		qtyAcquiredSTB,
		totalBoxesBeforeDeactivation,
		numberOfRooms,
		occupancyRate,
		mLineCurrentMonthlyRate,
		mLinePreviousMonthlyRate,
		extCurrentMonthlyRate,
		extPreviousMonthlyRate,
		agentCode,
		preferreddatetimefrom,
		preferreddatetimeto,
		specialinstructions,
		noOfRequiredSTB,
		noOfExtraSTB,
		acquisitiontypecode,
		applicationStatusCode,
		useradd,
		dateadd,
		instFee,
		forAcceptance,
		divisionCode,
		nodeNo,
		companyCode,
		subsUserName,
		password,
		currencyCode,
		lockInPeriod,
		installationremarkscode,
		isSoaPrinting,
		iscableboxemail,
		issmssending,
		isemailsending,
		lastUpdateOfTags,
		lastUserUpdateOfTags, 
		installationremarksgroupcode,
		isprintcomclark,
		isprintconverge,
		isprintsme,
		company,
		salessource,
		referredby,
		isstaggered,
		noofmonthsamort,
		napcode,
		portno,
		dbdirection,
		from_nocoicop,
		payment_option,
		oldacctno,
		reference_code
		)
	VALUES
		(:ls_tranNo,
		:ls_acctNo,
		:ls_subscriberName,
		:ls_typeOfBusiness,
		:ls_lastName,
		:ls_firstName,
		:ls_middleName,
		:ls_motherMaidenName	,
		:ls_citizenshipCode,
		:ls_sex,
		:ldt_birthDate,
		:ls_civilStatus,
		:ls_telNo,
		:is_mobileNo,
		:ls_mobileNo2,
		:ls_mobileNo3,
		:ls_faxNo,
		:ls_emailAddress,
		:ls_emailAddress2,
		:ls_emailAddress3,
		:ls_spousename,
		:ls_nameofcompany,
		:ls_guarantor,
		:ls_chargeTypeCode	,
		:ls_subsUserTypeCode	,
		:ls_packageCode,
		:ls_subscriberStatusCode,
		:is_subsTypeCode,
		:ldt_dateApplied,
		:ll_qtyAcquiredSTB,
		:ll_totalBoxesBeforeDeactivation,
		:ll_numberOfRooms,
		:ld_occupancyRate,
		:ld_mLineCurrentMonthlyRate, 
		0.00,
		:ld_extCurrentMonthlyRate,
		0.00,
		:ls_agentCode,
		:ldt_preferreddatetimefrom,
		:ldt_preferreddatetimeto,
		:ls_specialinstructions,
		:ll_noofrequiredSTB,  // noOfRequiredSTB - by default only one STB is required for mainLine
		:li_noOfExtraSTB,
		:ls_acqusitiontypecode,
		'FJ',
		:gs_username,
		:ldt_dateadd,
		:ad_applicationFee,
		:ls_acceptance,
		:gs_divisionCode,
		:li_nodeNo,
		:gs_companyCode,
		:ls_userName,
		:ls_password,
		:ls_currencyCode,
		:li_lockIn,
		:ls_installationremarkscode,
		:ls_isSoaPrinting,
		:ls_isCableBoxSending,
		:ls_isSMSSending,
		:ls_isEmailSending, 
		:ldt_lastupdatetags,
		:gs_userName,
		:ls_installationsubremarks,
		:ls_isPrintComclark,
		:ls_isPrintConverge,
		:ls_isPrintSME,
		:ls_typeOfCompany,
		:ls_salessourcecode , 
		:ls_referredby,
		:is_isstaggered,
		:ll_noofmonthsamort,
		:ls_napcode,
		:ls_portno,
		'IBAS',
		:ls_fromnocoicop,
		:ll_payment_option,
		:ls_oldacctno,
		:is_referenceCode
		)
	USING SQLCA;
	
	if SQLCA.SQLCode = -1 then
		is_msgNo    = 'SM-0000001'
		is_msgTrail = "Saving AR Account Subscriber ~nSQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
		return -1
	end if
	
	insert into arAccountMaster 
		(acctNo,
		 accountTypeCode,
		 acctName,
		 contactNo,
		 emailadd,
		 currencyCode,
		 refAcctNo,
		 divisionCode,
		 companyCode,
		 taxProfileCode,
		 isVAT,
		 isnonvat,
		 iswhtagent)
	values
		(:ls_acctNo,
		 'ARSUB',
		 :ls_subscriberName,
		 :ls_serviceLessorOwnerContactNo,
		 :ls_emailAddress,
		 :ls_currencyCode,
		 null,
		 :gs_divisionCode,
		 :gs_companyCode,
		 '001',
		 'Y',
		 'N',
		 'N'
		)
	USING SQLCA;
	if SQLCA.SQLCode = -1 then
		is_msgNo    = 'SM-0000001'
		is_msgTrail = "Saving AR Account Master ~nSQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
		return -1
	end if
	
	--AR Account Service Address
	insert into arAcctAddress 
		(acctNo,
	    addressTypeCode,
		 isDefaultServiceAdd,
		 lotNo,
		 blkNo,
		 phaseNo,
		 district,
		 subdivisionCode,
		 barangayCode,
		 municipalityCode,
		 provinceCode,
		 countryCode,
		 zipCode,
		 serviceLessorOwnerName,
		 serviceLessorOwnerContactNo,
		 serviceYearsResidency,
		 serviceExpirationDate,
		 serviceHomeOwnerShip,
		 streetName,
		 bldgName,
		 roomNo,
		 floorNo,
		 contactName,
		 contactNo,
		 designation,
		 houseNo,
		 purokNo,
		 divisionCode,
		 companyCode,
		 gpscoordinatee,
		 gpscoordinaten 
		 )
	values
		(:ls_acctNo,
		 'SERVADR1',
		 'Y',
		 :ls_serviceLotNo,
		 :ls_serviceBlockNo,
		 :ls_servicePhase,
		 :ls_serviceDistrict,
		 :ls_serviceSubdivisionCode,
		 :ls_serviceBarangayCode,
		 :ls_serviceMunicipalityCode,
		 :ls_serviceProvinceCode,
		 '000001',
		 null,
		 :ls_serviceLessorOwnerName,
		 :ls_serviceLessorOwnerContactNo,
		 :li_serviceYearsResidency,
		 :ldt_serviceExpirationDate,
		 :ls_serviceHomeOwnerShip,
		 :ls_serviceStreetName,
		 :ls_serviceBldgCompApartmentName,
		 null,
		 null,
		 :ls_serviceContactName,
		 :ls_serviceContactNo,
		 null,
		 :ls_serviceHouseNo,
		 :ls_servicePurok,
		 :gs_divisionCode,
		 :gs_companyCode,
		 :ls_longitude,
		 :ls_latitude
		)
	USING SQLCA;
	if SQLCA.SQLCode = -1 then
		is_msgNo    = 'SM-0000001'
		is_msgTrail = "Saving AR Account Address ~nSQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
		return -1
	end if
	
	
	
	--AR Account BILLING Address
	insert into arAcctAddress 
		(acctNo,
	    addressTypeCode,
		 isDefaultServiceAdd,
		 lotNo,
		 blkNo,
		 phaseNo,
		 district,
		 subdivisionCode,
		 barangayCode,
		 municipalityCode,
		 provinceCode,
		 countryCode,
		 zipCode,
		 serviceLessorOwnerName,
		 serviceLessorOwnerContactNo,
		 serviceYearsResidency,
		 serviceExpirationDate,
		 serviceHomeOwnerShip,
		 streetName,
		 bldgName,
		 roomNo,
		 floorNo,
		 contactName,
		 contactNo,
		 designation,
		 houseNo,
		 purokNo,
		 divisionCode,
		 companyCode
		 )
	values
		(:ls_acctNo,
		 'BILLING',
		 'N',
		 :ls_billingLotNo,
		 :ls_billingBlockNo,
		 :ls_billingPhase,
		 :ls_billingDistrict,
		 :ls_billingSubdivisionCode,
		 :ls_billingBarangayCode,
		 :ls_billingMunicipalityCode,
		 :ls_billingProvinceCode,
		 '000001',
		 null,
		 :ls_serviceLessorOwnerName,
		 :ls_serviceLessorOwnerContactNo,
		 :li_serviceYearsResidency,
		 :ldt_serviceExpirationDate,
		 :ls_serviceHomeOwnerShip,
		 :ls_billingStreetName,
		 :ls_billingBldgCompApartmentName,
		 null,
		 null,
		 :ls_billingcontactName,
		 :ls_billingcontactNo,
		 null,
		 :ls_billingHouseNo,
		 :ls_billingPurok,
		 :gs_divisionCode,
		 :gs_companyCode
		)
	USING SQLCA;
	if SQLCA.SQLCode = -1 then
		is_msgNo    = 'SM-0000001'
		is_msgTrail = "Saving AR Account Address ~nSQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
		return -1
	end if
	/*---------This part added for subscriber application character refferences-----*/
	string ls_charFullName, ls_charAddress, ls_charRelationship, ls_charContactNo
	long   ll_charLoop, ll_charData
	
	idw_charRefs.accepttext()
	ll_charData = idw_charRefs.rowCount()
	
	for ll_charLoop = 1 to ll_charData
		
		ls_charFullName 		= idw_charRefs.getItemString(ll_charLoop,'charfullname')
		ls_charAddress			= idw_charRefs.getItemString(ll_charLoop,'charaddress')
		ls_charRelationship	= idw_charRefs.getItemString(ll_charLoop,'charrelationship')
		ls_charContactNo		= idw_charRefs.getItemString(ll_charLoop,'charcontactno')
		
		insert into subscriberApplicationCharRefs
			(acctNo, 
			 charFullName, 
			 charAddress,
			 charRelationship,
			 charContactNo,
			 divisionCode,
			 companyCode)
		values
			(:ls_acctNo,
			 :ls_charFullName,
			 :ls_charAddress,
			 :ls_charRelationship,
			 :ls_charContactNo,
			 :gs_divisionCode,
			 :gs_companyCode)
		using SQLCA; 
		
		if SQLCA.SQLCode = -1 then
			is_msgNo    = 'SM-0000001'
			is_msgTrail = "Saving Subscriber Character Refferences  ~nSQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
			return -1
		end if
		
	next 
	if is_tempAcctno <> '' or not isnull(is_tempAcctno) then
		
		select imagepath 
		into :ls_imagepath
		from subscriberimagemaster
		where acctno = :is_tempAcctno
		and companycode = :gs_companycode
		and divisioncode = :gs_divisioncode
		using SQLCA;
		if SQLCA.SQLCode < 0 then
			is_msgNo    = 'SM-0000001'
			is_msgTrail = "Unable to get information from table [subscriberimagemaster]~nSQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
			return -1
		end if
		
		if ls_imagepath <> '' or not isnull(ls_imagepath) then
			string ls_leftimagepath, ls_rightimagepath,ls_newimagepath
			ls_leftimagepath = left(ls_imagepath,30)
			ls_rightimagepath = right(ls_imagepath,6)
			ls_newimagepath = ls_leftimagepath + ls_acctno + ls_rightimagepath
			integer li_FileNum

			li_FileNum = FileCopy (ls_imagepath ,ls_newimagepath, TRUE)
			
			if trim(ls_imagepath) <> trim(ls_newimagepath) then
				filedelete(ls_imagepath)
			end if
			
			update subscriberimagemaster
			set imagepath = :ls_newimagepath, acctno = :ls_acctno
			where imagepath = :ls_imagePath
			and acctno = :is_tempacctno
			and companycode = :gs_companycode
			and divisionCode = :gs_divisioncode
			using SQLCA;
			if SQLCA.SQLCode < 0 then
				is_msgNo    = 'SM-0000001'
				is_msgTrail = "Unable to update table[subscriberimagemaster]~nSQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
				return -1
			end if

		end if
	end if
	
if not isNull(gb_authorizationNo) and gb_authorizationNo <> "" then

	update overridePolicy
	set acctNo = :as_acctNo
	where tranNo = :gb_authorizationNo
	and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	and requestStatus = 'AP'
	using SQLCA;
	
	commit using SQLCA;

end if		


update napport_assignment_latest
set portstatus = 'RS', acctno = :as_acctNo
where portno = :ls_portno
and napcode = :ls_napcode
and divisioncode = :gs_divisioncode
and companycode = :gs_companycode
using SQLCA;


update INSTANTKABITACCTNO
set used = 'Y', subscribername = :ls_subscriberName, packagecode = :ls_packagecode
where acctno = :is_acctno
and divisioncode = :gs_divisioncode
using SQLCA;


UPDATE SERVICEABILITYREQUEST SET ISRESERVENAPPORT = 'Y',ISRESERVEDNAPPORT = 'N' , ACCOUNTNUMBER = :ls_acctno
WHERE LONGITUDE = :is_longitude  and LATITUDE = :is_latitude 
AND ISSERVICEABLE = 'Y '
USING SQLCA;


return 0

--END VALIDASI

--==================================================
--NGLara | 03-17-2008
--Prepare GL Poster
if not iuo_glPoster.initialize(is_transactionID, is_tranNo, idt_tranDate) then
	is_msgno 	= 'SM-0000001'
	is_msgtrail = iuo_glPoster.errorMessage
	is_sugtrail = iuo_glPoster.suggestionRemarks
	return -1
end IF

--VALIDASI IUO_GLPOSTER
	initialized = True
	dw_GLEntries.reset()
	
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
	
	return True

--END VALIDASI

uo_subs_advar.setGLPoster(iuo_glPoster)

--VALIDASI setGLPoster
--==================================================
--NGLara | 03-15-2008
--Call this method in order to prepare GL entries
--and perform GL Posting
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
iuo_glPoster = auo_glPoster

--END VALIDASI

--==================================================
--Apply Open Credits
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if not uo_subs_advar.setAcctNo(ls_acctno) then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = uo_subs_advar.lastSQLCode + '~r~n' + uo_subs_advar.lastSQLErrText
	return -1
end if
if	This.Event ue_applyOCBalances(ld_instFee) <> 0 then
	return -1	
end if
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 

--VALIDASI SETACCTNO

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
	
--END VALIDASI SETACCTNO

if not iuo_glPoster.postGLEntries() then
	is_msgno 	= 'SM-0000001'
	is_msgtrail =  iuo_glPoster.errorMessage
	is_sugtrail = iuo_glPoster.suggestionRemarks
	return -1
end IF

--NOT USE postGLEntries
string 		ls_accountCode, ls_glAccountCode, ls_sourceTranTypeCode, ls_sourceTranNo, ls_remarks, ls_glDistClr
decimal{2}	ld_debit, ld_credit, ld_totalDebit, ld_totalCredit, ld_gTotDebit, ld_gTotCredit, ld_gTotDiff
long 			ll_records, ll_row, ll_lineNum
integer		li_fileNum

ld_gTotDebit 	= 0
ld_gTotCredit	= 0
ld_gTotDiff    = 0

--END 

uo_subscriber luo_subscriber

if not luo_subscriber.setAcctNo(ls_acctno) then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = luo_subscriber.lastSQLCode + '~r~n' + luo_subscriber.lastSQLErrText
	return -1
end if 

--VALIDASI LUO_SUBRIBER.SETACCTNO

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

return TRUE

--END VALIDASI

if luo_subscriber.autocreatejo() < 0 then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = luo_subscriber.lastSQLCode + '~r~n' + luo_subscriber.lastSQLErrText
	return -1
end if 

--VALIDASI luo_subscriber.autocreatejo

	decimal ld_balance, ld_accepted_rip_amt, ld_balance_rip 
	date ld_jodate
	
	string		ls_joNo, ls_tranTypeCode, ls_acctNo, ls_lineManCode, ls_referenceNo, ls_joStatusCode, ls_trantype, ls_teamcode, ls_teammembercode
	string		ls_sqlcode, ls_sqlerrtext, ls_refno, ls_specialInstructions, ls_batch, ls_tranNo, ls_serialNo, ls_NOCOICOP
	datetime		ldt_joDate, ldt_preferredDatetimeFrom, ldt_preferredDatetimeTo
	long			ll_ans, ll_joNo, ll_tranNo
	integer		li_noOfSTB
	
	string ls_from_nocoicop
	
	boolean is_nocoicop
	
	long ll_count
	
	uo_jo_nv luo_jo
	
	long ll_payment_option
	
	string ls_napcode, ls_portno
	
	select nvl(payment_option,0), napcode, portno into :ll_payment_option,  :ls_napcode, :ls_portno
	from arAcctSubscriber
	where acctno = :acctno
	and divisioncode = :gs_divisioncode
	and companycode = :gs_companycode
	using SQLCA;
			
		
	
	if subscriberStatusCode <> 'APL' then
		return 0
	end if 
	
	select NOCOICOP into :ls_NOCOICOP
	from systemparameter
	where divisioncode = :gs_divisionCode
	and companyCode = :gs_companyCode
	using SQLCA;
	
	
	select sum(balance) into :ld_balance
	from artranhdr
	where acctno = :acctno
	and divisioncode = :gs_divisioncode
	and companycode = :gs_companycode
	using SQLCA;
	
	if isnull(ld_balance)  then ld_balance = 0
	
	select sum(balance) into :ld_balance_rip
	from subsinitialpayment
	where acctno = :acctNo
	and divisioncode = :gs_divisioncode
	and companycode = :gs_companycode
	using SQLCA;
	
	if isnull(ld_balance_rip) then ld_balance_rip = 0
	
	
	select amount into :ld_accepted_rip_amt
	from accepted_rip_amount
	using SQLCA;
	
	boolean is_minimum
	
	is_minimum = (ld_balance_rip + ld_balance )<= ld_accepted_rip_amt
	
	if is_minimum or ls_NOCOICOP = 'Y' or ll_payment_option = 1 THEN
		
		select napcode , portno,  preferreddatetimefrom, tranno into :ls_napcode , :ls_portno , :ld_jodate, :ls_referenceNo
		from aracctsubscriber
		where acctno = :acctNo
		and divisioncode = :gs_divisioncode
		and companycode = :gs_companycode
		using SQLCA;
		
		uf_get_applPreferences(ls_tranTypeCode, ls_referenceNo, ldt_preferredDatetimeFrom, ldt_preferredDatetimeTo, ls_specialInstructions)
		
		--VALIDASI UF_GET_APPLPREFERENCE
		
		if as_tranTypeCode = 'APPLYML' then
				select preferreddatetimefrom,
						 preferreddatetimeto,
						 specialInstructions
				  into :adt_datefrom,
				  		 :adt_dateto,
						 :as_specialinstructions
				  from arAcctSubscriber
				 where tranNo = :as_tranNo
				 	and divisionCode = :gs_divisionCode
					and companyCode = :gs_companyCode
				using SQLCA;
				if SQLCA.sqlcode <> 0 then
					return FALSE
				end if
			elseif as_tranTypeCode = 'CONVD2F' then
				select preferreddatetimefrom,
						 preferreddatetimeto,
						 specialInstructions
				  into :adt_datefrom,
				  		 :adt_dateto,
						 :as_specialinstructions
				  from conversiondoctofibtran
				 where tranNo = :as_tranNo
				 and divisionCode = :gs_divisionCode
					and companyCode = :gs_companyCode
				using SQLCA;
				if SQLCA.sqlcode <> 0 then
					return FALSE
				end if
				
			elseif as_tranTypeCode = 'APPLYEXT' then
				select preferreddatetimefrom,
						 preferreddatetimeto,
						 specialInstructions
				  into :adt_datefrom,
				  		 :adt_dateto,
						 :as_specialinstructions
				  from applOfExtTranHdr
				 where tranNo = :as_tranNo
				 and divisionCode = :gs_divisionCode
					and companyCode = :gs_companyCode
				using SQLCA;
				if SQLCA.sqlcode <> 0 then
					return FALSE
				end if
			
			elseif as_tranTypeCode = 'SERVCALL' then
				select scheduledDateTime,
						 scheduledDateTime,
						 specialInstruction
				  into :adt_datefrom,
				  		 :adt_dateto,
						 :as_specialinstructions
				  from serviceCallTranHdr
				 where tranNo = :as_tranNo
				 and divisionCode = :gs_divisionCode
					and companyCode = :gs_companyCode
				using SQLCA;
				if SQLCA.sqlcode <> 0 then
					return FALSE
				end if	
			
			elseif as_tranTypeCode = 'APPLMLEXTREA' then
				select preferreddatetimefrom,
						 preferreddatetimeto,
						 specialInstructions
				  into :adt_datefrom,
				  		 :adt_dateto,
						 :as_specialinstructions
				  from applOfReactivationTranHdr
				 where tranNo = :as_tranNo
				 and divisionCode = :gs_divisionCode
					and companyCode = :gs_companyCode
				using SQLCA;
				if SQLCA.sqlcode <> 0 then
					return FALSE
				end if	
			
			elseif as_tranTypeCode = 'APPLYTRANSFR' then
				select preferreddatetimefrom,
						 preferreddatetimeto,
						 specialInstructions
				  into :adt_datefrom,
				  		 :adt_dateto,
						 :as_specialinstructions
				  from applOfTransferTranHdr
				 where tranNo = :as_tranNo
				 using SQLCA;
				if SQLCA.sqlcode <> 0 then
					return FALSE
				end if	
			
			elseif as_tranTypeCode = 'APPLYXTDSRVC' then
				select preferreddatetimefrom,
						 preferreddatetimeto,
						 specialInstructions
				  into :adt_datefrom,
				  		 :adt_dateto,
						 :as_specialinstructions
				  from applExtendedServicesTranHdr
				 where tranNo = :as_tranNo
				 and divisionCode = :gs_divisionCode
					and companyCode = :gs_companyCode
				using SQLCA;
				if SQLCA.sqlcode <> 0 then
					return FALSE
				end if	
			
			elseif as_tranTypeCode = 'APPLYPD' then
				select preferreddatetimefrom,
						 preferreddatetimeto,
						 specialInstructions
				  into :adt_datefrom,
				  		 :adt_dateto,
						 :as_specialinstructions
				  from applOfPermanentDiscTranHdr
				 where tranNo = :as_tranNo
				 and divisionCode = :gs_divisionCode
					and companyCode = :gs_companyCode
				using SQLCA;
				if SQLCA.sqlcode <> 0 then
					return FALSE
				end if	
			
			elseif as_tranTypeCode = 'APPLYDEAC' then
				select preferreddatetimefrom,
						 preferreddatetimeto,
						 specialInstructions
				  into :adt_datefrom,
				  		 :adt_dateto,
						 :as_specialinstructions
				  from applOfDeactivationTranHdr
				 where tranNo = :as_tranNo
				 and divisionCode = :gs_divisionCode
					and companyCode = :gs_companyCode
				using SQLCA;
				if SQLCA.sqlcode <> 0 then
					return FALSE
				end if	
			
			elseif as_tranTypeCode = 'REPANADIGI' then
				select preferreddatetimefrom,
						 preferreddatetimeto,
						 specialInstructions
				  into :adt_datefrom,
				  		 :adt_dateto,
						 :as_specialinstructions
				  from AppOfDigitalConversionTranHdr
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
		
		select count(jono) into :ll_count
		from jotranhdr
		where acctno = :acctno
		and divisioncode = :gs_divisioncode
		and companycode = :gs_companycode
		and trantypecode = 'APPLYML'
		using SQLCA;
		
		if ll_count > 0 and ll_payment_option = 0  then
			
			return 0
		
		end if
		
		if ll_count > 0 and ll_payment_option = 1 then
		
			return 0
		
		end if
	
		if not guo_func.get_nextnumber("JO", ll_joNo, "WITH LOCK") then
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
			
			return true
		
		--END VALIDASI GET_NEXTNUMBER
		
		ls_joNo 			= string(ll_joNo, "00000000")
		ls_tranTypeCode 	= 'APPLYML'
		ls_lineManCode		= '00013'
		
		
		ls_joStatusCode 	= "FR"
	
		
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
						:ls_referenceNo,
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
		
		if not uf_set_referenceJoNo(ls_tranTypeCode, ls_referenceNo, ls_joNo) then
			return -1
		end IF
		
		--VALIDASI uf_set_referenceJoNo
			if as_trantypecode = 'APPLYML' then
				update arAcctSubscriber
					set referenceJONo = :as_jono
				 where tranNo = :as_tranno
				 and divisionCode = :gs_divisionCode
				and companyCode = :gs_companyCode
				using SQLCA;
			elseif as_trantypecode = 'CONVD2F' then
				update conversiondoctofibtran
					set referenceJONo = :as_jono
				 where tranNo = :as_tranno
				 and divisionCode = :gs_divisionCode
				and companyCode = :gs_companyCode
				using SQLCA;
			elseif as_trantypecode = 'CONVD2DF' then
				update CONVERSIONDSLTODOCFIBTRAN
					set referenceJONo = :as_jono
				 where tranNo = :as_tranno
				 and divisionCode = :gs_divisionCode
				and companyCode = :gs_companyCode
				using SQLCA;
			elseif as_trantypecode = 'APPLYEXT' then
				update applOfExtTranHdr
					set referenceJONo = :as_jono
				 where tranNo = :as_tranno
				 and divisionCode = :gs_divisionCode
				and companyCode = :gs_companyCode
				using SQLCA;
			elseif as_trantypecode = 'APPLEXTHO' then
				update applOfExtHotelTranHdr
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
			elseif as_trantypecode = 'APPLYTRANSFR' then
				update applOfTransferTranHdr
					set referenceJONo = :as_jono
				 where tranNo = :as_tranno
				 and divisionCode = :gs_divisionCode
				and companyCode = :gs_companyCode
				using SQLCA;
			elseif as_trantypecode = 'APPLYXTDSRVC' then
				update applExtendedServicesTranHdr
					set referenceJONo = :as_jono
				 where tranNo = :as_tranno
				 and divisionCode = :gs_divisionCode
				and companyCode = :gs_companyCode
				using SQLCA;
			elseif as_trantypecode = 'PULLOUTADS' then
				update adsTranHdr
					set referenceJONo = :as_jono
				 where tranNo = :as_tranno
				 and divisionCode = :gs_divisionCode
				and companyCode = :gs_companyCode
				using SQLCA;
			elseif as_trantypecode = 'APPLEXTD' then
				update applOfExtDiscTranHdr
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
			elseif as_trantypecode = 'APPLMLEXTREA' then
				update applOfReactivationTranHdr
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
			elseif as_trantypecode = 'REPANADIGI' then
				update AppOfDigitalConversionTranHdr
					set referenceJONo = :as_jono
				 where tranNo = :as_tranno
				 and divisionCode = :gs_divisionCode
				and companyCode = :gs_companyCode
				using SQLCA;
			elseif as_trantypecode = 'SERVMGMT' then
				update serviceCallMaster
					set referenceJONo = :as_jono
				 where tranNo = :as_tranno
				 and divisionCode = :gs_divisionCode
				and companyCode = :gs_companyCode
				using SQLCA;	
			elseif as_trantypecode = 'ADDFIBERTV' then
				update APPLOFVASTRANHDR
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
		
		--END VALIDASI uf_set_referenceJoNo
		
		if not guo_func.set_number("JO", ll_joNo) then
			return -1
		end IF
		
		----VALIDASI SET NUMBER
		
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
		
		IF is_minimum then
			ls_from_nocoicop = 'N'
		else
			ls_from_nocoicop = 'Y'
		end if
		
			update arAcctSubscriber
			set applicationStatusCode = 'FR' , from_nocoicop = :ls_from_nocoicop
			where acctno = :acctNo
			and divisionCode = :gs_divisionCode
			and companyCode = :gs_companyCode
			using sqlca;
			if sqlca.sqlcode < 0 then
				return -1
			end if
	
		
		update_ssp_status(acctNo, gs_divisioncode, gs_companycode, 'From Payment' , '')
		
		--VALIDASI UPDATE_SSP_STATUS
		
		
				string ls_napcode, ls_remarks, ls_jonumber, ls_reference_code, ls_fullacctno, ls_jono, ls_subscriberstatuscode
				string ls_dateinstalled
				integer li_portno, li_trigger_type
				decimal{2} ld_balance_rip , ld_balance_sip
				
				string ls_or_number
				
				long ll_pos_1 , ll_pos_2 
				
				
				select reference_code, napcode, portno, to_char(dateinstalled,'MM/DD/YYYY') into :ls_reference_code, :ls_napcode, :li_portno, :ls_dateinstalled
				from aracctsubscriber
				where acctno = :as_acctno
				and divisioncode = :as_divisioncode
				and companycode = :as_companycode
				using SQLCA;
				
				if ls_reference_code = '' or isnull(ls_reference_code) then
					return 0
				end if
				
				
				select acctno, subscriberstatuscode into :ls_fullacctno, :ls_subscriberstatuscode
				from vw_fullacctno
				where ibas_Acctno = :as_Acctno
				and divisioncode = :as_divisioncode
				and companycode = :as_companycode
				using SQLCA;
				
				select jono into :ls_jono
				from Jotranhdr
				where trantypecode = 'APPLYML'
				AND divisioncode = :as_divisioncode
				and companycode = :as_companycode
				and acctno = :as_acctno
				and rownum< 2
				using SQLCA;
				
				if ls_subscriberstatuscode <> 'APL' then
					return 0
				end if
				
				string ls_updatestatustype
				string ls_date_today
				
				select to_char(sysdate,'MM/DD/YYYY') into :ls_date_today from dual using SQLCA;
				
				select sum(balance) into :ld_balance_rip 
				from artranhdr
				where acctno = :as_acctno
				and divisioncode = :as_divisioncode
				and companycode = :as_companycode
				using SQLCA;
				
				if isnull(ld_balance_rip) then ld_balance_rip = 0.00
				
				select sum(balance) into :ld_balance_sip 
				from subsinitialpayment
				where acctno = :as_acctno
				and divisioncode = :as_divisioncode
				and companycode = :as_companycode
				using SQLCA;
				
				if isnull(ld_balance_sip)  then ld_balance_sip = 0.00
				
				decimal{2} ld_total_balance
				string ls_reftranno, ls_trantypecode
				
				ld_total_balance = ld_balance_rip + ld_balance_sip
				
				if as_triggered_by = 'From Payment' or as_triggered_by  = 'From Prepare Job Order' then
					li_trigger_type = 7
					ls_updatestatustype = 'FOR SCHEDULE OF INSTALLATION'
					ls_remarks = 'JOBORDER NO. ' + ls_jono
					ls_reftranno = ls_jono
					ls_trantypecode = 'APPLYML'
				elseif as_triggered_by = 'On Going Installation' then
					li_trigger_type = 8
				elseif as_triggered_by = 'On Hold' then
					li_trigger_type = 12
				elseif as_triggered_by = 'Cancelled' then
					li_trigger_type = 13
					ls_updatestatustype = 'CANCELLED'
					ls_remarks = 'DATE CANCELLED: '+ ls_date_today + ' ' + as_trigger_remarks
					ls_reftranno = ls_jono
					ls_trantypecode = 'CANCELJO'
				elseif as_triggered_by = 'Active' then
					li_trigger_type = 9
					ls_updatestatustype = 'ACTIVE'
					ls_reftranno = ls_jono
					ls_trantypecode = 'JOCLOSING'
					ls_remarks = 'DATE INSTALLED: '+ ls_dateinstalled
				elseif as_triggered_by = 'Insufficient Payment' then
					ls_updatestatustype = 'PAYMENT INSUFFICIENT'
					
					ll_pos_1 = pos(as_trigger_remarks,':')
					ll_pos_2 = pos(as_trigger_remarks,'ORDATE')
					
					ls_or_number = mid(as_trigger_remarks, ll_pos_1+1, 8)
				
					ls_reftranno = ls_or_number
					ls_trantypecode = 'COLLECTION'
					ls_remarks = as_trigger_remarks + ' Please settle remaining: P' + string(ld_total_balance)
				end if
				
				
				if POS(ls_reference_code,'SMA-') > 0 and as_triggered_by <> 'Active' then
				
				end if
				
				
				insert into UPDATEAPPSTATUSSSP
				(reference_no,
				 trigger_type,
				 acct_no,
				 nap_code,
				 port_no,
				 remarks,
				 job_order_no,
				 activation_date,
				 created_at,
				 processed,
				 trigger_remarks)
				 values
				 (:ls_reference_code,
				  :li_trigger_type,
				  :ls_fullacctno,
				  :ls_napcode,
				  :li_portno,
				  :as_triggered_by,
				  :ls_jono,
				  null,
				  sysdate,
				  'N',
				  :as_trigger_remarks)
				  USING SQLCA;
				  
				  COMMIT USING SQLCA;
				 
				 
				 RETURN 0
		
		--END VALIDASI UPDATE_SSP_STATUS
		
		return 0
	else
		long ll_id
		string ls_receiptno, ls_col_remarks, ls_ordate
		decimal{2} ld_amount
		
		select max(id) into :ll_id
		from collectiontranhdr
		where acctno = :acctNo
		and divisioncode = :gs_divisioncode
		and companycode = :gs_companycode
		using SQLCA;
		
		
		select receiptno, to_char(trandate,'MM/DD/YYYY'), amount into :ls_receiptno, :ls_ordate, :ld_amount
		from collectiontranhdr
		where id = :ll_id
		and  acctno = :acctNo
		and divisioncode = :gs_divisioncode
		and companycode = :gs_companycode
		using SQLCA;
		
		ls_col_remarks = 'ORNO.:'+ls_receiptno+' ORDATE:'+ ls_ordate +' OR AMOUNT:' + string(ld_amount)
		
		update_ssp_status(acctNo, gs_divisioncode, gs_companycode, 'Insufficient Payment' , ls_col_remarks)
		
			--VALIDASI UPDATE_SSP_STATUS
		
		
				string ls_napcode, ls_remarks, ls_jonumber, ls_reference_code, ls_fullacctno, ls_jono, ls_subscriberstatuscode
				string ls_dateinstalled
				integer li_portno, li_trigger_type
				decimal{2} ld_balance_rip , ld_balance_sip
				
				string ls_or_number
				
				long ll_pos_1 , ll_pos_2 
				
				
				select reference_code, napcode, portno, to_char(dateinstalled,'MM/DD/YYYY') into :ls_reference_code, :ls_napcode, :li_portno, :ls_dateinstalled
				from aracctsubscriber
				where acctno = :as_acctno
				and divisioncode = :as_divisioncode
				and companycode = :as_companycode
				using SQLCA;
				
				if ls_reference_code = '' or isnull(ls_reference_code) then
					return 0
				end if
				
				
				select acctno, subscriberstatuscode into :ls_fullacctno, :ls_subscriberstatuscode
				from vw_fullacctno
				where ibas_Acctno = :as_Acctno
				and divisioncode = :as_divisioncode
				and companycode = :as_companycode
				using SQLCA;
				
				select jono into :ls_jono
				from Jotranhdr
				where trantypecode = 'APPLYML'
				AND divisioncode = :as_divisioncode
				and companycode = :as_companycode
				and acctno = :as_acctno
				and rownum< 2
				using SQLCA;
				
				if ls_subscriberstatuscode <> 'APL' then
					return 0
				end if
				
				string ls_updatestatustype
				string ls_date_today
				
				select to_char(sysdate,'MM/DD/YYYY') into :ls_date_today from dual using SQLCA;
				
				select sum(balance) into :ld_balance_rip 
				from artranhdr
				where acctno = :as_acctno
				and divisioncode = :as_divisioncode
				and companycode = :as_companycode
				using SQLCA;
				
				if isnull(ld_balance_rip) then ld_balance_rip = 0.00
				
				select sum(balance) into :ld_balance_sip 
				from subsinitialpayment
				where acctno = :as_acctno
				and divisioncode = :as_divisioncode
				and companycode = :as_companycode
				using SQLCA;
				
				if isnull(ld_balance_sip)  then ld_balance_sip = 0.00
				
				decimal{2} ld_total_balance
				string ls_reftranno, ls_trantypecode
				
				ld_total_balance = ld_balance_rip + ld_balance_sip
				
				if as_triggered_by = 'From Payment' or as_triggered_by  = 'From Prepare Job Order' then
					li_trigger_type = 7
					ls_updatestatustype = 'FOR SCHEDULE OF INSTALLATION'
					ls_remarks = 'JOBORDER NO. ' + ls_jono
					ls_reftranno = ls_jono
					ls_trantypecode = 'APPLYML'
				elseif as_triggered_by = 'On Going Installation' then
					li_trigger_type = 8
				elseif as_triggered_by = 'On Hold' then
					li_trigger_type = 12
				elseif as_triggered_by = 'Cancelled' then
					li_trigger_type = 13
					ls_updatestatustype = 'CANCELLED'
					ls_remarks = 'DATE CANCELLED: '+ ls_date_today + ' ' + as_trigger_remarks
					ls_reftranno = ls_jono
					ls_trantypecode = 'CANCELJO'
				elseif as_triggered_by = 'Active' then
					li_trigger_type = 9
					ls_updatestatustype = 'ACTIVE'
					ls_reftranno = ls_jono
					ls_trantypecode = 'JOCLOSING'
					ls_remarks = 'DATE INSTALLED: '+ ls_dateinstalled
				elseif as_triggered_by = 'Insufficient Payment' then
					ls_updatestatustype = 'PAYMENT INSUFFICIENT'
					
					ll_pos_1 = pos(as_trigger_remarks,':')
					ll_pos_2 = pos(as_trigger_remarks,'ORDATE')
					
					ls_or_number = mid(as_trigger_remarks, ll_pos_1+1, 8)
				
					ls_reftranno = ls_or_number
					ls_trantypecode = 'COLLECTION'
					ls_remarks = as_trigger_remarks + ' Please settle remaining: P' + string(ld_total_balance)
				end if
				
				
				if POS(ls_reference_code,'SMA-') > 0 and as_triggered_by <> 'Active' then
				
				end if
				
				
				insert into UPDATEAPPSTATUSSSP
				(reference_no,
				 trigger_type,
				 acct_no,
				 nap_code,
				 port_no,
				 remarks,
				 job_order_no,
				 activation_date,
				 created_at,
				 processed,
				 trigger_remarks)
				 values
				 (:ls_reference_code,
				  :li_trigger_type,
				  :ls_fullacctno,
				  :ls_napcode,
				  :li_portno,
				  :as_triggered_by,
				  :ls_jono,
				  null,
				  sysdate,
				  'N',
				  :as_trigger_remarks)
				  USING SQLCA;
				  
				  COMMIT USING SQLCA;
				 
				 
				 RETURN 0
		
		--END VALIDASI UPDATE_SSP_STATUS
		
	end if 
	
	return 0

--END VALIDASI autocreatejo



string ls_jono_iptv
long ll_ctr_hb_package
long ll_seq
string is_seq_no, ls_packagecode, ls_ext_packagecode

ls_packageCode	= trim(idw_InstallInfo.getItemString(1, "packageCode"))

ll_ctr_hb_package = 0

select count(*), bundle_packagecode  into :ll_ctr_hb_package, :ls_ext_packagecode
from hard_bundle_packages
where mainline_packagecode = :ls_packagecode
group by bundle_packagecode
using SQLCA;


long ll_Ctr_hb_packages
string selected

IF ll_ctr_hb_package > 0 THEN

	select REPLACE('J'||to_Char(AUTO_JO_HB_SEQ.nextval,'0000000'),' ','') into :is_seq_no from dual using SQLCA;
	
	for ll_Ctr_hb_packages = 1 to idw_hardbundle_packages.rowcount()
		selected =  idw_hardbundle_packages.getItemString(ll_Ctr_hb_packages,'selected')
		if selected = 'Y' THEN
			ls_ext_packagecode = idw_hardbundle_packages.getItemString(ll_Ctr_hb_packages,'BUNDLE_PACKAGECODE')
		END IF 
	next
	
	If trigger event ue_saveapplofexttranhdrdtl(ls_acctno, ls_ext_packagecode, is_seq_no) = -1 then
		return -1
	end IF
	
	--VALIDASI UE_SAVEAPPLOFEXTTRANSHDRDTL
		string 		ls_acctNo, ls_userAdd, ls_packageCode
		long 		ll_noOfExtension
		string 		ls_specialinstructions, ls_referenceJONo
		datetime	ldt_preferreddatetimefrom, ldt_preferreddatetimeto						
		datetime 	ldt_dateadd 
		long 		ll_row
	
		--get subscriber information
		idt_tranDate 					= guo_func.get_server_date()
		ls_acctNo 						= trim(as_acctno)
		ll_noOfExtension				= 1
		ls_specialinstructions			= "Auto Create via Mainline Application"
		ldt_preferreddatetimefrom	= guo_func.get_server_date()
		ldt_preferreddatetimeto		= guo_func.get_server_date()
		
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
				:as_tranno,
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
				0.00,
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
		string ls_acquisitionTypeCode
		dec{2} ld_rate, ld_amount
		
		ll_rows = 1
		
		for ll_loop = 1 to ll_rows
				
			ls_acquisitionTypeCode 	= 'RND'
			ll_applOfExtTranDtl_qty 	= 1
			ld_rate 						= 0.00
			ld_amount 					=  0.00
			ls_packageCode			= as_packagecode
			
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
					(:as_tranno,
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
		
		
		return 0

	
	--END VALIDASI UE_SAVEAPPLOFEXTTRANSHDRDTL
	
	if luo_subscriber.autocreatejo_IPTV(is_seq_no, ls_jono_iptv) < 0 then
		is_msgNo    = 'SM-0000001'
		is_msgTrail = luo_subscriber.lastSQLCode + '~r~n' + luo_subscriber.lastSQLErrText
		return -1
	end if 
	
	--VALIDASI autocreatejo_IPTV
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
			
		--END VALIDASI
	
		ls_joNo 			= string(ll_joNo, "00000000")
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
		end IF
		
		--VALIDASI UF_SET_REFERENCEjONO
		if as_trantypecode = 'APPLYML' then
					update arAcctSubscriber
						set referenceJONo = :as_jono
					 where tranNo = :as_tranno
					 and divisionCode = :gs_divisionCode
					and companyCode = :gs_companyCode
					using SQLCA;
				elseif as_trantypecode = 'CONVD2F' then
					update conversiondoctofibtran
						set referenceJONo = :as_jono
					 where tranNo = :as_tranno
					 and divisionCode = :gs_divisionCode
					and companyCode = :gs_companyCode
					using SQLCA;
				elseif as_trantypecode = 'CONVD2DF' then
					update CONVERSIONDSLTODOCFIBTRAN
						set referenceJONo = :as_jono
					 where tranNo = :as_tranno
					 and divisionCode = :gs_divisionCode
					and companyCode = :gs_companyCode
					using SQLCA;
				elseif as_trantypecode = 'APPLYEXT' then
					update applOfExtTranHdr
						set referenceJONo = :as_jono
					 where tranNo = :as_tranno
					 and divisionCode = :gs_divisionCode
					and companyCode = :gs_companyCode
					using SQLCA;
				elseif as_trantypecode = 'APPLEXTHO' then
					update applOfExtHotelTranHdr
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
				elseif as_trantypecode = 'APPLYTRANSFR' then
					update applOfTransferTranHdr
						set referenceJONo = :as_jono
					 where tranNo = :as_tranno
					 and divisionCode = :gs_divisionCode
					and companyCode = :gs_companyCode
					using SQLCA;
				elseif as_trantypecode = 'APPLYXTDSRVC' then
					update applExtendedServicesTranHdr
						set referenceJONo = :as_jono
					 where tranNo = :as_tranno
					 and divisionCode = :gs_divisionCode
					and companyCode = :gs_companyCode
					using SQLCA;
				elseif as_trantypecode = 'PULLOUTADS' then
					update adsTranHdr
						set referenceJONo = :as_jono
					 where tranNo = :as_tranno
					 and divisionCode = :gs_divisionCode
					and companyCode = :gs_companyCode
					using SQLCA;
				elseif as_trantypecode = 'APPLEXTD' then
					update applOfExtDiscTranHdr
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
				elseif as_trantypecode = 'APPLMLEXTREA' then
					update applOfReactivationTranHdr
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
				elseif as_trantypecode = 'REPANADIGI' then
					update AppOfDigitalConversionTranHdr
						set referenceJONo = :as_jono
					 where tranNo = :as_tranno
					 and divisionCode = :gs_divisionCode
					and companyCode = :gs_companyCode
					using SQLCA;
				elseif as_trantypecode = 'SERVMGMT' then
					update serviceCallMaster
						set referenceJONo = :as_jono
					 where tranNo = :as_tranno
					 and divisionCode = :gs_divisionCode
					and companyCode = :gs_companyCode
					using SQLCA;	
				elseif as_trantypecode = 'ADDFIBERTV' then
					update APPLOFVASTRANHDR
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
				
		--END VALIDASI UF_SET_REFERENCEjONO
		
		if not guo_func.set_number("JO", ll_joNo) then
			return -1
		end IF
		
		--VALIDASI SET LAST NUMBER
		
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
		
		--END SET LAST NUMBER
		
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

	--END VALIDASI autocreatejo_IPTV
	
	
	if trigger event ue_salesaddontranhdr(ls_acctno, 1, ls_ext_packagecode, ls_jono_iptv) = -1 then
	  	return -1
	end if 
	
	--VALIDASI UE_SALESADDONTRANHDR
	
	
			long ll_tranno
			SELECT sales_seq.nextval into :ll_tranno from dual using SQLCA;
			
			string ls_tranno
			ls_tranno		=	'AO'+string(ll_tranNo, '000000')
			
			long li_addon_id
			string ls_packagecode, ls_itemcode, ls_install_type
			
			decimal ld_total_amount, ld_outright_price, ld_staggered_price ,ld_delivery_fee, ld_setup_fee , ld_total_delivery_fee
			decimal ld_total_setup_fee
			
			ld_total_amount = 0.00
			ld_total_delivery_fee = 0.00
			ld_total_setup_fee = 0.00
			
			INT i
			
			string ls_mop , ls_mode_of_delivery
			
			
				ls_packagecode = as_packagecode
				
			
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
				
				ls_mop = 'outright'
				ls_mode_of_delivery = 'delivery only'
				ls_mop = 'staggered'
				
				if ls_mop = 'O' then
					ld_total_amount = ld_total_amount + ld_outright_price
					ls_mop = 'outright'
				end if
				
				ld_total_delivery_fee = ld_total_delivery_fee + ld_delivery_fee
				
				ls_mode_of_delivery = 'delivery only'
				
				if ls_install_type = 'INSTALL' then
					ld_total_setup_fee = ld_total_setup_fee + ld_setup_fee + ld_delivery_fee
					ls_mode_of_delivery = 'deliver and install'
				end if
					
				
				INSERT INTO SOLD_ADD_ON_ITEMS
				(TRANNO,acctno, ITEMCODE, SERIALNO, DIVISIONCODE, COMPANYCODE, USERADD, DATEADD, JONO, ISIPTV, USED, addon_id, mop, mode_of_delivery )
				VALUES
				(:ls_tranno, :as_acctno,:ls_itemCode, '', :gs_divisioncode, :Gs_companycode, :gs_username, sysdate, :as_jono, 'Y', 'N', :li_addon_id, :ls_mop, :ls_mode_of_delivery)
				using SQLCA;
				
			next
			
			//is_tranNo 		= string(ll_tranNo, '00000000')
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
							'O',
							NULL,
							'DELIVERY',
							'DIY',
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

	
	--END VALIDASI UE_SALESADDONTRANHDR
			
END IF
return 0

--END
