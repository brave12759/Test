IF OBJECT_ID('dbo.usp_AddLog') IS NOT NULL 
    DROP PROCEDURE [dbo].[usp_AddLog]
GO

CREATE PROCEDURE usp_AddLog
(
    @_InBox_ReadID TINYINT,                   -- 執行 Log 的版本
    @_InBox_SPNAME NVARCHAR(120),            -- 執行的儲存程序名稱
    @_InBox_GroupID UNIQUEIDENTIFIER,        -- 執行群組代碼
    @_InBox_ExProgram NVARCHAR(40),          -- 執行的動作名稱
    @_InBox_ActionJSON NVARCHAR(MAX),        -- 執行內容 (JSON 格式)
    @_OutBox_ReturnValues NVARCHAR(MAX) OUTPUT -- 回傳執行的結果
)
AS

-- ========================= 新增與維護注意事項(必須遵守規定) =====================
-- 指定檔案　：usp_AddLog.sql
-- 專案項目　：Test
-- 專案用途　：記錄儲存程序執行動作，寫入日誌到 MyOffice_ExecutionLog 資料表
-- 專案資料庫：TestDB
-- 專案資料表：MyOffice_ExecutionLog
-- 專案人員　：Aaron
-- 專案日期　：2025/01/21
-- ==========================================================================
-- 注意事項：
-- 1. 此預存程序主要用於記錄儲存程序的執行資訊，包括儲存程序名稱、執行群組代碼、
--    執行的動作名稱以及 JSON 格式的執行內容。
-- 2. 插入的日誌資料包括執行的儲存程序名稱 (`DeLog_StoredPrograms`)、執行群組代碼
--    (`DeLog_GroupID`)、執行的動作名稱 (`DeLog_ExecutionProgram`) 和執行內容 (`DeLog_ExecutionInfo`)。
-- 3. 修改時請確認相關引用是否受影響，尤其是應用程式層級中調用的程序。
-- 4. 請勿刪除或更改與資料表結構對應的欄位名稱，以免影響資料一致性。
-- 5. 當新增或修改日誌結構時，需同步更新應用程式相關功能，並進行測試以確保不影響既有功能的執行。
-- ==========================================================================

BEGIN
    SET NOCOUNT ON;

    -- 插入執行內容到日誌表
    PRINT 'Inserting Log into MyOffice_ExecutionLog';
    INSERT INTO MyOffice_ExecutionLog (
        DeLog_StoredPrograms,
        DeLog_GroupID,
        DeLog_ExecutionProgram,
        DeLog_ExecutionInfo
    )
    VALUES (
        @_InBox_SPNAME,
        @_InBox_GroupID,
        @_InBox_ExProgram,
        @_InBox_ActionJSON
    );

    -- 返回執行的記錄內容
    PRINT 'Returning Execution Log JSON';
    SET @_OutBox_ReturnValues = (
        SELECT TOP 100
            DeLog_AutoID AS 'AutoID',
            DeLog_ExecutionProgram AS 'NAME',
            DeLog_ExecutionInfo AS 'Action',
            DeLog_ExDateTime AS 'DateTime'
        FROM MyOffice_ExecutionLog WITH (NOLOCK)
        WHERE DeLog_GroupID = @_InBox_GroupID
        ORDER BY DeLog_AutoID
        FOR JSON PATH, ROOT('ProgramLog'), INCLUDE_NULL_VALUES
    );
END;
GO
