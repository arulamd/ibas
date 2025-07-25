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
         
--EVENT BUTTON CLICK ACTION
         
string ls_acctNo, ls_macAddress, ls_ipAddress, ls_oldipAddress
int li_nodeNo, li_count, li_vLan

this.acceptText()

if dwo.name = 'b_search' then
	
	str_search str_s
	str_s.serviceType = 'INET'
	str_s.s_dataobject = "dw_aracct_russ"
	str_s.s_return_column = "acctno"
	str_s.s_title = "Search For Subscribers"
	
	--VALIDASI SEARCH Subscribers qUERY TO FIND ACCTNO 
	
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

	openwithparm(w_search_subscriber,str_s)
	
	--BUTTON SEARCH IN w_search_subscriber :
	
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
	---END SEARCH
	
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
		and (packageTypeGroupCode = 'CM' or packageTypeGroupCode = 'ONU')
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
	
	
	update arAcctSubscriber
	set nodeNo = :li_nodeNo
	where acctNo = :ls_acctNo
	and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	using SQLCA;
	
	
	if iuo_subscriber.refreshCableModem() then
		commit using SQLCA;
	else
		rollback using SQLCA;
		guo_func.msgbox('Warning!', iuo_subscriber.lastSQLCode + '~r~n~r~n' + iuo_subscriber.lastSQLErrText)
	end if
	guo_func.msgBox("ATTENTION","Node No. and VLAN for this subscriber was successfully changed.")
	this.reset()
	this.insertRow(0) 
	
elseif dwo.name = 'b_close' then
	close(parent)
end if