--QUERY FORM INPUT 

SELECT linemanmaster.linemancode,
		   linemanmaster.linemanname,
		   linemanmaster.useradd ,           
		   linemanmaster.dateadd,
		   linemanmaster.divisionCode,
		   linemanmaster.companyCode
   FROM linemanmaster
INNER JOIN locationMaster on linemanmaster.linemancode = locationMaster.locationCode
		AND  linemanmaster.companyCode = locationMaster.companyCode
		AND  locationMaster.isActive = 'Y'
	WHERE  linemanmaster.companyCode = :as_company 
	
	
--BUTTON ADD

long ll_tranno
string ls_linemancode


il_current_row = i_dw.getrow()				--just in case they undo the changes in the data window
il_current_row  = i_dw.insertrow(0)
i_dw.scrollToRow(il_current_row)
i_dw.setfocus()
i_dw.enabled = true
i_dw.object.datawindow.readonly = false
i_dw.setcolumn(1)

ib_add_edit = TRUE	// may be use in ue_validate event
ib_addingediting = TRUE

wf_enabledisable_buttons("save, undo")		--the user has to save or undo the changes he made

if not guo_func.get_nextnumber_company('LOCATION',ll_tranno,'') then
	return 
end IF

--VALIDASI get_nextnumber_company
f_displayStatus("Retrieving next transaction # for " + as_trantype + "...")

string	ls_lockedby

select lockedUserName
  		into :ls_lockedby
from sysTransactionParam
 		where tranTypeCode = :as_tranType 
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

--END VALIDASI 

--SET DEFAULT VALUE IN FORM
ls_linemancode = string(ll_tranno,"00000")
dw_1.setitem(il_current_row ,"linemanCode",ls_linemancode)
dw_1.setitem(il_current_row , "useradd", gs_username)
dw_1.setitem(il_current_row , "dateadd", datetime(today(),now()))
dw_1.setitem(il_current_row , "divisioncode", gs_divisionCode)
dw_1.setitem(il_current_row , "companycode", gs_companyCode)

--BUTTON EDIT
JUST MAKE FORM ENABLED CAN EDIT , CODE DISABLED

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

--JUST DELETE THE DATA FROM TABLE linemanmaster BY ID

--BUTTON SAVE

string ls_code, ls_name, ls_loccode, ls_sqlcode, ls_sqlerrtext
datetime ldtme_Date
long ll_tranno
string ls_linemanCode

i_dw.accepttext()
if not guo_func.get_nextnumber_company('LOCATION',ll_tranNo,'WITH LOCK') then
	return 
end IF

--VALIDASI get_nextnumber_company

f_displayStatus("Retrieving next transaction # for " + as_trantype + "...")

string	ls_lockedby

select lockedUserName
  		into :ls_lockedby
from sysTransactionParam
 		where tranTypeCode = :as_tranType 
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

--END VALIDASI 


ls_linemanCode = string(ll_tranno,"00000")
i_dw.setItem(il_current_row ,"linemanCode",ls_linemanCode)

if not guo_func.set_Number_company('LOCATION',ll_tranNo) then
	return 
end if	

--VALIDASI guo_func.set_Number_company
	
update sysTransactionParam
	set recordLocked = 'N',
		 lockedUserName = '',
		 lastTransactionNo = :al_tranno
where recordLocked = 'Y' 
		and companyCode  = :gs_companyCode
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

--END VALIDASI 


if i_dw.update() = 1 then
	wf_enabledisable_buttons("first, previous, next, last, search, filter, add, edit, delete, close")
	i_dw.enabled = true
	i_dw.object.datawindow.readonly = true
	ib_addingediting = FALSE
else
	rollback using sqlca;
	return
end if

ls_code = i_dw.getitemstring(il_current_row ,"linemancode")
ls_name = i_dw.getitemstring(il_current_row ,"linemanname	")
ldtme_Date = guo_func.get_server_Date()
	
select locationCode
into	 :ls_locCode
from	 locationmaster
where locationcode = :ls_code
and companyCode = :gs_companyCode
using sqlca;
if sqlca.sqlcode <= 0 then
	
	guo_func.msgbox("Error in SQL",sqlca.sqlerrtext)
	rollback using sqlca;
	return
	
elseif sqlca.sqlcode =100 then
	
	insert into locationmaster
		(locationCode,
		locationName,
		address1,
		address2,
		locationTypeCode,
		isActive,
		userName,
		dateAdd,
		divisionCode,
		companyCode)
	values
		(	:ls_code,
			:ls_name,
			'-',
			'-',
			'001',
			'Y',
			:gs_username,
			:ldtme_date,
			:gs_divisionCode,
			:gs_companyCode
		)
		using sqlca;
		ls_sqlcode = string(sqlca.sqlcode)
		ls_sqlerrtext = sqlca.sqlerrtext
		if sqlca.sqlcode <> 0 then
			guo_func.msgbox("Error in INSERT", ls_sqlerrtext)	
			rollback using sqlca;
			return
		end if
		commit using sqlca;
		
end if

i_dw.retrieve(gs_companyCode)

