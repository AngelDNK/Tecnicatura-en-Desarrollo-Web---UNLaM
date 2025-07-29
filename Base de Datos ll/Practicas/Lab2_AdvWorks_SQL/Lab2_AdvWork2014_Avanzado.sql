use AdventureWorks2014;

/*1. Listar los nombres de los productos y el nombre del modelo
que posee asignado. Solo listar aquellos que tengan asignado
algún modelo.*/

SELECT PP.Name AS NombreDeProductos, PM.Name AS NombreDelModelo
FROM Production.Product PP
JOIN Production.ProductModel PM ON PP.ProductModelID = PM.ProductModelID
WHERE PP.ProductModelID IS NOT NULL;

/*2. Mostrar “todos” los productos junto con el modelo que tenga
asignado. En el caso que no tenga asignado ningún modelo,
mostrar su nulidad.*/

SELECT PP.ProductID, PM.ProductModelID
FROM Production.Product PP
LEFT JOIN Production.ProductModel PM ON PP.ProductModelID = PM.ProductModelID;

/*3. Ídem Ejercicio2, pero en lugar de mostrar nulidad, mostrar la
palabra “Sin Modelo” para indicar que el producto no posee un
modelo asignado.*/

SELECT PP.Name,
CASE 
WHEN PM.Name IS NULL THEN 'Sin modelo'
ELSE PM.Name
END AS 'Modelo'
From Production.Product PP LEFT JOIN Production.ProductModel PM ON PP.ProductModelID = PM.ProductModelID;

/*4. Contar la cantidad de Productos que poseen asignado cada
uno de los modelos.*/

SELECT ProductModelID, COUNT(ProductID) AS cantidad_productos
FROM Production.Product
GROUP BY ProductModelID;

/*5. Contar la cantidad de Productos que poseen asignado cada
uno de los modelos, pero mostrar solo aquellos modelos que
posean asignados 2 o más productos.*/

SELECT ProductModelID, COUNT(ProductID) AS cantidad_productos
FROM Production.Product
GROUP BY ProductModelID
HAVING COUNT(ProductID) >= 2;

/*6. Contar la cantidad de Productos que poseen asignado un
modelo valido, es decir, que se encuentre cargado en la tabla
de modelos. Realizar este ejercicio de 3 formas posibles:
“exists” / “in” / “inner join”.*/

/*USANDO EL EXISTS*/
SELECT COUNT(PP.ProductID) AS cantidad_productos
FROM Production.Product PP
WHERE EXISTS (
    SELECT 1
    FROM Production.ProductModel PM
    WHERE PM.ProductModelID = PP.ProductModelID);

/*USANDO EL IN*/
SELECT COUNT(ProductID) AS cantidad_productos
FROM Production.Product
WHERE Product.ProductModelID IN (
    SELECT ProductModelID
    FROM Production.ProductModel);

/*USANDO EL INNER JOIN*/
SELECT COUNT(PP.ProductID) AS cantidad_productos
FROM Production.Product PP
INNER JOIN Production.ProductModel PM ON PP.ProductModelID = PM.ProductModelID;

/*7. Contar cuantos productos poseen asignado cada uno de los
modelos, es decir, se quiere visualizar el nombre del modelo y
la cantidad de productos asignados. Si algún modelo no posee
asignado ningún producto, se quiere visualizar 0 (cero).*/

SELECT PM.Name AS Nombre_Modelo, COUNT(PP.ProductID) AS cantidad_productos
FROM Production.ProductModel PM
LEFT JOIN Production.Product PP ON PM.ProductModelID = PM.ProductModelID
GROUP BY PM.Name;

/*8. Se quiere visualizar, el nombre del producto, el nombre
modelo que posee asignado, la ilustración que posee asignada
y la fecha de última modificación de dicha ilustración y el
diagrama que tiene asignado la ilustración. Solo nos interesan
los productos que cuesten más de $150 y que posean algún
color asignado.*/

SELECT PP.Name AS Producto, PM.Name AS Modelo, PMI.IllustrationID, PI.ModifiedDate AS UltimaModificacion, PI.Diagram AS Diagrama, PP.ListPrice AS Precio, PP.Color
FROM Production.Product PP 
JOIN Production.ProductModel PM ON PP.ProductModelID = PM.ProductModelID
JOIN Production.ProductModelIllustration PMI ON PM.ProductModelID = PMI.ProductModelID
JOIN Production.Illustration PI ON PI.IllustrationID = PI.IllustrationID
WHERE PP.Color IS NOT NULL AND PP.ListPrice >150;

/*9. Mostrar aquellas culturas que no están asignadas a ningún
producto/modelo.
(Production.ProductModelProductDescriptionCulture)*/

SELECT PC.Name AS Cultura , PC.CultureID
FROM Production.Culture PC
WHERE pc.CultureID NOT IN (SELECT PMC.CultureID 
						   FROM Production.Product PP 
						   JOIN Production.ProductModel PM ON PP.ProductModelID = PM.ProductModelID
						   JOIN Production.ProductModelProductDescriptionCulture PMC ON PM.ProductModelID = PMC.ProductModelID);

/*10. Agregar a la base de datos el tipo de contacto “Ejecutivo de
Cuentas” (Person.ContactType)*/

INSERT INTO Person.ContactType (Name, ModifiedDate) 
VALUES('Ejecutivo de Cuentas','2022-09-02');

/*11. Agregar la cultura llamada “nn” – “Cultura Moderna”.*/

INSERT INTO Production.Culture (CultureID,Name, ModifiedDate)
VALUES('nn','Cultura Moderna', '2022-09-02');

/*12. Cambiar la fecha de modificación de las culturas Spanish,
French y Thai para indicar que fueron modificadas hoy.*/

UPDATE Production.Culture
SET ModifiedDate = GETDATE() --Dia de hoy
WHERE Name IN ('Spanish','French','Thai');

/*13. En la tabla Production.CultureHis agregar todas las culturas
que fueron modificadas hoy. (Insert/Select).*/

INSERT INTO Production.Culture SELECT * 
							   FROM Production.Culture PC where PC.ModifiedDate = GETDATE();

/*14. Al contacto con ID 10 colocarle como nombre “Juan Perez”.*/

UPDATE Person.ContactType 
SET Name = 'Juan Perez' 
WHERE ContactTypeID = 10;

/*15. Agregar la moneda “Peso Argentino” con el código “PAR”
(Sales.Currency)-*/

INSERT INTO Sales.Currency 
VALUES ('PAR', 'Peso Argentino', GETDATE());

/*16. ¿Qué sucede si tratamos de eliminar el código ARS
correspondiente al Peso Argentino? ¿Por qué?*/

DELETE FROM Sales.Currency 
WHERE Currency.CurrencyCode ='ARS';

/*17. Realice los borrados necesarios para que nos permita eliminar
el registro de la moneda con código ARS.*/

DELETE FROM Sales.CountryRegionCurrency 
WHERE CurrencyCode = 'ARS';

DELETE FROM Sales.Currency 
WHERE Currency.CurrencyCode ='ARS';

/*18. Eliminar aquellas culturas que no estén asignadas a ningún
producto (Production.ProductModelProductDescriptionCulture).*/

DELETE FROM Production.Culture
WHERE CultureID NOT IN (SELECT PMC.CultureID 
						FROM Production.Product PP 
						JOIN Production.ProductModel PM ON PP.ProductModelID = PM.ProductModelID
						JOIN Production.ProductModelProductDescriptionCulture PMC ON PM.ProductModelID = PMC.ProductModelID);