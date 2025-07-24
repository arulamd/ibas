--QUERY FORM
 SELECT  barangaymaster.barangayCode ,
 barangaymaster.barangayName ,
 barangaymaster.municipalityCode ,
 barangaymaster.mapXpos ,
 barangaymaster.mapYpos ,
 barangaymaster.mapHandle
 FROM barangaymaster   


 EVENT BUTTON CLICK IN FORM:


  dec{0}   xpos, ypos
string handle
if (row = this.getRow()) then
		
		///////////////////////////////////////////////////////
		//   G E T   G I S   M A P   H A N D L E
		///////////////////////////////////////////////////////
		
		if dwo.name = 'b_1' then
			
			ole_1.object.apptivate()
			
			ole_1.object.GetTextCoor()
			xpos = ole_1.object.xp
			ypos = ole_1.object.yp
			handle = ole_1.object.enthandle
			
			this.setItem(row,'maphandle',handle)
			this.setItem(row,'mapxpos',xpos)
			this.setItem(row,'mapypos',ypos)
		end if	
		
		///////////////////////////////////////////////////////
		//   L O C A T E
		///////////////////////////////////////////////////////
		
		if dwo.name = 'b_2' then
			xPos = getItemDecimal(row,'mapxpos')
			yPos = getItemDecimal(row,'mapypos')
			if not isNull(xPos) or not isNull(yPos) then			
				ole_1.object.apptivate()
				ole_1.object.xposition = xPos
				ole_1.object.yposition = yPos
				ole_1.object.magnification = 500
				ole_1.object.Locate()
			end if
		end if	
		
		///////////////////////////////////////////////////////
		//   G E N E R A T E    D W F
		///////////////////////////////////////////////////////
		
		
		if dwo.name = 'b_3' then
			string ls_plotFileName, ls_brgyCode, ls_brgyName, ls_dwfserver, ls_default
			boolean lb_fileExists
			integer ans
			
			select itemValue into :ls_dwfserver
			from sysParamString
			where itemName = 'DWFPATH'
			and divisionCode = :gs_divisionCode
			and companyCode = :gs_companyCode
			Using SQLCA;
			if SQLCA.SQLCode <> 0 then
					guo_func.MsgBox('Error inserting value to variable ls_dwfserver', &
										 'SQL Error Code : ' + string(SQLCA.SQLCode) + &
										 'SQL Error Text : ' + SQLCA.SQLErrText)
										 return
			end if						 		
			ls_brgyCode 		= tab_1.Tabpage_1.dw_1.getItemString(tab_1.Tabpage_1.dw_1.getRow(),'barangaycode')
			ls_plotFileName 	= ls_dwfserver+'brgy-'+ls_brgyCode+'.dwf'
		    ls_default			= ls_dwfserver+'default'+'.dwf'
			SELECT barangayName INTO :ls_brgyName FROM barangayMaster
			WHERE barangayCode = :ls_brgyCode
			USING SQLCA;
			if SQLCA.SQLCode <> 0 then
					guo_func.MsgBox('Error inserting value to variable ls_brgyName', &
										 'SQL Error Code : ' + string(SQLCA.SQLCode) + &
										 'SQL Error Text : ' + SQLCA.SQLErrText)
										 return
			end if						 		
			
			lb_fileExists = fileExists(ls_plotFileName)
				
			if lb_fileExists = False then
				ole_1.object.PlotFileName = ls_plotFileName
				ole_1.object.GenerateDWF()
			else
				ans = guo_func.msgbox(is_title, "DWF for barangay "+ls_brgyName+" Already Exist.. Do you wish to override the existing file?",	gc_Information, gc_OkCancel, "Choose Ok to proceed.");
				if ans = 1 then
					tab_1.tabpage_2.ole_2.object.navigateToUrl(ls_default)
					fileDelete(ls_plotFileName)
					ole_1.object.PlotFileName = ls_plotFileName
					ole_1.object.GenerateDWF()
				end if
				return
			end if			
		end if	
end if
RETURN
----










BUTTON ADD :


long ll_tranno
string ls_barangaycode
il_current_row = i_dw.getrow()				// just in case they undo the changes in the data window
i_dw.scrolltorow(i_dw.insertrow(0))
i_dw.insertrow(0)
i_dw.setfocus()
i_dw.enabled = true
i_dw.object.datawindow.readonly = false
i_dw.setcolumn(1)
if not guo_func.get_nextnumber_continous('BARANGAY',ll_tranno,'') then
	return
end IF
--VALIDASI guo_func.get_nextnumber_continous
f_displayStatus("Retrieving next transaction # for " + as_trantype + "...")
string	ls_lockedby
select lockedUserName
 		into :ls_lockedby
from sysTransactionParam
		where tranTypeCode = :as_tranType
		and companyCode = :gs_companyCode
		and divisionCode = :gs_divisionCode
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
		   and companyCode = :gs_companyCode
		   and divisionCode = :gs_divisionCode
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
	 and companyCode = :gs_companyCode
		and divisionCode = :gs_divisionCode	
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
ls_barangaycode = string(ll_tranno,"000000")
tab_1.tabpage_1.dw_1.setitem(tab_1.tabpage_1.dw_1.getRow(),"barangayCode",ls_barangaycode)
wf_enabledisable_buttons("save, undo")		// the user has to save or undo the changes he made
ib_add_edit = TRUE	// may be use in ue_validate event
ib_addingediting = True
il_row = i_dw.getrow()


BUTTON EDIT :


il_current_row = i_dw.getrow()				// just in case they undo the changes in the data window
i_dw.enabled = true
i_dw.object.datawindow.readonly = false
wf_enabledisable_buttons("save, undo")
ib_add_edit = FALSE	// may be use in ue_validate event
ib_addingediting = TRUE
il_row = i_dw.getrow( )


--JUST MAKE FORM ENABLE CAN EDIT


BUTTON DELETE:


integer ans
ans = guo_func.msgbox(is_title, "You are about to delete the current record!",	gc_Information, gc_OkCancel, "Choose Ok to proceed.");
integer i_update
if ans = 1 then
	i_dw.deleterow(i_dw.getrow());
	if i_dw.update() < 0 then
		i_dw.retrieve();
	end if
end IF
--JUST DELETE FROM TABLE barangaymaster BY ID


BUTTON SAVE :


long ll_tranno
string ls_barangaycode
if not guo_func.get_nextnumber_continous('BARANGAY',ll_tranNo,'WITH LOCK') then
	return
end IF
--VALIDASI guo_func.get_nextnumber_continous
f_displayStatus("Retrieving next transaction # for " + as_trantype + "...")
string	ls_lockedby
select lockedUserName
 		into :ls_lockedby
from sysTransactionParam
		where tranTypeCode = :as_tranType
		and companyCode = :gs_companyCode
		and divisionCode = :gs_divisionCode
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
		   and companyCode = :gs_companyCode
		   and divisionCode = :gs_divisionCode
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
	 and companyCode = :gs_companyCode
		and divisionCode = :gs_divisionCode	
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
ls_barangaycode = string(ll_tranno,"000000")
tab_1.tabpage_1.dw_1.setItem(tab_1.tabpage_1.dw_1.getrow(),"barangaycode",ls_barangaycode)
if not guo_func.set_Number_continous('BARANGAY',ll_tranNo) then
	return
end if	
--VALIDASI guo_func.set_Number_continous
update sysTransactionParam
	set recordLocked = 'N',
		 lockedUserName = '',
		 lastTransactionNo = :al_tranno
where recordLocked = 'Y'
		and trantypecode = :as_trantype
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
--END VALIDASI
if i_dw.update() = 1 then
	wf_enabledisable_buttons("first, previous, next, last, search, filter, add, edit, delete, close")
	i_dw.retrieve()
	i_dw.enabled = true
	i_dw.object.datawindow.readonly = true
	ib_addingediting = FALSE
	i_dw.scrolltorow( il_row)
	commit using SQLCA;
end if
rollback using SQLCA;
