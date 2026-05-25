$jsonPath = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\extracted_dairy.json"
$outputPath = "C:\Users\sky\.gemini\antigravity\brain\8159cdce-69ff-4e05-8285-c5a923016032\dairy_eggs_list.md"

$json = Get-Content -Raw -Path $jsonPath | ConvertFrom-Json

$md = "# Dairy & Eggs Products List`r`n`r`n"
$md += "This document lists all **$($json.Count)** dairy and eggs products precisely extracted from `dairy & eggs.csv` with their respective images.`r`n`r`n"
$md += "| ID | Product Name | Subcategory | Price | Image Preview |`r`n"
$md += "| :--- | :--- | :--- | :--- | :--- |`r`n"

foreach ($p in $json) {
    # Render small image preview
    $imgHtml = "<img src=`"$($p.image)`" alt=`"$($p.name)`" height=`"60`" style=`"max-height: 60px; object-fit: contain;`" />"
    $md += "| $($p.id) | $($p.name) | $($p.subcategory) | AED $($p.price.ToString('F2')) | $imgHtml |`r`n"
}

[System.IO.File]::WriteAllText($outputPath, $md, [System.Text.Encoding]::UTF8)
Write-Host "Generated markdown list with $($json.Count) items at $outputPath"
