$fruitsPath = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\fruits.csv"
$vegetablesPath = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\vegetables.csv"
$herbsPath = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\herbs.csv"
$outputPath = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\extracted_fruits_veg_herbs.json"

# Helper function to extract products from a CSV and assign category
function Extract-ProductsFromCsv {
    param(
        [string]$csvPath,
        [string]$mainSubcat # "Fruits" or "Vegetables" or "Herbs"
    )

    if (-not (Test-Path $csvPath)) {
        Write-Host "Warning: CSV path not found: $csvPath"
        return @()
    }

    $csv = Import-Csv -Path $csvPath

    # Step 1: Map all images in the CSV by their product ID
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

    # Step 2: Parse products slot by slot
    $products = @()
    $seenNames = [System.Collections.Generic.HashSet[string]]::new()
    $seenIds = [System.Collections.Generic.HashSet[string]]::new()

    for ($i = 0; $i -lt $csv.Count; $i++) {
        $row = $csv[$i]
        
        $slots = @(
            @{ name = 'text-sm'; p_main = 'text-lg'; p_frac = 'text-2xs'; links = @('max-w-[134px] href', 'w-full href'); unit = 'text-xs 3'; original = 'text-sm 2'; badge = 'text-xs' },
            @{ name = 'text-sm 2'; p_main = 'text-lg 2'; p_frac = 'text-2xs 3'; links = @('max-w-[134px] href 2', 'w-full href 2'); unit = 'text-xs 4'; original = 'text-sm 3'; badge = 'text-xs 2' },
            @{ name = 'text-sm 3'; p_main = 'text-lg 3'; p_frac = 'text-2xs 5'; links = @('max-w-[134px] href 3', 'w-full href 3'); unit = 'text-xs 5'; original = 'text-sm 4'; badge = 'text-xs 4' },
            @{ name = 'text-sm 4'; p_main = 'text-lg 4'; p_frac = 'text-2xs 7'; links = @('max-w-[134px] href 4', 'w-full href 4'); unit = 'text-xs 6'; original = 'text-sm 5'; badge = 'text-xs 6' }
        )

        foreach ($slot in $slots) {
            $name = $row.($slot.name)
            if ($name) { 
                # Clean up any non-breaking spaces (U+00A0) and garbled characters
                $name = $name.Replace([char]0x00A0, " ").Trim()
                # Remove garbled double-encoded characters if any
                $name = $name -replace 'Ã\S+\s*', ''
            }
            if (-not $name -or $name -eq "") { continue }

            $lowerName = $name.ToLower()
            if ($seenNames.Contains($lowerName)) { continue }

            # Filter out dairy or irrelevant items if they get mixed up
            if ($lowerName.Contains("yoghurt") -or $lowerName.Contains("yogurt") -or $lowerName.Contains("cheese")) {
                continue
            }

            # Get ID from link columns
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
            if ($seenIds.Contains($id)) { continue }

            $linkStr = if ($linkVal) { $linkVal.ToLower() } else { "" }

            # Price
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

            # Category and Subcategory determination
            $sub = $null
            
            if ($mainSubcat -eq "Herbs") {
                $parentCat = "Herbs"
                $subcategory = "Herbs"
            }
            elseif ($mainSubcat -eq "Fruits") {
                $parentCat = "Fruits"
                
                # Check fruit keywords
                if ($lowerName -match "berry|berries|strawberry|blueberry|raspberry|blackberry|cranberry") { $sub = "Berries" }
                elseif ($lowerName -match "banana") { $sub = "Banana" }
                elseif ($lowerName -match "apple|pink lady|gala|golden delicious|granny smith|red delicious") { $sub = "Apple" }
                elseif ($lowerName -match "orange|navel|valencia") { $sub = "Orange" }
                elseif ($lowerName -match "mandarin|clementine|tangerine|kumquat") { $sub = "Clementine & Mandarin" }
                elseif ($lowerName -match "grape(?!fruit)") { $sub = "Grapes" }
                elseif ($lowerName -match "lemon|lime") { $sub = "Lemon & Lime" }
                elseif ($lowerName -match "melon|watermelon|cantaloupe|sweet melon") { $sub = "Melon" }
                elseif ($lowerName -match "date|dates") { $sub = "Dates" }
                elseif ($lowerName -match "mango") { $sub = "Mango" }
                elseif ($lowerName -match "pineapple") { $sub = "Pineapple" }
                elseif ($lowerName -match "kiwi") { $sub = "Kiwi" }
                elseif ($lowerName -match "avocado") { $sub = "Avocado" }
                elseif ($lowerName -match "packed|cut fruit|fruit bowl|fruit salad|soup|broth|oats") { $sub = "Packed Fruits" }
                elseif ($lowerName -match "pear") { $sub = "Pears" }
                elseif ($lowerName -match "apricot|plum|loquat") { $sub = "Apricot & Plums" }
                elseif ($lowerName -match "peach|nectarine") { $sub = "Peaches & Nectarines" }
                elseif ($lowerName -match "grapefruit|pomelo") { $sub = "Grapefruit & Pomelo" }
                elseif ($lowerName -match "cherry|cherries") { $sub = "Cherries" }
                elseif ($lowerName -match "pomegranate") { $sub = "Pomegranate" }
                elseif ($lowerName -match "exotic|dragon fruit|passion fruit|carambola|fig|papaya|coconut|rambutan|mangosteen|guava|lychee|chickoo|tamarind|coco thumb|phithaya|basket|granadilla") { $sub = "Exotic Fruit" }
                
                # URL fallback for Fruits
                if (-not $sub -and $linkVal -and $linkVal -match '/en/([^/]+)/') {
                    $urlSubcat = $matches[1]
                    switch ($urlSubcat) {
                        "apple" { $sub = "Apple" }
                        "dates" { $sub = "Dates" }
                        "exotic-fruit" { $sub = "Exotic Fruit" }
                        "clementine-mandarin" { $sub = "Clementine & Mandarin" }
                        "packed-fruits" { $sub = "Packed Fruits" }
                        "apricot-plums" { $sub = "Apricot & Plums" }
                        "berries" { $sub = "Berries" }
                        "banana" { $sub = "Banana" }
                        "orange" { $sub = "Orange" }
                        "grapes" { $sub = "Grapes" }
                        "lemon-lime" { $sub = "Lemon & Lime" }
                        "melon" { $sub = "Melon" }
                        "mango" { $sub = "Mango" }
                        "pineapple" { $sub = "Pineapple" }
                        "kiwi" { $sub = "Kiwi" }
                        "avocado" { $sub = "Avocado" }
                        "pears" { $sub = "Pears" }
                        "grapefruit-pomelo" { $sub = "Grapefruit & Pomelo" }
                        "cherries" { $sub = "Cherries" }
                        "peaches-nectarines" { $sub = "Peaches & Nectarines" }
                        "pomegranate" { $sub = "Pomegranate" }
                    }
                }
                
                if (-not $sub) { $sub = "Fruits" }
                $subcategory = "Fruits > $sub"
            }
            elseif ($mainSubcat -eq "Vegetables") {
                $parentCat = "Vegetables"
                
                # Check vegetable keywords
                if ($lowerName -match "corn|maize") { $sub = "Corn" }
                elseif ($lowerName -match "beetroot|turnip|radish|taro|yam|tapioca|colocasia|aravi|ruwaid|drumstick") { $sub = "Root Vegetables" }
                elseif ($lowerName -match "pumpkin|squash|butternut") { $sub = "Pumpkin & Squash" }
                elseif ($lowerName -match "broccoli|cauliflower") { $sub = "Broccoli & Cauliflower" }
                elseif ($lowerName -match "tomato") { $sub = "Tomato" }
                elseif ($lowerName -match "potato(?!s?\s*sweet)") { $sub = "Potato" }
                elseif ($lowerName -match "cabbage|brussel|kale|coleslaw|fennel|asparagus") { $sub = "Cabbage" }
                elseif ($lowerName -match "lettuce|salad|lollo|romaine|mesclun|mesculin|cress|chicory|frisee|iceberg|celery|everyday mix|spring mix|power blend|lolomix|oakleaf") { $sub = "Salads" }
                elseif ($lowerName -match "cucumber") { $sub = "Cucumber" }
                elseif ($lowerName -match "capsicum|chilli|chili|pepper|jalapeno") { $sub = "Capsicum & Chilli" }
                elseif ($lowerName -match "onion|shallot|leek") { $sub = "Onion & Shalots" }
                elseif ($lowerName -match "spinach|leaves|chard|microgreens|rucola|rocket|cheera|salak|molekhia|pechay|kangkong|greens|sprout|tofu|crunchy leaf") { $sub = "Packed Leaves" }
                elseif ($lowerName -match "mushroom|enoki|portobello|shiitake|oyster") { $sub = "Mushrooms" }
                elseif ($lowerName -match "carrot") { $sub = "Carrot" }
                elseif ($lowerName -match "garlic|ginger") { $sub = "Garlic & Ginger" }
                elseif ($lowerName -match "cut|sliced|peeled|chopped|diced|shredded|zoodles|rice|noodles|noodle") { $sub = "Cut Vegetables" }
                elseif ($lowerName -match "zucchini|courgette|marrow") { $sub = "Zucchini" }
                elseif ($lowerName -match "beans|peas|okra|bhindi|edamame|tindly|green bean") { $sub = "Beans & Peas" }
                elseif ($lowerName -match "eggplant|aubergine") { $sub = "Eggplant" }
                
                # URL fallback for Vegetables
                if (-not $sub -and $linkVal -and $linkVal -match '/en/([^/]+)/') {
                    $urlSubcat = $matches[1]
                    switch ($urlSubcat) {
                        "packed-leaves-salad" { $sub = "Packed Leaves" }
                        "salads" { $sub = "Salads" }
                        "root-vegetables" { $sub = "Root Vegetables" }
                        "cabbage" { $sub = "Cabbage" }
                        "beans-peas" { $sub = "Beans & Peas" }
                        "corn" { $sub = "Corn" }
                        "pumpkin-squash" { $sub = "pumpkin & Squash" }
                        "broccoli-cauliflower" { $sub = "Broccoli & Cauliflower" }
                        "tomato" { $sub = "Tomato" }
                        "potato" { $sub = "Potato" }
                        "cucumber" { $sub = "Cucumber" }
                        "capsicum-chilli" { $sub = "Capsicum & Chilli" }
                        "onion-shallot" { $sub = "Onion & Shalots" }
                        "mushroom" { $sub = "Mushrooms" }
                        "carrot" { $sub = "Carrot" }
                        "garlic-ginger" { $sub = "Garlic & Ginger" }
                        "cut-vegetables" { $sub = "Cut Vegetables" }
                        "zucchini" { $sub = "Zucchini" }
                        "eggplant" { $sub = "Eggplant" }
                    }
                }
                
                if (-not $sub) { $sub = "Vegetables" }
                $subcategory = "Vegetables > $sub"
            }

            # Tag
            $tag = "Fresh"
            $badgeVal = $row.($slot.badge)
            if ($badgeVal -and $badgeVal.Trim() -ne "") {
                $tag = $badgeVal.Trim()
            }

            # Unit determination: default is kg for loose items, pc for pre-packaged/unit items
            $unitVal = "kg"
            if ($lowerName -match '\b\d+(?:\.\d+)?\s*(?:g|kg|gm|piece|pc|pkg|pack|piece|oz|lbs|ml|l)\b') {
                $unitVal = "pc"
            }
            if ($lowerName -match 'pack|piece|pc|bunch|bag|pot|punnet|bowl|box|bundle|noodle|tofu|seeds|mesh|net|tray|cup|tub|bucket|basket|wrapper|cellophane|cling') {
                $unitVal = "pc"
            }

            # Original Price
            $originalPriceVal = $null
            $isDealVal = $null
            $origColVal = $row.($slot.original)
            if ($origColVal -and $origColVal -match 'AED\s*([\d\.]+)') {
                $originalPriceVal = [double]$matches[1]
                $isDealVal = $true
            }

            # Swap if inverted
            if ($isDealVal -and $originalPriceVal -lt $priceVal) {
                $temp = $priceVal
                $priceVal = $originalPriceVal
                $originalPriceVal = $temp
            }

            $seenNames.Add($lowerName) | Out-Null
            $seenIds.Add($id) | Out-Null

            $prodObj = @{
                id = $id
                name = $name
                category = "fruits-veg"
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

    # Step 3: Resolve missing images using name similarity
    $matchedProductsWithImage = $products | Where-Object { $_.image -ne $null }
    Write-Host "$mainSubcat - Direct images: $($matchedProductsWithImage.Count), Lacking: $($products.Count - $matchedProductsWithImage.Count)"

    if ($matchedProductsWithImage.Count -gt 0) {
        $countResolved = 0
        for ($idx = 0; $idx -lt $products.Count; $idx++) {
            $p = $products[$idx]
            if ($p.image -eq $null) {
                $pNameLower = $p.name.ToLower()
                
                # Predefined subcategory fallback image
                $subcatFallback = $matchedProductsWithImage | Where-Object { $_.subcategory -eq $p.subcategory } | Select-Object -First 1
                
                # Dynamic word matching
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
        Write-Host "$mainSubcat - Resolved $countResolved missing images via similarity."
    } else {
        # Fallbacks if NO images at all in CSV (e.g. herbs.csv might be tiny)
        $defaultImage = "https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&w=400&q=80"
        if ($mainSubcat -eq "Herbs") {
            $defaultImage = "https://images.unsplash.com/photo-1596040033229-a9821ebd058d?auto=format&fit=crop&w=400&q=80"
        }
        for ($idx = 0; $idx -lt $products.Count; $idx++) {
            $products[$idx].image = $defaultImage
        }
        Write-Host "$mainSubcat - Hardcoded $($(products.Count)) images because no direct images exist."
    }

    return $products
}

# Extract all three categories
$fruits = Extract-ProductsFromCsv -csvPath $fruitsPath -mainSubcat "Fruits"
$vegetables = Extract-ProductsFromCsv -csvPath $vegetablesPath -mainSubcat "Vegetables"
$herbs = Extract-ProductsFromCsv -csvPath $herbsPath -mainSubcat "Herbs"

$combined = @()
foreach ($f in $fruits) { $combined += $f }
foreach ($v in $vegetables) { $combined += $v }
foreach ($h in $herbs) { $combined += $h }

# Re-index IDs to p_fv_1 to p_fv_N
for ($idx = 0; $idx -lt $combined.Count; $idx++) {
    $num = $idx + 1
    $combined[$idx].id = "p_fv_$num"
}

# Convert to JSON
$json = ConvertTo-Json $combined -Depth 10
[System.IO.File]::WriteAllText($outputPath, $json, [System.Text.Encoding]::UTF8)

Write-Host "Completed! Extracted $($combined.Count) unique Fruits, Vegetables, and Herbs products to $outputPath"
