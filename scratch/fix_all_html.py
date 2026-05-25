import os

html_files = [
    "index.html",
    "about.html",
    "accessibility.html",
    "beverages.html",
    "cart.html",
    "food-cupboard.html",
    "fresh-food.html",
    "fruits-veg.html",
    "privacy.html",
    "return.html",
    "tech-shield.html",
    "terms.html",
    "warranty.html"
]

base_dir = r"C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app"

replacements = {
    # Star replacements
    "Ã¢Ëœâ€¦Ã¢Ëœâ€¦Ã¢Ëœâ€¦Ã¢Ëœâ€¦Ã¢Ëœâ€¦": "★★★★★",
    "â˜…â˜…â˜…â˜…â˜…": "★★★★★",
    "Ã¢Ëœâ€¦": "★",
    "â˜…": "★",
    
    # Arabic Language Switcher
    "Ø¹Ø±Ø¨ÙŠ": "عربي",
    
    # Testimonials (Card 0 - Tarek)
    'Ø£Ù\u0081Ø¶Ù\u0084 Ø³Ù\u0088Ø¨Ø±Ù\u0085Ø§Ø±Ù\u0083Øª Ù\u0084Ù\u0084Ù\u0085Ù\u0086ØªØ¬Ø§Øª Ø§Ù\u0084Ù\u0085ØµØ±Ù\u008aØ© Ù\u0081Ù\u008a Ø¹Ø¬Ù\u0085Ø§Ù\u0086! Ø§Ù\u0084Ù\u0085Ù\u0084Ù\u0088Ø®Ù\u008aØ© Ù\u0088Ø§Ù\u0084Ø¬Ø¨Ù\u0086Ø© Ø§Ù\u0084Ù\u0082Ø¯Ù\u008aÙ\u0085Ø© Ù\u0088Ø§Ù\u0084Ù\u0083Ø´Ø±Ù\u008a Ø·Ø§Ø²Ø¬Ø© Ù\u0088Ù\u0085Ù\u0085ØªØ§Ø²Ø©. Ù\u0083Ø£Ù\u0086Ù\u0083 Ù\u0081Ù\u008a Ù\u0085ØµØ±!': 'أفضل سوبرماركت للمنتجات المصرية في عجمان! الملوخية والجبنة القديمة والكشري طازجة وممتازة. كأنك في مصر!',
    'Ø·Ø§Ø±Ù\u0082 Ø§Ù\u0084Ù\u0085ØµØ±Ù\u008a': 'طارق المصري',
    
    # Testimonials (Card 1 - Amira)
    'Ø®Ø¯Ù\u0085Ø© Ø§Ù\u0084ØªÙ\u0088ØµÙ\u008aÙ\u0084 Ø§Ù\u0084Ø³Ø±Ù\u008aØ¹Ø© Ø¹Ø¨Ø± Ø§Ù\u0084Ù\u008aØ§ØªØ³Ø§Ø¨ Ù\u0085Ù\u0085ØªØ§Ø²Ø© Ø¬Ø¯Ø§Ù\u008b. Ø§Ù\u0084Ù\u0085Ø§Ù\u0086Ø¬Ù\u0088 Ø§Ù\u0084Ù\u0085ØµØ±Ù\u008a Ù\u0088Ø§Ù\u0084Ø¹Ù\u008aØ´ Ø§Ù\u0084Ø¨Ù\u008bØ¯Ù\u008a Ø·Ø§Ø²Ø¬ Ù\u0088Ø¬Ù\u0085Ù\u008aÙ\u008b. ØØ¹ØµØ\u00ad Ø¨Ù\u008d Ø¨Ø´Ø¯Ø©.': 'خدمة التوصيل السريعة عبر الواتساب ممتازة جداً. المانجو المصري والعيش البلدي طازج وجميل. أنصح به بشدة.',
    'Ø£Ù\u0085Ù\u008aØ±Ø© Ø\u00adØ¬Ø§Ø²Ù\u008a': 'أميرة حجازي',
    
    # Testimonials (Card 2 - Youssef)
    'Ø£Ø³Ø¹Ø§Ø± Ù\u0085Ù\u0085ØªØ§Ø²Ø© Ù\u0088Ù\u0085Ù\u0083Ø§Ù\u0086 Ù\u0086Ø¸Ù\u008aÙ\u0081 Ø¬Ø¯Ø§Ù\u008b. Ø§Ù\u0084Ù\u0084Ø\u00adÙ\u0088Ù\u0085 Ø§Ù\u0084Ø·Ø§Ø²Ø¬Ø© Ù\u0088Ø§Ù\u0084Ø¨Ù\u008bØ¯Ù\u008a Ù\u0085Ù\u0085ØªØ§Ø²Ø©. Ù\u0081Ù\u0083Ø±Ø© ØªØ\u00adÙ\u0085Ù\u008aÙ\u0084 Ø§Ù\u0084Ù\u0081Ø§ØªÙ\u0088Ø±Ø© Ù\u0088Ø§Ù\u0084Ø¯Ù\u0081Ø¹ Ø¹Ø¨Ø± Ø§Ù\u0084Ù\u008aØ§ØªØ³Ø§Ø¨ Ù\u0085Ø±Ù\u008aØ\u00adØ© Ù\u0084Ù\u0084ØºØ§Ù\u008aØ©.': 'أسعار ممتازة ومكان نظيف جداً. اللحوم الطازجة والبلدي ممتازة. فكرة تحميل الفاتورة والدفع عبر الواتساب مريحة للغاية.',
    'Ù\u008aÙ\u0088Ø³Ù\u0081 Ù\u0085Ù\u0086ØµÙ\u0088Ø±': 'يوسف منصور',
}

# Wait, let's also support direct string replacement for substrings of the testimonial text, in case unicode characters differ or have weird spaces:
direct_replacements = [
    # Card 0
    ('Ø£Ù\u0081Ø¶Ù\u0084 Ø³Ù\u0088Ø¨Ø±Ù\u0085Ø§Ø±Ù\u0083Øª Ù\u0084Ù\u0084Ù\u0085Ù\u0086ØªØ¬Ø§Øª Ø§Ù\u0084Ù\u0085ØµØ±Ù\u008aØ© Ù\u0081Ù\u008a Ø¹Ø¬Ù\u0085Ø§Ù\u0086!', 'أفضل سوبرماركت للمنتجات المصرية في عجمان!'),
    ('Ø§Ù\u0084Ù\u0085Ù\u0084Ù\u0088Ø®Ù\u008aØ© Ù\u0088Ø§Ù\u0084Ø¬Ø¨Ù\u0086Ø© Ø§Ù\u0084Ù\u0082Ø¯Ù\u008aÙ\u0085Ø© Ù\u0088Ø§Ù\u0084Ù\u0083Ø´Ø±Ù\u008a Ø·Ø§Ø²Ø¬Ø© Ù\u0088Ù\u0085Ù\u0085ØªØ§Ø²Ø©.', 'الملوخية والجبنة القديمة والكشري طازجة وممتازة.'),
    ('Ù\u0083Ø£Ù\u0086Ù\u0083 Ù\u0081Ù\u008a Ù\u0085ØµØ±!', 'كأنك في مصر!'),
    ('Ø·Ø§Ø±Ù\u0082 Ø§Ù\u0084Ù\u0085ØµØ±Ù\u008a', 'طارق المصري'),
    
    # Card 1
    ('Ø®Ø¯Ù\u0085Ø© Ø§Ù\u0084ØªÙ\u0088ØµÙ\u008aÙ\u0084 Ø§Ù\u0084Ø³Ø±Ù\u008aØ¹Ø© Ø¹Ø¨Ø± Ø§Ù\u0084Ù\u008aØ§ØªØ³Ø§Ø¨ Ù\u0085Ù\u0085ØªØ§Ø²Ø© Ø¬Ø¯Ø§Ù\u008b.', 'خدمة التوصيل السريعة عبر الواتساب ممتازة جداً.'),
    ('Ø§Ù\u0084Ù\u0085Ø§Ù\u0086Ø¬Ù\u0088 Ø§Ù\u0084Ù\u0085ØµØ±Ù\u008a Ù\u0088Ø§Ù\u0084Ø\u00b9Ù\u008aØ´ Ø§Ù\u0084Ø¨Ù\u008bØ¯Ù\u008a Ø·Ø§Ø²Ø¬ Ù\u0088Ø¬Ù\u0085Ù\u008aÙ\u008b.', 'المانجو المصري والعيش البلدي طازج وجميل.'),
    ('ØØ¹ØµØ\u00ad Ø¨Ù\u008d Ø¨Ø´Ø¯Ø©.', 'أنصح به بشدة.'),
    ('Ø£Ù\u0085Ù\u008aØ±Ø© Ø\u00adØ¬Ø§Ø²Ù\u008a', 'أميرة حجازي'),
    
    # Card 2
    ('Ø£Ø³Ø¹Ø§Ø± Ù\u0085Ù\u0085ØªØ§Ø²Ø© Ù\u0088Ù\u0085Ù\u0083Ø§Ù\u0086 Ù\u0086Ø¸Ù\u008aÙ\u0081 Ø¬Ø¯Ø§Ù\u008b.', 'أسعار ممتازة ومكان نظيف جداً.'),
    ('Ø§Ù\u0084Ù\u0084Ø\u00adÙ\u0088Ù\u0085 Ø§Ù\u0084Ø·Ø§Ø²Ø¬Ø© Ù\u0088Ø§Ù\u0084Ø¨Ù\u008bØ¯Ù\u008a Ù\u0085Ù\u0085ØªØ§Ø²Ø©.', 'اللحوم الطازجة والبلدي ممتازة.'),
    ('Ù\u0081Ù\u0083Ø±Ø© ØªØ\u00adÙ\u0085Ù\u008aÙ\u0084 Ø§Ù\u0084Ù\u0081Ø§ØªÙ\u0088Ø±Ø© Ù\u0088Ø§Ù\u0084Ø¯Ù\u0081Ø¹ Ø¹Ø¨Ø± Ø§Ù\u0084Ù\u008aØ§ØªØ³Ø§Ø¨ Ù\u0085Ø±Ù\u008aØ\u00adØ© Ù\u0084Ù\u0084ØºØ§Ù\u008aØ©.', 'فكرة تحميل الفاتورة والدفع عبر الواتساب مريحة للغاية.'),
    ('Ù\u008aÙ\u0088Ø³Ù\u0081 Ù\u0085Ù\u0086ØµÙ\u0088Ø±', 'يوسف منصور'),
]

for filename in html_files:
    filepath = os.path.join(base_dir, filename)
    if not os.path.exists(filepath):
        print(f"Skipping {filename} (not found)")
        continue
        
    print(f"Fixing {filename}...")
    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()
        
    original = content
    
    # 1. Direct dict replacements
    for old, new in replacements.items():
        content = content.replace(old, new)
        
    # 2. Direct tuple replacements
    for old, new in direct_replacements:
        content = content.replace(old, new)
        
    # Let's write another regex-free replacement logic for anything else
    # e.g., if there are remaining instances of 'Ø£Ù\x81Ø¶Ù\x84 Ø³Ù\x88Ø¨Ø±Ù\x85Ø§Ø±Ù\x83Øª'
    # which can be encoded differently depending on how python reads the file bytes.
    # Let's do a raw binary search/replace if needed, but standard UTF-8 string replace is usually good if the file was saved as UTF-8.
    
    if content != original:
        with open(filepath, "w", encoding="utf-8") as f:
            f.write(content)
        print(f"  -> Updated {filename}")
    else:
        print(f"  -> No changes in {filename}")

print("Done fixing HTML files.")
