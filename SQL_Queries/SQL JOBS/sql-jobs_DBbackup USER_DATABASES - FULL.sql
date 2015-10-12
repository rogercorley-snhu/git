--  STEP NAME:  GEMdb_DBbackup USER_DATABASES_FULL
--  TYPE: Operating System (CmdExec)
--  RUN AS:  SQL Server Agent Service Account




sqlcmd -E -S $(ESCAPE_SQUOTE(SRVR)) -d master -Q "EXECUTE [dbo].[DatabaseBackup] @Databases = 'ALL_DATABASES', @Directory = N'T:\Backup', @BackupType = 'FULL', @Verify = 'Y', @CleanupTime = 24, @CheckSum = 'Y', @LogToTable = 'Y'" -b


-- ADVANCED
--  On Success:  Quit Job Reporting Success
-- On Failure : Quit Job Reporting Failure
--  Output File: S:\Data\MSSQL10_50.MSSQLSERVER\MSSQL\Log\DatabaseBackup_$(ESCAPE_SQUOTE(JOBID))_$(ESCAPE_SQUOTE(STEPID))_$(ESCAPE_SQUOTE(STRTDT))_$(ESCAPE_SQUOTE(STRTTM)).txt




-----------------------------------------------------------------------------------------------------------------------


USE [msdb]
GO

/****** Object:  Job [WakeMed - DBbackup ALL_DATABASES - FULL]    Script Date: 10/07/2015 12:04:38 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [Database Maintenance]    Script Date: 10/07/2015 12:04:38 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'Database Maintenance' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'Database Maintenance'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'WakeMed - DBbackup ALL_DATABASES - FULL',
		@enabled=1,
		@notify_level_eventlog=2,
		@notify_level_email=0,
		@notify_level_netsend=0,
		@notify_level_page=0,
		@delete_level=0,
		@description=N'Source: WakeMed DBA Scripting',
		@category_name=N'Database Maintenance',
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [WakeMed - DBbackup USER_DATABASES - FULL]    Script Date: 10/07/2015 12:04:38 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'WakeMed - DBbackup USER_DATABASES - FULL',
		@step_id=1,
		@cmdexec_success_code=0,
		@on_success_action=1,
		@on_success_step_id=0,
		@on_fail_action=2,
		@on_fail_step_id=0,
		@retry_attempts=0,
		@retry_interval=0,
		@os_run_priority=0, @subsystem=N'CmdExec',
		@command=N'sqlcmd -E -S $(ESCAPE_SQUOTE(SRVR)) -d master -Q "EXECUTE [dbo].[DatabaseBackup] @Databases = ''ALL_DATABASES'', @Directory = N''T:\Backup'', @BackupType = ''FULL'', @Verify = ''Y'', @CleanupTime = 24, @CheckSum = ''Y'', @LogToTable = ''Y''" -b',
		@output_file_name=N'S:\Data\MSSQL10_50.MSSQLSERVER\MSSQL\Log\DatabaseBackup_$(ESCAPE_SQUOTE(JOBID))_$(ESCAPE_SQUOTE(STEPID))_$(ESCAPE_SQUOTE(STRTDT))_$(ESCAPE_SQUOTE(STRTTM)).txt',
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


