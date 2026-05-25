$content = [System.IO.File]::ReadAllText('C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\js\cart.js', [System.Text.Encoding]::UTF8)
# Look for PRODUCTS array or categories definition
# Let's extract all unique category and subcategory pairs from the PRODUCTS array
# A product looks like: {id: "...", name: "...", category: "...", subcategory: "...", ...}
# Let's find unique categories and subcategories in the file
$pattern = 'category:\s*["'']([^"'']+)["''],\s*subcategory:\s*["'']([^"'']+)["'']'
$matches = [regex]::Matches($content, $pattern)
$uniquePairs = @{}
foreach ($m in $matches) {
    $cat = $m.Groups[1].Value
    $sub = $m.Groups[2].Value
    $key = "$cat | $sub"
    $uniquePairs[$key] = $true
}
foreach ($k in $uniquePairs.Keys | Sort-Object) {
    Write-Host $k
}
