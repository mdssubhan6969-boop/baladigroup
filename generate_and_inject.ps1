$csvPath = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\carrefouruae (3).csv"
$cartPath = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\js\cart.js"

$csvData = Import-Csv -Path $csvPath

$products = @()
$seenNames = @{}
$count = 1

foreach ($row in $csvData) {
    $url = $row."w-full href"
    if (-not $url) { $url = $row."max-w-[134px] href" }
    if (-not $url) { continue }

    $parts = $url -split "/en/"
    if ($parts.Length -lt 2) { continue }
    
    $rawCategory = ($parts[1] -split "/")[0]
    
    $mainCategory = "food-cupboard"
    $subcategory = "Pantry > Others"
    
    if ($rawCategory -match "cheese|yogurt|butter|milk|eggs|cream|chicken|beef|lamb|veal|offals|fish|crab|shrimp|turkey|olives|pickles|antipasti") {
        $mainCategory = "fresh-food"
        $subcategory = "Fresh > " + $rawCategory
    } elseif ($rawCategory -match "fruit|veg|apple|banana|tomato|potato|onion|herb|salad") {
        $mainCategory = "fruits-veg"
        $subcategory = "Produce > " + $rawCategory
    } elseif ($rawCategory -match "water|juice|drink|tea|coffee|soda|beverage") {
        $mainCategory = "beverages"
        $subcategory = "Drinks > " + $rawCategory
    } else {
        $mainCategory = "food-cupboard"
        $subcategory = "Pantry > " + $rawCategory
    }
    
    $name = $row."text-sm"
    if ($name) { $name = $name.Trim() }
    if (-not $name) { continue }
    if ($seenNames.ContainsKey($name)) { continue }
    $seenNames[$name] = $true

    $image = $row."rounded-lg src"
    if (-not $image -or -not $image.StartsWith("http")) {
        $image = "https://via.placeholder.com/300?text=No+Image"
    }

    $unitInfo = $row."text-xs 3"
    $unit = "pc"
    if ($unitInfo -match "per Kilo") { $unit = "kg" }
    if ($unitInfo -match "per Liter") { $unit = "L" }
    
    $priceMain = $row."text-lg"
    if ($priceMain) { $priceMain = $priceMain.Trim() }
    
    $priceFraction = $row."text-2xs"
    if ($priceFraction) { $priceFraction = $priceFraction.Trim() }
    
    $priceStr = "${priceMain}${priceFraction}"
    
    $price = 0.0
    if ([double]::TryParse($priceStr, [ref]$price)) {
        $product = @{
            id = "prod-$count"
            name = $name
            category = $mainCategory
            subcategory = $subcategory
            price = $price
            unit = $unit
            image = $image
            tag = "New"
        }
        $products += $product
        $count++
    }
}

$jsonBody = $products | ConvertTo-Json -Depth 5 -Compress
Write-Host "Generated $($products.Length) products."

$cartContent = Get-Content -Path $cartPath -Raw

# Replace everything from `const PRODUCTS = [` to the matching `];` 
$regex = [regex]::new("const PRODUCTS\s*=\s*\[.*?\];", [System.Text.RegularExpressions.RegexOptions]::Singleline)

$newText = "const PRODUCTS = " + $jsonBody + ";"
$cartContent = $regex.Replace($cartContent, $newText, 1)

$cartContent | Out-File -FilePath $cartPath -Encoding UTF8
Write-Host "Injected products into cart.js"
