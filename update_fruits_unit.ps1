$cartJsPath = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\js\cart.js"
$cartJs = Get-Content -Raw -Path $cartJsPath

# Locate the PRODUCTS array in cart.js
$regex = "(?s)const PRODUCTS = (\[.*?\]);"
if ($cartJs -match $regex) {
    $productsJson = $matches[1]
    $products = $productsJson | ConvertFrom-Json
    
    $countUpdated = 0
    foreach ($p in $products) {
        if ($p.category -eq "fruits-veg") {
            if ($p.unit -ne "kg") {
                $p.unit = "kg"
                $countUpdated++
            }
        }
    }
    
    Write-Host "Updated $countUpdated fruits-veg products to unit 'kg'."
    
    # Convert back to clean JSON
    $updatedProductsJson = ConvertTo-Json $products -Depth 10
    
    $replacement = "const PRODUCTS = $updatedProductsJson;"
    $newCartJs = $cartJs -replace "(?s)const PRODUCTS = \[.*?\];", $replacement
    
    [System.IO.File]::WriteAllText($cartJsPath, $newCartJs, [System.Text.Encoding]::UTF8)
    Write-Host "Successfully wrote updated products to js/cart.js."
} else {
    Write-Error "Failed to locate PRODUCTS array in js/cart.js."
}
