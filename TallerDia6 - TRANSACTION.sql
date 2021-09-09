
---Transacciones (Transact-SQL)
/*/
Una transacci�n es una unidad �nica de trabajo. Si una transacci�n tiene �xito, 
todas las modificaciones de los datos realizadas durante la transacci�n se confirman 
y se convierten en una parte permanente de la base de datos.
*/

/*
SQL Server funciona en los modos de transacci�n siguientes:

Transacciones de confirmaci�n autom�tica
Cada instrucci�n individual es una transacci�n.
*/

/*
2 tipos de transacciones

Transacciones expl�citas
Transacciones impl�citas

*/

/*
Transacciones expl�citas
Cada transacci�n se inicia expl�citamente con la instrucci�n BEGIN TRANSACTION y 
se termina expl�citamente con una instrucci�n COMMIT o ROLLBACK.
*/

/*
Transacciones impl�citas
Se inicia impl�citamente una nueva transacci�n cuando se ha completado la anterior, 
pero cada transacci�n se completa expl�citamente con una instrucci�n COMMIT o ROLLBACK.
*/

/*

SQL Server proporciona las siguientes instrucciones de transacci�n:

BEGIN DISTRIBUTED TRANSACTION

ROLLBACK TRANSACTION

BEGIN TRANSACTION

COMMIT TRANSACTION

ROLLBACK WORK

COMMIT WORK

SAVE TRANSACTION

*/


---BEGIN DISTRIBUTED TRANSACTION

USE AdventureWorks2014;  
GO  
BEGIN DISTRIBUTED TRANSACTION;  

-- Delete candidate from local instance.  
DELETE AdventureWorks2014.HumanResources.JobCandidate  
    WHERE JobCandidateID = 13;  

-- Delete candidate from remote instance.  
DELETE RemoteServer.AdventureWorks2012.HumanResources.JobCandidate  ---- RemoteServer = (LINKED SERVER)
    WHERE JobCandidateID = 13;  

COMMIT TRANSACTION;  
GO


/*
ROLLBACK TRANSACTION
BEGIN TRANSACTION
COMMIT TRANSACTION
*/

BEGIN TRAN V

SELECT * FROM MovieStore..EmpresaMovie

TRUNCATE TABLE MovieStore..EmpresaMovie

SELECT * FROM MovieStore..EmpresaMovie

ROLLBACK TRAN V

SELECT * FROM MovieStore..EmpresaMovie

-------------------------------------------------

BEGIN TRAN V

SELECT * FROM MovieStore..EmpresaMovie

INSERT INTO MovieStore..EmpresaMovie(IdEmpresa, IdMovie, Estado)
VALUES(2, 2, 'A')

COMMIT TRAN V

SELECT * FROM MovieStore..EmpresaMovie



/*
ROLLBACK WORK
COMMIT WORK

Esta instrucci�n funciona de forma id�ntica a la instrucci�n COMMIT TRANSACTION
con la diferencia de que COMMIT TRANSACTION acepta nombres de transacci�n definidos por el usuario.

*/

BEGIN TRAN V

SELECT * FROM MovieStore..EmpresaMovie

INSERT INTO MovieStore..EmpresaMovie(IdEmpresa, IdMovie, Estado)
VALUES(3, 2, 'A')

ROLLBACK WORK

SELECT * FROM MovieStore..EmpresaMovie


---SAVE TRANSACTION
/*Establece un punto de retorno dentro de una transacci�n.
Para ver la sintaxis de Transact-SQL para SQL Server 2014 Y VERSIONES ANTERIORES
*/

---savepoint_name  => Es el nombre asignado al punto de retorno.
--@savepoint_variable

/*
XACT_STATE()

notifica el estado de la transacci�n de usuario de una solicitud que se est� ejecutando actualmente

--- 0 No hay ninguna transacci�n de usuario activa para la solicitud actual.   /1/-1
--- 1 La solicitud actual tiene una transacci�n de usuario activa
---  -1 La solicitud actual tiene una transacci�n de usuario activa, 
pero se ha producido un error por el cual la transacci�n se clasific� como no confirmable
*/

USE AdventureWorks2014
GO

IF EXISTS (SELECT name FROM sys.objects  
           WHERE name = N'SaveTranExample')  
    DROP PROCEDURE SaveTranExample;  
GO  
CREATE PROCEDURE SaveTranExample  
    @InputCandidateID INT  
AS  
    -- Detect whether the procedure was called  
    -- from an active transaction and save  
    -- that for later use.  
    -- In the procedure, @TranCounter = 0  
    -- means there was no active transaction  
    -- and the procedure started one.  
    -- @TranCounter > 0 means an active  
    -- transaction was started before the   
    -- procedure was called.  
    DECLARE @TranCounter INT;  
    SET @TranCounter = @@TRANCOUNT;  
    IF @TranCounter > 0  
        -- Procedure called when there is  
        -- an active transaction.  
        -- Create a savepoint to be able  
        -- to roll back only the work done  
        -- in the procedure if there is an  
        -- error.  
        SAVE TRANSACTION ProcedureSave;  
    ELSE  
        -- Procedure must start its own  
        -- transaction.  
        BEGIN TRANSACTION;  
    -- Modify database.  
    BEGIN TRY  
        DELETE HumanResources.JobCandidate  
            WHERE JobCandidateID = @InputCandidateID;  
        -- Get here if no errors; must commit  
        -- any transaction started in the  
        -- procedure, but not commit a transaction  
        -- started before the transaction was called.  
        IF @TranCounter = 0  
            -- @TranCounter = 0 means no transaction was  
            -- started before the procedure was called.  
            -- The procedure must commit the transaction  
            -- it started.  
            COMMIT TRANSACTION;  
    END TRY  
    BEGIN CATCH  
        -- An error occurred; must determine  
        -- which type of rollback will roll  
        -- back only the work done in the  
        -- procedure.  
        IF @TranCounter = 0  
            -- Transaction started in procedure.  
            -- Roll back complete transaction.  
            ROLLBACK TRANSACTION;  
        ELSE  
            -- Transaction started before procedure  
            -- called, do not roll back modifications  
            -- made before the procedure was called.  
            IF XACT_STATE() <> -1
                -- If the transaction is still valid, just  
                -- roll back to the savepoint set at the  
                -- start of the stored procedure.  
                ROLLBACK TRANSACTION ProcedureSave;  
                -- If the transaction is uncommitable, a  
                -- rollback to the savepoint is not allowed  
                -- because the savepoint rollback writes to  
                -- the log. Just return to the caller, which  
                -- should roll back the outer transaction.  
  
        -- After the appropriate rollback, echo error  
        -- information to the caller.  
        DECLARE @ErrorMessage NVARCHAR(4000);  
        DECLARE @ErrorSeverity INT;  
        DECLARE @ErrorState INT;  
  
        SELECT @ErrorMessage = ERROR_MESSAGE();  
        SELECT @ErrorSeverity = ERROR_SEVERITY();  
        SELECT @ErrorState = ERROR_STATE();  
  
        RAISERROR (@ErrorMessage, -- Message text.  
                   @ErrorSeverity, -- Severity.  
                   @ErrorState -- State.  
                   );  
    END CATCH  
GO  


---@@TRANCOUNT  => Devuelve el n�mero de instrucciones BEGIN TRANSACTION que se han producido en la conexi�n actual.

PRINT @@TRANCOUNT  
--  The BEGIN TRAN statement will increment the  
--  transaction count by 1.  
BEGIN TRAN  
    PRINT @@TRANCOUNT  
    BEGIN TRAN  
        PRINT @@TRANCOUNT  
--  The COMMIT statement will decrement the transaction count by 1.  
    COMMIT  
    PRINT @@TRANCOUNT  
COMMIT  
PRINT @@TRANCOUNT  
