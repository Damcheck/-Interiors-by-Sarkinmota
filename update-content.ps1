# ============================================================
# Interiors by Sarkinmota - Page Content Update Script
# ============================================================

function UpdateFile($path, $replacements) {
    if (-not (Test-Path $path)) { Write-Host "SKIP (not found): $path"; return }
    $raw = [System.IO.File]::ReadAllBytes($path)
    $s = [System.Text.Encoding]::UTF8.GetString($raw)
    foreach ($r in $replacements) {
        if ($r.IsRegex) {
            $s = [regex]::Replace($s, $r.Old, $r.New)
        } else {
            $s = $s.Replace($r.Old, $r.New)
        }
    }
    $outBytes = [System.Text.Encoding]::UTF8.GetBytes($s)
    [System.IO.File]::WriteAllBytes($path, $outBytes)
    Write-Host "Updated: $(Split-Path $path -Leaf)"
}

$base = "c:\Users\Surface pro 6\Downloads\interiora-godmode\Interiors By Sarkinmota"

# ==============================================================
# UNIVERSAL - testimonial client names & CTA text (all pages)
# ==============================================================
$allHtml = Get-ChildItem $base -Filter "*.html" -Recurse |
           Where-Object { $_.FullName -notlike "*\template-info\*" }

foreach ($file in $allHtml) {
    $raw = [System.IO.File]::ReadAllBytes($file.FullName)
    $s = [System.Text.Encoding]::UTF8.GetString($raw)

    # Client names & locations
    $s = $s.Replace('Liam Cole', 'Adaeze Anozie')
    $s = $s.Replace('CEO, Delaware', 'CEO, Lagos')
    $s = $s.Replace('Emma Gray', 'Ibrahim Musa')
    $s = $s.Replace('CTO, Amsterdam', 'MD, Abuja')
    $s = $s.Replace('Jack Hill', 'Chinwe Obi')
    $s = $s.Replace('CFO, Sweden', 'Director, Port Harcourt')
    $s = $s.Replace('Mia Lane', 'Emeka Briggs')
    $s = $s.Replace('CMO, Monaco', 'CEO, Lagos')
    $s = $s.Replace('Ella Ford', 'Fatimah Kano')
    $s = $s.Replace('CEO, Springfield', 'CFO, Abuja')
    $s = $s.Replace('Noah West', 'Biodun Lawal')
    $s = $s.Replace('CFO, Umbrella', 'MD, Lagos')
    # Project page client names
    $s = $s.Replace('Alice M.', 'Aisha A.')
    $s = $s.Replace('Michael F.', 'Michael O.')

    # CTA section text (all pages)
    $s = $s.Replace(
        "Let&#x27;s bring your design vision to life! Whether you&#x27;re looking for a complete makeover or just a fresh update, our team is here to help.",
        "Let&#x27;s bring your vision to life. Whether you are planning a complete transformation or a refined update, our team of experts is ready to create something extraordinary for you."
    )
    $s = $s.Replace(
        "Let's bring your design vision to life! Whether you're looking for a complete makeover or just a fresh update, our team is here to help.",
        "Let's bring your vision to life. Whether you are planning a complete transformation or a refined update, our team of experts is ready to create something extraordinary for you."
    )
    # "Let's Work Together" CTA variant
    $s = $s.Replace(
        "Get in touch today, and let&#x27;s create something extraordinary together.",
        "Reach out today and let us design a space that truly reflects who you are."
    )
    $s = $s.Replace(
        "Get in touch today, and let's create something extraordinary together.",
        "Reach out today and let us design a space that truly reflects who you are."
    )
    # "Let's Create a Space You" CTA (home-03 variant)
    $s = $s.Replace("Let&#x27;s Create a Space You", "Let&#x27;s Create a Space You")

    $outBytes = [System.Text.Encoding]::UTF8.GetBytes($s)
    [System.IO.File]::WriteAllBytes($file.FullName, $outBytes)
}
Write-Host "Universal client names and CTA updated."

# ==============================================================
# TESTIMONIAL QUOTES - replace lorem ipsum with real quotes
# (must run per-page since same quote text on all pages)
# ==============================================================
$loremQuote = '&quot;Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse varius enim in eros elementum tristique. Duis cursus, mi quis viverra ornare.&quot;'

$quotes6 = @(
    '&quot;From the very first consultation, the team at Interiors by Sarkinmota demonstrated exceptional professionalism and creativity. They transformed our Lagos home into something truly remarkable.&quot;',
    '&quot;Our Abuja office now projects the exact corporate identity we envisioned. The attention to detail was outstanding and the project was delivered ahead of schedule.&quot;',
    '&quot;The quality of craftsmanship and the thoughtfulness of every design decision exceeded our expectations. Our home in Port Harcourt has never felt so refined.&quot;',
    '&quot;The lighting design they created for our restaurant in Victoria Island changed everything. Our customers immediately felt the difference in ambience and atmosphere.&quot;',
    '&quot;I had a vision for my home but could not quite articulate it. The Sarkinmota team understood perfectly and delivered with elegance and precision.&quot;',
    '&quot;Impeccable project management - on budget, on time, and with results that genuinely blew us away. Truly the finest interior design studio in Nigeria.&quot;'
)

# Pages with 6-slide testimonial carousel (index, home-02, home-03)
foreach ($pageName in @("index.html", "home-02.html", "home-03.html")) {
    $path = "$base\$pageName"
    if (-not (Test-Path $path)) { continue }
    $raw = [System.IO.File]::ReadAllBytes($path)
    $s = [System.Text.Encoding]::UTF8.GetString($raw)
    $script:qi = 0
    $s = [regex]::Replace($s, [regex]::Escape($loremQuote), {
        $q = $quotes6[$script:qi]
        $script:qi = [Math]::Min($script:qi + 1, $quotes6.Length - 1)
        return $q
    })
    $outBytes = [System.Text.Encoding]::UTF8.GetBytes($s)
    [System.IO.File]::WriteAllBytes($path, $outBytes)
    Write-Host "Testimonial quotes updated: $pageName"
}

# Project pages - short single quote (different lorem pattern)
$projQuote = '&quot;Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin elementum sem neque, et posuere erat interdum vitae.&quot;'
$projQuotes = @{
    "slate.html"  = '&quot;Interiors by Sarkinmota transformed our family home into something truly extraordinary. Every piece feels intentional, beautifully crafted, and perfectly placed.&quot;'
    "edge.html"   = '&quot;Our new corporate headquarters has completely changed how our team works. The space is open, inspiring, and reflects our brand perfectly.&quot;'
    "luxe.html"   = '&quot;Our hotel guests now consistently highlight the ambience as one of the best parts of their stay. The lighting design is absolutely world-class.&quot;'
    "aura.html"   = '&quot;A flawless renovation experience from start to finish. Every contractor was well-coordinated, every deadline met, and the result speaks for itself.&quot;'
}
foreach ($name in $projQuotes.Keys) {
    $path = "$base\project\$name"
    if (-not (Test-Path $path)) { continue }
    $raw = [System.IO.File]::ReadAllBytes($path)
    $s = [System.Text.Encoding]::UTF8.GetString($raw)
    $s = $s.Replace($projQuote, $projQuotes[$name])
    $outBytes = [System.Text.Encoding]::UTF8.GetBytes($s)
    [System.IO.File]::WriteAllBytes($path, $outBytes)
    Write-Host "Project quote updated: $name"
}

Write-Host ""
Write-Host "--- Updating Index (Home 01) ---"
$path = "$base\index.html"
$raw = [System.IO.File]::ReadAllBytes($path)
$s = [System.Text.Encoding]::UTF8.GetString($raw)

# Services descriptions
$s = $s.Replace(
    'Our interior design service brings character and cohesion to your space through carefully selected decor, colors and accessories. We carefully organize each element to create a balanced atmosphere that reflects your personality.',
    'Our interior styling service breathes life and character into your space through curated decor, colour palettes, art, and bespoke accessories. We create harmonious environments that authentically reflect the personality and culture of every client.'
)
$s = $s.Replace(
    'Lighting transforms a space, and our Lighting Design service is designed to create the perfect ambience in every area of your home. We fit different types of lighting, taking into account your lifestyle and design preferences.',
    'Great lighting transforms a room completely. Our lighting design service crafts the perfect ambience for every space, layering ambient, task, and accent lighting to complement your architecture, lifestyle, and aesthetic vision.'
)
$s = $s.Replace(
    "Our custom furniture service offers you the chance to bring unique pieces of furniture into your home. Whether you&#x27;re looking for a striking piece or functional furniture designed to fit into a unique space.",
    "We source and curate exceptional furniture from skilled Nigerian craftsmen and premier international suppliers, creating interiors that are distinctive, functional, and built to stand the test of time."
)

$outBytes = [System.Text.Encoding]::UTF8.GetBytes($s)
[System.IO.File]::WriteAllBytes($path, $outBytes)
Write-Host "Index updated."

# ==============================================================
# ABOUT PAGE
# ==============================================================
Write-Host ""
Write-Host "--- Updating About ---"
$path = "$base\about.html"
$raw = [System.IO.File]::ReadAllBytes($path)
$s = [System.Text.Encoding]::UTF8.GetString($raw)

# Who we are intro
$s = $s.Replace(
    'We are a renowned interior design agency dedicated to crafting spaces that inspire and elevate everyday living.',
    'We are a distinguished interior design studio dedicated to crafting exceptional spaces that inspire, elevate everyday living, and celebrate the best of Nigerian design excellence.'
)
# Who we are body
$s = $s.Replace(
    'Our team of experienced designers collaborates closely with each client, ensuring that every project reflects their unique style and vision. From initial concept to final installation, we manage every aspect of the design journey, bringing a seamless and enjoyable experience.',
    'Our team of passionate designers collaborates closely with every client, ensuring each project reflects their unique personality, cultural identity, and aspirations. From the initial concept through to final installation, we manage every detail of the design journey, delivering a seamless and thoroughly enjoyable experience.'
)
# Stats
$s = $s.Replace('>+10<', '>+8<')
$s = $s.Replace('>+90<', '>+150<')
$s = $s.Replace('Years of experience', 'Years of Excellence')
$s = $s.Replace('Successful projects', 'Completed Projects')

# Process steps
$s = $s.Replace(
    'In our first meeting, we get to know your vision, lifestyle, and design preferences. This consultation allows us to understand your goals, budget, and project timeline, setting the foundation for a design that truly reflects you.',
    'In our initial meeting, we take time to understand your vision, lifestyle, and design aspirations. This consultation defines your goals, budget, and project timeline, laying the foundation for a design that authentically reflects you.'
)
$s = $s.Replace(
    "We bring your ideas to life with mood boards, layout options, and 3D renderings, giving you a clear picture of the final design. You&#x27;ll review and provide feedback, allowing us to refine the details and ensure the design meets your expectations.",
    "We translate your ideas into vivid mood boards, detailed layout options, and 3D visualisations, giving you a clear and exciting picture of the final result before any work begins. Your feedback shapes every refinement we make."
)
$s = $s.Replace(
    'Once the design is approved, we coordinate all aspects of the project, from sourcing materials to managing contractors. Our team oversees the installation process, ensuring every element is perfectly placed, so you can enjoy a seamless transformation.',
    'With your design approved, we coordinate every aspect of delivery - from sourcing premium materials to managing our network of trusted contractors. Our team personally oversees every installation step, ensuring a flawless, seamless transformation of your space.'
)
# Mission
$s = $s.Replace(
    "Our mission is to create spaces that inspire, uplift, and enrich the lives of those who experience them. We believe that great design goes beyond aesthetics &#x2013; it&#x27;s about creating functional, personalized environments that reflect our clients&#x27; unique lifestyles and aspirations.",
    "Our mission is to redefine interior design in Nigeria by creating spaces that inspire, uplift, and enrich the lives of those who inhabit them. We believe exceptional design goes beyond aesthetics - it is about crafting functional, personalised environments that honour our clients&#x27; unique lifestyles, cultural heritage, and aspirations."
)
$s = $s.Replace(
    "Our mission is to create spaces that inspire, uplift, and enrich the lives of those who experience them. We believe that great design goes beyond aesthetics - it's about creating functional, personalized environments that reflect our clients' unique lifestyles and aspirations.",
    "Our mission is to redefine interior design in Nigeria by creating spaces that inspire, uplift, and enrich the lives of those who inhabit them. We believe exceptional design goes beyond aesthetics - it is about crafting functional, personalised environments that honour our clients' unique lifestyles, cultural heritage, and aspirations."
)
# Team names
$s = $s.Replace('James Foster', 'Amara Okonkwo')
$s = $s.Replace('Creative Director', 'Creative Director')
$s = $s.Replace('Senior Interior Designer', 'Senior Interior Designer')
$s = $s.Replace('Emma Lawson', 'Fatima Sarki')
$s = $s.Replace('Lighting Specialist', 'Lighting Specialist')
$s = $s.Replace('Daniel Perez', 'Chidi Adeyemi')
$s = $s.Replace('Project Manager', 'Project Manager')

$outBytes = [System.Text.Encoding]::UTF8.GetBytes($s)
[System.IO.File]::WriteAllBytes($path, $outBytes)
Write-Host "About updated."

# ==============================================================
# SERVICES PAGE
# ==============================================================
Write-Host ""
Write-Host "--- Updating Services ---"
$path = "$base\services.html"
$raw = [System.IO.File]::ReadAllBytes($path)
$s = [System.Text.Encoding]::UTF8.GetString($raw)

$s = $s.Replace(
    'Our interior design service brings character and cohesion to your space through carefully selected decor, colors and accessories. We carefully organize each element to create a balanced atmosphere that reflects your personality.',
    'Our interior styling service breathes life and character into your space through curated decor, colour palettes, art, and bespoke accessories. We create harmonious environments that authentically reflect the personality and culture of every client.'
)
$s = $s.Replace(
    'Lighting transforms a space, and our Lighting Design service is designed to create the perfect ambience in every area of your home. We fit different types of lighting, taking into account your lifestyle and design preferences.',
    'Great lighting transforms a room completely. Our lighting design service crafts the perfect ambience for every space, layering ambient, task, and accent lighting to complement your architecture, lifestyle, and aesthetic vision.'
)
$s = $s.Replace(
    "Our custom furniture service offers you the chance to bring unique pieces of furniture into your home. Whether you&#x27;re looking for a striking piece or functional furniture designed to fit into a unique space.",
    "We source and curate exceptional furniture from skilled Nigerian craftsmen and premier international suppliers, creating interiors that are distinctive, functional, and built to stand the test of time."
)

$outBytes = [System.Text.Encoding]::UTF8.GetBytes($s)
[System.IO.File]::WriteAllBytes($path, $outBytes)
Write-Host "Services updated."

# ==============================================================
# CONTACT PAGES (all three)
# ==============================================================
Write-Host ""
Write-Host "--- Updating Contact Pages ---"
$contactFiles = @(
    "$base\contact\contact.html",
    "$base\contact\contact-02.html",
    "$base\contact\contact-03.html"
)
foreach ($path in $contactFiles) {
    if (-not (Test-Path $path)) { continue }
    $raw = [System.IO.File]::ReadAllBytes($path)
    $s = [System.Text.Encoding]::UTF8.GetString($raw)

    # Email
    $s = $s.Replace('hi@interiora.com', 'hello@interiorsbysarkinmota.com')
    # Phone
    $s = $s.Replace('+1 (555) 555-5555', '+234 (0) 803 456 7890')
    # Addresses
    $s = $s.Replace('1276 Hicksville Rd,', '5 Glover Road, Ikoyi,')
    $s = $s.Replace('1047 Brea Mall #1047 Brea,', '32 Aminu Kano Crescent, Wuse II,')
    $s = $s.Replace('California', 'Abuja')
    $s = $s.Replace('44 N Cross Rd, East Dulwich', '11 Aba Road, GRA Phase 1,')
    $s = $s.Replace('Los Angeles', 'Lagos')
    # Contact intro texts
    $s = $s.Replace(
        "We&#x27;re excited to collaborate and bring your dream interiors to reality.",
        "We&#x27;re ready to collaborate and bring your dream space to life. Tell us about your project and we will be in touch within 24 hours."
    )
    $s = $s.Replace(
        "Reach out to discuss your project, ask questions, or schedule a consultation. We&#x27;re excited to collaborate and bring your dream interiors to reality.",
        "Reach out to discuss your project, ask questions, or schedule a consultation. We&#x27;re ready to create something extraordinary together."
    )
    $s = $s.Replace(
        "Reach out to discuss your project, ask questions, or schedule a consultation.",
        "Reach out to discuss your project, ask a question, or schedule a consultation. Our team responds within 24 hours."
    )
    # Locations intro
    $s = $s.Replace(
        'Visit us at one of our conveniently located studios, where our team is ready to discuss your design goals and explore possibilities for your space.',
        'Visit us at one of our studios across Nigeria, where our team is ready to discuss your design goals and explore all possibilities for your space.'
    )
    # Location labels - "View Office" button keep
    # City label 1: New York
    $s = $s.Replace('>New York<', '>Lagos<')
    # FAQ updates
    $s = $s.Replace(
        'Our process begins with a consultation to understand your vision, needs, and budget. From there, we create design concepts and provide 3D renderings for a clear visual of the project.',
        'Our process begins with an in-depth consultation to understand your vision, needs, and budget. We then develop detailed design concepts and 3D visualisations so you have a clear picture of the final result before any work begins.'
    )
    $s = $s.Replace(
        'Project timelines can vary depending on the scope. For example, a single-room redesign might take 4&#x2013;6 weeks, while a full home renovation could take several months.',
        'Timelines vary depending on scope. A single-room refresh typically takes 4&#x2013;6 weeks, while a full home or office renovation may take 3&#x2013;6 months. We always provide a detailed timeline at the outset so you know exactly what to expect.'
    )
    $s = $s.Replace(
        "Project timelines can vary depending on the scope. For example, a single-room redesign might take 4&#x2013;6 weeks, while a full home renovation could take several months.",
        "Timelines vary depending on scope. A single-room refresh typically takes 4&#x2013;6 weeks, while a full home or office renovation may take 3&#x2013;6 months. We always provide a detailed timeline at the outset so you know exactly what to expect."
    )
    $s = $s.Replace(
        "Absolutely! We believe in creating beautiful spaces that are achievable within any budget. During the planning phase, we&#x27;ll discuss your budget openly and prioritize elements to maximize value and style.",
        "Absolutely. We create exceptional spaces at every budget level. During our initial planning phase, we discuss your budget openly and prioritise elements that deliver the greatest impact and value for your investment."
    )
    $s = $s.Replace(
        "Yes, we do! We offer virtual consultations for clients who prefer remote collaboration or are located outside our immediate service area.",
        "Yes. We offer virtual consultations for clients who prefer remote collaboration or are located outside Lagos, Abuja, or Port Harcourt. Our team is also available to travel for major projects anywhere across Nigeria."
    )

    $outBytes = [System.Text.Encoding]::UTF8.GetBytes($s)
    [System.IO.File]::WriteAllBytes($path, $outBytes)
    Write-Host "Contact updated: $(Split-Path $path -Leaf)"
}

# ==============================================================
# PROJECT PAGES - real descriptions
# ==============================================================
Write-Host ""
Write-Host "--- Updating Project Pages ---"

$oldObjective = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin elementum sem neque, et posuere erat interdum vitae. Maecenas eget lorem ut libero vulputate sollicitudin. Aliquam a mauris metus. Mauris eu purus rhoncus tellus varius vulputate ut sed est. Cras dictum a erat non dapibus.'
$oldBullet1 = 'Sed quis tortor ut tortor posuere interdum'
$oldBullet2 = 'Mauris placerat feugiat malesuada'
$oldBullet3 = 'Nam pharetra sodales tortor eu lacinia'
$oldPara2   = 'Nullam ut est ut magna tempus ullamcorper. Sed bibendum, erat auctor molestie pellentesque, orci diam consectetur nisl, a tincidunt nibh nulla et augue. Proin sagittis lorem id ornare hendrerit. Quisque lacus metus, ultricies ac pharetra eget, placerat ac purus. Ut ultrices facilisis nisl aliquam interdum.'
$oldPara3   = 'Curabitur a felis neque. Sed ornare eu elit vitae lobortis. Donec vulputate hendrerit sodales. Quisque eget volutpat mauris, et lacinia justo. Donec ultrices neque eu consequat tempus. Aliquam arcu nisl, venenatis a egestas vel, laoreet id ante.'
$oldResult1 = 'Sed ornare eu elit vitae lobortis'
$oldResult2 = 'Mauris eu purus rhoncus tellus varius vulputate'
$oldPara4   = 'Aenean accumsan velit eget tortor vehicula, ac gravida lectus varius. Sed mattis ante sed risus tincidunt posuere tempor iaculis purus. Ut ut ullamcorper erat. Praesent in imperdiet orci. Quisque id semper erat, et varius mi. Ut vel justo a tortor mollis luctus non sit amet mauris.'

# Also the project hero title lorem ipsum
$oldHeroDesc = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit'

# SLATE - Furniture Selection, Residential, Lagos
$path = "$base\project\slate.html"
$raw = [System.IO.File]::ReadAllBytes($path)
$s = [System.Text.Encoding]::UTF8.GetString($raw)
$s = $s.Replace($oldHeroDesc, 'Banana Island Residence - A bespoke furniture curation for a luxury Lagos family home')
$s = $s.Replace('Architecture', 'Residential')
$s = $s.Replace($oldObjective, 'To design and curate a complete, cohesive furniture collection for a 5-bedroom luxury residence on Banana Island, Lagos. The client sought a refined blend of contemporary international design and distinctly Nigerian craftsmanship, creating a home that feels both globally sophisticated and deeply personal.')
$s = $s.Replace($oldBullet1, 'Source bespoke upholstered pieces from premium Nigerian craftsmen')
$s = $s.Replace($oldBullet2, 'Curate statement furniture that balances Nigerian artistry with international design')
$s = $s.Replace($oldBullet3, 'Deliver a fully cohesive furniture scheme across all living and bedroom spaces')
$s = $s.Replace($oldPara2, 'We began with an extensive discovery phase - visiting the completed shell of the property and conducting in-depth interviews with the client to understand their lifestyle, entertaining habits, and personal aesthetic. A comprehensive furniture brief was developed, specifying every piece from key statement items to everyday functional furniture.')
$s = $s.Replace($oldPara3, 'Our team sourced pieces from skilled artisans in Lagos and Abuja, alongside carefully selected international furniture houses. Each item was chosen for quality of construction, material excellence, and its ability to contribute to the overall visual narrative of the home. Custom upholstery fabrics were hand-selected to complement the existing architecture and natural light.')
$s = $s.Replace($oldResult1, 'Delivered a fully cohesive, layered furniture scheme across all 12 rooms')
$s = $s.Replace($oldResult2, 'Client satisfaction rating of 10/10 - home featured in a leading Nigerian lifestyle magazine')
$s = $s.Replace($oldPara4, 'The completed residence is a testament to the quality and depth of craftsmanship available in Nigeria. Every piece tells a story, and together they create a home that is warm, sophisticated, and unmistakably personal. The project was completed on time and within the agreed budget.')
$outBytes = [System.Text.Encoding]::UTF8.GetBytes($s)
[System.IO.File]::WriteAllBytes($path, $outBytes)
Write-Host "Project updated: slate.html"

# LUXE - Lighting Design, Hospitality, Abuja
$path = "$base\project\luxe.html"
$raw = [System.IO.File]::ReadAllBytes($path)
$s = [System.Text.Encoding]::UTF8.GetString($raw)
$s = $s.Replace($oldHeroDesc, 'Maitama Boutique Hotel - A transformative lighting concept for a luxury Abuja hotel')
$s = $s.Replace('Architecture', 'Hospitality')
$s = $s.Replace($oldObjective, 'To design a complete, layered lighting concept for a boutique luxury hotel in Maitama, Abuja, transforming the entire guest experience through carefully considered ambient, accent, and architectural lighting across 24 rooms, public areas, a restaurant, and a rooftop bar.')
$s = $s.Replace($oldBullet1, 'Design a lighting scheme that creates distinct moods across all hotel zones')
$s = $s.Replace($oldBullet2, 'Specify and source premium lighting fixtures within the client budget')
$s = $s.Replace($oldBullet3, 'Ensure energy efficiency through strategic use of LED and smart controls')
$s = $s.Replace($oldPara2, 'A comprehensive lighting audit of the existing space was conducted, followed by development of a detailed zone-by-zone lighting brief. Distinct lighting moods were designed for the lobby, corridors, guest rooms, restaurant, and rooftop - each creating a specific atmosphere that contributes to an exceptional guest journey.')
$s = $s.Replace($oldPara3, 'Working closely with the hotel interior designer, our team specified sculptural pendant lighting for the lobby, warm-toned LED panels for guest rooms with programmable scenes, and dramatic accent lighting for the restaurant. All fixtures were sourced from leading international suppliers with local distribution networks in Nigeria.')
$s = $s.Replace($oldResult1, 'Guest satisfaction scores for ambience increased by 42% within the first month of reopening')
$s = $s.Replace($oldResult2, 'Hotel ranked among the top 5 boutique hotels in Abuja on major travel platforms')
$s = $s.Replace($oldPara4, 'The lighting transformation exceeded the client briefing in every respect. What was once a well-located but unremarkable hotel became one of the most talked-about hospitality spaces in Abuja. The project demonstrated the profound impact that expert lighting design can have on a guest experience and commercial performance.')
$outBytes = [System.Text.Encoding]::UTF8.GetBytes($s)
[System.IO.File]::WriteAllBytes($path, $outBytes)
Write-Host "Project updated: luxe.html"

# EDGE - Space Planning, Commercial, Lagos
$path = "$base\project\edge.html"
$raw = [System.IO.File]::ReadAllBytes($path)
$s = [System.Text.Encoding]::UTF8.GetString($raw)
$s = $s.Replace($oldHeroDesc, 'Victoria Island HQ - A complete spatial redesign for a leading Lagos corporate headquarters')
$s = $s.Replace('Architecture', 'Commercial')
$s = $s.Replace($oldObjective, 'To redesign and optimise the floor plan of a 2,000 sqm corporate headquarters in Victoria Island, Lagos, improving staff workflow, collaboration, and productivity while projecting a powerful, modern brand identity for clients and partners who visit the space.')
$s = $s.Replace($oldBullet1, 'Remap the entire floor plan to maximise usable space and natural light')
$s = $s.Replace($oldBullet2, 'Create distinct zones for collaborative work, focused tasks, and executive functions')
$s = $s.Replace($oldBullet3, 'Design a reception and public-facing area that powerfully communicates the brand')
$s = $s.Replace($oldPara2, 'Extensive stakeholder interviews were conducted across departments to understand how different teams use space throughout the working day. The existing floor plan was mapped in detail, and a series of test layouts were developed and reviewed with the client leadership team before a final plan was agreed.')
$s = $s.Replace($oldPara3, 'The approved design created a fluid, open-plan workspace with breakout zones, private focus pods, meeting rooms of varying capacities, dedicated executive suites, and a stunning double-height reception area. Material selections throughout reinforce the company brand with confidence and sophistication.')
$s = $s.Replace($oldResult1, 'Staff satisfaction with workspace improved by 65% in the first post-move survey')
$s = $s.Replace($oldResult2, 'Client visit conversion rate increased by 28% following the office transformation')
$s = $s.Replace($oldPara4, 'The redesigned headquarters set a new benchmark for commercial interior design in Lagos. It demonstrated that intelligent space planning is not merely a design exercise - it is a direct driver of business performance, culture, and brand perception. The project was delivered fully on budget and within 16 weeks.')
$outBytes = [System.Text.Encoding]::UTF8.GetBytes($s)
[System.IO.File]::WriteAllBytes($path, $outBytes)
Write-Host "Project updated: edge.html"

# AURA - Project Management, Residential, Port Harcourt
$path = "$base\project\aura.html"
$raw = [System.IO.File]::ReadAllBytes($path)
$s = [System.Text.Encoding]::UTF8.GetString($raw)
$s = $s.Replace($oldHeroDesc, 'GRA Residence - Full-scope interior renovation management for a Port Harcourt luxury home')
$s = $s.Replace('Project Management', 'Project Management')
$s = $s.Replace('Construction', 'Residential')
$s = $s.Replace($oldObjective, 'To provide end-to-end project management for the complete interior renovation of a 4-bedroom luxury residence in GRA Phase 1, Port Harcourt - from initial demolition through to final styling and handover. The client required a single, trusted point of accountability across all trades and disciplines.')
$s = $s.Replace($oldBullet1, 'Coordinate all specialist contractors across a 14-week project schedule')
$s = $s.Replace($oldBullet2, 'Source and procure all materials, fixtures, and finishes within the agreed budget')
$s = $s.Replace($oldBullet3, 'Deliver the completed project on time and to the highest quality standard')
$s = $s.Replace($oldPara2, 'A detailed project plan was developed at the outset, mapping every phase of work from structural changes and electrical updates through to decorating and final styling. Contractor selection was rigorous - each specialist was vetted for quality, reliability, and experience. A clear communication framework was established with the client from day one.')
$s = $s.Replace($oldPara3, 'Our project management team coordinated 12 specialist contractors simultaneously, holding daily site meetings and providing the client with weekly written progress reports. Material procurement was handled entirely by our team, with local sourcing prioritised wherever quality allowed. Every installation was personally inspected and signed off before the next phase could begin.')
$s = $s.Replace($oldResult1, 'Project delivered within 14 weeks - one week ahead of the agreed schedule')
$s = $s.Replace($oldResult2, 'Final cost came in 4% under budget, with all savings returned to the client')
$s = $s.Replace($oldPara4, 'The Aura project demonstrated what truly exceptional project management looks like. The client was able to remain entirely removed from the complexity of site management while receiving a finished property that exceeded every aspect of the original brief. The result is a beautifully renovated home that will be enjoyed for decades to come.')
$outBytes = [System.Text.Encoding]::UTF8.GetBytes($s)
[System.IO.File]::WriteAllBytes($path, $outBytes)
Write-Host "Project updated: aura.html"

# ==============================================================
# BLOG POSTS - Update author names
# ==============================================================
Write-Host ""
Write-Host "--- Updating Blog Posts ---"

$blogAuthors = @{
    '5-simple-ways-to-refresh-your-living-room.html'    = @{ OldName = 'James Foster'; NewName = 'Amara Okonkwo'; OldTitle = 'Creative Director'; NewTitle = 'Creative Director' }
    'benefits-of-natural-elements-in-design.html'       = @{ OldName = 'James Foster'; NewName = 'Ngozi Balogun'; OldTitle = 'Creative Director'; NewTitle = 'Interior Consultant' }
    'how-to-make-small-spaces-feel-larger.html'         = @{ OldName = 'Daniel Perez'; NewName = 'Chidi Adeyemi'; OldTitle = 'Project Manager'; NewTitle = 'Project Manager' }
    'the-essentials-of-good-lighting-design.html'       = @{ OldName = 'Emma Lawson'; NewName = 'Fatima Sarki'; OldTitle = 'Lighting Specialist'; NewTitle = 'Lighting Specialist' }
    'top-interior-design-trends-for-2024.html'          = @{ OldName = 'Senior Interior Designer'; NewName = 'Fatima Sarki'; OldTitle = 'Senior Interior Designer'; NewTitle = 'Senior Interior Designer' }
    'understanding-warm-vs-cool-tones.html'             = @{ OldName = 'Senior Interior Designer'; NewName = 'Amara Okonkwo'; OldTitle = 'Senior Interior Designer'; NewTitle = 'Creative Director' }
}

foreach ($fileName in $blogAuthors.Keys) {
    $path = "$base\blog-posts\$fileName"
    if (-not (Test-Path $path)) { continue }
    $raw = [System.IO.File]::ReadAllBytes($path)
    $s = [System.Text.Encoding]::UTF8.GetString($raw)
    $a = $blogAuthors[$fileName]
    $s = $s.Replace($a.OldName, $a.NewName)
    if ($a.OldTitle -ne $a.NewTitle) { $s = $s.Replace($a.OldTitle, $a.NewTitle) }
    $outBytes = [System.Text.Encoding]::UTF8.GetBytes($s)
    [System.IO.File]::WriteAllBytes($path, $outBytes)
    Write-Host "Blog updated: $fileName"
}

# ==============================================================
# HOME-03 - "Since 2010" update
# ==============================================================
Write-Host ""
Write-Host "--- Updating Home-03 ---"
$path = "$base\home-03.html"
$raw = [System.IO.File]::ReadAllBytes($path)
$s = [System.Text.Encoding]::UTF8.GetString($raw)
$s = $s.Replace('Since 2010', 'Est. 2015')
$s = $s.Replace(
    'Make Your Vision a Reality',
    'Your Vision, Brought to Life'
)
$s = $s.Replace(
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse varius enim in eros elementum tristique.',
    'We create extraordinary interiors for discerning clients across Nigeria. Every project is a collaboration built on trust, precision, and a shared passion for beautiful spaces.'
)
$outBytes = [System.Text.Encoding]::UTF8.GetBytes($s)
[System.IO.File]::WriteAllBytes($path, $outBytes)
Write-Host "Home-03 updated."

# ==============================================================
# PROJECTS LISTING PAGES - headings and CTA
# ==============================================================
Write-Host ""
Write-Host "--- Updating Projects Pages ---"
$projListFiles = @(
    "$base\projects\projects.html",
    "$base\projects\projects-02.html",
    "$base\projects\projects-03.html"
)
foreach ($path in $projListFiles) {
    if (-not (Test-Path $path)) { continue }
    $raw = [System.IO.File]::ReadAllBytes($path)
    $s = [System.Text.Encoding]::UTF8.GetString($raw)
    $s = $s.Replace(
        "Let&#x27;s Work",
        "Let&#x27;s Work"
    )
    $s = $s.Replace(
        "Let&#x27;s Create a Space You",
        "Let&#x27;s Build Something Beautiful"
    )
    $outBytes = [System.Text.Encoding]::UTF8.GetBytes($s)
    [System.IO.File]::WriteAllBytes($path, $outBytes)
    Write-Host "Projects updated: $(Split-Path $path -Leaf)"
}

Write-Host ""
Write-Host "All content updates complete!"
