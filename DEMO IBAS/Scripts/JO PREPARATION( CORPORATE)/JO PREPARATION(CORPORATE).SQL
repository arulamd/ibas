--FORM QUERY
SELECT  vw_applications_for_jo.tranDate ,
		  vw_applications_for_jo.tranTypeCode ,
		  vw_applications_for_jo.tranNo ,
		  vw_applications_for_jo.acctNo ,
			vw_applications_for_jo.serviceCallSubTypeCode,
		  '' linemancode,
		  '' jodate,
		  arAcctSubscriber.subscribername,
		  systransactionParam.tranTypeName,
        vw_arAcctAddress.completeAddress,
        vw_applications_for_jo.teamcode,
        vw_applications_for_jo.teammembercode
FROM vw_applications_for_jo, arAcctSubscriber, systransactionParam, vw_arAcctAddress
where (vw_applications_for_jo.acctNo = arAcctSubscriber.acctno)
and (vw_applications_for_jo.tranTypeCode = systransactionParam.tranTypeCode) 
and (vw_applications_for_jo.divisionCode = arAcctSubscriber.divisionCode)
and (vw_applications_for_jo.companyCode = arAcctSubscriber.companyCode)
and (vw_applications_for_jo.divisionCode = systransactionParam.divisionCode)
and (vw_applications_for_jo.companyCode = systransactionParam.companyCode)
and (vw_applications_for_jo.acctNo = vw_arAcctAddress.acctno)
and (vw_applications_for_jo.divisionCode = vw_arAcctAddress.divisionCode)
and (vw_applications_for_jo.companyCode = vw_arAcctAddress.companyCode)
and (vw_arAcctAddress.addressTypeCode = 'SERVADR1')
and (( vw_applications_for_jo.companyCode = :as_company)
and ( vw_applications_for_jo.divisionCode = :as_division))
--BUTTON NEW

if dw_header.retrieve(gs_divisionCode, gs_companyCode) <= 0 then
	guo_func.msgbox("Oppsss...","There is no application created yet!", gc_Information, gc_OkOnly, "")
	return
end if

pb_new.default = FALSE

pb_new.enabled = FALSE
pb_close.enabled = FALSE
pb_cancel.enabled = TRUE
pb_createjo.enabled = TRUE

-- BUTTON CREATE JO

dw_header.SelectRow(dw_header.GetRow(), TRUE)

parent.Event ue_createjo()

--VALIDASI UE_CREATEJO
string ls_tranTypeCode, ls_tranNo, ls_acctNo
datetime ldt_joDate

ls_tranTypeCode 	= trim(dw_header.GetItemString(dw_header.GetRow(), 'tranTypeCode'))
ls_tranNo			= trim(dw_header.GetItemString(dw_header.GetRow(), 'tranNo'))
ls_acctNo			= trim(dw_header.GetItemString(dw_header.GetRow(), 'acctNo'))

ls_acctNo = trim(ls_acctNo)
if not iuo_subscriber.setAcctNo( ls_acctNo ) then
	guo_func.msgbox("Warning!", iuo_subscriber.lastSQLCode + "~r~n" + iuo_subscriber.lastSQLErrText)
end if


--END VALIDASI 


dw_header.SelectRow(dw_header.GetRow(), FALSE)