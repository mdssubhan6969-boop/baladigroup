# extract_chilled_food_counter.ps1
$csvPath = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\chilled food counter.csv"
$outputPath = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\extracted_chilled_food_counter.json"

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
        @{ name = 'text-sm'; p_main = 'text-lg'; p_frac = 'text-2xs'; links = @('w-full href', 'max-w-[134px] href'); unit = 'text-xs 3'; badge = 'text-xs' },
        @{ name = 'text-sm 3'; p_main = 'text-lg 2'; p_frac = 'text-2xs 3'; links = @('w-full href 2', 'max-w-[134px] href 2'); unit = 'text-xs 6'; badge = 'text-xs 3' },
        @{ name = 'text-sm 5'; p_main = 'text-lg 3'; p_frac = 'text-2xs 5'; links = @('w-full href 3', 'max-w-[134px] href 3'); unit = 'text-xs 8'; badge = 'text-xs 5' },
        @{ name = 'text-sm 6'; p_main = 'text-lg 4'; p_frac = 'text-2xs 7'; links = @('w-full href 4', 'max-w-[134px] href 4'); unit = 'text-xs 9'; badge = 'text-xs 7' }
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

        # Subcategory logic
        $linkStr = if ($linkVal) { $linkVal.ToLower() } else { "" }
        $subcategory = "Chilled Food Counter > Dips, Spreads & P$([char]226)t$([char]233)s" # Default
        
        if ($lowerName.Contains("sea-foods") -or $lowerName.Contains("caviar") -or $lowerName.Contains("crab") -or $lowerName.Contains("salmon") -or $lowerName.Contains("trout") -or $lowerName.Contains("roe") -or $lowerName.Contains("herring") -or $lowerName.Contains("shrimp") -or $lowerName.Contains("seafood") -or $lowerName.Contains("krill") -or $lowerName.Contains("anchovy") -or $linkStr.Contains("sea-foods")) {
            $subcategory = "Chilled Food Counter > Seafood & Caviar"
        } elseif ($lowerName.Contains("turkey") -or $lowerName.Contains("mortadella") -or $lowerName.Contains("mortadelle") -or $lowerName.Contains("beef") -or $lowerName.Contains("frankfurter") -or $lowerName.Contains("salami") -or $lowerName.Contains("pastrami") -or $lowerName.Contains("sausage") -or $lowerName.Contains("chicken") -or $lowerName.Contains("meat") -or $lowerName.Contains("slices") -or $lowerName.Contains("pepperoni") -or $lowerName.Contains("hotdog") -or $lowerName.Contains("frank") -or $lowerName.Contains("gala") -or $lowerName.Contains("bacon") -or $lowerName.Contains("bresaola") -or $linkStr.Contains("turkey") -or $linkStr.Contains("salamis") -or $linkStr.Contains("chicken") -or $linkStr.Contains("beef") -or $linkStr.Contains("mortadella")) {
            $subcategory = "Chilled Food Counter > Cold Cuts & Meat Snacks"
        } elseif ($lowerName.Contains("olive") -or $lowerName.Contains("olives") -or $lowerName.Contains("pickle") -or $lowerName.Contains("pickles") -or $lowerName.Contains("makdous") -or $lowerName.Contains("magdous") -or $lowerName.Contains("jalapeno") -or $lowerName.Contains("antipasti") -or $lowerName.Contains("sundried") -or $lowerName.Contains("tomato") -or $lowerName.Contains("pepperoncini") -or $lowerName.Contains("caper") -or $lowerName.Contains("capers") -or $linkStr.Contains("olives") -or $linkStr.Contains("antipasti") -or $linkStr.Contains("pickles")) {
            $subcategory = "Chilled Food Counter > Olives & Antipasti"
        } elseif ($lowerName.Contains("kimchi") -or $linkStr.Contains("kimchi")) {
            $subcategory = "Chilled Food Counter > Kimchi"
        } elseif ($lowerName.Contains("dressing") -or $linkStr.Contains("dressing")) {
            $subcategory = "Chilled Food Counter > Dressing"
        } elseif ($lowerName.Contains("hummus") -or $lowerName.Contains("mutabal") -or $lowerName.Contains("muhamara") -or $lowerName.Contains("tarator") -or $lowerName.Contains("garlic") -or $lowerName.Contains("dip") -or $lowerName.Contains("spread") -or $lowerName.Contains("pate") -or $lowerName.Contains("p$([char]226)t$([char]233)") -or $lowerName.Contains("honey") -or $lowerName.Contains("halawa") -or $lowerName.Contains("halva") -or $lowerName.Contains("cheese") -or $linkStr.Contains("honey") -or $linkStr.Contains("dips") -or $linkStr.Contains("spreads") -or $linkStr.Contains("cheese")) {
            $subcategory = "Chilled Food Counter > Dips, Spreads & P$([char]226)t$([char]233)s"
        }

        # Tag
        $tag = "Fresh"
        if ($slot.badge) {
            $badgeVal = $row.($slot.badge)
            if ($badgeVal -and $badgeVal.Trim() -ne "" -and -not $badgeVal.Contains("http") -and $badgeVal.Length -lt 20) {
                $tag = $badgeVal.Trim()
            }
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
        if ($lowerName.Contains("per kilo") -or $lowerName.Contains("per kg") -or $lowerName.Contains("approx") -or $lowerName.Contains("pieces/kg")) {
            $unitVal = "kg"
        }
        
        # Override to 'pc' if the name or unit column contains packaging/weight indicators
        $combinedText = "$lowerName $unitColVal".ToLower()
        if ($combinedText -match '\b\d+(?:\.\d+)?\s*(?:g|kg|gm|piece|pc|pkg|pack|piece|oz|lbs|ml|l)\b' -or
            $combinedText -match 'pack|piece|pc|bunch|bag|pot|punnet|bowl|box|bundle|noodle|tofu|seeds|mesh|net|tray|cup|tub|bucket|basket|wrapper|cellophane|cling|roll|stick|jar|can|bottle') {
            $unitVal = "pc"
        }

        # Check for deal/original price
        $originalPriceVal = $null
        $isDealVal = $null
        
        # If there is a badge indicating sale or deal
        if ($tag -match '(\d+)%\s*OFF') {
            $discountPct = [double]$matches[1]
            $originalPriceVal = [Math]::Round($priceVal / (1.0 - ($discountPct / 100.0)), 2)
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
            image = $image
            tag = $tag
        }

        if ($isDealVal) {
            $prodObj["isDeal"] = $true
            $prodObj["originalPrice"] = $originalPriceVal
        }

        $products += $prodObj
    }
}

# Resolve missing images using name similarity or subcategory fallback
$matchedProductsWithImage = $products | Where-Object { $_.image -ne $null }
Write-Host "Chilled Food Counter: total parsed $($products.Count), direct images $($matchedProductsWithImage.Count)"

$countResolved = 0
for ($idx = 0; $idx -lt $products.Count; $idx++) {
    $p = $products[$idx]
    if ($p.image -eq $null) {
        $pNameLower = $p.name.ToLower()
        
        # Predefined fallbacks
        if ($pNameLower.Contains("turkey")) {
            $fallbackItem = $matchedProductsWithImage | Where-Object { $_.name.ToLower().Contains("turkey") } | Select-Object -First 1
            if ($fallbackItem) { $p.image = $fallbackItem.image }
        } elseif ($pNameLower.Contains("olive")) {
            $fallbackItem = $matchedProductsWithImage | Where-Object { $_.name.ToLower().Contains("olive") } | Select-Object -First 1
            if ($fallbackItem) { $p.image = $fallbackItem.image }
        } elseif ($pNameLower.Contains("salmon")) {
            $fallbackItem = $matchedProductsWithImage | Where-Object { $_.name.ToLower().Contains("salmon") } | Select-Object -First 1
            if ($fallbackItem) { $p.image = $fallbackItem.image }
        }
        
        # Similarity search
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
                # Same subcategory fallback
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

Write-Host "Resolved $countResolved missing images via similarity/subcat mapping."

# Re-index IDs to p_cfc_1 to p_cfc_N
for ($idx = 0; $idx -lt $products.Count; $idx++) {
    $num = $idx + 1
    $products[$idx].id = "p_cfc_$num"
}

$json = ConvertTo-Json $products -Depth 10
[System.IO.File]::WriteAllText($outputPath, $json, [System.Text.Encoding]::UTF8)

Write-Host "Precisely extracted $($products.Count) unique Chilled Food Counter products to $outputPath"
