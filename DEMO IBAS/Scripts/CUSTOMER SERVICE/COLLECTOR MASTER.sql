---QUEERY COLLECTOR MASTER FORM

SELECT  collectormaster.collectorcode ,     
			collectormaster.collectorname ,    
			collectormaster.collectortypecode ,  
			collectormaster.active ,      
			collectormaster.printdocument,
			collectormaster.divisioncode,
			collectormaster.companyCode
    FROM collectormaster    
    where collectorMaster.companyCode = :as_company and
			collectorMaster.divisioncode = :as_division
			
	--SEARCH COLLECTOR TYPE TO KEY IN DATA IN FORM	
	
	string ls_collectortypeName, ls_collectortypeCode
	long ll_row
	
	str_search str_s
	ll_row = dw_1.getrow()
	
	if as_search = "collectortype" then
	
		str_s.s_dataobject = "dw_search_collectortype"
		str_s.s_return_column = "collectortypecode"
		str_s.s_title = "Search For Customer Type"
		
		--QUERY SEARCH COLLECTOR TYPE
		 SELECT  collectorTypeMaster.collectorTypeName ,
		 collectorTypeMaster.collectorTypeCode
		 FROM collectorTypeMaster   
		 
		
		openwithparm(w_search_ancestor,str_s)
	
		ls_collectortypecode	= trim(message.stringparm)  
	
		if ls_collectortypecode <> '' then
	
			select collectortypename
			into :ls_collectortypeName
			from collectorTypeMaster
			where collectortypecode = :ls_collectortypecode
			using SQLCA;
	
			if SQLCA.SQLCode = 100 then
				guo_func.msgbox("IC-0000003")
			elseif SQLCA.sqlcode < 0 then
				guo_func.msgbox("IC-0000002")
			else
				
				dw_1.setitem(ll_row,'collectorTypeCode', ls_collectortypecode)
			
			end if
		end if
		
	end if	
	
	return 0

--BUTTON ADD
dw_1.object.b_type.visible = true
dw_1.setitem(dw_1.getrow(), 'divisioncode',gs_divisionCode)
dw_1.setitem(dw_1.getrow(), 'companycode',gs_companyCode)
dw_1.setitem(dw_1.getRow(), "active",'Y')   // LD - 08202010
dw_1.object.active.protect = 1		

--SET DEFAUULT VALUE IN FORM ,divisioncode,companycode,active

--BUTTON EDIT

integer li_count

select count(*)
  into :li_count
  from userRightsMaster
 where userCode = :gs_usercode and 
 		 rightsCode = 'AC006'
 and divisionCode = :gs_divisionCode
and companyCode = :gs_companyCode
using SQLCA;
if SQLCA.sqlcode = 0 and li_count > 0 then
	dw_1.object.active.protect = 0
else
	dw_1.object.active.protect = 1
end IF

--SET FROM  active field with disable true or false

--BUTTON SAVE

String ls_collectorcode, ls_collectorname, ls_colCode

ls_collectorcode = i_dw.getitemstring(i_dw.getRow(),"collectorcode")
ls_collectorname = i_dw.getitemstring(i_dw.getRow(),"collectorname")
	
select collectorCode
into	 :ls_colCode
from	 collectormaster
where collectorCode = :ls_collectorcode
and companyCode = :gs_companyCode
and divisionCode = :gs_divisionCode
using sqlca;
if sqlca.sqlcode < 0 then
	Messagebox("Error in SQL",'This collectorCode  was already exist in collectorMaster!')
	rollback using sqlca;
	return
else
	if i_dw.update() = 1 then
		wf_enabledisable_buttons("first, previous, next, last, search, filter, add, edit, delete, close")
		i_dw.retrieve(gs_companyCode,gs_divisionCode)
		i_dw.enabled = true
		i_dw.object.datawindow.readonly = true
		ib_addingediting = FALSE
	end if
End if

dw_1.object.b_type.visible = FALSE

guo_func.msgBox("Saving Complete.", "You have successfully saved your entry.")

--INSERT THE DATA TO Table collectormaster

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

--DELETE THE DATA FROM Table collectormaster BY ID

