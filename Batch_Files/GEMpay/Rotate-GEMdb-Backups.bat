@Echo off

if not exist c:\Gem\backup\gemdb.bak goto done

If exist C:\Gem\backup\gemdb.b04 Erase  C:\Gem\backup\gemdb.b04
If exist C:\Gem\backup\gemdb.b03 Rename C:\Gem\backup\gemdb.b03 gemdb.b04
If exist C:\Gem\backup\gemdb.b02 Rename C:\Gem\backup\gemdb.b02 gemdb.b03
If exist C:\Gem\backup\gemdb.b01 Rename C:\Gem\backup\gemdb.b01 gemdb.b02
If exist C:\Gem\backup\gemdb.bak Rename C:\Gem\backup\gemdb.bak gemdb.b01

:done