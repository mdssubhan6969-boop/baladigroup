$csvPath = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\dairy & eggs.csv"
$outputPath = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\extracted_dairy.json"

$csv = Import-Csv -Path $csvPath

$products = @()
$seen = [System.Collections.Generic.HashSet[string]]::new()

$count = 1

foreach ($row in $csv) {
    # We have 4 products per row
    $mappings = @(
        # @{ name_col = 'colName'; img_col = 'colName'; p_main_col = 'colName'; p_frac_col = 'colName'; link_col = 'colName' }
        @{ name = 'text-sm'; img = 'rounded-lg src'; p_main = 'text-lg'; p_frac = 'text-2xs'; link = 'w-full href' },
        @{ name = 'text-sm 3'; img = 'rounded-lg src 2'; p_main = 'text-lg 2'; p_frac = 'text-2xs 3'; link = 'w-full href 2' },
        @{ name = 'text-sm 4'; img = 'rounded-lg src 3'; p_main = 'text-lg 3'; p_frac = 'text-2xs 5'; link = 'w-full href 3' },
        @{ name = 'text-sm 5'; img = 'rounded-lg src 4'; p_main = 'text-lg 4'; p_frac = 'text-2xs 7'; link = 'w-full href 4' }
    )

    foreach ($map in $mappings) {
        $name = $row.($map.name)
        if ($name) {
            $name = $name.Trim()
        }
        
        if (-not $name) {
            continue
        }

        $lowerName = $name.ToLower()
        if ($seen.Contains($lowerName)) {
            continue
        }

        $image = $row.($map.img)
        if ($image) { $image = $image.Trim() }
        if (-not $image -or -not $image.StartsWith("http")) {
            continue
        }

        $p_main = $row.($map.p_main)
        $p_frac = $row.($map.p_frac)
        if ($p_main) { $p_main = $p_main.Trim() }
        if ($p_frac) { $p_frac = $p_frac.Trim() }

        $priceVal = 0.0
        try {
            $priceStr = "$p_main$p_frac"
            $priceStr = $priceStr.Replace(" ", "")
            if ([double]::TryParse($priceStr, [ref]$priceVal)) {
                # Parsed successfully
            } else {
                continue
            }
        } catch {
            continue
        }

        $seen.Add($lowerName) | Out-Null

        $link = ""
        if ($row.($map.link)) {
            $link = $row.($map.link).ToLower()
        }

        # Subcategory logic
        $subcategory = "Dairy & Eggs"
        if ($name.ToLower().Contains("yoghurt") -or $name.ToLower().Contains("yogurt") -or $link.Contains("yoghurt") -or $link.Contains("yogurt")) {
            $subcategory = "Dairy & Eggs > Yoghurt"
        } elseif ($name.ToLower().Contains("milk") -or $name.ToLower().Contains("laban") -or $link.Contains("milk") -or $link.Contains("laban")) {
            $subcategory = "Dairy & Eggs > Milk & Laban"
        } elseif ($name.ToLower().Contains("cheese") -or $name.ToLower().Contains("labneh") -or $link.Contains("cheese") -or $link.Contains("labneh")) {
            $subcategory = "Dairy & Eggs > Cheese & Labneh"
        } elseif ($name.ToLower().Contains("butter") -or $name.ToLower().Contains("margarine") -or $name.ToLower().Contains("ghee") -or $link.Contains("butter") -or $link.Contains("ghee")) {
            $subcategory = "Dairy & Eggs > Butter & Margarine"
        } elseif ($name.ToLower().Contains("egg") -or $link.Contains("egg")) {
            $subcategory = "Dairy & Eggs > Eggs"
        } elseif ($name.ToLower().Contains("cream") -or $link.Contains("cream")) {
            $subcategory = "Dairy & Eggs > Cream"
        }

        $products += @{
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

$json = ConvertTo-Json $products -Depth 10
[System.IO.File]::WriteAllText($outputPath, $json, [System.Text.Encoding]::UTF8)

Write-Host "Extracted $($products.Count) unique dairy products."
