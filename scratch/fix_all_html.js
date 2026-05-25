const fs = require('fs');
const path = require('path');

const htmlFiles = [
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
];

const baseDir = "C:\\Users\\sky\\.gemini\\antigravity\\scratch\\hypermarket-app";

const replacements = {
  // Star replacements
  "Ã¢Ëœâ€¦Ã¢Ëœâ€¦Ã¢Ëœâ€¦Ã¢Ëœâ€¦Ã¢Ëœâ€¦": "★★★★★",
  "â˜…â˜…â˜…â˜…â˜…": "★★★★★",
  "Ã¢Ëœâ€¦": "★",
  "â˜…": "★",
  
  // Arabic Language Switcher
  "Ø¹Ø±Ø¨ÙŠ": "عربي"
};

// Direct substring replacements for index.html testimonials
const directReplacements = [
  // Card 0 (Tarek)
  ["Ø£Ù\u0081Ø¶Ù\u0084 Ø³Ù\u0088Ø¨Ø±Ù\u0085Ø§Ø±Ù\u0083Øª Ù\u0084Ù\u0084Ù\u0085Ù\u0086ØªØ¬Ø§Øª Ø§Ù\u0084Ù\u0085ØµØ±Ù\u008aØ© Ù\u0081Ù\u008a Ø¹Ø¬Ù\u0085Ø§Ù\u0086! Ø§Ù\u0084Ù\u0085Ù\u0084Ù\u0088Ø®Ù\u008aØ© Ù\u0088Ø§Ù\u0084Ø¬Ø¨Ù\u0086Ø© Ø§Ù\u0084Ù\u0082Ø¯Ù\u008aÙ\u0085Ø© Ù\u0088Ø§Ù\u0084Ù\u0083Ø´Ø±Ù\u008a Ø·Ø§Ø²Ø¬Ø© Ù\u0088Ù\u0085Ù\u0085ØªØ§Ø²Ø©. Ù\u0083Ø£Ù\u0086Ù\u0083 Ù\u0081Ù\u008a Ù\u0085ØµØ±!", "أفضل سوبرماركت للمنتجات المصرية في عجمان! الملوخية والجبنة القديمة والكشري طازجة وممتازة. كأنك في مصر!"],
  ["Ø·Ø§Ø±Ù\u0082 Ø§Ù\u0084Ù\u0085ØµØ±Ù\u008a", "طارق المصري"],
  
  // Card 1 (Amira)
  ["Ø®Ø¯Ù\u0085Ø© Ø§Ù\u0084ØªÙ\u0088ØµÙ\u008aÙ\u0084 Ø§Ù\u0084Ø³Ø±Ù\u008aØ¹Ø© Ø¹Ø¨Ø± Ø§Ù\u0084Ù\u008aØ§ØªØ³Ø§Ø¨ Ù\u0085Ù\u0085ØªØ§Ø²Ø© Ø¬Ø¯Ø§Ù\u008b. Ø§Ù\u0084Ù\u0085Ø§Ù\u0086Ø¬Ù\u0088 Ø§Ù\u0084Ù\u0085ØµØ±Ù\u008a Ù\u0088Ø§Ù\u0084Ø\u00b9Ù\u008aØ´ Ø§Ù\u0084Ø¨Ù\u008bØ¯Ù\u008a Ø·Ø§Ø²Ø¬ Ù\u0088Ø¬Ù\u0085Ù\u008aÙ\u008b. ØØ¹ØµØ\u00ad Ø¨Ù\u008d Ø¨Ø´Ø¯Ø©.", "خدمة التوصيل السريعة عبر الواتساب ممتازة جداً. المانجو المصري والعيش البلدي طازج وجميل. أنصح به بشدة."],
  ["Ø£Ù\u0085Ù\u008aØ±Ø© Ø\u00adØ¬Ø§Ø²Ù\u008a", "أميرة حجازي"],
  
  // Card 2 (Youssef)
  ["Ø£Ø³Ø¹Ø§Ø± Ù\u0085Ù\u0085ØªØ§Ø²Ø© Ù\u0088Ù\u0085Ù\u0083Ø§Ù\u0086 Ù\u0086Ø¸Ù\u008aÙ\u0081 Ø¬Ø¯Ø§Ù\u008b. Ø§Ù\u0084Ù\u0084Ø\u00adÙ\u0088Ù\u0085 Ø§Ù\u0084Ø·Ø§Ø²Ø¬Ø© Ù\u0088Ø§Ù\u0084Ø¨Ù\u008bØ¯Ù\u008a Ù\u0085Ù\u0085ØªØ§Ø²Ø©. Ù\u0081Ù\u0083Ø±Ø© ØªØ\u00adÙ\u0085Ù\u008aÙ\u0084 Ø§Ù\u0084Ù\u0081Ø§ØªÙ\u0088Ø±Ø© Ù\u0088Ø§Ù\u0084Ø¯Ù\u0081Øع Ø¹Ø¨Ø± Ø§Ù\u0084Ù\u008aØ§ØªØ³Ø§Ø¨ Ù\u0085Ø±Ù\u008aØ\u00adØ© Ù\u0084Ù\u0084ØºØ§Ù\u008aØ©.", "أسعار ممتازة ومكان نظيف جداً. اللحوم الطازجة والبلدي ممتازة. فكرة تحميل الفاتورة والدفع عبر الواتساب مريحة للغاية."],
  ["Ù\u008aÙ\u0088Ø³Ù\u0081 Ù\u0085Ù\u0086ØµÙ\u0088Ø±", "يوسف منصور"]
];

htmlFiles.forEach(filename => {
  const filePath = path.join(baseDir, filename);
  if (!fs.existsSync(filePath)) {
    console.log(`Skipping ${filename} (not found)`);
    return;
  }
  
  console.log(`Fixing ${filename}...`);
  let content = fs.readFileSync(filePath, 'utf8');
  const original = content;
  
  // 1. Direct dict replacements
  for (const [old, val] of Object.entries(replacements)) {
    content = content.split(old).join(val);
  }
  
  // 2. Direct array replacements
  for (const [old, val] of directReplacements) {
    content = content.split(old).join(val);
  }
  
  // Extra robust checks for index.html testimonials using regex or simple substring mapping of garbled values
  if (filename === 'index.html') {
    // Let's replace the whole Arabic paragraphs with regex or specific strings.
    // Let's print out if they are found or replaced.
    // Card 0 Arabic text line:
    // we can search for the class="testimonial-text-ar" element and replace its content
    content = content.replace(/"Ø£Ù Ø¶Ù„ Ø³ÙˆØ¨Ø±Ù…Ø§Ø±ÙƒØª Ù„Ù„Ù…Ù†ØªØ¬Ø§Øª Ø§Ù„Ù…ØµØ±ÙŠØ© Ù ÙŠ Ø¹Ø¬Ù…Ø§Ù†! Ø§Ù„Ù…Ù„ÙˆØ®ÙŠØ© ÙˆØ§Ù„Ø¬Ø¨Ù†Ø© Ø§Ù„Ù‚Ø¯ÙŠÙ…Ø© ÙˆØ§Ù„ÙƒØ´Ø±ÙŠ Ø·Ø§Ø²Ø¬Ø© ÙˆÙ…Ù…ØªØ§Ø²Ø©. ÙƒØ£Ù†Ùƒ Ù ÙŠ Ù…ØµØ±!"/g, '"أفضل سوبرماركت للمنتجات المصرية في عجمان! الملوخية والجبنة القديمة والكشري طازجة وممتازة. كأنك في مصر!"');
    content = content.replace(/Ø·Ø§Ø±Ù‚ Ø§Ù„Ù…ØµØ±ÙŠ/g, 'طارق المصري');
    
    // Card 1 Arabic text line:
    content = content.replace(/"Ø®Ø¯Ù…Ø© Ø§Ù„ØªÙˆØµÙŠÙ„ Ø§Ù„Ø³Ø±ÙŠØ¹Ø© Ø¹Ø¨Ø± Ø§Ù„ÙˆØ§ØªØ³Ø§Ø¨ Ù…Ù…ØªØ§Ø²Ø© Ø¬Ø¯Ø§Ù‹. Ø§Ù„Ù…Ø§Ù†Ø¬Ùˆ Ø§Ù„Ù…ØµØ±ÙŠ ÙˆØ§Ù„Øعيش Ø§Ù„Ø¨Ù„Ø¯ÙŠ Ø·Ø§Ø²Ø¬ ÙˆØ¬Ù…ÙŠÙ„. Ø£Ù†ØµØ­ Ø¨Ù‡ Ø¨Ø´Ø¯Ø©."/g, '"خدمة التوصيل السريعة عبر الواتساب ممتازة جداً. المانجو المصري والعيش البلدي طازج وجميل. أنصح به بشدة."');
    content = content.replace(/Ø£Ù…ÙŠØ±Øة Ø­Ø¬Ø§Ø²ÙŠ/g, 'أميرة حجازي');
    content = content.replace(/Ø£Ù…ÙŠØ±Ø© Ø­Ø¬Ø§Ø²ÙŠ/g, 'أميرة حجازي');
    
    // Card 2 Arabic text line:
    content = content.replace(/"Ø£Ø³Ø¹Ø§Ø± Ù…Ù…ØªØ§Ø²Ø© ÙˆÙ…ÙƒØ§Ù† Ù†Ø¸ÙŠÙ  Ø¬Ø¯Ø§Ù‹. Ø§Ù„Ù„Ø­ÙˆÙ… Ø§Ù„Ø·Ø§Ø²Ø¬Ø© ÙˆØ§Ù„Ø¨Ù„Ø¯ÙŠ Ù…Ù…ØªØ§Ø²Ø©. Ù ÙƒØ±Ø© ØªØ­Ù…ÙŠÙ„ Ø§Ù„Ù  Ø§ØªÙˆØ±Ø© ÙˆØ§Ù„Ø¯Ù  Ø¹ Ø¹Ø¨Ø± Ø§Ù„ÙˆØ§ØªØ³Ø§Ø¨ Ù…Ø±ÙŠØ­Ø© Ù„Ù„ØºØ§ÙŠØ©."/g, '"أسعار ممتازة ومكان نظيف جداً. اللحوم الطازجة والبلدي ممتازة. فكرة تحميل الفاتورة والدفع عبر الواتساب مريحة للغاية."');
    content = content.replace(/ÙŠÙˆØ³Ù  Ù…Ù†ØµÙˆØ±/g, 'يوسف منصور');
  }

  if (content !== original) {
    fs.writeFileSync(filePath, content, 'utf8');
    console.log(`  -> Updated ${filename}`);
  } else {
    console.log(`  -> No changes in ${filename}`);
  }
});

console.log("Done!");
