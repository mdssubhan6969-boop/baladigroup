# extract_chilled_desserts.ps1
$csvPath = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\chilled desserts.csv"
$outputPath = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\extracted_chilled_desserts.json"

$csv = Import-Csv -Path $csvPath

# Step 1: Collect all images in the CSV and map them by their product ID
$imageMap = @{}
foreach ($row in $csv) {
    $rowProperties = $row | Get-Member -MemberType NoteProperty
    foreach ($prop in $rowProperties) {
        $val = $row.($prop.Name)
        if ($val -and $val.StartsWith("http") -and $val -match '(\d+)_main\.jpg') {
            $id = $matches[1]
            $imageMap[$id] = $val.Trim()
        }
    }
}

# Step 2: Parse unique products
$products = @()
$seenNames = [System.Collections.Generic.HashSet[string]]::new()
$seenIds = [System.Collections.Generic.HashSet[string]]::new()

for ($i = 0; $i -lt $csv.Count; $i++) {
    $row = $csv[$i]
    
    $slots = @(
        @{ name = 'text-sm'; p_main = 'text-lg'; p_frac = 'text-2xs'; links = @('w-full href'); unit = 'text-xs 2'; badge = 'text-xs' },
        @{ name = 'text-sm 3'; p_main = 'text-lg 2'; p_frac = 'text-2xs 3'; links = @('w-full href 2'); unit = 'text-xs 4'; badge = 'text-xs 3' },
        @{ name = 'text-sm 5'; p_main = 'text-lg 3'; p_frac = 'text-2xs 5'; links = @('w-full href 3'); unit = $null; badge = $null },
        @{ name = 'text-sm 6'; p_main = 'text-lg 4'; p_frac = 'text-2xs 7'; links = @('w-full href 4'); unit = 'text-xs 5'; badge = $null }
    )

    foreach ($slot in $slots) {
        $name = $row.($slot.name)
        if ($name) { $name = $name.Trim() }
        if (-not $name -or $name -eq "") { continue }

        $lowerName = $name.ToLower()
        if ($seenNames.Contains($lowerName)) { continue }

        # Get product ID from link columns
        $id = $null
        $linkVal = $null
        foreach ($linkCol in $slot.links) {
            $val = $row.$linkCol
            if ($val -and $val -match '\/p\/(\d+)') {
                $id = $matches[1]
                $linkVal = $val
                break
            }
        }

        if (-not $id) { continue }

        # Extract price
        $p_main = $row.($slot.p_main)
        $p_frac = $row.($slot.p_frac)
        if ($p_main) { $p_main = $p_main.Trim() }
        if ($p_frac) { $p_frac = $p_frac.Trim() }

        $priceVal = 0.0
        $priceStr = "$p_main$p_frac"
        $priceStr = $priceStr.Replace(" ", "")
        if (-not [double]::TryParse($priceStr, [ref]$priceVal)) {
            continue
        }

        # Image mapping
        $image = $null
        if ($imageMap.ContainsKey($id)) {
            $image = $imageMap[$id]
        }

        # Subcategory: Chilled Desserts
        $subcategory = "Dairy & Eggs > Chilled Desserts"

        # Tag
        $tag = "Fresh"
        if ($slot.badge) {
            $badgeVal = $row.($slot.badge)
            if ($badgeVal -and $badgeVal.Trim() -ne "" -and -not $badgeVal.Contains("http") -and $badgeVal.Length -lt 20) {
                $tag = $badgeVal.Trim()
            }
        }

        # Unit
        # Unit (desserts are always sold as pre-packaged units)
        $unitVal = "pc"

        $seenNames.Add($lowerName) | Out-Null
        $seenIds.Add($id) | Out-Null

        $prodObj = @{
            id = $id
            name = $name
            category = "fresh-food"
            subcategory = $subcategory
            price = $priceVal
            unit = $unitVal
            image = $image
            tag = $tag
        }

        $products += $prodObj
    }
}

# Resolve missing images using same subcategory fallback if any
$matchedProductsWithImage = $products | Where-Object { $_.image -ne $null }
Write-Host "Chilled Desserts: total parsed $($products.Count), direct images $($matchedProductsWithImage.Count)"

for ($idx = 0; $idx -lt $products.Count; $idx++) {
    $p = $products[$idx]
    if ($p.image -eq $null) {
        if ($matchedProductsWithImage.Count -gt 0) {
            $p.image = $matchedProductsWithImage[0].image
        } else {
            # Absolute fallback
            $p.image = "https://cdn.mafrservices.com/pim-content/UAE/media/product/1726681/1749378003/1726681_main.jpg?im=Resize=(300,300)"
        }
    }
}

# Re-index IDs to p_cd_1 to p_cd_N
for ($idx = 0; $idx -lt $products.Count; $idx++) {
    $num = $idx + 1
    $products[$idx].id = "p_cd_$num"
}

$json = ConvertTo-Json $products -Depth 10
[System.IO.File]::WriteAllText($outputPath, $json, [System.Text.Encoding]::UTF8)

Write-Host "Precisely extracted $($products.Count) unique Chilled Desserts products to $outputPath"
