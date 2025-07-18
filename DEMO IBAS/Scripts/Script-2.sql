SELECT * FROM Artranhdr WHERE DIVISIONCODE = 'NLZNT' 

--ADD BUTTON
long ll_tranno
string ls_disconnectionRemarksCode

if not guo_func.get_nextnumber_continous('DISREM',ll_tranno,'') then
	return 
end IF

--validasi guo_func.get_nextnumber_continous('DISREM',ll_tranNo,'WITH LOCK')
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

ls_disconnectionRemarksCode = string(ll_tranno,"00")
dw_2.setitem(dw_2.getRow(),"disconnectionremarkscode",ls_disconnectionRemarksCode)
dw_2.setitem(dw_2.getrow(), "companyCode", gs_companycode)
dw_2.setitem(dw_2.getrow(), "divisioncode", gs_divisionCode)
dw_2.setitem(dw_2.getrow(), "useradd", gs_username)
dw_2.setitem(dw_2.getrow(), "dateadd", guo_func.get_server_date())

--SAVE BUTTON
long ll_tranno
string ls_disconnectionremarkscode

if not guo_func.get_nextnumber_continous('DISREM',ll_tranNo,'WITH LOCK') then
	return 
end IF

--validasi guo_func.get_nextnumber_continous('DISREM',ll_tranNo,'WITH LOCK')
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

ls_disconnectionremarkscode = string(ll_tranno,"00")
dw_1.setItem(dw_1.getrow(),"disconnectionremarkscode",ls_disconnectionremarkscode)

if not guo_func.set_Number_continous('DISREM',ll_tranNo) then
	return 
end if	

--VALIDASI guo_func.set_Number_continous('DISREM',ll_tranNo)
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
end IF

