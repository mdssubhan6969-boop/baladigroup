$csvPath = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\food cupboard.csv"
$outputPath = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\extracted_food_cupboard.json"

if (-not (Test-Path $csvPath)) {
    Write-Error "CSV path not found: $csvPath"
    exit 1
}

$csv = Import-Csv -Path $csvPath

# Step 1: Collect all images in the CSV and map them by product ID
$imageMap = @{}
foreach ($row in $csv) {
    $rowProperties = $row | Get-Member -MemberType NoteProperty
    foreach ($prop in $rowProperties) {
        $val = $row.($prop.Name)
        if ($val -and $val.StartsWith("http") -and $val -match '(\d+)_main\.jpg') {
            $id = $matches[1]
            $imageMap[$id] = $val.Trim()
        }
    }
}

# Step 2: Define categorization function
function Get-Subcategory {
    param(
        [string]$name,
        [string]$urlSubcat
    )
    $lowerName = $name.ToLower()
    $url = $urlSubcat.ToLower()

    # --- Specific Types First (Culinary Type takes priority over country origin) ---
    
    # Oils & Ghee
    if ($lowerName -match "oil|ghee|canola|sunflower|mustard|fry|vegetable ghee|pure ghee|olive oil" -or $url -match "oil|ghee|sunflower-oil|olive-oil|corn-oil|animal-ghee|vegetable-ghee") {
        return "Cooking Ingredients > Oils & Ghee"
    }
    # Spices & Herbs
    if ($lowerName -match "salt|pepper|cumin|coriander powder|turmeric|masala|cinnamon|cardamom|paprika|chilli powder|spice|clove|saffron|chili flakes|powder" -or $url -match "spices|salt|herbs|black-pepper|white-pepper|safron|seasoning|masala-and-mix") {
        return "Cooking Ingredients > Spices & Herbs"
    }
    # Gravy & Stock
    if ($lowerName -match "stock|cube|cubes|bouillon|gravy|maggie|maggi|knorr" -or $url -match "cubes|chicken-cubes|beef-cubes|vegetable-cubes") {
        return "Cooking Ingredients > Gravy & Stock"
    }
    # Breadcrumbs
    if ($lowerName -match "breadcrumb|breadcrumbs|panko") {
        return "Cooking Ingredients > Breadcrumbs"
    }
    
    # Rice
    if ($lowerName -match "rice" -or $url -match "rice") {
        return "Rice, Pasta & Pulses > Rice"
    }
    # Pasta
    if ($lowerName -match "pasta|spaghetti|penne|fusilli|macaroni|lasagna|lasagne|linguine|fettuccine|vermicelli|tagliatelle" -or $url -match "pasta|spaghetti|short-cut-pasta|special-shape-pasta|soup-pasta") {
        return "Rice, Pasta & Pulses > Pasta"
    }
    # Grains & Pulses
    if ($lowerName -match "lentil|lentils|chickpea|chickpeas|beans|pulses|quinoa|bulgur|couscous|barley|kidney bean|chia|flax|popcorn kernel|seeds" -or $url -match "lentils|beans|quinoa|peas|seeds|flax-seeds|chia-flax-seeds") {
        return "Rice, Pasta & Pulses > Grains & Pulses"
    }

    # Chocolates
    if ($lowerName -match "chocolate|chocolates|cocoa|cacao|praline|truffle|nutella|kinder|milka|galaxy|snickers|bounty|twix|kitkat|mars|cadbury|toblerone" -or $url -match "chocolates|choco-spreads|cake-decorating-spreads") {
        return "Chocolate & Confectionery > Chocolates"
    }
    # Gums & Mints
    if ($lowerName -match "gum|gums|chewing" -or $url -eq "chewing-gum") {
        return "Chocolate & Confectionery > Gums & Mints"
    }
    # Candy
    if ($lowerName -match "candy|candies|gummy|gummies|jelly|jellies|marshmallow|marshmallows|lollipop|lollipops|licorice|sweet|sweets|drops|toffees|caramel|fudge" -or $url -match "candy|lollipops|jellies|toffees|sugar-free-candy") {
        return "Chocolate & Confectionery > Candy"
    }

    # Oats
    if ($lowerName -match "oats|oatmeal|rolled oats|quick oats" -or $url -eq "oats") {
        return "Breakfast Cereals & Bars > Oats"
    }
    # Granola
    if ($lowerName -match "granola" -or $url -eq "granola") {
        return "Breakfast Cereals & Bars > Granola"
    }
    # Muesli
    if ($lowerName -match "muesli" -or $url -eq "muesli") {
        return "Breakfast Cereals & Bars > Muesli"
    }
    # Puffs
    if ($lowerName -match "puffed" -or $url -eq "puffs") {
        return "Breakfast Cereals & Bars > Puffs"
    }
    # Cereals
    if ($lowerName -match "cereal|cereals|corn flakes|cornflakes|choco shell|choco shells|froot loops" -or $url -match "cereals|cereal-bars|fruit-nuts-cereals-bars|kids-cereal-bars|lifestyle-cereal-bars|fiber|fiber-cereals|fitness-cereals|kids-cereals") {
        return "Breakfast Cereals & Bars > Cereals"
    }

    # Tuna & Seafood
    if ($lowerName -match "tuna|salmon|sardines|anchovies|sardine|mackerel|seafood" -or $url -match "tuna|salmon") {
        return "Tins, Jars & Packets > Tuna & Seafood"
    }
    # Soup & Instant Noodles
    if ($lowerName -match "soup|soups|instant noodle|instant noodles|ramen|cup noodle|cup noodles|indomie|maggi noodle|noodle cup" -or $url -match "soup|noodles|packet-noodles|cup-noodles|liquid-soups") {
        return "Tins, Jars & Packets > Soup & Instant Noodles"
    }
    # Powdered Milk
    if ($lowerName -match "powdered milk|milk powder|nido|rainbow powder|luna powder" -or $url -eq "powdered-milk") {
        return "Tins, Jars & Packets > Powdered Milk"
    }
    # Pickles & Olives
    if ($lowerName -match "pickle|pickles|pickled|olive|olives|kalamata|caper|capers|jalapeno jar" -or $url -match "pickles|olives|green-olives|gherkins-pickles") {
        return "Tins, Jars & Packets > Pickles & Olives"
    }
    # Canned Meat
    if ($lowerName -match "canned meat|corned beef|luncheon|spam|canned chicken") {
        return "Tins, Jars & Packets > Canned Meat"
    }
    # Coconut Milk
    if ($lowerName -match "coconut milk" -or $url -match "coconut-milk") {
        return "Tins, Jars & Packets > Coconut Milk"
    }
    # Canned Fruits
    if ($lowerName -match "canned fruit|canned fruits|canned pineapple|canned peach|canned peaches") {
        return "Tins, Jars & Packets > Canned Fruits"
    }
    # Coconut Powder
    if ($lowerName -match "coconut powder" -or $url -match "coconut-powder") {
        return "Tins, Jars & Packets > Coconut Powder"
    }
    # Coconut Cream
    if ($lowerName -match "coconut cream" -or $url -match "coconut-cream") {
        return "Tins, Jars & Packets > Coconut Cream"
    }
    # Canned Vegetables
    if ($lowerName -match "canned corn|sweetcorn|canned beans|baked beans|canned peas|canned mushroom|canned tomato|canned tomatoes|chickpeas canned|hummus canned|foul medammes|foul mudammas" -or $url -match "baked-beans|chick-peas-hummos|foul-medamas-broad-beans|mushrooms|peeled-chopped-tomato|mix-vegetables") {
        return "Tins, Jars & Packets > Canned Vegetables"
    }

    # Baking Ingredients
    if ($lowerName -match "baking powder|yeast|vanilla extract|food coloring|gelatine|cornstarch|bicarbonate|baking soda|corn starch" -or $url -match "baking-soda-yeast|food-colouring-essences") {
        return "Baking Essentials > Baking Ingredients"
    }
    # Sugar & Sweeteners
    if ($lowerName -match "sugar|sweetener|sweeteners|stevia|splenda|maple syrup|agave" -or $url -match "sugar|white-sugar|brown-sugar|sugar-substitute") {
        return "Baking Essentials > Sugar & Sweeteners"
    }
    # Flour & Bread Mixes
    if ($lowerName -match "flour|wheat flour|cake mix|pancake mix|muffin mix|cookie mix|dough" -or $url -match "flour|plain-white-flour") {
        return "Baking Essentials > Flour & Bread Mixes"
    }
    # Condensed & Evaporated Milk
    if ($lowerName -match "condensed|evaporated|rainbow milk|rainbow cardation" -or $url -match "evaporated-plain-milk|specialty-milk") {
        return "Baking Essentials > Condensed & Evaporated Milk"
    }

    # Rusk
    if ($lowerName -match "rusk|rusks" -or $url -eq "rusk") {
        return "Biscuits & Crackers > Rusk"
    }
    # Digestives & Assorted Biscuits
    if ($lowerName -match "digestive|digestives|mcvitie" -or $url -eq "digestives") {
        return "Biscuits & Crackers > Digestives & Assorted Biscuits"
    }
    # Filled Biscuits
    if ($lowerName -match "filled biscuit|filled biscuits|cream filled|sandwich biscuit|oreo" -or $url -match "filled|cream-chocolate-filled|date-fruit-filled|filled-dates-chocodates") {
        return "Biscuits & Crackers > Filled Biscuits"
    }
    # Coated Biscuits & Wafers
    if ($lowerName -match "wafer|wafers|coated biscuit|coated biscuits|chocolate coated" -or $url -match "wafers|coated-biscuits") {
        return "Biscuits & Crackers > Coated Biscuits & Wafers"
    }
    # Crackers & Crispbread
    if ($lowerName -match "cracker|crackers|crispbread|crispbreads|ritz|tuc|rice cake|rice cakes" -or $url -eq "crackers") {
        return "Biscuits & Crackers > Crackers & Crispbread"
    }
    # Cakes, Cupcake & Muffins
    if ($lowerName -match "cake|cupcake|cupcakes|muffin|muffins|sponge cake|pound cake|swiss roll|brownie|brownies" -or $url -match "cake|croisant") {
        return "Biscuits & Crackers > Cakes, Cupcake & Muffins"
    }
    # Premium Biscuits
    if ($lowerName -match "premium biscuits|shortbread|butter cookies|cookies" -or $url -match "premuim-biscuits|cookies") {
        return "Biscuits & Crackers > Premium Biscuits"
    }

    # Hand cooked Chips
    if ($lowerName -match "hand cooked|handcooked|kettle" -or $url -eq "hand-cooked-chips") {
        return "Chips, Dips & Snacks > Hand cooked Chips"
    }
    # Tortilla & Nacho
    if ($lowerName -match "tortilla|nacho|nachos|tostitos" -or $url -match "nachos|tortilla") {
        return "Chips, Dips & Snacks > Tortilla & Nacho"
    }
    # Pop Corn
    if ($lowerName -match "popcorn|pop corn" -or $url -eq "pop-corn") {
        return "Chips, Dips & Snacks > Pop Corn"
    }
    # Canister & Puffs
    if ($lowerName -match "canister|puffs|puff|cheese balls|cheese puff|cheese puffs|cheese rings" -or $url -match "canister|puffs") {
        return "Chips, Dips & Snacks > Canister & Puffs"
    }
    # Chips (Standard)
    if ($lowerName -match "chips|lays|pringles|bugles|doritos|cheetos|snack|snacks" -or $url -match "chips|dips|salty-sticks") {
        return "Chips, Dips & Snacks > Chips"
    }

    # Dates
    if ($lowerName -match "date|dates|mabroom|ajwa|medjool|sukari|kheneizi|khadrawi|segal|sagai|date paste" -or $url -match "dates") {
        return "Nuts, Dates & Dried Fruits > Dates"
    }
    # Dried Fruits
    if ($lowerName -match "raisin|raisins|apricot dried|dried apricot|dried fig|dried figs|prunes|dried cranberry|dried fruit|dried fruits" -or $url -eq "dried-fruits") {
        return "Nuts, Dates & Dried Fruits > Dried Fruits"
    }
    # Nuts & Seeds
    if ($lowerName -match "nuts|nut|almond|almonds|cashew|cashews|pistachio|pistachios|walnut|walnuts|peanut|peanuts|hazelnut|hazelnuts|macadamia|pecan|pecans|sunflower seeds|pumpkin seeds" -or $url -match "nuts|almonds|cashew|peanuts|pistachios") {
        return "Nuts, Dates & Dried Fruits > Nuts & Seeds"
    }

    # Honey
    if ($lowerName -match "honey|honeys|sidr|manuka" -or $url -match "honey") {
        return "Jams, Honey & Spreads > Honey"
    }
    # Jams
    if ($lowerName -match "jam|jams|marmalade|preserve|preserves" -or $url -match "jam") {
        return "Jams, Honey & Spreads > Jams"
    }
    # Spreadables
    if ($lowerName -match "spreadable|spreadables|peanut butter|biscoff spread|cookie butter|hazelnut spread|tahina|hallawa|halva|halawa" -or $url -match "spreadables|peanut-butter|tahina|hallawa") {
        return "Jams, Honey & Spreads > Spreadables"
    }
    
    # Cooking Sauces (general fallback for vinegar/dressings/sauces that didn't match specific above)
    if ($lowerName -match "ketchup|mayo|sauce|dressing|vinegar|pesto|marinade|mustard|sriracha|soy|bbq|paste|puree|pure|tabasco" -or $url -match "sauces|ketchup|mayonnaise|mustard|salad-dressings|red-vinegar|white-vinegars|special-vinegars|pizza-sauce|tomato-paste") {
        return "Cooking Ingredients > Cooking Sauces"
    }

    # --- World Specialities (Fallback if not categorized above) ---
    if ($lowerName -match "philippines|filipino|ufc|datu puti|silver swan|boy bawang|nene|pinoy" -or $url -eq "philippines") {
        return "World Specialities > Philippines"
    }
    if ($lowerName -match "mexican|taco|tortilla|salsa|cantina|el paso" -or $url -match "mexican|taco|tortilla") {
        return "World Specialities > Mexican"
    }
    if ($lowerName -match "indian|ashirvaad|haldiram|patanjali|mdh|everest|tata salt|priya|moti|parle-g|britannia|rasgulla|gulab jamun" -or $url -match "indian") {
        return "World Specialities > Indian Food"
    }
    if ($lowerName -match "korean|samyang|nongshim|kimchi|gochujang|buldak" -or $url -eq "korean-food") {
        return "World Specialities > Korean Food"
    }
    if ($lowerName -match "eastern europe|russian|polish|ukrainian|romanian" -or $url -eq "eastern-europe") {
        return "World Specialities > Eastern Europe"
    }
    if ($lowerName -match "thai|pad thai|thai heritage|real thai" -or $url -eq "thai-jasmine-rice") {
        return "World Specialities > Thai Food"
    }
    if ($lowerName -match "italy|italian|barilla|ponti|de cecco|bertolli" -or $url -match "italy|italian") {
        return "World Specialities > Italy"
    }
    if ($lowerName -match "usa|american|hershey|reese|kraft|jack daniel" -or $url -eq "usa") {
        return "World Specialities > USA"
    }
    if ($lowerName -match "chinese|lee kum kee|laoganma" -or $url -eq "chinese-food") {
        return "World Specialities > Chinese Food"
    }
    if ($lowerName -match "south african|mrs balls|nandos|nando's|biltong" -or $url -eq "south-african-food") {
        return "World Specialities > South African Food"
    }
    if ($lowerName -match "french|bonne maman|maille|st dalfour" -or $url -eq "french") {
        return "World Specialities > French"
    }

    # --- Absolute URL fallbacks ---
    if ($url -match "oil|ghee") { return "Cooking Ingredients > Oils & Ghee" }
    if ($url -match "spice|herb|salt") { return "Cooking Ingredients > Spices & Herbs" }
    if ($url -match "sauce|ketchup|mayo|vinegar") { return "Cooking Ingredients > Cooking Sauces" }
    if ($url -match "cube|stock") { return "Cooking Ingredients > Gravy & Stock" }
    if ($url -match "rice") { return "Rice, Pasta & Pulses > Rice" }
    if ($url -match "pasta|spaghetti") { return "Rice, Pasta & Pulses > Pasta" }
    if ($url -match "lentil|bean|pulse") { return "Rice, Pasta & Pulses > Grains & Pulses" }
    if ($url -match "tuna|fish|salmon") { return "Tins, Jars & Packets > Tuna & Seafood" }
    if ($url -match "vegetable|tomato|mushroom|corn") { return "Tins, Jars & Packets > Canned Vegetables" }
    if ($url -match "soup|noodle") { return "Tins, Jars & Packets > Soup & Instant Noodles" }
    if ($url -match "milk|powder") { return "Tins, Jars & Packets > Powdered Milk" }
    if ($url -match "pickle|olive") { return "Tins, Jars & Packets > Pickles & Olives" }
    if ($url -match "meat| luncheon") { return "Tins, Jars & Packets > Canned Meat" }
    if ($url -match "baking|soda|yeast") { return "Baking Essentials > Baking Ingredients" }
    if ($url -match "sugar|sweetener") { return "Baking Essentials > Sugar & Sweeteners" }
    if ($url -match "flour") { return "Baking Essentials > Flour & Bread Mixes" }
    if ($url -match "condensed|evaporated") { return "Baking Essentials > Condensed & Evaporated Milk" }
    if ($url -match "biscuit|cookie") { return "Biscuits & Crackers > Premium Biscuits" }
    if ($url -match "cake|muffin") { return "Biscuits & Crackers > Cakes, Cupcake & Muffins" }
    if ($url -match "wafer|coated") { return "Biscuits & Crackers > Coated Biscuits & Wafers" }
    if ($url -match "cracker") { return "Biscuits & Crackers > Crackers & Crispbread" }
    if ($url -match "digestive") { return "Biscuits & Crackers > Digestives & Assorted Biscuits" }
    if ($url -match "rusk") { return "Biscuits & Crackers > Rusk" }
    if ($url -match "cereal|corn-flake") { return "Breakfast Cereals & Bars > Cereals" }
    if ($url -match "oat") { return "Breakfast Cereals & Bars > Oats" }
    if ($url -match "granola") { return "Breakfast Cereals & Bars > Granola" }
    if ($url -match "muesli") { return "Breakfast Cereals & Bars > Muesli" }
    if ($url -match "chips") { return "Chips, Dips & Snacks > Chips" }
    if ($url -match "pop-corn") { return "Chips, Dips & Snacks > Pop Corn" }
    if ($url -match "nacho|tortilla") { return "Chips, Dips & Snacks > Tortilla & Nacho" }
    if ($url -match "nuts|almond|cashew|peanut|pistachio") { return "Nuts, Dates & Dried Fruits > Nuts & Seeds" }
    if ($url -match "dates") { return "Nuts, Dates & Dried Fruits > Dates" }
    if ($url -match "dried-fruit") { return "Nuts, Dates & Dried Fruits > Dried Fruits" }
    if ($url -match "honey") { return "Jams, Honey & Spreads > Honey" }
    if ($url -match "jam") { return "Jams, Honey & Spreads > Jams" }

    return "Cooking Ingredients > Oils & Ghee"
}

# Step 3: Parse products slot by slot
$products = @()
$seenNames = [System.Collections.Generic.HashSet[string]]::new()
$seenIds = [System.Collections.Generic.HashSet[string]]::new()

for ($i = 0; $i -lt $csv.Count; $i++) {
    $row = $csv[$i]
    
    $slots = @(
        @{ name = 'text-sm'; p_main = 'text-lg'; p_frac = 'text-2xs'; links = @('max-w-[134px] href', 'w-full href'); badge = 'text-xs'; original = 'text-sm 2' },
        @{ name = 'text-sm 3'; p_main = 'text-lg 2'; p_frac = 'text-2xs 3'; links = @('max-w-[134px] href 2', 'w-full href 2'); badge = 'text-xs 5'; original = 'text-sm 4' },
        @{ name = 'text-sm 5'; p_main = 'text-lg 3'; p_frac = 'text-2xs 5'; links = @('max-w-[134px] href 3', 'w-full href 3'); badge = 'text-xs 8'; original = 'text-sm 6' },
        @{ name = 'text-sm 7'; p_main = 'text-lg 4'; p_frac = 'text-2xs 7'; links = @('max-w-[134px] href 4', 'w-full href 4'); badge = 'text-xs 10'; original = 'text-sm 8' }
    )

    foreach ($slot in $slots) {
        $name = $row.($slot.name)
        if ($name) { $name = $name.Replace([char]0x00A0, " ").Trim() }
        if (-not $name -or $name -eq "") { continue }

        $lowerName = $name.ToLower()
        if ($seenNames.Contains($lowerName)) { continue }

        # Get ID from link
        $id = $null
        $linkVal = $null
        foreach ($linkCol in $slot.links) {
            $val = $row.$linkCol
            if ($val -and $val -match '\/p\/(\d+)') {
                $id = $matches[1]
                $linkVal = $val
                break
            }
        }

        if (-not $id) { continue }
        if ($seenIds.Contains($id)) { continue }

        $linkStr = if ($linkVal) { $linkVal.ToLower() } else { "" }

        # Extract price
        $p_main = $row.($slot.p_main)
        $p_frac = $row.($slot.p_frac)
        if ($p_main) { $p_main = $p_main.Trim() }
        if ($p_frac) { $p_frac = $p_frac.Trim() }

        $priceVal = 0.0
        $priceStr = "$p_main$p_frac"
        $priceStr = $priceStr.Replace(" ", "")
        if (-not [double]::TryParse($priceStr, [ref]$priceVal)) {
            continue
        }

        # Image mapping
        $image = $null
        if ($imageMap.ContainsKey($id)) {
            $image = $imageMap[$id]
        }

        # URL Category path
        $urlSubcat = ""
        if ($linkVal -and $linkVal -match '/en/([^/]+)/') {
            $urlSubcat = $matches[1]
        }

        # Subcategory mapping
        $subcategory = Get-Subcategory -name $name -urlSubcat $urlSubcat

        # Tag
        $tag = "Fresh"
        $badgeVal = $row.($slot.badge)
        if ($badgeVal -and $badgeVal.Trim() -ne "") {
            $tag = $badgeVal.Trim()
        }

        # Unit (all food cupboard items are packaged, hence "pc")
        $unitVal = "pc"

        # Original Price
        $originalPriceVal = $null
        $isDealVal = $null
        $origColVal = $row.($slot.original)
        if ($origColVal -and $origColVal -match 'AED\s*([\d\.]+)') {
            $originalPriceVal = [double]$matches[1]
            $isDealVal = $true
            
            # Swap if inverted
            if ($originalPriceVal -lt $priceVal) {
                $temp = $priceVal
                $priceVal = $originalPriceVal
                $originalPriceVal = $temp
            }
        }

        $seenNames.Add($lowerName) | Out-Null
        $seenIds.Add($id) | Out-Null

        $prodObj = @{
            id = $id
            name = $name
            category = "food-cupboard"
            subcategory = $subcategory
            price = $priceVal
            unit = $unitVal
            image = $image
            tag = $tag
        }

        if ($isDealVal) {
            $prodObj["isDeal"] = $true
            $prodObj["originalPrice"] = $originalPriceVal
        }

        $products += $prodObj
    }
}

# Step 4: Resolve missing images using name similarity
$matchedProductsWithImage = $products | Where-Object { $_.image -ne $null }
Write-Host "Food Cupboard - Direct images: $($matchedProductsWithImage.Count), Lacking: $($products.Count - $matchedProductsWithImage.Count)"

if ($matchedProductsWithImage.Count -gt 0) {
    $countResolved = 0
    for ($idx = 0; $idx -lt $products.Count; $idx++) {
        $p = $products[$idx]
        if ($p.image -eq $null) {
            $pNameLower = $p.name.ToLower()
            
            # Subcategory fallback
            $subcatFallback = $matchedProductsWithImage | Where-Object { $_.subcategory -eq $p.subcategory } | Select-Object -First 1
            
            # Similarity search
            $words = $pNameLower.Split(" ,-()[]") | Where-Object { $_.Length -gt 3 -and $_ -ne "fresh" -and $_ -ne "import" }
            $bestMatch = $null
            $bestScore = 0
            foreach ($mItem in $matchedProductsWithImage) {
                $score = 0
                $mNameLower = $mItem.name.ToLower()
                foreach ($w in $words) {
                    if ($mNameLower.Contains($w)) { $score++ }
                }
                if ($score -gt $bestScore) {
                    $bestScore = $score
                    $bestMatch = $mItem
                }
            }

            if ($bestMatch -and $bestScore -gt 0) {
                $p.image = $bestMatch.image
                $countResolved++
            } elseif ($subcatFallback) {
                $p.image = $subcatFallback.image
                $countResolved++
            } else {
                $p.image = $matchedProductsWithImage[0].image
                $countResolved++
            }
        }
    }
    Write-Host "Food Cupboard - Resolved $countResolved missing images via similarity."
} else {
    $defaultImage = "https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&w=400&q=80"
    for ($idx = 0; $idx -lt $products.Count; $idx++) {
        $products[$idx].image = $defaultImage
    }
}

# Re-index IDs to p_fc_1 to p_fc_N
for ($idx = 0; $idx -lt $products.Count; $idx++) {
    $num = $idx + 1
    $products[$idx].id = "p_fc_$num"
}

# Save to JSON
$json = ConvertTo-Json $products -Depth 10
[System.IO.File]::WriteAllText($outputPath, $json, [System.Text.Encoding]::UTF8)

Write-Host "Completed! Extracted $($products.Count) unique Food Cupboard products to $outputPath"
