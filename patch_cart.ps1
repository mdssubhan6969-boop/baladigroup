$content = Get-Content -Path "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\js\cart.js" -Raw

# Remove the 'Pantry > ', 'Fresh > ' prefixes from subcategories
$content = $content -replace 'Fresh \\u003e ', '' -replace 'Pantry \\u003e ', '' -replace 'Produce \\u003e ', '' -replace 'Drinks \\u003e ', ''
$content = $content -replace 'Fresh > ', '' -replace 'Pantry > ', '' -replace 'Produce > ', '' -replace 'Drinks > ', ''

# The old image function
$oldFunc = 'function getProductImageHTML(imageStr, name, extraStyle = '''') {
  if (imageStr && (imageStr.startsWith(''http://'') || imageStr.startsWith(''https://''))) {
    return `<img src="${imageStr}" alt="${name}" style="width: 100%; height: 100%; object-fit: contain; max-height: 100%; ${extraStyle}">`;
  }
  return imageStr || ''🛒'';
}'

# The new image function to fix 403s with no-referrer and add an onerror handler
$newFunc = 'function getProductImageHTML(imageStr, name, extraStyle = '''') {
  if (imageStr && (imageStr.startsWith(''http://'') || imageStr.startsWith(''https://''))) {
    return `<img src="${imageStr}" alt="${name}" referrerpolicy="no-referrer" onerror="this.onerror=null; this.src=''https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&w=300&q=80''; this.style.opacity=''0.4'';" style="width: 100%; height: 100%; object-fit: contain; max-height: 100%; ${extraStyle}">`;
  }
  return imageStr || ''🛒'';
}'

$content = $content.Replace($oldFunc, $newFunc)

Out-File -FilePath "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\js\cart.js" -InputObject $content -Encoding UTF8
Write-Host "cart.js patched!"
