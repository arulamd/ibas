opensheetwithparm(w_change_package, 'CTV', w_mdiFrame, 0, original!)


--EVENT OPEN FORM

is_serviceType = message.stringParm
is_serviceType = CTV

uo_center_window luo_center_window
luo_center_window = create uo_center_window
luo_center_window.f_center(this)


iuo_subscriber = create uo_subscriber_def

--END EVENT

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
        
--EVENT UE_SEARCH ACCTNO
        
string ls_search, ls_result, ls_serviceAddress, ls_oldPackageCode, ls_msg
long ll_row
decimal{2} ld_changePackageFee, ld_packageRate
str_search str_s

ls_search = trim(as_search)
ll_row = dw_header.getrow()

ib_is_flexibiz = False

choose case ls_search
	case "acct_no"
		str_s.serviceType = is_serviceType
		
		--QUERY FORM SEARCH ACCTNO
		
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

		--END QUERY
		
		openwithparm(w_search_subscriber,str_s)	
		
		ls_result = trim(message.stringparm)
		
		if ls_result <> '' then			
			
			if not iuo_subscriber.setAcctNo(ls_result) then
				guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + iuo_subscriber.lastSQLErrText)
				return 0
			end IF
			
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
			
			if is_isDigital <> 'Y' then
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
				
				
				
				string ls_packagetypecode_old
				decimal{2} ld_curr_mrc
				
				select packagetypecode, monthlyrate into :ls_packagetypecode_old, :ld_curr_mrc
				from arpackagemaster 
				where packagecode = :iuo_subscriber.packageCode
				and divisioncode = :gs_divisioncode
				and companycode = :gs_companycode
				using SQLCA;
				
				dw_header.setitem(ll_row,'oldmrc',ld_curr_mrc)
				
			else
				parent.triggerevent("ue_cancel")	
				guo_func.msgBox("ATTENTION","Only subscriber that has analog package can use this transaction.")
			end if
			
		end if
		
	case "package"
		
		if this.getItemString(ll_row,'acctno') <> '' then
			str_s.s_dataobject = "dw_search_package_master"
			str_s.s_return_column = "packagecode"
			str_s.s_title = "Search For ARPackageMaster"
			
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
			
			str_s.s_1 = 'N'
			str_s.s_2 = is_serviceType
			str_s.s_3 = gs_divisionCode
			str_s.s_4 = is_isDigital
			
			ls_oldPackageCode = trim(iuo_subscriber.packageCode)
			
			openwithparm(w_search_ancestor,str_s)
			ls_result = trim(message.stringparm)
			
			string ls_packagetypecode_new
			
			if ls_result <> '' then			
				
				decimal{2} ld_new_mrc
				select packagetypecode, monthlyrate into :ls_packagetypecode_new, :ld_new_mrc
				from arpackagemaster 
				where packagecode = :ls_result
				and divisioncode = :gs_divisioncode
				and companycode = :gs_companycode
				using SQLCA;
				
				dw_header.setitem(ll_row,'newmrc',ld_new_mrc)
				
				if ls_packagetypecode_old = 'IPT'  then
					
					if ls_packagetypecode_new <> 'IPT' then
						guo_func.msgbox("ATTENTION","The package you've selected must be also an IPTV Package. Please select the right package for this account")
						return -1
					end if
					
					
				end if 
				
				IF iuo_subscriber.packageCode = "MB806" OR &
					iuo_subscriber.packageCode = "MB807" OR &
					iuo_subscriber.packageCode = "MB809" OR &
					iuo_subscriber.packageCode = "MB810" OR &
					iuo_subscriber.packageCode = "MB811" OR &
					iuo_subscriber.packageCode = "LEM01" OR &
					iuo_subscriber.packageCode = "LEM02" OR &
					iuo_subscriber.packageCode = "MB812" OR &
					iuo_subscriber.packageCode = "MB813" OR &
					iuo_subscriber.packageCode = "MB815" OR &
					iuo_subscriber.packageCode = "MB816" THEN
				
					 ib_is_flexibiz = TRUE
					 
				END IF
				
				if ib_is_flexibiz then
					decimal{2} ld_old_mrc, ld_total_balance
					
					select monthlyrate into :ld_old_mrc
					from arPackagemaster
					where packagecode = :ls_oldPackageCode
					and divisioncode = :gs_divisioncode
					and companycode = :gs_companycode
					using SQLCA;
					
					if ld_new_mrc >  ld_old_mrc then
						
						select sum(balance) into :ld_total_balance
						from artranhdr
						where acctno = :iuo_subscriber.acctno
						and divisioncode = :gs_divisioncode
						and companycode = :gs_companycode
						using SQLCA;
						
						if ld_total_balance > 0 then
							guo_func.msgbox("ATTENTION","Account has an outstanding balance. Cannot proceed upgrade.")
							return -1
						end if
						
						
					end if
					
				
				end if
				
				
				
				
				if ls_result = ls_oldPackageCode then
					guo_func.MsgBox('Error in package...','Old package and New package must not be the same...')
					return -1
				end if	
				
				string ls_packageDesc, ls_packageName2 , ls_clientClassValue
				
				select packageName, packageDescription, monthlyRate , clientClassValue
				into :ls_packageName2, :ls_packageDesc, :ld_packageRate, :ls_clientClassValue
				from arPackageMaster
				where packageCode = :ls_result
				and divisionCode = :gs_divisionCode
				and companyCode = :gs_companyCode
				using SQLCA;
				
				
				long ctr_packages, ctr_packages_old
				string ls_itemcode, ls_itemname
				
				select count(packagecode), itemcode into :ctr_packages, :ls_itemcode
				from gamechanger_packages
				where packagecode = :ls_result
				group by itemcode
				using SQLCA;
				
				
				select count(packagecode) into :ctr_packages_old
				from gamechanger_packages
				where packagecode = :iuo_subscriber.packageCode
				using SQLCA;
				
				if ctr_packages > 0 and ctr_packages_old = 0 then
					is_gamechanger = 'Y'
					
					select itemname into :ls_itemname
					from itemmaster
					where itemcode = :ls_itemcode
					and companycode = :gs_companycode
					using SQLCA;
					
					this.setItem(1,'itemcode', ls_itemcode)
					this.setItem(1,'itemname', ls_itemname)
					
					this.object.gb_addon.visible = true
					this.object.itemcode.visible = true
					this.object.itemname.visible = true
					this.object.installation_type.visible = true
					this.object.delivery_option.visible = true
					this.object.t_install_type.visible = true
					this.object.t_delivery_option.visible = true
					
				else
					is_gamechanger = 'N'
					
					this.setItem(1,'itemcode', '')
					this.setItem(1,'itemname', '')
					
					this.object.gb_addon.visible = FALSE
					this.object.itemcode.visible = FALSE
					this.object.itemname.visible = FALSE
					this.object.installation_type.visible = FALSE
					this.object.delivery_option.visible = FALSE
					this.object.t_install_type.visible = FALSE
					this.object.t_delivery_option.visible = FALSE
				
				end if
				
				if  is_serviceType = 'INET' then 
				
				if isNull(ls_clientClassValue) then
					guo_func.msgbox("ATTENTION","The package you've selected has no CLIENTCLASSVALUE. Therefore it must be relayed to Marketing / SysAd Department.")
					return -1
				end if
				
			end if
			
				dw_header.setitem(ll_row,'newpackageCode', ls_result)		
				dw_header.setitem(ll_row,'newpackageName', ls_packageName2)	
				dw_header.setitem(ll_row,'newpackageDesc', ls_packageDesc)	
				
				if ld_packageRate < iuo_subscriber.mLineCurrentMonthlyRate then
							this.object.waive_downgradefee.visible = True
							this.setItem(ll_row,'waive_downgradefee','N')
				else
					this.object.waive_downgradefee.visible = False
					this.setItem(ll_row,'waive_downgradefee','N')
				end if
				
				
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
							
						--END VALIDASI
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
				END IF
				//----------------------------------------------------------			
				// validate policy on no of months a/r min requirement - end
				//----------------------------------------------------------
				
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

string 		ls_oldPackageCode, ls_newPackageCode, ls_acctno, ls_remarks, ls_arRemarks, ls_serialNo
datetime 	ldt_tranDate, ldt_daterelockin
decimal{2} 	ld_changePackageFee, ld_changePackageDiscount, ld_changePackageDiscountRate, ld_extendedFeeAmount
decimal{2} 	ld_mlinePreviousMonthlyRate, ld_extPreviousMonthlyRate, ld_mlineCurrentMonthlyRate, ld_extCurrentMonthlyRate
decimal{2} 	ld_mLineCurrentDailyRate, ld_mlineBaseDailyRate, ld_mLinePreviousDailyRate, ld_mLineAmount
decimal{2} 	ld_extCurrentDailyRate, ld_extBaseDailyRate, ld_extPreviousDailyRate, ld_extAmount, ld_additionalSubsDepReq
long 		ll_tranNo, ll_noOfExt, ll_daysConsumed
integer		li_noOfDaysOfTheMonth, li_month, li_ctr
boolean	lb_gotBilledThisMonth
string ls_oldpackagename, ls_newpackagename, ls_relockin, ls_waive_downgrade_fee

ib_forReclassifyOC = false

if not guo_func.get_nextNumber(is_transactionID, ll_tranNo, "WITH LOCK") then			
	return -1
end if	

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
 
ldt_tranDate			= guo_func.getServerDatetime()
li_month				   = month(date(ldt_tranDate))
is_tranno				= string(ll_tranno,'00000000')
ls_acctno				= trim(dw_header.getitemString(1, 'acctno'))
ls_oldPackageCode		= trim(dw_header.getitemString(1, 'oldPackagecode'))
ls_newPackageCode 	= trim(dw_header.getitemString(1, 'newPackageCode'))
ls_remarks				= trim(dw_header.getitemString(1, 'remarks'))	
is_acctNo				= ls_acctNo
ls_waive_downgrade_fee = dw_header.getItemString(1,'waive_downgradefee')


if is_gamechanger = 'Y' then
	
	string ls_delivery_option , ls_install_type, ls_tranno_sales, ls_itemcode
	long ll_tranNo_sales
	decimal{2} ld_delivery_fee, ld_installation_fee, ldc_mrc
	string ls_jono
	
	ls_delivery_option = dw_header.getItemString(1,'delivery_option')
	ls_install_type = dw_header.getItemString(1,'installation_type')
	ls_itemcode = dw_header.getItemString(1,'itemcode')
	
	if ls_delivery_option = 'DELIVERY' then ld_delivery_fee = 200.00
	if ls_install_type = 'INSTALL' then ld_installation_fee = 1300.00	
	
	select monthlyrate into :ldc_mrc
	from arpackagemaster 
	where packagecode = :ls_newPackagecode
	and divisioncode = :gs_divisioncode
	and companycode= :gs_companycode
	using SQLCA;
	
	if ldc_mrc > 3500 then
		ld_delivery_fee = 0.00
		ld_installation_fee = 0.00
	end if
	
	if ls_delivery_option = '' or isnull(ls_delivery_option) then
		is_msgNo = ''
		is_msgTrail = 'Delivery Option was not specified.'
		is_sugTrail = 'Please select the delivery option of the Add On.'	
		return -1
	end if
	
	if ls_install_type = '' or isnull(ls_install_type) then
		is_msgNo = ''
		is_msgTrail = 'Installation type was not specified.'
		is_sugTrail = 'Please select the installation type of the Add On.'	
		return -1 
	end if
	
	if not guo_func.get_nextNumber('SALES', ll_tranNo_sales, "WITH LOCK") then			
		return -1
	end if	
	
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
	
	ls_tranno_sales		=	string(ll_tranNo_sales, '00000000')
	
	if trigger Event ue_create_jo_add_on(ls_acctno, ls_delivery_option,ls_tranno_sales, ls_jono, ls_install_type,'O') < 0 then
					is_msgNo    = 'SM-0000001' 
					is_msgTrail = 'Error Insert in Jotranhdr' + &
					  '~r~nSQLCode     : ' + string(SQLCA.SQLCode)   + & 
					  '~r~nSQLErrText  : ' + SQLCA.SQLErrText        + &	
					  '~r~nSQLDBCode   : ' + String(SQLCA.SQLDBCode) + &
					  '~r~n~r~nA RollBack will Follow...'
					  return -1		
	end if 
	
	--VALIDASI UE_CREATE_JO_ADD_ON
	
	string ls_trantypecode
		string ls_jostatuscode
		
		if as_deliveryoptions = 'PICK UP LATER' then
			ls_trantypecode = 'ADDONP'
		end if 
		if as_deliveryoptions = 'DELIVERY' and as_installation_type = 'DIY' then
			ls_trantypecode = 'ADDOND'
		end if 
		if as_deliveryoptions = 'DELIVERY' and as_installation_type = 'INSTALL' then	
			ls_trantypecode = 'ADDONDI'
		end if 
		
		ls_jostatuscode = 'OQ'
		
		if as_mop = 'D' then
			ls_jostatuscode = 'DP'
		end if
		
		select REPLACE('AO'||to_char(ADD_ON_PICKUP_SEQ.nextval,'000000'),' ','') into :as_jono FROM DUAL using SQLCA;
			
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
							IS_AUTO_CREATE)
				  values (
							:as_jono,
							getDate(),
							:ls_tranTypeCode,
							:as_acctno,
							'00013',
							:as_refno,
							:ls_jostatuscode,
							null,
							null,
							null,
							:gs_username,
							getdate(),
							:gs_divisionCode,
							:gs_companyCode,
							null,
							null,
							null,
							null,
							'AUTO CREATE JO VIA SALES ADD ON',
							'Y')
					using SQLCA;
			if SQLCA.sqlcode <> 0 then
				return -1
			end if
		
		COMMIT USING SQLCA;
		
		return 0
	
	--END VALDIASI UE_CREATE_JO_ADD_ON
	

	
	
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
	  			:ls_tranno_sales,
				sysdate,
				:ls_acctno,
				'-',
				0.00,
				0.00,
				0.00,	
				'SALES',
				'00013',
				:gs_username,
				:ldt_tranDate,
				:gs_divisionCode,
				:gs_companyCode,
				:ls_jono,
				'OG',
				'O',
				NULL,
				:ls_delivery_option,
				:ls_install_type,
				:ld_delivery_fee,
				:ld_installation_fee)
		using SQLCA;
	
	
	INSERT INTO SOLD_ADD_ON_ITEMS
							(TRANNO,acctno, ITEMCODE, SERIALNO, DIVISIONCODE, COMPANYCODE, USERADD, DATEADD, JONO, ISIPTV, USED)
							VALUES
							(:ls_tranno_sales, :ls_acctno,:ls_itemCode, '', :gs_divisioncode, :Gs_companycode, :gs_username, sysdate, :ls_jono, 'N', 'N')
							using SQLCA;
	
	if not guo_func.set_number('SALES', ll_tranNo_sales) then
		return -1 
	end if	
	
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
		
		return TRUE
		
--END set_number

end if

If ls_newPackagecode = '' or IsNull(ls_newPackagecode) Then
	is_msgNo = ''
	is_msgTrail = 'New package was not specified.'
	is_sugTrail = 'Please select the new package of the subscriber.'	
	return -1
End If


--NOT USE ANYMORE
if not iuo_glPoster.initialize(is_transactionID, is_tranNo, ldt_tranDate) then
	is_msgno 	= 'SM-0000001'
	is_msgtrail = iuo_glPoster.errorMessage
	is_sugtrail = iuo_glPoster.suggestionRemarks
	return -1
end if
uo_subs_advar.setGLPoster(iuo_glPoster)
--END NOT USE ANYMORE

uo_subscriber_def luo_subscriber
luo_subscriber = create uo_subscriber_def

if not luo_subscriber.setAcctNo(ls_acctNo) then
	is_msgNo = 'SM-0000001'
	is_msgTrail = luo_subscriber.lastSQLCode + '~r~n~r~n' + luo_subscriber.lastSQLErrText
	is_sugTrail = ''	
	return -1
end IF

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

if not luo_subscriber.getnoofactiveext(ll_noOfExt) then
	is_msgNo = 'SM-0000001'
	is_msgTrail = luo_subscriber.lastSQLCode + '~r~n~r~n' + luo_subscriber.lastSQLErrText
	is_sugTrail = ''	
	return -1
end IF

--VALIDASI GETNOOFACTIVEEXT
		
	lastMethodAccessed = 'getNoOfExt'

	select count(acctNo)
	  into :al_noofext
	  from subscriberCPEMaster
	 where acctNo = :acctNo and acctNo is not null
	 	and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	and cpeStatusCode = 'AC'
	 group by acctNo 
	 using SQLCA;
	if SQLCA.sqlcode < 0 then
		lastSQLCode = string(SQLCA.sqlcode)
		lastSQLErrText = SQLCA.sqlerrtext
		return FALSE
	elseif SQLCA.sqlcode = 100 then
		al_noofext = 0
	end if
	
	if al_noofext > 0 then
		if substypecode <> 'CP' then
			al_noofext = al_noofext - 1
		else
			al_noofext = 0
		end if
		///al_noofext = al_noofext - 1
	end if
	return TRUE


--END VALIDASI GETNOOFACTIVEEXT

if not luo_subscriber.getMLineMonthlyRate(ld_mlinePreviousMonthlyRate) then
	is_msgNo = 'SM-0000001'
	is_msgTrail = luo_subscriber.lastSQLCode + '~r~n~r~n' + luo_subscriber.lastSQLErrText
	is_sugtrail = 'Error produced by luo_subscriber.getMLineMonthlyRate()'
	return -1
end IF

--VALIDASI getMlineMonthlyRate
		lastMethodAccessed = 'getMLineMonthlyRate'
	
	select monthlyRate
	  into :ad_mlineMonthlyRate
	  from arPackageMaster
	 where packageCode = :packageCode
	 and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	using SQLCA;
	if SQLCA.sqlcode <> 0 then
		lastSQLCode = string(SQLCA.sqlcode)
		lastSQLErrText = SQLCA.sqlerrtext
		return FALSE
	end if
	return TRUE

	--END getMlineMonthlyRate

if not luo_subscriber.getExtMonthlyRate(ld_extPreviousMonthlyRate) then
	is_msgNo = 'SM-0000001'
	is_msgTrail = luo_subscriber.lastSQLCode + '~r~n~r~n' + luo_subscriber.lastSQLErrText
	is_sugtrail = 'Error produced by luo_subscriber.getExtMonthlyRate()'
	return -1
end IF

--VALIDASI GETEXTMONTHLYRATE
	
	lastMethodAccessed = 'getExtMonthlyRate'

		if isDigital  <> 'Y'  then
		
			select extMonthlyRate
			  into :ad_extMonthlyRate
			  from arPackageMaster
			 where packageCode = :packageCode
			 and divisionCode = :gs_divisionCode
				and companyCode = :gs_companyCode
				using SQLCA;
			if SQLCA.sqlcode <> 0 then
				lastSQLCode = string(SQLCA.sqlcode)
				lastSQLErrText = SQLCA.sqlerrtext
				return FALSE
			end if
			
		else
			
			select sum(monthlyRate)
			  into :ad_extMonthlyRate
			  from arPackageMaster
			  inner join subscriberCPEMaster on arPackageMaster.packageCode = subscriberCPEMaster.packageCode
			  	and arPackageMaster.divisionCode = subscriberCPEMaster.divisionCode
				and arPackageMaster.companyCode = subscriberCPEMaster.companyCode
			 //where arPackageMaster.packageCode <> :packageCode --zar 12/08/2009 12am
			 where subscriberCPEMaster.isPrimary <> 'Y'
			 and subscriberCPEMaster.acctNo = :acctNo
			 and arPackageMaster.divisionCode = :gs_divisionCode
			 and arPackageMaster.companyCode = :gs_companyCode
			using SQLCA;
			if SQLCA.sqlcode <> 0 then
				lastSQLCode = string(SQLCA.sqlcode)
				lastSQLErrText = SQLCA.sqlerrtext
				return FALSE
			end if
			
			if isnull(ad_extMonthlyRate) then ad_extMonthlyRate = 0
			
			
		end if
		return TRUE

	
	--END VALIDASI GETEXTMONTHLYRATE

if not luo_subscriber.getNewMLineMonthlyRate(ls_newPackageCode, ld_mlineCurrentMonthlyRate) then
	is_msgNo = 'SM-0000001'
	is_msgTrail = luo_subscriber.lastSQLCode + '~r~n~r~n' + luo_subscriber.lastSQLErrText
	is_sugtrail = 'Error produced by luo_subscriber.getNewMLineMonthlyRate()'
	return -1
end IF

--VALIDASI LIO_SUBSCRIBER.GETNEWMLINEMONTHLYRATE
lastMethodAccessed = 'getNewMLineMonthlyRate'

select monthlyRate
  into :ad_mlineMonthlyRate
  from arPackageMaster
 where packageCode = :as_newPackageCode
 and divisionCode = :gs_divisionCode
and companyCode = :gs_companyCode
using SQLCA;
if SQLCA.sqlcode <> 0 then
	lastSQLCode = string(SQLCA.sqlcode)
	lastSQLErrText = SQLCA.sqlerrtext
	return FALSE
end if
return TRUE

--END VALIDASI  GETNEWMLINEMONTHLYRATE

if not luo_subscriber.getNewExtMonthlyRate(ls_newPackageCode, ld_extCurrentMonthlyRate) then
	is_msgNo = 'SM-0000001'
	is_msgTrail = luo_subscriber.lastSQLCode + '~r~n~r~n' + luo_subscriber.lastSQLErrText
	is_sugtrail = 'Error produced by luo_subscriber.getNewExtMonthlyRate()'
	return -1
end IF

--VALIDASI GETNEWEXTMONTHLYRATE
lastMethodAccessed = 'getNewExtMonthlyRate'

select extMonthlyRate
  into :ad_extmonthlyrate
  from arPackageMaster
 where packageCode = :as_newPackageCode
 and divisionCode = :gs_divisionCode
and companyCode = :gs_companyCode
using SQLCA;
if SQLCA.sqlcode <> 0 then
	lastSQLCode = string(SQLCA.sqlcode)
	lastSQLErrText = SQLCA.sqlerrtext
	return FALSE
end if
return TRUE

--END VALIDASI GETNEWEXTMONTHLYRATE

if not luo_subscriber.getChangePackageFee(ld_changePackageFee) then
	is_msgNo = 'SM-0000001'
	is_msgTrail = luo_subscriber.lastSQLCode + '~r~n~r~n' + luo_subscriber.lastSQLErrText
	is_sugtrail = 'Error produced by luo_subscriber.getChangePackageFee()'
	return -1
end IF

--VALIDASI GETCHANGEPAKACKAGEFEE
lastMethodAccessed = 'getChangePackageFee'

date ldt_startdate, ldt_sysdate
long ll_noofdays

IF subsTypeCode = 'RE' or subsTypeCode = 'CO' then
	if isnull(daterelockin) then
		ldt_startdate = date(dateinstalled)
	else
		ldt_startdate = date(daterelockin)		
	end if 
	
	select sysdate into :ldt_sysdate	from dual
	using SQLCA;
	
	
	ll_noofdays = daysafter(ldt_startdate, ldt_sysdate)
	
	//check if subs is within lockin
	if ll_noofdays <= 730 then
		select changePackageFee
		  into :ad_changePackageFee
		  from arPackageMaster
		 where packageCode = :packageCode
		 and divisionCode = :gs_divisionCode
			and companyCode = :gs_companyCode
			using SQLCA;
		if SQLCA.sqlcode < 0 then
			lastSQLCode = string(SQLCA.sqlcode)
			lastSQLErrText = SQLCA.sqlerrtext
			return FALSE
		elseif SQLCA.sqlcode = 100 then
			lastSQLCode = string(SQLCA.sqlcode)
			lastSQLErrText = "The package code: " + packageCode + " does not exist in arPackageMaster table "
			return FALSE
		end if
		return TRUE
	else 
		ad_changepackagefee = 0
	end if

else
		
		
		select changePackageFee
		  into :ad_changePackageFee
		  from arPackageMaster
		 where packageCode = :packageCode
		 and divisionCode = :gs_divisionCode
			and companyCode = :gs_companyCode
			using SQLCA;
		if SQLCA.sqlcode < 0 then
			lastSQLCode = string(SQLCA.sqlcode)
			lastSQLErrText = SQLCA.sqlerrtext
			return FALSE
		elseif SQLCA.sqlcode = 100 then
			lastSQLCode = string(SQLCA.sqlcode)
			lastSQLErrText = "The package code: " + packageCode + " does not exist in arPackageMaster table "
			return FALSE
		end if
end if
return TRUE


--END VALIDASI GETCHANGEPAKACKAGEFEE

if ls_waive_downgrade_fee = 'Y' then
	ld_changePackageFee = 0.00
end if

if not luo_subscriber.getPercentDiscount('CHGPF', ld_changePackageDiscountRate) then
	is_msgno = 'SM-0000001'
	is_msgtrail = luo_subscriber.lastSQLCode + "~r~n" + luo_subscriber.lastSQLErrText
	is_sugtrail = 'Error produced by luo_subscriber.getPercentDiscount()'
	return -1
end IF

--VALIDASI getPercentDiscount

lastMethodAccessed = 'getPercentDiscount'

select percentDiscount
  into :ad_percent
  from chargeTypeDiscountMaster
 where chargeTypeCode = :chargeTypeCode
 	and divisionCode = :gs_divisionCode
and companyCode = :gs_companyCode
and arTypeCode = :as_arTypeCode
 using SQLCA;
if SQLCA.sqlcode < 0 then
	lastSQLCode = string(SQLCA.sqlcode)
	lastSQLErrText = SQLCA.sqlerrtext
	return FALSE
elseif SQLCA.sqlcode = 100 then
	ad_percent = 0
end if
return TRUE


--END VALIDASI getPercentDiscount


--check if subs contract expired - if yes change package fee is free else 1000


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
end IF

--VALIDASI F_GETBILLINGDAYOFMONTH

select billingDayOfMonth
  into :ad_day
  from systemParameter
  where divisionCode = :gs_divisionCode
and companyCode = :gs_companyCode
and rownum < 2
using SQLCA;
if SQLCA.sqlCode < 0 then
	return FALSE
end if

--default to every 10th of the month
if isnull(ad_day) or ad_day = 0 then ad_day = 10

return TRUE

--END VALIDASI G_GETBILLINGDAYOFMONTH

li_noOfDaysOfTheMonth 		=	guo_func.getMonthDays(li_month)
ld_mLineCurrentDailyRate		= 	(ld_mlineCurrentMonthlyRate / li_noOfDaysOfTheMonth)
ld_mLinePreviousDailyRate 	= 	(ld_mlinePreviousMonthlyRate / li_noOfDaysOfTheMonth)
ld_extCurrentDailyRate		= 	(ld_extCurrentMonthlyRate / li_noOfDaysOfTheMonth)
ld_extPreviousDailyRate 		= 	(ld_extPreviousMonthlyRate / li_noOfDaysOfTheMonth)

if luo_subscriber.subsTypeCode <> 'CP' then
	
	lb_gotBilledThisMonth = iuo_subscriber.gotBilledThisMonth()
	if lb_gotBilledThisMonth then		
		ll_daysConsumed 		 	= (li_noOfDaysOfTheMonth - integer(string(ldt_tranDate, 'dd'))) + 1
		ld_mlineBaseDailyRate 	= (ld_mLineCurrentDailyRate - ld_mLinePreviousDailyRate)
		ld_extBaseDailyRate	 	= (ld_extCurrentDailyRate - ld_extPreviousDailyRate)
	else
		ll_daysConsumed 			= (li_noOfDaysOfTheMonth - integer(string(ldt_tranDate, 'dd'))) + 1
		ld_mlineBaseDailyRate 	= (ld_mLineCurrentDailyRate - ld_mLinePreviousDailyRate)
		ld_extBaseDailyRate	 	= (ld_extPreviousDailyRate - ld_extCurrentDailyRate)
	end if
	
	ld_mLineAmount	=	(ll_daysConsumed * ld_mlineBaseDailyRate)
	ld_extAmount		=	(ll_daysConsumed * ld_extBaseDailyRate * ll_noOfExt)
	
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
	
	if ld_mLineCurrentMonthlyRate < ld_mLinePreviousMonthlyRate then 	//downgrade
		if ls_oldPackageCode = 'RE095' OR ls_oldPackageCode = 'RE096' OR &
				ls_oldPackageCode = 'RE097' OR 	ls_oldPackageCode = 'RE098'  OR &
					ls_oldPackageCode = 'RE099' OR ls_oldPackageCode = 'RE100' OR & 
					ls_oldPackageCode = 'RE101' OR ls_oldPackageCode = 'RE102' OR & 
					ls_oldPackageCode = 'RE103' OR ls_oldPackageCode = 'RE104' OR &
						ls_oldPackageCode = 'RE105' OR 	ls_oldPackageCode = 'RE106' THEN
			
					is_msgNo    = 'SM-0000001'
		is_msgTrail = "This package is not allowed for downgrade transaction."
		return -1
	END IF

	else
			
			ld_changePackageFee = 0
			ld_extendedFeeAmount = 0
	end if 
	
	string ls_processed
	
	ls_processed = 'N'
	if ld_mLineCurrentMonthlyRate = ld_mLinePreviousMonthlyRate then
		ls_processed = 'Y'
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
					:ls_processed,
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
	
	
	
else 
	
	
	
	insert into CHANGEPACKAGETRANHDR_APL (
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
		is_msgTrail = "select in select changePackageTranHdr_APL"+"SQLCode    : "+string(SQLCA.SQLCode) + "SQLErrText : " + SQLCA.SQLErrText
		return -1
	end if
	
end if

--==================================================
-- set subscriber's old package code to get the
-- subscription dep req for comparison
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if not luo_subscriber.setPackageCode(ls_oldPackageCode) then
	is_msgno = 'SM-0000001'
	is_msgtrail = luo_subscriber.lastSQLCode + "~r~n" + luo_subscriber.lastSQLErrText
	is_sugtrail = 'Error produced by luo_subscriber.setPackageCode()'
	return -1
end IF

--VALIDASI setPackageCode

lastMethodAccessed = 'setPackageCode'

update arAcctSubscriber
	set packageCode = :as_packageCode
 where acctNo = :acctNo
 and divisionCode = :gs_divisionCode
and companyCode = :gs_companyCode
using SQLCA;
if SQLCA.sqlcode <> 0 then
	lastSQLCode = string(SQLCA.sqlcode)
	lastSQLErrText = SQLCA.sqlerrtext
	return FALSE
end if

packageCode = as_packageCode

return TRUE

--END VALIDASI setPackageCode

select packagename into :ls_oldpackagename 
from arpackagemaster
where packagecode = :ls_oldpackagecode
and divisioncode = :gs_divisioncode
using SQLCA;


decimal ld_oldSubsDepReq
if not luo_subscriber.getSubscriptionDepReq(ld_oldSubsDepReq) then
	is_msgNo = 'SM-0000001'
	is_msgTrail = luo_subscriber.lastSQLCode + '~r~n~r~n' + luo_subscriber.lastSQLErrText
	is_sugtrail = 'Error produced by luo_subscriber.getSubscriptionDepReq()'
	return -1	
end IF

--VALIDASI getSubscriptionDepReq

select subscriptionDepReq//(subscriptionDepReq * noOfMonthsDepReq)
  into :ad_amount
  from arPackageMaster
 where packageCode = :packageCode
 and divisionCode = :gs_divisionCode
and companyCode = :gs_companyCode
using SQLCA;
if SQLCA.sqlcode < 0 then
	lastSQLCode 	= string(SQLCA.sqlCode)
	lastSQLErrText = SQLCA.sqlErrText
	return FALSE
end if

if isnull(ad_amount) then ad_amount = 0

return TRUE

--END VALIDASI getSubscriptionDepReq

--==================================================
-- set subscriber's new package code
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if not luo_subscriber.setPackageCode(ls_newPackageCode) then
	is_msgno = 'SM-0000001'
	is_msgtrail = luo_subscriber.lastSQLCode + "~r~n" + luo_subscriber.lastSQLErrText
	is_sugtrail = 'Error produced by luo_subscriber.setPackageCode()'
	return -1
end IF

--VALIDASI setPackageCode

lastMethodAccessed = 'setPackageCode'

update arAcctSubscriber
	set packageCode = :as_packageCode
 where acctNo = :acctNo
 and divisionCode = :gs_divisionCode
and companyCode = :gs_companyCode
using SQLCA;
if SQLCA.sqlcode <> 0 then
	lastSQLCode = string(SQLCA.sqlcode)
	lastSQLErrText = SQLCA.sqlerrtext
	return FALSE
end if

packageCode = as_packageCode

return TRUE

--END VALIDASI setPackageCode

select packagename into :ls_newpackagename 
from arpackagemaster
where packagecode = :ls_newPackageCode
and divisioncode = :gs_divisioncode
using SQLCA;

--==================================================
-- set subscriber's new monthly rates
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if not luo_subscriber.setMonthlyRate(ld_mLineCurrentMonthlyRate, ld_mLinePreviousMonthlyRate, ld_extCurrentMonthlyRate, ld_extPreviousMonthlyRate) then
	is_msgno = 'SM-0000001'
	is_msgtrail = luo_subscriber.lastSQLCode + "~r~n" + luo_subscriber.lastSQLErrText
	is_sugtrail = 'Error produced by luo_subscriber.setMonthlyRate()'
	return -1
end IF

--VALIDASI setMonthlyRate
lastMethodAccessed = 'setMonthlyRate'

update arAcctSubscriber
	set mLineCurrentMonthlyRate = :ad_mLineCurrentMonthlyRate,
		 mLinePreviousMonthlyRate = :ad_mLinePreviousMonthlyRate,
		 extCurrentMonthlyRate = :ad_extCurrentMonthlyRate,
		 extPreviousMonthlyRate = :ad_extPreviousMonthlyRate
 where acctNo = :acctNo
 and divisionCode = :gs_divisionCode
and companyCode = :gs_companyCode
using SQLCA;
if SQLCA.sqlcode <> 0 then
	lastSQLCode = string(SQLCA.sqlcode)
	lastSQLErrText = SQLCA.sqlerrtext
	return FALSE
end if
return TRUE
--END VALIDASI setMonthlyRate

decimal ld_subscriptionDepReq
if not luo_subscriber.getSubscriptionDepReq(ld_subscriptionDepReq) then
	is_msgNo = 'SM-0000001'
	is_msgTrail = luo_subscriber.lastSQLCode + '~r~n~r~n' + luo_subscriber.lastSQLErrText
	is_sugtrail = 'Error produced by luo_subscriber.getSubscriptionDepReq()'
	return -1	
end IF

--VALIDASI getSubscriptionDepReq

select subscriptionDepReq//(subscriptionDepReq * noOfMonthsDepReq)
  into :ad_amount
  from arPackageMaster
 where packageCode = :packageCode
 and divisionCode = :gs_divisionCode
and companyCode = :gs_companyCode
using SQLCA;
if SQLCA.sqlcode < 0 then
	lastSQLCode 	= string(SQLCA.sqlCode)
	lastSQLErrText = SQLCA.sqlErrText
	return FALSE
end if

if isnull(ad_amount) then ad_amount = 0

return TRUE

--END VALIDASI getSubscriptionDepReq

if luo_subscriber.subscriberStatusCode = 'ACT' then
	

	if ld_oldSubsDepReq < ld_subscriptionDepReq then
		--==================================================
		-- Compute for additional subscription deposit req.
		-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		decimal ld_subsDepReceivable
		if not luo_subscriber.getSubsDepReceivable(ld_subsDepReceivable) then
			is_msgNo = 'SM-0000001'
			is_msgTrail = luo_subscriber.lastSQLCode + '~r~n~r~n' + luo_subscriber.lastSQLErrText
			is_sugtrail = 'Error produced by luo_subscriber.getSubsDepReceivable()'
			return -1	
		end IF
		
		--VALIDASI GETSUBSDEPRECEIVABLE
		
		select sum(balance)
		  into :ad_amount
		  from subsDepositReceivable
		 where acctNo = :acctNo
		 	and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		and arTypeCode = 'OCDEP'
		 using SQLCA;
		if SQLCA.sqlcode < 0 then
			lastSQLCode 	= string(SQLCA.sqlCode)
			lastSQLErrText = SQLCA.sqlErrText
			return FALSE
		end if
		
		if isnull(ad_amount) then ad_amount = 0
		
		return TRUE
		
		--END VALIDASI GETSUBSDEPRECEIVABLE
		
		decimal ld_subscriptionDeposit
		if not luo_subscriber.getSubscriptionDeposit(ld_subscriptionDeposit) then
			is_msgNo = 'SM-0000001'
			is_msgTrail = luo_subscriber.lastSQLCode + '~r~n~r~n' + luo_subscriber.lastSQLErrText
			is_sugtrail = 'Error produced by luo_subscriber.getSubsDepReceivable()'
			return -1	
		end IF
		
		--VALIDASI GETSUBSCRIPTIONDEPOSIT
		
		select sum(balance)
		  into :ad_amount
		  from arOpenCreditMaster
		 where acctNo = :acctNo
		 	and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		and ocTypeCode = 'SUBSDEP'
			and (recordStatus is null or recordStatus <> 'V')
		 using SQLCA;
		if SQLCA.sqlcode < 0 then
			lastSQLCode 	= string(SQLCA.sqlCode)
			lastSQLErrText = SQLCA.sqlErrText
			return FALSE
		end if
		
		if isnull(ad_amount) then ad_amount = 0
		
		return TRUE
		
		--END VALIDASI GETSUBSCRIPTIONDEPOSIT
		
		ld_additionalSubsDepReq = (ld_subscriptionDepReq - (ld_subsDepReceivable + ld_subscriptionDeposit))
--!!!Commented by RAY for something purposes CSR!!!				
--!!!Removed comment by vince - New MFAI (08-06-2018)
		if ld_additionalSubsDepReq > 0 then
			if This.Event ue_save_subsInitialPayment(ls_acctNo, ld_additionalSubsDepReq) <> 0 then
				is_msgno = 'SM-0000001'
				is_msgtrail = luo_subscriber.lastSQLCode + "~r~n" + luo_subscriber.lastSQLErrText
				is_sugtrail = 'Error produced by ue_save_subsInitialPayment()'
				return -1
			end IF
			
			--VALIDASI ue_save_subsInitialPayment
			
							insert into subsInitialPayment (
								acctNo,
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
					  values (
					  			:as_acctNo,
								:is_transactionID,
								'OCDEP',
								:is_tranNo,
								getDate(),
								1,
								:ad_amount,
								0,
								:ad_amount,
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
			--END VALIDASI ue_save_subsInitialPayment
		end if	

	end if

else
	
	decimal{2}	ld_ripAmount, ld_paidAmount
	
	if not luo_subscriber.getSubsInitialPaymentAmount_w_paid('APPLYML', luo_subscriber.tranNo, 'OCDEP', ld_ripAmount, ld_paidAmount) then
		is_msgno = 'SM-0000001'
		is_msgtrail = luo_subscriber.lastSQLCode + "~r~n" + luo_subscriber.lastSQLErrText
		is_sugtrail = 'Error produced by luo_subscriber.getSubsInitialPaymentAmount()'
		return -1
	end IF
	
	--VALIDASI getSubsInitialPaymentAmount_w_paid
	
	lastMethodAccessed = 'getSubsInitialPaymentAmount'

		select amount, paidAmt
		  into :ad_amount, :ad_paidAmount  
		  from subsInitialPayment
		 where acctNo = :acctNo
		 	and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		and tranTypeCode = :as_tranTypeCode
			and tranNo = :as_tranNo
		 	and arTypeCode = :as_arTypeCode
		 using SQLCA;
		if SQLCA.sqlcode < 0 then
			lastSQLCode = string(SQLCA.sqlcode)
			lastSQLErrText = SQLCA.sqlerrtext
			return FALSE
		elseif SQLCA.sqlcode = 100 then 
			ad_amount = 0
		end if
		
		return TRUE
		
	--END VALIDASI getSubsInitialPaymentAmount_w_paid
	
	if ld_subscriptionDepReq > ld_ripAmount then
		
		if not luo_subscriber.setRIPAmount('APPLYML', luo_subscriber.tranNo, 'OCDEP', ld_ripAmount + (ld_subscriptionDepReq - ld_ripAmount)) then
			is_msgno = 'SM-0000001'
			is_msgtrail = luo_subscriber.lastSQLCode + "~r~n" + luo_subscriber.lastSQLErrText
			is_sugtrail = 'Error produced by luo_subscriber.setRIPAmount()'
			return -1
		end if	
		
		--VALIDASI SETRIPAMOUNT
		
		update subsInitialPayment
			set amount = :ad_ripAmount,
				 balance = :ad_ripAmount - paidAmt,
				 processed = 'N'
		 where acctNo = :acctNo 
		   and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		and tranTypeCode 	= :as_tranTypeCode 
			and tranNo 			= :as_tranNo
			and arTypeCode 	= :as_arTypeCode	
		 using SQLCA;
		if SQLCA.sqlcode < 0 then
			lastSQLCode = string(SQLCA.sqlcode)
			lastSQLErrText = SQLCA.sqlerrtext
			return FALSE
		end if
		
		return TRUE

		
		--END VALIDASI SETRIPAMOUNT
		
	elseif ld_subscriptionDepReq < ld_ripAmount  then
		
		--str_filter str
		
		--Current RIP(Deposits) are greater than the current Requirement				
		if ld_paidAmount = 0 then --unpaid
		
			if not luo_subscriber.setRIPAmount('APPLYML', luo_subscriber.tranNo, 'OCDEP', ld_subscriptionDepReq) then
				is_msgno = 'SM-0000001'
				is_msgtrail = luo_subscriber.lastSQLCode + "~r~n" + luo_subscriber.lastSQLErrText
				is_sugtrail = 'Error produced by luo_subscriber.setRIPAmount()'
				return -1
			end IF
			
			--VALIDASI SETRIPAMOUNT
			
			update subsInitialPayment
				set amount = :ad_ripAmount,
					 balance = :ad_ripAmount - paidAmt,
					 processed = 'N'
			 where acctNo = :acctNo 
			   and divisionCode = :gs_divisionCode
			and companyCode = :gs_companyCode
			and tranTypeCode 	= :as_tranTypeCode 
				and tranNo 			= :as_tranNo
				and arTypeCode 	= :as_arTypeCode	
			 using SQLCA;
			if SQLCA.sqlcode < 0 then
				lastSQLCode = string(SQLCA.sqlcode)
				lastSQLErrText = SQLCA.sqlerrtext
				return FALSE
			end if
			
			return TRUE
	
			
			--END VALIDASI SETRIPAMOUNT
			
		else --paid na dito
			string ls_ocTranNo,ls_applicationtranno
			decimal{2} ld_ripAmountPaid
			
			ls_applicationtranno = trim(iuo_subscriber.tranno)
			
			select tranNo , amount
			into   :ls_ocTranNo , :ld_ripAmountPaid
			from   arOpenCreditMaster 
			where  ocTypeCode = 'SUBSDEP' 
			and    acctNo     = :ls_acctNo
			and    divisionCode = :gs_divisionCode
			and    companyCode  = :gs_companyCode
--			and    amount       = :ld_ripAmount  - removed by banong - 04-04-2011
			using  SQLCA;
			if SQLCA.SQLCode <> 0 then
				is_msgNo 	= 'SM-0000001'
				is_msgTrail	= 'Error reading reading current deposit...' + &
								  '~r~nSQL Error Code : ' + string(SQLCA.SQLCode)+ &
								  '~r~nSQL Error Text : ' + SQLCA.SQLErrText
								  return -1
			end if	
			
			if ld_ripamountpaid > ld_subscriptionDepReq then			
				istr.s_string1 = is_serviceType
				istr.s_string2 = ls_acctNo
				istr.s_string3 = ls_ocTranNo
				istr.d_amount  = ld_ripAmount - ld_subscriptionDepReq 			
				
				ib_forReclassifyOC = true
			else
				update subsinitialpayment
				set amount = :ld_subscriptionDepReq,
					balance = :ld_subscriptionDepReq - paidamt
					where acctno = :ls_acctno
					and tranno = :ls_applicationtranno
					and trantypecode = 'APPLYML'
					and artypecode = 'OCDEP'
					using SQLCA;
			end if
			
		end if
				
	end if
	
end if

-- =====================================================================================================================
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

--ray 02-17-2012
--if upgrade it will pass this condition if downgrade it will go through this condition
--vince - 10-23-2018 - only charge change pakage fee for subs inside lockin period

if ld_mLineCurrentMonthlyRate < ld_mLinePreviousMonthlyRate then 	//downgrade //downgrade


--insert new scripts here - vince 11-07-2018
if (luo_subscriber.subscriberStatusCode <> 'APL') then
	if not uo_subs_advar.insertNewAr(is_tranno, is_transactionID, 'CHGPF', ld_extendedFeeAmount, ldt_trandate, ls_arRemarks) then
		is_msgno = 'SM-0000001'
		is_msgtrail = uo_subs_advar.lastSQLCode + "~r~n" + uo_subs_advar.lastSQLErrText
		is_sugtrail = 'Error produced by uo_subs_advar.insertNewAr()'
		return -1
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
		
end if

	string ls_unearnedAccount, ls_errorMessage	
	
end if

if not uo_subs_advar.applyOpenCreditMultiple('', '') then                                
	is_msgno = 'SM-0000001'                                                               
	is_msgtrail = uo_subs_advar.lastSQLCode + "~r~n" + uo_subs_advar.lastSQLErrText
	is_sugtrail = 'Error produced by uo_subs_advar.applyApplAdvToBalances()'
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
	
--END VALIDASI setOcTranNo

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
		
----END VALIDASI postOpenCreditUpdates

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
					
					--VALIDASI F_GETARTYPEARACCOUNT
	
					--==================================================
						--NGLara | 04-26-2008
						--This function is primarily being used by Billing
						--computation...
						--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
						
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
				
					
					--END VALIDASI F_GETARTYPEARACCOUNT
					
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
					
					--VALIDASI F_GETARTYPEUNEARNEDACCOUNT
					
					--==================================================
					--NGLara | 04-26-2008
					--This function is primarily being used by Billing
					--computation...
					--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
					
					if isnull(as_arTypeCode) then
						as_errorMsg = 'Null AR Type Code is invalid.'
						return FALSE  
					end if  
					   
					select unEarnedRevAccount
					  into :as_glAccountCode
					  from arTypeMaster
					 where arTypeCode = :as_arTypeCode
					 and divisionCode = :gs_divisionCode
					and companyCode = :gs_companyCode
					using SQLCA;
					if SQLCA.sqlcode = 100 then	// record not found
						as_errorMsg  = 'AR Type Code : [' + as_arTypeCode + '] doest not exist.'
						return FALSE
					elseif SQLCA.sqlcode < 0 then
						as_errorMsg  = SQLCA.sqlerrtext
						return FALSE
					end if
					
					if isnull(as_glAccountCode) or trim(as_glAccountCode) = '' then
						as_errorMsg = 'The AR Account obtained was empty or null. Check the AR Type Code : [' + as_arTypeCode + '] in AR Type Maintenance'
						return FALSE
					end if
					
					Return True

					
					--END VALIDASI F_GETARTYPEUNEARNERDACCOUNT
					
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
						end IF
						
						-VALIDASI F_GETARTYPEREVACCOUNT
								
						if isnull(as_arTypeCode) then
							as_errorMsg = 'Null AR Type Code is invalid.'
							return False
						end if
						
						select revenueAccount
						  into :as_glAccountCode
						  from arTypeMaster
						 where arTypeCode = :as_arTypeCode
						 and divisionCode = :gs_divisionCode
						and companyCode = :gs_companyCode
						using SQLCA;
						if SQLCA.sqlcode = 100 then
							as_errorMsg = 'AR Type Code : [' + as_arTypeCode + '] doest not exist.'
							return False
						elseif SQLCA.sqlcode < 0 then
							as_errorMsg = string(SQLCA.sqlcode) + '~r~n' + SQLCA.sqlerrtext
							return False
						end if
						
						if isnull(as_glAccountCode) or trim(as_glAccountCode) = '' then
							as_errorMsg = 'The Revenue Account obtained was empty or null. Check the AR Type Code : [' + as_arTypeCode + '] in AR Type Maintenance'
							return False
						end if
						
						Return TRUE
						
						--END VALIDASI F_GETARTYPEREVACCOUNT
						
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
		end IF
		
		--VALIDASI SET_NUMBER
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
		
		--END VALIDASI SET_NUMBER
	end if
	
	return True




--END VALIDASI uo_subs_advar.postApplicationOfOpenCredit

-- =====================================================================================================================
--
-- 								 					end of extraction and application
--
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


--added by vince - if passed thru these conditions , should require lockin

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



uo_subscriber luo_subscriber2



string ls_package_code_vas
boolean lb_for_jo_vas

ls_package_code_vas = ''
lb_for_jo_vas = False




CHOOSE CASE ls_newPackageCode
    CASE "JM060"
        ls_package_code_vas = "JM220"
        lb_for_jo_vas = True
    CASE "JM061"
        ls_package_code_vas = "JM120"
        lb_for_jo_vas = True
    CASE "JM062"
        ls_package_code_vas = "JM320"
        lb_for_jo_vas = True
    CASE "JM246"
        ls_package_code_vas = "JM247"
        lb_for_jo_vas = True
	CASE "FBX15", "FBX14", "FBX16" 
		ls_package_code_vas = "JM276"
		 lb_for_jo_vas = tRUE
		 ls_relockin = 'Y'
    CASE ELSE
        -- Do nothing or handle the default case if needed
END CHOOSE


if ls_relockin = 'Y' then
	
	update aracctsubscriber
	set daterelockin = sysdate 
	where acctno = :ls_acctno
	and divisioncode = :gs_divisioncode
	using SQLCA;
	
end if


string ls_codes[] = {"JM060", "JM061", "JM062", "JM246","FBX15", "FBX14", "FBX16" }
integer i

FOR i = 1 TO UpperBound(ls_codes)
    IF Pos(ls_oldPackagecode, ls_codes[i]) > 0 THEN
        lb_for_jo_vas = FALSE
        EXIT
    END IF
NEXT


update subscribercpemaster
set packagecode = :ls_newPackageCode
where acctno = :ls_Acctno
and divisioncode = :gs_divisioncode
and cpetypecode = 'CM'
using SQLCA;



if lb_for_jo_vas then
	
	--Wifi6 Checking

long ll_ctr_wifi5
long ll_wifi6_tranno

ll_ctr_wifi5 = 0

	select count(*) into :ll_ctr_wifi5
	from subscribercpemaster
	where acctno = :ls_acctno
	and divisioncode = :gs_divisioncode
	and companycode = :gs_companycode
	and cpetypecode= 'CM'
	and itemcode in ('00030501',
	'00030419',
	'00030781',
	'00030750',
	'00030762',
	'00030763',
	'00030779',
	'00030771',
	'00030338',
	'00030405',
	'00030311',
	'00030779',
	'00030754') 
	using SQLCA;

if ll_ctr_wifi5 > 0 then
	
		select ADDON_WIFI6.NEXTVAL into :ll_wifi6_tranno from dual using SQLCA;
		
		insert into wifi6onsitetran (acctno, divisioncode, companycode, trandate, referencejono,onsite_charge,equipment_charge, id)
		values (:ls_acctno, :gs_Divisioncode, :gs_companycode, sysdate, :ll_wifi6_tranno, 0, 0, :ll_wifi6_tranno)
		using SQLCA;
		
		
		
		
		insert into JoTranHdr (jono, jodate, trantypecode, acctno, linemancode, referenceno, jostatuscode, useradd, dateadd, divisioncode, companycode, is_auto_create, remarks, specialinstructions)
		values (:ll_wifi6_tranno, sysdate, 'WIFI6TA', :ls_acctno, '00013', :ll_wifi6_tranno, 'FR', :gs_username, SYSDATE, :GS_DIVISIONCODE, :GS_COMPANYCODE, 'Y', 'Free Wifi6','')
		using SQLCA;
else
	
	string ls_tranno_amort
	long ll_ctr_amort
	
	ll_ctr_amort = 0
	
	select count(*) into :ll_ctr_amort
	from amortizedarTranhdr
	where acctno = :ls_acctno
	and divisioncode = :gs_divisioncode
	and companycode = :Gs_companycode and artypecode = 'DUFEE'
	AND REMARKS LIKE 'WIFI6%'
	group by tranno
	USING SQLCA;
	
	if ll_ctr_amort > 0 then
		update amortizedartrandtl
		set billed = 'W'
		where tranno in (select tranno from amortizedartranhdr
								where acctno = :ls_acctno
								and divisioncode = :gs_divisioncode
								and companycode = :gs_companycode
								and artypecode = 'DUFEE' AND REMARKS LIKE 'WIFI6%')
		and billed = 'N'
		using SQLCA;
		
	end if

end if
	
	
	string ls_jono_iptv

	if not luo_subscriber2.setAcctNo(ls_acctno) then
		is_msgNo    = 'SM-0000001'
		is_msgTrail = luo_subscriber2.lastSQLCode + '~r~n' + luo_subscriber2.lastSQLErrText
		return -1
	end if 
	
	--VALIDASI IOU_SUBCRIBER.SETACCTNO
	
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
	
	--END VALIDASI IUO_SUBCRIBER.SETACCTNO
	
	if luo_subscriber2.autocreatejo_IPTV(is_tranNo, ls_jono_iptv) < 0 then
		is_msgNo    = 'SM-0000001'
		is_msgTrail = luo_subscriber2.lastSQLCode + '~r~n' + luo_subscriber2.lastSQLErrText
		return -1
	end if 
	
	--VALIDASI AUTOCREATEJO_IPTV
	
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

	
	--END VALIDASI AUTOCREATEJO_IPTV
	
	if trigger event ue_create_sales_addontranhdr(ls_package_code_vas, ls_acctno, ls_jono_iptv) = -1 then
		return -1
	end if 
	
	--VALIDASI ue_create_sales_addontranhdr
	
	long ll_tranno, ll_tranno_ext
	SELECT sales_seq.nextval into :ll_tranno from dual using SQLCA;
	
	string ls_tranno, as_mop , ls_tranno_ext
	ls_tranno		=	'AO'+string(ll_tranNo, '000000')
	
	long li_addon_id
	ls_tranno_ext = 'C'+string(ll_tranNo,'00000')
	
	
	
	string ls_packagecode, ls_itemcode, as_install_type
	
	as_install_type = 'INSTALL'
	
	decimal ld_total_amount, ld_outright_price, ld_staggered_price ,ld_delivery_fee, ld_setup_fee , ld_total_delivery_fee
	decimal ld_total_setup_fee
	
	ld_total_amount = 0.00
	ld_total_delivery_fee = 0.00
	ld_total_setup_fee = 0.00
	
	INT i
	
	string ls_mop , ls_mode_of_delivery
	
	
		ls_packagecode = as_packagecode
	
	for i = 1 to 1
		
		
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
		
	NEXT
	
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
				0,
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
			:ls_tranno_ext,
			sysdate,
			:as_acctno,
			1,
			1,
			'', 
			:as_jono,
			sysdate, 
			sysdate,						
			'FJ', 
			0.00,
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
	string ls_acquisitionTypeCode, ls_package_code_new
	dec{2} ld_rate, ld_amount
	--boolean is_netflix, lb_high_speed_plans,
	
	--ll_rows = idw_application_for_ext_dtl.rowCount()
	--is_netflix = False
	
	for ll_loop = 1 to 1
		
		ll_applOfExtTranDtl_qty = 1
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
				(:ls_tranno_ext,
				 'RND',
				 1,
				 0,
				 0,
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
	
	for ll_loop = 1 to 1
		insert into applOfExtTranFeeBreakdown (
						tranNo,
						extInstFee,
						divisionCode,
						companyCode)
			  values (
			  			:ls_tranno_ext,
						0.00,
						:gs_divisionCode,
						:gs_companyCode)
				using SQLCA;
		if SQLCA.sqlCode < 0 then
			is_msgNo    = 'SM-0000001'
			is_msgTrail = 'insert in applOfExtTranFeeBreakdown'+'SQLCode    : '+string(SQLCA.SQLCode) + 'SQLErrText : ' + SQLCA.SQLErrText
			return -1	
		end if
		open(w_relax) --just to avoid primary key violation of dateAdd column
	next
	
	
	update jotranhdr
	set referenceno = :ls_tranno_Ext
	where jono = :as_jono
	and divisioncode = :gs_divisioncode
	and companycode = :gs_companycode
	using SQLCA;
	
	
	RETURN 1

	--END VALIDASI ue_create_sales_addontranhdr
	
	string ls_fullacctno
	
	
	select acctno into :ls_fullacctno
	from vw_fullacctno
	where ibas_acctno = :ls_acctno
	and divisioncode = :gs_divisioncode
	and companycode = :gs_companycode
	using SQLCA;
	
	
	insert into netflix_account_movement(acctno, divisioncode, companycode, action, newpackagecode, request_date, processed, useradd)
	values( :ls_fullacctno, :gs_divisioncode, :gs_companycode, 'ENROLL', :ls_newpackagecode, sysdate, 'N', :gs_username)
	using SQLCA;

end if 
if not guo_func.set_number(is_transactionID, ll_tranNo) then
	return -1
end IF

--VALIDASI SET_NUMBER

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

--END VALIDASI SET_NUMBER


--NOT USE ANYMORE
--=================================================
-- post GL Entries
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if not iuo_glPoster.postGLEntries() then
	is_msgno 	= 'SM-0000001'
	is_msgtrail =  iuo_glPoster.errorMessage
	is_sugtrail = iuo_glPoster.suggestionRemarks
	return -1
end if

if is_gamechanger = 'Y' then
		

end if

is_msgno = "SM-0000002"
is_msgtrail = ''
is_sugtrail = ''

return 0


--END BUTTON SAVE