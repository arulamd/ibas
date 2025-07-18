---NEW BUTTON

select groupcode 
into :is_Groupcode
from groupmembers 
where usercode = :gs_usercode
using SQLCA;

if dw_header.retrieve(gs_divisionCode, gs_companyCode,is_groupCode) <= 0 then
	guo_func.msgbox("Oppsss...","There is no application created yet!", gc_Information, gc_OkOnly, "")
	return
end IF

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
        vw_applications_for_jo.teammembercode,
        vw_applications_for_jo.companyCode
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
and (vw_applications_for_jo.companyCode = 'COMCL')
and ( vw_applications_for_jo.divisionCode = 'ISG');
