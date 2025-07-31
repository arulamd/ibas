--PARAMETER BEFORE OPEN THE MENU , AND WILL CARRY OUT TO MENU

lstr_subsInfo.subsTypeCode = 'RE'
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
-----**** end ***--- //

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
	
	

//idw_InstallInfo.setItem(1,'isstaggered','O')

if gs_application = 'POS' then
	this.title = 'Mainline Application' + ' - ' + gs_company + ' - ' + gs_sourceDatabase + ' - ' + gs_uFullName
end if


--END

--QUERY FORM HEADER 
 
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
    
--VALIDASI KEY IN FORM HEADER

--QUERY FOR DROPDOWN SELECT ORIGIN
select installationRemarksGroupCode, installationRemarksGroupName
from installationremarksGroups 

--END

--QUERY FOR DRODOWN SELECT SUB ORIGIN INSTALATION
    
select a.installationRemarksGroupCode,b.installationRemarksGroupname,a.installationRemarksCode,a.installationRemarksName
from installationRemarksMaster a
inner join installationremarksGroups  b on b.installationRemarksGroupCode = a.installationRemarksGroupCode
where b.installationRemarksGroupCode = :as_installationRemarksGroupCode  

--END 


--QUERY SERVICE ADDRESS TAB
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

--EVENT BUTTON CLICK FROM SERVCE ADREES

if dwo.name = "b_barangay" then
	iw_parent.trigger dynamic event ue_search('barangaycode1')
elseif dwo.name = "b_subdivision" then
	iw_parent.trigger dynamic event ue_search('subdivision1')
elseif dwo.name = "b_municipality" then
	iw_parent.trigger dynamic event ue_search('municipalitycode1')
elseif dwo.name = "b_province" then
	iw_parent.trigger dynamic event ue_search('provincecode1')
elseif dwo.name = "b_copybilledto" then	
	copybilledto()
elseif dwo.name = "b_check_serviceability" then	
	checkserviceability()
end IF

--VALIDASI EVENT UE_SEARCH 

long ll_row, ll_success
string ls_search, ls_result, ls_requiresApproval, ls_chargeType, ls_errormsg, ls_validPackagetypeCode[]
string ls_barangayCode, ls_serviceBarangay, ls_municipalityCode, ls_packageDesc, ls_packageName, ls_packageType , ls_clientClassValue
int li_tab
string ls_chargetypecode

str_search str_s

ls_search = trim(as_search)
ll_row = dw_header.getrow()


choose case ls_search

	case "citizenshipcode"
		str_s.s_dataobject = "dw_search_citizenship_master"
		str_s.s_return_column = "citizenshipCode"
		str_s.s_title = "Search For Citizenship"
		
		--QUERY FOR SERACH CITIZENSHIPCODE
			SELECT  citizenshipname ,
	           citizenshipcode     
	        FROM citizenshipmaster    
        --END 
		
		openwithparm(w_search_ancestor,str_s)
		
		
		ls_result = trim(message.stringparm)
		
		if ls_result <> '' then			
			idw_genInfo.setitem(ll_row,'citizenshipcode', ls_result)		
		end if
		
	case "napcode"
		str_s.s_dataobject = "dw_search_napcode"
		str_s.s_return_column = "napcode"
		str_s.s_title = "Search For Napcode"
		
		--QUERY FOR SEARCH NAPCODE
			SELECT  old_napcode area , napcode
	        FROM r_napmaster
        --END
		
		openwithparm(w_search_ancestor,str_s)
		
		ls_result = trim(message.stringparm)
		
		if ls_result <> '' then			
			idw_InstallInfo.setitem(ll_row,'napcode', ls_result)	
			dataWindowChild dwc_portno
			idw_InstallInfo.getChild('portno',dwc_portno)
			dwc_portno.setTransObject(SQLCA);
			dwc_portno.retrieve(ls_result)
		end if
		
		


	case "subdivision1","subdivision2"
		str_s.s_dataobject = "dw_search_subdivision"
		str_s.s_return_column = "subdivisionCode"
		str_s.s_title = "Search For Subdivision"
		
		--QUERY FOR SEARCH SUBDIVISON2
			SELECT  subdivisionMaster.subdivisionName,
				subdivisionMaster.subdivisionCode
	        FROM subdivisionMaster
        --END 
		
		openwithparm(w_search_ancestor,str_s)		
		
		ls_result = trim(message.stringparm)
		
		if ls_result <> '' then			
			if ls_search = "subdivision1" then
				idw_servAdd.setitem(ll_row,'serviceSubdivisionCode', ls_result)		
			else
				idw_billAdd.setitem(ll_row,'billingSubdivisioncode', ls_result)			
			end if
		end if

	case "barangaycode1","barangaycode2"
		str_s.s_dataobject = "dw_search_barangay_master_w_arg"
		str_s.s_return_column = "barangayCode"
		str_s.s_title = "Search For Barangay"
		
		--QUERY FOR SEARCH BARANGAYCODE2
		
		SELECT  barangayname ,
           barangaycode     
		        FROM barangaymaster  
		WHERE municipalityCode   = :as_municipality
		
		--END 
		
		if tabform.SelectedTab = 2 then
			str_s.s_1 = idw_servAdd.getItemString(ll_row,'servicemunicipalitycode')
		else
			str_s.s_1 = idw_billAdd.getItemString(ll_row,'billingmunicipalitycode')
		end if
		if str_s.s_1 = '' or isNull(str_s.s_1) then
			guo_func.msgbox("ATTENTION","Required municipality, before selecting barangay..")
			return
		end if
		openwithparm(w_search_ancestor,str_s)
		ls_result = trim(message.stringparm)
		
		if ls_result <> '' then			
			if ls_search = "barangaycode1" then
				idw_servAdd.setitem(ll_row,'servicebarangaycode', ls_result)		
			else
				idw_billAdd.setitem(ll_row,'billingbarangaycode', ls_result)			
			end if
		end if
		
	case "municipalitycode1","municipalitycode2"
		str_s.s_dataobject = "dw_search_municipality_master_w_arg"
		str_s.s_return_column = "municipalityCode"
		str_s.s_title = "Search For Municipality"
		
		--QUERY FOR SEARCH MUNICIPALITUCODE2
		SELECT  municipalityname ,
		           municipalitycode     
		        FROM municipalitymaster    
		where   provinceCode = :as_provinceCode		
		--END

		if tabform.SelectedTab = 2 then
			str_s.s_1 = idw_servAdd.getItemString(ll_row,'serviceprovincecode')
		else
			str_s.s_1 = idw_billAdd.getItemString(ll_row,'billingprovincecode')
		end if
		if str_s.s_1 = '' or isNull(str_s.s_1) then
			guo_func.msgbox("ATTENTION","Required province, before selecting municipality..")
			return
		end if
		
		openwithparm(w_search_ancestor,str_s)
		ls_result = trim(message.stringparm)
		
		if ls_result <> '' then			
			if ls_search = "municipalitycode1" then
				idw_servAdd.setitem(ll_row,'servicemunicipalitycode', ls_result)	
				idw_servAdd.setItem(ll_row,'servicebarangaycode', 'N/A')
			else
				idw_billAdd.setitem(ll_row,'billingmunicipalitycode', ls_result)	
				idw_billAdd.setItem(ll_row,'billingbarangaycode', 'N/A')
			end if
		end if
		
	case "provincecode1","provincecode2"
		str_s.s_dataobject = "dw_search_province_master"
		str_s.s_return_column = "provinceCode"
		str_s.s_title = "Search For Province"
		
		--QUERY FOR SEACRH PROVINCECODE2
			SELECT  provincename ,
	           provincecode     
	        FROM provincemaster  
		--
		
		openwithparm(w_search_ancestor,str_s)
		ls_result = trim(message.stringparm)
		
		if ls_result <> '' then			
			if ls_search = "provincecode1" then
				idw_servAdd.setitem(ll_row,'serviceprovincecode', ls_result)
				idw_servAdd.setitem(ll_row,'servicemunicipalitycode', '')	
				idw_servAdd.setItem(ll_row,'servicebarangaycode', '')
			else
				idw_billAdd.setitem(ll_row,'billingprovincecode', ls_result)		
				idw_billAdd.setitem(ll_row,'billingmunicipalitycode', '')	
				idw_billAdd.setItem(ll_row,'billingbarangaycode', '')
			end if
		end if
		
	case "packagecode"
		
		str_s.s_dataobject = "dw_search_package_master"
		str_s.s_return_column = "packageCode"
		str_s.s_title = "Search For Package"
		
		--QUERY FOR SEARCH PACKAGE MASTER
		SELECT arPackageMaster.packagename ,
					 arPackageMaster.packagecode     
			  FROM arPackageMaster
			 WHERE ( arPackageMaster.isPrepaid = :as_isPrepaid ) and
					 (	arPackageMaster.isPPV =  'N' and arPackageMaster.isActive = 'Y')and
			       ( arPackageMaster.serviceType = :as_serviceType ) and (arPackageMaster.divisionCode = :as_division) and
				(arPackageMaster.isDigital = :as_isDigital) and
			( arPackageMaster.packageClassCode <>  'DPP' ) and
			( arPackageMaster.packageClassCode <>  'DGP' )
			
		-- END
		
		ls_chargeType = idw_InstallInfo.GetItemString(1, 'chargeTypecode')
		if isNull(ls_chargeType) then
			guo_func.msgBox("ATTENTION","Select Charge Type before selecting a package..")
			return
		elseif ls_chargeType = 'PPS' then
			str_s.s_1 = 'Y'
		else
			str_s.s_1 = 'N'
		end if
		str_s.s_3 = gs_divisionCode
		str_s.s_2 = is_serviceType
		
		if is_isdigital = 'I'  or is_isdigital = 'P' then
		
		str_s.s_dataobject = "dw_search_package_master_iptv"
		str_s.s_4 = 'N'
		
		--QUERY FOR TEKE TO str_s DATAOBHECT
		SELECT arPackageMaster.packagename ,
				 arPackageMaster.packagecode     
		  FROM arPackageMaster
		 WHERE  arPackageMaster.isActive = 'Y' and (arPackageMaster.divisionCode = :as_division) 
			and arpackagemaster.isiptvpackage = 'Y'
		--END 
		
		else
			
			str_s.s_4 = is_isdigital
			
		end if 
      
		openwithparm(w_search_ancestor,str_s)
		ls_result = trim(message.stringparm)
	
		if ls_result <> '' then	
			idw_InstallInfo.setitem(ll_row,'packagecode', ls_result)	
			ll_success = uf_prepare_required_initial_payment()
			
			--VALIDASI uf_prepare_required_initial_payment
			
				long ll_rows, ll_success
				string ls_subsTypeCode, ls_packageCode, ls_chargeTypeCode, ls_acquisitionTypeCode, ls_subsusertypecode 
				integer li_noOfRooms
				decimal ld_occupancyRate
				
				ls_subsusertypecode = idw_InstallInfo.getItemString( 1, "subsusertypecode" )
				ls_subsTypeCode = dw_header.getItemString( 1, "subsTypeCode" )
				ls_packageCode = idw_InstallInfo.getItemString( 1, "packageCode" )
				ls_chargeTypeCode = idw_InstallInfo.getItemString( 1, "chargeTypeCode" )
				ls_acquisitionTypeCode = idw_InstallInfo.getItemString( 1, "acquisitionTypeCode" )
				li_noOfRooms = idw_genInfo.GetItemNumber(1, 'numberOfRooms')
				ld_occupancyRate = idw_genInfo.GetItemDecimal(1, 'occupancyRate')
				
				ll_rows = idw_ReqInitPayment.rowCount()
				
				if not isnull(ls_subsTypeCode) then
					if not isnull(ls_packageCode) then
						if not isnull(ls_chargeTypeCode) then	
							if not isnull(ls_acquisitionTypeCode) then	
								if ll_rows > 0 then
									ll_success = uf_compute_req_init_payment_mline(	&
											ls_subsusertypecode, &  
											ls_subsTypeCode, &
											ls_packageCode, &
											ls_chargeTypeCode, &
											ls_acquisitionTypeCode, &
											idw_ReqInitPayment, &
											li_noOfRooms, &
											ld_occupancyRate, is_isstaggered )
											
									--VALIDASI uf_compute_req_init_payment_mline
									
									decimal{2} ld_mLineInstallFee, ld_stbDepReqPerBox, ld_stbPricePerBox
									
									ld_mLineInstallFee = 0.00
									ld_stbDepReqPerBox = 0.00
									ld_stbPricePerBox = 0.00	
											
									SELECT 	mLineInstallFee, stbPricePerBox, stbDepReqPerBox
									INTO 		:ld_mLineInstallFee, :ld_stbPricePerBox , :ld_stbDepReqPerBox 
									FROM 		arPackageMaster
									WHERE 	packageCode = :as_packageCode
									and divisionCode = :gs_divisionCode
									and companyCode = :gs_companyCode
									USING SQLCA;			
									If SQLCA.SQLcode = -1 then
										messagebox('SM-0000001',"select in subcriberTypeMaster SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText)
										return -1
									end if
											
									if isnull(ld_mLineInstallFee) then ld_mLineInstallFee = 0.00
									if isnull(ld_stbDepReqPerBox) then ld_stbDepReqPerBox = 0.00
									if isnull(ld_stbPricePerBox) then ld_stbPricePerBox = 0.00	  
									
									//packageCode based fees
									decimal{2} ld_mainLineMonthlyRate, ld_noOfMonthsDepReq, ld_noOfMonthsAdvDepReq
									decimal{2} ld_subscriptionDepReq, ld_subscriptionAdvDepReq, ld_materialsInitialPaymentReq
									decimal{2} ld_mlineInstallFeePartial
									
									ld_mainLineMonthlyRate = 0.00
									ld_noOfMonthsDepReq = 0.00
									ld_noOfMonthsAdvDepReq = 0.00
									ld_subscriptionDepReq = 0.00
									ld_subscriptionAdvDepReq = 0.00
									ld_materialsInitialPaymentReq = 0.00
									
									SELECT 	monthlyRate, noOfMonthsDepReq, noOfMonthsAdvDepReq,  
												subscriptionDepReq, subscriptionAdvDepReq, materialsInitialPaymentReq,
												mlineInstallFee_partial
									INTO 		:ld_mainLineMonthlyRate, :ld_noOfMonthsDepReq, :ld_noOfMonthsAdvDepReq,  
												:ld_subscriptionDepReq, :ld_subscriptionAdvDepReq, :ld_materialsInitialPaymentReq,
												:ld_mlineInstallFeePartial
									FROM 		arPackageMaster
									WHERE 	packageCode = :as_packageCode
									and divisionCode = :gs_divisionCode
									and companyCode = :gs_companyCode
									USING 	SQLCA;			
									If SQLCA.SQLcode = -1 then
										messagebox('SM-0000001',"select in arPackageMaster SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText)
										return -1
									end if
									
									--acquisitionTypeCode based fees
									long ll_row
									decimal{2} ld_amount_OCDEQ, ld_amount_OCDEP, ld_amount_OCADV, ld_amount_SALES, ld_amount_INSTF
									
									ld_amount_OCDEQ = 0.00
									ld_amount_OCDEP = 0.00 
									ld_amount_OCADV = 0.00
									ld_amount_SALES = 0.00 
									ld_amount_INSTF = 0.00
									
									if isnull(ld_mainLineMonthlyRate) then ld_mainLineMonthlyRate = 0.00
									if isnull(ld_noOfMonthsDepReq) then ld_noOfMonthsDepReq = 0.00
									if isnull(ld_noOfMonthsAdvDepReq) then ld_noOfMonthsAdvDepReq = 0.00
									if isnull(ld_subscriptionDepReq) then ld_subscriptionDepReq = 0.00
									if isnull(ld_subscriptionAdvDepReq) then ld_subscriptionAdvDepReq = 0.00
									if isnull(ld_materialsInitialPaymentReq) then ld_materialsInitialPaymentReq = 0.00
									
									
														
									if as_subsTypeCode <> 'HO' then
									--ld_amount_OCDEP = ld_mainLineMonthlyRate * ld_noOfMonthsDepReq  // mLineMo rate * no of mos dep req
									--removed by vince 11-03-2015
										ld_amount_OCDEP = ld_subscriptionDepReq  //new code
									
									else
										ld_amount_OCDEP = ld_subscriptionDepReq * ld_noOfMonthsDepReq  // mLineMo rate * no of mos dep req
									
									end if
									
									--additional nalang -zar 09162010
									if as_subsUserTypeCode = 'HOTEL' then
										ld_amount_OCDEP = ( ld_mainLineMonthlyRate * ld_noOfMonthsDepReq) * ai_noofrooms
									end if	
									
									
									ld_amount_OCADV = ld_mainLineMonthlyRate * ld_noOfMonthsAdvDepReq  // mLineMo rate * no of mos adv req
									
									ld_amount_SALES = ld_materialsInitialPaymentReq // materials initial payment requirement
									
									if as_subsTypeCode <> 'HO' then
										ld_amount_INSTF = ld_mLineInstallFee // installation fees
									else
										ld_amount_INSTF = 0
									end if
									
									--additional nalang -zar 09162010
									if as_subsUserTypeCode = 'HOTEL' then
										ld_amount_INSTF = ld_mLineInstallFee * ai_noOfRooms
									end if	
									
									if as_acquisitionTypeCode = "BUY" then // BUY STB
									
										ld_amount_OCDEQ = 0.00  // since subscriber will buy the STB, 
																		// no equipment deposit is required
									
										if as_substypecode <> 'PP' and as_substypecode <> 'P1' then
											ld_amount_SALES = ld_amount_SALES + ( ld_stbPricePerBox * 1 )  // ADD stb price for purchase of STB										
										end if		
											
									elseif as_acquisitionTypeCode = "RND" then // RENT STB NO DEPOSIT
										
									elseif as_acquisitionTypeCode = "RWD" then // RENT STB WITH DEPOSIT						
									
										if as_subsTypeCode <> 'HO' then
											ld_amount_OCDEQ = ld_stbDepReqPerBox * 1  // STB since this is just mainline																// since subscriber will rent with deposit the STB, 																
											--equipment deposit is required	
										end if	
									
										--additional nalang -zar 09162010
										if as_subsUserTypeCode = 'HOTEL' then
											ld_amount_OCDEQ = ld_stbDepReqPerBox * ai_noofrooms																		
										end if	
										
									end if
									
									/* -zar 09162010
									if as_subsTypeCode = 'HO' then
										ld_amount_OCDEP = ld_amount_OCDEP * (ai_noOfRooms * (ad_occupancyRate / 100))
										ld_amount_OCADV = ld_amount_OCADV * (ai_noOfRooms * (ad_occupancyRate / 100))
										ld_amount_OCDEQ = ld_amount_OCDEQ * (ai_noOfRooms * (ad_occupancyRate / 100))
									end if
									*/
									
									--chargeType based fees (discounts)
									
									--OCDEP - Subscription Deposit
									decimal{2} ld_percentDiscount, ld_amountDiscount
									ld_percentDiscount = 0.00 
									ld_amountDiscount = 0.00
									
									SELECT 	percentDiscount
									INTO 		:ld_percentDiscount
									FROM 		chargeTypeDiscountMaster
									WHERE 	chargeTypeCode = :as_chargeTypeCode and arTypeCode = 'OCDEP'
									and divisionCode = :gs_divisionCode
									and companyCode = :gs_companyCode
									USING SQLCA;			
									If SQLCA.SQLcode = -1 then
										messagebox('SM-0000001',"select in chargeTypeMaster SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText)
										return -1
									end if
									
									if isnull(ld_percentDiscount) then ld_percentDiscount = 0.00 
									if ld_percentDiscount > 0.00 then
										ld_amountDiscount = ( ld_amount_OCDEP * (ld_percentDiscount/100) )
										ld_amount_OCDEP = ld_amount_OCDEP - ld_amountDiscount
										if ld_amount_OCDEP < 0.00 then 
											ld_amount_OCDEP = 0.00
										end if
									end if
									
									--OCDEQ - Equipment Deposit
									ld_percentDiscount = 0.00 
									ld_amountDiscount = 0.00
									
									SELECT 	percentDiscount
									INTO 		:ld_percentDiscount
									FROM 		chargeTypeDiscountMaster
									WHERE 	chargeTypeCode = :as_chargeTypeCode and arTypeCode = 'OCDEQ'
									and divisionCode = :gs_divisionCode
									and companyCode = :gs_companyCode
									USING SQLCA;			
									If SQLCA.SQLcode = -1 then
										messagebox('SM-0000001',"select in chargeTypeMaster SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText)
										return -1
									end if
									
									if isnull(ld_percentDiscount) then ld_percentDiscount = 0.00 
									if ld_percentDiscount > 0.00 then
										ld_amountDiscount = ( ld_amount_OCDEQ * (ld_percentDiscount/100) )
										ld_amount_OCDEQ = ld_amount_OCDEQ - ld_amountDiscount
										if ld_amount_OCDEQ < 0.00 then 
											ld_amount_OCDEQ = 0.00
										end if
									end if
									
									--OCADV - Subscription Advances
									ld_percentDiscount = 0.00 
									ld_amountDiscount = 0.00
									
									SELECT 	percentDiscount
									INTO 		:ld_percentDiscount
									FROM 		chargeTypeDiscountMaster
									WHERE 	chargeTypeCode = :as_chargeTypeCode and arTypeCode = 'OCADV'
									and divisionCode = :gs_divisionCode
									and companyCode = :gs_companyCode
									USING SQLCA;			
									If SQLCA.SQLcode = -1 then
										messagebox('SM-0000001',"select in chargeTypeMaster SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText)
										return -1
									end if
									
									if isnull(ld_percentDiscount) then ld_percentDiscount = 0.00 
									if ld_percentDiscount > 0.00 then
										ld_amountDiscount = ( ld_amount_OCADV * (ld_percentDiscount/100) )
										ld_amount_OCADV = ld_amount_OCADV - ld_amountDiscount
										if ld_amount_OCADV < 0.00 then 
											ld_amount_OCADV = 0.00
										end if
									end if
									
									// SALES - Materials Required Initial Payment
									ld_percentDiscount = 0.00 
									ld_amountDiscount = 0.00
									
									SELECT 	percentDiscount
									INTO 		:ld_percentDiscount
									FROM 		chargeTypeDiscountMaster
									WHERE 	chargeTypeCode = :as_chargeTypeCode and arTypeCode = 'SALES'
									and divisionCode = :gs_divisionCode
									and companyCode = :gs_companyCode
									USING SQLCA;			
									If SQLCA.SQLcode = -1 then
										messagebox('SM-0000001',"select in chargeTypeMaster SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText)
										return -1
									end if
									
									if isnull(ld_percentDiscount) then ld_percentDiscount = 0.00 
									if ld_percentDiscount > 0.00 then
										ld_amountDiscount = ( ld_amount_SALES * (ld_percentDiscount/100) )
										ld_amount_SALES = ld_amount_SALES - ld_amountDiscount
										if ld_amount_SALES < 0.00 then 
											ld_amount_SALES = 0.00
										end if
									end if
									
									// INSTF - Installation Fees Required Initial Payment
									ld_percentDiscount = 0.00 
									ld_amountDiscount = 0.00
									
									SELECT 	percentDiscount
									INTO 		:ld_percentDiscount
									FROM 		chargeTypeDiscountMaster
									WHERE 	chargeTypeCode = :as_chargeTypeCode and arTypeCode = 'INSTF'
									and divisionCode = :gs_divisionCode
									and companyCode = :gs_companyCode
									USING SQLCA;			
									If SQLCA.SQLcode = -1 then
										messagebox('SM-0000001',"select in chargeTypeMaster SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText)
										return -1
									end if
									
									if isnull(ld_percentDiscount) then ld_percentDiscount = 0.00 
									if ld_percentDiscount > 0.00 then
										ld_amountDiscount = ( ld_amount_INSTF * (ld_percentDiscount/100) )
										ld_amount_INSTF = ld_amount_INSTF - ld_amountDiscount
										if ld_amount_INSTF < 0.00 then 
											ld_amount_INSTF = 0.00
										end if
									end if
									
									
									// update datawindow for required initial payment
									ll_row = adw_ReqInitPayment.find("arTypeCode='OCDEP'",1,adw_ReqInitPayment.rowCount())		
									adw_ReqInitPayment.scrollToRow( ll_row )		
									if ll_row > 0 then
										adw_ReqInitPayment.setItem( ll_row, "amount", ld_amount_OCDEP )
									end if	
									
									ll_row = adw_ReqInitPayment.find("arTypeCode='OCDEQ'",1,adw_ReqInitPayment.rowCount())		
									adw_ReqInitPayment.scrollToRow( ll_row )				
									if ll_row > 0 then
										adw_ReqInitPayment.setItem( ll_row, "amount", ld_amount_OCDEQ )
									end if
									
									ll_row = adw_ReqInitPayment.find("arTypeCode='OCADV'",1,adw_ReqInitPayment.rowCount())		
									adw_ReqInitPayment.scrollToRow( ll_row )				
									if ll_row > 0 then
										adw_ReqInitPayment.setItem( ll_row, "amount", ld_amount_OCADV )
									end if		
									
									ll_row = adw_ReqInitPayment.find("arTypeCode='SALES'",1,adw_ReqInitPayment.rowCount())		
									adw_ReqInitPayment.scrollToRow( ll_row )				
									if ll_row > 0 then
										adw_ReqInitPayment.setItem( ll_row, "amount", ld_amount_SALES )
									end if
									
									if as_isstaggered = 'S' then ld_amount_INSTF = 0.00
									
									IF as_isstaggered = "S" AND &
									   (as_packageCode = "BDA01" OR as_packageCode = "BDA02" OR as_packageCode = "BDA03") THEN
									    ld_amount_INSTF = ld_mlineInstallFeePartial
									END IF
									
									ll_row = adw_ReqInitPayment.find("arTypeCode='INSTF'",1,adw_ReqInitPayment.rowCount())		
									adw_ReqInitPayment.scrollToRow( ll_row )						
									if ll_row > 0 then
										adw_ReqInitPayment.setItem( ll_row, "amount", ld_amount_INSTF )
									end if		
									
									adw_ReqInitPayment.acceptText()
									
									
									return 0


									--END VALIDASI		
								end if
							end if
						end if
					end if
				end if
									
				
				
				return 0
			--END VALIDASI
			
			select packageTypeCode, packageName, packageDescription , clientClassValue
			into :ls_packageType, :ls_packagename, :ls_packageDesc , :ls_clientClassValue
			from arPackageMaster
			where packageCode = :ls_result
			and divisionCode = :gs_divisionCode
			and companyCode = :gs_companyCode
			using SQLCA;

				
			idw_InstallInfo.setItem(idw_InstallInfo.getrow(),'packagename',ls_packagename )
			idw_InstallInfo.setItem(idw_InstallInfo.getrow(),'packagedesc',ls_packageDesc)	
				
			if is_serviceType = 'INET' then
				int li_loop
				string ls_userName, ls_password,ls_divisionPrefix
				string ls_userNamePrefix, ls_acctNo
				
				
				long ll_ctr_hb_package
				
				ll_ctr_hb_package = 0
				
				string ls_serviceBarangayCode, ls_serviceMunicipalityCode, ls_serviceProvinceCode
				string ls_municipalityname , ls_provincename , ls_all_hb
				
				
				
				ls_serviceBarangayCode						= trim(idw_servAdd.getItemString(ll_row, "serviceBarangayCode"))	
				ls_serviceMunicipalityCode					= trim(idw_servAdd.getItemString(ll_row, "serviceMunicipalityCode"))	
				ls_serviceProvinceCode						= trim(idw_servAdd.getItemString(ll_row, "serviceProvinceCode"))	
				
				
				select provincename into :ls_provincename
				from provincemaster 
				where provincecode = :ls_serviceProvinceCode
				using SQLCA;
				
				select municipalityname into :ls_municipalityname
				from municipalitymaster
				where municipalitycode = :ls_serviceMunicipalityCode
				using SQLCA;
				
				
				
				long ll_ctr_pa_area
				
				ls_all_hb = 'N'
				
				select count(*) into :ll_ctr_pa_area
				from iptv_area_mapping
				where municipalityname = :ls_municipalityname
				and provincename = :ls_provincename
				using SQLCA;
				
				if ll_ctr_pa_area > 0 then
					ls_all_hb = 'Y'
				end if
				
				if ll_ctr_pa_area > 0 or  Pos(ls_provincename,'MANILA') > 0 then
					ls_all_hb = 'Y'
				end if
								
				select count(*) into :ll_ctr_hb_package
				from HARD_BUNDLE_PACKAGES_CHOICES
				WHERE MAINLINE_PACKAGECODE = :ls_result
				using SQLCA;
				
				if ll_ctr_hb_package > 0 then
					idw_hardbundle_packages.visible = true
					idw_hardbundle_packages.retrieve(gs_divisioncode,ls_result,ls_all_hb )
					idw_hardbundle_packages.accepttext()
					idw_hardbundle_packages.setItem(1,'selected','Y')
				else
					idw_hardbundle_packages.visible = false
				end if 
				
				if isNull(ls_clientClassValue) then
					guo_func.msgbox("ATTENTION","The package you've selected has no CLIENTCLASSVALUE. Therefore it must be relayed to Marketing / SysAd Department.")
					return
				end if
				
				ls_acctNo = dw_header.getItemString(1,'acctno')
				
				select userNamePrefix, divisionprefix 
				into :ls_userNamePrefix,:ls_divisionPrefix 
				from systemParameter 
				where divisionCode = :gs_divisionCode
				and companyCode = :gs_companyCode
				using SQLCA;

				if trim(ls_userNamePrefix) = "" then 
					guo_func.msgbox("ATTENTION","Please set {USER NAME PREFIX in SYSTEM PARAMETER} ")
					return 	
				end if	
				if isnull(ls_userNamePrefix) then  
					guo_func.msgbox("ATTENTION","Please set {USER NAME PREFIX in SYSTEM PARAMETER} ")
					return		
				end if
				
				uf_getAllowedPackagetypeCode('WLSRADIUS', ls_validPackagetypeCode) 
				idw_InstallInfo.object.specialinstructions.width = 2674
				for li_loop = 1 to upperBound(ls_validPackagetypeCode)
					if ls_packageType = ls_validPackagetypeCode[li_loop] then
						idw_InstallInfo.object.specialinstructions.width = 1381
						idw_InstallInfo.object.subsusername.tabsequence = 81
						idw_InstallInfo.object.password.tabsequence = 82
						idw_InstallInfo.object.confirmed.tabsequence = 83
						exit
					end if
				next
				
				if uf_isAllowedInOneWirelessRadius(ls_packageType) then
					idw_InstallInfo.object.specialinstructions.width = 1381
					ls_userName = trim(ls_userNamePrefix) + trim(ls_acctNo)
					ls_password = ls_userName
					idw_InstallInfo.setItem(idw_InstallInfo.getrow(),'subsUserName',ls_userName )
					idw_InstallInfo.setItem(idw_InstallInfo.getrow(),'password',ls_password )
					idw_InstallInfo.setItem(idw_InstallInfo.getrow(),'confirmed',ls_password )
					
					idw_InstallInfo.object.subsusername.tabsequence = 0
					idw_InstallInfo.object.password.tabsequence = 0
					idw_InstallInfo.object.confirmed.tabsequence = 0
					
				end if	
				
				if uf_isAllowedInFITRadius(ls_packageType) then
					
					ib_fitPackage = true
					
					select itemValue, itemDescription
					into :ls_userNamePrefix, :ls_password
					from sysParamString
					where itemName = 'FITUSERPREFIX'
					and divisionCode = :gs_divisionCode
					and companyCode = :gs_companyCode
					using SQLCA;
					
					idw_InstallInfo.object.specialinstructions.width = 1381
					ls_userName = trim(ls_userNamePrefix) + trim(ls_divisionPrefix) + trim(ls_acctNo)
					idw_InstallInfo.setItem(idw_InstallInfo.getrow(),'subsUserName',ls_userName )
					idw_InstallInfo.setItem(idw_InstallInfo.getrow(),'password',ls_password )
					idw_InstallInfo.setItem(idw_InstallInfo.getrow(),'confirmed',ls_password )
					
					idw_InstallInfo.object.subsusername.tabsequence = 0
					idw_InstallInfo.object.password.tabsequence = 82
					idw_InstallInfo.object.confirmed.tabsequence = 83
					
				end if	
			end if
		end if
		
end choose
return 

--END VALIDASI EVENT UE_SEARCH 

--TAB BILLING ADDRESS

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


--EVENT BUTTON CLICK 
if dwo.name = "b_copybilledto" then
	copybilledto()
	
elseif dwo.name = "b_serviceaddress" then	
	copyserviceaddessinfo()
elseif dwo.name = "b_subdivision" then
	iw_parent.trigger dynamic event ue_search('subdivision2')
elseif dwo.name = "b_barangay" then
	iw_parent.trigger dynamic event ue_search('barangaycode2')
elseif dwo.name = "b_municipality" then
	iw_parent.trigger dynamic event ue_search('municipalitycode2')
elseif dwo.name = "b_province" then
	iw_parent.trigger dynamic event ue_search('provincecode2')
end if
--END 
--INFO UE_SEARCH SAME WITH TAB BEFORE

--TAB INSTALLATION INFORMATION

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
    
    
--QUERY BUNDLE PACKAGE NAME
SELECT a.bundle_packagecode, b.packagename , '' selected  FROM HARD_BUNDLE_PACKAGES_CHOICES A
INNER JOIN ARPACKAGEMASTER B ON B.PACKAGECODE = A.bundle_PACKAGECODE
where b.divisioncode = :as_divisioncode and A.MAINLINE_PACKAGECODE = :as_packagecode
and (pa_area_enabled = 'N' or :as_all_hb_package = 'Y')
--END 

--EVENT ITEMCHANGE FOR BUNDLE PACKAGE
decimal{2} ld_mrc
long ll_rc
string ls_packagecode


if dwo.name = 'selected' then
	if data = 'Y' then
		for ll_rc = 1 to this.rowcount()
			if this.getRow() = ll_rc then
				this.setItem(ll_rc,'selected','Y')
			else
				this.setItem(ll_rc,'selected','N')
			end if
		next
	end if
	
	ls_packagecode = this.getItemString(this.getRow(), 'BUNDLE_PACKAGECODE')
	
	select monthlyrate into :ld_mrc
	from arpackagemaster
	where packagecode = :ls_packagecode
	and divisioncode = :gs_divisioncode
	using SQLCA;
	
	this.object.t_additional_mrc.text = 'PHP ' + string(ld_mrc)

end IF

--END

--QUERY ADDITIONAL MRC
  SELECT  subsinitialpayment.acctno ,
  subsinitialpayment.trantypecode , 
  subsinitialpayment.artypecode ,  
  subsinitialpayment.tranno ,   
  subsinitialpayment.trandate , 
  subsinitialpayment.priority ,   
  subsinitialpayment.amount 
  FROM subsinitialpayment  
--END 

    
 --EVENT  BUTTON SEARCH SEARCH
    if dwo.name = "b_packagecode" then
	iw_parent.trigger dynamic event ue_search('packagecode')
elseif dwo.name = "b_chargetypecode" then
	iw_parent.trigger dynamic event ue_search('chargeTypecode')
elseif dwo.name = "b_subsusertypecode" then
	iw_parent.trigger dynamic event ue_search('subsusertypecode')
elseif dwo.name = "b_napcode" then
	iw_parent.trigger dynamic event ue_search('napcode')
end IF

--VALUE SAME TAB BEFORE


--TAB CHARACTER REFERENCE

  SELECT  subscriberApplicationCharRefs.charFullName ,
  subscriberApplicationCharRefs.charRelationship , 
  subscriberApplicationCharRefs.charAddress ,    
  subscriberApplicationCharRefs.charContactNo 
  FROM subscriberApplicationCharRefs 
  
 --CLICK ADD TO INSERT ROW IN FORM
  
--BUTTON NEW
  
  long ll_currentRow, ll_acctno, ll_applml, ll_row
	string ls_acctno, ls_applml
	datetime ldt_date, ldt_now 
	
	dw_header.insertRow(0)
	idw_genInfo.insertRow(0)
	idw_servAdd.insertRow(0)
	idw_billAdd.insertRow(0)
	idw_InstallInfo.insertRow(0)
	idw_genInfo.accepttext()
	
	idw_servadd.object.b_check_serviceability.enabled = True
	
	select REPLACE('IBAS-'||to_char(REFERENCE_SEQ.nextval,'00000000'),' ','') into :is_referenceCode 
	from dual
	using SQLCA;
	
	dataWindowChild ldw_agent
	dw_header.getChild("agentcode", ldw_agent)
	ldw_agent.setTransObject(SQLCA)
	ldw_agent.retrieve(gs_companyCode,gs_divisioncode)
	
	if not guo_func.get_nextnumber('APPLYML', il_applml, "WITH LOCK") then
		return
	end IF
	
	--validasi gue_func.get_nextnumber
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
	 
	if not guo_func.get_nextnumber('ACCOUNT', il_acctNo, "WITH LOCK") then
		return
	end IF
	
	--validasi gue_func.get_nextnumber
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
	
	--commit agad para hindi mag hang mga users. --ray 05/24/2018
	if	not guo_func.set_number('APPLYML', il_applml) then
		return 	
	end if
	
	if	not guo_func.set_number('ACCOUNT', il_acctNo) then
		return 
	end IF
	
	--validasi  set_number
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
	
	commit using SQLCA;
	
	ls_applml = string(il_applml, '00000000')
	ls_acctNo = string(il_acctNo, '000000')
	
	--set to global para sa save. --ray 05/24/2018 
	is_applml = ls_applml
	is_acctNo = ls_acctNo
	
	ll_currentRow = idw_genInfo.getRow()
	
	ldt_date = guo_func.get_server_date()
	ldt_now = guo_func.get_server_datetime( )
	
	--Set default Values
	dw_header.setitem(ll_currentRow, "tranNo", ls_applml) 
	dw_header.setitem(ll_currentRow, "dateapplied", ldt_date) 
	dw_header.setitem(ll_currentRow, "dateadd", ldt_date) 
	dw_header.setitem(ll_currentRow, "substypecode", is_substypecode)
	
	dw_header.setitem(ll_currentRow, "acctno", ls_acctno) 
	idw_genInfo.setitem(ll_currentRow, "birthdate", today())
	
	idw_InstallInfo.setitem(ll_currentRow, "preferreddatetimefrom", ldt_now)
	idw_InstallInfo.setitem(ll_currentRow,"payment_option",'0')
	idw_InstallInfo.setitem(ll_currentRow, "preferreddatetimeto", ldt_now)
	
	if gs_Divisioncode = 'BDANT' then
		idw_installInfo.object.isstaggered.visible = False
		idw_installInfo.object.noofmonthsamort.visible = False
		idw_installInfo.setItem(ll_currentRow,'isstaggered','O')
	end if
	
	ll_row = idw_servAdd.getRow()
	idw_servAdd.setItem(ll_row, 'servicesubdivisioncode', 'N/A')
	idw_servAdd.setItem(ll_row, 'servicebarangaycode', '000001')
	idw_servAdd.setItem(ll_row, 'servicemunicipalitycode', '000001')
	idw_servAdd.setItem(ll_row, 'serviceprovincecode', '000001')
	
	--idw_InstallInfo.setitem(1,"chargetypecode",'REG')
	
	pb_new.enabled = false
	pb_close.enabled = false
	
	pb_save.enabled = true
	pb_cancel.enabled = true
	tabform.tabpage_1.cb_upload.enabled = true
	
	is_prepaidSubscriber = 'N'
	
	if is_serviceType = 'INET' then
		idw_InstallInfo.object.b_packagecode.enabled 	= True
	else
		idw_InstallInfo.object.b_packagecode.enabled = False
	end if
	
	
	string ls_state
	select state into :ls_state
	from FEATURE_CONTROL_IBAS
	where name = 'PAYMENT OPTION'
	using SQLCA;
	
	idw_InstallInfo.setItem(1,'payment_option',1)
	
	IF ls_state <> 'ACTIVE' OR isnull(ls_state) or ls_state = '' then
		idw_InstallInfo.object.payment_option.visible = false
		idw_InstallInfo.object.t_19.visible = false
	else
		idw_InstallInfo.object.payment_option.visible = true
		idw_InstallInfo.object.t_19.visible = true
	end if


--END BUTTON NEW
  
--FINISHING
  
--CLICK BUTTON SAVE
  
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

// create records on subsInitialPayment
if trigger event ue_save_subsInitialPayment(ls_acctno, ld_instFee) = -1 then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = "Saving subsInitialPayment ~nSQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
	return -1
	
	--validasi ue_save_subsInitialPayment
	
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

	--end validasi
end if

--save record to Subscriber Master
if trigger event ue_save_subscriberMaster(ls_acctno, ld_instFee) = -1 then
	return -1
end IF

--validasi ue_save_subcriberMaster
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
//ld_birthDate				= idw_genInfo.getItemDate(ll_row, "birthdate")	
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
end if


--For GEPON Corporate Wee 05-15-15
if is_substypecode = "CP"  Then
	li_noOfExtraSTB = 0
	ll_noofrequiredSTB = 1
	ls_sex = ' '
	ldt_birthDate = DateTime(DATE('01/01/1900'),time('00:00'))
	ls_civilStatus = ' '
	ls_citizenshipCode = ' '
end if


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
					
	end if
	
	
	if isnull(ls_agentCode) then
	
		is_msgNo    = 'SM-0000001'
		is_msgTrail = "Please set {AGENTCODE IN INSTALLATION INFORMATION} "
		return -1		
	
	
	end if
	
	
	
	--FIT
	if uf_isAllowedInFITRadius(ls_packageTypeCode) THEN
	
	--validasi uf_isAllowedInFITRadius
	
	string ls_validPackageTypeCode[]

	if not uf_getAllowedPackageTypeCode('FITRADIUS', ls_validPackageTypeCode) then
		return FALSE
	end IF
	
	--validasi uf_getAllowedPacakgeTYpeCode
	
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
	
	--end validasi uf_getAllowedPacakgeTYpeCode
	
	int li_element
	for li_element = 1 to upperbound(ls_validPackageTypeCode)
		if trim(as_packageTypeCode) = trim(ls_validPackageTypeCode[li_element]) then
			return TRUE
		end if
	next
	
	return FALSE
	
	--end validasi
		
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
	
	if uf_isAllowedInAAA(ls_packageTypeCode) or uf_isAllowedInCMLRadius(ls_packageTypeCode) then
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
		end IF
		
		--validasi uf_isAllowedInCMLRadius
			string ls_validPackagetypeCode[]
	
			if not uf_getAllowedPackagetypeCode('CMLRADIUS', ls_validPackagetypeCode) then
				if not uf_getAllowedPackagetypeCode('WLSRADIUS', ls_validPackagetypeCode) then
					return FALSE
				end if
			end if
			
			if not uf_getAllowedPackagetypeCode('WLSRADIUS', ls_validPackagetypeCode) then
				return FALSE
			end IF
			
			--validasi uf_getAllowedPacakgeTYpeCode
	
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
			
			--end validasi uf_getAllowedPacakgeTYpeCode
			
			int li_element
			for li_element = 1 to upperbound(ls_validPackagetypeCode)
				if trim(as_packageTypecode) = trim(ls_validPackagetypeCode[li_element]) then
					return TRUE
				end if
			next
			
			return FALSE
		
		--end uf_isAllowedInCMLRadius
		
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
end if


if not ls_emailAddress2 = '' and not isnull(ls_emailAddress2) then
	if not of_validateEmail(ls_emailAddress2) then
		idw_genInfo.SetColumn("emailAddress2")
		is_msgNo    = 'RS-0000002'
		is_msgTrail = "Saving Subscriber Master : ~r~n Email Address 2 is invalid."
		return -1
	end if
end if 

if not ls_emailAddress3 = '' and not isnull(ls_emailAddress3) then
	if not of_validateEmail(ls_emailAddress3) then
		idw_genInfo.SetColumn("emailAddress3")
		is_msgNo    = 'RS-0000003'
		is_msgTrail = "Saving Subscriber Master : ~r~n Email Address 3 is invalid."
		return -1
	end if
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
end if

if not ls_mobileno2 = '' and not isnull(ls_mobileno2) then
	if not of_validatemobile(ls_mobileno2) then
		is_msgNo    = 'RS-0000005'
		is_msgTrail = "Saving Subscriber Master : ~r~n Mobile Number 2 " + ls_mobileno2 + " is invalid."
		return -1
	end if
end if

if not ls_mobileno3 = '' and not isnull(ls_mobileno3) then
	if not of_validatemobile(ls_mobileno3) then
		is_msgNo    = 'RS-0000006'
		is_msgTrail = "Saving Subscriber Master : ~r~n Mobile Number 3 "+ ls_mobileno3+" is invalid."
		return -1
	end if
end if

--BG 12/5/20
--Sir russ minub ke ini 
--after we set to international number then
--karin te i validate ing duplication
--then pelitan ke ing "or" to "and" CONDITION

if not isnull(is_mobileno) and not is_mobileno = '' then
	is_mobileno =	of_fixToInternationalFormat(is_mobileno)
end if

if not isnull(ls_mobileno2) and not ls_mobileno2 = '' then
	 ls_mobileno2 =	of_fixToInternationalFormat(ls_mobileno2)
end if

if not isnull(ls_mobileno3) and not ls_mobileno3 = '' then
	 ls_mobileno3 =	of_fixToInternationalFormat(ls_mobileno3)
end if

if not isnull(ls_serviceContactNo) and not ls_serviceContactNo = '' then
	 ls_serviceContactNo =	of_fixToInternationalFormat(ls_serviceContactNo)
end if

if not isnull(ls_billingcontactNo) and not ls_billingcontactNo = '' then
	 ls_billingcontactNo =	of_fixToInternationalFormat(ls_billingcontactNo)
end if

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

--added for staggered payment russ 1/22/2018


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
	
	
	
	// AR Account BILLING Address
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

--end validasi

--==================================================
--NGLara | 03-17-2008
--Prepare GL Poster
if not iuo_glPoster.initialize(is_transactionID, is_tranNo, idt_tranDate) then
	is_msgno 	= 'SM-0000001'
	is_msgtrail = iuo_glPoster.errorMessage
	is_sugtrail = iuo_glPoster.suggestionRemarks
	return -1
end if
uo_subs_advar.setGLPoster(iuo_glPoster)

if not uo_subs_advar.setAcctNo(ls_acctno) then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = uo_subs_advar.lastSQLCode + '~r~n' + uo_subs_advar.lastSQLErrText
	return -1
end if
if	This.Event ue_applyOCBalances(ld_instFee) <> 0 then
	return -1	
end IF

if not iuo_glPoster.postGLEntries() then
	is_msgno 	= 'SM-0000001'
	is_msgtrail =  iuo_glPoster.errorMessage
	is_sugtrail = iuo_glPoster.suggestionRemarks
	return -1
end if

uo_subscriber luo_subscriber

if not luo_subscriber.setAcctNo(ls_acctno) then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = luo_subscriber.lastSQLCode + '~r~n' + luo_subscriber.lastSQLErrText
	return -1
end if 

if luo_subscriber.autocreatejo() < 0 then
	is_msgNo    = 'SM-0000001'
	is_msgTrail = luo_subscriber.lastSQLCode + '~r~n' + luo_subscriber.lastSQLErrText
	return -1
end if 



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
	end if
	
	if luo_subscriber.autocreatejo_IPTV(is_seq_no, ls_jono_iptv) < 0 then
		is_msgNo    = 'SM-0000001'
		is_msgTrail = luo_subscriber.lastSQLCode + '~r~n' + luo_subscriber.lastSQLErrText
		return -1
	end if 
	
	
	if trigger event ue_salesaddontranhdr(ls_acctno, 1, ls_ext_packagecode, ls_jono_iptv) = -1 then
	  	return -1
	end if 
END IF
return 0


