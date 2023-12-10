$VPNConn = Get-VpnConnection
if ($VPNConn) {
    $VPNConnRegex = $VPNConn.Name -join '|'
    $InterfaceIPs = Get-NetIPAddress | Where-Object -Property InterfaceAlias -Match -Value $VPNConnRegex | Select-Object -Property INterfaceAlias, IPAddress

    [PSCustomObject]@{
        Name                  = $($VPNConn.Name) -creplace '(?!^)([A-Z])',' $1'
        TunnelType            = $VPNConn.TunnelType
        ConnectionStatus      = $VPNConn.ConnectionStatus
        SplitTunneling        = $VPNConn.SplitTunneling
        IPAddress             = $InterfaceIPs.IPAddress
        IdleDisconnectSeconds = $VPNConn.IdleDisconnectSeconds
    }
}
