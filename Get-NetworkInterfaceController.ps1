$IPConfigList = Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration 
$NICList = Get-NetAdapter -Physical |
Where-Object { $_.Status -ne 'Not Present' } | 
ForEach-Object { 
    $NetAdapter = $_
    $IPConfig = $IPConfigList | Where-Object {
        ($NetAdapter.MACAddress -replace '-') -eq ($_.MACAddress -replace ':')
    }

    $NIC = 
    [ordered]@{
        Name                 = $NetAdapter.Name
        '01IPAddress'            = ($IPConfig.IPAddress | Select-Object -First 1)
        '02SubnetMask'           = ($IPConfig.IPSubnet | Select-Object -First 1)
        '03DefaultGateway'       = ($IPConfig.DefaultIPGateway | Select-Object -First 1)
        '04DHCPServer'           = $IPConfig.DHCPServer -join ' '
        '05DNSHostName'          = $IPConfig.DNSHostName -join ' '
        '06DNSDomain'            = $IPConfig.DNSDomain -join ' '
        '07DNSServerSearchOrder' = ($IPConfig.DNSServerSearchOrder -join ', ')
        '08MacAddress'           = $NetAdapter.MacAddress
        '09NICType'              = $NetAdapter.InterfaceDescription
        '10LinkSpeed'            = $NetAdapter.LinkSpeed
        '11Status'               = $NetAdapter.Status
    }

    [PSCustomObject]$NIC
}

$NICList
