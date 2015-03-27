		@echo off
		cls
		setlocal ENABLEDELAYEDEXPANSION

::-----------------------------------------------------------------------
::		Set Global Variables
::-----------------------------------------------------------------------

	::	Configure Batch Variables
	::	[ ** Modify AS NEEDED 											** ] 
	::	[ ** Be Sure To Create Archive & ImportEmployees Directories 	** ]
	::---------------------------------------------------------
		set __SYS_ROOT=C:
		set __GEM_ROOT=D:
		set __DIR_GEM=GEM
		set __DIR_IMPEXP=ImportExport
		set __DIR_ARCH=Archive


	::	Configure Log File Variables
	::	[ ** INSERT LOG FILE NAME WITHOUT FILE EXTENTION				** ]
	::	[ ** KEEP LEADING UNDERSCORE  (e.g. _logfilename)				** ]
	::	[ ** REMOVE BRACKETS											** ]
	::---------------------------------------------------------
		set __LOG_NAME=_[FILENAME]


::-----------------------------------------------------------------------
:FileRotations
::-----------------------------------------------------------------------
		del /Q %__GEM_ROOT%\%__DIR_IMPEXP%\%DIR_ARCH%\%LOG_NAME%.log08
		if exist %__GEM_ROOT%\%__DIR_IMPEXP%\%DIR_ARCH%\%LOG_NAME%.log07 copy %__GEM_ROOT%\%__DIR_IMPEXP%\%DIR_ARCH%\%LOG_NAME%.log07 %__GEM_ROOT%\%__DIR_IMPEXP%\%DIR_ARCH%\%LOG_NAME%.log08
		if exist %__GEM_ROOT%\%__DIR_IMPEXP%\%DIR_ARCH%\%LOG_NAME%.log06 copy %__GEM_ROOT%\%__DIR_IMPEXP%\%DIR_ARCH%\%LOG_NAME%.log06 %__GEM_ROOT%\%__DIR_IMPEXP%\%DIR_ARCH%\%LOG_NAME%.log07
		if exist %__GEM_ROOT%\%__DIR_IMPEXP%\%DIR_ARCH%\%LOG_NAME%.log05 copy %__GEM_ROOT%\%__DIR_IMPEXP%\%DIR_ARCH%\%LOG_NAME%.log05 %__GEM_ROOT%\%__DIR_IMPEXP%\%DIR_ARCH%\%LOG_NAME%.log06
		if exist %__GEM_ROOT%\%__DIR_IMPEXP%\%DIR_ARCH%\%LOG_NAME%.log04 copy %__GEM_ROOT%\%__DIR_IMPEXP%\%DIR_ARCH%\%LOG_NAME%.log04 %__GEM_ROOT%\%__DIR_IMPEXP%\%DIR_ARCH%\%LOG_NAME%.log05
		if exist %__GEM_ROOT%\%__DIR_IMPEXP%\%DIR_ARCH%\%LOG_NAME%.log03 copy %__GEM_ROOT%\%__DIR_IMPEXP%\%DIR_ARCH%\%LOG_NAME%.log03 %__GEM_ROOT%\%__DIR_IMPEXP%\%DIR_ARCH%\%LOG_NAME%.log04
		if exist %__GEM_ROOT%\%__DIR_IMPEXP%\%DIR_ARCH%\%LOG_NAME%.log02 copy %__GEM_ROOT%\%__DIR_IMPEXP%\%DIR_ARCH%\%LOG_NAME%.log02 %__GEM_ROOT%\%__DIR_IMPEXP%\%DIR_ARCH%\%LOG_NAME%.log03
		if exist %__GEM_ROOT%\%__DIR_IMPEXP%\%DIR_ARCH%\%LOG_NAME%.log01 copy %__GEM_ROOT%\%__DIR_IMPEXP%\%DIR_ARCH%\%LOG_NAME%.log01 %__GEM_ROOT%\%__DIR_IMPEXP%\%DIR_ARCH%\%LOG_NAME%.log02