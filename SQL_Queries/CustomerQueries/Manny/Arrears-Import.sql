/*
=================================================================================================================================================
Title:		Arrears - Bulk Import Query
-------------------------------------------------------------------------------------------------------------------------------------------------
Author:		Roger Corley
Created:	August 24, 2015  03:41:51 PM


-------------------------------------------------------------------------------------------------------------------------------------------------
Description:
-------------------------------------------------------------------------------------------------------------------------------------------------
	A SQL script that will run after a new Arrears.csv has been created and placed in the ImportExport directory.
	This script will perform a BULK IMPORT from this .csv file into a temporary table named, ArrearsTemp. It will
	drop and recreate the current ArrearsImport table and then insert all records from ArrearsTemp into ArrearsImport.
	The script will then check if any AccountNo(s) in the current ArrearsCurrent table do not exist in the ArrearsImport table.
	If so, those AccountNo(s) will be inserted into a new copy of the ArrearsOld table. The script will then delete all
	records from the ArrearsCurrent table to start a clean import from ArrearsImport.

	After these import process are complete, the script will then SET LIMITS for accounts based on whether they exist
	in the ArrearsCurrent or ArrearsOld tables. After these processes are complete, the script will then DROP the ArrearsTemp table.

-------------------------------------------------------------------------------------------------------------------------------------------------

=================================================================================================================================================	*/

USE [GEMdb];


GO


--	Check IF the ArrearsTemp table EXISTS,
--	IF the table EXISTS, DROP ArrearsTable table before starting ArrearsImport Processes.
------------------------------------------------------------------------------------------------------
IF (NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'ArrearsTemp'))

	BEGIN
		PRINT '[IMPORT] : The temporary table, dbo.ArrearsTemp, does not exist.'
		PRINT '[IMPORT] : Beginning bulk Arrears import.'
	END

ELSE
	BEGIN
		PRINT '[MESSAGE] : The temporary table, dbo.ArrearsTemp, already exists.'
		PRINT '[MESSAGE] : Dropping existing temporary table.'

		DROP TABLE dbo.ArrearsTemp

		PRINT '[IMPORT] : Existing dbo.ArrearsTemp dropped.'
		PRINT '[IMPORT] : Beginning bulk Arrears import.'
	END


GO


--	If ArrearsTemp table DOES NOT EXIST,
--	CREATE the table before starting ArrearsImport processes.
------------------------------------------------------------------------------------------------------
CREATE TABLE ArrearsTemp (
	AccountNo CHAR(19) NOT NULL,
	LastName CHAR(20) NOT NULL,
	FirstName CHAR(15) NOT NULL,
)


GO


--	Begin BULK IMPORT of Arrears.csv file
------------------------------------------------------------------------------------------------------
BULK

	INSERT dbo.ArrearsTemp

	FROM 'C:\GEM\ImportExport\Arrears.csv'

	WITH (
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n'
	)


GO


--	IF ArrearsImport table EXISTS,
--	DROP the table before starting INSERT from ArrearsTemp.
------------------------------------------------------------------------------------------------------
	IF OBJECT_ID(N'GEMdb..ArrearsImport') IS NOT NULL
		BEGIN
		PRINT '[MESSAGE] : ArrearsImport exists'
			DROP TABLE ArrearsImport
		PRINT '[MESSAGE] : ArrearsImport table dropped.'
		END
	ELSE
		BEGIN
		PRINT '[MESSAGE] : ArrearsImport does not exist'
		PRINT '[IMPORT] : Beginning ArrearsImport Processing'
		END


GO


--	BEGIN INSERT from ArrearsTemp INTO ArrearsImport table
------------------------------------------------------------------------------------------------------
	DECLARE @importDate datetime;
	SET		@importDate = GETDATE();

	SELECT AccountNo, LastName, FirstName, @importDate AS [ImportDate]
		INTO dbo.ArrearsImport
	FROM dbo.ArrearsTemp


GO


--	IF ArrearsOld table EXISTS,
--	DROP the table before starting import processes.
------------------------------------------------------------------------------------------------------
	IF (NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'ArrearsOld'))
		BEGIN
			PRINT '[IMPORT] : The temporary table, dbo.ArrearsOld, does not exist.'
			PRINT '[IMPORT] : Beginning bulk Arrears import.'
		END

	ELSE
		BEGIN
			PRINT '[MESSAGE] : The temporary table, dbo.ArrearsOld, already exists.'
			PRINT '[MESSAGE] : Dropping existing dbo.ArrearsOld table.'

				DROP TABLE dbo.ArrearsOld

			PRINT '[IMPORT] : Existing dbo.ArrearsOld dropped.'
			PRINT '[IMPORT] : Beginning bulk Arrears import.'
		END


GO


--	CREATE TABLE ArrearsOld.
--	This table will store accounts that existed in ArrearsCurrent but are no longer in arrears.
------------------------------------------------------------------------------------------------------
	CREATE TABLE ArrearsOld (
		AccountNo CHAR(19) NOT NULL,
		LastName CHAR(20) NOT NULL,
		FirstName CHAR(15) NOT NULL,
		ImportDate DATETIME NULL
	)


GO


--	WHERE AccountNo EXISTS IN ArrearsCurrent BUT NOT EXISTS IN ArrearsImport,
--	INSERT into ArrearsOld table. After this process, DELETE ALL records from ArrearsCurrent
--	to start a clean current import.
------------------------------------------------------------------------------------------------------
	INSERT ArrearsOld (AccountNo, LastName, FirstName, ImportDate)
		SELECT *
		FROM ArrearsCurrent AS C
		WHERE C.AccountNo NOT IN (SELECT AccountNo FROM ArrearsImport)

	DELETE FROM ArrearsCurrent


GO


--	INSERT INTO ArrearsCurrent table ALL records from current ArrearsImport table.
------------------------------------------------------------------------------------------------------
	INSERT INTO ArrearsCurrent
		SELECT *
		FROM ArrearsImport


GO


------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
--	[ SCRIPT PROCESSES ] : SET BALANCE BUCKET LIMITS
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------


--	If AccountNo EXISTS IN ArrearsCurrent table,
--	SET Limit (Balance Buckets) to '0.00' for ALL TTLs
------------------------------------------------------------------------------------------------------
	UPDATE tblAccountTTL
		SET Limit = '0.00'
		WHERE AccountNo IN (SELECT AccountNo FROM ArrearsCurrent)


GO


--	If AccountNo EXISTS IN ArrearsOld table,
--	SET LIMITs for TransClassIDs (20, 30, 70, 80, 100) to '400.00'
------------------------------------------------------------------------------------------------------
	UPDATE tblAccountTTL
		SET Limit = '400.00'
		WHERE AccountNo IN (SELECT AccountNo FROM ArrearsOld) AND TransClassID IN (20,30,70,80,100)


GO


--	If AccountNo EXISTS IN ArrearsOld table,
--	SET LIMITs for TransClassIDs (10, 110) to '999999.00' (Unlimited)
------------------------------------------------------------------------------------------------------
	UPDATE tblAccountTTL
		SET Limit = '999999.00'
		WHERE AccountNo IN (SELECT AccountNo FROM ArrearsOld) AND TransClassID IN (10,110)


GO


--	After all processes are complete,
--	DROP the ArrearsTemp table
------------------------------------------------------------------------------------------------------
	DROP TABLE ArrearsTemp


FINISH: