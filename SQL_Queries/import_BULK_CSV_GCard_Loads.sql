/*
=================================================================================================================================================
Title:		GiftCards - Bulk Import Query
-------------------------------------------------------------------------------------------------------------------------------------------------
Author:		Roger Corley
Created:	May 11, 2015 	02:12:51 PM


-------------------------------------------------------------------------------------------------------------------------------------------------
Description:
-------------------------------------------------------------------------------------------------------------------------------------------------
A set of SQL queries that will allow the technician to bulk import a series of giftcard account/badge
numbers from a .CSV file and create a batch that will assign a payment load of those cards with an
amount specified in the .CSV file.


-------------------------------------------------------------------------------------------------------------------------------------------------
Instructions:
-------------------------------------------------------------------------------------------------------------------------------------------------
1.	From the Account Numbers / Badge Numbers of Gift Cards given by the client, create an Excel
spreadsheet with the following columns. DO NOT CREATE a header row. Just the required columns
with values entered.
...............................................................................................................
	BatchID Value = 'GCLOAD'
	CoreID Value = '1'
	AccountNo Value = Account Numbers given by the client
	BadgeNo Value = Badge Numbers given by the client (there may only be one number given if badgeno matches accountno)
	TransDate = Today's date with this format: yyyy-mm-dd hh:mm:ss
	OutletNo Value = 3000
	TransID Value = 3000
	ChkNum Value = 'LOAD'
	TransTotal Value = Dollar amount desired to load on giftcards.
...............................................................................................................

2.	Save the file as a CSV with the filename of 'giftcards.csv'

3.	Copy the file to the C: drive on the SQL Server hosting GEMdb.

4.	Open SQL Management Studio and log in with 'gemuser' credentials

5.	Click 'NEW QUERY' from the top left and copy/paste this query into the window.

6.	Click 'EXECUTE' to run the query.

7.	Click the 'MESSAGES' tab next to the 'RESULTS' tab to see if any errors occurred.

8.	Log into the GEMpay website and navigate to MANAGEMENT --> BATCH CREATE/EDIT/POST

9.	Locate the GCLOAD batch and click the pushpin icon to post the batch.

10.	Spot check minimum five giftcards to verify correct load payments.

-------------------------------------------------------------------------------------------------------------------------------------------------

=================================================================================================================================================	*/

USE [GEMdb];
GO


IF (NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'GCImport'))

	BEGIN
		PRINT '[IMPORT] : The temporary table, GCImport, does not exist.'
		PRINT '[IMPORT] : Beginning bulk GiftCard Load import.'
	END

ELSE
	BEGIN
		PRINT '[ERROR] : The temporary table, GCImport, already exists.'
		PRINT '[ERROR] : Dropping existing temporary table.'

		DROP TABLE GCImport

		PRINT '[IMPORT] : Existing temporary table dropped.'
		PRINT '[IMPORT] : Beginning bulk GiftCard Load import.'
	END
GO

CREATE TABLE GCImport (
	BatchID CHAR(10) NOT NULL,
	CoreID INT NOT NULL,
	AccountNo CHAR(19) NOT NULL,
	BadgeNo CHAR(19) NOT NULL,
	TransDate DATETIME NOT NULL,
	OutletNo INT NOT NULL,
	TransID INT NOT NULL,
	ChkNum CHAR(6) NOT NULL,
	TransTotal MONEY NOT NULL
)
GO

BULK
	INSERT GCImport

	FROM 'C:\giftcards.csv'

	WITH (
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n'
	)
GO


GO
