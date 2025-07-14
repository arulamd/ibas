---JO MONITORING , WHEN OPEN RETRIEVE DATA

SELECT  joTranHdr.joNo ,
		  joTranHdr.joDate ,
		  joTranHdr.tranTypeCode ,
		  joTranHdr.acctNo ,
		  joTranHdr.linemanCode ,
		  joTranHdr.referenceNo ,
		  joTranHdr.preferredDatetimeFrom ,
		  joTranHdr.preferredDatetimeTo ,
		  joTranHdr.timeStarted ,
		  joTranHdr.timeFinished ,
		  joTranHdr.rating ,
		  joTranHdr.specialInstructions ,
		  joTranHdr.remarks ,
		  joTranHdr.joStatusCode ,
		  joTranHdr.useradd ,
		  joTranHdr.dateadd ,
		  joTranHdr.referenceNo,
		  arAcctSubscriber.subscriberName ,
		  case  when joTranHdr.tranTypeCODE = 'APPLYML' and arAcctSubscriber.packageCode IN (SELECT PACKAGECODE FROM ARPACKAGEMASTER
			WHERE PACKAGENAME LIKE 'SWELDO%'
			) then 'SWELDO MO APPLICATION' else systransactionParam.tranTypeName end AS trantypename  , 
		  0 requiredSTB ,
		  0 assignedSTB ,
		  arAcctSubscriber.subsTypeCode , arAcctSubscriber.chargeTypeCode,
		  arAcctSubscriber.subscriberStatusCode, arPackageMaster.serviceType, arPackageMaster.isDigital,
			'N' withRemarks, lineManMaster.lineManName,
		 joTranHdr.teamCode,
		 joTranHdr.teamMemberCode,
     vw_aracctaddress.houseNo||' '||vw_aracctaddress.streetname||', '||vw_aracctaddress.blkno||vw_aracctaddress.lotno||vw_aracctaddress.subdivisionname||', '||vw_aracctaddress.barangayname||', '||vw_aracctaddress.municipalityname as address,
		JoTranhdr.jostatusremarks,
		joremarksmaster.remarksname
FROM joTranHdr   
INNER JOIN arAcctSubscriber on joTranHdr.acctNo = arAcctSubscriber.acctNo 
	and arAcctSubscriber.divisionCode = joTranHdr.divisionCode
	and arAcctSubscriber.companyCode =  joTranHdr.companyCode
INNER JOIN arPackageMaster on arPackageMaster.packageCode =  arAcctSubscriber.packageCode
	and arPackageMaster.divisionCode = arAcctSubscriber.divisionCode  
	and arPackageMaster.companyCode = arAcctSubscriber.companyCode 
INNER JOIN systransactionParam on joTranHdr.tranTypeCode = systransactionParam.tranTypeCode 
	and systransactionParam.divisionCode = joTranHdr.divisionCode  
	and  systransactionParam.companyCode = joTranHdr.companyCode 
LEFT JOIN lineManMaster on joTranHdr.linemanCode = lineManMaster.lineManCode 
	and lineManMaster.companyCode = joTranHdr.companyCode
left join vw_aracctaddress on vw_aracctaddress.acctNo = joTranHdr.acctNo 
and vw_aracctaddress.addressTypeCode = 'SERVADR1' 
and vw_aracctaddress.divisionCode = joTranHdr.divisionCode 
and vw_aracctaddress.companyCode = joTranHdr.companyCode
left join joremarksmaster on joremarksmaster.remarkscode = jotranhdr.jostatusremarkscode
 WHERE -- ( ( :as_alltrantype = 'Y' ) or joTranHdr.tranTypeCode in (:as_trantypecode) )   
  --and ( ( :as_allstatus = 'Y' ) or joTranHdr.joStatusCode in (:as_jostatuscode) )
  --and ( ( :as_alllineman = 'Y' ) or joTranHdr.linemancode in (select linemancode from temp_lineman_for_reporting) )
  --and ( ( :as_allprovince = 'Y' ) or vw_aracctaddress.ProvinceCode in (:as_provincecode) )
  --and ( ( :as_allmunicipality = 'Y' ) or vw_aracctaddress.MunicipalityCode in (:as_municipalitycode) )
  --and ( ( :as_allbarangay = 'Y' ) or vw_aracctaddress.BarangayCode in (:as_barangaycode) )
  --and ( ( :as_alldates = 'Y' ) or UTILS.CONVERT_TO_VARCHAR2(joTranhdr.joDate,10,p_style=>111) BETWEEN :as_datefrom and :as_dateto )
  ( joTranHdr.divisionCode = 'ISG' ) and ( joTranHdr.companyCode = 'COMCL') 
 and (arPackageMaster.isDigital = 'N')