$jsonPath = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\extracted_dairy.json"
$cartJsPath = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\js\cart.js"

$json = Get-Content -Raw -Path $jsonPath
$cartJs = Get-Content -Raw -Path $cartJsPath

# Replace the PRODUCTS array
$regex = "(?s)const PRODUCTS = \[.*?\];"
$replacement = "const PRODUCTS = $json;"
$newCartJs = $cartJs -replace $regex, $replacement

[System.IO.File]::WriteAllText($cartJsPath, $newCartJs, [System.Text.Encoding]::UTF8)
Write-Host "Injected products database into js/cart.js successfully."
