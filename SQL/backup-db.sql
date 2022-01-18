USE [master]
GO
EXECUTE AS LOGIN='sa';
GO
BACKUP DATABASE [<db_name>]
TO DISK='<path_here>'
WITH  INIT
     ,FORMAT
     ,STATS=5
GO