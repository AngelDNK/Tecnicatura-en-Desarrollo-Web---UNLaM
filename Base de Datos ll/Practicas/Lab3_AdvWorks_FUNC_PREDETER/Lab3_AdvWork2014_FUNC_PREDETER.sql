use AdventureWorks2014;

/*1. Realizar una consulta que permita devolver la fecha y hora actual*/

DECLARE @fecha DATE = GETDATE();

SELECT @fecha AS Fecha;

/*2. Realizar una consulta que permita devolver únicamente el año y mes actual: Año=2010 Mes=6 */

DECLARE @mes DATE = GETDATE();
DECLARE @anio DATE = GETDATE();

SELECT YEAR(@anio) as Año, MONTH(GETDATE()) as Mes;

/*3. Realizar una consulta que permita saber cuántos días faltan para el día de la
primavera (21-Sep).*/

DECLARE @fechaPrimavera DATE = '2024-09-21';

SELECT DATEDIFF(DAY, GETDATE(), @fechaPrimavera) AS Dias_Que_Faltan;

/*4. Realizar una consulta que permita redondear el número 385,86 con
únicamente 1 decimal.*/

DECLARE @numero FLOAT(10) = 385.86;

SELECT ROUND(@numero,1) AS Numero_Redondeado;

/*5. Realizar una consulta permita saber cuánto es el mes actual al cuadrado. Por
ejemplo, si estamos en Junio, sería 62*/

DECLARE @fechaActual DATE = GETDATE();
DECLARE @mesActual INT = MONTH(@fecha); 

SELECT POWER(@mesActual,2) AS MesActual

/*6. Devolver cuál es el usuario que se encuentra conectado a la base de datos*/

SELECT SESSION_USER Sesion, 
       CURRENT_USER UsuarioActual, 
       SYSTEM_USER  UsuarioDelSitema, 
       ORIGINAL_LOGIN() Logeado, 
       SUSER_SNAME() LogeadoALaSesion;

/*7. Realizar una consulta que permita conocer la edad de cada empleado
(Ayuda: HumanResources.Employee)*/

SELECT DATEDIFF(YEAR, HE.BirthDate, GETDATE())  
FROM HumanResources.Employee HE;

/*8. Realizar una consulta que retorne la longitud de cada apellido de los
Contactos, ordenados por apellido. En el caso que se repita el apellido
devolver únicamente uno de ellos. Por ejemplo, Apellido=Abel Longitud=4*/

SELECT PP.LastName, LEN(PP.LastName) AS Tamaño 
FROM Person.Person PP 
JOIN Sales.PersonCreditCard SP ON PP.BusinessEntityID = SP.BusinessEntityID
JOIN Sales.CreditCard SC ON SP.CreditCardID = SC.CreditCardID
JOIN Person.BusinessEntityContact pb ON SC.CreditCardID = PB.PersonID
JOIN Person.ContactType PC ON PB.ContactTypeID = PC.ContactTypeID;

/*9. Realizar una consulta que permita encontrar el apellido con mayor longitud.*/

SELECT PP.LastName AS Mayor_longitud  
FROM Person.Person PP 
JOIN Sales.PersonCreditCard SP ON PP.BusinessEntityID = SP.BusinessEntityID
JOIN Sales.CreditCard SC ON SP.CreditCardID = SC.CreditCardID
JOIN Person.BusinessEntityContact PB ON SC.CreditCardID = PB.PersonID
JOIN Person.ContactType PC ON PB.ContactTypeID = PC.ContactTypeID
WHERE LEN(pp.LastName) = (SELECT MAX(LEN(pp2.LastName)) 
						  FROM Person.Person PP2 )
						  GROUP BY PP.LastName;

/*10.Realizar una consulta que devuelva los nombres y apellidos de los contactos
que hayan sido modificados en los últimos 3 años.*/

DECLARE @AnioAtras INT = YEAR(getdate())-3;

SELECT PP.FirstName, PP.LastName, PP.ModifiedDate 
FROM Person.Person PP 
JOIN Sales.PersonCreditCard SP ON pp.BusinessEntityID = SP.BusinessEntityID
JOIN Sales.CreditCard SC ON SP.CreditCardID = SC.CreditCardID
JOIN Person.BusinessEntityContact PB ON SC.CreditCardID = PB.PersonID
JOIN Person.ContactType PC ON PB.ContactTypeID = PC.ContactTypeID
WHERE YEAR(pp.ModifiedDate) > @AnioAtras;

/*11.Se quiere obtener los emails de todos los contactos, pero en mayúscula.*/

SELECT UPPER(pe.EmailAddress) 
FROM Person.Person PP 
JOIN Sales.PersonCreditCard SP ON PP.BusinessEntityID = SP.BusinessEntityID
JOIN Sales.CreditCard SC ON SP.CreditCardID = SC.CreditCardID
JOIN Person.BusinessEntityContact PB ON SC.CreditCardID = PB.PersonID
JOIN Person.ContactType PC ON PB.ContactTypeID = PC.ContactTypeID
JOIN Person.EmailAddress PE ON PE.BusinessEntityID = PP.BusinessEntityID

/*12.Realizar una consulta que permita particionar el mail de cada contacto,
obteniendo lo siguiente: IDContacto=1 email=juanp@ibm.com nombre=juanp Dominio=ibm*/

SELECT PC.ContactTypeID, PE.EmailAddress, REPLACE(PE.EmailAddress, 'juanp@ibm.com', ' ') 
FROM Person.Person PP 
JOIN Sales.PersonCreditCard SP ON PP.BusinessEntityID = SP.BusinessEntityID
JOIN Sales.CreditCard SC ON SP.CreditCardID = SC.CreditCardID
JOIN Person.BusinessEntityContact PB ON SC.CreditCardID = PB.PersonID
JOIN Person.ContactType PC ON PB.ContactTypeID = PC.ContactTypeID
JOIN Person.EmailAddress PE ON PE.BusinessEntityID = PP.BusinessEntityID;

/*13. Devolver los últimos 3 dígitos del NationalIDNumber de cada empleado*/

SELECT RIGHT( HE.NationalIDNumber,3) 
FROM HumanResources.Employee HE;

/*14.Se desea enmascarar el NationalIDNumbre de cada empleado, de la
siguiente forma ###-####-##: ID=36 Numero=113695504  Enmascarado=113-6955-04*/

SELECT HE.NationalIDNumber,
SUBSTRING(NationalIDNumber, 1, 3) + '-' + 
SUBSTRING(NationalIDNumber, 4, 4) + '-' + 
SUBSTRING(NationalIDNumber, 8, 2) AS NumeroEnmascarado
FROM HumanResources.Employee he;
 
/*15. Listar la dirección de cada empleado “supervisor” que haya nacido hace más
de 30 años. Listar todos los datos en mayúscula. Los datos a visualizar son:
nombre y apellido del empleado, dirección y ciudad.*/

SELECT DATEDIFF(YEAR, HE.BirthDate, GETDATE()) AS Edad, UPPER(PP.FirstName) AS Nombre,
UPPER(pp.LastName) AS Apellido, UPPER(PA.AddressLine1) AS Direccion, UPPER(PA.City) AS Ciudad
FROM HumanResources.Employee HE 
JOIN Person.Person PP ON PP.BusinessEntityID = HE.BusinessEntityID
JOIN Person.BusinessEntity PB ON PP.BusinessEntityID = PB.BusinessEntityID
JOIN Person.BusinessEntityAddress PBA ON PB.BusinessEntityID = PBA.BusinessEntityID
JOIN Person.Address PA ON PBA.AddressID = PA.AddressID
WHERE HE.JobTitle = 'Production Supervisor - WC10'
AND DATEDIFF(YEAR, HE.BirthDate, GETDATE()) >30 ;

/*16. Listar la cantidad de empleados hombres y mujeres, de la siguiente forma:
Sexo=Femenino-Masculino  Cantidad=47-56
Nota: Debe decir, Femenino y Masculino de la misma forma que se muestra.*/

SELECT 
CASE
WHEN HE.Gender = 'M' THEN 'Masculino'
WHEN HE.Gender = 'F' THEN 'Femenino'
ELSE HE.Gender
END AS Sexo , COUNT(HE.Gender) AS Cantidad 
FROM HumanResources.Employee HE 
GROUP BY HE.Gender;

/*17.Categorizar a los empleados según la cantidad de horas de vacaciones,
según el siguiente formato:
Alto = más de 50 / medio= entre 20 y 50 / bajo = menos de 20 
Empleado Horas
Juan Perez Alto
Ana Sanchez Bajo
Julio Gomez Medio */

SELECT
CASE
WHEN HE.VacationHours >50 THEN 'Alto'
WHEN HE.VacationHours BETWEEN 20 AND 50 THEN 'Medio'
WHEN HE.VacationHours < 20 THEN 'Bajo'
END AS 'Nivel vacacional' 
FROM HumanResources.Employee HE;