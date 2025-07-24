--QUERY FROM DW_1
  SELECT  nodemaster.nodecode ,           
          nodemaster.nodename ,           
			 nodemaster.provinceCode,
		    nodemaster.municipalityCode,
          nodemaster.useradd ,           
          nodemaster.dateadd     
  FROM    nodemaster    
  
  --QUERY FROM DW_2(RERIEVE DATA FROM NodeCode TABLE nodemaster)
SELECT  nodePortMaster.NodeCode ,
nodePortMaster.PortNo , 
nodePortMaster.NodePortCode ,
nodePortMaster.companyCode ,
nodePortMaster.divisionCode
FROM nodePortMaster 
WHERE ( nodePortMaster.NodeCode = :as_nodeCode )  

  --QUERY FROM DW_3(RERIEVE DATA FROM NodePortCode TABLE nodePortMaster)
 SELECT nodePortBarangayMaster.barangayCode,   
         nodePortBarangayMaster.municipalityCode,   
         nodePortBarangayMaster.ProvinceCode  
    FROM nodePortBarangayMaster  
   WHERE nodePortBarangayMaster.NodePortCode = :as_nodePortCode    
	and nodePortBarangayMaster.companyCode = :as_company
	and nodePortBarangayMaster.divisionCode = :as_division
	
	
BUTTON ADD:

WHEN CLICK ADD THE DW_1 INSERT ROW TO KEY IN DATA SEARCH PROVINCE AND MUNICIPALITY

--SEARCH PROVINCE QUERY
SELECT  provincename ,
           provincecode     
        FROM provincemaster   
        
--SEARCH MUNICIPALITY QUERY
 SELECT  municipalityname ,
           municipalitycode     
        FROM municipalitymaster    
where   provinceCode = :as_provinceCode

BUTTON EDIT :


ROW FOCUS IN DW_1 TAKE DATA 

if currentRow > 0 then	
	
	il_row = currentrow
	
	selectRow(0,false)
	selectRow(currentrow,true)
	
	is_nodeCode            = getItemString(currentrow,'nodecode')
	is_municipalityCode    = getItemString(currentrow,'municipalitycode')
	dw_2.reset()
	dw_2.retrieve(is_nodeCode)		
	dw_2.scrollToRow(1)
end if	

pb_add_line_item.enabled = true
pb_delete_line_item.enabled = true


dw_2.object.datawindow.readonly = false
dw_3.object.datawindow.readonly = false


lb_viewing = false
cbx_1.enabled = true

if dw_2.getRow() > 0 then
	dw_2.scrollTorow(1)
	is_nodePortCode = dw_2.getitemstring(dw_2.getRow(),'nodeportcode')
	
	dw_2.selectRow(1,true)
end if	

dw_3.dataobject = 'dw_node_port_barangay_master_w_arg'
dw_3.setTransObject(SQLCA)
dw_3.retrieve(is_municipalityCode)

--QUERY FORM DW_3
  SELECT  barangayMaster.barangayCode ,
  barangayMaster.barangayName ,
  municipalityMaster.municipalityName ,
  provinceMaster.provinceName ,
  " " as selected, 
  municipalityMaster.municipalityCode ,
  provinceMaster.provinceCode
  FROM barangayMaster , 
  municipalityMaster ,
  provinceMaster
  WHERE ( barangayMaster.municipalityCode = municipalityMaster.municipalityCode ) and 
  ( municipalityMaster.provinceCode = provinceMaster.provinceCode ) and 
  ( ( barangayMaster.municipalityCode = :as_municipality ) )
  
BUTTON DELETE :

integer ans
ans = guo_func.msgbox(is_title, "You are about to delete the current record!",	gc_Information, gc_OkCancel, "Choose Ok to proceed.");
integer i_update
if ans = 1 then
	i_dw.deleterow(i_dw.getrow());
	if i_dw.update() < 0 then
		i_dw.retrieve();
	end if
end IF
--JUST DELETE DATA FROM TABLE nodemaster BY NODECODE

BUTTON SAVE :

long   ll_loop, ll_rows
string ls_selected, ls_barangayCode, ls_municipalityCode, ls_provinceCode

if i_dw.update() = 1 then
	
	if dw_2.update() <> 1 then
		rollback using SQLCA;
	end if		
	
	ll_rows = dw_3.rowcount()
	
	delete from nodePortBarangayMaster
	where  nodePortCode = :is_nodePortCode 
	and companyCode = :gs_companyCode
	using  SQLCA;
	if SQLCA.SQLCode <> 0 then 
		guo_func.MsgBox('SQL Error in [Delete]...', 'SQL Error Code : ' + string(SQLCA.SQLCode) + &
							 '~r~nSQL Error Text : ' + SQLCA.SQLErrText)
							 rollback using SQLCA;
							 return		
	end if	
	
	for ll_loop = 1 to ll_rows
		
		ls_selected 			= dw_3.getItemString(ll_loop,'selected')
		ls_barangayCode 		= dw_3.getItemString(ll_loop,'barangaycode')
		ls_municipalityCode	= dw_3.getItemString(ll_loop,'municipalitycode')
		ls_provinceCode      = dw_3.getItemString(ll_loop,'provincecode')
		
		if ls_selected <> 'Y' then continue
		
		insert into nodePortBarangayMaster
			(nodePortCode, barangayCode, municipalityCode, provinceCode,companyCode,divisionCode)
		values
			(:is_nodePortCode, :ls_barangayCode, :ls_municipalityCode, :ls_provinceCode,:gs_companyCode,:gs_divisionCode)
		using SQLCA;	
		if SQLCA.SQLCode <> 0 then
			guo_func.MsgBox('SQL Error encountered in Insert [nodePortBarangayMaster]', &
							    'SQL Error Code : ' + string(SQLCA.SQLCode) + &
								 'SQL Error Text : ' + SQLCA.SQLErrText)
								 rollback using SQLCA;
								 return 
		end if						 		
		
	next	
	
	
	wf_enabledisable_buttons("first, previous, next, last, search, filter, add, edit, delete, close")
	
	i_dw.enabled = true
	i_dw.object.datawindow.readonly = true
	ib_addingediting = FALSE
	
	
	dw_2.object.datawindow.readOnly = true
	dw_3.object.datawindow.readOnly = true
	
	pb_add_line_item.enabled = false
	pb_delete_line_item.enabled = false
	
	cbx_1.enabled = false
	lb_viewing = true
	
	dw_2.retrieve(is_nodeCode)

end if

commit using SQLCA;




	
	