select *
  from WORKSTATIONMASTER w WHERE w.WORKSTATIONNAME = 'LAPTOP-22UNUEFK'
  
  
  
 select *	 
  from userMaster 
 where upper(userName) = upper('ARULAMD2')

 
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
WHERE ( userrightsmaster.usercode = :a_s_user_code ) and ( userrightsmaster.divisionCode = :as_division )   


select custom_hash('pardo') from dual
