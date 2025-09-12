SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
USE [Insights];


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
PRINT N'Creating View [dbo].[NotificationWithSiteChange]...';


GO
CREATE VIEW [dbo].[NotificationWithSiteChange] AS
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
PRINT N'Update complete.';


GO

