use AdventureWorks2014;

/*1- p_InsertaDatos(): Realizar un sp que permita insertar números pares del
2 al 20 en una tabla con el nombre dbo.NumeroPar (nro smallint), excepto
los números 10 y 16. La tabla debe ser creada fuera del procedimiento.
Controlar los errores que pudieran sucederse.*/

CREATE TABLE dbo.NumeroPar (
    nro SMALLINT
);
GO

CREATE PROCEDURE p_InsertaDatos
AS
BEGIN
    BEGIN TRY
	BEGIN TRANSACTION;
		DECLARE @numero SMALLINT = 2;
				WHILE @numero <= 20
    BEGIN
        IF @numero <> 10 AND @numero <> 16
    BEGIN
        INSERT INTO dbo.NumeroPar (nro) VALUES (@numero);
    END
            SET @numero = @numero + 2;
    END
	    COMMIT TRANSACTION;
    END 
	TRY
    BEGIN CATCH
		 ROLLBACK TRANSACTION;
	    DECLARE @MensajeDeError NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @GravedadDelError INT = ERROR_SEVERITY();
        DECLARE @EstadoDeError INT = ERROR_STATE();

        RAISERROR ( @MensajeDeError, @GravedadDelError, @EstadoDeError);
    END CATCH
END;
GO

/*2- p_InsertaDatos2(nro): Realiza un sp que inserte a la tabla
dbo.NumeroPar el número ingresado por parámetro, pero sólo se deberá
insertar si el número es par. De lo contrario lanzar una excepción.*/


CREATE PROCEDURE p_InsertaDatos2
    @nro SMALLINT
AS
BEGIN
    BEGIN TRY
        
        IF @nro % 2 <> 0
       
        
        INSERT INTO dbo.NumeroPar (nro)
        VALUES (@nro);
    END TRY
    BEGIN CATCH
        
        DECLARE @MensajeDeError NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @GravedadDelError INT = ERROR_SEVERITY();
        DECLARE @EstadoDeError INT = ERROR_STATE();
        THROW;
    END CATCH
END;
GO

/*3- p_MuestraNroPares(): Realizar un sp que devuelva los registros
insertados en los ítems anteriores. En el caso de que la tabla esté vacía
lanzar una excepción indicando dicho error.*/

CREATE PROCEDURE p_MuestraNroPares
AS
BEGIN
    BEGIN TRY
      
        IF NOT EXISTS (SELECT 1 FROM dbo.NumeroPar)
        BEGIN
            
            THROW 50002, 1;
        END

       
        SELECT nro FROM dbo.NumeroPar;
    END TRY
    BEGIN CATCH
       
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

       
        THROW;
    END CATCH
END;
GO

/*4- p_ActualizaBonus(): Se actualizará el bonus de todas las personas que se
encuentran en la tabla Sales.SalesPerson, teniendo en cuenta las siguientes
condiciones: Se calculará el bonus tomando como % el valor CommissionPct
(%) de su valor SalesQuota. Si el valor de SalesQuota es NULL se colocará 0
(cero) como bonus. Si el bonus resultante quedó a menos de 3000, se
dejará 3000 como mínimo valor de bonus (siempre y cuando tenga algún
dato en SalesQuota). Controlar errores y manejar todo el ejercicio como una
única transacción.*/

CREATE PROCEDURE p_ActualizaBonus
AS
BEGIN
    BEGIN TRY
        
        BEGIN TRANSACTION;

        
        UPDATE Sales.SalesPerson
        SET Bonus = CASE 
                        
                        WHEN SalesQuota IS NULL THEN 0
                      
                        ELSE CASE 
                                WHEN (CommissionPct * SalesQuota) < 3000 
                                THEN 3000 
                                ELSE CommissionPct * SalesQuota 
                             END
                   END;

        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
       
        ROLLBACK TRANSACTION;

       
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO

/*5- p_MuestraClientes(tipo): Realizar un procedimiento que muestre los
clientes de un determinado tipo. Los tipos ingresados por parámetro posibles
sólo pueden ser S ó I, si se ingresa otro valor como tipo arrojar un error. El
sp debe mostrar sólo los números de cuentas de los tipos seleccionados
ordenados en forma descendente. Utilizar en este ejemplo la cláusula WITH.*/

CREATE PROCEDURE p_MuestraClientes
    @tipo CHAR(1)
AS
BEGIN
    BEGIN TRY
        
        IF @tipo NOT IN ('S', 'I')
        BEGIN
            
            THROW 50001, 'El tipo de cliente debe ser S o I.', 1;
        END;

       
        WITH CTE_Clientes AS
        (
            SELECT AccountNumber
            FROM Customers 
            WHERE CustomerType = @tipo
        )
      
        SELECT AccountNumber
        FROM CTE_Clientes
        ORDER BY AccountNumber DESC;

    END TRY
    BEGIN CATCH
       
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

       
        THROW;
    END CATCH
END;
GO

/*6- En el p_InsCulture(id,name,date), se deberá agregar el manejo de
transacciones y arrojar una excepción en el caso de encontrarse que la
validación es incorrecta.*/

CREATE PROCEDURE p_InsCulture
    @CultureID NCHAR(6),
    @Name NVARCHAR(50),
    @ModifiedDate DATETIME
AS
BEGIN
    BEGIN TRY
        -- Inicia la transacción
        BEGIN TRANSACTION;

        -- Verifica si el CultureID ya existe
        IF EXISTS (SELECT 1 FROM Production.Culture WHERE CultureID = @CultureID)
        BEGIN
            -- Lanza una excepción si el CultureID ya existe
            THROW 50001, 'El CultureID ya existe en la tabla Production.Culture.', 1;
        END

        -- Inserta el nuevo registro en la tabla
        INSERT INTO Production.Culture (CultureID, Name, ModifiedDate)
        VALUES (@CultureID, @Name, @ModifiedDate);

        -- Confirma la transacción si todo es exitoso
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, deshace la transacción
        ROLLBACK TRANSACTION;

        -- Manejo de errores
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        -- Lanza el error capturado
        THROW;
    END CATCH
END;
GO

/*7- En el p_SelCulture(id), arrojar una excepción si se estaría buscando un
registro que no existe. Devolver con el mensaje “Registro no encontrado”.*/

CREATE PROCEDURE p_SelCulture
    @CultureID NCHAR(6)
AS
BEGIN
    BEGIN TRY
       
        IF NOT EXISTS (SELECT 1 FROM Production.Culture WHERE CultureID = @CultureID)
        BEGIN
           
            THROW 50001, 'Registro no encontrado.', 1;
        END

        
        SELECT *
        FROM Production.Culture
        WHERE CultureID = @CultureID;
    END TRY
    BEGIN CATCH
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        
        THROW;
    END CATCH
END;
GO

/*8- Realizar el mismo procedimiento para el p_DelCulture(id). Además, en este
caso realizar el manejo de transacciones.*/

CREATE PROCEDURE p_DelCulture
    @CultureID NCHAR(6)  
AS
BEGIN
    BEGIN TRY
       
        BEGIN TRANSACTION;

        
        IF NOT EXISTS (SELECT 1 FROM Production.Culture WHERE CultureID = @CultureID)
        BEGIN
            
            THROW 50001, 'No se puede eliminar. Registro no encontrado.', 1;
        END

        
        DELETE FROM Production.Culture
        WHERE CultureID = @CultureID;

       
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        
        ROLLBACK TRANSACTION;

        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        
        THROW;
    END CATCH
END;
GO

/*9- En el procedimiento p_CrearCultureHis realizar el manejo de transacciones y
errores.*/

CREATE PROCEDURE p_CrearCultureHis
AS
BEGIN
    BEGIN TRY
        
        BEGIN TRANSACTION;

        
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

        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
       
        ROLLBACK TRANSACTION;

        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

       
        THROW;
    END CATCH
END;
GO