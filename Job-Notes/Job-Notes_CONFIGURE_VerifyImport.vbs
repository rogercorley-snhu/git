Job Notes
================================================================

-- Created / Configured VerifyImport__01310.vbs and saved to the new _Scripts directory

-- Created new _Bad-Records, _Good-Records, and _Logs directories for this process

-- Modified ImportOrangePark.bat to include the wscript to call VerifyImport

-- Reconfigured cgScriptParams in SQL to point to _Good-Records\Good-Import-01310.csv for both the ImportFile and ImportSource

-- Set the ImportPostProc to ie_Import_v3_60

--- Tested and it worked