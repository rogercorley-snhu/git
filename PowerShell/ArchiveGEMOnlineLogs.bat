@echo off
set DATESTAMP=%DATE:~10,4%_%DATE:~4,2%_%DATE:~7,2%


if exist c:\gemonline.log move c:\gemonline.log %1\gemonline1_%DATESTAMP%.log

echo . >> gemonline.log