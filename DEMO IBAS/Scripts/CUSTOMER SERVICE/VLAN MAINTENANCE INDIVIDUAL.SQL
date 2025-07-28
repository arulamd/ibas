--QUERY FORM 
 
SELECT arAcctSubscriber.acctNo,   
         arAcctSubscriber.subscriberName,   
         vw_arAcctAddress.completeAddress,   
         arAcctSubscriber.nodeNo  
    FROM arAcctSubscriber,   
         vw_arAcctAddress  
   WHERE ( arAcctSubscriber.acctNo = vw_arAcctAddress.acctNo ) and  
         ( arAcctSubscriber.divisionCode = vw_arAcctAddress.divisionCode ) and  
         ( arAcctSubscriber.companyCode = vw_arAcctAddress.companyCode ) and  
         ( ( arAcctSubscriber.acctNo = :as_acctNo ) AND  
         ( arAcctSubscriber.divisionCode = :as_division ) AND  
         ( arAcctSubscriber.companyCode = :as_company ) AND  
         ( vw_arAcctAddress.addressTypeCode = 'SERVADR1' ) )
         
iuo_subscriber = create using "uo_subscriber_def"

--EVENT BUTTON CLICKED 

string ls_acctNo, ls_macAddress, ls_ipAddress, ls_oldipAddress, ls_serialNo, lastSQLErrText
int li_nodeNo, li_count, li_vLan, li_vlanNew

this.acceptText()

if dwo.name = 'b_search' then
	
	str_search str_s
	str_s.serviceType = 'INET'
	str_s.s_dataobject = "dw_search_acctno_subsname"
	str_s.s_return_column = "acctno"
	str_s.s_title = "Search For Subscribers"
	
	--QUERY FOR SEARCH
	
		SELECT arAcctSubscriber.acctno,   
			arAcctSubscriber.subscribername,   
			vw_arAcctAddress.contactNo,   
			arAcctSubscriber.mobileno,   
			vw_arAcctAddress.municipalityCode,   
			arAcctSubscriber.packagecode,   
			arAcctSubscriber.subscriberstatuscode,   
			vw_arAcctAddress.completeAddress,
	      subscriberStatusMaster.subscriberStatusName,
	      arPackageMaster.packageName
	 FROM arAcctSubscriber 
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
			   
	
	BUTTON SEARCH
	
	String s_search, ls_searchBy
 	
	integer li_kawnt
	
	s_search = upper(trim(sle_search.text))
	s_search = upper(trim(s_search))
	
	ls_searchBy = lower(ddlb_searchby.text)
	
	string ls_select, ls_where, ls_retrieve
	
	if is_selected = '' or isNull(is_selected) then
	
		if ls_searchBy <> 'completeaddress' then
			if pos(s_OriginalSelect,'WHERE') > 0 then
				ls_where = " AND upper(arAcctSubscriber." + ls_searchBy + ") LIKE '%"+s_search+"%'" +  " AND arAcctSubscriber.divisionCode = '"+gs_divisionCode+"'" +  " AND arAcctSubscriber.companyCode = '"+gs_companyCode+"'"
			else	
				ls_where = " WHERE upper(arAcctSubscriber." + ls_searchBy + ") LIKE '%"+s_search+"%'" + " AND arAcctSubscriber.divisionCode = '"+gs_divisionCode+"'" +  " AND arAcctSubscriber.companyCode = '"+gs_companyCode+"'"
			end if	
		else
			if pos(s_OriginalSelect,'WHERE') > 0 then
				ls_where = " AND upper(vw_arAcctAddress." + ls_searchBy + ") LIKE '%"+s_search+"%'" +  " AND arAcctSubscriber.divisionCode = '"+gs_divisionCode+"'" +  " AND arAcctSubscriber.companyCode = '"+gs_companyCode+"'"+ " AND vw_arAcctAddress.addressTypeCode = 'SERVADR1' "
			else	 
				ls_where = " WHERE upper(vw_arAcctAddress." + ls_searchBy + ") LIKE '%"+s_search+"%'" + " AND arAcctSubscriber.divisionCode = '"+gs_divisionCode+"'" +  " AND arAcctSubscriber.companyCode = '"+gs_companyCode+"'"+ " AND vw_arAcctAddress.addressTypeCode = 'SERVADR1' "
			end if	
		end if
		
	else
		
		if ls_searchBy = 'subscribername' or ls_searchBy = 'acctno' or ls_searchBy = 'DatelcomTelNo' or ls_searchBy = 'oldacctno' then
			if pos(s_OriginalSelect,'WHERE') > 0 then
				ls_where = " AND upper(arAcctSubscriber." + ls_searchBy + ") LIKE '%"+s_search+"%'" +  " AND arAcctSubscriber.divisionCode = '"+gs_divisionCode+"'" +  " AND arAcctSubscriber.companyCode = '"+gs_companyCode+"'" +  "AND ( ( arAcctSubscriber.subsTypeCode <> 'CP' and 'N' =  '"+is_selected+"'" +  ") OR ( arAcctSubscriber.subsTypeCode = 'CP' and 'Y' =  '"+is_selected+"'"+"))"
			else	
				ls_where = " WHERE upper(arAcctSubscriber." + ls_searchBy + ") LIKE '%"+s_search+"%'" + " AND arAcctSubscriber.divisionCode = '"+gs_divisionCode+"'" +  " AND arAcctSubscriber.companyCode = '"+gs_companyCode+"'" +  "AND ( ( arAcctSubscriber.subsTypeCode <> 'CP' and 'N' =  '"+is_selected+"'" +  ") OR ( arAcctSubscriber.subsTypeCode = 'CP' and 'Y' =  '"+is_selected+"'"+"))"
			end if	
		elseif ls_searchBy = 'completeaddress' then
			if pos(s_OriginalSelect,'WHERE') > 0 then
				ls_where = " AND upper(vw_arAcctAddress." + ls_searchBy + ") LIKE '%"+s_search+"%'" +  " AND arAcctSubscriber.divisionCode = '"+gs_divisionCode+"'" +  " AND arAcctSubscriber.companyCode = '"+gs_companyCode+"'"+ " AND vw_arAcctAddress.addressTypeCode = 'SERVADR1' " +  "AND ( ( arAcctSubscriber.subsTypeCode <> 'CP' and 'N' =  '"+is_selected+"'" +  ") OR ( arAcctSubscriber.subsTypeCode = 'CP' and 'Y' =  '"+is_selected+"'"+"))"
			else	 
				ls_where = " WHERE upper(vw_arAcctAddress." + ls_searchBy + ") LIKE '%"+s_search+"%'" + " AND arAcctSubscriber.divisionCode = '"+gs_divisionCode+"'" +  " AND arAcctSubscriber.companyCode = '"+gs_companyCode+"'"+ " AND vw_arAcctAddress.addressTypeCode = 'SERVADR1' " +  "AND ( ( arAcctSubscriber.subsTypeCode <> 'CP' and 'N' =  '"+is_selected+"'" +  ") OR ( arAcctSubscriber.subsTypeCode = 'CP' and 'Y' =  '"+is_selected+"'"+"))"
			end if	
		
		elseif ls_searchBy = 'circuitid' then
			if pos(s_OriginalSelect,'WHERE') > 0 then
				ls_where = " AND subscriberCircuitID." + ls_searchBy + " LIKE '%"+s_search+"%'" +  " AND subscriberCircuitID.divisionCode = '"+gs_divisionCode+"'" +  " AND subscriberCircuitID.companyCode = '"+gs_companyCode+"'" +  "AND ( ( arAcctSubscriber.subsTypeCode <> 'CP' and 'N' =  '"+is_selected+"'" +  ") OR ( arAcctSubscriber.subsTypeCode = 'CP' and 'Y' =  '"+is_selected+"'"+"))"
			else	
				ls_where = " WHERE subscriberCircuitID." + ls_searchBy + " LIKE '%"+s_search+"%'" + " AND subscriberCircuitID.divisionCode = '"+gs_divisionCode+"'" +  " AND subscriberCircuitID.companyCode = '"+gs_companyCode+"'" +  "AND ( ( arAcctSubscriber.subsTypeCode <> 'CP' and 'N' =  '"+is_selected+"'" +  ") OR ( arAcctSubscriber.subsTypeCode = 'CP' and 'Y' =  '"+is_selected+"'"+"))"
			end if	
		end if
		
	end if
	
	dw_1.modify('DataWindow.Table.Select ="' +s_OriginalSelect+ls_where+'"')
	
	if len(s_search) > 1 then
		if dw_1.retrieve(s_search) > 0 then
			dw_1.setfocus()
			pb_3.default = TRUE
		end if	
	elseif len(s_search) <> 0 then
		guo_func.msgbox('SM-0000025')
	end IF
	
	--END BUTTON SEARCH
	
	AFTER GET THE DATA IN ROW THEN CLICK BUTTON SELECT THEN RETURN VALUE ls_acctNo
	
	openwithparm(w_search_subscriber,str_s)
	
	ls_acctNo = trim(message.stringparm)
	
	if ls_acctNo <> '' then
		iuo_subscriber.setAcctNo(ls_acctNo)
		
		select count(*)
		into :li_count
		from packageTypeMaster
		where packageTypeCode = :iuo_subscriber.packageTypeCode
		and packageTypeGroupCode = 'CM'
		and divisionCode = :gs_divisionCode  // LD - 09/13/2010 PackageTypeMaster was not a division,company.
		and companyCode = :gs_companyCode
		using SQLCA;
		
		if li_count <> 1 then 
			guo_func.msgBox("ATTENTION","This maintenance is intended only for subscriber that has cable modem.")
			return -1
		end if
		
		this.retrieve(ls_acctNo, gs_divisionCode, gs_companyCode)
		il_oldNodeNo = this.getItemNumber(1,'nodeNo')
		this.setItem(1,'nodeno',0)
		
	end if
elseif dwo.name = 'b_save' then
	ls_acctNo = this.getItemString(1,'acctNo')
	li_vlanNew = this.getItemNumber(1,'nodeNo')
	
	if ( isnull(ls_acctNo) or ls_acctNo = "" ) or ( isnull(li_vlanNew) or li_vlanNew = 0 ) then
		guo_func.msgBox("ATTENTION","Account and VLAN No. are required.")
		return -1
	end if
	
	select macAddress, vlan, ipAddress
	into :ls_macAddress, :li_vLan, :ls_oldipAddress
	from ipMaster
	where acctNo = :ls_acctNo
	and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	and rownum < 2
	using SQLCA;
	

	select ipAddress
	into :ls_ipAddress
	from ipMaster
	where vlan = :li_vlanNew
	and macAddress = null
	and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	and rownum < 2
	using SQLCA;
	if SQLCA.sqlcode <> 0 then
		rollback using SQLCA;
		guo_func.msgBox("ATTENTION",string(SQLCA.sqlcode) + '. ' + SQLCA.sqlerrtext)
		return -1
	end if

		
	update ipMaster
	set macAddress = null,
		 acctNo = null
	where acctNo = :ls_acctNo
	and macAddress = :ls_macAddress
	//and vlan <> 13
	and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	using SQLCA;

		
	update ipMaster
	set macAddress = :ls_macAddress,
		 acctNo = :ls_acctNo
	where vlan = :li_vlanNew
	and ipAddress = :ls_ipAddress
	and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	using SQLCA;
	
	select serialNo into :ls_serialNo from subscriberCPEMaster 
	where acctNo = :ls_acctNo and macAddress = :ls_macAddress 
	and   divisionCode = :gs_divisionCode and companyCode = :gs_companyCode
	using SQLCA;
		
	
	insert into ipMasterHistory
		(	acctNo,
			ipAddress,
			vLAN,
			nodeNo,
			userAdd,
			dateAdd,
			divisionCode,
			companyCode
		)
	values
		(
			:ls_acctNo,
			:ls_oldipAddress,
			:li_vLan,
			:il_oldNodeNo,
			:gs_userCode,
			getDate(),
			:gs_divisionCode,
			:gs_companyCode
		)
	using SQLCA;
	
	
	if not uf_insertIntoMPThrilRequestMaster(ls_acctNo, '', '', 'REFRESH', '', 'EDITVLAN', &
				ls_serialNo, ls_macAddress, lastSQLErrText) then
		if not isnull(lastSQLErrText) and lastSQLErrText <> '' then
			guo_func.msgBox('Error',lastSQLErrText )				
			rollback using SQLCA;
			return 
		end if	
	end IF
	
	--VALDIDASI uf_insertIntoMPThrilRequestMaster
	
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
		 
		 
		// ls_companyid = right(ls_companyid,2)
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
		
		
		--check muna kung allowed sa bcc, para hindi siya lagi nag coconnect
		if f_ifallowedinbccserver(as_acctno) then	
			uo_ipcomm_mon luo_ipcomm
		
			if not	luo_ipcomm.getsubscribername(as_acctno,ls_subscribername, ls_subscriberstatuscode) then
				as_errormsg = as_errormsg + '~r~n~r~n' + 'Warning: ' + string(SQLCA.sqlcode) + '~r~n' + SQLCA.sqlerrtext
				return FALSE
			end IF
			
			--SAME WITH VLAN MAINTENANCE SEE THE LOGIC
			
			if not	luo_ipcomm.getpackagecode(as_acctno,ls_packagecode) then
				as_errormsg = as_errormsg + '~r~n~r~n' + 'Warning: ' + string(SQLCA.sqlcode) + '~r~n' + SQLCA.sqlerrtext
				return FALSE
			end IF
			
			--SAME WITH VLAN MAINTENANCE SEE THE LOGIC
			
			if not	luo_ipcomm.getclientclassnamenew(ls_packagecode,ls_clientclassvalue,as_acctno, ls_approachtype) then
				as_errormsg = as_errormsg + '~r~n~r~n' + 'Warning: ' + string(SQLCA.sqlcode) + '~r~n' + SQLCA.sqlerrtext
				return FALSE
			end if 
			
			--SAME WITH VLAN MAINTENANCE SEE THE LOGIC
			
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
			
			// Profile BCCDSN
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
				
			
			--001 - ADD SUB
			--002 - ADD MAC
			--003 - DEL MAC
			--004 - RES MAC
		
		
			
		if ls_approachtype = 'DOCSIS' then	
			
			
			if trim(as_reftrantypecode) = 'ADS' or trim(as_reftrantypecode) = 'APPLYPD' then
				
				if not guo_func.get_nextNumber('BCCREQUESTNO',ll_reqno,'WITH LOCK') then 
					return FALSE
				end if	
				
				--SAME WITH VLAN MAINTENANCE SEE THE LOGIC
				
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
				
				--SAME WITH VLAN MAINTENANCE SEE THE LOGIC
				
				commit using SQLCA;
				
			elseif trim(as_reftrantypecode) = 'ASSIGNEDCPE' then
					
				if not guo_func.get_nextNumber('BCCREQUESTNO',ll_reqno,'WITH LOCK') then 
					return FALSE
				end if	
				
				--SAME WITH VLAN MAINTENANCE SEE THE LOGIC
				
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
					end IF
					
					--SAME WITH VLAN MAINTENANCE SEE THE LOGIC
					
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
					
					--SAME WITH VLAN MAINTENANCE SEE THE LOGIC
				END IF
			elseif  trim(as_reftrantypecode) = 'REACTIVATE' then
				
				if not guo_func.get_nextNumber('BCCREQUESTNO',ll_reqno,'WITH LOCK') then 
					return FALSE
				end if	
				
				--SAME WITH VLAN MAINTENANCE SEE THE LOGIC
				
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
					
					--SAME WITH VLAN MAINTENANCE SEE THE LOGIC
			
			elseif trim(as_reftrantypecode) = 'REFRESH' then
				
				if ls_subscriberstatuscode = 'APL' or ls_subscriberstatuscode = 'ACT' then
					
					if not guo_func.get_nextNumber('BCCREQUESTNO',ll_reqno,'WITH LOCK') then 
						return FALSE
					end if	
					
					--SAME WITH VLAN MAINTENANCE SEE THE LOGIC
					
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
					
					--SAME WITH VLAN MAINTENANCE SEE THE LOGIC
		
				else //if not APPLIED or ACTIVE ---> DEACTIVATE
					
					if not guo_func.get_nextNumber('BCCREQUESTNO',ll_reqno,'WITH LOCK') then 
						return FALSE
					end if	
					
					--SAME WITH VLAN MAINTENANCE SEE THE LOGIC
					
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
					
					--SAME WITH VLAN MAINTENANCE SEE THE LOGIC
				end if
			
			elseif  trim(as_reftrantypecode) = 'REACTIVATE' or trim(as_reftrantypecode) = 'ACTIVATEPDS' or trim(as_reftrantypecode) = 'ACTIVATEADS' then
				
					if not guo_func.get_nextNumber('BCCREQUESTNO',ll_reqno,'WITH LOCK') then 
						return FALSE
					end if	
					
					--SAME WITH VLAN MAINTENANCE SEE THE LOGIC
					
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
					
					--SAME WITH VLAN MAINTENANCE SEE THE LOGIC
						
					
			elseif  trim(as_reftrantypecode) = 'CHANGEPACK'  then
					
					if not guo_func.get_nextNumber('BCCREQUESTNO',ll_reqno,'WITH LOCK') then 
						return FALSE
					end IF
					--SAME WITH VLAN MAINTENANCE SEE THE LOGIC
					
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
					end IF
					--SAME WITH VLAN MAINTENANCE SEE THE LOGIC
				
					
				elseif trim(as_reftrantypecode) = 'REPLACECM' then
						
						if not guo_func.get_nextNumber('BCCREQUESTNO',ll_reqno,'WITH LOCK') then 
							return FALSE
						end if	
						--SAME WITH VLAN MAINTENANCE SEE THE LOGIC
					
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
							--SAME WITH VLAN MAINTENANCE SEE THE LOGIC
							
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
							end IF
							--SAME WITH VLAN MAINTENANCE SEE THE LOGIC
						
					
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
						--SAME WITH VLAN MAINTENANCE SEE THE LOGIC
						
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
						end IF
						--SAME WITH VLAN MAINTENANCE SEE THE LOGIC
				
				elseif trim(as_reftrantypecode) = 'ASSIGNEDCPE' then
					
						if not guo_func.get_nextNumber('BCCREQUESTNO',ll_reqno,'WITH LOCK') then 
							return FALSE
						end if	
						--SAME WITH VLAN MAINTENANCE SEE THE LOGIC
						
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
						
						--SAME WITH VLAN MAINTENANCE SEE THE LOGIC
						
				elseif  trim(as_reftrantypecode) = 'REACTIVATE' or trim(as_reftrantypecode) = 'ACTIVATEPDS' or trim(as_reftrantypecode) = 'ACTIVATEADS' then
					
						if not guo_func.get_nextNumber('BCCREQUESTNO',ll_reqno,'WITH LOCK') then 
							return FALSE
						end IF
						
						--SAME WITH VLAN MAINTENANCE SEE THE LOGIC
						
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
						--SAME WITH VLAN MAINTENANCE SEE THE LOGIC
						
				elseif  trim(as_reftrantypecode) = 'CHANGEPACK' or trim(as_reftrantypecode) = 'REPLACECM' then
					
						if not guo_func.get_nextNumber('BCCREQUESTNO',ll_reqno,'WITH LOCK') then 
							return FALSE
						end if	
						
						--SAME WITH VLAN MAINTENANCE SEE THE LOGIC
						
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
										
										--SAME WITH VLAN MAINTENANCE SEE THE LOGIC
								
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
										end IF
										
										--SAME WITH VLAN MAINTENANCE SEE THE LOGIC
									
									END IF
						
						
				elseif trim(as_reftrantypecode) = 'REFRESH' then				
						
										
							
								IF as_inserttype = 'DEACTIVATE' then
									
									if not guo_func.get_nextNumber('BCCREQUESTNO',ll_reqno,'WITH LOCK') then 
									return FALSE
									end if	
									
									--SAME WITH VLAN MAINTENANCE SEE THE LOGIC
							
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
									end IF
									
									--SAME WITH VLAN MAINTENANCE SEE THE LOGIC
								
							else
								
							
									
								if not guo_func.get_nextNumber('BCCREQUESTNO',ll_reqno,'WITH LOCK') then 
									return FALSE
								end IF
								
								--SAME WITH VLAN MAINTENANCE SEE THE LOGIC
								
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
								
								--SAME WITH VLAN MAINTENANCE SEE THE LOGIC
						
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
				ls_url = "http://192.168.253.149:11223/v1/converge/provisioning_json/activateINET?brand=BCC&acctNo=&subscriberName="+ls_subscribername+"&nodeNo=0&macAddress="+as_macaddress+"&deviceModel=DPC2100R2&productId=IPTV_CLK"
				lblb_args = blob(ls_cont)
				ll_length = Len(lblb_args)
				
				iinet.GetURL(ls_url, iir_msgbox) 
				
				
			END IF 
		
		
				
		
		return TRUE


	
	--END uf_insertIntoMPThrilRequestMaster
	
	
	commit using SQLCA;
	guo_func.msgBox("ATTENTION","VLAN for this subscriber was successfully changed.")
	this.reset()
	this.insertRow(0)
	
	
elseif dwo.name = 'b_close' then
	close(parent)
end if