syncthing.exe cli operations shutdown

timeout 3

rmdir /s /q %LOCALAPPDATA%\Syncthing
@rem syncthing.exe generate --no-default-folder
start /min syncthing.exe serve --no-default-folder

timeout 5

syncthing.exe cli config defaults device auto-accept-folders set true
syncthing.exe cli config defaults folder rescan-intervals set 600
syncthing.exe cli config defaults device compression set always
syncthing.exe cli config defaults folder path set c:\tmp

syncthing.exe cli config devices add^
  --device-id W4VTQIB-HAI2DHP-6ZCI5XD-EOV6NNI-3PGCRJJ-4MNHZ53-QKNXFF2-GA23HAN^
  --name LAPTOP-JOSCH^
  --introducer^
  --auto-accept-folders^
  --compression always
  
mkdir c:\tmp
del /A:H /q /f c:\tmp\.stignore
echo // !/DebugTools/syncthing-excutables/install.cmd>>c:\tmp\.stignore
echo // /DebugTools/syncthing-excutables>>c:\tmp\.stignore
echo // /DebugTools/everything*/>>c:\tmp\.stignore
echo // /DebugTools/doublecmd/>>c:\tmp\.stignore
echo // /DebugTools/Everything-1.4.1.1009.x64/>>c:\tmp\.stignore
echo /*/**>>c:\tmp\.stignore
echo /BIN.zip>>c:\tmp\.stignore
echo /*.dmp>>c:\tmp\.stignore
syncthing.exe cli config folders add --id TMP-%COMPUTERNAME% --path c:\tmp --label TMP-%COMPUTERNAME% --paused

powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut([Environment]::GetFolderPath('Desktop')+'\Syncthing.lnk');$s.TargetPath='%CD%\syncthing.exe';$s.Save()"

@REM https://docs.syncthing.net/rest/config.html
@REM https://www.mankier.com/7/syncthing-rest-api

@REM @curl -H "X-API-Key: iVPAH5Vi7VTmdoJKiyxsRZc4MTfzk7qy" -X POST http://127.0.0.1:8384/rest/db/scan
@REM @curl -H "X-API-Key: iVPAH5Vi7VTmdoJKiyxsRZc4MTfzk7qy" -X GET http://127.0.0.1:8384/rest/config/devices
@REM @curl -H "X-API-Key: 3JCpWS9zsve5HFyMxryvGRETaRZATbTo" -X PATCH http://127.0.0.1:8384/rest/config/devices/W4VTQIB-HAI2DHP-6ZCI5XD-EOV6NNI-3PGCRJJ-4MNHZ53-QKNXFF2-GA23HAN -H 'Content-Type: application/json' -d "{""addresses"": [""dynamic""]}"
@REM @curl -H "X-API-Key: 3JCpWS9zsve5HFyMxryvGRETaRZATbTo" -X PATCH http://127.0.0.1:8384/rest/config/devices/W4VTQIB-HAI2DHP-6ZCI5XD-EOV6NNI-3PGCRJJ-4MNHZ53-QKNXFF2-GA23HAN -H 'Content-Type: application/json' -d "{""paused"": ""true""}"


