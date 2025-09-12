SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
USE [Insights];


GO
PRINT N'Creating Table [dbo].[APIServiceCatalog]...';


GO
CREATE TABLE [dbo].[APIServiceCatalog] (
    [ServiceCatalogKey]  INT            IDENTITY (1, 1) NOT NULL,
    [ServiceCatalogName] VARCHAR (150)  NOT NULL,
    [ServiceDescription] VARCHAR (1000) NULL,
    [APIProductCategory] VARCHAR (250)  NULL,
    [CreateDateTime]     SMALLDATETIME  NULL,
    [ModifyDateTime]     SMALLDATETIME  NULL,
    CONSTRAINT [ServiceCatalogKey] PRIMARY KEY CLUSTERED ([ServiceCatalogKey] ASC),
    CONSTRAINT [ServiceCatalogName] UNIQUE NONCLUSTERED ([ServiceCatalogName] ASC, [APIProductCategory] ASC)
);


GO
PRINT N'Creating Table [dbo].[ApplicationLog]...';


GO
CREATE TABLE [dbo].[ApplicationLog] (
    [LogItemKey]                INT             IDENTITY (1, 1) NOT NULL,
    [LogItemID]                 NVARCHAR (50)   NOT NULL,
    [Severity]                  NVARCHAR (50)   NOT NULL,
    [LogEventTimestamp]         DATETIME        NOT NULL,
    [LogEventName]              NVARCHAR (500)  NOT NULL,
    [LogEventDescription]       NVARCHAR (4000) NULL,
    [ApplicationName]           NVARCHAR (500)  NOT NULL,
    [ApplicationServiceAccount] NVARCHAR (100)  NULL,
    [ApplicationUser]           NVARCHAR (100)  NULL,
    [ApplicationMachineName]    NVARCHAR (100)  NULL,
    [ApplicationException]      NVARCHAR (4000) NULL,
    [ApplicationStack]          NVARCHAR (4000) NULL,
    [ApplicationThread]         NVARCHAR (255)  NULL,
    [IntegrationSource]         NVARCHAR (250)  NULL,
    [IntegrationTarget]         NVARCHAR (250)  NULL,
    [IntegrationMessage]        NTEXT           NULL,
    [RelatedPolicyNumber]       NVARCHAR (25)   NULL,
    [RelatedAccountNumber]      NVARCHAR (25)   NULL,
    [RelatedClaimNumber]        NVARCHAR (25)   NULL,
    [BusinessEntityName]        NVARCHAR (60)   NULL,
    [BusinessEntityId]          NVARCHAR (25)   NULL,
    [BusinessEntityData]        NTEXT           NULL,
    [RecordedTimestamp]         DATETIME        NOT NULL,
    [ServiceContractKey]        INT             NULL,
    CONSTRAINT [PK_ApplicationLog] PRIMARY KEY CLUSTERED ([LogItemKey] ASC)
);


GO
PRINT N'Creating Index [dbo].[ApplicationLog].[IX_ApplicationLog]...';


GO
CREATE NONCLUSTERED INDEX [IX_ApplicationLog]
    ON [dbo].[ApplicationLog]([RecordedTimestamp] DESC);


GO
PRINT N'Creating Table [dbo].[SendGridMessages]...';


GO
CREATE TABLE [dbo].[SendGridMessages] (
    [msgKey]              INT            IDENTITY (1, 1) NOT NULL,
    [from_email]          NVARCHAR (256) NULL,
    [msg_id]              NVARCHAR (100) NOT NULL,
    [subject]             NVARCHAR (100) NULL,
    [to_email]            NVARCHAR (256) NULL,
    [status]              NVARCHAR (50)  NOT NULL,
    [opens_count]         INT            NOT NULL,
    [clicks_count]        INT            NOT NULL,
    [last_event_time]     NVARCHAR (50)  NOT NULL,
    [first_recorded_time] DATETIME       NOT NULL,
    [last_accessed_time]  DATETIME       NOT NULL,
    [past_30_days]        BIT            NOT NULL,
    CONSTRAINT [PK_SendGridMessages] PRIMARY KEY CLUSTERED ([msgKey] ASC)
);


GO
PRINT N'Creating Index [dbo].[SendGridMessages].[IX_SendGridMessages]...';


GO
CREATE NONCLUSTERED INDEX [IX_SendGridMessages]
    ON [dbo].[SendGridMessages]([msg_id] ASC);


GO
PRINT N'Creating Index [dbo].[SendGridMessages].[IX_SendGridMessages_FRT]...';


GO
CREATE NONCLUSTERED INDEX [IX_SendGridMessages_FRT]
    ON [dbo].[SendGridMessages]([first_recorded_time] DESC);


GO
PRINT N'Creating Table [dbo].[SendGridTemplate]...';


GO
CREATE TABLE [dbo].[SendGridTemplate] (
    [EmailTemplateKey]  INT            IDENTITY (1, 1) NOT NULL,
    [EmailTemplateGuid] NVARCHAR (50)  NOT NULL,
    [EmailTemplateName] NVARCHAR (100) NOT NULL,
    [EmailTemplateBody] NVARCHAR (MAX) NULL,
    [EmailTemplateDate] DATE           NOT NULL,
    CONSTRAINT [PK_SendGridTemplat] PRIMARY KEY CLUSTERED ([EmailTemplateKey] ASC)
);


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[APIServiceCatalog]...';


GO
ALTER TABLE [dbo].[APIServiceCatalog]
    ADD DEFAULT (getdate()) FOR [CreateDateTime];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[APIServiceCatalog]...';


GO
ALTER TABLE [dbo].[APIServiceCatalog]
    ADD DEFAULT (getdate()) FOR [ModifyDateTime];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[ApplicationLog]...';


GO
ALTER TABLE [dbo].[ApplicationLog]
    ADD DEFAULT (getdate()) FOR [RecordedTimestamp];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[SendGridMessages]...';


GO
ALTER TABLE [dbo].[SendGridMessages]
    ADD DEFAULT ((0)) FOR [opens_count];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[SendGridMessages]...';


GO
ALTER TABLE [dbo].[SendGridMessages]
    ADD DEFAULT ((0)) FOR [clicks_count];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[SendGridMessages]...';


GO
ALTER TABLE [dbo].[SendGridMessages]
    ADD DEFAULT (getdate()) FOR [first_recorded_time];


GO
PRINT N'Creating Default Constraint [dbo].[DF_SendGridMessages_exceed_thirty_days]...';


GO
ALTER TABLE [dbo].[SendGridMessages]
    ADD CONSTRAINT [DF_SendGridMessages_exceed_thirty_days] DEFAULT ((0)) FOR [past_30_days];


GO
PRINT N'Creating Default Constraint [dbo].[DF_SendGridMessages_last_accessed_time]...';


GO
ALTER TABLE [dbo].[SendGridMessages]
    ADD CONSTRAINT [DF_SendGridMessages_last_accessed_time] DEFAULT (getutcdate()-(1)) FOR [last_accessed_time];


GO
PRINT N'Creating Default Constraint [dbo].[DF_SendGridTemplate_EmailTemplateDate]...';


GO
ALTER TABLE [dbo].[SendGridTemplate]
    ADD CONSTRAINT [DF_SendGridTemplate_EmailTemplateDate] DEFAULT (getdate()) FOR [EmailTemplateDate];


GO
PRINT N'Creating Extended Property [dbo].[APIServiceCatalog].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Logically grouped Master API definations', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'APIServiceCatalog';


GO
PRINT N'Creating Extended Property [dbo].[APIServiceCatalog].[ServiceCatalogKey].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Service Catalog Key', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'APIServiceCatalog', @level2type = N'COLUMN', @level2name = N'ServiceCatalogKey';


GO
PRINT N'Creating Extended Property [dbo].[APIServiceCatalog].[ServiceCatalogName].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Catalog Name', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'APIServiceCatalog', @level2type = N'COLUMN', @level2name = N'ServiceCatalogName';


GO
PRINT N'Creating Extended Property [dbo].[APIServiceCatalog].[ServiceDescription].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Description about the Service', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'APIServiceCatalog', @level2type = N'COLUMN', @level2name = N'ServiceDescription';


GO
PRINT N'Creating Extended Property [dbo].[APIServiceCatalog].[APIProductCategory].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Category such as Underwriting, Financial, Enterprise Services etc', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'APIServiceCatalog', @level2type = N'COLUMN', @level2name = N'APIProductCategory';


GO
PRINT N'Creating Extended Property [dbo].[ApplicationLog].[LogItemKey].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Reference Key to APIServiceContract Catalog where applicable from an API or Application flow', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ApplicationLog', @level2type = N'COLUMN', @level2name = N'LogItemKey';


GO
PRINT N'Update complete.';


GO

