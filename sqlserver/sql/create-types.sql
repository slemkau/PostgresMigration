SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
USE [Insights];


GO
PRINT N'Creating User-Defined Table Type [dbo].[AttachmentArray]...';


GO
CREATE TYPE [dbo].[AttachmentArray] AS TABLE (
    [FileType] NVARCHAR (100) NULL,
    [FileName] NVARCHAR (256) NULL,
    [FileSize] INT            NULL);


GO
PRINT N'Creating User-Defined Table Type [dbo].[ParameterArray]...';


GO
CREATE TYPE [dbo].[ParameterArray] AS TABLE (
    [ParmName]  NVARCHAR (50)   NULL,
    [ParmValue] NVARCHAR (1024) NULL);


GO
PRINT N'Creating User-Defined Table Type [dbo].[PostAddressArray]...';


GO
CREATE TYPE [dbo].[PostAddressArray] AS TABLE (
    [DisplayName] NVARCHAR (100) NULL,
    [Address]     NVARCHAR (256) NULL,
    [CC]          BIT            NULL);


GO
PRINT N'Creating User-Defined Table Type [dbo].[SendGridDetailArray]...';


GO
CREATE TYPE [dbo].[SendGridDetailArray] AS TABLE (
    [event_name]      NVARCHAR (50)  NULL,
    [processed]       DATETIME       NULL,
    [reason]          NVARCHAR (MAX) NULL,
    [attempt_num]     INT            NULL,
    [mx_server]       NVARCHAR (100) NULL,
    [http_user_agent] NVARCHAR (MAX) NULL);


GO
PRINT N'Creating User-Defined Table Type [dbo].[SendGridEventArray]...';


GO
CREATE TYPE [dbo].[SendGridEventArray] AS TABLE (
    [template_id]    NVARCHAR (100) NULL,
    [api_key_id]     NVARCHAR (500) NULL,
    [originating_ip] NVARCHAR (25)  NULL,
    [categories]     NVARCHAR (256) NULL);


GO
PRINT N'Update complete.';


GO

