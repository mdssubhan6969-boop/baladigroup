$csvPath = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\meat & poultry.csv"
$outputPath = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\extracted_meat.json"

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
        @{ name = 'text-sm'; p_main = 'text-lg'; p_frac = 'text-2xs'; links = @('max-w-[134px] href', 'w-full href'); unit = 'text-xs 2'; original = 'text-sm 2'; badge = 'text-xs' },
        @{ name = 'text-sm 3'; p_main = 'text-lg 2'; p_frac = 'text-2xs 3'; links = @('max-w-[134px] href 2', 'w-full href 2'); unit = 'text-xs 4'; original = 'text-sm 4'; badge = 'text-xs 3' },
        @{ name = 'text-sm 5'; p_main = 'text-lg 3'; p_frac = 'text-2xs 5'; links = @('max-w-[134px] href 3', 'w-full href 3'); unit = 'text-xs 6'; original = 'text-sm 6'; badge = 'text-xs 5' },
        @{ name = 'text-sm 7'; p_main = 'text-lg 4'; p_frac = 'text-2xs 7'; links = @('max-w-[134px] href 4', 'w-full href 4'); unit = 'text-xs 8'; original = 'text-sm 8'; badge = 'text-xs 7' }
    )

    foreach ($slot in $slots) {
        $name = $row.($slot.name)
        if ($name) { $name = $name.Trim() }
        if (-not $name -or $name -eq "") { continue }

        $lowerName = $name.ToLower()
        if ($seenNames.Contains($lowerName)) { continue }

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
        $subcategory = "Meat & Poultry"
        $linkStr = if ($linkVal) { $linkVal.ToLower() } else { "" }
        if ($lowerName.Contains("chicken") -or $lowerName.Contains("chk") -or $linkStr.Contains("chicken")) {
            $subcategory = "Meat & Poultry > Chicken"
        } elseif ($lowerName.Contains("beef") -or $linkStr.Contains("beef")) {
            $subcategory = "Meat & Poultry > Beef"
        } elseif ($lowerName.Contains("lamb") -or $lowerName.Contains("mutton") -or $linkStr.Contains("lamb") -or $linkStr.Contains("mutton")) {
            $subcategory = "Meat & Poultry > Lamb"
        } elseif ($lowerName.Contains("veal") -or $linkStr.Contains("veal")) {
            $subcategory = "Meat & Poultry > Veal"
        } elseif ($lowerName.Contains("offal") -or $lowerName.Contains("liver") -or $lowerName.Contains("gizzard") -or $lowerName.Contains("heart") -or $linkStr.Contains("offal") -or $linkStr.Contains("liver")) {
            $subcategory = "Meat & Poultry > Offals"
        }

        # Tag
        $tag = "Fresh"
        $badgeVal = $row.($slot.badge)
        if ($badgeVal -and $badgeVal.Trim() -ne "") {
            $tag = $badgeVal.Trim()
        }

        # Unit
        $unitVal = "pc"
        $unitColVal = ""
        if ($slot.unit) {
            $unitColVal = $row.($slot.unit)
            if ($unitColVal -and $unitColVal -match 'per Kilo|per kg|/kg|/ Kilo') {
                $unitVal = "kg"
            }
        }
        
        # Override to 'pc' if the name or unit column contains packaging/weight indicators
        $combinedText = "$lowerName $unitColVal".ToLower()
        if ($combinedText -match '\b\d+(?:\.\d+)?\s*(?:g|kg|gm|piece|pc|pkg|pack|piece|oz|lbs|ml|l)\b' -or
            $combinedText -match 'pack|piece|pc|bunch|bag|pot|punnet|bowl|box|bundle|noodle|tofu|seeds|mesh|net|tray|cup|tub|bucket|basket|wrapper|cellophane|cling|roll|stick|jar|can|bottle') {
            $unitVal = "pc"
        }

        # Original/strikethrough price
        $originalPriceVal = $null
        $isDealVal = $null
        $origColVal = $row.($slot.original)
        if ($origColVal -and $origColVal -match 'AED\s*([\d\.]+)') {
            $originalPriceVal = [double]$matches[1]
            $isDealVal = $true
            
            # Swap if inverted
            if ($originalPriceVal -lt $priceVal) {
                $temp = $priceVal
                $priceVal = $originalPriceVal
                $originalPriceVal = $temp
            }
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
            image = $image  # might be null, resolved in step 3
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
        if ($pNameLower.Contains("capon")) {
            # Find Al Khazna Whole Chicken pack or any whole chicken with image
            $fallbackItem = $matchedProductsWithImage | Where-Object { $_.name.ToLower().Contains("al khazna") -and $_.name.ToLower().Contains("whole chicken") } | Select-Object -First 1
            if ($fallbackItem) {
                $p.image = $fallbackItem.image
                Write-Host "Resolved Capon to whole chicken: $($fallbackItem.name)"
            }
        } elseif ($pNameLower.Contains("bbq chichen combo") -or $pNameLower.Contains("bbq chicken combo")) {
            # Find Shish Tawook
            $fallbackItem = $matchedProductsWithImage | Where-Object { $_.name.ToLower().Contains("shish tawook") } | Select-Object -First 1
            if ($fallbackItem) {
                $p.image = $fallbackItem.image
                Write-Host "Resolved BBQ combo to shish tawook: $($fallbackItem.name)"
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

            if ($bestMatch -and $bestScore -gt 1) {
                $p.image = $bestMatch.image
                $countResolved++
            } else {
                # General subcategory fallbacks if similarity fails
                # Let's borrow an image from the same subcategory
                $sameSubcatItem = $matchedProductsWithImage | Where-Object { $_.subcategory -eq $p.subcategory } | Select-Object -First 1
                if ($sameSubcatItem) {
                    $p.image = $sameSubcatItem.image
                    $countResolved++
                } else {
                    # Absolute fallback to any fresh food image
                    $p.image = $matchedProductsWithImage[0].image
                    $countResolved++
                }
            }
        }
    }
}

Write-Host "Resolved $countResolved products using similarity mapping."

# Step 4: Re-index IDs to p_mp_1 to p_mp_N format
for ($idx = 0; $idx -lt $products.Count; $idx++) {
    $num = $idx + 1
    $products[$idx].id = "p_mp_$num"
}

# Step 5: Save to JSON
$json = ConvertTo-Json $products -Depth 10
[System.IO.File]::WriteAllText($outputPath, $json, [System.Text.Encoding]::UTF8)

Write-Host "Precisely extracted $($products.Count) unique Meat & Poultry products to $outputPath"
