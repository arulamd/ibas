--USER MASTER
SELECT  *
FROM usermaster  WHERE USERCODE ='ARUL';

s_user_code = i_dw.getitemstring(currentrow,'usercode')
l_ret = i_dw_2.retrieve(s_user_code, gs_divisionCode)

--USER RIGHT
 SELECT  userrightsmaster.usercode ,           
			userrightsmaster.rightscode,
         userrightsmaster.divisionCode,
         userrightsmaster.companyCode     
FROM userrightsmaster      
WHERE ( userrightsmaster.usercode = :a_s_user_code ) and ( userrightsmaster.divisionCode = :as_division )  


--BUTTON SAVE
if i_dw.update() = 1 then
	//
ls_usertype = trim(dw_2.getitemstring(dw_2.getrow(),"usertypecode"))
ls_usercode	= trim(dw_2.getitemstring(dw_2.getrow(),"usercode"))
ls_fullname = trim(dw_2.getitemstring(dw_2.getrow(),"fullname"))

select usertypename
into   :ls_name
from   usertypemaster
where  usertypecode =:ls_usertype
using SQLCA;

if SQLCA.sqlcode <> 0 then
	guo_func.msgbox("ERROR SQL Usertypemaster",sqlca.sqlerrtext)
	return 
end if

dw_2.AcceptText()

ls_password = dw_2.GetItemString(dw_2.GetRow(),'new_password')

select custom_hash(:ls_password) into :ls_save_password from dual ;

select userCode
into   :ls_name
from   userMaster
where  userCode =:ls_usercode
using SQLCA;

update userMaster
set password = :ls_save_password
where  userCode =:ls_usercode ;

if SQLCA.sqlcode = 0 then
	COMMIT;
end if

if trim(ls_name) = 'CASHIER' then
	select collectorcode
	into   :ls_temp
	from   collectormaster
	where collectorcode = :ls_usercode
	using sqlca;
	if sqlca.sqlcode = 100 then	
		insert into collectormaster
					 (collectorcode, 
					 collectorname,
					 collectorTypeCode,
					 active, 
					 printdocument,
					 remit,
					 threshold,
					 companyCode,
					 divisionCode,
					 collectorfeephp,
					 collectorfeeusd)
			values (:ls_usercode,
					  :ls_fullname,
					  'CASHR',
					  'Y',
					  'Y',
					  null,
					  25,
					  :gs_companyCode,
					  :gs_divisionCode,
					  0,
					  0)
		using SQLCA;
		commit using SQLCA;
		if SQLCA.sqlcode =-1 then
			guo_func.msgbox("ERROR INSERTING CollectorMaster", sqlca.sqlerrtext)
			rollback using SQLCA;
			return
		end if
	end if	
end if

	//
	wf_enabledisable_buttons("first, previous, next, last, search, filter, add, edit, delete, close")
	i_dw.retrieve()
	i_dw.enabled = true
	i_dw.object.datawindow.readonly = true
	ib_addingediting = FALSE
end if

i_dw_2.object.datawindow.readonly = true


--ADD USER RIGHT

SELECT '' c_selected,   
		rightsmaster.rightscode,   
		rightsmaster.rightsname,   
		rightsmaster.module,   
		rightsmaster.type  
 FROM rightsmaster   
 
 
 string	ls_selected_rights[]
long		ll_row, ll_records

ll_records = dw_1.rowcount()
for ll_row = 1 to ll_records
	if dw_1.getitemstring(ll_row, "c_selected") = 'Y' then
		ls_selected_rights[upperbound(ls_selected_rights) + 1] = dw_1.getitemstring(ll_row, "rightscode")
	end if
next
ll_records = upperbound(ls_selected_rights)
parent.parentwindow().trigger dynamic event ue_add_multiple_rights(ls_selected_rights)


datawindow dw_ur
dw_ur = tab_1.tabpage_1.dw_3

picture p_progress
p_progress = tab_1.tabpage_1.p_progress

long	ll_newrow, ll_row, ll_records

dw_ur.visible = FALSE
p_progress.visible = TRUE

ll_records = dw_ur.rowcount()
//for ll_row = 1 to ll_records
do while dw_ur.rowcount() > 0
	dw_ur.deleterow(dw_ur.getrow())
loop
//next

ll_records = upperbound(as_rights_code)
for ll_row = 1 to ll_records

	ll_newrow = dw_ur.insertrow(0)
	dw_ur.scrolltorow(ll_newrow)
	dw_ur.setitem(ll_newrow, "rightscode", as_rights_code[ll_row])
	dw_ur.setitem(ll_newrow, "divisioncode", gs_divisionCode)
	dw_ur.setitem(ll_newrow, "companycode", gs_companyCode)
next

dw_ur.visible = TRUE
p_progress.visible = FALSE
