-- Create new test login [testing_pikachu].
USE [master]
GO
CREATE LOGIN [testing_pikachu] WITH PASSWORD=N'<strong-password', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=ON
GO
-- Grant read access to [testing_pikachu] login.
USE [Detection]
GO
CREATE USER [testing_pikachu] FOR LOGIN [testing_pikachu]
GO
ALTER ROLE [db_datareader] ADD MEMBER [testing_pikachu]
GO
USE [EcoDWH]
GO
CREATE USER [testing_pikachu] FOR LOGIN [testing_pikachu]
GO
ALTER ROLE [db_datareader] ADD MEMBER [testing_pikachu]
GO
USE [EcoSystem]
GO
CREATE USER [testing_pikachu] FOR LOGIN [testing_pikachu]
GO
ALTER ROLE [db_datareader] ADD MEMBER [testing_pikachu]
GO
USE [EcoSystem_Massive]
GO
CREATE USER [testing_pikachu] FOR LOGIN [testing_pikachu]
GO
ALTER ROLE [db_datareader] ADD MEMBER [testing_pikachu]
GO
USE [EcoSystemEnrollment]
GO
CREATE USER [testing_pikachu] FOR LOGIN [testing_pikachu]
GO
ALTER ROLE [db_datareader] ADD MEMBER [testing_pikachu]
GO
USE [FtpContent]
GO
CREATE USER [testing_pikachu] FOR LOGIN [testing_pikachu]
GO
ALTER ROLE [db_datareader] ADD MEMBER [testing_pikachu]
GO
USE [FtpContent_Massive]
GO
CREATE USER [testing_pikachu] FOR LOGIN [testing_pikachu]
GO
ALTER ROLE [db_datareader] ADD MEMBER [testing_pikachu]
GO
USE [Heuristics]
GO
CREATE USER [testing_pikachu] FOR LOGIN [testing_pikachu]
GO
ALTER ROLE [db_datareader] ADD MEMBER [testing_pikachu]
GO
USE [ImageTrackerX]
GO
CREATE USER [testing_pikachu] FOR LOGIN [testing_pikachu]
GO
ALTER ROLE [db_datareader] ADD MEMBER [testing_pikachu]
GO
USE [ImageTrackerX_Auditing]
GO
CREATE USER [testing_pikachu] FOR LOGIN [testing_pikachu]
GO
ALTER ROLE [db_datareader] ADD MEMBER [testing_pikachu]
GO
USE [MasterFile]
GO
CREATE USER [testing_pikachu] FOR LOGIN [testing_pikachu]
GO
ALTER ROLE [db_datareader] ADD MEMBER [testing_pikachu]
GO