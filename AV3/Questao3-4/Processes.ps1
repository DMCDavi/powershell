$Processes = Get-Process | Select-Object Name, ID, @{n='MV';e={$PSItem.PM}},@{n='MP';e={$PSItem.PM}} | ConvertTo-HTML -Fragment
$CreatedAt = Get-Date
$Body = @"
    <h2>Processes</h2>
    $Processes
    <p> <b>Created at: </b>$CreatedAt </p>
"@
ConvertTo-HTML -Body $Body -Title 'Processes' | Out-File ./Processes.html
Compress-Archive -Path ./Processes.html -CompressionLevel Optimal -DestinationPath ./ProcessesZipped.zip