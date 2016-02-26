USE [msdb]
GO

/****** Object:  Job [Back Up Database - GEMdb]    Script Date: 02/25/2016 11:14:38 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0


/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 02/25/2016 11:14:38 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Back Up : GEMdb Database - FULL',
		@enabled=1,
		@notify_level_eventlog=0,
		@notify_level_email=0,
		@notify_level_netsend=0,
		@notify_level_page=0,
		@delete_level=0,
		@description=N'Nightly Full Backup and Rotation of the GEMdb SQL database. ',
		@category_name=N'[Uncategorized (Local)]',
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback


/****** Object:  Step [Rotate Backup]    Script Date: 02/25/2016 11:14:39 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Rotate Backup',
		@step_id=1,
		@cmdexec_success_code=0,
		@on_success_action=3,
		@on_success_step_id=0,
		@on_fail_action=2,
		@on_fail_step_id=0,
		@retry_attempts=0,
		@retry_interval=0,
		@os_run_priority=0, @subsystem=N'CmdExec',
		@command=N'C:\GEM\Backup\Rotate-GEMdb-Backups.bat',
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback


/****** Object:  Step [Database Backup]    Script Date: 02/25/2016 11:14:39 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Database Backup',
		@step_id=2,
		@cmdexec_success_code=0,
		@on_success_action=1,
		@on_success_step_id=0,
		@on_fail_action=2,
		@on_fail_step_id=0,
		@retry_attempts=0,
		@retry_interval=0,
		@os_run_priority=0, @subsystem=N'TSQL',
		@command=N'BACKUP DATABASE [GEMdb] TO  DISK = N''C:\GEM\Backup\GEMdb.bak'' WITH NOFORMAT, NOINIT,  NAME = N''GEMdb-Full Database Backup'', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
',
		@database_name=N'master',
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Daily',
		@enabled=1,
		@freq_type=4,
		@freq_interval=1,
		@freq_subday_type=1,
		@freq_subday_interval=0,
		@freq_relative_interval=0,
		@freq_recurrence_factor=0,
		@active_start_date=20111130,
		@active_end_date=99991231,
		@active_start_time=233000,
		@active_end_time=235959,
		@schedule_uid=N'81e7d27b-8370-4b51-8808-fbd2af628996'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO