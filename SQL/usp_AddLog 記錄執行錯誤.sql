IF OBJECT_ID('dbo.usp_AddLog') IS NOT NULL 
    DROP PROCEDURE [dbo].[usp_AddLog]
GO

CREATE PROCEDURE usp_AddLog
(
    @_InBox_ReadID TINYINT,                   -- ���� Log ������
    @_InBox_SPNAME NVARCHAR(120),            -- ���檺�x�s�{�ǦW��
    @_InBox_GroupID UNIQUEIDENTIFIER,        -- ����s�եN�X
    @_InBox_ExProgram NVARCHAR(40),          -- ���檺�ʧ@�W��
    @_InBox_ActionJSON NVARCHAR(MAX),        -- ���椺�e (JSON �榡)
    @_OutBox_ReturnValues NVARCHAR(MAX) OUTPUT -- �^�ǰ��檺���G
)
AS

-- ========================= �s�W�P���@�`�N�ƶ�(������u�W�w) =====================
-- ���w�ɮס@�Gusp_AddLog.sql
-- �M�׶��ء@�GTest
-- �M�ץγ~�@�G�O���x�s�{�ǰ���ʧ@�A�g�J��x�� MyOffice_ExecutionLog ��ƪ�
-- �M�׸�Ʈw�GTestDB
-- �M�׸�ƪ�GMyOffice_ExecutionLog
-- �M�פH���@�GAaron
-- �M�פ���@�G2025/01/21
-- ==========================================================================
-- �`�N�ƶ��G
-- 1. ���w�s�{�ǥD�n�Ω�O���x�s�{�Ǫ������T�A�]�A�x�s�{�ǦW�١B����s�եN�X�B
--    ���檺�ʧ@�W�٥H�� JSON �榡�����椺�e�C
-- 2. ���J����x��ƥ]�A���檺�x�s�{�ǦW�� (`DeLog_StoredPrograms`)�B����s�եN�X
--    (`DeLog_GroupID`)�B���檺�ʧ@�W�� (`DeLog_ExecutionProgram`) �M���椺�e (`DeLog_ExecutionInfo`)�C
-- 3. �ק�ɽнT�{�����ޥάO�_���v�T�A�ר�O���ε{���h�Ť��եΪ��{�ǡC
-- 4. �ФŧR���Χ��P��ƪ��c���������W�١A�H�K�v�T��Ƥ@�P�ʡC
-- 5. ��s�W�έק��x���c�ɡA�ݦP�B��s���ε{�������\��A�öi����եH�T�O���v�T�J���\�઺����C
-- ==========================================================================

BEGIN
    SET NOCOUNT ON;

    -- ���J���椺�e���x��
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

    -- ��^���檺�O�����e
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
