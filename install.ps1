Start-Process -FilePath '.\syncthing.exe' -ArgumentList 'cli operations shutdown' -Wait
Start-Sleep -Seconds 3
Remove-Item -LiteralPath ($env:LOCALAPPDATA + '\Syncthing') -Force -Recurse
Start-Process -FilePath '.\syncthing.exe'  -WindowStyle Minimized -ArgumentList 'serve --no-default-folder'
Start-Sleep -Seconds 3
# Start-Process -FilePath '.\syncthing.exe' -ArgumentList 'cli operations shutdown' -Wait
[XML]$config = Get-Content ($env:LOCALAPPDATA + '\Syncthing\config.xml')
#$config.configuration.gui.apikey = "iVPAH5Vi7VTmdoJKiyxsRZc4MTfzk7qy"
#$config.save($env:LOCALAPPDATA + '\Syncthing\config.xml')
# & .\syncthing.exe cli operations shutdown
#Start-Process -FilePath '.\syncthing.exe'  -WindowStyle Minimized -ArgumentList 'serve --no-default-folder'
#Start-Sleep -Seconds 5

& .\syncthing.exe cli config defaults device auto-accept-folders set true
& .\syncthing.exe cli config defaults folder rescan-intervals set 600
& .\syncthing.exe cli config defaults device compression set always
& .\syncthing.exe cli config defaults folder path set c:\tmp

$device = @'
{
    "deviceID": "VRBIB4S-MTKWVLA-5YCETVO-NDTGBW2-E7KONTA-QDHDDCG-G6LPGIU-YYUFEAL",
    "name": "JOSCH-LAPTOP",
    "addresses": [
        "tcp://panjamo.selfhost.eu:22000",
        "quic://panjamo.selfhost.eu:22000",
        "dynamic"
        ],
    "compression": "always",
    "certName": "",
    "introducer": true,
    "skipIntroductionRemovals": false,
    "introducedBy": "",
    "paused": false,
    "allowedNetworks": [],
    "autoAcceptFolders": true,
    "maxSendKbps": 0,
    "maxRecvKbps": 0,
    "ignoredFolders": [],
    "maxRequestKiB": 0,
    "untrusted": false,
    "remoteGUIPort": 0
  }
'@

Invoke-WebRequest `
-Uri "http://127.0.0.1:8384/rest/config/devices/VRBIB4S-MTKWVLA-5YCETVO-NDTGBW2-E7KONTA-QDHDDCG-G6LPGIU-YYUFEAL" `
-body $device -Method "PUT" -ContentType "application/json" -Headers @{ "X-API-Key" = $config.configuration.gui.apikey }

$s=(New-Object -COM WScript.Shell).CreateShortcut([Environment]::GetFolderPath('Desktop')+'\Syncthing1.lnk');$s.TargetPath=((Get-Location).ToString()+'\syncthing.exe');$s.Save()


# syncthing.exe cli config devices add^
#   --device-id W4VTQIB-HAI2DHP-6ZCI5XD-EOV6NNI-3PGCRJJ-4MNHZ53-QKNXFF2-GA23HAN^
#   --name LAPTOP-JOSCH^
#   --introducer^
#   --auto-accept-folders^
#   --compression always
  
# mkdir c:\tmp
# del /A:H /q /f c:\tmp\.stignore
# echo // !/DebugTools/syncthing-excutables/install.cmd>>c:\tmp\.stignore
# echo // /DebugTools/syncthing-excutables>>c:\tmp\.stignore
# echo // /DebugTools/everything*/>>c:\tmp\.stignore
# echo // /DebugTools/doublecmd/>>c:\tmp\.stignore
# echo // /DebugTools/Everything-1.4.1.1009.x64/>>c:\tmp\.stignore
# echo /*/**>>c:\tmp\.stignore
# echo /BIN.zip>>c:\tmp\.stignore
# echo /*.dmp>>c:\tmp\.stignore
# syncthing.exe cli config folders add --id TMP-%COMPUTERNAME% --path c:\tmp --label TMP-%COMPUTERNAME% --paused

# @REM https://docs.syncthing.net/rest/config.html
# @REM https://www.mankier.com/7/syncthing-rest-api

# @REM @curl -H "X-API-Key: iVPAH5Vi7VTmdoJKiyxsRZc4MTfzk7qy" -X POST http://127.0.0.1:8384/rest/db/scan
# @REM @curl -H "X-API-Key: iVPAH5Vi7VTmdoJKiyxsRZc4MTfzk7qy" -X GET http://127.0.0.1:8384/rest/config/devices
# @REM @curl -H "X-API-Key: 3JCpWS9zsve5HFyMxryvGRETaRZATbTo" -X PATCH http://127.0.0.1:8384/rest/config/devices/W4VTQIB-HAI2DHP-6ZCI5XD-EOV6NNI-3PGCRJJ-4MNHZ53-QKNXFF2-GA23HAN -H 'Content-Type: application/json' -d "{""addresses"": [""dynamic""]}"
# @REM @curl -H "X-API-Key: 3JCpWS9zsve5HFyMxryvGRETaRZATbTo" -X PATCH http://127.0.0.1:8384/rest/config/devices/W4VTQIB-HAI2DHP-6ZCI5XD-EOV6NNI-3PGCRJJ-4MNHZ53-QKNXFF2-GA23HAN -H 'Content-Type: application/json' -d "{""paused"": ""true""}"









# curl -H "X-API-Key: iVPAH5Vi7VTmdoJKiyxsRZc4MTfzk7qy" `
# -X PATCH http://127.0.0.1:8384/rest/config/devices/64HAS4W-H3OCIIC-6RHPVTF-XFFBCHP-H3BOOTZ-PTYAW5L-RKD2E4Y-WNNGOAY `
# -H 'Content-Type: application/json' `
# -d '{"paused": true}'

# curl -H "X-API-Key: iVPAH5Vi7VTmdoJKiyxsRZc4MTfzk7qy" `
# -X PATCH http://127.0.0.1:8384/rest/config/devices/64HAS4W-H3OCIIC-6RHPVTF-XFFBCHP-H3BOOTZ-PTYAW5L-RKD2E4Y-WNNGOAY `
# -H 'Content-Type: application/json' `
# -d @'
# {
#     "addresses": [
#       "tcp://panjamo.selfhost.eu:22000"
#     ]
#   }
# '@

# & curl -H "X-API-Key: iVPAH5Vi7VTmdoJKiyxsRZc4MTfzk7qy" `
# -X PUT http://127.0.0.1:8384/rest/config/devices/64HAS4W-H3OCIIC-6RHPVTF-XFFBCHP-H3BOOTZ-PTYAW5L-RKD2E4Y-WNNGOAY `
# -H 'Content-Type: application/json' `
# -d @'
# {
#     "deviceID": "64HAS4W-H3OCIIC-6RHPVTF-XFFBCHP-H3BOOTZ-PTYAW5L-RKD2E4Y-WNNGOAY",
#     "name": "Pixel 5",
#     "addresses": [
#       "tcp://127.0.0.1:4545"
#     ],
#     "compression": "always",
#     "certName": "",
#     "introducer": false,
#     "skipIntroductionRemovals": false,
#     "introducedBy": "",
#     "paused": false,
#     "allowedNetworks": [],
#     "autoAcceptFolders": false,
#     "maxSendKbps": 0,
#     "maxRecvKbps": 0,
#     "ignoredFolders": [],
#     "maxRequestKiB": 0,
#     "untrusted": false,
#     "remoteGUIPort": 0
#   }
# '@

# # curl -H "X-API-Key: iVPAH5Vi7VTmdoJKiyxsRZc4MTfzk7qy" `
# #     -X GET http://127.0.0.1:8384/rest/config/devices/64HAS4W-H3OCIIC-6RHPVTF-XFFBCHP-H3BOOTZ-PTYAW5L-RKD2E4Y-WNNGOAY
 
# # curl -H "X-API-Key: iVPAH5Vi7VTmdoJKiyxsRZc4MTfzk7qy" -X GET http://127.0.0.1:8384/rest/config/devices    