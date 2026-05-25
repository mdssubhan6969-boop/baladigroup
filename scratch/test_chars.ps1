$content = [System.IO.File]::ReadAllText('C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\beverages.html', [System.Text.Encoding]::UTF8)
$idx = $content.IndexOf('Leave a Review ')
if ($idx -ge 0) {
    $sub = $content.Substring($idx + 15, 35)
    $chars = $sub.ToCharArray()
    foreach ($c in $chars) {
        Write-Host ( "{0:X4} : {1}" -f [int]$c, $c )
    }
} else {
    Write-Host "Not found"
}
