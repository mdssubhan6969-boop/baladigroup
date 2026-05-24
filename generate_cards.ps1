$categories = @(
    "Refreshes Everyday", "Fruits & Vegetables", "Dairy, Eggs & More", "Poultry, Meat & Seafood", "Food Cupboard", "Breakfast Food", "Bakery", "Deli", "Snacks, Chocolate & More", "Water & Beverages", "Cooking & Baking", "Coffee & Tea", "World Foods", "Frozen Food", "Condiments", "Ice Cream", "Speciality Food", "Roastery", "Oils, Ghee & More", "Rice & Pulses", "Cleaning & Laundry", "Beauty & Fragrances", "Baby Store", "Health & Wellness", "Pet Care", "Mobiles", "TV", "Computer", "Audio", "Perfumes", "Luggage", "Home Appliances", "Kitchen Appliances", "Cooking and Dining", "Apparels & Accessories"
)

$cardsHtml = '<div class="section-header" style="margin-top: 4rem;"><h2>Shop by Category</h2></div>'
$cardsHtml += '<div class="new-categories-grid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(130px, 1fr)); gap: 1rem; margin-bottom: 2rem;">'

foreach ($cat in $categories) {
    $query = $cat -replace ' & ', ' ' -replace ', ', ' ' -replace ' ', '-'
    $url = "https://unsplash.com/ngetty/v3/search/images?fields=display_set%2Creferral_destinations%2Ctitle&page_size=1&query=$query"
    
    $imgUrl = "https://via.placeholder.com/150?text=$query"
    try {
        $response = Invoke-RestMethod -Uri $url -Method Get -Headers @{"User-Agent"="Mozilla/5.0"}
        if ($response.images.Count -gt 0) {
            $imgUrl = $response.images[0].display_sizes[0].uri
        }
    } catch {
        Write-Host "Failed to fetch for $cat"
    }

    $cardsHtml += @"
    <div class="new-category-card" style="text-align: center; cursor: pointer; transition: transform 0.2s; background: var(--bg-alt); border-radius: var(--radius-md); overflow: hidden; border: 1px solid var(--border); box-shadow: var(--shadow-sm);">
        <img src="$imgUrl" alt="$cat" style="width: 100%; height: 120px; object-fit: cover;">
        <h4 style="font-size: 0.85rem; padding: 0.5rem; margin: 0; color: var(--charcoal); font-weight: 600;">$cat</h4>
    </div>
"@
}
$cardsHtml += "</div>"

Out-File -FilePath "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\category_cards.html" -InputObject $cardsHtml -Encoding UTF8
Write-Host "Categories generated!"
