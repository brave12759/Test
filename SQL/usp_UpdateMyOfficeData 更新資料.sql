IF OBJECT_ID('dbo.usp_UpdateMyOfficeData') IS NOT NULL 
    DROP PROCEDURE [dbo].[usp_UpdateMyOfficeData]
GO

CREATE PROCEDURE usp_UpdateMyOfficeData
(
    @JsonInput NVARCHAR(MAX) -- �]�t��s����M��s���e�� JSON �榡
)
AS

-- ========================= �s�W�P���@�`�N�ƶ�(������u�W�w) =====================
-- ���w�ɮס@�Gusp_UpdateMyOfficeData.sql
-- �M�׶��ء@�GTest
-- �M�ץγ~�@�G�ھ� JSON �榡����J����M��s���e�A��s MyOffice_ACPD ��ƪ������
-- �M�׸�Ʈw�GTestDB
-- �M�׸�ƪ�GMyOffice_ACPD
-- �M�פH���@�GAaron
-- �M�פ���@�G2025/01/21
-- ==========================================================================
-- �`�N�ƶ��G
-- 1. ���w�s�{�ǻݱ��� JSON �榡����J�A�ѪR��ھڱ����s���w��ơC
-- 2. ��s�ާ@���ˬd����O�_���T�]�Ҧp�A�D��O�_�s�b�^�A�קK��s���~����ơC
-- 3. �� MyOffice_ACPD ��ƪ��c�ܧ�ɡA�ݦP�B��s���{�ǥH�ǰt�s���c�C
-- 4. ��x�O���\��w���ءA�ե� `usp_AddLog` �N��s�ާ@�O���� MyOffice_ExecutionLog ���C
-- ==========================================================================

BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- �w�q�ܼƥH�s�x�ѪR�᪺ JSON ��
        DECLARE @ACPD_SID CHAR(20);
        DECLARE @ACPD_Cname NVARCHAR(60);
        DECLARE @ACPD_Email NVARCHAR(60);

        -- �q JSON �������Ȩýᤩ�ܼ�
        SELECT 
            @ACPD_SID = JSON_VALUE(@JsonInput, '$.ACPD_SID'),
            @ACPD_Cname = JSON_VALUE(@JsonInput, '$.ACPD_Cname'),
            @ACPD_Email = JSON_VALUE(@JsonInput, '$.ACPD_Email');

        -- �����T��
        PRINT 'Parsed JSON Values:';
        PRINT 'ACPD_SID: ' + ISNULL(@ACPD_SID, 'NULL');
        PRINT 'ACPD_Cname: ' + ISNULL(@ACPD_Cname, 'NULL');
        PRINT 'ACPD_Email: ' + ISNULL(@ACPD_Email, 'NULL');

        -- �ˬd��s����
        IF @ACPD_SID IS NULL
        BEGIN
            RAISERROR('��s����ʥ��GACPD_SID�C', 16, 1);
            RETURN;
        END

        -- �����s
        UPDATE MyOffice_ACPD
        SET ACPD_Cname = ISNULL(@ACPD_Cname, ACPD_Cname),
            ACPD_Email = ISNULL(@ACPD_Email, ACPD_Email)
        WHERE ACPD_SID = @ACPD_SID;

        -- �O����x
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
