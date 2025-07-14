--SAVE JO PREPARATION

--GET NEXT NUMBER  guo_func.get_nextnumber("JO", ll_joNo, "WITH LOCK")

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

al_tranNo = al_tranNo + 1
--f_closeStatus()



--ls_joNo 				= string(ll_joNo, "00000000")
--ldt_joDate 			= istr_jo.jodate
--ls_tranTypeCode 	= trim(dw_header.getitemstring(dw_header.getrow(), "trantypecode"))
--ls_acctNo			= trim(dw_header.getitemstring(dw_header.getrow(), "acctno"))
--ls_lineManCode		= trim(istr_jo.linemancode)
--ls_referenceNo		= trim(dw_header.getitemstring(dw_header.getrow(), "tranno"))
--ls_joStatusCode 	= "FR"
--ls_teamcode		= trim(dw_header.getitemstring(dw_header.getrow(), "teamcode"))
--ls_teammembercode		= trim(dw_header.getitemstring(dw_header.getrow(), "teammembercode"))

select napcode , portno --into :ls_napcode , :ls_portno
from aracctsubscriber
where acctno = :ls_acctno
and divisioncode = :gs_divisioncode
and companycode = :gs_companycode

--validation uf_get_applPreferences

if as_tranTypeCode = 'APPLYML' then
	select preferreddatetimefrom,
			 preferreddatetimeto,
			 specialInstructions	 
	  from arAcctSubscriber
	 where tranNo = :as_tranNo
	 	and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
	
elseif as_tranTypeCode = 'CONVD2F' then
	select preferreddatetimefrom,
			 preferreddatetimeto,
			 specialInstructions	
	  from conversiondoctofibtran
	 where tranNo = :as_tranNo
	 and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode	
	
elseif as_tranTypeCode = 'APPLYEXT' then
	select preferreddatetimefrom,
			 preferreddatetimeto,
			 specialInstructions
	  into :adt_datefrom,
	  		 :adt_dateto,
			 :as_specialinstructions
	  from applOfExtTranHdr
	 where tranNo = :as_tranNo
	 and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
	

elseif as_tranTypeCode = 'SERVCALL' then
	select scheduledDateTime,
			 scheduledDateTime,
			 specialInstruction
	  into :adt_datefrom,
	  		 :adt_dateto,
			 :as_specialinstructions
	  from serviceCallTranHdr
	 where tranNo = :as_tranNo
	 and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
	
elseif as_tranTypeCode = 'APPLMLEXTREA' then
	select preferreddatetimefrom,
			 preferreddatetimeto,
			 specialInstructions
	  into :adt_datefrom,
	  		 :adt_dateto,
			 :as_specialinstructions
	  from applOfReactivationTranHdr
	 where tranNo = :as_tranNo
	 and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
	
elseif as_tranTypeCode = 'APPLYTRANSFR' then
	select preferreddatetimefrom,
			 preferreddatetimeto,
			 specialInstructions
	  into :adt_datefrom,
	  		 :adt_dateto,
			 :as_specialinstructions
	  from applOfTransferTranHdr
	 where tranNo = :as_tranNo
	
elseif as_tranTypeCode = 'APPLYXTDSRVC' then
	select preferreddatetimefrom,
			 preferreddatetimeto,
			 specialInstructions
	  into :adt_datefrom,
	  		 :adt_dateto,
			 :as_specialinstructions
	  from applExtendedServicesTranHdr
	 where tranNo = :as_tranNo
	 and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
	
elseif as_tranTypeCode = 'APPLYPD' then
	select preferreddatetimefrom,
			 preferreddatetimeto,
			 specialInstructions
	  into :adt_datefrom,
	  		 :adt_dateto,
			 :as_specialinstructions
	  from applOfPermanentDiscTranHdr
	 where tranNo = :as_tranNo
	 and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
	
elseif as_tranTypeCode = 'APPLYDEAC' then
	select preferreddatetimefrom,
			 preferreddatetimeto,
			 specialInstructions
	  into :adt_datefrom,
	  		 :adt_dateto,
			 :as_specialinstructions
	  from applOfDeactivationTranHdr
	 where tranNo = :as_tranNo
	 and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
	using SQLCA;
	
elseif as_tranTypeCode = 'REPANADIGI' then
	select preferreddatetimefrom,
			 preferreddatetimeto,
			 specialInstructions
	  into :adt_datefrom,
	  		 :adt_dateto,
			 :as_specialinstructions
	  from AppOfDigitalConversionTranHdr
	 where tranNo = :as_tranNo
	 and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
	
end if

--validation into : ll_count
select count(jono)
from jotranhdr
where acctno = :ls_acctno
and divisioncode = :gs_divisioncode
and companycode = :gs_companycode
and trantypecode = 'APPLYML'


--if ll_count > 0 and ls_tranTypeCode = 'APPLYML' then
	
--string ls_jono_used , ls_useradd_used 
--datetime ldt_jodate_used , ldt_dateadd_used

select jono , useradd , jodate , dateadd --into :ls_jono_used , :ls_useradd_used , :ldt_jodate_used , :ldt_dateadd_used
from jotranhdr
where acctno = :ls_acctno
and divisioncode = :gs_divisioncode
and companycode = :gs_companycode
and trantypecode = 'APPLYML'


insert into joTranHdr (
				joNo,
				joDate,
				tranTypeCode,
				acctNo,
				lineManCode,
				referenceNo,
				joStatusCode,
				preferredDatetimeFrom,
				preferredDatetimeTo,
				specialInstructions,
				userAdd,
				dateAdd,
				divisionCode,
				companyCode,
				teamcode,
				teammembercode,
				napcode,
				portno)
	  values (
				:ls_joNo,
				:ldt_joDate,
				:ls_tranTypeCode,
				:ls_acctNo,
				:ls_lineManCode,
				:ls_referenceNo,
				:ls_joStatusCode,
				:ldt_preferredDatetimeFrom,
				:ldt_preferredDatetimeTo,
				:ls_specialInstructions,
				:gs_username,
				getdate(),
				:gs_divisionCode,
				:gs_companyCode,
				:ls_teamcode,
				:ls_teammembercode,
				:ls_napcode,
				:ls_portno)

		
--Update preference Jo No uf_set_referenceJoNo(ls_tranTypeCode, ls_referenceNo, ls_joNo)
				
IF as_trantypecode = 'APPLYML' then				
	update arAcctSubscriber
		set referenceJONo = :as_jono
	 where tranNo = :as_tranno
	 and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	
elseif as_trantypecode = 'CONVD2F' then
	update conversiondoctofibtran
		set referenceJONo = :as_jono
	 where tranNo = :as_tranno
	 and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	
elseif as_trantypecode = 'CONVD2DF' then
	update CONVERSIONDSLTODOCFIBTRAN
		set referenceJONo = :as_jono
	 where tranNo = :as_tranno
	 and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	using SQLCA;
elseif as_trantypecode = 'APPLYEXT' then
	update applOfExtTranHdr
		set referenceJONo = :as_jono
	 where tranNo = :as_tranno
	 and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	using SQLCA;
elseif as_trantypecode = 'APPLEXTHO' then
	update applOfExtHotelTranHdr
		set referenceJONo = :as_jono
	 where tranNo = :as_tranno
	 and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	using SQLCA;
elseif as_trantypecode = 'APPLYPD' then
	update applOfPermanentDiscTranHdr
		set referenceJONo = :as_jono
	 where tranNo = :as_tranno
	 and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	using SQLCA;
elseif as_trantypecode = 'APPLYTRANSFR' then
	update applOfTransferTranHdr
		set referenceJONo = :as_jono
	 where tranNo = :as_tranno
	 and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	using SQLCA;
elseif as_trantypecode = 'APPLYXTDSRVC' then
	update applExtendedServicesTranHdr
		set referenceJONo = :as_jono
	 where tranNo = :as_tranno
	 and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	using SQLCA;
elseif as_trantypecode = 'PULLOUTADS' then
	update adsTranHdr
		set referenceJONo = :as_jono
	 where tranNo = :as_tranno
	 and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	using SQLCA;
elseif as_trantypecode = 'APPLEXTD' then
	update applOfExtDiscTranHdr
		set referenceJONo = :as_jono
	 where tranNo = :as_tranno
	 and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	using SQLCA;
elseif as_trantypecode = 'APPLYDEAC' then
	update applOfDeactivationTranHdr
		set referenceJONo = :as_jono
	 where tranNo = :as_tranno
	 and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	using SQLCA;
elseif as_trantypecode = 'APPLMLEXTREA' then
	update applOfReactivationTranHdr
		set referenceJONo = :as_jono
	 where tranNo = :as_tranno
	 and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	using SQLCA;
elseif as_trantypecode = 'SERVCALL' then
	update serviceCallTranHdr
		set referenceJONo = :as_jono
	 where tranNo = :as_tranno
	 and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	using SQLCA;
elseif as_trantypecode = 'REPANADIGI' then
	update AppOfDigitalConversionTranHdr
		set referenceJONo = :as_jono
	 where tranNo = :as_tranno
	 and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	using SQLCA;
elseif as_trantypecode = 'SERVMGMT' then
	update serviceCallMaster
		set referenceJONo = :as_jono
	 where tranNo = :as_tranno
	 and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	using SQLCA;	
elseif as_trantypecode = 'ADDFIBERTV' then
	update APPLOFVASTRANHDR
		set referenceJONo = :as_jono
	 where tranNo = :as_tranno
	 and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	using SQLCA;	
end if
if SQLCA.sqlcode <> 0 then
	return FALSE
end if

--Update cunter number ll_jono
	update sysTransactionParam
	set recordLocked = 'N',
		 lockedUserName = '',
		 lastTransactionNo = :al_tranno
where recordLocked = 'Y' 
       and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		and tranTypeCode = :as_tranType



--UPDATE SSP_status(ls_acctNo, gs_divisioncode, gs_companycode, 'From Prepare Job Order' , '')

string ls_napcode, ls_remarks, ls_jonumber, ls_reference_code, ls_fullacctno, ls_jono, ls_subscriberstatuscode
string ls_dateinstalled
integer li_portno, li_trigger_type
decimal{2} ld_balance_rip , ld_balance_sip

--string ls_or_number

--long ll_pos_1 , ll_pos_2 


select reference_code, napcode, portno, to_char(dateinstalled,'MM/DD/YYYY') into :ls_reference_code, :ls_napcode, :li_portno, :ls_dateinstalled
from aracctsubscriber
where acctno = :as_acctno
and divisioncode = :as_divisioncode
and companycode = :as_companycode
using SQLCA;

if ls_reference_code = '' or isnull(ls_reference_code) then
	return 0
end if


select acctno, subscriberstatuscode into :ls_fullacctno, :ls_subscriberstatuscode
from vw_fullacctno
where ibas_Acctno = :as_Acctno
and divisioncode = :as_divisioncode
and companycode = :as_companycode
using SQLCA;

select jono into :ls_jono
from Jotranhdr
where trantypecode = 'APPLYML'
AND divisioncode = :as_divisioncode
and companycode = :as_companycode
and acctno = :as_acctno
and rownum< 2
using SQLCA;

if ls_subscriberstatuscode <> 'APL' then
	return 0
end if

string ls_updatestatustype
string ls_date_today

select to_char(sysdate,'MM/DD/YYYY') into :ls_date_today from dual using SQLCA;

select sum(balance) into :ld_balance_rip 
from artranhdr
where acctno = :as_acctno
and divisioncode = :as_divisioncode
and companycode = :as_companycode
using SQLCA;

if isnull(ld_balance_rip) then ld_balance_rip = 0.00

select sum(balance) into :ld_balance_sip 
from subsinitialpayment
where acctno = :as_acctno
and divisioncode = :as_divisioncode
and companycode = :as_companycode
using SQLCA;

if isnull(ld_balance_sip)  then ld_balance_sip = 0.00

decimal{2} ld_total_balance
string ls_reftranno, ls_trantypecode

ld_total_balance = ld_balance_rip + ld_balance_sip

if as_triggered_by = 'From Payment' or as_triggered_by  = 'From Prepare Job Order' then
	li_trigger_type = 7
	ls_updatestatustype = 'FOR SCHEDULE OF INSTALLATION'
	ls_remarks = 'JOBORDER NO. ' + ls_jono
	ls_reftranno = ls_jono
	ls_trantypecode = 'APPLYML'
elseif as_triggered_by = 'On Going Installation' then
	li_trigger_type = 8
elseif as_triggered_by = 'On Hold' then
	li_trigger_type = 12
elseif as_triggered_by = 'Cancelled' then
	li_trigger_type = 13
	ls_updatestatustype = 'CANCELLED'
	ls_remarks = 'DATE CANCELLED: '+ ls_date_today + ' ' + as_trigger_remarks
	ls_reftranno = ls_jono
	ls_trantypecode = 'CANCELJO'
elseif as_triggered_by = 'Active' then
	li_trigger_type = 9
	ls_updatestatustype = 'ACTIVE'
	ls_reftranno = ls_jono
	ls_trantypecode = 'JOCLOSING'
	ls_remarks = 'DATE INSTALLED: '+ ls_dateinstalled
elseif as_triggered_by = 'Insufficient Payment' then
	ls_updatestatustype = 'PAYMENT INSUFFICIENT'
	
	ll_pos_1 = pos(as_trigger_remarks,':')
	ll_pos_2 = pos(as_trigger_remarks,'ORDATE')
	
	ls_or_number = mid(as_trigger_remarks, ll_pos_1+1, 8)

	ls_reftranno = ls_or_number
	ls_trantypecode = 'COLLECTION'
	ls_remarks = as_trigger_remarks + ' Please settle remaining: P' + string(ld_total_balance)
end if



insert into UPDATEAPPSTATUSSSP
(reference_no,
 trigger_type,
 acct_no,
 nap_code,
 port_no,
 remarks,
 job_order_no,
 activation_date,
 created_at,
 processed,
 trigger_remarks)
 values
 (:ls_reference_code,
  :li_trigger_type,
  :ls_fullacctno,
  :ls_napcode,
  :li_portno,
  :as_triggered_by,
  :ls_jono,
  null,
  sysdate,
  'N',
  :as_trigger_remarks)
 			
				
--update status wf_updateApplicationStatus(ls_trantype, ls_acctno, 'FR')
case 'APPLYML'			//#1
		update arAcctSubscriber
		set applicationStatusCode = :as_statusCode
		where acctno = :as_acctno
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		
		
	case 'CONVD2F'			//#1
		update conversiondoctofibtran
		set applicationStatusCode = :as_statusCode
		where acctno = :as_acctno
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
				
	case	'APPLYEXT'		//#2
		update applOfExtTranHdr
		set applicationStatusCode = :as_statusCode
		where acctno = :as_acctno
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		
		
	case	'APPLYPD'		//#3
		update applOfPermanentDiscTranHdr
		set applicationStatusCode = :as_statusCode
		where acctno = :as_acctno
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
					
	case	'APPLYTRANSFR'	//#4
		update applOfTransferTranHdr
		set applicationStatusCode = :as_statusCode
		where acctno = :as_acctno
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
				
	case 'APPLMLEXTREA'	//#5
		update applOfReactivationTranHdr
		set applicationStatusCode = :as_statusCode
		where acctno = :as_acctno
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
				
	case	'SERVCALL'		//#6
		update serviceCallTranHdr
		set applicationStatusCode = :as_statusCode
		where acctno = :as_acctno
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
			
	case	'APPLYXTDSRVC'	//#7
		update applExtendedServicesTranHdr
		set applicationStatusCode = :as_statusCode
		where acctno = :as_acctno
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
				
	case	'APPLEXTD'		//#8
		update applOfExtDiscTranHdr
		set applicationStatusCode = :as_statusCode
		where acctno = :as_acctno
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		
	case	'APPLYDEAC'		//#9
		update applOfDeactivationTranHdr
		set applicationStatusCode = :as_statusCode
		where acctno = :as_acctno
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		
	case	'APPLEXTHO'		//#10
		update applOfExtHotelTranHdr
		set applicationStatusCode = :as_statusCode
		where acctno = :as_acctno
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
		
		
	case	'REPANADIGI'		//#11
		update AppOfDigitalConversionTranHdr
		set applicationStatusCode = :as_statusCode
		where acctno = :as_acctno
		and divisionCode = :gs_divisionCode
		and companyCode = :gs_companyCode
			
		
		
	-----last update	
	update overridePolicy
	set refTranNo = :is_tranNo
	where tranNo = :gb_authorizationNo
	and divisionCode = :gs_divisionCode
	and companyCode = :gs_companyCode
	and requestStatus = 'AP'
	using SQLCA;
				