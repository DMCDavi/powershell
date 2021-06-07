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
