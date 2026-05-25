$csv = Import-Csv "food cupboard.csv" -Header (1..50 | ForEach-Object { "Col$_" }) | Select-Object -First 2
foreach ($row in $csv) {
    $rowProperties = $row | Get-Member -MemberType NoteProperty
    foreach ($prop in $rowProperties) {
        $val = $row.($prop.Name)
        if ($val) {
            Write-Host "$($prop.Name): $val"
        }
    }
    Write-Host "---"
}
