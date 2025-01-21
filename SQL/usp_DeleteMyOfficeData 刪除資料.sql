IF OBJECT_ID('dbo.usp_DeleteMyOfficeData') IS NOT NULL 
    DROP PROCEDURE [dbo].[usp_DeleteMyOfficeData]
GO

CREATE PROCEDURE usp_DeleteMyOfficeData
(
    @JsonInput NVARCHAR(MAX) -- �]�t�R������ JSON �榡
)
AS

-- ========================= �s�W�P���@�`�N�ƶ�(������u�W�w) =====================
-- ���w�ɮס@�Gusp_DeleteMyOfficeData.sql
-- �M�׶��ء@�GTest
-- �M�ץγ~�@�G�ھ� JSON �榡����J����A�q MyOffice_ACPD ��ƪ��R�����
-- �M�׸�Ʈw�GTestDB
-- �M�׸�ƪ�GMyOffice_ACPD
-- �M�פH���@�GAaron
-- �M�פ���@�G2025/01/21
-- ==========================================================================
-- �`�N�ƶ��G
-- 1. ���w�s�{�ǻݱ��� JSON �榡����J�A�ѪR��ھڱ���R�����w��ơC
-- 2. �R���ާ@���ˬd����O�_���T�]�Ҧp�A�D��O�_�s�b�^�A�קK�~�R��ơC
-- 3. �� MyOffice_ACPD ��ƪ��c�ܧ�ɡA�ݦP�B��s���{�ǥH�ǰt�s���c�C
-- 4. ��x�O���\��w���ءA�ե� `usp_AddLog` �N�R���ާ@�O���� MyOffice_ExecutionLog ���C
-- ==========================================================================


BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- �w�q�ܼƥH�s�x�ѪR�᪺ JSON ��
        DECLARE @ACPD_SID CHAR(20);

        -- �q JSON �������Ȩýᤩ�ܼ�
        SELECT 
            @ACPD_SID = JSON_VALUE(@JsonInput, '$.ACPD_SID');

        -- �����T��
        PRINT 'Parsed JSON Values:';
        PRINT 'ACPD_SID: ' + ISNULL(@ACPD_SID, 'NULL');

        -- �ˬd�R������
        IF @ACPD_SID IS NULL
        BEGIN
            RAISERROR('�R������ʥ��GACPD_SID�C', 16, 1);
            RETURN;
        END

        -- ����R��
        DELETE FROM MyOffice_ACPD
        WHERE ACPD_SID = @ACPD_SID;

        -- �O����x
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
