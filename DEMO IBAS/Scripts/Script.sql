SELECT * FROM GL WHERE TRANTYPECODE ='JO'



select custom_hash('pardo') FROM DUAL;


SELECT u.PASSWORD, 
	(SELECT custom_hash('pardo') FROM dual)
	FROM USERMASTER u WHERE u.USERNAME = 'PARDO'

UPDATE USERMASTER
SET PASSWORD = (select custom_hash('???') FROM dual)
WHERE USERNAME = '????'