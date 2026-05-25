$baseDir = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app"
$files = Get-ChildItem -Path $baseDir -Filter *.html

# Define characters safely
$star_char = [char]0x2605 # '★'
$five_stars = [string]($star_char) * 5

# Garbled star representations
# 1. â˜… (UTF-8 bytes of ★ decoded as Windows-1252)
# â is U+00E2, ˜ is U+02DC, … is U+2026
$g_star1 = [string][char]0x00E2 + [char]0x02DC + [char]0x2026
$g_five1 = $g_star1 * 5

# 2. Ã¢Ëœâ€¦ (Double-encoded ★)
# Codes from real test output:
# 00C3 : Ã
# 00A2 : ¢
# 00CB : Ë
# 0153 : œ
# 00E2 : â
# 20AC : €
# 00A6 : ¦
$g_star2 = [string][char]0x00C3 + [char]0x00A2 + [char]0x00CB + [char]0x0153 + [char]0x00E2 + [char]0x20AC + [char]0x00A6
$g_five2 = $g_star2 * 5

# Arabic text replacements
# عربي is [char]0x0639 + [char]0x0631 + [char]0x0628 + [char]0x064a
$ar_clean = [string][char]0x0639 + [char]0x0631 + [char]0x0628 + [char]0x064a

# Garbled عربي is Ø¹Ø±Ø¨ÙŠ
# Ø is U+00D8, ¹ is U+00B9, Ø is U+00D8, ± is U+00B1, Ù is U+00D9, Š is U+0160 (or others)
$ar_garbled1 = [string][char]0x00D8 + [char]0x00B9 + [char]0x00D8 + [char]0x00B1 + [char]0x00D9 + [char]0x0160
$ar_garbled2 = [string][char]0x00D8 + [char]0x00B9 + [char]0x00D8 + [char]0x00B1 + [char]0x00D9 + [char]0x008A
$ar_garbled3 = [string][char]0x00D8 + [char]0x00B9 + [char]0x00D8 + [char]0x00B1 + [char]0x00D9 + [char]0x008c
$ar_garbled4 = [string][char]0x00D8 + [char]0x00B9 + [char]0x00D8 + [char]0x00B1 + [char]0x00D9 + [char]0x2039

Write-Host "Starting replacement..."

foreach ($file in $files) {
    $filePath = $file.FullName
    Write-Host "Processing $filePath..."
    $content = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)
    $original = $content

    # Replace stars
    $content = $content.Replace($g_five2, $five_stars)
    $content = $content.Replace($g_five1, $five_stars)
    $content = $content.Replace($g_star2, $star_char)
    $content = $content.Replace($g_star1, $star_char)
    
    # Replace Arabic language switcher
    $content = $content.Replace($ar_garbled1, $ar_clean)
    $content = $content.Replace($ar_garbled2, $ar_clean)
    $content = $content.Replace($ar_garbled3, $ar_clean)
    $content = $content.Replace($ar_garbled4, $ar_clean)
    
    # Fallback plain string replace
    $content = $content.Replace("Ø¹Ø±Ø¨ÙŠ", $ar_clean)

    # For index.html, inject testimonials
    if ($file.Name -eq "index.html") {
        Write-Host "Injecting clean testimonials into index.html..."
        $cleanTestimonialsPath = Join-Path $baseDir "scratch\clean_testimonials.html"
        if (Test-Path $cleanTestimonialsPath) {
            $cleanHTML = [System.IO.File]::ReadAllText($cleanTestimonialsPath, [System.Text.Encoding]::UTF8)
            
            # Locate and replace using Regex
            $pattern = '(?s)(<div\s+class="testimonials-deck"\s+id="testimonials-deck">).*?(</div>\s*</div>\s*<div\s+class="testimonials-shuffle-btn-wrapper">)'
            if ($content -match $pattern) {
                $replacement = '${1}' + "`r`n" + $cleanHTML + "`r`n          " + '${2}'
                $content = [regex]::Replace($content, $pattern, $replacement)
                Write-Host "Successfully injected testimonials deck!"
            } else {
                Write-Host "Regex match failed for testimonials deck!"
            }
        } else {
            Write-Host "Clean testimonials file not found!"
        }
    }

    if ($content -ne $original) {
        [System.IO.File]::WriteAllText($filePath, $content, [System.Text.Encoding]::UTF8)
        Write-Host "Saved changes for $filePath"
    } else {
        Write-Host "No changes for $filePath"
    }
}
Write-Host "Done!"
