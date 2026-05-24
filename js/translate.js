// Baladi Hypermarket - i18n Translation Engine
// Supports English (en), Arabic (ar), Hindi (hi), and Urdu (ur)

const TRANSLATIONS = {
  en: {
    "scheduled": "Scheduled",
    "get-tomorrow": "Get it by Tomorrow",
    "quick": "Quick",
    "categories-btn": "Categories",
    "nav-grocery": "Grocery",
    "nav-fresh": "Fresh Food",
    "nav-electronics": "Electronics",
    "nav-home": "Home & Living",
    "nav-festive": "Festive Collection",
    "nav-deals": "Deals",
    "search-placeholder": "Search for \"Anything\"...",
    "explore-depts": "Explore Departments",
    "sorted-count": "3,000+ Products sorted",
    "shop-by-cat": "Shop by Category",
    "popular-prods": "Popular Products",
    "live-flash-deals": "Live Flash Deals",
    "hotline-order": "Hotline Order",
    "all-categories": "All Categories",
    "my-cart": "My Cart",
    "cart-title": "Cart",
    "empty-cart-p": "Your cart is empty.",
    "empty-cart-sub": "Browse categories to add delicious products!",
    "address-label": "Delivery Address:",
    "no-address": "There is no address added yet.",
    "add-new-address": "Add New Address",
    "address-tooltip": "Complete your address to continue.",
    "savings-corner": "Savings Corner",
    "apply-coupons": "Apply Coupons",
    "order-summary": "Order Summary",
    "summary-subtotal": "Subtotal",
    "summary-vat": "VAT (5%)",
    "summary-total": "Total (Incl. VAT)",
    "summary-grand-total": "Grand Total",
    "btn-checkout": "Continue to checkout",
    "min-cart-warning": "Minimum cart value must be 30.00 AED for delivery",
    "footer-about-h3": "Baladi Hypermarket",
    "footer-about-p": "Bringing you the finest selection of quality fresh food, organic produce, snacks, and chilled beverages. Save time with our seamless WhatsApp order system.",
    "footer-visit": "Visit Us: Al Nuaimiya, Ajman, UAE",
    "footer-depts": "Departments",
    "footer-care": "Customer Care",
    "footer-contact": "Contact Hotline",
    "footer-faq": "FAQ",
    "footer-fulfillment": "Fulfillment Details",
    "footer-privacy": "Privacy Policy",
    "footer-terms": "Terms & Conditions",
    "footer-about-policies": "About & Policies",
    "footer-return": "Return Policy",
    "footer-warranty": "Service & Warranty",
    "footer-tech-shield": "Tech Shield",
    "footer-accessibility": "Website Accessibility",
    "footer-visit-heading": "Visit Us:",
    "footer-visit-value": "Al Naseem Street - Al Rashidiya 1 - Ajman",
    "footer-timings": "Timings: Closes 2 AM - Reopens 8 AM",
    "footer-review": "Leave a Review ★★★★★",
    "footer-247": "24/7 Service",
    "footer-rights": "© 2026 Baladi Hypermarket. All Rights Reserved. Designed by skids.",
    "mobile-home": "Home",
    "mobile-fresh": "Fresh Food",
    "mobile-fruits": "Fruits & Veg",
    "mobile-cupboard": "Food Cupboard",
    "mobile-beverages": "Beverages",
    "mobile-bottom-home": "Home",
    "mobile-bottom-menu": "Menu",
    "mobile-bottom-cart": "Cart",
    "mobile-bottom-search": "Search",
    "explore-depts-subtitle": "3,000+ Products sorted",
    "toast-added": "added to cart!",
    "toast-removed": "removed from cart.",
    "toast-empty": "Your cart is empty!",
    "modal-invoice-title": "Invoice Details",
    "modal-fullname": "Full Name",
    "modal-whatsapp": "WhatsApp Number",
    "modal-fulfillment": "Fulfillment Method",
    "modal-pickup": "Store Self-Pickup",
    "modal-delivery": " Fast Home Delivery (AED 10.00)",
    "modal-submit": "Generate PDF & Checkout WhatsApp",
    "shop-now": "Shop Now",
    "al-nuaimiya": "Al Nuaimiya",
    "add-address-title": "Add Delivery Address",
    "enter-fullname": "e.g. John Doe",
    "enter-phone": "e.g. 0526278571",
    "enter-address": "e.g. Flat 402, Building A, Al Nuaimiya, Ajman",
    "address-details-lbl": "Complete Address Details",
    "cancel-btn": "Cancel",
    "save-address-btn": "Save Address",
    "apply-btn": "Apply",
    "enter-coupon-ph": "Enter coupon code (e.g. SAVE10)",
    "coupon-modal-title": "Apply Promo Code",
    "coupon-applied-msg": "Promo code applied successfully!"
  },
  ar: {
    "scheduled": "مجدول",
    "get-tomorrow": "احصل عليه غداً",
    "quick": "سريع",
    "categories-btn": "الفئات",
    "nav-grocery": "البقالة",
    "nav-fresh": "أغذية طازجة",
    "nav-electronics": "الإلكترونيات",
    "nav-home": "المنزل والمعيشة",
    "nav-festive": "مجموعة الأعياد",
    "nav-deals": "العروض",
    "search-placeholder": "ابحث عن \"أي شيء\"...",
    "explore-depts": "استكشف الأقسام",
    "sorted-count": "أكثر من 3000 منتج مصنف",
    "shop-by-cat": "تسوق حسب الفئة",
    "popular-prods": "المنتجات الشائعة",
    "live-flash-deals": "عروض فلاش الحية",
    "hotline-order": "طلب الخط الساخن",
    "all-categories": "جميع الفئات",
    "my-cart": "عربتي",
    "cart-title": "سلة التسوق",
    "empty-cart-p": "سلة التسوق فارغة.",
    "empty-cart-sub": "تصفح الفئات لإضافة منتجات لذيذة!",
    "address-label": "عنوان التوصيل:",
    "no-address": "لم يتم إضافة عنوان بعد.",
    "add-new-address": "إضافة عنوان جديد",
    "address-tooltip": "أكمل عنوانك للمتابعة.",
    "savings-corner": "ركن التوفير",
    "apply-coupons": "تطبيق الكوبونات",
    "order-summary": "ملخص الطلب",
    "summary-subtotal": "المجموع الفرعي",
    "summary-vat": "ضريبة القيمة المضافة (5%)",
    "summary-total": "الإجمالي (شامل الضريبة)",
    "summary-grand-total": "المجموع الكلي",
    "btn-checkout": "المتابعة لإتمام الطلب",
    "min-cart-warning": "يجب أن يكون الحد الأدنى لقيمة السلة 30.00 درهم للتوصيل",
    "footer-about-h3": "بلدي هايبر ماركت",
    "footer-about-p": "نقدم لكم أفضل تشكيلة من الأغذية الطازجة عالية الجودة والمنتجات العضوية والوجبات الخفيفة والمشروبات المبردة. وفر وقتك مع نظام الطلب السلس عبر واتساب.",
    "footer-visit": "تفضل بزيارتنا: النعيمية، عجمان، الإمارات العربية المتحدة",
    "footer-depts": "الأقسام",
    "footer-care": "رعاية العملاء",
    "footer-contact": "الخط الساخن",
    "footer-faq": "الأسئلة الشائعة",
    "footer-fulfillment": "تفاصيل الاستلام",
    "footer-privacy": "سياسة الخصوصية",
    "footer-terms": "الشروط والأحكام",
    "footer-about-policies": "عن الهايبرماركت والسياسات",
    "footer-return": "سياسة الإرجاع",
    "footer-warranty": "الخدمة والضمان",
    "footer-tech-shield": "حماية التكنولوجيا",
    "footer-accessibility": "إمكانية الوصول للموقع",
    "footer-visit-heading": "تفضل بزيارتنا:",
    "footer-visit-value": "شارع النسيم - الراشدية 1 - عجمان",
    "footer-timings": "الأوقات: يغلق 2 صباحاً - يفتح 8 صباحاً",
    "footer-review": "اترك لنا تقييماً ★★★★★",
    "footer-247": "خدمة 24/7",
    "footer-rights": "حقوق الطبع والنشر © 2026 بلدي هايبر ماركت. كل الحقوق محفوظة. تم التصميم بواسطة skids.",
    "mobile-home": "الرئيسية",
    "mobile-fresh": "أغذية طازجة",
    "mobile-fruits": "فواكه وخضار",
    "mobile-cupboard": "خزانة الأغذية",
    "mobile-beverages": "المشروبات",
    "mobile-bottom-home": "الرئيسية",
    "mobile-bottom-menu": "القائمة",
    "mobile-bottom-cart": "العربة",
    "mobile-bottom-search": "بحث",
    "explore-depts-subtitle": "أكثر من 3000 منتج مصنف",
    "toast-added": "تمت إضافته إلى السلة!",
    "toast-removed": "تمت إزالته من السلة.",
    "toast-empty": "سلة التسوق فارغة!",
    "modal-invoice-title": "تفاصيل الفاتورة",
    "modal-fullname": "الاسم الكامل",
    "modal-whatsapp": "رقم الواتساب",
    "modal-fulfillment": "طريقة الاستلام",
    "modal-pickup": "الاستلام من المتجر",
    "modal-delivery": " توصيل سريع للمنزل (10.00 درهم)",
    "modal-submit": "إنشاء فاتورة PDF وإتمام الطلب عبر واتساب",
    "shop-now": "تسوق الآن",
    "al-nuaimiya": "النعيمية",
    "add-address-title": "إضافة عنوان التوصيل",
    "enter-fullname": "مثال: جون دو",
    "enter-phone": "مثال: 0526278571",
    "enter-address": "مثال: شقة 402، بناية أ، النعيمية، عجمان",
    "address-details-lbl": "تفاصيل العنوان بالكامل",
    "cancel-btn": "إلغاء",
    "save-address-btn": "حفظ العنوان",
    "apply-btn": "تطبيق",
    "enter-coupon-ph": "أدخل رمز الكوبون (مثال SAVE10)",
    "coupon-modal-title": "تطبيق رمز ترويجي",
    "coupon-applied-msg": "تم تطبيق الرمز الترويجي بنجاح!"
  },
  hi: {
    "scheduled": "अनुसूचित",
    "get-tomorrow": "कल तक प्राप्त करें",
    "quick": "त्वरित",
    "categories-btn": "श्रेणियाँ",
    "nav-grocery": "किराना",
    "nav-fresh": "ताज़ा भोजन",
    "nav-electronics": "इलेक्ट्रॉनिक्स",
    "nav-home": "होम एंड लिविंग",
    "nav-festive": "उत्सव संग्रह",
    "nav-deals": "सौदे",
    "search-placeholder": "कुछ भी खोजें...",
    "explore-depts": "विभागों का अन्वेषण करें",
    "sorted-count": "3,000+ उत्पाद क्रमबद्ध",
    "shop-by-cat": "श्रेणी के अनुसार खरीदारी करें",
    "popular-prods": "लोकप्रिय उत्पाद",
    "live-flash-deals": "लाइव फ्लैश डील",
    "hotline-order": "हॉटलाइन ऑर्डर",
    "all-categories": "सभी श्रेणियां",
    "my-cart": "मेरी कार्ट",
    "cart-title": "कार्ट",
    "empty-cart-p": "आपकी कार्ट खाली है।",
    "empty-cart-sub": "स्वादिष्ट उत्पादों को जोड़ने के लिए श्रेणियों को ब्राउज़ करें!",
    "address-label": "वितरण पता:",
    "no-address": "अभी तक कोई पता नहीं जोड़ा गया है।",
    "add-new-address": "नया पता जोड़ें",
    "address-tooltip": "जारी रखने के लिए अपना पता पूरा करें।",
    "savings-corner": "बचत कोना",
    "apply-coupons": "कूपन लागू करें",
    "order-summary": "आदेश सारांश",
    "summary-subtotal": "उपयोगिता योग",
    "summary-vat": "वैट (5%)",
    "summary-total": "कुल (वैट सहित)",
    "summary-grand-total": "कुल योग",
    "btn-checkout": "चेकआउट के लिए आगे बढ़ें",
    "min-cart-warning": "वितरण के लिए न्यूनतम कार्ट मूल्य 30.00 AED होना चाहिए",
    "footer-about-h3": "बलदी हाइपरमार्केट",
    "footer-about-p": "हम आपके लिए बेहतरीन ताज़ा भोजन, जैविक उत्पाद, स्नैक्स और ठंडे पेय पदार्थों का सबसे अच्छा चयन लाते हैं। हमारे सहज व्हाट्सएप ऑर्डर सिस्टम के साथ समय बचाएं।",
    "footer-visit": "हमारे यहां आएं: अल नुइमिया, अजमान, यूएई",
    "footer-depts": "विभाग",
    "footer-care": "ग्राहक सेवा",
    "footer-contact": "संपर्क हॉटलाइन",
    "footer-faq": "अक्सर पूछे जाने वाले प्रश्न",
    "footer-fulfillment": "पूर्ति विवरण",
    "footer-privacy": "गोपनीयता नीति",
    "footer-terms": "नियम एवं शर्तें",
    "footer-about-policies": "हमारे बारे में और नीतियां",
    "footer-return": "लौटाने की नीति",
    "footer-warranty": "सेवा और वारंटी",
    "footer-tech-shield": "टेक शील्ड",
    "footer-accessibility": "वेबसाइट पहुंच योग्यता",
    "footer-visit-heading": "हमारे यहाँ आएं:",
    "footer-visit-value": "अल नसीम स्ट्रीट - अल राशिय्या 1 - अजमान",
    "footer-timings": "समय: बंद होने का समय 2 बजे सुबह - खुलने का समय 8 बजे सुबह",
    "footer-review": "समीक्षा लिखें ★★★★★",
    "footer-247": "24/7 सेवा",
    "footer-rights": "© 2026 बलदी हाइपरमार्केट। सभी अधिकार सुरक्षित। skids द्वारा डिज़ाइन किया गया।",
    "mobile-home": "मुख्य",
    "mobile-fresh": "ताज़ा भोजन",
    "mobile-fruits": "फल और सब्जियां",
    "mobile-cupboard": "खाद्य अलमारी",
    "mobile-beverages": "पेय पदार्थ",
    "mobile-bottom-home": "मुख्य",
    "mobile-bottom-menu": "मेनू",
    "mobile-bottom-cart": "कार्ट",
    "mobile-bottom-search": "खोजें",
    "explore-depts-subtitle": "3,000+ उत्पाद क्रमबद्ध",
    "toast-added": "कार्ट में जोड़ा गया!",
    "toast-removed": "कार्ट से हटाया गया।",
    "toast-empty": "आपकी कार्ट खाली है!",
    "modal-invoice-title": "चालान विवरण",
    "modal-fullname": "पूरा नाम",
    "modal-whatsapp": "व्हाट्सएप नंबर",
    "modal-fulfillment": "पूर्ति विधि",
    "modal-pickup": "स्टोर स्व-पिकअप",
    "modal-delivery": " तेज़ होम डिलीवरी (AED 10.00)",
    "modal-submit": "पीडीएफ बनाएं और व्हाट्सएप चेकआउट करें",
    "shop-now": "अभी खरीदें",
    "al-nuaimiya": "अल नुइमिया",
    "add-address-title": "वितरण पता जोड़ें",
    "enter-fullname": "जैसे: जॉन डो",
    "enter-phone": "जैसे: 0526278571",
    "enter-address": "जैसे: फ्लैट 402, बिल्डिंग ए, अल नुइमिया, अजमान",
    "address-details-lbl": "पूरा पता विवरण",
    "cancel-btn": "रद्द करें",
    "save-address-btn": "पता सुरक्षित करें",
    "apply-btn": "लागू करें",
    "enter-coupon-ph": "कूपन कोड दर्ज करें (जैसे SAVE10)",
    "coupon-modal-title": "प्रोमो कोड लागू करें",
    "coupon-applied-msg": "प्रोमो कोड सफलतापूर्वक लागू किया गया!"
  },
  ur: {
    "scheduled": "شیڈول",
    "get-tomorrow": "کل تک حاصل کریں",
    "quick": "فوری",
    "categories-btn": "زمرہ جات",
    "nav-grocery": "گروسری",
    "nav-fresh": "تازہ کھانا",
    "nav-electronics": "الیکٹرانکس",
    "nav-home": "ہوم اینڈ لیونگ",
    "nav-festive": "فیسٹیو کلیکشن",
    "nav-deals": "ڈیلز",
    "search-placeholder": "کسی بھی چیز کے لیے تلاش کریں...",
    "explore-depts": "شعبہ جات دریافت کریں",
    "sorted-count": "3,000+ مصنوعات ترتیب دی گئی ہیں",
    "shop-by-cat": "زمرے کے لحاظ سے خریداری کریں",
    "popular-prods": "مقبول مصنوعات",
    "live-flash-deals": "لائیو فلیش ڈیلز",
    "hotline-order": "ہاٹ لائن آرڈر",
    "all-categories": "تمام زمرہ جات",
    "my-cart": "میری کارٹ",
    "cart-title": "ٹوکری",
    "empty-cart-p": "آپ کی ٹوکری خالی ہے۔",
    "empty-cart-sub": "مزیدار مصنوعات شامل کرنے کے لیے زمرہ جات کو براؤز کریں!",
    "address-label": "ترسیل کا پتہ:",
    "no-address": "ابھی تک کوئی پتہ شامل نہیں کیا گیا ہے۔",
    "add-new-address": "نیا پتہ شامل کریں",
    "address-tooltip": "جاری رکھنے کے لیے اپنا پتہ مکمل کریں۔",
    "savings-corner": "بچت کارنر",
    "apply-coupons": "کوپن لاگو کریں",
    "order-summary": "آرڈر کا خلاصہ",
    "summary-subtotal": "ذیلی کل",
    "summary-vat": "ویٹ (5%)",
    "summary-total": "کل رقم (بشمول ویٹ)",
    "summary-grand-total": "مجموعی رقم",
    "btn-checkout": "چیک آؤٹ کے لیے آگے بڑھیں",
    "min-cart-warning": "ڈیلیوری کے لیے کارٹ کی کم از کم قیمت 30.00 AED ہونی چاہیے",
    "footer-about-h3": "بلدی ہائپر مارکیٹ",
    "footer-about-p": "ہم آپ کے لیے بہترین قسم کے تازہ کھانے، نامیاتی مصنوعات، اسنیکس اور ٹھنڈے مشروبات فراہم کرتے ہیں۔ ہمارے آسان واٹس ایپ آرڈر سسٹم کے ساتھ اپنا وقت بچائیں۔",
    "footer-visit": "تشریف لائیں: النعیمیہ، عجمان، متحدہ عرب امارات",
    "footer-depts": "شعبہ جات",
    "footer-care": "کسٹمر کیئر",
    "footer-contact": "رابطہ ہاٹ لائن",
    "footer-faq": "اکثر پوچھے گئے سوالات",
    "footer-fulfillment": "تفصیلات وصولی",
    "footer-privacy": "رازداری کی پالیسی",
    "footer-terms": "شرائل و ضوابط",
    "footer-about-policies": "ہمارے بارے میں اور پالیسیاں",
    "footer-return": "واپسی کی پالیسی",
    "footer-warranty": "سروس اور وارنٹی",
    "footer-tech-shield": "ٹیک شیلڈ",
    "footer-accessibility": "ویب سائٹ تک رسائی",
    "footer-visit-heading": "تشریف لائیں:",
    "footer-visit-value": "النسیم اسٹریٹ - الراشدیہ 1 - عجمان",
    "footer-timings": "اوقات: بند 2 بجے صبح - کھلنے 8 بجے صبح",
    "footer-review": "ایک جائزہ لکھیں ★★★★★",
    "footer-247": "سروس 24/7",
    "footer-rights": "کاپی رائٹ © 2026 بلدی ہائپر مارکیٹ۔ جملہ حقوق محفوظ ہیں۔ skids کے ذریعہ ڈیزائن کیا گیا ہے۔",
    "mobile-home": "ہوم",
    "mobile-fresh": "تازہ کھانا",
    "mobile-fruits": "پھل اور سبزیاں",
    "mobile-cupboard": "فوڈ کیبنٹ",
    "mobile-beverages": "مشروبات",
    "mobile-bottom-home": "ہوم",
    "mobile-bottom-menu": "مینیو",
    "mobile-bottom-cart": "کارٹ",
    "mobile-bottom-search": "تلاش",
    "explore-depts-subtitle": "3,000+ مصنوعات ترتیب دی گئی ہیں",
    "toast-added": "ٹوکری میں شامل کر دیا گیا!",
    "toast-removed": "ٹوکری سے ہٹا دیا گیا۔",
    "toast-empty": "آپ کی ٹوکری خالی ہے!",
    "modal-invoice-title": "انعام نامہ کی تفصیلات",
    "modal-fullname": "مکمل نام",
    "modal-whatsapp": "واٹس ایپ نمبر",
    "modal-fulfillment": "وصولی کا طریقہ",
    "modal-pickup": "اسٹور خود پک اپ",
    "modal-delivery": " تیز رفتار ہوم ڈیلیوری (AED 10.00)",
    "modal-submit": "پی ڈی ایف بنائیں اور واٹس ایپ پر چیک آؤٹ کریں",
    "shop-now": "ابھی خریدیں",
    "al-nuaimiya": "النعیمیہ",
    "add-address-title": "ترسیل کا پتہ شامل کریں",
    "enter-fullname": "جیسے: جون دو",
    "enter-phone": "جیسے: 0526278571",
    "enter-address": "جیسے: فلیٹ 402، بلڈنگ اے، النعیمیہ، عجمان",
    "address-details-lbl": "پتے کی مکمل تفصیلات",
    "cancel-btn": "منسوخ کریں",
    "save-address-btn": "پتہ محفوظ کریں",
    "apply-btn": "لاگو کریں",
    "enter-coupon-ph": "کوپن کوڈ درج کریں (جیسے SAVE10)",
    "coupon-modal-title": "پرومو کوڈ لاگو کریں",
    "coupon-applied-msg": "پرومو کوڈ کامیابی سے لاگو ہو گیا!"
  }
};

// Get active language or default to 'en'
function getActiveLanguage() {
  return localStorage.getItem('baladi_lang') || 'en';
}

// Function to translate the webpage elements
function translatePage(lang = null) {
  if (!lang) lang = getActiveLanguage();
  
  // Set html direction and lang attributes
  const isRTL = (lang === 'ar' || lang === 'ur');
  document.documentElement.lang = lang;
  document.documentElement.dir = isRTL ? 'rtl' : 'ltr';
  
  // Apply translation class to body for custom layout shifts in CSS
  document.body.classList.remove('lang-en', 'lang-ar', 'lang-hi', 'lang-ur', 'rtl-layout');
  document.body.classList.add(`lang-${lang}`);
  if (isRTL) document.body.classList.add('rtl-layout');

  // Translate all elements with data-i18n attribute
  document.querySelectorAll('[data-i18n]').forEach(el => {
    const key = el.getAttribute('data-i18n');
    if (TRANSLATIONS[lang] && TRANSLATIONS[lang][key]) {
      // Check if it has child elements that need preservation (e.g. svg icons)
      const svg = el.querySelector('svg');
      if (svg) {
        // Keep the svg and replace the text next to it
        const tempSpan = document.createElement('span');
        tempSpan.textContent = TRANSLATIONS[lang][key];
        // Clean out text nodes while retaining the SVG
        Array.from(el.childNodes).forEach(node => {
          if (node.nodeType === Node.TEXT_NODE) {
            el.removeChild(node);
          }
        });
        el.appendChild(document.createTextNode(' ' + TRANSLATIONS[lang][key]));
      } else {
        el.textContent = TRANSLATIONS[lang][key];
      }
    }
  });

  // Handle placeholders
  document.querySelectorAll('[data-i18n-placeholder]').forEach(el => {
    const key = el.getAttribute('data-i18n-placeholder');
    if (TRANSLATIONS[lang] && TRANSLATIONS[lang][key]) {
      el.setAttribute('placeholder', TRANSLATIONS[lang][key]);
    }
  });

  // Specifically translate the search input on the page if it's dynamic
  const mainSearchInput = document.getElementById('search-input');
  if (mainSearchInput) {
    mainSearchInput.setAttribute('placeholder', TRANSLATIONS[lang]['search-placeholder'] || 'Search for "Anything"');
  }

  // Update language selector UI to match the current selection
  updateLanguageDropdownUI(lang);
  
  // Dispatch custom event for dynamic components (like cart.js) to re-render
  const event = new CustomEvent('languageChanged', { detail: { lang, isRTL } });
  document.dispatchEvent(event);
}

// Change page language
function changeLanguage(lang) {
  localStorage.setItem('baladi_lang', lang);
  translatePage(lang);
}

// Synchronize all language dropdowns on the page
function updateLanguageDropdownUI(lang) {
  const selectors = document.querySelectorAll('.language-select-dropdown');
  selectors.forEach(select => {
    if (select.value !== lang) {
      select.value = lang;
    }
  });
}

// Initialize translations
document.addEventListener('DOMContentLoaded', () => {
  // Wrap active language selector in select element
  const langTrigger = document.querySelector('.language-selector');
  if (langTrigger) {
    const isRTL = (getActiveLanguage() === 'ar' || getActiveLanguage() === 'ur');
    langTrigger.outerHTML = `
      <div class="lang-select-container">
        <svg stroke="currentColor" fill="none" stroke-width="2" viewBox="0 0 24 24" height="1em" width="1em" xmlns="http://www.w3.org/2000/svg" class="globe-icon">
          <circle cx="12" cy="12" r="10"></circle>
          <line x1="2" y1="12" x2="22" y2="12"></line>
          <path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"></path>
        </svg>
        <select class="language-select-dropdown" onchange="changeLanguage(this.value)" aria-label="Change Language">
          <option value="en">English</option>
          <option value="ar">عربي</option>
          <option value="hi">हिन्दी</option>
          <option value="ur">اردو</option>
        </select>
      </div>
    `;
  }
  
  // Call translation
  translatePage();
});
