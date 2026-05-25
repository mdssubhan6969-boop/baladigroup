$baseDir = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app"

# Page metadata definition
$pagesMeta = [ordered]@{
    "index.html" = @{
        title = "Baladi Hypermarket | Online Grocery Delivery in Ajman, UAE"
        description = "Shop fresh fruits, vegetables, dairy, meat, seafood, cupboard essentials, & beverages online at Baladi Hypermarket. Fast delivery in Ajman. Order via WhatsApp!"
        robots = "index, follow"
        slug = ""
        schema_type = "GroceryStore"
    }
    "fresh-food.html" = @{
        title = "Fresh Food Online Delivery | Meat, Dairy, Seafood in Ajman | Baladi"
        description = "Get premium cuts of fresh beef, chicken, mutton, daily dairy products, fresh seafood, and deli specialties delivered right to your doorstep in Ajman."
        robots = "index, follow"
        slug = "fresh-food.html"
        schema_type = "BreadcrumbList"
        breadcrumb_name = "Fresh Food"
    }
    "fruits-veg.html" = @{
        title = "Fresh Fruits & Vegetables Delivery in Ajman | Baladi Hypermarket"
        description = "Buy fresh fruits, vegetables, herbs, and leafy greens online. Selected for peak freshness and hand-delivered quickly in Ajman, UAE."
        robots = "index, follow"
        slug = "fruits-veg.html"
        schema_type = "BreadcrumbList"
        breadcrumb_name = "Fruits & Vegetables"
    }
    "food-cupboard.html" = @{
        title = "Food Cupboard Essentials Online | Rice, Oils, Spices in Ajman"
        description = "Stock up on cooking ingredients, spices, oils, rice, pasta, canned food, snacks, and baking essentials at Baladi Hypermarket. Delivery across Ajman."
        robots = "index, follow"
        slug = "food-cupboard.html"
        schema_type = "BreadcrumbList"
        breadcrumb_name = "Food Cupboard"
    }
    "beverages.html" = @{
        title = "Buy Cold Drinks & Beverages Online in Ajman | Baladi Hypermarket"
        description = "Browse mineral water, soft drinks, instant coffee, juices, tea, energy drinks, and powdered beverages. Fast and cold doorstep delivery in Ajman."
        robots = "index, follow"
        slug = "beverages.html"
        schema_type = "BreadcrumbList"
        breadcrumb_name = "Beverages"
    }
    "cart.html" = @{
        title = "Shopping Cart | Baladi Hypermarket"
        description = "Review your shopping cart items, select self-pickup or fast home delivery, and check out directly via WhatsApp at Baladi Hypermarket."
        robots = "noindex, nofollow"
        slug = "cart.html"
        schema_type = "BreadcrumbList"
        breadcrumb_name = "Shopping Cart"
    }
    "about.html" = @{
        title = "About Us & Policies | Baladi Hypermarket Ajman"
        description = "Learn more about Baladi Hypermarket in Ajman, UAE. Read our mission, values, and customer policies."
        robots = "index, follow"
        slug = "about.html"
        schema_type = "BreadcrumbList"
        breadcrumb_name = "About Us"
    }
    "accessibility.html" = @{
        title = "Website Accessibility Statement | Baladi Hypermarket"
        description = "Baladi Hypermarket is committed to ensuring digital accessibility for all visitors. Read our accessibility policies here."
        robots = "index, follow"
        slug = "accessibility.html"
        schema_type = "BreadcrumbList"
        breadcrumb_name = "Accessibility"
    }
    "privacy.html" = @{
        title = "Privacy Policy | Baladi Hypermarket"
        description = "Read the privacy policy of Baladi Hypermarket. Learn how we handle your customer data, cookies, and secure ordering info."
        robots = "index, follow"
        slug = "privacy.html"
        schema_type = "BreadcrumbList"
        breadcrumb_name = "Privacy Policy"
    }
    "return.html" = @{
        title = "Refund and Return Policy | Baladi Hypermarket"
        description = "Check our hassle-free return and refund policy. Learn how to return fresh items, packaged goods, and grocery products."
        robots = "index, follow"
        slug = "return.html"
        schema_type = "BreadcrumbList"
        breadcrumb_name = "Return Policy"
    }
    "tech-shield.html" = @{
        title = "Tech Shield Warranty Services | Baladi Hypermarket"
        description = "Protect your home appliances and electronics with Baladi Hypermarket's Tech Shield warranty. Safe grocery and tech shopping."
        robots = "index, follow"
        slug = "tech-shield.html"
        schema_type = "BreadcrumbList"
        breadcrumb_name = "Tech Shield"
    }
    "terms.html" = @{
        title = "Terms of Service | Baladi Hypermarket"
        description = "Review the terms and conditions for using the Baladi Hypermarket online grocery store and ordering through WhatsApp."
        robots = "index, follow"
        slug = "terms.html"
        schema_type = "BreadcrumbList"
        breadcrumb_name = "Terms of Service"
    }
    "warranty.html" = @{
        title = "Service & Warranty Terms | Baladi Hypermarket"
        description = "Learn about our manufacturer and store warranty terms for electronic goods and appliances bought from Baladi Hypermarket."
        robots = "index, follow"
        slug = "warranty.html"
        schema_type = "BreadcrumbList"
        breadcrumb_name = "Warranty Terms"
    }
}

Write-Host "Verifying SEO metadata across all HTML files...`n"
$failed = $false

foreach ($entry in $pagesMeta.GetEnumerator()) {
    $filename = $entry.Key
    $meta = $entry.Value
    
    $filePath = Join-Path $baseDir $filename
    if (-not (Test-Path $filePath)) {
        Write-Host "FAIL: File $filename not found." -ForegroundColor Red
        $failed = $true
        continue
    }
    
    $content = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)
    $errors = @()
    
    # 1. Check title
    $titles = [regex]::Matches($content, "(?si)<title>(.*?)</title>")
    if ($titles.Count -eq 0) {
        $errors += "Missing <title> tag"
    } elseif ($titles.Count -gt 1) {
        $errors += "Multiple <title> tags found"
    } else {
        $foundTitle = $titles[0].Groups[1].Value.Trim()
        if ($foundTitle -ne $meta.title) {
            $errors += "Title mismatch. Expected: '$($meta.title)', Found: '$foundTitle'"
        }
    }
    
    # 2. Check meta description
    $descMatches = [regex]::Matches($content, "(?si)<meta\s+[^>]*?name=`"description`"\s+content=`"(.*?)`"[^>]*?>")
    if ($descMatches.Count -eq 0) {
        $descMatches = [regex]::Matches($content, "(?si)<meta\s+[^>]*?content=`"(.*?)`"\s+name=`"description`"[^>]*?>")
    }
    if ($descMatches.Count -eq 0) {
        $errors += "Missing <meta name=`"description`"> tag"
    } elseif ($descMatches.Count -gt 1) {
        $errors += "Multiple <meta name=`"description`"> tags found"
    } else {
        $foundDesc = $descMatches[0].Groups[1].Value.Trim()
        if ($foundDesc -ne $meta.description) {
            $errors += "Description mismatch. Expected: '$($meta.description)', Found: '$foundDesc'"
        }
    }
    
    # 3. Check canonical
    $expectedCanonical = "https://baladihypermarket.com/" + $meta.slug
    $canonicalMatches = [regex]::Matches($content, "(?si)<link\s+[^>]*?rel=`"canonical`"\s+href=`"(.*?)`"[^>]*?>")
    if ($canonicalMatches.Count -eq 0) {
        $errors += "Missing canonical link"
    } elseif ($canonicalMatches.Count -gt 1) {
        $errors += "Multiple canonical links found"
    } else {
        $foundCanonical = $canonicalMatches[0].Groups[1].Value.Trim()
        if ($foundCanonical -ne $expectedCanonical) {
            $errors += "Canonical URL mismatch. Expected: '$expectedCanonical', Found: '$foundCanonical'"
        }
    }
    
    # 4. Check Open Graph URL
    $ogUrlMatches = [regex]::Matches($content, "(?si)<meta\s+[^>]*?property=`"og:url`"\s+content=`"(.*?)`"[^>]*?>")
    if ($ogUrlMatches.Count -eq 0) {
        $errors += "Missing og:url"
    } else {
        $foundOgUrl = $ogUrlMatches[0].Groups[1].Value.Trim()
        if ($foundOgUrl -ne $expectedCanonical) {
            $errors += "og:url mismatch. Expected: '$expectedCanonical', Found: '$foundOgUrl'"
        }
    }
    
    # 5. Check Open Graph Title
    $ogTitleMatches = [regex]::Matches($content, "(?si)<meta\s+[^>]*?property=`"og:title`"\s+content=`"(.*?)`"[^>]*?>")
    if ($ogTitleMatches.Count -eq 0) {
        $errors += "Missing og:title"
    } else {
        $foundOgTitle = $ogTitleMatches[0].Groups[1].Value.Trim()
        if ($foundOgTitle -ne $meta.title) {
            $errors += "og:title mismatch. Expected: '$($meta.title)', Found: '$foundOgTitle'"
        }
    }

    # 6. Check Twitter Title
    $twTitleMatches = [regex]::Matches($content, "(?si)<meta\s+[^>]*?name=`"twitter:title`"\s+content=`"(.*?)`"[^>]*?>")
    if ($twTitleMatches.Count -eq 0) {
        $errors += "Missing twitter:title"
    } else {
        $foundTwTitle = $twTitleMatches[0].Groups[1].Value.Trim()
        if ($foundTwTitle -ne $meta.title) {
            $errors += "twitter:title mismatch. Expected: '$($meta.title)', Found: '$foundTwTitle'"
        }
    }

    # 7. Check JSON-LD Schema
    $schemas = [regex]::Matches($content, "(?si)<script\s+[^>]*?type=`"application/ld\+json`"[^>]*?>(.*?)</script>")
    if ($schemas.Count -eq 0) {
        $errors += "Missing JSON-LD schema"
    } else {
        $schemaText = $schemas[0].Groups[1].Value.Trim()
        try {
            # Attempt to parse json
            $jsonObject = ConvertFrom-Json $schemaText
            if ($jsonObject."@type" -ne $meta.schema_type) {
                $errors += "JSON-LD schema type mismatch. Expected: '$($meta.schema_type)', Found: '$($jsonObject."@type")'"
            }
        } catch {
            $errors += "Failed to parse JSON-LD schema: $_"
        }
    }
    
    # 8. Check UTF-8 mojibake patterns
    if ($content.Contains("Ãƒ") -or $content.Contains("Ã¢") -or $content.Contains("Ø¹Ø±Ø¨Ù")) {
        $errors += "Detected Mojibake characters indicating double-encoding or file corruptions!"
    }
    
    if ($errors.Count -gt 0) {
        Write-Host "FAIL: $filename" -ForegroundColor Red
        foreach ($err in $errors) {
            Write-Host "  - $err" -ForegroundColor Red
        }
        $failed = $true
    } else {
        Write-Host "PASS: $filename" -ForegroundColor Green
    }
}

if ($failed) {
    Write-Host "`nSEO Verification failed with errors!" -ForegroundColor Red
    exit 1
} else {
    Write-Host "`nALL 13 HTML PAGES PASSED SEO VERIFICATION!" -ForegroundColor Green
    exit 0
}
