syncthing.exe cli operations shutdown
timeout 5
taskkill /F /IM syncthing.exe
rmdir /s /q %LOCALAPPDATA%\Syncthing
