select a.itemCode, a.serialNo,a.barCode, a.controlNo, a.locationCode, a.serialNoStatusCode, a.acctNo, a.macAddress, b.itemName, 
				b.productLineCode, b.model, b.voltage, a.boxIdNo, b.isiptv	 
	  from serialNoMaster a, itemMaster b
	 where a.itemCode = b.itemCode
	 	and a.companyCode = b.companyCode
		and a.serialNo = 'ZTEV2F62500040231'
		and b.itemIsCableModem = 'Y'
		and a.divisionCode = 'NCRNT'
		and b.companyCode = 'COMCL' AND b.ITEMCODE  ='00030794'

SELECT * FROM ITEMMASTER i WHERE i.COMPANYCODE = 'COMCL' AND i.ITEMNAME LIKE '%OTT BOX%'

SELECT * FROM serialNoMaster WHERE ITEMCODE  ='00030794' AND COMPANYCODE ='COMCL' AND 