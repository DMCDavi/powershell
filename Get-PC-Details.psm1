
function Get-PC-Name {
    Get-CimInstance -ClassName Win32_ComputerSystem | ConvertTo-HTML -Property Name -Fragment
}

function Get-Services {

    param(
        [string] $Status,
        [int] $Quantity,
        $Properties
    )

    Get-Service * | Where { $_.Status -eq $Status } | Select-Object -First $Quantity | ConvertTo-HTML -Property $Properties -Fragment
}

function Get-OS-Info {

    param(
        $Properties
    )

    Get-CimInstance -ClassName Win32_OperatingSystem | ConvertTo-HTML -Property $Properties -Fragment
}

function Get-BIOS-Info {

    param(
        $Properties
    )

    Get-CimInstance -ClassName Win32_BIOS | ConvertTo-HTML -Property $Properties -Fragment
}

function Get-Mem-Info {

    param(
        $Properties
    )

    Get-CimInstance -ClassName Win32_PhysicalMemory | ConvertTo-HTML -Property $Properties -Fragment
}

function Get-Disk-Info {

    param(
        $Properties
    )

    Get-Disk | ConvertTo-HTML -Property $Properties -Fragment
}

function Generate-HTML {

    param(
        [string] $Title,
        [string] $Body,
        $File
    )

    ConvertTo-HTML -Body $Body -Title $Title | Out-File $File
}

function Get-PC-Details{
    $PCName = Get-PC-Name
    $ServicesRunning = Get-Services -Status 'Running' -Quantity 5 -Properties Name,DisplayName,ServiceName,Status
    $ServicesStopped = Get-Services -Status 'Stopped' -Quantity 5 -Properties Name,DisplayName,ServiceName,Status
    $OSInfo = Get-OS-Info -Properties Version,Caption,BuildNumber,Manufacturer
    $BiosInfo = Get-BIOS-Info -Properties Name,Manufacturer,SerialNumber,Version,ReleaseDate
    $MemoryInfo = Get-Mem-Info -Properties Name,CreationClassName,Capacity,Speed
    $DiskInfo = Get-Disk-Info -Properties DiskNumber,PartitionStyle,BusType,Model
    $CreatedAt = Get-Date

    Generate-HTML -Body "$PCName $ServicesRunning $ServicesStopped $OSInfo $BiosInfo $MemoryInfo $DiskInfo <b>Criado em: </b>$CreatedAt" -Title "AV3" -File ./AV3.html
}
Export-ModuleMember -Function Get-PC-Details
