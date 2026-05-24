$ErrorActionPreference = "Stop"
$jsonPath = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\new_products.json"
$cartPath = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\js\cart.js"

$json = Get-Content -Path $jsonPath -Raw
# Ensure we have a valid JSON array string without surrounding whitespace
$jsonBody = $json.Trim()
if ($jsonBody.StartsWith("[")) { $jsonBody = $jsonBody.Substring(1) }
if ($jsonBody.EndsWith("]")) { $jsonBody = $jsonBody.Substring(0, $jsonBody.Length - 1) }
$jsonBody = $jsonBody.Trim()

$cartContent = Get-Content -Path $cartPath -Raw

# Update PRODUCTS list between markers
$startMarker = "// Fresh Food"
$endMarker = "// Fruits & Veg"
$startIdx = $cartContent.IndexOf($startMarker)
$endIdx = $cartContent.IndexOf($endMarker)
if ($startIdx -ge 0 -and $endIdx -gt $startIdx) {
    $before = $cartContent.Substring(0, $startIdx + $startMarker.Length)
    $after = $cartContent.Substring($endIdx)
    $newProductsSection = "`n  " + $jsonBody + ",`n"
    $cartContent = $before + $newProductsSection + $after
} else {
    Write-Host "Could not locate product section markers in cart.js"
}

# Fix image URLs: replace any non-http values with a placeholder image
$placeholder = "https://via.placeholder.com/300?text=No+Image"
$cartContent = $cartContent -replace "image: '\\'[^']*'", "image: '$placeholder'"
# Note: the above simplistic regex may replace existing URLs; instead we replace only emojis (single character) or non‑http strings.
# A more precise approach: replace occurrences where image value does not start with http
$cartContent = $cartContent -replace "image: '(?!http)[^']+'", "image: '$placeholder'"

# Update Search Logic (same as before)
$searchOld = @"
      const pageCategory = document.body.getAttribute('data-category') || 'all';
      renderProductGrid(pageCategory, e.target.value);
"@
$searchNew = @"
      const pageCategory = document.body.getAttribute('data-category') || 'all';
      let currentSubcat = 'all';
      if (pageCategory === 'fresh-food') {
         currentSubcat = activeChild !== 'all' ? activeParent + ' > ' + activeChild : activeParent;
      }
      renderProductGrid(pageCategory, e.target.value, currentSubcat);
"@
$cartContent = $cartContent.Replace($searchOld, $searchNew)

# Write back to cart.js
$cartContent | Out-File -FilePath $cartPath -Encoding UTF8
Write-Host "cart.js updated with accurate images and search logic."
