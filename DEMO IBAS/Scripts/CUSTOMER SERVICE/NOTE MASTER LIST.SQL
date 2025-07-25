--QUERY FORM MAIN DW 1
  SELECT arAcctSubscriber.acctNo,   
         arAcctSubscriber.subscriberName,   
         arAcctSubscriber.nodeNo,   
			arAcctSubscriber.divisionCode,   
         arAcctSubscriber.companyCode,  
         vw_arAcctAddress.barangayCode,   
         vw_arAcctAddress.subdivisionCode,   
         vw_arAcctAddress.municipalityCode,  
			vw_arAcctAddress.completeAddress,
			'N' selected,
		arPackageMaster.packageCode,
		arPackageMaster.packageName,
		arAcctSubscriber.emailAddress,
			nodesinipcommander.ubrtype,
			ARPACKAGEMASTER.CLIENTCLASSVALUE
    FROM arAcctSubscriber,   
         vw_arAcctAddress,
			arPackageMaster,
			packageTypeMaster ,
			nodesinipcommander 
   WHERE ( arAcctSubscriber.acctNo = vw_arAcctAddress.acctNo )   
			AND ( arAcctSubscriber.divisionCode = vw_arAcctAddress.divisionCode ) 
			AND ( arAcctSubscriber.companyCode = vw_arAcctAddress.companyCode ) 
			AND ( vw_arAcctAddress.addressTypeCode = 'SERVADR1' ) 
		   AND ( arAcctSubscriber.packageCode = arPackageMaster.packageCode )
			AND ( arAcctSubscriber.divisionCode = arPackageMaster.divisionCode ) 
			AND ( arAcctSubscriber.companyCode = arPackageMaster.companyCode ) 
			AND ( arPackageMaster.packageTypeCode = packageTypeMaster.packageTypeCode )
			AND ( arPackageMaster.divisionCode = packageTypeMaster.divisionCode ) 
			AND ( arPackageMaster.companyCode = packageTypeMaster.companyCode ) 
			AND (nodesinipcommander.NODENO = arAcctSubscriber.NODENO)
			AND (nodesinipcommander.COMPANYCODE = arAcctSubscriber.COMPANYCODE)
			AND (nodesinipcommander.divisionCode = arAcctSubscriber.divisionCode)
			AND (	( vw_arAcctAddress.subdivisionCode in (:as_subdivision) or :as_allsubdivision = 'Y' )
					AND ( vw_arAcctAddress.barangayCode in (:as_barangay) or :as_all_barangay = 'Y' )
					AND ( vw_arAcctAddress.municipalityCode in (:as_municipality) or :as_all_municipality = 'Y' )
					AND ( vw_arAcctAddress.provinceCode in (:as_province) or :as_all_province = 'Y' )
					AND ( arAcctSubscriber.subscriberStatusCode in (:as_status) or :as_allStatus = 'Y' )
					AND ( arAcctSubscriber.nodeNo = :ai_nodeNo or :as_allNode = 'Y')
					AND ( arAcctSubscriber.divisionCode = :as_division ) 
					AND ( arAcctSubscriber.companyCode = :as_company ) 
					AND ( packageTypeGroupCode in (:as_packageTypeGroup) or :as_allPackageTypeGroup = 'Y' ) )
					
--DROWDOP SELECT IN DW_ 1
					
SELECT  nodePortMasterList.nodeNo
FROM nodePortMasterList  

--QUERY FORM DW 2
  SELECT nodePortMasterList.nodeNo,   
         count(arAcctSubscriber.nodeNo)totalsubs
    FROM nodePortMasterList,   
         arAcctSubscriber,
		   arAcctAddress,
			arPackageMaster,
			packageTypeMaster  
   WHERE ( nodePortMasterList.nodeNo = arAcctSubscriber.nodeNo ) and
			( nodePortMasterList.divisionCode = arAcctSubscriber.divisionCode ) and
			( nodePortMasterList.companyCode = arAcctSubscriber.companyCode ) and
			( arAcctSubscriber.acctNo = arAcctAddress.acctNo ) and 
			( arAcctSubscriber.divisionCode = arAcctAddress.divisionCode ) and
			( arAcctSubscriber.companyCode = arAcctAddress.companyCode ) and
			( arAcctAddress.addressTypeCode = 'SERVADR1' ) and    
			( arPackageMaster.packageCode = arAcctSubscriber.packageCode ) and
			( arPackageMaster.divisionCode = arAcctSubscriber.divisionCode ) and
			( arPackageMaster.companyCode = arAcctSubscriber.companyCode ) and
			( packageTypeMaster.packageTypeCode = arPackageMaster.packageTypeCode ) and
			( packageTypeMaster.divisionCode = arPackageMaster.divisionCode ) and
			( packageTypeMaster.companyCode = arPackageMaster.companyCode ) and
			( ( arAcctAddress.subdivisionCode in (:as_subdivision) or :as_allsubdivision = 'Y' )
					AND ( arAcctAddress.barangayCode in (:as_barangay) or :as_all_barangay = 'Y' )
					AND ( arAcctAddress.municipalityCode in (:as_municipality) or :as_all_municipality = 'Y' )
					AND ( arAcctAddress.provinceCode in (:as_province) or :as_all_province = 'Y' )
					AND ( arAcctSubscriber.subscriberStatusCode in (:as_status) or :as_allStatus = 'Y' )
					AND ( arAcctSubscriber.nodeNo = :ai_nodeNo or :as_allNode = 'Y')and
           ( nodePortMasterList.divisionCode = :as_division ) and 
           ( nodePortMasterList.companyCode = :as_company ) and
			  ( packageTypeMaster.packageTypeGroupCode in (:as_packageTypeGroup) or :as_allPackageTypeGroup = 'Y'))
   group by  nodePortMasterList.nodeNo
   order by nodeNo


   --EVENT BUTTON CLICK IN DW 1
   long ll_loop

if this.rowCount() > 0 then
	if dwo.name = 'b_save' then
		this.saveAs()
		
	elseif dwo.name = 'b_1' then
		
		for ll_loop = 1 to rowCount()
			setItem(ll_loop,'selected','Y')
		next
		
	elseif dwo.name = 'b_2' then	
		
		for ll_loop = 1 to rowCount()
			setItem(ll_loop,'selected','N')
		next		
		
	end if
end IF

---BUTTON FILTER
pointer OldPointer
OldPointer=SetPointer(HourGlass!)
Open(w_filter_loc_node,parent)
setPointer(OldPointer)

--CHOOSE GENERATE THE DATA YOU WANT SHOW IN LIST

--TAB SELECT PROVINCE
  SELECT '' selected,   
         provinceMaster.provinceCode as sortcode,   
         provinceMaster.provinceName as sortname,   
         provinceMaster.provinceCode as displaycode,   
         provinceMaster.provinceName as displayname  
    FROM provinceMaster

--TAB SELECT STATUS
    SELECT 	'' selected,   
			subscriberstatusmaster.subscriberstatuscode sortcode,   
         subscriberstatusmaster.subscriberstatusname sortname,
			subscriberstatusmaster.subscriberstatuscode displaycode,   
         subscriberstatusmaster.subscriberstatusname displayname
FROM 		subscriberstatusmaster

--TAB SELECT MUNICIPALITY
  SELECT '' selected,   
         municipalityMaster.municipalityCode as sortcode,   
         municipalityMaster.municipalityName as sortname,   
         municipalityMaster.municipalityCode as displaycode,   
         municipalityMaster.municipalityName as displayname  
    FROM municipalityMaster   
   WHERE municipalityMaster.provinceCode in (:as_provincecodes)
      OR :as_all_provincecodes = 'Y'
      
--TAB SELECT BARANGAY
  SELECT '' selected,   
         barangayMaster.barangayCode as sortcode,   
         barangayMaster.barangayName as sortname,   
         barangayMaster.barangayCode as displaycode,   
         barangayMaster.barangayName as displayname  
    FROM barangayMaster   
   WHERE barangayMaster.municipalityCode in (select municipalitycode from temp_mun_for_reporting)
      OR :as_all_municipalitycodes = 'Y'
      
--TAB SELECT PACKAGE TYPE GROUP
 SELECT 	'' selected,   
         packageTypeGroupMaster.packageTypeGroupCode sortcode,
			packageTypeGroupMaster.packageTypeGroupName sortname,
         packageTypeGroupMaster.packageTypeGroupCode displaycode,
			packageTypeGroupMaster.packageTypeGroupName displayname
FROM 		packageTypeGroupMaster
WHERE		packageTypeGroupMaster.companyCode = :as_company 

--TAB SELECT SUB DIVISION
 SELECT '' selected,   
         subdivisionmaster.subdivisioncode as sortcode,   
         subdivisionmaster.subdivisionname as sortname,   
         subdivisionmaster.subdivisioncode as displaycode,   
         subdivisionmaster.subdivisionname as displayname  
    FROM subdivisionmaster   
 


BUTTON GENERATE :

string ls_status[], ls_all_status, ls_packageTypeGroup[], ls_allPackageTypeGroup
string ls_province[], ls_all_province
string ls_municipality[], ls_all_municipality, ls_barangay[], ls_all_barangay
string ls_subdivision[], ls_allsubdivision, ls_allNode = 'N'
int    li_nodeNo

--Subdivision
if tab_1.tabpage_10.uo_subdivision.uf_getselecteditems_array("displaycode", ls_subdivision) <= 0 then
	guo_func.msgbox("No subdivision code selected!", "You must select at least 1 subdivision code from the SUBDIVISION TAB")
	return
end if
ls_allsubdivision = tab_1.tabpage_10.uo_subdivision.uf_select_all()
string ls_emptySubdivision[]
if ls_allSubdivision = 'Y' then
	ls_emptySubdivision[1] = 'Y'
	ls_subdivision = ls_emptysubdivision
end if


--province
if tab_1.tabpage_5.uo_province.uf_getselecteditems_array("displaycode", ls_province) <= 0 then
	guo_func.msgbox("No province code selected!", "You must select at least 1 province code from the PROVINCE TAB")
	return
end if
ls_all_province = tab_1.tabpage_5.uo_province.uf_select_all()

--municipality
if tab_1.tabpage_6.uo_municipality.uf_getselecteditems_array("displaycode", ls_municipality) <= 0 then
	guo_func.msgbox("No municipality code selected!", "You must select at least 1 municipality code from the MUNICIPALITY TAB")
	return
end if
ls_all_municipality = tab_1.tabpage_6.uo_municipality.uf_select_all()

--barangay
if tab_1.tabpage_7.uo_barangay.uf_getselecteditems_array("displaycode", ls_barangay) <= 0 then
	guo_func.msgbox("No barangay code selected!", "You must select at least 1 barangay code from the BARANGAY TAB")
	return
end if
ls_all_barangay = tab_1.tabpage_7.uo_barangay.uf_select_all()

--Subs status
if tab_1.tabpage_2.uo_substatus.uf_getselecteditems_array("displaycode", ls_status) <= 0 then
	guo_func.msgbox("No subscriber status selected!", "You must select at least 1 subscriber status from the SUBSCRIBER STATUS TAB")
	return
end if
ls_all_status = tab_1.tabpage_2.uo_substatus.uf_select_all()

--Package Type Group
if tab_1.tabpage_1.uo_packageTypeGroup.uf_getselecteditems_array("displaycode", ls_packageTypeGroup) <= 0 then
	guo_func.msgbox("No package type group selected!", "You must select at least 1 package type group status from the PACKAGE TYPE GROUP TAB")
	return
end if
ls_allpackageTypeGroup = tab_1.tabpage_1.uo_packageTypeGroup.uf_select_all()

li_nodeNo = integer(trim(em_node.text))

if rb_all.checked = True then
	ls_allNode = 'Y'
end if

Parent.ParentWindow().Trigger Dynamic Event ue_xclosefilter(ls_subdivision, ls_allsubdivision, ls_barangay, ls_all_barangay, &
																				ls_municipality, ls_all_municipality, ls_province, ls_all_province, &
-VALIDASI Event ue_xclosefilter
																				
long ll_subs, ll_count

is_subdivision    		= as_subdivision
is_allsubdivision 		= as_allsubdivision
is_barangay 				= as_barangay
is_all_barangay			= as_all_barangay
is_municipality			= as_municipality
is_all_municipality		= as_all_municipality
is_province					= as_province
is_all_province			= as_all_province
is_status					= as_status
is_allStatus				= as_allStatus
ii_nodeNo					= ai_nodeNo
is_allNode					= as_allNode
is_packageTypeGroup		= as_packageTypeGroup
is_allPackageTypeGroup	= as_allPackageTypeGroup


if i_dw.retrieve( as_subdivision, as_allsubdivision, as_barangay, as_all_barangay, &
					as_municipality, as_all_municipality, as_province, as_all_province, &
					as_status, as_allStatus, ai_nodeNo, as_allNode, as_packageTypeGroup, &
					as_allPackageTypeGroup, gs_divisionCode, gs_companyCode) > 0 then

	dw_2.retrieve( as_subdivision, as_allsubdivision, as_barangay, as_all_barangay, &
					as_municipality, as_all_municipality, as_province, as_all_province, &
					as_status, as_allStatus, ai_nodeNo, as_allNode, as_packageTypeGroup, &
					as_allPackageTypeGroup, gs_divisionCode, gs_companyCode)
	wf_enabledisable_buttons("edit, filter, close, search")
	
	st_total.text = string(i_dw.rowcount(), '#,##0')
	ll_subs = dw_2.getitemNumber(1, "total")
	ll_count = i_dw.rowcount() - ll_subs
	dw_2.object.t_nonode.text = string(ll_count, '#,##0')

else
	
	i_dw.reset()
	wf_enabledisable_buttons("close, filter")
	
end if	
ls_status, ls_all_status, li_nodeNo, ls_allNode, ls_packageTypeGroup, ls_allPackageTypeGroup)
Close(Parent)
