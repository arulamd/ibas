--QUERY FORM
select cocode ,
coname ,
technology ,
dateadd , useradd from r_comaster

BUTTON ADD

il_current_row = i_dw.getrow()				// just in case they undo the changes in the data window
i_dw.scrolltorow(i_dw.insertrow(0))
i_dw.setfocus()
i_dw.enabled = true
i_dw.object.datawindow.readonly = false
i_dw.setcolumn(1)

wf_enabledisable_buttons("save, undo")		// the user has to save or undo the changes he made

ib_add_edit = TRUE	// may be use in ue_validate event
ib_addingediting = TRUE

JUST INSERT FORM TO KEY IN

BUTTON EDIT

il_current_row = i_dw.getrow()				// just in case they undo the changes in the data window
i_dw.enabled = true
i_dw.object.datawindow.readonly = false
wf_enabledisable_buttons("save, undo")

ib_add_edit = FALSE	// may be use in ue_validate event
ib_addingediting = TRUE

JUST MAKE FORM ENABLE SO CAN EDIT

BUTTON DELETE

integer ans
ans = guo_func.msgbox(is_title, "You are about to delete the current record!",	gc_Information, gc_OkCancel, "Choose Ok to proceed.");
integer i_update
if ans = 1 then
	i_dw.deleterow(i_dw.getrow());
	if i_dw.update() < 0 then
		i_dw.retrieve();
	end if
end if


JUST DELETE THE DATA FROM TABLE r_comaster BY CODE 

BUTTON SAVE

datetime ldt_trandate

ldt_tranDate = guo_func.getServerDate()

i_dw.setItem(i_dw.getRow(),'dateadd',ldt_tranDate)
i_dw.setItem(i_dw.getRow(),'useradd',gs_username)

if i_dw.update() = 1 then
	wf_enabledisable_buttons("first, previous, next, last, search, filter, add, edit, delete, close")
	i_dw.retrieve()
	i_dw.enabled = true
	i_dw.object.datawindow.readonly = true
	ib_addingediting = FALSE
end IF

JUST INSERT INTO TO TABLE r_comaster