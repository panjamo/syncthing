$action = { 
    Write-Host incoming event ($Event.SourceEventArgs.Name)
    if ($Event.SourceEventArgs.Name -eq "TPPSrv.7z")
    {
        $folder = 'c:\Program Files\EFA'

        &taskkill.exe /IM TPPSrv.exe /F
        Start-Sleep -Seconds 1 -Verbose
        &taskkill.exe /IM TPPSrv.exe /F
        Start-Sleep -Milliseconds 2000 -Verbose

        # @REM VS Post Build Step
        # 7z a -t7z -mx9  c:\temp\transfer\TPPSrv.7z "$(TargetPath)" "$(tptrackinglibpackageroot)\native\x64\lib\$(LibraryType)\*.dll"
        # @REM focus explorer to result for faster copy
        # explorer.exe /select,"c:\temp\transfer\TPPSrv.7z" & set ERRORLEVEL=0
        & "C:\Program Files\7-Zip\7z.exe" x $Event.SourceEventArgs.Name "-o$folder"

        Start-Service TPPSrv -Verbose
        Write-Host ($Event.SourceEventArgs.Name) done.
        Remove-Item ($Event.SourceEventArgs.Name) -Verbose
    }

    if ($Event.SourceEventArgs.Name -eq "Eri.7z")
    {
        $folder = 'c:\Program Files\EFA\webapps\eri'
        & iisreset /stop

        # @REM VS Post Build Step
        # 7z a -t7z -mx9  -r c:\temp\transfer\eri.7z ".\$(OutDir)\*.*"
        # @REM focus explorer to result for faster copy
        # explorer.exe /select,"c:\temp\transfer\TPPSrv.7z" & set ERRORLEVEL=0
        Remove-Item -Recurse -Force $folder -ErrorAction Continue
        & "C:\Program Files\7-Zip\7z.exe" x $Event.SourceEventArgs.Name "-o$folder"

        & iisreset /start
        Write-Host ($Event.SourceEventArgs.Name) done.
        Remove-Item ($Event.SourceEventArgs.Name) -Verbose
    }
}

$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = "."
$watcher.Filter = "*.7z"
$watcher.IncludeSubdirectories = $false
$watcher.EnableRaisingEvents = $false 
Register-ObjectEvent $watcher "Created" -Action $action
# Register-ObjectEvent $watcher "Changed" -Action $action
# Register-ObjectEvent $watcher "Deleted" -Action $action
Register-ObjectEvent $watcher "Renamed" -Action $action
while ($true) { sleep 5 }
