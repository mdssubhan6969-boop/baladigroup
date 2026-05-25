$csv = Import-Csv -Path "beverages.csv"

# Global image map: ID -> Image URL
$imageMap = @{}
foreach ($row in $csv) {
    $rowProperties = $row | Get-Member -MemberType NoteProperty
    foreach ($prop in $rowProperties) {
        $val = $row.($prop.Name)
        if ($val -and $val.StartsWith("http") -and $val -match '(\d+)_main\.jpg') {
            $id = $matches[1]
            if ($val -notmatch 'Vector_2|SLA_clock') {
                $imageMap[$id] = $val.Trim()
            }
        }
    }
}

function Get-OverlapScore {
    param(
        [string]$name,
        [string]$slug
    )
    if (-not $slug) { return 0 }
    
    $nameTokens = $name.ToLower().Split(" ,-()[]/&+") | Where-Object { $_.Length -gt 1 -and $_ -ne "pack" -and $_ -ne "bottle" -and $_ -ne "with" -and $_ -ne "free" -and $_ -ne "super" }
    $slugTokens = $slug.ToLower().Split(" ,-()[]/&+") | Where-Object { $_.Length -gt 1 -and $_ -ne "pack" -and $_ -ne "bottle" -and $_ -ne "with" -and $_ -ne "free" -and $_ -ne "super" }
    
    $overlap = 0
    foreach ($token in $nameTokens) {
        if ($slugTokens -contains $token) {
            $overlap++
        }
    }
    return $overlap
}

# Look at first 20 rows
$rowCount = 0
foreach ($row in $csv) {
    if ($rowCount -gt 20) { break }
    $rowCount++

    # Parse slots
    $slots = @(
        @{ index = 1; name = 'text-sm'; p_main = 'text-lg'; p_frac = 'text-2xs'; links = @('w-full href', 'max-w-[134px] href') },
        @{ index = 2; name = 'text-sm 3'; p_main = 'text-lg 2'; p_frac = 'text-2xs 3'; links = @('w-full href 2', 'max-w-[134px] href 2') },
        @{ index = 3; name = 'text-sm 4'; p_main = 'text-lg 3'; p_frac = 'text-2xs 5'; links = @('w-full href 3', 'max-w-[134px] href 3') },
        @{ index = 4; name = 'text-sm 5'; p_main = 'text-lg 4'; p_frac = 'text-2xs 7'; links = @('w-full href 4', 'max-w-[134px] href 4') }
    )

    # Collect all links in this row with their slugs and IDs
    $rowLinks = @()
    foreach ($slot in $slots) {
        foreach ($linkCol in $slot.links) {
            $linkVal = $row.$linkCol
            if ($linkVal -and $linkVal -match '\/en\/([^\/]+)\/([^\/]+)\/p\/(\d+)') {
                $rowLinks += @{
                    col = $linkCol
                    urlSubcat = $matches[1]
                    slug = $matches[2]
                    id = $matches[3]
                    url = $linkVal
                }
                break # Only need one link per slot
            } elseif ($linkVal -and $linkVal -match '\/en\/([^\/]+)\/p\/(\d+)') {
                $rowLinks += @{
                    col = $linkCol
                    urlSubcat = ""
                    slug = $matches[1]
                    id = $matches[2]
                    url = $linkVal
                }
                break
            }
        }
    }

    # Match each name to the best link in this row
    foreach ($slot in $slots) {
        $name = $row.($slot.name)
        if ($name) { $name = $name.Replace([char]0x00A0, " ").Trim() }
        if (-not $name -or $name -eq "") { continue }

        $bestLink = $null
        $bestScore = -1

        foreach ($l in $rowLinks) {
            $score = Get-OverlapScore -name $name -slug $l.slug
            if ($score -gt $bestScore) {
                $bestScore = $score
                $bestLink = $l
            }
        }

        # Fallback to index-based link if score is very low or no links found
        if ($bestScore -le 0 -or -not $bestLink) {
            # Find the link corresponding to slot.index
            $fallbackLinkCol = $slot.links[0]
            $linkVal = $row.$fallbackLinkCol
            if ($linkVal -and $linkVal -match '\/p\/(\d+)') {
                $fallbackId = $matches[1]
                $bestLink = @{
                    id = $fallbackId
                    url = $linkVal
                    slug = ""
                }
            }
        }

        if ($bestLink) {
            $id = $bestLink.id
            $image = $null
            if ($imageMap.ContainsKey($id)) {
                $image = $imageMap[$id]
            }

            Write-Host "Name: '$name'"
            Write-Host "  -> Matched ID: $id (Score: $bestScore)"
            Write-Host "  -> Link: $($bestLink.url)"
            Write-Host "  -> Image: $image"
            Write-Host ""
        }
    }
}
