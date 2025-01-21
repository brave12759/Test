IF OBJECT_ID('dbo.usp_InsertMyOfficeData') IS NOT NULL 
    DROP PROCEDURE [dbo].[usp_InsertMyOfficeData]
GO

CREATE PROCEDURE usp_InsertMyOfficeData
(
    @JsonInput NVARCHAR(MAX) -- �]�t Name �M Description �� JSON ���
)
AS

-- ========================= �s�W�P���@�`�N�ƶ�(������u�W�w) =====================
-- ���w�ɮס@�Gusp_InsertMyOfficeData.sql
-- �M�׶��ء@�GTest
-- �M�ץγ~�@�G�N JSON �榡����ƴ��J�� MyOffice_ACPD ��ƪ�
-- �M�׸�Ʈw�GTestDB
-- �M�׸�ƪ�GMyOffice_ACPD
-- �M�פH���@�GAaron
-- �M�פ���@�G2025/01/21
-- ==========================================================================
-- �`�N�ƶ��G
-- 1. ���w�s�{�ǻݱ��� JSON �榡����J�A�ѪR��N��ƴ��J�� MyOffice_ACPD ��ƪ��C
-- 2. �ݽT�{ JSON �����W�ٻP��ƪ��c�@�P�A�קK�]�ѪR���ѾɭP��ƴ��J���~�C
-- 3. ��s�W�έק� MyOffice_ACPD ��ƪ��c�ɡA�ݦP�B��s���w�s�{�ǥH�ǰt�s���c�C
-- 4. �ק惡�ɮ׫e�нT�{���ε{�����O�_�������̿হ�w�s�{�ǡA�öi����եH�T�O�\��L�~�C
-- 5. ��x�O���\��w���ءA�ե� `usp_AddLog` �N��������ާ@�O���� MyOffice_ExecutionLog ���C
-- ==========================================================================

BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- �w�q�ܼƥH�s�x�ѪR�᪺ JSON ��
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

        -- �q JSON �������Ȩýᤩ�ܼ�
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

        -- �����T��
        PRINT 'Parsed JSON Values:';
        PRINT 'ACPD_SID: ' + ISNULL(@ACPD_SID, 'NULL');
        PRINT 'ACPD_Cname: ' + ISNULL(@ACPD_Cname, 'NULL');

        -- �ˬd���n���O�_�s�b
        IF @ACPD_SID IS NULL OR @ACPD_Cname IS NULL
        BEGIN
            RAISERROR('���n���ʥ��GACPD_SID �� ACPD_Cname�C', 16, 1);
            RETURN;
        END

        -- ���J���
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

        -- �O����x
        DECLARE @GroupID UNIQUEIDENTIFIER = NEWID();
        DECLARE @ReturnValues NVARCHAR(MAX);
        EXEC usp_AddLog 0, 'usp_InsertMyOfficeData', @GroupID, 'Insert', @JsonInput, @ReturnValues OUTPUT;

        -- ��^���J���D��
        PRINT 'Returning Inserted Primary Key';
        SELECT @ACPD_SID AS InsertedSID;
    END TRY
    BEGIN CATCH
        PRINT 'Error occurred: ' + ERROR_MESSAGE();
        THROW;
    END CATCH;
END;
GO
