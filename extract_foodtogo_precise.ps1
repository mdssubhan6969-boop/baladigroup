$csvPath = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\food to go.csv"
$outputPath = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\extracted_foodtogo.json"

$csv = Import-Csv -Path $csvPath

# Step 1: Collect all images in the CSV and map them by their product ID (digits before _main.jpg)
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

# Step 2: First pass - Parse all unique products and gather links, names, prices
$products = @()
$seenNames = [System.Collections.Generic.HashSet[string]]::new()
$seenIds = [System.Collections.Generic.HashSet[string]]::new()

for ($i = 0; $i -lt $csv.Count; $i++) {
    $row = $csv[$i]
    
    # Define slots in the CSV
    $slots = @(
        @{ name = 'text-sm'; p_main = 'text-lg'; p_frac = 'text-2xs'; links = @('max-w-[134px] href', 'w-full href'); unit = 'text-xs 2'; original = 'text-sm 3'; badge = 'text-xs' },
        @{ name = 'text-sm 2'; p_main = 'text-lg 2'; p_frac = 'text-2xs 3'; links = @('max-w-[134px] href 2', 'w-full href 2'); unit = 'text-xs 5'; original = 'text-sm 5'; badge = 'text-xs 2' },
        @{ name = 'text-sm 4'; p_main = 'text-lg 3'; p_frac = 'text-2xs 5'; links = @('max-w-[134px] href 3', 'w-full href 3'); unit = 'text-xs 7'; original = 'text-sm 7'; badge = 'text-xs 4' },
        @{ name = 'text-sm 6'; p_main = 'text-lg 4'; p_frac = 'text-2xs 7'; links = @('max-w-[134px] href 4', 'w-full href 4'); unit = 'text-xs 9'; original = 'text-sm 9'; badge = 'text-xs 6' }
    )

    foreach ($slot in $slots) {
        $name = $row.($slot.name)
        if ($name) { $name = $name.Trim() }
        if (-not $name -or $name -eq "") { continue }

        $lowerName = $name.ToLower()
        if ($seenNames.Contains($lowerName)) { continue }

        # Filter out sponsored items that are yoghurt or other dairy
        if ($lowerName.Contains("yoghurt") -or $lowerName.Contains("yogurt")) {
            continue
        }

        # Get product ID from the link columns for this slot
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

        $linkStr = if ($linkVal) { $linkVal.ToLower() } else { "" }
        if ($linkStr.Contains("yogurt") -or $linkStr.Contains("yoghurt")) {
            continue # Filter out dairy products
        }

        # Extract current price
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

        # Check for image matching this ID in the global map
        $image = $null
        if ($imageMap.ContainsKey($id)) {
            $image = $imageMap[$id]
        }

        # Subcategory logic
        $subcategory = "Food To Go"
        if ($lowerName.Contains("sushi") -or $lowerName.Contains("maki") -or $lowerName.Contains("sashimi") -or $lowerName.Contains("roll") -or $linkStr.Contains("sushi") -or $linkStr.Contains("maki") -or $linkStr.Contains("sashimi")) {
            $subcategory = "Food To Go > Sushi & Sashimi"
        } elseif ($lowerName.Contains("salad") -or $lowerName.Contains("soup") -or $lowerName.Contains("hummus") -or $lowerName.Contains("dip") -or $lowerName.Contains("mutabal") -or $lowerName.Contains("muhamara") -or $lowerName.Contains("tarator") -or $lowerName.Contains("sauce") -or $lowerName.Contains("tabbouleh") -or $lowerName.Contains("fattoush") -or $lowerName.Contains("dressing") -or $linkStr.Contains("salad") -or $linkStr.Contains("soup") -or $linkStr.Contains("hummus") -or $linkStr.Contains("dip")) {
            $subcategory = "Food To Go > Salads & Soup"
        } elseif ($lowerName.Contains("meal") -or $lowerName.Contains("rice") -or $lowerName.Contains("bento") -or $lowerName.Contains("curry") -or $lowerName.Contains("pasta") -or $lowerName.Contains("biryani") -or $lowerName.Contains("platter") -or $lowerName.Contains("combo") -or $lowerName.Contains("chicken") -or $linkStr.Contains("meal") -or $linkStr.Contains("bento") -or $linkStr.Contains("rice") -or $linkStr.Contains("curry")) {
            $subcategory = "Food To Go > Ready Meals"
        } else {
            $subcategory = "Food To Go > Appetizers & Bites"
        }

        # Tag
        $tag = "Fresh"
        $badgeVal = $row.($slot.badge)
        if ($badgeVal -and $badgeVal.Trim() -ne "") {
            $tag = $badgeVal.Trim()
        }

        # Unit
        $unitVal = "pc"
        $unitColVal = $row.($slot.unit)
        if ($unitColVal -and $unitColVal -match 'per Kilo|per kg|/kg|/ Kilo') {
            $unitVal = "kg"
        } elseif ($lowerName.Contains("per kilo") -or $lowerName.Contains("per kg")) {
            $unitVal = "kg"
        }

        # Original/strikethrough price
        $originalPriceVal = $null
        $isDealVal = $null
        $origColVal = $row.($slot.original)
        if ($origColVal -and $origColVal -match 'AED\s*([\d\.]+)') {
            $originalPriceVal = [double]$matches[1]
            $isDealVal = $true
        }

        $seenNames.Add($lowerName) | Out-Null
        $seenIds.Add($id) | Out-Null

        $prodObj = @{
            id = $id
            name = $name
            category = "fresh-food"
            subcategory = $subcategory
            price = $priceVal
            unit = $unitVal
            image = $image  # resolved in step 3
            tag = $tag
        }

        if ($isDealVal) {
            $prodObj["isDeal"] = $true
            $prodObj["originalPrice"] = $originalPriceVal
        }

        $products += $prodObj
    }
}

# Step 3: Second pass - Resolve missing images using name similarity mapping or predefined fallbacks
$matchedProductsWithImage = $products | Where-Object { $_.image -ne $null }

Write-Host "Products with direct images: $($matchedProductsWithImage.Count)"
Write-Host "Products lacking direct images: $($products.Count - $matchedProductsWithImage.Count)"

$countResolved = 0
for ($idx = 0; $idx -lt $products.Count; $idx++) {
    $p = $products[$idx]
    if ($p.image -eq $null) {
        $pNameLower = $p.name.ToLower()
        
        # Predefined fallbacks for special items
        if ($pNameLower.Contains("quiche")) {
            # Find any Appetizers & Bites or Ready Meals with image
            $fallbackItem = $matchedProductsWithImage | Where-Object { $_.subcategory -eq "Food To Go > Appetizers & Bites" } | Select-Object -First 1
            if ($fallbackItem) {
                $p.image = $fallbackItem.image
                Write-Host "Resolved Quiche to: $($fallbackItem.name)"
            }
        } elseif ($pNameLower.Contains("mutabal") -or $pNameLower.Contains("eggplant")) {
            # Find salad/sauce/muhamara
            $fallbackItem = $matchedProductsWithImage | Where-Object { $_.name.ToLower().Contains("muhamara") -or $_.name.ToLower().Contains("sauce") } | Select-Object -First 1
            if ($fallbackItem) {
                $p.image = $fallbackItem.image
                Write-Host "Resolved Mutabal to: $($fallbackItem.name)"
            }
        }

        # If still null, do dynamic name similarity
        if ($p.image -eq $null) {
            $words = $pNameLower.Split(" ,-()[]") | Where-Object { $_.Length -gt 3 -and $_ -ne "fresh" -and $_ -ne "import" }
            
            $bestMatch = $null
            $bestScore = 0
            foreach ($mItem in $matchedProductsWithImage) {
                $score = 0
                $mNameLower = $mItem.name.ToLower()
                foreach ($w in $words) {
                    if ($mNameLower.Contains($w)) { $score++ }
                }
                if ($score -gt $bestScore) {
                    $bestScore = $score
                    $bestMatch = $mItem
                }
            }

            if ($bestMatch -and $bestScore -gt 0) {
                $p.image = $bestMatch.image
                $countResolved++
            } else {
                # Fallback to same subcategory
                $sameSubcatItem = $matchedProductsWithImage | Where-Object { $_.subcategory -eq $p.subcategory } | Select-Object -First 1
                if ($sameSubcatItem) {
                    $p.image = $sameSubcatItem.image
                    $countResolved++
                } else {
                    $p.image = $matchedProductsWithImage[0].image
                    $countResolved++
                }
            }
        }
    }
}

Write-Host "Resolved $countResolved products using similarity mapping."

# Step 4: Re-index IDs to p_ftg_1 to p_ftg_N format
for ($idx = 0; $idx -lt $products.Count; $idx++) {
    $num = $idx + 1
    $products[$idx].id = "p_ftg_$num"
}

# Step 5: Save to JSON
$json = ConvertTo-Json $products -Depth 10
[System.IO.File]::WriteAllText($outputPath, $json, [System.Text.Encoding]::UTF8)

Write-Host "Precisely extracted $($products.Count) unique Food to Go products to $outputPath"
