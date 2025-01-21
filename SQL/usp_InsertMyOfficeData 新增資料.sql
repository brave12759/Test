IF OBJECT_ID('dbo.usp_InsertMyOfficeData') IS NOT NULL 
    DROP PROCEDURE [dbo].[usp_InsertMyOfficeData]
GO

CREATE PROCEDURE usp_InsertMyOfficeData
(
    @JsonInput NVARCHAR(MAX) -- 包含 Name 和 Description 的 JSON 資料
)
AS

-- ========================= 新增與維護注意事項(必須遵守規定) =====================
-- 指定檔案　：usp_InsertMyOfficeData.sql
-- 專案項目　：Test
-- 專案用途　：將 JSON 格式的資料插入到 MyOffice_ACPD 資料表中
-- 專案資料庫：TestDB
-- 專案資料表：MyOffice_ACPD
-- 專案人員　：Aaron
-- 專案日期　：2025/01/21
-- ==========================================================================
-- 注意事項：
-- 1. 此預存程序需接受 JSON 格式的輸入，解析後將資料插入至 MyOffice_ACPD 資料表中。
-- 2. 需確認 JSON 的欄位名稱與資料表結構一致，避免因解析失敗導致資料插入錯誤。
-- 3. 當新增或修改 MyOffice_ACPD 資料表結構時，需同步更新此預存程序以匹配新結構。
-- 4. 修改此檔案前請確認應用程式中是否有直接依賴此預存程序，並進行測試以確保功能無誤。
-- 5. 日誌記錄功能已內建，調用 `usp_AddLog` 將執行相關操作記錄到 MyOffice_ExecutionLog 中。
-- ==========================================================================

BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- 定義變數以存儲解析後的 JSON 值
        DECLARE @ACPD_SID CHAR(20);
        DECLARE @ACPD_Cname NVARCHAR(60);
        DECLARE @ACPD_Ename NVARCHAR(40);
        DECLARE @ACPD_Sname NVARCHAR(40);
        DECLARE @ACPD_Email NVARCHAR(60);
        DECLARE @ACPD_Status TINYINT;
        DECLARE @ACPD_Stop BIT;
        DECLARE @ACPD_StopMemo NVARCHAR(60);
        DECLARE @ACPD_LoginID NVARCHAR(30);
        DECLARE @ACPD_LoginPWD NVARCHAR(60);
        DECLARE @ACPD_Memo NVARCHAR(600);
        DECLARE @ACPD_NowDateTime DATETIME;
        DECLARE @ACPD_NowID NVARCHAR(20);
        DECLARE @ACPD_UPDDateTime DATETIME;
        DECLARE @ACPD_UPDID NVARCHAR(20);

        -- 從 JSON 中提取值並賦予變數
        SELECT 
            @ACPD_SID = JSON_VALUE(@JsonInput, '$.ACPD_SID'),
            @ACPD_Cname = JSON_VALUE(@JsonInput, '$.ACPD_Cname'),
            @ACPD_Ename = JSON_VALUE(@JsonInput, '$.ACPD_Ename'),
            @ACPD_Sname = JSON_VALUE(@JsonInput, '$.ACPD_Sname'),
            @ACPD_Email = JSON_VALUE(@JsonInput, '$.ACPD_Email'),
            @ACPD_Status = JSON_VALUE(@JsonInput, '$.ACPD_Status'),
            @ACPD_Stop = JSON_VALUE(@JsonInput, '$.ACPD_Stop'),
            @ACPD_StopMemo = JSON_VALUE(@JsonInput, '$.ACPD_StopMemo'),
            @ACPD_LoginID = JSON_VALUE(@JsonInput, '$.ACPD_LoginID'),
            @ACPD_LoginPWD = JSON_VALUE(@JsonInput, '$.ACPD_LoginPWD'),
            @ACPD_Memo = JSON_VALUE(@JsonInput, '$.ACPD_Memo'),
            @ACPD_NowDateTime = JSON_VALUE(@JsonInput, '$.ACPD_NowDateTime'),
            @ACPD_NowID = JSON_VALUE(@JsonInput, '$.ACPD_NowID'),
            @ACPD_UPDDateTime = JSON_VALUE(@JsonInput, '$.ACPD_UPDDateTime'),
            @ACPD_UPDID = JSON_VALUE(@JsonInput, '$.ACPD_UPDID');

        -- 除錯訊息
        PRINT 'Parsed JSON Values:';
        PRINT 'ACPD_SID: ' + ISNULL(@ACPD_SID, 'NULL');
        PRINT 'ACPD_Cname: ' + ISNULL(@ACPD_Cname, 'NULL');

        -- 檢查必要欄位是否存在
        IF @ACPD_SID IS NULL OR @ACPD_Cname IS NULL
        BEGIN
            RAISERROR('必要欄位缺失：ACPD_SID 或 ACPD_Cname。', 16, 1);
            RETURN;
        END

        -- 插入資料
        INSERT INTO MyOffice_ACPD (
            ACPD_SID, ACPD_Cname, ACPD_Ename, ACPD_Sname, ACPD_Email, ACPD_Status, ACPD_Stop,
            ACPD_StopMemo, ACPD_LoginID, ACPD_LoginPWD, ACPD_Memo, ACPD_NowDateTime,
            ACPD_NowID, ACPD_UPDDateTime, ACPD_UPDID
        )
        VALUES (
            @ACPD_SID, @ACPD_Cname, @ACPD_Ename, @ACPD_Sname, @ACPD_Email, @ACPD_Status, @ACPD_Stop,
            @ACPD_StopMemo, @ACPD_LoginID, @ACPD_LoginPWD, @ACPD_Memo, @ACPD_NowDateTime,
            @ACPD_NowID, @ACPD_UPDDateTime, @ACPD_UPDID
        );

        -- 記錄日誌
        DECLARE @GroupID UNIQUEIDENTIFIER = NEWID();
        DECLARE @ReturnValues NVARCHAR(MAX);
        EXEC usp_AddLog 0, 'usp_InsertMyOfficeData', @GroupID, 'Insert', @JsonInput, @ReturnValues OUTPUT;

        -- 返回插入的主鍵
        PRINT 'Returning Inserted Primary Key';
        SELECT @ACPD_SID AS InsertedSID;
    END TRY
    BEGIN CATCH
        PRINT 'Error occurred: ' + ERROR_MESSAGE();
        THROW;
    END CATCH;
END;
GO
