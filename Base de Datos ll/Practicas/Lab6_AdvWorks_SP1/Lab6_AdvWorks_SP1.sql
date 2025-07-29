USE AdventureWorks2014;


/*1- p_InsCulture(id,name,date): Este sp debe permitir dar de alta un nuevo
registro en la tabla Production.Culture. Los tipos de datos de los parámetros
deben corresponderse con la tabla. Para ayudarse, se podrá ejecutar el
procedimiento sp_help“<esquema.objeto>”.*/

EXEC sp_help 'Production.Culture'; /*Consultar la estructura de la tabla*/

CREATE PROCEDURE p_InsCulture
    @CultureID NCHAR(6),
    @Name NVARCHAR(50),
    @ModifiedDate DATETIME
AS
BEGIN
    INSERT INTO Production.Culture (CultureID, Name, ModifiedDate)
    VALUES (@CultureID, @Name, @ModifiedDate);
END;
GO

/*2- p_SelCuture(id): Este sp devolverá el registro completo según el id
enviado.*/

CREATE PROCEDURE p_SelCulture
    @CultureID NCHAR(6) 
AS
BEGIN
    SELECT *
    FROM Production.Culture
    WHERE CultureID = @CultureID;
END;
GO

EXEC p_SelCulture @CultureID = 'específico_id'; /* Para obtener el resultado*/

/*3- p_DelCulture(id): Este sp debe borrar el id enviado por parámetro de la
tabla Production.Culture.*/

CREATE PROCEDURE p_DelCulture
    @CultureID NCHAR(6)  
AS
BEGIN
    DELETE FROM Production.Culture
    WHERE CultureID = @CultureID;
END;
GO

EXEC p_DelCulture @CultureID = 'específico_id'; /* Para obtener el resultado*/

/*4- p_UpdCulture(id): Dado un id debe permitirme cambiar el campo name
del registro.*/

CREATE PROCEDURE p_UpdCulture
    @CultureID NCHAR(6),     
    @NewName NVARCHAR(50)     
AS
BEGIN
    UPDATE Production.Culture
    SET Name = @NewName
    WHERE CultureID = @CultureID;
END;
GO

EXEC p_UpdCulture @CultureID = 'específico_id', @NewName = 'NuevoNombre'; /* Para obtener el resultado*/

/*5- sp_CantCulture (cant out): Realizar un sp que devuelva la cantidad de
registros en Culture. El resultado deberá colocarlo en una variable de salida.*/

CREATE PROCEDURE sp_CantCulture
    @Cant INT OUTPUT  
AS
BEGIN
    
    SELECT @Cant = COUNT(*) 
    FROM Production.Culture;
END;
GO

DECLARE @CantidadRegistros INT;

EXEC sp_CantCulture @Cant = @CantidadRegistros OUTPUT;


SELECT @CantidadRegistros AS CantidadDeRegistros; /* Mostrar el valor de la variable de salida */

/*6- sp_CultureAsignadas : Realizar un sp que devuelva solamente las
Culture’s que estén siendo utilizadas en las tablas (Verificar qué tabla/s la
están referenciando). Sólo debemos devolver id y nombre de la Cultura.*/

CREATE PROCEDURE sp_CultureAsignadas
AS
BEGIN
    SELECT DISTINCT c.CultureID, c.Name
    FROM Production.Culture c
    INNER JOIN SomeTable st ON c.CultureID = st.CultureID  
END;
GO

/*7- p_ValCulture(id,name,date,operación, valida out): Este sp permitirá
validar los datos enviados por parámetro. En el caso que el registro sea
válido devolverá un 1 en el parámetro de salida valida ó 0 en caso contrario.
El parámetro operación puede ser “U” (Update), “I” (Insert) ó “D” (Delete).
Lo que se debe validar es:
- Si se está insertando no se podrá agregar un registro con un id
existente, ya que arrojará un error.
- Tampoco se puede agregar dos registros Cultura con el mismo Name,
ya que el campo Name es un unique index.
- Ninguno de los campos debería estar vacío.
- La fecha ingresada no puede ser menor a la fecha actual.*/

CREATE PROCEDURE p_ValCulture
    @CultureID NCHAR(6),
    @Name NVARCHAR(50),
    @ModifiedDate DATETIME,
    @Operacion CHAR(1),     
    @Valida BIT OUTPUT       
AS
BEGIN
    
    SET @Valida = 0;
    
   
    IF (@CultureID = '' OR @Name = '' OR @ModifiedDate IS NULL)
    BEGIN
        RETURN;  
    END

  
    IF (@ModifiedDate < GETDATE())
    BEGIN
        RETURN;  
    END

    IF (@Operacion = 'I')  
    BEGIN
       
        IF EXISTS (SELECT 1 FROM Production.Culture WHERE CultureID = @CultureID)
        BEGIN
            RETURN;  
        END
        
       
        IF EXISTS (SELECT 1 FROM Production.Culture WHERE Name = @Name)
        BEGIN
            RETURN;  
        END
    END
    ELSE IF (@Operacion = 'U')  
    BEGIN
     
        IF NOT EXISTS (SELECT 1 FROM Production.Culture WHERE CultureID = @CultureID)
        BEGIN
            RETURN;  
        END

        
        IF EXISTS (SELECT 1 FROM Production.Culture WHERE Name = @Name AND CultureID <> @CultureID)
        BEGIN
            RETURN;  
        END
    END
    ELSE IF (@Operacion = 'D')  
    BEGIN
      
        IF NOT EXISTS (SELECT 1 FROM Production.Culture WHERE CultureID = @CultureID)
        BEGIN
            RETURN; 
        END
    END

    
    SET @Valida = 1;
END;
GO

/* Para obtener el resultado*/

DECLARE @Valido BIT;

EXEC p_ValCulture @CultureID = 'A123', @Name = 'Nueva Cultura', @ModifiedDate = '2024-10-15', @Operacion = 'I', @Valida = @Valido OUTPUT;

SELECT @Valido AS ResultadoDeValidacion;

/*8- p_SelCulture2(id out, name out, date out): A diferencia del sp del punto
2, este debe emitir todos los datos en sus parámetros de salida. ¿Cómo se
debe realizar la llamada del sp para testear este sp?*/

CREATE PROCEDURE p_SelCulture2
    @CultureID NCHAR(6) OUTPUT,
    @Name NVARCHAR(50) OUTPUT,
    @ModifiedDate DATETIME OUTPUT
AS
BEGIN
    
    SELECT 
        @CultureID = CultureID, 
        @Name = Name, 
        @ModifiedDate = ModifiedDate
    FROM Production.Culture
    WHERE CultureID = @CultureID;
END;
GO

/*Para testear este procedimiento y recibir los valores en variables, se debe declarar previamente 
las variables para almacenar los resultados, luego ejecutar el stored procedurey finalmente mostrar 
los valores obtenidos.*/


/*9- Realizar una modificación al sp p_InsCulture para que valide los registros
ingresados. Por lo cual, deberá invocar al sp p_ValCulture. Sólo se insertará
si la validación es correcta.¨*/

CREATE PROCEDURE p_InsCulture
    @CultureID NCHAR(6),
    @Name NVARCHAR(50),
    @ModifiedDate DATETIME
AS
BEGIN
    DECLARE @Valida BIT;

    
    EXEC p_ValCulture @CultureID, @Name, @ModifiedDate, 'I', @Valida OUTPUT;

    IF @Valida = 1
    BEGIN
        
        INSERT INTO Production.Culture (CultureID, Name, ModifiedDate)
        VALUES (@CultureID, @Name, @ModifiedDate);
    END
    ELSE
    BEGIN
       
        RAISERROR('Los datos no son válidos para la inserción.', 16, 1);
    END
END;
GO

EXEC p_InsCulture @CultureID = 'A123', @Name = 'Nueva Cultura', @ModifiedDate = '2024-10-15'; /* Para obtener el resultado*/

/* 10-Idem con el sp p_UpdCulture. Validar los datos a actualizar.*/

CREATE PROCEDURE p_UpdCulture
    @CultureID NCHAR(6),
    @NewName NVARCHAR(50),
    @ModifiedDate DATETIME
AS
BEGIN
    DECLARE @Valida BIT;

    
    EXEC p_ValCulture @CultureID, @NewName, @ModifiedDate, 'U', @Valida OUTPUT;

    
    IF @Valida = 1
    BEGIN
     
        UPDATE Production.Culture
        SET Name = @NewName, ModifiedDate = @ModifiedDate
        WHERE CultureID = @CultureID;
    END
    ELSE
    BEGIN
      
        RAISERROR('Los datos no son válidos para la actualización.', 16, 1);
    END
END;
GO

/*11-En p_DelCulture se deberá modificar para que valide que no posea registros
relacionados en la tabla que lo referencia. Investigar cuál es la tabla
referenciada e incluir esta validación. Si se está utilizando, emitir un
mensaje que no se podrá eliminar.*/

CREATE PROCEDURE p_DelCulture
    @CultureID NCHAR(6)
AS
BEGIN
   
    IF EXISTS (SELECT 1 FROM SomeTable WHERE CultureID = @CultureID)
    BEGIN
  
        RAISERROR('No se puede eliminar la cultura, ya que posee registros relacionados en la tabla que la referencia.', 16, 1);
        RETURN;  
    END

   
    DELETE FROM Production.Culture
    WHERE CultureID = @CultureID;
END;
GO

/*12-p_CrearCultureHis: Realizar un sp que permita crear la siguiente tabla
histórica de Cultura. Si existe deberá eliminarse. Ejecutar el procedimiento
para que se pueda crear:

CREATE TABLE Production.CultureHis(
CultureID nchar(6) NOT NULL,
Name [dbo].[Name] NOT NULL,
ModifiedDate datetime NOT NULL CONSTRAINT
DF_CultureHis_ModifiedDate DEFAULT (getdate()),
CONSTRAINT PK_CultureHis_IDDate PRIMARY KEY CLUSTERED (CultureID,
ModifiedDate)
)
- ¿Qué tipo de datos posee asignado el campo Name?
- ¿Qué sucede si no se inserta el campo ModifiedDate?*/

CREATE TABLE Production.CultureHis(
CultureID nchar(6) NOT NULL,
Name [dbo].[Name] NOT NULL,
ModifiedDate datetime NOT NULL CONSTRAINT
DF_CultureHis_ModifiedDate DEFAULT (getdate()),
CONSTRAINT PK_CultureHis_IDDate PRIMARY KEY CLUSTERED (CultureID,
ModifiedDate)
)

CREATE PROCEDURE p_CrearCultureHis
AS
BEGIN
    
    IF OBJECT_ID('Production.CultureHis', 'U') IS NOT NULL
    BEGIN
        DROP TABLE Production.CultureHis;
    END

    
    CREATE TABLE Production.CultureHis (
        CultureID NCHAR(6) NOT NULL,
        Name NVARCHAR(50) NOT NULL, 
        ModifiedDate DATETIME NOT NULL CONSTRAINT DF_CultureHis_ModifiedDate DEFAULT (GETDATE()),
        CONSTRAINT PK_CultureHis_IDDate PRIMARY KEY CLUSTERED (CultureID, ModifiedDate)
    );
END;
GO

/*El campo Name ha sido asignado como NVARCHAR lo que esto significa que puede almacenar cadenas de texto con hasta 50 caracteres.*/

/*Si no se proporciona un valor para ModifiedDate al insertar un registro en la tabla CultureHis, se utilizará el valor por defecto 
especificado (DEFAULT (GETDATE())), lo que asignará automáticamente la fecha y hora actuales al campo ModifiedDate.*/

/*13-Dada la tabla histórica creada en el punto 12, se desea modificar el
procedimiento p_UpdCulture creado en el punto 4. La modificación consiste
en que cada vez que se cambia algún valor de la tabla Culture se desea
enviar el registro anterior a una tabla histórica. De esta forma, en la tabla
Culture siempre tendremos el último registro y en la tabla CutureHis cada
una de las modificaciones realizadas.*/CREATE PROCEDURE p_UpdCulture
    @CultureID NCHAR(6),
    @NewName NVARCHAR(50),
    @ModifiedDate DATETIME
AS
BEGIN
    DECLARE @OldName NVARCHAR(50);
    DECLARE @OldModifiedDate DATETIME;

    
    SELECT 
        @OldName = Name,
        @OldModifiedDate = ModifiedDate
    FROM Production.Culture
    WHERE CultureID = @CultureID;

 
    IF @OldName IS NULL
    BEGIN
        RAISERROR('El registro con el CultureID especificado no existe.', 16, 1);
        RETURN;
    END

  
    INSERT INTO Production.CultureHis (CultureID, Name, ModifiedDate)
    VALUES (@CultureID, @OldName, @OldModifiedDate);

   
    UPDATE Production.Culture
    SET Name = @NewName, ModifiedDate = @ModifiedDate
    WHERE CultureID = @CultureID;
END;
GO

/*14-p_UserTables(opcional esquema): Realizar un procedimiento que liste
las tablas que hayan sido creadas dentro de la base de datos con su
nombre, esquema y fecha de creación. En el caso que se ingrese por
parámetro el esquema, entonces mostrar únicamente dichas tablas, de lo
contrario, mostrar todos los esquemas de la base.*/

CREATE PROCEDURE p_UserTables
    @SchemaName NVARCHAR(128) = NULL  
AS
BEGIN
    
    SELECT 
        s.name AS SchemaName,
        t.name AS TableName,
        t.create_date AS CreationDate
    FROM 
        sys.tables t
    INNER JOIN 
        sys.schemas s ON t.schema_id = s.schema_id
    WHERE 
        (@SchemaName IS NULL OR s.name = @SchemaName)  
    ORDER BY 
        s.name, t.name;  
END;
GO

/*15-p_GenerarProductoxColor(): Generar un procedimiento que divida los
productos según el color que poseen. Los mismos deben ser insertados en
diferentes tablas según el color del producto. Por ejemplo, las tablas podrían
ser Product_Black, Product_Silver, etc… Estas tablas deben ser generadas
dinámicamente según los colores que existan en los productos, es decir, si
genero un nuevo producto con un nuevo color, al ejecutar el procedimiento
debe generar dicho color. Cada vez que se ejecute este procedimiento se
recrearán las tablas de colores. Los productos que no posean color
asignados, no se tendrán en cuenta para la generación de tablas y no se
insertarán en ninguna tabla de color.*/

CREATE PROCEDURE p_GenerarProductoxColor
AS
BEGIN
    DECLARE @Color NVARCHAR(50);
    DECLARE @TableName NVARCHAR(128);
    DECLARE @SQL NVARCHAR(MAX);
    
    
    DECLARE color_cursor CURSOR FOR
    SELECT DISTINCT Color
    FROM Products
    WHERE Color IS NOT NULL;

    OPEN color_cursor;
    FETCH NEXT FROM color_cursor INTO @Color;

   
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @TableName = 'Product_' + REPLACE(@Color, ' ', '_'); 
        SET @SQL = 'IF OBJECT_ID(''dbo.' + @TableName + ''', ''U'') IS NOT NULL DROP TABLE dbo.' + @TableName;
        EXEC sp_executesql @SQL; 
        
        FETCH NEXT FROM color_cursor INTO @Color;
    END

    CLOSE color_cursor;
    DEALLOCATE color_cursor;

   
    OPEN color_cursor;
    FETCH NEXT FROM color_cursor INTO @Color;

   
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @TableName = 'Product_' + REPLACE(@Color, ' ', '_'); 

        
        SET @SQL = 'CREATE TABLE dbo.' + @TableName + ' (ProductID INT PRIMARY KEY, ProductName NVARCHAR(100), Color NVARCHAR(50));';
        EXEC sp_executesql @SQL;  

        
        SET @SQL = 'INSERT INTO dbo.' + @TableName + ' (ProductID, ProductName, Color) SELECT ProductID, ProductName, Color 
		FROM Products WHERE Color = ''' + @Color + ''';';
        EXEC sp_executesql @SQL;  
        
        FETCH NEXT FROM color_cursor INTO @Color;
    END

    CLOSE color_cursor;
    DEALLOCATE color_cursor;
END;
GO

/*16-p_UltimoProducto(param): Realizar un procedimiento que devuelva en
sus parámetros (output), el último producto ingresado.*/

CREATE PROCEDURE p_UltimoProducto
    @ProductID INT OUTPUT,
    @ProductName NVARCHAR(100) OUTPUT,
    @CreatedDate DATETIME OUTPUT
AS
BEGIN
    
    SELECT TOP 1
        @ProductID = ProductID,
        @ProductName = ProductName,
        @CreatedDate = CreatedDate
    FROM Products
    ORDER BY CreatedDate DESC;  
END;
GO

/*17-p_TotalVentas(fecha): Realizar un procedimiento que devuelva el total
facturado en un día dado. El procedimiento, simplemente debe devolver el
total monetario de lo facturado (Sales).*/

CREATE PROCEDURE p_TotalVentas
    @Fecha DATETIME
AS
BEGIN
    DECLARE @TotalFacturado DECIMAL(18, 2);

    
    SELECT @TotalFacturado = SUM(Monto)
    FROM Sales
    WHERE CONVERT(DATE, FechaVenta) = CONVERT(DATE, @Fecha);

    
    SELECT @TotalFacturado AS TotalFacturado;
END;
GO

DECLARE @Fecha DATETIME = '2024-10-13';  

EXEC p_TotalVentas @Fecha;