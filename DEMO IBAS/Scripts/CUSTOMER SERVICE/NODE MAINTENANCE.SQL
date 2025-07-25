--EVENT BUTTON CLICK IN DW_1

string ls_acctNo, ls_macAddress, ls_ipAddress, ls_oldipAddress
int li_nodeNo, li_count, li_vLan

this.acceptText()

if dwo.name = 'b_search' then
	
	str_search str_s
	str_s.serviceType = 'INET'
	str_s.s_dataobject = "dw_search_acctno_subsname"
	str_s.s_return_column = "acctno"
	str_s.s_title = "Search For Subscribers"
	
	--QUERY FOR SEARCH ACCNO
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
	--END 
			   
	openwithparm(w_search_subscriber,str_s)
	
	--BUTTON SEARCH
	
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
	end if

--END BUTTON SEARCH
	
	--BUTTON SELECT IN SEARC FORM
		if dw_1.rowcount() > 0 then
		closewithreturn(parent,dw_1.getitemstring(dw_1.getrow(),'acctno'))
	end if
	
	
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
		
	end if
elseif dwo.name = 'b_save' then
	ls_acctNo = this.getItemString(1,'acctNo')
	li_nodeNo = this.getItemNumber(1,'nodeNo')
	
	if ( isnull(ls_acctNo) or ls_acctNo = "" ) or ( isnull(li_nodeNo) or li_nodeNo = 0 ) then
		guo_func.msgBox("ATTENTION","Account and Node No. are required.")
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
	
	if li_nodeNo = 19 or &
		li_nodeNo = 1 then
		
		select ipAddress
		into :ls_ipAddress
		from ipMaster
		where vlan = 13
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
		where vlan = 13
		and ipAddress = :ls_ipAddress
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;
		
	elseif li_nodeNo = 96 or &
		    li_nodeNo = 51 or &
		    li_nodeNo = 45 or &
		    li_nodeNo = 39 or &			 			 
		    li_nodeNo = 36 or &			 			 			 
			 li_nodeNo = 17 or &		 			 
		    li_nodeNo = 35 then
		
		
		select ipAddress
		into :ls_ipAddress
		from ipMaster
		where vlan = 9
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
		where vlan = 9
		and ipAddress = :ls_ipAddress
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;				
		
	elseif li_nodeNo = 32 or &
			li_nodeNo = 27 or &
			li_nodeNo = 26 or &
			li_nodeNo = 25 then
		
		select ipAddress
		into :ls_ipAddress
		from ipMaster
		where vlan = 1
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
		where vlan = 1
		and ipAddress = :ls_ipAddress
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;
		
		
	else
		
		update ipMaster
		set macAddress = null,
			 acctNo = null
		where acctNo = :ls_acctNo
		and ( vlan = 13 or vlan = 9 )
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;
		
	end if
	
	update arAcctSubscriber
	set nodeNo = :li_nodeNo
	where acctNo = :ls_acctNo
	and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
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
	
	commit using SQLCA;
	guo_func.msgBox("ATTENTION","Node No. and VLAN for this subscriber was successfully changed.")
	this.reset()
	this.insertRow(0)
	
	if iuo_subscriber.refreshCableModem() then
		commit using SQLCA;
	else
		rollback using SQLCA;
		guo_func.msgbox('Warning!', iuo_subscriber.lastSQLCode + '~r~n~r~n' + iuo_subscriber.lastSQLErrText)
	end if 
	

	
elseif dwo.name = 'b_close' then
	close(parent)
end if