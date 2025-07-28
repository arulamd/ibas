--QUERY FORM

  SELECT  provincemaster.provincecode ,
  provincemaster.provincename ,
  provincemaster.useradd ,
  provincemaster.dateadd
  FROM provincemaster    
  
 --BUTTON ADD
  
 long ll_tranno
string ls_provinceCode

il_current_row = i_dw.getrow()				// just in case they undo the changes in the data window
i_dw.scrolltorow(i_dw.insertrow(0))
i_dw.setfocus()
i_dw.enabled = true
i_dw.object.datawindow.readonly = false
i_dw.setcolumn(2)

if not guo_func.get_nextnumber_continous('PROVINCE',ll_tranno,'') then
	return 
end IF

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

return true

--END VALIDASI get_nextnumber_continous

ls_provinceCode = string(ll_tranno,"00000")
dw_1.setitem(dw_1.getRow(),"provinceCode",ls_provinceCode)

wf_enabledisable_buttons("save, undo")		--the user has to save or undo the changes he made

ib_add_edit = TRUE	// may be use in ue_validate event
ib_addingediting = TRUE

--BUTTON EDIT

il_current_row = i_dw.getrow()				// just in case they undo the changes in the data window
i_dw.enabled = true
i_dw.object.datawindow.readonly = false
wf_enabledisable_buttons("save, undo")

ib_add_edit = FALSE	// may be use in ue_validate event
ib_addingediting = TRUE

--JUST MAKE FORM ENABLED SO CAN EDIT THE FORM

--BUTTON DELETE

integer ans
ans = guo_func.msgbox(is_title, "You are about to delete the current record!",	gc_Information, gc_OkCancel, "Choose Ok to proceed.");
integer i_update
if ans = 1 then
	i_dw.deleterow(i_dw.getrow());
	if i_dw.update() < 0 then
		i_dw.retrieve();
	end if
end IF

JUST DELETE THE DATA FROM TABLE provincemaster

--BUTTON SAVE

if i_dw.update() = 1 then
	wf_enabledisable_buttons("first, previous, next, last, search, filter, add, edit, delete, close")
	i_dw.retrieve()
	i_dw.enabled = true
	i_dw.object.datawindow.readonly = true
	ib_addingediting = FALSE
end if

long ll_tranno
string ls_provinceCode
dw_1.accepttext()
if not guo_func.get_nextnumber_continous('PROVINCE',ll_tranNo,'WITH LOCK') then
	return 
end IF

----VALIDASI get_nextnumber_continous

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

--END VALIDASI get_nextnumber_continous

ls_provinceCode = string(ll_tranno,"00000")
dw_1.setItem(dw_1.getrow(),"provinceCode",ls_provinceCode)

if not guo_func.set_Number_continous('PROVINCE',ll_tranNo) then
	return 
end if	

--VALIDASI set_Number_continous

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

--END VALIDASI set_Number_continous