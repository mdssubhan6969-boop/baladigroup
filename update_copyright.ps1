$Directory = "C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app"

Get-ChildItem -Path $Directory -Filter *.html | ForEach-Object {
    $Content = [System.IO.File]::ReadAllText($_.FullName, [System.Text.Encoding]::UTF8)
    if ($Content -match "Designed with UI/UX Excellence") {
        $NewContent = $Content -replace "Designed with UI/UX Excellence", "Designed by skids"
        [System.IO.File]::WriteAllText($_.FullName, $NewContent, [System.Text.Encoding]::UTF8)
        Write-Host "Updated copyright in $($_.Name)"
    }
}
