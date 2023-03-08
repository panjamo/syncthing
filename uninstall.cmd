syncthing.exe cli operations shutdown
timeout 5
taskkill /F /IM syncthing.exe
del %USERPROFILE%\Desktop\Syncthing.lnk
@REM rmdir /s /q %LOCALAPPDATA%\Syncthing
