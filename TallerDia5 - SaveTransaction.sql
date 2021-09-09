USE AdventureWorks2014;  
GO  
IF EXISTS (SELECT name FROM sys.objects  
           WHERE name = N'SaveTranExample')  
    DROP PROCEDURE SaveTranExample;  
GO  
CREATE PROCEDURE SaveTranExample  
    @InputCandidateID INT  
AS  
     ----

    DECLARE @TranCounter INT;  
    SET @TranCounter = @@TRANCOUNT;  
    IF @TranCounter > 0  
       
	   ----

        SAVE TRANSACTION ProcedureSave;
		
    ELSE  
        -- Procedure must start its own  
        -- transaction.  

        BEGIN TRANSACTION;  
    -- Modify database.  
    BEGIN TRY  


        DELETE HumanResources.JobCandidate  
            WHERE JobCandidateID = @InputCandidateID;  
        
		----

        IF @TranCounter = 0  
            
			---

            COMMIT TRANSACTION;  
    END TRY  
    BEGIN CATCH  
       
	   ---
       
	   IF @TranCounter = 0  
            -- Transaction started in procedure.  
            -- Roll back complete transaction.  
            ROLLBACK TRANSACTION;  
        ELSE  
            -- Transaction started before procedure  
            -- called, do not roll back modifications  
            -- made before the procedure was called.  
            IF XACT_STATE() <> -1  
                ---
                ROLLBACK TRANSACTION ProcedureSave;  
                
				---
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


sp_who2
