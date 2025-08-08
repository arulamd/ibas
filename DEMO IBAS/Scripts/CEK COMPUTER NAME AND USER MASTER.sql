select *
  from WORKSTATIONMASTER w WHERE w.WORKSTATIONCODE    = 'PAR'
  
  
  
 select *	 
  from userMaster 
 where upper(userName) = upper('PARDO')

 
SELECT  usermaster.usercode ,
		usermaster.username ,
		usermaster.password ,
		usermaster.fullname ,
		usermaster.usertypecode ,
		usermaster.loggedin ,
		usermaster.loggedinworkstation ,
		usermaster.dateadd ,
		usermaster.expdate
FROM usermaster  ;

 SELECT  userrightsmaster.usercode ,           
			userrightsmaster.rightscode,
         userrightsmaster.divisionCode,
         userrightsmaster.companyCode     
FROM userrightsmaster      
WHERE ( userrightsmaster.usercode = 'PARDO') and ( userrightsmaster.divisionCode = 'ACCTN')  AND userrightsmaster.COMPANYCODE = 'ACCTN'

SELECT * FROM RIGHTSMASTER r WHERE MODULE IN('CS','JO') AND r.COMPANYCODE = 'ACCTN';

 SELECT DISTINCT m.MODULECODE, m.MODULENAME
                FROM IBAS.MODULEMASTER m
                JOIN IBAS.RIGHTSMASTER r ON r.MODULE = m.MODULECODE
                JOIN IBAS.USERRIGHTSMASTER ur ON ur.RIGHTSCODE = r.RIGHTSCODE     
                WHERE ur.USERCODE = 'PARDO' AND ur.COMPANYCODE = 'ACCTN' AND ur.DIVISIONCODE = 'ACCTN' AND m.MODULECODE IN('CS','JO')

select custom_hash('pardo') from dual
