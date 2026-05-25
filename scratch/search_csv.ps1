$csv = Import-Csv -Path "beverages.csv"
$id = "1808893"

$matches = @()
foreach ($row in $csv) {
    $rowProperties = $row | Get-Member -MemberType NoteProperty
    $isMatch = $false
    foreach ($prop in $rowProperties) {
        $val = $row.($prop.Name)
        if ($val -and $val -like "*$id*") {
            $isMatch = $true
            break
        }
    }
    if ($isMatch) {
        # Clean empty properties for display
        $cleanObj = @{}
        foreach ($prop in $rowProperties) {
            $val = $row.($prop.Name)
            if ($val -and $val.Trim() -ne "") {
                $cleanObj[$prop.Name] = $val.Trim()
            }
        }
        $matches += [PSCustomObject]$cleanObj
    }
}

Write-Host "Found $($matches.Count) rows:"
$matches | Format-List | Out-String | Write-Host
