$ComputerSystem =
Get-CimInstance -ClassName CIM_ComputerSystem

$Bios =
Get-CimInstance -ClassName CIM_BIOSElement

$HW = Get-CimInstance -ClassName Win32_Processor

$OSInfo = 
[ordered]@{
    Manufacturer   = $ComputerSystem.Manufacturer
    Type           = $ComputerSystem.SystemFamily
    Model          = $ComputerSystem.Model
    Serialnumber   = $Bios.SerialNumber
    BIOSVersion    = $Bios.SMBIOSBIOSVersion
    BIOSDate       = $Bios.ReleaseDate
    Processor      = $HW.Name
    PhysicalCores  = $HW.NumberOfCores
    LogicalCores   = $HW.NumberOfLogicalProcessors
    PhysicalMemory = ('{0:n2} GB' -f ($ComputerSystem.TotalPhysicalMemory / 1GB))
}
[PSCustomObject]$OSInfo
