gs_username = Trim(sle_UID.Text)
ls_pword = trim(sle_pword.text)

if isnull(gs_username) or gs_username = '' then
	guo_func.msgbox("System Security...", "Please specify your User ID to log in..", gc_Critical, gc_OkOnly, "")
	sle_uid.setfocus()
	return 0
end if

if upper(gs_username) = "SYSADMIN" then
	if guo_func.validate_user(gs_username, ls_pword) THEN
	
		--VALIDASI guo_func.validate_user(gs_username, ls_pword)
		string	s_db_password, s_decrypted_password 
		int is_md5
		string ls_md5_password
		
		if upper(as_username) = 'SYSADMIN' then
		
			declare cur_user cursor for
				select u.password, u.is_md5
				from userMaster u 
				inner join sysAdminUser s on u.userName = s.userName
				using SQLCA;
		
			open cur_user;
			if SQLCA.sqlcode <> 0 then
				guo_func.msgbox("ATTENTION",string(SQLCA.sqlcode) + '~r~n' + SQLCA.sqlerrtext)
				return False
			end if
		
			fetch cur_user into :s_db_password, :is_md5;
			
			do while SQLCA.sqlcode = 0
				
				if is_md5 = 0 then 
					s_decrypted_password = guo_func.decrypt(trim(s_db_password))
					if s_decrypted_password = as_password then
						close cur_user;
						return True
					else
						fetch cur_user into :s_db_password, :is_md5;
					end if
				else
					select custom_hash(:as_password) into :ls_md5_password from dual
					using SQLCA;
					
					if s_db_password = ls_md5_password then
						close cur_user;
						return True
					else
						fetch cur_user into :s_db_password, :is_md5;
					end if
				end if 
			loop
			close cur_user;
			return False
		else
			
			select userCode,password,  usercode_oebs, is_md5
			into :gs_usercode,:s_db_password , :gl_usercode_oebs, :is_md5
			from userMaster 
			where upper(userName) = upper(:as_username)
			using SQLCA;
			
			if SQLCA.Sqlcode = 100 then
				guo_func.msgbox("System Security...", "Username does not exist in the userMaster Table...", gc_Critical, gc_OkOnly, "")
				return false		
			else	
				
				if is_md5 = 0 then 				
					s_decrypted_password = guo_func.decrypt(trim(s_db_password))
					
					--VALIDASI password guo_func.decrypt(trim(s_db_password))
					return xdecrypt(xdecrypt(a_s_string))
					
					
					---decrypt
					int i
					string out
					for i = len(a_s_text) -1 to 1 step -2
						out = out + char(asc( mid(a_s_text,i,1))-1)
					next
					
					return OUT
					
					---xdecrypt
					int i,a
					string out
					randomize(0)
					for i = len(a_s_text) to 1 step -1
						a = rand(27) + 37
						out = out + char(asc( mid(a_s_text,i,1))+1) + char(a)
					next
					
					return OUT
					-------------------------------------------										
					
					if s_decrypted_password <> as_password then
						guo_func.msgbox('SM-0000024','',"First, Re-type carefully your password. ~r~n~r~nSecond, check if caps lock is on. ~r~n~r~nThird, check if username is correct. ~r~n~r~nLastly, administrators dont really know your password not until they debug it. Now, If you think you forgot your password you'll gonna have to request your administrator for a new account. and try not to loose your password again. ~r~n~r~nRegards, ~r~nMIS Dept.")
						return false
					else
						return true
					end if
				else
					select custom_hash(:as_password) into :ls_md5_password from dual
					using SQLCA;
						if s_db_password <> ls_md5_password then
							guo_func.msgbox('SM-0000024','',"First, Re-type carefully your password. ~r~n~r~nSecond, check if caps lock is on. ~r~n~r~nThird, check if username is correct. ~r~n~r~nLastly, administrators dont really know your password not until they debug it. Now, If you think you forgot your password you'll gonna have to request your administrator for a new account. and try not to loose your password again. ~r~n~r~nRegards, ~r~nMIS Dept.")
							return false
						else
							return true
						end if
							
					
				end if
			end if
			
		end if
		
		return TRUE
		----------------------------------------------------
	
		open(w_tbl_user_master) //kasama TO
		
	else
		guo_func.msgbox('Warning!', 'You are not a SYSTEM ADMINISTRATOR...')
	end if
	sle_UID.Text = ""
	sle_pword.text = ""
	return -1
else	
	if guo_func.validate_user(gs_username, ls_pword) then	
	
	---------VALIDASI guo_func.validate_user(gs_username, ls_pword)
		string	s_db_password, s_decrypted_password 
		int is_md5
		string ls_md5_password
		
		if upper(as_username) = 'SYSADMIN' then
		
			declare cur_user cursor for
				select u.password, u.is_md5
				from userMaster u 
				inner join sysAdminUser s on u.userName = s.userName
				using SQLCA;
		
			open cur_user;
			if SQLCA.sqlcode <> 0 then
				guo_func.msgbox("ATTENTION",string(SQLCA.sqlcode) + '~r~n' + SQLCA.sqlerrtext)
				return False
			end if
		
			fetch cur_user into :s_db_password, :is_md5;
			
			do while SQLCA.sqlcode = 0
				
				if is_md5 = 0 then 
					s_decrypted_password = guo_func.decrypt(trim(s_db_password))
					if s_decrypted_password = as_password then
						close cur_user;
						return True
					else
						fetch cur_user into :s_db_password, :is_md5;
					end if
				else
					select custom_hash(:as_password) into :ls_md5_password from dual
					using SQLCA;
					
					if s_db_password = ls_md5_password then
						close cur_user;
						return True
					else
						fetch cur_user into :s_db_password, :is_md5;
					end if
				end if 
			loop
			close cur_user;
			return False
		else
			
			select userCode,password,  usercode_oebs, is_md5
			into :gs_usercode,:s_db_password , :gl_usercode_oebs, :is_md5
			from userMaster 
			where upper(userName) = upper(:as_username)
			using SQLCA;
			
			if SQLCA.Sqlcode = 100 then
				guo_func.msgbox("System Security...", "Username does not exist in the userMaster Table...", gc_Critical, gc_OkOnly, "")
				return false		
			else	
				
				if is_md5 = 0 then 				
					s_decrypted_password = guo_func.decrypt(trim(s_db_password))
					
					--VALIDASI password guo_func.decrypt(trim(s_db_password))
					return xdecrypt(xdecrypt(a_s_string))
					
					
					---decrypt
					int i
					string out
					for i = len(a_s_text) -1 to 1 step -2
						out = out + char(asc( mid(a_s_text,i,1))-1)
					next
					
					return OUT
					
					---xdecrypt
					int i,a
					string out
					randomize(0)
					for i = len(a_s_text) to 1 step -1
						a = rand(27) + 37
						out = out + char(asc( mid(a_s_text,i,1))+1) + char(a)
					next
					
					return OUT
					-------------------------------------------										
					
					if s_decrypted_password <> as_password then
						guo_func.msgbox('SM-0000024','',"First, Re-type carefully your password. ~r~n~r~nSecond, check if caps lock is on. ~r~n~r~nThird, check if username is correct. ~r~n~r~nLastly, administrators dont really know your password not until they debug it. Now, If you think you forgot your password you'll gonna have to request your administrator for a new account. and try not to loose your password again. ~r~n~r~nRegards, ~r~nMIS Dept.")
						return false
					else
						return true
					end if
				else
					select custom_hash(:as_password) into :ls_md5_password from dual
					using SQLCA;
						if s_db_password <> ls_md5_password then
							guo_func.msgbox('SM-0000024','',"First, Re-type carefully your password. ~r~n~r~nSecond, check if caps lock is on. ~r~n~r~nThird, check if username is correct. ~r~n~r~nLastly, administrators dont really know your password not until they debug it. Now, If you think you forgot your password you'll gonna have to request your administrator for a new account. and try not to loose your password again. ~r~n~r~nRegards, ~r~nMIS Dept.")
							return false
						else
							return true
						end if
							
					
				end if
			end if
			
		end if
		
		return TRUE
		----------------------------------------
		
		----computer name
		uo_ws luo_ws
		if luo_ws.setComputerName(gs_loginworkstation) THEN
		
			---VALIDASI luo_ws.setComputerName(gs_loginworkstation)
			select workStationCode, 
					 workStationName, 
					 computerName, 
					 defaultLocationCode, 
					 glAccountCode,
					 workStationLocationCode,
					 defSalesPPCAcctNo,
					 forCCUse
			  into :workStationCode, 
					 :workStationName, 
					 :computerName, 
					 :defaultLocationCode, 
					 :glAccountCode,
					 :workStationLocationCode,
					 :defSalesPPCAcctNo,
					 :forCCUse
			  from workStationMaster
			where upper(computerName) = upper(:as_computerName)
			using SQLCA;
			if SQLCA.sqlCode = 100 then
				lastSQLCode		= string(SQLCA.sqlCode)
				lastSQLErrText	= 'Computer name [' + as_computerName + '] does not exist.'
				return FALSE
			elseif SQLCA.sqlCode < 0 then
				lastSQLCode		= string(SQLCA.sqlCode)
				lastSQLErrText	= SQLCA.sqlErrText
				return FALSE
			end if
			
			return TRUE
			----------------------------------------------------------------
			
			luo_ws.workStationCode = workStationCode
			luo_ws.workStationLocationCode = workStationLocationCode
			
			if isNull(luo_ws.workStationLocationCode) or luo_ws.workStationLocationCode = '' then
				guo_func.msgbox('Warning!', 'Unable to continue please set Workstation Locationcode in [WorkStationMaster]')
				return -1
			end if
			gs_stationCode = luo_ws.workStationCode
			gs_workStationLocationCode = luo_ws.workStationLocationCode
		else
			guo_func.msgbox('Warning!', luo_ws.lastSQLCode  + '~r~n' + luo_ws.lastSQLErrText)
			if guo_func.adminUsers(ls_adminLog, gs_userCode) then
				if ls_adminLog = 'N' then
					shl_managews.visible = true	
				else
					shl_managews.visible = false
				end if
			end if
			return -1
		end if
		//end
		
		
		//check if ibas in the workstation of the user is updated this day if not then live update will be excecuted once for this day

		ldt_trandate = guo_func.get_server_datetime()
		
		ls_trandate = string(ldt_trandate,'DD-MM-YY')
		
		ls_uppertrandate = upper(ls_trandate)
		
		ls_exe = 'IBAS ORACLE UPDATE FORCE.bat'
		
		if ls_exe = 'IBAS ORACLE UPDATE FORCE.bat' then
			gs_version = 'PB10'
		end if 	
		
		select dateibasupdate into :ldt_dateibasupdate
		from ibasupdatehistorymaster
		where computername = :gs_loginworkstation
		and to_char(dateibasupdate,'DD-MM-YY') = :ls_uppertrandate
		and version = :gs_version
		and rownum < 2
		using SQLCA;
		
		ls_dateibasupdate = upper(string(ldt_dateibasupdate,'DD-MM-YY'))
		
		if ls_dateibasupdate <> ls_uppertrandate then
		
		if not fileExists(ls_exe) then
			guo_func.msgbox('Warning!', ls_exe + ' not found...', 'Please contact your system administrator.')
			return
		end IF
		
		run(ls_exe)
			
			if uf_insertibasupdatehistorymaster() then	
			end if			
			
			commit using SQLCA;
			
			halt close			
		
		else
		end if 
		
		//station code		
		if not luo_ws.get_computer_stationCode(gs_computerStationCode) then			
			guo_func.msgbox('Warning!', luo_ws.lastSQLCode  + '~r~n' + luo_ws.lastSQLErrText)
			return -1
		end if	
		
		---VALIASI luo_ws.get_computer_stationCode(gs_computerStationCode)
		
		string ls_iniFile
		boolean lb_fileExist
		
		ls_iniFile = 'SYSTEM.INI'
		
		lb_fileExist = fileExists(ls_iniFile)
		
		if not lb_fileExist then
			lastSQLCode	= '-1'
			lastSQLErrText	= 'The file SYSTEM.INI does not exist'
			return FALSE
		end if
		
		--THIS DATA FROM SYSTEM.INI FILE, IN REACT CREATE IN ENV FILE
		as_computerStationCode = profileString(ls_iniFile, 'STATION', 'Code', '')
		
		gs_computerStationCode = as_computerStationCode
		
		return TRUE
		-------------------------
		
		
		if guo_func.adminUsers(ls_adminLog, gs_userCode) then
			if not ls_adminLog = 'N' then
			/*	if not trim(gs_stationCode) = trim(gs_computerStationCode) then
					guo_func.msgbox('Warning!', 'Your current Work Station Code [' + gs_stationCode+ '] does not match in SYSTEM.INI file' )
					return -1
				end if*/
			end if
		end IF
		
		--validation for not equal station code guo_func.adminUsers(ls_adminLog, gs_userCode)
		
		lastMethodAccessed = 'adminUsers'

		select userName
		into :as_userCode
		from sysAdminUser
		where userName = :as_userCode
		using SQLCA;
		if SQLCA.SQLCode = 0 then
			as_log = 'N'
		end if	
		
		return TRUE
		----------------------------------
		
		--Validate Password Expiration
	
		string ls_implemented, ls_validate 
		datetime ldt_expDate
		date ld_expDate, ld_currentDate	
	
		ld_currentDate	= date(guo_func.get_server_date())
	
		select implemented 
		  into :ls_implemented 
		  from systemPolicies 
		 where policyName = 'PASSWORD EXPIRES'
		 and divisionCode = :gs_divisionCode
		 and companyCode = :gs_companyCode
		using SQLCA;
		
		ls_implemented = trim(ls_implemented) 
	
		if ls_implemented = 'Y' then
				
			select expdate into :ldt_expDate
			  from userMaster 
			 where userCode = :gs_usercode
			 using SQLCA;
			
			ld_expDate	= date(ldt_expDate)
			
			if ld_currentDate >= ld_expDate then
				guo_func.msgbox('Attention!!!', 'Your Password has expired. You need to enter new one. You may ask your manager to reset your password expiration date..')
				
				--open
				open(w_change_password) 
				
				ls_validate	=	trim(message.stringparm)
				
				if ls_validate = 'FAILED' then
					sle_uid.setfocus()						
					rollback using SQLCA;
					return -1
				end if	
			end if						
		end if
			
		--end validation of Password 
		
		string ls_log, ls_CompName
		datetime dt_login_time
		dt_login_time = guo_func.get_server_date()
	
		select loggedIn, loggedInWorkStation 
		  into :ls_Log, :ls_compName 
		  from userMaster 
		 where upper(userName) = upper(:gs_username )
		 using SQLCA;	

		if not guo_func.adminUsers(ls_log, gs_userCode) then
			guo_func.msgbox('Error occured', guo_func.lastSQLCode + '~r~n' + guo_func.lastSQLErrText + &
									'~r~n' + 'Method: ' + guo_func.lastMethodAccessed)
			return -1
		end if
			 
		if ls_log = 'Y' then 
			if upper(trim(gs_loginworkstation)) <> upper(trim(ls_compname)) then 
				i_b_log_failed = true
				guo_func.msgbox("User is currently logged in...", "User is logged in : {" + trim(ls_compName) + "}" + &
									  "~n~rPls. Contact the System Administrator ? ", gc_Information, gc_OkOnly, "")
				return
			else //added
				select companyid, barcodeLength
				  into :gs_companyid, :gi_barcodelength
				  from systemParameter
				 where divisionCode = :gs_divisionCode
		 			and companyCode = :gs_companyCode
				using SQLCA;
				if SQLCA.sqlcode <> 0 then
					guo_func.msgbox("SM-0000001")
					close(parent)
					return
				end if					
				
				if isnull(gi_barcodelength) then gi_barcodelength = 8
				
				if i_b_log_failed then
					Openwithparm(w_mdiFrame,'LOG_FAILED')
				else
					gs_username = upper(gs_username)
					open(w_mdiframe)
				end if
			end if
		else	

			update userMaster
				set loggedIN = 'Y', 
					 loggedInWorkstation = :st_computer_name.text,
					 loggedintime = :dt_login_time,
					 imEnabled = 'Y'
			 where userName = :gs_username
			 using SQLCA ;	
			if SQLCA.Sqlcode <> 0 then
				guo_func.msgbox("Error Locking UserMaster...", &
							  "SQLCode    : " + string(SQLCA.SQLCODE) + &
							  "SQLERRTEXT : " + SQLCA.SQLERRTEXT + &
							  "SQLDBCODE  : " + string(SQLCA.SQLDBCODE) , &
							  gc_Critical, gc_OkOnly, "")
				rollback using SQLCA;
				sle_uid.setfocus()						
				return 0
			else	
				commit using SQLCA ;
													
				select companyid, barcodeLength
				  into :gs_companyid, :gi_barcodelength
				  from systemParameter
				 where divisionCode = :gs_divisionCode
		 		 and companyCode = :gs_companyCode
				 using SQLCA;
				if SQLCA.sqlcode = 100 then				
					return
				end if
				
				if not luo_user.getUserLogInfo(gs_userCode, 'Y') then
					guo_func.msgbox('Warning!', '~r~nSQL Error Code ' + luo_user.lastSQLCode + &
															'~r~nSQL Error Text ' + luo_user.lastSQLErrText + &
															'' + luo_user.lastMethodAccessed)
					return -1
				end if
				
				if isnull(gi_barcodelength) then gi_barcodelength = 8
				
				if i_b_log_failed then
					Openwithparm(w_mdiFrame,'LOG_FAILED')
				else
					gs_username = upper(gs_username)
					open(w_mdiframe)
				end if
			end if	
		end if
	else
		return 0
	end if
end if		

gb_clickbymenu = false 

Close(Parent)
				
		