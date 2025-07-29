Use AdventureWorks2014;


/*1- Listar los códigos y descripciones de todos los productos
(Ayuda: Production.ProductDescription)*/

SELECT ProductDescriptionID, Description 
FROM Production.ProductDescription;


/*2- Listar los datos de la subcategoría número 17 (Ayuda:
Production.ProductSubCategory)*/

SELECT *
FROM Production.ProductSubcategory
WHERE ProductSubcategoryID = 17;

/*3- Listar los productos cuya descripción comience con D (Ayuda:
like ‘D%’)*/

SELECT * 
FROM Production.ProductDescription
WHERE Description LIKE 'D%';

/*4- Listar las descripciones de los productos cuyo número finalice
con 8 (Ayuda: ProductNumber like ‘%8’)*/

SELECT PP.ProductID, PD.Description, PP.ProductNumber 
FROM Production.Product PP 
JOIN Production.ProductModel PM ON PP.ProductModelID = PM.ProductModelID
JOIN Production.ProductModelProductDescriptionCulture PMPDC ON PM.ProductModelID = PMPDC.ProductModelID
JOIN Production.ProductDescription PD ON PD.ProductDescriptionID = PMPDC.ProductDescriptionID
WHERE PP.ProductNumber LIKE '%8';

/*5- Listar aquellos productos que posean un color asignado. Se
deberán excluir todos aquellos que no posean ningún valor
(Ayuda: is not null)*/

SELECT ProductID, Color
FROM Production.Product 
WHERE Color IS NOT NULL;

/*6- Listar el código y descripción de los productos de color Black
(Negro) y que posean el nivel de stock en 500. (Ayuda:
SafetyStockLevel = 500)*/

SELECT PP.ProductID, PD.Description
FROM Production.Product PP
JOIN Production.ProductModel PM ON PP.ProductModelID = PM.ProductModelID
JOIN Production.ProductModelProductDescriptionCulture PMPDC ON PM.ProductModelID = PMPDC.ProductModelID
JOIN Production.ProductDescription PD ON PD.ProductDescriptionID = PMPDC.ProductDescriptionID
WHERE PP.Color='Black' AND SafetyStockLevel = 500;

/*7- Listar los productos que sean de color Black (Negro) ó Silver
(Plateado).*/

SELECT ProductID
FROM Production.Product 
WHERE Color = 'Black' OR Color = 'Silver';

/*8- Listar los diferentes colores que posean asignados los
productos. Sólo se deben listar los colores. (Ayuda: distinct). */

SELECT DISTINCT Color 
FROM Production.Product;

/* 9- Contar la cantidad de categorías que se encuentren cargadas
en la base. (Ayuda: count)*/

SELECT COUNT(*)
FROM Production.Product

/*10- Contar la cantidad de subcategorías que posee asignada la
categoría 2.*/

SELECT COUNT(*)
FROM Production.ProductSubcategory 
WHERE ProductSubcategoryID = 2;

/*11- Listar la cantidad de productos que existan por cada uno de los
colores. */

SELECT Color, COUNT(*)
FROM Production.Product
GROUP BY Color;

/*12- Sumar todos los niveles de stocks aceptables que deben existir
para los productos con color Black. (Ayuda: sum)*/

SELECT SUM(SafetyStockLevel) 
FROM Production.Product 
WHERE Color = 'Black';

/*13- Calcular el promedio de stock que se debe tener de todos los
productos cuyo código se encuentre entre el 316 y 320.
(Ayuda: avg)*/

SELECT AVG(SafetyStockLevel) 
FROM Production.Product 
WHERE ProductID between 316 and 320;

/*14- Listar el nombre del producto y descripción de la subcategoría
que posea asignada. (Ayuda: inner join)*/

SELECT Name, Description 
FROM Production.Product 
JOIN Production.ProductDescription ON ProductID = ProductDescriptionID;

/*15- Listar todas las categorías que poseen asignado al menos una
subcategoría. Se deberán excluir aquellas que no posean
ninguna.*/

SELECT * 
FROM Production.ProductCategory PC 
join Production.ProductSubcategory PSC ON PC.ProductCategoryID = PSC.ProductCategoryID
WHERE PSC.ProductCategoryID IS NOT NULL;

/*16- Listar el código y descripción de los productos que posean fotos
asignadas. (Ayuda: Production.ProductPhoto)*/

SELECT PP.ProductID, PD.Description, PPH.ThumbnailPhotoFileName 
FROM Production.Product PP 
join Production.ProductProductPhoto PPP ON PP.ProductID = PPP.ProductID
join Production.ProductPhoto PPH ON PPP.ProductPhotoID= PPH.ProductPhotoID
JOIN Production.ProductModel PM ON PP.ProductModelID=PM.ProductModelID 
JOIN Production.ProductModelProductDescriptionCulture PDMC ON PDMC.ProductModelID=PP.ProductModelID
JOIN Production.ProductDescription PD ON PD.ProductDescriptionID=PDMC.ProductDescriptionID;

/*17- Listar la cantidad de productos que existan por cada una de las
Clases (Ayuda: campo Class)*/

SELECT COUNT(Class), Class 
FROM Production.Product 
GROUP BY Class;

/*18- Listar la descripción de los productos y su respectivo color. Sólo
nos interesa caracterizar al color con los valores: Black, Silver
u Otro. Por lo cual si no es ni silver ni black se debe indicar
Otro. (Ayuda: utilizar case).*/

SELECT
CASE
WHEN Color = 'Black' THEN 'Black'
WHEN Color = 'Silver' THEN 'Silver'
ELSE 'Otro'
END AS Color, PD.Description
from Production.Product  PP
JOIN Production.ProductModel PM ON PP.ProductModelID=PM.ProductModelID 
JOIN Production.ProductModelProductDescriptionCulture PDMC ON PDMC.ProductModelID=PP.ProductModelID
JOIN Production.ProductDescription PD ON PD.ProductDescriptionID=PDMC.ProductDescriptionID;

/*19- Listar el nombre de la categoría, el nombre de la subcategoría
y la descripción del producto. (Ayuda: join)*/

SELECT PC.Name AS Categoria, PS.Name AS SubCategoria, PD.Description
FROM Production.Product PP 
JOIN Production.ProductModel PM ON PP.ProductModelID=PM.ProductModelID 
JOIN Production.ProductModelProductDescriptionCulture PDMC ON PDMC.ProductModelID=PP.ProductModelID
JOIN Production.ProductDescription PD ON PD.ProductDescriptionID=PDMC.ProductDescriptionID
Join Production.ProductSubcategory PS on PS.ProductSubcategoryID = PP.ProductSubcategoryID
join Production.ProductCategory PC on PC.ProductCategoryID = PS.ProductCategoryID;

/*20- Listar la cantidad de subcategorías que posean asignado los
productos. (Ayuda: distinct).*/

SELECT COUNT(DISTINCT ProductSubcategoryID) 
FROM Production.Product;