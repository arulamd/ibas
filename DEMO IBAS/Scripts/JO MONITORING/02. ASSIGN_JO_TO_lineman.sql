---PROSES assign_jo_to_lineman

string 	ls_sqlCode, ls_sqlErrText
string	ls_tranNo, ls_oldLinemanCode, ls_newLinemanCode
datetime	ldt_tranDate
long		ll_tranNo


--GET NEXT NUMBER  guo_func.get_nextnumber("REASSIGNJO",ll_tranNo, "WITH LOCK")

--if as_getmode = "WITH LOCK" then
	--do while true
		update sysTransactionParam
			set recordLocked = 'Y',
				 lockedUserName = :gs_username
		   where recordLocked = 'N' 
		   and tranTypeCode = :as_tranType
		   and divisionCode = :gs_divisionCode
 		   and companyCode = :gs_companyCode		 
		--using SQLCA;
		--if SQLCA.sqlnrows < 1 then
		--	if guo_func.msgbox("SM-0000011", ls_lockedby, "") = 2 then
		--		f_closeStatus()
		--		return false
 		--	end if
		--else
		--	exit
		--end if
	--loop--
--end if

select lastTransactionNo, tranYear
      --into :al_tranNo, :ii_tranYear
from sysTransactionParam
      where tranTypeCode = :as_tranType
      and divisionCode = :gs_divisionCode
 		and companyCode = :gs_companyCode
using SQLCA;

--al_tranNo = al_tranNo + 1

--ls_tranNo 		= string(ll_tranNo, "00000000")
--ldt_tranDate	= guo_func.get_server_date()

--ls_oldLinemanCode = dw_1.getitemstring(1, "linemanCode")
--ls_newLinemanCode = dw_2.getitemstring(1, "linemanCode_1")

string ls_joNo, ls_serviceType
is_joNo 			= dw_jo.getitemstring(dw_jo.getrow(), "jono")
ls_serviceType = dw_jo.getitemstring(dw_jo.getrow(), "servicetype")


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

	update joTranHdr
		set linemanCode = :ls_newLinemanCode
	 where joNo = :is_joNo
	 and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	
	
	--VALIDATION JO NO
	
	if isnull(as_joNo) or trim(as_joNo) = '' then
	lastSQLCode 	= '-2'
	lastSQLErrText = 'as_joNo passed does not contained any value.'
	return FALSE
	end if
	
	joNo = as_joNo
	select acctNo, linemanCode, joStatusCode, joDate, tranTypeCode, referenceNo, actionType, joMobStatusRemarks
	  into :acctNo, :linemanCode, :statusCode, :joDate, :tranTypeCode, :referenceNo, :actionType , :joMobStatusRemarks
	  from joTranHdr
	 where joNo = :joNo
	 and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
	using SQLCA;
	if SQLCA.sqlcode = 100 then
		lastSQLCode = string(SQLCA.sqlcode)
		lastSQLErrText = "Invalid J.O. #"
		return FALSE
	elseif SQLCA.sqlcode < 0 then
		lastSQLCode = string(SQLCA.sqlcode)
		lastSQLErrText = SQLCA.sqlerrtext
		return FALSE
	end if
	
	
	select serviceType, isDigital
	into :servicetype, :isDigital
	from arPackageMaster 
	inner join arAcctSubscriber on arPackageMaster.packageCode = arAcctSubscriber.packageCode
	where acctNo = :acctNo
	and arAcctSubscriber.divisionCode = :gs_divisionCode
	and arAcctSubscriber.companyCode = :gs_companyCode
	and arPackageMaster.divisionCode = :gs_divisionCode
	and arPackageMaster.companyCode = :gs_companyCode
	using SQLCA;
	if SQLCA.sqlcode < 0 then
		lastSQLCode = string(SQLCA.sqlcode)
		lastSQLErrText = SQLCA.sqlerrtext
		return FALSE
	end if
	
	
	--UPDATE LAST COUNTER NUMBER
	
	--Update cunter number ll_tranNo
	update sysTransactionParam
	set recordLocked = 'N',
		 lockedUserName = '',
		 lastTransactionNo = :al_tranno
	where recordLocked = 'Y' 
       and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		and tranTypeCode = :as_tranType
		
		
-- LAST UPDATE
		
string ls_jono_add_on
string ls_acctno

select acctNo --into :ls_acctNo
from joTranHdr
where jono = :is_joNo
and divisioncode = :gs_divisionCode
and companyCode = :gs_companyCode
using SQLCA;



select jono --into :ls_jono_add_on
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

	
	
	
	




