$csv = Import-Csv -Path "beverages.csv"
$matchingFields = @{}

foreach ($row in $csv) {
    $rowProperties = $row | Get-Member -MemberType NoteProperty
    foreach ($prop in $rowProperties) {
        $val = $row.($prop.Name)
        if ($val -and $val -match 'AED\s*\d+(\.\d+)?' -and $val -notmatch 'per Litre|per Liter|per kg|per pc') {
            $matchingFields[$prop.Name] = $val
        }
    }
}

Write-Host "Matching columns containing AED prices:"
$matchingFields | Format-Table | Out-String | Write-Host
