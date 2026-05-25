$csvPath = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\beverages.csv"
$outputPath = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\extracted_beverages.json"

if (-not (Test-Path $csvPath)) {
    Write-Error "CSV path not found: $csvPath"
    exit 1
}

$csv = Import-Csv -Path $csvPath

if ($csv.Count -eq 0) {
    Write-Error "CSV is empty!"
    exit 1
}

# Step 1: Collect property names once using PSObject to avoid slow Get-Member calls
$propNames = $csv[0].PSObject.Properties.Name

# Collect all valid images in the CSV and map them by product ID
$imageMap = @{}
foreach ($row in $csv) {
    foreach ($name in $propNames) {
        $val = $row.$name
        if ($val -and $val.StartsWith("http") -and $val -match '(\d+)_main\.jpg') {
            $id = $matches[1]
            # Ignore vector/delivery placeholders
            if ($val -notmatch 'Vector_2|SLA_clock') {
                $imageMap[$id] = $val.Trim()
            }
        }
    }
}

# Step 2: Define categorization function
function Get-Subcategory {
    param(
        [string]$name,
        [string]$urlSubcat
    )
    $lowerName = $name.ToLower()
    $url = $urlSubcat.ToLower()

    # --- Kids Juices & Water ---
    if ($lowerName -match "kids water|water for kids") {
        return "Water > Kids Water"
    }
    if ($lowerName -match "kids juice|kids drink|capri-sun kids|capri sun kids|lacnor kids|almarai kids") {
        return "Kids Drinks > Kids Juices"
    }

    # --- Coffee Subcategories ---
    if ($lowerName -match "decaf|decaffeinated") {
        return "Coffee > Decaffeinated Coffee"
    }
    if ($lowerName -match "capsules|nespresso|dolce gusto|capsule|starbucks capsule|lavazza capsule") {
        return "Coffee > Capsules"
    }
    if ($lowerName -match "beans|ground coffee|whole bean|espresso beans|coffee filter|coffee bag") {
        return "Coffee > Ground Coffee & Beans"
    }
    if ($lowerName -match "iced latte|iced coffee|cold brew|starbucks bottle|double shot|frappuccino|cappuccino bottle|coffee drink") {
        return "Coffee > Coffee Drinks"
    }
    if ($lowerName -match "instant|nescafe|gold blend|davidoff|red mug|3 in 1|2 in 1|sachet" -or $url -match "instant-coffee|coffee-sachet") {
        return "Coffee > Instant Coffee & Sachets"
    }

    # --- Tea Subcategories ---
    if ($lowerName -match "ice tea|iced tea|lipton ice") {
        return "Tea & Coffee Based > Cold Coffee & Ice Tea"
    }
    if ($lowerName -match "tea sachet|instant tea|matcha sachet|chai sachet|karak sachet|karak tea") {
        return "Tea & Coffee Based > Tea Sachets"
    }
    if ($lowerName -match "tea|lipton|ahmad|twining|chamomile|peppermint" -or $url -match "tea|herbal") {
        return "Tea & Coffee Based > Loose Leaf & Tea Bags"
    }

    # --- Soft Drinks ---
    if ($lowerName -match "red bull|monster|pocari|gatorade|energy drink|sports drink|powerade|boost|milo drink" -or $url -match "energy|sports-drink") {
        return "Soft Drinks > Vitamins, Sports & Energy Drinks"
    }
    if ($lowerName -match "coke|coca-cola|pepsi|sprite|fanta|7up|seven up|dew|mirinda|shani|ginger ale|tonic|club soda|schweppes|carbonated|soft drink|cola" -or $url -match "carbonated|soft-drink") {
        return "Soft Drinks > Carbonated Drinks"
    }

    # --- Water Subcategories ---
    if ($lowerName -match "sparkling|perrier|san pellegrino|soda water" -or $url -match "sparkling") {
        return "Water > Sparkling Water"
    }
    if ($lowerName -match "alkaline|ph8|zero sodium|al ain zero|zero water" -or $url -match "alkaline") {
        return "Water > Alkaline Water"
    }
    if ($lowerName -match "flavored|flavoured|peach water|lemon water|strawberry water|apple water|volvic touch" -or $url -match "flavoured") {
        return "Water > Flavoured Water"
    }
    if ($lowerName -match "still|pure life|masafi still|al ain still|evian still|maii|oasis still" -or $url -match "still-water") {
        return "Water > Still Water"
    }
    if ($lowerName -match "water|water bottle|bottled water" -or $url -match "water|mineral") {
        return "Water > Mineral Water"
    }

    # --- Powdered Drinks ---
    if ($lowerName -match "hot chocolate|drinking chocolate|cocoa powder|nesquik" -or $url -match "hot-chocolate|cocoa") {
        return "Powdered Drinks > Hot Chocolate & Melts"
    }
    if ($lowerName -match "ensure|pediasure|malt|protein shake|nutrition powder" -or $url -match "nutrition-shake|protein") {
        return "Powdered Drinks > Nourishing & Healthy Instant"
    }
    if ($lowerName -match "powdered juice|tang powder|instant drink powder|foster clark|bolero" -or $url -match "powdered-drink|instant-powder") {
        return "Powdered Drinks > Powdered Juices"
    }

    # --- Juice Subcategories ---
    if ($lowerName -match "squeezed|fresh juice|barakat juice" -or $url -match "fresh-juice") {
        return "Juices > Freshly Squeezed Juices"
    }
    if ($lowerName -match "syrup|concentrate|cordial|rose water|vimto" -or $url -match "syrups|concentrate") {
        return "Juices > Syrups & Concentrate"
    }
    if ($lowerName -match "coconut water|basil seed|aloe vera" -or $url -match "coconut-water|aloe") {
        return "Juices > Coconut & Flavored Water"
    }
    if ($lowerName -match "juice|smoothie|nectar|capri sun|tetra pack" -or $url -match "juice|nectar") {
        return "Juices > Long Life Juices & Smoothies"
    }

    # --- General Fallbacks ---
    if ($lowerName -match "coffee|cafe|cappuccino|espresso|latte|macchiato") {
        return "Coffee > Instant Coffee & Sachets"
    }
    if ($lowerName -match "tea|green tea|black tea|herbal") {
        return "Tea & Coffee Based > Loose Leaf & Tea Bags"
    }
    if ($lowerName -match "juice|fruit drink|nectar") {
        return "Juices > Long Life Juices & Smoothies"
    }
    if ($lowerName -match "water|bottle") {
        return "Water > Mineral Water"
    }

    return "Water > Still Water"
}

# Step 3: Similarity Scorer between Product Name and Link Slug
function Get-OverlapScore {
    param(
        [string]$name,
        [string]$slug,
        [int]$slotIndex,
        [int]$linkIndex
    )
    if (-not $slug) { return 0 }
    
    $nameLower = $name.ToLower()
    $slugLower = $slug.ToLower()
    
    $nameWords = $nameLower.Split(" ,-()[]/&+") | Where-Object { $_.Length -gt 1 }
    $slugWords = $slugLower.Split(" ,-()[]/&+") | Where-Object { $_.Length -gt 1 }
    
    $score = 0
    foreach ($w in $nameWords) {
        # Exact match gets high weight
        if ($slugWords -contains $w) {
            $score += 3
            continue
        }
        
        # Abbreviation/partial match helper
        if ($w -eq "green" -and ($slugLower.Contains("gt") -or $slugLower.Contains("grn"))) {
            $score += 2
        }
        elseif ($w -eq "pure" -and $slugLower.Contains("pur")) {
            $score += 2
        }
        elseif ($w -eq "envelope" -and $slugLower.Contains("env")) {
            $score += 2
        }
        elseif ($w -eq "tea" -and $slugLower.Contains("tea")) {
            $score += 2
        }
        elseif ($w.Length -ge 4 -and $slugLower.Contains($w.Substring(0, 3))) {
            $score += 1
        }
    }
    
    # Slot index bonus to prefer matching Slot i with Link i if they are aligned
    if ($slotIndex -eq $linkIndex) {
        $score += 1.5
    }
    
    return $score
}

# Step 4: Parse products slot by slot
$products = @()
$seenNames = [System.Collections.Generic.HashSet[string]]::new()
$seenIds = [System.Collections.Generic.HashSet[string]]::new()

for ($i = 0; $i -lt $csv.Count; $i++) {
    $row = $csv[$i]
    
    $slots = @(
        @{ index = 1; name = 'text-sm'; p_main = 'text-lg'; p_frac = 'text-2xs'; links = @('w-full href', 'max-w-[134px] href'); badge = 'text-xs'; original = 'text-sm 2' },
        @{ index = 2; name = 'text-sm 3'; p_main = 'text-lg 2'; p_frac = 'text-2xs 3'; links = @('w-full href 2', 'max-w-[134px] href 2'); badge = 'text-xs 4'; original = 'text-sm 4' },
        @{ index = 3; name = 'text-sm 4'; p_main = 'text-lg 3'; p_frac = 'text-2xs 5'; links = @('w-full href 3', 'max-w-[134px] href 3'); badge = 'text-xs 6'; original = 'text-sm 6' },
        @{ index = 4; name = 'text-sm 5'; p_main = 'text-lg 4'; p_frac = 'text-2xs 7'; links = @('w-full href 4', 'max-w-[134px] href 4'); badge = 'text-xs 9'; original = 'text-sm 8' }
    )

    # Collect all valid links in this row with their indices, slugs, subcategories and IDs
    $rowLinks = @()
    foreach ($slot in $slots) {
        foreach ($linkCol in $slot.links) {
            $linkVal = $row.$linkCol
            if ($linkVal -and $linkVal -match '\/p\/(\d+)') {
                $id = $matches[1]
                $slug = ""
                $urlSubcat = ""
                
                if ($linkVal -match '\/en\/([^\/]+)\/([^\/]+)\/p\/(\d+)') {
                    $urlSubcat = $matches[1]
                    $slug = $matches[2]
                } elseif ($linkVal -match '\/en\/([^\/]+)\/p\/(\d+)') {
                    $slug = $matches[1]
                }
                
                $rowLinks += @{
                    index = $slot.index
                    id = $id
                    url = $linkVal
                    slug = $slug
                    urlSubcat = $urlSubcat
                }
                break
            }
        }
    }

    # Match each name to the best link in this row
    foreach ($slot in $slots) {
        $name = $row.($slot.name)
        if ($name) { $name = $name.Replace([char]0x00A0, " ").Trim() }
        if (-not $name -or $name -eq "") { continue }

        $lowerName = $name.ToLower()
        if ($seenNames.Contains($lowerName)) { continue }

        # Find best matched link in this row
        $bestLink = $null
        $bestScore = -1

        foreach ($l in $rowLinks) {
            $score = Get-OverlapScore -name $name -slug $l.slug -slotIndex $slot.index -linkIndex $l.index
            if ($score -gt $bestScore) {
                $bestScore = $score
                $bestLink = $l
            }
        }

        # Fallback to slot index link if score is very low or no links matched
        if ($bestScore -le 0 -or -not $bestLink) {
            # Find link corresponding to the current slot index
            $matchedFallback = $rowLinks | Where-Object { $_.index -eq $slot.index } | Select-Object -First 1
            if ($matchedFallback) {
                $bestLink = $matchedFallback
            } elseif ($rowLinks.Count -gt 0) {
                $bestLink = $rowLinks[0] # general fallback to first link in row
            }
        }

        if (-not $bestLink) { continue }

        $id = $bestLink.id
        if ($seenIds.Contains($id)) { continue }

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

        # URL Category path
        $urlSubcat = $bestLink.urlSubcat

        # Subcategory mapping
        $subcategory = Get-Subcategory -name $name -urlSubcat $urlSubcat

        # Tag
        $tag = "Fresh"
        $badgeVal = $row.($slot.badge)
        if ($badgeVal -and $badgeVal.Trim() -ne "") {
            $tag = $badgeVal.Trim()
        }

        # Unit (all packaged beverages are pieces)
        $unitVal = "pc"

        # Original Price
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
            category = "beverages"
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

# Step 5: Resolve missing images using name similarity
$matchedProductsWithImage = $products | Where-Object { $_.image -ne $null }
Write-Host "Beverages - Direct images: $($matchedProductsWithImage.Count), Lacking: $($products.Count - $matchedProductsWithImage.Count)"

if ($matchedProductsWithImage.Count -gt 0) {
    $countResolved = 0
    for ($idx = 0; $idx -lt $products.Count; $idx++) {
        $p = $products[$idx]
        if ($p.image -eq $null) {
            $pNameLower = $p.name.ToLower()
            
            # Subcategory fallback
            $subcatFallback = $matchedProductsWithImage | Where-Object { $_.subcategory -eq $p.subcategory } | Select-Object -First 1
            
            # Similarity search
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
            } elseif ($subcatFallback) {
                $p.image = $subcatFallback.image
                $countResolved++
            } else {
                $p.image = $matchedProductsWithImage[0].image
                $countResolved++
            }
        }
    }
    Write-Host "Beverages - Resolved $countResolved missing images via similarity."
} else {
    $defaultImage = "https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&w=400&q=80"
    for ($idx = 0; $idx -lt $products.Count; $idx++) {
        $products[$idx].image = $defaultImage
    }
}

# Re-index IDs to p_bev_1 to p_bev_N
for ($idx = 0; $idx -lt $products.Count; $idx++) {
    $num = $idx + 1
    $products[$idx].id = "p_bev_$num"
}

# Save to JSON
$json = ConvertTo-Json $products -Depth 10
[System.IO.File]::WriteAllText($outputPath, $json, [System.Text.Encoding]::UTF8)

Write-Host "Completed! Extracted $($products.Count) unique Beverages products to $outputPath"
