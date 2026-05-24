$ErrorActionPreference = "Stop"
$csvPath = "C:\Users\sky\Downloads\carrefouruae (3).csv"
$outPath = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\new_products.json"

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
    
    $subcategory = ""
    switch ($rawCategory) {
        "vegan-cheese" { $subcategory = "Dairy & Eggs > Cheese & Labneh" }
        "spread-processed-cheese" { $subcategory = "Dairy & Eggs > Cheese & Labneh" }
        "edam-slices" { $subcategory = "Dairy & Eggs > Cheese & Labneh" }
        "shredded-grated-cheese" { $subcategory = "Dairy & Eggs > Cheese & Labneh" }
        "italian-cheese" { $subcategory = "Dairy & Eggs > Cheese & Labneh" }
        "burrata" { $subcategory = "Dairy & Eggs > Cheese & Labneh" }
        "mozzarella-whey-cheese" { $subcategory = "Dairy & Eggs > Cheese & Labneh" }
        "local-cheese" { $subcategory = "Dairy & Eggs > Cheese & Labneh" }
        "french-cheese" { $subcategory = "Dairy & Eggs > Cheese & Labneh" }
        "cheddar-cheese" { $subcategory = "Dairy & Eggs > Cheese & Labneh" }
        "soft-cheese-cottage" { $subcategory = "Dairy & Eggs > Cheese & Labneh" }
        "labneh" { $subcategory = "Dairy & Eggs > Cheese & Labneh" }
        "greek-yogurt" { $subcategory = "Dairy & Eggs > Yoghurt" }
        "low-fat-yogurt" { $subcategory = "Dairy & Eggs > Yoghurt" }
        "full-fat-yogurt" { $subcategory = "Dairy & Eggs > Yoghurt" }
        "flavored-greek-yogurt" { $subcategory = "Dairy & Eggs > Yoghurt" }
        "flavoured-yoghurt" { $subcategory = "Dairy & Eggs > Yoghurt" }
        "probiotic-yoghurt" { $subcategory = "Dairy & Eggs > Yoghurt" }
        "drinking-yogurt" { $subcategory = "Dairy & Eggs > Yoghurt" }
        "flavored-laban" { $subcategory = "Dairy & Eggs > Milk & Laban" }
        "plain-laban" { $subcategory = "Dairy & Eggs > Milk & Laban" }
        "full-fat-milk" { $subcategory = "Dairy & Eggs > Milk & Laban" }
        "uht-flavored-milk" { $subcategory = "Dairy & Eggs > Milk & Laban" }
        "uht-milk-low-fat" { $subcategory = "Dairy & Eggs > Milk & Laban" }
        "brown-eggs" { $subcategory = "Dairy & Eggs > Eggs" }
        "white-eggs" { $subcategory = "Dairy & Eggs > Eggs" }
        "omega-3-eggs" { $subcategory = "Dairy & Eggs > Eggs" }
        "unsalted-butter" { $subcategory = "Dairy & Eggs > Butter & Margarine" }
        "frozen-unsalted-butter" { $subcategory = "Dairy & Eggs > Butter & Margarine" }
        "whipping-cream" { $subcategory = "Dairy & Eggs > Cream" }
        "whole-chicken" { $subcategory = "Meat & Poultry > Chicken" }
        "chicken-wings" { $subcategory = "Meat & Poultry > Chicken" }
        "chicken" { $subcategory = "Meat & Poultry > Chicken" }
        "chicken-leg" { $subcategory = "Meat & Poultry > Chicken" }
        "chicken-thigh" { $subcategory = "Meat & Poultry > Chicken" }
        "prepared-chicken" { $subcategory = "Meat & Poultry > Chicken" }
        "beef" { $subcategory = "Meat & Poultry > Beef" }
        "minced-meat" { $subcategory = "Meat & Poultry > Beef" }
        "australian-beef" { $subcategory = "Meat & Poultry > Beef" }
        "brazilian-beef" { $subcategory = "Meat & Poultry > Beef" }
        "australian-lamb" { $subcategory = "Meat & Poultry > Lamb" }
        "asian-veal" { $subcategory = "Meat & Poultry > Veal" }
        "poultry-offals" { $subcategory = "Meat & Poultry > Offals" }
        "lamb-offals" { $subcategory = "Meat & Poultry > Offals" }
        "sea-foods" { $subcategory = "Fish & Seafood > Fish" }
        "fish" { $subcategory = "Fish & Seafood > Fish" }
        "crab" { $subcategory = "Fish & Seafood > Seafood" }
        "fresh-shrimp" { $subcategory = "Fish & Seafood > Seafood" }
        "smoked-roasted-turkey" { $subcategory = "Chilled Food Counter > Cold Cuts & Meat Snacks" }
        "turkey" { $subcategory = "Chilled Food Counter > Cold Cuts & Meat Snacks" }
        "smoked-roasted-beef" { $subcategory = "Chilled Food Counter > Cold Cuts & Meat Snacks" }
        "olives" { $subcategory = "Chilled Food Counter > Olives & Antipasti" }
        "pickles" { $subcategory = "Chilled Food Counter > Olives & Antipasti" }
        "antipasti" { $subcategory = "Chilled Food Counter > Olives & Antipasti" }
        "cakes-tarts-pastry" { $subcategory = "Food To Go > Appetizers & Bites" }
    }
    }
    
    if ($subcategory -ne "") {
        $name = $row."text-sm"
        if ($name) { $name = $name.Trim() }
        if (-not $name) { continue }
        if ($seenNames.ContainsKey($name)) { continue }
        $seenNames[$name] = $true

        $image = $row."rounded-lg src"
        if (-not $image -or -not $image.StartsWith("http")) {
            $image = "🛒"
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
                id = "csv-ff-$count"
                name = $name
                category = "fresh-food"
                subcategory = $subcategory
                price = $price
                unit = $unit
                image = $image
                tag = "Fresh"
            }
            $products += $product
            $count++
        }
    }
}

$products | ConvertTo-Json -Depth 5 | Out-File -FilePath $outPath
Write-Host "Exported $($products.Length) fresh food products."
