# ============================================================
# Interiors by Sarkinmota - Site Content Update Script
# ============================================================

$baseDir = "c:\Users\Surface pro 6\Downloads\interiora-godmode\interiora.webflow.io"
$files = Get-ChildItem $baseDir -Filter "*.html" -Recurse |
         Where-Object { $_.FullName -notlike "*\template-info\*" }

Write-Host "Found $($files.Count) files to process..."

foreach ($file in $files) {
    Write-Host "  Processing: $($file.Name)"
    $content = Get-Content $file.FullName -Raw -Encoding UTF8

    # ============================================================
    # 1. META TITLES
    # ============================================================
    $content = $content.Replace(
        'Interiora &#x2013; Webflow Ecommerce Website Template',
        'Interiors by Sarkinmota &#x2013; Premium Interior Design Studio, Nigeria'
    )
    $content = $content.Replace(
        'Interiora – Webflow Ecommerce Website Template',
        'Interiors by Sarkinmota – Premium Interior Design Studio, Nigeria'
    )
    # Generic "– Interiora" suffix in all other page titles
    $content = $content -replace ' &#x2013; Interiora', ' &#x2013; Interiors by Sarkinmota'
    $content = $content -replace ' – Interiora', ' – Interiors by Sarkinmota'
    # og:title and twitter:title that reference old name
    $content = $content -replace '(?<=content=")Interiora &#x2013; Webflow Ecommerce Website Template(?=")', 'Interiors by Sarkinmota &#x2013; Premium Interior Design Studio, Nigeria'

    # ============================================================
    # 2. META DESCRIPTIONS (same on all pages originally)
    # ============================================================
    $oldDesc = 'Interiora is a stunning Webflow template created for Interior Design and Architecture studios. With clean aesthetics and sophisticated animations, it simplifies the presentation of your projects with elegance and clarity.'
    $newDesc = 'Interiors by Sarkinmota is a premier interior design studio in Nigeria, crafting exceptional, personalised living and commercial spaces for discerning clients across Lagos, Abuja, and Port Harcourt.'
    $content = $content.Replace($oldDesc, $newDesc)

    # ============================================================
    # 3. LOGO & IMAGE ALT TEXTS
    # ============================================================
    $content = $content.Replace('alt="Logo Icon - Interiora Webflow Template"', 'alt="Logo Icon - Interiors by Sarkinmota"')
    $content = $content.Replace('alt="Logo - Interiora Webflow Template"', 'alt="Logo - Interiors by Sarkinmota"')
    $content = $content.Replace('alt="Template Image - Interiora Webflow Template"', 'alt="Interior Design - Interiors by Sarkinmota"')

    # ============================================================
    # 4. FOOTER - REMOVE HOME 02 & HOME 03 LINKS (by data-w-id)
    # ============================================================
    # Home 02
    $content = [regex]::Replace($content,
        '<a[^>]*data-w-id="f802643e-f83e-2ab5-1618-95ada1bcba94"[^>]*>.*?</a>',
        '')
    # Home 03
    $content = [regex]::Replace($content,
        '<a[^>]*data-w-id="4e9c20df-e66c-ae79-07b6-5baddd442518"[^>]*>.*?</a>',
        '')

    # ============================================================
    # 5. FOOTER - REMOVE CONTACT 02 & CONTACT 03 LINKS
    # ============================================================
    # Contact 02
    $content = [regex]::Replace($content,
        '<a[^>]*data-w-id="58dc11f9-f24a-e355-3b2f-1f6aedeb010d"[^>]*>.*?</a>',
        '')
    # Contact 03
    $content = [regex]::Replace($content,
        '<a[^>]*data-w-id="ac11be98-c80b-4159-828e-d3aea2437dfd"[^>]*>.*?</a>',
        '')

    # ============================================================
    # 6. FOOTER - REMOVE PROJECT 02 & PROJECT 03 LINKS
    # ============================================================
    # Project 02
    $content = [regex]::Replace($content,
        '<a[^>]*data-w-id="65fc594e-7927-a276-1858-b5bba16a8410"[^>]*>.*?</a>',
        '')
    # Project 03
    $content = [regex]::Replace($content,
        '<a[^>]*data-w-id="c716143d-e210-a424-0994-6bcf338fea67"[^>]*>.*?</a>',
        '')

    # ============================================================
    # 7. FOOTER - REMOVE SHOP LINK
    # ============================================================
    $content = [regex]::Replace($content,
        '<a[^>]*data-w-id="3c0d8a72-f7fd-78fb-c1a1-ef379f0e8191"[^>]*>.*?</a>',
        '')

    # ============================================================
    # 8. FOOTER - RENAME REMAINING LINK LABELS
    # ============================================================
    $content = $content.Replace(
        '<div class="link-text text-color-alternate">Home 01</div><div class="link-text text-color-alternate">Home 01</div>',
        '<div class="link-text text-color-alternate">Home</div><div class="link-text text-color-alternate">Home</div>'
    )
    $content = $content.Replace(
        '<div class="link-text text-color-alternate">Contact 01</div><div class="link-text text-color-alternate">Contact 01</div>',
        '<div class="link-text text-color-alternate">Contact</div><div class="link-text text-color-alternate">Contact</div>'
    )
    $content = $content.Replace(
        '<div class="link-text text-color-alternate">Project 01</div><div class="link-text text-color-alternate">Project 01</div>',
        '<div class="link-text text-color-alternate">Projects</div><div class="link-text text-color-alternate">Projects</div>'
    )
    $content = $content.Replace(
        '<div class="link-text text-color-alternate">About us</div><div class="link-text text-color-alternate">About us</div>',
        '<div class="link-text text-color-alternate">About</div><div class="link-text text-color-alternate">About</div>'
    )

    # ============================================================
    # 9. HIDE CART WRAPPER (no shop = no cart)
    # ============================================================
    $content = $content.Replace(
        'class="w-commerce-commercecartwrapper cart" data-node-type="commerce-cart-wrapper"',
        'class="w-commerce-commercecartwrapper cart" data-node-type="commerce-cart-wrapper" style="display:none"'
    )

    # ============================================================
    # 10. FOOTER BOTTOM - REPLACE "CREATED BY" WITH COPYRIGHT
    # ============================================================
    $content = $content.Replace(
        '>CREATED BY<',
        '>&copy; 2025 Interiors by Sarkinmota. All Rights Reserved.<'
    )
    # Hide the Flowaze link
    $content = [regex]::Replace($content,
        '<a[^>]*data-w-id="37b78ce8-6c56-439d-e460-72774bac88e6"[^>]*>.*?</a>',
        '')
    # Hide the "POWERED / Webflow" block entirely by hiding text
    $content = $content.Replace('>POWERED<', ' style="display:none">POWERED<')
    $content = [regex]::Replace($content,
        '<a[^>]*data-w-id="37b78ce8-6c56-439d-e460-72774bac88ef"[^>]*>.*?</a>',
        '')

    # ============================================================
    # 11. FOOTER - HIDE STYLE GUIDE / LICENSES / CHANGELOG LINKS
    # ============================================================
    $content = [regex]::Replace($content,
        '<a[^>]*data-w-id="37b78ce8-6c56-439d-e460-72774bac88f6"[^>]*>.*?</a>',
        '')
    $content = [regex]::Replace($content,
        '<a[^>]*data-w-id="37b78ce8-6c56-439d-e460-72774bac88fc"[^>]*>.*?</a>',
        '')
    $content = [regex]::Replace($content,
        '<a[^>]*data-w-id="37b78ce8-6c56-439d-e460-72774bac8902"[^>]*>.*?</a>',
        '')

    # ============================================================
    # 12. FOOTER TAGLINE (keep but update if needed)
    # ============================================================
    # "Where design meets lifestyle in perfect harmony." - keeping as is, it's good

    # ============================================================
    # 13. SCROLLING TEXT / HERO - BUSINESS NAME
    # ============================================================
    $content = $content.Replace(
        '>We are <span class="featured-scroll-text">Interiora</span>',
        '>We are <span class="featured-scroll-text">Interiors by Sarkinmota</span>'
    )
    $content = $content.Replace('We are Acinteriora', 'We are Interiors by Sarkinmota')
    $content = $content.Replace('We are AcInteriora', 'We are Interiors by Sarkinmota')

    # ============================================================
    # Save with UTF-8 (no BOM)
    # ============================================================
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($file.FullName, $content, $utf8NoBom)
}

Write-Host ""
Write-Host "Phase 1 complete! Universal replacements applied to all pages."
