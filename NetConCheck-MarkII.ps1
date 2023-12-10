$Config = Import-PowerShellDataFile -Path $($MyInvocation.MyCommand.Definition).Replace('.ps1', '.psd1')


Push-Location -Path (Split-Path -Path $MyInvocation.MyCommand.Definition -parent)

. .\ConvertTo-TransposedData.ps1
$HWInfo = .\Get-ComputerInfo.ps1
$OSInfo = .\Get-OperatingSystemInfo.ps1
$VPNInfo = .\Get-VpnConnection.ps1
$NICInfo = .\Get-NetworkInterfaceController.ps1
$UserInfo = .\Get-UserInfo.ps1
$CSS = Get-Item .\style.css
$TimeStamp = Get-Date -Format 'yyyy-MM-dd_HH-mm-ss'
$outFile = Join-Path -Path $Env:APPDATA -ChildPath ($ENV:COMPUTERNAME + '_'+ $TimeStamp + '.html')
$LogPath = $Config.LogPath
$RSOPFile = Join-Path -Path $LogPath -ChildPath ($ENV:COMPUTERNAME + '_'+ $TimeStamp + '.txt')
$LogPathAccess = Test-Path -Path $LogPath -PathType Container
if ($LogPathAccess) {
    Start-Process -FilePath $ENV:ComSpec -ArgumentList '/c gpresult /r' -RedirectStandardOutput $RSOPFile -WindowStyle Hidden
}

$HWHTML = 
    $HWInfo | 
        ConvertTo-Html -As List -Fragment -PreContent $Config.HWPreContent -PostContent $Config.PostContent
$OSHTML = 
    $OSInfo | 
        ConvertTo-Html -As List -Fragment -PreContent $Config.OSPreContent -PostContent $Config.PostContent
$NICHTML = 
    ConvertTo-TransposedData -InputData $NICInfo -PrimaryKey Name -Label Name | 
        Select-Object -ExcludeProperty Name -Property @{Name = 'Name'; Expression = { $_.Name.substring(2) } }, * | 
            # remove the leading sorting numbers prior to the output
            ConvertTo-Html -As Table -Fragment -PreContent $Config.NICPreContent -PostContent $Config.PostContent
$VPNHTML = 
    $VPNInfo | 
        ConvertTo-Html -As List -Fragment -PreContent $Config.VPNPreContent -PostContent $Config.PostContent
$UserHTML = 
    $UserInfo |
        ConvertTo-Html -As List -Fragment -PreContent $Config.UserPreContent -PostContent $Config.PostContent

$ConvertToThmlParams = @{
    Body        = "<div class=""flexbox-container""> $HWHTML $OSHTML $NICHTML $VPNHTML $UserHTML </div>"
    Title       = 'NetConCheck MARK II'
    CssUri      = $CSS.FullName
}

ConvertTo-Html @ConvertToThmlParams | Out-File -FilePath $outFile
Invoke-Item -Path $outFile
if ($LogPathAccess) {
    Copy-Item -Path $outFile -Destination $LogPath
}
