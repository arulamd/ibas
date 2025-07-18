---BUTTON ADD

string ls_circuitid, ls_oldcircuit, ls_path
long ll_countcircuitid, ll_row

ll_row = tab_1.tp_sitea.dw_sitea_circuit.getRow()

ls_oldcircuit = tab_1.tp_sitea.dw_sitea_circuit.getitemString(ll_row,'circuitid')

select count(circuitid) into :ll_countcircuitid 
from subscribercircuitid
where acctno = :is_acctNo
and divisionCode = :gs_divisionCode
and companyCode = :gs_companyCode
using SQLCA;

if ll_countcircuitid = 1 then
	guo_func.msgbox("ATTENTION","Account Number: " + is_acctNo + " has already assigned CircuitID: " + ls_oldcircuit + ", Delete the Existing Assigned CircuitID then Add Again, 1 CircuitID per Account Only")
	return -1
end if 	

openwithparm(w_search_circuitID,'dw_search_circuitid')

--QUERY FORM SEARCH

  SELECT circuitMaster.circuitID,   
         circuitMaster.description 
  FROM circuitMaster   
  where circuitMaster.circuitID not in ( select circuitID
  from subscriberCircuitID
  where subscriberCircuitID.divisionCode = :as_division and subscriberCircuitID.companyCode = :as_company)
  
--END QUERY FORM SEARCH  
  
  CHOOSE SELECT BUTTON THEN RETURN THE VALUE 


 ls_circuitid = dw_1.getitemString(dw_1.getrow(), 'circuitid')

  
ls_circuitid = message.stringparm

if ls_circuitid <> "" then
	
	insert into subscriberCircuitID (acctNo, circuitID, divisionCode, companyCode)
	values(:is_acctNo, :ls_circuitID, :gs_divisionCode, :gs_companyCode)
	using SQLCA;
	commit using SQLCA;
	
	guo_func.msgbox("ATTENTION","New Circuit ID has been assigned to Acct. No.: " + is_acctNo)
	
	dw_sitea_circuit.retrieve(is_acctNo, gs_divisionCode, gs_companyCode )
	st_ida.text = 'Circuit ID : '+ ls_circuitid
	ls_path = dw_sitea_circuit.getitemString(1, 'circuitbuilderimagemaster_imagepath')
	ole_1.insertFile(ls_path)
		
	pb_dela.enabled = True
	pb_viewa.enabled = True
end IF

--BUTTON DELETE 

string ls_circuit, ls_path
int li_row

ls_circuit = dw_sitea_circuit.getitemString(dw_sitea_circuit.getRow(),'circuitid')
	
if guo_func.msgbox('Confirmation...', 'Do you want to delete this circuit ID: '+ls_circuit+' ?', gc_question, gc_okCancel, "Click ok to proceed...") = 1 then
	delete from subscriberCircuitID
	where circuitID = :ls_circuit and acctNo = :is_acctNo
	and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	using SQLCA;
	commit using SQLCA;
	li_row = dw_sitea_circuit.retrieve(is_acctNo, gs_divisionCode, gs_companyCode )
	ole_1.clear()
	if li_row > 0 then
		ls_path = dw_sitea_circuit.getitemString(1,'circuitbuilderimagemaster_imagepath')
		ole_1.insertFile(ls_path)
	else
		this.enabled = False
		pb_viewa.enabled = False
	end if
end IF

--BUTTON VIEW

string ls_circuit
ls_circuit = dw_sitea_circuit.getitemString(dw_sitea_circuit.getRow(),'circuitid')

openwithparm(w_circuitviewer,ls_circuit)

--DW 1 FORM w_circuitviewer
 SELECT  circuitDetails.circuitID,
     		circuitDetails.equipment,
			circuitDetails.brand,
      	circuitDetails.model,
     		circuitDetails.interface,
			circuitDetails.ipAddress,
         circuitDetails.description
FROM circuitDetails      
WHERE ( circuitDetails.circuitID = :as_circuit )

--DW PARTY
 SELECT  otherPartyCircuitDtl.refcircuitID,
     		otherPartyCircuitDtl.equipment,
			otherPartyCircuitDtl.brand,
      	otherPartyCircuitDtl.model,
     		otherPartyCircuitDtl.interface,
			otherPartyCircuitDtl.ipAddress,
         otherPartyCircuitDtl.description
FROM otherPartyCircuitDtl      
WHERE ( otherPartyCircuitDtl.circuitID = :as_circuit )

--EVENT OPEN FROM w_circuitviewer

string ls_circuit, ls_description, ls_fileServer, ls_path, ls_other
string ls_ext
long ll_len, ll_row

dw_1.setTransObject(SQLCA);
dw_2.setTransObject(SQLCA);
dw_party.setTransObject(SQLCA);

ls_circuit = message.stringParm
this.title = "Circuit ID Viewer : "+ ls_circuit

select description
into :st_description.text
from circuitMaster
where circuitID = :ls_circuit
using SQLCA;
if SQLCA.SQLCode <> 0 then
	guo_func.msgBox('Error!','Error while selecting values from table circuitMaster.. ' + SQLCA.SQLErrText )
	return
end if

ll_row = dw_2.retrieve(ls_circuit, gs_divisionCode, gs_companyCode)
dw_1.retrieve(ls_circuit, gs_divisionCode, gs_companyCode)
dw_party.retrieve(ls_circuit, gs_divisionCode, gs_companyCode)

if ll_row > 0 then
	ls_path = dw_2.getitemString(1,'imagepath')
	
	long ll_pos1, ll_pos2
	string ls_mid1, ls_mid2
	
	ll_pos1 = pos(ls_path, '\\')
	ls_mid1 = mid(ls_path, 3, len(ls_path))
	ll_pos2 = pos(ls_mid1, '\')
	ls_mid2 = mid(ls_mid1, ll_pos2, len(ls_path))
	ls_path = '\\' + gs_ImageServerIPAddress + ls_mid2	
	
	ole_1.insertFile(ls_path)
	is_image = ls_path
else
	ole_1.clear()
end if
