--USER MASTER
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

--USER RIGHT
 SELECT  userrightsmaster.usercode ,           
			userrightsmaster.rightscode,
         userrightsmaster.divisionCode,
         userrightsmaster.companyCode     
FROM userrightsmaster      
WHERE ( userrightsmaster.usercode = :a_s_user_code ) and ( userrightsmaster.divisionCode = :as_division )   