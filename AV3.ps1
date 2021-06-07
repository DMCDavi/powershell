function Get-PC-Name {
    Get-CimInstance -ClassName Win32_ComputerSystem | ConvertTo-HTML -Property Name -Fragment
}
