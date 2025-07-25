SELECT arAcctSubscriber.acctno ,
           arAcctSubscriber.subscribername ,
           arAcctSubscriber.lastname ,
           arAcctSubscriber.firstname ,
           arAcctSubscriber.middlename ,
           arAcctSubscriber.mothermaidenname ,
           arAcctSubscriber.citizenshipcode ,
           arAcctSubscriber.sex ,
           arAcctSubscriber.birthdate ,
           arAcctSubscriber.civilstatus ,
           arAcctSubscriber.typeofbusiness ,
           arAcctSubscriber.telno ,
           arAcctSubscriber.mobileno ,
           arAcctSubscriber.faxno ,
           arAcctSubscriber.emailaddress ,
           service.serviceHomeOwnerShip ,
           service.serviceLessorOwnerName ,
           service.serviceLessorOwnerContactNo ,
           service.serviceYearsResidency ,
           service.serviceExpirationDate ,
           service.contactName,
           service.contactNo,
           service.HouseNo ,
           service.streetName ,
           service.bldgName ,
           service.LotNo ,
           service.BlkNo ,
           service.PhaseNo ,
           service.District ,
           service.PurokNo ,
           service.SubdivisionCode ,
           service.BarangayCode ,
           service.MunicipalityCode ,
           service.ProvinceCode ,
           arAcctSubscriber.circuitID,
           billing.contactName,
		  billing.contactNo,
           billing.HouseNo ,
           billing.StreetName ,
           billing.bldgName ,
           billing.LotNo ,
           billing.BlkNo ,
           billing.PhaseNo ,
           billing.District ,
           billing.PurokNo ,
           billing.SubdivisionCode ,
           billing.BarangayCode ,
           billing.MunicipalityCode ,
           billing.ProvinceCode ,
           arAcctSubscriber.chargeTypecode ,
           arAcctSubscriber.subsusertypecode ,
           arAcctSubscriber.packagecode ,
           arAcctSubscriber.subscriberstatuscode ,
           arAcctSubscriber.substypecode ,
           arAcctSubscriber.dateapplied ,
           arAcctSubscriber.dateinstalled ,
           arAcctSubscriber.dateautodeactivated ,
           arAcctSubscriber.datemanualdeactivated ,
           arAcctSubscriber.datepermanentlydisconnected ,
           arAcctSubscriber.datereactivated ,
           arAcctSubscriber.qtyacquiredstb ,
           arAcctSubscriber.totalboxesbeforedeactivation ,
           arAcctSubscriber.numberofrooms ,
           arAcctSubscriber.occupancyrate ,
           arAcctSubscriber.mLineCurrentMonthlyRate ,
           arAcctSubscriber.mLinePreviousMonthlyRate ,
           arAcctSubscriber.extCurrentMonthlyRate ,
           arAcctSubscriber.extPreviousMonthlyRate ,
           arAcctSubscriber.withadvances ,
           arAcctSubscriber.locked ,
           arAcctSubscriber.lockedby ,
           arAcctSubscriber.lockedwithtrans ,
           0 noOfBoxMLine,
           0 noOfBoxExt,
           0.00 insuranceFee,
           0.00 rentalFee,
           0.00 regMonthlyBill,
           arAcctSubscriber.userAdd,
           arAcctSubscriber.dateAdd,
			  arAcctSubscriber.tranNo,
			  arAcctSubscriber.oldAcctNo,
			  arAcctSubscriber.noOfMonthArrears,
			  arAcctSubscriber.noOfMonthArrearsAllowed,
			  arAcctSubscriber.acquisitionTypeCode,
           arAcctSubscriber.handle,
			  arAcctSubscriber.xpos,
			  arAcctSubscriber.ypos,
			  arAcctSubscriber.subsUserName,
			  arAcctSubscriber.password,
			  service.lastInfoUpdate,
			  '' as contactNo,
			  arPackageMaster.packageName,
			  arPackageMaster.isBundledServiceType,
			  arPackageMaster.isDigital,
				'' arothacctno,
				'' arothacctname,
			'N' withadshistory,
			AracctSubscriber.bundledCTVAcctno,
			aracctsubscriber.lockinperiod,
			aracctsubscriber.isSoaPrinting,
			aracctsubscriber.isCableBoxEmail,
			aracctsubscriber.isSMSSending,
			aracctsubscriber.isEmailSending,
			arAcctSubscriber.mobileno2,
			arAcctSubscriber.mobileno3,
			arAcctSubscriber.emailaddress2,
			arAcctSubscriber.emailaddress3,
			arAcctSubscriber.guarantor,
			arAcctSubscriber.spousename,
			arAcctSubscriber.nameofcompany,
			nodesInIpCommander.nodeno,
			nodesInIpCommander.nodedesc, 
			arpackagemaster.clientclassvalue,
			arAccountMaster.isvat,
			arAccountMaster.isnonvat,
			arAccountMaster.iswhtagent,
			arAcctSubscriber.TIN,
			arAcctSubscriber.BSTRADENAME,
			arAcctSubscriber.ISAPPLIEDAUTODEBIT,
			applicationautodebittranhdr.trandate,
			applicationautodebittranhdr.useradd,
			subsusertypemaster.subsusertypename,
			arAcctSubscriber.isprintcomclark,
			arAcctSubscriber.isprintconverge,
			systemparameter.companyid,
			systemparameter.divisionprefix,
			systemparameter.servicecode,
			agentmaster.agentname,
			arAcctSubscriber.napcode,
			arAcctSubscriber.portno,
			applcancelautodebittranhdr.dateadd,
			applcancelautodebittranhdr.useradd,
			datelcomservicetypemaster.ServiceTypeName as DatelcomServiceTypeName,
			arAcctSubscriber.datelcomtelno,
		 	arAcctSubscriber.iptvacctno,
			arAcctsubscriber.iptvdivisioncode,
			arAcctSubscriber.iptvcompanycode,
			arAcctSubscriber.daterelockin,
			arAcctSubscriber.relockintrigger,
			aracctsubscriber.tagno,
		    arAcctsubscriber.bssacctno, 
			arAcctsubscriber.migratedbsstoibasacctno,
arAcctSubscriber.NOCOICOP,
0.00 iptvmainlinerate,
0.00 iptvextensionrate,
ADD_MONTHS(nvl(arAcctSubscriber.daterelockin,arAcctSubscriber.dateinstalled) , arAcctSubscriber.LOCKINPERIOD) lockinperiod_end,
arAcctSubscriber.billingcycle,
arAcctSubscriber.migratedfromacctno,
arAcctSubscriber.migratedtoacctno,
systemparameterfrom.companyid,
			systemparameterfrom.divisionprefix,
			systemparameterfrom.servicecode,
systemparameterto.companyid,
			systemparameterto.divisionprefix,
			systemparameterto.servicecode,
			'N' greenFlagTagging,
			arAcctSubscriber.sweldomo_acctno,
case when arAcctSubscriber.payment_option = 0 then 'Pay via Pay Partners' 
	   when arAcctSubscriber.payment_option = 1 then 'Pay via Installers'
	   else 'Pay via Pay Partners' end as payment_option,
	aracctsubscriber.networkactivationdate,
	arAcctSubscriber.application_type
        FROM arAcctSubscriber 
		  inner join arAcctAddress billing on arAcctSubscriber.acctNo = billing.acctNo 
              and billing.addresstypeCode = 'BILLING' 
              and billing.divisionCode = :as_division 
              and billing.companyCode = :as_company
        inner join arAcctAddress service on arAcctSubscriber.acctNo = service.acctNo 
              and service.addresstypeCode = 'SERVADR1' 
              and service.divisionCode = :as_division 
              and service.companyCode = :as_company
		  inner join arPackageMaster on arPackageMaster.packageCode = arAcctSubscriber.packageCode
		  		  and arPackageMaster.divisionCode = arAcctSubscriber.divisionCode
				  and arPackageMaster.companyCode = arAcctSubscriber.companyCode
		 left join nodesInIpCommander on nodesInIpCommander.nodeno = arAcctSubscriber.nodeno
		 		and nodesInIpCommander.divisionCode = arAcctSubscriber.divisionCode
				  and nodesInIpCommander.companyCode = arAcctSubscriber.companyCode
		inner join arAccountMaster on arAccountMaster.acctNo =  arAcctSubscriber.acctNo
				and arAccountMaster.divisionCode = arAcctSubscriber.divisionCode
				and arAccountMaster.companyCode = arAcctSubscriber.companyCode
		left join applicationautodebittranhdr on applicationautodebittranhdr.acctno = arAcctSubscriber.acctno
				and applicationautodebittranhdr.divisionCode = arAcctSubscriber.divisionCode
				and applicationautodebittranhdr.companyCode = arAcctSubscriber.companyCode 
		left join applcancelautodebittranhdr on applcancelautodebittranhdr.acctno = arAcctSubscriber.acctno
				and applcancelautodebittranhdr.divisionCode = arAcctSubscriber.divisionCode
				and applcancelautodebittranhdr.companyCode = arAcctSubscriber.companyCode 
		inner join subsusertypemaster on subsusertypemaster.subsusertypecode = arAcctSubscriber.subsusertypecode
		inner join systemparameter on systemparameter.divisioncode = arAcctSubscriber.divisioncode and systemparameter.companycode = arAcctSubscriber.companycode
    left join systemparameter systemparameterfrom on systemparameterfrom.divisioncode = arAcctSubscriber.migratedfromdivisioncode and systemparameterfrom.companycode = arAcctSubscriber.migratedfromcompanycode
    left join systemparameter systemparameterto on systemparameterto.divisioncode = arAcctSubscriber.migratedtodivisioncode and systemparameterto.companycode = arAcctSubscriber.migratedtocompanycode
		left join agentmaster on agentmaster.agentcode = arAcctSubscriber.agentcode
				and agentmaster.divisioncode = arAcctSubscriber.divisioncode
				and agentmaster.companycode = arAcctSubscriber.companycode
		left join datelcomservicetypemaster on datelcomservicetypemaster.servicetypecode = arAcctSubscriber.datelcomServTypeCode and datelcomservicetypemaster.divisionCode = arAcctSubscriber.divisionCode 
		  WHERE (( arAcctSubscriber.acctno = :as_acctno ))
		  AND ( arAcctSubscriber.divisionCode = :as_division ) 
        and ( arAcctSubscriber.companyCode = :as_company)
	and rownum < 2