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
PRINT N'Creating Table [dbo].[APIServiceContract]...';


GO
CREATE TABLE [dbo].[APIServiceContract] (
    [ServiceContractKey]          INT            IDENTITY (1, 1) NOT NULL,
    [ServiceCatalogKey]           INT            NOT NULL,
    [ServiceName]                 VARCHAR (150)  NOT NULL,
    [ServiceDescription]          VARCHAR (2000) NOT NULL,
    [ServiceAvailability]         VARCHAR (100)  NULL,
    [ServiceReusability]          VARCHAR (50)   NULL,
    [ServiceVersion]              VARCHAR (10)   NOT NULL,
    [ServiceIdentifier]           VARCHAR (50)   NULL,
    [ServiceDiscoverableURL]      VARCHAR (150)  NULL,
    [ServiceBinding]              VARCHAR (200)  NULL,
    [ServiceInstanceInfo]         VARCHAR (2000) NULL,
    [ServicePrimaryEndPoint]      VARCHAR (150)  NULL,
    [ServiceSourceSystems]        VARCHAR (250)  NULL,
    [ServiceTechnicalOwner]       VARCHAR (500)  NULL,
    [ServiceTechnicalDescription] VARCHAR (2000) NULL,
    [ServiceBusinessOwner]        VARCHAR (500)  NULL,
    [ServiceOperationsOwner]      VARCHAR (500)  NULL,
    [ServiceScope]                VARCHAR (100)  NULL,
    [ServiceSecurity]             VARCHAR (100)  NULL,
    CONSTRAINT [PK_APIServiceContract] PRIMARY KEY CLUSTERED ([ServiceContractKey] ASC),
    CONSTRAINT [APIServiceConstraint] UNIQUE NONCLUSTERED ([ServiceName] ASC, [ServiceVersion] ASC)
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
    [IntegrationMessage]        NVARCHAR (MAX)  NULL,
    [RelatedPolicyNumber]       NVARCHAR (25)   NULL,
    [RelatedAccountNumber]      NVARCHAR (25)   NULL,
    [RelatedClaimNumber]        NVARCHAR (25)   NULL,
    [BusinessEntityName]        NVARCHAR (60)   NULL,
    [BusinessEntityId]          NVARCHAR (25)   NULL,
    [BusinessEntityData]        NVARCHAR (MAX)  NULL,
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
PRINT N'Creating Table [dbo].[AttachmentLog]...';


GO
CREATE TABLE [dbo].[AttachmentLog] (
    [AttachItemKey] INT             IDENTITY (1, 1) NOT NULL,
    [EmailItemKey]  INT             NOT NULL,
    [FileType]      NVARCHAR (100)  NULL,
    [FileName]      NVARCHAR (256)  NOT NULL,
    [FileSize]      INT             NOT NULL,
    [Content]       VARBINARY (MAX) NULL,
    CONSTRAINT [PK_AttachmentLog] PRIMARY KEY CLUSTERED ([AttachItemKey] ASC)
);


GO
PRINT N'Creating Table [dbo].[HtmlBodyLog]...';


GO
CREATE TABLE [dbo].[HtmlBodyLog] (
    [HtmlItemKey]  INT            IDENTITY (1, 1) NOT NULL,
    [EmailItemKey] INT            NOT NULL,
    [HtmlBody]     NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_HtmlBodyLog] PRIMARY KEY CLUSTERED ([HtmlItemKey] ASC)
);


GO
PRINT N'Creating Table [dbo].[ParmGridLog]...';


GO
CREATE TABLE [dbo].[ParmGridLog] (
    [ParmItemKey]  INT             IDENTITY (1, 1) NOT NULL,
    [EmailItemKey] INT             NOT NULL,
    [ParmName]     NVARCHAR (50)   NOT NULL,
    [ParmValue]    NVARCHAR (1024) NULL,
    CONSTRAINT [PK_ParmGridLog] PRIMARY KEY CLUSTERED ([ParmItemKey] ASC)
);


GO
PRINT N'Creating Table [dbo].[PostAddressLog]...';


GO
CREATE TABLE [dbo].[PostAddressLog] (
    [PostItemKey]  INT            IDENTITY (1, 1) NOT NULL,
    [EmailItemKey] INT            NOT NULL,
    [DisplayName]  NVARCHAR (100) NULL,
    [Address]      NVARCHAR (256) NOT NULL,
    [CC]           BIT            NOT NULL,
    CONSTRAINT [PK_PostAddressLog] PRIMARY KEY CLUSTERED ([PostItemKey] ASC)
);


GO
PRINT N'Creating Table [dbo].[SendGridEventDetails]...';


GO
CREATE TABLE [dbo].[SendGridEventDetails] (
    [eventDetailKey]  INT            IDENTITY (1, 1) NOT NULL,
    [eventKey]        INT            NOT NULL,
    [event_name]      NVARCHAR (50)  NOT NULL,
    [processed]       DATETIME       NOT NULL,
    [reason]          NVARCHAR (MAX) NULL,
    [attempt_num]     INT            NOT NULL,
    [mx_server]       NVARCHAR (100) NULL,
    [http_user_agent] NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_SendGridEventDetails] PRIMARY KEY CLUSTERED ([eventDetailKey] ASC)
);


GO
PRINT N'Creating Table [dbo].[SendGridEvents]...';


GO
CREATE TABLE [dbo].[SendGridEvents] (
    [eventKey]       INT            IDENTITY (1, 1) NOT NULL,
    [msgKey]         INT            NOT NULL,
    [template_id]    NVARCHAR (100) NULL,
    [api_key_id]     NVARCHAR (500) NULL,
    [originating_ip] NVARCHAR (25)  NULL,
    [categories]     NVARCHAR (256) NULL,
    CONSTRAINT [PK_SendGridEvents] PRIMARY KEY CLUSTERED ([eventKey] ASC)
);


GO
PRINT N'Creating Table [dbo].[SendGridLog]...';


GO
CREATE TABLE [dbo].[SendGridLog] (
    [EmailItemKey]          INT              IDENTITY (1, 1) NOT NULL,
    [EmailItemID]           UNIQUEIDENTIFIER NOT NULL,
    [EmailTemplateKey]      INT              NOT NULL,
    [EmailTemplateGuid]     NVARCHAR (50)    NULL,
    [EmailTemplateName]     NVARCHAR (100)   NOT NULL,
    [EmailRequestTimestamp] DATETIME         NOT NULL,
    [EmailRequestStatus]    NVARCHAR (50)    NOT NULL,
    [EmailRecipientAddress] NVARCHAR (256)   NOT NULL,
    [EmailRecipientName]    NVARCHAR (256)   NULL,
    [SourceMachineName]     NVARCHAR (100)   NULL,
    [MachineName]           NVARCHAR (100)   NULL,
    [RecordedTimestamp]     DATETIME         NOT NULL,
    [EmailSubject]          NVARCHAR (100)   NULL,
    [XMessageId]            NVARCHAR (50)    NULL,
    [EmailFromAddress]      NVARCHAR (256)   NOT NULL,
    [EmailFromName]         NVARCHAR (256)   NULL,
    CONSTRAINT [PK_SendGridLog] PRIMARY KEY CLUSTERED ([EmailItemKey] ASC)
);


GO
PRINT N'Creating Index [dbo].[SendGridLog].[IX_SendGridLog]...';


GO
CREATE NONCLUSTERED INDEX [IX_SendGridLog]
    ON [dbo].[SendGridLog]([RecordedTimestamp] DESC);


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
    CONSTRAINT [PK_SendGridTemplate] PRIMARY KEY CLUSTERED ([EmailTemplateKey] ASC)
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
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[AttachmentLog]...';


GO
ALTER TABLE [dbo].[AttachmentLog]
    ADD DEFAULT ((0)) FOR [FileSize];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[PostAddressLog]...';


GO
ALTER TABLE [dbo].[PostAddressLog]
    ADD DEFAULT ((0)) FOR [CC];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[SendGridEventDetails]...';


GO
ALTER TABLE [dbo].[SendGridEventDetails]
    ADD DEFAULT ((0)) FOR [attempt_num];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[SendGridLog]...';


GO
ALTER TABLE [dbo].[SendGridLog]
    ADD DEFAULT ((1)) FOR [EmailTemplateKey];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[SendGridLog]...';


GO
ALTER TABLE [dbo].[SendGridLog]
    ADD DEFAULT ('Initiated') FOR [EmailRequestStatus];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[SendGridLog]...';


GO
ALTER TABLE [dbo].[SendGridLog]
    ADD DEFAULT (getdate()) FOR [RecordedTimestamp];


GO
PRINT N'Creating Default Constraint [dbo].[DF_SendGridLog_EmailFromAddress]...';


GO
ALTER TABLE [dbo].[SendGridLog]
    ADD CONSTRAINT [DF_SendGridLog_EmailFromAddress] DEFAULT (N'noreply@prosightdirect.com') FOR [EmailFromAddress];


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
PRINT N'Creating Foreign Key [dbo].[FK_APIServiceContract_ServiceCatalogKey]...';


GO
ALTER TABLE [dbo].[APIServiceContract] WITH NOCHECK
    ADD CONSTRAINT [FK_APIServiceContract_ServiceCatalogKey] FOREIGN KEY ([ServiceCatalogKey]) REFERENCES [dbo].[APIServiceCatalog] ([ServiceCatalogKey]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_AttachmentLog_SendGridLog]...';


GO
ALTER TABLE [dbo].[AttachmentLog] WITH NOCHECK
    ADD CONSTRAINT [FK_AttachmentLog_SendGridLog] FOREIGN KEY ([EmailItemKey]) REFERENCES [dbo].[SendGridLog] ([EmailItemKey]) ON DELETE CASCADE;


GO
PRINT N'Creating Foreign Key [dbo].[FK_HtmlBodyLog_SendGridLog]...';


GO
ALTER TABLE [dbo].[HtmlBodyLog] WITH NOCHECK
    ADD CONSTRAINT [FK_HtmlBodyLog_SendGridLog] FOREIGN KEY ([EmailItemKey]) REFERENCES [dbo].[SendGridLog] ([EmailItemKey]) ON DELETE CASCADE;


GO
PRINT N'Creating Foreign Key [dbo].[FK_ParmGridLog_SendGridLog]...';


GO
ALTER TABLE [dbo].[ParmGridLog] WITH NOCHECK
    ADD CONSTRAINT [FK_ParmGridLog_SendGridLog] FOREIGN KEY ([EmailItemKey]) REFERENCES [dbo].[SendGridLog] ([EmailItemKey]) ON DELETE CASCADE;


GO
PRINT N'Creating Foreign Key [dbo].[FK_PostAddressLog_SendGridLog]...';


GO
ALTER TABLE [dbo].[PostAddressLog] WITH NOCHECK
    ADD CONSTRAINT [FK_PostAddressLog_SendGridLog] FOREIGN KEY ([EmailItemKey]) REFERENCES [dbo].[SendGridLog] ([EmailItemKey]) ON DELETE CASCADE;


GO
PRINT N'Creating Foreign Key [dbo].[FK_SendGridEventDetails_SendGridEvents]...';


GO
ALTER TABLE [dbo].[SendGridEventDetails] WITH NOCHECK
    ADD CONSTRAINT [FK_SendGridEventDetails_SendGridEvents] FOREIGN KEY ([eventKey]) REFERENCES [dbo].[SendGridEvents] ([eventKey]) ON DELETE CASCADE;


GO
PRINT N'Creating Foreign Key [dbo].[FK_SendGridEvents_SendGridMessages]...';


GO
ALTER TABLE [dbo].[SendGridEvents] WITH NOCHECK
    ADD CONSTRAINT [FK_SendGridEvents_SendGridMessages] FOREIGN KEY ([msgKey]) REFERENCES [dbo].[SendGridMessages] ([msgKey]) ON DELETE CASCADE;


GO
PRINT N'Creating Foreign Key [dbo].[FK_SendGridLog_SendGridTemplate]...';


GO
ALTER TABLE [dbo].[SendGridLog] WITH NOCHECK
    ADD CONSTRAINT [FK_SendGridLog_SendGridTemplate] FOREIGN KEY ([EmailTemplateKey]) REFERENCES [dbo].[SendGridTemplate] ([EmailTemplateKey]);


GO
PRINT N'Creating View [dbo].[NotificationVw]...';


GO















CREATE VIEW [dbo].[NotificationVw] as SELECT 
    EmailRecipientName AS [Full Name], a.RecordedTimestamp as Recorded, msg_id,
	ISNULL(to_email, EmailRecipientAddress) as Company, EmailRecipientAddress as Parent, e.EmailTemplateName as Trade, a.EmailRequestStatus as Status,
	d.event_name as [Certificate], d.processed as Issued, EmailItemKey as SiteID
FROM SendGridLog a
LEFT JOIN SendGridMessages b
  ON LEFT(b.msg_id, CHARINDEX('.recvd', b.msg_id) - 1) = a.XMessageId
LEFT JOIN SendGridEvents c
  ON b.msgKey = c.msgKey
LEFT JOIN SendGridEventDetails d
  ON c.eventKey = d.eventKey
INNER JOIN SendGridTemplate e
  ON a.EmailTemplateGuid = e.EmailTemplateGuid
GO
PRINT N'Creating View [dbo].[NotificatiosVw]...';


GO



CREATE VIEW [dbo].[NotificatiosVw] AS
SELECT 
    [Full Name], Recorded, msg_id,
    Company, Parent,
    Trade, Status,
    ISNULL(Certificate, Status) AS Certificate, 
    Issued,
    SiteID,
    LAG(SiteID) OVER (PARTITION BY Trade ORDER BY Company, [Full Name], Trade, Issued) AS PrevSiteID,
    CASE 
        WHEN LAG(SiteID) OVER (PARTITION BY Trade ORDER BY Company, [Full Name], Trade, Issued) IS NOT NULL 
             AND LAG(SiteID) OVER (PARTITION BY Trade ORDER BY Company, [Full Name], Trade, Issued) <> SiteID 
        THEN 1 ELSE 0 
    END AS ShowTradeAgain
FROM NotificationVw;
GO
PRINT N'Creating Procedure [dbo].[InsertTemplates]...';


GO
CREATE procedure [dbo].[InsertTemplates]
	@file varchar(100),
	@guid varchar(50)
AS
BEGIN
	declare @sql nvarchar(max)
	declare @path varchar(100)
	declare @pathfile varchar(200)

	select @path = 'C:\Users\Steve\Source\repos\Dashboard\SendGrid Templates\';
	select @pathfile = @path + @file + ' ' + @guid + '.html';
	select @pathfile = replace(@pathfile, '''', '''''')

	select @sql = N'
	INSERT INTO SendGridTemplate ([EmailTemplateGuid], [EmailTemplateName], [EmailTemplateDate], [EmailTemplateBody])
	SELECT ''' + @guid + ''',''' + @file + ''',getdate(),
	(
	SELECT replace(replace(bulkcolumn, CHAR(13), ''''), CHAR(10), '''') from OPENROWSET   
	( BULK ''' + @pathfile + ''', SINGLE_NCLOB ) x
	)'

	--PRINT @sql
	EXEC sp_executesql @sql
END
GO
PRINT N'Creating Procedure [dbo].[InsUpdActivityLog]...';


GO



CREATE PROCEDURE [dbo].[InsUpdActivityLog]
	@from_email nvarchar(256),
	@msg_id nvarchar(100),
	@subject nvarchar(100),
	@to_email nvarchar(256),
	@status nvarchar(50),
	@opens_count int,
	@clicks_count int,
	@last_event_time nvarchar(50),
	@first_recorded_time datetime,
	@SendGridEventArray as [dbo].[SendGridEventArray] READONLY,
	@SendGridDetailArray as [dbo].[SendGridDetailArray] READONLY
AS
BEGIN
	declare @msgKey int;
	declare @eventKey int;
	declare @processed datetime;

	IF EXISTS (SELECT * FROM SendGridMessages where msg_id = @msg_id)
	BEGIN
		SELECT @msgKey = msgKey FROM SendGridMessages where msg_id = @msg_id;

		update SendGridMessages set [status] = @status, opens_count = @opens_count, 
		clicks_count = @clicks_count, last_event_time = @last_event_time,
		from_email = @from_email, [subject] = @subject
		where @msgKey = msgKey

		SELECT @eventKey = eventKey FROM SendGridEvents where msgKey = @msgKey

		IF @eventKey is null
		BEGIN
			INSERT INTO SendGridEvents (
			msgKey, template_id, api_key_id, originating_ip, categories
			)
			SELECT @msgKey, template_id, api_key_id, originating_ip, categories
			FROM @SendGridEventArray
			where template_id is not null or api_key_id is not null
			or originating_ip is not null or categories is not null

			SELECT @eventKey = SCOPE_IDENTITY();

			INSERT INTO SendGridEventDetails (
			eventKey, event_name, processed, reason, attempt_num, mx_server, http_user_agent
			)
			SELECT @eventKey, event_name, processed, reason, attempt_num, mx_server, http_user_agent
			FROM @SendGridDetailArray
			where event_name is not null or processed is not null or reason is not null
			or attempt_num is not null or mx_server is not null or http_user_agent is not null

			SELECT @processed = processed
			FROM SendGridEventDetails
			where event_name = 'processed' or event_name = 'drop'

			update SendGridMessages set first_recorded_time = @processed
			where @msgKey = msgKey and @processed is not null
		END
		ELSE
		BEGIN
			update SendGridEvents set template_id = sgea.template_id, api_key_id = sgea.api_key_id,
			originating_ip = sgea.originating_ip, categories = sgea.categories
			FROM @SendGridEventArray sgea where eventKey = @eventKey

			INSERT INTO SendGridEventDetails (
			eventKey, event_name, processed, reason, attempt_num, mx_server, http_user_agent
			)
			SELECT @eventKey, event_name, processed, reason, attempt_num, mx_server, http_user_agent
			FROM @SendGridDetailArray sgda where LEN(event_name) != 0
			and (processed > (select max(processed) from SendGridEventDetails where eventKey = @eventKey)
			or (event_name in ('processed', 'delivered', 'drop')
			and NOT EXISTS (SELECT * FROM SendGridEventDetails where eventKey = @eventKey and event_name = sgda.event_name)))
		END
	END
	ELSE
	BEGIN
		INSERT INTO SendGridMessages (
		from_email, msg_id, [subject], to_email, [status],
		opens_count, clicks_count, last_event_time, first_recorded_time
		)
		VALUES (
		@from_email, @msg_id, @subject, @to_email, @status,
		@opens_count, @clicks_count, @last_event_time, @first_recorded_time
		);

		SELECT @msgKey = SCOPE_IDENTITY();

		INSERT INTO SendGridEvents (
		msgKey, template_id, api_key_id, originating_ip, categories
		)
		SELECT @msgKey, template_id, api_key_id, originating_ip, categories
		FROM @SendGridEventArray
		where template_id is not null or api_key_id is not null
		or originating_ip is not null or categories is not null

		SELECT @eventKey = SCOPE_IDENTITY();

		INSERT INTO SendGridEventDetails (
		eventKey, event_name, processed, reason, attempt_num, mx_server, http_user_agent
		)
		SELECT @eventKey, event_name, processed, reason, attempt_num, mx_server, http_user_agent
		FROM @SendGridDetailArray
		where event_name is not null or processed is not null or reason is not null
		or attempt_num is not null or mx_server is not null or http_user_agent is not null
	END
END
GO
PRINT N'Creating Procedure [dbo].[InsUpdSendGridLog]...';


GO

CREATE PROCEDURE [dbo].[InsUpdSendGridLog]
	@EmailItemID uniqueidentifier,
	@EmailTemplateGuid nvarchar(50) = null,
	@EmailTemplateName nvarchar(100),
	@EmailRequestTimestamp datetime,
	@EmailRequestStatus nvarchar(50),
	@EmailRecipientAddress nvarchar(256),
	@EmailRecipientName nvarchar(256),
	@EmailFromAddress nvarchar(256),
	@EmailFromName nvarchar(256),
	@HtmlBody nvarchar(max),
	@SourceMachineName nvarchar(100),
	@MachineName nvarchar(100),
	@EmailSubject nvarchar(100),
	@XMessageId nvarchar(50),
	@ParameterArray as [dbo].[ParameterArray] READONLY,
	@PostAddressArray as [dbo].[PostAddressArray] READONLY,
	@AttachmentArray as [dbo].[AttachmentArray] READONLY
AS
BEGIN
	declare @EmailTemplateKey int;
	declare @EmailTemplateKeyCount int;

	select @EmailTemplateKeyCount = count([EmailTemplateKey])
	from SendGridTemplate
	where replace([EmailTemplateName], ' ', '') = replace(replace(@EmailTemplateName, ' ', ''), '_', '')

	if @EmailTemplateKeyCount = 0
	begin
		set @EmailTemplateKey = 1
	end
	else
	begin
		select @EmailTemplateKey = [EmailTemplateKey]
		from SendGridTemplate
		where replace([EmailTemplateName], ' ', '') = replace(replace(@EmailTemplateName, ' ', ''), '_', '')
	end

	IF EXISTS (SELECT * FROM SendGridLog where EmailItemID = @EmailItemID)
	BEGIN
		update SendGridLog
		set [EmailTemplateKey] = @EmailTemplateKey, [EmailTemplateGuid] = @EmailTemplateGuid,
		[EmailTemplateName] = ltrim(rtrim(@EmailTemplateName)),
		[EmailRequestTimestamp] = @EmailRequestTimestamp, [EmailRequestStatus] = @EmailRequestStatus,
		[EmailRecipientAddress] = @EmailRecipientAddress, [EmailRecipientName] = @EmailRecipientName,
		[EmailFromAddress] = @EmailFromAddress, [EmailFromName] = @EmailFromName,
		[SourceMachineName] = @SourceMachineName, [MachineName] = @MachineName,
		[EmailSubject] = @EmailSubject, [XMessageId] = @XMessageId, [RecordedTimestamp] = GETDATE()
		where EmailItemID = @EmailItemID
	END
	ELSE
	BEGIN
		declare @EmailItemKey int;

		insert into SendGridLog (
		[EmailItemID], [EmailTemplateKey], [EmailTemplateGuid], [EmailTemplateName], [EmailRequestTimestamp],
		[EmailRequestStatus],
		[EmailRecipientAddress], [EmailRecipientName],
		[EmailFromAddress], [EmailFromName],
		[SourceMachineName], [MachineName], [EmailSubject], [XMessageId]
		)
		values (
		@EmailItemID, @EmailTemplateKey, @EmailTemplateGuid, ltrim(rtrim(@EmailTemplateName)), @EmailRequestTimestamp,
		@EmailRequestStatus,
		@EmailRecipientAddress, @EmailRecipientName,
		@EmailFromAddress, @EmailFromName,
		@SourceMachineName, @MachineName, @EmailSubject, @XMessageId
		);

		select @EmailItemKey = SCOPE_IDENTITY();

		INSERT INTO ParmGridLog (
		[EmailItemKey], [ParmName], [ParmValue]
		)
		SELECT @EmailItemKey, [ParmName], [ParmValue]
		FROM @ParameterArray p WHERE len(p.[ParmName]) != 0

		INSERT INTO PostAddressLog (
		[EmailItemKey], [DisplayName], [Address], [CC]
		)
		SELECT @EmailItemKey, [DisplayName], [Address], [CC]
		FROM @PostAddressArray p WHERE len(p.[Address]) != 0

		INSERT INTO AttachmentLog (
		[EmailItemKey], [FileType], [FileName], [FileSize]
		)
		SELECT @EmailItemKey, [FileType], [FileName], [FileSize]
		FROM @AttachmentArray p WHERE len(p.[FileName]) != 0

		INSERT INTO HtmlBodyLog (
		[EmailItemKey], [HtmlBody]
		)
		SELECT @EmailItemKey, @HtmlBody WHERE len(@HtmlBody) != 0

	END
END
GO
PRINT N'Creating Procedure [dbo].[InsUpdTemplates]...';


GO
CREATE procedure [dbo].[InsUpdTemplates]
	@file varchar(100),
	@guid varchar(50)
AS
BEGIN
	declare @sql nvarchar(max)
	declare @path varchar(100)
	declare @pathfile varchar(200)

	select @path = 'C:\Users\Steve\Source\Repos\Dashboard\SendGrid Templates\';
	select @pathfile = @path + @file + ' ' + @guid + '.html';
	select @pathfile = replace(@pathfile, '''', '''''')

	select @sql = N'
	INSERT INTO [SendGridTemplate] ([EmailTemplateName], [EmailTemplateDate], [EmailTemplateGuid])
	VALUES (''' + @file + ''', getdate(), ''' + @guid + ''')'

	--PRINT @sql
	EXEC sp_executesql @sql

	select @sql = N'
	UPDATE [SendGridTemplate] SET [EmailTemplateDate] = getdate(), [EmailTemplateBody] =
	(
	select replace(replace(bulkcolumn, CHAR(13), ''''), CHAR(10), '''') from OPENROWSET   
	( BULK ''' + @pathfile + ''', SINGLE_NCLOB ) x
	)
	WHERE [EmailTemplateGuid] = ''' + @guid + ''''

	--PRINT @sql
	EXEC sp_executesql @sql
END
GO
PRINT N'Creating Procedure [dbo].[QuerySelectActivityLogs]...';


GO
CREATE PROCEDURE [dbo].[QuerySelectActivityLogs]
    @Status NVARCHAR(50) = NULL,
    @FromDate SMALLDATETIME = NULL,
    @ToDate SMALLDATETIME = NULL,
    @ToEmail NVARCHAR(256) = NULL,
    @TotalRows INT = 1000
AS
BEGIN
    SET NOCOUNT ON;

    WITH SendMessageLogs AS (
        SELECT
            ROW_NUMBER() OVER (ORDER BY [first_recorded_time] DESC) AS RowNumber,
            [msgKey],
            [from_email],
            [msg_id],
            [subject],
            CAST([last_event_time] AS SMALLDATETIME) AS [last_event_time],
            [to_email],
            [status],
            [opens_count],
            [clicks_count],
            CAST([first_recorded_time] AS SMALLDATETIME) AS [first_recorded_time],
            CAST([last_accessed_time] AS SMALLDATETIME) AS [last_accessed_time],
            SGL.EmailTemplateGuid AS [email_template_guid]
        FROM [dbo].[SendGridMessages] SGM WITH (NOLOCK)
        LEFT JOIN [dbo].[SendGridLog] SGL
            ON SUBSTRING(SGM.msg_id, 1, LEN(SGL.XMessageId)) = SGL.XMessageId
        WHERE
            ([first_recorded_time] > @FromDate OR @FromDate IS NULL) AND
            ([first_recorded_time] < @ToDate OR @ToDate IS NULL) AND
            ([to_email] LIKE @ToEmail OR @ToEmail IS NULL) AND
            (@Status IS NULL OR [status] LIKE @Status)
    )
    SELECT
        RowNumber,
        [msgKey],
        [from_email],
        [msg_id],
        [subject],
        CAST([last_event_time] AS SMALLDATETIME) AS [last_event_time],
        [to_email],
        [status],
        [opens_count],
        [clicks_count],
        CAST([first_recorded_time] AS SMALLDATETIME) AS [first_recorded_time],
        CAST([last_accessed_time] AS SMALLDATETIME) AS [last_accessed_time],
        [email_template_guid]
    FROM SendMessageLogs WITH (NOLOCK)
    WHERE
        (RowNumber <= @TotalRows OR @TotalRows = 0) AND
        ([first_recorded_time] > @FromDate OR @FromDate IS NULL) AND
        ([first_recorded_time] < @ToDate OR @ToDate IS NULL) AND
        ([to_email] LIKE @ToEmail OR @ToEmail IS NULL) AND
        (@Status IS NULL OR [status] LIKE @Status);
END;
GO
PRINT N'Creating Procedure [dbo].[QuerySelectApplicationLogs]...';


GO
CREATE PROCEDURE dbo.QuerySelectApplicationLogs
    @FromDate smalldatetime = NULL,
    @ToDate smalldatetime = NULL,
    @Severity nvarchar(50) = NULL,
    @TotalRows int = 1000
AS
BEGIN
    SET NOCOUNT ON;

    WITH ApplicationLogs AS (
        SELECT 
            ROW_NUMBER() OVER (ORDER BY [LogItemKey] DESC) AS RowNumber,
            [LogItemKey],
            [LogItemID],
            [Severity],
            CAST([LogEventTimestamp] AS smalldatetime) AS [LogEventTimestamp],
            [LogEventName],
            [LogEventDescription],
            [ApplicationName],
            [ApplicationServiceAccount],
            [ApplicationUser],
            [ApplicationMachineName],
            [ApplicationException],
            [ApplicationStack],
            [ApplicationThread],
            [IntegrationSource],
            [IntegrationTarget],
            [IntegrationMessage],
            [RelatedPolicyNumber],
            [RelatedAccountNumber],
            [RelatedClaimNumber],
            [BusinessEntityName],
            [BusinessEntityId],
            [BusinessEntityData],
            CAST([RecordedTimestamp] AS smalldatetime) AS [RecordedTimestamp],
            AL.ServiceContractKey,
            [ServiceName]
        FROM [dbo].[ApplicationLog] AL WITH (NOLOCK)
        LEFT OUTER JOIN [dbo].[APIServiceContract] APISC 
            ON AL.ServiceContractKey = APISC.ServiceContractKey
        WHERE 
            ([RecordedTimestamp] > @FromDate OR @FromDate IS NULL) AND
            ([RecordedTimestamp] < @ToDate OR @ToDate IS NULL) AND
            (@Severity IS NULL OR [Severity] LIKE @Severity)
    )

    SELECT 
        RowNumber,
        [LogItemKey],
        [LogItemID],
        [Severity],
        [LogEventTimestamp],
        [LogEventName],
        [LogEventDescription],
        [ApplicationName],
        [ApplicationServiceAccount],
        [ApplicationUser],
        [ApplicationMachineName],
        [ApplicationException],
        [ApplicationStack],
        [ApplicationThread],
        [IntegrationSource],
        [IntegrationTarget],
        [IntegrationMessage],
        [RelatedPolicyNumber],
        [RelatedAccountNumber],
        [RelatedClaimNumber],
        [BusinessEntityName],
        [BusinessEntityId],
        [BusinessEntityData],
        [RecordedTimestamp],
        [ServiceContractKey],
        [ServiceName]
    FROM ApplicationLogs WITH (NOLOCK)
    WHERE RowNumber <= @TotalRows;
END;
GO
PRINT N'Creating Procedure [dbo].[QuerySelectSendGridLogs]...';


GO
CREATE PROCEDURE [dbo].[QuerySelectSendGridLogs]
    @FromDate     smalldatetime = NULL,
    @ToDate       smalldatetime = NULL,
    @ToEmail      nvarchar(256) = NULL,
    @TotalRows    int = 1000
AS
BEGIN
    SET NOCOUNT ON;

    WITH SendGridLogs AS (
        SELECT 
            ROW_NUMBER() OVER (ORDER BY [RecordedTimestamp] DESC) AS RowNumber,
            SGL.[EmailItemKey],
            [EmailItemID],
            [EmailTemplateKey],
            [EmailTemplateGuid],
            [EmailTemplateName],
            CAST([EmailRequestTimestamp] AS smalldatetime) AS [EmailRequestTimestamp],
            [EmailRequestStatus],
            [EmailRecipientAddress],
            [EmailRecipientName],
            [SourceMachineName],
            [MachineName],
            CAST([RecordedTimestamp] AS smalldatetime) AS [RecordedTimestamp],
            [EmailSubject],
            [XMessageId],
            [EmailFromAddress],
            [EmailFromName],
            [HtmlBody]
        FROM 
            [dbo].[SendGridLog] SGL WITH (NOLOCK)
        LEFT OUTER JOIN 
            [dbo].[HtmlBodyLog] HBL 
            ON SGL.EmailItemKey = HBL.EmailItemKey
        WHERE 
            ([RecordedTimestamp] > @FromDate OR @FromDate IS NULL)
            AND ([RecordedTimestamp] < @ToDate OR @ToDate IS NULL)
            AND ([EmailRecipientAddress] LIKE @ToEmail OR @ToEmail IS NULL)
    )

    SELECT 
        RowNumber,
        SGL.[EmailItemKey],
        [EmailItemID],
        [EmailTemplateKey],
        [EmailTemplateGuid],
        [EmailTemplateName],
        CAST([EmailRequestTimestamp] AS smalldatetime) AS [EmailRequestTimestamp],
        [EmailRequestStatus],
        [EmailRecipientAddress],
        [EmailRecipientName],
        [SourceMachineName],
        [MachineName],
        CAST([RecordedTimestamp] AS smalldatetime) AS [RecordedTimestamp],
        [EmailSubject],
        [XMessageId],
        [EmailFromAddress],
        [EmailFromName],
        HBL.[HtmlBody]
    FROM 
        SendGridLogs SGL WITH (NOLOCK)
    LEFT OUTER JOIN 
        [dbo].[HtmlBodyLog] HBL 
        ON SGL.EmailItemKey = HBL.EmailItemKey
    WHERE 
        (RowNumber <= @TotalRows OR @TotalRows = 0)
        AND ([RecordedTimestamp] > @FromDate OR @FromDate IS NULL)
        AND ([RecordedTimestamp] < @ToDate OR @ToDate IS NULL)
        AND ([EmailRecipientAddress] LIKE @ToEmail OR @ToEmail IS NULL);
END;
GO
PRINT N'Creating Procedure [dbo].[UpdateTemplates]...';


GO
CREATE procedure [dbo].[UpdateTemplates]
	@file varchar(100),
	@guid varchar(50)
AS
BEGIN
	declare @sql nvarchar(max)
	declare @path varchar(100)
	declare @pathfile varchar(200)

	select @path = 'C:\Users\Steve\Source\Repos\Dashboard\SendGrid Templates\';
	select @pathfile = @path + @file + ' ' + @guid + '.html';
	select @pathfile = replace(@pathfile, '''', '''''')

	select @sql = N'
	UPDATE [SendGridTemplate] SET [EmailTemplateDate] = getdate(), [EmailTemplateBody] =
	(
	select replace(replace(bulkcolumn, CHAR(13), ''''), CHAR(10), '''') from OPENROWSET   
	( BULK ''' + @pathfile + ''', SINGLE_NCLOB ) x
	)
	WHERE [EmailTemplateGuid] = ''' + @guid + ''''

	--PRINT @sql
	EXEC sp_executesql @sql
END
GO
PRINT N'Creating Procedure [dbo].[UpdAttachmentLog]...';


GO

CREATE PROCEDURE [dbo].[UpdAttachmentLog]
	@EmailItemID uniqueidentifier,
	@FileName nvarchar(256),
	@Content varbinary(max)
AS
BEGIN
    update [AttachmentLog]
	set Content = @Content
    FROM [SendGridLog] s
    inner join [AttachmentLog] a
    on s.EmailItemKey = a.EmailItemKey
    where s.EmailItemID = @EmailItemID
    and a.FileName = @FileName
END
GO
PRINT N'Creating Extended Property [dbo].[APIServiceCatalog].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Logically grouped Master API definitions', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'APIServiceCatalog';


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
PRINT N'Creating Extended Property [dbo].[APIServiceContract].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Entities that describe a Service.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'APIServiceContract';


GO
PRINT N'Creating Extended Property [dbo].[APIServiceContract].[ServiceContractKey].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Service Contract API Key', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'APIServiceContract', @level2type = N'COLUMN', @level2name = N'ServiceContractKey';


GO
PRINT N'Creating Extended Property [dbo].[APIServiceContract].[ServiceName].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Service Friendly Name', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'APIServiceContract', @level2type = N'COLUMN', @level2name = N'ServiceName';


GO
PRINT N'Creating Extended Property [dbo].[APIServiceContract].[ServiceDescription].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Service Description.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'APIServiceContract', @level2type = N'COLUMN', @level2name = N'ServiceDescription';


GO
PRINT N'Creating Extended Property [dbo].[APIServiceContract].[ServiceAvailability].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Service High Availability (HA) information.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'APIServiceContract', @level2type = N'COLUMN', @level2name = N'ServiceAvailability';


GO
PRINT N'Creating Extended Property [dbo].[APIServiceContract].[ServiceReusability].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Service Reusability - Define the capabilities that can be reused based on the nature of the API', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'APIServiceContract', @level2type = N'COLUMN', @level2name = N'ServiceReusability';


GO
PRINT N'Creating Extended Property [dbo].[APIServiceContract].[ServiceVersion].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'API Version information', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'APIServiceContract', @level2type = N'COLUMN', @level2name = N'ServiceVersion';


GO
PRINT N'Creating Extended Property [dbo].[APIServiceContract].[ServiceIdentifier].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'An Organization-wide identification scheme that logically groups providers by a common form of identification, such as a cost code, etc. Identifiers are optional descriptions.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'APIServiceContract', @level2type = N'COLUMN', @level2name = N'ServiceIdentifier';


GO
PRINT N'Creating Extended Property [dbo].[APIServiceContract].[ServiceDiscoverableURL].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'The Discovery URL is an HTTP-accessible resource that typically responds to an HTTP-GET request with technical information that describes a provider.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'APIServiceContract', @level2type = N'COLUMN', @level2name = N'ServiceDiscoverableURL';


GO
PRINT N'Creating Extended Property [dbo].[APIServiceContract].[ServiceBinding].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'A Binding is the point where a specific implementation of a service can be accessed, such as the Uniform Resource Locator (URL) where an interface can be found. Bindings may also include one or more Instance Info structures.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'APIServiceContract', @level2type = N'COLUMN', @level2name = N'ServiceBinding';


GO
PRINT N'Creating Extended Property [dbo].[APIServiceContract].[ServiceInstanceInfo].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Technical information about a binding, such as an interface specification document or Web Services Description Language (WSDL) file.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'APIServiceContract', @level2type = N'COLUMN', @level2name = N'ServiceInstanceInfo';


GO
PRINT N'Creating Extended Property [dbo].[APIServiceContract].[ServicePrimaryEndPoint].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Published API End point where applicable', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'APIServiceContract', @level2type = N'COLUMN', @level2name = N'ServicePrimaryEndPoint';


GO
PRINT N'Creating Extended Property [dbo].[APIServiceContract].[ServiceSourceSystems].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Source Systems such as Policy, Billing, Claims, Submission and other underlying source systems.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'APIServiceContract', @level2type = N'COLUMN', @level2name = N'ServiceSourceSystems';


GO
PRINT N'Creating Extended Property [dbo].[APIServiceContract].[ServiceTechnicalOwner].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Service Technical Owner', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'APIServiceContract', @level2type = N'COLUMN', @level2name = N'ServiceTechnicalOwner';


GO
PRINT N'Creating Extended Property [dbo].[APIServiceContract].[ServiceTechnicalDescription].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Service Technical Description', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'APIServiceContract', @level2type = N'COLUMN', @level2name = N'ServiceTechnicalDescription';


GO
PRINT N'Creating Extended Property [dbo].[APIServiceContract].[ServiceBusinessOwner].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Service Business Owner', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'APIServiceContract', @level2type = N'COLUMN', @level2name = N'ServiceBusinessOwner';


GO
PRINT N'Creating Extended Property [dbo].[APIServiceContract].[ServiceOperationsOwner].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Service Operations Owner', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'APIServiceContract', @level2type = N'COLUMN', @level2name = N'ServiceOperationsOwner';


GO
PRINT N'Creating Extended Property [dbo].[APIServiceContract].[ServiceScope].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Scope - Internal or External', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'APIServiceContract', @level2type = N'COLUMN', @level2name = N'ServiceScope';


GO
PRINT N'Creating Extended Property [dbo].[APIServiceContract].[ServiceSecurity].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Security - token based or Internal AD based, claims based or others', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'APIServiceContract', @level2type = N'COLUMN', @level2name = N'ServiceSecurity';


GO
PRINT N'Creating Extended Property [dbo].[ApplicationLog].[LogItemKey].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Reference Key to APIServiceContract Catalog where applicable from an API or Application flow', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ApplicationLog', @level2type = N'COLUMN', @level2name = N'LogItemKey';


GO
PRINT N'Checking existing data against newly created constraints';


GO
USE [Insights];


GO
ALTER TABLE [dbo].[APIServiceContract] WITH CHECK CHECK CONSTRAINT [FK_APIServiceContract_ServiceCatalogKey];

ALTER TABLE [dbo].[AttachmentLog] WITH CHECK CHECK CONSTRAINT [FK_AttachmentLog_SendGridLog];

ALTER TABLE [dbo].[HtmlBodyLog] WITH CHECK CHECK CONSTRAINT [FK_HtmlBodyLog_SendGridLog];

ALTER TABLE [dbo].[ParmGridLog] WITH CHECK CHECK CONSTRAINT [FK_ParmGridLog_SendGridLog];

ALTER TABLE [dbo].[PostAddressLog] WITH CHECK CHECK CONSTRAINT [FK_PostAddressLog_SendGridLog];

ALTER TABLE [dbo].[SendGridEventDetails] WITH CHECK CHECK CONSTRAINT [FK_SendGridEventDetails_SendGridEvents];

ALTER TABLE [dbo].[SendGridEvents] WITH CHECK CHECK CONSTRAINT [FK_SendGridEvents_SendGridMessages];

ALTER TABLE [dbo].[SendGridLog] WITH CHECK CHECK CONSTRAINT [FK_SendGridLog_SendGridTemplate];


GO
PRINT N'Update complete.';


GO
