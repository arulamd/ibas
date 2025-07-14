--CREATE JO BUTTON
--ls_acctNo			= trim(dw_header.GetItemString(dw_header.GetRow(), 'acctNo'))
--ls_tranNo			= trim(dw_header.GetItemString(dw_header.GetRow(), 'tranNo'))
-- SEELECT acctNo FROM   vw_applications_for_jo (ls_acctNo)

select referencejono 
from IBAS.ARACCTSUBSCRIBER
where acctNo = :ls_acctNo
and divisionCode = :gs_divisionCOde
and companyCode = :gs_companyCOde
using SQLCA;


--validate policy on no of months a/r min requirement - start


