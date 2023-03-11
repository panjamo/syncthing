# @REM https://docs.syncthing.net/rest/config.html
# @REM https://www.mankier.com/7/syncthing-rest-api

[XML]$config = Get-Content ('.\config\config.xml')

Invoke-WebRequest `
    -Uri "http://127.0.0.1:8384/rest/system/shutdown" `
    -Method "POST" `
    -Headers @{ "X-API-Key" = $config.configuration.gui.apikey }

Start-Sleep -Seconds 3

Remove-Item  ([Environment]::GetFolderPath('Desktop')+'\Syncthing.lnk')
Remove-Item '.\config' -Force -Recurse -ErrorAction SilentlyContinue

New-Item -Path '.\config' -ItemType Directory -ErrorAction SilentlyContinue

Start-Process -FilePath '.\syncthing.exe'  -WindowStyle Minimized -ArgumentList 'serve --no-default-folder --home=.\config'
Start-Sleep -Seconds 3

[XML]$config = Get-Content ('.\config\config.xml')
$defaultFolder = (Invoke-WebRequest -Uri "http://127.0.0.1:8384/rest/config/defaults/folder"  -Method "GET"  -Headers @{ "X-API-Key" = $config.configuration.gui.apikey }) | ConvertFrom-Json
$defaultFolder.rescanIntervalS = 600
$defaultFolder.path = 'c:\tmp'
$defaultFolder.order = 'smallestFirst'
Invoke-WebRequest `
    -Uri "http://127.0.0.1:8384/rest/config/defaults/folder" `
    -Method "PUT" `
    -Headers @{ "X-API-Key" = $config.configuration.gui.apikey } `
    -body ($defaultFolder | ConvertTo-Json)


$defaultDevice = (Invoke-WebRequest -Uri "http://127.0.0.1:8384/rest/config/defaults/device"  -Method "GET"  -Headers @{ "X-API-Key" = $config.configuration.gui.apikey }) | ConvertFrom-Json
$defaultDevice.autoAcceptFolders = $true
$defaultDevice.compression = 'always'
Invoke-WebRequest `
    -Uri "http://127.0.0.1:8384/rest/config/defaults/device" `
    -Method "PUT" `
    -Headers @{ "X-API-Key" = $config.configuration.gui.apikey } `
    -body ($defaultDevice | ConvertTo-Json) `

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

$s=(New-Object -COM WScript.Shell).CreateShortcut([Environment]::GetFolderPath('Desktop')+'\Syncthing.lnk');
$s.TargetPath=((Get-Location).ToString()+'\syncthing.exe');
$s.Arguments='--home='+(Get-Location).ToString()+'\config'
$s.Save()

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


# Events einfangen und darauf reagieren
# https://manpages.ubuntu.com/manpages/bionic/man7/syncthing-event-api.7.html
# (Invoke-WebRequest -Uri "http://127.0.0.1:8384/rest/events?events=DeviceRejected&since=40"  -Method "GET"  -Headers @{ "X-API-Key" = $config.configuration.gui.apikey }) | ConvertFrom-Json

# [
    # {
    # "id": 40,
    # "globalID": 1751,
    # "time": "2023-03-12T00:24:01.8040928+01:00",
    # "type": "DeviceRejected",
    # "data": {
    #   "address": "20.3.109.80:1025",
    #   "device": "VIJPBYI-WX4TB7J-OYCPMYL-UI57P5T-FZJTLL6-F2WKXMD-HDJ3KD6-X5FQUQG",
    #   "name": "rwrktstnw00000Z"
    # }
#   }
# ]

# $device = @'
# {
#     "deviceID": "VIJPBYI-WX4TB7J-OYCPMYL-UI57P5T-FZJTLL6-F2WKXMD-HDJ3KD6-X5FQUQG",
#     "name": "rwrktstnw00000Z"
# }
# '@

# Invoke-WebRequest `
# -Uri "http://127.0.0.1:8384/rest/config/devices/VIJPBYI-WX4TB7J-OYCPMYL-UI57P5T-FZJTLL6-F2WKXMD-HDJ3KD6-X5FQUQG" `
# -body $device -Method "PUT" -ContentType "application/json" -Headers @{ "X-API-Key" = $config.configuration.gui.apikey }



