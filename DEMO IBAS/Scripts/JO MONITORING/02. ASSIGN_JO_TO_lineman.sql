string ls_joNo, ls_serviceType
ls_joNo 			= dw_jo.getitemstring(dw_jo.getrow(), "jono")
ls_serviceType = dw_jo.getitemstring(dw_jo.getrow(), "servicetype")

il_joRow  = dw_jo.getrow()
str_acctno_jono lstr_jo
lstr_jo.joNo 			= ls_joNo
lstr_jo.serviceType 	= ls_serviceType

openwithparm(w_reassign_jo_to_lineman, lstr_jo)

--QUERY FORM FOR SEARCH
SELECT  joTranHdr.joNo ,
   joTranHdr.joDate ,
   joTranHdr.tranTypeCode ,
   joTranHdr.acctNo ,
   joTranHdr.linemanCode ,
   joTranHdr.referenceNo ,
   joTranHdr.joStatusCode,
	  '' subscribername     
FROM joTranHdr      
WHERE ( joTranHdr.joNo = :as_jono ) AND (joTranHdr.divisionCode = :as_division ) AND (joTranHdr.companyCode = :as_company)  

--Select search Assign New Lineman ;

SELECT linemanmaster.linemanname,
		   linemanmaster.linemancode     
  FROM linemanmaster
INNER JOIN locationMaster on linemanmaster.linemancode = locationMaster.locationCode
		AND  linemanmaster.companyCode = locationMaster.companyCode
		AND  locationMaster.isActive = 'Y'
	WHERE  linemanmaster.companyCode = :as_company 


string ls_status
ls_status = message.stringparm
if ls_status = "SAVED" then
	if is_all_trantypecode = "" then
		this.Event ue_retrieve_jos(True)
	else
		this.Event ue_retrieve_jos(False)
	end if
end if


---PROSES assignjotoline

dw_2.accepttext()

string 	ls_sqlCode, ls_sqlErrText
string	ls_tranNo, ls_oldLinemanCode, ls_newLinemanCode
datetime	ldt_tranDate
long		ll_tranNo

if not guo_func.get_nextnumber("REASSIGNJO", ll_tranNo, "WITH LOCK") then
	rollback using SQLCA;
	return
end IF

--VALIDASI  guo_func.get_nextnumber("REASSIGNJO", ll_tranNo, "WITH LOCK")

f_displayStatus("Retrieving next transaction # for " + as_trantype + "...")

string	ls_lockedby

if as_tranType = 'SCSREQUEST' then
	
	update systransactionparam
	set recordlocked = 'N',
	lockedusername = ''
	where tranTypeCode = :as_tranType 
			and divisionCode = :gs_divisionCode
			and companyCode = :gs_companyCode
			and  recordlocked = 'Y'
	using SQLCA;
	
end if 

select lockedUserName
  		into :ls_lockedby
from sysTransactionParam
 		where tranTypeCode = :as_tranType 
 		and divisionCode = :gs_divisionCode
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
		   and divisionCode = :gs_divisionCode
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
      and divisionCode = :gs_divisionCode
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

return true

--END VALIDASI guo_func.get_nextnumber("REASSIGNJO", ll_tranNo, "WITH LOCK")

ls_tranNo 		= string(ll_tranNo, "00000000")
ldt_tranDate	= guo_func.get_server_date()

ls_oldLinemanCode = dw_1.getitemstring(1, "linemanCode")
ls_newLinemanCode = dw_2.getitemstring(1, "linemanCode_1")

insert into reAssignLMToJOTranHdr (
				tranNo,
				tranDate,
				joNo,
				oldLinemanCode,
				newLinemanCode,
				userAdd,
				dateAdd,
				divisionCode,
				companyCode)
	  values (
	  			:ls_tranNo,
				:ldt_tranDate,
				:is_joNo,
				:ls_oldLinemanCode,
				:ls_newLinemanCode,
				:gs_userName,
				getdate(),
				:gs_divisionCode,
				:gs_companyCode)
		using SQLCA;
if SQLCA.sqlcode <> 0 then
	ls_sqlCode		= string(SQLCA.sqlcode)
	ls_sqlErrText	= SQLCA.sqlerrtext
	rollback using SQLCA;
	guo_func.msgbox("Insert Error!", ls_sqlCode + "~r~n" + &
												ls_sqlErrText)
	return
end if

update joTranHdr
	set linemanCode = :ls_newLinemanCode
 where joNo = :is_joNo
 and divisionCode = :gs_divisionCode
and companyCode = :gs_companyCode
using SQLCA;
if SQLCA.sqlcode <> 0 then
	ls_sqlCode		= string(SQLCA.sqlcode)
	ls_sqlErrText	= SQLCA.sqlerrtext
	rollback using SQLCA;
	guo_func.msgbox("Update Error!", ls_sqlCode + "~r~n" + &
												ls_sqlErrText)
	return
end if


uo_jo_nv luo_jo
luo_jo.setJoNo(is_joNo)
if not luo_jo.assignCPEToLinemanUpdateSNM() then
	ls_sqlCode		= 'SM-0000001'
	ls_sqlErrText	= luo_jo.lastSQLCode + "~r~n" + luo_jo.lastSQLErrText
	rollback using SQLCA;
	guo_func.msgbox("Update Error!", ls_sqlCode + "~r~n" + &
												ls_sqlErrText)
	return
end IF

if not luo_jo.assignPrepaidCardToLinemanUpdateSNM() then
	ls_sqlCode		= 'SM-0000001'
	ls_sqlErrText	= luo_jo.lastSQLCode + "~r~n" + luo_jo.lastSQLErrText
	rollback using SQLCA;
	guo_func.msgbox("Update Error!", ls_sqlCode + "~r~n" + &
												ls_sqlErrText)
	return
end if	

--VALIDASI luo_jo.assignPrepaidCardToLinemanUpdateSNM()

string 	ls_itemCode, ls_cardNo
long		ll_row

s_prepaidCard lstr_prepaidCard[]

--increment the attribute for the next use
if not getPrepaidCardSerialNos(lstr_prepaidCard) then
	return FALSE
end IF

--VALIDASI getPrepaidCardSerialNos(lstr_prepaidCard)

string ls_itemCode, ls_cardNo

s_prepaidCard ls_emptyArray[]

astr_prepaidCard = ls_emptyArray

declare cur_joPPC cursor for
	select itemCode, serialNo
	  from joTranDtlPPCardLoadAssigned
	 where joNo = :joNo
	 	and newSerialNo is null
	 and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	using SQLCA;

open cur_joPPC;
if SQLCA.sqlcode < 0 then
	lastSQLCode 	= string(SQLCA.sqlcode)
	lastSQLErrText = SQLCA.sqlerrtext
	return FALSE
end if

fetch cur_joPPC into :ls_itemCode, :ls_cardNo;
if SQLCA.sqlcode < 0 then
	lastSQLCode 	= string(SQLCA.sqlcode)
	lastSQLErrText = SQLCA.sqlerrtext
	return FALSE
end if

do while SQLCA.sqlcode = 0
	
	astr_prepaidCard[upperBound(astr_prepaidCard) + 1].itemCode = ls_itemCode
	astr_prepaidCard[upperBound(astr_prepaidCard)].cardNo = ls_cardNo
	
	fetch cur_joPPC into :ls_itemCode, :ls_cardNo;
	if SQLCA.sqlcode < 0 then
		lastSQLCode 	= string(SQLCA.sqlcode)
		lastSQLErrText = SQLCA.sqlerrtext
		return FALSE
	end if
loop

close cur_joPPC;

return TRUE

-- END VALIDASI getPrepaidCardSerialNos(lstr_prepaidCard)

uo_prePaidCard luo_prePaidCard

for ll_row = 1 to upperbound(lstr_prepaidCard)
	
	ls_itemCode = lstr_prepaidCard[ll_row].itemCode
	ls_cardNo 	= lstr_prepaidCard[ll_row].cardNo
	
	if not luo_prePaidCard.setItemCodeCardNo(ls_itemCode, ls_cardNo) then
		lastSQLCode 	= luo_prePaidCard.lastSQLCode
		lastSQLErrText = luo_prePaidCard.lastSQLErrText
		return FALSE
	end IF
	
	--validasi setItemCodeCardNo(ls_itemCode, ls_cardNo)
	
		select cardNo, 
		 itemCode,
		 pinCodeNo, 
		 cardStatusCode, 
		 packageCode, 
		 serialNo
		  into :cardNo, 
				 :itemCode,
				 :pinCodeNo, 
				 :cardStatusCode, 
				 :packageCode, 
				 :serialNo
		  from prepaidCardsMaster
		 where itemCode = :as_itemcode
		   and cardNo = :as_cardNo
		 and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;
		if SQLCA.sqlcode < 0 then
			lastSQLCode = string(SQLCA.sqlcode) +"~r~n setCardNo - prePaidCardsMaster"
			lastSQLErrText = SQLCA.sqlerrtext
			return FALSE
		elseif SQLCA.sqlcode = 100 then
			lastSQLCode = '-2'
			lastSQLErrText = 'Prepaid card no.: ' + as_cardNo  + ' does not exist.'
			return FALSE
		end if
		
		select cardStatusName
		  into :cardStatusName
		  from cardStatusMaster
		 where cardStatusCode = :cardStatusCode
		 using SQLCA;
		if SQLCA.sqlcode < 0 then
			lastSQLCode = string(SQLCA.sqlcode) +"~r~n setCardNo - cardStatusMaster"
			lastSQLErrText = SQLCA.sqlerrtext
			return FALSE
		end if
		
		if isnull(cardStatusName) then cardStatusName = 'Card Status Not Found'
		
		select generalPackageCode
		  into :packageTypeCode
		  from arPackageMaster
		 where packageCode = :packageCode
		 and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		using SQLCA;
		if SQLCA.sqlcode < 0 then
			lastSQLCode = string(SQLCA.sqlcode) + "~r~n setPIN - arPackageMaster"
			lastSQLErrText = SQLCA.sqlerrtext
			return FALSE
		end if
		
		if not getSerialNoInfo() then
			return FALSE
		end if
		
		return TRUE
	
	--end validasi setItemCodeCardNo(ls_itemCode, ls_cardNo) 


	if not luo_prePaidCard.setLocationCodeAndAcctNo(lineManCode, luo_prePaidCard.acctNo) then
		lastSQLCode 	= luo_prePaidCard.lastSQLCode
		lastSQLErrText = luo_prePaidCard.lastSQLErrText
		return FALSE
	end if	
	
	--validasi uo_prePaidCard.setLocationCodeAndAcctNo(lineManCode, luo_prePaidCard.acctNo)
	update serialNoMaster
	set locationCode = :as_locationCode,
		 acctNo = :as_acctNo
	 where itemCode 	= :itemCode
		and controlNo 	= :controlNo
	 and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	using SQLCA;
	if SQLCA.sqlcode <> 0 then
		lastSQLCode		= string(SQLCA.sqlcode)
		lastSQLErrText = SQLCA.sqlerrtext
		return FALSE
	end if
		
	return TRUE
	
	--end validasi uo_prePaidCard.setLocationCodeAndAcctNo(lineManCode, luo_prePaidCard.acctNo)
	
next
return TRUE

--END VALIDASI luo_jo.assignPrepaidCardToLinemanUpdateSNM()


if not guo_func.set_number("REASSIGNJO", ll_tranNo) then
	rollback using SQLCA;
	return
end IF

--VALIDASI guo_func.set_number("REASSIGNJO", ll_tranNo)

update sysTransactionParam
	set recordLocked = 'N',
		 lockedUserName = '',
		 lastTransactionNo = :al_tranno
where recordLocked = 'Y' 
       and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
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

return true

--END VALIDASI guo_func.set_number("REASSIGNJO", ll_tranNo)

commit using SQLCA;

string ls_jono_add_on
string ls_acctno

select acctNo into :ls_acctNo
from joTranHdr
where jono = :is_joNo
and divisioncode = :gs_divisionCode
and companyCode = :gs_companyCode
using SQLCA;



select jono into :ls_jono_add_on
from salesaddontranhdr
where acctNo = :ls_acctNo
and divisioncode = :gs_divisioncode
and companycode = :gs_companycode
and rownum < 2
using SQLCA;

update jotranhdr
set linemancode = :ls_newLinemanCode
where jono = :ls_jono_add_on
and divisioncode = :gs_divisioncode
and companycode = :gs_companycode
using SQLCA;

commit using SQLCA;


closewithreturn(parent, "SAVED")

return

	
string ls_status

ls_status = message.stringparm
if ls_status = "SAVED" then
	if is_all_trantypecode = "" then
		this.Event ue_retrieve_jos(True)
	else
		this.Event ue_retrieve_jos(False)
	end if
end if

	
	
	
	




