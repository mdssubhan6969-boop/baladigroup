$csv = Import-Csv "food cupboard.csv"
$categories = [System.Collections.Generic.HashSet[string]]::new()

for ($i = 0; $i -lt $csv.Count; $i++) {
    $row = $csv[$i]
    $slots = @('w-full href', 'w-full href 2', 'w-full href 3', 'w-full href 4')
    foreach ($col in $slots) {
        $val = $row.$col
        if ($val -and $val -match '/en/([^/]+)/') {
            $categories.Add($matches[1]) | Out-Null
        }
    }
}

$categories | Sort-Object | Out-String | Write-Host
