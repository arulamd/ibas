--QUERY FORM DW_2 
 
SELECT AGENTCODE,   
         AGENTNAME,   
         FULLNAME,   
        AGENTTYPECODE,   
        AGENTADDRESS  ,
		USERADD ,
 DATEADD,
 COMPANYCODE,
 DIVISIONCODE,
 teamleadercode,
case ISACTIVE when null then 'N' when 'Y' then 'Y' else 'N' end isactive
    FROM AGENTMASTER  
where divisionCode = :as_divisionCode
and companyCode = :as_companyCode

--BUTTON ADD

il_current_row = i_dw.getrow()				// just in case they undo the changes in the data window
dw_2.scrolltorow(i_dw.insertrow(0))
dw_2.setfocus()
dw_2.enabled = true
dw_2.object.datawindow.readonly = false
dw_2.setcolumn(1)

wf_enabledisable_buttons("save, undo")		// the user has to save or undo the changes he made

--QUERY DATA TO GET AGENTTYPECODE
  SELECT IBAS.AGENTTYPEMASTER.AGENTTYPECODE,   
         IBAS.AGENTTYPEMASTER.AGENTTYPENAME  
    FROM IBAS.AGENTTYPEMASTER   
----
    
--SEARCH QUERYTEAMLEADERCODE 
select teamleadercode , teamleadername from teamleadermaster
where divisioncode = :as_division and companycode = :as_company


ib_add_edit = TRUE	// may be use in ue_validate event
ib_addingediting = TRUE

dw_2.setitem(dw_2.getrow(), "useradd", gs_username)
dw_2.setitem(dw_2.getrow(), "dateadd", guo_func.get_server_date())
dw_2.setitem(dw_2.getrow(),"companycode",gs_companycode)
dw_2.setitem(dw_2.getrow(),"divisioncode",gs_divisioncode)

--END BUTTON ADD

--BUTTON EDIT
il_current_row = i_dw.getrow()				// just in case they undo the changes in the data window
i_dw.enabled = true
i_dw.object.datawindow.readonly = false
wf_enabledisable_buttons("save, undo")

ib_add_edit = FALSE	// may be use in ue_validate event
ib_addingediting = TRUE

UPDATE TO TABLE AGENTMASTER

---END BUTTON EDIT

--BUTTON SAVE
INSERT INTO AGENTMASTER(AGENTCODE,   
         AGENTNAME,   
         FULLNAME,   
        AGENTTYPECODE,   
        AGENTADDRESS  ,
		USERADD ) VALUES('','','')

		
		
--BUTTON DELETE
integer ans
ans = guo_func.msgbox(is_title, "You are about to delete the current record!",	gc_Information, gc_OkCancel, "Choose Ok to proceed.");
integer i_update
if ans = 1 then
	i_dw.deleterow(i_dw.getrow());
	if i_dw.update() < 0 then
		i_dw.retrieve(gs_companycode,gs_divisioncode);
	end if
end IF

DELETE BY ID AGENTMASTER