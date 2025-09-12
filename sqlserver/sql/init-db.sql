CREATE DATABASE [Insights]
CONTAINMENT = NONE
ON PRIMARY
(
  NAME = N'Insights',
  FILENAME = N'/var/opt/mssql/data/Insights.mdf',
  SIZE = 8192KB,
  MAXSIZE = UNLIMITED,
  FILEGROWTH = 65536KB
)
LOG ON
(
  NAME = N'Insights_log',
  FILENAME = N'/var/opt/mssql/data/Insights_log.ldf',
  SIZE = 8192KB,
  MAXSIZE = 2048GB,
  FILEGROWTH = 65536KB
)
WITH CATALOG_COLLATION = DATABASE_DEFAULT;
GO
