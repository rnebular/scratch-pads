---- Script #1 - Populate database [DUMMY-AG] with simulated data using SQLCMD Mode.
-- Run script using sqlcmd command line tool.
--    sqlcmd -N -C -M -i <file>.sql
:CONNECT DUMMY-AG-L.stage.local
USE [DUMMY-AG]
GO

IF EXISTS (select * from sysobjects where name='test_table')
    DROP TABLE test_table

IF OBJECT_ID(N'dbo.test_table', N'U') IS NULL BEGIN
    CREATE TABLE dbo.test_table (
       FirstName varchar(255) not null,
       SecondName varchar(255) not null,
    );
END;

-- faking Smith Students
IF NOT EXISTS (select * from test_table where FirstName = 'John')
    INSERT INTO test_table (FirstName, SecondName) VALUES ('John','Smith')
	INSERT INTO test_table (FirstName, SecondName) VALUES ('Tommy','Smith')
GO

-- faking 25 students with the Same Name
INSERT INTO test_table (FirstName, SecondName) VALUES ('Same','Name')
GO 25

SELECT * FROM test_table
GO
