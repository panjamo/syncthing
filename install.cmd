syncthing.exe cli operations shutdown
timeout 3
del /q /f c:\tmp\.stignore.
rmdir /s /q %LOCALAPPDATA%\Syncthing
@rem syncthing.exe generate --no-default-folder
start /min syncthing.exe serve --no-default-folder
timeout 5
syncthing.exe cli config defaults device auto-accept-folders set true
syncthing.exe cli config defaults folder rescan-intervals set 600
syncthing.exe cli config defaults device compression set always
syncthing.exe cli config defaults folder path set c:\tmp
syncthing.exe cli config devices add^
  --device-id 7VHFNSU-PMOKRFH-HDHVTXV-26I73YZ-647XTPT-524CNHG-VEUCYJK-ATCMGAI^
  --name LAPTOP-JOSCH^
  --introducer^
  --auto-accept-folders^
  --compression always
echo /*/** > c:\tmp\.stignore.
echo /BIN.zip >> c:\tmp\.stignore.
syncthing.exe cli config folders add --id TMP-%COMPUTERNAME% --path c:\tmp --label TMP-%COMPUTERNAME% --paused
