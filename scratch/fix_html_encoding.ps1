$indexPath = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\index.html"
if (Test-Path $indexPath) {
    Write-Host "Fixing index.html garbled texts..."
    $content = [System.IO.File]::ReadAllText($indexPath, [System.Text.Encoding]::UTF8)

    # 1. Fix Arabic language switcher in header
    $content = $content.Replace("Ø¹Ø±Ø¨ÙŠ", "عربي")

    # 2. Fix stars
    $content = $content.Replace("â˜…â˜…â˜…â˜…â˜…", "★★★★★")
    $content = $content.Replace("â˜…", "★")
    $content = $content.Replace("Ã¢Ëœâ€¦Ã¢Ëœâ€¦Ã¢Ëœâ€¦Ã¢Ëœâ€¦Ã¢Ëœâ€¦", "★★★★★")
    $content = $content.Replace("Ã¢Ëœâ€¦", "★")

    # 3. Fix Card 0 (Tarek El-Masry)
    $oldCard0Text = '"Ø£Ù  Ø¶Ù„ Ø³ÙˆØ¨Ø±Ù…Ø§Ø±ÙƒØª Ù„Ù„Ù…Ù†ØªØ¬Ø§Øª Ø§Ù„Ù…ØµØ±ÙŠØ© Ù  ÙŠ Ø¹Ø¬Ù…Ø§Ù†! Ø§Ù„Ù…Ù„ÙˆØ®ÙŠØ© ÙˆØ§Ù„Ø¬Ø¨Ù†Ø© Ø§Ù„Ù  Ø¯ÙŠÙ…Ø© ÙˆØ§Ù„ÙƒØ´Ø±ÙŠ Ø·Ø§Ø²Ø¬Ø© ÙˆÙ…Ù…ØªØ§Ø²Ø©. ÙƒØ£Ù  Ù†Ùƒ Ù  ÙŠ Ù…ØµØ±!"'
    # Sometimes spacing is slightly different, let's target the exact raw text:
    $oldCard0Text_2 = '"Ø£Ù  Ø¶Ù„ Ø³ÙˆØ¨Ø±Ù…Ø§Ø±ÙƒØª Ù„Ù„Ù…Ù†ØªØ¬Ø§Øª Ø§Ù„Ù…ØµØ±ÙŠØ© Ù  ÙŠ Ø¹Ø¬Ù…Ø§Ù†! Ø§Ù„Ù…Ù„ÙˆØ®ÙŠØ© ÙˆØ§Ù„Ø¬Ø¨Ù†Ø© Ø§Ù„Ù‚Ø¯ÙŠÙ…Ø© ÙˆØ§Ù„ÙƒØ´Ø±ÙŠ Ø·Ø§Ø²Ø¬Ø© ÙˆÙ…Ù…ØªØ§Ø²Ø©. ÙƒØ£Ù  Ù†Ùƒ Ù  ÙŠ Ù…ØµØ±!"'
    $oldCard0Text_3 = '"Ø£Ù  Ø¶Ù„ Ø³ÙˆØ¨Ø±Ù…Ø§Ø±ÙƒØª Ù„Ù„Ù…Ù†ØªØ¬Ø§Øª Ø§Ù„Ù…ØµØ±ÙŠØ© Ù  ÙŠ Ø¹Ø¬Ù…Ø§Ù†! Ø§Ù„Ù…Ù„ÙˆØ®ÙŠØ© ÙˆØ§Ù„Ø¬Ø¨Ù†Ø© Ø§Ù„Ù‚Ø¯ÙŠÙ…Ø© ÙˆØ§Ù„ÙƒØ´Ø±ÙŠ Ø·Ø§Ø²Ø¬Ø© ÙˆÙ…Ù…ØªØ§Ø²Ø©. ÙƒØ£Ù†Ùƒ Ù  ÙŠ Ù…ØµØ±!"'
    $oldCard0Text_4 = '"Ø£Ù  Ø¶Ù„ Ø³ÙˆØ¨Ø±Ù…Ø§Ø±ÙƒØª Ù„Ù„Ù…Ù†ØªØ¬Ø§Øª Ø§Ù„Ù…ØµØ±ÙŠØ© Ù ÙŠ Ø¹Ø¬Ù…Ø§Ù†! Ø§Ù„Ù…Ù„ÙˆØ®ÙŠØ© ÙˆØ§Ù„Ø¬Ø¨Ù†Ø© Ø§Ù„Ù‚Ø¯ÙŠÙ…Ø© ÙˆØ§Ù„ÙƒØ´Ø±ÙŠ Ø·Ø§Ø²Ø¬Ø© ÙˆÙ…Ù…ØªØ§Ø²Ø©. ÙƒØ£Ù†Ùƒ Ù Ù Ù…ØµØ±!"'
    
    # We can replace the whole line:
    $content = $content.Replace('"Ø£Ù  Ø¶Ù„ Ø³ÙˆØ¨Ø±Ù…Ø§Ø±ÙƒØª Ù„Ù„Ù…Ù†ØªØ¬Ø§Øª Ø§Ù„Ù…ØµØ±ÙŠØ© Ù ÙŠ Ø¹Ø¬Ù…Ø§Ù†! Ø§Ù„Ù…Ù„ÙˆØ®ÙŠØ© ÙˆØ§Ù„Ø¬Ø¨Ù†Ø© Ø§Ù„Ù‚Ø¯ÙŠÙ…Ø© ÙˆØ§Ù„ÙƒØ´Ø±ÙŠ Ø·Ø§Ø²Ø¬Ø© ÙˆÙ…Ù…ØªØ§Ø²Ø©. ÙƒØ£Ù†Ùƒ Ù ÙŠ Ù…ØµØ±!"', '"أفضل سوبرماركت للمنتجات المصرية في عجمان! الملوخية والجبنة القديمة والكشري طازجة وممتازة. كأنك في مصر!"')
    $content = $content.Replace('Ø·Ø§Ø±Ù‚ Ø§Ù„Ù…ØµØ±ÙŠ', 'طارق المصري')

    # 4. Fix Card 1 (Amira Hegazi)
    $content = $content.Replace('"Ø®Ø¯Ù…Ø© Ø§Ù„ØªÙˆØµÙŠÙ„ Ø§Ù„Ø³Ø±ÙŠØ¹Ø© Ø¹Ø¨Ø± Ø§Ù„ÙˆØ§ØªØ³Ø§Ø¨ Ù…Ù…ØªØ§Ø²Ø© Ø¬Ø¯Ø§Ù‹. Ø§Ù„Ù…Ø§Ù†Ø¬Ùˆ Ø§Ù„Ù…ØµØ±ÙŠ ÙˆØ§Ù„Ø¹ÙŠØ­ Ø§Ù„Ø¨Ù„Ø¯ÙŠ Ø·Ø§Ø²Ø¬ ÙˆØ¬Ù…ÙŠÙ„. Ø£Ù†ØµØ­ Ø¨Ù‡ Ø¨Ø´Ø¯Ø©."', '"خدمة التوصيل السريعة عبر الواتساب ممتازة جداً. المانجو المصري والعيش البلدي طازج وجميل. أنصح به بشدة."')
    $content = $content.Replace('Ø£Ù…ÙŠØ±Ø© Ø­Ø¬Ø§Ø²ÙŠ', 'أميرة حجازي')

    # 5. Fix Card 2 (Youssef Mansour)
    $content = $content.Replace('"Ø£Ø³Ø¹Ø§Ø± Ù…Ù…ØªØ§Ø²Ø© ÙˆÙ…ÙƒØ§Ù† Ù†Ø¸ÙŠÙ  Ø¬Ø¯Ø§Ù‹. Ø§Ù„Ù„Ø­ÙˆÙ… Ø§Ù„Ø·Ø§Ø²Ø¬Ø© ÙˆØ§Ù„Ø¨Ù„Ø¯ÙŠ Ù…Ù…ØªØ§Ø²Ø©. Ù ÙƒØ±Ø© ØªØ­Ù…ÙŠÙ„ Ø§Ù„Ù  Ø§ØªÙˆØ±Ø© ÙˆØ§Ù„Ø¯Ù  Ø¹ Ø¹Ø¨Ø± Ø§Ù„ÙˆØ§ØªØ³Ø§Ø¨ Ù…Ø±ÙŠØ­Ø© Ù„Ù„ØºØ§ÙŠØ©."', '"أسعار ممتازة ومكان نظيف جداً. اللحوم الطازجة والبلدي ممتازة. فكرة تحميل الفاتورة والدفع عبر الواتساب مريحة للغاية."')
    $content = $content.Replace('"Ø£Ø³Ø¹Ø§Ø± Ù…Ù…ØªØ§Ø²Ø© ÙˆÙ…ÙƒØ§Ù† Ù†Ø¸ÙŠÙ  Ø¬Ø¯Ø§Ù‹. Ø§Ù„Ù„Ø­ÙˆÙ… Ø§Ù„Ø·Ø§Ø²Ø¬Ø© ÙˆØ§Ù„Ø¨Ù„Ø¯ÙŠ Ù…Ù…ØªØ§Ø²Ø©. Ù ÙƒØرو ØªØ­Ù…ÙŠÙ„ Ø§Ù„Ù  Ø§ØªÙˆØ±Ø© ÙˆØ§Ù„Ø¯Ù  Ø¹ Ø¹Ø¨Ø± Ø§Ù„ÙˆØ§ØªØ³Ø§Ø¨ Ù…Ø±ÙŠØ­Ø© Ù„Ù„ØºØ§ÙŠØ©."', '"أسعار ممتازة ومكان نظيف جداً. اللحوم الطازجة والبلدي ممتازة. فكرة تحميل الفاتورة والدفع عبر الواتساب مريحة للغاية."')
    # Let's also do a general substring replacement to capture any slight spelling variation:
    $content = $content.Replace('Ø£Ø³Ø¹Ø§Ø± Ù…Ù…ØªØ§Ø²Ø© ÙˆÙ…ÙƒØ§Ù† Ù†Ø¸ÙŠÙ  Ø¬Ø¯Ø§Ù‹', 'أسعار ممتازة ومكان نظيف جداً')
    $content = $content.Replace('Ø§Ù„Ù„Ø­ÙˆÙ… Ø§Ù„Ø·Ø§Ø²Ø¬Ø© ÙˆØ§Ù„Ø¨Ù„Ø¯ÙŠ Ù…Ù…ØªØ§Ø²Ø©', 'اللحوم الطازجة والبلدي ممتازة')
    $content = $content.Replace('Ù ÙƒØ±Ø© ØªØ­Ù…ÙŠÙ„ Ø§Ù„Ù  Ø§ØªÙˆØ±Ø© ÙˆØ§Ù„Ø¯Ù  Ø¹ Ø¹Ø¨Ø±', 'فكرة تحميل الفاتورة والدفع عبر')
    $content = $content.Replace('Ø§Ù„ÙˆØ§ØªØ³Ø§Ø¨ Ù…Ø±ÙŠØ­Ø© Ù„Ù„ØºØ§ÙŠØ©', 'الواتساب مريحة للغاية')
    $content = $content.Replace('ÙŠÙˆØ³Ù  Ù…Ù†ØµÙˆØ±', 'يوسف منصور')

    # Save fixed file
    [System.IO.File]::WriteAllText($indexPath, $content, [System.Text.Encoding]::UTF8)
    Write-Host "index.html updated successfully."
}

# Fix all other HTML files (primarily stars in the footer)
$htmlFiles = Get-ChildItem -Path "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app" -Filter *.html -Recurse
foreach ($file in $htmlFiles) {
    Write-Host "Processing $($file.Name)..."
    $fileContent = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    
    $modified = $false
    
    # Replace the footer reviews star string
    if ($fileContent.Contains("Ã¢Ëœâ€¦Ã¢Ëœâ€¦Ã¢Ëœâ€¦Ã¢Ëœâ€¦Ã¢Ëœâ€¦")) {
        $fileContent = $fileContent.Replace("Ã¢Ëœâ€¦Ã¢Ëœâ€¦Ã¢Ëœâ€¦Ã¢Ëœâ€¦Ã¢Ëœâ€¦", "★★★★★")
        $modified = $true
    }
    if ($fileContent.Contains("Ã¢Ëœâ€¦")) {
        $fileContent = $fileContent.Replace("Ã¢Ëœâ€¦", "★")
        $modified = $true
    }
    if ($fileContent.Contains("â˜…â˜…â˜…â˜…â˜…")) {
        $fileContent = $fileContent.Replace("â˜…â˜…â˜…â˜…â˜…", "★★★★★")
        $modified = $true
    }
    if ($fileContent.Contains("â˜…")) {
        $fileContent = $fileContent.Replace("â˜…", "★")
        $modified = $true
    }
    if ($fileContent.Contains("Ø¹Ø±Ø¨ÙŠ")) {
        $fileContent = $fileContent.Replace("Ø¹Ø±Ø¨ÙŠ", "عربي")
        $modified = $true
    }

    if ($modified) {
        [System.IO.File]::WriteAllText($file.FullName, $fileContent, [System.Text.Encoding]::UTF8)
        Write-Host "Fixed star/text encoding in $($file.Name)"
    }
}
