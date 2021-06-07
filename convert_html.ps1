$OSinfo = Get-CimInstance -ClassName Win32_OperatingSystem | ConvertTo-Html -Property Version,Caption,BuildNumber,Manufacturer -Fragment
$OSProcess = Get-CimInstance -ClassName Win32_Processor | ConvertTo-Html -Property DeviceId,Name,Caption,MaxClockSpeed,SocketDesignation -Fragment
$Report = ConvertTo-HTML -Body "$OSinfo $OSProcess" -Title "Descritivo PC"
$Report | Out-File ./OCS.html