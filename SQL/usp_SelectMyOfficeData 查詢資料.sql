IF OBJECT_ID('dbo.usp_SelectMyOfficeData') IS NOT NULL 
    DROP PROCEDURE [dbo].[usp_SelectMyOfficeData]
GO

CREATE PROCEDURE usp_SelectMyOfficeData
(
    @JsonInput NVARCHAR(MAX) -- 包含查詢條件的 JSON 格式
)
AS

-- ========================= 新增與維護注意事項(必須遵守規定) =====================
-- 指定檔案　：usp_SelectMyOfficeData.sql
-- 專案項目　：Test
-- 專案用途　：根據 JSON 格式的查詢條件，從 MyOffice_ACPD 資料表中檢索資料
-- 專案資料庫：TestDB
-- 專案資料表：MyOffice_ACPD
-- 專案人員　：Aaron
-- 專案日期　：2025/01/21
-- ==========================================================================
-- 注意事項：
-- 1. 此預存程序需接受 JSON 格式的輸入，解析後根據條件檢索 MyOffice_ACPD 資料。
-- 2. 當 JSON 中未提供查詢條件時，應返回全部資料，但需謹慎處理大量資料的性能問題。
-- 3. 修改查詢條件時，需確認是否對應資料表欄位並進行測試。
-- 4. 日誌記錄功能已內建，調用 `usp_AddLog` 將查詢操作記錄到 MyOffice_ExecutionLog 中。
-- ==========================================================================

BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- 定義變數以存儲解析後的 JSON 值
        DECLARE @ACPD_SID CHAR(20);
        DECLARE @ACPD_Cname NVARCHAR(60);

        -- 從 JSON 中提取值並賦予變數
        SELECT 
            @ACPD_SID = JSON_VALUE(@JsonInput, '$.ACPD_SID'),
            @ACPD_Cname = JSON_VALUE(@JsonInput, '$.ACPD_Cname');

        -- 除錯訊息
        PRINT 'Parsed JSON Values:';
        PRINT 'ACPD_SID: ' + ISNULL(@ACPD_SID, 'NULL');
        PRINT 'ACPD_Cname: ' + ISNULL(@ACPD_Cname, 'NULL');

        -- 查詢資料
        SELECT *
        FROM MyOffice_ACPD
        WHERE (@ACPD_SID IS NULL OR ACPD_SID = @ACPD_SID)
          AND (@ACPD_Cname IS NULL OR ACPD_Cname = @ACPD_Cname);

        -- 記錄日誌
        DECLARE @GroupID UNIQUEIDENTIFIER = NEWID();
        DECLARE @ReturnValues NVARCHAR(MAX);
        EXEC usp_AddLog 0, 'usp_SelectMyOfficeData', @GroupID, 'Select', @JsonInput, @ReturnValues OUTPUT;
    END TRY
    BEGIN CATCH
        PRINT 'Error occurred: ' + ERROR_MESSAGE();
        THROW;
    END CATCH;
END;
GO
