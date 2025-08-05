 SELECT 
    arAcctSubscriber.acctno                               AS acctno,
    arAcctSubscriber.subscribername                       AS subscribername,
    arAcctSubscriber.lastname                             AS lastname,
    arAcctSubscriber.firstname                            AS firstname,
    arAcctSubscriber.middlename                           AS middlename,
    arAcctSubscriber.mothermaidenname                     AS mothermaidenname,
    arAcctSubscriber.citizenshipcode                      AS citizenshipcode,
    arAcctSubscriber.sex                                  AS sex,
    arAcctSubscriber.birthdate                            AS birthdate,
    arAcctSubscriber.civilstatus                          AS civilstatus,
    arAcctSubscriber.typeofbusiness                       AS typeofbusiness,
    arAcctSubscriber.telno                                AS telno,
    arAcctSubscriber.mobileno                             AS mobileno,
    arAcctSubscriber.faxno                                AS faxno,
    arAcctSubscriber.emailaddress                         AS emailaddress,
    service.serviceHomeOwnerShip                          AS servicehomeownership,
    service.serviceLessorOwnerName                        AS servicelessorownername,
    service.serviceLessorOwnerContactNo                   AS servicelessorownercontactno,
    service.serviceYearsResidency                         AS serviceyearsresidency,
    service.serviceExpirationDate                         AS serviceexpirationdate,
    service.contactName                                   AS contactname,
    service.contactNo                                     AS contactno,
    service.HouseNo                                       AS houseno,
    service.streetName                                    AS streetname,
    service.bldgName                                      AS bldgname,
    service.LotNo                                         AS lotno,
    service.BlkNo                                         AS blkno,
    service.PhaseNo                                       AS phaseno,
    service.District                                      AS district,
    service.PurokNo                                       AS purokno,
    service.SubdivisionCode                               AS subdivisioncode,
    service.BarangayCode                                  AS barangaycode,
    service.MunicipalityCode                              AS municipalitycode,
    service.ProvinceCode                                  AS provincecode,
    billing.contactName                                   AS billing_contactname,
    billing.contactNo                                     AS billing_contactno,
    billing.HouseNo                                       AS billing_houseno,
    billing.StreetName                                    AS billing_streetname,
    billing.bldgName                                      AS billing_bldgname,
    billing.LotNo                                         AS billing_lotno,
    billing.BlkNo                                         AS billing_blkno,
    billing.PhaseNo                                       AS billing_phaseno,
    billing.District                                      AS billing_district,
    billing.PurokNo                                       AS billing_purokno,
    billing.SubdivisionCode                               AS billing_subdivisioncode,
    billing.BarangayCode                                  AS billing_barangaycode,
    billing.MunicipalityCode                              AS billing_municipalitycode,
    billing.ProvinceCode                                  AS billing_provincecode,
    arAcctSubscriber.circuitID                            AS circuitid,
    arAcctSubscriber.chargeTypecode                       AS chargetypecode,
    arAcctSubscriber.subsusertypecode                     AS subsusertypecode,
    arAcctSubscriber.packagecode                          AS packagecode,
    arAcctSubscriber.subscriberstatuscode                 AS subscriberstatuscode,
    arAcctSubscriber.substypecode                         AS substypecode,
    arAcctSubscriber.dateapplied                          AS dateapplied,
    arAcctSubscriber.dateinstalled                        AS dateinstalled,
    arAcctSubscriber.dateautodeactivated                  AS dateautodeactivated,
    arAcctSubscriber.datemanualdeactivated                AS datemanualdeactivated,
    arAcctSubscriber.datepermanentlydisconnected          AS datepermanentlydisconnected,
    arAcctSubscriber.datereactivated                      AS datereactivated,
    arAcctSubscriber.qtyacquiredstb                       AS qtyacquiredstb,
    arAcctSubscriber.totalboxesbeforedeactivation         AS totalboxesbeforedeactivation,
    arAcctSubscriber.numberofrooms                        AS numberofrooms,
    arAcctSubscriber.occupancyrate                        AS occupancyrate,
    arAcctSubscriber.mLineCurrentMonthlyRate              AS mlinecurrentmonthlyrate,
    arAcctSubscriber.mLinePreviousMonthlyRate             AS mlinepreviousmonthlyrate,
    arAcctSubscriber.extCurrentMonthlyRate                AS extcurrentmonthlyrate,
    arAcctSubscriber.extPreviousMonthlyRate               AS extpreviousmonthlyrate,
    arAcctSubscriber.withadvances                         AS withadvances,
    arAcctSubscriber.locked                               AS locked,
    arAcctSubscriber.lockedby                             AS lockedby,
    arAcctSubscriber.lockedwithtrans                      AS lockedwithtrans,
    0                                                    AS noofboxmline,
    0                                                    AS noofboxext,
    0.00                                                 AS insurancefee,
    0.00                                                 AS rentalfee,
    0.00                                                 AS regmonthlybill,
    arAcctSubscriber.userAdd                              AS useradd,
    arAcctSubscriber.dateAdd                              AS dateadd,
    arAcctSubscriber.tranNo                               AS tranno,
    arAcctSubscriber.oldAcctNo                            AS oldacctno,
    arAcctSubscriber.noOfMonthArrears                     AS noofmontharrears,
    arAcctSubscriber.noOfMonthArrearsAllowed              AS noofmontharrearsallowed,
    arAcctSubscriber.acquisitionTypeCode                  AS acquisitiontypecode,
    arAcctSubscriber.handle                               AS handle,
    arAcctSubscriber.xpos                                 AS xpos,
    arAcctSubscriber.ypos                                 AS ypos,
    arAcctSubscriber.subsUserName                         AS subsusername,
    arAcctSubscriber.password                             AS password,
    service.lastInfoUpdate                                AS lastinfoupdate,
    ''                                                   AS contactno,
    arPackageMaster.packageName                           AS packagename,
    arPackageMaster.isBundledServiceType                  AS isbundledservicetype,
    arPackageMaster.isDigital                             AS isdigital,
    ''                                                   AS arothacctno,
    ''                                                   AS arothacctname,
    'N'                                                  AS withadshistory,
    AracctSubscriber.bundledCTVAcctno                     AS bundledctvacctno,
    aracctsubscriber.lockinperiod                         AS lockinperiod,
    aracctsubscriber.isSoaPrinting                        AS issoaprinting,
    aracctsubscriber.isCableBoxEmail                      AS iscableboxemail,
    aracctsubscriber.isSMSSending                         AS issmssending,
    aracctsubscriber.isEmailSending                       AS isemailsending,
    arAcctSubscriber.mobileno2                            AS mobileno2,
    arAcctSubscriber.mobileno3                            AS mobileno3,
    arAcctSubscriber.emailaddress2                        AS emailaddress2,
    arAcctSubscriber.emailaddress3                        AS emailaddress3,
    arAcctSubscriber.guarantor                            AS guarantor,
    arAcctSubscriber.spousename                           AS spousename,
    arAcctSubscriber.nameofcompany                        AS nameofcompany,
    nodesInIpCommander.nodeno                             AS nodeno,
    nodesInIpCommander.nodedesc                           AS nodedesc,
    arpackagemaster.clientclassvalue                      AS clientclassvalue,
    arAccountMaster.isvat                                 AS isvat,
    arAccountMaster.isnonvat                              AS isnonvat,
    arAccountMaster.iswhtagent                            AS iswhtagent,
    arAcctSubscriber.TIN                                  AS tin,
    arAcctSubscriber.BSTRADENAME                          AS bstradename,
    arAcctSubscriber.ISAPPLIEDAUTODEBIT                   AS isappliedautodebit,
    applicationautodebittranhdr.trandate                  AS trandate,
    applicationautodebittranhdr.useradd                   AS applicationautodebit_useradd,
    subsusertypemaster.subsusertypename                   AS subsusertypename,
    arAcctSubscriber.isprintcomclark                      AS isprintcomclark,
    arAcctSubscriber.isprintconverge                       AS isprintconverge,
    systemparameter.companyid                              AS companyid,
    systemparameter.divisionprefix                         AS divisionprefix,
    systemparameter.servicecode                            AS servicecode,
    agentmaster.agentname                                 AS agentname,
    arAcctSubscriber.napcode                              AS napcode,
    arAcctSubscriber.portno                               AS portno,
    applcancelautodebittranhdr.dateadd                    AS dateadd,
    applcancelautodebittranhdr.useradd                    AS applcancelautodebit_useradd,
    datelcomservicetypemaster.ServiceTypeName             AS datelcomservicetypename,
    arAcctSubscriber.datelcomtelno                        AS datelcomtelno,
    arAcctSubscriber.iptvacctno                           AS iptvacctno,
    arAcctsubscriber.iptvdivisioncode                     AS iptvdivisioncode,
    arAcctSubscriber.iptvcompanycode                      AS iptvcompanycode,
    arAcctSubscriber.daterelockin                         AS daterelockin,
    arAcctSubscriber.relockintrigger                      AS relockintrigger,
    aracctsubscriber.tagno                                AS tagno,
    aracctsubscriber.bssacctno                            AS bssacctno,
    aracctsubscriber.migratedbsstoibasacctno              AS migratedbsstoibasacctno,
    arAcctSubscriber.NOCOICOP                             AS nocoicop,
    0.00                                                 AS iptvmainlinerate,
    0.00                                                 AS iptvextensionrate,
    ADD_MONTHS(NVL(arAcctSubscriber.daterelockin, arAcctSubscriber.dateinstalled), arAcctSubscriber.LOCKINPERIOD) AS lockinperiod_end,
    arAcctSubscriber.billingcycle                         AS billingcycle,
    arAcctSubscriber.migratedfromacctno                   AS migratedfromacctno,
    arAcctSubscriber.migratedtoacctno                     AS migratedtoacctno,
    systemparameterfrom.companyid                         AS from_companyid,
    systemparameterfrom.divisionprefix                    AS from_divisionprefix,
    systemparameterfrom.servicecode                       AS from_servicecode,
    systemparameterto.companyid                           AS to_companyid,
    systemparameterto.divisionprefix                      AS to_divisionprefix,
    systemparameterto.servicecode                         AS to_servicecode,
    'N'                                                  AS greenflagtagging,
    arAcctSubscriber.sweldomo_acctno                      AS sweldomo_acctno,
    CASE 
        WHEN arAcctSubscriber.payment_option = 0 THEN 'Pay via Pay Partners'
        WHEN arAcctSubscriber.payment_option = 1 THEN 'Pay via Installers'
        ELSE 'Pay via Pay Partners'
    END                                                   AS payment_option,
    aracctsubscriber.networkactivationdate                AS networkactivationdate,
    arAcctSubscriber.application_type                     AS application_type
FROM arAcctSubscriber 
                  inner join arAcctAddress billing on arAcctSubscriber.acctNo = billing.acctNo 
              and billing.addresstypeCode = 'BILLING' 
              and billing.divisionCode = 'ISG'
              and billing.companyCode = 'COMCL'
        inner join arAcctAddress service on arAcctSubscriber.acctNo = service.acctNo 
              and service.addresstypeCode = 'SERVADR1' 
              and service.divisionCode = 'ISG'
              and service.companyCode = 'COMCL'
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
                  WHERE (( arAcctSubscriber.acctno = '002502'))
                  AND ( arAcctSubscriber.divisionCode = 'ISG') 
        and ( arAcctSubscriber.companyCode = 'COMCL')
        and rownum < 2
        
        
        
        
         SELECT COUNT(*)
                FROM arAcctSubscriber
                INNER JOIN vw_arAcctAddress
                        ON vw_arAcctAddress.acctNo = arAcctSubscriber.acctNo
                        AND vw_arAcctAddress.addressTypeCode = 'SERVADR1'
                        AND vw_arAcctAddress.divisionCode = arAcctSubscriber.divisionCode
                        AND vw_arAcctAddress.companyCode = arAcctSubscriber.companyCode
                INNER JOIN arPackageMaster
                        ON arPackageMaster.packageCode = arAcctSubscriber.packageCode
                        AND arPackageMaster.divisionCode = arAcctSubscriber.divisionCode
                        AND arPackageMaster.companyCode = arAcctSubscriber.companyCode
                INNER JOIN subscriberStatusMaster
                        ON subscriberStatusMaster.subscriberstatuscode = arAcctSubscriber.subscriberstatuscode       
                WHERE 1=1 AND arAcctSubscriber.divisionCode = 'NCRNT' AND arAcctSubscriber.companyCode = 'COMCL'
                AND LOWER(arAcctSubscriber.acctNo ) LIKE '%002502%'