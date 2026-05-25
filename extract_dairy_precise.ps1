$csvPath = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\dairy & eggs.csv"
$outputPath = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\extracted_dairy.json"

$csv = Import-Csv -Path $csvPath

# Maps to hold data
$imageMap = @{}      # ID -> Image URL
$productData = @()   # List of parsed products before image matching

$count = 1

# First pass: collect all image URLs and map them by ID, and parse all products
foreach ($row in $csv) {
    # 1. Collect all images in the row
    $imageCols = @('rounded-lg src', 'rounded-lg src 2', 'rounded-lg src 3', 'rounded-lg src 4')
    foreach ($col in $imageCols) {
        $imgUrl = $row.$col
        if ($imgUrl) {
            $imgUrl = $imgUrl.Trim()
            if ($imgUrl.StartsWith("http")) {
                # Extract ID from image URL (usually digits before _main.jpg)
                # Example: .../2296917_main.jpg or .../2296917/1778004600/2296917_main.jpg
                if ($imgUrl -match '(\d+)_main\.jpg') {
                    $id = $matches[1]
                    $imageMap[$id] = $imgUrl
                }
            }
        }
    }

    # 2. Parse all name/price blocks in the row
    $mappings = @(
        @{ name = 'text-sm'; p_main = 'text-lg'; p_frac = 'text-2xs'; link = 'max-w-[134px] href' },
        @{ name = 'text-sm 3'; p_main = 'text-lg 2'; p_frac = 'text-2xs 3'; link = 'w-full href 2' }, # Wait, link for col 11 is w-full href 2 or max-w-[134px] href 2?
        @{ name = 'text-sm 4'; p_main = 'text-lg 3'; p_frac = 'text-2xs 5'; link = 'max-w-[134px] href 3' },
        @{ name = 'text-sm 5'; p_main = 'text-lg 4'; p_frac = 'text-2xs 7'; link = 'max-w-[134px] href 4' }
    )

    # Let's dynamically find links by checking all properties in the row for product link formats
    # Product links look like: https://www.carrefouruae.com/mafuae/en/.../p/123456
    # Let's scan all columns in the row for product links and match them by ID
}

# Let's write a robust scanner that loops through the fields in each row, extracts product IDs,
# and groups names, prices, and images by those IDs!
# This is even simpler and more robust because we don't rely on column indices that can shift!

# Let's rebuild the parser with this direct ID grouping logic:
$productsById = @{} # ID -> @{ name, price, image, subcategory }

foreach ($row in $csv) {
    # We will look at all keys in the row
    $rowProperties = $row | Get-Member -MemberType NoteProperty
    
    # Extract IDs from link properties
    foreach ($prop in $rowProperties) {
        $val = $row.($prop.Name)
        if ($val -and $val.StartsWith("http") -and $val -match '\/p\/(\d+)') {
            $id = $matches[1]
            if (-not $productsById.ContainsKey($id)) {
                $productsById[$id] = @{
                    id = $id
                    name = $null
                    price = $null
                    image = $null
                    link = $val
                }
            }
        }
    }

    # Extract IDs from images and map them
    foreach ($prop in $rowProperties) {
        $val = $row.($prop.Name)
        if ($val -and $val.StartsWith("http") -and $val -match '(\d+)_main\.jpg') {
            $id = $matches[1]
            if ($productsById.ContainsKey($id)) {
                $productsById[$id].image = $val
            } else {
                # Save image for later matching
                $productsById[$id] = @{
                    id = $id
                    name = $null
                    price = $null
                    image = $val
                    link = $null
                }
            }
        }
    }
}

# Now do a second pass to extract names and prices, matching them to the closest product block.
# Since names/prices are always in the same row as their corresponding links, we can associate them by row index!
# Let's do a row-based extraction:
$finalProducts = @()
$seenNames = [System.Collections.Generic.HashSet[string]]::new()

for ($i = 0; $i -lt $csv.Count; $i++) {
    $row = $csv[$i]
    
    # We will search the 4 slots in this row
    # Slot 1: Name='text-sm', Price='text-lg'+'text-2xs', Link='max-w-[134px] href' (or 'w-full href')
    # Slot 2: Name='text-sm 3', Price='text-lg 2'+'text-2xs 3', Link='max-w-[134px] href 2' (or 'w-full href 2')
    # Slot 3: Name='text-sm 4', Price='text-lg 3'+'text-2xs 5', Link='max-w-[134px] href 3' (or 'w-full href 3')
    # Slot 4: Name='text-sm 5', Price='text-lg 4'+'text-2xs 7', Link='max-w-[134px] href 4' (or 'w-full href 4')
    
    $slots = @(
        @{ name = 'text-sm'; p_main = 'text-lg'; p_frac = 'text-2xs'; links = @('max-w-[134px] href', 'w-full href') },
        @{ name = 'text-sm 3'; p_main = 'text-lg 2'; p_frac = 'text-2xs 3'; links = @('max-w-[134px] href 2', 'w-full href 2') },
        @{ name = 'text-sm 4'; p_main = 'text-lg 3'; p_frac = 'text-2xs 5'; links = @('max-w-[134px] href 3', 'w-full href 3') },
        @{ name = 'text-sm 5'; p_main = 'text-lg 4'; p_frac = 'text-2xs 7'; links = @('max-w-[134px] href 4', 'w-full href 4') }
    )

    foreach ($slot in $slots) {
        $name = $row.($slot.name)
        if ($name) { $name = $name.Trim() }
        if (-not $name) { continue }

        $lowerName = $name.ToLower()
        if ($seenNames.Contains($lowerName)) { continue }

        # Find the product ID from the link columns for this slot
        $id = $null
        foreach ($linkCol in $slot.links) {
            $linkVal = $row.$linkCol
            if ($linkVal -and $linkVal -match '\/p\/(\d+)') {
                $id = $matches[1]
                break
            }
        }

        # If no link ID found, try to find it by scanning the row properties containing the slot index suffix
        if (-not $id) {
            # fallback: look at link values in the row that match this ID format
            # (e.g. if slot is 3, check properties containing '3')
            # But usually the link is in the slot's links list.
        }

        if (-not $id) { continue }

        # Now get the price
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

        # Get the matched image URL from our global imageMap
        $image = $null
        if ($productsById.ContainsKey($id) -and $productsById[$id].image) {
            $image = $productsById[$id].image
        }

        # If no image matched from the global map, try to search the current row's image columns
        if (-not $image) {
            $imageCols = @('rounded-lg src', 'rounded-lg src 2', 'rounded-lg src 3', 'rounded-lg src 4')
            foreach ($col in $imageCols) {
                $imgUrl = $row.$col
                if ($imgUrl -and $imgUrl -match $id) {
                    $image = $imgUrl
                    break
                }
            }
        }

        # If still no image, search the entire CSV for any image containing this ID
        if (-not $image) {
            foreach ($r in $csv) {
                $imageCols = @('rounded-lg src', 'rounded-lg src 2', 'rounded-lg src 3', 'rounded-lg src 4')
                foreach ($col in $imageCols) {
                    $imgUrl = $r.$col
                    if ($imgUrl -and $imgUrl -match $id) {
                        $image = $imgUrl
                        break
                    }
                }
                if ($image) { break }
            }
        }

        # Only add if we successfully found an image!
        if (-not $image) {
            continue
        }

        $seenNames.Add($lowerName) | Out-Null

        $linkStr = ""
        if ($productsById.ContainsKey($id) -and $productsById[$id].link) {
            $linkStr = $productsById[$id].link.ToLower()
        }

        # Subcategory logic
        $subcategory = "Dairy & Eggs"
        if ($name.ToLower().Contains("yoghurt") -or $name.ToLower().Contains("yogurt") -or $linkStr.Contains("yoghurt") -or $linkStr.Contains("yogurt")) {
            $subcategory = "Dairy & Eggs > Yoghurt"
        } elseif ($name.ToLower().Contains("milk") -or $name.ToLower().Contains("laban") -or $linkStr.Contains("milk") -or $linkStr.Contains("laban")) {
            $subcategory = "Dairy & Eggs > Milk & Laban"
        } elseif ($name.ToLower().Contains("cheese") -or $name.ToLower().Contains("labneh") -or $linkStr.Contains("cheese") -or $linkStr.Contains("labneh")) {
            $subcategory = "Dairy & Eggs > Cheese & Labneh"
        } elseif ($name.ToLower().Contains("butter") -or $name.ToLower().Contains("margarine") -or $name.ToLower().Contains("ghee") -or $linkStr.Contains("butter") -or $linkStr.Contains("ghee")) {
            $subcategory = "Dairy & Eggs > Butter & Margarine"
        } elseif ($name.ToLower().Contains("egg") -or $linkStr.Contains("egg")) {
            $subcategory = "Dairy & Eggs > Eggs"
        } elseif ($name.ToLower().Contains("cream") -or $linkStr.Contains("cream")) {
            $subcategory = "Dairy & Eggs > Cream"
        }

        $finalProducts += @{
            id = "p_de_$count"
            name = $name
            category = "fresh-food"
            subcategory = $subcategory
            price = $priceVal
            unit = "pc"
            image = $image
            tag = "Fresh"
        }
        $count++
    }
}

$json = ConvertTo-Json $finalProducts -Depth 10
[System.IO.File]::WriteAllText($outputPath, $json, [System.Text.Encoding]::UTF8)

Write-Host "Precisely matched and extracted $($finalProducts.Count) unique products with correct images."
