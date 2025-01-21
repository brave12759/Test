IF OBJECT_ID('dbo.usp_UpdateMyOfficeData') IS NOT NULL 
    DROP PROCEDURE [dbo].[usp_UpdateMyOfficeData]
GO

CREATE PROCEDURE usp_UpdateMyOfficeData
(
    @JsonInput NVARCHAR(MAX) -- 包含更新條件和更新內容的 JSON 格式
)
AS

-- ========================= 新增與維護注意事項(必須遵守規定) =====================
-- 指定檔案　：usp_UpdateMyOfficeData.sql
-- 專案項目　：Test
-- 專案用途　：根據 JSON 格式的輸入條件和更新內容，更新 MyOffice_ACPD 資料表中的資料
-- 專案資料庫：TestDB
-- 專案資料表：MyOffice_ACPD
-- 專案人員　：Aaron
-- 專案日期　：2025/01/21
-- ==========================================================================
-- 注意事項：
-- 1. 此預存程序需接受 JSON 格式的輸入，解析後根據條件更新指定資料。
-- 2. 更新操作需檢查條件是否正確（例如，主鍵是否存在），避免更新錯誤的資料。
-- 3. 當 MyOffice_ACPD 資料表結構變更時，需同步更新此程序以匹配新結構。
-- 4. 日誌記錄功能已內建，調用 `usp_AddLog` 將更新操作記錄到 MyOffice_ExecutionLog 中。
-- ==========================================================================

BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- 定義變數以存儲解析後的 JSON 值
        DECLARE @ACPD_SID CHAR(20);
        DECLARE @ACPD_Cname NVARCHAR(60);
        DECLARE @ACPD_Email NVARCHAR(60);

        -- 從 JSON 中提取值並賦予變數
        SELECT 
            @ACPD_SID = JSON_VALUE(@JsonInput, '$.ACPD_SID'),
            @ACPD_Cname = JSON_VALUE(@JsonInput, '$.ACPD_Cname'),
            @ACPD_Email = JSON_VALUE(@JsonInput, '$.ACPD_Email');

        -- 除錯訊息
        PRINT 'Parsed JSON Values:';
        PRINT 'ACPD_SID: ' + ISNULL(@ACPD_SID, 'NULL');
        PRINT 'ACPD_Cname: ' + ISNULL(@ACPD_Cname, 'NULL');
        PRINT 'ACPD_Email: ' + ISNULL(@ACPD_Email, 'NULL');

        -- 檢查更新條件
        IF @ACPD_SID IS NULL
        BEGIN
            RAISERROR('更新條件缺失：ACPD_SID。', 16, 1);
            RETURN;
        END

        -- 執行更新
        UPDATE MyOffice_ACPD
        SET ACPD_Cname = ISNULL(@ACPD_Cname, ACPD_Cname),
            ACPD_Email = ISNULL(@ACPD_Email, ACPD_Email)
        WHERE ACPD_SID = @ACPD_SID;

        -- 記錄日誌
        DECLARE @GroupID UNIQUEIDENTIFIER = NEWID();
        DECLARE @ReturnValues NVARCHAR(MAX);
        EXEC usp_AddLog 0, 'usp_UpdateMyOfficeData', @GroupID, 'Update', @JsonInput, @ReturnValues OUTPUT;

        PRINT 'Update completed for ACPD_SID: ' + @ACPD_SID;
    END TRY
    BEGIN CATCH
        PRINT 'Error occurred: ' + ERROR_MESSAGE();
        THROW;
    END CATCH;
END;
GO
