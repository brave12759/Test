IF OBJECT_ID('dbo.usp_DeleteMyOfficeData') IS NOT NULL 
    DROP PROCEDURE [dbo].[usp_DeleteMyOfficeData]
GO

CREATE PROCEDURE usp_DeleteMyOfficeData
(
    @JsonInput NVARCHAR(MAX) -- 包含刪除條件的 JSON 格式
)
AS

-- ========================= 新增與維護注意事項(必須遵守規定) =====================
-- 指定檔案　：usp_DeleteMyOfficeData.sql
-- 專案項目　：Test
-- 專案用途　：根據 JSON 格式的輸入條件，從 MyOffice_ACPD 資料表中刪除資料
-- 專案資料庫：TestDB
-- 專案資料表：MyOffice_ACPD
-- 專案人員　：Aaron
-- 專案日期　：2025/01/21
-- ==========================================================================
-- 注意事項：
-- 1. 此預存程序需接受 JSON 格式的輸入，解析後根據條件刪除指定資料。
-- 2. 刪除操作需檢查條件是否正確（例如，主鍵是否存在），避免誤刪資料。
-- 3. 當 MyOffice_ACPD 資料表結構變更時，需同步更新此程序以匹配新結構。
-- 4. 日誌記錄功能已內建，調用 `usp_AddLog` 將刪除操作記錄到 MyOffice_ExecutionLog 中。
-- ==========================================================================


BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- 定義變數以存儲解析後的 JSON 值
        DECLARE @ACPD_SID CHAR(20);

        -- 從 JSON 中提取值並賦予變數
        SELECT 
            @ACPD_SID = JSON_VALUE(@JsonInput, '$.ACPD_SID');

        -- 除錯訊息
        PRINT 'Parsed JSON Values:';
        PRINT 'ACPD_SID: ' + ISNULL(@ACPD_SID, 'NULL');

        -- 檢查刪除條件
        IF @ACPD_SID IS NULL
        BEGIN
            RAISERROR('刪除條件缺失：ACPD_SID。', 16, 1);
            RETURN;
        END

        -- 執行刪除
        DELETE FROM MyOffice_ACPD
        WHERE ACPD_SID = @ACPD_SID;

        -- 記錄日誌
        DECLARE @GroupID UNIQUEIDENTIFIER = NEWID();
        DECLARE @ReturnValues NVARCHAR(MAX);
        EXEC usp_AddLog 0, 'usp_DeleteMyOfficeData', @GroupID, 'Delete', @JsonInput, @ReturnValues OUTPUT;

        PRINT 'Delete completed for ACPD_SID: ' + @ACPD_SID;
    END TRY
    BEGIN CATCH
        PRINT 'Error occurred: ' + ERROR_MESSAGE();
        THROW;
    END CATCH;
END;
GO
