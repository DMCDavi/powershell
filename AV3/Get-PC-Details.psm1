
function Get-PC-Name {
    Get-CimInstance -ClassName Win32_ComputerSystem | ConvertTo-HTML -Property Name -Fragment
}

function Get-Services {

    param(
        [string] $StatusAlias,
        [int] $Quantity,
        $Properties
    )
    
    $Status = ""
    Switch($StatusAlias){
        "R" {$Status = "Running"}
        "S" {$Status = "Stopped"}
    }

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
        [string] $Head,
        $File
    )

    ConvertTo-HTML -Head $Head -Body $Body -Title $Title | Out-File $File
}

function Get-PC-Details{
    $PCName = Get-PC-Name
    $ServicesRunning = Get-Services -StatusAlias 'R' -Quantity 5 -Properties Name,DisplayName,ServiceName,Status
    $ServicesStopped = Get-Services -StatusAlias 'S' -Quantity 5 -Properties Name,DisplayName,ServiceName,Status
    $OSInfo = Get-OS-Info -Properties Version,Caption,BuildNumber,Manufacturer
    $BiosInfo = Get-BIOS-Info -Properties Name,Manufacturer,SerialNumber,Version,ReleaseDate
    $MemoryInfo = Get-Mem-Info -Properties Name,CreationClassName,Capacity,Speed
    $DiskInfo = Get-Disk-Info -Properties DiskNumber,PartitionStyle,Size,BusType,Model
    $CreatedAt = Get-Date

    $Style = @"
<style>
      body {
        background-color: rgb(62, 65, 77);
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto,
          Oxygen, Ubuntu, Cantarell, "Open Sans", "Helvetica Neue", sans-serif;
        padding-left: 2%;
      }
      th {
        background-color: cadetblue;
      }
      tr {
        background-color: lightgray;
      }
      table {
        margin-bottom: 10px;
      }
      p{
          color: white;
      }
      h1{
          font-size: large;
          color: white;
      }
      h2{
          font-size: medium;
          color: white;
      }
    </style>
"@

$Body = @"
<h2>Computer Name</h2>
$PCName 
<h2>Services Information</h2>
$ServicesRunning
 $ServicesStopped
 <h2>OS Information</h2>
  $OSInfo
  <h2>BIOS Information</h2>
   $BiosInfo
   <h2>Memory Information</h2>
    $MemoryInfo
    <h2>Disk Information</h2>
     $DiskInfo
     <p> <b>Created at: </b>$CreatedAt </p>
"@

    Generate-HTML -Head $Style -Body $Body -Title "AV3" -File ./AV3.html
}

Export-ModuleMember -Function Get-PC-Details