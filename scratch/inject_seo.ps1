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

# Base schema templates
$grocerySchema = @'
{
  "@context": "https://schema.org",
  "@type": "GroceryStore",
  "name": "Baladi Hypermarket",
  "image": "https://baladihypermarket.com/Baladi_Hypermarket_Door.png",
  "@id": "https://baladihypermarket.com/#store",
  "url": "https://baladihypermarket.com/",
  "telephone": "+971526278571",
  "priceRange": "$$",
  "address": {
    "@type": "PostalAddress",
    "streetAddress": "Al Naseem Street, Al Rashidiya 1",
    "addressLocality": "Ajman",
    "addressRegion": "Ajman",
    "postalCode": "00000",
    "addressCountry": "AE"
  },
  "geo": {
    "@type": "GeoCoordinates",
    "latitude": 25.4093,
    "longitude": 55.4389
  },
  "openingHoursSpecification": {
    "@type": "OpeningHoursSpecification",
    "dayOfWeek": [
      "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"
    ],
    "opens": "08:00",
    "closes": "02:00"
  },
  "sameAs": [
    "https://www.facebook.com/baladihypermarket",
    "https://www.instagram.com/baladihypermarket"
  ]
}
'@

$breadcrumbSchemaTemplate = @'
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {
      "@type": "ListItem",
      "position": 1,
      "name": "Home",
      "item": "https://baladihypermarket.com/"
    },
    {
      "@type": "ListItem",
      "position": 2,
      "name": "PLACEHOLDER_NAME",
      "item": "PLACEHOLDER_URL"
    }
  ]
}
'@

Write-Host "Starting SEO tag injection across HTML files..."

$successCount = 0

foreach ($entry in $pagesMeta.GetEnumerator()) {
    $filename = $entry.Key
    $meta = $entry.Value
    
    $filePath = Join-Path $baseDir $filename
    if (-not (Test-Path $filePath)) {
        Write-Host "Warning: File $filename not found." -ForegroundColor Yellow
        continue
    }
    
    Write-Host "Processing $filename..."
    
    # Read file with explicit UTF-8 to preserve all Arabic and special chars
    $content = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)
    
    # Remove existing <title> tags (case-insensitive, multi-line)
    $content = [regex]::Replace($content, "(?si)<title>.*?</title>", "")
    
    # Remove existing meta description tags (various formatting)
    $content = [regex]::Replace($content, "(?si)<meta\s+[^>]*?name=`"description`"[^>]*?>", "")
    $content = [regex]::Replace($content, "(?si)<meta\s+[^>]*?content=`"[^`"]*`"\s+name=`"description`"[^>]*?>", "")
    
    # Generate JSON-LD Schema
    if ($meta.schema_type -eq "GroceryStore") {
        $schema = $grocerySchema
    } else {
        $canonicalUrl = "https://baladihypermarket.com/" + $meta.slug
        $schema = $breadcrumbSchemaTemplate.Replace("PLACEHOLDER_NAME", $meta.breadcrumb_name).Replace("PLACEHOLDER_URL", $canonicalUrl)
    }
    
    # Build SEO Injection Block
    $title = $meta.title
    $description = $meta.description
    $robots = $meta.robots
    $canonicalUrl = "https://baladihypermarket.com/" + $meta.slug
    
    $seoBlock = @"

  <title>$title</title>
  <meta name="description" content="$description">
  <meta name="robots" content="$robots">
  <link rel="canonical" href="$canonicalUrl" />
  <meta property="og:title" content="$title" />
  <meta property="og:description" content="$description" />
  <meta property="og:image" content="https://baladihypermarket.com/Baladi_Hypermarket_Door.png" />
  <meta property="og:url" content="$canonicalUrl" />
  <meta property="og:type" content="website" />
  <meta property="og:site_name" content="Baladi Hypermarket" />
  <meta name="twitter:card" content="summary_large_image" />
  <meta name="twitter:title" content="$title" />
  <meta name="twitter:description" content="$description" />
  <meta name="twitter:image" content="https://baladihypermarket.com/Baladi_Hypermarket_Door.png" />
  <script type="application/ld+json">
$schema
  </script>
"@
    
    # Find <head> tag to insert SEO block immediately after it
    $headPattern = "(?i)<head\b[^>]*>"
    if ($content -match $headPattern) {
        $match = [regex]::Match($content, $headPattern)
        $insertPos = $match.Index + $match.Length
        
        $content = $content.Substring(0, $insertPos) + $seoBlock + $content.Substring($insertPos)
        
        # Write file back in UTF-8
        [System.IO.File]::WriteAllText($filePath, $content, [System.Text.Encoding]::UTF8)
        Write-Host "Successfully injected SEO tags into $filename." -ForegroundColor Green
        $successCount++
    } else {
        Write-Host "Error: Could not find <head> tag in $filename!" -ForegroundColor Red
    }
}

Write-Host "`nCompleted: Injected SEO metadata into $successCount files." -ForegroundColor Green
