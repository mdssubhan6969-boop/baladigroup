$dairyPath = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\extracted_dairy.json"
$meatPath = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\extracted_meat.json"
$seafoodPath = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\extracted_seafood.json"
$foodtogoPath = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\extracted_foodtogo.json"
$chilledDessertsPath = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\extracted_chilled_desserts.json"
$chilledFoodCounterPath = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\extracted_chilled_food_counter.json"
$fruitsVegHerbsPath = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\extracted_fruits_veg_herbs.json"
$foodCupboardPath = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\extracted_food_cupboard.json"
$beveragesPath = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\extracted_beverages.json"
$cartJsPath = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\js\cart.js"

$dairyJson = Get-Content -Raw -Path $dairyPath
$meatJson = Get-Content -Raw -Path $meatPath
$seafoodJson = Get-Content -Raw -Path $seafoodPath
$foodtogoJson = Get-Content -Raw -Path $foodtogoPath
$chilledDessertsJson = Get-Content -Raw -Path $chilledDessertsPath
$chilledFoodCounterJson = Get-Content -Raw -Path $chilledFoodCounterPath
$fruitsVegHerbsJson = Get-Content -Raw -Path $fruitsVegHerbsPath
$foodCupboardJson = Get-Content -Raw -Path $foodCupboardPath
$beveragesJson = Get-Content -Raw -Path $beveragesPath

$dairy = $dairyJson | ConvertFrom-Json
$meat = $meatJson | ConvertFrom-Json
$seafood = $seafoodJson | ConvertFrom-Json
$foodtogo = $foodtogoJson | ConvertFrom-Json
$chilledDesserts = $chilledDessertsJson | ConvertFrom-Json
$chilledFoodCounter = $chilledFoodCounterJson | ConvertFrom-Json
$fruitsVegHerbs = $fruitsVegHerbsJson | ConvertFrom-Json
$foodCupboard = $foodCupboardJson | ConvertFrom-Json
$beverages = $beveragesJson | ConvertFrom-Json

# Merge list
$merged = @()
foreach ($d in $dairy) { $merged += $d }
foreach ($m in $meat) { $merged += $m }
foreach ($s in $seafood) { $merged += $s }
foreach ($f in $foodtogo) { $merged += $f }
foreach ($cd in $chilledDesserts) { $merged += $cd }
foreach ($cfc in $chilledFoodCounter) { $merged += $cfc }
foreach ($fv in $fruitsVegHerbs) { $merged += $fv }
foreach ($fc in $foodCupboard) { $merged += $fc }
foreach ($bv in $beverages) { $merged += $bv }

Write-Host "Total products in merged list: $($merged.Count) ($($dairy.Count) dairy, $($meat.Count) meat, $($seafood.Count) seafood, $($foodtogo.Count) foodtogo, $($chilledDesserts.Count) chilledDesserts, $($chilledFoodCounter.Count) chilledFoodCounter, $($fruitsVegHerbs.Count) fruitsVegHerbs, $($foodCupboard.Count) foodCupboard, $($beverages.Count) beverages)"

# Convert merged list to clean JSON
$mergedJson = $merged | ConvertTo-Json -Depth 10

# Read current cart.js
$cartJs = Get-Content -Raw -Path $cartJsPath

# Replace the PRODUCTS array
$regex = "(?s)const PRODUCTS = (?:\[.*?\]|\{.*?\});"
$replacement = "const PRODUCTS = $mergedJson;"
$newCartJs = $cartJs -replace $regex, $replacement

# Verify replacement worked
if ($newCartJs -eq $cartJs) {
    Write-Error "Failed to find 'const PRODUCTS = [...];' pattern in js/cart.js!"
    exit 1
}

[System.IO.File]::WriteAllText($cartJsPath, $newCartJs, [System.Text.Encoding]::UTF8)
Write-Host "Successfully merged and injected $($merged.Count) products into js/cart.js."
