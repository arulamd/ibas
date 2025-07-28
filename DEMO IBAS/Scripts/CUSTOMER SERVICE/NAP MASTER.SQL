--QUERY FORM HEADER
  
  SELECT NODECODE,   
         NAPCODE,   
         NAPNAME,   
         NOOFPORTS,   
         GPSLAT,   
         GPSLONG,   
         DIVISIONCODE,   
         COMPANYCODE  ,
		OLTCODE
    FROM NAPMASTER   
where divisioncode = :as_division and companycode = :as_company

--QUERY FORM DETAIL

 SELECT NAPCODE,   
         PORTNO,   
         ACCTNO,   
         PORTSTATUS  
    FROM NAPPORTASSIGNMENT   
where napcode = :as_napcode and divisioncode = :as_division and companycode = :as_company

BUTTON ADD :

il_current_row = i_dw.getrow()				// just in case they undo the changes in the data window
i_dw.scrolltorow(i_dw.insertrow(0))
i_dw.setfocus()
i_dw.enabled = true
i_dw.object.datawindow.readonly = false
i_dw.setcolumn(1)
i_dw.setItem(il_current_row,'divisioncode',gs_divisioncode)
i_dw.setItem(il_current_row,'companycode',gs_companycode)
wf_enabledisable_buttons("save, undo")		// the user has to save or undo the changes he made

ib_add_edit = TRUE	// may be use in ue_validate event
ib_addingediting = TRUE

JUST INSERT THE FORM TO KEY IN DATA

BUTTON EDIT

il_current_row = i_dw.getrow()				// just in case they undo the changes in the data window
i_dw.enabled = true
i_dw.object.datawindow.readonly = false
wf_enabledisable_buttons("save, undo")

ib_add_edit = FALSE	// may be use in ue_validate event
ib_addingediting = TRUE

JUST ENABLE THE FORM ENABLE SO CAN CHANGE THE INFO

BUTTON DELETE 

integer ans
ans = guo_func.msgbox(is_title, "You are about to delete the current record!",	gc_Information, gc_OkCancel, "Choose Ok to proceed.");
integer i_update
if ans = 1 then
	i_dw.deleterow(i_dw.getrow());
	if i_dw.update() < 0 then
		i_dw.retrieve();
	end if
end IF

JUST DELETE THE DATA FROM TABLE NAPMASTER AND NAPPORTASSIGNMENT BY CODE

BUTTON SAVE

i_dw.setItem(i_dw.getrow(),'divisioncode',gs_divisioncode)
i_dw.setItem(i_dw.getrow(),'companycode',gs_companycode)

if i_dw.update() = 1 then
	
	triggerevent("ue_napportassign")
	
	--VALIDASI ue_napportassign
		
	long ll_noofports , ll_ctr , ll_portno
	string ls_napcode , ls_portno
	
	
	
	ll_noofports = i_dw.getItemNumber(i_dw.getRow(),'noofports')
	ls_napcode = i_dw.getItemString(i_dw.getRow(),'napcode')
	
	for ll_ctr = 1 to ll_noofports
		
		
		ls_portno= string(ll_ctr)
		
		insert into napPortAssignment(
		napcode,
		portno,
		acctno,
		portstatus,
		companycode,
		divisioncode)
		values(
		:ls_napcode,
		:ll_ctr,
		NULL,
		'AV',
		:gs_companycode,
		:gs_divisioncode)
		using SQLCA;
	
		commit using SQLCA;
	
	next 
	
	--END VALIDASI
	
	wf_enabledisable_buttons("first, previous, next, last, search, filter, add, edit, delete, close")
	i_dw.retrieve(gs_divisioncode, gs_companycode)
	i_dw.enabled = true
	i_dw.object.datawindow.readonly = true
	ib_addingediting = FALSE
end IF

AND INSERT DATA TO TABLE NAPMASTER TO 

