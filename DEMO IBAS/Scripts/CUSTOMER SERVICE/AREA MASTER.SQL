--QUERY FORM

  SELECT  areamaster.areaCode ,
  areamaster.areaName ,
  areamaster.useradd ,
  areamaster.dateadd , 
  areamaster.mapHandle ,
  areamaster.mapXPos , 
  areamaster.mapYPos 
  FROM areamaster    
  
  
  --EVENT BUTTON IN FORM
  
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
		ole_1.object.apptivate()
		
		xPos = getItemDecimal(row,'mapxpos')
		yPos = getItemDecimal(row,'mapypos')
		
		ole_1.object.xposition = xPos
		ole_1.object.yposition = yPos
		ole_1.object.magnification = 500
		ole_1.object.Locate()
	end if	
	
	///////////////////////////////////////////////////////
	//   G E N E R A T E    D W F 
	///////////////////////////////////////////////////////
	
	
	if dwo.name = 'b_3' then
		string ls_plotFileName, ls_areaCode, ls_areaName
		boolean lb_fileExists
		integer ans
			
		ls_areaCode 		= tab_1.Tabpage_1.dw_1.getItemString(tab_1.Tabpage_1.dw_1.getRow(),'areacode')
		ls_plotFileName 	= 'c:\PlotFiles\'+ls_areaCode+'.dwf'
	
		SELECT areaName INTO :ls_areaName FROM areaMaster 
		WHERE areaCode = :ls_areaCode
		USING SQLCA;
		if SQLCA.SQLCode <> 0 then
				guo_func.MsgBox('Error inserting value to variable ='+ls_areaName, &
									 'SQL Error Code : ' + string(SQLCA.SQLCode) + &
									 'SQL Error Text : ' + SQLCA.SQLErrText)
									 rollback using SQLCA;
									 return 
		end if						 		
		
	//	ls_brgyCode 		= tab_1.Tabpage_1.dw_1.getItemString(tab_1.Tabpage_1.dw_1.getRow(),'barangaycode')
	//	ls_plotFileName 	= 'c:\PlotFiles\'+ls_brgyCode+'.dwf'
		
		lb_fileExists = fileExists(ls_plotFileName)
			
		if lb_fileExists = False then
			ole_1.object.PlotFileName = ls_plotFileName
			ole_1.object.GenerateDWF()
		else
			ans = guo_func.msgbox(is_title, "DWF for area = "+ls_areaName+" Already Exist.. Do you wish to overwrite the existing file?",	gc_Information, gc_OkCancel, "Choose Ok to proceed.");
			if ans = 1 then
				fileDelete(ls_plotFileName)
				ole_1.object.PlotFileName = ls_plotFileName
				ole_1.object.GenerateDWF()
			end if
			return
		end if
	end if	
end IF

--BUTTON ADD

il_current_row = i_dw.getrow()				// just in case they undo the changes in the data window
i_dw.scrolltorow(i_dw.insertrow(0))
i_dw.insertrow(0)
i_dw.setfocus()
i_dw.enabled = true
i_dw.object.datawindow.readonly = false
i_dw.setcolumn(1)

wf_enabledisable_buttons("save, undo")		// the user has to save or undo the changes he made

ib_add_edit = TRUE	// may be use in ue_validate event
ib_addingediting = True
il_row = i_dw.getrow()

tab_1.tabpage_1.dw_1.object.b_1.Enabled = True
tab_1.tabpage_1.dw_1.object.b_2.Enabled = True
tab_1.tabpage_1.dw_1.object.b_3.Enabled = TRUE


--BUTTON EDIT

il_current_row = i_dw.getrow()				// just in case they undo the changes in the data window
i_dw.enabled = true
i_dw.object.datawindow.readonly = false
wf_enabledisable_buttons("save, undo")

ib_add_edit = FALSE	// may be use in ue_validate event
ib_addingediting = TRUE
il_row = i_dw.getrow( )


tab_1.tabpage_1.dw_1.object.b_1.Enabled = True
tab_1.tabpage_1.dw_1.object.b_2.Enabled = True
tab_1.tabpage_1.dw_1.object.b_3.Enabled = TRUE

--BUTTON DELETE:

integer ans
ans = guo_func.msgbox(is_title, "You are about to delete the current record!",	gc_Information, gc_OkCancel, "Choose Ok to proceed.");
integer i_update
if ans = 1 then
	i_dw.deleterow(i_dw.getrow());
	if i_dw.update() < 0 then
		i_dw.retrieve();
		tab_1.tabpage_1.dw_1.object.b_1.Enabled = False
		tab_1.tabpage_1.dw_1.object.b_2.Enabled = False
		tab_1.tabpage_1.dw_1.object.b_3.Enabled = False
	end if
end if
--DELETE THE DATA FROM TABLE areamaster

--BUTTON SAVE

if i_dw.update() = 1 then
	wf_enabledisable_buttons("first, previous, next, last, search, filter, add, edit, delete, close")
	i_dw.retrieve()
	i_dw.enabled = true
	i_dw.object.datawindow.readonly = true
	ib_addingediting = FALSE
	i_dw.scrolltorow( il_row)
	tab_1.tabpage_1.dw_1.object.b_1.Enabled = False
	tab_1.tabpage_1.dw_1.object.b_2.Enabled = False
	tab_1.tabpage_1.dw_1.object.b_3.Enabled = False
end IF

--JUST INSERT TO TABLE areamaster
