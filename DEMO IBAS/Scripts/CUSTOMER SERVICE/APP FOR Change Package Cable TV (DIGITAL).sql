opensheetwithparm(w_change_package_digital, 'CTV', w_mdiFrame, 0, original!)

is_serviceType = message.stringParm
is_serviceType = 'CTV'

uo_center_window luo_center_window
luo_center_window = create uo_center_window
luo_center_window.f_center(this)

dw_detail.setTransObject(SQLCA);
iuo_subscriber = create uo_subscriber_def

--QUERY FORM DW_HEADER
SELECT  changepackagetranhdr.tranNo ,
           changepackagetranhdr.tranDate ,
           changepackagetranhdr.acctNo ,
           changepackagetranhdr.oldPackageCode ,
           changepackagetranhdr.newPackageCode ,
           changepackagetranhdr.remarks ,
           changepackagetranhdr.changepackagefee ,
           '' serviceAddress,
			  '' subscribername,
      	  '' oldPackagename,
			  '' newPackageName,
			  '' oldPackageDesc,
			  '' newPackageDesc,
			  '' installation_type,
			 '' delivery_option,
				'' itemcode, '' itemname, '' waive_downgradefee,
0.00 oldMrc,
0.00 newMrc	
        FROM changepackagetranhdr    

--END QUERY
        
--QUERY FORM DW_DETAIL
 SELECT c.packageCode ,
       c.serialNo ,
       LPAD('', 500, ' ') remarks  ,
       a.packageName oldPackagename  ,
       '' newPackageName  ,
       '' newPackageCode  ,
       c.isPrimary 
  FROM subscriberCPEMaster c
         JOIN arPackageMaster a
          ON c.packageCode = a.packageCode
         AND c.divisionCode = a.divisionCode
         AND c.companyCode = a.companyCode
 WHERE c.acctNo =:as_acctNo
         AND c.divisionCode = :as_division
         AND c.companyCode =:as_company;       
--END QUERY

--EVENT UE_SEARCH ACCTNO

string ls_search, ls_result, ls_serviceAddress, ls_oldPackageCode, ls_msg
long ll_row
decimal{2} ld_changePackageFee, ld_packageRate
str_search str_s

ls_search = trim(as_search)
ll_row = dw_header.getrow()

choose case ls_search
	case "acct_no"
		str_s.serviceType = is_serviceType
		
		--QUERY SEARCH ACCTNO
		
		select aracctsubscriber.acctno,
 			 aracctsubscriber.subscribername,
			arAcctSubscriber.subscribername,   
					vw_arAcctAddress.contactNo,   
					arAcctSubscriber.mobileno,   
					vw_arAcctAddress.municipalityCode,   
					arAcctSubscriber.packagecode,   
					arAcctSubscriber.subscriberstatuscode,   
					vw_arAcctAddress.completeAddress,
			 subscriberStatusMaster.subscriberStatusName,
			      arPackageMaster.packageName
									 from
									 aracctsubscriber
			 inner join vw_arAcctAddress 
					   on  vw_arAcctAddress.acctNo = arAcctSubscriber.acctNo
			            and vw_arAcctAddress.addressTypeCode = 'SERVADR1' 
			            and vw_arAcctAddress.divisionCode = arAcctSubscriber.divisionCode
			            and vw_arAcctAddress.companyCode = arAcctSubscriber.companyCode
			inner join arPackageMaster  
					   on  arPackageMaster.packageCode = arAcctSubscriber.packageCode
			            and arPackageMaster.divisionCode = arAcctSubscriber.divisionCode
			            and arPackageMaster.companyCode = arAcctSubscriber.companyCode
			inner join subscriberStatusMaster 
					   on  subscriberStatusMaster.subscriberstatuscode = arAcctSubscriber.subscriberstatuscode

		--END QUERY SEARCH ACCTNO
		
		openwithparm(w_search_subscriber,str_s)	
		ls_result = trim(message.stringparm)
		
		if ls_result <> '' then			
			
			if not iuo_subscriber.setAcctNo(ls_result) then
				guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + iuo_subscriber.lastSQLErrText)
				return 0
			end if
			
			--VALIDASI IUO_SUBCRIBER.SETACCTNO
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
		
		--END VALIDASI SETACCTNO
			
			is_isDigital = iuo_subscriber.isDigital
			
			if is_isDigital = 'Y'  then
			
				if not iuo_subscriber.getServiceAddress(ls_serviceAddress) then
					guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + iuo_subscriber.lastSQLErrText)
					return 0
				end IF
				
				--validasi getServiceAddress
				lastMethodAccessed = 'getServiceAddress'
			
				as_serviceAddress = serviceAddressComplete (take FROM ue_subcriber.setaccno.serviceAddressComplete)
				
				--end getServiceAddress
	
				if iuo_subscriber.subscriberStatusCode <> 'APL' and iuo_subscriber.subscriberStatusCode <> 'ACT' then
					guo_func.msgbox("Unable to proceed...", 'Change package is only allowed for APPLICANT and ACTIVE Subscriber only.')
					return -1
				end if
				
				dw_header.setitem(ll_row,'acctno', ls_result)		
				dw_header.setitem(ll_row,'subscribername', iuo_subscriber.subscriberName)
				dw_header.setitem(ll_row,'oldpackageCode', iuo_subscriber.packageCode)
				dw_header.setitem(ll_row,'serviceaddress', ls_serviceAddress)
				dw_header.setitem(ll_row,'oldpackageName', iuo_subscriber.packageName)
				dw_header.setitem(ll_row,'oldpackageDesc', iuo_subscriber.packageDescription)
				if iuo_subscriber.subscriberstatuscode = 'APL' then
					dw_detail.dataobject = 'dw_change_package_dtl_apl'
					dw_detail.settransobject(SQLCA);
				end if
				dw_detail.retrieve(ls_result, gs_divisionCode, gs_companyCode)
			else
				parent.triggerevent("ue_cancel")	
				guo_func.msgBox("ATTENTION","Only subscriber that has digital package can use this transaction.")
			end if
		end if
		
	case "package"
		
		if this.getItemString(ll_row,'acctno') <> '' then
			str_s.s_dataobject = "dw_search_package_master"
			str_s.s_return_column = "packagecode"
			str_s.s_title = "Search For ARPackageMaster"
			
			str_s.s_1 = 'N'
			str_s.s_2 = is_serviceType
			str_s.s_3 = gs_divisionCode
			str_s.s_4 = is_isDigital
			
			ls_oldPackageCode = trim(iuo_subscriber.packageCode)
			
			--QUERY SEARCH PACKAGE
			
			SELECT arPackageMaster.packagename ,
					 arPackageMaster.packagecode     
			  FROM arPackageMaster
			 WHERE ( arPackageMaster.isPrepaid = :as_isPrepaid ) and
					 (	arPackageMaster.isPPV =  'N' and arPackageMaster.isActive = 'Y')and
			       ( arPackageMaster.serviceType = :as_serviceType ) and (arPackageMaster.divisionCode = :as_division) and
				(arPackageMaster.isDigital = :as_isDigital) and
			( arPackageMaster.packageClassCode <>  'DPP' ) and
			( arPackageMaster.packageClassCode <>  'DGP' )
						
			--END QUERY
			
			openwithparm(w_search_ancestor,str_s)
			ls_result = trim(message.stringparm)
			
			if ls_result <> '' then			
				
				if ls_result = ls_oldPackageCode then
					guo_func.MsgBox('Error in package...','Old package and New package must not be the same...')
					return -1
				end if	
				
				string ls_packageDesc, ls_packageName2
				
				select packageName, packageDescription, monthlyRate
				into :ls_packageName2, :ls_packageDesc, :ld_packageRate
				from arPackageMaster
				where packageCode = :ls_result
				and divisionCode = :gs_divisionCode
				and companyCode = :gs_companyCode
				using SQLCA;
				
				dw_header.setitem(ll_row,'newpackageCode', ls_result)		
				dw_header.setitem(ll_row,'newpackageName', ls_packageName2)	
				dw_header.setitem(ll_row,'newpackageDesc', ls_packageDesc)	
				
				--------------------------------------------------------------
				-- validate policy on no of months a/r min requirement - start
				--------------------------------------------------------------		
				s_arrears_override_policy.refTranTypeCode = 'CHANGEPACK'
				
				if iuo_subscriber.subscriberStatusCode = 'ACT' then
					if iuo_subscriber.chargeTypeCode <> 'REG' then
						if not f_overridechargeType(s_arrears_override_policy, 'Y',iuo_subscriber.subscriberName,iuo_subscriber.acctno) then			
							trigger event ue_cancel()
							return -1
						end IF
						
						--VALIASI F_OVERRIDECHARGETYPE
						
							-------------------------------------------
							-- validate policy on customer type - start
							-------------------------------------------
							
							
							--pop up override policy window for authorization
							if as_requiresApproval = 'Y' then
								if guo_func.msgbox("Policy Override!!!", &
														"The charge type requires approval. You can not apply for this charge type without approval.  Do you want to override this policy?", &										
														gc_Question, &
														gc_yesNo, &
														"Please secure an authorization for overriding this policy.") = 1 then
									
									s_charge_type_override_policy.overridePolicyTypeCode 		= '002'
									s_charge_type_override_policy.policyCode 					= '002'
									s_charge_type_override_policy.subscriberName			  	= as_acctName
									s_charge_type_override_policy.acctno						= as_acctNo
									
									openwithparm(w_online_authorization,s_charge_type_override_policy)
									
									--event open w_online_authorization
							string ls_remarks
								long ll_tranNo
								int li_noOfArrears = 0, li_subscription, li_ads
								dateTime ldt_date
								
								istr_override_policy = message.powerObjectParm
								
								if f_getPolicy(istr_policy, istr_override_policy.policyCode, istr_override_policy.refTranTypeCode) <> 0 then
									closeWithReturn(this,'ER')
								else
								
									dw_1.setTransObject(SQLCA);
									dw_2.setTransObject(SQLCA);
									dw_1.insertRow(0)
									
									if not guo_func.get_nextNumber_continous('OVERRIDE', ll_tranNo, '') then
										closeWithReturn(this,'ER')
									end if
									
									dw_1.setItem(1,'tranNo',string(ll_tranNo, '0000000000'))
									dw_1.setItem(1,'requestedby',gs_ufullname)
									
									select datediff(mm, dateInsTalled, getdate())
									into :li_subscription
									from arAcctSubscriber
									where acctNo = :istr_override_policy.acctNo
									and divisionCode = :gs_divisionCode
									and companyCode = :gs_companyCode
									using SQLCA;
									
									if isNull(li_subscription) then li_subscription = 0
									
									ldt_date = dateTime(RelativeDate(date(guo_func.get_server_datetime()), li_subscription))
									
									--VALIDASI GET_SERVER_DATETIME
											
											datetime ldt_datetime
											select sysdate into :ldt_datetime 
											from systemparameter 
											where divisionCode = :gs_divisionCode
											and companyCode = :gs_companyCode
											using SQLCA;
											if SQLCA.sqlcode <> 0 then
												select sysdate into :ldt_datetime from systemparameter where rownum < 2 using SQLCA;
												if SQLCA.sqlcode < 0 then
													guo_func.msgbox('Warning!', 'Unable to get server date')
													lastSQLCode	= string(SQLCA.SQLCode)
													lastSQLErrText	= SQLCA.SQLErrText
												end if
											end if
											
											return ldt_datetime
											
									--END VALIDASI GET_SERVER_DATETIME
									
									select count(*)
									into :li_ads
									from adsTranHdr
									where tranDate between :ldt_date and getDate()
									and acctNo = :istr_override_policy.acctNo
									and divisionCode = :gs_divisionCode
									and companyCode = :gs_companyCode
									using SQLCA;
									
									if isNull(li_ads) then li_ads = 0
									
									li_noOfArrears = f_getSubsNoOfMonthArrears(istr_override_policy.acctNo)
									
									if istr_override_policy.policyCode  = '001' then
										ls_remarks = 'Trans.: '+ upper(istr_policy.tranTypeName) + ' Subs.: ' + &
														 upper(istr_override_policy.subscriberName) + ' Bal.: ' + &
														 string(istr_override_policy.arBalance,'###,###,###,##0.00') + &
														 ' Arrears: ' + string(li_noOfArrears) + ' Lock In: NO '+'Subsription: ' + &
														 string(li_subscription) + ' mos. '+'ADS: ' +string(li_ads)
									elseif istr_override_policy.policyCode  = '005' then
										ls_remarks = 'Trans.: '+ upper(istr_policy.tranTypeName) + ' Subs.: ' + &
														 upper(istr_override_policy.subscriberName) + ' Bal.: ' + &
														 string(istr_override_policy.arBalance,'###,###,###,##0.00') + &
														 ' Arrears:  '+ string(li_noOfArrears) + ' Lock In: YES Subsription: ' + &
														 string(li_subscription) + ' mos. '+'ADS: ' +string(li_ads)
									elseif istr_override_policy.policyCode  = '003' then
										ls_remarks = 'Trans.: '+ upper(istr_policy.tranTypeName) + ' Subs.: ' + &
														 upper(istr_override_policy.subscriberName) + ' Bal.: ' + &
														 string(istr_override_policy.arBalance,'###,###,###,##0.00') + &
														 ' Arrears:  0 Lock In: YES Subsription: ' + &
														 string(li_subscription) + ' mos. '+'ADS: ' +string(li_ads)
									elseif istr_override_policy.policyCode = '004' then
										ls_remarks = 'Trans.: '+ upper(istr_policy.tranTypeName) + ' Subs.: ' + &
														 upper(istr_override_policy.subscriberName) + ' RIP: ' + &
														 string(istr_override_policy.arBalance,'###,###,###,##0.00') 
									elseif istr_override_policy.policyCode = '002'  and istr_override_policy.reqType = 'APPLYML' then
										ls_remarks = 'Trans.: '+ upper(istr_policy.tranTypeName) + ' Subs.: ' + &
														 upper(istr_override_policy.subscriberName) + ' Charge Type: '+istr_override_policy.chargeType 
									elseif istr_override_policy.policyCode = '002'  and istr_override_policy.reqType = 'CHARGETYPE' then
										ls_remarks = 'Trans.:  CHANGE CHARGE TYPE Subs.: ' + &
														 upper(istr_override_policy.subscriberName) +  ' Charge Type: '+istr_override_policy.chargeType +&
														 'Bal.: '+string(istr_override_policy.arBalance,'###,###,###,##0.00') +&
														 ' Arrears: ' + string(li_noOfArrears) 
									elseif istr_override_policy.policyCode = '006' then
										ls_remarks = 'Trans.: '+ upper(istr_policy.tranTypeName) + ' Subs.: ' + &
														 upper(istr_override_policy.subscriberName) + ' Orig. CPE Fee: ' + &
														 string(istr_override_policy.origFee,'###,##0.00 ' ) + &
														 ' Request CPE Fee: ' + string(istr_override_policy.cpeRepFee,'###,##0.00 ')
									elseif  istr_override_policy.policyCode = '010' then
														ls_remarks = 'Trans: JO BACKDATE'
									end if			
									dw_1.setItem(1,'remarks',ls_remarks)
									dw_1.setItem(1,'policyName',istr_policy.policyName)
									dw_1.setItem(1,'arBalance',istr_override_policy.arBalance)
									dw_1.setItem(1,'lockinperiod','N')
								end IF
								
							--end open w_online_authorization
								
							--event button click w_open_autorization
								
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
								
								--VALIDASI GET_SERVER_DATETIME
											
											datetime ldt_datetime
											select sysdate into :ldt_datetime 
											from systemparameter 
											where divisionCode = :gs_divisionCode
											and companyCode = :gs_companyCode
											using SQLCA;
											if SQLCA.sqlcode <> 0 then
												select sysdate into :ldt_datetime from systemparameter where rownum < 2 using SQLCA;
												if SQLCA.sqlcode < 0 then
													guo_func.msgbox('Warning!', 'Unable to get server date')
													lastSQLCode	= string(SQLCA.SQLCode)
													lastSQLErrText	= SQLCA.SQLErrText
												end if
											end if
											
											return ldt_datetime
											
								--END VALIDASI GET_SERVER_DATETIME
								
								
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
							end if	
							
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
							
					--end event  button click
									
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
													
									// reset entry		
									return false
								end if
								
							end if
							return true
							
						--END VALIDASI F_OVERRIDECHARGETYPE
							
					else
						ls_msg = f_lockInPeriod(iuo_subscriber.acctNo)
						if ls_msg <> 'NO' and ls_msg <> 'YES' then
							guo_func.msgBox("ERROR",ls_msg)
							return -1
						end IF
						
						--VALIDASI F_LOCKINPERIOD
						integer li_no, li_lockIn, li_year, li_month, li_day, li_addyear
						string ls_msg
						date ld_lockin, ld_today, ld_dateinstalled
						
						select TRUNC(months_between(sysdate, dateinstalled)) DP_MONTH, lockInPeriod ,dateinstalled
						into :li_no, :li_lockIn,:ld_dateinstalled
						from arAcctSubscriber
						where acctNo = :as_acctNo
						and divisionCode = :gs_divisionCode
						and companyCode = :gs_companyCode
						and rownum < 2
						using SQLCA;
						if SQLCA.sqlCode <> 0 then
							ls_msg = string(SQLCA.sqlCode) + ' ' + SQLCA.sqlerrText
							return ls_msg
						end if
						
						li_addyear = (month(ld_dateinstalled) + li_lockin) / 12
						li_year = li_addyear + year(ld_dateinstalled)
						li_month = month(ld_dateinstalled) + li_lockin
						if li_month > 12 then
							li_month = li_month - (li_addyear *  12)
							if li_month = 0 then
								li_month = 12
							end if
						end if
						li_day = f_getlastdayofmonth(li_month,li_year)
						if day(ld_dateinstalled) > li_day then
							li_day = li_day
						else
							li_day = day(ld_dateinstalled)
						end if
						
						ld_lockin = date(li_year,li_month,li_day)
						ld_today = today()
						
						
						select  ( (add_months(dateinstalled,lockInPeriod) - dateinstalled )) DP_DAY  , TRUNC(SYSDATE -dateinstalled) DP_DAY 
						into :li_lockin,:li_no
						from aracctsubscriber
						where acctno = :as_acctno
						and divisioncode = :gs_divisioncode
						and companycode = :gs_companycode
						and rownum < 2
						using SQLCA;
						if SQLCA.sqlCode <> 0 then
							ls_msg = string(SQLCA.sqlCode) + ' ' + SQLCA.sqlerrText
							return ls_msg
						end if
						
						if li_no > li_lockIn then
							select  nvl(( (add_months(DATERELOCKIN,24) - DATERELOCKIN )),0) DP_DAY  , nvl(TRUNC(SYSDATE -DATERELOCKIN),0) DP_DAY 
							into :li_lockin,:li_no
							from aracctsubscriber
							where acctno = :as_acctno
							and divisioncode = :gs_divisioncode
							and companycode = :gs_companycode
							and rownum < 2
							using SQLCA;
							
							if li_lockin = 0 then
								return 'NO'
							end if
							
							if li_no > li_lockIn then
								ls_msg = 'NO'
							else
								ls_msg = 'YES'
							end if
						else 
							ls_msg = 'YES'
						end if
						
						return ls_msg
						
						--END VALIDASI F_LOCKINPERIOD
						
						if ls_msg = 'YES' and (ld_packageRate < iuo_subscriber.mLineCurrentMonthlyRate) then
							if not f_overrideArrearsLockIn(iuo_subscriber, s_arrears_override_policy ) then
								trigger event ue_cancel()
								return -1
							end IF
							
							--VALIDASI F_OVERRIDEARREARSLOCKIN
							
							decimal {2} ld_ARBalance
								string ls_msg, ls_remarks
								
								--------------------------------------------------------------
								-- validate policy on no of months a/r min requirement - start
								--------------------------------------------------------------
								
								
								ld_ARBalance = 0.00
								--check if subscriber has a/r balances
								if not iuo_subscriber.getARBalance(ld_ARBalance,1) then
									guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + &
										iuo_subscriber.lastSQLErrText)
								end if
								
								ls_msg = f_lockInPeriod(iuo_subscriber.acctNo)
								if ls_msg <> 'NO' and ls_msg <> 'YES' then
									guo_func.msgBox("ERROR",ls_msg)
									return False
								end if
								
								s_arrears_override_policy.acctNo 						= iuo_subscriber.acctNo
								s_arrears_override_policy.arBalance 					= ld_ARBalance
								s_arrears_override_policy.subscriberName				= iuo_subscriber.subscriberName
								
								if ld_ARBalance > 0.00 and ls_msg = 'NO' then
									s_arrears_override_policy.overridePolicyTypeCode 	= '001'
									ls_remarks = "The current subscriber has a/r balances.  You can not continue with this request.  Do you want to override this policy?"
									s_arrears_override_policy.policyCode = '001'
								elseif ld_ARBalance > 0.00 and ls_msg = 'YES' then
									s_arrears_override_policy.overridePolicyTypeCode 	= '005'
									ls_remarks = "The current subscriber is in lock in period and has a/r balances.  You can not continue with this request.  Do you want to override this policy?"
									s_arrears_override_policy.policyCode = '004'
								elseif ld_ARBalance = 0.00 and ls_msg = 'YES' then
									s_arrears_override_policy.overridePolicyTypeCode 	= '003'
									ls_remarks = "The current subscriber is in lock in period.  You can not continue with this request.  Do you want to override this policy?"
									s_arrears_override_policy.policyCode = '005'
								else
									return True
								end if
								--pop up override policy window for authorization
								
								if guo_func.msgbox("Policy Override!!!", ls_remarks, &										
														gc_Question, gc_yesNo, "Please secure an authorization for overriding this policy.") = 1 then
									
									openwithparm(w_online_authorization,s_arrears_override_policy)	
									
									--event open w_online_authorization
											string ls_remarks
											long ll_tranNo
											int li_noOfArrears = 0, li_subscription, li_ads
											dateTime ldt_date
											
											istr_override_policy = message.powerObjectParm
											
											if f_getPolicy(istr_policy, istr_override_policy.policyCode, istr_override_policy.refTranTypeCode) <> 0 then
												closeWithReturn(this,'ER')
											else
											
												dw_1.setTransObject(SQLCA);
												dw_2.setTransObject(SQLCA);
												dw_1.insertRow(0)
												
												if not guo_func.get_nextNumber_continous('OVERRIDE', ll_tranNo, '') then
													closeWithReturn(this,'ER')
												end if
												
												dw_1.setItem(1,'tranNo',string(ll_tranNo, '0000000000'))
												dw_1.setItem(1,'requestedby',gs_ufullname)
												
												select datediff(mm, dateInsTalled, getdate())
												into :li_subscription
												from arAcctSubscriber
												where acctNo = :istr_override_policy.acctNo
												and divisionCode = :gs_divisionCode
												and companyCode = :gs_companyCode
												using SQLCA;
												
												if isNull(li_subscription) then li_subscription = 0
												
												ldt_date = dateTime(RelativeDate(date(guo_func.get_server_datetime()), li_subscription))
												
										  --VALIDASI GET_SERVER_DATETIME
											
											datetime ldt_datetime
											select sysdate into :ldt_datetime 
											from systemparameter 
											where divisionCode = :gs_divisionCode
											and companyCode = :gs_companyCode
											using SQLCA;
											if SQLCA.sqlcode <> 0 then
												select sysdate into :ldt_datetime from systemparameter where rownum < 2 using SQLCA;
												if SQLCA.sqlcode < 0 then
													guo_func.msgbox('Warning!', 'Unable to get server date')
													lastSQLCode	= string(SQLCA.SQLCode)
													lastSQLErrText	= SQLCA.SQLErrText
												end if
											end if
											
											return ldt_datetime
											
											--END VALIDASI GET_SERVER_DATETIME
												
												select count(*)
												into :li_ads
												from adsTranHdr
												where tranDate between :ldt_date and getDate()
												and acctNo = :istr_override_policy.acctNo
												and divisionCode = :gs_divisionCode
												and companyCode = :gs_companyCode
												using SQLCA;
												
												if isNull(li_ads) then li_ads = 0
												
												li_noOfArrears = f_getSubsNoOfMonthArrears(istr_override_policy.acctNo)
												
												if istr_override_policy.policyCode  = '001' then
													ls_remarks = 'Trans.: '+ upper(istr_policy.tranTypeName) + ' Subs.: ' + &
																	 upper(istr_override_policy.subscriberName) + ' Bal.: ' + &
																	 string(istr_override_policy.arBalance,'###,###,###,##0.00') + &
																	 ' Arrears: ' + string(li_noOfArrears) + ' Lock In: NO '+'Subsription: ' + &
																	 string(li_subscription) + ' mos. '+'ADS: ' +string(li_ads)
												elseif istr_override_policy.policyCode  = '005' then
													ls_remarks = 'Trans.: '+ upper(istr_policy.tranTypeName) + ' Subs.: ' + &
																	 upper(istr_override_policy.subscriberName) + ' Bal.: ' + &
																	 string(istr_override_policy.arBalance,'###,###,###,##0.00') + &
																	 ' Arrears:  '+ string(li_noOfArrears) + ' Lock In: YES Subsription: ' + &
																	 string(li_subscription) + ' mos. '+'ADS: ' +string(li_ads)
												elseif istr_override_policy.policyCode  = '003' then
													ls_remarks = 'Trans.: '+ upper(istr_policy.tranTypeName) + ' Subs.: ' + &
																	 upper(istr_override_policy.subscriberName) + ' Bal.: ' + &
																	 string(istr_override_policy.arBalance,'###,###,###,##0.00') + &
																	 ' Arrears:  0 Lock In: YES Subsription: ' + &
																	 string(li_subscription) + ' mos. '+'ADS: ' +string(li_ads)
												elseif istr_override_policy.policyCode = '004' then
													ls_remarks = 'Trans.: '+ upper(istr_policy.tranTypeName) + ' Subs.: ' + &
																	 upper(istr_override_policy.subscriberName) + ' RIP: ' + &
																	 string(istr_override_policy.arBalance,'###,###,###,##0.00') 
												elseif istr_override_policy.policyCode = '002'  and istr_override_policy.reqType = 'APPLYML' then
													ls_remarks = 'Trans.: '+ upper(istr_policy.tranTypeName) + ' Subs.: ' + &
																	 upper(istr_override_policy.subscriberName) + ' Charge Type: '+istr_override_policy.chargeType 
												elseif istr_override_policy.policyCode = '002'  and istr_override_policy.reqType = 'CHARGETYPE' then
													ls_remarks = 'Trans.:  CHANGE CHARGE TYPE Subs.: ' + &
																	 upper(istr_override_policy.subscriberName) +  ' Charge Type: '+istr_override_policy.chargeType +&
																	 'Bal.: '+string(istr_override_policy.arBalance,'###,###,###,##0.00') +&
																	 ' Arrears: ' + string(li_noOfArrears) 
												elseif istr_override_policy.policyCode = '006' then
													ls_remarks = 'Trans.: '+ upper(istr_policy.tranTypeName) + ' Subs.: ' + &
																	 upper(istr_override_policy.subscriberName) + ' Orig. CPE Fee: ' + &
																	 string(istr_override_policy.origFee,'###,##0.00 ' ) + &
																	 ' Request CPE Fee: ' + string(istr_override_policy.cpeRepFee,'###,##0.00 ')
												elseif  istr_override_policy.policyCode = '010' then
																	ls_remarks = 'Trans: JO BACKDATE'
												end if			
												dw_1.setItem(1,'remarks',ls_remarks)
												dw_1.setItem(1,'policyName',istr_policy.policyName)
												dw_1.setItem(1,'arBalance',istr_override_policy.arBalance)
												dw_1.setItem(1,'lockinperiod','N')
											end IF
											
										--end open w_online_authorization
											
										--event button click w_open_autorization
											
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
											
											--VALIDASI GET_SERVER_DATETIME
											
											datetime ldt_datetime
											select sysdate into :ldt_datetime 
											from systemparameter 
											where divisionCode = :gs_divisionCode
											and companyCode = :gs_companyCode
											using SQLCA;
											if SQLCA.sqlcode <> 0 then
												select sysdate into :ldt_datetime from systemparameter where rownum < 2 using SQLCA;
												if SQLCA.sqlcode < 0 then
													guo_func.msgbox('Warning!', 'Unable to get server date')
													lastSQLCode	= string(SQLCA.SQLCode)
													lastSQLErrText	= SQLCA.SQLErrText
												end if
											end if
											
											return ldt_datetime
											
											--END VALIDASI GET_SERVER_DATETIME
											
											
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
										end if	
										
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
										
								--end event  button click
									 
									if message.stringParm = 'CN' then
										guo_func.msgbox("Policy Override!!!", &
														"You have cancelled the authorization.  This will cancel your transaction.", &										
														gc_Information, &
														gc_OKOnly, &
														"Please secure an authorization for overriding this policy.")
														
										-- reset entry
										return false
									elseif message.stringParm = 'DP' then
										return false
									elseif message.stringParm = 'ER' then
										return false
									end if
								else  --policy ignored close window transaction
									guo_func.msgbox("Policy Override!!!", &
													"You have cancelled the authorization.  This will cancel your transaction.", &										
													gc_Information, &
													gc_OKOnly, &
													"Please secure an authorization for overriding this policy.")
													
									// reset entry		
									return false
								end if
								return true
								------------------------------------------------------------			
								-- validate policy on no of months a/r min requirement - end
								------------------------------------------------------------
							
							--END VALIDASI F_OVERRIDEARREARSLOCKIN
						end if
					end if
				end if
				------------------------------------------------------------			
				--validate policy on no of months a/r min requirement - end
				------------------------------------------------------------
				
			end if
		else
			guo_func.MsgBox('ATTENTION','Select a subscriber before selecting a new package.')
		end if
		
end choose
return 0


--END EVENT UE_SEARCH

--BUTTON NEW
string ls_tranNo
long ll_tranNo
datetime ldt_dateadd

ldt_dateadd	= guo_func.get_server_date()

--VALIDASI GET_SERVER_DATE
datetime ldt_datetime
date		ldt_date
select sysdate into :ldt_datetime 
from systemparameter 
where divisionCode = :gs_divisionCode
and companyCode = :gs_companyCode
using SQLCA;
if SQLCA.sqlcode <> 0 then
	select sysdate into :ldt_datetime from DUAL where rownum < 2 using SQLCA;
	if SQLCA.sqlcode < 0 then
		guo_func.msgbox('Warning!', 'Unable to get server date')
		lastSQLCode	= string(SQLCA.SQLCode)
		lastSQLErrText	= SQLCA.SQLErrText
	end if
end if
ldt_date = date(ldt_datetime)
ldt_datetime = datetime(ldt_date)
return ldt_datetime

--END VALIDASI GET_SERVER_DATE

dw_header.insertRow(0);

if not guo_func.get_nextnumber('CHANGEPACK', ll_tranNo, "") then
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

--END VALIDASI GET_NEXTNUMBER

ls_tranNo = string(ll_tranNo, '00000000')
dw_header.setitem(dw_header.getrow(), 'tranNo', ls_tranNo) 
dw_header.setitem(dw_header.getrow(), 'tranDate', ldt_dateadd) 


--END BUTTON NEW

--BUTTON SAVE
string 		ls_oldPackageCode, ls_newPackageCode, ls_acctno, ls_remarks, ls_arRemarks, ls_serialNo, ls_primary
datetime 	ldt_tranDate
decimal{2} 	ld_changePackageFee, ld_changePackageDiscount, ld_changePackageDiscountRate, ld_extendedFeeAmount
decimal{2} 	ld_mlinePreviousMonthlyRate, ld_extPreviousMonthlyRate, ld_mlineCurrentMonthlyRate, ld_extCurrentMonthlyRate
decimal{2} 	ld_mLineCurrentDailyRate, ld_mlineBaseDailyRate, ld_mLinePreviousDailyRate, ld_mLineAmount
decimal{2} 	ld_extCurrentDailyRate, ld_extBaseDailyRate, ld_extPreviousDailyRate, ld_extAmount, ld_additionalSubsDepReq
long 		ll_tranNo, ll_noOfExt, ll_daysConsumed
integer		li_noOfDaysOfTheMonth, li_month, li_ctr
boolean	lb_gotBilledThisMonth, lb_first
 STRING ls_oldpackagename, ls_newpackagename, ls_relockin
 
dw_header.acceptText()
dw_detail.acceptText()

ib_forReclassifyOC = false

if not guo_func.get_nextNumber(is_transactionID, ll_tranNo, "WITH LOCK") then			
	return -1
end if	
 
ldt_tranDate			= guo_func.getServerDatetime()
li_month				   = month(date(ldt_tranDate))
ls_acctno				= trim(dw_header.getitemString(1, 'acctno'))
is_acctNo				= ls_acctNo
ls_remarks			= "Change Package Fee"
lb_first = true ///-zar 08202010

for li_ctr = 1 to dw_detail.rowCount()
	
	ls_oldPackageCode		= trim(dw_detail.getitemString(li_ctr, 'packagecode'))
	ls_newPackageCode 	= trim(dw_detail.getitemString(li_ctr, 'newPackageCode'))
	ls_serialNo			 	= trim(dw_detail.getitemString(li_ctr, 'serialno'))
	ls_primary			 	= trim(dw_detail.getitemString(li_ctr, 'isprimary'))
	
	if isNull(ls_newPackageCode) or trim(ls_newPackageCode) = '' then continue
	
//	if not isNull(ls_newPackageCode) and ls_newPackageCode <> '' then
		is_tranno			= string(ll_tranno,'00000000')
		ls_remarks			= trim(dw_detail.getitemString(li_ctr, 'remarks'))	
		
		if not iuo_glPoster.initialize(is_transactionID, is_tranNo, ldt_tranDate) then
			is_msgno 	= 'SM-0000001'
			is_msgtrail = iuo_glPoster.errorMessage
			is_sugtrail = iuo_glPoster.suggestionRemarks
			return -1
		end if
		uo_subs_advar.setGLPoster(iuo_glPoster)
				
		uo_subscriber_def luo_subscriber
		luo_subscriber = create uo_subscriber_def
		
		if not luo_subscriber.setAcctNoDigital(ls_acctNo, ls_oldPackageCode) then
			is_msgNo = 'SM-0000001'
			is_msgTrail = luo_subscriber.lastSQLCode + '~r~n~r~n' + luo_subscriber.lastSQLErrText
			is_sugTrail = ''	
			return -1
		end if
		
		if not luo_subscriber.getMLineMonthlyRate(ld_mlinePreviousMonthlyRate) then
			is_msgNo = 'SM-0000001'
			is_msgTrail = luo_subscriber.lastSQLCode + '~r~n~r~n' + luo_subscriber.lastSQLErrText
			is_sugtrail = 'Error produced by luo_subscriber.getMLineMonthlyRate()'
			return -1
		end if
		
		ld_extPreviousMonthlyRate 	= 0.00
		ld_extCurrentMonthlyRate		= 0.00
		
		if not luo_subscriber.getNewMLineMonthlyRate(ls_newPackageCode, ld_mlineCurrentMonthlyRate) then
			is_msgNo = 'SM-0000001'
			is_msgTrail = luo_subscriber.lastSQLCode + '~r~n~r~n' + luo_subscriber.lastSQLErrText
			is_sugtrail = 'Error produced by luo_subscriber.getNewMLineMonthlyRate()'
			return -1
		end if
		
		if not luo_subscriber.getChangePackageFee(ld_changePackageFee) then
			is_msgNo = 'SM-0000001'
			is_msgTrail = luo_subscriber.lastSQLCode + '~r~n~r~n' + luo_subscriber.lastSQLErrText
			is_sugtrail = 'Error produced by luo_subscriber.getChangePackageFee()'
			return -1
		end if
		
		if not luo_subscriber.getPercentDiscount('CHGPF', ld_changePackageDiscountRate) then
			is_msgno = 'SM-0000001'
			is_msgtrail = luo_subscriber.lastSQLCode + "~r~n" + luo_subscriber.lastSQLErrText
			is_sugtrail = 'Error produced by luo_subscriber.getPercentDiscount()'
			return -1
		end if
		
		if isnull(ld_changePackageDiscountRate) then ld_changePackageDiscountRate = 0
		
		ld_changePackageDiscountRate 	= ld_changePackageDiscountRate / 100
		ld_changePackageDiscount 		= ld_changePackageFee * ld_changePackageDiscountRate
		ld_extendedFeeAmount		 	= ld_changePackageFee - ld_changePackageDiscount
		
		integer li_billingDayOfMonth
		if not f_getBillingDayOfMonth(li_billingDayOfMonth) then
			is_msgno 	= 'SM-0000001'
			is_msgtrail =  string(SQLCA.SQLCode) + "~r~n" + SQLCA.SQLErrText
			is_sugtrail = 'Method: f_getBillingDayOfMonth()'
			return -1
		end if
		
		li_noOfDaysOfTheMonth 		=	guo_func.getMonthDays(li_month)
		ld_mLineCurrentDailyRate		= 	(ld_mlineCurrentMonthlyRate / li_noOfDaysOfTheMonth)
		ld_mLinePreviousDailyRate 	= 	(ld_mlinePreviousMonthlyRate / li_noOfDaysOfTheMonth)
		ld_extCurrentDailyRate		= 	0.00
		ld_extPreviousDailyRate 		= 	0.00
		
		if luo_subscriber.subsTypeCode <> 'CP' then
			
			lb_gotBilledThisMonth = iuo_subscriber.gotBilledThisMonth()
			if lb_gotBilledThisMonth then		
				ll_daysConsumed 		 	= (li_noOfDaysOfTheMonth - integer(string(ldt_tranDate, 'dd'))) + 1
				ld_mlineBaseDailyRate 	= (ld_mLineCurrentDailyRate - ld_mLinePreviousDailyRate)
				ld_extBaseDailyRate	 	= 0.00
			else
				ll_daysConsumed 			= (li_noOfDaysOfTheMonth - integer(string(ldt_tranDate, 'dd'))) + 1
				ld_mlineBaseDailyRate 	= (ld_mLineCurrentDailyRate - ld_mLinePreviousDailyRate)
				ld_extBaseDailyRate	 	= 0.00
			end if
			
			ld_mLineAmount	=	(ll_daysConsumed * ld_mlineBaseDailyRate)
			ld_extAmount		=	0.00
			
		else
			
			if integer(string(ldt_tranDate, 'dd')) < li_billingDayOfMonth then
				ll_daysConsumed 		 = integer(string(ldt_tranDate, 'dd')) - 1
				ld_mlineBaseDailyRate = (ld_mLinePreviousDailyRate - ld_mLineCurrentDailyRate)
			else
				ll_daysConsumed 		 =	(li_noOfDaysOfTheMonth - integer(string(ldt_tranDate, 'dd'))) + 1
				ld_mlineBaseDailyRate = (ld_mLineCurrentDailyRate - ld_mLinePreviousDailyRate)
			end if
			
			ld_mLineAmount	=	(luo_subscriber.numberOfRooms * (luo_subscriber.occupancyRate / 100)) * (ll_daysConsumed * ld_mlineBaseDailyRate) 
		
		end if
		
		if isNull(ld_mLineAmount) then ld_mLineAmount = 0
		
		if luo_subscriber.subscriberStatusCode <> 'APL' then
			
			if not lb_first then ld_extendedFeeAmount = 0
			
			if ld_mLineCurrentMonthlyRate < ld_mLinePreviousMonthlyRate then 	//downgrade
			else
				ld_changePackageFee = 0
				ld_extendedFeeAmount = 0
			end if 
		
			insert into changePackageTranHdr (
							tranNo,	
							tranDate,
							acctNo,
							oldPackageCode,
							newPackageCode,
							daysConsumption,
							mLineCurrentMonthlyRate,
							mLinePreviousMonthlyRate,
							mLineCurrentDailyRate,
							mLinePreviousDailyRate,
							mLineBaseDailyRate,
							mLineAmount,
							extCurrentMonthlyRate,
							extPreviousMonthlyRate,
							extCurrentDailyRate,
							extPreviousDailyRate,
							extBaseDailyRate,
							extAmount,
							changePackageFee,
							changePackageDiscount,
							extendedFeeAmount,
							processed,
							remarks,
							occupancyRate,
							noOfExtension,
							useradd,
							dateadd,
							divisionCode,
							companyCode,
							stbSerialNo)
				  values (
							:is_tranNo,
							:ldt_tranDate,
							:ls_acctno,
							:ls_oldPackageCode,
							:ls_newPackageCode,
							:ll_daysConsumed,
							:ld_mLineCurrentMonthlyRate,
							:ld_mLinePreviousMonthlyRate,
							:ld_mLineCurrentDailyRate,
							:ld_mLinePreviousDailyRate,
							:ld_mLineBaseDailyRate,
							:ld_mLineAmount,
							:ld_extCurrentMonthlyRate,
							:ld_extPreviousMonthlyRate,
							:ld_extCurrentDailyRate,
							:ld_extPreviousDailyRate,
							:ld_extBaseDailyRate,
							:ld_extAmount,
							:ld_changePackageFee,
							:ld_changePackageDiscount,
							:ld_extendedFeeAmount,
							'N',
							:ls_remarks,
							:luo_subscriber.occupancyRate,
							:ll_noOfExt,
							:gs_username,
							getdate(),
							:gs_divisionCode,
							:gs_companyCode,
							:ls_serialNo)
					using SQLCA;
			if SQLCA.SQLCode = -1 then
				is_msgNo    = 'SM-0000001'
				is_msgTrail = "select in select changePackageTranHdr"+"SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
				return -1
			end if
			
		end if
		
		decimal ld_oldSubsDepReq
		
		select subscriptionDepReq
		 	 	into :ld_oldSubsDepReq
		 from arPackageMaster
		 where packageCode = :ls_oldPackageCode
		 and divisionCode = :gs_divisionCode
		 and companyCode = :gs_companyCode
		 using SQLCA;
		
		if isnull(ld_oldSubsDepReq) then ld_oldSubsDepReq = 0
		
		decimal ld_subscriptionDepReq
		--==================================================
		--set subscriber's new package code
		--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		if ls_primary = 'Y' then 
			
			if not luo_subscriber.setPackageCode(ls_newPackageCode) then
				is_msgno = 'SM-0000001'
				is_msgtrail = luo_subscriber.lastSQLCode + "~r~n" + luo_subscriber.lastSQLErrText
				is_sugtrail = 'Error produced by luo_subscriber.setPackageCode()'
				return -1
			end if
			
			
			select packagename into :ls_oldpackagename 
			from arpackagemaster
			where packagecode = :ls_oldpackagecode
			and divisioncode = :gs_divisioncode
			using SQLCA;
			
			select packagename into :ls_newpackagename
			from arpackagemaster
			where packagecode = :ls_newPackageCode
			and divisioncode = :gs_divisioncode
			using SQLCA;
			
			if not luo_subscriber.setMonthlyRate(ld_mLineCurrentMonthlyRate, ld_mLinePreviousMonthlyRate, ld_extCurrentMonthlyRate, ld_extPreviousMonthlyRate) then
				is_msgno = 'SM-0000001'
				is_msgtrail = luo_subscriber.lastSQLCode + "~r~n" + luo_subscriber.lastSQLErrText
				is_sugtrail = 'Error produced by luo_subscriber.setMonthlyRate()'
				return -1
			end if
		
			if not luo_subscriber.getSubscriptionDepReq(ld_subscriptionDepReq) then
				is_msgNo = 'SM-0000001'
				is_msgTrail = luo_subscriber.lastSQLCode + '~r~n~r~n' + luo_subscriber.lastSQLErrText
				is_sugtrail = 'Error produced by luo_subscriber.getSubscriptionDepReq()'
				return -1	
			end if
		else
			select subscriptionDepReq
		 	 	into :ld_subscriptionDepReq
			 from arPackageMaster
			 where packageCode = :ls_newPackageCode
			 and divisionCode = :gs_divisionCode
			 and companyCode = :gs_companyCode
			 using SQLCA;
			
			if isnull(ld_subscriptionDepReq) then ld_subscriptionDepReq = 0		
		end if
		
		
		--banong 09-20-2010
		--for applied accounts only, update assigned package in JO assignment of CPE
		if luo_subscriber.subscriberStatusCode = 'APL' then
			
			update jotrandtlassignedcpe
			set packagecode = :ls_newpackagecode
			where acctno = :ls_acctno
			and newItemCode = null  
			and  newCAItemCode = null
			and serialno = :ls_serialNo
			and divisioncode = :gs_divisioncode
			and companycode = :gs_companycode
			using SQLCA;
			if SQLCA.SQLCode <> 0 then
				is_msgNo = 'SM-0000001'						
				is_msgTrail = string(SQLCA.SQLCode) + '~r~n~r~n' + SQLCA.SQLErrText
				is_sugtrail = 'Unable to Update [jotrandtlassignedcpe]'
				return -1	
			end if
			
		end if
		
				
		if ls_primary = 'Y' then
		
			if luo_subscriber.subscriberStatusCode = 'ACT' then

			
				if ld_oldSubsDepReq < ld_subscriptionDepReq then
					--==================================================
					--Compute for additional subscription deposit req.
					--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
					decimal ld_subsDepReceivable
					if not luo_subscriber.getSubsDepReceivable(ld_subsDepReceivable) then
						is_msgNo = 'SM-0000001'
						is_msgTrail = luo_subscriber.lastSQLCode + '~r~n~r~n' + luo_subscriber.lastSQLErrText
						is_sugtrail = 'Error produced by luo_subscriber.getSubsDepReceivable()'
						return -1	
					end if
					
					decimal ld_subscriptionDeposit
					if not luo_subscriber.getSubscriptionDeposit(ld_subscriptionDeposit) then
						is_msgNo = 'SM-0000001'
						is_msgTrail = luo_subscriber.lastSQLCode + '~r~n~r~n' + luo_subscriber.lastSQLErrText
						is_sugtrail = 'Error produced by luo_subscriber.getSubsDepReceivable()'
						return -1	
					end if
					
					ld_additionalSubsDepReq = (ld_subscriptionDepReq - (ld_subsDepReceivable + ld_subscriptionDeposit))

				end if
			
			else
				
				decimal{2}	ld_ripAmount, ld_paidAmount
				
				if not luo_subscriber.getSubsInitialPaymentAmount_w_paid('APPLYML', luo_subscriber.tranNo, 'OCDEP', ld_ripAmount, ld_paidAmount) then
					is_msgno = 'SM-0000001'
					is_msgtrail = luo_subscriber.lastSQLCode + "~r~n" + luo_subscriber.lastSQLErrText
					is_sugtrail = 'Error produced by luo_subscriber.getSubsInitialPaymentAmount()'
					return -1
				end if
				
				if ld_subscriptionDepReq > ld_ripAmount then
					
					if not luo_subscriber.setRIPAmount('APPLYML', luo_subscriber.tranNo, 'OCDEP', ld_ripAmount + (ld_subscriptionDepReq - ld_ripAmount)) then
						is_msgno = 'SM-0000001'
						is_msgtrail = luo_subscriber.lastSQLCode + "~r~n" + luo_subscriber.lastSQLErrText
						is_sugtrail = 'Error produced by luo_subscriber.setRIPAmount()'
						return -1
					end if
					
				elseif ld_subscriptionDepReq < ld_ripAmount then
	
					if ld_paidAmount = 0 then --unpaid		
					
						if not luo_subscriber.setRIPAmount('APPLYML', luo_subscriber.tranNo, 'OCDEP', ld_subscriptionDepReq) then
							is_msgno = 'SM-0000001'
							is_msgtrail = luo_subscriber.lastSQLCode + "~r~n" + luo_subscriber.lastSQLErrText
							is_sugtrail = 'Error produced by luo_subscriber.setRIPAmount()'
							return -1
						end if
						
					else
						
						string ls_ocTranNo
				
						select tranNo   
						into   :ls_ocTranNo 
						from   arOpenCreditMaster 
						where  ocTypeCode = 'SUBSDEP' 
						and    acctNo     = :ls_acctNo
						and    divisionCode = :gs_divisionCode
						and    companyCode  = :gs_companyCode
						and    amount       = :ld_ripAmount 
						using  SQLCA;
						if SQLCA.SQLCode <> 0 then
							is_msgNo 	= 'SM-0000001'
							is_msgTrail	= 'Error reading reading current deposit...' + &
											  '~r~nSQL Error Code : ' + string(SQLCA.SQLCode)+ &
											  '~r~nSQL Error Text : ' + SQLCA.SQLErrText
											  return -1
						end if	
									
						istr.s_string1 = is_serviceType
						istr.s_string2 = ls_acctNo
						istr.s_string3 = ls_ocTranNo
						istr.d_amount  = ld_ripAmount - ld_subscriptionDepReq 			
						
						ib_forReclassifyOC = true			
						
					end if  --paid or not						
						
				end if --dep req > curr dep 
				
			end if --active/applied
			
			if POS(ls_oldpackagename,'IBIZ',1) > 0 and POS(ls_newpackagename,'MICROBIZ',1) > 0 THEN
				ls_relockin = 'Y'
			ELSEIF (POS(ls_oldpackagename,'FTTH',1) > 0 OR POS(ls_oldpackagename,'FTTX',1) > 0) and (POS(ls_newpackagename,'FIBERX',1) > 0 OR POS(ls_newpackagename,'FIBER X',1) > 0) THEN
				ls_relockin = 'Y'
			ELSEIF (POS(ls_oldpackagename,'FAB',1) > 0 ) and (POS(ls_newpackagename,'1188',1) > 0 OR POS(ls_newpackagename,'1488',1) > 0) THEN
				ls_relockin = 'Y'
			ELSEIF (POS(ls_oldpackagename,'AIR',1) > 0 OR POS(ls_oldpackagename,'EXCEED',1) > 0 OR POS(ls_oldpackagename,'FAB',1) > 0) and (POS(ls_newpackagename,'IBIZ',1) > 0) THEN
				ls_relockin = 'Y'
			ELSE
				ls_relockin  = 'N'
			END IF
			
			if ls_relockin = 'Y' then
				
				update aracctsubscriber
				set daterelockin = sysdate
				where acctno = :ls_acctno
				and divisioncode = :gs_divisioncode
				using SQLCA;
				
			end if
			
		end if	--primary
		--=====================================================================================================================
		--
		-- 								 time to extract open credits and ar balances at the same time apply
		--
		-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		
		uo_subs_advar.setAcctNo(ls_acctNo)
		
		if not uo_subs_advar.getOcNextTranNo() then
			is_msgno = 'SM-0000001'
			is_msgtrail = uo_subs_advar.lastSQLCode + "~r~n" + uo_subs_advar.lastSQLErrText
			is_sugtrail = 'Error produced by uo_subs_advar.getOcNextTranNo()'
			return -1
		end if
		
		if not uo_subs_advar.setParentTranNo(is_tranNo) then
			is_msgno = 'SM-0000001'
			is_msgtrail = uo_subs_advar.lastSQLCode + "~r~n" + uo_subs_advar.lastSQLErrText
			is_sugtrail = 'Error produced by uo_subs_advar.setParentTranNo()'
			return -1
		end if
		
		if not uo_subs_advar.setParentTranTypeCode(is_transactionID) then
			is_msgno = 'SM-0000001'
			is_msgtrail = uo_subs_advar.lastSQLCode + "~r~n" + uo_subs_advar.lastSQLErrText
			is_sugtrail = 'Error produced by uo_subs_advar.setParentTranTypeCode()'
			return -1
		end if
		
		--I added lb_first here - to charge CHGPF only once!!! - I ordered revision for this 100% 
		--I ended up coding this up mylsef!  08202010
	
	--ray 02-17-2012	
	--if upgrade it will pass this condition if downgrade it will go through this condition	
	if ld_mLineCurrentMonthlyRate < ld_mLinePreviousMonthlyRate then 	//downgrade
		if  (luo_subscriber.subscriberStatusCode <> 'APL') and lb_first then 
			
				if not uo_subs_advar.insertNewAr(is_tranno, is_transactionID, 'CHGPF', ld_extendedFeeAmount, ldt_trandate, ls_arRemarks) then
					is_msgno = 'SM-0000001'
					is_msgtrail = uo_subs_advar.lastSQLCode + "~r~n" + uo_subs_advar.lastSQLErrText
					is_sugtrail = 'Error produced by uo_subs_advar.insertNewAr()'
					return -1
				end if
				
		end if 
			string ls_unearnedAccount, ls_errorMessage
			
			lb_first = false //zar 08-20-2010 - i order for the revision 100% -> what happened ? I dont know!!!
		
		
		end if
		
		if not uo_subs_advar.applyOpenCreditMultiple('', '') then
			is_msgno = 'SM-0000001'
			is_msgtrail = uo_subs_advar.lastSQLCode + "~r~n" + uo_subs_advar.lastSQLErrText
			is_sugtrail = 'Error produced by uo_subs_advar.applyApplAdvToBalances()'
			return -1
		end if
		
		if not uo_subs_advar.setOcTranNo() then
			is_msgno = 'SM-0000001'
			is_msgtrail = uo_subs_advar.lastSQLCode + "~r~n" + uo_subs_advar.lastSQLErrText
			is_sugtrail = 'Error produced by uo_subs_advar.setOcTranNo()'
			return -1
		end if
		
		if not uo_subs_advar.postOpenCreditUpdates() then
			is_msgno = 'SM-0000001'
			is_msgtrail = uo_subs_advar.lastSQLCode + "~r~n" + uo_subs_advar.lastSQLErrText
			is_sugtrail = 'Error produced by uo_subs_advar.postOpenCreditUpdates()'
			return -1
		end if
		
		if not uo_subs_advar.postArUpdates() then
			is_msgno = 'SM-0000001'
			is_msgtrail = uo_subs_advar.lastSQLCode + "~r~n" + uo_subs_advar.lastSQLErrText
			is_sugtrail = 'Error produced by uo_subs_advar.postArUpdates()'
			return -1
		end if
		
		if not uo_subs_advar.postApplicationOfOpenCredit() then
			is_msgno = 'SM-0000001'
			is_msgtrail = uo_subs_advar.lastSQLCode + "~r~n" + uo_subs_advar.lastSQLErrText
			is_sugtrail = 'Error produced by uo_subs_advar.postApplicationOfOpenCredit()'
			return -1
		end if
		
		--=====================================================================================================================
		--
		-- 								 					end of extraction and application
		--
		-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		
		

		
		// =================================================
		// post GL Entries
		// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		if not iuo_glPoster.postGLEntries() then
			is_msgno 	= 'SM-0000001'
			is_msgtrail =  iuo_glPoster.errorMessage
			is_sugtrail = iuo_glPoster.suggestionRemarks
			return -1
		end if
		
		ll_tranno ++
		
//	end if
next	

ll_tranno --

if not guo_func.set_number(is_transactionID, ll_tranNo) then
	return -1
end if

is_msgno = "SM-0000002"
is_msgtrail = ''
is_sugtrail = ''

return 0

--END BUTTON SAVE