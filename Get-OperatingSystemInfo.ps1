$OperatingSystem =
Get-CimInstance -ClassName CIM_OperatingSystem
$Uptime =
[timespan]((Get-Date) - $OperatingSystem.LastBootUpTime)
$DayString = if ($Uptime.Days -eq 1) { 'Day' }else { 'Days' }
$HourString = if ($Uptime.Hours -eq 1) { 'Hour' }else { 'Hours' }
$MinuteString = if ($Uptime.Minutes -eq 1) { 'Minute' }else { 'Minutes' }
$UptimeString =
'{0} {1} {2} {3} {4} {5}' -f $Uptime.Days, $DayString, $Uptime.Hours, $HourString, $Uptime.Minutes, $MinuteString

$WindowsBuild =
try {
    (Get-ItemProperty -Path 'REGISTRY::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name DisplayVersion -ea Stop).DisplayVersion
}
catch {
    (Get-ItemProperty -Path 'REGISTRY::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name ReleaseID).ReleaseID
}
$DiskList = Get-CimInstance -ClassName CIM_LogicalDisk | Where-Object { $_.DriveType -gt 2 }


$OSInfoHash = 
[ordered]@{
    HostName        = $OperatingSystem.CSName
    OperatingSystem = $OperatingSystem.Caption
    OSArchitecture  = $OperatingSystem.OSArchitecture
    Version         = $OperatingSystem.Version
    ReleaseID       = $WindowsBuild
    InstallDate     = $OperatingSystem.InstallDate
    LastBootUpTime  = $OperatingSystem.LastBootUpTime
    UpTime          = $UptimeString
}


foreach ($Disk in $DiskList) {
    $OSInfoHash.Add("HDD $($Disk.DeviceID) / $($Disk.VolumeName)", $("Size: {0,6:n0} GB - FreeSpace: {1:n0} GB" -f ($Disk.Size / 1GB), ($Disk.FreeSpace / 1GB)))
}
[PSCustomObject]$OSInfoHash