--QUERY FORM
SELECT	subdivisionCode,
			subdivisionName,
			userAdd,
			dateAdd
from subdivisionMaster


BUTTON ADD :

long ll_tranno
string ls_subdivisionCode

il_current_row = i_dw.getrow()				// just in case they undo the changes in the data window
i_dw.scrolltorow(i_dw.insertrow(0))
i_dw.setfocus()
i_dw.enabled = true
i_dw.object.datawindow.readonly = false
i_dw.setcolumn(2)

if not guo_func.get_nextnumber_continous('SUBDIVISION',ll_tranno,'') then
	return 
end if

--VALIDASI get_nextnumber_continous
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

ls_subdivisionCode = string(ll_tranno,"000000")
dw_1.setitem(dw_1.getRow(),"subdivisionCode",ls_subdivisionCode)


wf_enabledisable_buttons("save, undo")		// the user has to save or undo the changes he made

ib_add_edit = TRUE	// may be use in ue_validate event
ib_addingediting = TRUE

BUTTON EDIT :

il_current_row = i_dw.getrow()				// just in case they undo the changes in the data window
i_dw.enabled = true
i_dw.object.datawindow.readonly = false
wf_enabledisable_buttons("save, undo")

ib_add_edit = FALSE	// may be use in ue_validate event
ib_addingediting = TRUE

--JUST OPEN THE FORM SET ENABLED = TRUE CAN CHANGE THE VALUE FORM

BUTTON DELETE:

integer ans
ans = guo_func.msgbox(is_title, "You are about to delete the current record!",	gc_Information, gc_OkCancel, "Choose Ok to proceed.");
integer i_update
if ans = 1 then
	i_dw.deleterow(i_dw.getrow());
	if i_dw.update() < 0 then
		i_dw.retrieve();
	end if
end if
--JUST DELETE THE DATA FROM TABLE subdivisionMaster BY ID

BUTTON SAVE:

long ll_tranno
string ls_subdivisionCode

dw_1.accepttext()

If ib_add_edit = TRUE then
	if not guo_func.get_nextnumber_continous('SUBDIVISION',ll_tranNo,'WITH LOCK') then
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
		
		return true
	--END VALIDASI
	
	ls_subdivisionCode = string(ll_tranno,"000000")
	dw_1.setItem(dw_1.getrow(),"subdivisionCode",ls_subdivisionCode)
	
	if not guo_func.set_Number_continous('SUBDIVISION',ll_tranNo) then
		return 
	end IF
	
	--VALIDASI not guo_func.set_Number_continous
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
		
		return true
	--END VALIDASI
		
End if

if i_dw.update() = 1 then
	wf_enabledisable_buttons("first, previous, next, last, search, filter, add, edit, delete, close")
	i_dw.retrieve()
	i_dw.object.datawindow.readonly = true
	i_dw.enabled = TRUE
	ib_addingediting = FALSE
end if
